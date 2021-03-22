Class DHCDoc.DHCDocConfig.ItemPrior Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->出院带药医嘱扩展设定 查询出院带药医嘱扩展设定
Query Find(Alias As %String) As %Query(ROWSPEC = "rowid:%String,BillTypeRowid:%String,BillType:%String,ItemCatRowid:%String,ItemCat:%String,DurationRowid:%String,Duration:%String,Drugspecies:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, Alias As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","Find")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	 s rowid=0
     for  s rowid=$O(^DHCOOOC(rowid)) Q:rowid=""  d
     .set ItemCatRowid=$P(^DHCOOOC(rowid),"^",1)
     .set BillTypeRowid=$P(^DHCOOOC(rowid),"^",2)
     .set DurationRowid=$P(^DHCOOOC(rowid),"^",3)
     .set Drugspecies=$P(^DHCOOOC(rowid),"^",4)
     .s (ItemCat,BillType,Duration)=""
     .if ItemCatRowid'="" s ItemCat=$p($g(^ARC("IC",ItemCatRowid)),"^",2)
     .if BillTypeRowid'="" s BillType=$p($g(^PAC("ADMREA",BillTypeRowid)),"^",2)
     .if DurationRowid'="" s Duration=$p($g(^PHCDU(DurationRowid)),"^",3)
	 .d OutputRowFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	Set Data=$lb(rowid,BillTypeRowid,BillType,ItemCatRowid,ItemCat,DurationRowid,Duration,Drugspecies)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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
/// desc:医生站设置程序->出院带药医嘱扩展设定 录入频次疗程的非药品子类
Query FindCatList(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
 	.i value'="" d
 	..s FrequencedItemCatListStr=$g(^DHCDocConfig(value,OutOrderPrior))
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->出院带药医嘱扩展设定 录入频次疗程的非药品子类
Query FindPoison(value As %String) As %Query(ROWSPEC = "PHCPORowId:%String,PHCPODesc:%String,selected:%Boolean")
{
}

ClassMethod FindPoisonExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindPoison","OutOrderNotPoison")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PHCPORowId=0 
 	f  s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""  d
 	.s PHCPODesc=$p(^PHCPO(PHCPORowId),"^",2)
 	.s PHCPOCode=$p(^PHCPO(PHCPORowId),"^",1)
 	.q:((PHCPOCode="J1")||(PHCPOCode="J2")||(PHCPOCode="DX")||(PHCPOCode="MZ"))&&(value="OutOrderNotPoison")
 	.s selected=0
 	.s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
 	.i value'="" d
 	..s PHCPORowIdStr=$g(^DHCDocConfig(value,OutOrderPrior))
 	..s:("^"_PHCPORowIdStr_"^")[("^"_PHCPORowId_"^") selected=1
	.Do OutputRowFindPoison
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPoison
	set Data=$lb($g(PHCPORowId),$g(PHCPODesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPoisonExecute ]
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

ClassMethod delete(RowId As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCOutOrderOtherContral(RowId)
	zn "dhc-app"
	q rtn
}

ClassMethod insert(Para As %String) As %String
{
	zn "dhc-data"
	s rtn=$$insert^DHCOutOrderOtherContral(Para)
	zn "dhc-app"
	q rtn
}

ClassMethod SaveConfig(node, value) As %String
{
	s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
	s ^DHCDocConfig(node,OutOrderPrior)=value
	q 0
}

Query FindCatListPrior(PriorCode As %String, value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListPriorExecute(ByRef qHandle As %Binary, PriorCode As %String, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindCatListPrior","NORM","OnlyNORMItemCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
    s ItemCatRowId=0
 	f  s ItemCatRowId=$o(^ARC("IC",ItemCatRowId)) q:ItemCatRowId=""  d
 	.s ItemCatDesc=$p(^ARC("IC",ItemCatRowId),"^",2)
 	.s selected=0
 	.i value'="" d
 	..s ItemCatListStr=$g(^DHCDocConfig(value,OrderPrior))
 	..s:("^"_ItemCatListStr_"^")[("^"_ItemCatRowId_"^") selected=1
	.Do OutputRowFindCatListPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListPrior
	set Data=$lb($g(ItemCatRowId),$g(ItemCatDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListPriorExecute ]
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

Query FindOrdPriorLimit(PriorCode As %String, Value As %String) As %Query(ROWSPEC = "Index:%String,ArcimDr:%String,ArcimDesc:%Boolean")
{
}

ClassMethod FindOrdPriorLimitExecute(ByRef qHandle As %Binary, PriorCode As %String, Value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindOrdPriorLimit","NORM","OnlyNORMItemCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
    s Index=0
 	f  s Index=$o(^DHCDocConfig(Value,OrderPrior,"Item",Index)) q:Index=""  d
 	.s ArcimDr=$p(^DHCDocConfig(Value,OrderPrior,"Item",Index),"^",1)
 	.s ArcimDesc=$P($G(^ARCIM(+ArcimDr,+$P(ArcimDr,"||",2),1)),"^",2)
	.Do OutputRowFindOrdPriorLimit
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOrdPriorLimit
	set Data=$lb(Index,$g(ArcimDr),$g(ArcimDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOrdPriorLimitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdPriorLimitExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdPriorLimitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdPriorLimitExecute ]
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

ClassMethod SaveOrdPriorLimit(Value As %String, PriorCode As %String, Info As %String) As %String
{
	q:(+Info=0)||(Info'["||") "-2"
	q:'$d(^ARCIM(+Info,$p(Info,"||",2),1)) "-2"
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	s Index=$O(^DHCDocConfig(Value,OrderPrior,"Item",""),-1)
	s Index=Index+1
	s ^DHCDocConfig(Value,OrderPrior,"Item",Index)=Info
	q 0
}

ClassMethod DelPriorLimit(Value As %String, PriorCode As %String, IndexS As %String) As %String
{
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	for i=1:1:$Length(IndexS,"^"){
		s Index=$P(IndexS,"^",i)
		k ^DHCDocConfig(Value,OrderPrior,"Item",Index)
	}
	q 0
}

ClassMethod SavePriorLimitConfig(Value As %String, PriorCode As %String, ItemCatS As %String) As %String
{
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	s ^DHCDocConfig(Value,OrderPrior)=ItemCatS
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyNORMItemCat","NORM")
ClassMethod GetPriorLimitInfo(Value As %String, PriorCode As %String) As %String
{
	n (Value,PriorCode)
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	q:(OrderPrior="") ""
	s ItemCatStr=$G(^DHCDocConfig(Value,OrderPrior))
	s ArcItemStr=""
	s Index=""
	for {
		s Index=$O(^DHCDocConfig(Value,OrderPrior,"Item",Index))
		q:(Index="")
		s Item=$G(^DHCDocConfig(Value,OrderPrior,"Item",Index))
		continue:(Item="")
		i (ArcItemStr=""){
			s ArcItemStr=Item
		}else{
			s ArcItemStr=ArcItemStr_"^"_Item
		}
	}
	q ItemCatStr_$C(1)_ArcItemStr
}

}
