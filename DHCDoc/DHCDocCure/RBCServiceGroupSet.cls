Class DHCDoc.DHCDocCure.RBCServiceGroupSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryServiceGroup(config As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCServiceGroupSet","QueryServiceGroup")
ClassMethod QueryServiceGroupExecute(ByRef qHandle As %Binary, config As %String = "") As %Status
{
	s ind=1
 Set repid=$I(^CacheTemp)
 s ServiceGroupRowid=0  f  s ServiceGroupRowid=$o(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid)) q:ServiceGroupRowid=""  d
 .d OutServiceGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutServiceGroup
 s ServiceGroupCode=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",1)
 s ServiceGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",2)
 s DateFrom=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",3)
 Q:(config'=1)&&(DateFrom'="")&&(DateFrom>+$H)
 i DateFrom'="" d
 .s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom) ;$zd(DateFrom,3)
 s DateTo=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",4)
 Q:(config'=1)&&(DateTo'="")&&(DateTo<+$H)
 i DateTo'="" d 
 .s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo) ;$zd(DateTo,3)
 set Data=$lb(ServiceGroupRowid,ServiceGroupCode,ServiceGroupDesc,DateFrom,DateTo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryServiceGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryServiceGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
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

/// 通过ID判断服务组是否已过期
ClassMethod CheckServiceGroupActive(Id As %String) As %String
{
	q:Id="" 0
	s ret=1
	s DateFrom=$p(^DHCDocCureRBCServiceGroupSet(Id),"^",3)
	if (DateFrom'="")&&(DateFrom>+$H) s ret=0
	i DateFrom'="" d
	s DateTo=$p(^DHCDocCureRBCServiceGroupSet(Id),"^",4)
	if (DateTo'="")&&(DateTo<+$H) s ret=0
	q ret
}

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).SaveCureRBCServiceGroupSet("^01^针灸组^02/23/2016^")
ClassMethod SaveCureRBCServiceGroupSet(str As %String, hisui As %String = "") As %String
{
	n (str,hisui)
	s ^TMP("SaveCureRBCServiceGroupSet")=str
	Q:str="" -1
	Set DDCSGSROWID=$P(str,"^")
	Set DDCSGSCode=$P(str,"^",2)
	Set DDCSGSDesc=$P(str,"^",3)
	Set DDCSGSDateFrom=$P(str,"^",4)
	Set DDCSGSDateTo=$P(str,"^",5)
	if hisui=""{
		s:DDCSGSDateFrom'="" DDCSGSDateFrom=$zdh(DDCSGSDateFrom,1)
		s:DDCSGSDateTo'="" DDCSGSDateTo=$zdh(DDCSGSDateTo,1)
	}else{
		;hisui改造后日期格式按照系统格式
		if DDCSGSDateFrom["/" s DDCSGSDateFrom=$zdh(DDCSGSDateFrom,4)
		if DDCSGSDateTo["/" s DDCSGSDateTo=$zdh(DDCSGSDateTo,4)
		if DDCSGSDateFrom["-" s DDCSGSDateFrom=$zdh(DDCSGSDateFrom,3)
		if DDCSGSDateTo["-" s DDCSGSDateTo=$zdh(DDCSGSDateTo,3)
	}
	if (DDCSGSDateFrom'="")&&(DDCSGSDateTo'="")&&(DDCSGSDateTo<DDCSGSDateFrom) Q 201
	S RowID=$O(^DHCDocCureRBCServiceGroupSet(0,"Code",DDCSGSCode,""))
	Q:(DDCSGSROWID="")&&(RowID'="") 101
	Q:(DDCSGSROWID'="")&&(RowID'="")&&(RowID'=DDCSGSROWID) 101
	K PLIST
	s PLIST(2)=DDCSGSCode
	s PLIST(3)=DDCSGSDesc
	s PLIST(4)=DDCSGSDateFrom
	s PLIST(5)=DDCSGSDateTo
	if DDCSGSROWID="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCureRBCServiceGroupSet values :PLIST())
	 	
	}else{
		&sql(update SQLUser.DHC_DocCureRBCServiceGroupSet values :PLIST() where DDCSGS_Rowid=:DDCSGSROWID )
	}
	q SQLCODE
}

ClassMethod DeleteCureRBCServiceGroupSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureRBCServiceGroupSet where DDCSGS_Rowid=:Rowid)
	 q SQLCODE
}

// 以下为服务组下可分配资源配置

/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).SaveTriageResource(^TMP("SaveTriageResource"))
ClassMethod SaveTriageResource(str As %String) As %String
{
	n (str)
	s ^TMP("SaveTriageResource")=str
	Q:str="" -1
	Set ROWID=$P(str,"^")
	Set DDCTRCTLocDr=$P(str,"^",2)
	Set DDCTRCTPCPDr=$P(str,"^",3)
	Set DDCTRParRef=$P(str,"^",4)
	Set DDCTRActive=$P(str,"^",5)
	Set DDCTRCount=$P(str,"^",6)
	s FRowID=""
	S ChildSub=$O(^DHCDocCureTRi(0,"RES",DDCTRCTLocDr,DDCTRCTPCPDr,DDCTRParRef,0))
	if (ChildSub'="") s FRowID=DDCTRParRef_"||"_ChildSub
	Q:(ROWID="")&&(FRowID'="") 101
	Q:(ROWID'="")&&(FRowID'="")&&(ROWID'=FRowID) 102
	K PLIST
	s PLIST(3)=DDCTRCTLocDr
	s PLIST(4)=DDCTRCTPCPDr
	s PLIST(5)=DDCTRActive
	s PLIST(6)=DDCTRCount
	if ROWID="" 
	{
		s PLIST(0)=DDCTRParRef
	 	&sql(insert into SQLUser.DHC_DocCureTriageResource values :PLIST())
	 	
	}else{
		&sql(update SQLUser.DHC_DocCureTriageResource values :PLIST() where DDCTR_RowID=:ROWID )
	}
	q SQLCODE
}

ClassMethod DeleteTriageResource(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureTriageResource where DDCTR_RowID=:Rowid)
	 q SQLCODE
}

Query QueryTriageResource(LocRowID As %String = "") As %Query(ROWSPEC = "DDCTRROWID:%String,DDCTRServiceGroupID:%String,DDCTRServiceGroup:%String,DDCTRCTLocID:%String,DDCTRCTLoc:%String,DDCTRCTPCPID:%String,DDCTRCTPCP:%String,DDCTRActive:%String,DDCTRCount:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCServiceGroupSet","QueryTriageResource")
ClassMethod QueryTriageResourceExecute(ByRef qHandle As %Binary, LocRowID As %String = "") As %Status
{
	s ind=1
 Set repid=$I(^CacheTemp)
 s DDCTRParRef=0  f  s DDCTRParRef=$o(^DHCDocCureTR(DDCTRParRef)) q:DDCTRParRef=""  d
 .s DDCTRChildSub=0 f  s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""  d
 ..d OutTriageResource
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutTriageResource
 s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
 Q:'$d(^DHCDocCureRBCServiceGroupSet(DDCTRParRef))
 s RowID=DDCTRParRef_"||"_DDCTRChildSub
 s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
 s DDCTRCTLocDr=$p(TRData,"^",1)
 Q:(LocRowID'="")&&(LocRowID'=DDCTRCTLocDr)
 s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
 s DDCTRResDr=$p(TRData,"^",2)
 s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
 s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
 s DDCTRActive=$p(TRData,"^",3)
 if DDCTRActive="Y" s DDCTRActive=""
 else  s DDCTRActive="已失效"
 s DDCTRCount=$p(TRData,"^",4)
 set Data=$lb(RowID,DDCTRParRef,DDCTRServiceGroup,DDCTRCTLocDr,DDCTRCTLoc,DDCTRResDr,DDCTRCTPCP,DDCTRActive,DDCTRCount)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryTriageResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTriageResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTriageResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTriageResourceExecute ]
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

}
