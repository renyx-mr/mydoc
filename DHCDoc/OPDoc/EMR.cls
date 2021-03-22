Class DHCDoc.OPDoc.EMR Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2016-08-04
/// desc:获取患者就诊历史列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetPatHistoryAdmList","189")
Query GetPatHistoryAdmList(EpisodeID As %String = "", PatientID As %String = "", OrderBy As %String = "All", ExpString As %String = "") As %Query(ROWSPEC = "MainDiagnos:%String,AdmDate:%String,AdmLoc:%String,AdmDoc:%String,AdmRowId:%String,AdmType:%String")
{
}

ClassMethod GetPatHistoryAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatHistoryAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod GetPatHistoryAdmListExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", PatientID As %String = "", OrderBy As %String = "All", ExpString As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetPatHistoryAdmList","",2,"All","")
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	if (EpisodeID="")&&(PatientID="") {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s StartDate=$p(ExpString,$c(1),1)
	i StartDate'=""{
	   i StartDate["-" s StartDate=$zdh(StartDate,3)
	   i StartDate["/" s StartDate=$zdh(StartDate,4)
	}
	s EndDate=$p(ExpString,$c(1),2)
	i EndDate'=""{
	   i EndDate["-" s EndDate=$zdh(EndDate,3)
	   i EndDate["/" s EndDate=$zdh(EndDate,4)
	}
	s paraAdmTypeStr=$p(ExpString,$c(1),3)
	
	k ^TEMPPatHistoryAdmList($j)
	k ^TEMPPatHistoryAdmListOrderByDiag($j)
	k ^TEMPPatHistoryAdmListOrderByLoc($j)
	
	s tmpPatientID=PatientID
	if (tmpPatientID="") s tmpPatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PAADMTypeStr="O^E^I"
	i paraAdmTypeStr'="" s PAADMTypeStr=paraAdmTypeStr
	s ^tmpscl("GetPatHistoryAdmList")=EpisodeID_","_PatientID_","_OrderBy_","_StartDate_","_EndDate
	for i=1:1:$l(PAADMTypeStr,"^") d
	.s PAADMType=$p(PAADMTypeStr,"^",i)
	.s AdmRowId=""
	.f  s AdmRowId=$o(^PAPERdr(tmpPatientID,"ADM",PAADMType,AdmRowId),-1) q:(AdmRowId="")  d
	..s AdmDate=$p($g(^PAADM(AdmRowId)),"^",6)
	..Q:(StartDate'="")&&(AdmDate<StartDate)
	..Q:(EndDate'="")&&(AdmDate>EndDate)
	..//s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate) //$zd(AdmDate,3)
	..s PAADMMainMRADMDR=$p($g(^PAADM(AdmRowId)),"^",61)
	..s MRDIAChildsub=0,MainDiagnos=""
	..f  s MRDIAChildsub=$o(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)) q:(MRDIAChildsub="")  d  //||(MainDiagnos'="")
	...s MainDiagFlag=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub,1)),"^",20)
	...i MainDiagFlag="Y" d
	....s MRDIAICDCodeDR=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)),"^",1)
	....i MRDIAICDCodeDR'="" s tmpMainDiagnos=$p(^MRC("ID",MRDIAICDCodeDR),"^",2)
	....e  s tmpMainDiagnos=$g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub,"DES",1))
	....i MainDiagnos="" s MainDiagnos=tmpMainDiagnos
	....e  s MainDiagnos=MainDiagnos_";"_tmpMainDiagnos
	..s AdmLocDr=$p($g(^PAADM(AdmRowId)),"^",4)
	..s AdmLoc=$p(^CTLOC(AdmLocDr),"^",2)
	..s AdmLocDesc=$p(AdmLoc,"-",2)
	..i AdmLocDesc'="" s AdmLoc=AdmLocDesc
	..s AdmDoc=""
	..s PAAdmDocCodeDR=$P($g(^PAADM(AdmRowId)),"^",9)
	..i PAAdmDocCodeDR'="" s AdmDoc=$P($g(^CTPCP(PAAdmDocCodeDR,1)),"^",2)
	..s Data=AdmRowId_"$"_MainDiagnos_"$"_##class(websys.Conversions).DateLogicalToHtml(AdmDate)_"$"_AdmLoc_"$"_AdmDoc
	..s ^TEMPPatHistoryAdmList($j,AdmDate,AdmRowId)=Data
	..s tempMainDiagnos="99"
	..i MainDiagnos'="" s tempMainDiagnos=MainDiagnos
	..s ^TEMPPatHistoryAdmListOrderByDiag($j,tempMainDiagnos,AdmRowId)=Data
	..s ^TEMPPatHistoryAdmListOrderByLoc($j,AdmLoc,AdmRowId)=Data
	if (OrderBy="All"){
		s tmpAdmDate=""
		f  s tmpAdmDate=$o(^TEMPPatHistoryAdmList($j,tmpAdmDate),-1) q:tmpAdmDate=""  d
		.s tmpAdmRowId=""
		.f  s tmpAdmRowId=$o(^TEMPPatHistoryAdmList($j,tmpAdmDate,tmpAdmRowId),-1) q:tmpAdmRowId=""  d
		..s Data=$g(^TEMPPatHistoryAdmList($j,tmpAdmDate,tmpAdmRowId))
		..d GetOutputRowDate(Data)
	}elseif(OrderBy="OrderByDiag"){
		s tmpDiag=0
		f  s tmpDiag=$o(^TEMPPatHistoryAdmListOrderByDiag($j,tmpDiag)) q:tmpDiag=""  d
		.s tmpAdmRowId=""
		.f  s tmpAdmRowId=$o(^TEMPPatHistoryAdmListOrderByDiag($j,tmpDiag,tmpAdmRowId),-1) q:tmpAdmRowId=""  d
		..s Data=$g(^TEMPPatHistoryAdmListOrderByDiag($j,tmpDiag,tmpAdmRowId))
		..d GetOutputRowDate(Data)
	}elseif(OrderBy="OrderByLoc"){
		s tmpLoc=0
		f  s tmpLoc=$o(^TEMPPatHistoryAdmListOrderByLoc($j,tmpLoc)) q:tmpLoc=""  d
		.s tmpAdmRowId=""
		.f  s tmpAdmRowId=$o(^TEMPPatHistoryAdmListOrderByLoc($j,tmpLoc,tmpAdmRowId),-1) q:tmpAdmRowId=""  d
		..s Data=$g(^TEMPPatHistoryAdmListOrderByLoc($j,tmpLoc,tmpAdmRowId))
		..d GetOutputRowDate(Data)
	}
	k ^TEMPPatHistoryAdmList($j)
	k ^TEMPPatHistoryAdmListOrderByDiag($j)
	k ^TEMPPatHistoryAdmListOrderByLoc($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
     set Data=$lb(MainDiagnos,AdmDate,AdmLoc,AdmDoc,AdmRowId,AdmType)
	 Set ^CacheTemp(repid,index)=Data
	 Set index=index+1
	 quit
GetOutputRowDate(Data)
    s AdmRowId=$p(Data,"$",1)
    s MainDiagnos=$p(Data,"$",2)
    //i MainDiagnos="" s MainDiagnos="测试诊断测试诊"
    s AdmDate=$p(Data,"$",3)
    //s AdmDate=$tr(AdmDate,"-",".")
    s AdmLoc=$p(Data,"$",4)
    s AdmDoc=$p(Data,"$",5)
    s AdmType=$p(^PAADM(AdmRowId),"^",2)
    d OutputRow1
 Quit
}

