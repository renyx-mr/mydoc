Class DHCDoc.DHCDocConfig.RollOrder Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindPrior(value As %String) As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindPriorExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.RollOrder","FindPrior","RollItemPrior")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s selected=0
 	.i value'="" d
 	..s:("^"_$g(^DHCDocConfig(value))_"^")[("^"_OECPRRowId_"^") selected=1
	.Do OutputRowFindPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPriorExecute ]
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

/// RollIPCheckFee
ClassMethod getRollIPCheckFee(value As %String)
{
	s ArcimDesc=""
	s StartDate=""
	s rtn=$g(^DHCDocConfig(value))
	q:rtn="" "{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"
	s ArcimId=$p(rtn,"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s StartDate=$p(rtn,"^",2)
	if (StartDate'=""){
		s DateFormat=##class(websys.Conversions).DateFormat()
		i StartDate["/" {
			if (DateFormat=3) s StartDate=$p(StartDate,"/",3)_"-"_$p(StartDate,"/",2)_"-"_$p(StartDate,"/",1)
		}
		i StartDate["-" {
			if (DateFormat=4) s StartDate=$p(StartDate,"-",3)_"/"_$p(StartDate,"-",2)_"/"_$p(StartDate,"-",1)
		}
		s $p(rtn,"^",2)=StartDate
	}
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"
	q rtn
}

// 

ClassMethod getRollSeasonAddFee(value As %String)
{
	s ArcimDesc=""
	s StartDate=""
	s EndDate=""
	s rtn=$g(^DHCDocConfig(value))
	q:rtn="" "{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"  /2013/6/1
	s ArcimId=$p(rtn,"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s StartDate=$p(rtn,"^",2)
	if (StartDate'=""){
		//s StartDate=$p(StartDate,"/",1)_"-"_$p(StartDate,"/",2)_"-"_$p(StartDate,"/",3)
		s DateFormat=##class(websys.Conversions).DateFormat()
		i StartDate["/" {
			if (DateFormat=3) s StartDate=$p(StartDate,"/",3)_"-"_$p(StartDate,"/",2)_"-"_$p(StartDate,"/",1)
		}
		i StartDate["-" {
			if (DateFormat=4) s StartDate=$p(StartDate,"-",3)_"/"_$p(StartDate,"-",2)_"/"_$p(StartDate,"-",1)
		}
		s $p(rtn,"^",2)=StartDate
	}
	s EndDate=$p(rtn,"^",3)
	if (EndDate'=""){
		//s EndDate=$p(EndDate,"/",1)_"-"_$p(EndDate,"/",2)_"-"_$p(EndDate,"/",3)
		s DateFormat=##class(websys.Conversions).DateFormat()
		i EndDate=$p["/" {
			if (DateFormat=3) s EndDate=$p(EndDate,"/",3)_"-"_$p(EndDate,"/",2)_"-"_$p(EndDate,"/",1)
		}
		i EndDate["-" {
			if (DateFormat=4) s EndDate=$p(EndDate,"-",3)_"/"_$p(EndDate,"-",2)_"/"_$p(EndDate,"-",1)
		}
		s $p(rtn,"^",3)=EndDate
	}
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_ArcimDesc_""""_"}"
	q rtn
}

}
