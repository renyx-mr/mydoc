Class web.DHCOPAdmRegLocal Extends %RegisteredObject
{

ClassMethod CheckInsuNoByInsuInfo(PatientID As %String, InsuCardNo As %String)
{
	s RetFlag=0
	q:InsuCardNo="" RetFlag
	q:'$d(^PAPER(PatientID,"PAT",3)) RetFlag
	;医保号 PA_PatMas.PAPMI_HealthFundNo
	s PatientInsuCardNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	if (PatientInsuCardNo'=InsuCardNo){
		s $p(^PAPER(PatientID,"PAT",3),"^",12)=InsuCardNo
	}
	s RetFlag=1
	q RetFlag
}

/// 获取号源价格
ClassMethod GetRBASFeeByASRowId(ASRowId As %String, PatientId As %String, FeeStr As %String)
{
	s PatCatDr=$p($g(^PAPER(PatientId,"PER",1)),"^",10)
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s Re=AdmRowId
	s ResRowId=$P(ASRowId,"||",1)
	s ASChild=$P(ASRowId,"||",2)
	s AdmReason=$P(^PAADM(AdmRowId,1),"^",7)
	s AdmDep=$P(^PAADM(AdmRowId),"^",4)
	s AdmDate=$P(^PAADM(AdmRowId),"^",6)
	s AdmTime=$P(^PAADM(AdmRowId),"^",7)

	s Fee=$P(FeeStr,"||",1)
	s checkfee=$P(FeeStr,"||",2)
	s holi=$P(FeeStr,"||",3)
	s appfee=$P(FeeStr,"||",4)
	s mrfee=$P(FeeStr,"||",5)
	s recheckfee=$P(FeeStr,"||",6)
	s cardfee=$P(FeeStr,"||",7)
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmRowId,"","",""),"^",1)
    if (RegConDisId=""){
		s RegConDisIdPara=PatientID_"^"_ASRowId_"^"_AdmReason_"^"_""
		s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	}
	set err=0
	set Price=0
	;取挂号费和诊查费和节假日挂号费信息
	s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ASRowId,AdmReason)
	s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService(PatientId,ASRowId,SerIdStr)
	i cardfee=1  {
	 	s CardFeeArcimId=##class(web.DHCOPAdmReg).GetCardFeeArcimId()
	 	if CardFeeArcimId'="" {
		 	if SerIdStr="" s SerIdStr=CardFeeArcimId
		 	else  s SerIdStr=SerIdStr_"^"_CardFeeArcimId
	 	}
	}
	i mrfee=1  {
	 	s MRFeeArcimId=##class(web.DHCOPAdmReg).GetMRFeeArcimId(HospId)
	 	if MRFeeArcimId'="" {
		 	if SerIdStr="" s SerIdStr=MRFeeArcimId
		 	else  s SerIdStr=SerIdStr_"^"_MRFeeArcimId
	 	}
	}
	s InsertOrdFlag=0
	;如果没有医嘱，则取挂号设置的免费医嘱
	Set FreeOrder=$p(##class(web.DHCOPRegConfig).GetSpecConfigNode("FreeOrder",HospId),"@",1)
	if SerIdStr="" s SerIdStr=FreeOrder
	s Price=0
	i SerIdStr'="" {
	 	f i=1:1:$l(SerIdStr,"^") {
			 ;s SerId=$P(SerIdStr,"^",i)
			 ;s ArcimId=$p(^RBC("SER",SerId),"^",1)
			 s ArcimId=$P(SerIdStr,"^",i)
			 i (ArcimId="") {continue}
			 ;判断挂号所涉及的费用分类性质并插入医嘱表
			 ;s RegSerBillSubType=..GeRegSerBillSubType(SerId)
			 s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
			 i (RegSerBillSubType="Check")&&((checkfee=0)!(checkfee="")) {continue}
			 i (RegSerBillSubType="ReCheck")&&((recheckfee=0)!(recheckfee="")) {continue}
			 i (RegSerBillSubType="Check")&&((recheckfee'=0)&&(recheckfee'="")) {continue}
			 i (RegSerBillSubType="App")&&((appfee=0)!(appfee="")) {continue}
			 i (RegSerBillSubType="Holi")&&((holi=0)!(appfee="")) {continue}
			 i ((RegSerBillSubType="Reg")&&(FreeRegFlag="Y"))  {continue}
			 i ((RegSerBillSubType="Check")&&(FreeCheckFlag="Y"))  {continue}
			 ;w ##Class(web.UDHCJFPRICE).GetOrderPrice("","","1||1",60971,"","","","")
			 s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,+$H,"","","","",HospId,RegConDisId),"^",4)
			 s Price=Price+BillPrice
	 	}
	}
	q Price
}

