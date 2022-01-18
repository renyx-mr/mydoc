Class DHCDoc.Interface.HealthCard.Common Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(DHCDoc.Interface.HealthCard.Common).CheckCardNoQrcode("3C70A9ACBEDA504022FD4DC2C3972C3347929EC49C075516E5109269E727A48B:1::4500A0028APPA0003")
ClassMethod CheckCardNoQrcode(Qrcode As %String)
{
	;担心使用动态二维码  还是调用第三方接口判断
	//s CheckRet=##class(DHCDoc.YunHaiPower.HealthCard.Common).VerifyHealthCardQrcode(Qrcode,"000000")
	s CheckRet=..VerificationQrCode(Qrcode)
	q:+CheckRet'="0" "-202"
	s ElecPId=$p(CheckRet,"^",4)
	s CardNO="",securityno=""
	&sql(SELECT CF_CardNo,CF_SecurityNO 
		INTO :CardNO,securityno 
		FROM SQLUser.dhc_cardref
		WHERE CF_ElecPId=:ElecPId AND CF_ActiveFlag="N")
	s:securityno'="" securityno=##class(web.UDHCOPOtherLB).Decrypt(securityno)
	s CardInfo=##class(web.UDHCAccManageCLS).getaccinfofromcardno(CardNO,securityno)
	s RetStr=$p(CardInfo,"^",1)_"^"_CardNO_"^"_securityno_"^"_$p(CardInfo,"^",4)_"^"_$p(CardInfo,"^",8)
	s RetStr=RetStr_"^"_$p(CardInfo,"^",9)_"^"_$p(CardInfo,"^",11)_"^"_$p(CardInfo,"^",2)_"^"_$p(CardInfo,"^",13)_"^"_$p(CardInfo,"^",14)
	q RetStr
}

/// 根据登记号映射患者的电子健康卡
ClassMethod CreateHealthCard(PatNo As %String)
{
	s PatId=$o(^PAPERi("PAPMI_PatNo",PatNo,0))
	q:PatId="" "-101^未找到改患者的注册信息！"
	q ##class(DHCDoc.Interface.HealthCard.Interface).ReceiveHealthCard(PatId,"3")
}

/// 注册电子健康卡
/// w ##class(DHCDoc.Interface.HealthCard.Common).RegisterHealthCard("205930",461)
ClassMethod RegisterHealthCard(PatientId As %String, UserId As %String)
{
    q:'$d(^PAPER(PatientId)) "请先完成病人基本信息的登记再进行注册健康卡。"
    // 注册电子健康卡
    s RegisterHealthCardRet=##class(DHCDoc.Interface.HealthCard.Interface).RegisterHealthCard(PatientId)
    s RegisterHealthCardOutRet=##class(DHCDoc.Interface.HealthCard.Interface).RegisterHealthCardOut(RegisterHealthCardRet)
    
    if (+RegisterHealthCardOutRet'="0") q $p(RegisterHealthCardOutRet,"^",2)
    // 静态二维码申请  获取到静态的二维码 
    s ApplyQRcodeRet=##class(DHCDoc.Interface.HealthCard.Interface).ApplyQRcode(PatientId)
    s ApplyQRcodeOutRet=##class(DHCDoc.Interface.HealthCard.Interface).ApplyQRcodeOut(PatientId,ApplyQRcodeRet)
    if (+ApplyQRcodeOutRet'="0") q $p(ApplyQRcodeOutRet,"^",2)
    s StaticQrcode=$p(ApplyQRcodeOutRet,"^",3)
    s VerificationQrCodeRet=..VerificationQrCode(StaticQrcode)
    q:+VerificationQrCodeRet'=0 VerificationQrCodeRet
    b ;test 1
    ;CreateHealthCard(NewCardNo As %String = "", PatientID As %String = "", UserID As %String = "",HealthCardNo As %String = "", QRCode As %String = "")
    s CreateHealthCardRet=##class(DHCDoc.Interface.HealthCard.Interface).UpdatePatInfo(PatientId,"",$p(VerificationQrCodeRet,"^",4),StaticQrcode)
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
    b ;;;ret
    if ($p(VerificationQrCodeOutRet,"^",3)'="启用") q "-1^该健康卡未启用，不能进行使用。"
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
