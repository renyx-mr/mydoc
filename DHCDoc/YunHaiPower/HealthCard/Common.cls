Class DHCDoc.YunHaiPower.HealthCard.Common Extends %RegisteredObject [ LegacyInstanceContext ]
{

/// 机构编码
Parameter HospitalOrgCode = "12ceshi";

Parameter HospitalOrgName = "13ceshi";

/// 4.1.1 诊疗卡创建接口
/// w ##class(DHCDoc.YunHaiPower.HealthCard.Common).CreatePatientID()
ClassMethod CreatePatientID(InputJsonStr As %String = "") As %GlobalCharacterStream
{
	s $ZTRAP="CreatePatientIDErrMag"
	s InputJsonStr="{""name"":""张三"",""gender"":""1"",""nation"":""2"",""birthday"":""1978-04-28"",""idCard"":""xxxxxxxxxxxxxxxxx"","
		_"""cardType"":""0"",""address"":""xxx"",""phone"":""18808808808""}"
	s InputObj=##class(ext.util.JsonObject).FromJSON(InputJsonStr)
	s name= InputObj.GetValue("name")
	s gender= InputObj.GetValue("gender")
	s nation= InputObj.GetValue("nation")
	s birthday= InputObj.GetValue("birthday")
	s idCard= InputObj.GetValue("idCard")
	s cardType= InputObj.GetValue("cardType")
	s address= InputObj.GetValue("address")
	s phone= InputObj.GetValue("phone")
	
	if (name="") {
		q $$CreatePatientIDErrMag("患者姓名不能为空.")
	}
	if (cardType="") {
		q $$CreatePatientIDErrMag("证件类型不能为空.")
	}
	if (idCard="") {
		q $$CreatePatientIDErrMag("证件号码不能为空.")
	}
	if (gender="") {
		q $$CreatePatientIDErrMag("性别不能为空.")
	}
	if (birthday="") {
		q $$CreatePatientIDErrMag("出生日期不能为空.")
	}
	s PatientIDStr=..GetAllPatIDByIDCardAndName(idCard,name)
	i '$d(^PAPER(+PatientIDStr,"ALL")) q $$CreatePatientIDErrMag("系统中未找到对应信息,请先到医院建立实体卡。")
	set PatientIDStrLen=$l(PatientIDStr,"^")
	s PatientCardID=""
	s PatDr=""
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		s PatientCardID=""
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:PatientCardID=""
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s PatDr=$p(PatientIDStr,"^",mycount)
		}
	}
	if (PatientCardID="")||(PatDr="")  q $$CreatePatientIDErrMag("系统中未找到对应的卡信息,请先到医院核实账户信息。")
	s RetErr=..ReceiveHealthCard(PatDr,"1")
	if (+RetErr'="0") q $$CreatePatientIDErrMag("关联健康卡失败:"_$p(RetErr,"^",2)_"请联系客服或者到医院处理。")
	
	s Content=##class(%ArrayOfDataTypes).%New()
    /*d Content.SetAt((..#HospitalOrgCode),"orgCode")	;机构编码 orgCode 是 string 平台分配
    d Content.SetAt((..#HospitalOrgName),"orgName")	;机构名称 orgName 是 string 平台分配
    s PatInfo=..GetPatInfoById(PatDr)
    d Content.SetAt("000000","visitSceneCode")	;用卡场景代码 visitSceneCode 是 string 见 6.4 用卡场景代码
    s healthCardId=$p(RetErr,"^",7)
    d Content.SetAt(healthCardId,"healthCardId")	;电子健康卡 ID healthCardId 是 string
    s idCard=$p(RetErr,"^",3)
    s cardType=$p(RetErr,"^",4)
    d Content.SetAt(idCard,"idCard")	;证件号 idCard 是 string
    d Content.SetAt(cardType,"cardType")	;证件类型 cardType 是 string 见身份证件类型代码*/
    s patintID=..PatientIDToNo(PatDr)
    d Content.SetAt(patintID,"patintID")	;诊疗卡号 patintID 是 string 诊疗卡号或院内主索引号
    s name=$p(RetErr,"^",5)
    d Content.SetAt(name,"name")	;姓名 name 是 string
    s idCard=$p(RetErr,"^",3)
    s cardType=$p(RetErr,"^",4)
    d Content.SetAt(idCard,"idCard")	;证件号 idCard 是 string
    d Content.SetAt(cardType,"cardType")	;证件类型 cardType 是 string 见身份证件类型代码
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    s Stream=##class(%GlobalCharacterStream).%New()
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
	q Stream
CreatePatientIDErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	s Stream=##class(%GlobalCharacterStream).%New()
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt("1","resultCode")
    d Content.SetAt(ErrText,"errMsg")
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
    q Stream
}

/// 4.1.2 诊疗卡映射接口
/// w ##class(DHCDoc.YunHaiPower.HealthCard.Common).RecivePatientID("5")
ClassMethod RecivePatientID(PatDr As %String) As %String
{
	s $ZTRAP="RecivePatientIDErrMag"
	//s InputObj=##class(ext.util.JsonObject).FromJSON(InputJsonStr)
	s ParNo=..PatientIDToNo(PatDr)
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt((..#HospitalOrgCode),"orgCode")
    d Content.SetAt((..#HospitalOrgName),"orgName")
    d Content.SetAt(ParNo,"patintID")	;诊疗卡号 patintID 是 string 诊疗卡号或院内主索引号
    s healthCardId=..GetHealthInfoById(PatDr)
    d Content.SetAt("","healthCardId")	;电子健康卡 ID healthCardId 是 string 电子健康卡
	s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    s Stream=##class(%GlobalCharacterStream).%New()
   
    d Stream.Write("{""head"":{""resultCode"":""0""},""errMsg"":""成功"",""rsp"":"_JsonStr_"}")
    
    s RetJson=""
	s RetJson=$replace(RetJson,"""head"":","")
	s RetJson=$replace(RetJson,"""rsp"":","")
	s OutputObj=##class(ext.util.JsonObject).FromJSON(RetJson)
	s resultCode= OutputObj.GetValue("resultCode")
	s errMsg=OutputObj.GetValue("errMsg")
    q resultCode_"^"_errMsg
	
RecivePatientIDErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	q "1^"_ErrText
	/*s Stream=##class(%GlobalCharacterStream).%New()
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt("1","resultCode")
    d Content.SetAt(ErrText,"errMsg")
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
    q Stream*/
}

/// 4.1.3 注册电子健康卡接口
/// w ##class(DHCDoc.YunHaiPower.HealthCard.Common).ReceiveHealthCard("q2")
ClassMethod ReceiveHealthCard(PatDr As %String, AppMode As %String) As %String
{
	s $ZTRAP="ReceiveHealthCardErrMag"
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt((..#HospitalOrgCode),"orgCode")
    d Content.SetAt((..#HospitalOrgName),"orgName")
    s PatInfo=..GetPatInfoById(PatDr)
    s name=$p($g(PatInfo),"^",1) ;是 string
	s gender=$p($g(PatInfo),"^",2) ; 是 string 见性别代码表
	s nation=$p($g(PatInfo),"^",11) ; 否 string 见民族类别代码表
	s birthday=$p($g(PatInfo),"^",3) ; 是 string 格式：yyyy-MM-dd
	s idCard=$p($g(PatInfo),"^",4) ; 是 string
	s cardType=$p($g(PatInfo),"^",5) ; 是 string 见身份证件类型代码表
	s address=$p($g(PatInfo),"^",9) ; 否 string
	s phone=$p($g(PatInfo),"^",7) ; 是 string 注册人联系方式
	s patid=..PatientIDToNo(PatDr) ; 否 string id 或就诊卡号
	s appMode=AppMode ; 是 string1:APP 在线申请2:医疗卫生机构自助机申请3:医疗卫生机构窗口申请4:批量预生成
	s payAccType="0^1^2^3^4^5^9" ;0:无1:微信2:支付宝3:银联4:银行5:统一支付平台9:其他
    d Content.SetAt(name,"name")
    d Content.SetAt(gender,"gender")
    d Content.SetAt(nation,"nation")
    d Content.SetAt(birthday,"birthday")
    d Content.SetAt(idCard,"idCard")
    d Content.SetAt(cardType,"cardType")
    d Content.SetAt(address,"address")
    d Content.SetAt(phone,"phone")
    d Content.SetAt(patid,"patid")
    d Content.SetAt(appMode,"appMode")
    d Content.SetAt(payAccType,"payAccType")
	s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
	//s Json=##class(ext.util.JsonObject).ObjToJson(InsertObj)
	
	
	s RetJson="{""head"":{""resultCode"":""0"",""errMsg"":""成功""},"
		_"""rsp"":{""idCard"":""xxxxxxxxxxxxxxxxx"",""cardType"":""01"",""name"":""张三"","
		_"""qrCodeText"":""85:9A60D3D561E4ADBA89ACD9FBF2FB8D2C:1"",""healthCardId"":""9A60D3D561E4ADBA89ACD9FBF2FB8D2C"","
		_"""healthCardNo"":""xxxxxxxxxxxxxxxxx"",""mainIndexId"":""xxxxxxxxxxxxxxxxx""}}"
	s RetJson=$replace(RetJson,"""head"":","")
	s RetJson=$replace(RetJson,"""rsp"":","")
	s OutputObj=##class(ext.util.JsonObject).FromJSON(RetJson)
	s resultCode= OutputObj.GetValue("resultCode")
	s errMsg=OutputObj.GetValue("errMsg")
	s (idCard,cardType,name,qrCodeText,healthCardId,healthCardNo,mainIndexId)=""
	if (resultCode="0"){
		s idCard= OutputObj.GetValue("idCard") 
		s cardType= OutputObj.GetValue("cardType")
		s name= OutputObj.GetValue("name")
		s qrCodeText= OutputObj.GetValue("qrCodeText")
		s healthCardId= OutputObj.GetValue("healthCardId")
		s healthCardNo= OutputObj.GetValue("healthCardNo")
		s mainIndexId= OutputObj.GetValue("mainIndexId")
		s reterr=..UpdatePatInfo(PatDr,healthCardNo,healthCardId,qrCodeText)
		if (reterr="0"){
			if (AppMode'="1"){
				s reterr= ..RecivePatientID(PatDr)
				if (+reterr'="0"){
					q $$ReceiveHealthCardErrMag("诊疗卡和电子健康卡映射失败")
				}
			}
		}else{
			q $$ReceiveHealthCardErrMag("添加电子健康卡失败")
		}
	}else{
		q $$ReceiveHealthCardErrMag("创建电子健康卡失败")
	}
	q resultCode_"^"_errMsg_"^"_idCard_"^"_cardType_"^"_name_"^"_qrCodeText_"^"_healthCardId_"^"
		_healthCardNo_"^"_mainIndexId
	///Do objStream.Write(Json)
ReceiveHealthCardErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	q "1^"_ErrText
}

/// 4.1.4 电子健康卡查询接口
ClassMethod GetHealthCard(PatDr As %String, VisitSceneCode As %String) As %String
{
	s $ZTRAP="GetHealthCardErrMag"
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt((..#HospitalOrgCode),"orgCode")	;机构编码 orgCode 是 string 平台分配
    d Content.SetAt((..#HospitalOrgName),"orgName")	;机构名称 orgName 是 string 平台分配
    s PatInfo=..GetPatInfoById(PatDr)
    d Content.SetAt(VisitSceneCode,"visitSceneCode")	;用卡场景代码 visitSceneCode 是 string 见 6.4 用卡场景代码
    s healthCardId=..GetHealthInfoById(PatDr)
    d Content.SetAt(healthCardId,"ID")	;电子健康卡 ID healthCardId 是 string
    s idCard=$p(PatInfo,"^",4)
    s cardType=$p(PatInfo,"^",5)
    d Content.SetAt(idCard,"idCard")	;证件号 idCard 是 string
    d Content.SetAt(cardType,"cardType")	;证件类型 cardType 是 string 见身份证件类型代码
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
	s RetJson=""
	s RetJson=$replace(RetJson,"""head"":","")
	s RetJson=$replace(RetJson,"""rsp"":","")
	s InputObj=##class(ext.util.JsonObject).FromJSON(RetJson)
	s resultCode= InputObj.GetValue("resultCode")
	s errMsg=InputObj.GetValue("errMsg")
	s (qrCodeText,healthCardId,mainIndexId,name,gender,nation)=""
	if (resultCode="0"){
		s qrCodeText= InputObj.GetValue("qrCodeText")	;电子健康卡二维码 qrCodeText 是String（66）静态二维码
		s healthCardId= InputObj.GetValue("healthCardId")	;电子健康卡 ID healthCardId 是string（64）
		s mainIndexId= InputObj.GetValue("mainIndexId")	;主索引 ID mainIndexId 是 string 电子健康卡主索引 ID
		s name= InputObj.GetValue("name")	;姓名 name 是 string
		s gender= InputObj.GetValue("gender")	;性别 gender 是 string 见性别代码表
		s nation= InputObj.GetValue("nation")	;民族 nation 否 string
	}else{
		q $$GetHealthCardErrMag("查询电子健康卡失败")
	}
	q resultCode_"^"_errMsg_"^"_qrCodeText_"^"_healthCardId_"^"_mainIndexId_"^"_name_"^"_gender_"^"_nation
GetHealthCardErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	q resultCode_"^"_ErrText
	/*s Stream=##class(%GlobalCharacterStream).%New()
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt("1","resultCode")
    d Content.SetAt(ErrText,"errMsg")
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
    q Stream*/
}

/// 4.1.5 获取电子健康卡二维码
/// w ##class(DHCDoc.YunHaiPower.HealthCard.Common).GetHealthCardQrcode("q2")
ClassMethod GetHealthCardQrcode(PatDr As %String) As %String
{
	s $ZTRAP="GetHealthCardQrcodeErrMag"
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt((..#HospitalOrgCode),"orgCode")	;机构编码 orgCode 是 string 平台分配
    d Content.SetAt((..#HospitalOrgName),"orgName")	;机构名称 orgName 是 string 平台分配
    s PatInfo=..GetPatInfoById(PatDr)
    s healthCardId=..GetHealthInfoById(PatDr)
    d Content.SetAt(healthCardId,"healthCardId")	;电子健康卡 ID healthCardId 是 string
    s idCard=$p($g(PatInfo),"^",4) ; 是 string
	s cardType=$p($g(PatInfo),"^",5) ; 是 string 见身份证件类型代码表
    d Content.SetAt(idCard,"idCard")	;证件号 idCard 是 string 申领时证件号
    d Content.SetAt(cardType,"cardType")	;证件类型 cardType 是 string 见身份证件类型代码表
    d Content.SetAt("","codeType")	;二维码类型 codeType 是 string1.静态2.动态
    d Content.SetAt("","returnType")	;返回数据类型 returnType 是 string1.二维码图片字符串(BASE64)
	s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
	s RetJson=""
	s RetJson=$replace(RetJson,"""head"":","")
	s RetJson=$replace(RetJson,"""rsp"":","")
	s InputObj=##class(ext.util.JsonObject).FromJSON(RetJson)
	s resultCode= InputObj.GetValue("resultCode")
	s errMsg=InputObj.GetValue("errMsg")
	s qrCodeText=""
	if (resultCode="0"){
		s qrCodeText= InputObj.GetValue("qrCodeText")	;电子健康卡二维码 qrCodeText 是 String
	}else{
		q $$GetHealthCardQrcodeErrMag("获取电子健康卡二维码失败")
	}
	
	q resultCode_"^"_errMsg_"^"_qrCodeText
GetHealthCardQrcodeErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	q "1^"_ErrText
}

/// 4.1.6 二维码校验接口
ClassMethod VerifyHealthCardQrcode(PatDr As %String, QrCode As %String, VisitSceneType As %String) As %String
{
	s $ZTRAP="VerifyHealthCardQrcodeErrMag"
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt((..#HospitalOrgCode),"orgCode")	;机构编码 orgCode 是 string 平台分配
    d Content.SetAt((..#HospitalOrgName),"orgName")	;机构名称 orgName 是 string 平台分配
    d Content.SetAt(QrCode,"qrCodeText")	;电子健康卡二维码 qrCodeText 是 string（128） 
    d Content.SetAt(VisitSceneType,"visitSceneCode")	;用卡场景代码 visitSceneCode 是 string 见 6.4 用卡场景代码
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
	s RetJson=""
	s RetJson=$replace(RetJson,"""head"":","")
	s RetJson=$replace(RetJson,"""rsp"":","")
	s InputObj=##class(ext.util.JsonObject).FromJSON(RetJson)
	s resultCode= InputObj.GetValue("resultCode")
	s errMsg=InputObj.GetValue("errMsg")
	s (qrCodeText,healthCardId,mainIndexId,name,gender,nation,birthday,idCard,cardType,address,phone)=""
	if (resultCode="0"){
		s qrCodeText= InputObj.GetValue("qrCodeText")	;电子健康卡二维码 qrCodeText 是string（99）
		s healthCardId= InputObj.GetValue("healthCardId")	;电子健康卡 ID healthCardId 是string（64）
		s mainIndexId= InputObj.GetValue("mainIndexId")	;主索引 ID mainIndexId 是 string 主索引 ID
		s name= InputObj.GetValue("name")	;姓名 name 是 string
		s gender= InputObj.GetValue("gender")	;性别 gender 是 string 见性别代码表
		s nation= InputObj.GetValue("nation")	;民族 nation 否 string
		s birthday= InputObj.GetValue("birthday")	;出生年月日 birthday 是 string 格式：yyyy-MM-dd
		s idCard= InputObj.GetValue("idCard")	;证件号 idCard 是 string
		s cardType= InputObj.GetValue("cardType")	;证件类型 cardType 是 string 见证件类别代码表
		s address= InputObj.GetValue("address")	;联系地址 address 否 string
		s phone= InputObj.GetValue("phone")	;联系电话 phone 是 string 联系方式
	}else{
		q $$VerifyHealthCardQrcodeErrMag("二维码校验失败")
	}
	q resultCode_"^"_errMsg_"^"_qrCodeText_"^"_healthCardId_"^"_mainIndexId_"^"_name_"^"_gender_"^"_nation_"^"
		_birthday_"^"_idCard_"^"_cardType_"^"_address_"^"_phone
VerifyHealthCardQrcodeErrMag(ErrText="")
	if (ErrText="") s ErrText="操作失败"
	q resultCode_"^"_errMsg
	/*s Stream=##class(%GlobalCharacterStream).%New()
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt("1","resultCode")
    d Content.SetAt(ErrText,"errMsg")
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
    q Stream*/
}

Method ClasErrMsg(ErrText As %String)
{
	if (ErrText="") s ErrText="操作失败"
	s Stream=##class(%GlobalCharacterStream).%New()
	s Content=##class(%ArrayOfDataTypes).%New()
    d Content.SetAt("1","resultCode")
    d Content.SetAt(ErrText,"errMsg")
    s JsonStr=##class(web.INSUCacheJSON).Encode(Content)
    s JsonStr=$replace(JsonStr,"null","""""")
    d Stream.Write("{""head"":"_JsonStr_",""rsp"":{}}")
    q Stream
}

/// PatientID to RegNo
ClassMethod PatientIDToNo(PatientID As %String = "") As %String
{
	;w ##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo("6")
	
	;b ;PatientID1
	q:PatientID="" ""
	q $P($g(^PAPER(PatientID,"PAT",1)),"^",1)
}

/// 获取患者基本信息
/// input:PAPMIRowid:病人id
/// output: 姓名^性别^生日^证件号^证件类型^医保卡号^手机号^电话^居住地址^婚姻^民族^国籍^工作单位
ClassMethod GetPatInfoById(PAPMIRowid As %String)
{
	s (Name,Sex,Dob,DVAnumber,CreadType,InsuCode,PatTel,Mobile,Address,Marital,Nation,Country,Company)=""
    s Name=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",1)
    s Sex=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",7)
    s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
    s Sex=$case(Sex,"男":1,"女":2,:9)
    s Dob=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",6)
    s:Dob'="" Dob=$zd(Dob,3)
    s DVAnumber=$p($g(^PAPER(PAPMIRowid,"PAT",3)),"^",6)
    s CreadType=$p($g(^PAPER(PAPMIRowid,"PAT",3)),"^",7)
    s:CreadType'="" CreadType=$p($g(^PAC("CARD",CreadType)),"^",1)
    s CreadType=..GetRealationCode("CreadType","N",CreadType)
    s CreadType="01"
    s InsuCode=$p($g(^PAPER(PAPMIRowid,"PAT",3)),"^",12)
    s PatTel=$p($g(^PAPER(PAPMIRowid,"PER",1)),"^",11)
    s Mobile=$p($g(^PAPER(PAPMIRowid,"PER",4)),"^",21)
    s Address=$p($g(^PAPER(PAPMIRowid,"PER","ADD",1)),"^",1)
    s Marital=$p($g(^PAPER(PAPMIRowid,"PER",2)),"^",3)
    s:Marital'="" Marital=$p($g(^CT("MAR",Marital)),"^",1)
    i Marital'="" s Marital=..GetRealationCode("Marital","N",Marital)
    s Nation=$p($g(^PAPER(PAPMIRowid,"PER",2)),"^",1)
    s:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)
    i Nation'="" s Nation=..GetRealationCode("Nation","N",Nation)
    s Country=$p($g(^PAPER(PAPMIRowid,"PER",1)),"^",8)
    s:Country'="" Country=$p($g(^CT("COU",Country)),"^",2)
    i Country'="" s Country=..GetRealationCode("Country","N",Country)
    s Company=$p($g(^PAPER(PAPMIRowid,"PER",4)),"^",18)
    
    ;姓名^性别^生日^证件号^证件类型^医保卡号^手机号^电话^居住地址^婚姻^民族^国籍^工作单位
    ;1-10,11-13
    s ret=Name_"^"_Sex_"^"_Dob_"^"_DVAnumber_"^"_CreadType_"^"_InsuCode_"^"_PatTel_"^"_Mobile_"^"_Address_"^"_Marital
    s ret=ret_"^"_Nation_"^"_Country_"^"_Company
    q ret
}

/// 医生站对外预约字典(在字典类别和对外标记下，通过代码取相应代码)
/// input:TypeFlag:字典类别、HisFlag：(Y\N):外部到his、Code:代码
ClassMethod GetRealationCode(TypeFlag As %String, HisFlag As %String, Code As %String)
{
	q:(TypeFlag="")||(HisFlag="")||(Code) ""
    q:$d(^DHCDocTEXTDIC(0,"HisFlag",TypeFlag))=0 ""
    q:$d(^DHCDocTEXTDIC(0,"HisFlag",TypeFlag,HisFlag))=0 ""
    q:$d(^DHCDocTEXTDIC(0,"HisFlag",TypeFlag,HisFlag,Code))=0 ""
    s DiscCode="",rowid=""
    f  s rowid=$o(^DHCDocTEXTDIC(0,"HisFlag",TypeFlag,HisFlag,Code,rowid)) q:rowid=""  d
    .s Active=$p(^DHCDocTEXTDIC(rowid),"^",4)
    .q:Active'="Y"
    .s DiscCode=$p(^DHCDocTEXTDIC(rowid),"^",1)
    q DiscCode
}

ClassMethod UpdatePatInfo(PatDr As %String, healthCardNo As %String, healthCardId As %String, qrCodeText As %String)
{
	s CardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
	q:CardDr="" "1"
	s CardRefObj=##class(User.DHCCardRef).%OpenId(CardDr)
	ts
	if $ISOBJECT(CardRefObj){
		s CardRefObj.CFElecCardNo=healthCardNo
		s CardRefObj.CFElecPId=healthCardId
		s CardRefObj.CFElecStaticQrcodePhoto=qrCodeText
	}else{
		tro
		q "1"
	}
	s sc=CardRefObj.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		tro
		q "1"
	}
	tc
	q "0"
}

ClassMethod GetHealthInfoById(PatDr As %String)
{
	s RetStr=""
	s CardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
	q:CardDr="" RetStr
	s CardRefObj=##class(User.DHCCardRef).%OpenId(CardDr)
	if $ISOBJECT(CardRefObj){
		s RetStr=CardRefObj.CFElecPId
	}
	d CardRefObj.%Close()
	q RetStr
}

/// 根据证件号和姓名得到所有病人id
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatIDByIDCardAndName("370285199106144416","nk")
ClassMethod GetAllPatIDByIDCardAndName(IDCardNo As %String = "", PatientName As %String = "") As %String
{
	set PatientIDStr=""
	quit:IDCardNo="" PatientIDStr
	set PatientID=""
	
	Set IDCardNo=$ZCVT(IDCardNo,"U")
	Set RecordCount=0
	Set PatientId=0
	for  Set PatientId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PatientId)) Quit:PatientId=""  do
	.s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )  ;身份证 证件类型
	.if PAPMIDVAnumber=""  d
	..s myCredTypeDesc=""
	..s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
	..s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	..if myCredTypeDesc["身份证"  d
	..s PAPMIDVAnumber=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
	.Q:PAPMIDVAnumber'=IDCardNo
	.if PatientIDStr=""  s PatientIDStr=PatientId
	.else  s PatientIDStr=PatientIDStr_"^"_PatientId
 		
	//证件信息位数不足,可以用以下作为补充查询
	Set PatientId=0
	f  s PatientId=$O(^PAPERi("DVA",IDCardNo,PatientId)) q:PatientId=""  do
    .s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
    .Q:ActiveFlag="N"
    .set CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
    .Q:(PatientName'="")&&(CurName'=PatientName)
    .Q:("^"_PatientIDStr_"^")[("^"_PatientId_"^")
    .if PatientIDStr=""  s PatientIDStr=PatientId
	.else  s PatientIDStr=PatientIDStr_"^"_PatientId
 		
	quit PatientIDStr
}

}
