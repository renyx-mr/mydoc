Class DHCDoc.OPDoc.AjaxPatientAgentInfor Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetPatientAgentInfor")
	{
  		w ..GetPatientAgentInfor()
  		
	}
   
	Quit $$$OK
}

/// creator:潘晓凤
/// date:2016-07-14
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfig).GetPatientAgentInfor()     
ClassMethod GetPatientAgentInfor(EpisodeID As %String) As %String
{
	Set PersonID=$p($g(^PAADM(EpisodeID)),"^",1)
	Set ret=""
	Quit:PersonID="" ret
	s PAPMIDVAnumber=##class(web.DHCDocOrderEntry).FindPAPMIID(PersonID)
	Set PAPMIID=$P($G(^PAPER(PersonID,"PAT",3)),"^",6)
	Set AgencyName=$P($G(^PAPER(PersonID,"DHC")),"^",49)
	Set AgencyCredNo=$P($G(^PAPER(PersonID,"DHC")),"^",48)
	Set AgencyTel=$P($G(^PAPER(PersonID,"DHC")),"^",50)
	
    Set PatAddressDr=$O(^PAPER(PersonID,"PER","ADD",""),-1)
	Set PatAddress=""
	if (PatAddressDr'=""){
		Set PatAddress=$g(^PAPER(PersonID,"PER","ADD",PatAddressDr)) ;סַ
	}
	Set mradm=$p($g(^PAADM(EpisodeID)),"^",61)
    Set Weight=$p($g(^MR(mradm,"PRO",1)),"^",27)
	Set ret=PAPMIDVAnumber_"^"_AgencyName_"^"_AgencyCredNo_"^"_AgencyTel_"^"_PatAddress_"^"_Weight_"^"_mradm_"^"_PersonID
	Quit ret
}

/// w ##class(DHCDoc.OPDoc.AjaxPatientAgentInfor).SaveWeight("597","")
ClassMethod SaveWeight(MRAdmID As %String, Weight As %String) As %String
{
	s $p(^MR(MRAdmID,"PRO",1),"^",27)=Weight
	q 0
}

ClassMethod SavePatAddress(PatientID As %String, PatAddress As %String) As %String
{
	//s $p(^PAPER(PatientID,"PER","ADD",1),"^",1)=PatAddress
	s person=##class(User.PAPerson).%OpenId(PatientID)
	d person.PAPERStName.Insert(PatAddress)
	Set sc1=person.%Save()
	If $$$ISERR(sc1) {
 		Quit -100
 	}
	
	Q 0
}

/// Date 2015-08-13
/// Description:  PAPERName7代办人姓名  PAPERName8代办人身份证号
/// w ##class(web.UDHCPrescript).CredNoCheck("60","522426198805200874")
ClassMethod CredNoCheck(PatientID As %String, PatInfo As %String) As %String
{
	Q:PatientID="" -100
	s myIDNo=$P(PatInfo,"^",1)
	s DPatName=$P(PatInfo,"^",2)
	s DPatCredNo=$P(PatInfo,"^",3)
	s PatAddress=$P(PatInfo,"^",4)
	TSTART
	s Obj=##class(User.PAPatMas).%OpenId(PatientID)
	if (Obj.PAPMIID="") s Obj.PAPMIID=myIDNo
	s DVANumber=Obj.PAPMIDVAnumber
	s Obj.PAPMIDVAnumber=myIDNo
	s Obj.PAPMIName7=DPatName
	s Obj.PAPMIName8=DPatCredNo
	do Obj.PAPMICardTypeDRSetObjectId(1)
	Set sc=Obj.%Save()
	If $$$ISERR(sc) {
 		Trollback
 		Quit -100
 	}
 	s Object=##class(User.PAPerson).%OpenId(PatientID)
 	s Object.PAPERID=myIDNo
 	s Object.PAPERName7=DPatName
 	s Object.PAPERName8=DPatCredNo
 	Set sc1=Object.%Save()
	If $$$ISERR(sc1) {
 		Trollback
 		Quit -100
 	}
 	TCommit
	q 0
}

