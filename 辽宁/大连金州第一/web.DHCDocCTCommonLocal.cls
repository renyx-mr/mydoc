Class web.DHCDocCTCommonLocal Extends %RegisteredObject
{

ClassMethod GetArcItemDepProcNote()
{
	s CTDefineDr=##class(User.DHCDocCTDefine).GetIdByCode("1")
}

ClassMethod QryArcItemDepProcNoteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcItemDepProcNoteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocCTCommonLocal","QryArcItemDepProcNote","")
ClassMethod QryArcItemDepProcNoteExecute(ByRef qHandle As %Binary, ArcItemDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s CTDefineDr=##class(User.DHCDocCTDefine).GetIdByCode("COVID")
	if (CTDefineDr'=""){
		s ChildSub=0
		for{
			s ChildSub=$o(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub))
			q:ChildSub=""
			; "ALL^2123^^"
			s StartDate=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",4)
			continue:((StartDate'="")&&(StartDate>+$h))
			s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",5)
			continue:((EndDate'="")&&(EndDate<=+$h))
			s ConfigArcItemStr=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",1)
			continue:(ConfigArcItemStr'="ALL")&&(((","_ConfigArcItemStr_",")'[(","_+ArcItemDr_",")))
			s ArcItemDepProcNote=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",2)
			do OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(ArcItemDepProcNote)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryArcItemDepProcNoteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcItemDepProcNoteExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QryArcItemDepProcNote(ArcItemDr As %String = "") As %Query(ROWSPEC = "ArcItemDepProcNote:%String:医嘱备注")
{
}

}