ClassMethod GetPatHistoryAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatHistoryAdmListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2016-08-011
/// desc:获取ztree父节点
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","EMRZTreeConfig","189")
Query EMRZTreeConfig(EpisodeID As %String) As %Query(ROWSPEC = "id:%String,pId:%String,text:%String,state:%String,checked:%String,urlObject:%String,isParent:%String,expandMethodForLoadingTable:%String,iconCls:%String") [ SqlProc ]
{
}

ClassMethod EMRZTreeConfigExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	//s id="EMR_"_EpisodeID,pId="",text="病历",iconCls="",state="open",checked="false",urlObject="opdoc.emr.info.csp",isParent="true",expandMethodForLoadingTable="" //LoadEMRInfo
	//d OutputRow2
	s id="Exam_"_EpisodeID,pId="",text="检查结果",iconCls="",state="closed",checked="false",urlObject="dhcem.inspectrs.csp?PatientID=@patientID&EpisodeID=@episodeID",isParent="true",expandMethodForLoadingTable="" //LoadExamOrdTable
	d OutputRow2
	s id="Lab_"_EpisodeID,pId="",text="化验结果",iconCls="",state="closed",checked="false",urlObject="dhcem.seepatlis.csp?PatientID=@patientID&EpisodeID=@episodeID",isParent="true",expandMethodForLoadingTable="" //LoadLabOrdTable
	d OutputRow2
	s id="Ord_"_EpisodeID,pId="",text="医嘱",iconCls="",state="closed",checked="false",urlObject="oeorder.opbillinfo.csp?&PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&copyOeoris=&copyTo=",isParent="true",expandMethodForLoadingTable="" //loadOrdTableData
	
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow2
	set Data=$lb(id,pId,text,state,checked,urlObject,isParent,expandMethodForLoadingTable,iconCls)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EMRZTreeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EMRZTreeConfigExecute ]
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

ClassMethod EMRZTreeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EMRZTreeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creator:宋春莉
/// date:2016-08-011
/// desc:获取ztree子节点数据
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","EMRZTreeChildNode","189")
Query EMRZTreeChildNode(parentNode As %String, SearchName As %String = "") As %Query(ROWSPEC = "id:%String,pId:%String,text:%String,nocheck:%String,checked:%String,state:%String,urlObject:%String,isParent:%String,urlObject:%String,expandMethodForLoadingTable:%String") [ SqlProc ]
{
}

