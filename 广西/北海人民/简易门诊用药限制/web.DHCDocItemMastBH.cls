Class web.DHCDocItemMastBH Extends %RegisteredObject
{

Query ItemOrderQtyList(ArcimRowid As %String, HospId As %String = "") As %Query(ROWSPEC = "DARCIMRowid:%String,DARCIMARCIMDR:%String,ARCIMDesc:%String,DARCIMMaxDay:%String,DARCIMMaxQty:%String,DARCIMMaxQtyUomDr:%String,DARCIMMaxQtyUom:%String")
{
}

ClassMethod ItemOrderQtyListExecute(ByRef qHandle As %Binary, ArcimRowid As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocItemMastBH","ItemOrderQtyList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TempItemOrderQtyLimitList
	s num=0
	i ArcimRowid'="" d
	.s DARCIMRowid=0
	.f  s DARCIMRowid=$O(^DHCItmMastBH("0","ARCIM",ArcimRowid,DARCIMRowid)) Q:DARCIMRowid=""  d
	..d GetOutPutData(DARCIMRowid)
	e  d
	.s DARCIMRowid=0
    .f  s DARCIMRowid=$O(^DHCItmMastBH(DARCIMRowid)) Q:DARCIMRowid=""  d
    ..d GetOutPutData(DARCIMRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemOrderQtyLimitList
	Set ^TempItemOrderQtyLimitList(ind)=DARCIMRowid_"^"_DARCIMARCIMDR_"^"_ARCIMDesc_"^"_DARCIMMaxDay_"^"_DARCIMMaxQty_"^"_DARCIMMaxQtyUomDr_"^"_DARCIMMaxQtyUom
	Set Data=$lb(DARCIMRowid,DARCIMARCIMDR,ARCIMDesc,DARCIMMaxDay,DARCIMMaxQty,DARCIMMaxQtyUomDr,DARCIMMaxQtyUom)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
GetOutPutData(DARCIMRowid)
     s num=num+1
     set DARCIMARCIMDR=$P(^DHCItmMastBH(DARCIMRowid),"^",1)
     q:'$d(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1))
     Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",DARCIMARCIMDR,HospId)="N"
     set ARCIMDesc=$p(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1),"^",2)
	 Set ARCIMDesc=##class(web.DHCDocUtil).EvalJSON(ARCIMDesc)
	 s DARCIMMaxDay=$P(^DHCItmMastBH(DARCIMRowid),"^",2)
     set DARCIMMaxQty=$P(^DHCItmMastBH(DARCIMRowid),"^",3)
     set DARCIMMaxQtyUomDr=$P(^DHCItmMastBH(DARCIMRowid),"^",4)
     s DARCIMMaxQtyUom=""
     s:DARCIMMaxQtyUomDr'="" DARCIMMaxQtyUom=$p($g(^CT("UOM",DARCIMMaxQtyUomDr)),"^",2)
     d OutputRowItemOrderQtyLimitList
}

ClassMethod ItemOrderQtyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemOrderQtyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemOrderQtyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemOrderQtyListExecute ]
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

ClassMethod Save(StrPara As %String, UserId As %String)
{
	k PLIST
	s Rowid=$p(StrPara,"^",1)
    s ArcimRowid=$p(StrPara,"^",2)
    s count=0
    if (Rowid="") {
	    &sql(select count(*) into :count from SQLUser.DHC_Doc_ItemMastBH where DARCIM_ARCIM_DR=:ArcimRowid)
	}else{
		&sql(select count(*) into :count from SQLUser.DHC_Doc_ItemMastBH where DARCIM_ARCIM_DR=:ArcimRowid and DARCIM_Rowid<>:Rowid)
	}
	Q:count'=0 "-1"
	s PLIST(2)=$p(StrPara,"^",2)
    s PLIST(3)=$p(StrPara,"^",3)
    s PLIST(4)=$p(StrPara,"^",4)
    s PLIST(5)=$p(StrPara,"^",5)
    if (Rowid=""){
	    s PLIST(9)=UserId
	    s PLIST(10)=+$h
	    s PLIST(11)=$p($h,",",2)
		&sql(insert into SQLUser.DHC_Doc_ItemMastBH values PLIST())
		if SQLCODE=0 q 0
        e  q SQLCODE
	}else{
		s ArcimRowid=$p(StrPara,"^",2)
		s MaxDay=$p(StrPara,"^",3)
		s MaxQty=$p(StrPara,"^",4)
		s MaxQtyUom=$p(StrPara,"^",5)
		s UpdateUserId=UserId
		s UpdateDate=+$h
		s UpdateTime=$p($h,",",2)
		&sql(update SQLUser.DHC_Doc_ItemMastBH
		 set DARCIM_ARCIM_DR=:ArcimRowid,DARCIM_MaxDay=:MaxDay,DARCIM_MaxQty=:MaxQty,DARCIM_MaxQtyUom=:MaxQtyUom
		 ,DARCIM_UpdateUser_Dr=:UpdateUserId,DARCIM_UpdateDate=:UpdateDate,DARCIM_UpdateTime=:UpdateTime
		 where DARCIM_Rowid=:Rowid )
		q SQLCODE
	}
	q rtn
}

ClassMethod Delete(Rowid)
{
    &sql(delete from SQLUser.DHC_Doc_ItemMastBH where DARCIM_Rowid=:Rowid)
    Q SQLCODE
}

}
