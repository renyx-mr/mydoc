Class DHCDoc.DHCDocCure.WordReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 治疗预约统计查询
Query QryWorkReport(DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,UnitPrice:%String,ApplyFinishUser:%String,Job:%String,CureDate:%String,ApplyCureRecord:%String")
{
}

ClassMethod QryWorkReportExecute(ByRef qHandle As %Binary, DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReport","APPLY","8/1/2017","8/14/2017","1")
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReport","APPOINT","2018-07-11","2018-07-11","6462","","ALL")
	s ^TMP("QryWorkReport")=DateType_","_StartDate_","_EndDate_","_UserID_","_queryLoc_","_queryStatus_","_queryArcim_","_queryGroup
	Set repid=$I(^CacheTemp)
	if DateType=""{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	Set ind=1
	Set myind=1
	if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,4)
	else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	else  s StartDate=+$h
	if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
	else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	else  s EndDate=+$h
	
	if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReport("DHCDOCCURE",UserID)
	if queryStatus="ALL" s queryStatus=""
	if DateType="APPLY"{
		For QueryDate=StartDate:1:EndDate Do
		.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
		..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		..s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		..s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		..Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
		..s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		..q:CureOrdArcimId=""
		..q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		..s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",CureOrdArcimId,""))
		..q:DDCISRowid=""
		..s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		..Q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
		..;Q:(queryStatus'="")&&(queryStatus'=ApplyStatus)
		..Q:((queryStatus="C")!(queryStatus="F"))&&(queryStatus'=ApplyStatus)
		..d ReserveVar
		..d OutputRowWorkReport
	}else{
		s SericeGroup=""
		for  set SericeGroup=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup)) q:SericeGroup=""  d
		.Q:(queryGroup'="")&&(SericeGroup'=queryGroup)
		.For QueryDate=StartDate:1:EndDate Do
		..s DDCRSRowID=0
		..for  s DDCRSRowID=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup,QueryDate,DDCRSRowID)) q:DDCRSRowID=""  d
		...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId)) q:DCARowId=""  d
		....Q:$d(OutputArr(UserID,DDCRSRowID,DCARowId))
		....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		....s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		....s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		....Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
		....s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		....q:CureOrdArcimId=""
		....q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		....Q:((queryStatus="C")!(queryStatus="F"))&&(queryStatus'=ApplyStatus)
		....s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId,DCAAChildSubRowID)) q:DCAAChildSubRowID=""  d
		.....d ReserveVar
		.....d OutputRowWorkReport
		....s OutputArr(UserID,DDCRSRowID,DCARowId)=""
		s myDDCRSDate=""
		f  s myDDCRSDate=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate)) q:myDDCRSDate=""  d
		.s myDDCRSStartTime=""
		.f  s myDDCRSStartTime=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime)) q:myDDCRSStartTime=""  d
		..s myDCAAppointRowID1=""
		..f  s myDCAAppointRowID1=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)) q:myDCAAppointRowID1=""  d
		...set Data1=^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)
		...Set ^CacheTemp(repid,ind)=Data1
 		...Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReport
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'="" d
	.s AdmType=$P(^PAADM(Adm),"^",2)
	.s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	.s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s CureDate=$p(ApplyDate," ")
	s ApplyAppedTimes=$p(CureAppInfo,"^",10) ;已预约次数
	s ApplyNoAppTimes=$p(CureAppInfo,"^",11) ;未预约次数
	s ApplyFinishTimes=$p(CureAppInfo,"^",12) ;已治疗次数
	s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) ;未治疗次数
	;"ANA"_$c(1)_"申请未预约"_"^"_"ANC"_$c(1)_"预约未治疗"_"^"_"AC"_$c(1)_"在治疗"
	s myApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	if (myApplyStatus'="C")&&(myApplyStatus'="F"){
		i (ApplyAppedTimes=0) s myApplyStatus="ANA"
		else  if (ApplyFinishTimes=0)&&(ApplyAppedTimes>0) s myApplyStatus="ANC"
		else  if ApplyNoFinishTimes>0 s myApplyStatus="AC"
		else  if ApplyFinishTimes=OrderQty s myApplyStatus="F" ;已治疗次数=总次数但是未有进行完成操作认为已治疗完成
	}
	q:(queryStatus'="")&&(queryStatus'="F")&&(queryStatus'="C")&&(queryStatus'="A")&&(queryStatus'=myApplyStatus)
	q:(queryStatus="A")&&(myApplyStatus'="ANC")&&(myApplyStatus'="AC")
	s OrdPrice=$p(CureAppInfo,"^",17) 
	s OrdBilled=$p(CureAppInfo,"^",18) 
	s UnitPrice=$p(CureAppInfo,"^",19) 
	s ApplyFinishUser="" ;$p(CureAppInfo,"^",20)
	s ServiceGroupDR=$p(CureAppInfo,"^",21)
	s myDCAAppointRowID=""
	if DateType="APPOINT"{
		s myDCAAppointRowID=DCARowId_"||"_DCAAChildSubRowID
		s DCRChildId=$o(^DHCDocCure(0,"AppArriveDR",myDCAAppointRowID,+DCARowId,""))
		if (DCRChildId'=""){
			Set CreateUserDR=$p($g(^DHCDocCure(+DCARowId,"Recode",DCRChildId)),"^",5)
			s:CreateUserDR'="" ApplyFinishUser=$p($g(^SSU("SSUSR",CreateUserDR)),"^",2)
		}
	}
	s ApplyCureRecord=..GetCureAppointByApply(DCARowId,myDCAAppointRowID)
	Q:(ApplyCureRecord="")&&(DateType="APPOINT")
	set Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,Job,CureDate,ApplyCureRecord)
	if DateType="APPOINT"{
		s AppData=$g(^DHCDocCure(+myDCAAppointRowID,"Arrive",$p(myDCAAppointRowID,"||",2)))
		s DCAARBASDR=$p(AppData,"^",1)  //资源排班ID
		s ResData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
		s DDCRSDate=$p(ResData,"^",4)  //出诊日期
		s DDCRSStartTime=$p(ResData,"^",6)  //开始时间
		s ^||TMPQryWorkReport("DHCDOCCURE_SORT",DDCRSDate,DDCRSStartTime,myDCAAppointRowID)=Data
		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,myind)=DCARowId_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_OrdPrice_"^"_OrdBilled_"^"_UnitPrice_"^"_ApplyFinishUser_"^"_CureDate_"^"_ApplyCureRecord
 		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,"num")=myind
 		s myind=myind+1
		quit
	}else{
		s ApplyFinishUser=""
		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,ind)=DCARowId_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_OrdPrice_"^"_OrdBilled_"^"_UnitPrice_"^"_ApplyFinishUser_"^"_CureDate_"^"_ApplyCureRecord
 		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,"num")=ind
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
 		quit	
	}
	;if ApplyCureRecord="" b ;1
 	
