Class DHCDoc.DHCDocCure.RBCResSchdule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 通过排班ID获取排班信息
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(1)
ClassMethod GetResApptSchuldeInfo(ASRowID As %String) As %String
{
	n (ASRowID)
	Q:ASRowID="" ""
	s Data=$g(^DHCDocCureRBCResSchdule(ASRowID))
	s DDCRSLocDR=$p(Data,"^",2)  //排班科室ID
	s DDCRSResSourceDR=$p(Data,"^",3)  //排班资源ID
	s DDCRSDate=$p(Data,"^",4)  //出诊日期
	s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
	s DDCRSStartTime=$p(Data,"^",6)  //开始时间
	s DDCRSEndTime=$p(Data,"^",7)  //结束时间
	s DDCRSServiceGroupDR=$p(Data,"^",8)  //服务组ID
	s DDCRSStatus=$p(Data,"^",9)  //排程记录状态
	s DDCRSMaxNumber=$p(Data,"^",10)  //最大预约数
	s DDCRSAutoNumber=$p(Data,"^",11)  //自动预约数
	s DDCRSChargeTime=$p(Data,"^",12)  //截止缴费时间
	s DDCRSAvailPatType=$p(Data,"^",13)  //允许预约的病人类型
	s DDCRSAutoAvtiveFlag=$p(Data,"^",14)  //自动预约启用开关
	i DDCRSLocDR'=""  d
	.s DDCRSLoc=$P($G(^CTLOC(DDCRSLocDR)),"^",2)
	.i $P(DDCRSLoc,"-",2)'="" s DDCRSLoc=$P(DDCRSLoc,"-",2)
	i DDCRSResSourceDR'=""  d
	.s CTCareProvDr=$P($G(^RB("RES",DDCRSResSourceDR)),"^",2)
	.i CTCareProvDr'=""  d
	..s CTCareProv=$p($g(^CTPCP(CTCareProvDr,1)),"^",2)
	..i $P(CTCareProv,"-",2)'="" s CTCareProv=$P(CTCareProv,"-",2)
	s:DDCRSDate'="" DDCRSDate=##class(websys.Conversions).DateLogicalToHtml(DDCRSDate) ;$zd(DDCRSDate,3)
	i DDCRSTimeRangeDR'="" d
	.s DDCRSTimeRangeDesc=$P($G(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",2)
	s:DDCRSStartTime'="" DDCRSStartTime=$zt(DDCRSStartTime)
	s:DDCRSEndTime'="" DDCRSEndTime=$zt(DDCRSEndTime)
	i DDCRSServiceGroupDR'="" d
	.s DDCRSServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(DDCRSServiceGroupDR)),"^",2)
	s DDCRSStatus=$case(DDCRSStatus,"N":"正常","S":"停诊",:"")
	s:DDCRSChargeTime'="" DDCRSChargeTime=$zt(DDCRSChargeTime)
	Q DDCRSLocDR_"^"_$G(DDCRSLoc)_"^"_DDCRSResSourceDR_"^"_CTCareProv_"^"_DDCRSDate_"^"_DDCRSTimeRangeDR_"^"_DDCRSTimeRangeDesc_"^"_DDCRSStartTime_"^"_DDCRSEndTime_"^"_DDCRSServiceGroupDR_"^"_DDCRSServiceGroupDesc_"^"_DDCRSStatus_"^"_DDCRSMaxNumber_"^"_DDCRSAutoNumber_"^"_DDCRSChargeTime_"^"_DDCRSAvailPatType_"^"_DDCRSAutoAvtiveFlag
}