ClassMethod EMRZTreeChildNodeExecute(ByRef qHandle As %Binary, parentNode As %String = "", SearchName As %String = "") As %Status
{
    s ^tempscl("EMRZTreeChildNode")=parentNode_","_SearchName
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	s SearchName=$$ALPHAUP^SSUTIL4(SearchName)
	d resetData
	s parentType=$p(parentNode,"_",1)
	s EpisodeID=$p(parentNode,"_",2)
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	if (OEORDRowId="")||(parentType="EMR") {
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}
	s OEORIChildsub=0
	f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.s OrdStatusCode=""
	.s OrdStatusDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.s:$g(OrdStatusDR)'="" OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	.Q:(OrdStatusCode'="E")&&(OrdStatusCode'="V")
	.s OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.s ARCIMItemCatDR=$p($g(^ARCIM(+OEORIItmMastDR,$p(OEORIItmMastDR,"||",2),1)),"^",10)
	.Q:ARCIMItemCatDR=""
	.s OrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
	.Q:(OrderType'="L")&&(parentType="Lab")
	.s ExamOrdFlag=0
	.i parentType="Exam" d
	..s ExamOrdFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(OEORIItmMastDR)
	.Q:(ExamOrdFlag=0)&&(parentType="Exam")
	.s name=$p($g(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1)),"^",2)
	.s FindFlag=0
	.i SearchName'="" d
	..s ALIASRowId=0 f  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",OEORIItmMastDR,ALIASRowId)) q:(ALIASRowId="")||(FindFlag=1)  d
	...s ALIASDesc=$p(^ARC("ALIAS",ALIASRowId),"^",6)
	...s ALIASDesc=$$ALPHAUP^SSUTIL4(ALIASDesc)
	...i ALIASDesc[SearchName s FindFlag=1
	.q:(SearchName'="")&&(name'[SearchName)&&(FindFlag=0)
	.s pId=parentNode
	.s id=OEORDRowId_"||"_OEORIChildsub_"$"_OEORIItmMastDR_"$"_parentType
	.s nocheck="true"
	.s checked="false"
	.s open="false"
	.s urlObject=""
	.s expandMethodForLoadingTable=""
	.i parentType="Lab" d
	..s urlObject="dhcem.seepatlis.csp?PatientID=@patientID&EpisodeID="_EpisodeID_"&OEORIID="_OEORDRowId_"||"_OEORIChildsub
	..s expandMethodForLoadingTable="" //LoadLabOrdResultTable
	.i parentType="Exam" d
	..s urlObject=""
	..s expandMethodForLoadingTable="" //LoadExamOrdResultTable
	.s isParent="false"
	.d OutputRow3
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow3
	set Data=$lb(id,pId,name,nocheck,checked,open,urlObject,isParent,urlObject,expandMethodForLoadingTable)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData
  s (id,pId,name,nocheck,checked,open,urlObject,isParent)=""
  quit
}

ClassMethod EMRZTreeChildNodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EMRZTreeChildNodeExecute ]
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

ClassMethod EMRZTreeChildNodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EMRZTreeChildNodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(DHCDoc.OPDoc.EMR).GetExamOrdList(189)

ClassMethod GetExamOrdList(EpisodeID As %String) As %String
{
	s ^tmpscl("GetExamOrdList")=EpisodeID
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="DHCDoc.OPDoc.EMR"
	set rs.QueryName="GetExamOrdListByAdm"
	set sc=rs.Execute(EpisodeID)
	s dataHeadConfig="PrintFlag:选择,OEORIRowID:,ArcimId:,OrdStartDate:医嘱日期,OrdStartTime:医嘱时间,ArcimDesc:医嘱名称,ReportDate:报告日期,ReportTime:报告时间,PAADMDate:就诊日期"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""ExamOrdList_Table"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	w ",""title"":""检查"""
	w ",""config"":{""checkHeaders"":{""0"":true}}"
	w "}"
	d rs.Close()
	q ""
}

ClassMethod FormatDataTable(ByRef rs As %ResultSet, dataHeadConfig As %String, ByRef needColMap, ByRef indexTitleData, isTruncated = 0)
{
	w ..FormatDataTableCols(.rs,dataHeadConfig,.needColMap,isTruncated)
	w ",""rows"":["
	s c=..FormatJson(.rs,.needColMap,.indexTitleData)
	w "],""total"":"_ c
}

ClassMethod FormatDataTableCols(ByRef rs As %ResultSet, dataHeadConfig As %String, ByRef needColMap, isTruncated = 0) As %String
{
	s status=""
	k dataHeadConfigMap,dataHeadConfigMap2,allPro,needColMap
	
	f i=1:1:rs.GetColumnCount() {
		s allPro(rs.GetColumnName(i))=i
		i 'isTruncated s needColMap(i)=rs.GetColumnName(i)
	}
	f i=1:1:$L(dataHeadConfig,","){
		s m=$P(dataHeadConfig,",",i)
		s d=$P(m,":",1)
		s h=$P(m,":",2)
		i '((h="")||(h="null")) {
			s dataHeadConfigMap(h)=d
			s dataHeadConfigMap2(i)=h
		}
		s:isTruncated needColMap(allPro(d))=d
		if ('$d(allPro(d))){
			s status="Config of "_h_"->"_d_" is wrong, no "_d_" column in this query!"
			q
		}
	}
	q:status'="" status
	s json= """head"":["
	s count=0
	s h="" f  {
		s h=$o(dataHeadConfigMap2(h))
		q:h=""
		s:count>0 json=json_","
		s json=json_ """"_dataHeadConfigMap2(h)_""""
		s count=count+1
	}
	s json=json_ "],""rowCols"":["
	s count=0
	s h="" f {
		s h=$o(dataHeadConfigMap2(h)) 
		q:h=""
		s:count>0 json=json_","
		s json=json_ "{""data"":"_""""_dataHeadConfigMap(dataHeadConfigMap2(h))_"""}"
		s count=count+1
	}
	s json=json_ "]"
	q json
}

ClassMethod FormatJson(rs As %ResultSet, ByRef needColMap = "", ByRef indexTitleData) As %Integer
{
	k allPro,proType
	s len=rs.GetColumnCount()
	f i=1:1:len {
		s allPro(i)=""""_rs.GetColumnName(i)_""":"
		s proType(i)=rs.GetColumnType(i)
	}
	s count=0
	While rs.Next(.sc) {
		if $$$ISERR(sc) Quit
		Write:count>0 (",")
		s count=count+1
		Write ( "{")
		s countPro=0
		s i="" f  {
			s i=$o(needColMap(i))
			q:i=""
			s colName=needColMap(i)
			Write:countPro>0 (",")
			s countPro=countPro+1
			Write ( allPro(i))
			s v=rs.GetData(i)
			s:(($d(indexTitleData(colName)))&&(v'="")) indexTitleData(colName)=v
			s t=proType(i)
			if (colName="ArcimDesc"){
				s v=##class(web.DHCDocUtil).EvalJSON(v)
			}
			Write (""""_v_"""")
		}
		Write ( "}")
	}
	q count
}

ClassMethod ReplaceStr(str, src = "", dem = "") As %String
{
	q:((src="")||(str="")) str
	s strLen=$l(str),srcLen=$l(src),demLen=$l(dem)
	s flag=0
	f i=1:1:strLen {
		s flag=1
		f j=1:1:srcLen {
			if ($e(str,i+j-1)=$e(src,j)){
			}else{
				s flag=0
				q
			}
		}
		if (flag=1){
			s $e(str,i,i+srcLen-1)=dem
			s i=i+demLen-1
		}
	}
	q str
}

/// creator:宋春莉
/// date:2016-08-12
/// desc:根据就诊ID 获取检查医嘱
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetExamOrdListByAdm","189")
Query GetExamOrdListByAdm(EpisodeID As %String) As %Query(ROWSPEC = "OEORIRowID:%String,ArcimId:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,ReportDate:%String,ReportTime:%String,PAADMDate:%String,PrintFlag:%String") [ SqlProc ]
{
}

ClassMethod GetExamOrdListByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	d resetData1
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID))
	if (OEORDRowId="") {
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}
	s OEORIChildsub=0
	f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.s ordstr1=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
	.s ArcimId=$p(ordstr1,"^",2)
	.s IsExamItemFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)
	.Q:IsExamItemFlag'=1
	.s OEORIRowID=OEORDRowId_"||"_OEORIChildsub
	.s RptRowIdStr=..GetRisReportId(OEORIRowID)
	.s RptRowId=$p(RptRowIdStr,"^",1)
	.i RptRowId="" d
	..//未出报告
	..s ReportDate=""
	..s ReportTime=""
	.e  d
	..;检查号
	..s StudyNo=$p(RptRowIdStr,"^",2)
	..s CurrentSpace=$znspace
	..zn "PACS"
	..s ReportInfo=##class(PACS.RISInterface).GetReportInfo(StudyNo)
	..zn CurrentSpace
	..s ReportDate="报告日期"
	..s ReportTime=$p(ReportInfo,"^",21)
	.s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
	.s OrdStartDate=$p(ordstr1,"^",9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,"^",10),OrdStartTime=$zt(OrdStartTime,2)
	.s PAADMDate=$p(^PAADM(EpisodeID),"^",6),PAADMDate=$zd(PAADMDate,3)
	.s PrintFlag=""
	.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow4
	set Data=$lb(OEORIRowID,ArcimId,OrdStartDate,OrdStartTime,ArcimDesc,ReportDate,ReportTime,PAADMDate,PrintFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData1
  s (ArcimId,OrdStartDate,OrdStartTime,ArcimDesc,ReportDate,ReportTime,PAADMDate,PrintFlag)=""
  quit
}

ClassMethod GetExamOrdListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExamOrdListByAdmExecute ]
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