ReserveVar
 	set (PatientNo,PatientName,PatientSex,PatientAge,PatientTel,AdmType,AdmDep,ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,CureDate,ApplyCureRecord)=""
 	quit
}

ClassMethod QryWorkReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportExecute ]
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

ClassMethod GetWorkReportNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetWorkReportInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// 获取某个申请单下所有的预约治疗记录情况
/// Creator:nikang
/// CreateDate:2017-08-24
ClassMethod GetCureAppointByApply(AppRowID As %String, DCAAppointRowID As %String = "")
{
	q:AppRowID="" ""
	s ret=""
	s count=0
	s DCAAChildSub=0
	for  s DCAAChildSub=$o(^DHCDocCure(AppRowID,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
	.s DCAARowID=AppRowID_"||"_DCAAChildSub
	.Q:(DCAAppointRowID'="")&&(DCAAppointRowID'=DCAARowID)
	.s DCAAStatus=$p(^DHCDocCure(AppRowID,"Arrive",DCAAChildSub),"^",7)
	.Q:DCAAStatus="C"
	.s Appointment=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowID)
	.s AppResInfo=$p(Appointment,$c(1))
	.s AppAppointInfo=$p(Appointment,$c(1),2)
	.s count=count+1
	.s AppDate=$p(AppResInfo,"^",5)
	.s AppointRegDate=$p(AppAppointInfo,"^",5)
	.;s AppResStr="预约资源:"_$p(AppResInfo,"^",2)_" "_$p(AppResInfo,"^",4)_" "_AppDate_"("_$p(AppResInfo,"^",7)_") "_$p(AppResInfo,"^",8)_"-"_$p(AppResInfo,"^",9)
	.;s AppAppointStr="预约操作人:"_$p(AppAppointInfo,"^",4)_" 预约时间:"_AppointRegDate_" "_$p(AppAppointInfo,"^",6)_" 预约状态:"_$p(AppAppointInfo,"^",8)
	.;s CureRecordInfo=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCAARowID)
	.;s CureRecordStr=""
	.;i CureRecordInfo'="" d
	.;.s CureRecordStr=" 治疗记录医生:"_$p(CureRecordInfo,"^",6)
	.s AppResStr=AppDate_" "_$p(AppResInfo,"^",8)_"-"_$p(AppResInfo,"^",9)_"("_$p(AppResInfo,"^",2)_" "_$p(AppResInfo,"^",4)_")"
	.s myStr=AppResStr ;_" "_AppAppointStr_CureRecordStr
	.i ret="" s ret=myStr
	.else  s ret=ret_"<br>"_myStr
	q ret
}

Query QryRecordReport(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryExcuteRet As %String = "") As %Query(ROWSPEC = "DCARowId:%String,OrderRecLoc:%String,FinishUser:%String,CureDate:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String,PatientNo:%String,PatientName:%String,OrderLoc:%String,PatientTel:%String,ExcuteRet:%String,OrdDate:%String")
{
}

