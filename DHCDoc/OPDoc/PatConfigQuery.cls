Class DHCDoc.OPDoc.PatConfigQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("epr.DHCDocOrderEntry","GetLocICD","1")
/// d ##class(%ResultSet).RunQuery("epr.PrefeencesQuery","FindOETabList")
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIntBill","ordsubcatlookup","","","2")
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIntBill","ordcatlookup","")
/// d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","DiagTemplateDetailList","235")
/// d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","DiagTemplateList","600")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","PatientInfo")
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","ctloclookup","")
/// w ##class(web.DHCDoc.OP.PatConfigQuery).GessCardType("1")
ClassMethod GessCardType(cardValue As %String)
{
	s count=0
	s myTypeID=0
	s myDataFlag=0
	s json="["
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.b ;3
	.q:checkdValue=""
	.s cfRowId=$o(^DHCCARDi("CF",0,"CardNo",checkdValue,""))
	.s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	.i count>0 s json=json_","  
	.s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_""",""myval"":"""_myval_"""}"
	//.s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_"""}"
	.s count=count+1
	q json_"]"
}

// d ##class(DHCDoc.OP.PatientList).CheckCardValue("1","1")

ClassMethod CheckCardValue(cardTypeId As %String, cardValue As %String) As %String [ Private ]
{
	q:( (cardTypeId="") || ('$d(^DHCCARDTYPEDef(cardTypeId))) ) ""
	s ls=^DHCCARDTYPEDef(cardTypeId)
	s len=$p(ls,"^",17)
	for i=$l(cardValue)+1:1:len {
		s cardValue="0"_cardValue
	}
	if '$d(^DHCCARDi("CF",0,"CardNo",cardValue)) s cardValue=""
	q cardValue
}

/// creator:宋春莉
/// date:2016-08-02
/// desc:有效卡列表
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","ReadCardTypeList","12")
Query ReadCardTypeList(cardValue As %String) As %Query(ROWSPEC = "CardTypeDesc:%String,checkdValue:%String,CardTypeValue:%String,DefaultFlag:%String")
{
}

ClassMethod ReadCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod ReadCardTypeListExecute(ByRef qHandle As %Binary, cardValue As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
	;Set repid=$I(^CacheTemp)
	;If $g(ind)="" Set ind=1
	
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	
	
	s ^ml("data")=cardValue
	s myTypeID=0
	s myDataFlag=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.q:checkdValue=""
	.Do OutputRow123
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow123
     s ^tmpscl("data12",ind)=myval
     set Data=$lb(mydes,checkdValue,myval,mySelFlag)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod ReadCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
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

/*ClassMethod GetOPDeptStr(UserId As %String, AdmType As %String) As %String
{
	;w ##class(web.DHCDoc.OP.PatConfigQuery).GetOPDeptStr(298,"O")
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId,AdmType)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		s DepGroupDR=""
		;set DepGroupDR=$P(^CTLOC(RowId),"^",19)
		if (DepGroupDR'="") {
			i '$d(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) {
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=RowId
			}else{
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=CacheTemp($J,"OPRegDepGroup",DepGroupDR)_$C(2)_RowId
			}
		}else {
			set Deptdesc=$p(rset.GetData(2),"-",2)
			if $l(Deptdesc,"-")>1 set Deptdesc=$p(Deptdesc,"-",2)
			set Alias=rset.GetData(3)
			if Alias="" Set Alias=$p(rset.GetData(2),"-",1)
			set ret=rset.GetData(1)_$C(1)_Deptdesc_"-"_Alias  //guorongyong 2008-03-20
			;set ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		    i ret1="" s ret1=ret
		    e  s ret1=ret_"^"_ret1
		    b ;1
		}
	}
	
	i $d(CacheTemp($J,"OPRegDepGroup")) {
		s DepGroupDR=0  f  s DepGroupDR=$O(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) Q:DepGroupDR=""  d
		.Q:'$D(^RBC("DEP",DepGroupDR))
		.s DepGroupDesc=$P(^RBC("DEP",DepGroupDR),"^",2)
		.s LocRowIdStr=CacheTemp($J,"OPRegDepGroup",DepGroupDR)
		.s FirstLocRowId=$P(LocRowIdStr,$C(2),1)
		.s CTAlias=$P(^CTLOC(FirstLocRowId),"^",43)
		.s DepGroupData=LocRowIdStr_$C(1)_DepGroupDesc_"-"_CTAlias
		.i ret1="" s ret1=DepGroupData
		.e  s ret1=ret1_"^"_DepGroupData
		.b ;2
	}
	
	d rset.Close()
	Q ret1
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","GetOPDeptStr",298,"O")
Query GetOPDeptStr(UserId As %String, AdmType As %String) As %Query(ROWSPEC = "ID:%String,DESC:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod GetOPDeptStrExecute(ByRef qHandle As %Binary, UserId As %String, AdmType As %String, Alias As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId,AdmType)
	Set columns = rset.GetColumnCount()
	set row=0
	s ID=""
	s DESC=""
	s Alias=""
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		s DepGroupDR=""
		;set DepGroupDR=$P(^CTLOC(RowId),"^",19)
		if (DepGroupDR'="") {
			i '$d(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) {
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=RowId
			   }
			else{
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=CacheTemp($J,"OPRegDepGroup",DepGroupDR)_$C(2)_RowId
		    	}
		}
		else {
			set Deptdesc=$p(rset.GetData(2),"-",2)
			if $l(Deptdesc,"-")>1 set Deptdesc=$p(Deptdesc,"-",2)
			set Alias=rset.GetData(3)
			if Alias="" Set Alias=$p(rset.GetData(2),"-",1)
			set ID=rset.GetData(1)
			set DESC=Deptdesc
			;set DESC=Deptdesc_Alias
			d OutputRow122
			;set ret=rset.GetData(1)_$C(1)_Deptdesc_"-"_Alias  //guorongyong 2008-03-20
			;set ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		   ; i ret1="" s ret1=ret
		   ; e  s ret1=ret_"^"_ret1
		}
	}
	
	i $d(CacheTemp($J,"OPRegDepGroup")) {
		s DepGroupDR=0  f  s DepGroupDR=$O(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) Q:DepGroupDR=""  d
		.Q:'$D(^RBC("DEP",DepGroupDR))
		.s DepGroupDesc=$P(^RBC("DEP",DepGroupDR),"^",2)
		.s LocRowIdStr=CacheTemp($J,"OPRegDepGroup",DepGroupDR)
		.s FirstLocRowId=$P(LocRowIdStr,$C(2),1)
		.s CTAlias=$P(^CTLOC(FirstLocRowId),"^",43)
		.s DepGroupData=LocRowIdStr_$C(1)_DepGroupDesc_"-"_CTAlias
		.i ret1="" s ret1=DepGroupData
		.e  s ret1=ret1_"^"_DepGroupData
	}
	
	quit $$$OK
	
OutputRow122
	set Data=$lb(ID,DESC,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOPDeptStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPDeptStrExecute ]
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

ClassMethod GetOPDeptStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPDeptStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCOPAdmReg).FindDocMarkStr(600,63)
ClassMethod FindDocMarkStr(UserID As %String, LocID As %String) As %String
{
	s ^Tempzong("FindMarkStr")=UserID_","_LocID
	Q:((UserID="")||(LocID="")) ""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	Q:DocID="" ""
	s Ret=""
	s DHCMarkRowID=0 
	f  s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:DHCMarkRowID=""  d
	.s FindFlag=0
	.s ID="" f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) Q:(ID="")||(FindFlag=1)  d
	..s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
	..i MarkDepId=LocID s FindFlag=1
	.Q:FindFlag=0
	.s ResRowID=$O(^RB("RES",0,"CTPCP",DHCMarkRowID,LocID,0))
	.Q:ResRowID=""
	.s ScheSt=$p(^RB("RES",ResRowID),"^",6)
	.Q:ScheSt'="Y"
	.s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
	.if Ret=""  s Ret=DHCMarkRowID_$C(1)_MarkDesc
	.else  s Ret=Ret_"^"_DHCMarkRowID_$C(1)_MarkDesc
	Q Ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindDocMarkStr",298,"361")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindDocMarkStr",600,63)
Query FindDocMarkStr(UserId As %String, LocID As %String) As %Query(ROWSPEC = "ID:%String,DESC:%String") [ SqlProc ]
{
}

ClassMethod FindDocMarkStrExecute(ByRef qHandle As %Binary, UserID As %String, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	
	s ^Tempzong("FindMarkStr")=UserID_","_LocID
	Q:((UserID="")||(LocID="")) ""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	Q:DocID="" ""
	s Ret=""
	s DHCMarkRowID=0 
	f  s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:DHCMarkRowID=""  d
	.s FindFlag=0
	.s ID="" f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) Q:(ID="")||(FindFlag=1)  d
	..s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
	..i MarkDepId=LocID s FindFlag=1
	.Q:FindFlag=0
	.s ResRowID=$O(^RB("RES",0,"CTPCP",DHCMarkRowID,LocID,0))
	.Q:ResRowID=""
	.s ScheSt=$p(^RB("RES",ResRowID),"^",6)
	.Q:ScheSt'="Y"
	.s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
	.s ID=DHCMarkRowID
	.s DESC=MarkDesc
	.d OutputRow121
	;.if Ret=""  s Ret=DHCMarkRowID_$C(1)_MarkDesc
	;.else  s Ret=Ret_"^"_DHCMarkRowID_$C(1)_MarkDesc
	
	quit $$$OK
	
OutputRow121
	set Data=$lb(ID,DESC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDocMarkStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
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

ClassMethod FindDocMarkStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query PatientInfo(paraAdmType As %String) As %Query(ROWSPEC = "ID:%String,DisplayItem:%String,Code:%String,DisplayNum:%String,ExecuteCode:%String,Style:%String,Link:%String,Operator:%String,OprDate:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod PatientInfoExecute(ByRef qHandle As %Binary, paraAdmType As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="select ID,DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive from SQLUser.DocCFPatientInfo "
	    _"where AdmType='"_paraAdmType_"' "
	    _"ORDER BY DisplayNum"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s ID=resultStr.Data("ID")
		s DisplayItem  = resultStr.Data("DisplayItem")
		s Code = resultStr.Data("Code")
		s DisplayNum = resultStr.Data("DisplayNum")
		s ExecuteCode = resultStr.Data("ExecuteCode")
		s Style = resultStr.Data("Style")
        s Link = resultStr.Data("Link") 
        s Operator  = resultStr.Data("Operator")
		s OprDate = resultStr.Data("OprDate")
		s OprDate=##class(websys.Conversions).DateLogicalToHtml(OprDate)
		s IsActive = resultStr.Data("IsActive")
		s IsActive=$case(IsActive,1:"是","0":"否",:"是")
	    d OutputRow12
	}
	
	quit $$$OK
	
OutputRow12	
	set Data=$lb(ID,DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatientInfoExecute ]
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

ClassMethod PatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.PatConfigQuery","Streamline")
Query Streamline() As %Query(ROWSPEC = "ID:%String,ItemID:%String,ItemName:%String,ItemClick:%String,ConditionalExpre:%String,StrLink:%String,DisplayNum:%String,Operator:%String,OprDate:%String,IsActive:%String,isRefresh:%String") [ SqlProc ]
{
}

ClassMethod StreamlineExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="select ID,ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive,isRefresh from SQLUser.DocCFStreamlineInfo ORDER BY DisplayNum"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s ID=resultStr.Data("ID")
		s ItemID = resultStr.Data("ItemID")
		s ItemName = resultStr.Data("ItemName")
		s ItemClick = resultStr.Data("ItemClick")
		s ConditionalExpre = resultStr.Data("ConditionalExpre")
		s StrLink = resultStr.Data("StrLink")
		s DisplayNum = resultStr.Data("DisplayNum")
        s Operator  = resultStr.Data("Operator")
		s OprDate = resultStr.Data("OprDate")
		s IsActive = resultStr.Data("IsActive")
		s isRefresh = resultStr.Data("isRefresh")
	d OutputRow11
	}
	
	quit $$$OK
	
OutputRow11	
	set Data=$lb(ID,ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive,isRefresh)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod StreamlineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StreamlineExecute ]
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

ClassMethod StreamlineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StreamlineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindOrd","","cs","","","","","")
ClassMethod FindOrdExecute(ByRef qHandle As %Binary, OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Status
{
	;w !,OrdType_","_OrdAlias_","_OrdDesc_","_OrdSubType_","_ArcimRowid_","_AllOrdSets_","_OrdSetsAlias
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	If $g(ind)="" Set ind=1
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(OrdType)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(OrdSubType)
	s OrdNameDesc=$g(OrdDesc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	
	s DepHospID="" ;  $G(%session.Data("LOGON.HOSPID"))
	k ArrArc
	;s DepHospID=##class(web.UDHCHospitalGroup).GetDefHospitalInfoByLocID(DepID)
	//s OrdAliasDesc=$g(OrdAlias)
	;yyx 2009-09-21 查询医嘱套的所有医嘱项
	if AllOrdSets="on" d
	.s ARCosRowID="0"
	.f  s ARCosRowID=$o(^ARCOS(ARCosRowID)) q:ARCosRowID=""  d
	..s Count=0
	..d ..GetAllOrderSetItem(ARCosRowID)
	;yyx 2009-09-21 如果医嘱套的别名不为空，则按照医嘱套的别名查询医嘱项
    s OrdSetsAlias=$$ALPHAUP^SSUTIL4(OrdSetsAlias)
	i OrdSetsAlias'="" d
	.s OrdSetsAlias=OrdSetsAlias
	.s OldOrdSetsAlias=OrdSetsAlias
	.s AliasText=$o(^ARC("ALIAS",0,"Desc",OldOrdSetsAlias),-1)
	.;s LastAlias=LastAlias_" "
	.f  s AliasText=$o(^ARC("ALIAS",0,"Desc",AliasText)) q:(AliasText="")!(AliasText'[OldOrdSetsAlias)  d
	..s ALiasDesc=""
	..f  s ALiasDesc=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc))  q:ALiasDesc=""  d
	...s AliasRowID=""
	...f  s AliasRowID=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc,AliasRowID))  q:AliasRowID=""  d
	....q:$d(^ARC("ALIAS",AliasRowID))=0
	....s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
	....q:AliasType'="ARCOS"
	....s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
	....s Count=0
	....d ..GetAllOrderSetItem(ARCOSRowID)
	
	//s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	if (ORSUBCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	.s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
	..;s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(arcsubcat'=ORSUBCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow,""))
	...s arcitmrow=arcrow_"||"_sub
	...q:arcitmrow=""
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...q:$d(^ARCIM(arcrow,sub))=0
	...s ordname2=$p(^ARCIM(arcrow,sub,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,sub,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,sub,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1) 
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,sub,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",4)
	...s ordcode=$p(^ARCIM(arcrow,sub,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,sub,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow,""))
	...s ORSUBCATRowId=""
	...i ORSUBCATDesc'="" s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	...s arcitmcat=$p(^ARCIM(arcrow,sub,1),"^",10)
	...q:((arcitmcat'=ORSUBCATRowId)&(ORSUBCATRowId'=""))
	...s arcitmrow=arcrow_"||"_sub
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
	.s OrdNameDesc=$g(OrdNameDesc)
	.s id1="0" f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	..s id2="0" f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	...Q:'($d(^ARCIM(id1,id2,1)))
	...s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	...s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s lei=$p(^ARCIM(id1,id2,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s arcitmrow=id1_"||"_id2
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
	...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordExternalCode=""
	...s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
	.k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..;s ^lgl("sbo",id)=arcitmrow
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow  	
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
    .s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
	...q:arcitmrow=""
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)  
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
	..q:$g(ordOnItOwn)="N" 
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
    ...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",  ordExternalCode="",ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow    
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..q:(ordname2'[OrdNameDesc)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow 
	e  if (ArcimRowid'="") do
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .q:$g(ordOnItOwn)="N"
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.;s ordExternalCode=""
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""	
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow 
	//e  do OutputRow 
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow
	set tjob=$j
    if $g(ordname2)="" {
	    set ordExternalCode="" ,ordExternalDesc=""
    }
    s ordname2=##class(web.DHCDocUtil).EvalJSON(ordname2)
    s itmname=##class(web.DHCDocUtil).EvalJSON(itmname)
    s DrgGdesc=##class(web.DHCDocUtil).EvalJSON(DrgGdesc)
    ;set InusTarInfo=##class(web.DHCINSUPort).GetInusTarInfo(TariffDR)
    s InusTarInfo=""
    set InusTarInfo=$case(InusTarInfo,1:"甲",2:"乙",3:"丙","":"")
    if InusTarInfo'="" s itmname="("_InusTarInfo_")"_itmname
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	//Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	
	quit
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj)
{
  s gnum=$o(^TMP("UDHCJFOrdPriceSearch",jj,""),-1)
  q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, num)
{
    
	s str=^TMP("UDHCJFOrdPriceSearch",jj,num)
	q str
}

ClassMethod killdata(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
    
	kill ^TMP("UDHCJFOrdPriceSearch")
}

ClassMethod getpath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod FindOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdExecute ]
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

Query FindOrd(OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Query(ROWSPEC = "TOrdCode:%String,TOrdName:%String,TOrdType:%String,TOrdPrice:%String,TArcim:%String,Titmname:%String,Titmnum:%String,Titmprice:%String,TOrdChildType:%String,TOrdAlias:%String,DrgGdesc:%String,Titmcode:%String,TOrdExternalCode:%String,TOrdExternalDesc:%String,Tjob:%String,TOrdSetName:%String,TARCOSItemQty:%String")
{
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String)
{
   
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	;s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.;d ..GetAllOrderSetItem(+s)
	Q 0
}

ClassMethod GetOrderSetItem(ARCOSRowid As %String, ARCOSDateRowid As %String) As %String
{
	s allQty=0
	s ARCOSPrice=0
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.s Count=Count+1
    .i Count>1 s ARCOSDesc=""
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.;s count=$o(^TMP("ARCOI",$j,""),-1)+1
	.d ..GetArcimInfo(ARCIMRowid)
	Q 0
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String)
{
	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q drow
}

ClassMethod GetArcimInfo(ArcimRowid)
{
	if (ArcimRowid'="") do
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s arcitmrow=ArcimRowid ;add hujunbin 15.2.11
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .;q:$g(ordOnItOwn)="N"  //Hw 2009-09-26
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s ARCOSPrice=ARCOSPrice+(ordprice2*ARCOSItemQty) //Hw 
	.s allQty=allQty+1
	.i ($o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item))="")&&(allQty'=1) s ARCOSDesc=ARCOSPrice
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc="",ARCOSDesc="",ARCOSItemQty=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow1
    Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow1
    
    s OrdAlias1=##class(web.DHCDocUtil).EvalJSON(OrdAlias1)
    //i OrdAlias1["/" b //12
	set tjob=$j
    if $g(ordname2)="" set ordExternalCode="" ,ordExternalDesc=""
    s ordname2=##class(web.DHCDocUtil).EvalJSON(ordname2)
    s itmname=##class(web.DHCDocUtil).EvalJSON(itmname)
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob,ARCOSDesc,ARCOSItemQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)_"^"_$g(ARCOSDesc)_"^"_$g(ARCOSItemQty) //Hw
 	Set ind=ind+1
	quit
}

ClassMethod ValARCItem(ARCIMRowid As %String) As %String
{
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod FindCurrenAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrenAdmExecute(ByRef qHandle As %Binary, Papmino As %String, LocID As %String, UserID As %String) As %Status
{
	s ^RP("Papmino")=Papmino
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	;If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	;If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	If UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s CareId=..GetCareDrByUserID(UserID)
	i CareId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	//s UserID="1335"
	//s LocID="152"
	s AdmType=""
	s index=0
	s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(LocID)
	if IsEmergency="1" s AdmType="E"
	if (AdmType'="E"){
	s rset=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"",+$H,+$H,"","on")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		s index=index+1
		d OutputRow3
	}
	}
	else{
	s rset=##class(%ResultSet).%New("web.DHCDocEmergencyPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"","","","","")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		s index=index+1
		d OutputRow3
	}
		
		}
	d rset.Close()
	d rset.Close()
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(SeqNo,RegNo,AdmID,PatName,PatSex,PatAge,RegDoctor,TimeRange,PAAdmReason,PAAdmDep,PAAdmType,TPoliticalLevel,TSecretLevel,index)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCurrenAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindCurrenAdm","","63","600")
Query FindCurrenAdm(Papmino As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "SeqNo:%String,RegNo:%String,AdmID:%String,PatName:%String,PatSex:%String,PatAge:%String,RegDoctor:%String,TimeRange:%String,PAAdmReason:%String,PAAdmDep:%String,PAAdmType:%String,TPoliticalLevel:%String,TSecretLevel:%String,index:%String")
{
}

ClassMethod GetCareDrByUserID(UserID As %String) As %String
{
	q:UserID="" ""
	s CareId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	q CareId
}

/// w ##class(web.DHCDoc.OP.PatConfigQuery).GetOPDeptStr("O")
ClassMethod GetOPDeptStr(AdmType As %String = "O") As %String
{
	;w ##class(web.DHCDocTransfer).GetOPDeptStr("O")
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDeptList")
	s ret=""
	i AdmType=""  s AdmType="O"
	do rset.Execute(AdmType)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","GetOPDeptStrTransfer","O")
Query GetOPDeptStrTransfer(AdmType As %String = "O") As %Query(ROWSPEC = "ID:%String,DESC:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod GetOPDeptStrTransferExecute(ByRef qHandle As %Binary, AdmType As %String = "O") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDeptList")
	s ret=""
	i AdmType=""  s AdmType="O"
	do rset.Execute(AdmType)
	while (rset.Next()) {
        s ID=rset.GetData(1)
	    s DESC=rset.GetData(2)
	    s Alias=rset.GetData(3)
	    d OutputRow1222
		}
	
	quit $$$OK
	
OutputRow1222
	set Data=$lb(ID,DESC,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOPDeptStrTransferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPDeptStrTransferExecute ]
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

ClassMethod GetOPDeptStrTransferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPDeptStrTransferExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /// w ##class(web.DHCDoc.OP.PatConfigQuery).GetDocStr("")
ClassMethod GetDocStr(DepRowId As %String) As %String
{
	;w ##class(web.DHCDocTransfer).GetDocStr(152)
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDocList")
	s ret=""
	do rset.Execute(DepRowId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_"$c(2)"_rset.GetData(2)
		e  s ret=ret_"$c(1)"_rset.GetData(1)_"$c(2)"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod OPDocListExecute(ByRef qHandle As %Binary, DepRowId As %String, LocID As %String, UserID As %String) As %Status
{
	;lxz去掉不必要的限制出诊type在转诊的时候判断 根据需要排班标志过滤不需要显示所有医生。因为不会有出诊
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s ^yjy(28)=DepRowId
	i DepRowId="" 	Set qHandle=$lb(0,repid,0)	Quit $$$OK
	;s UserID=%session.Get("LOGON.USERID")
	;s LocID=%session.Get("LOGON.CTLOCID")
	i UserID'="" s CareId=..GetCareDrByUserID(UserID)
	i CareId=""   Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.Q:(ScheSt'="Y")  
	.s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime()
	.s AvailAS=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,+$H,"",TRRowId)
	.Q:AvailAS="" 
	.Do OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DocId,DocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","OPDocList","63","63","600")
Query OPDocList(DepRowId As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

/// creator:m马琳
/// date:2016-08-22
/// desc:根据安全组得到开始菜单
/// input:StartTMENU 开始菜单
/// w ##class(web.DHCDoc.OP.PatConfigQuery).GetStartTMENU()
ClassMethod GetStartTMENU(GroupID As %String) As %String
{
	n (GroupID)
	s StartTMENU=""
	s StartWFRowid=##class(epr.GroupSettings).GetStartPage(GroupID)
    s MainMenuRowid=##class(epr.GroupSettings).GetMainMenu(GroupID)
    if (StartWFRowid'="")&(MainMenuRowid'="") {
	    s Obj=##class(websys.WorkFlow).%OpenId(StartWFRowid)
	    ;s FirstItemDesc=$p(Obj.NamesGet(),"|")
	    s WorkFlowItemID=Obj.WorkFlowItems.GetAt(1).ItemGetObjectId()
	    d Obj.%Close()
	    if WorkFlowItemID'="" {
		    s WFIObj=##class(websys.WorkFlowItemDefinition).%OpenId(WorkFlowItemID)
		    s ComponentID=WFIObj.ComponentGetObjectId()
		    s Url=WFIObj.Url
		    d WFIObj.%Close()
		    if ComponentID'="" {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    s WorkFlowID=LMObj.WorkFlowGetObjectId()
				    d LMObj.%Close()
				    ;1.按菜单关联的组件找
				    if ComponentID=LinkComponentID s StartTMENU=LoopMenu_"^"_LinkUrl Q
				    ;2.如菜单未关联组件,按配置的工作流下的组件找
				    if (WorkFlowID'="") {
					    s SubWFObj=##class(websys.WorkFlow).%OpenId(WorkFlowID)
					    s SubFirstWFI=SubWFObj.WorkFlowItems.GetAt(1)
					    if $IsObject(SubFirstWFI) {
					    	if ComponentID=SubFirstWFI.Item.ComponentGetObjectId() s StartTMENU=LoopMenu_"^"_LinkUrl Q
					    }
				    }
			    }
		    }
		    ;w ",StartTMENU1="_StartTMENU_",Url="_Url_",ComponentID="_ComponentID_",MainMenuRowid="_MainMenuRowid
		    if (StartTMENU="")&&(Url'="") {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    d LMObj.%Close()
				    if Url=LinkUrl s StartTMENU=LoopMenu_"^"_LinkUrl Q
			    }
		    }
	    }
    }
    
    Q StartTMENU
    //q "563^opdoc.outpatientlist.csp"
}

ClassMethod GetordersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetordersExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetordersExecute(ByRef qHandle As %Binary, EpisodeID As %String, OrdDesc As %String, CurDataFlag As %String, Lflag As %String, Sflag As %String, User As %String, lulocdes, QueryStartDate As %String = "", QueryEndDate As %String = "", AllowStopOtherLoc As %String = "", LogonLocID As %String, UserRowId As %String, ssgroup As %String) As %Status
{

	Set repid=$I(^CacheTemp)  ;这个是大家公用的?
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s QueryStartDate=$zdh(QueryStartDate,3)
	s QueryEndDate=$zdh(QueryEndDate,3)
	s lulocdes=##class(web.DHCDocUtil).UnEscape(lulocdes)
	s tmpid=##class(DHCDoc.OPDoc.PatConfigQuery).GetAdmOrderC(EpisodeID,OrdDesc,CurDataFlag,Lflag,Sflag,User,lulocdes,QueryStartDate,QueryEndDate,AllowStopOtherLoc,LogonLocID,UserRowId,ssgroup)
	i tmpid<0 Quit $$$OK
	s j=0 f   s j=$o(^mPLIST(tmpid,j)) q:j=""  d
	.s ^CacheTemp(repid,ind)=^mPLIST(tmpid,j)
	.S ind=ind+1
	k ^mPLIST(tmpid)
	Quit $$$OK
}

ClassMethod GetordersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetordersExecute ]
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

/// 新停医嘱界面  医嘱数据读取
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.PatConfigQuery","Getorders","22","","","","","600","","64128","64159","","63","600")
Query Getorders(EpisodeID As %String, OrdDesc As %String, CurDataFlag As %String, Lflag As %String, Sflag As %String, User As %String, lulocdes As %String = "", QueryStartDate As %String = "", QueryEndDate As %String = "", AllowStopOtherLoc As %String = "", LogonLocID As %String, UserRowId As %String, ssgroup As %String) As %Query(ROWSPEC = "seqno:%String,arcdesc:%String,ordtype:%String,oeflag:%String,date:%String,status:%String,qty:%String,reploc:%String,presc:%String,dosage:%String,freq:%String,inst:%String,ordch:%String,sttd:%String,xuserid:%String,xusername:%String,ordlink:%String,usemethod:%String,docloc:%String,exflag:%String,EndDate:%String,EndTime:%String,AddDoc:%String,LabSpec:%String,NurseExecStatus:%String,FirstSttdate:%String,FirstStttime:%String,Notes:%String,index:%String")
{
}

ClassMethod GetAdmOrderC(NowAdm, Arcim, dayflag, longflag, shortflag, user, lulocdes, QueryStartDate, QueryEndDate, AllowStopOtherLoc As %String = "", LogonLocID, UserRowId, ssgroup)
{
	;d ##class(web.UDHCStopOrderLook).GetAdmOrderC(360773,"","on","on","on","590","血液内科医疗单元","","")
	;s ^zhou("GetAdmOrderC")=NowAdm_","_Arcim_","_dayflag_","_longflag_","_shortflag_","_user_","_lulocdes_","_QueryStartDate_","_QueryEndDate
   ; s asv=NowAdm_","_ Arcim_","_dayflag_","_longflag_","_shortflag_","_user_","_lulocdes_","_ QueryStartDate_","_ QueryEndDate_","_ AllowStopOtherLoc_","_LogonLocID_","_UserRowId
	n (NowAdm,Arcim,dayflag,longflag,shortflag,user,lulocdes,QueryStartDate,QueryEndDate,AllowStopOtherLoc,LogonLocID,UserRowId,ssgroup)
	s index=0
	s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
	s CMSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	s CMKLSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedKLItemCat")
	s HospitalCode=$P(Hospital,"^",1)

	//s LogonLocID=%session.Get("LOGON.CTLOCID")
	s LogonLanID="",UserLanguage=""
	//set UserRowId=%session.Get("LOGON.USERID")
	s SSUSRCTLANDR=$p($g(^SSU("SSUSR",UserRowId)),"^",13)
	i SSUSRCTLANDR'=""{
		s LogonLanID=SSUSRCTLANDR
		s UserLanguage=$p(^SS("LAN",SSUSRCTLANDR),"^",1)
	}
	if user="" s user=UserRowId
	
	s luloc=""
	s lulocdes=$g(lulocdes)
	i lulocdes'="" s luloc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(lulocdes),""))  
	i ($g(longflag)="on")!(+$g(longflag)=1) s longflag=1
	e  s longflag=0
	
	i ($g(shortflag)="on")!(+$g(shortflag)=1)  s shortflag=1 
	e  s shortflag=0 
	
	i ($g(dayflag)="on")!(+$g(dayflag)=1)  s dayflag=1,longflag=1,shortflag=1
	e  s dayflag=0

	if QueryStartDate="" s QueryStartDate=+$h
	if QueryEndDate="" s QueryEndDate=+$h

	q:$g(NowAdm)="" -1
	
	s AdmType=$P($g(^PAADM(NowAdm)),"^",2)
	s visstat=$p(^PAADM(NowAdm),"^",20)

	;已经出院结算的患者不能处理医嘱,留观的离院可以停医嘱退费
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(NowAdm)
	i " 1 2 "[(" "_PatCurStat_" ") s IsStayFlag=1
	e  s IsStayFlag=0
	q:(IsStayFlag'=1)&($g(visstat)="D") -1
	s ord="" s ord=$o(^OEORD(0,"Adm",NowAdm,ord)) q:ord="" -1
	
	k ^CacheTemp($j,"StopOrderSpecItem")
	if Arcim'="" d
	.s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d 
	..q:'$d(^OEORD(ord,"I",chl))         ;
	..q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",NowAdm,ord_"||"_chl))     ; 门急诊费用转住院后不允许停医嘱
	..s Arcimid=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	..q:$g(Arcimid)=""
	..s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)       ;医嘱名称
	..q:(Arcim'=ARCimDesc)
	..s MasterOrderDR=""
	..i $d(^OEORD(ord,"I",chl,11)) s MasterOrderDR=$p(^OEORD(ord,"I",chl,11),"^",39)
	..i MasterOrderDR'="" d
	...s ^CacheTemp($j,"StopOrderSpecItem",MasterOrderDR)=""
	...s chl1=0  f  s chl1=$O(^OEORDi(0,"OEORI",ord,MasterOrderDR,chl1)) q:chl1=""  d
	....s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl1)="" 
	..e  d
	...s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl)="" 
	...s chl1=0  f  s chl1=$O(^OEORDi(0,"OEORI",ord,ord_"||"_chl,chl1)) q:chl1=""  d
	....s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl1)=""  

	s i=0
	s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.k UserDR,UserName
	.q:'$d(^OEORD(ord,"I",chl))
	.q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",NowAdm,ord_"||"_chl))     ; 门急诊费用转住院后不允许停医嘱
	.s Arcimid=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	.q:$g(Arcimid)=""
	.q:'$D(^OEORD(ord,"I",chl,3))
	.;
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.q:(QueryStartDate'="")&&(Sttdate<QueryStartDate)
	.q:(QueryEndDate'="")&&(Sttdate>QueryEndDate)
	.;                     
	.s PriorityDR=$p(^OEORD(ord,"I",chl,1),"^",8)              ;医嘱优先级
	.s PriorityCode=""
	.i PriorityDR'="" s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
	.q:(longflag=0)&((PriorityCode="S")!(PriorityCode="OMST"))          ;longflag=0,不保留长期医嘱
	.q:(shortflag=0)&((PriorityCode'="S")&&(PriorityCode'="OMST"))  ;shortflag=0,不保留短期医嘱
	.q:(dayflag=1)&($g(Sttdate)'=+$h)                        ;flag=1时?只保留当天的医嘱
	.s reploc=$p(^OEORD(ord,"I",chl,3),"^",6)                  ;医嘱接收位置
	.Q:((HospitalCode'="SHHSPD")&&(..usersecurity(user,Arcimid,ssgroup)=100))  ;根据默认安全组的开医嘱权限?确定其停医嘱的权限
	.i $g(PriorityDR)'="" s priortycode=$p(^OECPR(PriorityDR),"^",1)
	.s priortycode=$g(priortycode) 
	.q:'$d(^ARCIM($P(Arcimid,"||",1),$P(Arcimid,"||",2),1))   
	.s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)        ;医嘱名称
	.s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.;                                                       
	.s findspecitem=1
	.i $d( ^CacheTemp($j,"StopOrderSpecItem")) d
	..s findspecitem=0
	..i $d( ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl)) s findspecitem=1
	.q:findspecitem=0
	.;
	.;q:(Arcim'="")&(Arcim'=ARCimDesc)
	.q:'$d(^OEORD(ord,"I",chl,1))
	.;
	.s xintmp=$p(^OEORD(ord,"I",chl,1),"^",13)
	.q:$g(xintmp)=""
	.q:'$d(^OEC("OSTAT",xintmp))
	.; 
	.Q:'$d(^OEORD(ord,"I",chl,3))
	.s oeitem=ord_"||"_chl
	.;门诊如果先停医嘱后退费的模式,需要设置可显示的子类   2009.11.13 周志强
	.s PayStatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	.Q:..IsPayCanStopOrder(oeitem)=1
	.;
	.s HourOrderFlag=..HourOrder(oeitem)
	.;;医嘱核实,未核实,停止状态
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)            
	.Q:(oeflag="I")
	.Q:(oeflag="E")
	.Q:(oeflag="U")
	.;//20160512 修改为不允许看下已停止的小时医嘱
	.Q:(oeflag="D") //&&(HospitalCode'="SHHSPD")&&(HourOrderFlag'="1")
	.;  
	.s XUserDR=""
	.i $d(^OEORD(ord,"I",chl,7)) s XUserDR=$p(^OEORD(ord,"I",chl,7),"^",1)                                  ;下医嘱人ID
	.s XUserName=""
	.s:$g(XUserDR)'="" XUserName=$p(^SSU("SSUSR",XUserDR),"^",2)                                 ;下医嘱人的Initials
	.s adduser=$P($G(^OEORD(ord,"I",chl,7)),"^",1)
	.s AddLoc=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	.s AddUserInternalType=..GetCareProvType(adduser)
  	.s StopUserInternalType=..GetCareProvType(user)
  	.q:(StopUserInternalType'=AddUserInternalType)&&(AddUserInternalType'="")
	.s AddLocId=$p($g(^OEORD(ord,"I",chl,7)),"^",2) //科室扩展设置-》医嘱只能本科室停止
	.s OnlyThisDepStopFlag=0
	.s:AddLocId'="" OnlyThisDepStopFlag=$P($G(^CTLOC(AddLocId,"DHC")),"^",14)
	.q:(LogonLocID'=AddLocId)&&(OnlyThisDepStopFlag=1)
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.i $g(Sttdate)'="" s Sttdate=$ZD(Sttdate,3)
	.s Stttime=$p(^OEORD(ord,"I",chl,1),"^",10)
	.i $g(Stttime)'="" s Stttime=$ZT(Stttime,1)
	.s Enddate=$p($g(^OEORD(ord,"I",chl,9)),"^",9)
	.i Enddate'="" s Enddate=$zd(Enddate,4) 
	.s Endtime=$p($g(^OEORD(ord,"I",chl,9)),"^",10)
	.i Endtime'="" s Endtime=$zt(Endtime,3)
	.
	.;长期医嘱首次医嘱的开始日期时间
	.s oeorifillerno=$p($g(^OEORD(ord,"I",chl,9)),"^",12) 
	.i oeorifillerno="" d
	..s FirSttdate=Sttdate
	..s FirStttime=Stttime
	.e  d
	..s FirOeorRowid=$p(oeorifillerno,"!!",1)
	..i FirOeorRowid'="" d
	...s FirSttdate=$p($g(^OEORD($p(FirOeorRowid,"||",1),"I",$p(FirOeorRowid,"||",2),1)),"^",9)
	...s FirSttdate=$ZD(FirSttdate,3)
	...s FirStttime=$p($g(^OEORD($p(FirOeorRowid,"||",1),"I",$p(FirOeorRowid,"||",2),1)),"^",10)
	...i $g(FirStttime)'="" s FirStttime=$ZT(FirStttime,1)
	.;
	.s replocdesc=$p(^CTLOC(reploc),"^",2)
	.i $f(replocdesc,"-")  s replocdesc=$p(replocdesc,"-",2)
	.s freqdesc="",durdesc="",instdesc=""
	.i $D(^OEORD(ord,"I",chl,2)) d                         
	..i $p(^OEORD(ord,"I",chl,2),"^",4)="" s freqdesc=""           
	..e  s freqdesc=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",3)          ;用药频率                
	..i $p(^OEORD(ord,"I",chl,2),"^",6)="" s durdesc=""
	..e  s durdesc=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",3)           ;用药疗程
	..i $p(^OEORD(ord,"I",chl,2),"^",7)="" s instdesc=""
	..e  s instdesc=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)           ;用法
	..i $f(instdesc,"-")  s instdesc=$p(instdesc,"-",2)
	.;
	.s doseuom="",ordtype="",oeflagDesc=""
	.if (UserLanguage="EN") d
	..s ARCimDesc=##class(web.DHCDocOrderCommon).GetForeignName(Arcimid)
	..s doseuomrowid=$p(^OEORD(ord,"I",chl,2),"^",3)
	..s doseuom=##class(web.DHCDocOrderCommon).GetUOMDesc(doseuomrowid,UserLanguage) 
	.s ordtypeid=$p(^OEORD(ord,"I",chl,1),"^",8)
	.i (ordtypeid'="") d
	..s ordtype=$p(^OECPR(ordtypeid),"^",2)
	..s ordtype=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,ordtype)
	.s oeflagid=$p(^OEORD(ord,"I",chl,1),"^",13)
	.i oeflagid'="" d
	..s oeflagDesc=$p(^OEC("OSTAT",oeflagid),"^",2) 
	..s oeflagDesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,oeflagDesc)
	.s durdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,durdesc)
	.s freqdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,freqdesc)
	.s instdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,instdesc)
	.;
	.s locex=..getlocEx(ord,chl,NowAdm)
	.s adddocname=""
	.s adddocrowid=$p(^OEORD(ord,"I",chl,1),"^",11)    //OEORI_Doctor_DR
	.i adddocrowid'="" s adddocname=$P(^CTPCP(adddocrowid,1),"^",2) 
	.;
	.i ($g(arctype)="R") d
	..;w !,"d" ;-------------------------------药物---------------------------------------------------------  
	..s HaveDispensing=0
	..s oeori=ord_"||"_chl
	..d setdruglist()
	. e  d  ;-------------------------------非药物-------------------------------------------
	..s i=i+1
	..s user(i)=adduser
	..s xuserid(i)=$g(XUserDR)
	..s xusername(i)=$g(XUserName) 
	..s locord(i)=$G(AddLoc)
	..s sttd(i)=Sttdate
	..s status(i)=""
	..s arcdesc(i)=ARCimDesc
	..s ordch(i)=ord_"||"_chl                                                    ;医嘱名称
	..s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)                                 ;医嘱序号     
	..s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)                                ;医嘱处方号
	..s enddate(i)=Enddate
	..s endtime(i)=Endtime
	..i $p(^OEORD(ord,"I",chl,1),"^",8)'="" d
	...s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)             ;医嘱优先级代码  
	..e  s ordtype(i)=""
	..s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2)       ;医嘱核实?未核实?停止状态 
	..s date(i)=$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)    						 ;OEORI_Date 下医嘱时间
	..s OEORIOEORIDR(i)=""
	..i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	..q:$d(^OEORD(ord,"I",chl,2))=0 
	..s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)
	..s qty(i)=$p(^OEORD(ord,"I",chl,1),"^",12) 
	..s freq(i)=freqdesc
	..s inst(i)=instdesc
	..s patientsort(i)=$p(^PAADM(NowAdm),"^",2)  //cwg061028
	..s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
	..s usemethod(i)="" 
	.s reploc(i)=replocdesc
	.s adddoc(i)=adddocname
	.s spec(i)=##class(web.DHCOEOrdItem).GetLabSpec(oeitem)
	.;判断是否护士执行状态 1:执行  0:未执行 	2:退回
	.s NurseExecStatus(i)=##class(web.DHCNurCom).IfExecOrder(oeitem)
	.i NurseExecStatus(i)=0 s NurseExecStatus(i)="未执行"
	.i NurseExecStatus(i)=1 s NurseExecStatus(i)="已执行"
	.i NurseExecStatus(i)=2 s NurseExecStatus(i)="已退回"
	.s FirstSttdate(i)=FirSttdate
	.s FirstStttime(i)=FirStttime
	.s Notes(i)=$g(^OEORD(ord,"I",chl,"DEP",1))                                 ;备注 gsb2008-12-1
	.s CMFlag="N"  
	.s CMSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	.s CMKLSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedKLItemCat")
	.if ((("^"_CMSubCategory_"^")[("^"_arctpdr_"^"))&&(CMSubCategory'="")) s CMFlag="Y"
	.if ((("^"_CMKLSubCategory_"^")[("^"_arctpdr_"^"))&&(CMKLSubCategory'="")) s CMFlag="Y"
	.if CMFlag="Y" d
	..if $G(presc(i))'=""  d
	...s PrescRowid=$O(^PAQUE1(0,"PrescNo",$G(presc(i)),""))
	...s Notes(i)=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",21)

	s tmpid=$I(^mPLIST)
	F j=1:1:i d
	.s ret=""
	.s CanStopLoc="Y"
	.if ($G(luloc)'="")&&($G(luloc)'=$G(locord(j))) s CanStopLoc="N"
	.Q:CanStopLoc="N"
	.s ^mPLIST(tmpid,j)=$lb(seqno(j),arcdesc(j),ordtype(j),oeflag(j),date(j),status(j),qty(j),reploc(j),presc(j),dosage(j),freq(j),inst(j),ordch(j),$g(sttd(j)),$g(xuserid(j)),$g(xusername(j)),$g(OEORIOEORIDR(j)),$g(usemethod(j)),$G(docloc(j)),$G(exflag(j)),$g(enddate(j)),$g(endtime(j)),$g(adddoc(j)),$g(spec(j)),$g(NurseExecStatus(j)),$g(FirstSttdate(j)),$g(FirstStttime(j)),$g(Notes(j)),index+1)
    .s index=index+1
	q tmpid
setdruglist()
	s i=i+1
	s dstatus=""
	s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	if $g(dis)'="" {
		/*
		s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2)                       ;INCLB_RowId
		s inci=$p(inclbid,"||",1)
		s qty(i)=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",1)                      ;发药数量       
		s uom(i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2)  ;药品基本库存单位
		*/
		s dis1=0
		f  s dis1=$o(^DHCOEDISQTY(0,"OEORI",oeori,dis1)) q:dis1=""  d
		.s qty(i)=+$g(qty(i))+$p(^DHCOEDISQTY(dis1),"^",2)
		s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		//s qty(i)=$p(^DHCOEDISQTY(dis),"^",2)
		s uom(i)=$p(^DHCOEDISQTY(dis),"^",6)
		if uom(i)'="" s uom(i)=$p(^CT("UOM",uom(i)),"^",2)  ;药品基本库存单位
		s qty(i)=qty(i)_" "_uom(i)
		
		
	}else{
		s qty(i)=""
	}
	s user(i)=adduser
	s locord(i)=$G(AddLoc)
	s sttd(i)=Sttdate
	i dstatus="C" s status(i)="已发"
	i dstatus="TC" s status(i)="未发"
	i dstatus=""  s status(i)="未打包"

	s xuserid(i)=$g(XUserDR)
	s xusername(i)=$g(XUserName) 
	s arcdesc(i)=ARCimDesc
	s OEORIOEORIDR(i)="" 
	i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	s ordch(i)=ord_"||"_chl                                                    ;医嘱名称
	s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)                                 ;医嘱序号     
	s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)                                ;医嘱处方号
	s date(i)=$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)    ;下医嘱时间
	s enddate(i)=Enddate
	s endtime(i)=Endtime
	s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)                                ;用药剂量
	i $p(^OEORD(ord,"I",chl,2),"^",3)'="" s doseuom(i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)          ;剂量单位
	e  s doseuom(i)=""
	s freq(i)=freqdesc             ;用药频率                
	s dur(i)=durdesc               ;用药疗程
	s inst(i)=instdesc             ;用法
	s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)          ;医嘱优先级代码 
	s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2)    ;医嘱核实?未核实?停止状态     
	;s price(i)=$$getprice(inci,sttdate)
	s dosage(i)=dosage(i)_" "_doseuom(i)
	s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
	s usemethod(i)=""
	s spec(i)=""
	Q 0
}

