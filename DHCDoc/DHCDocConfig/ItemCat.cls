Class DHCDoc.DHCDocConfig.ItemCat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->医嘱子类扩展设置 查询医嘱子类扩展设置
Query GetItemCatList() As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,OpenForAllHosp:%String,LimitStartTime:%String,FrequenceRowId:%String,FrequenceDesc:%String,StopOrderDiscExec:%String")
{
}

ClassMethod GetItemCatListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemCat","GetItemCatList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
    f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .s OpenForAllHosp=..FormatValue($P($G(^ARC("IC",ARCICRowId,"DHC")),"^",1))
    .s LimitStartTime=$P($G(^ARC("IC",ARCICRowId,"DHC")),"^",2)
    .s FrequenceRowId=$P($G(^ARC("IC",ARCICRowId,"DHC")),"^",3)
    .s FrequenceDesc=""
    .s:FrequenceRowId'="" FrequenceDesc=$p(^PHCFR(FrequenceRowId),"^",3)
    .s StopOrderDiscExec=..FormatValue($P($G(^ARC("IC",ARCICRowId,"DHC")),"^",4))
	.Do OutputRowGetItemCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItemCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(OpenForAllHosp),$g(LimitStartTime),$g(FrequenceRowId),$g(FrequenceDesc),$g(StopOrderDiscExec))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetItemCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemCatListExecute ]
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

ClassMethod FormatValue(value As %String) As %String
{
	i value=1 s value="Y"
	e  s value="N"
	q value
}

ClassMethod SetDHCARCItemCatFieldValue(Rowid As %String, DHCFieldNumStr As %String, ValStr As %String) As %String
{
	For i=1:1:$l(ValStr,"^") d
	.s DHCFieldNum=$p(DHCFieldNumStr,"^",i)
	.s Val=$p(ValStr,"^",i)
	.s $P(^ARC("IC",Rowid,"DHC"),"^",DHCFieldNum)=Val 
	q 0
}

}
