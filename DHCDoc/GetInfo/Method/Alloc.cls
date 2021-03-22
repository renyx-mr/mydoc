/// 名称:    DHCDoc.GetInfo.Method.Alloc
/// 描述:    分诊相关信息获取公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
/// 继承:   
Class DHCDoc.GetInfo.Method.Alloc Extends %RegisteredObject
{

/// 描述:    分诊相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.24
/// w ##class(DHCDoc.GetInfo.Method.Alloc).GetAllocInfo()
ClassMethod GetAllocInfo(QueID As %String) As DHCDoc.GetInfo.Entry.DHCQueue
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.DHCQueue).%New()
	s QueObj=##class(User.DHCQueue).%OpenId(QueID)
	if $ISOBJECT(QueObj) {
		s OutputObj.ID=QueID
		s OutputObj.Operuserid=QueObj.Operuserid
		if $ISOBJECT(OutputObj.Operuserid) {
			s OutputObj.Operuserid=QueObj.Operuserid.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.Operuserid)
			if $ISOBJECT(UserObj) {
				s OutputObj.OperuserCode=UserObj.SSUSRInitials
				s OutputObj.OperuserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.QueCalled=QueObj.QueCalled
		s OutputObj.QueCompDr=QueObj.QueCompDr
		s OutputObj.QueDate=QueObj.QueDate
		s OutputObj.QueDepDr=QueObj.QueDepDr
		if $ISOBJECT(OutputObj.QueDepDr) {
			s OutputObj.QueDepDr=QueObj.QueDepDr.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.QueDepDr)
			if $ISOBJECT(LocObj) {
				s OutputObj.QueDepCode=LocObj.CTLOCCode
				s OutputObj.QueDepDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.QueDocDr=QueObj.QueDocDr
		if $ISOBJECT(OutputObj.QueDocDr) {
			s OutputObj.QueDocDr=QueObj.QueDocDr.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.QueDocDr)
			if $ISOBJECT(DocObj) {
				s OutputObj.QueDocCode=DocObj.CTPCPCode
				s OutputObj.QueDocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.QueExabDr=QueObj.QueExabDr
		if $ISOBJECT(OutputObj.QueExabDr) {
			s OutputObj.QueExabDr=QueObj.QueExabDr.%Id()
			s ExaBObj=##class(User.DHCExaBorough).%OpenId(OutputObj.QueExabDr)
			if $ISOBJECT(ExaBObj) {
				s OutputObj.QueExabCode=ExaBObj.ExabCode
				s OutputObj.QueExabDesc=ExaBObj.ExabName
				do ExaBObj.%Close()
			}
		}
		s OutputObj.QueFirstDr=QueObj.QueFirstDr
		if $ISOBJECT(OutputObj.QueFirstDr) {
			s OutputObj.QueFirstDr=QueObj.QueFirstDr.%Id()
			s FirstObj=##class(User.DHCFirstCode).%OpenId(OutputObj.QueFirstDr)
			if $ISOBJECT(FirstObj) {
				s OutputObj.QueFirstCode=FirstObj.FirstcCode
				s OutputObj.QueFirstDesc=FirstObj.FirstcName
				do FirstObj.%Close()
			}
		}
		s OutputObj.QueMarkDr=QueObj.QueMarkDr
		if $ISOBJECT(OutputObj.QueMarkDr) {
			s OutputObj.QueMarkDr=QueObj.QueMarkDr.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.QueMarkDr)
			if $ISOBJECT(DocObj) {
				s OutputObj.QueMarkCode=DocObj.CTPCPCode
				s OutputObj.QueMarkDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.QueName=QueObj.QueName
		s OutputObj.QueNo=QueObj.QueNo
		s OutputObj.QuePersonId=QueObj.QuePersonId
		if $ISOBJECT(OutputObj.QuePersonId) {
			s OutputObj.QuePersonId=QueObj.QuePersonId.%Id()
		}
		s OutputObj.QueRoomDr=QueObj.QueRoomDr
		if $ISOBJECT(OutputObj.QueRoomDr) {
			s OutputObj.QueRoomDr=QueObj.QueRoomDr.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.QueRoomDr)
			if $ISOBJECT(LocObj) {
				s OutputObj.QueRoomCode=LocObj.CTLOCCode
				s OutputObj.QueRoomDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.QueStateDr=QueObj.QueStateDr
		if $ISOBJECT(OutputObj.QueStateDr) {
			s OutputObj.QueStateDr=QueObj.QueStateDr.%Id()
			s StateObj=##class(User.DHCPerState).%OpenId(OutputObj.QueStateDr)
			if $ISOBJECT(StateObj) {
				s OutputObj.QueStateCode=StateObj.PersCode
				s OutputObj.QueStateDesc=StateObj.PersName
				do StateObj.%Close()
			}
		}
		s OutputObj.QueStateTime=QueObj.QueStateTime
		s OutputObj.QueConsultFlag=QueObj.QueConsultFlag
		s OutputObj.QueStateDate=QueObj.QueStateDate
		s OutputObj.QueTime=QueObj.QueTime
		s OutputObj.ChangeDepDr=QueObj.ChangeDepDr
		if $ISOBJECT(OutputObj.ChangeDepDr) {
			s OutputObj.ChangeDepDr=QueObj.ChangeDepDr.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.ChangeDepDr)
			if $ISOBJECT(LocObj) {
				s OutputObj.ChangeDepCode=LocObj.CTLOCCode
				s OutputObj.ChangeDepDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.Comm1=QueObj.Comm1
		s OutputObj.Comm2=QueObj.Comm2
		d ..GetQueStatusChangeInfo(QueID,.OutputObj)
		do QueObj.%Close()
	}
	//d OutputObj.XMLExportToString(.tt,"<Request>")
	Q OutputObj
}

/// 描述:    分诊状态变化相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.24
/// w ##class(DHCDoc.GetInfo.Method.Alloc).GetQueStatusChangeInfo()
ClassMethod GetQueStatusChangeInfo(QueID As %String, OutputObj) As DHCDoc.GetInfo.Entry.DHCQueueStatus
{
	s QSChildSub=0
	for {
		s QSChildSub=$O(^DHCQueueStatus(QueID,QSChildSub)) q:QSChildSub=""  d
		s QueStatusChangeOutputObj=##class(DHCDoc.GetInfo.Entry.DHCQueueStatus).%New()
		s QueStatusObj=##class(User.DHCQueueStatus).%OpenId(QueID_"||"_QSChildSub)
		if $ISOBJECT(QueStatusObj) {
			s QueStatusChangeOutputObj.QSRowId=QueID_"||"_QSChildSub
			s QueStatusChangeOutputObj.QSDate=QueStatusObj.QSDate
			s QueStatusChangeOutputObj.QSTime=QueStatusObj.QSTime
			s QueStatusChangeOutputObj.QSDocDr=QueStatusObj.QSDocDr
			if $ISOBJECT(QueStatusChangeOutputObj.QSDocDr) {
				s QueStatusChangeOutputObj.QSDocDr=QueStatusObj.QSDocDr.%Id()
				s DocObj=##class(User.CTCareProv).%OpenId(QueStatusChangeOutputObj.QSDocDr)
				if $ISOBJECT(DocObj) {
					s QueStatusChangeOutputObj.QSDocCode=DocObj.CTPCPCode
					s QueStatusChangeOutputObj.QSDocCode=DocObj.CTPCPDesc
					do DocObj.%Close()
				}
			}
			s QueStatusChangeOutputObj.QSStatus=QueStatusObj.QSStatus
			if $ISOBJECT(QueStatusChangeOutputObj.QSStatus) {
				s QueStatusChangeOutputObj.QSStatus=QueStatusObj.QSStatus.%Id()
				s StateObj=##class(User.DHCPerState).%OpenId(QueStatusChangeOutputObj.QSStatus)
				if $ISOBJECT(StateObj) {
					s QueStatusChangeOutputObj.QSStatusCode=StateObj.PersCode
					s QueStatusChangeOutputObj.QSStatusDesc=StateObj.PersName
					do StateObj.%Close()
				}
			}
			s QueStatusChangeOutputObj.QSUpUserID=QueStatusObj.QSUpUserID
			if $ISOBJECT(QueStatusChangeOutputObj.QSUpUserID) {
				s QueStatusChangeOutputObj.QSUpUserID=QueStatusObj.QSUpUserID.%Id()
				s UserObj=##class(User.SSUser).%OpenId(QueStatusChangeOutputObj.QSUpUserID)
				if $ISOBJECT(UserObj) {
					s QueStatusChangeOutputObj.QSUpUserCode=UserObj.SSUSRInitials
					s QueStatusChangeOutputObj.QSUpUserDesc=UserObj.SSUSRName
					do UserObj.%Close()
				}
			}
			if $IsObject(QueStatusChangeOutputObj) {
			  do OutputObj.StatusChangeList.Insert(QueStatusChangeOutputObj)
		    }
			do QueStatusChangeOutputObj.%Close()
			do QueStatusObj.%Close()
		}
	}
}

}
