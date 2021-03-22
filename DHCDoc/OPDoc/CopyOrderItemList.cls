Class DHCDoc.OPDoc.CopyOrderItemList Extends %Persistent
{

// d ##class(DHCDoc.OPDoc.CopyOrderItemList).QueryOEForCopyJson(4133,126,3,"","","","")

ClassMethod QueryOEForCopyJson(episodeID As %String, GroupRowId As %String = "", PriorID As %String, CTLOCRowId As %String, DocNameID As %String, Drug As %String, notDrug As %String)
{
	s ^tmpscl("QueryOEForCopyJson")=episodeID_","_GroupRowId_","_PriorID_","_CTLOCRowId_","_DocNameID_","_Drug_","_notDrug
	d ..QueryOEForCopyData(episodeID,GroupRowId,PriorID,CTLOCRowId,DocNameID,Drug,notDrug,.colDefine)
	s RecLocIndex=colDefine.index("OrderOrdDep") //OrderRecDep
	s DoctorIndex=colDefine.index("OrderDoc")
	s len=colDefine.count()
	s list="",prelist=""
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
	...s col="PrintFlag:选择,OrderSeqNo:序号,OrderStartDate:开始日期,OrderStartTime:开始时间,OrderName:医嘱名称,OrderDoseQty:剂量,OrderDoseUOM:剂量单位,OrderFreq:频率,OrderInstr:用法,OrderDur:疗程,OrderSkinTest:皮试,OrderPrice:价格,OrderPackQty:取药数量,OrderPackUOM:取药单位,OrderSum:金额,OrderStatus:状态,OrderRecDep:接收科室,OrderDepProcNote:备注,OrderBillType:费别,OrderUserDep:下医嘱科室,OrderDoc:开医嘱人,TOrderEndDate:停止日期,TOrderEndTime:停止时间"  //OrderLabEpisodeNo:标本号,
	...s col=col_","_"OrderARCIMRowid:,OrderType:,OrderPriorRowid:,OrderDoseUOMRowid:,OrderFreqRowid:,OrderFreqFactor:,OrderFreqInterval:,OrderInstrRowid:,OrderDurRowid:,OrderDurFactor:,OrderPackUOMRowid:,OrderBillTypeRowId:,OrderItemRowid:OrderItemRowid"
	...w:tableCount>0 ","
	...s tableCount=tableCount+1
	...w "{"
	...w ##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine)
	...w ",""id"":"""_prescNo_"_Table"","
	...w """rows"":["
	...s recLoc="",doc=""
	...s rowCount=0,MainSeqNo=1,prelist=""
	...s OEItemID="" f  s OEItemID=$o(^CacheTemp(tIndx,orderType,prescNo,OEItemID)) q:OEItemID=""  d
	....w:rowCount>0 ","
	....s rowCount=rowCount+1
	....s list=^CacheTemp(tIndx,orderType,prescNo,OEItemID)
	....s recLoc=$lg(list,RecLocIndex)
	....s doc=$lg(list,DoctorIndex)
	....i (OEItemID=" 3612||7")||(OEItemID="3612||8")||(OEItemID="3612||9")||(OEItemID="3612||10") b //45
	....i $lg(list,24)[".",prelist'="" d
	.....s PreSeqNo=$list(prelist,24)
	.....i PreSeqNo["." s $list(list,24)=$p(PreSeqNo,".",1)_"."_($p(PreSeqNo,".",2)+1)
	.....e  s $list(list,24)=PreSeqNo_".1"  ///MainSeqNo_".1"
	....e  d
	.....s $list(list,24)=MainSeqNo,MainSeqNo=MainSeqNo+1
	....d BuildJsonForList(colDefine,list)
	....//s MainSeqNo=MainSeqNo+1
	....s prelist=list //^CacheTemp(tIndx,orderType,prescNo,OEItemID)
	...w "]"
	...w ",""title"":""处方-处方号："_prescNo_"-"_recLoc_"-"_doc_""""
	...w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true}"
	...w "}"
	...w ",""titleClass"":""normal-head"""
	...w "}"
	.else  if orderType="L" d
	..s col="PrintFlag:选择,OrderSeqNo:序号,OrderStartDate:医嘱日期,OrderStartTime:医嘱时间,OrderName:医嘱名称,ReportDate:报告日期,ReportTime:报告时间,ReqPartDesc:标本,OrderLabEpisodeNo:标本号,OrderRecDep:接收科室,TOrderEndDate:停止日期,TOrderEndTime:停止时间"
	..s col=col_","_"OrderARCIMRowid:,OrderType:,OrderPriorRowid:,OrderDoseUOMRowid:,OrderFreqRowid:,OrderFreqFactor:,OrderFreqInterval:,OrderInstrRowid:,OrderDurRowid:,OrderDurFactor:,OrderPackUOMRowid:,OrderBillTypeRowId:,OrderItemRowid:OrderItemRowid"
	..s title="检验"
	..d BuildNotR
	.else  if orderType="S" d
	..s col="PrintFlag:选择,OrderSeqNo:序号,OrderStartDate:医嘱日期,OrderStartTime:医嘱时间,OrderName:医嘱名称,ReportDate:报告日期,ReportTime:报告时间,ReqPartDesc:部位,OrderRecDep:接收科室,TOrderEndDate:停止日期,TOrderEndTime:停止时间"
	..s col=col_","_"OrderARCIMRowid:,OrderType:,OrderPriorRowid:,OrderDoseUOMRowid:,OrderFreqRowid:,OrderFreqFactor:,OrderFreqInterval:,OrderInstrRowid:,OrderDurRowid:,OrderDurFactor:,OrderPackUOMRowid:,OrderBillTypeRowId:,OrderItemRowid:OrderItemRowid"
	..s title="检查"
	..d BuildNotR
	.else  d
	..s col="PrintFlag:选择,OrderSeqNo:序号,OrderStartDate:医嘱日期,OrderStartTime:医嘱时间,OrderName:医嘱名称,OrderStatus:状态,OrderRecDep:接收科室,OrderDoc:开医嘱人,OrderSum:金额,OrderDepProcNote:备注,OrderBillType:费别,TOrderEndDate:停止日期,TOrderEndTime:停止时间"
	..s col=col_","_"OrderARCIMRowid:,OrderType:,OrderPriorRowid:,OrderDoseUOMRowid:,OrderFreqRowid:,OrderFreqFactor:,OrderFreqInterval:,OrderInstrRowid:,OrderDurRowid:,OrderDurFactor:,OrderPackUOMRowid:,OrderBillTypeRowId:,OrderItemRowid:OrderItemRowid"
	..s title="其他"
	..d BuildNotR
	w "]"
	q ""
BuildJsonForList(colDef,list)
    w "{"
	f i=1:1:len {
		s pro=colDef.get(i)
		s t=$g(colDef.map(pro,"Type"),10)
		//i pro="ReportTime" b //44
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
			i t=2 s v=$zd(v,3)
			i t=3 s v=$zt(v,1)
			Write ("""")
			s v=##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr(v,"'","&#39")
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
	s rowCount=0,SeqNo=1
	k MenuOEMap
	s OEItemID="" f  s OEItemID=$o(^CacheTemp(tIndx,orderType,OEItemID)) q:OEItemID=""  d
	.w:rowCount>0 ","
	.s rowCount=rowCount+1
	.s list=^CacheTemp(tIndx,orderType,OEItemID)
	.s $list(list,24)=SeqNo
	.d BuildJsonForList(colDefine,list)
	.s SeqNo=SeqNo+1
	w "]"
	w ",""title"":"""_title_""""
	w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true}"
	//w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true},"
	//d BuildMenuOEConfig
	w "}"
	w ",""titleClass"":""normal-head"""
	w "}"
    q
	k ^CacheTemp(tIndx)
}

// d ##class(DHCDoc.OPDoc.CopyOrderItemList).QueryOEForCopyData(230,126,3,"","","","")

// 234,,3,,,,

ClassMethod QueryOEForCopyData(episodeID As %String, GroupRowId As %String = "", PriorID As %String, CTLOCRowId As %String, DocNameID As %String, Drug As %String, notDrug As %String, ByRef colDefine As DHCDoc.Common.MapIndex)
{
	s colDefine=##class(DHCDoc.Common.MapIndex).%New()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOrderItemList"
	set rs.QueryName="FindAdmOrderItems"
	set sc=rs.Execute(episodeID,GroupRowId,PriorID,CTLOCRowId,DocNameID,Drug,notDrug)
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
    d colDefine.add("ReqPartDesc")
    s colDefine.map("ReqPartDesc","Type")=10  //部位/标本
    d colDefine.add("ReqPartId")
    s colDefine.map("ReqPartId","Type")=10  //部位id
    
	s PAADMDate=##class(websys.Conversions).DateLogicalToHtml($p(^PAADM(episodeID),"^",6)) //$zd($p(^PAADM(episodeID),"^",6),3)
	s tIndx="QueryOEForPrint_"_$j
	k ^CacheTemp(tIndx)
	s OESubType="",count=1
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s OEItemID=rs.Data("OrderItemRowid")
		s OEID=$p(OEItemID,"||",1)
		s OEORID=$p(OEItemID,"||",2)
		s AdmID=$p(^OEORD(OEID),"^",1)
		s PAPMIID=$p(^PAADM(AdmID),"^",1)
		s PatName=$p(^PAPER(PAPMIID,"ALL"),"^",1)
		S PatIDNo=$p(^PAPER(PAPMIID,"PAT",3),"^",6)
		s PrescNo=rs.Data("OrderPrescNo")
		s OrderType=rs.Data("OrderType")
		if (OrderType'="R")&&(OrderType'="L"){
			s ARCIMRowid=rs.Data("OrderARCIMRowid")
			s ServiceFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
		    i ServiceFlag="1" s OrderType="S"
		}
		s ReportDate="",ReportTime="",ReqPartDesc="",ReqPartId=""
		if (OrderType="S"){
			s RptRowIdStr=$$GetRisReportId(OEItemID)
			/*zn "PACS"
			s ReportInfo=##class(PACS.RISInterface).GetReportInfo($p(RptRowIdStr,"^",2))
			zn "DHC-APP"
			s ReportDate=$p(ReportInfo,"^",21)
			s ReportTime=$p(ReportInfo,"^",20)*/
			s rbID=$p(RptRowIdStr,"^",1)
			if (rbID'=""){
				s AuthDate=$p(^DHCRBStudy("Report",rbID),"^",9)   /// 报告日期
				s AuthTime=$p(^DHCRBStudy("Report",rbID),"^",10)  /// 报告时间
				s ReportDate=##class(websys.Conversions).DateLogicalToHtml(AuthDate)
				s ReportTime=##Class(websys.Conversions).TimeLogicalToHtml(AuthTime)
			}
			
			s ReqPartDesc=##Class(DHCDoc.OPDoc.CopyOrderItemList).GetExaReqPartDesc(OEItemID)
			s ReqPartId=##Class(DHCDoc.OPDoc.CopyOrderItemList).GetReqPartID(OEItemID)
		}elseif(OrderType="L"){
			s OrdStr3=$g(^OEORD(OEID,"I",OEORID,3))
			s VisitNumber=$p(OrdStr3,"^",20)
			i $l(VisitNumber) {
				if ($d(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_VisitNumber))){
					s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_VisitNumber,""))
					i $d(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR)) {
						s wgm="" f  s wgm=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,wgm)) q:wgm=""  d
						.s ordno="" f  s ordno=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,wgm,ordno)) q:ordno=""  d
						..s ReportId="" f  s ReportId=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,wgm,ordno,ReportId)) q:ReportId=""  d
						...s ReportData=$g(^dbo.RPVisitNumberReportD(ReportId))
						...s ReportStatus=$lg(ReportData,22)	
						...q:ReportStatus'=3 
						...s ReportDate=$lg(ReportData,19)
						...s ReportTime=$lg(ReportData,20)
						...i $l(ReportDate) s ReportDate=##class(websys.Conversions).DateLogicalToHtml($zdh(ReportDate,8))
						...i $l(ReportTime) s ReportTime=##Class(websys.Conversions).TimeLogicalToHtml(ReportTime)
					}
				}
			}
			s ReqPartDesc=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
		}
		s list=$lb()
		s index=0
		f index=1:1:len{
			s onedata=rs.GetData(index)
			i index=4 {
				if (rs.GetData(index)'["-")&&(rs.GetData(index)'["/"){
					s onedata=##class(websys.Conversions).DateLogicalToHtml(rs.GetData(index)) //$zd(rs.GetData(index),3)
				}else{
					s onedata=rs.GetData(index)
				}
			}
			i index=12 s onedata=$fn(onedata,"",2)
			i index=5 s onedata=##Class(websys.Conversions).TimeLogicalToHtml(rs.GetData(index)) //$zt(rs.GetData(index),1)
			s $list(list,index)=onedata
		}
		s $list(list,index+1)=""
		s $list(list,index+2)=ReportDate
		s $list(list,index+3)=ReportTime
		s $list(list,index+4)=PAADMDate
		s $list(list,index+5)=ReqPartDesc
		s $list(list,index+6)=ReqPartId
		if OrderType="R",PrescNo'=""{
			s ^CacheTemp(tIndx,OrderType,PrescNo,count)=list
		}elseif OrderType="L" {
			s ^CacheTemp(tIndx,OrderType,count)=list
		}elseif OrderType="S" {
			s ^CacheTemp(tIndx,OrderType,count)=list
		}else{
			s ^CacheTemp(tIndx,"O",count)=list
		}
		s count=count+1
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

