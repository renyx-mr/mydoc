/// 治疗项目设置 操作类
Class DHCDoc.DHCDocCure.CureItemSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询治疗项目子类下的所有治疗项目
Query FindCureItem(ItemCat As %String, ItemDesc As %String) As %Query(ROWSPEC = "Rowid:%String,ItemRowid:%String,ArcimDesc:%String,ActiveFlag:%String")
{
}

ClassMethod FindCureItemExecute(ByRef qHandle As %Binary, ItemCat As %String, ItemDesc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItem")
	s ^TMP("FindCureItem")=ItemCat_"^"_ItemDesc
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if ItemCat="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ItemMast="" f  s ItemMast=$O(^ARCIM(0,"ARCIC_DR",ItemCat,ItemMast)) q:(ItemMast="")  d
 	.s ItemSub="" f  s ItemSub=$o(^ARCIM(0,"ARCIC_DR",ItemCat,ItemMast,ItemSub)) q:(ItemSub="")  d
 	..s ItemRowid=ItemMast_"||"_ItemSub
 	..q:'$d(^ARCIM(ItemMast,ItemSub))
 	..s ArcimDesc=$p($g(^ARCIM(ItemMast,ItemSub,1)),"^",2)
 	..s ArcimDesc=$tr($tr($tr(ArcimDesc,$c(10),""),$c(13),""),"\","")
 	..q:(ItemDesc'="")&&(ArcimDesc'[ItemDesc)
 	..s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ItemRowid,""))
    ..i DDCISRowid'="" s ActiveFlag="是"
    ..else  s ActiveFlag="否"
	..d OutputRowFindCureItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItem
	Set Data=$lb(DDCISRowid,ItemRowid,ArcimDesc,ActiveFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemExecute ]
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

Query FindCureItemCat() As %Query(ROWSPEC = "ItemCatId:%String,ItemCatDesc:%String")
{
}

ClassMethod FindCureItemCatExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItemCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat"))
 	f i=1:1:$l(DHCDocCureItemCatStr,"^")  d
 	.s ARCICRowId=$p(DHCDocCureItemCatStr,"^",i)
 	.q:ARCICRowId=""
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s ARCICDesc=##class(ext.util.String).EvalJSON(ARCICDesc)
	.Do OutputRowFindCureItemCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItemCat
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemCatExecute ]
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

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureRBCServiceGroupSet("^01^针灸组^02/23/2016^")
ClassMethod SaveCureItemSet(str As %String) As %String
{
	n (str)
	s ^TMP("SaveCureItemSet")=str
	Q:str="" -1
	Set DDCISRowid=$P(str,"^")
	Set ItemRowid=$P(str,"^",2)
	Set ShortName=$P(str,"^",3)
	Set ServiceGroupDR=$P(str,"^",4)
	Q:('$D(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR))) -2
	Set AutoAppFlag=$P(str,"^",5)
	Set Effect=$P(str,"^",6)
	Set Indication=$P(str,"^",7)
	Set Avoid=$P(str,"^",8)
	Set ManualApply=$P(str,"^",9)
	Set ApplyExec=$P(str,"^",10)
	K PLIST
	s PLIST(2)=ItemRowid
	s PLIST(3)=ShortName
	s PLIST(4)=ServiceGroupDR
	s PLIST(5)=AutoAppFlag
	s PLIST(6)=Effect
	s PLIST(7)=Indication
	s PLIST(8)=Avoid
	s PLIST(9)=ManualApply
	s PLIST(10)=ApplyExec
	if DDCISRowid="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCureItemSet values :PLIST())
	 	
	}else{
		&sql(update SQLUser.DHC_DocCureItemSet values :PLIST() where DDCIS_Rowid=:DDCISRowid )
	}
	q SQLCODE
}

ClassMethod DeleteCureItemSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureItemSet where DDCIS_Rowid=:Rowid)
	 q SQLCODE
}

