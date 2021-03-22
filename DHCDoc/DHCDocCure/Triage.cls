Class DHCDoc.DHCDocCure.Triage Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryTriageResource(DCARowIDStr As %String, LocRowID As %String, LogLocID As %String = "") As %Query(ROWSPEC = "DDCTRROWID:%String,DDCTRServiceGroupID:%String,DDCTRServiceGroup:%String,DDCTRCTLocID:%String,DDCTRCTLoc:%String,DDCTRResDr:%String,DDCTRResDesc:%String,CureTriageNum:%String,DDCTRCount:%String,DDCTRLeftCount:%String,DDCTRHistoryRes:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Triage","QueryTriageResource","3","")
ClassMethod QueryTriageResourceExecute(ByRef qHandle As %Binary, DCARowIDStr As %String, LocRowID As %String, LogLocID As %String = "") As %Status
{
	s ^tmpnk("QueryTriageResource")=DCARowIDStr_","_LocRowID
	s ind=1
	Set repid=$I(^CacheTemp)
	if DCARowIDStr=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 	
	}
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	s DCARowIDLen=$l(DCARowIDStr,"!")
	s ServiceGroupDR=""
	k HistoryResArr
	k RelocList
	for myfor=1:1:DCARowIDLen{
		;Q:ServiceGroupDR'=""
		s DCARowID=$p(DCARowIDStr,"!",myfor)
		continue:DCARowID=""
		Set CureData=$g(^DHCDocCure(DCARowID))
		Set OrderId=$p(CureData,"^",2)
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		continue:ArcimId=""
		s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
		continue:DDCISRowid=""
		s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		s HistoryResStr=..GetHistoryRes(DCARowID,"ALL")
		if HistoryResStr'=""{
			s HistoryResLen=$l(HistoryResStr,"^")
			for mycount=1:1:HistoryResLen{
				s aHistoryRes=$p(HistoryResStr,"^",mycount)
				s HistoryResArr(aHistoryRes)=""
			}
		}
		s OrderRecDepRowid=$P($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6) 
		s:OrderRecDepRowid="" OrderRecDepRowid="9999999"
		s RelocList(OrderRecDepRowid)=""
	}
	if ServiceGroupDR=""{
		;Set qHandle=$lb(0,repid,0)
		;Quit $$$OK 	
		s DDCTRParRef=""
		f  s DDCTRParRef=$o(^DHCDocCureTR(DDCTRParRef)) q:DDCTRParRef=""  d
		.s DDCTRChildSub=0 f  s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""  d
		..d GetTriageResource
	}else{
		s DDCTRParRef=ServiceGroupDR
		s DDCTRChildSub=0 f  s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""  d
		.d GetTriageResource
	}
	s mysortcode=""
	for  s mysortcode=$o(^||TMPHistoryRes("SORT",mysortcode)) Q:mysortcode=""  d
	.s myRowID=""
	.for  s myRowID=$o(^||TMPHistoryRes("SORT",mysortcode,myRowID)) Q:myRowID=""  d
	..d OutputTriageResource
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutputTriageResource
	set Data=$g(^||TMPHistoryRes("SORT",mysortcode,myRowID))
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1 
	quit