ClassMethod usersecurity(user, Arcimid, sgroup)
{
	i $g(user)="" q -100
	s Arcimid=$p(Arcimid,"||")
	//s ssgroup=%session.Get("LOGON.GROUPID")
	;s ssgroup=$p(^SSU("SSUSR",user),"^",5)
	s ssgroup=sgroup
	s ordcat=$p(^ARC("IC",$p(^ARCIM(Arcimid,1,1),"^",10)),"^",8)
	&sql(select * from SQLUser.SS_GroupOrderCategory where SSORD_ParRef=:ssgroup and SSORD_OrdCat_DR=:ordcat)
	q SQLCODE
}

/// creator:郭荣勇
/// desc:门诊如果退费需要停医嘱,则返回可停标识;对于不需要停医嘱的,在界面不显示并控制不能停止
///      对于先诊疗后收费的模式,药品发药,治疗,材料护士执行视同收费状态
///     住院根据医生站的配置判断
/// date:2013-11-27
/// output:0 可以停止,1 不能停止
ClassMethod IsPayCanStopOrder(oeitem As %String)
{
	;先停医嘱再退费的子类,不用,走退费需停医嘱的配置
	;s CFOPStopPaidItemCat=##Class(web.DHCDocConfig).GetConfigNode("OPStopPaidItemCat")
	;if CFOPStopPaidItemCat'="" s CFOPStopPaidItemCat="^"_CFOPStopPaidItemCat_"^"
	s CFIPStopPaidOrder=##Class(web.DHCDocConfig).GetConfigNode("IPStopPaidOrder")
	
	s myrtn=0
	Q:oeitem="" 0
	s AdmId=$p(^OEORD(+oeitem),"^",1)
	s AdmType=$p(^PAADM(AdmId),"^",2)
	s Arcimid=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),1)),"^",2) 
	s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
	Q:arctpdr="" 0
	;药理实验项目是否直接计费
	s CFEntryOrdBillPad=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("EntryOrdBillPad")
	;药理项目已经收费停医嘱查询能作废和停医嘱
	s PilotProflag=$p($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),"DHC")),"^",10)
	Q:(CFEntryOrdBillPad=1)&&(PilotProflag'="") 0
	
	;门诊已经预结算的医嘱不能作废和停医嘱
	s TPFlag=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByOEORIDR(oeitem)
	Q:(AdmType'="I")&(TPFlag=1) 1
	s OrderBilled=$P($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),3)),"^",5)
	;计费组配置,Return:1!例外子类串 表示需要医生停止医嘱才能退费,0 表示医生不需要停止医嘱就能退费
    s CFOPJFNeedStopStr=##class(web.DHCOPConfig).GetAPPOEFlag()
    s CFOPJFNeedStopFlag=$p(CFOPJFNeedStopStr,"!",1)
    s CFOPJFNeedStopItemCatStr=$p(CFOPJFNeedStopStr,"!",2)
    i CFOPJFNeedStopItemCatStr'="" s CFOPJFNeedStopItemCatStr=$c(2)_CFOPJFNeedStopItemCatStr_$c(2)
    ;留观
    s IsStayFlag=0
    s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
	i " 1 2 "[(" "_PatCurStat_" ") s IsStayFlag=1
	s AsPayFlag=0
	s ReadyToBill=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),12)),"^",26) 
	i (AdmType'="I")&((ReadyToBill="Y")||(IsStayFlag=1))&((..IsDspDrug(oeitem)=1)||(+..IsOrdExec(oeitem)>0)) s AsPayFlag=1
	if (AdmType'="I")&(IsStayFlag'=1)&((OrderBilled="P")||(AsPayFlag=1)) {
		if (CFOPJFNeedStopFlag=0)||((CFOPJFNeedStopFlag=1)&(CFOPJFNeedStopItemCatStr[($c(2)_arctpdr_$c(2)))) s myrtn=1
		s ArcimId=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),1)),"^",2)
		s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
		if (type'="Other")&&(OrderBilled="P") s myrtn=1
	}
	if (AdmType="I")&(OrderBilled="P")&(CFIPStopPaidOrder'="1") s myrtn=1
	//急诊留观患者 收费模式为普通收费模式，已收费医嘱不能停止
	s StayPayMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
	if (StayPayMode=0)&&(IsStayFlag=1)&&(OrderBilled="P") {
		if (CFOPJFNeedStopFlag=0)||((CFOPJFNeedStopFlag=1)&(CFOPJFNeedStopItemCatStr[($c(2)_arctpdr_$c(2)))) s myrtn=1
	}
	;调用计费组接口,如果留观是使用的押金收费的模式,护士执行后不可以停止医嘱
	i (StayPayMode=1)&&(+..IsOrdExec(oeitem)>0)&&(IsStayFlag=1) s myrtn=1
	//---------end----------
	Q myrtn
}

ClassMethod HourOrder(OrderItemRowId)
{
	n (OrderItemRowId)
	s ArcimRowId=$p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1),"^",2)
	s BillUomRowId=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14)
	s BillUomCode=""
	s:+BillUomRowId'=0 BillUomCode=$p($g(^CT("UOM",BillUomRowId)),"^")
	s BillUomCode=$zcvt($g(BillUomCode),"U")
	Q:BillUomCode="HOUR" 1
	Q 0
}