ClassMethod QryRecordReportExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryExcuteRet As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryRecordReport","9/20/2018","9/20/2017","1")
	s ^TMP("QryRecordReport")=StartDate_","_EndDate_","_UserID_","_queryLoc_","_queryDoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=2
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	if queryExcuteRet="ABNORMAL"{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK	
	}
	
	s LogLocID=%session.Get("LOGON.CTLOCID")
	
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryRecordReport("DHCDOCCURE",UserID)
	s TotalPrice=0
	s FindCureState="A^F"
	for mycount=1:1:$l(FindCureState,"^"){
		s aCureState=$p(FindCureState,"^",mycount)
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"STAT",aCureState,DCARowId)) q:DCARowId=""  d
		.;s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",CureOrdArcimId,""))
		.q:DDCISRowid=""
		.s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		.Q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
		.s CureFinishUser=$p(^DHCDocCure(DCARowId),"^",12)
		.s CureFinishDate=$p(^DHCDocCure(DCARowId),"^",13)
		.s CureFinishTime=$p(^DHCDocCure(DCARowId),"^",14)
		.Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		.s StateChangeChild=0
		.for  s StateChangeChild=$o(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild)) q:StateChangeChild=""  d
		..s ChangeDate=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",1)
		..s ChangeUser=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",3)
		..s OrdDate=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",7) ;开单日期 
		..s ChangeType=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",4)
		..s ChangeNum=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",5)
		..Q:ChangeNum=0
		..Q:(StartDate'="")&&(ChangeDate<StartDate)
		..Q:(EndDate'="")&&(ChangeDate>EndDate)
		..Q:(queryDoc'="")&&(queryDoc'=ChangeUser)
		..d ReserveVarRecord
		..d OutputRowRecordReport
	}
	s ind=1
	d ReserveVarRecord
	s TotalPrice=$j(TotalPrice,10,2)
	set Data=$lb("-","-","-","-","-","-","-","-",TotalPrice,Job,"合计:","-","-","-")
 	s ^TMPQryRecordReport("DHCDOCCURE",UserID,Job,ind)="-"_"^"_"-"_"^"_"-"_"^"_"-"_"^"_"-"_"^"_"-"_"^"_"-"_"^"_"-"_"^"_TotalPrice_"^"_"合计:"_"^"_"-"_"^"_"-"_"^"_"-"
 	Set ^CacheTemp(repid,ind)=Data
 	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowRecordReport
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	;s PatientSex=$p(PatientInfo,"^",4)
	;s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrdDate=$zd($p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",7),3) ;开单日期 
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)   ;$zd(OrdDate,3) ;_" "_CureOrderId
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	;s CureDate=$p(ApplyDate," ")
	;s OrdPrice=$p(CureAppInfo,"^",17)_"元"
	;s OrdBilled=$p(CureAppInfo,"^",18) 
	s CureDate=$zd(ChangeDate,3)
	s OrderQty=ChangeNum
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$j($g(UnitPrice)*ChangeNum,10,2)
	s:ChangeUser'="" FinishUser=$P(^SSU("SSUSR",ChangeUser),"^",2) ;$p(CureAppInfo,"^",20)
	i CureOrdLocId'="" d
	.s OrderLoc=$P($G(^CTLOC(CureOrdLocId)),"^",2)
	.i $P(OrderLoc,"-",2)'="" s OrderLoc=$P(OrderLoc,"-",2)

	s TotalPrice=TotalPrice+(+$g(UnitPrice)*ChangeNum)
	s ExcuteRet="正常"
	set Data=$lb(DCARowId,OrderReLoc,FinishUser,CureDate,ArcimDesc,UnitPrice,OrderQty,OrdBillUOM,OrdPrice,Job,PatientNo,PatientName,OrderLoc,PatientTel,ExcuteRet,OrdDate)
 	s ^TMPQryRecordReport("DHCDOCCURE",UserID,Job,ind)=DCARowId_"^"_OrderReLoc_"^"_FinishUser_"^"_CureDate_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice_"^"_PatientNo_"^"_PatientName_"^"_OrderLoc_"^"_PatientTel_"^"_OrdDate
 	s ^TMPQryRecordReport("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
ReserveVarRecord
 	set (OrderReLoc,FinishUser,CureDate,ArcimDesc,UnitPrice,OrderQty,OrdBillUOM,OrdPrice,PatientNo,PatientName,OrderLoc,PatientTel,OrdDate)=""
 	quit
}

ClassMethod QryRecordReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRecordReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordReportExecute ]
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

ClassMethod GetQryRecordReportNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryRecordReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryRecordReportInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryRecordReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

ClassMethod GetLocDesc(LocID)
{
	q:LocID="" ""
	s LocDesc=$p(^CTLOC(LocID),"^",2)
	if LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	q LocDesc
}

