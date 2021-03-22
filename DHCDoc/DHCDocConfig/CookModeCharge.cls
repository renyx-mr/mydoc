Class DHCDoc.DHCDocConfig.CookModeCharge Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->草药加工方式收费设置 草药加工方式
Query GetCNMedCookMode() As %Query(ROWSPEC = "Code,Desc")
{
}

ClassMethod GetCNMedCookModeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetCNMedCookMode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s str=$g(^DHCDocConfig("CNMedCookMode"))
    s Code=0
    For i=1:1:$l(str,"^") d
    .s value=$p(str,"^",i)
    .s Code=+$p(value,$c(1),1)
    .;s Code=Code+1
    .s Desc=$p(value,$c(1),2)
	.Do OutputRowGetCNMedCookMode
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCNMedCookMode
	set Data=$lb($g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCNMedCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCNMedCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCNMedCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCNMedCookModeExecute ]
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
/// desc:医生站设置程序->草药加工方式收费设置 限定单位
Query GetCTUomList(value As %String, CookMode As %String) As %Query(ROWSPEC = "CTUOMRowId:%String,CTUOMDesc:%String,selected:%Boolean")
{
}

ClassMethod GetCTUomListExecute(ByRef qHandle As %Binary, value As %String, CookMode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetCTUomList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s CTUOMRowId=0  f  s CTUOMRowId=$o(^CT("UOM",CTUOMRowId)) q:CTUOMRowId=""  d
    .s CTUOMDesc=$p(^CT("UOM",CTUOMRowId),"^",2)
    .s selected=0
    .i CookMode'="" d
    ..i CTUOMRowId=$p($g(^DHCDocConfig(value,CookMode)),"^",1)  s selected=1
	.Do OutputRowGetCTUomList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTUomList
	set Data=$lb($g(CTUOMRowId),$g(CTUOMDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTUomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTUomListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTUomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTUomListExecute ]
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
/// desc:医生站设置程序->草药加工方式收费设置 绑定的收费项目
Query GetAppendItem(value As %String, CookMode As %String) As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,Qty:%String,CTUomDr:%String,CTUomDesc:%String,StartQty:%String")
{
}

ClassMethod GetAppendItemExecute(ByRef qHandle As %Binary, value As %String, CookMode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetAppendItem","CookModeCharge",3)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (CookMode="") {
	   Set qHandle=$lb(0,repid,0)
	   Quit $$$OK
	}
    s ARCIMRowID=0 
    f  s ARCIMRowID=$o(^DHCDocConfig(value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
	.q:+ARCIMRowID="0"
    .q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
    .s val=$g(^DHCDocConfig(value,CookMode,ARCIMRowID))
    .s Qty=$p(val,"!",1)
    .s CTUomDr=$p(val,"!",2)
    .s CTUomDesc=$p(^CT("UOM",CTUomDr),"^",2)
    .s StartQty=$p(val,"!",3)
	.Do OutputRowGetAppendItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAppendItem
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(Qty),$g(CTUomDr),$g(CTUomDesc),$g(StartQty))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemExecute ]
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
/// desc:医生站设置程序->草药加工方式收费设置 查询所有的绑定的收费项目
Query GetChargeItem(value As %String, ChargeCate As %String) As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,selected:%Boolean")
{
}

ClassMethod GetChargeItemExecute(ByRef qHandle As %Binary, value As %String, ChargeCate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetChargeItem","CookModeCharge","Material")
	Set repid=$I(^CacheTemp)
    Set ind=1
    
	s CookMode=0  f  s CookMode=$o(^DHCDocConfig(value,CookMode)) q:CookMode=""  d
    .s ARCIMRowID=0 
    .f  s ARCIMRowID=$o(^DHCDocConfig(value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
	..q:+ARCIMRowID="0"
    ..q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
    ..s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
    ..s selected=0
    ..i ChargeCate'="" d
    ...i ("^"_$g(^DHCDocConfig("CookModeChargeCate",ChargeCate))_"^")[("^"_ARCIMRowID_"^")  s selected=1
	..Do OutputRowGetChargeItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetChargeItem
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetChargeItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChargeItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChargeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChargeItemExecute ]
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

ClassMethod delete(node, node1, node2) As %String
{
	zn "dhc-data"
	s rtn=$$killconfignodes2^DHCDocConfig(node,node1,node2)
	zn "dhc-app"
	q rtn
}

ClassMethod save(node, node1, node2, value) As %String
{
    q:(+node2="0")||(node2'["||") 1
	q:'$d(^ARCIM(+node2,$p(node2,"||",2),1)) 1
	s ^DHCDocConfig(node,node1,node2)=value
	q 0
}

}
