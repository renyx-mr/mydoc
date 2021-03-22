Class DHCDoc.Renyx.Test Extends %RegisteredObject
{

ClassMethod UpdateCanCrossDayFlag()
{
	s DHCARCIMRowid=0
	Set DHCARCIMRowid = ""
	For {
		Set DHCARCIMRowid = $ORDER(^DHCItmMast(DHCARCIMRowid))
		Quit:DHCARCIMRowid=""
		s $p(^DHCItmMast(DHCARCIMRowid),"^",11)="Y"
	}
	q "0"
}

/// Renyx 2020.10.27
/// input PatDr:患者id
/// output 工作单位^单位电话^单位邮编
/// debug w ##Calss(DHCDoc.Renyx.Test).GetPatMasInfo(12)
ClassMethod GetPatMasInfo(PatDr As %String) As %String
{
	b ;;;1
	s PresonObj=##class(User.PAPerson).%OpenId(PatDr)
	s PAPERSecondPhone="" ;工作单位
	s PAPERTelO="" ;单位电话
	s PAPERName6="" ;单位邮编
	if IsObject(PresonObj){
		s PAPERSecondPhone=PresonObj.PAPERSecondPhone
		s PAPERTelO=PresonObj.PAPERTelO
		s PAPERName6=PresonObj.PAPERName6
	}
	q PAPERSecondPhone_"^"_PAPERTelO_"^"_PAPERName6
}

ClassMethod GetUserStr(AdmDr As %String)
{
	;n (AdmDr)
}

/// w ##class(DHCDoc.Renyx.Test).ExportAdmInfoToExecl("2019-2-12","2019-2-14")
ClassMethod ExportAdmInfoToExecl(StartDate As %String, EndDate As %String)
{
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if (StartDate="") s StartDate=+$h
	if (EndDate="") s EndDate=+$h
	s FileName="D:\AdmInfo"_$tr($zd(+$h,3),"-","")_$tr($zt($p($h,",",2),1),":","")_".xls"
	s AdmFile=##class(%File).%New(FileName)
	d AdmFile.Open("WSN")
	/*
	s ss="身份证号"_$c(9)_"门诊病历号"_$c(9)_"联系电话"_$c(9)_"联系人"_$c(9)_"住址"_$c(9)_"病人类型"
		_$c(9)_"科别名称"_$c(9)_"医师姓名"_$c(9)_"挂号费"_$c(9)_"基金金额支付"_$c(9)_"挂号时间"_$c(9)_"挂号/退号"
	*/
	d AdmFile.WriteLine("身份证号"_$c(9)_"门诊病历号"_$c(9)_"联系电话"_$c(9)_"联系人"_$c(9)_"住址"_$c(9)_"病人类型"
		_$c(9)_"科别名称"_$c(9)_"医师姓名"_$c(9)_"挂号费"_$c(9)_"基金金额支付"_$c(9)_"挂号时间"_$c(9)_"挂号/退号")
	s SizeCount=0
	for AdmDate=StartDate:1:EndDate{
		s AdmDr=""
		for {
			s AdmDr=$o(^PAADMi("PAADM_AdmDate",AdmDate,AdmDr))
			q:AdmDr=""
			s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmDr,0))
			continue:RegfeeRowId=""
			s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
			continue:(AdmType'="O")&&(AdmType'="E")
			s PatDr=$P(^PAADM(AdmDr),"^")
			;s InMedical=$p($g(^PAPER(PatDr,"PAT",1)),"^",22)
			//s InMedical=##Class(web.DHCWMRService).IGetMrNoByPatientID(PatDr) 
			S PatIdNo=$p($g(^PAPER(PatDr,"PAT",3)),"^",6)
			s MedicalNo=##Class(web.DHCWMRService).IGetMrNoByPatientID(PatDr)  //##class(web.DHCDocOrderCommon).GetMrNo("",PatDr,"O")
			s PatPhone=$p($g(^PAPER(PatDr,"PER",1)),"^",11)
			s Contact=$p($g(^PAPER(PatDr,"PER",2)),"^",13)
			s Address=$g(^PAPER(PatDr,"PER","ADD"))
			s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
			s AdmType=$case(AdmType,"O":"门诊","E":"急诊")
			s DepCodeDR=$p($g(^PAADM(AdmDr)),"^",4)
			s LocDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
			if LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
			s AdmDocCodeDR=$p($g(^PAADM(AdmDr)),"^",9)
			s DocDesc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
			s InvoiceId=$List(^User.DHCRegistrationFeeD(RegfeeRowId),11)
			s RegFee="",ConRowId=""
			if (InvoiceId'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceId,0))
			;打印挂号费和诊疗费(包括附属的其他费用)
			s TotalRMBDX="",PBRowId=""
			i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
			s AppFee=0,OtherFee=0,Total=""
			if PBRowId'="" {
				s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
				.s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
				.Q:ArcimId=""
				.s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
				.s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
				.i type="App" s AppFee=AppFee+BillSum
				.e  d
				..;i (type="Reg")!(type="Check") s RegFee=RegFee+BillSum
				..;i (type="Check") s CheckFee=CheckFee+BillSum
				..i (type="Reg") s RegFee=RegFee+BillSum
				..e  s OtherFee=OtherFee+BillSum
				s Total=AppFee+RegFee+OtherFee
				s TotalRMBDX=##class(web.DHCOPAdmReg).RMBDXXZH("","",Total)
			}
			/*s RegFee=""
			s VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
			if (VisitStatus="C") {
   				s GetStr=##class(web.DHCOPRegReports).GetAdmRegSum(AdmDr)
   				//s TAppFee=$P(GetStr,"^",7) s TRegFee=$P(GetStr,"^",2) s TCheckFee=$P(GetStr,"^",3)
   				s RegFee=$P(GetStr,"^",2)
			}
   			if (InvoiceId="") {
   				s GetStr=##class(web.DHCOPRegReports).GetBMAdmRegSum(AdmDr)
				//s ##class(web.DHCOPRegReports).GetBMAdmRegSum(118)
				s RegFee=$P(GetStr,"^",2)
   			}*/
			s InsuFund=$List(^User.DHCRegistrationFeeD(RegfeeRowId),27)
			s Insu=$P($g(InsuFund),"!",2)
			s CreateDate=$p($g(^PAADM(AdmDr)),"^",41)
			s CreateTime=$p($g(^PAADM(AdmDr)),"^",42)
			s RegDateTime=$zd(CreateDate,3)_" "_$zt(CreateTime,1)
			s VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
			s RegType=""
			s:VisitStatus="C" RegType="退号"
			s:VisitStatus="A" RegType="挂号"
			//s RegType=$select(VisitStatus="C":"退号",VisitStatus="A":"挂号")
			d AdmFile.WriteLine(PatIdNo_$c(9)_MedicalNo_$c(9)_PatPhone_$c(9)_Contact_$c(9)_Address
				_$c(9)_AdmType_$c(9)_LocDesc_$c(9)_DocDesc_$c(9)_Total_$c(9)_Insu
				_$c(9)_RegDateTime_$c(9)_RegType)
			s SizeCount=+SizeCount+1
		}
	}
	//AdmFile.Size
	d AdmFile.Close()
	q "导出成功: 共导出"_SizeCount_"条数据。"
}

}