ClassMethod QryWorkReportForExecute(ByRef qHandle As %Binary, query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportFor","doc","2018-06-06","2018-06-06","4852","",221)
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportFor","dept","2018-06-07","2018-06-07","4852","",221)
	s ^TMP("QryWorkReportFor")=query_","_StartDate_","_EndDate_","_UserID_","_queryDoc_","_queryLoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=1
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	s LogLocID=queryLoc
	if queryLoc="" s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	;if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportFor("DHCDOCCURE",UserID)
	s TotalPrice=0
	s FindCureState="A^F"
	/*for mycount=1:1:$l(FindCureState,"^"){
		s aCureState=$p(FindCureState,"^",mycount)
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"STAT",aCureState,DCARowId)) q:DCARowId=""  d
		.s CureApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
		.;执行不可能在申请之前
		.;q:((StartDate'="")&&(CureApplyDate<StartDate))
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.s CureFinishUser=$p(^DHCDocCure(DCARowId),"^",12)
		.s CureFinishDate=$p(^DHCDocCure(DCARowId),"^",13)
		.s CureFinishTime=$p(^DHCDocCure(DCARowId),"^",14)
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		.Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		.s OEOREChild=0
		.for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) q:OEOREChild=""  d
		..s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		..s ChangeStatus=""
		..s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		..s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		..Q:ChangeStatus'="F"
		..s ChangeCP=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",15)
		..s ChangeUser=$o(^SSU("SSUSR",0,"CTPCP",ChangeCP,0))
		..s ChangeNum=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",5)
		..Q:ChangeNum=0
		..Q:(StartDate'="")&&(ChangeDate<StartDate)
		..Q:(EndDate'="")&&(ChangeDate>EndDate)
		..Q:(queryDoc'="")&&(queryDoc'=ChangeUser)
		..d ReserveVarWorkReportFor
		..d GetWorkReportFor
	}*/
	for QryDate=StartDate:1:EndDate{
		s OEOREOrdID=0
		for  s OEOREOrdID=$o(^OEORDi(0,"DateExecute",QryDate,OEOREOrdID)) Q:OEOREOrdID=""  d
		.s OEOREOrdChild=0
		.for  s OEOREOrdChild=$o(^OEORDi(0,"DateExecute",QryDate,OEOREOrdID,OEOREOrdChild)) Q:OEOREOrdChild=""  d
		..s OrdRowID=OEOREOrdID_"||"_OEOREOrdChild
		..s DCARowId=""
		..s DCARowId=$o(^DHCDocCure(0,"OEORI",OrdRowID,""))
		..;非治疗申请退出
		..Q:DCARowId=""
		..s CureOrderId=OrdRowID
		..s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		..s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		..s CureOrdPHFreqDR=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),2)),"^",4)
		..q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		..;Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		..;Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		..s OEOREChild=0
		..for  s OEOREChild=$o(^OEORDi(0,"DateExecute",QryDate,OEOREOrdID,OEOREOrdChild,OEOREChild)) Q:OEOREChild=""  d
		...s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		...s ChangeStatus=""
		...s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		...s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		...Q:ChangeStatus'="F"
		...s ChangeCP=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",15)
		...s ChangeUser=$o(^SSU("SSUSR",0,"CTPCP",ChangeCP,0))
		...s OEOREQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",4)
		...s OEOREAdminQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",5)
		...s UserCTLOCDR=$p($G(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"NUR"),"^",30)
		...s:CureOrdPHFreqDR="" OEOREQty=OEOREAdminQty
		...s ChangeNum=OEOREQty
		...Q:ChangeNum=0
		...Q:(StartDate'="")&&(ChangeDate<StartDate)
		...Q:(EndDate'="")&&(ChangeDate>EndDate)
		...Q:(queryDoc'="")&&(queryDoc'=ChangeUser)
		...Q:(UserCTLOCDR'="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_UserCTLOCDR_"^"))
		...Q:(UserCTLOCDR'="")&&(LogLocIDStr="")&&(LogLocID'=UserCTLOCDR)
		...Q:(UserCTLOCDR="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		...Q:(UserCTLOCDR="")&&(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		...d ReserveVarWorkReportFor
		...d GetWorkReportFor
	}
	if query="dept"{
		s myCureOrdArcimId=""
		s TotalOrderQty=0,TotalOrdPrice=0
		for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId)) q:myCureOrdArcimId=""  d
		.d ReserveVarWorkReportFor
		.s TDCARowId=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^")
		.s TArcimDesc=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",2)
		.s TUnitPrice=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",3)
		.s TOrderQty=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",4)
		.s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",5)
		.s TOrdPrice=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",6)
		.s TotalOrderQty=TotalOrderQty+TOrderQty
		.s TotalOrdPrice=TotalOrdPrice+TOrdPrice
		.s TOrdPrice=$j(TOrdPrice,10,2)
		.d OutputRowWorkReportFor
		s TDCARowId=""
		s TFinishUser=""
		s TArcimDesc="合计"
		s TUnitPrice="-",TOrdBillUOM="-"
		s TOrderQty=TotalOrderQty
		s TOrdPrice=$j(TotalOrdPrice,10,2)
		d OutputRowWorkReportFor
	}elseif query="doc"{
		s myChangeUser=""
		for  s myChangeUser=$o(^||TMPSort("QryWorkReportForUser",myChangeUser)) q:myChangeUser=""  d
		.s myCureOrdArcimId=""
		.s TotalOrderQty=0,TotalOrdPrice=0
		.for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId)) q:myCureOrdArcimId=""  d
		..d ReserveVarWorkReportFor
		..s TDCARowId=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^")
		..s TFinishUser=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",2)
		..s TArcimDesc=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",3)
		..s TUnitPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",4)
		..s TOrderQty=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",5)
		..s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",6)
		..s TOrdPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",7)
		..s TotalOrderQty=TotalOrderQty+TOrderQty
		..s TotalOrdPrice=TotalOrdPrice+TOrdPrice
		..s TOrdPrice=$j(TOrdPrice,10,2)
		..d OutputRowWorkReportFor
		.s TDCARowId=""
		.s TFinishUser="合计"
		.s TArcimDesc="-",TUnitPrice="-",TOrdBillUOM="-"
		.s TOrderQty=TotalOrderQty
		.s TOrdPrice=$j(TotalOrdPrice,10,2)
		.d OutputRowWorkReportFor
	}

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportFor
	set Data=$lb(ind,TDCARowId,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,TFinishUser,Job)
 	s ^TMPQryWorkReportFor("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice_"^"_TFinishUser
 	s ^TMPQryWorkReportFor("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetWorkReportFor
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s OrderQty=ChangeNum
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$g(UnitPrice)*ChangeNum
	if query="doc"{
		s:ChangeUser'="" FinishUser=$P(^SSU("SSUSR",ChangeUser),"^",2) ;$p(CureAppInfo,"^",20)
		if '$d(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)){
			s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
		}else{
			s ChangeNums=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",5)+OrderQty
			s OrdPrices=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",7)+OrdPrice
			s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
		}
	}elseif query="dept"{
		if '$d(^||TMPSort("QryWorkReportForDept",CureOrdArcimId)){
			s ^||TMPSort("QryWorkReportForDept",CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
		}else{
			s ChangeNums=$p(^||TMPSort("QryWorkReportForDept",CureOrdArcimId),"^",4)+OrderQty
			s OrdPrices=$p(^||TMPSort("QryWorkReportForDept",CureOrdArcimId),"^",6)+OrdPrice
			s ^||TMPSort("QryWorkReportForDept",CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
		}
	}
	
 	quit
ReserveVarWorkReportFor
 	set (TFinishUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice)=""
 	quit
}

Query QryWorkReportFor(query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,FinishUser:%String,Job:%String")
{
}

ClassMethod QryWorkReportForClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForExecute ]
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

ClassMethod GetQryWorkReportForNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportFor("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportFor("DHCDOCCURE",USERID,ProcessNo,Num))
}

Query QryWorkReportForDocApp(StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,CureAppUser:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String")
{
}

/// 治疗站医师申请工作量统计
ClassMethod QryWorkReportForDocAppExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportForDocApp","2018-07-01","2018-07-11","4852")
	s ^TMP("QryWorkReportForDocApp")=StartDate_","_EndDate_","_UserID_","_queryDoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=1
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	;if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID)
	s TotalPrice=0
	for Date=StartDate:1:EndDate{
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",Date,DCARowId)) q:DCARowId=""  d
		.s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		.Q:ApplyStatus="C"
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.s CureAppUserDr=$p($g(^DHCDocCure(DCARowId)),"^",4)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdAddLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),7)),"^",2)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdAddLocId_"^"))
		.Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		.Q:(queryDoc'="")&&(queryDoc'=CureAppUserDr)
		.d ReserveVarWorkReportForDocApp
		.d GetWorkReportForDocApp
	}
	s myCureAppUser=""
	for  s myCureAppUser=$o(^||TMPSort("QryWorkReportForDocApp",myCureAppUser)) q:myCureAppUser=""  d
	.s myCureOrdArcimId=""
	.s TotalOrderQty=0,TotalOrdPrice=0
	.for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId)) q:myCureOrdArcimId=""  d
	..d ReserveVarWorkReportForDocApp
	..s TDCARowId=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^")
	..s TCureAppUser=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",2)
	..s TArcimDesc=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",3)
	..s TUnitPrice=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",4)
	..s TOrderQty=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",5)
	..s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",6)
	..s TOrdPrice=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",7)
	..s TotalOrderQty=TotalOrderQty+TOrderQty
	..s TotalOrdPrice=TotalOrdPrice+TOrdPrice
	..s TOrdPrice=$j(TOrdPrice,10,2)
	..d OutputRowWorkReportForDocApp
	.s TDCARowId=""
	.s TCureAppUser="合计"
	.s TArcimDesc="-",TUnitPrice="-",TOrdBillUOM="-"
	.s TOrderQty=TotalOrderQty
	.s TOrdPrice=$j(TotalOrdPrice,10,2)
	.d OutputRowWorkReportForDocApp

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportForDocApp
	set Data=$lb(ind,TDCARowId,TCureAppUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,Job)
 	s ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TCureAppUser_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice
 	s ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetWorkReportForDocApp
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=+$p(CureAppInfo,"^",3)
	if OrderQty=0 s OrderQty=1
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$g(UnitPrice)*OrderQty
	s CureAppUser=""
	s:CureAppUserDr'="" CureAppUser=$P(^SSU("SSUSR",CureAppUserDr),"^",2) ;$p(CureAppInfo,"^",20)
	if '$d(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)){
		s ^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)=DCARowId_"^"_CureAppUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
	}else{
		s ChangeNums=$p(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId),"^",5)+OrderQty
		s OrdPrices=$p(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId),"^",7)+OrdPrice
		s ^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)=DCARowId_"^"_CureAppUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
	}
	
 	quit

