Class web.DHCDocMedAudit Extends %RegisteredObject
{

ClassMethod FindDocIPBookingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocIPBookingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMedAudit","FindDocIPBooking")
ClassMethod FindDocIPBookingExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s BookCreateDate=+$h-1
    for{
        s BookCreateDate=$o(^DHCDocIPBK(0,"BookingDate",BookCreateDate))
        q:BookCreateDate=""
        s BookDr=0
        for{
            s BookDr=$o(^DHCDocIPBK(0,"BookingDate",BookCreateDate,BookDr))
            q:BookDr=""
            // 住院日期	住院号	收住科室	联系手机号	信息是否完整	审核状态	审核人 
            s DocIPBookingObj=##class(User.DHCDocIPBooking).%OpenId(BookDr)
            s AdminDate="",IPBookNo="",AdminWardDesc="",PhoneNo="",InfoStrFlag="",Status="",AuditUserDesc=""
            if $IsObject(DocIPBookingObj){
	            s IPAdmDr=DocIPBookingObj.EpisodeIDToGetObjectId()
	            if (IPAdmDr'=""){
	            	s AdminDate=$p($g(^PAADM(IPAdmDr,"DHC")),"^",31)
	            	s:AdminDate'="" AdminDate=$zd(AdminDate,3)
	            }
	            s IPBookNo=DocIPBookingObj.IPBookNo
	            s AdminWardDr=$p($g(^PAADM(IPAdmDr,"DHC")),"^",34)
	            s:AdminWardDr'="" AdminWardDesc=$p($g(^PAC("PACWD",AdminWardDr)),"^",2)
	            s PhoneNo=DocIPBookingObj.ReceiveSMSPhone
	            s PAPMIDR=$p($g(^PAADM(IPAdmDr)),"^",1)
	            s InfoStrFlag=""
	            s ExistID=$O(^User.DHCDocMedAuditD("PAPMIDR",PAPMIDR,0))
	            s ExistObj=##class(User.DHCDocMedAudit).%OpenId(ExistID)
	            if $IsObject(DocIPBookingObj){
		            s StatusCode=ExistObj.Status
		            s Status=$case(StatusCode,"P":"通过","U":"拒绝","O":"其他",:"")
		            s AuditUserDR=ExistObj.AuditUserDR
		            s:AuditUserDR'="" AuditUserDesc=$p($g(^SSU("SSUSR",AuditUserDR)),"^",2)
	            }
            }
            
            d DocIPBookingObj.%Close()
            //s IPAdmDr=$p($g(^DHCDocIPBK(BookDr)),"^",3)
        }
    }
		//do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IPBookingOutputRow      
	set Data=$lb(AdminDate,IPBookNo,AdminWardDesc,PhoneNo,InfoStrFlag,Status,AuditUserDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindDocIPBookingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocIPBookingExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindDocIPBooking() As %Query(ROWSPEC = "AdminDate:%String,IPBookNo:%String,AdminWardDesc:%String,PhoneNo:%String,InfoStrFlag:%String,Status:%String,AuditUserDesc:%String")
{
}

}
