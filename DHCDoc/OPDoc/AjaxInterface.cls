Class DHCDoc.OPDoc.AjaxInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Extends %CSP.Page
/// 请求示例链接
/// http://127.0.0.1/dthealth/web/DHCDoc.OPDoc.AjaxInterface?OutputType=Stream&Class=DHCDoc.OPDoc.AjaxInterface&Method=GetOPDocProBarJsonData&p1=1&p2=2&p3=3&p4=&p5=&p6=
ClassMethod OnPage() As %Status
{
	/*
	s class = $Get(%request.Data("Class",1),"")
	s method = $Get(%request.Data("Method",1),"")
	s outputType = $Get(%request.Data("OutputType",1),"")
	s param = ""
	s name = "P0"
	for
	{
		s name = $Order(%request.Data(name))
		q:(name = "")
		s:(param '= "") param = param_","
		s param = param_""""_$Get(%request.Data(name,1),"")_""""
	}
	s execCode = "result=##class("_class_")."_method_"("_param_")"
	s @execCode
	s result = @"result" 
	if (outputType = "Stream")
	{
		while (result.AtEnd = 0)
		{
			w $ZSTRIP(result.Read(32000),"*C")
		}
	}
	else
	{
		w $ZSTRIP(result,"*C")
	}
	Quit $$$OK
	*/
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetOPDocProBarJsonData")
	{
  		w ..GetOPDocProBarJsonData()
	}
	Quit $$$OK
}

