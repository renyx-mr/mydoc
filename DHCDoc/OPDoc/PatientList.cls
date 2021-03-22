Class DHCDoc.OPDoc.PatientList Extends %RegisteredObject
{

ClassMethod DocRegList(userId As %String, locId As %String) As %String
{
	q:((userId="")||(locId="")) ""
	s docId=$P(^SSU("SSUSR",userId),"^",14)
	q:docId="" ""
	s json="["
	s ret=""
	s count=0
	s markRowId=0 
	s NowTime=$P($H,",",2)
	s NowTime=$P($H,",",2)
	s TimeRangeRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(NowTime)
	f  s markRowId=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",docId,markRowId))  q:markRowId=""  d
	.s flag=0
	.s id="" f  s id=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",docId,markRowId,id)) q:(id="")||(flag=1)  d
	..s markDepId=$list(^User.DHCMarkDocD(id),4)
	..i markDepId=locId s flag=1
	.q:flag=0
	.s id=0
	.s id=$o(^RB("RES",0,"CTPCP",markRowId,locId,id))
	.q:id=""
	.s st=$p(^RB("RES",id),"^",6)
	.q:st'="Y"
	.s markDesc=$p($g(^CTPCP(markRowId,1)),"^",2)
	.if count>0 s json=json_","
	.s selectedFlag=0
	.if markRowId=docId d
	..s ASChildSub=$o(^RBAS(0,"Date",+$h,id,0))
	..if ASChildSub'="" d
	...s TimeRangeDR=$p($g(^RBAS(id,ASChildSub,"DHC")),"^",17)
	...if (TimeRangeRowId=TimeRangeDR) s selectedFlag=1
	.if selectedFlag=1 d
	..s json=json_"{""id"":"""_markRowId_""",""des"":"""_markDesc_""",""selected"":""true""}"
	.e  d
	..s json=json_"{""id"":"""_markRowId_""",""des"":"""_markDesc_"""}"
	.s count=count+1
	q json_"]"
}

// w ##class(DHCDoc.OPDoc.PatientList).GessCardType("1")

ClassMethod GessCardType(cardValue As %String)
{
	s count=0
	s myTypeID=0
	s myDataFlag=0
	s json="["
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
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.b ;3
	.q:checkdValue=""
	.//s cfRowId=$o(^DHCCARDi("CF",0,"CardNo",checkdValue,""))
	.//s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	.//s CFActiveFlag=$p($g(^DHCCARD("CF",cfRowId)),"^",10)
	.//q:CFActiveFlag'="N"
	.s cfRowId=0
	.f  s cfRowId=$o(^DHCCARDi("CF",0,"CardNo",checkdValue,cfRowId)) q:cfRowId=""  d
	..s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	..s CFActiveFlag=$p($g(^DHCCARD("CF",cfRowId)),"^",10)
	..q:CFActiveFlag'="N"
	..s SecurityNo=$P(^DHCCARD("CF",cfRowId),"^",3)
	..s SecurityNo=##class(web.UDHCAccEnrypt).Decrypt(SecurityNo)
	..i count>0 s json=json_","
	..s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_""",""SecurityNo"":"""_SecurityNo_"""}"
	..s count=count+1
	q json_"]"
}

// d ##class(DHCDoc.OPDoc.PatientList).CheckCardValue("1","1")

