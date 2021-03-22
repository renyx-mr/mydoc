/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 医生站配置界面公共方法
Class DHCDoc.DHCDocConfig.CommonFunction Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","FindMasterItem","")
Query FindMasterItem(arcimdesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s Flag=0
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 Do OutputRow5
	..//s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..//q:AlisDR=""
	..//s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..//s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..//s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..//q:ArcimDesc'[arcimdesc
	..//Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询代码表外部对照类型
/// IN  : 
/// OUT : 
/// TABL: DHCDoc_CT_ExtDataType
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryExtDataType")
Query QueryExtDataType() As %Query(ROWSPEC = "TCTEDTRowId:%String,TCTEDTCode:%String,TCTEDTDesc:%String,TCTEDTClassName:%String,TCTEDTQueryName:%String,TCTEDTActive:%String")
{
}

ClassMethod QueryExtDataTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s CTEDTRowId="" for {
		set CTEDTRowId=$o(^DHCDOCCTEDT("CTEDT",CTEDTRowId)) quit:CTEDTRowId=""
		s CTEDTCode=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",1)
		s CTEDTDesc=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",2)
		s CTEDTClassName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",3)
		s CTEDTQueryName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",4)
		s CTEDTActive=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",5)
		continue:CTEDTActive'="Y"
		i CTEDTActive="Y" s CTEDTActive="是"
		e  s CTEDTActive="否"
		d OutputRow2
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2     
	set Data=$lb(CTEDTRowId,CTEDTCode,CTEDTDesc,CTEDTClassName,CTEDTQueryName,CTEDTActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryExtDataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
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

ClassMethod QueryExtDataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpCTLoc","zxy")
Query LookUpCTLoc(desc As %Library.String) As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,CTLOC:%String,ContactName:%String")
{
}

ClassMethod LookUpCTLocExecute(ByRef qHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s CTLocId=0
	s desc=$zcvt(desc,"U")
	S ^PENG("desc")=desc
	for {
		s CTLocId=$O(^CTLOC(CTLocId)) Q:CTLocId=""
		s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
		s CTLocContactName=$P(^CTLOC(CTLocId),"^",43)
		s ContactName=CTLocContactName_"-"_CTLocDesc
		//continue:((desc'="")&&(CTLocDesc'[desc))
		continue:##class(web.DHCOPAdmReg).CheckLocDesc(CTLocId,desc)'=1 
		s flagO=$d(^PAC("ADMLOC",0,"AdmType","O",CTLocId))
		s flagE=$d(^PAC("ADMLOC",0,"AdmType","E",CTLocId))
		d OuputRow111
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow111
	set Data=$lb(CTLocId,CTLocDesc,ContactName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpCTLocFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCTLocExecute ]
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

ClassMethod LookUpCTLocClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCTLocFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询用户
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpUser","王")
Query LookUpUser(desc As %Library.String) As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,USER:%String")
{
}

ClassMethod LookUpUserExecute(ByRef qHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*
	i desc=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}*/
	
	s USERID=0
	s desc=$zcvt(desc,"U")
	for {
		s USERID=$O(^SSU("SSUSR",USERID)) Q:USERID=""
		s USERIDNAME=$p(^SSU("SSUSR",USERID),"^",2)
		// 判断是否医生
		s CTCareProv9=$p(^SSU("SSUSR",USERID),"^",9)
		s CTCareProv14=$p(^SSU("SSUSR",USERID),"^",14)
		continue:((CTCareProv9="")&&(CTCareProv14=""))
		s SSUSRInitials=$p(^SSU("SSUSR",USERID),"^",1)
		;continue:((desc'="")&&($zcvt(USERIDNAME,"U")'[desc)&&($zcvt(SSUSRInitials,"U")'[desc))	
		d OuputRow222
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow222
	set Data=$lb(USERID,USERIDNAME)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpUserFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUserExecute ]
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

ClassMethod LookUpUserClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUserFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-22
/// DESC: 取医嘱模版数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetOETabItems("User.CTLoc",7,"")
ClassMethod GetOETabItems(objtype As %String, objvalue As %String, Key As %String = "") As %String
{
	n (objtype,objvalue,Key)
	s ^tempscl("GetOETabItems")=objtype_","_objvalue_","_Key
	s i=1
	k ^GetOETabItems("ORDER")	
	s ^GetOETabItems("ORDER",objtype,objvalue)=""
	s websysPrefId=""
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	do rs.Execute(objtype,objvalue)
	while(rs.%Next()){
		//valueDesc:%String:类型描述,valueCode:%String:类型代码,Type:%String:类型,
		//AppKey:%String:应用代码,EPRChartCode:%String:EPR图表,
		//EPRChartSize:%String:EPR图表尺寸,Tab:%String:表名,Col:%String:列名,
		//ARCIMorARCOS:%String:医嘱或医嘱套,Desc:%String:药品描述,Code:%String:药品代码
		//,NoShowAlias:%String:不显示别名,NoShowAliasSameCode:%String:别名和代码一致则不显示别名
		s valueDesc=rs.GetDataByName("valueDesc")
		s AppKey=rs.GetDataByName("AppKey")
		//不导按工作流保存的
		//continue:((Key="")&&(AppKey'="ORDER"))
		//按工作流 如 Key=ORDERW50008
		continue:((Key'="")&&(AppKey'=Key))
		
		s Type=rs.GetDataByName("Type")
		s Tab=rs.GetDataByName("Tab")
		s Col=rs.GetDataByName("Col")
		s ARCIMorARCOS=rs.GetDataByName("ARCIMorARCOS")
		//不导出医嘱套
		//continue:ARCIMorARCOS="ARCOS"
		s Desc=rs.GetDataByName("Desc")
		s Code=rs.GetDataByName("Code")
		s Index=rs.GetDataByName("Index")
		s itemrowid=rs.GetDataByName("itemrowid")
		s tabIndex=..FormateIndex($p(Index,"||",1))
		s ColIndex=..FormateIndex($p(Index,"||",2))
		s CodeIndex=..FormateIndex($p(Index,"||",3))
		s Tab=tabIndex_"!"_Tab
		s websysPrefId=rs.GetDataByName("websysPrefId")
		s ^GetOETabItems("ORDER",objtype,objvalue,Tab,ColIndex_"!"_Col,CodeIndex_"!"_Code)=valueDesc_"^"_Type_"^"_Tab_"^"_Col_"^"_ARCIMorARCOS_"^"_Code_"^"_Desc_"^"_itemrowid_"^"_websysPrefId

	}	
	b //34
	d rs.%Close()
	if (websysPrefId="")&&(Key'=""){
		s websysPrefId=$o(^websys.PreferencesI("Index", objtype, objvalue, Key, "OEOrder.PrefTabs.EditList", ""))
		Q "!!"_websysPrefId
	}	
	s allTable="",websysPrefId=""
	s Tab=""
	f  s Tab=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab)) q:Tab=""  d
	.//表名
	.s onetabName=$p(Tab,"!",2)
	.s groupsStr=""
	.s Col=""
	.f  s Col=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col)) q:Col=""  d
	..s groupname=$p(Col,"!",2)
	..s onegroupStr=""
	..s Code=""
	..f  s Code=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code)) q:Code=""  d
	...s DESC=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",7)
	...s Type=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",5)
	...//q:Type=""
	...s itemrowid=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",8)
	...s websysPrefId=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",9)
	...s tepstr=Code_"$c(4)"_DESC_"$c(4)"_Type_"$c(4)"_itemrowid_"$c(4)"_websysPrefId
	...i onegroupStr="" d
	....s onegroupStr=tepstr
	...else  d
	....s onegroupStr=onegroupStr_"^"_tepstr
	..s onegroup=groupname_"::"_onegroupStr
	..i groupsStr="" d
	...s groupsStr=onegroup
	..else  d
	...s groupsStr=groupsStr_"$c(28)"_onegroup	//groupsStr_$c(28)_onegroup
	.s onetable=onetabName_"@"_groupsStr
	.i allTable="" d
	..s allTable=onetable
	.else  d
	..s allTable=allTable_","_onetable	
	k ^GetOETabItems("ORDER")
	s ^tempscl("allTable")=allTable	
	q allTable_"!!"_websysPrefId
}

ClassMethod FormateIndex(SeqNo)
{
	If $L(SeqNo)=2 Set SeqNo="0"_SeqNo
	If $L(SeqNo)=1 Set SeqNo="00"_SeqNo
	Q SeqNo
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 根据类型获取科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","GetLocByType","O^E")
Query GetLocByType(TypeList As %String, code As %String = "") As %Query(ROWSPEC = "rowid,Desc,ContactName")
{
}

ClassMethod GetLocByTypeExecute(ByRef qHandle As %Binary, TypeList As %String, code As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    //i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    k TempList
    f itype=1:1:$L(TypeList,"^")  d
	.s loctype=$P(TypeList,"^",itype)
	.if loctype="I"  d
	..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...q:($p($g(^CTLOC(rowid)),"^",13)'="E")
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
    ...Q:(Desc["门诊")
    ...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s TempList(Desc,rowid)=Desc_"^"_ContactName
    ...;d OutputRow6
    ...
    .else  d
    ..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
 	...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s TempList(Desc,rowid)=Desc_"^"_ContactName
    ...;d OutputRow6
   
    s sub1=0
    f  s sub1=$O(TempList(sub1)) Q:sub1=""  d
    .s sub2=0
    .f  s sub2=$O(TempList(sub1,sub2)) Q:sub2=""  d
    ..s value=$G(TempList(sub1,sub2))
    ..s rowid=sub2
    ..s Desc=$p(value,"^",1)
    ..s ContactName=$p(value,"^",2)
    ..d OutputRow6
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(rowid,Desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetLocByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// ==================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取安全组
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","FindGroup","")
Query FindGroup(desc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_Rowid,SSGRP_Desc")
{
	SELECT SSGRP_Rowid, SSGRP_Desc 
	FROM SQLUser.SS_Group
	WHERE SSGRP_Desc %STARTSWITH :desc
	ORDER BY SSGRP_Desc
}

/// CTOR: QP
/// DATE: 2018-09-11
/// DESC: 根据安全组id获取科室
/// IN  : 
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetGroupAdmLoc("163","nk")
ClassMethod GetGroupAdmLoc(GroupRowId As %String, LocDesc As %String = "")
{
	n (GroupRowId,LocDesc)
	s mRtn = ""
	s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:AdmDep")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(GroupRowId)
		If 'Status Quit
		While (rset.Next()) {
			s CTLOCDesc=rset.GetData(2)
			s ResRowIdStr=rset.GetData(1)
			s LocId=+ResRowIdStr
			s LocOtherName=""
			s:LocId'="" LocOtherName=$p(^CTLOC(LocId),"^",43)
			continue:(LocOtherName'="")&&(LocDesc'="")&&(LocOtherName'[LocDesc)&&(CTLOCDesc'[LocDesc)
			i mRtn="" s mRtn=ResRowIdStr_"&"_CTLOCDesc
	   		e  s mRtn=mRtn_"^"_ResRowIdStr_"&"_CTLOCDesc
	   		
		    ;i mRtn="" s mRtn=$ZCVT(ResRowIdStr,"O","JS")_"!"_$ZCVT(CTLOCDesc,"O","JS")
	   		;e  s mRtn=mRtn_"^"_$ZCVT(ResRowIdStr,"O","JS")_"!"_$ZCVT(CTLOCDesc,"O","JS")
		}
		d rset.Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-11
/// DESC: 根据安全组id获取医生
/// IN  : 
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDocByLoc("1","")
ClassMethod GetDocByLoc(LocId As %String, DocName As %String = "")
{
	n (LocId,DocName)
	s mRtn=""
	s DocName=$$ALPHAUP^SSUTIL4(DocName)
	s Type="",UserID="",DataType="ResID"
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(LocId,Type,UserID)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 Set OtherName=$p(^CTPCP(DocRowid,3),"^",28)
			 continue:(DocName'="")&&(OtherName'="")&&(OtherName'[DocName)&&(DocDesc'[DocName)
			 i DataType = "ResID" d
			 .i mRtn="" s mRtn=ResRowid_"!"_DocDesc
	   		 .e  s mRtn=mRtn_"^"_ResRowid_"!"_DocDesc
			 e  d
			 .i mRtn="" s mRtn=DocRowid_"!"_DocDesc
	   		 .e  s mRtn=mRtn_"^"_DocRowid_"!"_DocDesc
		 }
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-11
/// DESC: 从web.DHCOPRegConfig.SaveGroupRes中改迁
/// IN  : +^869!+^1085!-^528
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveGroupRes("163","",528)
ClassMethod SaveGroupRes(GroupRowId As %String, inPara As %String, subPara As %String) As %String
{
	n (GroupRowId,inPara,subPara)
	q:((inPara="")&&(subPara=""))||(GroupRowId="") 0
	s osPara=$P($g(^SSU("SSGRP",GroupRowId,"DHC")),"^",1)
	s resPara=""
	s osLen=$l(osPara,"!")
	f i=1:1:osLen {
		s curValue=$p(osPara,"!",i)
		i ("!"_subPara_"!")'[("!"_curValue_"!") {
			i resPara="" s resPara=curValue
			e  s resPara=resPara_"!"_curValue
		}
	}
	i inPara'="" s resPara=resPara_"!"_inPara 
	s $P(^SSU("SSGRP",GroupRowId,"DHC"),"^",1)=resPara

	Q 0
}

// ========================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询模块代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryCodeModule")
Query QryCodeModule() As %Query(ROWSPEC = "ModuleRowId:%String,ModuleDesc:%String")
{
}

ClassMethod QryCodeModuleExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
      
	Set rset=##class(%ResultSet).%New("web.DHCDocCTCommon:GetDHCDocCTModule")
	do rset.Execute()
	While (rset.Next()) {
		s ModuleRowId=rset.Data("ModuleRowId")
		s ModuleDesc=rset.Data("ModuleDesc")
		d OutputRow66
	}
	d rset.Close()
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow66
	set Data=$lb(ModuleRowId,ModuleDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCodeModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCodeModuleExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryCodeModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCodeModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// =============医嘱归类模块HUI===========

/// web.DHCDocOrderEntry
/// /d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpItemNew","pttzs",29,"14#","","","","",67,"","",3009,"","",185,"","")
/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItemNew","ptt",29,"","","","","",69,"","",1259,"","",188,"","")
Query LookUpItemNew(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String,ArcimDr:%String")
{
}

ClassMethod LookUpItemNewExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	//New repid, index
	///do ResetVariables
	//n (QHandle,Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	s ^tempscl("sd")=Item_","_GroupID_","_Category_","_SubCategory_","_TYPE_","_OrderDepRowId_","_OrderPriorRowId_","_EpisodeID_","_BillingGrp_","_BillingSubGrp_","_UserRowId_","_OrdCatGrp_","_NonFormulary_","_Form_","_Strength_","_Route
	kill ^||tmpLookUpItemNew
	Set repid=$I(^CacheTemp)
	Set index=1,Num=0
	//b ;001
	i Item=""{
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d obj.Execute(Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	//b ;02
	
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		///OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,HIDDEN:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String
		s OrdName=obj.GetData(1)
		s OrdName=##class(web.DHCDocUtil).EvalJSON(OrdName)
		s OrdInfo=OrdName
		For col = 2:1:columns {
			s tmpOrdName=##class(web.DHCDocUtil).EvalJSON(obj.GetData(col))
			 i col="15" {
				 s tmpOrdName=$replace(tmpOrdName,$c(14),"")
				 s tmpOrdName=$replace(tmpOrdName,$c(12),"")
			 }
			 
	         s OrdInfo=OrdInfo_"^"_tmpOrdName
	    }
	    
		Set Data=$lb(OrdInfo,OrdName,obj.GetData(18),obj.GetData(19),obj.GetData(21),obj.GetData(27),obj.GetData(28),obj.GetData(29),obj.GetData(31),obj.GetData(32),obj.GetData(2))
		//i Data'="" s ^tempscl("OrdInfo1",Data)=1
		do RecordSortTmpDataNew
	}
	
	s RecordCount=""
	for {
		s RecordCount=$o(^||tmpLookUpItemNew(RecordCount),-1) Quit:RecordCount=""
		s Num=0
		for {
			s Num=$o(^||tmpLookUpItemNew(RecordCount,Num)) Quit:Num=""
			s id=0
			for {
				s id=$o(^||tmpLookUpItemNew(RecordCount,Num,id)) Quit:id=""
				s Data=^||tmpLookUpItemNew(RecordCount,Num,id)
				;s ^tmpLookUpItemNewlog(RecordCount,Num,id)=Data
				do OutputRowItemNew
			}
		}
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
RecordSortTmpDataNew
	Set Num=Num+1
	Set OutRecordId=obj.GetData(2)
	if OutRecordId["||"{
		s TableName="User.ARCItmMast"
	}else{
		s TableName="User.ARCOrdSets"	
	}
	Set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,OutRecordId,UserRowId,"U")
	Set ^||tmpLookUpItemNew(RecordCount,Num,OutRecordId)=Data
	quit
OutputRowItemNew
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod LookUpItemNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	//New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpItemNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	// New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// =============常用维护中医嘱项替换HUI===========

/// CTOR: QP
/// DATE: 2018-09-18
/// atype: ARCOS/TMPL/USE(医嘱套/医嘱模板/常用用法维护)
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryReplaceArcim","")
Query QryReplaceArcim(atype = "", arcimrow = "", locid = "", ssuid = "") As %Query(ROWSPEC = "acosdate,arcosname,acostype,desc,RowId,cfgType,detail,cfgCode")
{
}

ClassMethod QryReplaceArcimExecute(ByRef qHandle As %Binary, atype = "", arcimrow = "", locid = "", ssuid = "") As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 
 i (atype="ARCOS")||(atype="") {
	 s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:arcos=""  d
	 .s favId=$o(^DHCFavItems(0,"ItemRowid",arcos,""))
	
	 .s (userId,depId,hospId)=""
	 .i favId'="" d
	 ..s userId=$p(^DHCFavItems(favId),"^",2)
	 ..s depId=$p(^DHCFavItems(favId),"^",4)
	 ..s hospId=$p(^DHCFavItems(favId),"^",9)
	 .q:(ssuid'="")&&(userId'=ssuid)
	 .q:(locid'="")&&(depId'=locid)
	 .s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:datesub=""  d
	 ..s flag=0,detail=""
	 ..s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:arcossub=""  d
	 ...s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
	 ...q:(arcosarcitm="")||(arcosarcitm="undefined")	//处理表中垃圾数据QP
	 ...s arcosarcitmDesc=$p($g(^ARCIM(+arcosarcitm,$P(arcosarcitm,"||",2),1)),"^",2)
	 ...s curId=arcos_"||"_datesub_"||"_arcossub
	 ...i detail="" s detail=curId_"^"_arcosarcitmDesc_"^"_arcosarcitm
	 ...e  s detail=detail_"!"_curId_"^"_arcosarcitmDesc_"^"_arcosarcitm
	 ...q:(arcimrow'="")&&(arcimrow'=arcosarcitm)
	 ...s flag=1  //包含这个医嘱项
	 ..i flag=1 d
	 ...s userName="",depName="",hospName="全院",desc="",cfgType="医嘱套",cfgCode="ARCOS"
	 ...s acossubcat=$p(^ARCOS(arcos),"^",9) 
	 ...s acostype=""
	 ...if acossubcat'="" s acostype=$p(^ARC("IC",acossubcat),"^",2)	;套类型
	 ...s arcosname=$p(^ARCOS(arcos),"^",2)	;套名称
	 ...s acosdate=$p(^ARCOS(arcos,"DATE",datesub),"^",1)
	 ...s acosdate=##class(websys.Conversions).DateLogicalToHtml(acosdate)
	 ...i userId'="" d
	 ....s userName=$p(^SSU("SSUSR",userId),"^",2)
	 ....s desc=userName_"->"_arcosname
	 ...e  i depId'="" d
	 ....s depName=$p(^CTLOC(depId),"^",2)
	 ....s desc=depName_"->"_arcosname
	 ...e  s desc=hospName_"->"_arcosname
	 ...s RowId=arcos_"||"_datesub
	 ...d OutputRow
 }
 i (atype="TMPL")||(atype="") {
	s ch28=$C(28)
	s ch4=$C(4)
	s ch1=$C(1)
 	s AppSubKey="OEOrder.PrefTabs.EditList"
 	s AppKey="" f  s AppKey=$o(^websys.PreferencesI("AppKey",AppSubKey,AppKey)) q:AppKey=""  d
 	.s id="" f  s id=$o(^websys.PreferencesI("AppKey",AppSubKey,AppKey,id)) q:id=""  d
	..s data = $list(^websys.PreferencesD(id),3)
	..s (valueDesc,valueCode,Type,EPRChartCode,EPRChartSize,Tab,Col,Desc,Code,NoShowAlias,SaveContextWorkflow)=""
	..s Type = $list(^websys.PreferencesD(id),5)
	..s objId = $list(^websys.PreferencesD(id),4)
	..q:(locid'="")&&(objId'=locid)
	..q:(locid'="")&&(Type'="User.CTLoc")
	..q:(ssuid'="")&&(objId'=ssuid)
	..q:(ssuid'="")&&(Type'="User.SSUser")
	..s cfgType="医嘱模板",cfgCode="TMPL"
	..i Type="User.SSGroup" &SQL(SELECT SSGRP_Desc,SSGRP_Desc INTO:valueDesc,:valueCode FROM SQLUSER.SS_Group WHERE SSGRP_Rowid=:objId )
	..i Type="User.SSUser" d
	...&SQL(SELECT SSUSR_Name,SSUSR_Initials INTO:valueDesc ,:valueCode FROM SQLUSER.SS_User WHERE SSUSR_Rowid=:objId )
	...s cfgType="医嘱模板(个人)",cfgCode="TMPL-SSUser"
	..i Type="User.CTLoc" d
	...&SQL(SELECT CTLOC_Desc ,CTLOC_Code INTO:valueDesc,:valueCode FROM SQLUSER.CT_Loc WHERE CTLOC_Rowid=:objId )
	...s cfgType="医嘱模板(科室)",cfgCode="TMPL-CTLoc"
	..i Type="User.CTHospital" &SQL(SELECT HOSP_Desc,HOSP_Code INTO:valueDesc,:valueCode  FROM SQLUSER.CT_Hospital WHERE HOSP_Rowid=:objId )
	..i Type="User.PACTrust" &SQL(SELECT TRUST_Desc,TRUST_Code INTO:valueDesc,:valueCode FROM SQLUSER.PAC_Trust WHERE TRUST_Rowid=:objId )
	..i Type="SITE" s valueDesc="DHCHEALTH",valueCode="DHCHEALTH"
	..s EPRChartId = $lg(data,1)	//EPR图表
	..s EPRChartObj = ##class(epr.Chart).%OpenId(EPRChartId,0)
	..I $IsObject(EPRChartObj) s EPRChartCode = EPRChartObj.Name
	..s EPRChartSize = $lg(data,2)	//EPR图表尺寸
	..s TabList = $lg(data,3)
	..s NoShowAlias=$lg(data,4)		//不显示别名
	..s NoShowAliasSameCode=$lg(data,5)	//别名和代码一致则不显示别名
	..f i=1:1:$listlength(TabList) d
	...s TabItem = $lg(TabList,i)
	...s Tab=$P(TabItem,ch1,1)
	...s TabItem = $p(TabItem,ch1,2,$l(TabItem,ch1))
	...f j=1:1:$length(TabItem,ch1) d
	....s ColItem = $p(TabItem,ch1,j)
	....s Col=$p(ColItem,ch28,1)
	
	....s Col=$tr(Col,",","，")
	....i Col="" s Col="(空白列标头)"
	....s ColItem = $p(ColItem,ch28,2,$l(ColItem,ch28))
	....q:$length(ColItem,ch4)=1
	....s detail=""
	....f k=1:1:$length(ColItem,ch28) d
	.....s CellItem=$p(ColItem,ch28,k)
	.....s itemType = $p(CellItem,ch4,1)
	.....s itemrowid = $p(CellItem,ch4,2)
	.....i +itemrowid=0 s Desc="",Code=""
	.....i itemrowid="undefined" s itemrowid="",itemType=""
	.....q:(itemType="")
	.....i itemType="ARCIM"  d
	......s cItemid=itemrowid,bwids="",bwDesc="",twDesc=""
	......i itemrowid["*S*" s cItemid=$p(itemrowid,"*",1),bwids=$p($p(itemrowid,"*S*",2),"*",1)
	......i '$d(^ARCIM(+cItemid,+$p(cItemid,"||",2),1)) s Desc=cItemid_"医嘱项不存在",Code=cItemid_"医嘱项不存在" 
	......e  s Desc=$p($g(^ARCIM(+cItemid,$p(cItemid,"||",2),1)),"^",2),Code=$p($g(^ARCIM(+cItemid,$p(cItemid,"||",2),1)),"^",1)
	......i bwids'="" d
	.......s bwLen=$l(bwids,"A")
	.......s Desc=Desc_"["
	.......f h=1:1:bwLen d
	........s bwStr=$p(bwids,"A",h)
	........s bwid=$p(bwStr,"B",1),twid=$p(bwStr,"B",2)
	........i twid'="" s twDesc=$p(^DHCAPPOS(twid),"^",2)
	........i bwid'="" s bwDesc=$p(^DHCAPPART(bwid),"^",2)
	........s displayBwdesc=bwDesc
	........i twDesc'="" s displayBwdesc=displayBwdesc_"("_twDesc_")"
	........i h=1 s Desc=Desc_displayBwdesc
	........e  s Desc=Desc_"，"_displayBwdesc
	.......s Desc=Desc_"]"
	.....i itemType="ARCOS"  d
	......i ('$d(^ARCOS(itemrowid))) s Desc=itemrowid_"医嘱套不存在",Code=itemrowid_"医嘱套不存在" 
	......e  s Desc = $p(^ARCOS(itemrowid),"^",2),Code = $p(^ARCOS(itemrowid),"^",1)
	.....s Desc=$tr(Desc,",","，")
	.....i detail="" s detail=itemrowid_"^"_Desc_"^"_itemType
	.....e  s detail=detail_"!"_itemrowid_"^"_Desc_"^"_itemType
	....q:(arcimrow'="")&&(detail'[arcimrow)
	....s curRecord=valueDesc_"->"_Tab_"->"_Col
	....s (acosdate,arcosname,acostype)=""
	....s acostype=AppKey
	....d OutputRow1
	
	
 }
 i (atype="USE")||(atype="") {
	s:arcimrow'="" ItemDesc=$p($g(^ARCIM(+arcimrow,$P(arcimrow,"||",2),1)),"^",2)
	if (ssuid'="") {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","User",ssuid,Rowid))
			q:Rowid=""
			//s Rowid=$O(^DHCDID(0,"LastUser",UserID,Rowid)) q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetData
		}
	}
	if (locid'="") {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","Location",locid,Rowid))
			q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetData
		}
	}
	if ((ssuid="")&&(locid="")) {
		s curLoc="" f  s curLoc=$O(^DHCDID(0,"Contral","Location",curLoc)) q:curLoc=""  d
		.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","Location",curLoc,Rowid)) q:Rowid=""  d
		..s Data=$g(^DHCDID(Rowid))
		..d GetData
		
		s curUser="" f  s curUser=$O(^DHCDID(0,"Contral","User",curUser)) q:curUser=""  d
		.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","User",curUser,Rowid)) q:Rowid=""  d
		..s Data=$g(^DHCDID(Rowid))
		..d GetData
	}
 	
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

GetData
	s ARCIMDR=$p(Data,"^",1)
	if ARCIMDR="" q
	s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)),"^",2)
	q:(($g(ItemDesc)'="")&&(ArcimDesc'[ItemDesc))
	s DataPAAdmType=$p($g(Data),"^",23)
	//q:(PAAdmType'="")&&(PAAdmType'=DataPAAdmType)
	s ContralTypeCode=$p(Data,"^",2)
	s ContralKey=$p(Data,"^",3)
	s ContralType="",ContralDesc=""
	s cfgType="常用用法维护",cfgCode="USE"
	if ContralTypeCode="User" {
		s ContralType="用户"
		s cfgType="常用用法维护(用户)",cfgCode="USE-SSUser"
		s ContralDesc=$p($g(^SSU("SSUSR",+ContralKey)),"^",2)
	}
	if ContralTypeCode="Location" {
		s ContralType="科室"
		s cfgType="常用用法维护(科室)",cfgCode="USE-CTLoc"
		s ContralDesc=$p($g(^CTLOC(+ContralKey)),"^",2)
		s ContralDesc=##class(web.DHCOPAdmReg).LocDescFormate(ContralDesc)
	}
	s ActiveFlag=$p(Data,"^",4)
	s Priority=""
	s PriorityDR=$p(Data,"^",5)
	if PriorityDR'="" s Priority=$p(^OECPR(PriorityDR),"^",2)
	s Dose=$p(Data,"^",6)
	s DoseUom=""
	s DoseUomDR=$p(Data,"^",7)
	if DoseUomDR'="" s DoseUom=$P(^CT("UOM",DoseUomDR),"^",2)
	s Instr=""
	s InstrDR=$p(Data,"^",8)
	if InstrDR'="" s Instr=$p($G(^PHCIN(InstrDR)),"^",2)
	s PHFreq=""
	s PHFreqDR=$p(Data,"^",9)
	if PHFreqDR'="" s PHFreq=$p($g(^PHCFR(PHFreqDR)),"^",3)
	s Durat=""
	s DuratDR=$p(Data,"^",10)
	if DuratDR'="" s Durat=$p($g(^PHCDU(DuratDR)),"^",3)
	s PackQty=$p(Data,"^",11)
	s SkinTest=$p(Data,"^",12)
	i SkinTest="" s SkinTest="N"
	s SkinAction=""
	s SkinActionDR=$p(Data,"^",13)
	if SkinActionDR'="" s SkinAction=$p(^OEC("ACT",SkinActionDR),"^",2)
	s RelevanceNo=$p(Data,"^",14)
	s UserAdd=""
	s UserAddDR=$p(Data,"^",15)
	if UserAddDR'="" s UserAdd=$p($g(^SSU("SSUSR",UserAddDR)),"^",2)
	s DateAdd=$p(Data,"^",16)
	if DateAdd'="" s DateAdd=##class(websys.Conversions).DateLogicalToHtml(DateAdd) //$zd(DateAdd,3)
	s TimeAdd=$p(Data,"^",17)
	if TimeAdd'="" s TimeAdd=$zt(TimeAdd,1)
	s LastUpdateUser=""
	s LastUpdateUserDR=$p(Data,"^",18)
	if LastUpdateUserDR'="" s LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	s LastUpdateDate=$p(Data,"^",19)
	if LastUpdateDate'="" s LastUpdateDate=##class(websys.Conversions).DateLogicalToHtml(LastUpdateDate) //$zd(LastUpdateDate,3)
	s LastUpdateTime=$p(Data,"^",20)
	if LastUpdateTime'="" s LastUpdateTime=$zt(LastUpdateTime,1)
	s Notes=$p(Data,"^",21)
	
	s TPAAdmType=""
	if DataPAAdmType="I" s TPAAdmType="住院"
	if DataPAAdmType="O" s TPAAdmType="门诊"
	if DataPAAdmType="E" s TPAAdmType="急诊"
	
	s SpeedFlowRate=$p($g(Data),"^",24)
	s FlowRateUnitDr=$p($g(Data),"^",25)
	s FlowRateUnit=""
	if (FlowRateUnitDr'=""){
		s FlowRateUnit=$P(^OEC("SFR",FlowRateUnitDr),"^",2)
	}
	s ExceedReasonDR=$p($g(Data),"^",26)
	s ExceedReason=""
	i ExceedReasonDR'="" s ExceedReason=$p($g(^DHCDocExceedReason(ExceedReasonDR)),"^",2)
	s curRecord=ContralDesc_"->"_ArcimDesc_"->"_Priority
	//单次剂量^用法^频次^疗程^类型
	s detail=Dose_DoseUom_"^"_Instr_"^"_PHFreq_"^"_Durat_"^"_TPAAdmType
	s (acosdate,arcosname,acostype)=""
	d OuputRow3
	q 
OutputRow
	set Data=$lb(acosdate,arcosname,acostype,desc,RowId,cfgType,detail,cfgCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRow1
	set Data=$lb(acosdate,arcosname,acostype,curRecord,id,cfgType,detail,cfgCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OuputRow3
	set Data=$lb(acosdate,arcosname,acostype,curRecord,Rowid,cfgType,detail,cfgCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReplaceArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReplaceArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReplaceArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReplaceArcimExecute ]
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

// =========================新医嘱菜单权限分配==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询菜单类型
/// IN  : 
/// OUT : 
/// TABL: websys.ExtMenu
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryMenuType","menuTreeRoot","1")
Query QryMenuType(parentNode, groupid) As %Query(ROWSPEC = "id,code,desc,checkflag,showFunc,func")
{
}

ClassMethod QryMenuTypeExecute(ByRef qHandle As %Binary, parentNode, groupid) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i parentNode=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i parentNode="menuTreeRoot" s parentNode=""
	s parentNode = " "_$$ALPHAUP^SSUTIL4(parentNode)	
	s index=0 f  s index = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index)) q:index=""  d
	.s id = 0 f  s id = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index,id)) q:id=""  d
	..s obj = ##class(websys.ExtMenu).%OpenId(id,0)
	..s checkflag=0
	..i $d(^SSU("SSGRP",groupid,"Menu")) d
	...s checkflag=$bit($p(^SSU("SSGRP",groupid,"Menu"),"^",1),id) 
	..;s checkflag=$s(checkflag:"true",1:"false")
	..s code=obj.EMCode
	..s desc=obj.EMText
	..s showFunc=obj.EMDisplayHandler
	..s func=obj.EMHandler
	..d obj.%Close()
	..d OutputRow12
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12    
	set Data=$lb(id,code,desc,checkflag,showFunc,func)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryMenuTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMenuTypeExecute ]
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

ClassMethod QryMenuTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMenuTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// =========================批量修改医嘱费别==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询费别
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryFeeType")
Query QryFeeType() As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryFeeTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s myBMRowid=0 f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.s id=myBMRowid
	.s desc=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s code=$p(^PAC("ADMREA",myBMRowid),"^", 1)
	.d OutputRow14
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow14
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryFeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeeTypeExecute ]
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

ClassMethod QryFeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 医嘱替换保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveArcimReplace()
ClassMethod SaveArcimReplace(cfgId = "", atype, para)
{
	n (cfgId,atype,para)
	s ^TEMP("QPH",11)=cfgId_"!"_atype_"!"_para
	s mRtn=1,flag=0
	q:atype="" mRtn
	TS
	s ch28=$C(28)
	s ch4=$C(4)
	s ch1=$C(1)
	s fromArcim=$p(para,"^",1)
	s toArcim=$p(para,"^",2)
	i cfgId'="" {
		i atype="ARCOS" d
		.s arcos=$p(cfgId,"||",1),datesub=$p(cfgId,"||",2)
		.s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:(arcossub="")  d
		..s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
		..q:arcosarcitm'=fromArcim
		..s rowid=arcos_"||"_datesub_"||"_arcossub
		..&SQL(UPDATE SQLUser.ARC_OrdSetDateItem SET ITM_ARCIM_DR=:toArcim WHERE ITM_RowId=:rowid)
		..s flag=1
		..i SQLCODE'=0 s mRtn=SQLCODE
		
		i atype["USE" d
		.s Data=$g(^DHCDID(cfgId))
		.s ARCIMDR=$p(Data,"^",1)
		.q:fromArcim'=ARCIMDR
		.&SQL(UPDATE SQLUser.DHC_Doc_ItemDefault SET DID_ARCIM_DR=:toArcim WHERE DID_Rowid=:cfgId)
		.s flag=1
		.i SQLCODE'=0 s mRtn=SQLCODE
		
		i atype["TMPL" d
		.s result=..SaveOrdTPL(cfgId,atype,para)
		.i result=1 s flag=1
		.e  i result=2 s flag=0
		.e  s mRtn=result
		
	} else {
		s len=$l(atype,"^")
		f i=1:1:len d
		.q:mRtn'=1
		.s cType=$p(atype,"^",i)
		
		.i cType="ARCOS" d
		..s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:(arcos="")  d
		...s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:(datesub="")  d
		....s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:(arcossub="")  d
		.....s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
		.....q:arcosarcitm'=fromArcim
		.....s rowid=arcos_"||"_datesub_"||"_arcossub
		.....&SQL(UPDATE SQLUser.ARC_OrdSetDateItem SET ITM_ARCIM_DR=:toArcim WHERE ITM_RowId=:rowid)
		.....s flag=1
		.....i SQLCODE'=0 s mRtn=SQLCODE
		
		.i cType["TMPL" d
		..s AppSubKey="OEOrder.PrefTabs.EditList"
 		..s AppKey="" f  s AppKey=$o(^websys.PreferencesI("AppKey",AppSubKey,AppKey)) q:AppKey=""  d
 		...q:mRtn'=1
 		...s id="" f  s id=$o(^websys.PreferencesI("AppKey",AppSubKey,AppKey,id)) q:id=""  d
		....s result=..SaveOrdTPL(id,atype,para)
		....i result=1 s flag=1
		....i result="-100"  s mRtn=result
		
		
		.i cType["USE" d
		.s curLoc="" f  s curLoc=$O(^DHCDID(0,"Contral","Location",curLoc)) q:curLoc=""  d
		..q:mRtn'=1
		..s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","Location",curLoc,Rowid)) q:Rowid=""  d
		...s Data=$g(^DHCDID(Rowid))
		...s ARCIMDR=$p(Data,"^",1)
		...q:fromArcim'=ARCIMDR
		...&SQL(UPDATE SQLUser.DHC_Doc_ItemDefault SET DID_ARCIM_DR=:toArcim WHERE DID_Rowid=:Rowid)
		...s flag=1
		...i SQLCODE'=0 s mRtn=SQLCODE
		.q:mRtn'=1
		.s curUser="" f  s curUser=$O(^DHCDID(0,"Contral","User",curUser)) q:curUser=""  d
		..s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","User",curUser,Rowid)) q:Rowid=""  d
		...s Data=$g(^DHCDID(Rowid))
		...s ARCIMDR=$p(Data,"^",1)
		...q:fromArcim'=ARCIMDR
		...&SQL(UPDATE SQLUser.DHC_Doc_ItemDefault SET DID_ARCIM_DR=:toArcim WHERE DID_Rowid=:Rowid)
		...s flag=1
		...i SQLCODE'=0 s mRtn=SQLCODE
	
	}
	i (mRtn'=1) {
		tro
		q "-1"	//更新失败
	}
	TC
	
	q:flag=0 "2"	//没找到相关记录
 
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 医嘱模板替换
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPL(5312,"TMPL","1617||1^999||10")
ClassMethod SaveOrdTPL(cfgId = "", atype, para)
{
	n (cfgId,atype,para)
	s mRtn = 1,result=""
	q:(atype'["TMPL")||(cfgId="") mRtn
	
	s flag=0
	s fromArcim = $p(para,"^",1)
	s toArcim = $p(para,"^",2)
	s ch28=$C(28)
	s ch4=$C(4)
	s ch1=$C(1)
	s TABLIST="",ChartID="",eprChartFrameSize="",NoShowAlias=0,NoShowAliasSameCode=0
	
	s obj = ##Class(websys.Preferences).%OpenId(cfgId)
	s OldData = obj.Data
	s tabLen = $listlength($list(OldData,3))
	s result = ""
	f tabidx = 1:1:tabLen d
	.s OldDataList = $list($list(OldData,3),tabidx)
	.s curLen = $l(OldDataList,ch4)
	.i curLen = 1 d
	..s $List(TABLIST,tabidx) = OldDataList
	..i result = "" s result = OldDataList
	..e  s result = result_"===="_OldDataList
	.e  d
	..s bulidStr = $p(OldDataList,ch4,1)
	..f i = 2:1:curLen d
	...s curItem = $p(OldDataList,ch4,i),newItem=""
	...i $l(curItem,ch1)>1 s itemRowid = $p(curItem,ch1,1)
	...e  s itemRowid = $p(curItem,ch28,1)
	...i itemRowid = fromArcim  d 
	....s flag=1
	....i $l(curItem,ch1)>1 s newItem = toArcim_ch1_$p(curItem,ch1,2,$l(curItem,ch1))
	....e  s newItem = toArcim_ch28_$p(curItem,ch28,2,$l(curItem,ch28))
	...e  s newItem = curItem
	...s bulidStr = bulidStr_ch4_newItem
	..s $List(TABLIST,tabidx) = bulidStr
	
	..i result = "" s result = bulidStr
	..e  s result = result_"===="_bulidStr
	
	q:flag=0 2	//未找到
	s Data=$LB(ChartID,eprChartFrameSize,TABLIST,NoShowAlias,NoShowAliasSameCode)
	s obj.Data=Data
	//s ^TEMP("QP","TEST",1) = Data
	s sc=obj.%Save()
	if $$$ISERR(sc){
		//Do $System.Status.DisplayError()
		Trollback
		Quit "-100"
	}
	
	d obj.%Close() 
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 医嘱模板替换
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPL()
ClassMethod SaveOrdTPLOLD(cfgId = "", atype, para)
{
	n (cfgId,atype,para)
	s mRtn=1
	q:(atype'["TMPL")||(cfgId="") mRtn
	
	s fromArcim=$p(para,"^",1)
	s toArcim=$p(para,"^",2)
	
	s obj=##Class(websys.Preferences).%OpenId(cfgId)
	s OldData=obj.Data
	s tabLen=$listlength($list(OldData,3))
	s result=""
	f tabidx=1:1:tabLen d
	.s OldDataList=$list($list(OldData,3),tabidx)
	.s tabName=$P(OldDataList,ch1,1)
	.s curLen=$l(OldDataList,ch1)
	.s groupItem=$p(OldDataList,ch1,2,curLen)
	.s groupLen=$length(groupItem,ch1)
	.f groupidx=1:1:groupLen d
	..s ColItem = $p(groupItem,ch1,groupidx)
	..s colName = $p(ColItem,ch28,1)	//面板标题
	..s colName = $tr(colName,",","，")
	..s ColItem = $p(ColItem,ch28,2,$l(ColItem,ch28))
	..;q:$length(ColItem,ch4)=1
	..f k=1:1:$length(ColItem,ch28) d
	...s itemStr = $p(ColItem,ch28,k)
	...s itemType = $p(itemStr,ch4,1)
	...s itemRowid = $p(itemStr,ch4,2)
	...i itemRowid = "undefined" s itemRowid = "",itemType = ""
	...i itemRowid = fromArcim d
	....i itemStrNew = "" s itemStrNew = itemType_ch4_toArcim
	....e  s itemStrNew = itemStrNew_ch28_itemType_ch4_toArcim
}

// =========================导诊单配置==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询费别
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryPatGuide","acceptLoc")
Query QryPatGuide(code) As %Query(ROWSPEC = "id,typeDesc,desc")
{
}

ClassMethod QryPatGuideExecute(ByRef qHandle As %Binary, code) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//接受科室位置
	//w ##class(web.DHCDocPatGuideDocumentsPrt).GetConfig("DepLocation","451")
	i code="acceptLoc" d
	.s locId=""
	.f  s locId=$o(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",locId)) q:locId=""  d
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",locId))
	..s id=locId
	..s typeDesc=$p(^CTLOC(locId),"^",2)
	..d OutputRow114
	
	//开单科室位置
	i code="ordLoc" d
	.s locId=""
	.f  s locId=$o(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",locId)) q:locId=""  d
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",locId))
	..s id=locId
	..s typeDesc=$p(^CTLOC(locId),"^",2)
	..d OutputRow114
	
	//标本位置
	i code="bb" d
	.s bbDesc=""
	.f  s bbDesc=$o(^DHCDocConfig("PatGuideDocumentsPrt","Spec",bbDesc)) q:bbDesc=""  d
	..s typeDesc=bbDesc
	..s id=bbDesc
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",bbDesc))
	..d OutputRow114
	
	//医院温馨提示维护
	i code="hospInfo" d
	.s hospId=""
	.f  s hospId=$o(^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",hospId)) q:hospId=""  d
	..s typeDesc=$p(^CT("HOSP",hospId),"^",2)
	..s id=hospId
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",hospId))
	..d OutputRow114
	
	i code="itemPnt" d
	.s OrdCatID="" f  s OrdCatID=$O(^ARC("IC",0,"OrdCat",OrdCatID)) q:OrdCatID=""  d
	..s ItemCatRowID="" f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	...s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	...q:(ItemCatDesc="")&&(ItemCatRowID=0)
	...q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID))
	...q:$g(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID))'=1
	...s id=OrdCatID_"||"_ItemCatRowID
	...s typeDesc=$p(^OEC("ORCAT",OrdCatID),"^",2)
	...s desc=ItemCatDesc
	...d OutputRow114
	
	i code="ordItem" d
	.s OrdCatID="" f  s OrdCatID=$O(^ARC("IC",0,"OrdCat",OrdCatID)) q:OrdCatID=""  d
	..s ItemCatRowID="" f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	...s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	...q:(ItemCatDesc="")&&(ItemCatRowID=0)
	...q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID))
	...q:$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID))'=1
	...s id=OrdCatID_"||"_ItemCatRowID
	...s typeDesc=$p(^OEC("ORCAT",OrdCatID),"^",2)
	...s desc=ItemCatDesc
	...d OutputRow114
	
	i code="noDispalyOrd" d
	.s OrdCatRowID="" f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	..s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	..q:(OrdCatDesc="")&&(OrdCatRowID=0)
	..q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID))
	..q:$g(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID))'=1
	..s typeDesc="医嘱大类"
	..s desc=OrdCatDesc
	..s id=OrdCatRowID
	..d OutputRow114
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow114
	set Data=$lb(id,typeDesc,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryPatGuideFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatGuideExecute ]
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

ClassMethod QryPatGuideClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatGuideExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询维护类型
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryOrdCat","acceptLoc")
Query QryOrdCat(code, para1 = "") As %Query(ROWSPEC = "id,desc,ContactName")
{
}

ClassMethod QryOrdCatExecute(ByRef qHandle As %Binary, code, para1 = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//接受科室位置
	i (code="acceptLoc")||(code="ordLoc") d
	.s rowid=0 f  s rowid=$O(^CTLOC(rowid)) q:rowid=""  d	
	..s id=rowid
	..s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	..s CTDesc=$ZCVT(CTDesc,"U")
	..s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	..s CTContactNameTem=""
	..i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2,$L(CTDesc,"-"))
	..s CTDesc=$TR(CTDesc,"-")
	..s desc=CTDesc
	..s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	..s CTContactName=$ZCVT(CTContactName,"U")
	..s ContactName=CTContactName
	..d DHCDocOut1
	
	i code="bb" {
		i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
		i $d(^DHCLISBSVersion(1)) {
	   	 	s HospitalCode=$g(HospitalCode)
			s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
			i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
			i $l(HospitalDR) {
				s SPECstr=""
				s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
				.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
				.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
				.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
				.s id=SpecimenDR
				.s ContactName=SPECCode_"-"_SPECDesc
				.s desc=SPECDesc
				.d DHCDocOut1
			}
    	}else{
			s SpecRowid=""
			s SpecDesc=""
			f  s SpecRowid=$O(^TTAB("SPEC",SpecRowid)) q:SpecRowid=""  d
			.s SpecDesc=$p(^TTAB("SPEC",SpecRowid),"\",1)
			.q:(SpecDesc="")&&(SpecRowid=0)
			.s id=SpecRowid
			.s ContactName=""
			.s desc=SPECDesc
			.d DHCDocOut1
		}
	}
	
	i (code="itemPnt")||(code="ordItem")||(code="noDispalyOrd-Value") d
	.s OrdCatRowID=""
	.f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	..s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	..q:(OrdCatDesc="")&&(OrdCatRowID=0)
	..s id=OrdCatRowID
	..s desc=OrdCatDesc
	..s ContactName=""
	..d DHCDocOut1
	
	i code="hospInfo" d
	.s HospRowid=""
	.f  s HospRowid=$O(^CT("HOSP",HospRowid)) q:HospRowid=""  d
	..s HospDesc=$p(^CT("HOSP",HospRowid),"^",2)
	..q:(HospDesc="")&&(HospRowid=0)	
	..s id=HospRowid
	..s desc=HospDesc
	..s ContactName=""
	..d DHCDocOut1
	
	i (code="itemPnt-Value")||(code="ordItem-Value") d
	.q:para1=""
	.s ItemCatRowID=""
	.f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",para1,ItemCatRowID)) q:ItemCatRowID=""  d
	..s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	..q:(ItemCatDesc="")&&(ItemCatRowID=0)
	..s id=ItemCatRowID
	..s desc=ItemCatDesc
	..s ContactName=""
	..d DHCDocOut1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCDocOut1
	set Data=$lb(id,desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryOrdCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdCatExecute ]
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

ClassMethod QryOrdCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 保存导诊单配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPL()
ClassMethod SavePatGuide(code, id, value)
{
	n (code,id,value)
	s mRtn = 0
	
	i code = "acceptLoc" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",id) = value
	
	i code = "ordLoc" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",id) = value
	
	i code = "bb" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","Spec",id) = value
	
	i code = "itemPnt" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",id) = value
	
	i code = "ordItem" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",id) = value
	
	i code = "noDispalyOrd" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",id) = value
	
	i code = "hospInfo" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",id) = value
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 删除导诊单配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPL()
ClassMethod DeletePatGuide(code, id)
{
	n (code,id,value)
	s mRtn = 0
	i id [ "||" s id = $p(id,"||",2)
	i code = "acceptLoc" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",id)
	
	i code = "ordLoc" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",id)
	
	i code = "bb" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","Spec",id)
	
	i code = "itemPnt" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",id)
	
	i code = "ordItem" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",id)
	
	i code = "noDispalyOrd" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",id)
	
	i code = "hospInfo" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",id)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 设置默认住院证科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SetDefaultIPBookLoc(50,127)
ClassMethod SetDefaultIPBookLoc(OPLoc As %String, IPLoc As %String) As %String
{
	s ^DHCDocConfig("CanCreatBook-Default",OPLoc)=IPLoc
	q:IPLoc="" 0	;取消时不需要执行底下代码
	s CurValue=$g(^DHCDocConfig("CanCreatBook",OPLoc))
	s FinallyValue=""
	s InValue="^"_IPLoc_"^"
	i CurValue="" s FinallyValue=IPLoc
	e  d
	.s CompareValue="^"_CurValue_"^"
	.i CompareValue'[InValue s FinallyValue=CurValue_"^"_IPLoc
	.e  s FinallyValue=CurValue
	
	s ^DHCDocConfig("CanCreatBook",OPLoc)=FinallyValue
	q 0
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 获取默认住院证科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultIPBookLoc()
ClassMethod GetDefaultIPBookLoc(OPLoc As %String) As %String
{
	Q:OPLoc="" ""
	Q $G(^DHCDocConfig("CanCreatBook-Default",OPLoc))
}

// ==医生号别对照============================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryLoc","")
Query QueryLoc(depname As %String, UserID As %String = "") As %Query(ROWSPEC = "name:%String,id:%String,ContactName") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary, depname As %String, UserID As %String = "") As %Status
{
	;New repid, ind
	;New CTCode1,CTDesc1
 	Set repid=$I(^CacheTemp)
 	Set depname=$ZCVT(depname,"U")
 	s LogHospId=%session.Get("LOGON.HOSPID")
	s ind=1
	set myrowid=0
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","O",myrowid)) q:myrowid=""  d
 	   .;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_myrowid)))
 	   .;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,myrowid))
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .s ContactName=$P(^CTLOC(myrowid),"^",43)
 	   .//Quit:(CTDesc1'[depname)&&(depname'="")
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
 	   .q:$g(CTDesc1)
 	   .Do DHCDocOut2
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","E",myrowid)) q:myrowid=""  d
 	   .;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_myrowid)))
 	   .;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,myrowid))
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .s ContactName=$P(^CTLOC(myrowid),"^",43)
 	   .//Quit:(CTDesc1'[depname)&&(depname'="")
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
 	   .q:$g(CTDesc1)
 	   .Do DHCDocOut2
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
DHCDocOut2
    s CTDesc1=##class(web.DHCOPAdmReg).LocDescFormate(CTDesc1)
	set Data=$lb(CTDesc1,CTCode1,ContactName)
 	Set ^CacheTemp(repid,CTDesc1)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc1,CTCode1)=""
	quit
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 ;New repid,ind
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

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 ;New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 医生号别对照
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryLoc","")
Query UFindDHCMarkDoc(depid = "", reg = "", doc = "") As %Query(CONTAINID = 1, ROWSPEC = "Tdepname:%String,Tmarkname:%String,Tdocname:%String,Tdepid:%String,Tmarkid:%String,Tlocid:%String,Tid:%String,isDefault")
{
}

ClassMethod UFindDHCMarkDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod UFindDHCMarkDocExecute(ByRef qHandle As %Binary, depid As %String = "", reg = "", doc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i depid=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s (Tdepnam,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid,isDefault)=""
	&sql(DECLARE PrescCursor CURSOR FOR
		SELECT MarkddepDr,MarkdMarkDr,MarkdDocDr,ID,Markddefault
	  	into :Tdepid,:Tmarkid,:Tlocid,:Tid,:isDefault
 		From SQLUser.DHCMarkDoc
 		where SQLUser.DHCMarkDoc.MarkddepDr=:depid)
	&sql(OPEN PrescCursor)
 	for  &SQL(FETCH PrescCursor) QUIT:SQLCODE  do
 	.s Tmarkname=$P($g(^CTPCP(Tmarkid,1)),"^",2)
 	.s Tdocname=$P($g(^CTPCP(Tlocid,1)),"^",2)
 	.s Tdepname=$P($g(^CTLOC(Tdepid)),"^",2)
 	.i isDefault="" s isDefault=0
 	.q:(reg'="")&&(Tmarkid'=reg)
 	.q:(doc'="")&&(Tlocid'=doc)
 	.d OutputRow3
	&sql(CLOSE PrescCursor)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(Tdepname,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid,isDefault)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
}

ClassMethod UFindDHCMarkDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
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
 Else  {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 插入号别对照
/// IN  : 
/// OUT : 
/// TABL: DHCMarkDoc
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetKssCate("903||1")
ClassMethod insertMarkDoc(rowid As %Library.String = "", depDr As %Library.String = "", markDr As %Library.String = "", docDr As %Library.String = "", isDefault = "", action As %Library.String = "")
{
	n (action,rowid,depDr,markDr,docDr,isDefault)
	s ccode = "",mRtn=0,flag=0
	TS
	if (isDefault=1){
		&SQL(UPDATE SQLUser.DHCMarkDoc set Markddefault="N" WHERE MarkdDocDr=:docDr and MarkddepDr=:depDr)
	}
	i action="add" {
 		&SQL(SELECT id into :ccode FROM SQLUser.DHCMarkDoc 
 			WHERE MarkdMarkDr=:markDr and MarkdDocDr=:docDr and MarkddepDr=:depDr)
		if (ccode'=""){
			TROLLBACK
			Q "-1" ;记录重复
		}
 		&SQL(INSERT INTO SQLUser.DHCMarkDoc(Markddepdr,MarkdMarkDr,MarkdDocDr,Markddefault)
 		values(:depDr,:markDr,:docDr,:isDefault))
 		s mRtn=SQLCODE
	} else {
		s id=""
		f  s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",depDr,id)) q:(id="")||(flag=1)  d
		.q:id=rowid
		.s docid=$lg(^User.DHCMarkDocD(id),2)
		.s regid=$lg(^User.DHCMarkDocD(id),3)
		.s locid=$lg(^User.DHCMarkDocD(id),4)
		.i ((docid=docDr)&&(regid=markDr)&&(locid=depDr)) s flag=1
		if (flag=1){
			TROLLBACK
			Q "-1" ;记录重复
		}		
		&SQL(UPDATE SQLUser.DHCMarkDoc 
			SET MarkdMarkDr=:markDr,MarkdDocDr=:docDr,Markddepdr=:depDr,Markddefault=:isDefault
 			WHERE id=:rowid)
 		s mRtn=SQLCODE
	}
	if (mRtn=0){
		TC
	}
 	q mRtn
}

ClassMethod deleteMarkDoc(rowid As %Library.String = "")
{
	n (rowid)
	&SQL(DELETE from SQLUser.DHCMarkDoc WHERE id=:rowid)
	
	q SQLCODE
}

ClassMethod insertMarkDocMulit(depid As %Library.String = "", markstr As %Library.String = "", docstr As %Library.String = "")
{
	q:((depid="")||(markstr="")||(docstr=""))
	s rtn=""
	for i=1:1:$l(markstr,"^"){
		s MarkDr=$P(markstr,"^",i)
		s insertrtn=..insertMarkDoc("",depid,MarkDr,docstr,"","add")
		if (insertrtn="-1"){
			s MarkDesc=$p($g(^CTPCP(MarkDr,1)),"^",2)
			if rtn="" s rtn=MarkDesc
			else  s rtn=rtn_","_MarkDesc
			}
		}
	if rtn'="" {
		s DocDesc=$p($g(^CTPCP(docstr,1)),"^",2)
		s rtn="医生:"_DocDesc_",号别分别:"_rtn_";号别重复,其他插入成功"
	}else{
		s rtn="插入成功"
		}
	q rtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取默认号别
/// IN  : 
/// OUT : 
/// TABL: DHCMarkDoc
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultReg("4634",7)
ClassMethod GetDefaultReg(uid As %Library.String = "", locid As %Library.String = "")
{
	n (uid,locid)
	s mRtn=""
	Q:uid="" mRtn
	s DocID=$P(^SSU("SSUSR",uid),"^",14)
	Q:DocID="" mRtn
	s id="" f  s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",locid,id)) q:(id="")||(mRtn'="")  d
	.s doc=$lg(^User.DHCMarkDocD(id),2)
	.q:doc'=DocID
	.s regid=$lg(^User.DHCMarkDocD(id),3)
	.s locid=$lg(^User.DHCMarkDocD(id),4)
	.s isDefault=$lg(^User.DHCMarkDocD(id),5)
	.i isDefault=1 s mRtn=regid
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取是否住院总签床
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetInZBed(110)
ClassMethod GetInZBed(locid As %Library.String = "")
{
	n (locid)
	s mRtn="N"
	Q:locid="" mRtn
	S mRtn=$p(^CTLOC(locid),"^",87)
	i mRtn="" s mRtn="N"
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取住院证科室
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetZYZLoc(110)
ClassMethod GetZYZLoc(bookid As %Library.String = "")
{
	n (bookid)
	s mRtn=""
	Q:bookid="" mRtn
	s mRtn=$p(^DHCDocIPBK(bookid),"^",13) ;科室
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 是否需要显示签床
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).IfNeedSignBed(29)
ClassMethod IfNeedSignBed(bookid As %Library.String = "")
{
	n (bookid)
	s mRtn=0
	s locid=..GetZYZLoc(bookid) 
	s mRtn=..GetInZBed(locid)
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 保存“新医嘱菜单权限分配”菜单
/// IN  : id + "!" + desc + "!" + func + "!" + showFunc + "!" + check ;
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveMenuGroupSetting(29)
ClassMethod SaveMenuGroupSetting(codes, groupid)
{
	q:groupid="" 100
	q:codes="" 100
	s len=$l(codes,"^")
	s gobj = ##class(User.SSExtMeunGroup).%OpenId(groupid)
	q:'$IsObject(gobj)
	s error=0
	s menubit=gobj.DHCEMGExtMenu
	f j=1:1:len d
	.s id=$p($p(codes,"^",j),"!",1)
	.s desc = $p($p(codes,"^",j),"!",2)
	.s func = $p($p(codes,"^",j),"!",3)
	.s showFunc = $p($p(codes,"^",j),"!",4)
	.s check = $p($p(codes,"^",j),"!",5)
	.;q:code=""
	.;s id = $O(^websys.ExtMenuI("EMCodeMenu"," "_$$ALPHAUP^SSUTIL4(code),""))
	.q:id=""
	.s menuOBJ=##class(websys.ExtMenu).%OpenId(id)
	.q:'$IsObject(menuOBJ)
	.s menuOBJ.EMText=desc
	.s menuOBJ.EMDisplayHandler=showFunc
	.s menuOBJ.EMHandler=func
	.s sc=menuOBJ.%Save()
	.i $System.Status.IsError(sc) s error="-100" 
	.q:error'=0
	.d menuOBJ.%Close()   
	.s $bit(menubit,id)=check	
	s gobj.DHCEMGExtMenu = menubit
	d gobj.%Save()
	d gobj.%Close()
	s gobj=""	
	q 0
}

}
