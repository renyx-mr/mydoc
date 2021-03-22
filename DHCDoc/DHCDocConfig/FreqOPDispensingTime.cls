/// creator:宋春莉
/// date:2015-04-01
/// desc:医生站设置程序->门诊频率分发时间设定
Class DHCDoc.DHCDocConfig.FreqOPDispensingTime Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      宋春莉
/// CreatDate：    2015-04-01
/// Description:： 查询频率    
/// Input：         无
/// Output：        
/// Return：       
Query FindFreq() As %Query(ROWSPEC = "FreqRowId:%String,FreqCode:%String,FreqFactor:%String,FreqDays:%String,FreqDesc1:%String,FreqDesc2:%String,WeekFlag:%String,EveryDayFlag:%String")
{
}

ClassMethod FindFreqExecute(ByRef qHandle As %Binary) As %Status
{
	s ^FindFreq("FindFreq")="cheng"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.FreqOPDispensingTime","FindFreq")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s FreqRowId=0
 	f  s FreqRowId=$o(^PHCFR(FreqRowId)) q:FreqRowId=""  d
 	.s str=$g(^PHCFR(FreqRowId))
 	.s FreqCode=$p(str,"^",1)
 	.s FreqFactor=$p(str,"^",2)
 	.s FreqDays=$p(str,"^",5)
 	.s FreqDesc1=$p(str,"^",3)
 	.s FreqDesc2=$p(str,"^",4)
 	.s WeekFlag=$P($g(^PHCFR(FreqRowId,"DHC")),"^",1)
 	.i WeekFlag=1 s WeekFlag="Y"
 	.e  s WeekFlag=""
 	.s EveryDayFlag=$P($g(^PHCFR(FreqRowId,"DHC")),"^",2)
 	.i EveryDayFlag=1 s EveryDayFlag="Y" e  s EveryDayFlag=""
	.s FreqDesc1=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(FreqDesc1)	
	.s FreqDesc1=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(FreqDesc1)
	.s FreqDesc2=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(FreqDesc2)	
	.s FreqDesc2=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(FreqDesc2)	
	.Do OutputRowFindFreq
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindFreq
	set Data=$lb($g(FreqRowId),$g(FreqCode),$g(FreqFactor),$g(FreqDays),$g(FreqDesc1),$g(FreqDesc2),$g(WeekFlag),$g(EveryDayFlag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqExecute ]
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

/// Creator：      宋春莉
/// CreatDate：    2015-04-01
/// Description:： 查询频率门诊分发时间    
/// Input：         无
/// Output：        
/// Return：       
Query FindOPDispensingTime(FreqRowid As %String) As %Query(ROWSPEC = "rowid:%String,time:%String,weekrowid:%String,week:%String")
{
}

ClassMethod FindOPDispensingTimeExecute(ByRef qHandle As %Binary, FreqRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.FreqOPDispensingTime","FindOPDispensingTime",6)
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s childsub=0  f  s childsub=$O(^PHCFR(FreqRowid,"OPDT",childsub)) Q:childsub=""  d
    .s time=$p(^PHCFR(FreqRowid,"OPDT",childsub),"^",1)
    .s time=$zt(time)
    .s weekrowid=$p(^PHCFR(FreqRowid,"OPDT",childsub),"^",2)
    .s week=""
    .i weekrowid'="" s week=$P(^CT("DOW",1,weekrowid),"^",1)
    .s rowid=FreqRowid_"||"_childsub
	.Do OutputRowFindOPDispensingTime
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPDispensingTime
	set Data=$lb($g(rowid),$g(time),$g(weekrowid),$g(week))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPDispensingTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPDispensingTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPDispensingTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPDispensingTimeExecute ]
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

/// Creator：      宋春莉
/// CreatDate：    2015-04-01
/// Description:： 查询日期    
/// Input：         无
/// Output：        
/// Return：       
Query FindWeekList() As %Query(ROWSPEC = "weekId:%String,weekDesc:%String")
{
}

ClassMethod FindWeekListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.FreqOPDispensingTime","FindWeekList")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s weekId=0
 	f  s weekId=$o(^CT("DOW",1,weekId)) q:weekId=""  d
 	.s weekDesc=$p(^CT("DOW",1,weekId),"^",1)
	.Do OutputRowFindWeekList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindWeekList
	set Data=$lb($g(weekId),$g(weekDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindWeekListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWeekListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWeekListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWeekListExecute ]
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

ClassMethod DeleteTime(Rowid As %String) As %String
{
	/*&sql(delete from DHC_PHCDispensingTime where PHCDT_Rowid=:Rowid)
	q SQLCODE
	*/
	zn "dhc-data"
	s rtn=$$delete^DHCPHCDispensingTime(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod insertTime(Rowid As %String, FreqRowid As %String, Time As %String, weekId As %String) As %String
{
	s ^scl("insertTime")=Rowid_","_FreqRowid_","_Time_","_weekId
	k PLIST
	s PLIST(4)=weekId
	s PLIST(3)=Time
	zn "dhc-data"
	if (+Rowid=0){
		s rtn=$$insert^DHCPHCDispensingTime(FreqRowid)
	}else{
		s rtn=$$update^DHCPHCDispensingTime(Rowid)
	}
	zn "dhc-app"
	q rtn
}

ClassMethod find(FreqRowid As %String, Time As %String, weekId As %String) As %String
{
	zn "dhc-data"
	s rtn=$$find^DHCPHCDispensingTime(FreqRowid,Time,weekId)
	zn "dhc-app"
	q rtn
}

ClassMethod updateweekflag(Rowid As %String, weekflag As %String) As %String
{
	s ^tmpscl("updateweekflag")=Rowid_","_weekflag
	s n=0,Num1=0,Num2=0
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.FreqOPDispensingTime:FindOPDispensingTime")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(Rowid)
		If 'Status Quit
		While (rset.Next()) {
			s week=rset.GetData(4)
			if (week="") s Num1=Num1+1
			else  s Num2=Num2+1
			//s n=n+1
		}
	}
	q:(Num2>0)&&(weekflag="") 2
	q:(Num1>0)&&(weekflag="1") 3
	zn "dhc-data"
	s rtn=$$updateweekflag^DHCPHCDispensingTime(Rowid,weekflag)
	zn "dhc-app"
	q rtn
}

ClassMethod updateNotDeferFlag(Rowid As %String, NotDeferFlag As %String) As %String
{
	zn "dhc-data"
	s rtn=$$updateNotDeferFlag^DHCPHCDispensingTime(Rowid,NotDeferFlag)
	zn "dhc-app"
    q 1
}

ClassMethod getweekflag(Rowid As %String) As %String
{
}

/// 清除门诊频率分发时间配置,统一走基础设置-》频率设定
/// d ##class(DHCDoc.DHCDocConfig.FreqOPDispensingTime).clearFreqOPDispensingTime()
ClassMethod clearFreqOPDispensingTime() As %String
{
	zn "dhc-data"
	s FreqRowId=0
 	f  {
	 	s FreqRowId=$o(^PHCFR(FreqRowId)) q:FreqRowId="" 
	 	s childsub=0  f {
		 	 s childsub=$O(^PHCFR(FreqRowId,"OPDT",childsub)) Q:childsub=""
		 	 s rtn=$$delete^DHCPHCDispensingTime(FreqRowId_"||"_childsub)
		}
		s rtn=$$updateweekflag^DHCPHCDispensingTime(FreqRowId,"")
		s rtn=$$updateNotDeferFlag^DHCPHCDispensingTime(FreqRowId,"")
		
	}
	zn "dhc-app"
}

}