/// 取治疗项目的设置信息
/// w ##class(DHCDoc.DHCDocCure.CureItemSet).GetCureItemSet(867)
ClassMethod GetCureItemSet(DDCISRowid As %String, ArcimId As %String) As %String
{
	n (DDCISRowid,ArcimId)
	Quit:ArcimId="" ""
	s ArcimCode=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s Active=1
	if DDCISRowid'="" 
	{
	   s ShortName=$p(^DHCDocCureItemSet(DDCISRowid),"^",2)
	   s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	   s Active=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).CheckServiceGroupActive(ServiceGroupDR)
	   if Active=0 s ServiceGroupDR=""
	   s AutoAppFlag=$p(^DHCDocCureItemSet(DDCISRowid),"^",4)
	   s Effect=$p(^DHCDocCureItemSet(DDCISRowid),"^",5)
	   s Indication=$p(^DHCDocCureItemSet(DDCISRowid),"^",6)
	   s Avoid=$p(^DHCDocCureItemSet(DDCISRowid),"^",7)
	   s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
	   s ApplyExec=$p(^DHCDocCureItemSet(DDCISRowid),"^",9)
	}
	s rtn=ArcimCode_"^"_ArcimDesc_"^"_$g(ShortName)_"^"_$g(ServiceGroupDR)_"^"_$g(AutoAppFlag)_"^"_$g(Effect)_"^"_$g(Indication)_"^"_$g(Avoid)
	s rtn=rtn_"^"_$g(ManualApply)_"^"_$g(ApplyExec)_"^"_$g(Active)
	q rtn
}

/// Desc:保存治疗项目维护的治疗方案信息
/// Input:DDCISPRowid:治疗方案ID,若不含"||",则为新增,否则为更新
/// 	  PlanTitle:方案标题
/// 	  PlanDetail:方案内容
/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemSetPlan(92,1,2)
ClassMethod SaveCureItemSetPlan(DDCISPRowid As %String, PlanTitle As %String, PlanDetail As %String)
{
	Quit:DDCISPRowid="" "-100"
	set myrtn=0
	if $l(DDCISPRowid,"||")>1{
		set PlanObj=##class(User.DHCDocCureItemSetPlan).%OpenId(DDCISPRowid)
	}else{
		set PlanObj=##class(User.DHCDocCureItemSetPlan).%New(DDCISPRowid)
	}
	if $IsObject(PlanObj){
		do PlanObj.DDCISPParRefSetObjectId(DDCISPRowid)
		set PlanObj.DDCISPPlanTitle=PlanTitle
		set PlanObj.DDCISPPlanDetail=PlanDetail
		set sc=PlanObj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-101"
		}
	}else{
		set myrtn="-102"	
	}
	Quit myrtn
}

ClassMethod GetPlanDetailByID(DDCISPRowid As %String)
{
	set PlanObj=##class(User.DHCDocCureItemSetPlan).%OpenId(DDCISPRowid)
	if '$IsObject(PlanObj) Q ""
	set PlanDetail=PlanObj.DDCISPPlanDetail
	Quit PlanDetail
}

ClassMethod DelCureItemSetPlan(DDCISPRowid As %String)
{
	Quit:DDCISPRowid="" "-100"
	set myrtn=0
	&sql(delete SqlUser.DHC_DocCureItemSetPlan where DDCISP_Rowid=:DDCISPRowid)
	Quit SQLCODE
}

Query FindCureItemPlan(DDCISRowid As %String, Query As %String = "") As %Query(ROWSPEC = "PlanTitle:%String,PlanDetail:%String,PlanRowID:%String")
{
}

ClassMethod FindCureItemPlanExecute(ByRef qHandle As %Binary, DDCISRowid As %String, Query As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItemPlan","92")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if DDCISRowid=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK    
	}
    s DDCISPChildSub=0
    for  s DDCISPChildSub=$o(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub)) Q:DDCISPChildSub=""  d
 	.s PlanTitle=$p(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub),"^",1)
 	.s PlanTitle=##class(ext.util.String).EvalJSON(PlanTitle)
 	.s PlanDetail=$p(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub),"^",2)
 	.s PlanDetail=##class(DHCDoc.DHCDocCure.Common).CureEvalJSON(PlanDetail)
 	.if (Query=1)&&($l(PlanDetail)>25) d
 	..s PlanDetail=$e(PlanDetail,1,25)_"..."
 	.s PlanRowID=DDCISRowid_"||"_DDCISPChildSub
	.Do OutputRowFindCureItemPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItemPlan
	set Data=$lb($g(PlanTitle),$g(PlanDetail),PlanRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemPlanExecute ]
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
