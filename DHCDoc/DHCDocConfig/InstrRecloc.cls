Class DHCDoc.DHCDocConfig.InstrRecloc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->用法关联接受科室设置 根据用法查询关联接受科室
Query GetInstrLinkRecLoc(InstrRowId As %String) As %Query(ROWSPEC = "InstrRecLocRowid:%String,OrdDep:%String,RecLoc:%String,Default:%String,OrdSubCat:%String,OrdSubCatDesc:%String,OrdPrior:%String,OrdPriorDesc:%String,OrdTimeRangeFrom:%String,OrdTimeRangeTo:%String,HospitalDesc:%String")
{
}

ClassMethod GetInstrLinkRecLocExecute(ByRef qHandle As %Binary, InstrRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetInstrLinkRecLoc",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    //q:InstrRowId="" ""
	s InstrRecLocSub=0 
	f  s InstrRecLocSub=$o(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)) q:InstrRecLocSub=""  d
    .s OrdDep=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",1)
    .s:OrdDep'="" OrdDep=$p(^CTLOC(OrdDep),"^",2)
	.s RecLoc=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",2)
	.s:RecLoc'="" RecLoc=$p(^CTLOC(RecLoc),"^",2)
	.s Default=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",3)
	.i Default="1" s Default="Y"
	.e  s Default="N"
	.s OrdSubCat=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",4)
	.s OrdSubCatDesc=""
	.s:OrdSubCat'="" OrdSubCatDesc=$p(^ARC("IC",OrdSubCat),"^",2)
	.s OrdPrior=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",5)
	.s OrdPriorDesc=""
	.s:OrdPrior'="" OrdPriorDesc=$p(^OECPR(OrdPrior),"^",2)
	.s OrdTimeRange=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",6)
	.s OrdTimeRangeFrom=$p(OrdTimeRange,"~",1)
	.s OrdTimeRangeTo=$p(OrdTimeRange,"~",2)
	.s HospitalRowid=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",7)
	.s HospitalDesc=""
	.i HospitalRowid'="" s HospitalDesc=$p($g(^CT("HOSP",HospitalRowid)),"^", 2)
	.s InstrRecLocRowid=InstrRowId_"||"_InstrRecLocSub
	.Do OutputRowGetInstrLinkRecLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetInstrLinkRecLoc
	set Data=$lb($g(InstrRecLocRowid),$g(OrdDep),$g(RecLoc),$g(Default),$g(OrdSubCat),$g(OrdSubCatDesc),$g(OrdPrior),$g(OrdPriorDesc),$g(OrdTimeRangeFrom),$g(OrdTimeRangeTo),$g(HospitalDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetInstrLinkRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrLinkRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstrLinkRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrLinkRecLocExecute ]
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
/// desc:医生站设置程序->用法关联接受科室设置 查询接受科室
Query GetOrdDep() As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String")
{
}

ClassMethod GetOrdDepExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetOrdDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s CTLOCRowID=0 
	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
    .s CTLOCDesc=$p(^CTLOC(CTLOCRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(CTLOCRowID),"^",13)
    .q:(CTLOCType'="E")&&(CTLOCType'="W")
    .s CTLocContactName=$P(^CTLOC(CTLOCRowID),"^",43)
    .s CTLOCDesc=CTLocContactName_" "_CTLOCDesc
	.Do OutputRowGetOrdDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOrdDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOrdDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdDepExecute ]
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
/// desc:医生站设置程序->用法关联接受科室设置查询医院列表
Query GetCTHospital() As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String")
{
}

ClassMethod GetCTHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetCTHospital")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s HOSPRowId=0 
	f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""  d
    .s HOSPDesc=$p(^CT("HOSP",HOSPRowId),"^",2)
	.Do OutputRowGetCTHospital
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTHospital
	set Data=$lb($g(HOSPRowId),$g(HOSPDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTHospitalExecute ]
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

ClassMethod Insert(InstrRowId As %String, RecLocStr As %String) As %String
{
	n (InstrRowId,RecLocStr)
	i (InstrRowId'="")&&(RecLocStr'=""){
		s OrdDep=$p(RecLocStr,"!",1)
		s RecLoc=$p(RecLocStr,"!",2)
		s Default=$p(RecLocStr,"!",3)
		s OrdSubCat=$p(RecLocStr,"!",4)
		s OrdPrior=$p(RecLocStr,"!",5)
		s OrdTimeRange=$p(RecLocStr,"!",6)
		s Hospital=$p(RecLocStr,"!",7)
		Set $ZT="ERROR^DHCSSERR"
		TS
      &sql(insert into SQLUser.DHC_PHCInstrRecLoc (Instr_RecLoc_ParRef,Instr_OrdDep,Instr_RecLoc,Instr_Default,Instr_OrdSubcat,Instr_OrdPrior,Instr_TimeRange,Instr_Hospital_DR) values(:InstrRowId,:OrdDep,:RecLoc,:Default,:OrdSubCat,:OrdPrior,:OrdTimeRange,:Hospital))
		TC
		s InstrRecLocRowId=%ROWID
   }
		q SQLCODE
}

ClassMethod Delete(InstrRecLocRowid) As %String
{
	n (InstrRecLocRowid) 
	q:InstrRecLocRowid="" 1
    &sql(delete from SQLUser.DHC_PHCInstrRecLoc where (RowID=:InstrRecLocRowid))
	q SQLCODE
}

}
