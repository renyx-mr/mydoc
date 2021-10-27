Class DHCDoc.YunHaiPower.HealthCard.Interface Extends %RegisteredObject
{
	
/// w ##class(DHCDoc.YunHaiPower.HealthCard.Interface).CheckCardNoQrcode("2F7B548CDE10C37FFD2CDD8E452A7DAE9E1E5D2AF0CBA006FC25AB75CC465C89:1::4500A0028APPB0017")
ClassMethod CheckCardNoQrcode(Qrcode As %String)
{
	;担心使用动态二维码  还是调用第三方接口判断
	s CheckRet=##class(DHCDoc.YunHaiPower.HealthCard.Common).VerifyHealthCardQrcode(Qrcode,"000000")
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
classmethod CreateHealthCard(PatNo As %String)
{
	s PatId=$o(^PAPERi("PAPMI_PatNo",PatNo,0))
	q:PatId="" "-101^未找到改患者的注册信息！"
	q ##class(DHCDoc.YunHaiPower.HealthCard.Common).ReceiveHealthCard(PatId,"3")
}

}