ClassMethod CheckCardValue(cardTypeId As %String, cardNo As %String) As %String [ Private ]
{
	q:( (cardTypeId="") || ('$d(^DHCCARDTYPEDef(cardTypeId))) ) ""
	s ls=^DHCCARDTYPEDef(cardTypeId)
	s len=$p(ls,"^",17)
	for i=$l(cardNo)+1:1:len {
		s cardNo="0"_cardNo
	}
	if '$d(^DHCCARDi("CF",0,"CardNo",cardNo)) s cardNo=""
	if cardNo'="",'$d(^DHCCARDi("CF",0,"CardTypeNo",cardTypeId,cardNo)) s cardNo=""
	q cardNo
}

// d ##class(DHCDoc.OPDoc.PatientList).GetOPHandleStatusData("1981","JSON")

ClassMethod GetOPHandleStatusData(EpisodeID, format = "JSON", ByRef list = "") As %String
{
	try{
		d ##class(DHCDoc.OPDoc.PatientList).GetOPHandleData(EpisodeID,"",.opMap)
	}catch(e){
		zn "dhc-app"
		k opMap
	}
	s list=$lb()
	if '$d(opMap) d
	.s list=$lb("","","","")
	if ($d(opMap("DisDrugs"))) d
	.s code="DisDrugs"
	.s opMap(code)=$g(opMap(code),"")_"S3"
	.s opMap(code,"$Des")="药品"
	.s $list(list,1)=$lg(list,1)_"S3"
	if ($d(opMap("UnDisDrugs"))) d
	.s code="UnDisDrugs"
	.s opMap(code)=$g(opMap(code),"")_"S1"
	.s opMap(code,"$Des")="药品"
	.s $list(list,1)=$lg(list,1)_"S1"
	if (('$d(opMap("DisDrugs"))) && ('$d(opMap("UnDisDrugs")))) d
	.s $list(list,1)=$lg(list,1)_"S0"
	if ($d(opMap("AbnormalLab"))) d
	.s code="AbnormalLab"
	.s opMap(code)=$g(opMap(code),"")_"S3"
	.s opMap(code,"$Des")="化验"
	.s $list(list,2)=$lg(list,2)_"S3"
	if ($d(opMap("NotLabReport"))) d
	.s code="NotLabReport"
	.s opMap(code)=$g(opMap(code),"")_"S2"
	.s opMap(code,"$Des")="化验"
	.s $list(list,2)=$lg(list,2)_"S2"
	if (('$d(opMap("AbnormalLab"))) && ('$d(opMap("NotLabReport")))) d
	.s $list(list,2)=$lg(list,2)_"S0"
	if ($d(opMap("AbnormalExam"))) d
	.s code="AbnormalExam"
	.s opMap("AbnormalExam")="S3"
	.s opMap(code,"$Des")="检查"
	.s $list(list,3)=$lg(list,3)_"S3"
	if ($d(opMap("NotExamReport"))) d
	.s code="NotExamReport"
	.s opMap(code)=$g(opMap(code),"")_"S2"
	.s opMap(code,"$Des")="检查"
	.s $list(list,3)=$lg(list,3)_"S2"
	if (('$d(opMap("AbnormalExam"))) && ('$d(opMap("NotExamReport")))) d
	.s $list(list,3)=$lg(list,3)_"S0"
	if ($d(opMap("TreatItem"))) d
	.s code="TreatItem" //"TreatItemStatus"
	.s opMap(code)=$g(opMap(code),"")_"S1"
	.s opMap(code,"$Des")="治疗"
	.s $list(list,4)=$lg(list,4)_"S1"
	/*else  d
	.s code="TreatItem"
	.s opMap(code)=$g(opMap(code),"")_"S0"
	.s opMap(code,"$Des")="治疗"
	.s $list(list,4)=$lg(list,4)_"S0"*/
	if format="JSON" d
	.s ci=0
	.s str= "["
	.s code="" f  s code=$o(opMap(code)) q:code=""  d
	..s:ci>0 str=str_ ","
	..s ci=ci+1
	..s ii=0
	..s str=str_ "{""status"":"""_opMap(code)_""",""field"":"""_code_""",""des"":"""_opMap(code,"$Des")_""",""list"":["
	..s ind="" f  s ind=$o(opMap(code,ind)) q:ind=""  d
	...q:$e(ind,1)="$"
	...s v=opMap(code,ind)
	...q:v=""
	...s:ii>0 str=str_","
	...s ii=ii+1
	...s str=str_ """"_##class(DHCDoc.Common.FormatData).Escape(v)_""""
	..s str=str_ "]"
	..s str=str_ "}"
	.s str=str_ "]"
	else  d
	.s str=""
	q str
}

// d ##class(DHCDoc.OPDoc.PatientList).OutPatientList("7","4634","","","","","","","","","","","ArrivedQue")

ClassMethod OutPatientList(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "") As %String
{
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	s ^tempscl("OutPatientList12")=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation_","_MarkID_","_CheckName
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, CheckName)
	s colDefine=##class(DHCDoc.Common.MapIndex).%New()
	s len=rs.GetColumnCount()
	f i=1:1:len {
		d colDefine.add(rs.GetColumnName(i))
		s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
	}
	;d colDefine.add("DrugsStatus")
	;s colDefine.map("DrugsFlag","Type")=16 //bool
	d colDefine.add("DrugsStatus")
	s colDefine.map("DrugsStatus","Type")=10 //varchar
	;d colDefine.add("DrugsDes")
	d colDefine.add("LaboratoryStatus")
	;d colDefine.add("LaboratoryDes")
	d colDefine.add("InspectStatus")
	;d colDefine.add("InspectDes")
	d colDefine.add("TreatmentStatus")
	;d colDefine.add("TreatmentDes")
	
	s epIndex=colDefine.index("EpisodeID")
	s count=0
	w "["
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s list=$lb()
		s index=0
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		s EpisodeID=$lg(list,epIndex)
		;s EpisodeID=""
		if EpisodeID'="" {
			d ..GetOPHandleStatusData(EpisodeID,"",.list2)
			s $list(list,len+1,len+$ll(list2))=list2
		}
		s count=count+1
		w:count>1 ","
		d ##class(DHCDoc.Common.FormatData).JsonList(colDefine,list)
	}
	w "]"
	d rs.Close()
	q ""
}

// d ##class(DHCDoc.OPDoc.PatientList).OutPatientListCatCount("63","600","","","000000000001","","","","","","","","")

ClassMethod OutPatientListCatCount(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "") As %String
{
	s ^TempRen("OutPatientListCatCount")=$lb(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID)
	s NextPatName="",NextPatSeqNo=""
	w "{"
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "RegQue")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		//未就诊数量不包含说明记录
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		//未就诊数量不包含已到达、完成就诊
		s PatWalkStatus=rs.GetDataByName("WalkStatus")
		continue:PatWalkStatus="到达"
		s count=count+1
		if (NextPatName=""){
			s NextPatName=rs.GetDataByName("PAPMIName")
			s NextPatSeqNo=rs.GetDataByName("LocSeqNo")
		}
	}
	w """RegQue"":"_count
	w ",""NextPatName"":"_""""_NextPatName_""""
	w ",""NextPatSeqNo"":"_""""_NextPatSeqNo_""""
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "ArrivedQue")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""Complete"":"_count
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "Report")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""Report"":"_count
	d rs.Close()
	//renyx 完成就诊添加
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "DiagnosisQue")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""DiagnosisQue"":"_count
	d rs.Close()
	w "}"
	q ""
}

