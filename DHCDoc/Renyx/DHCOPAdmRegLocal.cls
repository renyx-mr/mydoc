Class DHCDoc.Renyx.DHCOPAdmRegLocal Extends %RegisteredObject
{

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