ReserveVarWorkReportForDocApp
 	set (TCureAppUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice)=""
 	quit
}

ClassMethod QryWorkReportForDocAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForDocAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForDocAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForDocAppExecute ]
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

ClassMethod GetQryWorkReportForDocAppNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportForDocApp("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForDocAppInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportForDocApp("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// 治疗服务组预约表
/// w ##class(DHCDoc.DHCDocCure.WordReport).MonthAppReport("2018-06-1","2018-06-30",49,4852)
ClassMethod MonthAppReport(StartDate As %String, EndDate As %String, queryGroup As %String, USERID As %String)
{
	K ^TMPMonthAppReport("DHCDOCCURE",USERID)
	s SericeGroup=queryGroup
	s TimeCount=0
	if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,4)
	else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	else  s StartDate=+$h
	if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
	else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	else  s EndDate=+$h
	For QueryDate=StartDate:1:EndDate Do
	.s DDCRSRowID=""
	.for  s DDCRSRowID=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup,QueryDate,DDCRSRowID)) q:DDCRSRowID=""  d
	..s QueryDay=+$p($zd(QueryDate,3),"-",3)
	..s Data=$g(^DHCDocCureRBCResSchdule(DDCRSRowID))
	..s DDCRSDate=$p(Data,"^",4)  //出诊日期
	..s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
	..s DDCRSStartTime=$p(Data,"^",6)  //开始时间
	..s DDCRSEndTime=$p(Data,"^",7)  //结束时间
	..s RSStartTime=$zt(DDCRSStartTime,2)
	..s RSEndTime=$zt(DDCRSEndTime,2)
	..s AppedSum=+$p($g(^TMPMonthAppReport("DHCDOCCURE",USERID,DDCRSStartTime,QueryDay)),"^",2)
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId)) q:DCARowId=""  d
	...s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	...Q:(ApplyStatus="C")
	...s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId,DCAAChildSubRowID)) q:DCAAChildSubRowID=""  d
	....s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID))
	....q:Data=""
	....s DCAAStatus=$p(Data,"^",7)   //预约状态
	....q:(DCAAStatus'="I")&&(DCAAStatus'="A")
    ....s AppedSum=AppedSum+1
    ..s TimeCount=TimeCount+1
    ..s ^TMPMonthAppReport("DHCDOCCURE",USERID,DDCRSStartTime,QueryDay)=RSStartTime_"-"_RSEndTime_"^"_AppedSum
    s myDDCRSStartTime=""
    s mysortno=0
    for  s myDDCRSStartTime=$o(^TMPMonthAppReport("DHCDOCCURE",USERID,myDDCRSStartTime)) q:myDDCRSStartTime=""  d
    .s myQueryDay=""
    .s mysortno=mysortno+1
    .for  s myQueryDay=$o(^TMPMonthAppReport("DHCDOCCURE",USERID,myDDCRSStartTime,myQueryDay)) q:myQueryDay=""  d
    ..s ^TMPMonthAppReport("DHCDOCCURE",USERID,mysortno,myQueryDay)=^TMPMonthAppReport("DHCDOCCURE",USERID,myDDCRSStartTime,myQueryDay)
    ..s ^TMPMonthAppReport("DHCDOCCURE",USERID,mysortno)=$p(^TMPMonthAppReport("DHCDOCCURE",USERID,myDDCRSStartTime,myQueryDay),"^",1)
    q mysortno
}

ClassMethod GetMonthAppInfo(QueryDay As %String, TimeCount As %String, USERID As %String)
{
	Q $g(^TMPMonthAppReport("DHCDOCCURE",USERID,TimeCount,QueryDay))
}

ClassMethod GetMonthAppTimeInfo(TimeCount As %String, USERID As %String)
{
	Q $g(^TMPMonthAppReport("DHCDOCCURE",USERID,TimeCount))
}

Query QryCureProcess(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "") As %Query(ROWSPEC = "DCAARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,Job:%String,CureDate:%String,ApplyAppInfo:%String,RecordInfo:%String,IStatusInfo:%String,CStatusInfo:%String,AStatusInfo:%String,ApplyInfo:%String")
{
}

