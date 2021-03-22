Class DHCDoc.Renyx.DHCDocIPBookNewLocal Extends %RegisteredObject
{

/// renyx 作废患者历史申请的住院证  
/// input 患者id，住院证id，用户id
ClassMethod VoidHistoryPatIPBook(PatId As %String, IPBookRowId As %String, UserId As %String)
{
	s IPBookDr=""
	s CancelDr=$o(^DHCDocIPBDIC("0","TypeCode","IPBookingState","Cancel",0))
	f{
		s IPBookDr=$o(^DHCDocIPBK(0,"PatientID",PatId,IPBookDr),-1)
		q:IPBookDr=""
		continue:IPBookRowId=IPBookDr
		s StateID=$p($g(^DHCDocIPBK(IPBookDr)),"^",8)
		s StateCode=$p($g(^DHCDocIPBDIC(StateID)),"^",1)
		; PreInPatient
		;continue:StateCode'="Booking"
		continue:((StateCode'="Booking")&&(StateCode'="PreInPatient"))
		s $p(^DHCDocIPBK(IPBookDr),"^",8)=CancelDr
		s $p(^DHCDocIPBK(IPBookDr),"^",9)="N"
		s $p(^DHCDocIPBK(IPBookDr),"^",25)=UserId
		s $p(^DHCDocIPBK(IPBookDr),"^",26)=+$h
		s $p(^DHCDocIPBK(IPBookDr),"^",27)=$p($h,",",2)
	}
	q "0"
}

}