ClassMethod GetExamOrdListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExamOrdListByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creator:宋春莉
/// date:2016-08-12
/// desc:根据就诊ID 获取检验医嘱
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetLabOrdListByAdm","189")
Query GetLabOrdListByAdm(EpisodeID As %String) As %Query(ROWSPEC = "OEORIRowID:%String,ArcimId:%String,OrdStartDate:%String,ArcimDesc:%String,OrdLabSpec:%String,LabEpisodeNo:%String,AuditDate:%String,ReportDate:%String,ApplyLoc:%String,ApplyDoc:%String,PrintFlag:%String") [ SqlProc ]
{
}

ClassMethod GetLabOrdListByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	d resetData2
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID))
	if (OEORDRowId="") {
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}
	s OEORIChildsub=0
	f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.s ordstr1=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
	.s ordstr3=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,3))
	.s ArcimId=$p(ordstr1,"^",2)
	.s ItemCatDR=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	.Q:OrderType'="L"
	.s OEORIRowID=OEORDRowId_"||"_OEORIChildsub
	.s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
	.s OrdStartDate=$p(ordstr1,"^",9),OrdStartDate=$zd(OrdStartDate,3)
	.s LabEpisodeNo=$p(ordstr3,"^",20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEORIRowID)
	.s AuditDate="" //审核日期
	.s ReportDate="" //报告日期
	.s ApplyLocDr=$p(^PAADM(EpisodeID),"^",4) 
	.s ApplyLoc=$p(^CTLOC(ApplyLocDr),"^",2)
	.s ApplyLoc1=$p(ApplyLoc,"-",2)
	.i ApplyLoc1'="" s ApplyLoc=ApplyLoc1
	.s OEORIDoctorDR=$p(ordstr1,"^",11)
	.s ApplyDoc=""
	.i OEORIDoctorDR'="" s ApplyDoc=$p(^CTPCP(OEORIDoctorDR,1),"^",2)
	.s PrintFlag=""
	.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow5
	set Data=$lb(OEORIRowID,ArcimId,OrdStartDate,ArcimDesc,OrdLabSpec,LabEpisodeNo,AuditDate,ReportDate,ApplyLoc,ApplyDoc,PrintFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData2
  s (OEORIRowID,ArcimId,OrdStartDate,ArcimDesc,OrdLabSpec,LabEpisodeNo,AuditDate,ReportDate,ApplyLoc,ApplyDoc)=""
  quit
}

ClassMethod GetLabOrdListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabOrdListByAdmExecute ]
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

ClassMethod GetLabOrdListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabOrdListByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(DHCDoc.OPDoc.EMR).GetLabOrdList(189)

