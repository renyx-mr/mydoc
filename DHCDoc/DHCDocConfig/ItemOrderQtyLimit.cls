Class DHCDoc.DHCDocConfig.ItemOrderQtyLimit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query ItemOrderQtyLimitList(ArcimRowid As %String) As %Query(ROWSPEC = "DARCIMRowid:%String,DARCIMARCIMDR:%String,ARCIMDesc:%String,DARCIMMinQty:%String,DARCIMMaxQty:%String,DARCIMShowOEMessage:%String,DARCIMRequireNote:%String,DARCIMNeedSkinTest:%String,DARCIMAlertStockQty:%String,DARCIMIPNeedBillQty:%String,DARCIMPartialValue:%String,DARCIMPartial:%String,DARCIMCanCrossDay:%String,AllowOnlyOnce:%String,DARCIMConflictTypeValue:%String,DARCIMConflictType:%String,AutoInsertONEOrd:%String")
{
}

ClassMethod ItemOrderQtyLimitListExecute(ByRef qHandle As %Binary, ArcimRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TempItemOrderQtyLimitList
	s num=0
	i ArcimRowid'="" d
	.s DARCIMRowid=0
	.f  s DARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowid,DARCIMRowid)) Q:DARCIMRowid=""  d
	..d GetOutPutData(DARCIMRowid)
	e  d
	.s DARCIMRowid=0
    .f  s DARCIMRowid=$O(^DHCItmMast(DARCIMRowid)) Q:DARCIMRowid=""  d
    ..d GetOutPutData(DARCIMRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemOrderQtyLimitList
	Set ^TempItemOrderQtyLimitList(ind)=DARCIMRowid_"^"_DARCIMARCIMDR_"^"_ARCIMDesc_"^"_DARCIMMinQty_"^"_DARCIMMaxQty_"^"_DARCIMShowOEMessage_"^"_DARCIMRequireNote_"^"_DARCIMNeedSkinTest_"^"_DARCIMAlertStockQty_"^"_DARCIMIPNeedBillQty_"^"_DARCIMPartialValue_"^"_DARCIMPartial_"^"_DARCIMCanCrossDay_"^"_DARCIMAllowOnlyOnce_"^"_DARCIMConflictType_"^"_AutoInsertONEOrd
	Set Data=$lb(DARCIMRowid,DARCIMARCIMDR,ARCIMDesc,DARCIMMinQty,DARCIMMaxQty,DARCIMShowOEMessage,DARCIMRequireNote,DARCIMNeedSkinTest,DARCIMAlertStockQty,DARCIMIPNeedBillQty,DARCIMPartialValue,DARCIMPartial,DARCIMCanCrossDay,DARCIMAllowOnlyOnce,DARCIMConflictTypeValue,DARCIMConflictType,AutoInsertONEOrd)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
GetOutPutData(DARCIMRowid)
     s num=num+1
     set DARCIMARCIMDR=$P(^DHCItmMast(DARCIMRowid),"^",1)
     q:'$d(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1))
     set ARCIMDesc=$p(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1),"^",2)
	 Set ARCIMDesc=##class(web.DHCDocUtil).EvalJSON(ARCIMDesc)
     set DARCIMMinQty=$P(^DHCItmMast(DARCIMRowid),"^",2)
     set DARCIMMaxQty=$P(^DHCItmMast(DARCIMRowid),"^",3)
     set DARCIMShowOEMessage=$P(^DHCItmMast(DARCIMRowid),"^",4)
     i DARCIMShowOEMessage="" s DARCIMShowOEMessage="N"
     set DARCIMRequireNote=$P(^DHCItmMast(DARCIMRowid),"^",5)
     i DARCIMRequireNote="" s DARCIMRequireNote="N"
     set DARCIMNeedSkinTest=$P(^DHCItmMast(DARCIMRowid),"^",6)
     i DARCIMNeedSkinTest="" s DARCIMNeedSkinTest="N"
     set DARCIMAlertStockQty=$P(^DHCItmMast(DARCIMRowid),"^",7)
     set DARCIMIPNeedBillQty=$P(^DHCItmMast(DARCIMRowid),"^",8)
     i DARCIMIPNeedBillQty="" s DARCIMIPNeedBillQty="N"
     set DARCIMPartialValue=$P(^DHCItmMast(DARCIMRowid),"^",9)
     i DARCIMPartialValue=0 s DARCIMPartialValue=""
     s DARCIMPartial=""
     i DARCIMPartialValue=1 s DARCIMPartial="一个基本单位"
     i DARCIMPartialValue=2 s DARCIMPartial="半个基本单位"
     i DARCIMPartialValue=3 s DARCIMPartial="无限制"
     set DARCIMCanCrossDay=$P(^DHCItmMast(DARCIMRowid),"^",11)
     //i DARCIMCanCrossDay="" s DARCIMCanCrossDay="N"
     s DARCIMAllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",13)
     i DARCIMAllowOnlyOnce="" s DARCIMAllowOnlyOnce="N"
     s DARCIMConflictTypeValue=$P(^DHCItmMast(DARCIMRowid),"^",14)
     i DARCIMConflictTypeValue="" s DARCIMConflictTypeValue="TW"
     s DARCIMConflictType=$case(DARCIMConflictTypeValue,"OW":"单向","TW":"双向")
     s AutoInsertONEOrd=$P(^DHCItmMast(DARCIMRowid),"^",15)
     //q:num>=219
     d OutputRowItemOrderQtyLimitList
}

