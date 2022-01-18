Class DHCDoc.Interface.Outside.OrganizationUnit.Patient Extends (%RegisteredObject, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

Parameter IDCardType = 01;

Parameter CardType = 02;

/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("GetPatientInfo","{""patientIdTypeId"":""3"",""patientId"":""610430200801011018"",""patientName"":""白毅航"",""patientMobileNumber"":""15291078867"",""birthDate"":""2008-01-01"",""reservedParentName"":""白晓鹏"",""reservedParentIdentifier"":""610430197905301031"",""reservedParentIdentifierTypeId"":""3"",""isNewBorn"":true}").Read()
ClassMethod GetPatientCommon(JsonInput, ExtUserID)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s isNewBorn=InputObj.isNewBorn
	s patientIdTypeId =InputObj.patientIdTypeId
	s BornObj={"true":true}
	if ((isNewBorn=BornObj.true)&&(patientIdTypeId'="11"))
	
	{  
 		q ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetPatientInfo(JsonInput, ExtUserID)
	}else{
		
		q ..GetPatient(JsonInput, ExtUserID)
	}
}

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Patient).GetPatient("{""patientIdTypeId"":""24"",""patientId"":""530111198807203840""}","WX")
ClassMethod GetPatient(JsonInput, ExtUserID)
{
   b ;;;;111
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
		s CFIDCardNo=""    ;初始化身份证号码
		s IDCardType=..#IDCardType
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType)
		s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
		s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,patientId,"",GetPatientIDRule)
	   b ;;PatientIDStr
	}elseif (patientIdTypeId="11"){
		s CardType=..#CardType
		s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
		s CFRowid=0
		for {
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",patientId,CFRowid)) Q:CFRowid=""
			s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			s PatientCardType=$p(^DHCCARDTYPEDef(CFCardTypeDR),"^",1)   ;1卡类型
			Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s PatientIDStr=$p(^DHCCARD("CF",CFRowid),"^",4)
			s CFIDCardNo=$p($G(^DHCCARD("CF",CFRowid)),"^",5)  ;身份证号码
		}
		//if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-3300021","卡号在系统中未找到")
	}
	if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-330002","该查询信息在系统中未找到")
	s myPatientID=""
	set PatientIDStrLen=$l(PatientIDStr,"^")
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		/*if ('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID))) {
			s OutputObj.responseCode="-330002"
			s OutputObj.respongseText="该身份证号信息在系统中未找到"
		}
		continue:('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID)))*/
		Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		//医保号
		set PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
		set Sex=""
		set SexCode=$p(^PAPER(myPatientID,"ALL"),"^",7)
		i SexCode'="" set Sex=$p($g(^CT("SEX",SexCode)),"^",2)
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
		
		s PAPERForeignCountry=$p($g(^PAPER(myPatientID,"PER",2)),"^",4)   ;联系人身份证
		s PAPERForeignId=$p($g(^PAPER(myPatientID,"PER",2)),"^",13)   ;联系人姓名
		
		if Mobile="" s Mobile=TelephoneNo
		s PatinetNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		s PatObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.getpatient).%New()
		s PatObj.patientIdTypeId=patientIdTypeId
		s patientIdTypeIdNew=patientIdTypeId
		s PatObj.patientIdTypeId="3"
		s PatObj.patientId=patientId
		s PatObj.patientName=PatientName
		i CFIDCardNo'="" s PatObj.patientId=CFIDCardNo
		i (CFIDCardNo="")&&(patientIdTypeIdNew="11") s PatObj.patientId=" "
		s PatObj.patientHisId=PatinetNo
		s PatObj.patientFamilyName=$e(PatientName,1,1)
		s PatObj.patientGivenName=$e(PatientName,2,$l(PatientName))
		s PatObj.patientFullName=PatientName
		s PatObj.patientGenderTypeId=$case(Sex,"男":4,"女":3,:1) ;（1 未知、 2 其它、 3女、 4 男）
		s PatObj.patientMobileNumber=Mobile
		s PatObj.patientResidenceAddress=Address
		s PatObj.patientFullName=PatientName
		////  add  by  qjh  2021-07-09 新增
		s PatObj.reservedParentIdentifierTypeId="3"
		s PatObj.reservedParentIdentifier=PAPERForeignCountry
		s PatObj.reservedParentName=PAPERForeignId
		s PatObj.birthDate=$ZD(DOB,3)
		////  add  by  qjh  2021-07-09
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
			;Continue:((CFCardTypeDR'=16)&(CFCardTypeDR'=26))  ;身份证和电子健康卡
			s CardObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard).%New()
		    s CardObj.identifierTypeId=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetOutCardType(CFCardTypeDR) ;(1-预留2-预留 3-院内就诊卡 4-电子健康卡 5-门诊号码)
			i CFCardTypeDR=24  s CardObj.identifierTypeId=6
			i CFCardTypeDR=25  s CardObj.identifierTypeId=8
			i CFCardTypeDR=2  s CardObj.identifierTypeId=3
			;e  s CardObj.identifierTypeId=3    ;;标识类型 (1-预留2-预留3-院内就诊卡 4-电子健康卡 8-院内虚拟卡)
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
	
	;b ;Hhr OutputObj
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
	s patientIdTypeId =obj.patientIdTypeId  ;卡类型
	s patientId =obj.patientId  ;;卡号 
	s patientFullName =obj.patientFullName 
	s patientGenderTypeId =obj.patientGenderTypeId 
	s patientMobileNumber =obj.patientMobileNumber 
	s patientResidenceAddress =obj.patientResidenceAddress 
	s healthCardId =obj.healthCardId 
	;renyx 添加联系人信息
	s ForeignId =obj.reservedParentIdentifier //预留家长身份证Id
	s ForeignName =obj.reservedParentName // 预留家长姓名
	s ForeignRelation=obj.relation // 与预留家长的关系
	s BirthDate=obj.birthDate
    ;b ;;;11
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="建卡成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	;b ;hhr abc
	;renyx 修改新生儿入参   
	s CheckPatUserFlag=""
	s BornObj={"true":true}
	s:obj.isNewBorn=BornObj.true CheckPatUserFlag="Y"
	if (patientIdTypeId="")&&(CheckPatUserFlag'="Y"){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID类型不能为空")
		q OutputObj
	}
	if (patientId="")&&(CheckPatUserFlag'="Y"){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID不能为空")
		q OutputObj
	}
	if (patientFullName=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者姓名不能为空")
		q OutputObj
	}
	;b ;patientGenderTypeId
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
		;b ;	SavePatientObj
	s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(..#IDCardType,patientId,patientFullName,"")
	i $d(^PAPER(+PatientIDStr,"ALL")){
		;d ..SetOutputCode(.OutputObj,"-1002","该证件类型在His中已存在")
		;q OutputObj
	}
	;b ;hhr beforeinput
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.SavePatientCardRt).%New()
	;set InputObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	set InputObj.Address=patientResidenceAddress
	Set InputObj.TradeCode="3014"
	set InputObj.CardTypeCode="06"    ;qjh 身份证卡类型
	s:CheckPatUserFlag="Y" InputObj.CardTypeCode="07"
	set InputObj.PatientCard=patientId
	set InputObj.SecurityNo=""
	set InputObj.PatientName=patientFullName
	set InputObj.Sex=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetSexByOut(patientGenderTypeId)
	// b ;;InputObj.Sex
	if CheckPatUserFlag'="Y" set InputObj.DOB=$e(patientId,7,10)_"-"_$e(patientId,11,12)_"-"_$e(patientId,13,14)
	else  set InputObj.DOB=BirthDate
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
	;set InputObj.IsSpecialFlag=""
	set InputObj.SecurityNo=""
	set InputObj.TelephoneNo=patientMobileNumber
	//b //s ForeignRelation =obj.relation // 与预留家长的关系
	set:ForeignName'="" InputObj.ContactName=ForeignName
	s:ForeignId'="" InputObj.ContactIDType=..#IDCardType
	s:ForeignId'="" InputObj.ContactID=ForeignId
	s:ForeignRelation'="" InputObj.Relation=$case(ForeignRelation,"1":"8","2":"8","3":"6","4":"6","5":"6","6":"6","7":"5","8":"5","9":"2","10":"3","11":"1")
	s InputObj.CheckPatUserFlag=CheckPatUserFlag
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

