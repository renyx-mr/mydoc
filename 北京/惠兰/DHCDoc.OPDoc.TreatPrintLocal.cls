Class DHCDoc.OPDoc.TreatPrintLocal Extends %RegisteredObject
{

/// w ##class(DHCDoc.OPDoc.TreatPrintLocal).GetXMLPrintCount("ZLDO")
ClassMethod GetXMLPrintCount(PrintType As %String, HospID) As %String
{
	s PrintCount=""
	Q:PrintType="" PrintCount
	s id=0
	for {
		s id=$o(^User.DocCFTreatPrintMainInfoD(id)) Q:(id="")||(PrintCount'="")
		s Data=$g(^User.DocCFTreatPrintMainInfoD(id))
		s Code=$lg(Data,28)
		continue:(Code'=PrintType)
		s HospDr=$lg(Data,30)
		continue:(HospDr'=HospID)
		s PrintCount=$lg(Data,31)
	}
	Q PrintCount
}

ClassMethod CheckInsertDiagnosByOrdStr(OrdList As %String)
{
	s RetStr=""
	q:OrdList="" RetStr
	s selPrescNoStr=##class(DHCDoc.OPDoc.TreatPrint).GetSelPerscNoStr(OrdList)
	if (selPrescNoStr=""){
		w PrintDataAll.%ToJSON()
		q RetStr
	}
	s DiagLinkToPrseCount=0
	//s PrescNumList=$LISTFROMSTRING(selPrescNoStr,"^")
	//&sql(SELECT count(*) INTO :DiagLinkToPrseCount FROM SQLUser.DHCDocDiagLinkToPrse WHERE PrescNum %INLIST :PrescNumList AND DiagList IS NOT NULL)
	for i=1:1:$l(selPrescNoStr,"^"){
		s OnePrescNoStr=$p(selPrescNoStr,"^",i)
		s DiagLinkToPrseCount=0
		&sql(SELECT count(*) INTO :DiagLinkToPrseCount FROM SQLUser.DHCDocDiagLinkToPrse WHERE PrescNum = :OnePrescNoStr AND DiagList IS NOT NULL)
		if (DiagLinkToPrseCount=0) s RetStr=1 
	}
	q RetStr
}

/// 打印检验告知单
/// w ##class(DHCDoc.OPDoc.TreatPrintLocal).GetExaReqPrintDataNew(626)
ClassMethod GetExaReqPrintDataNew(ExaReqID As %String) As %String
{
	//s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s selectedOEItemID=""
	s SubRowid=""
	for {
		//s SubRowid=$O(^DHCAPREP(ExaReqID,"AR",SubRowid))
		s SubRowid=$o(^DHCAPREP(ExaReqID,"AR",SubRowid))
		q:SubRowid=""
		if (selectedOEItemID=""){ s selectedOEItemID=$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
		else{s selectedOEItemID=selectedOEItemID_"^"_$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
	}
	d ##class(DHCDoc.OPDoc.TreatPrint).GetJCDMZPrintData(EpisodeID,selectedOEItemID,"","JCDMZ","Print")
	s rtn=""
	q rtn
}

ClassMethod GetJCDMZPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "") As %String
{
	/*s ^tempscl("GetJCDMZPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType_","_type
	s PrintDataAll=[]  //返回打印对象
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}*/
	s PrintDataAll=[]  //返回打印对象
	k TMPJCDMZData
	s OrdLen = $l(selectedOEItemID,"^")
	for i=1:1:OrdLen {
		s OrdItm = $p(selectedOEItemID,"^",i)
		s Params = ""
		s $p(Params,"^",3)=OrdItm
		s TraType=##Class(web.DHCAPPInterface).GetTraCatType(Params) /// P/E/L
		continue:TraType'="E"
		s ReqID=$o(^DHCAPREP(0,"OrdItem",OrdItm,""))
		continue:+ReqID=0
		/*s listRowId=episodeID_"JCDMZ"_ReqID
		continue:((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"")))*/
		//s TMPJCDMZData("E",ReqID)=""
		//每页数据对象
		s onepage={}
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		k ServiceOrdCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(..GetExaReqPrintData(ReqID,"",OrdItm),.ServiceOrdCongeriesArr)
		s listRowId=episodeID_"JCDMZ"_ReqID
		s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
		d onepage.%Set("checkTitle","")
		d onepage.%Set("listRowId",listRowId)
		d onepage.%Set("PrintTemp",PrintTemp)
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		s id=0
		for {
			s id=$o(ServiceOrdCongeriesArr(id)) q:id="" 
			d dataobj.%Set(id,$g(ServiceOrdCongeriesArr(id)))
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
		if type="Print" d ##Class(web.DHCAPPExaReport).UpdNurPrtInfo(ReqID,%session.Get("LOGON.USERID"))
	}
	w PrintDataAll.%ToJSON()
	Q ""
	//每页数据对象
	s onepage={}
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	s ReqID=""
	for {
		s ReqID = $o(TMPJCDMZData("E",ReqID)) q:ReqID=""
		k ServiceOrdCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##Class(web.DHCAPPPrintCom).GetExaReqPrintData(ReqID,""),.ServiceOrdCongeriesArr)
		s listRowId=episodeID_"JCDMZ"_ReqID
		s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
		d onepage.%Set("checkTitle","")
		d onepage.%Set("listRowId",listRowId)
		d onepage.%Set("PrintTemp",PrintTemp)
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		s id=0
		for {
			s id=$o(ServiceOrdCongeriesArr(id)) q:id="" 
			d dataobj.%Set(id,$g(ServiceOrdCongeriesArr(id)))
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
		if type="Print" d ##Class(web.DHCAPPExaReport).UpdNurPrtInfo(ReqID,%session.Get("LOGON.USERID"))
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

/// Creator：   bianshuai
/// CreatDate： 2016-08-15
/// Descript:   获取检查申请单打印数据
/// Table：     DHC_AppReport  
/// Input：	    ExaReqID：申请单ID、ExaReqNo：申请单号   
/// Return：    申请单json串
/// w ##Class(DHCDoc.OPDoc.TreatPrintLocal).GetExaReqPrintData("623","340||1")
ClassMethod GetExaReqPrintData(ExaReqID As %String, ExaReqNo As %String, OrdItemDr As %String) As %String
{
	i ExaReqID="" s ExaReqID=$o(^DHCAPREP(0,"ARNo",ExaReqNo,""))
	Q:ExaReqID="" "{}"
	
	k TmpPatDiagArr, TmpArcItemArr, TmpOthOptArr, TmpPatBaseArr
	s arSendFlag=$p(^DHCAPREP(ExaReqID),"^",17) 
	Q:arSendFlag="I" "{}"
	s arReqNo=$p(^DHCAPREP(ExaReqID),"^",1)           /// 单号
	s arReqData=$p(^DHCAPREP(ExaReqID),"^",2)         /// 报告日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //hxy $zd(arReqData,3)
	s arReqTime=$p(^DHCAPREP(ExaReqID),"^",3)         /// 报告时间
	s:arReqTime'="" arReqTime=$zt(arReqTime,1)
	s arReqTime=arReqData_" "_arReqTime
	s arUserCode=""
	s arUserID=$p(^DHCAPREP(ExaReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",2)
	//s arUserCode=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUserCode)
	s arRepExLoc=""
	s arExLocID=$p(^DHCAPREP(ExaReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)          /// 执行科室
	s arRepExLocFlor=$p(^CTLOC(arExLocID),"^",16)     /// 接收科室地址
	s arRepExLocAdrr=$g(^CTLOC(arExLocID,"ADDR",1))   /// 接收科室楼层
	s arRepExLocAdrr=arRepExLocAdrr_arRepExLocFlor
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s arPurpose=$g(^DHCAPREP(ExaReqID,"Purpose"))        /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(ExaReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"【加急】",1:"")
	s PrintFlag=""
	s NurPrtUser=$p(^DHCAPREP(ExaReqID),"^",22)        /// 打印人
	s NurPrtDate=$p(^DHCAPREP(ExaReqID),"^",23)        /// 打印日期
	s NurPrtTime=$p(^DHCAPREP(ExaReqID),"^",24)        /// 打印时间
	i (NurPrtUser'="")&&(NurPrtDate'="")&&(NurPrtTime'="") s PrintFlag="" //"[补]"
	s PreInFlag=##Class(web.DHCAPPPrintCom).GetPatPreInFlag(EpisodeID)           /// 获取病人预住院和日间标志
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",ExaReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"REQ",ExaReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s arExaReqSym=""
	s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",ExaReqID,""))
	i arExaReqSymID'="" s arExaReqSym=$G(^DHCAPPATSY(arExaReqSymID,"Symptom")) /// 主诉
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)            /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            /// 登记号
	s InsuCardNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)  /// 医保卡号
	s CardNo=##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID) /// 卡号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)          /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	//renyx 添加出生日期   2021.4.23
	s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s:PatDOB'="" PatDOB=$zd(PatDOB,3)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			   /// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s HospID=+$p($g(^CTLOC(+PatLocID)),"^",22)         /// 医院ID
	s HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	s InsuID=$o(^DHCINADM("0","ADM",EpisodeID,""))
	s InsuNo=$p($g(^DHCINADM(+InsuID)),"^",1)          /// 医疗保险号 
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s ExaRepDiags=""
	s mPatDiags=$p(^DHCAPREP(ExaReqID),"^",25)		/// 病人诊断
	s count=0
	For k=1:1:$L(mPatDiags,"@")  {
		s MrData=$p(mPatDiags,"@",k)    /// 诊断
		s MrID=$p(MrData,$C(2),1)       /// 诊断ID
		s MrID=$p(MrID,$C(4),1)  //2019-07-29 原诊断ID和描述分割符由$C(2)改为$C(4),
		continue:MrID=""
		if (ExaRepDiags="") s ExaRepDiags=MrID
		else  s ExaRepDiags=ExaRepDiags_"^"_MrID
	}	
	s PatDiag=##Class(web.DHCAPPPrintCom).GetMRDiagnosDesc(EpisodeID,",","",ExaRepDiags)       /// ##class(web.DHCSTKUTIL) 诊断
	D ##Class(web.DHCAPPExaRepCom).splitString(PatDiag, "86", "10", .TmpPatDiagArr)  /// 拆分字符串
	D ##Class(web.DHCAPPPrintCom).TrsTmpArrNew("PatDiagArr", .TmpPatDiagArr)
	s arItemDesc="", NoteList=""
	//s CH=""
	s CH=$o(^DHCAPREP(0,"OrdItem",OrdItemDr,ExaReqID,0))
	//F  s CH=$o(^DHCAPREP(ExaReqID,"AR",CH)) Q:CH=""  D
	if CH'="" d
	.s arcimid=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",1)        ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1), itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s PosiDesc="",PosiCode=""
	.s PosiID=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",2)     	///体位ID
	.s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	    ///体位
	.s Oeori=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",3)     	    ///医嘱ID
	.//Q:Oeori=""
	.s NoteList=##class(web.DHCRisResourceApptSchudle).GetMemo(Oeori)    /// 注意事项取接口数据  sufan  2017-03-27
	.s NoteList=$replace(NoteList,$c(10),"")
	.if NoteList="" d
	..s NoteList=##class(web.DHCAPPArcNote).GetAppArcNote(arcimid,HospID)
	.s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.//Q:(ItemStat="D")||(ItemStat="C")||(ItemStat="U")||(ItemStat="I")       /// 临嘱 住院为撤销、门诊为停止
	.s ItemLabel=##Class(web.DHCAPPInterface).GetExaReqItemDesc(Oeori) /// 项目描述
	.s OrdItemNote=$g(^OEORD($p(Oeori,"||",1),"I",$p(Oeori,"||",2),"DEP",1))
	.s:OrdItemNote'="" ItemLabel=ItemLabel_" 医嘱备注："_OrdItemNote
	.if arEmgFlag="" d
	..s emgFlag=$p(^OEORD($p(Oeori,"||",1),"I",$p(Oeori,"||",2),"11"),"^",55)	// 加急标志
	..s emgFlag=$case(emgFlag,"Y":"【加急】","N":"",:"")
	..i emgFlag'="" s ItemLabel=emgFlag_ItemLabel
	.i arItemDesc="" s arItemDesc=ItemLabel
	.E  s arItemDesc=arItemDesc_"；"_ItemLabel

	D ##Class(web.DHCAPPExaRepCom).splitString(arItemDesc, "86", "10", .TmpArcItemArr)  /// 拆分字符串
	D ##Class(web.DHCAPPPrintCom).TrsTmpArrNew("ArcItemArr", .TmpArcItemArr)
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ExaReqID)   /// 分类代码
	s arExaReqDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ExaReqID,1) /// 分类描述
	s arExaReqDesc=arExaReqDesc_"申请单"
	s OthOptList=""
	s CH=""
	F  s CH=$o(^DHCAPREP(ExaReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(ExaReqID,"OT",CH),"^",1)  /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(ExaReqID,"OT",CH),"^",2) /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.Q:OthOptList[(itemdesc_":"_itemval)
	.i OthOptList="" s OthOptList=itemdesc_":"_itemval
	.E  s OthOptList=OthOptList_"  "_itemdesc_":"_itemval
	.
	D ##Class(web.DHCAPPExaRepCom).splitString(OthOptList, "86", "10", .TmpOthOptArr)  /// 拆分字符串
	D ##Class(web.DHCAPPPrintCom).TrsTmpArrNew("OthOptArr", .TmpOthOptArr)
	s PatType=$p(^PAADM(EpisodeID),"^",2)            /// 就诊类型
	s Type=$s(PatType="I":"住院",PatType="E":"急诊",PatType="O":"门诊",1:"")    ///  sufan 2017-03-14
	i arExaReqSym'="" s arExaReqSym="主诉："_arExaReqSym_"；" 
	i arHisDesc'="" s arHisDesc="现病史："_arHisDesc_"；"
    i arSigDesc'="" s arSigDesc="体征："_arSigDesc_"；"
    s PatSymInfo=arExaReqSym_""_arHisDesc_""_arSigDesc
    s PatSymInfo=$replace(PatSymInfo,$c(10),"")
    D ##Class(web.DHCAPPExaRepCom).splitString(PatSymInfo, "86", "10", .TmpPatSymArr)  /// 拆分字符串
	D ##Class(web.DHCAPPPrintCom).TrsTmpArrNew("PatSymArr", .TmpPatSymArr)
	s BillType=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason(EpisodeID)
	//$p(^PAPER(PatientID,"PER",1),"^",10)  /// 费别
	//s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	
    s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s ExaReqNoCost=##Class(web.DHCAPPExaReportQuery).GetExaReqNoCost(ExaReqID,OrdItemDr)       /// 申请单总金额
	s PatCardMoney=##Class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)       /// 获取卡余额
	s PrintTemp=##Class(web.DHCAPPPrintCom).GetPrintTemp(ExaReqID)            /// 打印模板
	i PrintTemp="" s PrintTemp="DHCAPP_NT"
	//s ExaReqTitle=HospDesc_$s(PatType="I":"住院",PatType="E":"急诊",1:"门诊")_"检查申请单"_PrintFlag
	
	s HospDesc=HospDesc_$s(PatType="I":"住院",PatType="E":"急诊",1:"门诊")
	s ExaReqTitle="检查申请单"_PrintFlag
	
	s GreenFlag=##class(web.DHCEMInterfaceCom).CheckGreenRec(EpisodeID)   /// sufan 2018-10-22 
	s GreenFlag=$s(GreenFlag="1":"绿色通道",1:"")
	D ##Class(web.DHCAPPExaRepCom).splitString(NoteList, "86", "10", .TmpNoteListArr)  /// 拆分字符串
	D ##Class(web.DHCAPPPrintCom).TrsTmpArrNew("NoteListArr", .TmpNoteListArr)
	s Location=arRepExLocAdrr_"  "_arRepExLoc_"   刷卡检查"
	s mListData=HospDesc_$C(4)_"*"_PatNo_"*"_$C(4)_MedicareNo_$C(4)_PatNo_$C(4)_PatName
	s mListData=mListData_$C(4)_PatAge_$C(4)_PatLoc_$C(4)_PatSex_$C(4)_arHisDesc_$C(4)_arSigDesc
	//11-20
	s mListData=mListData_$C(4)_PatDiag_$C(4)_arRepExLocAdrr_$C(4)_CardNo_$C(4)_BillType_$C(4)_PatBed
	s mListData=mListData_$C(4)_Type_$C(4)_NoteList_$C(4)_arItemDesc_$C(4)_arRepExLoc_$C(4)_arReqTime
	//21-30
	s mListData=mListData_$C(4)_arUserCode_$C(4)_arReqNo_$C(4)_OthOptList_$C(4)_arExaReqCode_$C(4)_arExaReqDesc
	s mListData=mListData_$C(4)_""_$C(4)_PatCardMoney_$C(4)_ExaReqNoCost_$C(4)_ExaReqTitle_$C(4)_arEmgFlag
	//31-40
	s mListData=mListData_$C(4)_PrintTemp_$C(4)_InsuNo_$C(4)_InsuCardNo_$C(4)_PrintFlag_$C(4)_PreInFlag
	s mListData=mListData_$C(4)_GreenFlag_$C(4)_Location_$C(4)_PatDOB_$C(4)_TmpPatSymArr("PatSymArrVal")_$C(4)_TmpPatDiagArr("PatDiagArrVal")_$C(4)_TmpOthOptArr("OthOptArrVal")
	//41-50
	s mListData=mListData_$C(4)_TmpArcItemArr("ArcItemArrVal")_$C(4)_TmpNoteListArr("NoteListArrVal")
	////////
	s ListTitle="hopName"_$C(4)_"Barcode"_$C(4)_"MedicareNo"_$C(4)_"PatNo"_$C(4)_"PatName"
	s ListTitle=ListTitle_$C(4)_"PatAge"_$C(4)_"PatLoc"_$C(4)_"PatSex"_$C(4)_"arHisDesc"_$C(4)_"arSigDesc"
	//11-20
	s ListTitle=ListTitle_$C(4)_"PatDiag"_$C(4)_"arRepExLocAdrr"_$C(4)_"CardNo"_$C(4)_"BillType"_$C(4)_"PatBed"
	s ListTitle=ListTitle_$C(4)_"Type"_$C(4)_"NoteList"_$C(4)_"arItemDesc"_$C(4)_"arRepExLoc"_$C(4)_"arReqTime"
	//21-30
	s ListTitle=ListTitle_$C(4)_"arUserCode"_$C(4)_"arReqNo"_$C(4)_"OthOptList"_$C(4)_"arExaReqCode"_$C(4)_"arExaReqDesc"
	s ListTitle=ListTitle_$C(4)_"InsuranceNo"_$C(4)_"PatCardMoney"_$C(4)_"ExaReqNoCost"_$C(4)_"ExaReqTitle"_$C(4)_"EmgFlag"
	//31-40
	s ListTitle=ListTitle_$C(4)_"PrintTemp"_$C(4)_"InsuNo"_$C(4)_"InsuCardNo"_$C(4)_"PrintFlag"_$C(4)_"PreInFlag"
	s ListTitle=ListTitle_$C(4)_"GreenFlag"_$C(4)_"Location"_$C(4)_"PatDOB"_$C(4)_TmpPatSymArr("PatSymArrKey")_$C(4)_TmpPatDiagArr("PatDiagArrKey")_$C(4)_TmpOthOptArr("OthOptArrKey")
	//41-50
	s ListTitle=ListTitle_$C(4)_TmpArcItemArr("ArcItemArrKey")_$C(4)_TmpNoteListArr("NoteListArrKey")
	
	Q ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,mListData,$C(4))
}

}