ClassMethod ItemOrderQtyLimitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemOrderQtyLimitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemOrderQtyLimitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemOrderQtyLimitListExecute ]
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

/// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).delete("240")
ClassMethod delete(Rowid)
{
    zn "dhc-data"
    s rtn=$$delete^DHCItmMast(Rowid)
    zn "dhc-app"
    q rtn
}

// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).save("1^10338||1^^^N^N^N^^N^^N")

ClassMethod save(str As %String) As %String
{
	s ^tempsave("save")=str
	k PLIST
	s Rowid=$p(str,"^",1)
    s ArcimRowid=$p(str,"^",2)
	zn "dhc-data"
	s find=$$find^DHCItmMast(ArcimRowid)
	if (find=0){
		if (ArcimRowid'=PLIST(2))&&(Rowid'=""){
			zn "dhc-app"
		    q "-1"
		}elseif(Rowid=""){
		  zn "dhc-app"
		  q "-1"
		}
	}
	zn "dhc-app"
	s PLIST(2)=$p(str,"^",2)
    s PLIST(3)=$p(str,"^",3)
    s PLIST(4)=$p(str,"^",4)
    s PLIST(5)=$p(str,"^",5)
    s PLIST(6)=$p(str,"^",6)
    s PLIST(7)=$p(str,"^",7)
    s PLIST(8)=$p(str,"^",8)
    s PLIST(9)=$p(str,"^",9)
    s PLIST(10)=$p(str,"^",10)
    s PLIST(12)=$p(str,"^",11)
    s PLIST(14)=$p(str,"^",12)
    s PLIST(15)=$p(str,"^",13)
    s PLIST(16)=$p(str,"^",14)
	if (Rowid=""){
		//s rtn=$$insert^DHCItmMast()
		//if (rtn>0) s rtn=0
		&sql(insert into SQLUser.DHC_ItmMast values PLIST())
		if SQLCODE=0 q 0
        e  q SQLCODE
	}else{
		s arcim=PLIST(2)
	    s minqty=PLIST(3)
	    s maxqty=PLIST(4)
	    s ShowOEMessage=PLIST(5)
	    s RequireNote=PLIST(6)
	    s NeedSkinTest=PLIST(7)
	    s AlertStockQty=PLIST(8)
	    s IPNeedBillQty=PLIST(9)
	    s PartialValue=PLIST(10)
	    s DARCIMCanCrossDay=PLIST(12)
	    s AllowOnlyOnce=PLIST(14)
	    s DARCIMConflictType=PLIST(15)
	    s AutoInsertONEOrd=PLIST(16)
		//s rtn=$$update^DHCItmMast(Rowid)
		&sql(update SQLUser.DHC_ItmMast
		 set DARCIM_ARCIM_DR=:arcim,DARCIM_MinQty=:minqty,DARCIM_MaxQty=:maxqty,DARCIM_ShowOEMessage=:ShowOEMessage,DARCIM_RequireNote=:RequireNote,DARCIM_NeedSkinTest=:NeedSkinTest,DARCIM_AlertStockQty=:AlertStockQty,DARCIM_IPNeedBillQty=:IPNeedBillQty,DARCIM_PartialValue=:PartialValue
		 ,DARCIM_CanCrossDay=:DARCIMCanCrossDay,DARCIM_AllowOnlyOnce=:AllowOnlyOnce,DARCIM_ConflictType=:DARCIMConflictType,DARCIM_AutoInsertONEOrd=:AutoInsertONEOrd
		 where DARCIM_Rowid=:Rowid )
		q SQLCODE
	}
	//zn "dhc-app"
	q rtn
}

Query ItemConflictList(DARCIMRowid As %String) As %Query(ROWSPEC = "RowID:%String,ITCConflictItmDR:%String,ARCIMDesc:%String,ConflictType:%String")
{
}

