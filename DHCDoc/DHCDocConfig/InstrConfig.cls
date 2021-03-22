Class DHCDoc.DHCDocConfig.InstrConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->用法设置 
Query FindTypeInstr(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindTypeInstrExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrConfig","FindTypeInstr","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",2)
 	.s PHCINDesc2=$p(str,"^",3)
	.s selected=0
	.i value'="" d
	..s:("^"_$g(^DHCDocConfig(value))_"^")[("^"_InstrRowID_"^") selected=1
	.Do OutputRowFindTypeInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindTypeInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindTypeInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTypeInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeInstrExecute ]
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

}
