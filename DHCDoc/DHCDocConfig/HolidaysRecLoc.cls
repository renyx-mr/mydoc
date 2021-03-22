Class DHCDoc.DHCDocConfig.HolidaysRecLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->节假日接受科室定义 查询接受科室
Query FindRecDep(LocId As %String, NodeRowid As %String, NodeDesc As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%String")
{
}

ClassMethod FindRecDepExecute(ByRef qHandle As %Binary, LocId As %String, NodeRowid As %String, NodeDesc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindRecDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected=0
 	.i (NodeRowid'="")&&(LocId'="") d
 	..s:("^"_$g(^DHCDocConfig(NodeDesc,LocId,NodeRowid))_"^")[("^"_CTLOCRowID_"^") selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindRecDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindRecDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindRecDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRecDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecDepExecute ]
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
/// date:2015-05-04
/// desc:医生站设置程序->节假日接受科室定义 查询门诊 住院病区
Query FindDep() As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:(CTLOCType'="E")&&(CTLOCType'="W")
 	.s selected=0
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
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
/// date:2015-05-04
/// desc:医生站设置程序->节假日接受科室定义 
Query FindPriorByLoc(LocID As %String, value As %String) As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindPriorByLocExecute(ByRef qHandle As %Binary, LocID As %String, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindPriorByLoc",1,"HolidaysOrderPriorStr")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s selected=0
 	.i LocID'="" d
 	..s CNMedPriorListStr=$g(^DHCDocConfig(value,LocID))
 	..s:("^"_CNMedPriorListStr_"^")[("^"_OECPRRowId_"^") selected=1
	.Do OutputRowFindPriorByLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPriorByLoc
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPriorByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPriorByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPriorByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPriorByLocExecute ]
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
/// date:2015-12-18
/// desc:医生站设置程序->节假日接受科室定义 查询节假日列表
Query GetHolidaysList() As %Query(ROWSPEC = "HolidaySetRowId:%String,RDHIsActiveFlag:%String,RDHStartDate:%String,RDHStartTime:%String,RDHEndDate:%String,RDHEndTime:%String,RDHCreateUser:%String,RDHCreateDate:%String,RDHCreateTime:%String")
{
}

ClassMethod GetHolidaysListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","GetHolidaysList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set HolidaySetRowId=0
    f  s HolidaySetRowId=$o(^User.DHCOPRecDepHolidayD(HolidaySetRowId)) q:HolidaySetRowId=""  d
    .s RDHIsActiveFlag=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),5)
    .s RDHStartDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),6)
    .i RDHStartDate'="" s RDHStartDate=##class(websys.Conversions).DateLogicalToHtml(RDHStartDate) //$zd(RDHStartDate,3)
    .s RDHStartTime=+$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),7)
    .i RDHStartTime'="" s RDHStartTime=$zt(RDHStartTime,1)
    .s RDHEndDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),8)
    .i RDHEndDate'="" s RDHEndDate=##class(websys.Conversions).DateLogicalToHtml(RDHEndDate) //$zd(RDHEndDate,3)
    .s RDHEndTime=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),9)
    .i RDHEndTime'="" s RDHEndTime=$zt(RDHEndTime,1)
    .s RDHCreateUserDR=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),2)
    .s RDHCreateUser=""
    .i RDHCreateUserDR'="" s RDHCreateUser=$p($g(^SSU("SSUSR",RDHCreateUserDR)),"^",2)
    .s RDHCreateDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),3)
    .i RDHCreateDate'="" s RDHCreateDate=##class(websys.Conversions).DateLogicalToHtml(RDHCreateDate) //$zd(RDHCreateDate,3)
    .s RDHCreateTime=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),4)
    .i RDHCreateTime'="" s RDHCreateTime=$zt(RDHCreateTime,1)
	.Do OutputRowGetHolidaysList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetHolidaysList
	set Data=$lb($g(HolidaySetRowId),$g(RDHIsActiveFlag),$g(RDHStartDate),$g(RDHStartTime),$g(RDHEndDate),$g(RDHEndTime),$g(RDHCreateUser),$g(RDHCreateDate),$g(RDHCreateTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetHolidaysListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHolidaysListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHolidaysListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHolidaysListExecute ]
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

/// creator:fxn
/// date:2018-4-19
/// desc:医生站设置程序->节假日接受科室定义 查询下班时间段
Query GetOffWorkTimeList() As %Query(ROWSPEC = "OffWorkTimesSetRowId:%String,OffWorkStartTime:%String,OffWorkEndTime:%String")
{
}

ClassMethod GetOffWorkTimeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","GetOffWorkTimeList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set OffWorkTimesSetRowId=0
    f  s OffWorkTimesSetRowId=$o(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)) q:OffWorkTimesSetRowId=""  d
    .s OffWorkStartTime=$p($g(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)),"^",1)
    .i (OffWorkStartTime'="")&&(OffWorkStartTime'[":") s OffWorkStartTime=$zt(OffWorkStartTime,1)
    .s OffWorkEndTime=$p($g(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)),"^",2)
    .i (OffWorkEndTime'="")&&(OffWorkEndTime'[":")  s OffWorkEndTime=$zt(OffWorkEndTime,1)
	.Do OutputRowGetOffWorkTimeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOffWorkTimeList
	set Data=$lb($g(OffWorkTimesSetRowId),$g(OffWorkStartTime),$g(OffWorkEndTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOffWorkTimeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOffWorkTimeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOffWorkTimeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOffWorkTimeListExecute ]
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

/// 插入数据
ClassMethod InsertHoliday(Data As %String)
{
	s ^tempscl("InsertHoliday")=Data
	s HolidayStatrDate=$p(Data,"^",1)
	i HolidayStatrDate'="" s HolidayStatrDate=##class(websys.Conversions).DateHtmlToLogical(HolidayStatrDate)
	//i HolidayStatrDate["/" s HolidayStatrDate=$zdh(HolidayStatrDate,4)
	//i HolidayStatrDate["-" s HolidayStatrDate=$zdh(HolidayStatrDate,3)
	s HolidayStartTime=$p(Data,"^",2)
	i HolidayStartTime'="" s HolidayStartTime=$zth(HolidayStartTime)
	s HolidayEndDate=$p(Data,"^",3)
	i HolidayEndDate'="" s HolidayEndDate=##class(websys.Conversions).DateHtmlToLogical(HolidayEndDate)
	//i HolidayEndDate["/" s HolidayEndDate=$zdh(HolidayEndDate,4)
	//i HolidayEndDate["-" s HolidayEndDate=$zdh(HolidayEndDate,3)
	s HolidayEndTime=$p(Data,"^",4)
	i HolidayEndTime'="" s HolidayEndTime=$zth(HolidayEndTime)
	q:(HolidayEndDate=HolidayStatrDate)&&(HolidayStartTime>HolidayEndTime) "假期开始时间不能大于假期结束时间"
	s UserID=$p(Data,"^",5)
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	s ActiveFlag="Y"
	&sql(insert into SQLUSER.DHC_OPRecDepHoliday set RDH_StartDate=:HolidayStatrDate,RDH_StartTime=:HolidayStartTime,RDH_EndDate=:HolidayEndDate,RDH_EndTime=:HolidayEndTime,RDH_CreateUser_DR=:UserID,RDH_CreateDate=:CurrentDate,RDH_CreateTime=:CurrentTime,RDH_IsActiveFlag=:ActiveFlag)
    Q SQLCODE
}

/// 删除数据
ClassMethod DeleteHoliday(HolidaySetRowId As %String)
{
	&sql(delete SQLUSER.DHC_OPRecDepHoliday where ID=:HolidaySetRowId)
    Q SQLCODE
}

ClassMethod DeleteOffWorkTimes(OffWorkTimesSetRowId As %String)
{
	Q:OffWorkTimesSetRowId="" ""
	i $d(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)) d
	.k ^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)
	Q 0
}

ClassMethod SaveRecConfig(LocId As %String, NodeRowid As %String, NodeDesc As %String, RecLocStr As %String) As %String
{
	s ^DHCDocConfig(NodeDesc,LocId,NodeRowid)=RecLocStr
	q 0
}

}
