Class DHCDoc.Interface.HealthCard.Common Extends (%RegisteredObject, %XML.Adaptor)
{
/// 接入机构编号，由平台在接入机构时分配 
Parameter InstitutionID = "APP01";
/// 注册终端编号，由接入平台分配 
Parameter TerminalID = "APP01";
/// 终端密码，由平台在接入注册终端时，通过给予 Dll 动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输
Parameter TerminalSecret = "APP01";
/// 2.1	电子健康卡注册(优先完成)
ClassMethod RegisterHealthCard(PatId As %String)
{
    q:'$d(^PAPER(PatId)) ""
    s OutPutObj=##class(%DynamicObject).%New()
    ;"InstitutionID" 	"123" 	接入机构编号，由平台在接入机构时分配 
    d OutPutObj.%Set("InstitutionID",..#InstitutionID)
 	;"TerminalID" 	"234" 	注册终端编号，由接入平台分配 
    d OutPutObj.%Set("TerminalID",..#TerminalID)
 	;"Time" 	"20190329163207" 	注册时间，格式 yyyyMMddhhmmss 通过获取卫计委当前时间2.2接口获取 
    d OutPutObj.%Set("Time","")
 	;"CertType" 	 "01" 	证件类型：01，代表身份证；更多请参考数据字典中的证件类型 
    d OutPutObj.%Set("CertType","")
 	;"CertID" 	"XXXXXX" 	证件号码 
 	d OutPutObj.%Set("CertID","")
    ;"Name" 	"郑金凤" 	用户姓名 
 	d OutPutObj.%Set("Name","")
    ;"TerminalSecret" 	"123abc" 	终端密码，由平台在接入注册终端时，通过给予 Dll 动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输 	 	 
 	d OutPutObj.%Set("TerminalSecret",..#TerminalSecret)
    ;"residentInfo" 	 	用户居民信息 
    s ResidentObj=##class(%DynamicObject).%New()
 	;{ 	 	 
 	;"Gender" 		"2" 	性别：1，男；2，女；更多请参考数据字典 
    d ResidentObj.%Set("Gender","")
 	;"Nation" 		"汉族" 	民族;更多请参考数据字典(名族名称) 
    d ResidentObj.%Set("Nation","")
 	;"BirthDate" 		"1982.06.20" 	出生日期，格式yyyyMMdd 
    d ResidentObj.%Set("BirthDate","")
 	;"Address" 		"南昌" 	地址 
    d ResidentObj.%Set("Address","")
 	;"Phone" 		"XXXXX" 	手机号码 
    d ResidentObj.%Set("Phone","")
 	;} 		 	 
 	;"aPIVerify" 		 	API验证（对象） 
    s aPIVerifyObj=##class(%DynamicObject).%New()
 	;"Appid" 		"11" 	授权编码 
    d ResidentObj.%Set("Appid","")
 	;" Nonce_Str" 		"ceshi" 	随机字符串（8位以下，没有其他要求） 
    d ResidentObj.%Set("Nonce_Str","")
 	;"Sign" 		"dsahdi" 	签名值(见附录2) 
    d ResidentObj.%Set("Sign","")
 	;"Time" 		"332132132  1321321321" 	时间戳 格式:yyyyMMssHHmmss 格式yyyyMMddhhmmss 通过获取卫计委当前时间2.2接口获取 
    d ResidentObj.%Set("Time","")
 	;"MAC" 		"123"  	完整性校验信息，可空 
    d OutPutObj.%Set("MAC","")

}
/// 静态二维码申请(优先完成)（新增）  apply
ClassMethod ApplyQRcode(PatId As %String)
{
    s OutPutObj=##class(%DynamicObject).%New()
 	;"InstitutionID" 	"123" 	 接入机构编号 
    d OutPutObj.%Set("InstitutionID",..#InstitutionID)
 	;"TerminalID" 	"234" 	注册终端编号 
    d OutPutObj.%Set("TerminalID",..#InstitutionID)
 	;"Time" 	"20190329164234" 	识 读 时 间 格 式 yyyyMMddhhmmss, 通过获取卫计委当前时间2.2 接口获取
    d OutPutObj.%Set("Time","") 
 	;"CertType" 	"01" 	证件类型，01代表身份证，更多请参考数据字典中的证件类型 
    d OutPutObj.%Set("CertType","")
 	;"CertID" 	"XXXXXX" 	证件号码 
    d OutPutObj.%Set("CertID","")
 	;"TerminalSecret" 	"123abc" 	终端密码，由平台在接入注册终端时，通过给予Dll动态库 EhcInterface.dll（参考动态库说明文档），由dll自动获取硬件信息，获取反馈字符串（密码）并以此参数进行传输 
    d OutPutObj.%Set("TerminalSecret",..#TerminalSecret)
 	;"FamilyName" 	"张三" 	家庭信息名称，如果为空则返回主二维码加家庭二维码，如果不为空则返回对应的单个二维码，家庭二维码集合为空 
    d OutPutObj.%Set("FamilyName","")
 	;"aPIVerify" 	 	API验证(对象) 
    s aPIVerifyObj=##class(%DynamicObject).%New()
 	;"Appid" 	"11" 	授权编码 
    d aPIVerifyObj.%Set("Appid","")
 	;"Nonce_Str" 	"ceshi" 	随机字符串（8位以下，无其他要求） 
    d aPIVerifyObj.%Set("Nonce_Str","")
 	;"Sign" 	"dsahd" 	签名值(见附录2) 
    d aPIVerifyObj.%Set("Sign","")
 	;"Time" 	"201903029164302" 	时间戳格式:yyyyMMssHHmmss 通过获取卫计委当前时间2.2 接口获取 
    d aPIVerifyObj.%Set("Time","")
 	;"MAC" 	"123" 	完整性校验信息，可空 
    d OutPutObj.%Set("MAC","")

}
/// 静态二维码验证(优先完成)（新增）
ClassMethod VerificationQrCode(PatId As %String)
{
    s OutPutObj=##class(%DynamicObject).%New()
 	;"InstitutionID" 	"123" 	 接入机构编号 
    d OutPutObj.%Set("InstitutionID",..#InstitutionID)
 	;"TerminalID" 	"234" 	注册终端编号 
    d OutPutObj.%Set("TerminalID",..#InstitutionID)
}
}