/// 治疗过程状态查询
ClassMethod QryCureProcessExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryCureProcess","2018-6-20","2018-6-23",4636,7)
	s ^TMP("QryQryCureProcess")=StartDate_","_EndDate_","_UserID_","_queryLoc_","_queryStatus_","_queryArcim_","_queryGroup
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set myind=1
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,4)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k ^TMPQryCureProcessReport("DHCDOCCURE",UserID)
	if queryStatus="ALL" s queryStatus=""
	For QueryDate=StartDate:1:EndDate Do
	.s DCARowId=""
	.for  s DCARowId=$o(^DHCDocCure(0,"AppDate",QueryDate,DCARowId)) Q:DCARowId=""  d
	..s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	..s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
	..Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
	..s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
	..q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
	..s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(0,"AppDate",QueryDate,DCARowId,DCAAChildSubRowID)) Q:DCAAChildSubRowID=""  d
	...s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID)),"^",7)
	...q:(queryStatus'="")&&(DCAAStatus'=queryStatus)
	...d ReserveVarCureProcess
	...d OutputRowCureProcess
	s myDDCRSDate=""
	f  s myDDCRSDate=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate)) q:myDDCRSDate=""  d
	.s myDDCRSStartTime=""
	.f  s myDDCRSStartTime=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime)) q:myDDCRSStartTime=""  d
	..s myDCAAppointRowID1=""
	..f  s myDCAAppointRowID1=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)) q:myDCAAppointRowID1=""  d
	...set Data1=^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)
	...Set ^CacheTemp(repid,ind)=Data1
	...Set ind=ind+1
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowCureProcess
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'="" d
	.s AdmType=$P(^PAADM(Adm),"^",2)
	.s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	.s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	;s OrderStatus=$p(CureAppInfo,"^",2)
	;s OrderQty=$p(CureAppInfo,"^",3)
	;s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyStatus=$case(DCAAStatus,"I":"预约","A":"完成","C":"取消预约",:"")
	
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyInfo=ApplyDate_"由"_ApplyUser_"登记"
	;s CureDate=$p(ApplyDate," ")
	;s OrdPrice=$p(CureAppInfo,"^",17) 
	;s OrdBilled=$p(CureAppInfo,"^",18) 
	;s UnitPrice=$p(CureAppInfo,"^",19) 
	s ServiceGroupDR=$p(CureAppInfo,"^",21)
	q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
	s CureDate=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID),"^",4)
	s:CureDate'="" CureDate=$zd(CureDate,3)
	s myDCAAppointRowID=""
	s myDCAAppointRowID=DCARowId_"||"_DCAAChildSubRowID
	s ApplyAppInfo=..GetCureAppointByApply(DCARowId,myDCAAppointRowID)
	s RecordInfo=""
	s RecordInfoRet=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA(myDCAAppointRowID,1)
	if RecordInfoRet'="" s RecordInfo=$p(RecordInfoRet,"^",4)
	;s:RecordInfo="" RecordInfo="正常执行(默认)"
	;s RecordInfo=##class(ext.util.String).EvalJSON(RecordInfo)
	s IStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"I")
	s CStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"C")
	s AStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"A")
	set Data=$lb(myDCAAppointRowID,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,Job,CureDate,ApplyAppInfo,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo)
	
	s AppData=$g(^DHCDocCure(+myDCAAppointRowID,"Arrive",$p(myDCAAppointRowID,"||",2)))
	s DCAARBASDR=$p(AppData,"^",1)  //资源排班ID
	s ResData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
	s DDCRSDate=$p(ResData,"^",4)  //出诊日期
	s DDCRSStartTime=$p(ResData,"^",6)  //开始时间
	s ^||TMPQryCureProcessReport("DHCDOCCURE_SORT",DDCRSDate,DDCRSStartTime,myDCAAppointRowID)=Data
	s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)=myDCAAppointRowID_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_CureDate_"^"_ApplyAppInfo_"^"_RecordInfo_"^"_IStatusInfo_"^"_CStatusInfo_"^"_AStatusInfo_"^"_ApplyInfo
	s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,"num")=myind
	s myind=myind+1
	quit
 	
ReserveVarCureProcess
 	set (PatientNo,PatientName,PatientSex,PatientAge,PatientTel,AdmType,AdmDep,ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,CureDate,ApplyCureRecord,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo)=""
 	quit
}

ClassMethod QryCureProcessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCureProcessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCureProcessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCureProcessExecute ]
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

ClassMethod GetQryCureProcessNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryCureProcessReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryCureProcessInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryCureProcessReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

ClassMethod GetStatsuInfo(DCAARowID As %String, Status As %String)
{
	s StatsuInfoRet=""
	s DCAASTATChild=""
	s mycount=0
	for  s DCAASTATChild=$o(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild)) q:DCAASTATChild=""  d
	.s mycount=mycount+1
	.s Update=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",2)
	.s Update=##class(websys.Conversions).DateLogicalToHtml(Update) ;$zd(Update,3)
	.s Uptime=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",3)
	.s Uptime=$zt(Uptime,2)
	.s UpStat=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",4)
	.Q:Status'=UpStat
	.s UpStat=$case(UpStat,"I":"预约","A":"治疗完成","C":"取消预约",:"")
	.s UpUserID=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",5)
	.s UpUser=$p(^SSU("SSUSR",UpUserID),"^",2)
	.s info=Update_" "_Uptime_"由"_UpUser_UpStat
	.if StatsuInfoRet="" s StatsuInfoRet=info
	.else  s StatsuInfoRet=StatsuInfoRet_""_info
	if StatsuInfoRet="" s StatsuInfoRet="-"
	q StatsuInfoRet
}