/// creator:宋春莉
/// date:2016-07-09
/// desc:返回门诊接诊流程图json数据 
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetOPDocProBarJsonData()     
ClassMethod GetOPDocProBarJsonData() As %String
{
	//TODO
	//测试数据
	//s json="[{""id"":""WhiteEMR"",""Name"":""写病历"",""click"":""WhiteEMROnClick"",""link"":""""},{""id"":""InsertDiag"",""Name"":""下诊断"",""click"":""InsertDiagOnClick"",""link"":""diagnosentry.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""InsertOrder"",""Name"":""开医嘱"",""click"":""InsertOrderOnClick"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""PrintAll"",""Name"":""打印&申请单"",""click"":""PrintAllOnClick"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""CompleteAdm"",""Name"":""完成接诊"",""click"":""CompleteRecAdm"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""}]"
	//q json
	s DisplayNum=0,ret=""
	f  s DisplayNum=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum)) q:DisplayNum=""  d
	.s ID=0
	.f  s ID=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum,ID)) q:ID=""  d
	..s Active=$list(^User.DocCFStreamlineInfoD(ID),7)
	..Q:Active'=1
	..s id=$list(^User.DocCFStreamlineInfoD(ID),8)
	..s Name=$list(^User.DocCFStreamlineInfoD(ID),9)
	..s click=$list(^User.DocCFStreamlineInfoD(ID),10)
	..s link=$list(^User.DocCFStreamlineInfoD(ID),3)
	..s isRefresh=$list(^User.DocCFStreamlineInfoD(ID),11)
	..s oneret=""""_"id"_""":"""_##class(web.DHCDocUtil).EvalJSON(id)_""""
	..s oneret=oneret_","_""""_"Name"_""":"""_##class(web.DHCDocUtil).EvalJSON(Name)_""""
	..s oneret=oneret_","_""""_"click"_""":"""_##class(web.DHCDocUtil).EvalJSON(click)_""""
	..s oneret=oneret_","_""""_"link"_""":"""_##class(web.DHCDocUtil).EvalJSON(link)_""""
	..s oneret=oneret_","_""""_"isRefresh"_""":"""_##class(web.DHCDocUtil).EvalJSON(isRefresh)_""""
	..s oneret="{"_oneret_"}"
	..i ret="" d
	...s ret="["_oneret
	..else  d
	...s ret=ret_","_oneret
	q ret_"]"
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:返回门急诊患者信息
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetOPInfoBar()     
ClassMethod GetOPInfoBar(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatInfoBarStr=""
	s PatientID=$p(^PAADM(EpisodeID),"^",1),mradm=$p(^PAADM(EpisodeID),"^",61)
	s DisplayNum=0
	f  s DisplayNum=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum)) q:DisplayNum=""  d
	.s ID=0
	.f  s ID=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum,ID)) q:ID=""  d
	..s Active=$list(^User.DocCFPatientInfoD(ID),10)
	..q:Active'="1"
	..s id=$list(^User.DocCFPatientInfoD(ID),3)
	..s Name=$list(^User.DocCFPatientInfoD(ID),2)
	..s class=$list(^User.DocCFPatientInfoD(ID),6)
	..s Expression=$list(^User.DocCFPatientInfoD(ID),5)
	..s Expression=$tr(Expression,"&","""")
	..s Expression="s result="_Expression
	..X Expression
	..s LinkUrl=$list($g(^User.DocCFPatientInfoD(ID)),7)
	..s LinkUrl=..replaceLinkParams(LinkUrl,EpisodeID,PatientID,mradm)
	..i LinkUrl'="" d 
	...s iconHTML="<A HREF=""#"" id='"_id_"' onClick=""websys_lu('"_LinkUrl_"',false,'top=40,left=40,width=640,height=480');"">"_result_"</A>"
	..e  d
	...s iconHTML="<span>"_result_"</span>"
	..i PatInfoBarStr="" s PatInfoBarStr=iconHTML
	..e  s PatInfoBarStr=PatInfoBarStr_"<span>|<span>"_iconHTML
	q PatInfoBarStr
}

ClassMethod replaceLinkParams(lnk As %String, EpisodeID As %String, PatientID As %String, mradm As %String)
{
	s ret = $replace(lnk,"@patientID",PatientID)
	s ret = $replace(ret,"@episodeID",EpisodeID) 
	s ret = $replace(ret,"@mradm",mradm) 
	Q ret
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者出生日期 
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetPatDob()     
ClassMethod GetPatDob(PatientID As %String)
{
	s PatDob=$p(^PAPER(PatientID,"ALL"),"^",6)
	Q:PatDob="" ""
	Q ##class(websys.Conversions).DateLogicalToHtml(PatDob) //$zd(PatDob,3)
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取就诊费别
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason()     
ClassMethod GetAdmReason(EpisodeID As %String)
{
	Q:EpisodeID="" ""
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	Q:PAADMAdmReasonDR="" ""
	s AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	Q AdmReason
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者性别
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetPatSex()     
ClassMethod GetPatSex(PatientID As %String) As %String
{
	s PatSex=""
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	Q PatSex
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者卡号
/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetPatCardNo()  
ClassMethod GetPatCardNo(PatientID As %String) As %String
{
	s CFRowID=0,CardNo=""
	f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID)) q:(CFRowID="")||(CardNo'="")  d
	.s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	.Q:CFActiveFlag'="N"
	.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
	Q CardNo
}

ClassMethod test() As %String
{
	//s aCmdValue="ChildSub=$O(^DHCDocEntryTree("""_RootNodeId_""",""""),-1)"
	//s @aCmdValue
	X "s PatName=$p(^PAPER(189,"_"""ALL""),"_"""^"",7)"
	q PatName
}

/// creator:宋春莉
/// date:2016-08-02
/// desc:根据本次就诊获取最近四次就诊信息
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.AjaxInterface","GetPatAdmList","189")
Query GetPatAdmList(EpisodeID As %String = "", Limit As %String = "5") As %Query(ROWSPEC = "MainDiagnos:%String,AdmDate:%String,AdmLoc:%String,AdmDoc:%String,AdmRowId:%String")
{
}

