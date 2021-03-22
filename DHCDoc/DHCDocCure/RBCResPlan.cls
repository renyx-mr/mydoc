Class DHCDoc.DHCDocCure.RBCResPlan Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 函数：QueryResourceWeekPlan
/// 功能：查询资源的星期计划
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResPlan","QueryResourceWeekPlan",82,1992)
Query QueryResourceWeekPlan(LocId As %String, ResourceId As %String) As %Query(ROWSPEC = "LocDesc:%String,LocId:%String,ResSourceDR:%String,ResourceDesc:%String,TWEEK:%String,TServiceGroup:%String,TTimeDesc:%String,TStartTime:%String,TEndTime:%String,TMax:%String,TAutoNumber:%String,TRowid:%String,TWeekNum:%String,TSerivceGourpId:%String,TTimePeriodCode:%String,TChargTime:%String,TAvailPatType:%String,TAutoAvtiveFlag:%String")
{
}

ClassMethod QueryResourceWeekPlanExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String) As %Status
{
	s ^TMP("QueryResourceWeekPlan")=LocId_"^"_ResourceId
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s qHandle=$lb(0,repid,0) Quit $$$OK
 	s LocDesc=$p(^CTLOC(LocId),"^",2)
 	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	i ResourceId="" d
 	.s ResourceIdStr=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResIdByLocRowid(LocId)
	Set RowId=0	f  s RowId=$o(^DHCDocCureRBCResPlan(0,"LocId",LocId,RowId)) q:RowId=""  d
	.s (TimeDesc,ServiceGroup)=""
	.s ResSourceDR=$p(^DHCDocCureRBCResPlan(RowId),"^",2)
	.i ResSourceDR'="" d
	..s CareProvId=$p($g(^RB("RES",ResSourceDR)),"^",2)
	..i CareProvId'="" s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	.Q:(ResourceId'="")&&(ResSourceDR'=ResourceId)
	.Q:($g(ResourceIdStr)'="")&&(("@"_ResourceIdStr_"@")'[("@"_ResSourceDR_"@"))
	.s WeekNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",3)
	.s Week=..GetWeek(WeekNumber)
	.s TimeRangeDR=$p(^DHCDocCureRBCResPlan(RowId),"^",4)  //时间段代码
	.i TimeRangeDR'="" d
	..s TimeDesc=$p($g(^DHCDocCureRBCTimePeriodSet(TimeRangeDR)),"^",2)
	.s StartTime=$p(^DHCDocCureRBCResPlan(RowId),"^",5)
	.s StartTime=$zt(StartTime)
	.s EndTime=$p(^DHCDocCureRBCResPlan(RowId),"^",6)
	.s EndTime=$zt(EndTime)
	.s ServiceGroupID=$p(^DHCDocCureRBCResPlan(RowId),"^",7)
	.i ServiceGroupID'="" d
	..s ServiceGroup=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)),"^",2)
	.s MaxNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",8)
    .s AutoNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",9)
    .s ChargeTime=$p(^DHCDocCureRBCResPlan(RowId),"^",10)
    .i ChargeTime'="" s ChargeTime=$zt(ChargeTime)
    .s AvailPatType=$p(^DHCDocCureRBCResPlan(RowId),"^",11)
    .s AutoAvtiveFlag=$p(^DHCDocCureRBCResPlan(RowId),"^",12)
    .Do OutRowResourceWeekPlan
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowResourceWeekPlan
	set Data=$lb(LocDesc,LocId,ResSourceDR,ResourceDesc,Week,ServiceGroup,TimeDesc,StartTime,EndTime,MaxNumber,AutoNumber,RowId,WeekNumber,ServiceGroupID,TimeRangeDR,ChargeTime,AvailPatType,AutoAvtiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceWeekPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceWeekPlanExecute ]
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

ClassMethod QueryResourceWeekPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceWeekPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：QueryWeek
/// 功能：查询星期 
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryWeek")
Query QueryWeek() As %Query(ROWSPEC = "WeekName:%String,WeekId:%String")
{
}