ClassMethod OPDoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","OPDoclookup","221","")
ClassMethod OPDoclookupExecute(ByRef qHandle As %Binary, locid As %String, RDocdesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s OPDocdesc="",rowid="0",OtherName=""
	s RDocdesc=$zcvt(RDocdesc,"U")
	if locid'=""{
		s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(locid)
		for loccount=1:1:$l(LogLocIDStr,"^") d
		.s mylocid=$p(LogLocIDStr,"^",loccount)
		.Q:mylocid=""
		.s RowId="0" f  Set RowId=$o(^RB("RES",0,"CTLOC",mylocid,RowId)) quit:RowId=""  d
		..Set DocDr=""
		..If ($D(^RB("RES",RowId))) do 
		...Set DocDr=$p(^RB("RES",RowId),"^",2)
		..If DocDr="" Quit
		..s locdesc=$p(^CTLOC(mylocid),"^",2)
		..if locdesc["-" s locdesc=$p(locdesc,"-",2)
		..s OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
		..s OPDocCode=$p(^CTPCP(DocDr,1),"^",1)
		..&sql(select CTPCP_OtherName into :OtherName from SQLUser.CT_CareProv where CTPCP_RowId=:DocDr )
		..s OtherName=$zcvt(OtherName,"U")
		..Q:(OPDocdesc'[RDocdesc)&&(OPDocCode'=RDocdesc)&&(OtherName'=RDocdesc)&&(RDocdesc'="")
		..s rowid=$O(^SSU("SSUSR",0,"CTPCP",DocDr,0)) ;DocDr
		..if rowid="" quit
		..Q:$d(^||tmpOutPutArr(rowid))
		..s ^||tmpOutPutArr(rowid)=""
	 	..d OutputRow9
	}else{
		f  s locid=$o(^RB("RES",0,"CTLOC",locid)) quit:locid=""  d
		.s RowId="0" f  Set RowId=$o(^RB("RES",0,"CTLOC",locid,RowId)) quit:RowId=""  d
		..Set DocDr=""
		..If ($D(^RB("RES",RowId))) do 
		...Set DocDr=$p(^RB("RES",RowId),"^",2)
		..If DocDr="" Quit
		..s OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
		..s OPDocCode=$p(^CTPCP(DocDr,1),"^",1)
		..&sql(select CTPCP_OtherName into :OtherName from SQLUser.CT_CareProv where CTPCP_RowId=:DocDr )
		..s OtherName=$zcvt(OtherName,"U")
		..Q:(OPDocdesc'[RDocdesc)&&(OPDocCode'=RDocdesc)&&(OtherName'=RDocdesc)&&(RDocdesc'="")
		..s rowid=$O(^SSU("SSUSR",0,"CTPCP",DocDr,0)) ;DocDr
		..if rowid="" quit
		..Q:$d(^||tmpOutPutArr(rowid))
		..s ^||tmpOutPutArr(rowid)=""
	 	..d OutputRow9	
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(OPDocdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPDoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDoclookupExecute ]
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

Query OPDoclookup(locid As %String, RDocdesc As %String) As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String")
{
}

Query FindCureStatus() As %Query(ROWSPEC = "CureStatusCode:%String,CureStatusDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCureStatusExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCardType")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	set Default=0
	;set CureStatusStr=Apply,Cancel,Finish
	;set CureStatusStr="NA"_$c(1)_"未预约"_"^"_"A"_$c(1)_"已预约"_"^"_"D"_$c(1)_"已治疗"_"^"_"ALL"_$c(1)_"全部"
	set CureStatusStr="ANA"_$c(1)_"申请未预约"_"^"_"ANC"_$c(1)_"预约未治疗"_"^"_"AC"_$c(1)_"在治疗"_"^"_"A"_$c(1)_"预约(包含未治疗在治疗)"_"^"_"C"_$c(1)_"已取消"_"^"_"F"_$c(1)_"已完成"_"^"_"ALL"_$c(1)_"全部"
	s StatusLen=$l(CureStatusStr,"^")
	f StatusCount=1:1:StatusLen d
	.s aCureStatus=$p(CureStatusStr,"^",StatusCount)
	.s mydes=$p(aCureStatus,$C(1), 2)
	.s mycode=$p(aCureStatus,$C(1), 1)
	.Do OutputRowCureStatus
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCureStatus
	Set Data=$lb(mycode,mydes,Default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCureStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureStatusExecute ]
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

Query QryWorkReportForUser(StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,FinishUser:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String")
{
}

/// 治疗站个人工作量统计
ClassMethod QryWorkReportForUserExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportForUser","2018-01-07","2018-01-07","5")
	s ^TMP("QryWorkReportForUser")=StartDate_","_EndDate_","_UserID_","_queryDoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=1
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	;if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportForUser("DHCDOCCURE",UserID)
	s TotalPrice=0
	s FindCureState="A^F"
	for mycount=1:1:$l(FindCureState,"^"){
		s aCureState=$p(FindCureState,"^",mycount)
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"STAT",aCureState,DCARowId)) q:DCARowId=""  d
		.;s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.s CureFinishUser=$p(^DHCDocCure(DCARowId),"^",12)
		.s CureFinishDate=$p(^DHCDocCure(DCARowId),"^",13)
		.s CureFinishTime=$p(^DHCDocCure(DCARowId),"^",14)
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		.Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		.;Q:(queryDoc'="")&&(queryDoc'=CureFinishUser)
		.s StateChangeChild=0
		.for  s StateChangeChild=$o(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild)) q:StateChangeChild=""  d
		..s ChangeDate=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",1)
		..s ChangeUser=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",3)
		..s ChangeType=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",4)
		..s ChangeNum=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",5)
		..Q:ChangeNum=0
		..Q:(StartDate'="")&&(ChangeDate<StartDate)
		..Q:(EndDate'="")&&(ChangeDate>EndDate)
		..Q:(queryDoc'="")&&(queryDoc'=ChangeUser)
		..d ReserveVarWorkReportForUser
		..d GetWorkReportForUser
	}
	b ;nk-1
	s myChangeUser=""
	for  s myChangeUser=$o(^||TMPSort("QryWorkReportForUser",myChangeUser)) q:myChangeUser=""  d
	.s myCureOrdArcimId=""
	.s TotalOrderQty=0,TotalOrdPrice=0
	.for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId)) q:myCureOrdArcimId=""  d
	..d ReserveVarWorkReportForUser
	..s TDCARowId=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^")
	..s TFinishUser=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",2)
	..s TArcimDesc=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",3)
	..s TUnitPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",4)
	..s TOrderQty=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",5)
	..s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",6)
	..s TOrdPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",7)
	..s TotalOrderQty=TotalOrderQty+TOrderQty
	..s TotalOrdPrice=TotalOrdPrice+TOrdPrice
	..s TOrdPrice=$j(TOrdPrice,10,2)
	..d OutputRowWorkReportForUser
	.s TDCARowId=""
	.s TFinishUser="合计"
	.s TArcimDesc="-",TUnitPrice="-",TOrdBillUOM="-"
	.s TOrderQty=TotalOrderQty
	.s TOrdPrice=$j(TotalOrdPrice,10,2)
	.d OutputRowWorkReportForUser

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportForUser
	set Data=$lb(ind,TDCARowId,TFinishUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,Job)
 	s ^TMPQryWorkReportForUser("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TFinishUser_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice
 	s ^TMPQryWorkReportForUser("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetWorkReportForUser
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	if ArcimDesc["(" s ArcimDesc=$p(ArcimDesc,"(",1)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s OrderQty=ChangeNum
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$g(UnitPrice)*ChangeNum
	s:ChangeUser'="" FinishUser=$P(^SSU("SSUSR",ChangeUser),"^",2) ;$p(CureAppInfo,"^",20)
	if '$d(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)){
		s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
	}else{
		s ChangeNums=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",5)+OrderQty
		s OrdPrices=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",7)+OrdPrice
		s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
	}
	
 	quit

ReserveVarWorkReportForUser
 	set (TFinishUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice)=""
 	quit
}

ClassMethod QryWorkReportForUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForUserExecute ]
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

ClassMethod GetQryWorkReportForUserNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportForUser("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForUserInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportForUser("DHCDOCCURE",USERID,ProcessNo,Num))
}

Query QryWorkReportForDept(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryArcim As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String")
{
}

/// 治疗站科室工作量统计
ClassMethod QryWorkReportForDeptExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryArcim As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportForDept","2017-08-01","9/20/2017","1")
	s ^TMP("QryWorkReportForDept")=StartDate_","_EndDate_","_UserID_","_queryLoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=1
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	s LogLocID=queryLoc
	if queryLoc="" s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	;if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportForDept("DHCDOCCURE",UserID)
	s TotalPrice=0
	s FindCureState="A^F"
	for mycount=1:1:$l(FindCureState,"^"){
		s aCureState=$p(FindCureState,"^",mycount)
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"STAT",aCureState,DCARowId)) q:DCARowId=""  d
		.;s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.s CureFinishUser=$p(^DHCDocCure(DCARowId),"^",12)
		.s CureFinishDate=$p(^DHCDocCure(DCARowId),"^",13)
		.s CureFinishTime=$p(^DHCDocCure(DCARowId),"^",14)
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
		.Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		.;Q:(queryDoc'="")&&(queryDoc'=CureFinishUser)
		.s StateChangeChild=0
		.for  s StateChangeChild=$o(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild)) q:StateChangeChild=""  d
		..s ChangeDate=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",1)
		..s ChangeUser=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",3)
		..s ChangeType=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",4)
		..s ChangeNum=$p(^DHCDocCure(DCARowId,"DCAEC",StateChangeChild),"^",5)
		..Q:ChangeNum=0
		..Q:(StartDate'="")&&(ChangeDate<StartDate)
		..Q:(EndDate'="")&&(ChangeDate>EndDate)
		..d ReserveVarWorkReportForDept
		..d GetWorkReportForDept
	}
	s myCureOrdArcimId=""
	s TotalOrderQty=0,TotalOrdPrice=0
	for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId)) q:myCureOrdArcimId=""  d
	.d ReserveVarWorkReportForDept
	.s TDCARowId=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^")
	.s TArcimDesc=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",2)
	.s TUnitPrice=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",3)
	.s TOrderQty=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",4)
	.s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",5)
	.s TOrdPrice=$p(^||TMPSort("QryWorkReportForDept",myCureOrdArcimId),"^",6)
	.s TotalOrderQty=TotalOrderQty+TOrderQty
	.s TotalOrdPrice=TotalOrdPrice+TOrdPrice
	.s TOrdPrice=$j(TOrdPrice,10,2)
	.d OutputRowWorkReportForDept
	s TDCARowId=""
	s TArcimDesc="合计"
	s TUnitPrice="-",TOrdBillUOM="-"
	s TOrderQty=TotalOrderQty
	s TOrdPrice=$j(TotalOrdPrice,10,2)
	d OutputRowWorkReportForDept

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportForDept
	set Data=$lb(ind,TDCARowId,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,Job)
 	s ^TMPQryWorkReportForDept("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice
 	s ^TMPQryWorkReportForDept("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetWorkReportForDept
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s OrderQty=ChangeNum
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$g(UnitPrice)*ChangeNum
	if '$d(^||TMPSort("QryWorkReportForDept",CureOrdArcimId)){
		s ^||TMPSort("QryWorkReportForDept",CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
	}else{
		s ChangeNums=$p(^||TMPSort("QryWorkReportForDept",CureOrdArcimId),"^",5)+OrderQty
		s OrdPrices=$p(^||TMPSort("QryWorkReportForDept",CureOrdArcimId),"^",7)+OrdPrice
		s ^||TMPSort("QryWorkReportForDept",CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
	}
 	quit
ReserveVarWorkReportForDept
 	set (TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice)=""
 	quit
}

ClassMethod QryWorkReportForDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForDeptExecute ]
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

ClassMethod GetQryWorkReportForDeptNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportForDept("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForDeptInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportForDept("DHCDOCCURE",USERID,ProcessNo,Num))
}

ClassMethod test() As %String
{
}

}
