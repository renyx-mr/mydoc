Class DHCDoc.DHCDocConfig.PADiagnoseDuration Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetPADiagnoseDuration(PatType As %String, Diagnos As %String) As %Query(ROWSPEC = "PDDRowid:%String,PatientType:%String,PatientTypeDesc:%String,DiagnoseDR:%String,MRCIDDesc:%String,DurationDR:%String,Duration:%String,Remark:%String")
{
}

ClassMethod GetPADiagnoseDurationExecute(ByRef qHandle As %Binary, PatType As %String, Diagnos As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PADiagnoseDuration","GetPADiagnoseDuration",1,"")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    i PatType'="" d
    .s PDDRowid=0 f  s PDDRowid=$o(^DHCPADIADuration(0,"PatientType",PatType,PDDRowid)) q:PDDRowid=""  d
    ..d GetPADiagnoseDuration(PDDRowid)
	..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(PatType'="") $$$OK
    
    i Diagnos'="" d
    .s PDDRowid=0 f  s PDDRowid=$o(^DHCPADIADuration(0,"Diagnose",Diagnos,PDDRowid)) q:PDDRowid=""  d
    ..d GetPADiagnoseDuration(PDDRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(Diagnos'="") $$$OK
    
	s PDDRowid=0  
	f  s PDDRowid=$o(^DHCPADIADuration(PDDRowid)) q:PDDRowid=""  d
    .d GetPADiagnoseDuration(PDDRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPADiagnoseDuration
	set Data=$lb($g(PDDRowid),$g(PatientType),$g(PatientTypeDesc),$g(DiagnoseDR),$g(MRCIDDesc),$g(DurationDR),$g(Duration),$g(Remark))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetPADiagnoseDuration(PDDRowid)
    s PatientType=$p(^DHCPADIADuration(PDDRowid),"^",1)
	s PatientTypeDesc=""
	i PatientType'="" s PatientTypeDesc=$p(^CT("SS",PatientType),"^",2)
	q:(PatientType'=PatType)&&(PatType'="")
	s DiagnoseDR=$p(^DHCPADIADuration(PDDRowid),"^",2)
	q:(DiagnoseDR'=Diagnos)&&(Diagnos'="")
	s MRCIDDesc=""
	i DiagnoseDR'="" s MRCIDDesc=$p(^MRC("ID",DiagnoseDR),"^",2)
	s DurationDR=$p(^DHCPADIADuration(PDDRowid),"^",3)
	s Duration=""
	i DurationDR'="" s Duration=$p(^PHCDU(DurationDR),"^",1)
	s Remark=$p(^DHCPADIADuration(PDDRowid),"^",4)
	Do OutputRowGetPADiagnoseDuration
}

ClassMethod GetPADiagnoseDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPADiagnoseDurationExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPADiagnoseDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPADiagnoseDurationExecute ]
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

ClassMethod delete(Rowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCPADiagnoseDuration(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod save(Rowid As %String, Str As %String) As %String
{
	s DurationRowid=$p(Str,"!",2)
	q:'$d(^PHCDU(DurationRowid)) "-1"
	zn "dhc-data"
	 s PLIST(2)=$p(Str,"!",1) //PatientTypeRowid
     s PLIST(4)=$p(Str,"!",2) //DurationRowid
     s PLIST(3)=$p(Str,"!",3) //DiagnoseRowid
     s PLIST(5)=$p(Str,"!",4) //Remark
	if (Rowid=""){
		s rtn=$$insert^DHCPADiagnoseDuration()
	}else{
		s rtn=$$update^DHCPADiagnoseDuration(Rowid)
	}
	zn "dhc-app"
	q rtn
}

ClassMethod CopyPatType(SourceRowId As %String, DestinateRowId As %String) As %String
{
    Q:'$d(^CT("SS",SourceRowId))||('$d(^CT("SS",DestinateRowId))) "-1"
	zn "dhc-data"
	s rtn=0
	s find=$$finddiagnose^DHCPADiagnoseDuration(SourceRowId)
	if (find=0){
		s Rowid=0 f  s Rowid=$o(^DHCPADIADuration(0,"PatientType",SourceRowId,Rowid)) q:(Rowid="")||(rtn<0)  d
		.s DiagnoseRowid=$p(^DHCPADIADuration(Rowid),"^",2)
		.i ($$find^DHCPADiagnoseDuration(DestinateRowId,DiagnoseRowid)'=100) s rtn="-2"
		.q:rtn="-2"
		.s DurationRowid=$p(^DHCPADIADuration(Rowid),"^",3)
		.s remark=$p(^DHCPADIADuration(Rowid),"^",4)
		.s PLIST(2)=DestinateRowId
        .s PLIST(4)=DurationRowid
        .s PLIST(3)=DiagnoseRowid
        .s PLIST(5)=remark
        .s rtn=$$insert^DHCPADiagnoseDuration()
	}else{
		zn "dhc-app"
		q find
	}
	zn "dhc-app"
	b
	q rtn
}

}