ClassMethod QueryWeekExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// CT_DayOfWeek
	Set RowId=0	f  s RowId=$o(^CT("DOW",1,RowId)) q:RowId=""  d
	.s Name=$p(^CT("DOW",1,RowId),"^",1)
	.s Sequence=$p(^CT("DOW",1,RowId),"^",2)
	.s Checked=$p(^CT("DOW",1,RowId),"^",3)
	.;i Checked="Y"  d
    .Do OutRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow2
	set Data=$lb(Name,Sequence,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWeekExecute ]
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

ClassMethod QueryWeekClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWeekExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryBookTime() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargTime:%String,NotAvailFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResPlan","QueryBookTime")
ClassMethod QueryBookTimeExecute(ByRef qHandle As %Binary) As %Status
{
	s ind=1
 Set repid=$I(^CacheTemp)
 s TimeRowid=0  f  s TimeRowid=$o(^DHCDocCureRBCTimePeriodSet(TimeRowid)) q:TimeRowid=""  d
 .d OutTime 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutTime
 s TimeCode=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",1)
 s TimeDesc=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",2)
 s StartTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",3)
 i StartTime'="" d
 .s StartTime=$zt(StartTime)
 s EndTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",4)
 i EndTime'="" d 
 .s EndTime=$zt(EndTime)
 s EndChargeTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",5)
 i EndChargeTime'="" d
 .s EndChargeTime=$zt(EndChargeTime)
 s NotAvailFlag=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",6)
 if NotAvailFlag="Y" q
 set Data=$lb(TimeRowid,TimeCode,TimeDesc,StartTime,EndTime,EndChargeTime,NotAvailFlag)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryBookTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryBookTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 函数： UpdateResoucePlan
/// 功能： 更新资源计划
/// w ##class(DHCDoc.DHCDocCure.RBCResPlan).SaveCureRBCResPlan(^TMP("SaveCureRBCResPlan"))
ClassMethod SaveCureRBCResPlan(value As %String)
{
    n (value)
    s ^TMP("SaveCureRBCResPlan")=value
    q:value="" 100
    s Rowid=$p(value,"^",1)
    s LocId=$p(value,"^",2)
	s ResourceId=$p(value,"^",3)
	s WeekNumber=$p(value,"^",4)
	s TimeDesc=$p(value,"^",5)
	s ServiceGroupID=$p(value,"^",6)
	s StartTime=$p(value,"^",7)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(value,"^",8)
	s EndTime=$zth(EndTime,3)

	s BookMaxNumber=$p(value,"^",9)
    s AutoNumber=$p(value,"^",10)
    s ChargeTime=$p(value,"^",11)
    i ChargeTime'="" d
    .s ChargeTime=$zth(ChargeTime,3)
    Q:WeekNumber="" 100
    Q:LocId="" 100
    Q:ResourceId="" 100
    Q:'$D(^CTLOC(LocId)) 100
    Q:'$D(^RB("RES",ResourceId)) 100
    Q:'$D(^CT("DOW",1,WeekNumber)) 100
    Q:'$D(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)) 100
    Q:'$D(^DHCDocCureRBCTimePeriodSet(TimeDesc)) 100
    ;判断是否有同时段的排班模板
    s ret=..CheckCureRBCResPlan(LocId,ResourceId,WeekNumber,TimeDesc)
    if (Rowid="")&&(ret=1)   Q 101
	K PLIST
	s PLIST(2)=LocId
	s PLIST(3)=ResourceId
	s PLIST(4)=WeekNumber
	s PLIST(5)=TimeDesc
	s PLIST(6)=StartTime
	s PLIST(7)=EndTime
	s PLIST(8)=ServiceGroupID
	s PLIST(9)=BookMaxNumber
	s PLIST(10)=AutoNumber
	s PLIST(11)=ChargeTime
	if Rowid="" 
	{
		
	 	&sql(insert into SQLUser.DHC_DocCureRBCResPlan values :PLIST())
	 	B ;
	 	q SQLCODE
	}else{
		&sql(update SQLUser.DHC_DocCureRBCResPlan VALUES :PLIST() WHERE  DDCRP_RowID=:Rowid )
	    q SQLCODE
	}
}

/// 检查是否已经有排班
ClassMethod CheckCureRBCResPlan(LocRowID As %String, ResRowID As %String, WeekNumber As %String, TRRowId As %String)
{
	n (LocRowID,ResRowID,WeekNumber,TRRowId)
	s FindFlag=0
	s DDCRPRowID=""  for  s DDCRPRowID=$o(^DHCDocCureRBCResPlan(0,"Week-Resource",WeekNumber,LocRowID,ResRowID,DDCRPRowID))  q:(DDCRPRowID="")||(FindFlag=1)  d
	.s TimeDescCode=$p(^DHCDocCureRBCResPlan(DDCRPRowID),"^",4)  //时间段代码
	.i TRRowId=TimeDescCode  s FindFlag=1
	q FindFlag
}

/// 函数： DeleteCureRBCResPlan
/// 功能： 删除资源计划
ClassMethod DeleteCureRBCResPlan(Rowid As %String)
{
    q:Rowid="" 100
    &sql(delete from SQLUser.DHC_DocCureRBCResPlan  where DDCRP_RowID=:Rowid)
    q SQLCODE
}

/// 函数：GetWeek
/// 功能：获取星期的描述
ClassMethod GetWeek(WeekNumber As %String) As %String
{
	 s Name="",Sequence=""
	 Set RowId1=0	f  s RowId1=$o(^CT("DOW",1,RowId1)) q:(RowId1="")!(WeekNumber=Sequence)  d
	.s Sequence=$p(^CT("DOW",1,RowId1),"^",2)
	.i WeekNumber=Sequence d
	..s Name=$p(^CT("DOW",1,RowId1),"^",1)
    q Name
}

/// 导入排版前验证数据
/// w ##Class(DHCDoc.DHCDocCure.RBCResPlan).ValidateRBResSessData()
ClassMethod ValidateRBResSessData(SessData As %String) As %String
{
	q:(SessData="") "-1^无效数据"
	s RSLDesc=$P(SessData,"^",1)	//班次
	s LocDesc=$P(SessData,"^",2)	//科室名称
	s RESCode=$P(SessData,"^",3)	//号别代码
	s RESDesc=$P(SessData,"^",4)	//号别名称
	s WeekNum=$P(SessData,"^",5)	//出诊时间(星期)
	s TRDesc=$P(SessData,"^",6)		//时段
	s SessionTypeDesc=$P(SessData,"^",7)	//挂号职称
	s CLGRPDesc=$P(SessData,"^",8)	//亚专业
	s RoomDesc=$P(SessData,"^",9)	//诊室
	s SessLoad=$P(SessData,"^",10)	//正号限额
	s SessNoApptSlot=$P(SessData,"^",11)	//预约限额
	s AddtionMax=$P(SessData,"^",12)	//加号限额
	s SessNoSlots=SessLoad-SessNoApptSlot
	s SessNumberOfWeeks=$P(SessData,"^",13)	//预约起始号
	s TRFlag=$P(SessData,"^",14)	//分时段就诊
	s TRStartTime=$P(SessData,"^",15)	//开始时间
	s TREndTime=$P(SessData,"^",16)	//结束时间
	s TRLength=$P(SessData,"^",17)	//间隔分钟
	s TRRegNum=$P(SessData,"^",18)	//时段号数
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	
	if (RSLDesc=""){
		q "-1^班次为空"
	}
	s RSLRowID=""
	&SQL(SELECT RSL_RowId into :RSLRowID FROM SQLUser.RB_ResScheduleLines WHERE RSL_Desc=:RSLDesc)
	if (SQLCODE'=0)||(RSLRowID=""){
		q "-1^未找到对应的班次"
	}
	if (LocDesc=""){
		q "-1^科室为空"
	}
	s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	if (LocRowID=""){
		q "-1^未找到对应的科室"
	}
	if (RESCode="")||(RESDesc=""){
		q "-1^号别为空"
	}
	s MarkRowID=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(RESCode),0))
	if (MarkRowID=""){
		q "-1^找不到对应的号别:"_RESCode
	}
	s ResRowID=$O(^RB("RES",0,"CTPCP",MarkRowID,LocRowID,0))
	if (ResRowID=""){
		q "-1^找不到对应的资源"
	}
	if (WeekNum<1)||(WeekNum>7){
		q "-1^无效的星期"
	}
	s WeekDr=""
	&SQL(SELECT DOW_RowId into :WeekDr FROM SQLUser.CT_DayOfWeek WHERE DOW_Day=:WeekNum)
	if (SQLCODE'=0)||(WeekDr=""){
		q "-1^无效的周数:"_WeekNum
	}
	if (TRDesc=""){
		q "-1^时段为空"
	}
	s TimeRangeDr=""
	&SQL(SELECT TR_RowId into :TimeRangeDr FROM SQLUser.DHC_TimeRange WHERE TR_Desc=:TRDesc)
	if (SQLCODE'=0)||(TimeRangeDr=""){
		q "-1^无效的时段:"_TRDesc
	}
	if (SessionTypeDesc=""){
		q "-1^职称为空"
	}
	s SessionTypeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessionTypeDesc),0))
	if (SessionTypeDr=""){
		q "-1^无效的职称"_SessionTypeDesc
	}
	s CLGRPDr=""
	if (CLGRPDesc'=""){
		s CLGRPDr=$O(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(CLGRPDesc),0))
		if (CLGRPDr=""){
			q "-1^无效的亚专业"_CLGRPDesc
		}
	}
	s RoomDr=""
	if (RoomDesc'=""){
		s RoomDr=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RoomDesc),0))
		if (RoomDr=""){
			q "-1^无效的诊室"_RoomDesc
		}
	}
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).CheckBeforeSaveSess("",LocRowID,MarkRowID,WeekDr,TimeRangeDr,RSLRowID)
	q:(+ret<0) ret
	
	if (+SessLoad=0){
		q "-1^正号限额不能为空"
	}
	if (+SessNoApptSlot'=0)&&(+SessNumberOfWeeks=0){
		q "-1^预约限额不为空时,预约起始号不能为空"
	}
	if (SessLoad<SessNoApptSlot){
		q "-1^正号限额不能小于预约限额"
	}
	if (+SessNoApptSlot'=0){
		if (SessLoad-SessNumberOfWeeks+1)<SessNoApptSlot{
			q "-1^正号限额减去预约起始号要大于等于预约限额！"
		}
	}
	if (SessLoad>999){
		q "-1^正号限额不能超过999！"
	}
	s TRRegNumStr=""
	s TRRegInfoStr=""
	if (TRFlag="Y"){
		s ret=##Class(web.DHCRBResSession).TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)
		if (+ret'=0){
			q ret
		}else{
			s TRRegNumStr=$P(ret,"^",2)
			s TRRegInfoStr=$P(ret,"^",3)
		}
	}
	s OutPutStr="0^"_RSLRowID_"^"_ResRowID_"^"_WeekDr_"^"_TimeRangeDr
	s OutPutStr=OutPutStr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_RoomDr_"^"_SessLoad_"^"_SessNoApptSlot
	s OutPutStr=OutPutStr_"^"_SessNoSlots_"^"_AddtionMax_"^"_SessNumberOfWeeks_"^"_TRFlag_"^"_TRStartTime
	s OutPutStr=OutPutStr_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_TRRegNumStr_"^"_TRRegInfoStr
	q OutPutStr
}

