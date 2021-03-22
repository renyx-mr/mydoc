/// 名称:    DHCDoc.GetInfo.Method.Card
/// 描述:    卡管理相关信息获取公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
/// 继承: 
Class DHCDoc.GetInfo.Method.Card Extends %RegisteredObject
{

/// 描述:    分诊相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.25
/// w ##class(DHCDoc.GetInfo.Method.Card).GetCardInfo()
ClassMethod GetCardInfo(CFRowID As %String) As DHCDoc.GetInfo.Entry.DHCCardRef
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.DHCCardRef).%New()
	s CardObj=##class(User.DHCCardRef).%OpenId(CFRowID)
	if $ISOBJECT(CardObj) {
		s OutputObj.CFRowID=CFRowID
		s OutputObj.CFAccNoDR=CardObj.CFAccNoDR
		if $ISOBJECT(OutputObj.CFAccNoDR) {
			s OutputObj.CFAccNoDR=CardObj.CFAccNoDR.%Id()
		}
		s OutputObj.CFCardNo=CardObj.CFCardNo
		s OutputObj.CFSecurityNO=CardObj.CFSecurityNO
		s OutputObj.CFPAPMIDR=CardObj.CFPAPMIDR
		s OutputObj.CFIDCardNo=CardObj.CFIDCardNo
		s OutputObj.CFPAPMINo=CardObj.CFPAPMINo
		s OutputObj.CFDate=CardObj.CFDate
		s OutputObj.CFTime=CardObj.CFTime
		s OutputObj.CFUserDR=CardObj.CFUserDR
		s UserObj=##class(User.SSUser).%OpenId(OutputObj.CFUserDR)
		if $ISOBJECT(UserObj) {
			s OutputObj.CFUserCode=UserObj.SSUSRInitials
			s OutputObj.CFUserDesc=UserObj.SSUSRName
			do UserObj.%Close()
		}
		s OutputObj.CFActiveFlag=CardObj.CFActiveFlag
		s OutputObj.CFDateFrom=CardObj.CFDateFrom
		s OutputObj.CFDateTo=CardObj.CFDateTo
		s OutputObj.CFCancleDate=CardObj.CFCancleDate
		s OutputObj.CFCancleTime=CardObj.CFCancleTime
		s OutputObj.CFCancleUserDR=CardObj.CFCancleUserDR
		s UserObj=##class(User.SSUser).%OpenId(OutputObj.CFCancleUserDR)
		if $ISOBJECT(UserObj) {
			s OutputObj.CFCancleUserCode=UserObj.SSUSRInitials
			s OutputObj.CFCancleUserDesc=UserObj.SSUSRName
			do UserObj.%Close()
		}
		s OutputObj.CFCardTypeDR=CardObj.CFCardTypeDR
        if $ISOBJECT(OutputObj.CFCardTypeDR) {
	        s OutputObj.CFCardTypeDR=CardObj.CFCardTypeDR.%Id()
	        s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(OutputObj.CFCardTypeDR)
			if $ISOBJECT(CardTypeObj) {
				s OutputObj.CFCardTypeCode=CardTypeObj.CTDCode
				s OutputObj.CFCardTypeDesc=CardTypeObj.CTDDesc
				do CardTypeObj.%Close()
			}
	    }
	    s OutputObj.CFCardINVPRTDR=CardObj.CFCardINVPRTDR
        if $ISOBJECT(OutputObj.CFCardINVPRTDR) {
	        s OutputObj.CFCardINVPRTDR=CardObj.CFCardINVPRTDR.%Id()
	    }
	    s OutputObj.CFFareType=CardObj.CFFareType
	    s OutputObj.CFBankSignFlag=CardObj.CFBankSignFlag
	    s OutputObj.CFBankCode=CardObj.CFBankCode
	    d ..GetCardStatusChangeInfo(CFRowID,.OutputObj)
		do CardObj.%Close()
	}
	Q OutputObj
}

/// 描述:    卡状态变化相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.24
/// w ##class(DHCDoc.GetInfo.Method.Card).GetCardStatusChangeInfo()
ClassMethod GetCardStatusChangeInfo(CFRowID As %String, OutputObj) As DHCDoc.GetInfo.Entry.DHCCardStatusChange
{
	s CSCSub=0
	for {
		s CSCSub=$O(^DHCCARD("CF",CFRowID,"CSC",CSCSub)) q:CSCSub=""  d
		s CardStatusChangeOutputObj=##class(DHCDoc.GetInfo.Entry.DHCCardStatusChange).%New()
		s CardStatusObj=##class(User.DHCCardStatusChange).%OpenId(CFRowID_"||"_CSCSub)
		if $ISOBJECT(CardStatusObj) {
			s CardStatusChangeOutputObj.CSCRowID=CFRowID_"||"_CSCSub
			s CardStatusChangeOutputObj.CSCDate=CardStatusObj.CSCDate
			s CardStatusChangeOutputObj.CSCTime=CardStatusObj.CSCTime
			s CardStatusChangeOutputObj.CSCCurStatus=CardStatusObj.CSCCurStatus
			
			s CardStatusChangeOutputObj.CSCUserDR=CardStatusObj.CSCUserDR
			s UserObj=##class(User.SSUser).%OpenId(CardStatusChangeOutputObj.CSCUserDR)
			if $ISOBJECT(UserObj) {
				s CardStatusChangeOutputObj.CSCUserCode=UserObj.SSUSRInitials
				s CardStatusChangeOutputObj.CSCUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
			s CardStatusChangeOutputObj.CSCNote1=CardStatusObj.CSCNote1
			s CardStatusChangeOutputObj.CSCNote2=CardStatusObj.CSCNote2
			s CardStatusChangeOutputObj.CSCNote3=CardStatusObj.CSCNote3
			s CardStatusChangeOutputObj.CSCNote4=CardStatusObj.CSCNote4
			s CardStatusChangeOutputObj.CSCNote5=CardStatusObj.CSCNote5
			s CardStatusChangeOutputObj.CSCRLName=CardStatusObj.CSCRLName
			s CardStatusChangeOutputObj.CSCRLCredNo=CardStatusObj.CSCRLCredNo
			s CardStatusChangeOutputObj.CSCRLAddress=CardStatusObj.CSCRLAddress
			s CardStatusChangeOutputObj.CSCRLPhoneNo=CardStatusObj.CSCRLPhoneNo
			s CardStatusChangeOutputObj.CSCRLProof=CardStatusObj.CSCRLProof
			s CardStatusChangeOutputObj.CSCRLRemark=CardStatusObj.CSCRLRemark
			s CardStatusChangeOutputObj.CSCCredType=CardStatusObj.CSCCredType
			if $ISOBJECT(CardStatusChangeOutputObj.CSCCredType) {
				s CardStatusChangeOutputObj.CSCCredType=CardStatusObj.CSCCredType.%Id()
				s CredTypeObj=##class(User.DHCCredType).%OpenId(CardStatusChangeOutputObj.CSCUserDR)
				if $ISOBJECT(CredTypeObj) {
					s CardStatusChangeOutputObj.CSCCredTypeCode=CredTypeObj.CRTCode
					s CardStatusChangeOutputObj.CSCCredTypeDesc=CredTypeObj.CRTDesc
					do CredTypeObj.%Close()
				}
			}
			if $IsObject(CardStatusChangeOutputObj) {
			  do OutputObj.StatusChangeList.Insert(CardStatusChangeOutputObj)
		    }
			do CardStatusChangeOutputObj.%Close()
			do CardStatusObj.%Close()
		}
	}
}

}
