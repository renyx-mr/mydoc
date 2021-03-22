Class DHCDoc.DHCDocConfig.ArcItemConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->补录医嘱设置 查询所有医嘱项目
Query FindAllItem(Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary, Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ArcItemConfig","FindAllItem","lhn",1,0)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias="")&&(StopAfterLongOrder="")&&(NotAutoStop=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	k TempARCMList($j)
	s count=0
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d rs1.Execute(Alias)
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		continue:($d(TempARCMList($j,ArcimID)))
		s ARCIMType=rs1.GetData(4)
		continue:ARCIMType="ARCOS"
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s selected=0,TempARCMList($j,ArcimID)=1
		d OutputRowFindAllItem
		s count=count+1
		if (count>1000){
			q
		}
	}
	if (StopAfterLongOrder=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("StopAfterAllLongOrder",ArcimID)) q:ArcimID=""  d
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.d OutputRowFindAllItem
	}
	if (NotAutoStop=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("NotAutoStopLongOrder",ArcimID)) q:ArcimID=""  d
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.d OutputRowFindAllItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	Set Data=$lb(ArcimID,ArcimDesc,selected)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
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

// $g(^DHCDocConfig("ContinuousOxygenItem"))

ClassMethod getDefaultData(value As %String)
{
	s rtn=$g(^DHCDocConfig(value))
	s ArcimDesc=""
	i rtn'="" s ArcimDesc=$p(^ARCIM(+rtn,$p(rtn,"||",2),1),"^",2)
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"
	q rtn
}

// $g(^DHCDocConfig("ContinuousOxygenItem"))

ClassMethod getLabBloodFeeData(value As %String, HospId As %String)
{
	if ($g(^DHCDocConfig("UseHospSepLabConfig"))=1)&&(HospId="") s HospId=$g(^DHCDocConfig("MainHospital"))
	if (HospId=""){
		s rtn=$g(^DHCDocConfig(value))
	}else{
		s rtn=$g(^DHCDocConfig(value,HospId))
	}
	//s rtn=$g(^DHCDocConfig(value))
	s ArcimDesc=""
	i rtn'="" s ArcimDesc=$p(^ARCIM(+rtn,$p(rtn,"||",2),1),"^",2)
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"
	q rtn
}

}