ClassMethod GetLabOrdList(EpisodeID As %String) As %String
{
	s ^tmpscl("GetExamOrdList")=EpisodeID
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="DHCDoc.OPDoc.EMR"
	set rs.QueryName="GetLabOrdListByAdm"
	set sc=rs.Execute(EpisodeID)
	s dataHeadConfig="PrintFlag:选择,OEORIRowID:,ArcimId:,OrdStartDate:申请日期,ArcimDesc:医嘱名称,OrdLabSpec:标本类型,LabEpisodeNo:标本号,AuditDate:审核日期,ReportDate:报告日期,ApplyLoc:申请科室,ApplyDoc:申请医生"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""LabOrdList_Table"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	w ",""title"":""检验"""
	w ",""config"":{""checkHeaders"":{""0"":true}}"
	w "}"
	d rs.Close()
	q ""
}

/// creator:宋春莉
/// date:2016-08-12
/// desc:根据医嘱ID 获取检验医嘱结果
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetLabOrdResult","189")
Query GetLabOrdResultByOrd(OEORIRowID As %String) As %Query(ROWSPEC = "Name:%String,Sync:%String,Result:%String,Unit:%String,Flag:%String,Ranges:%String,LabDirection:%String,PrintFlag:%String,TestCodeDR:%String") [ SqlProc ]
{
}

ClassMethod GetLabOrdResultByOrdExecute(ByRef qHandle As %Binary, OEORIRowID As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	d resetData3
	Kill OutPutArray
	s OrdData3=$g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),3))
	s VisitNumberTestSetDR=$Piece(OrdData3,"^",35)
 	i VisitNumberTestSetDR="" {
	 	//4.未出检验报告
	 	d OutputRow6
	 	d OutputRow6
	 	d OutputRow6
	 	d OutputRow6
	 	d OutputRow6
	 	d OutputRow6
	 	//Set qHandle=$lb(0,repid,0)
	    //quit $$$OK
 	}else{
	 	;Code:检测项目,Name:项目名称,Sync:项目缩写,Result:项目结果,Flag:异常提示(H/L),Unit:单位,Ranges:参考范围,Comment:结果说明,Method:检测方法,Sequence:显示序号
	 	Set rset=##Class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId")
		If rset.QueryIsValid() { 
		    Set Status=rset.Execute(OEORIRowID)
			If 'Status Quit
			While (rset.Next()) {
				//s Code=rset.GetDataByName("Code")
			    s Name=rset.GetDataByName("Name")
			    s Sync=rset.GetDataByName("Sync")
			    s Result=rset.GetDataByName("Result")
			    s Flag=rset.GetDataByName("Flag")
			    s Unit=rset.GetDataByName("Unit")
			    s Ranges=rset.GetDataByName("Ranges")
			    s TestCodeDR=rset.GetDataByName("TestCodeDR")
			    /*s Comment=rset.GetDataByName("Comment")
			    s Method=rset.GetDataByName("Method")
			    s Sequence=rset.GetDataByName("Sequence")
			    s Name=Name_$e("            ",1,12-$l(Name))
			    s Result=Result_$e("    ",1,4-$l(Result))_Unit
			    s Ranges=Ranges_$e("      ",1,6-$l(Ranges))*/
			    s AbnormalLabOutput=Name_"^"_Sync_"^"_Result_"^"_Unit_"^"_Flag_"^"_Ranges_"^"_TestCodeDR
			    s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))=ArcimDesc
			}
			d rset.Close()
		}
	}
	s Node=""
	for {
		s Node=$o(OutPutArray(Node)) q:Node=""
		s Index=0
		for {
		   s Index=$o(OutPutArray(Node,Index)) q:Index=""
		   s NodeResultStr=OutPutArray(Node,Index)
		   s Name=$p(NodeResultStr,"^",1)
		   s Sync=$p(NodeResultStr,"^",2)
		   s Result=$p(NodeResultStr,"^",3)
		   s Unit=$p(NodeResultStr,"^",4)
		   s Flags=$p(NodeResultStr,"^",5)
		   s Ranges=$p(NodeResultStr,"^",6)
		   s TestCodeDR=$p(NodeResultStr,"^",7)
		   //,LabDirection:趋势
		   s LabDirection=""
		   s PrintFlag=""
		   d OutputRow6
	    }
	}
	Kill OutPutArray
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow6
	set Data=$lb(Name,Sync,Result,Unit,Flag,Ranges,LabDirection,PrintFlag,TestCodeDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData3
  s (Name,Sync,Result,Unit,Flag,Ranges,LabDirection,PrintFlag,TestCodeDR)="12"
  quit
}

ClassMethod GetLabOrdResultByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabOrdResultByOrdExecute ]
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

ClassMethod GetLabOrdResultByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabOrdResultByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(DHCDoc.OPDoc.EMR).GetLabOrdResult("74||1")

ClassMethod GetLabOrdResult(OEORIRowID As %String) As %String
{
	s ^tmpscl("GetLabOrdResult")=OEORIRowID
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="DHCDoc.OPDoc.EMR"
	set rs.QueryName="GetLabOrdResultByOrd"
	set sc=rs.Execute(OEORIRowID)
	s dataHeadConfig="PrintFlag:,Name:项目名称,Sync:缩写,Result:结果,Unit:单位,Flag:异常提示,Ranges:范围值,TestCodeDR:,LabDirection:查看趋势"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""LabOrdResult_Table"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	s ARCIMRowId=$p(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1),"^",2)
	s ARCIMDesc=$p(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1),"^",2)
	w ",""title"":""医嘱："_ARCIMDesc_""""
	w ",""config"":{""checkHeaders"":{""0"":true}}"
	w "}"
	d rs.Close()
	q ""
}

