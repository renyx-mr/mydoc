Class DHCDoc.Interface.HealthCard.Interface Extends (%RegisteredObject, %XML.Adaptor)
{
/// 接入机构编号，由平台在接入机构时分配 
Parameter InstitutionID = "12450521498818941H";
/// 注册终端编号，由接入平台分配 
Parameter TerminalID = "HPXHSZHYYZD";
/// 终端密码，由平台在接入注册终端时，通过给予 Dll 动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输
Parameter TerminalSecret = "APP01";
Parameter APPID="9m96Kh9X";
/// 卡类型 CardType
Parameter CardType="1";
/// 2.1	电子健康卡注册(优先完成)
ClassMethod RegisterHealthCard(PatientId As %String)
{
   q:'$d(^PAPER(PatientId)) ""
   s InPutObj=##class(%DynamicObject).%New()
   //"InstitutionID" 	"123" 	接入机构编号，由平台在接入机构时分配 
   d InPutObj.%Set("InstitutionID",..#InstitutionID)
 	//"TerminalID" 	"234" 	注册终端编号，由接入平台分配 
   d InPutObj.%Set("TerminalID",..#TerminalID)
 	//"Time" 	"20190329163207" 	注册时间，格式 yyyyMMddhhmmss 通过获取卫计委当前时间2.2接口获取 
   d InPutObj.%Set("Time",..GetDateTimeStr())
 	//"CertType" 	 "01" 	证件类型：01，代表身份证；更多请参考数据字典中的证件类型 
   s CardTypeDR=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
   s CertType=$p($g(^PAC("CARD",CardTypeDR)),"^",1)
   s:CertType="" CertType="99"
   d InPutObj.%Set("CertType",CertType)
 	//"CertID" 	"XXXXXX" 	证件号码 
   ;s CertID=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
 	d InPutObj.%Set("CertID",$p($g(^PAPER(PatientId,"PAT",3)),"^",6))
   //"Name" 	"郑金凤" 	用户姓名 
 	d InPutObj.%Set("Name","")
   //"TerminalSecret" 	"123abc" 	终端密码，由平台在接入注册终端时，通过给予 Dll 动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输 	 	 
 	d InPutObj.%Set("TerminalSecret",..#TerminalSecret)
   //"residentInfo" 	 	用户居民信息 
   s ResidentObj=##class(%DynamicObject).%New()
 	//{ 	 	 
 	//"Gender" 		"2" 	性别：1，男；2，女；更多请参考数据字典 
   s PatSexDR=$p($g(^PAPER(PatientId,"ALL")),"^",7)
   s Gender=$p(^CT("SEX",PatSexDR),"^",2)
   s Gender=$case(Gender,"男":"1","女":"2",:"9")
   d ResidentObj.%Set("Gender",Gender)
 	//"Nation" 		"汉族" 	民族//更多请参考数据字典(名族名称) 
   s NationDR=$p($g(^PAPER(PatientId,"PER",2)),"^",1)
   s Nation=""
   s:NationDR'="" Nation=$p($g(^CT("NAT",NationDR)),"^",2)
   d ResidentObj.%Set("Nation",Nation)
 	//"BirthDate" 		"1982.06.20" 	出生日期，格式yyyyMMdd 
   s BirthDate=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAPER(PatientId,"ALL")),"^",6))
   d ResidentObj.%Set("BirthDate",BirthDate)
 	//"Address" 		"南昌" 	地址
   s Address=$g(^PAPER(PatientId,"PER","ADD",1)) 
   d ResidentObj.%Set("Address",Address)
 	//"Phone" 		"XXXXX" 	手机号码 
   s Phone=$p($g(^PAPER(PatientId,"PER",1)),"^",11)
   d ResidentObj.%Set("Phone",Phone)
 	//} 
   d InPutObj.%Set("residentInfo",ResidentObj)		 	 
 	//"aPIVerify" 		 	API验证（对象） 
   s aPIVerifyJson=##class(web.DHCENS.STBLL.JKK.Method.JKKService).CreateSign()
   s aPIVerifyObj=##class(%DynamicObject).%FromJSON(aPIVerifyJson)
   d InPutObj.%Set("aPIVerify",aPIVerifyObj)	
 	//"MAC" 		"123"  	完整性校验信息，可空 
   d InPutObj.%Set("MAC","")
  s InPutJson=##class(DHCDoc.Util.FromJSON).GetJOSONByObj(InPutObj)
  q ##class(web.DHCENS.STBLL.JKK.Method.JKKService).JKKRegister("MES0002",InPutJson)
}
/// 电子健康卡注册(优先完成)  出参接口 
ClassMethod RegisterHealthCardOut(OutPutStr As %String)
{
   s OutPutObj=##class(%DynamicObject).%FromJSON(OutPutStr)
   ; "result" 	"0" 	详见错误返回列表 
   s Result=OutPutObj.%Get("result")
   ;"data" 	"注册成功!" 	返回数据的内容 
   s Date=OutPutObj.%Get("data")
   ;"message" 	"注册成功" 	申请结果描述 
   s Message=OutPutObj.%Get("message")
   ;"mac" 	"123" 	完整性校验信息，可空 
   s Mac=OutPutObj.%Get("mac")
   q Result_"^"_Message
}
/// 静态二维码申请(优先完成)（新增）  apply
ClassMethod ApplyQRcode(PatientId As %String)
{
   s InPutObj=##class(%DynamicObject).%New()
 	//"InstitutionID" 	"123" 	 接入机构编号 
   d InPutObj.%Set("InstitutionID",..#InstitutionID)
 	//"TerminalID" 	"234" 	注册终端编号 
   d InPutObj.%Set("TerminalID",..#InstitutionID)
 	//"Time" 	"20190329164234" 	识 读 时 间 格 式 yyyyMMddhhmmss, 通过获取卫计委当前时间2.2 接口获取
   d InPutObj.%Set("Time",..GetDateTimeStr()) 
 	//"CertType" 	"01" 	证件类型，01代表身份证，更多请参考数据字典中的证件类型 
   s CardTypeDR=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
   s CertType=$p($g(^PAC("CARD",CardTypeDR)),"^",1)
   s:CertType="" CertType="99"
   d InPutObj.%Set("CertType",CertType)
 	//"CertID" 	"XXXXXX" 	证件号码 
   d InPutObj.%Set("CertID",$p($g(^PAPER(PatientId,"PAT",3)),"^",6))
 	//"TerminalSecret" 	"123abc" 	终端密码，由平台在接入注册终端时，通过给予Dll动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输 
   d InPutObj.%Set("TerminalSecret",..#TerminalSecret)
 	//"FamilyName" 	"张三" 	家庭信息名称，如果为空则返回主二维码加家庭二维码，如果不为空则返回对应的单个二维码，家庭二维码集合为空 
   d InPutObj.%Set("FamilyName","")
 	//"aPIVerify" 	 	API验证(对象) 
   s aPIVerifyJson=##class(web.DHCENS.STBLL.JKK.Method.JKKService).CreateSign()
   s aPIVerifyObj=##class(%DynamicObject).%FromJSON(aPIVerifyJson)
   d InPutObj.%Set("aPIVerify",aPIVerifyObj)
 	//"MAC" 	"123" 	完整性校验信息，可空 
   d InPutObj.%Set("MAC","")
  s InPutJson=##class(DHCDoc.Util.FromJSON).GetJOSONByObj(InPutObj)
  q ##class(web.DHCENS.STBLL.JKK.Method.JKKService).JKKRegister("MES0003",InPutJson)
}
ClassMethod ApplyQRcodeOut(PatId As %String,OutPutStr As %String)
{
   s OutPutObj=##class(%DynamicObject).%FromJSON(OutPutStr)
   //"result" 	"0" 	详见错误返回列表 
   s Result=OutPutObj.%Get("result")
   //"message" 	"申请成功" 	申请结果描述 
   s Message=OutPutObj.%Get("message")
   if (Result'="0") q Result_"^"_Message
   //"data" 	 	返回参数对象 
   //"staticQrcode" 	"静态二维码值" 	电子健康卡静态二维码值 
   s StaticQrcode=OutPutObj.data.%Get("staticQrcode")
   //"name" 	"郑金凤" 	家庭监护人名称 
   s Name=OutPutObj.data.%Get("name")
   //"family" 	 	家庭成员（数量不能超过6个） 
   s Family=OutPutObj.data.%Get("family")
   //[{ 	 	 
   //"qrCode" 	"二维码值" 	电子健康卡静态二维码值 
   //"name" 	"陈向阳" 	家庭组成员名称 
   //}...]} 	 
   //"mac" 	"123" 	完整性校验信息，可空 
   s Mac=OutPutObj.data.%Get("mac")
   q Result_"^"_Message_"^"_StaticQrcode
}
/// 静态二维码验证(优先完成)（新增）
ClassMethod VerificationQrCode(QrCode As %String,ChannelCode As %String="" ,MedStepCode As %String = "")
{
   s InPutObj=##class(%DynamicObject).%New()
 	//"InstitutionID" 	"123" 	 接入机构编号 
   d InPutObj.%Set("InstitutionID",..#InstitutionID)
 	//"TerminalID" 	"234" 	注册终端编号 
   d InPutObj.%Set("TerminalID",..#InstitutionID)
 	//"Time" 	"20190329165022	识 读 时 间 ， 格 式" 	yyyyMMddhhmmss 通过获取卫计委当前时间2.2接口获取 
 	d InPutObj.%Set("Time",..GetDateTimeStr())
   //"Data" 	"二维码值" 	电子健康卡静态二维码值 
 	d InPutObj.%Set("Data",QrCode)
   //"ChannelCode" 	"01" 	刷卡终端类型（参考字典） 
   s:(ChannelCode="") ChannelCode="99"
 	d InPutObj.%Set("ChannelCode",ChannelCode)
   //"MedStepCode" 	"010101" 	诊疗环节代码（参考字典）
   s:MedStepCode="" MedStepCode="000000" 
 	d InPutObj.%Set("MedStepCode",MedStepCode)
   //"aPIVerify" 	 	API验证（对象）
   s aPIVerifyJson=##class(web.DHCENS.STBLL.JKK.Method.JKKService).CreateSign()
   s aPIVerifyObj=##class(%DynamicObject).%FromJSON(aPIVerifyJson)
   d InPutObj.%Set("aPIVerify",aPIVerifyObj)
 	// "MAC" 	"123" 	完整性校验信息，可空 新增参数(1.87版本添加) 	"OfficeCode " 	"A01" 	科室代码，详细见字典表  	 	 
   d InPutObj.%Set("MAC","")
  s InPutJson=##class(DHCDoc.Util.FromJSON).GetJOSONByObj(InPutObj)
  q ##class(web.DHCENS.STBLL.JKK.Method.JKKService).JKKRegister("MES0004",InPutJson)
}
ClassMethod VerificationQrCodeOut(OutPutStr As %String)
{
   s OutPutObj=##class(%DynamicObject).%FromJSON(OutPutStr)
   ;"result" 	"0" 	详见错误返回列表 
   s Result=OutPutObj.%Get("result")
   ;"message" 	"验证成功" 	验证结果描述 
   s Message=OutPutObj.%Get("message")
   if (Result'="0") q Result_"^"_Message
   ;"MAC":              	"" 	完整性校验信息，可空 
   s MAC=OutPutObj.%Get("MAC")
   ; "data" 	 	返回参数对象 
   ; { 	 	 
   ; "cardState" 	"启用" 	电子健康卡状态 
   s CardState=OutPutObj.data.%Get("cardState")
   ; "healthCardNo" 	"A8EB86D6289BAE955387C26411B85372A0D1B4CFFBC191EB16744771CFD56D93" 	电子健康卡ID值 
   s HealthCardNo=OutPutObj.data.%Get("healthCardNo")
   ; "poorModel" 	 	贫困对象 
   ; { 	 	 
   ; poorState 	"1" 	脱贫标志 
   s PoorState=OutPutObj.poorModel.%Get("poorState")
   ; ispoor 	True 	True为贫困人口，false为非贫困人口 
   s IsPoor=OutPutObj.poorModel.%Get("ispoor")
   ; } 	 	 
   ; "entityCardModel" 	 	证件对象 
   ; { 	 	 
   ; "cardType" 	"01" 	卡类型（详细见字典） 
   s CardType=OutPutObj.entityCardModel.%Get("cardType")
   s CardTypeDr=$o(^PAC("CARD",0,"Code",$$ALPHAUP^SSUTIL4(CardType),0))
   s:CardTypeDr="" CardTypeDr="27"
   ; "cardNumber" 	"XXXXXX" 	卡号码 
   s CardNumber=OutPutObj.entityCardModel.%Get("cardNumber")
   ; } 	 	 
   ; "residentInfoModel" 	 	居民信息（对象） 
   ; { 	 	 
   ; "name" 	"郑金凤" 	名称 
   s Name=OutPutObj.residentInfoModel.%Get("name")
   ; "gender" 	"女" 	性别（详见字典） 
   s Gender=OutPutObj.residentInfoModel.%Get("gender")
   s GenderDr=$case(Gender,"男":"1","女":"2",:"3")
   ; "nation" 	 "汉族" 	更多请参考数据字典(名族名称) 
   s Nation=OutPutObj.residentInfoModel.%Get("nation")
   s NationDr=$o(	^CT("NAT",0,"Desc",$$ALPHAUP^SSUTIL4(Nation),0))
   ; "birthDate" 	"1982/2/3 ; 0:00:00" 	出生日期 
   s BirthDate=OutPutObj.residentInfoModel.%Get("birthDate")
   s BirthDate=##class(websys.Conversions).DateLogicalToHtml(##class(websys.Conversions).DateHtmlToLogical(BirthDate))
   ; "address" 	"南昌" 	地址 
   s Address=OutPutObj.residentInfoModel.%Get("address")
   ; "phone" 	"12345678910" 	电话号码 
   s Phone=OutPutObj.residentInfoModel.%Get("phone")
   ; } 	 	 
   ; "custoryInfoModel" 	 	监护人对象 
   ; [{ 	 	 
   ; "custodyName" 	"郑金凤" 	监护人姓名 
   ; "cardNo" 	"XXXXXX" 	监护人身份证号码 
   ; " custodyPhone" 	"123456789" 	监护人电话号码 
   ; "cardType" 	"01" 	证件类型（01代表身份证，具体参照字典） 
   ; }...]} 
   // 返回状态，状态描述，健康卡状态，健康卡id，证件类型，证件号，姓名，性别id，民族id，出生日期，地址，手机号
   q Result_"^"_Message_"^"_CardState_"^"_HealthCardNo_"^"_CardTypeDr_"^"_CardNumber_"^"_Name_"^"_GenderDr_"^"_NationDr_"^"_BirthDate_"^"_Address_"^"_Phone
}
/// 2.4	2.4 动态二维码验证（新增贫困说明，标黄处）
ClassMethod VerifyQrCode(QrCode As %String)
{
   s InPutObj=##class(%DynamicObject).%New()
 	//"InstitutionID" 	"001" 	接入机构编号 
   d InPutObj.%Set("InstitutionID",..#InstitutionID)
 	//"TerminalID" 	"001" 	识读终端编号 
   d InPutObj.%Set("TerminalID",..#TerminalID)
 	//"Time" 	"20180613160707" 	识读时间，格式 yyyyMMddhhmmss 通过获取卫计委当前时间2.2接口获取
   d InPutObj.%Set("Time",..GetDateTimeStr())
 	//"Data" 	"动态二维码" 	电子健康卡动态二维码值 
   d InPutObj.%Set("Data","")
 	//"ChannelCode" 	"02" 	刷卡终端类型（见字典） 
   d InPutObj.%Set("ChannelCode","")
 	//"MedStepCode" 	"010101" 	诊疗环节代码(见字典) 	新增参数 	"OfficeCode " 	"0300" 	科室代码，详细见字典表 	 
   d InPutObj.%Set("MedStepCode","")
 	//"APIVerify" 	 	API验证（对象）
   s aPIVerifyJson=##class(web.DHCENS.STBLL.JKK.Method.JKKService).CreateSign()
   s aPIVerifyObj=##class(%DynamicObject).%FromJSON(aPIVerifyJson)
   d InPutObj.%Set("aPIVerify",aPIVerifyObj)
 	//"MAC" 	 "123abc" 	完整性校验信息，可空 	
   d InPutObj.%Set("MAC","")
  s InPutJson=##class(DHCDoc.Util.FromJSON).GetJOSONByObj(InPutObj)
  q ##class(web.DHCENS.STBLL.JKK.Method.JKKService).JKKRegister("MES0004",InPutJson)
}
ClassMethod VerifyQrCodeOut(OutPutStr As %String)
{
   s OutPutObj=##class(%DynamicObject).%FromJSON(OutPutStr)
   ;"result" 	"0" 	详见错误返回列表 
   s Result=OutPutObj.%Get("result")
   ;"message" 	"验证成功" 	验证结果描述 
   s Message=OutPutObj.%Get("message")
   if (Result'="0") q Result_"^"_Message
   ;"mac" 	"123abc" 	完整性校验信息，可空
   s Mac=OutPutObj.%Get("mac")
   ;"data" 	 	返回参数对象 
   ;{ 	 	 
   ;"healthCardNo" 	"7509D26B27514DDD0A308553D049AFA6481C68E4"  	电子健康卡ID值 
   s HealthCardNo=OutPutObj.data.%Get("healthCardNo")
   ;"poorModel" 	 	贫困对象
   ;{ 
 	;poorState "1" 脱贫标志
   s PoorState=OutPutObj.poorModel.%Get("poorState")
   ;ispoor True True 为贫困人口，false		为非贫困人口 
   s Ispoor=OutPutObj.poorModel.%Get("ispoor")
   ;} 
 	 
   ;"entityCardModel" 	 	实体卡对象 
   ;{ 	 	 
   ;"cardType" 	"01" 	卡类型（详见字典） 
   s CardType=OutPutObj.entityCardModel.%Get("cardType")
   ;"cardNumber" 	"360104199203041915" 	卡号码 
   s CardNumber=OutPutObj.entityCardModel.%Get("cardNumber")
   ;} 	 	 
   ;"residentInfoModel" 	 	居民信息（对象） 
   ;{ 	 	 
   ;"name" 	"高远" 	姓名 
   s Name=OutPutObj.residentInfoModel.%Get("name")
   ;"gender" 	"男性" 	性别（见字典） 
   s Gender=OutPutObj.residentInfoModel.%Get("gender")
   ; "nation" 	"汉族" 	更多请参考数据字典(名族名称) 
   s Nation=OutPutObj.residentInfoModel.%Get("nation")
   ; "birthDate"   	"2018/02/03" 	出生日期 
   s BirthDate=OutPutObj.residentInfoModel.%Get("birthDate")
   ; "address" 	"南昌" 	地址 
   s Address=OutPutObj.residentInfoModel.%Get("address")
   ;} 	 	 
   ;"custoryInfoModel" 	 	监护人对象 
   s CustoryInfoModel=OutPutObj.%Get("custoryInfoModel")
   ;[{
   ;"custodyName" 	"王二" 	监护人姓名 
   ;"cardNo" 	"3601041992030419
   ;15" 	 监护人身份证号 
   ;" custodyPhone":  	"13751154190" 	监护人电话 
   ;"cardType" 	"01" 	证件类型（01 代表身份证，具体参照字典表） 
   ;}...]} 	 	
}
/// / 有患者ID自动插卡号
ClassMethod CreateHealthCard(NewCardNo As %String = "", PatientID As %String = "", UserID As %String = "",HealthCardNo As %String = "", QRCode As %String = "") As %String
{
	Q:NewCardNo="" ""
	Q:PatientID="" ""
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	s CardType=+(..ReadCardTypeByDesc())
	s myCardRowID=""
	s myNormalFlag=0
	s CardRowID=""
	s myrtn=""
	for {
		s myCardRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO", CardType,PatientID, myCardRowID))  
		q:(myCardRowID="")
		s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
		continue:(myAFlag'="N")		;如果此登记号有
		s myNormalFlag=1
		s CardRowID=myCardRowID
	}
	if (myNormalFlag="0"){
		s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
		s myCardObj.CardNo=NewCardNo
		s myCardObj.CardTypeDefine=CardType
		s myCardObj.PAPMIRowID=PatientID
		s myCardObj.CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6) 
		s myCardObj.UserDR=UserID
		s myCardObj.CFDate=+$h
		s myCardObj.CFTime=$P($H,",",2)
		s myCardObj.PAPMINo=$P($G(^PAPER(PatientID,"PAT",1)),"^",1)
		s myCardObj.ActiveFlag="N"
    ; 添加电子健康卡信息 
    s myCardObj.ElecCardNo=NewCardNo
    s myCardObj.ElecPId=HealthCardNo
    s myCardObj.ElecStaticQrcodePhoto=QRCode
    s myCardObj.ElecActive="Y"
    s myCardObj.ElecRegistTime=$zdt($h,3)
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
		b ;0932323
		s myCardRowID=$p(myrtn, "^", 2)
		s myrtn=+myrtn
	}else{
		s CardNo=$P(^DHCCARD("CF",CardRowID),"^",2)
		if (CardNo'=NewCardNo){
			Set cf = ##class(User.DHCCardRef).%OpenId(CardRowID)
			Set cf.CFCardNo = NewCardNo
      ; 添加电子健康卡信息 
      s myCardObj.ElecCardNo=NewCardNo
      s myCardObj.ElecPId=HealthCardNo
      s myCardObj.ElecStaticQrcodePhoto=QRCode
      s myCardObj.ElecActive="Y"
      s myCardObj.ElecRegistTime=$zdt($h,3)
			Set sc = cf.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-200"	;卡信息保存失败
			}
		}
	}
		
	Q myrtn
}
/// 获取就诊卡为健康卡的卡类型id
ClassMethod ReadCardTypeByDesc()
{
	//s DZJJKCardTypeID=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ReadCardTypeByDesc()
	s myTypeID=0 s myval="" 
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:((myTypeID="")||(myval'=""))  d
	.//q:myTypeID'=DZJJKCardTypeID
	.s CardTypeDesc=$p($g(^DHCCARDTYPEDef(myTypeID)),"^",2)
	.q:CardTypeDesc'["健康卡"
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	q myval
}
ClassMethod GetDateTimeStr()
{
   s DateTimeStr=$zdt($h,3)
   s DateTimeStr=$replace(DateTimeStr,"-","")
   s DateTimeStr=$replace(DateTimeStr,":","")
   s DateTimeStr=$replace(DateTimeStr," ","")
   q DateTimeStr
}
}