ClassMethod UpdatePatientInfo(JsonInput, ExtUserID)
{
	s $ZTRAP="UpdatePatientInfoErr"
	s obj=##class(%DynamicObject).%FromJSON(JsonInput)
	//##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	; patientHisId string 是 患者在 HIS 系统的标识 P101010100
	s PatientNo=obj.patientHisId
	; patientIdTypeId int 否 患者 ID 类型(1-预留 2-预留3-身份证号)3
	s PatCredType =obj.patientIdTypeId
	; patientId string 否 患者 ID 110111188605069875
	s PatCredNo =obj.patientId
	; patientName string 否 患者姓名 张三
	s PatName =obj.patientName
	; patientMobileNumber string 否 患者手机号 1881111222222
	s PatPhoneNo =obj.patientMobileNumber
	; birthDate string 否 出生日期(格式yyyy-MM-dd)2021-03-16
	s PatBirth =obj.birthDate
	; patientResidenceAddress string 否 患者居住地址 北京市西城区复兴门外大街999 号院11 号楼 3 单元 502 室
	s PatAddress =obj.patientResidenceAddress
	; reservedParentIdentifierTypeId int 否 患者 ID 类型(1-预留 2-预留3-身份证号)3
	s PatCredType=obj.reservedParentIdentifierTypeId
	; reservedParentIdentifier string 否 预留家长身份证 Id 110111188605069875
	s ForeignIdNo =obj.reservedParentIdentifier
	; reservedParentName string 否 预留家长姓名 张三
	s ForeignName =obj.reservedParentName
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	s OutputObj={}
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	if (PatientNo=""){
		d ..SetOutputCode(.OutputObj,"-1","无法确定病人，请务必传入登记号")
		quit OutputObj
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	s IDCardType=""
	if (PatCredType'=""){
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,PatCredType)
		i IDCardType=""{
			d ..SetOutputCode(.OutputObj,"-1","证件类型没有对照")
			q OutputObj
		}
	}
	s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	if myPatientID=""{
		d ..SetOutputCode(.OutputObj,"-1","病人不存在")
		quit OutputObj
	}
	s FindCardid="",CFRowid=0
	for{
		s CFRowid=^DHCCARDi("CF",0,"PAPMIDR",myPatientID,CFRowid)
		Quit:CFRowid=""
		Set CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
		Continue:CFActive'="N"
		Set CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
		Continue:(CardTypeID'="")&(CardTypeID'=CFCardTypeDR)
		Set myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
		set FindCardid=CFRowid
	}
	s PatientCardNo=""
	Ts
	s PersonObj=##class(User.PAPerson).%OpenId(myPatientID)
	s PatMasObj=##class(User.PAPatMas).%OpenId(myPatientID)
	s CardObj=##class(User.DHCCardRef).%OpenId(FindCardid)
	s OldInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(myPatientID)
	if '$IsObject(PersonObj){
		;q "-1^病人主索引不正确"
	}
	if PatPhoneNo'=""{
 		s PersonObj.PAPERMobPhone=PatPhoneNo
		s PersonObj.PAPERTelH=PatPhoneNo
	}	
	i PatCredNo'=""{
		s PatMasObj.PAPMIDVAnumber=PatCredNo
		i PatMasObj.PAPMICardTypeDRGetObjectId()="" d PatMasObj.PAPMICardTypeDRSetObjectId(IDCardType)
		if IDCardType="1" d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(myPatientID,PatCredNo)
	}
	
	i PatAddress'=""{
		i PersonObj.PAPERStName.Count()=0{
			d PersonObj.PAPERStName.Clear()
			;s PersonObj.PAPERStName.GetAt(i)
			d PersonObj.PAPERStName.Insert(PatAddress)
		}
	}
	s PatMasObj.PAPMIName=PatName
	if PatBirth'="" s PersonObj.PAPERDob= $zdh(PatBirth,"3")
	if ForeignIdNo'="" s PersonObj.PAPERForeignCountry=ForeignIdNo
	if ForeignName'="" s PersonObj.PAPERForeignId=ForeignName
	s PersonObj.PAPERUpdateDate= +$h
	s PersonObj.PAPERUpdateTime= $p($h,",",2)
	s sc=PersonObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		Trollback
		d ..SetOutputCode(.OutputObj,"-1","更新人员信息失败PAPerson")
		quit OutputObj
 	}
 	s sc=PatMasObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		Trollback
		d ..SetOutputCode(.OutputObj,"-1","更新人员信息失败PAPatMas")
		quit OutputObj
 	}
	s NewInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(myPatientID)
 	s LogInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).CheckPatInfoUpdate(OldInfo,NewInfo)
 	s Flag=##class(web.DHCBL.Patient.DHCPatientBuilder).AddDHCPatientUpdateLog(LogInfo,UserID)
 	if Flag'=0{
	 	Trollback
		d ..SetOutputCode(.OutputObj,"-1","更新人员信息日志失败")
		quit OutputObj
 	}
 	if $IsObject(CardObj){
 		s CardObj.CFIDCardNo=PatCredNo
		s PatientCardNo=CardObj.CFCardNo
 		s sc=CardObj.%Save()
	 	If $$$ISERR(sc) {
			Do $System.Status.DisplayError(sc)
			Trollback
			d ..SetOutputCode(.OutputObj,"-1","更新卡表信息失败DHCCardRef")
			quit OutputObj
	 	}
 	}
	d CardObj.%Close()
 	d PatMasObj.%Close()
	d PersonObj.%Close()
	Tc
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTextForUser="患者信息修改成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	s PatObj={}
	s PatObj.patientHistId=PatientNo
	s PatObj.medicalCardId=PatientCardNo
	s OutputObj.Data=PatObj
	q OutputObj
UpdatePatientInfoErr
	s $ZTRAP=""
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","SavePatient调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
	q OutputObj
}

}