/// CreateDate 2016-01-28
/// Description:  医嘱录入开毒麻处方时、保存代办人信息
/// w ##class(DHCDoc.OPDoc.AjaxPatientAgentInfor).UpdateAgencyInfo("597","370285199106144416^^^")
ClassMethod UpdateAgencyInfo(PatientID As %String, PatInfo As %String) As %String
{
	Q:PatientID="" -100
	s ^tmpnk("UpdateAgencyInfo")=PatientID_"^"_PatInfo
	s myIDNo=$P(PatInfo,"^",1)
	s AgencyName=$P(PatInfo,"^",2)
	s AgencyCredNo=$P(PatInfo,"^",3)
	s AgencyTel=$P(PatInfo,"^",4)
	TSTART
	s Obj=##class(User.PAPatMas).%OpenId(PatientID)
	if $IsObject(Obj){
		s Obj.PAPMIID=myIDNo
		s Obj.PAPMIDVAnumber=myIDNo
		do Obj.PAPMICardTypeDRSetObjectId(1)
		Set sc=Obj.%Save()
		If $$$ISERR(sc) {
	 		Trollback
	 		Quit -100
	 	}
	 	d Obj.%Close()
	}
 	
 	s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
 	if $IsObject(PersonObj){
	 	s PersonObj.PAPERID=myIDNo
	 	Set sc1=PersonObj.%Save()
		If $$$ISERR(sc1) {
	 		Trollback
	 		Quit -100
	 	}
	 	d PersonObj.%Close()
 	}
 	
 	s DHCObj=##class(User.DHCPAPatMas).%OpenId(PatientID)
 	if $IsObject(DHCObj){
		s DHCObj.PAPMIAgencyCredNo=AgencyCredNo
		s DHCObj.PAPMIAgencyName=AgencyName
		s DHCObj.PAPMIAgencyTel=AgencyTel
		Set sc2=DHCObj.%Save()
		If $$$ISERR(sc2) {
	 		Trollback
	 		Quit -100
	 	}
	 	d DHCObj.%Close()
 	}
 	TCommit
	q 0
}

/// Description:保存处方预览打印时的相关打印信息
///  			信息包括：处方号、代办人姓名、代办人身份证号、本人身份证号、打印日期、打印用户
/// w ##class(DHCDoc.OPDoc.AjaxPatientAgentInfor).InsertPAQPrintLog()
ClassMethod InsertPAQPrintLog(PrintLogInfo As %String) As %String
{
	s ^tmpnk("InsertPAQPrintLog")=PrintLogInfo
	s myrtn=0
	s PrescNo=$p(PrintLogInfo,"^",1)
	s PrintUser=$p(PrintLogInfo,"^",2)
	s AgencyCredNo=$p(PrintLogInfo,"^",3)
	s AgencyName=$p(PrintLogInfo,"^",4)
	s AgencyTel=$p(PrintLogInfo,"^",5)
	s PrintDate=+$h
	s PrintTime=$p($h,",",2)
	Q:PrescNo="" myrtn
	Ts
	s LogObj=##class(User.DHCPAQuePrintLog).%New()
	if $IsObject(LogObj){
		s LogObj.PQPLPrescNo=PrescNo
		s LogObj.PQPLAgencyCredNo=AgencyCredNo
		s LogObj.PQPLAgencyName=AgencyName
		s LogObj.PQPLAgencyTel=AgencyTel
		s LogObj.PQPLPrintDate=PrintDate
		s LogObj.PQPLPrintTime=PrintTime
		d LogObj.PQPLPrintUserDRSetObjectId(PrintUser)
		Set sc=LogObj.%Save()
		If $$$ISERR(sc) {
	 		s myrtn="-100"
	 	}
	 	d LogObj.%Close()
	}
	if (+myrtn=0){
		TCommit
	}else{
		Tro
	}
	q myrtn
}

/// Description：根据处方号得到最近一次的打印时保存的代办人信息
/// w ##class(DHCDoc.OPDoc.AjaxPatientAgentInfor).GetAgencyInfoByPrescNo("O16012800002")
ClassMethod GetAgencyInfoByPrescNo(PrescNo As %String, EpisodeID As %String = "")
{
	;s ^tmpnk("GetAgencyInfoByPrescNo")=PrescNo
	q:PrescNo="" ""
	s findflag=0
	s ret=""
	s PAQPrintDate=""
	f  s PAQPrintDate=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate),-1) q:(PAQPrintDate="")!(findflag=1)  d
	.s PAQPrintTime=""
	.f  s PAQPrintTime=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate,PAQPrintTime),-1) q:(PAQPrintTime="")!(findflag=1)  d
	..s PAQPLRowID=0
	..f  s PAQPLRowID=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate,PAQPrintTime,PAQPLRowID)) q:PAQPLRowID=""  d
	...s PQPLAgencyCredNo=$p(^DHCPAQPL("PL",PAQPLRowID),"^",2)
	...s PQPLAgencyName=$p(^DHCPAQPL("PL",PAQPLRowID),"^",3)
	...s PQPLAgencyTel=$p(^DHCPAQPL("PL",PAQPLRowID),"^",4)
	...s findflag=1
	...s ret=PQPLAgencyCredNo_"^"_PQPLAgencyName_"^"_PQPLAgencyTel
	;如果未保存过,则取医嘱录入时保存信息
	i findflag=0 d
	.s SupplyInfo=..GetPatientAgentInfor(EpisodeID)
	.s PQPLAgencyCredNo=$p(SupplyInfo,"^",3)
	.s PQPLAgencyName=$p(SupplyInfo,"^",2)
	.s PQPLAgencyTel=$p(SupplyInfo,"^",4)
	.s ret=PQPLAgencyCredNo_"^"_PQPLAgencyName_"^"_PQPLAgencyTel
	q ret
}