/// creator:宋春莉
/// date:2016-08-12
/// desc:根据医嘱ID 获取检查医嘱结果
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetLabOrdResult","189")
Query GetExamOrdResultByOrd(OEORIRowID As %String) As %Query(ROWSPEC = "SeeDescEx:%String,DiagDescEx:%String,MethodDescEx:%String,ExamDirection:%String,PrintFlag:%String") [ SqlProc ]
{
}

ClassMethod GetExamOrdResultByOrdExecute(ByRef qHandle As %Binary, OEORIRowID As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	d resetData4
	Kill OutPutArray
	s RptRowIdStr=..GetRisReportId(OEORIRowID)
	s RptRowId=$p(RptRowIdStr,"^",1)
	if (RptRowId=""){
		s SeeDescEx="测试",DiagDescEx="测试",MethodDescEx="测试",PrintFlag=""  //测试用
		d OutputRow7
		//Set qHandle=$lb(0,repid,0)
	    //quit $$$OK
	}else{
		s StudyNo=$p(RptRowIdStr,"^",1)
		s CurrentSpace=$znspace
	    zn "PACS"
		s ReportInfo=##class(PACS.RISInterface).GetReportInfo(StudyNo)
		zn CurrentSpace
	    s SeeDescEx=$P(ReportInfo,"^",17) //检查所见
		s DiagDescEx=$P(ReportInfo,"^",18) //诊断意见
		s MethodDescEx=$P(ReportInfo,"^",20) //检查方法
		s ExamDirection=""
		s PrintFlag=""
		d OutputRow7
		
	}
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow7
	set Data=$lb(SeeDescEx,DiagDescEx,MethodDescEx,ExamDirection,PrintFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData4
  s (SeeDescEx,DiagDescEx,MethodDescEx,PrintFlag)=""
  quit
}

ClassMethod GetExamOrdResultByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExamOrdResultByOrdExecute ]
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

ClassMethod GetExamOrdResultByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExamOrdResultByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetRisReportId(oeitm As %String) As %String
{
	s RptRowId="",StudyNo=""
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",oeitm,0))
    i RegRowid'="" {
    	s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    }
    Q RptRowId_"^"_StudyNo
}

ClassMethod GetExamOrdResult(OEORIRowID As %String) As %String
{
	s ^tmpscl("GetLabOrdResult")=OEORIRowID
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="DHCDoc.OPDoc.EMR"
	set rs.QueryName="GetExamOrdResultByOrd"
	set sc=rs.Execute(OEORIRowID)
	s dataHeadConfig="PrintFlag:,SeeDescEx:检查所见,DiagDescEx:诊断意见,MethodDescEx:检查方法,ExamDirection:趋势"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""LabOrdResult_Table"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	s ARCIMRowId=$p(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1),"^",2)
	s ARCIMDesc=$p(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1),"^",2)
	w ",""title"":""医嘱："_ARCIMDesc_""""
	w ",""config"":{""checkHeaders"":{""0"":true}}"
	w "}"
	d rs.Close()
	q ""
}

// d ##class(DHCDoc.OPDoc.EMR).QueryOEForEMRJson(237,63,"测试",838,0,"Y")

ClassMethod QueryOEForEMRJson(episodeID As %String, currLocId As %String, inputOrderDesc As %String = "", doctor As %String = "", stloc As %String = "", nursebill As %String = "")
{
	s ^tmpscl("QueryOEForEMRJson")=episodeID_","_currLocId_","_inputOrderDesc_","_doctor_","_stloc_","_nursebill
	d ..QueryOEForPrintData(episodeID,currLocId,inputOrderDesc,doctor,stloc,nursebill,.colDefine)
	s RecLocIndex=colDefine.index("ReLoc")
	s DoctorIndex=colDefine.index("Doctor")
	s len=colDefine.count()
	s list=""
	s tIndx="QueryOEForPrint_"_$j
	w "["
	s tableCount=0
	s orderTypeStr="R^L^S^O"
	f qq=1:1:$l(orderTypeStr,"^") d
	.s orderType=$p(orderTypeStr,"^",qq)
	.q:'$d(^CacheTemp(tIndx,orderType))
	.//s orderType="" f   s orderType=$o(^CacheTemp(tIndx,orderType)) q:orderType=""  d
	.i orderType="R" d
	..s prescNo="" f  s prescNo=$o(^CacheTemp(tIndx,orderType,prescNo)) q:prescNo=""  d
	...k MenuOEMap
	...s col="PrintFlag:选择,ArcimDesc:医嘱名称,OrdBilled:,OrdStatus:,DoseQty:单次剂量,DoseUnit:单位,PHFreq:频次,Instr:用法,Dura:疗程,PrescNo:,ArcPrice:单价/元,OrderPackQty:数量,PackUOMDesc:单位,ReLoc:,Doctor:,OrderSum:,OrdDepProcNotes:,AdmReason:"
	...w:tableCount>0 ","
	...s tableCount=tableCount+1
	...w "{"
	...w ##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine)
	...w ",""id"":"""_prescNo_"_Table"","
	...w """rows"":["
	...s recLoc="",doc=""
	...s rowCount=0
	...s OEItemID="" f  s OEItemID=$o(^CacheTemp(tIndx,orderType,prescNo,OEItemID)) q:OEItemID=""  d
	....w:rowCount>0 ","
	....s rowCount=rowCount+1
	....s list=^CacheTemp(tIndx,orderType,prescNo,OEItemID)
	....s recLoc=$lg(list,RecLocIndex)
	....s doc=$lg(list,DoctorIndex)
	....d BuildJsonForList(colDefine,list)
	...w "]"
	...w ",""title"":""处方-处方号："_prescNo_"-"_recLoc_"-"_doc_""""
	...w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true}"
	...//w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true},"
	...//d BuildMenuOEConfig
	...//w "}"
	...w "}"
	...w ",""titleClass"":""normal-head"""
	...w "}"
	.else  if orderType="L" d
	..s col="PrintFlag:选择,OrdCreateDate:医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,ReportDate:报告日期,ReportTime:报告时间,PAADMDate:就诊日期"
	..s title="检验"
	..d BuildNotR
	.else  if orderType="S" d
	..s col="PrintFlag:选择,OrdCreateDate:医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,ReportDate:报告日期,ReportTime:报告时间,PAADMDate:就诊日期"
	..s title="检查"
	..d BuildNotR
	.else  d
	..//s col="PrintFlag:选择,ArcimDesc:医嘱名称,OrdBilled:,OrdStatus:,ReLoc:,Doctor:,OrderSum:,OrdDepProcNotes:备注,AdmReason:费别"
	..s col="PrintFlag:选择,ArcimDesc:医嘱名称,OrdBilled:,OrdStatus:,DoseQty:单次剂量,DoseUnit:单位,PHFreq:频次,Instr:用法,Dura:疗程,PrescNo:,ArcPrice:单价/元,OrderPackQty:数量,PackUOMDesc:单位,ReLoc:,Doctor:,OrderSum:,OrdDepProcNotes:,AdmReason:"
	..s title="其他"
	..d BuildNotR
	w "]"
	q ""
