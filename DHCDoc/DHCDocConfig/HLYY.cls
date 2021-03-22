Class DHCDoc.DHCDocConfig.HLYY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FinDTDep(value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FinDTDepExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HLYY","FinDTDep","DTAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.//q:(CTLOCType'="E")&&(CTLOCType'="W")
 	.s selected=0
 	.i value'="" d
 	..s:("^"_$g(^DHCDocConfig(value))_"^")[("^"_CTLOCRowID_"^") selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFinDTDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFinDTDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FinDTDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinDTDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FinDTDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinDTDepExecute ]
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

ClassMethod GetConfigNode1(Node As %String, SubNode As %String) As %String
{
	Q:SubNode="" ""
	s rtn=$g(^DHCDocConfig(Node,SubNode))
	s:rtn="" rtn="^^"
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

Storage Default
{
<Data name="HLYYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.DHCDocConfig.HLYYD</DataLocation>
<DefaultData>HLYYDefaultData</DefaultData>
<IdLocation>^DHCDoc.DHCDocConfig.HLYYD</IdLocation>
<IndexLocation>^DHCDoc.DHCDocConfig.HLYYI</IndexLocation>
<StreamLocation>^DHCDoc.DHCDocConfig.HLYYS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