ClassMethod NurPatInfo(EpisodeID) As %String
{
   //病人基本信息及费用
	//n (EpisodeID)
	if EpisodeID="" s EpisodeID=%request.Get("EpisodeID",1)
	//s ^T(0)=EpisodeID
	s Res=##class(web.DHCCLCom).PatInfo(""_"^"_EpisodeID)  //WKZ 071119
	s PatName=$P(Res,"^",5) //姓名
	s PatCardNo=$P(Res,"^",20)
	s Sex=$P(Res,"^",4) //性别
	s Age=$P(Res,"^",8) //年龄
	s AdmDate=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	s admDate=$p(AdmDate,"^",1)
	s admTime=$p(AdmDate,"^",2)
	i admDate'="" s admDate=$ZD(admDate,3)
	i admTime'="" s admTime=$ZT(admTime)
	s AdmDate=admDate_" "_admTime
	s BedCode=$P(Res,"^",7)
	s RegNo=$P(Res,"^",1) //登记号
	s ctloc=$P(Res,"^",2)
	s docdes=$P(Res,"^",12)
	s homeaddres=$P(Res,"^",10)
	s hometel=$P(Res,"^",11) //电话
	s MedCareNo=$P(Res,"^",13)
	s Nation=$P(Res,"^",15) //民族
	s paersonLX=$P(Res,"^",16)
	i $P($G(Nation),"-",2)'=""  s Nation=$P($G(Nation),"-",2)
	if $d(^DHCINADM("0","ADM",EpisodeID))'=0 d
	.s InfoId="",flag=""
	.s InfoId=$o(^DHCINADM("0","ADM",EpisodeID,InfoId),-1)
	.i $d(^DHCINADM(InfoId))=0  s CardNo=""
	.e  d
	..s s=$g(^DHCINADM(InfoId))
    ..s AdmDr=$p(s,"^",1)         ///指向PAADM的指针
    ..s InsuId=$p(s,"^",3)        ///医疗保险号
    ..s CardNo=$p(s,"^",3)        ///医保卡号
   
    s InsuId=##class(web.DHCINSUPort).GetInsuCardByAdm(EpisodeID)
    i +InsuId=0 d
    .s papmiId=+^PAADM(+EpisodeID)
    .s InsuId=$p($g(^PAPER(papmiId,"ALL")),"^",19)
    s total=+##class(web.UDHCJFORDCHK).getpatshare(EpisodeID)
    s depos=##class(web.UDHCJFCKD).deposit(EpisodeID)
    s balance=(+$G(depos))-(+$G(total))
    s warrant=##class(web.UDHCJFCKD).getwarrantamt(EpisodeID)
    s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID) ///获取留观状态
    b ;test1
    i (StayStatus=1)!(StayStatus=2) d
    .s depos=##class(web.DHCBillInterface).IGetStayDeposit(EpisodeID)
    .s balance=##class(web.DHCBillInterface).IGetStayBalance(EpisodeID)
    .Set StayFeeInfo=##Class(web.DHCBillInterface).IGetStayTotalAmt(EpisodeID,"")
	.Set total=+$p(StayFeeInfo,"^",1)
	.b ;test
    s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    if admreasondr'="" s admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    Set PatLevel=$p(PatEncryptLevel,"^",2) 
   //s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$G(docdes)
  // q $G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo_"^"_$G(Nation)_"^"_$G(paersonLX)
  s ret=$G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo_"^"_$G(Nation)_"^"_$G(paersonLX)_"^"_$g(PatCardNo)_"^"_$g(balance)
  //s ret=ret_"^"_PatLevel_"^"_EncryptLevel
  q ret
}

}