/// 用户的医护人员类别,医生/护士
/// w ##class(web.UDHCStopOrderLook).GetCareProvType(2610)
ClassMethod GetCareProvType(UserID)
{
	q:UserID="" ""
	s DoctorDR=$P(^SSU("SSUSR",UserID),"^",14)
	q:DoctorDR="" ""
	s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
	q:CareProvTypeDR="" ""
	s InternalType=$p($g(^CT("CPT",CareProvTypeDR)),"^",4)
	q InternalType
}

ClassMethod getlocEx(oew, chl, NowAdm) As %String
{
	n (oew,chl,NowAdm,WardNurse,doctor,nurse)
	//原来是处理住院信息项目上特殊使用
	s AddLoc=$p($g(^OEORD(oew,"I",chl,7)),"^",2)
	s DocLoc=""
	i AddLoc'="" s DocLoc=$P(^CTLOC(AddLoc),"^",2)
	if DocLoc["-" s DocLoc=$P(DocLoc,"-",2)
	q $G(DocLoc)_"^"_$G(flag)_"^"_""_"^"_""
	s zycat=0
	s OeorIDr=oew_"||"_chl
	&sql(select PAADM_DepCode_DR,PAADM_CurrentWard_DR into :AdmLoc,:AdmWard from SQLUser.Pa_Adm where paadm_rowid=:NowAdm)
	i AdmWard'="" s WardNurse=$p(^PAWARD(AdmWard),"^",5)
	i $d(^OEORD(oew,"I",chl,1))  d
	.s DoctorDr=$P($G(^OEORD(oew,"I",chl,1)),"^",11)
	s doctor=""
	s nurse=""
	s DocLoc=""
	i $g(DoctorDr)'="" d
	.f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:'$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc))  d
	..s doctor=DocLoc
	..q:AdmLoc=DocLoc
	i $g(doctor)'="" s DocLoc=doctor
	i $g(DoctorDr)="" s DocLoc=$g(WardNurse)
	s flag="N"
	
	q $G(DocLoc)_"^"_$G(flag)_"^"_""_"^"_""
}

/// creator:郭荣勇
/// date:2012-03-31
/// desc:医嘱是否有过发药
/// output:1 有发药;0 没有发药
/// other:
/// w ##class(web.UDHCStopOrderLook).IsDspDrug("599||1")
ClassMethod IsDspDrug(oeitm As %String) As %String
{
	n (oeitm)
	s dstatusFlag=0
	s dis=0 for {
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,dis)) q:dis=""
		s dstatus=""
		if $g(dis)'="" s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		if dstatus="C" s dstatusFlag=1
		q:dstatusFlag=1	
	}
	
	q dstatusFlag
}