GetTriageResource
	s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	s RowID=DDCTRParRef_"||"_DDCTRChildSub
	s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
	s DDCTRCTLocDr=$p(TRData,"^",1)
	Q:(LocRowID'="")&&(LocRowID'=DDCTRCTLocDr)
	Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_DDCTRCTLocDr_"^"))
	s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
	s DDCTRResDr=$p(TRData,"^",2)
	s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
	s DDCTRActive=$p(TRData,"^",3)
	q:DDCTRActive'="Y"
	if DDCTRActive="Y" s DDCTRActive=""
	else  s DDCTRActive="已失效"
	s CureTriageNum=+(..GetTriagedCount(RowID,"T"))
	s DDCTRCount=$p(TRData,"^",4)
	if DDCTRCount'="" s DDCTRLeftCount=(+DDCTRCount)-CureTriageNum
	else  s DDCTRCount="-",DDCTRLeftCount="-"
	s sortcode="02"
	s DDCTRHistoryRes=""
	if $d(HistoryResArr(RowID)) s DDCTRHistoryRes="是" s sortcode="01"
	if $D(RelocList(DDCTRCTLocDr)) s sortcode="01"
	set ^||TMPHistoryRes("SORT",sortcode,RowID)=$lb(RowID,DDCTRParRef,DDCTRServiceGroup,DDCTRCTLocDr,DDCTRCTLoc,DDCTRResDr,DDCTRCTPCP,CureTriageNum,DDCTRCount,DDCTRLeftCount,DDCTRHistoryRes)
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

/// Description:得到分配资源下的已分配申请单数量
/// Debug:w ##class(DHCDoc.DHCDocCure.Triage).GetTriagedCount("5")
ClassMethod GetTriagedCount(DDCTRResID As %String, Status As %String = "")
{
	s count=0
	s DDCTParRef=""
	f  s DDCTParRef=$O(^DHCDocCureTRIi(0,"StatuRBAS","T",DDCTRResID,DDCTParRef)) Q:DDCTParRef=""  d
	.s DDCTChildSub=0
	.f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"StatuRBAS","T",DDCTRResID,DDCTParRef,DDCTChildSub)) Q:DDCTChildSub=""  d
	..s count=count+1
	/*
	s DDCTParRef=""
	f  s DDCTParRef=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRResID,DDCTParRef)) Q:DDCTParRef=""  d
	.s DDCTChildSub=0
	.f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRResID,DDCTParRef,DDCTChildSub)) Q:DDCTChildSub=""  d
	..s DDCTStatus=$p(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub),"^",5)
	..Q:(Status'="")&&(DDCTStatus'=Status)
	..Q:(Status="")&&(DDCTStatus'="T")
	..s count=count+1
	*/
	s DDCTRLeftCount=""
	s DDCTRParRef=+DDCTRResID
	s DDCTRChildSub=$p(DDCTRResID,"||",2)
	s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	s DDCTRCount=$p(TRData,"^",4)
	if DDCTRCount'="" s DDCTRLeftCount=(+DDCTRCount)-count
	else  s DDCTRLeftCount=""
	q count_"^"_DDCTRLeftCount
}

/// w ##class(DHCDoc.DHCDocCure.Triage).CureTriaged("43||1","5^4661")
ClassMethod CureTriagedBak(DDCTRResID As %String, Para As %String)
{
	s ^tmpnk("CureTriaged")=DDCTRResID_","_Para
	if Para="" Q 100
	if DDCTRResID="" Q 101
	Set DCARowID=$p(Para,"^",1)
	Set UserID=$p(Para,"^",2)
	Set CureData=$g(^DHCDocCure(DCARowID))
	;s ApplyStatus=$p(CureData,"^",3)
	s findrec=""
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:(DDCTChildSub="")!(findrec'="")  d
	.s status=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",5)
	.q:status="C"
	.s findrec=DCARowID_"||"_DDCTChildSub
	if findrec'="" Q 102
	set LeftCount=..GetTriagedCount(DDCTRResID)
	set LeftCount=$p(LeftCount,"^",2)
	if (LeftCount'="")&&(+LeftCount=0) Q 103
	Ts
	K PLIST
	s PLIST(3)=DDCTRResID
	s PLIST(4)=UserID
	s PLIST(5)=+$H
	s PLIST(6)=$P($H,",",2)
	s PLIST(7)="T"
	s PLIST(0)=DCARowID
 	&sql(insert into SQLUser.DHC_DocCureTriage values :PLIST())
	if 'SQLCODE{
		s DCAStatus="D"
		&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:DCAStatus where DCA_RowId=:DCARowID)
		if SQLCODE{
			Tro
			Q "-300"	
		}
	}else{
		Tro	
		Q "-301"
	}
	Tc
	q 0
}

