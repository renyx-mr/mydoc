Class DHCDoc.DHCDocConfig.ItmDiagnose Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetItmDiagnose(PatType As %String, ARCIMRowid As %String, Diagnose As %String) As %Query(ROWSPEC = "ItmDiaRowid:%String,PatientType:%String,PatientTypeDesc:%String,ItmMastDR:%String,ARCIMDesc:%String,DiagnoseDR:%String,MRCIDDesc:%String,Remark:%String")
{
}

ClassMethod GetItmDiagnoseExecute(ByRef qHandle As %Binary, PatType As %String, ARCIMRowid As %String, Diagnose As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItmDiagnose","GetItmDiagnose")
	s ^tempscl("GetItmDiagnose")=PatType_","_ARCIMRowid_","_Diagnose
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    i PatType'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("PatientType",PatType,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(PatType'="") $$$OK  
    i ARCIMRowid'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("Itm",ARCIMRowid,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(ARCIMRowid'="") $$$OK
     i Diagnose'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("Diagnose",Diagnose,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(Diagnose'="") $$$OK
    
	s ItmDiaRowid=0 
	f  s ItmDiaRowid=$o(^DHCITMDIA(ItmDiaRowid)) q:ItmDiaRowid=""  d
	.d GetItmDiagnose(ItmDiaRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItmDiagnose
	set Data=$lb($g(ItmDiaRowid),$g(PatientType),$g(PatientTypeDesc),$g(ItmMastDR),$g(ARCIMDesc),$g(DiagnoseDR),$g(MRCIDDesc),$g(Remark))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetItmDiagnose(ItmDiaRowid)
     s PatientType=$p(^DHCITMDIA(ItmDiaRowid),"^",1)
     q:(PatientType'=PatType)&&(PatType'="")
	 s PatientTypeDesc=""
	 i PatientType'="" s PatientTypeDesc=$p(^CT("SS",PatientType),"^",2)
	 s ItmMastDR=$p(^DHCITMDIA(ItmDiaRowid),"^",2)
	 q:(ARCIMRowid'=ItmMastDR)&&(ARCIMRowid'="")
	 s ARCIMDesc=""
	 i ItmMastDR'="" s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
	 s DiagnoseDR=$p(^DHCITMDIA(ItmDiaRowid),"^",3)
	 q:(DiagnoseDR'=Diagnose)&&(Diagnose'="")
	 s MRCIDDesc=""
	 i DiagnoseDR'="" s MRCIDDesc=$p($g(^MRC("ID",DiagnoseDR)),"^",2)
	 s Remark=$p(^DHCITMDIA(ItmDiaRowid),"^",4)
	 Do OutputRowGetItmDiagnose
}

ClassMethod GetItmDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItmDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmDiagnoseExecute ]
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
	s rtn=$$delete^DHCItemDiagnose(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod save(Rowid As %String, Str As %String) As %String
{
	s ARCIMID=$p(Str,"!",2)
	s MRCICDDR=$p(Str,"!",3)
	s arcimcode="",MRCIDCode=""
	 &sql(select ARCIM_code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:ARCIMID)
     q:arcimcode="" "-1"
     &sql(select MRCID_Code into :MRCIDCode from SQLUSER.mrc_icddx where MRCID_RowId=:MRCICDDR)
     q:MRCIDCode="" "-2"
	zn "dhc-data"
	 s PLIST(2)=$p(Str,"!",1) //PatientTypeRowid
     s PLIST(3)=ARCIMID //$p(Str,"!",2) //ItemRowid
     s PLIST(4)=MRCICDDR //$p(Str,"!",3) //DiagnoseRowid
     s PLIST(5)=$p(Str,"!",4) //Remark
     
	if (Rowid=""){
		s rtn=$$insert^DHCItemDiagnose()
	}else{
		s rtn=$$update^DHCItemDiagnose(Rowid)
	}
	zn "dhc-app"
	q rtn
}

Query GetWeekDiagnose() As %Query(ROWSPEC = "WeekNum:%String,DiagnoseDR:%String,MRCIDDesc:%String")
{
}

ClassMethod GetWeekDiagnoseExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItmDiagnose","GetWeekDiagnose")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s WeekNum=""
	for {
		s WeekNum=$O(^DHCDocConfig("WeekGestationDia",WeekNum))
		q:WeekNum=""
		s DiagnoseDR=$G(^DHCDocConfig("WeekGestationDia",WeekNum))
		s DiagnoseDesc=$p(^MRC("ID",DiagnoseDR),"^",2)
		d OutPut2

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut2
	s Data=$LB(WeekNum,DiagnoseDR,DiagnoseDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetWeekDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWeekDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWeekDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWeekDiagnoseExecute ]
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

ClassMethod saveWeekDiagnose(WeekNum As %String, DiagnoseDr As %String) As %String
{
	if ((WeekNum="")||(DiagnoseDr="")) q "-100"
	s ^DHCDocConfig("WeekGestationDia",WeekNum)=DiagnoseDr
	q 0
}

ClassMethod deleteWeekDiagnose(WeekNum As %String) As %String
{
	if ((WeekNum="")) q "-100"
	k ^DHCDocConfig("WeekGestationDia",WeekNum)
	q 0
}

ClassMethod GetWeekDiagnose(WeekNum As %String) As %String
{
	if ((WeekNum="")) q ""
	q $G(^DHCDocConfig("WeekGestationDia",WeekNum))
}

}