/// creator:郭荣勇
/// date:2012-03-31
/// desc:医嘱是否有执行过
/// output:1 有执行;0 没有执行;2 完全执行
/// other:
/// w ##class(web.UDHCStopOrderLook).IsOrdExec("599||1")
ClassMethod IsOrdExec(oeoriId As %String = "")
{
	s retStr=0
	q:(oeoriId="")!(+oeoriId=0)!(+$P(oeoriId,"||",2)=0) retStr
	s oeordId=+$P(oeoriId,"||")
	s oeoriSub=$P(oeoriId,"||",2)
	s ordExecNum=$G(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:((ordExecNum=0)||(ordExecNum="")) retStr
	s oeoreSub=""
	s ordNum=0
	s ordExecNum=0
	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	.s ordNum=ordNum+1
	.s orderStatDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
	.q:orderStatDr=""
	.q:$P($G(^OEC("STAT",orderStatDr)),"^")'="F"
	.s CTPCPDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
	.q:CTPCPDr=""
	.s ordExecNum=ordExecNum+1
	
	i (ordExecNum'=0)&(ordNum'=0) {
		i (ordExecNum=ordNum) s retStr=2
		e  s retStr=1
	}
	
	q retStr
}

/// /---中医诊断证
/// 获取患者对应诊断所对应的证
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.PatConfigQuery","FindSynd","传染科","78||2",63)
Query FindSynd(SynDesc As %String, ICDRowid As %String, CTLoc As %String, MRDiagnoeRowId As %String) As %Query(ROWSPEC = "Num:%String,DSYMDesc:%String,DSYMDr:%String,LinkFlag:%String,index:%String")
{
}

ClassMethod FindSyndExecute(ByRef qHandle As %Binary, SynDesc As %String, ICDRowid As %String, CTLoc As %String, MRDiagnoeRowId As %String) As %Status
{
	s ^tmpScl("FindSynd")=SynDesc_","_ICDRowid_","_CTLoc_","_MRDiagnoeRowId
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Num=1
 	s SynDesc=$tr(SynDesc," ")
 	s SynDesc=$ZCVT(SynDesc,"U")
 	s LenDesc=$L(SynDesc)
 	s RtnHaveSyn="" ;已经选择关联的证
 	s RtnHaveSyn=##class(web.DHCDocDiagnosNew).GetDiaSynd(MRDiagnoeRowId)
 	s index=0
 	if ICDRowid'=""  d
 	.s RowID=0
 	.f  s RowID=$O(^DHCDocSyndLink(0,"MRCICDDX",ICDRowid,RowID)) Q:RowID=""  d
 	..s SyndRowid=$p(^DHCDocSyndLink(RowID),"^",1)
 	..s DescOut=""
 	..i SyndRowid'=""  d
 	...s DescOut=$p($g(^MRC("DSYM",SyndRowid)),"^",2)
 	...s Active=$p($g(^MRC("DSYM",SyndRowid)),"^",7)
 	...Q:Active'="Y"
 	...s StDate=$p($g(^MRC("DSYM",SyndRowid)),"^",5)
 	...Q:(StDate>+$H)&&(StDate'="")
 	...s EnDate=$p($g(^MRC("DSYM",SyndRowid)),"^",6)
 	...Q:(EnDate<+$H)&&(EnDate'="")
 	...s UserLoc=$p($g(^MRC("DSYM",SyndRowid)),"^",3)
 	...Q:(CTLoc'=UserLoc)&&(UserLoc'="")&&(CTLoc'="")
 	...s FlagFind="Y"
 	...i SynDesc'=""  d
 	....s FlagFind="N"
 	....s DescOut2=$E($ZCVT(DescOut,"U"),1,LenDesc)
 	....s:(DescOut2=SynDesc)&&(SynDesc'="") FlagFind="Y"
 	....s SubDr=0
 	....f  s SubDr=$O(^MRC("DSYM",SyndRowid,"ALIAS",SubDr)) Q:(SubDr="")||(FlagFind="Y")  d
 	.....s SubDesc=$G(^MRC("DSYM",SyndRowid,"ALIAS",SubDr))
 	.....Q:SubDesc=""
 	.....s SubDesc1=$E($ZCVT(SubDesc,"U"),1,LenDesc)
 	.....i SubDesc1=SynDesc  d
 	......s FlagFind="Y"
 	...Q:FlagFind'="Y"
 	...s DSYMDesc=DescOut
 	...s DSYMDr=SyndRowid
 	...//Q:("^"_RtnHaveSyn_"^")[("^"_DSYMDr_"^")  ;关联过的在前边输出
 	...s LinkFlag=0
 	...i ("^"_RtnHaveSyn_"^")[("^"_DSYMDr_"^") s LinkFlag=1
 	...s index=index+1
	...Do OutputRowSynd
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSynd
	set Data=$lb(Num,DSYMDesc,DSYMDr,LinkFlag,index)
 	Set ^CacheTemp(repid,ind)=Data
 	s Num=Num+1
 	Set ind=ind+1
	quit
GetDiahaveSys(RtnHaveSyn)
	;先输出已经存在关联
	s RtnLen=$L(RtnHaveSyn,"^")
	for j=1:1:RtnLen
	{	s DSYMDr=$P(RtnHaveSyn,"^",j)
		Continue:DSYMDr=""
		s DSYMDesc=$p($g(^MRC("DSYM",DSYMDr)),"^",2)
		s LinkFlag=1
		//Do OutputRow
	}
	q 1
}

ClassMethod FindSyndFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSyndExecute ]
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

ClassMethod FindSyndClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSyndExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 电子病历显示信息配置相关
Query EMRInfo() As %Query(ROWSPEC = "ID:%String,DisplayItem:%String,DisplayNum:%String,ExecuteCode:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod EMRInfoExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="select ID,DisplayItem,DisplayNum,ExecuteCode,IsActive from SQLUser.DocCFEMRShowInfo ORDER BY DisplayNum"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s ID=resultStr.Data("ID")
		s DisplayItem  = resultStr.Data("DisplayItem")
		s DisplayNum = resultStr.Data("DisplayNum")
		s ExecuteCode = resultStr.Data("ExecuteCode")
		s IsActive = resultStr.Data("IsActive")
	    d OutputRow13
	}
	quit $$$OK
OutputRow13
	set Data=$lb(ID,DisplayItem,DisplayNum,ExecuteCode,IsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EMRInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EMRInfoExecute ]
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

ClassMethod EMRInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EMRInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveEMRInfoDisplay(Str As %String) As %String
{
	s ID=$p(Str,$C(1),1)
	s DisplayItem=$p(Str,$C(1),2)
	s ExecuteCode=$p(Str,$C(1),3)
	if (ID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFEMRShowInfo)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
		&SQL(INSERT INTO SQLUser.DocCFEMRShowInfo (DisplayItem,DisplayNum,ExecuteCode,IsActive) values (:DisplayItem,:DisplayNum,:ExecuteCode,'1'))
	}else{
		&SQL(Update SQLUser.DocCFEMRShowInfo set DisplayItem=:DisplayItem,ExecuteCode=:ExecuteCode WHERE ID=:ID)
	}
	q SQLCODE
}

ClassMethod DelEMRInfoDisplay(ID As %String) As %String
{
	&SQL(delete SQLUser.DocCFEMRShowInfo where ID=:ID)
	q SQLCODE
}

ClassMethod IsActive(ID As %String, IsActive As %String) As %String
{
	s nowdt=+$h
	&SQL(Update SQLUser.DocCFEMRShowInfo set IsActive=:IsActive WHERE ID=:ID)
	q SQLCODE
}

ClassMethod RemoveEMRInfoDisplay(Str As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		&SQL(Update SQLUser.DocCFEMRShowInfo set DisplayNum=:index WHERE ID=:ID)
	}
	Q SQLCODE
}

}
