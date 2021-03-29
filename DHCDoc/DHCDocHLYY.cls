Class web.DHCDocHLYY Extends %RegisteredObject
{

/// 格式化药学项名称?因为大通的???不允许出现"<"或者">"的字符串
ClassMethod FormatDrgDesc(DrgDesc As %String) As %String
{
	s DrgDesc=$tr(DrgDesc,"<","(")
	s DrgDesc=$tr(DrgDesc,">",")")
	Quit DrgDesc
}

/// 大通要点提示
ClassMethod GetDTYDTS(ARCIMRowid As %String) As %String
{
	s Para="<general_name>"_"</general_name><license_number>"_"</license_number>"
	Quit:ARCIMRowid="" Para
	s DrgFrmRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	i DrgFrmRowid'="" {
		s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
		s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
		s DrgDesc=..FormatDrgDesc(DrgDesc)
		s Para="<general_name>"_DrgDesc_"</general_name><license_number>"_DrgCode_"</license_number>"
	}
 Quit Para
}

/// 大通分析程序
/// OrderStr:OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime+"!"+OEORIRowid;
/// 				医嘱项目ID			单次剂量		单次剂量单位ID			频次ID			疗程ID				用法ID				药学项目ID				组号			医嘱优先级ID		开始日期			开始时间		医嘱ID(仅保存后存在)
/// w ##class(web.DHCandDaTongInterface).GetPrescXML("2328||1!1!12!148!63!58!2328||1!1!4!04/06/2013!16:07","2250401","10118","876")
ClassMethod GetPrescXML(OrderStr As %String, EpisodeID As %String, DocCode As %String, UserID As %String) As %String
{
	;s OrderStr=%request.Get("Orders")
	;s EpisodeID=%request.Get("EpisodeID")
	;s DocCode=%request.Get("DocCode")
	;s UploadFlag=%request.Get("UploadFlag")
	;s UserID=$g(%session.Data("LOGON.USERID"))
	//s OtherPresc=%request.Get("OtherPresc")
	s ^TemTest111("GetPrescXML",1)=OrderStr_"^"_EpisodeID_"^"_DocCode_"^"_UserID
	
	if OrderStr="" Q ""
	s EpisodeType=$P(^PAADM(EpisodeID),"^",2)

	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	
	s DHCDTPrescXML=""
	//s DHCDTPrescXML=##class(web.DHCOEOrdItem).GetDaysDTPresc(EpisodeID,0)   //lgl+
	s OtherPresc=DHCDTPrescXML
	
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s DocID=$p(^SSU("SSUSR",UserID),"^",14)
	s DocName=$p($g(^CTPCP(DocID,1)),"^",2)				//医生姓名
	s DocProvID=$p(^CTPCP(DocID,1),"^",4)				//
	s DocProvCode=$p(^CT("CPT",DocProvID),"^",1)		//医生代码
	s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)		//就诊科室
	s EpisodeDate=$p($g(^PAADM(EpisodeID)),"^",6)		//就诊日期
	s EpisodeTime=$p($g(^PAADM(EpisodeID)),"^",7)		//就诊时间
	s EpisodeDate=$ZD(EpisodeDate,3)
	s EpisodeTime=$ZT(EpisodeTime,1)
	s CurentDate=$ZD(+$H,3),CurentTime=$ZT($p($h,",",2),1)
	s PaadmAdmNo=$p($g(^PAADM(EpisodeID)),"^",81)		//就诊号
	s BedNoID=$p($g(^PAADM(EpisodeID)),"^",73)  		//住院病人床位信息
	i BedNoID'="" s BedNo=$p($g(^PAWARD($p(BedNoID,"||",1),"BED",$p(BedNoID,"||",2))),"^",1)
	i BedNoID="" s BedNo=""
	s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
	s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
	s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	//病人住院号 登记号
	&SQL(Select PAPMI_No,PAPMI_Medicare into :PatientNo,:MedicareNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
	s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s PatientBirthday=$ZD($G(PatientDOB),3)
	s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
	else  s PatientSex=""
	s allergicCode=""
	s allergicDesc=""
	s MRDiagnosedat=""
	s MRDiagnos1="",MRDiagnos2="",MRDiagnos3=""
	s MRDiagnos1Desc="",MRDiagnos2Desc="",MRDiagnos3Desc=""
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmRowid'="" {
		s i=0
		Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For  Quit:'obj.Next()  Do
		.s Desc=obj.Data("MRDIAICDCodeDRDesc")
		.s Rowid=obj.Data("ID")
		.s CodeRowid=""   ;lgl+诊断只填描述也能过去导致
		.s CodeRowid=obj.Data("MRDIAICDCodeDR")
		.if CodeRowid'="" d
		..s ICDCode=$P($G(^MRC("ID",CodeRowid)),"^",4)
		..s ICDDesc=$P($G(^MRC("ID",CodeRowid)),"^",2)
		..s i=i+1
		..i i=1 d 
		...s MRDiagnos1=ICDCode
		...s MRDiagnos1Desc=ICDDesc
		..i i=2 
		...s MRDiagnos2=ICDCode
		...s MRDiagnos2Desc=ICDDesc
		..i i=3 
		...s MRDiagnos3=ICDCode
		...s MRDiagnos3Desc=ICDDesc
		d obj.Close()
	}
	s Para="<safe>"
	s Para=Para_"<doctor_information job_number='"_DocCode_"' date='"_CurentDate_" "_CurentTime_"' />"
	s Para=Para_"<doctor_name>"_DocName_"</doctor_name>"
	s Para=Para_"<doctor_type>"_DocProvCode_"</doctor_type>"
	s Para=Para_"<department_code>"_EpisodeLocCode_"</department_code>"
	s Para=Para_"<department_name>"_EpisodeLocDesc_"</department_name>"
	s Para=Para_"<case_id>"_PatientNo_"</case_id>"
	s Para=Para_"<inhos_code>"_PaadmAdmNo_"</inhos_code>"
	s Para=Para_"<bed_no>"_BedNo_"</bed_no>"
	if EpisodeType="I" {
		s Para=Para_"<patient_information weight='' height='' birth='"_PatientBirthday_"'>"
		s Para=Para_"<patient_name>"_PatientName_"</patient_name><patient_sex>"_PatientSex_"</patient_sex>"
	}else{
		s Para=Para_"<patient_information weight='' height='' age='"_PatientBirthday_"'>"
		s Para=Para_"<patrent_name>"_PatientName_"</patrent_name><patrent_sex>"_PatientSex_"</patrent_sex>"
	}
	s Para=Para_"<physiological_statms></physiological_statms><boacterioscopy_effect></boacterioscopy_effect>"
	s Para=Para_"<bloodpressure></bloodpressure><liver_clean></liver_clean>"
	if EpisodeType="I" {
		s Para=Para_"<pregnant></pregnant><pdw></pdw>"
	}
	s Para=Para_"<allergic_history><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case></allergic_history>"
	if EpisodeType="I" {
		s Para=Para_"<diagnoses>"
		s Para=Para_"<diagnose type=""0"" name="""_MRDiagnos1Desc_""">"_MRDiagnos1_"</diagnose>"
		s Para=Para_"<diagnose type=""0"" name="""_MRDiagnos2Desc_""">"_MRDiagnos2_"</diagnose>"
		s Para=Para_"<diagnose type=""0"" name="""_MRDiagnos3Desc_""">"_MRDiagnos3_"</diagnose>"
		s Para=Para_"</diagnoses>"
	}else{
		s Para=Para_"<diagnoses><diagnose>"_MRDiagnos1_"</diagnose><diagnose>"_MRDiagnos2_"</diagnose><diagnose>"_MRDiagnos3_"</diagnose><diagnose>"_MRDiagnosedat_"</diagnose><diagnose>"_MRDiagnosedat_"</diagnose><diagnose>"_MRDiagnosedat_"</diagnose></diagnoses>"
	}
	s Para=Para_"</patient_information>"
	
	s Para=Para_"<prescriptions>"
	s Para3=""
	s GroupNumber=""
	s ItmCount=$l($g(OrderStr),"^")
	FOR i=1:1:ItmCount {
	    s OrderStr1=$P(OrderStr,"^",i)
	    Q:OrderStr1=""
	    s ItmID=$P(OrderStr1,"!",1)
	    s DoseQty=$P(OrderStr1,"!",2)
	    s DoseQtyUOM=$P(OrderStr1,"!",3)
	    s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)
	    //频次
	    s Freq=$P(OrderStr1,"!",4)
	    i Freq'="" {
		    s FreqFac=$P($G(^PHCFR(Freq)),"^",2)
		    s FreqCode=$P($G(^PHCFR(Freq)),"^",1)
		}else{
		    s FreqFac=1
		    s FreqCode=""
	    }
	    //疗程
	    s Durationdr=$P(OrderStr1,"!",5)
		i Durationdr'="" {
			s Duration=$p(^PHCDU(Durationdr),"^",2)
		}else{
			s Duration=1
		}
		//用法
	    s Instr=$P(OrderStr1,"!",6)
	    i Instr'="" s InstrCode=$P($G(^PHCIN(Instr)),"^",1) 
	    e  s InstrCode=""
	    
	    s DrgFormRowid=$P(OrderStr1,"!",7)
	    s GroupNumber=$P(OrderStr1,"!",8)
	    
	    //医嘱优先级
	    s PriorType="T"
	    s PriorRowId=$P(OrderStr1,"!",9)
	    i PriorRowId'="" {
		    s PriorCode=$P(^OECPR(PriorRowId),"^",1)
		    if (PriorCode="S")!(PriorCode="OMST") s PriorType="L"
	    }
	    //医嘱开始日期
	    s StartDate=$P(OrderStr1,"!",10)
	    i $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	    i $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	    i StartDate="" s StartDate=$zd(+$h,3)
	    e  s StartDate=$zd(StartDate,3)
	    //医嘱开始时间
	    s StartTime=$P(OrderStr1,"!",11)
	    i StartTime[":" s StartTime=$zth(StartTime,1)
	    i StartTime="" s StartTime=$zt($p($h,",",2))
	    e  s StartTime=$zt(StartTime)
	    //医嘱Rowid
	    s OEORIRowid=$P(OrderStr1,"!",12)
	    s PrescNo=""
	    i OEORIRowid'="" {
		    //如果处方不存在则取预生成的处方号,现在仅协和有预生成的处方号
		    s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		    i PrescNo="" s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),"DHC")),"^",20)
	    }
	    i PrescNo="" s PrescNo=PaadmAdmNo
	    	    
	    i DrgFormRowid'="" {
			s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
			s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
			s DrgDesc=..FormatDrgDesc(DrgDesc)
			s drgform1=+DrgFormRowid
			s drgform2=$p(DrgFormRowid,"||",2)
		 	s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",0))
		 	i leq'="" {
		 		s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
		 		s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
		 		i eqUom'=DoseQtyUOM {
		 			s DoseQty=DoseQty*eqqty
		 			s DoseQtyUOMDesc=$p(^CT("UOM",eqUom),"^",2)
		 		}
		 	}
		 	s Para2="<prescription id='"_PrescNo_"' type='mz' current='1' >"
		 	if EpisodeType="I" {
			 	s Para2="<prescription id='"_PaadmAdmNo_"' type="""_PriorType_""">"
		 	}
		 	s Para3=Para3_Para2
			s Para3=Para3_"<medicine suspension='false' judge='true'>"
			s Para3=Para3_"<group_number>"_GroupNumber_"</group_number>"
			s Para3=Para3_"<general_name>"_DrgDesc_"</general_name>"
			s Para3=Para3_"<license_number>"_DrgCode_"</license_number>"
			s Para3=Para3_"<medicine_name>"_DrgDesc_"</medicine_name>"
			s Para3=Para3_"<single_dose coef='1'>"_DoseQty_"</single_dose>"
		 	if EpisodeType="I" {
				s Para3=Para3_"<frequency>"_FreqCode_"</frequency>"
		 	}
			s Para3=Para3_"<times>"_FreqFac_"</times>"
			if EpisodeType'="I" { 
				s Para3=Para3_"<days>"_Duration_"</days>"
			}
			s Para3=Para3_"<unit>"_DoseQtyUOMDesc_"</unit>"
			s Para3=Para3_"<administer_drugs>"_InstrCode_"</administer_drugs>"
			if EpisodeType="I" {
				s begintime=StartDate_" "_StartTime
				s Para3=Para3_"<begin_time>"_begintime_"</begin_time><end_time>"_"</end_time>"
				s Para3=Para3_"<prescription_time>"_begintime_"</prescription_time>"
			}
			s Para3=Para3_"</medicine>"
			s Para3=Para3_"</prescription>"
	    }
	}

	if EpisodeType="I" {
		s Para3=Para3_$$GetIPTodaySavedPresc()
	}
	b ;3
	if (Para3=""){
	    s Para3=Para3_"<prescription id='新开处方1' type='mz' current='1' >"
	    s Para3=Para3_"<medicine suspension='false' judge='true'>"
		s Para3=Para3_"<group_number>"_"</group_number>"
		s Para3=Para3_"<general_name>"_"</general_name>"
		s Para3=Para3_"<license_number>"_"</license_number>"
		s Para3=Para3_"<medicine_name>"_"</medicine_name>"
		s Para3=Para3_"<single_dose coef='1'>"_"</single_dose>"
		s Para3=Para3_"<times>"_"</times>"
		s Para3=Para3_"<days>"_"</days>"
		s Para3=Para3_"<unit>"_"</unit>"
		s Para3=Para3_"<administer_drugs>"_"</administer_drugs>"
		s Para3=Para3_"<begin_time></begin_time><end_time></end_time><prescription_time></prescription_time>"

		s Para3=Para3_"</medicine>"_"</prescription>"
	}else{
		//s Para2="<prescription id='新开处方1' type='mz' current='1' >"
		//s Para3=Para2_Para3_"</prescription>"
		
	}
	s Para=Para_Para3_"</prescriptions></safe>"
	Quit Para
GetIPTodaySavedPresc()
 s Para4=""
 Set childsub=0 for {
	s childsub=$O(^OEORDi(0,"StDt",+$H,OrderRowid,childsub))
	Quit:childsub=""
	s ItmID=$P(^OEORD(OrderRowid,"I",childsub,1),"^",2)
	
	s OrderType=""
	s subCATEG=$p($g(^ARCIM(+ItmID,1,1)),"^",10)
	i subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	if OrderType'="R" continue
	
	s DoseQty=$P(OrderStr1,"!",2)
	s DoseQtyUOM=$P(OrderStr1,"!",3)
	s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)

 i Freq'="" {
	    s FreqFac=$P($G(^PHCFR(Freq)),"^",2)
	    s FreqCode=$P($G(^PHCFR(Freq)),"^",1)
	}else{
	    s FreqFac=1
	    s FreqCode=""
 }
	
	s Durationdr=$P(OrderStr1,"!",5)
	s Duration=$p(^PHCDU(Durationdr),"^",2)
	s Instr=$P(OrderStr1,"!",6)
	i Instr'="" s InstrCode=$P($G(^PHCIN(Instr)),"^",1) 
	e  s InstrCode=""
	
	s DrgFormRowid=$p($g(^ARCIM(+ItmID,$p(ItmID,"||",2),1)),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	s LinkItemId=$P(^OEORD(OrderRowid,"I",childsub,11),"^",39)
	if LinkItemId'="" s GroupNumber=$P(^OEORD(+LinkItemId,"I",$p(LinkItemId,"||",2),3),"^",4)
	e  s GroupNumber=$P(^OEORD(OrderRowid,"I",childsub,3),"^",4)
	
	s PriorRowId=$P(^OEORD(OrderRowid,"I",childsub,1),"^",8)
	s PriorType="T"
	i PriorRowId'="" {
	    s PriorCode=$P(^OECPR(PriorRowId),"^",1)
	    if (PriorCode="S")!(PriorCode="OMST") s PriorType="L"
	}
	s OrderStartDate=$P(^OEORD(OrderRowid,"I",childsub,1),"^",9)
	if OrderStartDate="" s OrderStartDate=+$h
	s OrderStartTime=$P(^OEORD(OrderRowid,"I",childsub,1),"^",10)
	if OrderStartTime="" s OrderStartTime=$p($h,",",2)
	s OrderStartDate=$zd(OrderStartDate,3)
	s OrderStartTime=$zt(OrderStartTime,1)
	s CurrentOrderFillerNoStr=$p($g(^OEORD(OrderRowid,"I",childsub,9)),"^",12)
	s CurrentOrderFillerNo=$p(CurrentOrderFillerNoStr,"!!",1)
	i CurrentOrderFillerNo'="" {
		s FirstOrderOrd=$p(CurrentOrderFillerNo,"||",1)
		s FirstOrderChl=$p(CurrentOrderFillerNo,"||",2)
		s OrderStartDate=$P(^OEORD(FirstOrderOrd,"I",FirstOrderChl,1),"^",9)
		if OrderStartDate="" s OrderStartDate=+$h
		s OrderStartTime=$P(^OEORD(FirstOrderOrd,"I",FirstOrderChl,1),"^",10)
		if OrderStartTime="" s OrderStartTime=$p($h,",",2)
		s OrderStartDate=$zd(OrderStartDate,3)
		s OrderStartTime=$zt(OrderStartTime,1)
	}
	s OrderStatusDR=$p($g(^OEORD(OrderRowid,"I",childsub,1)),"^",13)
	s OrderStatusCode=$p($g(^OEC("OSTAT",OrderStatusDR)),"^",1)
	continue:OrderStatusCode="U"
	s EndDate="",EndTime="",endDattime=""
	i OrderStatusCode="D" {
		s EndDate=$P($g(^OEORD(OrderRowid,"I",childsub,3)),"^",34)
		i EndDate'="" s EndDate=$zd(EndDate,3)
		s EndTime=$P($g(^OEORD(OrderRowid,"I",childsub,2)),"^",15)
		i EndTime'="" s EndTime=$zt(EndTime,1)
	}
	i EndDate'="" s endDattime=EndDate_" "_EndTime
	
	i DrgFormRowid'="" {
		s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
		s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
		s DrgDesc=..FormatDrgDesc(DrgDesc)
		s drgform1=+DrgFormRowid
		s drgform2=$p(DrgFormRowid,"||",2)
		s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",0))
		i leq'="" {
			s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
			s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
			;b ;eqUom,eqqty
			i eqUom'=DoseQtyUOM {
				s DoseQty=DoseQty*eqqty
				s DoseQtyUOMDesc=$p(^CT("UOM",eqUom),"^",2)
			}
		}

		s Para5=""
	 	s Para5="<prescription id='"_PaadmAdmNo_"' type="""_PriorType_""">"
		s Para5=Para5_"<medicine suspension='false' judge='true'>"
		s Para5=Para5_"<group_number>"_GroupNumber_"</group_number>"
		s Para5=Para5_"<general_name>"_DrgDesc_"</general_name>"
		s Para5=Para5_"<license_number>"_DrgCode_"</license_number>"
		s Para5=Para5_"<medicine_name>"_DrgDesc_"</medicine_name>"
		s Para5=Para5_"<single_dose coef='1'>"_DoseQty_"</single_dose>"
		s Para5=Para5_"<frequency>"_FreqCode_"</frequency>"
		s Para5=Para5_"<times>"_FreqFac_"</times>"
		s Para5=Para5_"<unit>"_DoseQtyUOMDesc_"</unit>"
		s Para5=Para5_"<administer_drugs>"_InstrCode_"</administer_drugs>"
		s begintime=OrderStartDate_" "_OrderStartTime
		s Para5=Para5_"<begin_time>"_begintime_"</begin_time><end_time>"_endDattime_"</end_time>"
		s Para5=Para5_"<prescription_time>"_begintime_"</prescription_time>"
		s Para5=Para5_"</medicine>"
		s Para5=Para5_"</prescription>"
		
		i Para4="" s Para4=Para5
		e  s Para4=Para4_Para5
 }
 }
 Q Para4
}

/// 大通分析保存程序
/// OEOrdItemIDs:已经保存的医嘱串
/// w ##class(web.DHCandDaTongInterface).GetSavePrescXML("2123||1^2123||2^2123||3","196308","DH777777","3879")
ClassMethod GetSavePrescXML(OEOrdItemIDs As %String, EpisodeID As %String, DocCode As %String, UserID As %String) As %String
{
	s ^tmpgry("GetSavePrescXML",1)=OEOrdItemIDs_","_EpisodeID_","_DocCode_","_UserID
	s SavePrescXML=""
	Q:OEOrdItemIDs="" SavePrescXML
	s OrderStr=""
	f i=1:1:$l(OEOrdItemIDs,"^")-1 {
		s newOrdIdDR=$p($p(OEOrdItemIDs,"^",i),"*",2)
		i newOrdIdDR="" continue
		s newOrd=+newOrdIdDR
		s newChl=$p(newOrdIdDR,"||",2)
		s OrderARCIMRowid=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",2)
		s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P($g(^ARC("IC",ItemCatRowid)),"^",7)
		continue:OrderType'="R"
		s OrderDoseQty=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",1)
		s OrderDoseUOMRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",3)
		s OrderFreqRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",4)
		s OrderDurRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",6)
		s OrderInstrRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",7)
		s OrderDrugFormRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",12)
		i OrderDrugFormRowid=-1 s OrderDrugFormRowid=""
		s MasterSeqNo=$p($g(^OEORD(newOrd,"I",newChl,3)),"^",4)
		i MasterSeqNo["." s MasterSeqNo=$p(MasterSeqNo,".")
		s OrderPriorRowid=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",8)
		s OrderStartDate=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",9)
		s OrderStartTime=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",10)
		s OEORIRowid=newOrdIdDR
		i OrderStr="" s OrderStr=OrderARCIMRowid_"!"_OrderDoseQty_"!"_OrderDoseUOMRowid_"!"_OrderFreqRowid_"!"_OrderDurRowid_"!"_OrderInstrRowid_"!"_OrderDrugFormRowid_"!"_MasterSeqNo_"!"_OrderPriorRowid_"!"_OrderStartDate_"!"_OrderStartTime_"!"_OEORIRowid
		e  s OrderStr=OrderStr_"^"_OrderARCIMRowid_"!"_OrderDoseQty_"!"_OrderDoseUOMRowid_"!"_OrderFreqRowid_"!"_OrderDurRowid_"!"_OrderInstrRowid_"!"_OrderDrugFormRowid_"!"_MasterSeqNo_"!"_OrderPriorRowid_"!"_OrderStartDate_"!"_OrderStartTime_"!"_OEORIRowid
	}
	s Para=..GetPrescXML(OrderStr,EpisodeID,DocCode,UserID)
	s ^tmpgry("GetSavePrescXML","Para")=Para
	Q Para
}

}
