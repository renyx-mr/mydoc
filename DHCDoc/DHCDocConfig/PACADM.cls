Class DHCDoc.DHCDocConfig.PACADM Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->病人类别与费别对照 病人类别与费别对照
Query GetDHCPACADMList(value As %String) As %Query(ROWSPEC = "PACRowId:%String,PACSocialStatusDr:%String,PACSocialStatus:%String,PACAdmReasonDr:%String,PACAdmReason:%String")
{
}

ClassMethod GetDHCPACADMListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PACADM","GetDHCPACADMList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PACRowId=0  f  s PACRowId=$o(^DHCPACADM(PACRowId)) q:PACRowId=""  d
    .s PACSocialStatusDr=$p(^DHCPACADM(PACRowId),"^",1)
    .s PACSocialStatus=$p(^CT("SS",PACSocialStatusDr),"^",2)
    .s PACAdmReasonDr=$p(^DHCPACADM(PACRowId),"^",2)
    .q:'$d(^PAC("ADMREA",PACAdmReasonDr))
    .s PACAdmReason=$p(^PAC("ADMREA",PACAdmReasonDr),"^",2)
    .s PACStartDate=$p(^DHCPACADM(PACRowId),"^",3)
    .s PACEndDate=$p(^DHCPACADM(PACRowId),"^",4)
    .q:(PACStartDate'="")&&(PACStartDate>+$h)
    .q:(PACEndDate'="")&&(PACEndDate<=+$h)
	.Do OutputRowGetDHCPACADMList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDHCPACADMList
	set Data=$lb($g(PACRowId),$g(PACSocialStatusDr),$g(PACSocialStatus),$g(PACAdmReasonDr),$g(PACAdmReason))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDHCPACADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCPACADMListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDHCPACADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCPACADMListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->病人类别与费别对照 病人类别
Query GetCTSocialstatusList() As %Query(ROWSPEC = "SSRowId:%String,SSDesc:%String")
{
}

ClassMethod GetCTSocialstatusListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PACADM","GetCTSocialstatusList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s SSRowId=0  f  s SSRowId=$o(^CT("SS",SSRowId)) q:SSRowId=""  d
    .s SSDesc=$p(^CT("SS",SSRowId),"^",2)
	.Do OutputRowGetCTSocialstatusList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTSocialstatusList
	set Data=$lb($g(SSRowId),$g(SSDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTSocialstatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTSocialstatusListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTSocialstatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTSocialstatusListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod insert(PACSocialStatus As %String, PACAdmReason As %String) As %String
{
	s find=..find("",PACSocialStatus,PACAdmReason)
	q:find=1 "-1"
	k PLIST
	s PLIST(2)=PACSocialStatus
	s PLIST(3)=PACAdmReason
	zn "dhc-data"
	s rtn=$$insert^DHCPACADM()
	zn "dhc-app"
	q rtn
}

ClassMethod delete(Rowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCPACADM(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod update(Rowid As %String, PACSocialStatus As %String, PACAdmReason As %String) As %String
{
	s find=..find(Rowid,PACSocialStatus,PACAdmReason)
	q:find=1 "-1"
	k PLIST
	s PLIST(2)=PACSocialStatus
	s PLIST(3)=PACAdmReason
	s PLIST(4)=""
	s PLIST(5)=""
	zn "dhc-data"
	s rtn=$$update^DHCPACADM(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod find(Rowid, PACSocialStatus As %String, PACAdmReason As %String) As %String
{
	s Find=0
	s PACRowId=0  f  s PACRowId=$o(^DHCPACADM(0,"AdmReason",PACAdmReason,PACRowId)) q:(PACRowId="")||(Find=1)  d
	.Q:(Rowid'="")&&(PACRowId=Rowid)
	.s SocialStatus=$p(^DHCPACADM(PACRowId),"^",1)
	.s:(PACSocialStatus=SocialStatus) Find=1
	q Find
}

}
