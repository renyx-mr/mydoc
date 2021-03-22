Class DHCDoc.DHCDocConfig.OrdReasonRecLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->基本设置 根据医嘱费别接收科室定义 
Query FindDep(AdmReason As %String, value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary, AdmReason As %String, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrdReasonRecLoc","FindDep",1,"OrdReasonRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected="N"
 	.i (value'="")&&(AdmReason'="") d
 	..s:("^"_$g(^DHCDocConfig(value,AdmReason))_"^")[("^"_CTLOCRowID_"^") selected="Y"
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
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
/// date:2015-05-04
/// desc:医生站设置程序->基本设置 查询费别
Query FindBillType() As %Query(ROWSPEC = "BillTypeRowid:%String,BillTypeDesc:%String")
{
}

ClassMethod FindBillTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrdReasonRecLoc","FindBillType","QuickAdmBillType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BillTypeRowid=0
    f  s BillTypeRowid=$o(^PAC("ADMREA",BillTypeRowid)) q:BillTypeRowid=""  d
    .s BillTypeDesc=$p(^PAC("ADMREA",BillTypeRowid),"^",2)
	.Do OutputRowFindBillType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindBillType
	set Data=$lb($g(BillTypeRowid),$g(BillTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindBillTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBillTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillTypeExecute ]
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