/// w ##class(DHCDoc.DHCDocCure.Triage).CureTriagedJson("43||1","")
ClassMethod CureTriaged(DDCTRResID As %String, Para As %String, Type As %String = "")
{
	s ^tmpnk("CureTriaged")=DDCTRResID_","_Para
	if Para="" Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(100,Type)
	if DDCTRResID="" Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(101,Type)
	Set DCARowID=$p(Para,"^",1)
	Set UserID=$p(Para,"^",2)
	Set CureData=$g(^DHCDocCure(DCARowID))
	s ApplyStatus=$p(CureData,"^",3)
	if ApplyStatus="C"{
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(104,Type)	
	}
	s findrec=""
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:(DDCTChildSub="")!(findrec'="")  d
	.s status=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",5)
	.q:status="C"
	.s findrec=DCARowID_"||"_DDCTChildSub
	if findrec'="" Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(102,Type)
	set LeftCount=..GetTriagedCount(DDCTRResID)
	set LeftCount=$p(LeftCount,"^",2)
	if (LeftCount'="")&&(+LeftCount=0) Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(103,Type)
	Ts
	K PLIST
	s PLIST(3)=DDCTRResID
	s PLIST(4)=UserID
	s PLIST(5)=+$H
	s PLIST(6)=$P($H,",",2)
	s PLIST(7)="T"
	s PLIST(0)=DCARowID
 	&sql(insert into SQLUser.DHC_DocCureTriage values :PLIST())
	if 'SQLCODE{
		s DCAStatus="D"
		&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:DCAStatus where DCA_RowId=:DCARowID)
		if SQLCODE{
			Tro
			Q ##class(DHCDoc.DHCDocCure.Common).EvalJson("-300",Type)
		}
	}else{
		Tro	
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson("-301",Type)
	}
	Tc
	Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(0,Type)
}

/// w ##class(DHCDoc.DHCDocCure.Triage).CancelTriaged("4||2","600")
ClassMethod CancelTriaged(DDCTRRowID As %String, UserID As %String)
{
	s ^tmpnk("CancelTriaged")=DDCTRRowID_","_UserID
	if DDCTRRowID="" Q 100
	s DDCTParRef=+DDCTRRowID
	s DDCTChildSub=$p(DDCTRRowID,"||",2)
	if '$d(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub)) Q 101
	s DDCTStatus=$p(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub),"^",5)
	Q:DDCTStatus'="T" 102 ;非分配状态的不允许取消
	s rtn=..CheckDHACureTriaged(DDCTParRef,"C")
	Q:rtn'="" rtn
	s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DDCTParRef)
	s ApplyAppNum=+ApplyAppInfo
	Set CureData=$g(^DHCDocCure(DDCTParRef))
	Set OrderId=$p(CureData,"^",2)
	s ControlFlag=0 s ApplyExecFlag=""
	Set OrderId=$p(CureData,"^",2)
	if OrderId'=""{
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		if ArcimId'=""{
			s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
			if DDCISRowid'=""{
				s ApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",9)
			}
		}
	}
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) {
		if ApplyExecFlag="Y" s ControlFlag=1
	}else{
		s ControlFlag=1
	}
	Q:(ControlFlag=0)&&(ApplyAppNum>0) 103 ;已经有预约记录的不允许取消
	if ControlFlag=1{
		s find=0
		s Sub=0
		for  s Sub=$o(^OEORD(+OrderId,"I",$P(OrderId,"||",2),"X",Sub)) Q:(Sub="")!(find=1)  d
		.s StatusRowId=$P(^OEORD(+OrderId,"I",$P(OrderId,"||",2),"X",Sub),"^",16)
		.s StatusCode=""
		.if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
		.if (StatusCode="F") s find=1
		Q:(find=1) 104
	}
	
	Ts
	s curdate=+$H
	s curetime=$P($H,",",2)
	s DDCTStatus="C"
 	&sql(update SQLUser.DHC_DocCureTriage set DDCT_CancelTriageUser_DR=:UserID,DDCT_CancelTriageDate=:curdate,DDCT_CancelTriageTime=:curetime,
 	DDCT_Status=:DDCTStatus where DHCDocCureTRI_RowID=:DDCTRRowID)
 	b ;1
	if 'SQLCODE{
		s DCARowID=+DDCTRRowID
		s DCAStatus="A"
		&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:DCAStatus where DCA_RowId=:DCARowID)
		if SQLCODE{
			Tro
			Q "-300"	
		}
	}else{
		Tro	
		Q "-301"
	}
	Tc
	q 0
}