ClassMethod ItemConflictListExecute(ByRef qHandle As %Binary, DARCIMRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemConflictList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s ITCChildsub=0 f  s ITCChildsub=$o(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub)) q:ITCChildsub=""  d
	.s ITCConflictItmDR=$p(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub),"^",1)
	.s ARCIMDesc=$p(^ARCIM(+ITCConflictItmDR,$p(ITCConflictItmDR,"||",2),1),"^",2)
	.s ConflictType=$p(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub),"^",2)
	.i ConflictType="R" s ConflictType="反"
	.i ConflictType="F" s ConflictType="畏"
	.s RowID=DARCIMRowid_"||"_ITCChildsub
    .d OutputRowItemConflictList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemConflictList
	Set Data=$lb(RowID,ITCConflictItmDR,ARCIMDesc,ConflictType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ItemConflictListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemConflictListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemConflictListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemConflictListExecute ]
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

ClassMethod deleteConflict(Rowid)
{
    zn "dhc-data"
    s rtn=$$deleteConflict^DHCItmMast(Rowid)
    zn "dhc-app"
    q rtn
}

ClassMethod insertConflict(DARCIMRowid As %String, arcim As %String, ConflictType As %String)
{
	s ^scl("fff")=DARCIMRowid_","_arcim
	k PLIST
	&sql(SELECT * FROM SQLUser.DHC_ItmConflict WHERE ITC_ConflictItm_DR=:arcim and ITC_Parref=:DARCIMRowid)
	q:(SQLCODE=0) "-1"
	s PLIST(0)=DARCIMRowid
	s PLIST(3)=arcim
	s PLIST(4)=ConflictType
    &sql(insert into SQLUser.DHC_ItmConflict values PLIST())
    q SQLCODE
}

Query ItemOrderQtyLimitListExport(num As %String) As %Query(ROWSPEC = "DARCIMRowid:%String,DARCIMARCIMDR:%String,ARCIMDesc:%String,DARCIMMinQty:%String,DARCIMMaxQty:%String,DARCIMShowOEMessage:%String,DARCIMRequireNote:%String,DARCIMNeedSkinTest:%String,DARCIMAlertStockQty:%String,DARCIMIPNeedBillQty:%String,DARCIMPartialValue:%String,DARCIMPartial:%String")
{
}

ClassMethod ItemOrderQtyLimitListExportExecute(ByRef qHandle As %Binary, num As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitList")
	;w ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitListExport","2")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	set DARCIMRowid=$p(^TempItemOrderQtyLimitList(num),"^",1)
	set DARCIMARCIMDR=$p(^TempItemOrderQtyLimitList(num),"^",2)
	set ARCIMDesc=$p(^TempItemOrderQtyLimitList(num),"^",3)
	set DARCIMMinQty=$p(^TempItemOrderQtyLimitList(num),"^",4)
	set DARCIMMaxQty=$p(^TempItemOrderQtyLimitList(num),"^",5)
	set DARCIMShowOEMessage=$p(^TempItemOrderQtyLimitList(num),"^",6)
	set DARCIMRequireNote=$p(^TempItemOrderQtyLimitList(num),"^",7)
	set DARCIMNeedSkinTest=$p(^TempItemOrderQtyLimitList(num),"^",8)
	set DARCIMAlertStockQty=$p(^TempItemOrderQtyLimitList(num),"^",9)
	set DARCIMIPNeedBillQty=$p(^TempItemOrderQtyLimitList(num),"^",10)
	set DARCIMPartialValue=$p(^TempItemOrderQtyLimitList(num),"^",11)
	set DARCIMPartial=$p(^TempItemOrderQtyLimitList(num),"^",12)
	d OutputRowItemOrderQtyLimitList1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemOrderQtyLimitList1
	Set Data=$lb(DARCIMRowid,DARCIMARCIMDR,ARCIMDesc,DARCIMMinQty,DARCIMMaxQty,DARCIMShowOEMessage,DARCIMRequireNote,DARCIMNeedSkinTest,DARCIMAlertStockQty,DARCIMIPNeedBillQty,DARCIMPartialValue,DARCIMPartial)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ItemOrderQtyLimitListExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemOrderQtyLimitListExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemOrderQtyLimitListExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemOrderQtyLimitListExportExecute ]
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

ClassMethod ItemOrderQtyLimitListExport1(num As %String) As %String
{
	q:num="" "{"_"""result"""_":"_""""_""_""""_"}"
	Set Data=$g(^TempItemOrderQtyLimitList(num))
	s Data="{"_"""result"""_":"_""""_Data_""""_"}"
	q Data
}

Query FindConflictType() As %Query(ROWSPEC = "ConflictTypeRowid:%String,ConflictTypeDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","FindConflictType","2")
ClassMethod FindConflictTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	f TypeSeq=1:1:2 d
	.i TypeSeq=1 s ConflictTypeRowid="R",ConflictTypeDesc="反"
	.i TypeSeq=2 s ConflictTypeRowid="F",ConflictTypeDesc="畏"
	.d OutputConflictType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputConflictType
	Set Data=$lb(ConflictTypeRowid,ConflictTypeDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindConflictTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConflictTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindConflictTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConflictTypeExecute ]
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