BuildJsonForList(colDef,list)
    w "{"
	f i=1:1:len {
		s pro=colDef.get(i)
		s t=$g(colDef.map(pro,"Type"),10)
		s v=$lg(list,i)
		w """"_pro_""":"
		if ( (t=3) ||(t=5)||(t=14)||(t=15)||(t=18) ){
			s:v="" v=0
			Write (v)
		}elseif (t=16){
			i ((v=1)||(v="1")||(v="true")) {
				s v="true" 
			}else {
				s v="false"
			}
			Write (v) 
		}else{
			Write ("""")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,"'","\'")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,"""","\""")
 			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,$c(13),"\n")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,$c(10),"\r")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,$c(2),"<$C2>")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,$c(5),"<$C5>")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,$c(7),"<$C7>")
			Write (v)
			Write ("""")
		}
		w:i<len ","
	}
	w "}"
	q	
BuildMenuOEConfig
    s printHisCount=$lg(list,printHisCountIndex)
	w """menuOEConfig"":{"
	s mi=0
    s menu="" f  s menu=$o(MenuOEMap(menu)) q:menu=""  d
    .w:mi>0 ","
    .s mi=mi+1
    .w """"_menu_""":["
    .s oeStr=MenuOEMap(menu)
    .s oei=0
    .f j=1:1:$l(oeStr,",") d
    ..w:oei>0 ","
    ..s oei=oei+1
    ..w "{"""_$p(oeStr,",",j)_""":"_printHisCount_"}"
    .w "]"
    w "}"
    q
BuildNotR
	w:tableCount>0 ","
    s tableCount=tableCount+1
	w "{"
	w ##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine)
	w ",""id"":"""_orderType_"_Table"","
	w """rows"":["
	s rowCount=0
	s OEItemID="" f  s OEItemID=$o(^CacheTemp(tIndx,orderType,OEItemID)) q:OEItemID=""  d
	.w:rowCount>0 ","
	.s rowCount=rowCount+1
	.s list=^CacheTemp(tIndx,orderType,OEItemID)
	.d BuildJsonForList(colDefine,list)
	w "]"
	w ",""title"":"""_title_""""
	w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true}}"
	//w "}"
	w ",""titleClass"":""normal-head"""
	w "}"
    q
	k ^CacheTemp(tIndx)
}

/// appending fileds:IsDMPresc:是否毒麻,PrintFlag:是否打印,PatName:病人姓名,PatIDNo:病人身份证号,PatMasID:PA_PatMas的ID
/// ReportDate:检查日期,ReportTime检查时间,PAADMDate:就诊日期
///  base on the query of web.DHCDocQryOEOrder:GetOrdByAdm
ClassMethod QueryOEForPrintData(episodeID As %String, currLocId As %String, inputOrderDesc As %String = "", doctor As %String = "", stloc As %String = "", nursebill As %String = "", ByRef colDefine As DHCDoc.Common.MapIndex)
{
	s colDefine=##class(DHCDoc.Common.MapIndex).%New()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocQryOEOrder"
	set rs.QueryName="GetOrdByAdm"
	set sc=rs.Execute(episodeID)
	s len=rs.GetColumnCount()
	f i=1:1:len {
		d colDefine.add(rs.GetColumnName(i))
		s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
	}
	d colDefine.add("PrintFlag")
	s colDefine.map("PrintFlag","Type")=16 //bool
	d colDefine.add("ReportDate")
	s colDefine.map("ReportDate","Type")=10
	d colDefine.add("ReportTime")
	s colDefine.map("ReportTime","Type")=10
	d colDefine.add("PAADMDate")
    s colDefine.map("PAADMDate","Type")=10 
    s PAADMDate=$zd($p(^PAADM(episodeID),"^",6),3)
	s tIndx="QueryOEForPrint_"_$j
	k ^CacheTemp(tIndx)
	s OESubType=""
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s printFlag=0
		s OEItemID=rs.Data("OEItemID")
		s OEID=$p(OEItemID,"||",1)
		s OEORID=$p(OEItemID,"||",2)
		s ItmMastDR = $p(^OEORD(OEID,"I",OEORID,1),"^",2)
		continue:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc) //医嘱描述
		s DoctorDr=""
		i $d(^OEORD(OEID,"I",OEORID,1))=1 d
	    .s DoctorDr=$p(^OEORD(OEID,"I",OEORID,1),"^",11)
	    continue:(+doctor'=0)&&(doctor'=DoctorDr) //下医嘱医生
	    s ordDept = $p($g(^OEORD(OEID,"I",OEORID,7)),"^",2)	;OEORI_UserDepartment_DR
		continue:(stloc=1)&&(currLocId'[(","_ordDept_","))	;本病区或科室
		continue:(stloc=2)&&(currLocId[(","_ordDept_","))
		s CTCPTInternalType=""
		i +DoctorDr>0 d		
		.s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		.s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	    continue:(nursebill="Y")&&(CTCPTInternalType'="NURSE")
		continue:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(OEID,OEORID))
		
		s AdmID=$p(^OEORD(OEID),"^",1)
		s PAPMIID=$p(^PAADM(AdmID),"^",1)
		s PatName=$p(^PAPER(PAPMIID,"ALL"),"^",1)
		S PatIDNo=$p(^PAPER(PAPMIID,"PAT",3),"^",6)
		s PrescNo=rs.Data("PrescNo")
		s OrderType=rs.Data("OrderType")
		if (OrderType'="R")&&(OrderType'="L"){
			s IsExamItemFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)
			if (IsExamItemFlag="1") s OrderType="S"
		}
		s RptRowIdStr=$$GetRisReportId(OEItemID)
		zn "PACS"
		s ReportInfo=##class(PACS.RISInterface).GetReportInfo($p(RptRowIdStr,"^",2))
		zn "DHC-APP"
		s list=$lb()
		s index=0
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		s $list(list,index+2)=$p(ReportInfo,"^",21)
		s $list(list,index+3)=$p(ReportInfo,"^",20)
		s $list(list,index+4)=PAADMDate
		if OrderType="R"{
			s ^CacheTemp(tIndx,OrderType,PrescNo,OEItemID)=list
		}elseif OrderType="L" {
			s ^CacheTemp(tIndx,OrderType,OEItemID)=list
		}elseif OrderType="S" {
			s ^CacheTemp(tIndx,OrderType,OEItemID)=list
		}else{
			s ^CacheTemp(tIndx,"O",OEItemID)=list
		}
	}
	d rs.Close()
GetRisReportId(oeitm)
	s RptRowId="",StudyNo=""
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",oeitm,0))
    i RegRowid'="" {
    	s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    }
    Q RptRowId_"^"_StudyNo
}

