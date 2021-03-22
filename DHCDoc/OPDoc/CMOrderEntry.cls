Class DHCDoc.OPDoc.CMOrderEntry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUpInstr(Desc As %String) As %Query(ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
}

ClassMethod LookUpInstrExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s PHCINRowId=0
 	f  s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""  d
 	.s PHCINDesc2=$p(^PHCIN(PHCINRowId),"^",3)
 	.Q:PHCINDesc2'="饮片"
 	.s PHCINDesc1=$p(^PHCIN(PHCINRowId),"^",2)
 	.s Code=$p(^PHCIN(PHCINRowId),"^",1)
	.Do OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(PHCINRowId,PHCINDesc1,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpInstrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*Query LookUpDuration(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "PHCDURowid:%String,PHCDUDesc,PHCDUCode,PHCDUFactor:%String")
{
	SELECT PHCDU_Rowid,PHCDU_Desc1, PHCDU_Code, PHCDU_Factor
	FROM SQLUser.PHC_Duration
	WHERE   ((PHCDU_Desc1  %STARTSWITH  :desc) or (PHCDU_Factor=:desc)) and PHCDU_Desc2='饮片' 
	ORDER   BY PHCDU_Code
}*/
Query LookUpDuration(Desc As %String) As %Query(ROWSPEC = "PHCDURowid:%String,PHCDUDesc,PHCDUCode,PHCDUFactor:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s PHCDURowId=0
 	f  s PHCDURowId=$o(^PHCDU(PHCDURowId)) q:PHCDURowId=""  d
 	.s PHCDUDesc2=$p(^PHCDU(PHCDURowId),"^",4)
 	.Q:PHCDUDesc2'="饮片"
 	.s PHCDUDesc=$p(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUCode=$p(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$p(^PHCDU(PHCDURowId),"^",2)
	.Do OutputRow9
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(PHCDURowId,PHCDUDesc,PHCDUCode,PHCDUFactor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*Query LookUpFrequence(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "PHCFRDesc,PHCFRCode,PHCFRFactor:%String,PHCFRDays:%String,PHCFRRowid:%String")
{
	SELECT PHCFR_Desc1, PHCFR_Code, PHCFR_Factor,PHCFR_Days,PHCFR_Rowid
	FROM SQLUser.PHC_Freq
	WHERE  (PHCFR_Code=:desc or PHCFR_Desc1  %STARTSWITH  :desc) and (%ALPHAUP PHCFR_Desc2='饮片')
	ORDER   BY PHCFR_Code
}*/
Query LookUpFrequence(Desc As %String) As %Query(ROWSPEC = "PHCFRDesc,PHCFRCode,PHCFRFactor:%String,PHCFRDays:%String,PHCFRRowid:%String")
{
}

ClassMethod LookUpFrequenceExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s PHCFRRowId=0
 	f  s PHCFRRowId=$o(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""  d
 	.s PHCFRDesc2=$p(^PHCFR(PHCFRRowId),"^",4)
 	.Q:PHCFRDesc2'="饮片"
 	.s PHCFRDesc1=$p(^PHCFR(PHCFRRowId),"^",3)
 	.s PHCFRCode=$p(^PHCFR(PHCFRRowId),"^",1)
 	.s PHCFRFactor=$p(^PHCFR(PHCFRRowId),"^",2)
 	.s PHCFRDays=$p(^PHCFR(PHCFRRowId),"^",5)
	.Do OutputRow7
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(PHCFRDesc1,PHCFRCode,PHCFRFactor,PHCFRDays,PHCFRRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpFrequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(DHCDoc.OPDoc.CMOrderEntry).GetCNMedItemPhSpecInstr()

ClassMethod GetCNMedItemPhSpecInstr() As %String
{
	s PhSpecInstrList=":"
	s CNMedItemPhSpecInstr=##class(web.DHCDocConfig).GetConfigNode("CNMedItemPhSpecInstr")
	Q:CNMedItemPhSpecInstr="" PhSpecInstrList
	for i=1:1:$l(CNMedItemPhSpecInstr,"^") d
	.s OneCNMedItemPhSpecInstr=$p(CNMedItemPhSpecInstr,"^",i)
	.s SpecInstrRowid=$p(OneCNMedItemPhSpecInstr,$c(1),1)
	.s SpecInstrDesc=$p(OneCNMedItemPhSpecInstr,$c(1),2)
	.s PhSpecInstrList=PhSpecInstrList_";"_SpecInstrRowid_":"_SpecInstrDesc
	Q PhSpecInstrList
}

// w ##class(DHCDoc.OPDoc.CMOrderEntry).GetCNMedCookMode()

ClassMethod GetCNMedCookMode() As %String
{
	s ret=""
	s CNMedCookModeStr=##Class(web.DHCDocConfig).GetConfigNode("CNMedCookMode")
	f i=1:1:$l(CNMedCookModeStr,"^") d
	.s OneCNMedCookMode=$p(CNMedCookModeStr,"^",i)
	.s CookModeRowid=$p(OneCNMedCookMode,$c(1),1)
	.s CookModeDesc=$p(OneCNMedCookMode,$c(1),2)
	.s oneret=""""_##class(web.DHCDocUtil).EvalJSON(CookModeRowid)_"""" //""""_"CookModeRowid"_""":"""_
	.//s oneret=oneret_","_""""_"CookModeDesc"_""":"""_##class(web.DHCDocUtil).EvalJSON(CookModeDesc)_""""
	.s oneret=oneret_","_""""_##class(web.DHCDocUtil).EvalJSON(CookModeDesc)_""""
	.s oneret="{"_oneret_"}"
	.i ret="" d
	..s ret="["_oneret
	.else  d
	..s ret=ret_","_oneret
	q ret_"]"
}

Query CNMedCookModeList() As %Query(ROWSPEC = "CookModeRowid:%String,CookModeDesc:%String")
{
}

ClassMethod CNMedCookModeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CNMedCookModeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CNMedCookModeListExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s CNMedCookModeStr=##Class(web.DHCDocConfig).GetConfigNode("CNMedCookMode")
	f i=1:1:$l(CNMedCookModeStr,"^") d
	.s OneCNMedCookMode=$p(CNMedCookModeStr,"^",i)
	.s CookModeRowid=$p(OneCNMedCookMode,$c(1),1)
	.s CookModeDesc=$p(OneCNMedCookMode,$c(1),2)
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(CookModeRowid,CookModeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CNMedCookModeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CNMedCookModeListExecute ]
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

Query LookUpOrderPrior(EpisodeType As %String) As %Query(ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
}

ClassMethod LookUpOrderPriorExecute(ByRef qHandle As %Binary, EpisodeType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s CMPriorStr=##Class(web.DHCDocConfig).GetConfigNode("CNMedPrior")
	if CMPriorStr=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s Count=$LENGTH(CMPriorStr,"^")
	For i = 1:1:Count {
		s PriorRowid=$P(CMPriorStr,"^",i)
		s PriorDesc=$P(^OECPR(PriorRowid),"^",2)
		s PriorCode=$P(^OECPR(PriorRowid),"^",1)
		if (EpisodeType'="I")&&(PriorCode'="NORM") continue
		if (EpisodeType="I")&&(PriorCode="NORM") continue
		d OutputRowPrior
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPrior
	set Data=$lb(PriorRowid,PriorDesc,PriorCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpOrderPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpOrderPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
