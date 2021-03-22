/// CTOR: QP
/// DATE: 2019-01-11
/// DESC: 医生站配置界面公共方法-扩展2
Class DHCDoc.DHCDocConfig.CommonFunctionE2 Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询门诊科室
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmTypeLocation
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunctionE2","QryOPLoc")
Query QryOPLoc(desc = "", hospid = "") As %Query(CONTAINID = 1, ROWSPEC = "rowid,OPLocdesc,ContactName")
{
}

ClassMethod QryOPLocExecute(ByRef qHandle As %Binary, desc = "", hospid = "") As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	
 	s desc = $$ALPHAUP^SSUTIL4(desc)
	s OPLocdesc = "",rowid = "0",OEType="O^E"
	f i=1:1:2 {
		s curAdmType = $p(OEType,"^",i), rowid = 0
		f  s rowid = $o(^PAC("ADMLOC",0,"AdmType",curAdmType,rowid))  q:rowid=""  d
		.s ActiveFlag = $p(^CTLOC(rowid),"^",14)
		.q:ActiveFlag="N"							//CTLOC_ActiveFlag
		.s DateFrom = 	$p(^CTLOC(rowid),"^",24)	//CTLOC_DateActiveFrom
		.q:(DateFrom'="")&&(DateFrom>+$h)
		.s DateTo = 	$p(^CTLOC(rowid),"^",25)
		.q:(DateTo'="")&&(DateTo<+$h)
		.s OPLocdesc = 	$p(^CTLOC(rowid),"^",2)
		.s OPLocdesc = ##class(web.DHCOPAdmReg).LocDescFormate(OPLocdesc)
		.s LocHospId = 	$p(^CTLOC(rowid),"^",22)
		.s ContactName=$p($g(^CTLOC(rowid)),"^",43)
		.s ContactName=$ZCVT(ContactName,"U")
		.q:(hospid'="")&&(LocHospId'=hospid)
		.i desc'=""  d
		..i ##class(web.DHCOPAdmReg).CheckLocDesc(rowid,desc)=1 d 
		...d OutputRow1
		.e  d
		..d OutputRow1
	}
 	
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow1
	set Data = $lb(rowid,OPLocdesc,ContactName)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryOPLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPLocExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOPLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPLocExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询处方打印格式【处方打印格式与科室对照】
/// 	数据存储Global不做变动，为了兼容之前的版本
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunctionE2","QryPrescPrintType")
Query QryPrescPrintType(desc = "", hospid = "") As %Query(CONTAINID = 1, ROWSPEC = "PrintTypeID,PrintTypeDesc")
{
}

ClassMethod QryPrescPrintTypeExecute(ByRef qHandle As %Binary, desc = "", hospid = "") As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	
 	s ^UDHCPrescriptPrintType("PrintType",1) = 1_"^"_"儿科格式"
	s ^UDHCPrescriptPrintType("PrintType",2) = 2_"^"_"急诊格式"
	
	s PrintTypeID = ""
	f  s PrintTypeID = $O(^UDHCPrescriptPrintType("PrintType",PrintTypeID)) q:PrintTypeID=""  d
	.s PrintTypeDesc = $p(^UDHCPrescriptPrintType("PrintType",PrintTypeID),"^",2)
	.d OutputRow2
 	
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow2
	set Data = $lb(PrintTypeID,PrintTypeDesc)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryPrescPrintTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrescPrintTypeExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrescPrintTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrescPrintTypeExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询处方打印格式与科室对照
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunctionE2","QryPrescPrintDepCompare")
Query QryPrescPrintDepCompare(inLoc = "") As %Query(CONTAINID = 1, ROWSPEC = "PrintTypeDesc,PrintTypeID,LocDesc,TLocID")
{
}

ClassMethod QryPrescPrintDepCompareExecute(ByRef qHandle As %Binary, inLoc = "") As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	
 	s TLocID=""
	f  s TLocID = $O(^UDHCPrescriptPrintConfig("PrintConfig",TLocID)) q:TLocID=""  d
	.q:(inLoc'="")&&(inLoc'=TLocID)
	.s LocDesc = $p(^CTLOC(TLocID),"^",2)
	.s PrintTypeID = $g(^UDHCPrescriptPrintConfig("PrintConfig",TLocID))
	.s PrintTypeDesc = $p(^UDHCPrescriptPrintType("PrintType",PrintTypeID),"^",2)
 	.d OutputRow3
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow3
	set Data = $lb(PrintTypeDesc,PrintTypeID,LocDesc,TLocID)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryPrescPrintDepCompareFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrescPrintDepCompareExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrescPrintDepCompareClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrescPrintDepCompareExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 保存/更新 处方打印格式与科室对照配置HUI
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunctionE2).DBSavePrescPrint(1)
ClassMethod DBSavePrescPrint(LocID, PrintTypeID) As %String
{
	n (LocID, PrintTypeID)
	Q:(LocID="")||(PrintTypeID="") "-1"
	Q:PrintTypeID=$g(^UDHCPrescriptPrintConfig("PrintConfig",LocID)) "-2"
	s ^UDHCPrescriptPrintConfig("PrintConfig",LocID)=PrintTypeID
	q 0
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 删除处方打印格式与科室对照配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunctionE2).DBSavePrescPrint(1)
ClassMethod DBDeletePrescPrint(TLocID) As %String
{
	n (TLocID)
	Q:TLocID="" "-1"
	k ^UDHCPrescriptPrintConfig("PrintConfig",TLocID)
	q 0
}

}
