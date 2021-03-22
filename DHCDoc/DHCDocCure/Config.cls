Class DHCDoc.DHCDocCure.Config Extends %RegisteredObject
{

ClassMethod getDefaultData(value As %String) As %String
{
	s rtn=$g(^DHCDocConfig(value))
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

Query FindLoc(Loc As %String, CureFlag As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocContactName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindLoc","","1")
ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String, CureFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.q:(CureFlag'="")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(rowid)'=1)
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.if CTContactName="" s CTContactName=CTCode
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Do OutputRowFindLoc
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
	set Data=$lb(rowid,CTDesc,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveLoc(LocId As %String) As %String
{
	Q:LocId="" 100
	i '$d(^DHCDocConfig("DHCDocCureLocRoom",LocId)) s ^DHCDocConfig("DHCDocCureLocRoom",LocId)=""
	q 0
}

ClassMethod DeleteLoc(LocId As %String)
{
	Q:LocId="" 100
	Q:'$D(^DHCDocConfig("DHCDocCureLocRoom",LocId)) 100
	k ^DHCDocConfig("DHCDocCureLocRoom",LocId)
	q 0
}

/// 功能：查询治疗科室
/// 返回：科室名称，科室Rowid
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryCureLoc")
Query QueryCureLoc() As %Query(ROWSPEC = "LocDesc:%String,LocId:%String,LocContactName:%String")
{
}

ClassMethod QueryCureLocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DHCDocCureLocStr=$g(^DHCDocConfig("DHCDocCureLocStr"))
	f i=1:1:$l(DHCDocCureLocStr,"^")  d
	.s CureLocId=$p(DHCDocCureLocStr,"^",i)
	.Q:CureLocId="" 
	.s CTLocDesc=$p(^CTLOC(CureLocId),"^",2)
	.s CTCode=$p($g(^CTLOC(CureLocId)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(CureLocId)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.if CTContactName="" s CTContactName=CTCode
	.Do OutCureLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCureLoc
	set Data=$lb(CTLocDesc,CureLocId,CTContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCureLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCureLocExecute ]
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

ClassMethod QueryCureLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCureLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 功能：查询本科室可以预约的资源
/// 参数：LocID:科室ROWID
/// 返回：资源列表 
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryResource","63")
Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=2

	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s CTCPDR=$p(^RB("RES",RowId),"^",2)
	.Q:CTCPDR="" 
	.Q:'$d(^CTPCP(CTCPDR,1))
	.s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
    .Do OutputResRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputResRow
	set Data=$lb($g(ResDesc),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
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

ClassMethod QueryResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// 2013-01-12
/// tangtao
/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

Query FindCatList() As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCatList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat"))
 	.s:("^"_DHCDocCureItemCatStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

ClassMethod FindCatListBroker()
{
	s qstr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ARCICRowId=rset.Data("ARCICRowId")
			i ARCICRowId="" continue
			s ARCICDesc=rset.Data("ARCICDesc")
			s selected=rset.Data("selected")
			if qstr="" s qstr=ARCICRowId_$c(2)_ARCICDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_ARCICRowId_$c(2)_ARCICDesc_$c(2)_selected
		}
	}
	q qstr
}

ClassMethod FindLocListBroker()
{
	s qstr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindLocList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s LocRowId=rset.Data("LocRowId")
			i LocRowId="" continue
			s LocDesc=rset.Data("LocDesc")
			s selected=rset.Data("selected")
			if qstr="" s qstr=LocRowId_$c(2)_LocDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_LocRowId_$c(2)_LocDesc_$c(2)_selected
		}
	}
	q qstr
}

Query FindLocList() As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindLocList")
	Set repid=$I(^CacheTemp)
	k ^TMP($J,"DocCureFindLocList")
    Set ind=1
    s Desc="" f  s Desc=$o(^CTLOC(0,"Desc",Desc)) q:Desc=""  d
    .s LocRowId=0 f  s LocRowId=$o(^CTLOC(0,"Desc",Desc,LocRowId)) q:LocRowId=""  d
 	..q:'$d(^CTLOC(LocRowId))
 	..s LocDateTo=$p($g(^CTLOC(LocRowId)),"^",25)
	..Q:(LocDateTo'="")&&(LocDateTo<+$H)
 	..s LocDesc=$p(^CTLOC(LocRowId),"^",2)
 	..s selected=0
 	..s DHCDocCureLocStr=$g(^DHCDocConfig("DHCDocCureLocStr"))
 	..s:("^"_DHCDocCureLocStr_"^")[("^"_LocRowId_"^") selected=1
 	..s CTAliasTem=""
	..i $l(LocDesc,"-")>1 s CTAliasTem=$P(LocDesc,"-",1) s LocDesc=$P(LocDesc,"-",2)
	..s CTAlias=$P(^CTLOC(LocRowId),"^",43)
	..i CTAlias="" s CTAlias=CTAliasTem
	..s CTLOCMarkNO=##class(web.DHCINSUPort).GetCNCODE(LocDesc,4,"") ;##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",LocRowId)
	..i CTLOCMarkNO="" s CTLOCMarkNO="999"
    ..s ^TMP($J,"DocCureFindLocList",CTLOCMarkNO,LocRowId)=LocDesc_"^"_selected   //建立临时Globle
	..;Do OutputRowFindLocList
	//按照序号排序
	s seq="" for {
		s seq=$O(^TMP($j,"DocCureFindLocList",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"DocCureFindLocList",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"DocCureFindLocList",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s selected=$P(temp,"^",2)
			d OutputRowFindLocList		
		}
	}

	K ^TMP($J,"DocCureFindLocList")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLocList
	set Data=$lb($g(CTRowId),$g(CTDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

Query FindCardType() As %Query(ROWSPEC = "CardTypeId:%String,CardTypeDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCardType")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s myTypeID=0 f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" s Default=1
	.else  s Default=0
	.Do OutputRowCardType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCardType
	Set Data=$lb(myTypeID,mydes,Default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCardTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCardTypeExecute ]
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

ClassMethod GetPatientIDByNo(PatientNo As %String)
{
	s PatientID=""
	i (PatientNo'="") {
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	}
	Q PatientID
}

ClassMethod GetPatientIDByCardNo(CardNo As %String, cardType As %String = "")
{
	s NewPatientID=""
	i (CardNo'="") {
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0"){
			s NewPatientID=$P(ret,"^",8)
		}
	}
	Q NewPatientID
}

ClassMethod GetCardTypeInfo(myTypeID As %String) As %String
{
	Q:myTypeID="" ""
	Q $g(^DHCCARDTYPEDef(myTypeID))
}

Query FindCureLinkLoc(RowIDLocRowID As %String) As %Query(ROWSPEC = "RowID:%String,LinkLocRowID:%String,LocDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCureLinkLoc","44")
ClassMethod FindCureLinkLocExecute(ByRef QHandle As %Binary, LocRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^tmpnk("FindCureLinkLocExecute")=LocRowID
	s ind=1
	if (LocRowID=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rowid=0 f  s rowid=$o(^DHCDocCureLinkLoci(0,"MAINLOC",LocRowID,rowid)) q:rowid=""  d
	.s LinkLocID=$p(^DHCDocCureLinkLoc(rowid),"^",2)
	.s CTDesc=$p($g(^CTLOC(LinkLocID)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(LinkLocID)),"^",1)
	.s CTContactName=$p($g(^CTLOC(LinkLocID)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.Do OutputRowFindLoc
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
	set Data=$lb(rowid,LinkLocID,CTDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindCureLinkLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindCureLinkLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureLinkLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureLinkLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod insertLinkLoc(MainLocID, LinkLocID)
{
	s ^tmpnk("insertLinkLoc")=MainLocID_"^"_LinkLocID
	if MainLocID="" q "-100"
	if LinkLocID="" q "-100"
	if MainLocID=LinkLocID q "-101"
	if $d(^DHCDocCureLinkLoc(0,"LINKLOC",LinkLocID,MainLocID)) q "-1"
	if '$d(^CTLOC(+LinkLocID)) q "-2"
	s RowID=""
	if RowID=""{
		s obj=##class(User.DHCDocCureLinkLoc).%New()
	}else{
		s obj=##class(User.DHCDocCureLinkLoc).%OpenId(RowID)	
	}
	if $IsObject(obj){
		d obj.DDCLLMainLocDrSetObjectId(MainLocID)
		d obj.DDCLLLinkLocDrSetObjectId(LinkLocID)
		s sc=obj.%Save()
	    If $$$ISERR(sc) Quit "-102"
	    d obj.%Close()
	}
	Q 0
}

ClassMethod deleteLink(RowID)
{
	if RowID="" q "-100"
	&sql(delete SqlUser.DHC_DocCureLinkLoc where DDCLL_RowID=:RowID)
	Q SQLCODE
}

}