/// w ##class(web.DHCOPAdmRegLocal).GetAdmReasonJson(32)
ClassMethod GetAdmReasonJson(AdmReasonDr As %String)
{
	s RetStr=""
	q:'$d(^PAC("ADMREA",AdmReasonDr)) RetStr
	s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	s RetStr="["_"{""text"":"""_$g(AdmReasonDesc)_""",""id"":"""_$g(AdmReasonDr)_""""_",""selected"":true"_"}"_"]"
	q RetStr
}

ClassMethod UpdatePatAdmReason(PatDr As %String, AdmReason As %String)
{
	q:'$d(^PAC("ADMREA",AdmReason))!'$d(^PAPER(PatDr)) ""
	s $P(^PAPER(PatDr,"DHCINS"),"^",3)=AdmReason
	q "0"
}

/// =======================================插入核酸医嘱及核酸诊断==============================
/// w ##class(web.DHCOPAdmRegLocal).InsertCovi19Public()
ClassMethod InsertCovi19Public(EpisodeID As %String, ASRowId As %String, UserId As %String, HospitalID As %String = "")
{
	s ^TempRen("InsertCovi19Public")=$lb(EpisodeID,ASRowId,UserId,HospitalID)
	s AdmDep=$P($G(^RB("RES",+ASRowId)),"^",1)
	s AdmDoc=$P($G(^RB("RES",+ASRowId)),"^",2)
	if HospitalID=""{
		s HospitalID=$p(^CTLOC(AdmDep),"^",22)
	}
	s InsertCovi19OInfo=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","InsertCovi19OInfo",HospitalID)
	for i=1:1:$l(InsertCovi19OInfo,","){
		s OneInsertCovi19OInfo=$p(InsertCovi19OInfo,",",i)
		continue:OneInsertCovi19OInfo=""
		s CheckDocDr=$p(OneInsertCovi19OInfo,"!",1)
		continue:CheckDocDr'=AdmDoc
		s InsertIcddxStr=$p(OneInsertCovi19OInfo,"!",2)
		s InsertUserId=$p(OneInsertCovi19OInfo,"!",4)
		if (InsertUserId="") s InsertUserId=UserId
		if (InsertIcddxStr'=""){
			for j=1:1:$l(InsertIcddxStr,"-"){
				s OneInsertIcddx=$p(InsertIcddxStr,"-",j)
				continue:OneInsertIcddx=""
				b ;;;
				d ..InsertCovi19MRDiagnos(EpisodeID,InsertUserId,OneInsertIcddx)
			}
		}
		s InsertArcItemStr=$p(OneInsertCovi19OInfo,"!",3)
		b ;;
		if (InsertArcItemStr'=""){
			for j=1:1:$l(InsertArcItemStr,"-"){
				s OneInsertArcItem=$p(InsertArcItemStr,"-",j)
				continue:OneInsertArcItem=""
				d ..InsertCovi19Order(EpisodeID,InsertUserId,OneInsertArcItem)
			}
		}
	}
	q ""
}

/// 核酸诊断
ClassMethod InsertCovi19MRDiagnos(EpisodeID, UserID, ICDRowID)
{
		s AdmDep=$P(^PAADM(EpisodeID),"^",4)
		s mrrowid=$p($G(^PAADM(EpisodeID)),"^",61)
		s MRDIAID=##class(web.DHCMRDiagnos).InsertMRDiagnos(AdmDep,mrrowid,ICDRowID,UserID,"","门诊诊断","","","","","","","","")
		if (+MRDIAID'=0){
			s Rtn=##class(web.DHCMRDiagnos).UpdateOnsetDate(MRDIAID,$ZD(+$H,3))
		}
}

/// 插入核酸医嘱
ClassMethod InsertCovi19Order(EpisodeID As %String, UserID As %String, ARCIMRowID As %String, OrderLabSpecRowid As %String = "", OrderPackQty As %String = "")
{
	q:EpisodeID="" ""
	s i=1
	s Number=1
	Set OrderItemStr=""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	s LocID=$P(^PAADM(EpisodeID),"^",4)
	s OrderARCIMRowid=ARCIMRowID
	s OrderPackQty=OrderPackQty
	if (OrderPackQty="")  s OrderPackQty=1
	s ItemCatDr=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",10) 
	s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	s OrderPriorRowid=3
	s OrderStartDate=$zd($h,3)
	s OrderStartTime=$zt($P($h,",",2))
	s OrderPrice=""
	s GetLocRecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocID,OrderARCIMRowid)
	if (GetLocRecLocStr'=""){
		s OrderRecDepRowid=$P(GetLocRecLocStr,$c(1),1)
		s Len1=$l(GetLocRecLocStr,$c(2))
		for j=1:1:Len1{
			s OneLocRecStr=$P(GetLocRecLocStr,$C(2),j)
			s Defultflag=$p(OneLocRecStr,$C(1),3)
			if (Defultflag="Y"){
				s OrderRecDepRowid=$P(OneLocRecStr,$c(1),1)
				}
		}
	}
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s AdmReason=$P(^PAADM(EpisodeID,1),"^",7)
	s BillTypeRowid=AdmReason
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
	s OrderDrugFormRowid="",OrderDoseQty="",OrderDoseUOMRowid="",OrderFreqRowid="",OrderDurRowid=""
	s PHPrescType=""
	s OrderQtySum=OrderPackQty
	s OrderInstrRowid=""
	s OrderDepProcNotes=""
	s OrderMasterSeqNo=""
	Set ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	s OrderSeqNo=$$GetSeqNo^DHCDocOrderCommonNew(ord,+$h)+Number
	s OrderSkinTest="N"
	s OrderPhSpecInstr=""
	s OrderCoverMainIns=""
	s OrderActionRowid=""
	s OrderARCOSRowid=""
	s OrderEndDate=""
	s OrderEndTime=""
	s OrderLabSpecRowid=OrderLabSpecRowid
	if (OrderLabSpecRowid=""){
		s OrderLabSpecRowid=##class(web.DHCDocOrderCommon).GetLabSpec(OrderARCIMRowid)
	}
	s OrderDurRowid=""
	s OrderItem=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate_"^"_OrderStartTime_"^"_OrderPackQty_"^"_OrderPrice
	s OrderItem=OrderItem_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
	s OrderItem=OrderItem_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
	s OrderItem=OrderItem_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
	s OrderItem=OrderItem_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid
	s OrderItemStr=OrderItem
	if (OrderItemStr'=""){
		s rtn=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,OrderItemStr,UserID,LocID,DocID)
		b ;;;12
		f i=1:1:$L(rtn,"^") 
		{
			S OneOrderStr=$P(rtn,"^",i)
			s oeitm=$P(OneOrderStr,"*",2)
			Continue:oeitm=""
			&SQL(Update SQLUser.OE_OrdItemExt set OEORI_OtherFlags="Reg" where OEORI_rowid=:oeitm)

			}
		}
	q 0
}

ClassMethod GetRetPrintInfo(RegRowId)
{
	//s InvoiceId=$List(^User.DHCRegistrationFeeD(RegRowId),11)
	s PatName="",PatNo="",DepDesc="",DateStr=""
	s obj=##class(User.DHCRegistrationFee).%OpenId(RegRowId)
	if $IsObject(obj){
		s AdmDr=obj.RegfeeAdmDr
		s DepDr=obj.RegfeeDepDr
		s InvoiceId=obj.Regfeetemp1
		s DocDr=obj.RegfeeDocDr
		i AdmDr'="" {
			s PatDr=$P($g(^PAADM(AdmDr)),"^")
			s UpdateDate=$p($g(^PAADM(AdmDr,1)),"^",42)
			s:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
			s UpdateTime=$p($g(^PAADM(AdmDr,1)),"^",43)
			s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
			s DateStr=UpdateDate_" "_UpdateTime
			s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
			;取登记号
			s PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
		}
		i DepDr'=""{
			s HospitalDesc=$p($g(^CTLOC(DepDr)),"^",22)
			s:HospitalDesc'="" HospitalDesc=$P(^CT("HOSP",HospitalDesc),"^",2)
			s HospitalDesc=HospitalDesc //_"门诊挂号凭证"
			s DepDesc=$p($g(^CTLOC(DepDr)),"^",2)
			//s Room=$g(^CTLOC(DepDr,"ADDR",1)) ;="四层"="12"
		}
	}
	
	d obj.%Close()
	q PatName_"^"_PatNo_"^"_DepDesc_"^"_DateStr
}

/// 根据账单获取支付信息  
/// input 账单id
/// output 现金^银行卡^挂号优惠^记账
/// w ##class(web.DHCOPAdmRegLocal).GetINVPayMode(6891)
ClassMethod GetINVPayMode(InvoiceId As %String) As %String
{
	;n (InvoiceId)
	s ^ren("InvoiceId")=InvoiceId
	s Num=0
	s PayMode="",PayModeStr="^^^^^"
	s InitInvoiceId=$o(^DHCINVPRT(0,"InitInvDR",InvoiceId,""))
	s IPMSub=0
	for {
		s IPMSub=$O(^DHCINVPRT(InvoiceId,"P",IPMSub))
		Q:IPMSub=""
		s IPMPayModeDR=$p($g(^DHCINVPRT(InvoiceId,"P",IPMSub)),"^",1)
		
		s IPMAmt=$p($g(^DHCINVPRT(InvoiceId,"P",IPMSub)),"^",3)
		//b ;;123
		continue:+IPMAmt=0
		if (InitInvoiceId'=""){
			if ($d(^DHCINVPRT(InitInvoiceId,"P",IPMSub))) {
				s refIPMAmt=$p($g(^DHCINVPRT(InitInvoiceId,"P",IPMSub)),"^",3)
				s IPMAmt=IPMAmt+refIPMAmt
			}
		}
		if IPMPayModeDR'="" {
			/*s PayMode=$P($g(^CT("CTPM",IPMPayModeDR)),"^",2)
			if PayModeStr="" s PayModeStr=PayMode_":"_$j(IPMAmt,"",2)
			else  s PayModeStr=PayModeStr_","_PayMode_":"_$j(IPMAmt,"",2)*/
			s Num=Num+1
			s PayModeCode=$P($g(^CT("CTPM",IPMPayModeDR)),"^",1)
			s:PayModeCode="CASH" $p(PayModeStr,"^",1)=$j(IPMAmt,"",2)
			s:PayModeCode="YHK" $p(PayModeStr,"^",2)=$j(IPMAmt,"",2)
			s:PayModeCode="GHYH" $p(PayModeStr,"^",3)=$j(IPMAmt,"",2)
			s:PayModeCode="CCP" $p(PayModeStr,"^",4)=$j(IPMAmt,"",2)
			s:PayModeCode="YBINSU" $p(PayModeStr,"^",5)=$j(IPMAmt,"",2)
			s:PayModeCode="INSUZHZF" $p(PayModeStr,"^",6)=$j(IPMAmt,"",2)
		}
	}
	Q PayModeStr
}

/// w ##class(web.DHCOPAdmRegLocal).GetDelPayModeByPatId()
ClassMethod GetDelPayModeByPatId(PatientID As %String, HospId As %String = "")
{
	q:'$d(^PAPER(PatientID))||(HospId="") ""
	s RegDiscount=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","RegDiscount",HospId)
	q:((RegDiscount="")||(RegDiscount'[",")) ""
	s CheckAge=+$p(RegDiscount,",",1)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospId)
	q:((PatAge'["岁")||(+PatAge<CheckAge)) ""
	q $p(RegDiscount,",",2)
}

ClassMethod CheckPayModeByPatId(PatientID As %String, PayModeCode As %String, CheckInsuCard As %String, TabASRowId As %String, HospId As %String = "")
{
	q:'$d(^PAPER(PatientID))||(PayModeCode="")||(CheckInsuCard="")||(TabASRowId="")||(HospId="") ""
	s RegDiscount=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","RegDiscount",HospId)
	q:((RegDiscount="")||(RegDiscount'[",")) ""
	s CheckPayModeDr=$p(RegDiscount,",",2)
	q:CheckPayModeDr="" ""
	s CheckPayModeCode=$p($g(^CT("CTPM",CheckPayModeDr)),"^",1)
	q:(CheckPayModeCode'=PayModeCode) ""
	q:CheckInsuCard="0" "非实时结算，不允许使用"_$p($g(^CT("CTPM",CheckPayModeDr)),"^",2)
	s SeeTypeDr=$p($g(^RBAS(+TabASRowId,$p(TabASRowId,"||",2),"DHC")),"^",6)
	s CheckSeeTypeDr=$p(RegDiscount,",",3)
	;s SeeTypeDesc=""
	;s:SeeTypeDr'="" SeeTypeDesc=$p($g(^RBC("SESS",SeeTypeDr)),"^",2)
	q:((CheckSeeTypeDr'="")&&(CheckSeeTypeDr'=SeeTypeDr)) "非普通号，不允许使用"_$p($g(^CT("CTPM",CheckPayModeDr)),"^",2)
	s CheckAge=+$p(RegDiscount,",",1)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospId)
	q:((PatAge["岁")&&(+PatAge>=CheckAge)) ""
	q "该患者年龄小于："_CheckAge_"岁不允许使用  "_$p($g(^CT("CTPM",CheckPayModeDr)),"^",2)
}

/// w ##class(web.DHCOPAdmRegLocal).CheckPatAge(59636)
ClassMethod CheckPatAge(EpisodeID As %String)
{
	s RetFlag=0
	q:'$d(^PAADM(EpisodeID)) RetFlag
	s PatientId=$p($g(^PAADM(EpisodeID)),"^")
	q:PatientId="" RetFlag
	s PatDob=$p($g(^PAPER(PatientId,"ALL")),"^",6)
	q:PatDob="" RetFlag
	s PatDobYear=$p($zd(PatDob,3),"-")
	s HourYear=$p($zd(+$h,3),"-")
	b ;;we
	s:(HourYear-PatDobYear)<=5 RetFlag=1
	q RetFlag
}

}
