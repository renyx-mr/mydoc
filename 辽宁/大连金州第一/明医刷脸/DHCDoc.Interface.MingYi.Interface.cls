Class DHCDoc.Interface.MingYi.Interface Extends %RegisteredObject
{

Parameter DeviceId = "123asd";

/// w ##class(DHCDoc.Interface.MingYi.Interface).MyDoctorInfo("12","123")
ClassMethod MyDoctorInfo(LocId As %String, UserId As %String)
{
	s InputObj=##class(%DynamicObject).%New()
	;终端 ID MINGYI_DEVICEID String 否 由工作站获取本机操作系统环境变量MINGYI_DEVICEID 的值13
	d InputObj.%Set("MINGYI_DEVICEID",..#DeviceId)
	;科室名称 Visidemt String 否
	Set DeptName=$p($g(^CTLOC(LocId)),"^",2)
	d InputObj.%Set("Visidemt",DeptName)
	Set DeptCode=$p($g(^CTLOC(LocId)),"^",2)
	;医生名称 Name String 否
	s DoctorDR=$P($g(^SSU("SSUSR",UserId)),"^",14)
	s DocName=$P($g(^SSU("SSUSR",UserId)),"^",2) //$p($g(^CTPCP(DoctorDR,1)),"^",2)
	d InputObj.%Set("Name",DocName)
	;医生工号 Number String 否
	s DocCode=$P($g(^SSU("SSUSR",UserId)),"^",1) //$p($g(^CTPCP(DoctorDR,1)),"^",1)
	d InputObj.%Set("Number",DocCode)
	;医生职称 Title String 否
	s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
	s InternalType=""
	s:CareProvTypeDR'="" InternalType=$p($g(^CT("CPT",CareProvTypeDR)),"^",4)
	d InputObj.%Set("Title",InternalType)
	;医生简介 DocProfile String 否
	s DocProfile=""
	d InputObj.%Set("DocProfile",DocProfile)
	;医生照片 DocPhotos String 否 医生照片的
	s DocPhotos=""
	d InputObj.%Set("DocPhotos",DocPhotos)
	s InoutJson=InputObj.%ToJSON()
	q InoutJson
}

/// 读卡扫码接口
ClassMethod MyReadCard(CardType As %String)
{
	s InputObj=##class(%DynamicObject).%New()
	;终端 ID MINGYI_DEVICEID String 否 由工作站获取本机操作系统环境变量MINGYI_DEVICEID 的值13
	d InputObj.%Set("MINGYI_DEVICEID",..#DeviceId)
	;读卡类型 READ_TYPE String 否 IDCARD/身份证MAGCARD/磁条卡MEDCARD/社保卡QRCODE/二维码调用时传入一个或多个卡类型，英文逗号分隔
	s ReadTyp=""
	d InputObj.%Set("READ_TYPE",ReadTyp)
	s InoutJson=InputObj.%ToJSON()
	q InoutJson
}

/// 读卡扫码返回数据处理
/// w ##class(DHCDoc.Interface.MingYi.Interface).ReadCardRet("{ ""Code"": ""1"", ""Msg"": ""Success"", ""Data"": [{ ""type"": ""IDCARD"",""Content"": { ""Name"": ""姓名"", ""Number"": ""身份证号"", ""Address"": ""居住地址"", ""Sex"": ""性别"", ""Indate"": ""有效期"", ""Image"": ""照片的 BASE64""}}, { ""type"": ""MAGCARD"", ""Content"": { ""Number"": ""就诊卡号""}}, { ""type"": ""MEDCARD"", ""Content"": { ""Number"": ""社保账号"", ""CardNo"": ""社保卡号"", ""Name"": ""姓名"", ""Image"": ""照片的 BASE64"", ""IssueDate"": ""发卡日期""}}, { ""type"": ""QRCODE"", ""Content"": {""Code"":""二维码字符串""}}]}")
/// w ##class(DHCDoc.Interface.MingYi.Interface).ReadCardRet("{ ""Code"": ""1"", ""Msg"": ""Success"", ""Data"": [{ ""type"": ""IDCARD"",""Content"": { ""Name"": ""姓名"", ""Number"": ""身份证号"", ""Address"": ""居住地址"", ""Sex"": ""性别"", ""Indate"": ""有效期"", ""Image"": ""照片的 BASE64""}}]}")
ClassMethod ReadCardRet(RetJson As %String)
{
	s RetStr=""
	s RetObj=##class(%DynamicObject).%FromJSON(RetJson)
	s Code=RetObj.%Get("Code") ;, "Msg": "Success",
	s Msg=RetObj.%Get("Msg")
	q:Code'="1" RetStr
	s RetDataCount=RetObj.Data.%Size()-1
	s CardInfoObj=##class(%DynamicObject).%New()
	s CredCardInfo="",MagCardInfo="",InsuCardInfo="",QrCode=""
	for DataInd=0:1:RetDataCount{
		s OneData=RetObj.Data.%Get(DataInd)
		; IDCARD /身份证
		; MAGCARD /磁条卡
		; MEDCARD /社保卡
		; QRCODE /二维码
		s Type=OneData.%Get("type")
		s CardInfoObj=OneData.%Get("Content")
		if (Type="IDCARD"){
			// "Name"": ""姓名"", ""Number"": ""身份证号"", ""Address"": ""居住地址"", ""Sex"": ""          性别"", ""Indate"": ""有效期"", ""Image"": ""照片的 BASE64""
			s CredCardObj=##class(%DynamicObject).%New()
			s CredCardObj.Name=CardInfoObj.%Get("Name")
			s CredCardObj.CredNo=CardInfoObj.%Get("Number")
			s CredCardObj.CardNo=CardInfoObj.%Get("Number")
			s CredCardObj.Address=CardInfoObj.%Get("Address")
			s CredCardObj.Birth=..GetBirthByIDNo(CredCardObj.CredNo)
			s CredCardObj.Age=..GetAgeByBirth(CredCardObj.Birth)
			s ImageBase64=CardInfoObj.%Get("Image")
			s RetStr=##class(DHCDoc.Util.XMLParse).ObjToXML(CredCardObj,"IDRoot","").Read()
		}elseif (Type="MAGCARD"){
			s RetStr=CardInfoObj.%Get("Number")
		}elseif (Type="MEDCARD"){
			; {"Number":"社保账号","CardNo":"社保卡号","Name":"姓名","Image":"照片的 BASE64","             IssueDate":"发卡日期","type":"MEDCARD"}
			s InsuCardObj=##class(%DynamicObject).%New()
			s InsuCardObj.Name=CardInfoObj.%Get("Name")
			s InsuCardObj.CredNo=CardInfoObj.%Get("Number")
			s InsuCardObj.CardNo=CardInfoObj.%Get("Number")
			//s InsuCardObj.Address=CardInfoObj.%Get("Address")
			s InsuCardObj.Birth=..GetBirthByIDNo(CredCardObj.CredNo)
			s InsuCardObj.Age=..GetAgeByBirth(CredCardObj.Birth)
			s ImageBase64=CardInfoObj.%Get("Image")
			s RetStr=##class(DHCDoc.Util.XMLParse).ObjToXML(InsuCardObj,"IDRoot","").Read()
		}elseif (Type="QRCODE"){
			s RetStr=CardInfoObj.%Get("Code")
		}
	}
	// CardInfoObj.%ToJSON(),!
	q RetStr
}

/// 人脸信息核验
/// 口地址：http://{server}:{port}/api/his/MyRealTreatment? MINGYI_DEVICEID=
ClassMethod MyRealTreatment(PatientId As %String)
{
	s InputObj=##class(%DynamicObject).%New()
	// "Name": "姓名", "Phone": "手机号", "Idno": "身份证", "Address": "地址", "YBCard": "医保卡号"
	s Name=$p($g(^PAPER(PatientId,"ALL")),"^",1)
	d InputObj.%Set("Name",Name)
	s Mobile=$p($g(^PAPER(PatientId,"PER",4)),"^",21)
	d InputObj.%Set("Phone",Mobile)
	s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )
	d InputObj.%Set("Idno",PAPMIDVAnumber)
	s Address=$p($g(^PAPER(PatientId,"PER","ADD",1)),"^",1)
	d InputObj.%Set("Address",Address)
	s InsuCardNo=""
	d InputObj.%Set("YBCard","")
	s InoutJson=InputObj.%ToJSON()
	q InoutJson
}

/// 人脸信息核验返回数据处理
/// w ##class(DHCDoc.Interface.MingYi.Interface).RealTreatmentRet("{""Code"":""1"",""Msg"":""验证通过"",""Data"":{""Name"":""姓名"",""Phone"":""手机号"",""Idno"":""身份证"",""Address"":""地址""}}")
ClassMethod RealTreatmentRet(RetJson As %String)
{
	s RetStr=""
	s RetObj=##class(%DynamicObject).%FromJSON(RetJson)
	s Code=RetObj.%Get("Code") ;, "Msg": "Success",
	s Msg=RetObj.%Get("Msg")
	q:Code'="1" Msg
	if $IsObject(RetObj.Data){
		s Name=RetObj.Data.%Get("Name")
		s Phone=RetObj.Data.%Get("Phone")
		s Idno=RetObj.Data.%Get("Idno")
		s Address=RetObj.Data.%Get("Address")
		b ;;;23
	}
	q RetStr
}

/// w ##class(DHCDoc.Interface.MingYi.Interface).GetBirthByIDNo("610502199507208025")
ClassMethod GetBirthByIDNo(IDNo As %String)
{
	s Birth=""
	q:IDNo="" Birth
	s:$l(IDNo)="18" Birth=$e(IDNo,7,10)_"-"_$e(IDNo,11,12)_"-"_$e(IDNo,13,14)
	s:$l(IDNo)="15" Birth="19"_$e(IDNo,7,8)_"-"_$e(IDNo,11,12)_"-"_$e(IDNo,13,14)
	q Birth
}

/// w ##class(DHCDoc.Interface.MingYi.Interface).GetAgeByBirth("1996-09-09")
ClassMethod GetAgeByBirth(Birth As %String)
{
	s Age=""
	q:Birth="" Age
	s OneDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s Age=+OneDate-+Birth
	q Age
}

}
