Class DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->基本设置 查询子类对应的接收科室
Query FindRecLocByCat(CatDr As %String, value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindRecLocByCatExecute(ByRef qHandle As %Binary, CatDr As %String, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc","FindRecLocByCat","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected=0
 	.s:("^"_$g(^DHCDocConfig(value,CatDr))_"^")[CTLOCRowID selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindRecLocByCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindRecLocByCat
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindRecLocByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecLocByCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRecLocByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecLocByCatExecute ]
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
/// desc:医生站设置程序->基本设置 查询住院科室
Query FindIPLoc(value As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindIPLocExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc","FindIPLoc","LocNoInOneOrderCF")
	Set repid=$I(^CacheTemp)
    Set ind=1
    /*s ADMLOCRowId=0
    f  s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""  d 
    .s ADMLOCAdmType=$p(^PAC("ADMLOC",ADMLOCRowId),"^",1)
    .q:(ADMLOCAdmType'="I")||(ADMLOCAdmType'="E")
    .s LocID=$p(^PAC("ADMLOC",ADMLOCRowId),"^",2)
    .s LocDesc=$p(^CTLOC(LocID),"^",2)
    .s selected=0
    .i value'="" d
    ..i LocID=$g(^DHCDocConfig(value))  s selected=1
	.Do OutputRowFindIPLoc*/
	s LocID=0
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s selected=0
    .i value'="" d
    ..i LocID=$g(^DHCDocConfig(value))  s selected=1
	.Do OutputRowFindIPLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindIPLoc
	set Data=$lb($g(LocID),$g(LocDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindIPLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIPLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIPLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIPLocExecute ]
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
/// desc:医生站设置程序->基本设置 查询医嘱子类
Query FindCatList(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s ARCICOrderType=$p(^ARC("IC",ARCICRowId),"^",7)
 	.q:ARCICOrderType'="R"
 	.s selected=0
 	.i value'="" d
 	..s FrequencedItemCatListStr=$g(^DHCDocConfig(value))
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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