Query QueryTriageList(DCARowIDStr As %String, DDCTRIRowID As %String, Status As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatientNo:%String,PatientName:%String,ArcimDesc:%String,DDCTRCTLoc:%String,DDCTRCTPCP:%String,DDCTRUser:%String,DDCTRDate:%String,DDCTRStatus:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Triage","QueryTriageList","3","")
ClassMethod QueryTriageListExecute(ByRef qHandle As %Binary, DCARowIDStr As %String, DDCTRIRowID As %String, Status As %String = "") As %Status
{
	s ^tmpnk("QueryTriageResource")=DCARowIDStr_","_DDCTRIRowID_","_Status
	s ind=1
	Set repid=$I(^CacheTemp)
	if (DCARowIDStr="")&&(DDCTRIRowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 	
	}
	if DCARowIDStr'=""{
		s DCARowIDLen=$l(DCARowIDStr,"!")
		for myfor=1:1:DCARowIDLen{
			s DCARowID=$p(DCARowIDStr,"!",myfor)
			continue:DCARowID=""
			Set CureData=$g(^DHCDocCure(DCARowID))
			Set OrderId=$p(CureData,"^",2)
			s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
			continue:ArcimId=""
			s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
			continue:DDCISRowid=""
			s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
			s DDCTChildSub=0
			for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:DDCTChildSub=""  d
			.s TRIRowID=DCARowID_"||"_DDCTChildSub
			.s TRIResRowID=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",1)
			.Q:(DDCTRIRowID'="")&&(TRIResRowID'=DDCTRIRowID)
			.d OutTriageList
		}
	}else{
		s DDCTRParRef=0 f  s DDCTRParRef=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRIRowID,DDCTRParRef)) q:DDCTRParRef=""  d
		.s DDCTChildSub=""
		.s DDCTChildSub=0 f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRIRowID,DDCTRParRef,DDCTChildSub)) q:DDCTChildSub=""  d
		..s TRIRowID=DDCTRParRef_"||"_DDCTChildSub
		..d OutTriageList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutTriageList
	s CureData=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+TRIRowID)
	Q:CureData=""
	s PatientInfo=$p(CureData,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s CureAppInfo=$p(CureData,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s DDCTRParRef=+TRIRowID
	s DDCTChildSub=$p(TRIRowID,"||",2)
	Q:'$D(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub))
	s TRIStatus=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",5)
	Q:(Status'="")&(TRIStatus'=Status)
	Q:(Status="")&(TRIStatus'="T")
	s TRIResRowID=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",1)
	s TRIUser=""
	s TRIUserDr=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",2)
	s TRIDate=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",3)
	s TRITime=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",4)
	if TRIStatus="C" d
	.s TRIUserDr=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",6)
	.s TRIDate=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",7)
	.s TRITime=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",8)
	s:TRIUserDr'="" TRIUser=$p(^SSU("SSUSR",TRIUserDr),"^",2)
	s TRIDate=##class(websys.Conversions).DateLogicalToHtml(TRIDate) ;$zd(TRIDate,3)
	s TRITime=$zt(TRITime,2)
	s TRIStatus=$case(TRIStatus,"T":"已分配","C":"取消分配","A":"已接收",:"")
	s TRIDate=TRIDate_" "_TRITime
	s TRData=$g(^DHCDocCureTR(+TRIResRowID,"TR",$p(TRIResRowID,"||",2)))
	s DDCTRCTLocDr=$p(TRData,"^",1)
	s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
	s DDCTRResDr=$p(TRData,"^",2)
	s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
	set Data=$lb(TRIRowID,PatientNo,PatientName,ArcimDesc,DDCTRCTLoc,DDCTRCTPCP,TRIUser,TRIDate,TRIStatus)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1 
	quit
}

ClassMethod QueryTriageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTriageListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTriageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTriageListExecute ]
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

/// Creator：      nikang
/// CreatDate：    2018-03-26
/// Description:   根据本次治疗申请获取历史的最近一次分配资源
/// Table: 		   DHC_DocCureTriage
/// Input：        DCARowID:申请单ID
/// OutPut: 	   
/// Debug:		   w ##class(DHCDoc.DHCDocCure.Triage).GetHistoryRes(100)
ClassMethod GetHistoryRes(DCARowID As %String, AllFlag As %String = "")
{
	n (DCARowID,AllFlag)
	Set CureData=$g(^DHCDocCure(DCARowID))
	set order=$p(CureData,"^",2)
	Set Adm=$p(CureData,"^",1)
	;找到申请医嘱
	set Arcimdr=""
	set:order'="" Arcimdr=$p($g(^OEORD(+order,"I",$p(order,"||",2),1)),"^",2)
	Q:Adm="" ""
	s findResRowID=""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	s ADMType=""
	for{ 
		set ADMType=$o(^PAPERdr(PatientId,"ADM",ADMType)) Q:(ADMType="")!((findResRowID'="")&&(AllFlag=""))
		continue:ADMType="H"
		set AdmID=""
		for{
			set AdmID=$o(^PAPERdr(PatientId,"ADM",ADMType,AdmID),-1) Q:(AdmID="")!((findResRowID'="")&&(AllFlag=""))
			s DCARowIDs=""
			for{
				s DCARowIDs=$o(^DHCDocCure(0,"Adm",AdmID,DCARowIDs),-1) Q:(DCARowIDs="")!((findResRowID'="")&&(AllFlag=""))  d
				continue:DCARowID=DCARowIDs
				s FindArcim=""
				s OrderFind=$P($G(^DHCDocCure(DCARowIDs)),"^",2)
				s:OrderFind'="" FindArcim=$p($g(^OEORD(+OrderFind,"I",$p(OrderFind,"||",2),1)),"^",2)
				Continue:((FindArcim'="")&(Arcimdr'="")&(FindArcim'=Arcimdr)) 
				s DDCTChildSub=""
				for {
					s DDCTChildSub=$o(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),-1) Q:(DDCTChildSub="")!((findResRowID'="")&&(AllFlag=""))  d	
					continue:(DDCTChildSub=0)
					s DDCTStatus=$p(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),"^",5)
					continue:(DDCTStatus="C")
					s TRIResRowID=$p(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),"^",1)
					continue:TRIResRowID=""
					s TRData=$g(^DHCDocCureTR(+TRIResRowID,"TR",$p(TRIResRowID,"||",2)))
					s DDCTRActive=$p(TRData,"^",3)
				 	continue:DDCTRActive'="Y"
				 	if findResRowID="" s findResRowID=TRIResRowID
				 	else  s findResRowID=findResRowID_"^"_TRIResRowID
				}
			}
		}
	}
 	Q findResRowID
}

ClassMethod UpdateTriageStatus(DCARowID, UserID)
{
	n (DCARowID,UserID)
	;是否启用分诊配置
	s DHCDocCureNeedTriage=+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureNeedTriage"))
	Q:DHCDocCureNeedTriage'=1 0
	s findrec=""
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:(DDCTChildSub="")!(findrec'="")  d
	.s status=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",5)
	.q:status'="T"
	.s findrec=DCARowID_"||"_DDCTChildSub
	;Q:findrec="" "-300"
	s curdate=+$H
	s curetime=$P($H,",",2)

	if findrec'=""{
		s obj=##class(User.DHCDocCureTriage).%OpenId(findrec)
		if $IsObject(obj){
			s obj.DDCTStatus="A"
			s obj.DDCTArriveDate=curdate
			s obj.DDCTArriveTime=curetime
			do obj.DDCTArriveUserDRSetObjectId(UserID)
			s sc=obj.%Save()
		    If $$$ISERR(sc){
			    Quit "-301"
		    }
		    d obj.%Close()
		    s obj=""
		}else{
			Quit "-302"	
		}
	}
	Q 0
}

/// 检测单子是否可以被分配/取消分配
/// DCARowID 申请单ID CancelType A/C A验证分配 C验证取消
/// return 不为空为提示信息
/// w ##class(DHCDoc.DHCDocCure.Triage).CheckDHACureTriaged(35,"C")
ClassMethod CheckDHACureTriaged(DCARowID As %String, CancelType As %String)
{
	s ^lxz1=DCARowID_","_CancelType
	//进行新增认证
	if (CancelType="A"){
		s CureData=$g(^DHCDocCure(DCARowID))
		Q:CureData="" "不存在申请信息,不能进行分配!"
		s statu=$P(CureData,"^",3) //申请单状态 A 申请 C 撤销 F 完成 D 分配
		Q:statu'="A" "申请单状态不是【预约】,不能进行分配" ;
		s Adm=$P(CureData,"^",1)
		if (Adm'=""){
			s AdmVisitStatus=$P($g(^PAADM(Adm)),"^",20)
			if (AdmVisitStatus'="A"){
				q "患者就诊状态异常,不能进行分配!请核实."
			}
		}
		s DCAOEORIDR=$P(CureData,"^",2)
		if (DCAOEORIDR'=""){
			s StatusCode="",StatusDesc=""
			s StatusRowId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
			s:StatusRowId'="" StatusCode=$p(^OEC("OSTAT",StatusRowId),"^",1),StatusDesc=$p(^OEC("OSTAT",StatusRowId),"^",2)
			Q:((StatusCode'="V")&(StatusCode'="E")) "申请单医嘱状态异常为【"_StatusDesc_"】!,不能进行分配请核实!"
		}
		s triageDr=0
		s triageDr=$O(^DHCDocCureTRI(DCARowID,"Triage",""),-1) //申请状态表
		if triageDr'=""{
			s triageStatu=$P($G(^DHCDocCureTRI(DCARowID,"Triage",triageDr)),"^",5)
			s statu=$case(triageStatu,"W":"未分配","T":"已分配","A":"已接收","C":"取消分配","F":"已完成",:"")
			Q:((triageStatu'="C")&(triageStatu'="W")) "该单据已经存在申请状态:"_statu_",不能在进行分配!"
		}
	}elseif (CancelType="C"){
		s CureData=$g(^DHCDocCure(DCARowID))
		Q:CureData="" "不存在申请信息,不能进行分配!"
		s statu=$P(CureData,"^",3) //申请单状态 A 申请 C 撤销 F 完成 D 分配
		Q:statu'="D" "申请单状态不是【分配状态】,不能进撤销分配!" ;
		s triageDr=0
		s triageDr=$O(^DHCDocCureTRI(DCARowID,"Triage",""),-1) //申请状态表
		if triageDr'=""{
			s triageStatu=$P($G(^DHCDocCureTRI(DCARowID,"Triage",triageDr)),"^",5)
			s statu=$case(triageStatu,"W":"未分配","T":"已分配","A":"已接收","C":"取消分配","F":"已完成",:"")
			Q:(triageStatu'="T") "该单据已经存在申请状态:"_statu_",不能在进行分配!"
		}
	}
	q ""
}

}
