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
}
///  静态二维码验证  
ClassMethod VerificationQrCode(Qrcod As %String)
{
    s VerificationQrCodeRet=##class(DHCDoc.Interface.HealthCard.Interface).VerificationQrCode(StaticQrcode)
    s VerificationQrCodeOutRet=##class(DHCDoc.Interface.HealthCard.Interface).VerificationQrCodeOut(VerificationQrCodeRet)
    if (+VerificationQrCodeOutRet'="0") q $p(VerificationQrCodeOutRet,"^",2)
    if ($p(VerificationQrCodeOutRet,"^",2)'="启用") q "该健康卡未启用，不能进行使用。"
    q VerificationQrCodeOutRet
}
}