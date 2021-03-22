Class DHCDoc.DHCDocConfig.SkinTestConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->皮试设置 查询所有用法
Query FindAllInstr(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindAllInstrExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindAllInstr","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",2)
 	.s PHCINDesc2=$p(str,"^",3)
	.s selected=0
	.i InstrRowID=$g(^DHCDocConfig(value)) s selected=1
	.Do OutputRowFindAllInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAllInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllInstrExecute ]
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
/// desc:医生站设置程序->皮试设置 查询所有皮试备注
Query GetSkinAction() As %Query(ROWSPEC = "ActRowid:%String,ACTDesc:%String")
{
}

ClassMethod GetSkinActionExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SkinTestConfig","GetSkinAction")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s ActRowid=0 f  s ActRowid=$o(^OEC("ACT",ActRowid)) q:ActRowid=""  d
	.s ACTCode=$p($g(^OEC("ACT",ActRowid)),"^",1)
	.s ACTDesc=$p($g(^OEC("ACT",ActRowid)),"^",2)
	.Do OutputRowGetSkinAction
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSkinAction
	set Data=$lb($g(ActRowid),$g(ACTDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSkinActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinActionExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSkinActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinActionExecute ]
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
/// desc:医生站设置程序->皮试设置 查询皮试备注绑定的医嘱
Query GetSkinLinkItem(ActRowid As %String) As %Query(ROWSPEC = "ActIARCIMDR:%String,ActIARCIMDesc:%String,ActIQty:%String,Rowid:%String,InstrDR:%String,Instr:%String")
{
}

ClassMethod GetSkinLinkItemExecute(ByRef qHandle As %Binary, ActRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SkinTestConfig","GetSkinLinkItem")
	Set repid=$I(^CacheTemp)
    Set ind=1
	i ActRowid'="" d
	.s ActIChildsub=0  f  s ActIChildsub=$o(^OEC("ACT",ActRowid,"Item",ActIChildsub)) q:ActIChildsub=""  d
	..s ActIARCIMDR=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",1)
	..s ActIARCIMDesc=$p(^ARCIM(+ActIARCIMDR,$p(ActIARCIMDR,"||",2),1),"^",2)
	..s ActIQty=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",2)
	..s InstrDR=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",3)
	..s Instr=""
	..s:InstrDR'="" Instr=$p($g(^PHCIN(InstrDR)),"^",2)
	..Do OutputRowGetSkinLinkItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSkinLinkItem
	set Data=$lb($g(ActIARCIMDR),$g(ActIARCIMDesc),$g(ActIQty),ActRowid_"||"_ActIChildsub,InstrDR,Instr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSkinLinkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinLinkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSkinLinkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinLinkItemExecute ]
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

ClassMethod Insert(ActRowid As %String, ArcimRowid As %String, ActQty As %String, InstrDR As %String) As %String
{
    s arcimcode=""
	&sql(select arcim_code into :arcimcode from SQLUSER.arc_itmmast where arcim_rowid=:ArcimRowid)
	q:arcimcode="" "-1"
	zn "dhc-data"
	s rtn=$$Insert^DHCSkinTestConfig(ActRowid,ArcimRowid,ActQty)
	zn "dhc-app"
	i rtn'="" {
		S $p(^OEC("ACT",+rtn,"Item",$P(rtn,"||",2)),"^",3)=InstrDR
		s rtn=0
	}
	q rtn
}

ClassMethod delete(ARCIRowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCSkinTestConfig(ARCIRowid)
	zn "dhc-app"
	q rtn
}

}