ClassMethod GetPatAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod GetPatAdmListExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", Limit As %String = "5") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.AjaxInterface","GetPatAdmList","189")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if EpisodeID="" {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s Num=0
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PAADMTypeStr="O^E^I"
	for i=1:1:$l(PAADMTypeStr,"^") d
	.Q:(Num>=Limit)&&(Limit'="")
	.s PAADMType=$p(PAADMTypeStr,"^",i)
	.;s AdmRowId=EpisodeID
	.s AdmRowId=""
	.f  s AdmRowId=$o(^PAPERdr(PatientID,"ADM",PAADMType,AdmRowId),-1) q:(AdmRowId="")||((Num>=Limit)&&(Limit'=""))  d
	..s PAADMMainMRADMDR=$p($g(^PAADM(AdmRowId)),"^",61)
	..s MRDIAChildsub=0,MainDiagnos=""
	..f  s MRDIAChildsub=$o(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)) q:(MRDIAChildsub="")||((Num>=Limit)&&(Limit'=""))  d  //||(MainDiagnos'="")
	...s MainDiagFlag=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub,1)),"^",20)
	...i MainDiagFlag="Y" d
	....s MRDIAICDCodeDR=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)),"^",1)
	....i MRDIAICDCodeDR'="" s tmpMainDiagnos=$p(^MRC("ID",MRDIAICDCodeDR),"^",2)
	....e  s tmpMainDiagnos=$g(^MR(PAADMMainMRADMDR,"DIA",MRDIAICDCodeDR,"DES",1))
	....i MainDiagnos="" s MainDiagnos=tmpMainDiagnos
	....e  s MainDiagnos=MainDiagnos_";"_tmpMainDiagnos
	..s AdmDate=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmRowId)),"^",6)) //$zd($p($g(^PAADM(AdmRowId)),"^",6),3)
	..s AdmLocDr=$p($g(^PAADM(AdmRowId)),"^",4)
	..s AdmLoc=$p(^CTLOC(AdmLocDr),"^",2)
	..s AdmLocDesc=$p(AdmLoc,"-",2)
	..i AdmLocDesc'="" s AdmLoc=AdmLocDesc
	..s AdmDoc=""
	..s PAAdmDocCodeDR=$P($g(^PAADM(AdmRowId)),"^",9)
	..i PAAdmDocCodeDR'="" s AdmDoc=$P($g(^CTPCP(PAAdmDocCodeDR,1)),"^",2)
	..s Num=Num+1
	..Q:(Num>=Limit)&&(Limit'="")
	..Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
     set Data=$lb(MainDiagnos,AdmDate,AdmLoc,AdmDoc,AdmRowId)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod GetPatAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAdmListExecute ]
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

/// creator:宋春莉
/// date:2016-08-02
/// desc:有效卡列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.AjaxInterface","ReadCardTypeList")
Query ReadCardTypeList() As %Query(ROWSPEC = "CardTypeDesc:%String,CardTypeValue:%String,DefaultFlag:%String")
{
}

ClassMethod ReadCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod ReadCardTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.AjaxInterface","ReadCardTypeList")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s myTypeID=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
     s ^tmpscl("data12",ind)=myval
     set Data=$lb(mydes,myval,mySelFlag)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod ReadCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
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

/// w ##class(DHCDoc.OPDoc.AjaxInterface).GetOPInfoJosn()     
ClassMethod GetOPInfoJosn(EpisodeID As %String) As %String
{
	w "[{"
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s AdmHistoryCount=0
	s AdmTypeStr="O^I^E^H"
	for i=1:1:$l(AdmTypeStr,"^") {
		s AdmType=$p(AdmTypeStr,"^",i)
		s PAADMRowID=0
		for {
			s PAADMRowID=$o(^PAPERdr(PatientID,"ADM",AdmType,PAADMRowID))
			q:(PAADMRowID="")||(AdmHistoryCount>0)
			continue:(PAADMRowID=EpisodeID)
			s AdmHistoryCount=AdmHistoryCount+1
		}
	}
	w """"_"AdmHistoryCount"_""":"""_AdmHistoryCount_""""
	s val=##class(websys.DHCChartStyle).GetAllergyStyle(PatientID,EpisodeID,mradm)
	if (val'=1){
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(val,.AllergyStyleArr)
		w ","_""""_"AllergyCount"_""":"""_AllergyStyleArr("count")_""""
	}else{
		w ","_""""_"AllergyCount"_""":"""_0_""""
	}
	q "}]"
}

}
