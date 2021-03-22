Class DHCDoc.DHCDocConfig.Diagnose Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetDiagnos(DiagnosCode As %String, DiagnosDesc As %String) As %Query(ROWSPEC = "MRCIDRowId:%String,MRCIDCode:%String,MRCIDICD10CMCode:%String,MRCIDICD9Map:%String,MRCIDDesc:%String,MRCIDAlternateDesc:%String,MRCIDSexDR:%String,MRCIDSex:%String,MRCIDDateActiveFrom:%String,CPWRowId:%String,CPWdesc:%String")
{
}

ClassMethod GetDiagnosExecute(ByRef qHandle As %Binary, DiagnosCode As %String, DiagnosDesc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Diagnose","GetDiagnos")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i DiagnosCode'="" s DiagnosCode=$ZCVT(DiagnosCode,"U") //$$ALPHAUP^SSUTIL4(DiagnosCode)
	s MRCIDRowId=0 
	f  s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""  d
	.s MRCIDCode=$p(^MRC("ID",MRCIDRowId),"^",1)
	.q:(DiagnosCode'="")&&($ZCVT(MRCIDCode,"U")'[DiagnosCode)
	.s MRCIDICD10CMCode=$p(^MRC("ID",MRCIDRowId),"^",4)
	.s MRCIDICD9Map=$p(^MRC("ID",MRCIDRowId),"^",35)
	.s MRCIDDesc=$p(^MRC("ID",MRCIDRowId),"^",2)
	.q:(DiagnosDesc'="")&&(MRCIDDesc'[DiagnosDesc)
	.q:(DiagnosDesc'="")&&(MRCIDDesc="")
	.s MRCIDAlternateDesc=$p(^MRC("ID",MRCIDRowId),"^",37)
	.s MRCIDSexDR=$p(^MRC("ID",MRCIDRowId),"^",10)
	.s MRCIDSex=""
	.s:MRCIDSexDR'="" MRCIDSex=$p(^CT("SEX",MRCIDSexDR),"^",2)
	.s MRCIDDateActiveFrom=$p(^MRC("ID",MRCIDRowId),"^",6)
	.s:MRCIDDateActiveFrom'="" MRCIDDateActiveFrom=$zd(MRCIDDateActiveFrom,4)
	.s CPWRowId=$P($G(^MRC("ID",MRCIDRowId,"DHC")),"^",1)
	.s CPWdesc="",CPWcode=""
    .if (CPWRowId'="")&&($d(^MRC("CPW",CPWRowId))) d
    ..s CPWdesc=$P(^MRC("CPW",CPWRowId),"^",2)
    ..s CPWcode=$P(^MRC("CPW",CPWRowId),"^",1)
	.Do OutputRowGetDiagnos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnos
	set Data=$lb($g(MRCIDRowId),$g(MRCIDCode),$g(MRCIDICD10CMCode),$g(MRCIDICD9Map),$g(MRCIDDesc),$g(MRCIDAlternateDesc),$g(MRCIDSexDR),$g(MRCIDSex),$g(MRCIDDateActiveFrom),$g(CPWRowId),$g(CPWdesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosExecute ]
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

Query GetCTSex() As %Query(ROWSPEC = "CTSEXRowId:%String,CTSEXDesc:%String")
{
}

ClassMethod GetCTSexExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Diagnose","GetCTSex")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s CTSEXRowId=0  
	f  s CTSEXRowId=$o(^CT("SEX",CTSEXRowId)) q:CTSEXRowId=""  d
	.s CTSEXDesc=$p(^CT("SEX",CTSEXRowId),"^",2)
	.s CTSEXDateFrom=$p(^CT("SEX",CTSEXRowId),"^",4)
	.s CTSEXDateTo=$p(^CT("SEX",CTSEXRowId),"^",5)
	.q:(CTSEXDateFrom'="")&&(CTSEXDateFrom>+$h)
	.q:(CTSEXDateTo'="")&&(CTSEXDateTo<=+$h)
	.Do OutputRowGetCTSex
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTSex
	set Data=$lb($g(CTSEXRowId),$g(CTSEXDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTSexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTSexExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTSexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTSexExecute ]
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

Query GetDiagnosPathWay() As %Query(ROWSPEC = "CTSEXRowId:%String,CTSEXDesc:%String")
{
}

ClassMethod GetDiagnosPathWayExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Diagnose","GetDiagnosPathWay")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s rowid=0  f  s rowid=$O(^MRC("CPW",rowid)) Q:rowid=""  d  
	.s cnt=cnt+1
	.s desc=$P(^MRC("CPW",rowid),"^",2)
	.s code=$P(^MRC("CPW",rowid),"^",1)
	.Do OutputRowGetDiagnosPathWay
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnosPathWay
	set Data=$lb($g(rowid),$g(desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosPathWayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosPathWayExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosPathWayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosPathWayExecute ]
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

/// w ##class(DHCDoc.DHCDocConfig.Diagnose).save("26289","jhmcs01!L0000!!jhmcs01!!1!29/09/2015!")
ClassMethod save(RowID As %String, Str As %String) As %String
{
  K PLIST(1)
  s PLIST(2) = $p(Str,"!",1) //Code
  s PLIST(3) = $p(Str,"!",4) //Description
  s PLIST(6) = $p(Str,"!",2) //ICD10Code
  s PLIST(37) = $p(Str,"!",3) //ICD9Code
  s PLIST(39) = $p(Str,"!",5) //LongDescription
  s FromDateNum=$p(Str,"!",7)
  i FromDateNum["-" s FromDateNum=$zdh(FromDateNum,3)
  i FromDateNum["/" s FromDateNum=$zdh(FromDateNum,4)
  i FromDateNum=""  s FromDateNum=+$h
  s PLIST(8) =FromDateNum
  s PLIST(12) = $p(Str,"!",6) //SexRowid
  s PLIST(15) = "N"
  s PLIST(16) = "N"
  s PLIST(17) = "N"
  s PLIST(19) = "N"
  s CPWRowId=$p(Str,"!",8)
  TS
  if (RowID=""){
	  &sql(INSERT INTO SQLUser.MRC_ICDDx VALUES :PLIST())
  }else{
	  &sql(UPDATE SQLUser.MRC_ICDDx VALUES :PLIST() WHERE MRCID_RowId=:RowID)
  }
  if (SQLCODE=0){
	  s ICDRowId=$p(%ROWID,$c(1))
	  s $P(^MRC("ID",ICDRowId,"DHC"),"^",1)=CPWRowId
	  TC
  }else{
	  TROLLBACK
  }
  q SQLCODE
}

ClassMethod delete(RowId As %String) As %String
{
	s RowId=$g(RowId)
    &sql(DELETE FROM SQLUser.MRC_ICDDx WHERE MRCID_RowId = :RowId)
    q SQLCODE
}

Query GetDiagnosAlias(MRCIDRowId As %String) As %Query(ROWSPEC = "ALIASRowID:%String,ALIASText:%String")
{
}

ClassMethod GetDiagnosAliasExecute(ByRef qHandle As %Binary, MRCIDRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Diagnose","GetDiagnosAlias")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ALIASChildsub=0
    f  s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""  d
    .s ALIASText=$p(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub),"^",1)
    .s ALIASRowID=MRCIDRowId_"||"_ALIASChildsub
	.Do OutputRowGetDiagnosAlias
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnosAlias
	set Data=$lb(ALIASRowID,ALIASText)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosAliasExecute ]
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

ClassMethod saveAlias(MRCIDRowId As %String, RowID As %String, Alias As %String) As %String
{
  KILL PLIST
  s PLIST(0) =MRCIDRowId
  s PLIST(3) = Alias
  TS
  if (RowID=""){
	  &sql(INSERT INTO SQLUser.MRC_ICDAlias VALUES :PLIST())
  }else{
	  &sql(UPDATE SQLUser.MRC_ICDAlias VALUES :PLIST() WHERE ALIAS_RowId=:RowID)
  }
  if (SQLCODE=0){
	  TC
  }else{
	  TROLLBACK
  }
  q SQLCODE
}

ClassMethod deleteAlias(RowId As %String) As %String
{
	s RowId=$g(RowId)
    &sql(DELETE FROM SQLUser.MRC_ICDAlias WHERE ALIAS_RowId = :RowId)
    q SQLCODE
}

}