/// 生成资源的排版计划
/// 修改可以按科室生成排版计划 
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).CreateResApptSchulde(^TMP("CreateResApptSchulde"),"1","1")
ClassMethod CreateResApptSchulde(Info As %String, UserID As %String, hisui As %String = "") As %String
{
	n (Info,UserID,hisui)
	s $ztrap="CreateResApptSchuldeErr"
	s ^TMP("CreateResApptSchulde")=Info
	s LocId=$p(Info,"^",1)
	s StartDate=$p(Info,"^",2)
	s EndDate=$p(Info,"^",3)
	s ResourceId=$p(Info,"^",4)
	q:(LocId="") 100
	q:EndDate="" 100
	s ResID=..GetResIdByLocRowid(LocId,ResourceId)
	
	if hisui=""{
		s:StartDate'="" StartDate=$zdh(StartDate,1)
		s:EndDate'="" EndDate=$zdh(EndDate,1)
	}else{
		;hisui改造后日期格式按照系统格式
		if StartDate["/" s StartDate=$zdh(StartDate,4)
		if EndDate["/" s EndDate=$zdh(EndDate,4)
		if StartDate["-" s StartDate=$zdh(StartDate,3)
		if EndDate["-" s EndDate=$zdh(EndDate,3)
	}
	i StartDate="" s StartDate=+$h
	i EndDate="" s EndDate=+$h
	s errcount=0
    for CurrDate=StartDate:1:EndDate d
     .for i=1:1:$l(ResID,"@") d
     ..s ResourceId=$p(ResID,"@",i)
     ..q:ResourceId=""
     ..s WeekNum=$zd(CurrDate,10)
     ..i WeekNum=0 s WeekNum=7
     ..s DDCRPRowid=0 f  s DDCRPRowid=$o(^DHCDocCureRBCResPlan(0,"Week-Resource",WeekNum,LocId,ResourceId,DDCRPRowid)) q:DDCRPRowid=""  d
	 ...s TimeRangeDR=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",4)  //时间段代码
	 ...s StartTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",5)
	 ...s EndTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",6)
	 ...s ServiceGroupID=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",7)
	 ...s MaxNumber=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",8)
     ...s AutoNumber=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",9)
     ...s ChargTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",10)
     ...s AvailPatType=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",11)
     ...s AutoAvtiveFlag=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",12)
     ...s Para=CurrDate_"^"_LocId_"^"_ResourceId_"^"_TimeRangeDR_"^"_StartTime_"^"_EndTime_"^"_ServiceGroupID_"^"_MaxNumber_"^"_AutoNumber_"^"_ChargTime_"^"_AvailPatType_"^"_AutoAvtiveFlag
     ...s ret=..InsertOneRBCSchedule(Para,UserID)
     ...if +ret'=0  s errcount=errcount+errcount 
     q 0
CreateResApptSchuldeErr
   q 1000
}

/// 新增一条排班记录
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).InsertOneRBCSchedule(^zhou("InsertOneRBCSchedule"),1,1)
ClassMethod InsertOneRBCSchedule(Para As %String, UserID As %String, hisui As %String = "")
{
	s ^zhou("InsertOneRBCSchedule")=Para
	s ASDate=$P(Para,"^",1)
	s LocRowID=$P(Para,"^",2)
	s ResRowID=$P(Para,"^",3)
	s TRRowId=$P(Para,"^",4)
	s SessStartTime=$P(Para,"^",5)
	s SessEndTime=$P(Para,"^",6)
	s ServiceGroupRowID=$P(Para,"^",7)
	s MaxNum=$P(Para,"^",8)
	s AutoNum=$P(Para,"^",9)
	s ChargeTime=$P(Para,"^",10)
	s AvailPatType=$P(Para,"^",11)
	s AutoAvtiveFlag=$P(Para,"^",12)
	
	if MaxNum="" s MaxNum=1
	
	if hisui=""{
		s:ASDate["/" ASDate=$zdh(ASDate,1)
	}else{
		;hisui改造后日期格式按照系统格式
		if ASDate["/" s ASDate=$zdh(ASDate,4)
		if ASDate["-" s ASDate=$zdh(ASDate,3)
	}
	if SessStartTime[":"  s SessStartTime=$zth(SessStartTime)
	s:SessStartTime="" SessStartTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",3)
	if SessEndTime[":"  s SessEndTime=$zth(SessEndTime)
	s:SessEndTime="" SessEndTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",4)
    if ChargeTime[":" s ChargeTime=$zth(ChargeTime)
    s ret=..CheckRBCSchedule(LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)
    if (ret=1){
		s ^TMPInsertSchedule("DHCDoc.DHCDocCure.RBCResSchdule","CheckRBCSchedule",LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)=LocRowID_","_ResRowID_","_ASDate_","_TRRowId_","_ServiceGroupRowID 
	}
    b ;ret
    if ret=1  Q 101
	Set object = ##class(User.DHCDocCureRBCResSchdule).%New(ResRowID)
	Do object.DDCRSLocDRSetObjectId(LocRowID)
	Do object.DDCRSResSourceDRSetObjectId(ResRowID)
	set object.DDCRSDate=ASDate
	DO object.DDCRSTimeRangeDRSetObjectId(TRRowId)
	set object.DDCRSStartTime=SessStartTime
	set object.DDCRSEndTime=SessEndTime
	DO object.DDCRSServiceGroupDRSetObjectId(ServiceGroupRowID)
	set object.DDCRSStatus="N" 
	;预约限额
	set object.DDCRSMaxNumber=MaxNum
	set object.DDCRSAutoNumber=AutoNum
	set object.DDCRSChargeTime=ChargeTime
	set object.DDCRSAvailPatType=AvailPatType
	set object.DDCRSAutoAvtiveFlag=AutoAvtiveFlag
	DO object.DDCRSCreateUserDRSetObjectId(UserID)
	set object.DDCRSCreateDate=+$H
	set object.DDCRSCreateTime=$P($H,",",2)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	Set ASRowid=object.%Id()
	do object.%Close()
	Q 0 //_"^"_ASRowid
}

/// 检查是否已经有排班
ClassMethod CheckRBCSchedule(LocRowID As %String, ResRowID As %String, ASDate As %String, TRRowId As %String, ServiceGroupRowID As %String = "")
{
	n (LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)
	s FindFlag=0
	s ResSchduleID=""  for  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocRowID,ASDate,ResRowID,ResSchduleID))  q:(ResSchduleID="")||(FindFlag=1)  d
	.s TimeDescCode=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",5)
	.s DDCRSStatus=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",9)
	.s ServiceGroupDr=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",8)
	.q:DDCRSStatus'="N"
	.q:(ServiceGroupRowID'="")&&(ServiceGroupDr'=ServiceGroupRowID)
	.i TRRowId=TimeDescCode  s FindFlag=1
	q FindFlag
}

/// 修改一条排班记录
/// ;w ##class(DHCDoc.DHCDocCure.RBCResSchdule).UpdateOneRBCSchedule("3^1^09:00:00^11:00:00^1^70^^")
ClassMethod UpdateOneRBCSchedule(Para As %String, UserID As %String)
{
	s ^zhou("UpdateOneRBCSchedule")=Para
	s DDCRSRowId=$P(Para,"^",1)
	s TRRowId=$P(Para,"^",2)
	s SessStartTime=$P(Para,"^",3)
	s SessEndTime=$P(Para,"^",4)
	s ServiceGroupRowID=$P(Para,"^",5)
	s MaxNum=$P(Para,"^",6)
	s AutoNum=$P(Para,"^",7)
	s ChargeTime=$P(Para,"^",8)
	s AvailPatType=$P(Para,"^",9)
	s AutoAvtiveFlag=$P(Para,"^",10)
	
	if MaxNum="" s MaxNum=1
	if SessStartTime'=""  s SessStartTime=$zth(SessStartTime)
	else  s SessStartTime=$P(^DHCDocCureRBCTimePeriodSet(TRRowId),"^",3)
	if SessEndTime'=""  s SessEndTime=$zth(SessEndTime)
	else  s SessEndTime=$P(^DHCDocCureRBCTimePeriodSet(TRRowId),"^",4)
    s:ChargeTime'="" ChargeTime=$zth(ChargeTime)
    
	Set object = ##class(User.DHCDocCureRBCResSchdule).%OpenId(DDCRSRowId)
	;DO object.DDCRSTimeRangeDRSetObjectId(TRRowId)
	set object.DDCRSStartTime=SessStartTime
	set object.DDCRSEndTime=SessEndTime
	DO object.DDCRSServiceGroupDRSetObjectId(ServiceGroupRowID)
	;set object.DDCRSStatus=DDCRSStatus 
	set object.DDCRSMaxNumber=MaxNum
	set object.DDCRSAutoNumber=AutoNum
	set object.DDCRSChargeTime=ChargeTime
	set object.DDCRSAvailPatType=AvailPatType
	set object.DDCRSAutoAvtiveFlag=AutoAvtiveFlag
	DO object.DDCRSCreateUserDRSetObjectId(UserID)
	set object.DDCRSLastUpdateDate=+$H
	set object.DDCRSLastUpdateTime=$P($H,",",2)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	do object.%Close()
	Q 0
}

/// 停诊/撤销停诊单条资源排班
/// 入参  ASRowID 排班ID, UserID: 用户ID
/// 返回值  0 为成功,非0 为失败
ClassMethod StopOneRBCSchedule(ASRowID As %String, UserID As %String) As %String
{
	set schedule=##class(User.DHCDocCureRBCResSchdule).%OpenId(ASRowID)
	set DDCRSStatus=schedule.DDCRSStatus
	if DDCRSStatus="S" s DDCRSStatus="N"
	else  if DDCRSStatus="N" s DDCRSStatus="S"
	if (DDCRSStatus="N"){
		s LocRowID=schedule.DDCRSLocDR.%Id()
		s ASDate=schedule.DDCRSDate
		s TRRowId=schedule.DDCRSTimeRangeDR.%Id()
		s ResRowID=schedule.DDCRSResSourceDR.%Id()
		s ret=..CheckRBCSchedule(LocRowID,ResRowID,ASDate,TRRowId)
        if ret=1  {
	        Q 101
	    }
	}
	set schedule.DDCRSStatus=DDCRSStatus
	set schedule.DDCRSLastUpdateDate=+$H
	set schedule.DDCRSLastUpdateTime=$P($H,",",2)
	Do schedule.DDCRSLastUpdateUserDRSetObjectId(UserID)
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	Q 0
}

/// 根据科室ID获取所有设备ID
/// sunyi 2012-01-10  
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResIdByLocRowid("83")
ClassMethod GetResIdByLocRowid(LocID As %String, ResourceId As %String = "") As %String
{
	n (LocID,ResourceId)
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryResource")
	s ret=""
	do rset.Execute(LocID)
	while (rset.Next())
	{
		continue:(ResourceId'="")&&(ResourceId'=rset.GetData(2))
		i ret="" s ret=rset.GetData(2)
	    e  s ret=ret_"@"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 函数：QueryResApptSchdule
/// 功能：查询资源排班
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryResApptSchdule","66425||788","83","","")
Query QueryResApptSchdule(LocId As %String, ResourceId As %String, BookDate As %String, ResGroupID As %String = "") As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDr:%String,LocDesc:%String,ResourceDr:%String,ResourceDesc:%String,TimePeriodCode:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDr:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String")
{
}

ClassMethod QueryResApptSchduleExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, BookDate As %String, ResGroupID As %String = "") As %Status
{
	s ^TMP("QueryResApptSchdule")=LocId_"^"_ResourceId_"^"_BookDate
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i BookDate="" s BookDate=+$h
 	else  if BookDate["-" s BookDate=$zdh(BookDate,3)
 	else  if BookDate["/" s BookDate=$zdh(BookDate,4)
	i LocId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i ResourceId="" d
	.s ResourceId=0 f  s ResourceId=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
	..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
	...d OutRowResApptSchdule
	else  d
	.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
  	..d OutRowResApptSchdule 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutRowResApptSchdule
    Set Data=..GetResApptSchuldeInfo(ResSchduleID)
    Set LocDr=$p(Data,"^",1)
    Set LocDesc=$p(Data,"^",2)
    Set ResourceDr=$p(Data,"^",3)
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimePeriodCode=$p(Data,"^",6)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDr=$p(Data,"^",10)
    q:(ResGroupID'="")&&(ResGroupID'=ServiceGroupDr)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ResSchduleID)
    set AppedLeftNumber=MaxNumber-ResAppCount
    set Data=$lb(ResSchduleID,DDCRSDate,LocDr,LocDesc,ResourceDr,ResourceDesc,TimePeriodCode,TimeDesc,StartTime,EndTime,ServiceGroupDr,ServiceGroupDesc,DDCRSStatus,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag,ResAppCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResApptSchduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResApptSchduleExecute ]
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

ClassMethod QueryResApptSchduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResApptSchduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 为治疗申请单查找可以预约的排班
Query QueryAvailResApptSchduleBak(DCARowId As %String, BookDate As %String) As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,AppedNumber:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryAvailResApptSchdule","8735||1","02/22/2016")
ClassMethod QueryAvailResApptSchduleBakExecute(ByRef qHandle As %Binary, DCARowId As %String, BookDate As %String) As %Status
{
	s ^TMP("QueryAvailResApptSchdule")=DCARowId_"^"_BookDate
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i BookDate="" s BookDate=+$h+1
 	else  s BookDate=$zdh(BookDate,1)
	i DCARowId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	;lxz  如果使用的手工填写申请单的至认证医嘱项目
	s OrderStatus="V"
	Set OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	i OrderId'=""  d
	.s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	.s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
	.s:OrdStatusDR'="" OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	.s ReLocID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	else  d
	.s ArcimId=$p($g(^DHCDocCure(DCARowId)),"^",12)
	.s ReLocID=$p($g(^DHCDocCure(DCARowId)),"^",13)
	i ArcimId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i (OrderStatus'="V")&&(OrderStatus'="E") s qHandle=$lb(0,repid,0) Quit $$$OK
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
	i DDCISRowid="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	i ServiceGroupDR="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s StartTimeVal=0 f  s StartTimeVal=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal))  q:StartTimeVal=""  d
	.s ResSchduleID="" f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal,ResSchduleID)) q:ResSchduleID=""  d
	..d OutRowAvailResApptSchduleBak
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutRowAvailResApptSchduleBak
    Set Data=..GetResApptSchuldeInfo(ResSchduleID)
    Set DDCRSLocDR=$p(Data,"^",1)
    Q:ReLocID'=DDCRSLocDR
    Set LocDesc=$p(Data,"^",2)
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set AppedNumber=##class(DHCDoc.DHCDocCure.Appointment).GetRBCResSchduleAppedNum(ResSchduleID)
    set Data=$lb(ResSchduleID,DDCRSDate,LocDesc,ResourceDesc,TimeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,AppedNumber,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 为治疗申请单查找可以预约的排班
Query QueryAvailResApptSchdule(DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,AppedLeftNumber:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryAvailResApptSchdule","","","3!4!5")
ClassMethod QueryAvailResApptSchduleExecute(ByRef qHandle As %Binary, DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "") As %Status
{
	s ^TMP("QueryAvailResApptSchdule")=DCARowId_"^"_BookDate_"^"_DCARowIdStr
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s DateFormat=##class(websys.Conversions).DateFormat()
 	;if $l(BookDate,"/")=3  s BookDate=$zdh(BookDate,4)
	;else  if $l(BookDate,"-")=3  s BookDate=$zdh(BookDate,3)
	if BookDate'="" s BookDate=$zdh(BookDate,DateFormat)
	else  s BookDate=+$h
	
	i (DCARowId="")&&(DCARowIdStr="") s qHandle=$lb(0,repid,0) Quit $$$OK
	
	S OrdRecLocStr=""
	if DCARowIdStr'=""{
		s DCARowIdStrLen=$l(DCARowIdStr,"!")
		for myIDCount=1:1:DCARowIdStrLen{
			s oneDCARowId=$p(DCARowIdStr,"!",myIDCount)
			s CureOrderId=$p($g(^DHCDocCure(oneDCARowId)),"^",2)
			s OrdRecLoc=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
			s OrderStatus=""
			s OrdStatusDR=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",13)
			s:OrdStatusDR'="" OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
			continue:(OrderStatus'="V")&&(OrderStatus'="E")
			s OrdRecLoc=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(OrdRecLoc)
			if OrdRecLocStr="" s OrdRecLocStr=OrdRecLoc
			else  s OrdRecLocStr=OrdRecLocStr_"^"_OrdRecLoc
			s DCARowId=oneDCARowId
		}
	}else{
		s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		s OrdRecLoc=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		s OrdRecLoc=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(OrdRecLoc)
		if OrdRecLocStr="" s OrdRecLocStr=OrdRecLoc
		else  s OrdRecLocStr=OrdRecLocStr_"^"_OrdRecLoc	
	}
	i (DCARowId="") s qHandle=$lb(0,repid,0) Quit $$$OK
	
	Set OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	i OrderId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	i ArcimId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	
	if OrdRecLocStr'="" s OrdRecLocStr="^"_OrdRecLocStr_"^"
	s OrderStatus=""
	s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
	s:OrdStatusDR'="" OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	i (OrderStatus'="V")&&(OrderStatus'="E") s qHandle=$lb(0,repid,0) Quit $$$OK
	s ReLocID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
	i DDCISRowid="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	i ServiceGroupDR="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s StartTimeVal=0 f  s StartTimeVal=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal))  q:StartTimeVal=""  d
	.s ResSchduleID="" f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal,ResSchduleID)) q:ResSchduleID=""  d
	..d OutRowAvailResApptSchdule
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutRowAvailResApptSchdule
    Set Data=..GetResApptSchuldeInfo(ResSchduleID)
    Set DDCRSLocDR=$p(Data,"^",1)
    B ;Q:ReLocID'=DDCRSLocDR
    Q:(OrdRecLocStr'="")&&(OrdRecLocStr'[("^"_DDCRSLocDR_"^"))
    Set LocDesc=$p(Data,"^",2)
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ResSchduleID)
    set AppedLeftNumber=MaxNumber-ResAppCount
    set Data=$lb(ResSchduleID,DDCRSDate,LocDesc,ResourceDesc,TimeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag,ResAppCount,AppedLeftNumber)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAvailResApptSchduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAvailResApptSchduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAvailResApptSchduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAvailResApptSchduleExecute ]
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

}
