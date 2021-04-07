Class DHCDoc.Renyx.DHCOPAdmRegLocal Extends %RegisteredObject
{
/// 根据预约信息发送信息给患者 
ClassMethod SendMessageByAppt() 
{
	s AsDate=+$h+1
	s RESRowId=0
	for {
		s RESRowId=$o(^RBAS(0,"Date",AsDate,RESRowId))
		q:RESRowId=""
		s ASChildSub=0
		for {
			s ASChildSub=$o(^RBAS(0,"Date",AsDate,RESRowId,ASChildSub))
			q:ASChildSub=""
			s StatusDR=$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
			s StatusCode=""
			s:StatusDR'="" StatusCode=$p($g(^DHCRBCASStatus(StatusDR)),"^",1)
			continue:((StatusCode="S")||(StatusCode="PS"))
			s APPTChildSub=0
			for {
				s APPTChildSub=$o(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub))
				q:APPTChildSub=""
				s APPTStatus=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3)
				continue:(APPTStatus'="I")
				s PatId=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",2)
				continue:PatId=""
			}
		}
	}
	q "0"
}
ClassMethod PatSendMessage(PatDr As %String)
{
	s $zt="PatSendMessageErr"
	s StartDate=$zd(+$h,3)
	&sql(DECLARE ApptList CURSOR FOR
		SELECT APPT_AS_ParRef->AS_Date,APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc,APPT_RowId
		INTO :AsDate,:CTPCPDesc,:APPTRowId
		FROM SQLUser.RB_Appointment WHERE APPT_PAPMI_DR=:PatDr AND APPT_Status="I" AND APPT_TransDate=:StartDate
	)
	&SQL(OPEN ApptList)
	s intNum=0
 	For {
	 	&SQL(FETCH ApptList) 
	 	QUIT:SQLCODE
	 	
 	}
 	&SQL(CLOSE ApptList)
 	q "0"
PatSendMessageErr
 	q "-1"
}

}