/// Creator:guorongyong
/// CreateDate:2014-08-11
/// Desc:得到门诊已处理的业务数据
/// input: EpisodeID 就诊表rowid,OutDataType 需要输出的数据类型("" 或 "JSON")
/// output: Json数据格式eg:{DisDrugs:[{Desc:具体描述},{Desc:具体描述}],UnDisDrugs[{Desc:具体描述},{Desc:具体描述}]}
/// output: 字符数据格式eg:"DisDrugs"_$c(1)_具体描述1_$c(2)_具体描述2_"^"_"UnDisDrugs"_$c(1)_具体描述1_$c(2)_具体描述2
/// w ##class(DHCDoc.OPDoc.PatientList).GetOPHandleData(422,"","JSON")
ClassMethod GetOPHandleData(EpisodeID As %String, OutDataType As %String, ByRef OutPutArray = "") As %String(MAXLEN=5000)
{
	;1.已取药品:DisDrugs
	;2.未取药品:UnDisDrugs
	;3.异常检验:AbnormalLab
	;4.未出检验报告:NotLabReport
	;5.异常检查:AbnormalExam
	;6.未出检查报告:NotExamReport
	;7.治疗项目:TreatItem(子类配置:^DHCDocConfig("TreatItemCat")="...^...^...")
	s ^tmpgry("GetOPHandleData")=EpisodeID_","_OutDataType
	Set myrtnStr=""
	Quit:$g(EpisodeID)="" myrtnStr
	
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	q:OrderRowid="" myrtnStr
	Kill OutPutArray
	s itemsub=0,LabOrdNum=0
	for {
		s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")
		continue:'$d(^OEORD(OrderRowid,"I",itemsub,1))
		s OrdData1=$g(^OEORD(OrderRowid,"I",itemsub,1))
		s OrdData2=$g(^OEORD(OrderRowid,"I",itemsub,2))
		s OrdData3=$g(^OEORD(OrderRowid,"I",itemsub,3))
		s OrdData9=$g(^OEORD(OrderRowid,"I",itemsub,9))
		s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		i itemstat'="" d
		.s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:(statcode'="V")&&(statcode'="E")
	
		s ArcimId=$p(OrdData1,"^",2) 
		s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
		s ReqPartDesc=##Class(web.DHCEMInterface).GetExaReqPartDesc(OrderRowid_"||"_itemsub)
		if (ReqPartDesc'="") s ArcimDesc=ArcimDesc_ReqPartDesc
		s ItemCatDR=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
		s FreqDesc="",DurDesc="",InstrDesc=""
		s FreqId=$p(OrdData2,"^",4)
		i FreqId'="" d
		.s FreqDesc=$p(^PHCFR(FreqId),"^",3)
		.s WeekFlag=$P(^PHCFR(FreqId),"^",9)
		.i WeekFlag="Y" d
		..s OrderFreqWeek=$p($g(^OEORD(+OrderRowid,"I",itemsub,"DHC")),"^",55)
		..s FreqDesc=FreqDesc_"-"_$TR(OrderFreqWeek,"|","")
	
		s DurId=$p(OrdData2,"^",6)
		i DurId'="" s DurDesc=$p(^PHCDU(DurId),"^",3)
		s InstrId=$p(OrdData2,"^",7)
		i InstrId'="" s InstrDesc=$p(^PHCIN(InstrId),"^",2)
		s DoseQty=$p(OrdData2,"^",1)
		s DoseUomId=$p(OrdData2,"^",3)
		s DoseUom=##class(web.DHCDocOrderCommon).GetUOMDesc(DoseUomId,"") 
		
		;保持显示数据对其(30个空格字符)
		s Space="                              "
		//s ArcimDesc=ArcimDesc_$e(Space,1,30-$l(ArcimDesc))
		//s InstrDesc=InstrDesc_$e("    ",1,4-$l(InstrDesc))
		//s FreqDesc=FreqDesc_$e("    ",1,4-$l(FreqDesc))
		//s DurDesc=DurDesc_$e("    ",1,4-$l(DurDesc))
		i OrderType="R" {
			s PackQty=$$GetPackQty(OrderRowid_"||"_itemsub)
			s DrugOutPutDesc=ArcimDesc_"&nbsp"_InstrDesc_"&nbsp"_FreqDesc_"&nbsp"_DurDesc_"&nbsp"_PackQty
			s dstatusFlag=$$IsDspDrug(OrderRowid_"||"_itemsub)
			i dstatusFlag=1 {
				;1. 得到已取药品
				s OutPutArray("DisDrugs",$i(OutPutArray("DisDrugs")))=DrugOutPutDesc
			}else{
				;2. 未取药品
				s OutPutArray("UnDisDrugs",$i(OutPutArray("UnDisDrugs")))=DrugOutPutDesc
			}
		}
		
		i OrderType="L" {
 			s VisitNumberTestSetDR=$Piece(OrdData3,"^",35)
 			i VisitNumberTestSetDR="" {
	 			;4.未出检验报告
	 			s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
				s OutPutArray("NotLabReport",$i(OutPutArray("NotLabReport")))=ArcimDesc_"&nbsp"_Qty
 			}else{
	 			;3.异常检验
	 			s n=0
				Set rset=##Class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId")
				If rset.QueryIsValid() { 
					Set Status=rset.Execute(OrderRowid_"||"_itemsub)
					If 'Status Quit
					While (rset.Next()) {
						;Code:检测项目,Name:项目名称,Sync:项目缩写,Result:项目结果,Flag:异常提示(H/L),Unit:单位,Ranges:参考范围,Comment:结果说明,Method:检测方法,Sequence:显示序号
					    s Code=rset.GetDataByName("Code")
					    s Name=rset.GetDataByName("Name")
					    s Sync=rset.GetDataByName("Sync")
					    s Result=rset.GetDataByName("Result")
					    s Flag=rset.GetDataByName("Flag")
					    s Unit=rset.GetDataByName("Unit")
					    s Ranges=rset.GetDataByName("Ranges")
					    s Comment=rset.GetDataByName("Comment")
					    s Method=rset.GetDataByName("Method")
					    s Sequence=rset.GetDataByName("Sequence")
					    //s Name=Name_$e("            ",1,12-$l(Name))
					    //s Result=Result_$e("    ",1,4-$l(Result))_Unit
					    //s Ranges=Ranges_$e("      ",1,6-$l(Ranges))
					    i Flag'="" {
						    s n=n+1
						    s AbnormalLabOutput="&nbsp"_Name_"&nbsp"_Result_"&nbsp"_Flag_"&nbsp"_Ranges
						    ;对于第一条需要加上医嘱名称的显示
						    i n=1 {
							    s LabOrdNum=LabOrdNum+1
						    	s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))=LabOrdNum_"&nbsp"_ArcimDesc
						    	s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))="&nbsp&nbsp"_LabOrdNum_"."_n_"&nbsp"_AbnormalLabOutput
						    }else{
							    s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))="&nbsp&nbsp"_LabOrdNum_"."_n_"&nbsp"_AbnormalLabOutput
						    }
					    }
					    
					}
					d rset.Close()
				}
 			}
		}
		s IsExamItemFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)
		i IsExamItemFlag="1" {
			s RptRowIdStr=$$GetRisReportId(OrderRowid_"||"_itemsub)
			s RptRowId=$p(RptRowIdStr,"^",1)
			i RptRowId="" {
				;6.未出检查报告
				s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
				s OutPutArray("NotExamReport",$i(OutPutArray("NotExamReport")))=ArcimDesc_"&nbsp"_Qty
			}else{
				;5.异常检查
				s ReportInfo=$$GetRisReport(OrderRowid_"||"_itemsub)
				s ExamDesc=$p(ReportInfo,"^",1)
				s strResult=$p(ReportInfo,"^",2)
				s sdoccode=$p(ReportInfo,"^",3)
				i sdoccode="阳性" {
					s OutPutArray("AbnormalExam",$i(OutPutArray("AbnormalExam")))=ArcimDesc
					s OutPutArray("AbnormalExam",$i(OutPutArray("AbnormalExam")))="&nbsp&nbsp&nbsp&nbsp"_strResult
				}
			}
		}
		s TreatItemCatStr=$g(^DHCDocConfig("TreatItemCat"))
		i ("^"_TreatItemCatStr_"^")[("^"_ItemCatDR_"^") {
			;5.治疗项目
			s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
			s TreatItemOutPutDesc=ArcimDesc_"&nbsp"_InstrDesc_"&nbsp"_FreqDesc_"&nbsp"_DurDesc_"&nbsp"_Qty
			s OutPutArray("TreatItem",$i(OutPutArray("TreatItem")))=TreatItemOutPutDesc
		}
	}
	i OutDataType="JSON" {
		s Node=""
		for {
			s Node=$o(OutPutArray(Node)) q:Node=""
			s Index=0,NodeResultStr=""
			for {
				s Index=$o(OutPutArray(Node,Index)) q:Index=""
				i NodeResultStr="" {
					s NodeResultStr="{""Desc"":"""_OutPutArray(Node,Index)
				}else{
					s NodeResultStr=NodeResultStr_"""},{""Desc"":"""_OutPutArray(Node,Index)
				}
			}
			i NodeResultStr'="" s NodeResultStr=NodeResultStr_"""}"
			
			i myrtnStr="" {
				s myrtnStr="{"""_Node_""":["_NodeResultStr
			}else{
				s myrtnStr=myrtnStr_"],"""_Node_""":["_NodeResultStr
			}
		}
		i myrtnStr'="" s myrtnStr=myrtnStr_"]}"
	}else{
		s Node=""
		for {
			s Node=$o(OutPutArray(Node)) q:Node=""
			s Index=0,NodeResultStr=""
			for {
				s Index=$o(OutPutArray(Node,Index)) q:Index=""
				i NodeResultStr="" {
					s NodeResultStr=OutPutArray(Node,Index)
				}else{
					s NodeResultStr=NodeResultStr_$c(2)_OutPutArray(Node,Index)
				}
			}
			i myrtnStr="" {
				s myrtnStr=Node_$c(1)_NodeResultStr
			}else{
				s myrtnStr=myrtnStr_"^"_Node_$c(1)_NodeResultStr
			}
		}
	}
	
	Q myrtnStr
	
IsDspDrug(oeitm)
	s dstatusFlag=0
	s dis=0 for {
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,dis)) q:dis=""
		s dstatus=""
		if $g(dis)'="" s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		if dstatus="C" s dstatusFlag=1
		q:dstatusFlag=1	
	}
	
	q dstatusFlag
 ;药品得到实际使用的整包装数量
GetPackQty(oeitm)
	s ord=$p(oeitm,"||",1)
	s chl=$p(oeitm,"||",2)
	s PackQty=##class(web.DHCDocOrderEntry).GetActiveDrugQty(oeitm)
	i (PackQty'="")&&(PackQty<1) s PackQty="0"_$number(PackQty)
	s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	s BillingUOM="" 
	s BillingUOMDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8)),"^",14)
	i BillingUOMDR'="" s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	s ProtocolPackUOMDR=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		s convqty=$$ConvFac^ST02(BillingUOMDR,ProtocolPackUOMDR),convqty=$p(convqty,$c(1),1)
		i +convqty=0 s convqty=1
		s BillingUOMDR=ProtocolPackUOMDR
		s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
		s PackQty=PackQty/convqty
		;向上取整
		s PackQty=PackQty\1+$s(PackQty#1:1,1:0)
	}
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
	if (CheckCHNFlag="Y"){
		S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
		if (Phcdf'=""){
			s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
		}
	}
	Q PackQty_BillingUOM
 ;得到整包装数量和单位,直接获取存储数据
GetQtyPackUOM(oeitm)
	s ord=$p(oeitm,"||",1)
	s chl=$p(oeitm,"||",2)
	s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	s Qty=$P($g(^OEORD(ord,"I",chl,1)),"^",12)
	s BillingUOM="" 
	s BillingUOMDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8)),"^",14)
	i BillingUOMDR'="" s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	s ProtocolPackUOMDR=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		s BillingUOMDR=ProtocolPackUOMDR
		s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	}
	Q Qty_BillingUOM
	
 ;得到检查报告,参考RIS组提供给电子病历的Query:web.DHCRisclinicQueryEPR|SelectReportByOeordID
GetRisReport(oeitm)
	s ExamDesc="未回报",strResult="未回报"
	s RptRowIdStr=$$GetRisReportId(oeitm)
	s RptRowId=$p(RptRowIdStr,"^",1)
	;检查号
	s StudyNo=$p(RptRowIdStr,"^",2)
	i RptRowId'="" {
		i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" {
			s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")	
			s:(ExamDesc'="") ExamDesc=##class(web.DHCRisclinicQueryEPR).ConvertRptContent(ExamDesc)  //处理协和项目 平台组特殊字符
		}
	    i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" {
			s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
			s:(strResult'="") strResult=##class(web.DHCRisclinicQueryEPR).ConvertRptContent(strResult)  //处理协和项目 平台组特殊字符
	    }
	}
	;通过检查号获取检查阴阳性结果
	s CurrentSpace=$znspace
	zn "PACS"
	s ReportInfo=##class(PACS.RISInterface).GetReportInfo(StudyNo)
	zn CurrentSpace
	s sdoccode=$p(ReportInfo,"^",30)
	
	Q ExamDesc_"^"_strResult_"^"_sdoccode
 ;得到检查报告Rowid
GetRisReportId(oeitm)
	s RptRowId="",StudyNo=""
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",oeitm,0))
    i RegRowid'="" {
    	s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    }
    Q RptRowId_"^"_StudyNo
}

ClassMethod GetPatNameByAdm(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s PatId=$p(^PAADM(EpisodeID),"^",1)
	Q:PatId="" ""
	s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	Q PatName
}

}
