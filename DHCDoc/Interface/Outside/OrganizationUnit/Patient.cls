Class DHCDoc.Interface.Outside.OrganizationUnit.Patient Extends (%RegisteredObject, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

Parameter IDCardType = 01;

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Patient).GetPatient("{""patientIdTypeId"":""3"",""patientId"":""530111198807203840""}","WX")
ClassMethod GetPatient(JsonInput, ExtUserID)
{
	s $ZTRAP="GetPatientErr"
	s ^nk("GetPatient")=$LB(JsonInput, ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s patientIdTypeId =obj.patientIdTypeId 
	s patientId =obj.patientId 

	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	if (patientIdTypeId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID类型不能为空")
		q OutputObj
	}
	if (patientId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}

	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	s PatientIDStr=""
	if patientIdTypeId=3{
		s IDCardType=..#IDCardType
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType)
		s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
		s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,patientId,"",GetPatientIDRule)
	}
	if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-330002","该身份证号信息在系统中未找到")
	s myPatientID=""
	set PatientIDStrLen=$l(PatientIDStr,"^")
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		if ('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID))) {
			s OutputObj.responseCode="-330002"
			s OutputObj.respongseText="该身份证号信息在系统中未找到"
		}
		continue:('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID)))
		Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		//医保号
		set PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
		set Sex=""
		set SexCode=$p(^PAPER(myPatientID,"ALL"),"^",7)
		i SexCode'="" set Sex=$p(^CT("SEX",SexCode),"^",2)
		set DOB=$p(^PAPER(myPatientID,"ALL"),"^",6)
		set DocumentID=$p(^PAPER(myPatientID,"PAT",1),"^",22)
		set AddressId=$o(^PAPER(myPatientID,"PER","ADD",""),-1)
		set Address=""
		set:AddressId'="" Address=$g(^PAPER(myPatientID,"PER","ADD",AddressId))
		set IDTypeDesc=""
		set IDTypeCode=$p(^PAPER(myPatientID,"PAT",3),"^",7)
		if IDTypeCode'="" set IDTypeDesc=$p(^PAC("CARD",IDTypeCode),"^",7)
		set IDNo=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
		s TelephoneNo=$p(^PAPER(myPatientID,"PER",1),"^",11)
		s Mobile=$p($g(^PAPER(myPatientID,"PER",4)),"^",21)
		if Mobile="" s Mobile=TelephoneNo
		s PatinetNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		s PatObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.getpatient).%New()
		s PatObj.patientIdTypeId=patientIdTypeId
		s PatObj.patientId=patientId
		s PatObj.patientHistId=PatinetNo
		s PatObj.patientFamilyName=$e(PatientName,1,1)
		s PatObj.patientGivenName=$e(PatientName,2,$l(PatientName))
		s PatObj.patientFullName=PatientName
		
		s PatObj.patientGenderTypeId=$case(Sex,"男":4,"女":3,:1) ;（1 未知、 2 其它、 3女、 4 男）
		s PatObj.patientMobileNumber=Mobile
		s PatObj.patientResidenceAddress=Address
		s PatObj.patientFullName=PatientName
		
		s PatientCardID=""
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:PatientCardID=""
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
			s CFDate=$p(^DHCCARD("CF",PatientCardID),"^",7)
			s CFTime=$p(^DHCCARD("CF",PatientCardID),"^",8)
			Continue:((CFCardTypeDR'=16)&(CFCardTypeDR'=26))  ;身份证和电子健康卡
			s CardObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard).%New()
			;s CardObj.identifierTypeId=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetOutCardType(CFCardTypeDR) ;(1-预留2-预留 3-院内就诊卡 4-电子健康卡 5-门诊号码)
			i CFCardTypeDR=16  s CardObj.identifierTypeId=4
			i CFCardTypeDR=26  s CardObj.identifierTypeId=3
			s CardObj.identifierText=PatientCard
			s CardObj.isValid="true"
			s CardObj.createDate=$zd(CFDate,3)
			s CardObj.createTime=$zt(CFTime,1)
			s CardObj.lastUsedDate=$zd(CFDate,3)
			s CardObj.lastUsedTime=$zt(CFTime,1)
			s CardObj.mappedPatientHisId=PatinetNo
			d PatObj.patientIdentifierList.Insert(CardObj)
			d CardObj.%Close()
		}
		s OutputObj.PatientData=PatObj
		d OutputObj.%Close()
	}
	
	b ;Hhr OutputObj
	Q OutputObj
GetPatientErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRefundBillNo调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Patient).SavePatient("{""patientIdTypeId"" : 3,""patientId"" : ""532328193403150014"",""patientFamilyName"" : ""阮"",""patientGivenName"" : ""绍宽"",""patientFullName"" : ""阮绍宽"",""patientGenderTypeId"" : ""4"",""patientMobileNumber"" : ""13618780055"",""patientResidenceAddress"" : ""楚雄市开发区金盾小区"",""healthCardId"" : """"}","WX")
ClassMethod SavePatient(JsonInput, ExtUserID)
{
	s $ZTRAP="SavePatientErr"
	s ^nk("SavePatientWX")=$LB(JsonInput, ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s patientIdTypeId =obj.patientIdTypeId  ;身份证
	s patientId =obj.patientId  ;;身份证
	s patientFullName =obj.patientFullName 
	s patientGenderTypeId =obj.patientGenderTypeId 
	s patientMobileNumber =obj.patientMobileNumber 
	s patientResidenceAddress =obj.patientResidenceAddress 
	s healthCardId =obj.healthCardId 

	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="建卡成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	b ;hhr abc
	if (patientIdTypeId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID类型不能为空")
		q OutputObj
	}
	if (patientId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID不能为空")
		q OutputObj
	}
	if (patientFullName=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者姓名不能为空")
		q OutputObj
	}
	if (patientGenderTypeId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者性别不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
		
	Set SavePatientObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.savepatient).%New()
	
	s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(..#IDCardType,patientId,patientFullName,"")
	i $d(^PAPER(+PatientIDStr,"ALL")){
		;d ..SetOutputCode(.OutputObj,"-1002","该证件类型在His中已存在")
		;q OutputObj
	}
	b ;hhr beforeinput
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.SavePatientCardRt).%New()
	;set InputObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	set InputObj.Address=patientResidenceAddress
	Set InputObj.TradeCode="3014"
	set InputObj.CardTypeCode="05"
	set InputObj.PatientCard=patientId
	set InputObj.SecurityNo=""
	set InputObj.PatientName=patientFullName
	set InputObj.Sex=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetSexByOut(patientGenderTypeId)
	set InputObj.DOB=$e(patientId,7,10)_"-"_$e(patientId,11,12)_"-"_$e(patientId,13,14)
	set InputObj.IDType=..#IDCardType
	set InputObj.IDNo=patientId
	set InputObj.Mobile=patientMobileNumber
	set InputObj.UserID=ExtUserID
	Set InputObj.TerminalID=""
	set InputObj.CardDepositAmt=""
	set InputObj.PayModeCode=""
	set InputObj.PayBankCode=""
	set InputObj.PayCardNo=""
	set InputObj.PayTradeStr=""
	set InputObj.PatientType=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetDefPatType()
	set InputObj.ChargeDepositAmt=""
	set InputObj.AccountPassword=""
	set InputObj.TheArea=""
	set InputObj.BankTradeInfo=""
	set InputObj.IsSpecialFlag=""
	
	set InputObj.SecurityNo=""
	set InputObj.TelephoneNo=patientMobileNumber
	do InputObj.XMLExportToString(.InputXML,"Request")
	b ;hhr inserterr1
	s InsertRet=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(InputXML)
	b ;hhr insertenderr
	s ResultCode=InsertRet.ResultCode
	s ResultContent=InsertRet.ResultContent
	if (ResultCode="0"){
		s InsertPatientID=InsertRet.PatientID
		s patientHisId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(InsertPatientID)
		s outpatientId=InsertPatientID
		s SavePatientObj.patientHisId=InsertPatientID
		s SavePatientObj.outpatientId=outpatientId
		s OutputObj.SavePatientData=SavePatientObj
	}else{
		s OutputObj.responseCode=ResultCode	
		s OutputObj.respongseText=ResultContent
	}
	Q OutputObj
SavePatientErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","SavePatient调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

}