/// 导入排版模板
/// w ##Class(DHCDoc.DHCDocCure.RBCResPlan).ImportRBResSessData()
ClassMethod ImportRBResSessData(SessData As %String)
{
	s OutPutStr=..ValidateRBResSessData(SessData)
	q:(+OutPutStr<0) OutPutStr
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	s RSLRowID=$P(OutPutStr,"^",2)
	s ResRowID=$P(OutPutStr,"^",3)
	s WeekDr=$P(OutPutStr,"^",4)
	s TimeRangeDr=$P(OutPutStr,"^",5)
	s SessionTypeDr=$P(OutPutStr,"^",6)
	s CLGRPDr=$P(OutPutStr,"^",7)
	s RoomDr=$P(OutPutStr,"^",8)
	s SessLoad=$P(OutPutStr,"^",9)
	s SessNoApptSlot=$P(OutPutStr,"^",10)
	s SessNoSlots=$P(OutPutStr,"^",11)
	s AddtionMax=$P(OutPutStr,"^",12)
	s SessNumberOfWeeks=$P(OutPutStr,"^",13)
	s TRFlag=$P(OutPutStr,"^",14)
	s TRStartTime=$P(OutPutStr,"^",15)
	s TREndTime=$P(OutPutStr,"^",16)
	s TRLength=$P(OutPutStr,"^",17)
	s TRRegNum=$P(OutPutStr,"^",18)
	s TRRegNumStr=$P(OutPutStr,"^",19)
	s TRRegInfoStr=$P(OutPutStr,"^",20)
	
	s LocId=$P(^RB("RES",ResRowID),"^",1)
	s DocId=$P(^RB("RES",ResRowID),"^",2)
	s DOW=WeekDr_$C(1)_$P(^CT("DOW",1,WeekDr),"^",1)
	s TStartTime=$P(^DHCTimeRange(TimeRangeDr),"^",3)
	s TEndTime=$P(^DHCTimeRange(TimeRangeDr),"^",4)
	s:TStartTime'="" TStartTime=$zt(TStartTime,1)
	s:TEndTime'="" TEndTime=$zt(TEndTime,1)
	
	s SessPatientType="O"
	s AutoLoad=""
	s ExtLoad=""
	s InsertData=""_"^"_DOW_"^"_TStartTime_"^"_TEndTime_"^^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot
	s InsertData=InsertData_"^"_SessNumberOfWeeks_"^"_AddtionMax_"^"_RoomDr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_SessPatientType_"^"_TimeRangeDr_"^"_"Y"
	s InsertData=InsertData_"^"_TRFlag_"^"_TRStartTime_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_TRRegNumStr_"^"_TRRegInfoStr_"^"_AutoLoad_"^"_ExtLoad
	
	TS
	if (CLGRPDr'=""){
		s LocSpecCount=0
		&sql(select count(DHCLS_Loc_DR) into :LocSpecCount from SQLUSER.DHC_LocSpec where DHCLS_Loc_DR=:LocId and DHCLS_CG_DR=:CLGRPDr)
		if (SQLCODE=0)&&(LocSpecCount=0)
		{
			//自动插入科室及专业组对照
			d ##Class(web.DHCLocSpec).InsertLocSpec(LocId,CLGRPDr)
		}
	}
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).GetDocDateRowid(LocId, DocId, RSLRowID)
	if (+ret'=0){
		TRO
		q ret_",插入班次失败"
	}
	s ResEffDate=$P(ret,"^",2)
	s ret=##Class(web.DHCRBResSession).Insert(ResEffDate,InsertData)
	if (+ret'=0){
		TRO
		q ret_",插入排版模板失败"
	}
	s SessRowId=$P(ret,"^",2)
	s RetSessRowId=$P(ret,"^",2)
	s paraString=""
	for i=1:1:$L(AppMethodStr,"&") {
		s OneAppMethod=$P(AppMethodStr,"&",i)
		if (OneAppMethod=""){
			continue
		}
		s ApptMethod=$P(OneAppMethod,"|",1)
		s AppQty=$P(OneAppMethod,"|",2)
		s AppStartNum=$P(OneAppMethod,"|",3)
		s ApptMethodDr=$O(^RBC("APTM",0,"Desc",ApptMethod,0))
		if (paraString="") {
			s paraString=SessRowId_"^"_ApptMethodDr_"^"_AppQty_"^"_AppStartNum
		}else{
			s paraString=paraString_","_SessRowId_"^"_ApptMethodDr_"^"_AppQty_"^"_AppStartNum
		}
		
		
	}
	if (paraString'=""){
		s ret=##Class(web.DHCRBResEffDateSessAppQty).SaveScheduleAppQty(paraString)
		if (+ret'=0){
			TRO
			q ret_",插入预约方式限额失败"
		}
	}
	
	TC
	q 0_"^"_RetSessRowId
}

}