/// creator:宋春莉
/// date:2016-10-09
/// desc:根据医嘱ID 获取检查医嘱的检查趋势
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.EMR","GetExamOrdDirectionByOrd","1||1")
Query GetExamOrdDirectionByOrd(OEORIRowID As %String) As %Query(ROWSPEC = "ExamOrdApplyDate:%String,ExamOrdApplyLoc:%String,ExamOrdApplyDoc:%String,SeeDescEx:%String,DiagDescEx:%String,MethodDescEx:%String") [ SqlProc ]
{
}

ClassMethod GetExamOrdDirectionByOrdExecute(ByRef qHandle As %Binary, OEORIRowID As %String = "") As %Status
{
    //申请日期","申请科室","申请医生","检查所见","诊断意见","检查方法
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	d resetData5
	Kill OutPutArray
	s RptRowIdStr=..GetRisReportId(OEORIRowID)
	s RptRowId=$p(RptRowIdStr,"^",1)
	if (RptRowId=""){
		s ExamOrdApplyDate="测试日期",ExamOrdApplyLoc="测试科室"
		s ExamOrdApplyDoc="测试医生",SeeDescEx="测试检查所见"
		s DiagDescEx="测试诊断意见",MethodDescEx="测试检查方法"  //测试用
		d OutputRow8
		//Set qHandle=$lb(0,repid,0)
	    //quit $$$OK
	}else{
		s StudyNo=$p(RptRowIdStr,"^",1)
		s CurrentSpace=$znspace
	    zn "PACS"
		s ReportInfo=##class(PACS.RISInterface).GetReportInfo(StudyNo)
		zn CurrentSpace
	    s SeeDescEx=$P(ReportInfo,"^",17) //检查所见
		s DiagDescEx=$P(ReportInfo,"^",18) //诊断意见
		s MethodDescEx=$P(ReportInfo,"^",20) //检查方法
		s ExamDirection=""
		s PrintFlag=""
		d OutputRow8
		
	}
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow8
	set Data=$lb(ExamOrdApplyDate,ExamOrdApplyLoc,ExamOrdApplyDoc,SeeDescEx,DiagDescEx,MethodDescEx)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
resetData5
  s (ExamOrdApplyDate,ExamOrdApplyLoc,ExamOrdApplyDoc,SeeDescEx,DiagDescEx,MethodDescEx)=""
  quit
}

ClassMethod GetExamOrdDirectionByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExamOrdDirectionByOrdExecute ]
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

ClassMethod GetExamOrdDirectionByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExamOrdDirectionByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetExamOrdDirectionJson(OEORIRowID As %String) As %String
{
	s ^tmpscl("GetExamOrdDirectionJson")=OEORIRowID
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="DHCDoc.OPDoc.EMR"
	set rs.QueryName="GetExamOrdDirectionByOrd"
	set sc=rs.Execute(OEORIRowID)
	s dataHeadConfig="ExamOrdApplyDate:申请日期,ExamOrdApplyLoc:申请科室,ExamOrdApplyDoc:申请医生,SeeDescEx:检查所见,DiagDescEx:诊断意见,MethodDescEx:检查方法"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""ExamOrdList_Table"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	//w ",""title"":""检查"""
	w ",""config"":{""checkHeaders"":{""0"":true}}"
	w "}"
	d rs.Close()
	q ""
}

}