// w ##class(DHCDoc.OPDoc.CopyOrderItemList).GetReqPartID("3643||4")

ClassMethod GetReqPartID(oeori As %String) As %String
{
	s OrderBodyPartLabel=""
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.Q:$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)="D"
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s arPosiID="",arPosiIDStr=""
	.f  s arPosiID=$o(^DHCAPREPO(0,"RepPart",arPartID,arPosiID)) Q:arPosiID=""  D
	..s PosiID=$p(^DHCAPREPO(arPosiID),"^",2)
	..Q:PosiID=""
	..i arPosiIDStr="" s arPosiIDStr=PosiID
	..e  s arPosiIDStr=arPosiIDStr_","_PosiID
	.i OrderBodyPartLabel="" s OrderBodyPartLabel=PartID_"B"_arPosiIDStr
	.e  s OrderBodyPartLabel=OrderBodyPartLabel_"A"_PartID_"B"_arPosiIDStr
	Q OrderBodyPartLabel
}

ClassMethod GetExaReqPartDesc(oeori As %String) As %String
{
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.//Q:ExeStat="D"
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 		     /// 部位
	.i ListData'="" s ListData=ListData_" + "_PartDesc
	.E  s ListData=" "_PartDesc

	Q ListData
}

/// w ##class(DHCDoc.OPDoc.CopyOrderItemList).GetDataforCheck("173||3")
ClassMethod GetDataforCheck(Str)
{
	q:Str="" ""
	s ^tempqujian("GetDataforCheck")=Str
	s Length=$l(Str,"^")
	s retstring=""
	for i=1:1:Length{
		s OEOrdID=$p(Str,"^",i)
		s orderParref=$P(OEOrdID,"||",1)
		s orderId=$P(OEOrdID,"||",2)
		s EpisodeID=$P(^OEORD(orderParref),"^",1)
		s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
		s HospitalDR=$P(^CTLOC(AdmLoc),"^",22)
		i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
		s HospitalCode=$P(^CT("HOSP",HospitalDR),"^",1)
		s str1 = $g(^OEORD(orderParref,"I",orderId,1))
		s OrderARCIMRowid = $p(str1,"^",2)
		s OrderPackQty=$p($g(^OEORD(orderParref,"I",orderId,9)),"^",4)
		s str2 = $g(^OEORD(orderParref,"I",orderId,2))
		s OrderDoseQty = $p(str2,"^",1)
		s OrderDoseUOM = $p(str2,"^",3)
		s OrderFreqRowID=$p(str2,"^",4)
		s OrderDurRowid = $p(str2,"^",6) 
		s OrderInstrRowID = $p(str2,"^",7)
		s Link="",FindDrugLink=""
		f {
			s Link=$O(^OEORDi(0,"OEORI",+orderParref,OEOrdID,Link))
			Q:(Link="")||(FindDrugLink'="")
			s LinkOrderARCIMRowid=$p($g(^OEORD(+orderParref,"I",Link,1)),"^",2)
			s LinkOrderType=##class(web.DHCDocOrderCommon).GetOrderType(LinkOrderARCIMRowid)
			if (LinkOrderType="R")&&(("^"_Str_"^")[("^"_(+orderParref)_"||"_Link_"^")){
				s FindDrugLink=Link
			}
		}
		s Link=FindDrugLink
		s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
		if (groupdr'="")&&(("^"_Str_"^")'[("^"_groupdr_"^")) s groupdr=""
		if ((Link'="")||(groupdr'="")){
			s OrderMasterSeqNo=  $p(^OEORD(orderParref,"I",orderId,3),"^",4)
		}else{
			s OrderMasterSeqNo=  ""
		}
		if (groupdr'=""){
			s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(OrderARCIMRowid)
			if (OrderType'="R"){
				s OrderMasterSeqNo=  ""
			}
		}
		s OrderDepProcNote=""
		s depProcNotesIndex = 0
		f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		.q:(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)="")
		.if OrderDepProcNote'="" s OrderDepProcNote = OrderDepProcNote_" "_$g(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex))
		.else  s OrderDepProcNote=$g(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex))
		s OrderPriorRowid=$P($G(^OEORD(orderParref,"I",orderId,1)),"^",8)
		s OrdLabSpec=""
		s SpecCode=$$GetOELabSpecimen^DHCDocOrderCommonNew(OEOrdID)
		s:SpecCode'="" OrdLabSpec=##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode)
		s SampleId=$P(OrdLabSpec,$C(2),1)
		s OrderPriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
		s OrderPriorRemarks=$CASE(OrderPriorCode,"OM":"OM","OMLSZT":"ZT","OMST":"OM","ONE":"ONE",:"")
		s OrderStageCode=$p($G(^OEORD(+orderParref,"I",orderId,"DHC")),"^",8)
		s OrderSpeedFlowRate=$p($g(^OEORD(orderParref,"I",orderId,3)),"^",17)
		s OrderFlowRateUnitRowId=$p($g(^OEORD(orderParref,"I",orderId,6)),"^",8)
		s OrderPackUOM=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",13)
		s OrderRecDepRowid=$p($g(^OEORD(orderParref,"I",orderId,"3")),"^",6)
		s OrderBodyPartLabel=..GetReqPartID(OEOrdID)
		/*if (depProcNotesIndex'=""){
			s NotesLen=$l(depProcNotesIndex,",")
				s OrderBodyPart=$p(depProcNotesIndex,",",NotesLen)
				s OrderBodyPartLabel=$o(^MRC("BODP",0,"Desc",OrderBodyPart,""))
		}*/
		i ((OrderPriorRowid=6)||(OrderPriorRowid=4)||(OrderPriorRowid=30)||(OrderPriorRowid=1)||(OrderPriorRowid=2)) s OrderPriorRowid=3
		i ((OrderPriorRowid=8)||(OrderPriorRowid=29)) s OrderPriorRowid=5
		if (retstring=""){
			s retstring=OrderARCIMRowid_"^"_OrderPackQty_"^"_OrderDoseQty_"^"_OrderDoseUOM_"^"_OrderFreqRowID_"^"_OrderDurRowid_"^"_OrderInstrRowID_"^"_OrderMasterSeqNo_"^"_OrderDepProcNote_"^"_OrderPriorRowid_"^"_SampleId_"^^"_OrderPriorRemarks_"^"_OrderStageCode_"^"_OrderSpeedFlowRate_"^"_OrderFlowRateUnitRowId_"^"_OrderPackUOM_"^"_OrderRecDepRowid_"^"_OrderBodyPartLabel
		}else{
			s retstring=retstring_$C(2)_OrderARCIMRowid_"^"_OrderPackQty_"^"_OrderDoseQty_"^"_OrderDoseUOM_"^"_OrderFreqRowID_"^"_OrderDurRowid_"^"_OrderInstrRowID_"^"_OrderMasterSeqNo_"^"_OrderDepProcNote_"^"_OrderPriorRowid_"^"_SampleId_"^^"_OrderPriorRemarks_"^"_OrderStageCode_"^"_OrderSpeedFlowRate_"^"_OrderFlowRateUnitRowId_"^"_OrderPackUOM_"^"_OrderRecDepRowid_"^"_OrderBodyPartLabel
		}
	}
	q retstring
}

Storage Default
{
<Data name="CopyOrderItemListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.OPDoc.CopyOrderItD5C5D</DataLocation>
<DefaultData>CopyOrderItemListDefaultData</DefaultData>
<IdLocation>^DHCDoc.OPDoc.CopyOrderItD5C5D</IdLocation>
<IndexLocation>^DHCDoc.OPDoc.CopyOrderItD5C5I</IndexLocation>
<StreamLocation>^DHCDoc.OPDoc.CopyOrderItD5C5S</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
