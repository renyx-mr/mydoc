Class DHCDoc.Interface.HealthCard.Common Extends (%RegisteredObject, %XML.Adaptor)
{
///注册电子健康卡
ClassMethod RegisterHealthCard(PatientId As %String,UserId As %String)
{
    q:'$d(^PAPER(PatientId)) "请先完成病人基本信息的登记再进行注册健康卡。"
    // 注册电子健康卡
    s RegisterHealthCardRet=##class(DHCDoc.Interface.HealthCard.Interface).RegisterHealthCard(PatientId)
    s RegisterHealthCardOutRet=##class(DHCDoc.Interface.HealthCard.Interface).RegisterHealthCardOut(RegisterHealthCardRet)
    if (+RegisterHealthCardOutRet'="0") q $p(RegisterHealthCardOutRet,"^",2)
    // 静态二维码申请  获取到静态的二维码 
    s ApplyQRcodeRet=##class(DHCDoc.Interface.HealthCard.Interface).ApplyQRcode(PatientId)
    s ApplyQRcodeOutRet=##class(DHCDoc.Interface.HealthCard.Interface).ApplyQRcodeOut(ApplyQRcodeRet)
    if (+ApplyQRcodeOutRet'="0") q $p(ApplyQRcodeOutRet,"^",2)
    s StaticQrcode=$p(ApplyQRcodeOutRet,"^",3)
    s VerificationQrCodeRet=..VerificationQrCode(StaticQrcode)
    q:+VerificationQrCodeRet'=0 VerificationQrCodeRet
    ;CreateHealthCard(NewCardNo As %String = "", PatientID As %String = "", UserID As %String = "",HealthCardNo As %String = "", QRCode As %String = "")
    s CreateHealthCardRet=##class(DHCDoc.Interface.HealthCard.Interface).CreateHealthCard($p(VerificationQrCodeRet,"^",4),PatientId,UserId,$p(VerificationQrCodeRet,"^",4),StaticQrcode)
    if (CreateHealthCardRet<0){
        q "-1^注册电子健康卡失败"
    }
    q CreateHealthCardRet
}
///  静态二维码验证  
ClassMethod VerificationQrCode(Qrcod As %String)
{
    s VerificationQrCodeRet=##class(DHCDoc.Interface.HealthCard.Interface).VerificationQrCode(Qrcod)
    s VerificationQrCodeOutRet=##class(DHCDoc.Interface.HealthCard.Interface).VerificationQrCodeOut(VerificationQrCodeRet)
    if (+VerificationQrCodeOutRet'="0") q "-1^"_$p(VerificationQrCodeOutRet,"^",2)
    if ($p(VerificationQrCodeOutRet,"^",2)'="启用") q "-1^该健康卡未启用，不能进行使用。"
    q VerificationQrCodeOutRet
}
/// 根据二维码进行读卡
ClassMethod GetPatCardNoByQrCode(Qrcod As %String)
{
    s VerificationQrCodeRet=..VerificationQrCode(Qrcod)
    q:+VerificationQrCodeRet'=0 VerificationQrCodeRet
    q $p(VerificationQrCodeRet,"^",1)_"^"_$p(VerificationQrCodeRet,"^",4)_"^"
}
/// 根据二维码获取病人信息
ClassMethod GetPatQrCodeInfo(Qrcod As %String)
{
    s VerificationQrCodeRet=..VerificationQrCode(Qrcod)
    q:+VerificationQrCodeRet'=0 VerificationQrCodeRet
    s myXMLData="<CredNo>"_$p(VerificationQrCodeRet,"^",6)_"</CredNo>"
    s myXMLData=myXMLData_"<Name>"_$p(VerificationQrCodeRet,"^",7)_"</Name>"
    s myXMLData=myXMLData_"<Sex>"_$p(VerificationQrCodeRet,"^",8)_"</Sex>"
    s myXMLData=myXMLData_"<Birth>"_$p(VerificationQrCodeRet,"^",10)_"</Birth>"
    s myXMLData=myXMLData_"<Nation>"_$p(VerificationQrCodeRet,"^",9)_"</Nation>"
    s myXMLData=myXMLData_"<TelHome>"_$p(VerificationQrCodeRet,"^",12)_"</TelHome>"
    s myXMLData=myXMLData_"<Address>"_$p(VerificationQrCodeRet,"^",11)_"</Address>"
    s myXMLData = "<gRoot>" _ myXMLData _ "</gRoot>"
	q $p(VerificationQrCodeRet,"^",1)_"^"_$p(VerificationQrCodeRet,"^",4)_"^"_myXMLData
}
}