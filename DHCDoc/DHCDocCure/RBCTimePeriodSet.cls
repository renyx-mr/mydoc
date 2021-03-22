Class DHCDoc.DHCDocCure.RBCTimePeriodSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryBookTime() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargeTime:%String,NotAvailFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCTimePeriodSet","QueryBookTime")
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

/// 通过ID获取时间段设置数据
ClassMethod GetCureRBCTimePeriodSetById(Id As %String) As %String
{
	q:Id="" ""
	s Data=$G(^DHCDocCureRBCTimePeriodSet(Id))
	if $p(Data,"^",3)'="" s $p(Data,"^",3)=$zt($p(Data,"^",3),1)
	if $p(Data,"^",4)'="" s $p(Data,"^",4)=$zt($p(Data,"^",4),1)
	if $p(Data,"^",5)'="" s $p(Data,"^",5)=$zt($p(Data,"^",5),1)
	q Data
}

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.RBCTimePeriodSet).SaveCureRBCTimePeriodSet("^01^早上^08:30:00^08:30:00^^")
ClassMethod SaveCureRBCTimePeriodSet(value As %String) As %String
{
	s ^TMP("SaveCureRBCTimePeriodSet")=value
	Q:value="" -1
	Set DDCTSROWID=$P(value,"^")
	Set DDCTSCode=$P(value,"^",2)
	Set DDCTSDesc=$P(value,"^",3)
	Set DDCTSStartTime=$P(value,"^",4)
	Set DDCTSEndTime=$P(value,"^",5)
	Set DDCTSEndChargeTime=$P(value,"^",6)
	Set DDCTSNotAvailFlag=$P(value,"^",7)
	Q:DDCTSCode="" 100
	S RowID=$O(^DHCDocCureRBCTimePeriodSet(0,"Code",DDCTSCode,""))
	Q:(DDCTSROWID="")&&(RowID'="") 101
	Q:(DDCTSROWID'="")&&(RowID'="")&&(RowID'=DDCTSROWID) 101
	s:DDCTSStartTime'="" DDCTSStartTime=$zth(DDCTSStartTime,1)
	s:DDCTSEndTime'="" DDCTSEndTime=$zth(DDCTSEndTime,1)
	s:DDCTSEndChargeTime'="" DDCTSEndChargeTime=$zth(DDCTSEndChargeTime,1)
	K PLIST
	s PLIST(2)=DDCTSCode
	s PLIST(3)=DDCTSDesc
	s PLIST(4)=DDCTSStartTime
	s PLIST(5)=DDCTSEndTime
	s PLIST(6)=DDCTSEndChargeTime
	s PLIST(7)=DDCTSNotAvailFlag
	if DDCTSROWID="" 
	{	
	 	&sql(insert into SQLUser.DHC_DocCureRBCTimePeriodSet values :PLIST())	
	}else{
		&sql(update SQLUser.DHC_DocCureRBCTimePeriodSet values :PLIST() where DDCTS_Rowid=:DDCTSROWID ) 
	}
	q SQLCODE
}

ClassMethod DeleteCureRBCTimePeriodSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureRBCTimePeriodSet where DDCTS_Rowid=:Rowid)
	 q SQLCODE
}

}
