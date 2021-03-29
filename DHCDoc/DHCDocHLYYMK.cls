/// 美康合理用药的后台数据获取类
Class web.DHCDocHLYYMK Extends web.DHCDocHLYY
{

/// w ##class(web.DHCHLYY).GetPrescInfo(8697,"265||1!0.5!109!4!63!8!265||1!5!1!1!","测试医生")
///  8697,265||1!0.5!109!4!63!8!265||1!5!1!1!,测试医生
///  ,26||1!0.2!109!5!63!2!26||1!3!3^1490||1!10!139!40!63!2!1490||1!3!4,唐骅		
ClassMethod GetPrescInfo(EpisodeID As %String, OrderStr As %String, DocName As %String)
{
	s ^zhou("GetPrescInfo")=EpisodeID_","_OrderStr_","_DocName
	;w ##class(web.DHCHLYY).GetPrescInfo(1995,"15923||1!25!1719!3!1!20!466||1!5^15923||1!25!1719!3!1!20!466||1!5","梁占光")
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 	i (PAAdmType="I") {
		s IPOrders=..GetIPOrders(EpisodeID)
		//s OrderStr=OrderStr_"^"_IPOrders
 	}
 s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
 s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)
 s EpisodeDate=$p($g(^PAADM(EpisodeID)),"^",6)
 s EpisodeDate=$ZD(EpisodeDate,3)
 s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
 s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
 s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
 &SQL(Select PAPMI_No into :PatientNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
 s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
 s PatientBirthday=$ZD($G(PatientDOB),3)
	s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
 if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
	else  s PatientSex=""
	s Height=""
	s Weight=""
	s OutTime=""
	s VisitID=""
	s UseTime=""
	
	s PatInfo=PatientID_"^"_PatientName_"^"_PatientSex_"^"_PatientBirthday
	s PatInfo=PatInfo_"^"_UseTime_"^"_Height_"^"_Weight_"^"_VisitID_"^"_EpisodeLocDesc_"^"_DocName_"^"_OutTime

	s AllergenInfo=""
	s sub=0  f  s sub=$o(^PAPER(PatientID,"ALG",sub)) Q:sub=""  d
	.s allergicRowid=$P(^PAPER(PatientID,"ALG",sub),"^",9)
	.i allergicRowid'="" d
	..s allergicCode=$p(^PAC("ALG",allergicRowid),"^",1)
	..s allergicDesc=$p(^PAC("ALG",allergicRowid),"^",2)
	..s AllergenType="USER"
	..s AllergenReaction=""
	..s Allergen=allergicCode_"^"_allergicDesc_"^"_AllergenType_"^"_AllergenReaction
	..i AllergenInfo="" s AllergenInfo=Allergen
	..e  s AllergenInfo=AllergenInfo_$C(1)_Allergen

	s MedCondInfo=""
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmRowid'="" {
		s i=0
		s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For  Quit:'obj.Next()  Do
		.s Desc=obj.Data("MRDIAICDCodeDRDesc")
		.s Rowid=obj.Data("ID")
		.s CodeRowId=obj.Data("MRDIAICDCodeDR")
		.Q:CodeRowId=""   ;lgl+诊断只填描述也能过去导致
		.i CodeRowId'="" d
		..s Code=$P(^MRC("ID",CodeRowId),"^",4)
		..s Code=$tr(Code,$c(0),"")
		..s MedCondType=""
		..s MedCondStopDate=""
		..s MedCondStartDate=""
		..s VocabTypeCode=""
		..s MedCondType="USER"
		..s MedCond=Code_"^"_Desc_"^"_MedCondType_"^"_MedCondStartDate_"^"_MedCondStopDate_"^"_VocabTypeCode
		..i MedCondInfo="" s MedCondInfo=MedCond
		..e  s MedCondInfo=MedCondInfo_$C(1)_MedCond
		d obj.Close()
	}
	
	s OrderInfo=""
	s GroupNumber=1
	s ItmCount=$l($g(OrderStr),"^")
 	FOR i=1:1:ItmCount {
	    s OrderStr1=$P(OrderStr,"^",i)
	    Q:OrderStr1=""
	    s ItmID=$P(OrderStr1,"!",1)
	    s ItmCode=$P(^ARCIM(+ItmID,$P(ItmID,"||",2),1),"^",1)
	    s ItmDesc=$P(^ARCIM(+ItmID,$P(ItmID,"||",2),1),"^",2)
	    s DoseQty=$P(OrderStr1,"!",2)
	    s DoseQtyUOM=$P(OrderStr1,"!",3)
	    s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)
	    s Freq=$P(OrderStr1,"!",4)
	    i Freq'="" {
		    s FreqFac=$P($G(^PHCFR(Freq)),"^",2)
		    s FreqDays=$P($G(^PHCFR(Freq)),"^",5)
		    //i (FreqDays="")||(FreqDays=1) s FreqCode=FreqFac
		    //e  s FreqCode=FreqFac_"/"_FreqDays
		    i FreqFac="" s FreqCode=1
		    i FreqDays="" s FreqDays=1
		    s FreqCode=FreqFac_"/"_FreqDays
		}else{
			s FreqFac=1,FreqCode=""
		}
		s Durationdr=$P(OrderStr1,"!",5)
		i Durationdr'="" s Duration=$p(^PHCDU(Durationdr),"^",2)
		e  s Duration=1
	    s Instr=$P(OrderStr1,"!",6)
	    i Instr'="" {
		    s InstrCode=$P($G(^PHCIN(Instr)),"^",1)
		    s InstrDesc=$P($G(^PHCIN(Instr)),"^",2)
		    s:InstrCode["-" InstrCode=$p(InstrCode,"-",2)
		    s:InstrDesc["-" InstrDesc=$p(InstrDesc,"-",2)
	    }else{
		    s InstrCode=""
		    s InstrDesc=""
	    }
	    s DrgFormRowid=$P(OrderStr1,"!",7)
	    s PriorRowId=$P(OrderStr1,"!",8)
	    s SeqNo=$P(OrderStr1,"!",9)
	    s RowIndex=$P(OrderStr1,"!",10)
	    s OrderMasterSeqNo=$P(OrderStr1,"!",11)
	    s OrderPackQty=$P(OrderStr1,"!",12)
	    s OrderPackUOMRowid=$P(OrderStr1,"!",13)
	    i OrderMasterSeqNo'="" s GroupNumber=OrderMasterSeqNo
	    e  s GroupNumber=SeqNo
	    s OrderStartDate=$ZD(+$H,3)
	    s OrderEndDate=""
		/*
		s DoseQtyUOMDesc=""
		i DrgFormRowid'="" {
		s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
		s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
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
		s DoseQtyUOMDesc=$ZCVT(DoseQtyUOMDesc,"L")
		}
		}
		*/
		s Priority=1
		if PriorRowId'="" {
		        s PriorCode=$P(^OECPR(PriorRowId),"^",1)
		        if PriorCode="S" s Priority=0
		}
		s OrderPackUOM=""
		i +OrderPackUOMRowid'=0 s OrderPackUOM=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)

		s Order=SeqNo_"^"_ItmCode_"^"_ItmDesc_"^"_DoseQty_"^"_DoseQtyUOMDesc_"^"_FreqCode
		s Order=Order_"^"_OrderStartDate_"^"_OrderStartDate_"^"_InstrDesc_"^"_InstrDesc_"^"_GroupNumber
		s Order=Order_"^"_Priority_"^"_DocName_"^"_DoseQty_"^"_RowIndex_"^"_OrderPackQty_"^"_OrderPackUOM
		i OrderInfo="" s OrderInfo=Order
		e  s OrderInfo=OrderInfo_$C(1)_Order
	}
	Q PatInfo_$C(2)_MedCondInfo_$C(2)_AllergenInfo_$C(2)_OrderInfo
}

/// w ##class(web.DHCHLYY).GetIPOrders(8697)
ClassMethod GetIPOrders(EpisodeID As %String)
{
	s OrderStr=""
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	
	s ChildSub=0
	f  s ChildSub=$o(^OEORDi(0,"StDt",+$h,OrderRowid,ChildSub)) q:ChildSub=""  d 
	.q:'$d(^OEORD(OrderRowid,"I",ChildSub))         ;
	.s OrderARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)		;OEORI_ItmMast_DR
	.s ARCIMSubScript=$p(OrderARCIMRowid,"||",1)
	.s ARCIMSubVersion=$p(OrderARCIMRowid,"||",2)
	.s OrderName=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)     
	.s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)  ;ARCIM_ItemCat_DR  
	.s OrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
	.q:OrderType'="R"  
	.s OrderStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ChildSub,1),"^",13)),"^",1)            
	.q:((OrderStatus="I")||(OrderStatus="U")||(OrderStatus="D"))
	.s OrderDoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)	;OEORI_DoseQty
	.s OrderDoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;OEORI_Unit_DR
	.q:OrderDoseUOMRowid=""  //yury20131230add
	.s OrderDoseUOM=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2)				;剂量单位
	.s OrderFreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)		;OEORI_PHFreq_DR
	.s OrderInstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)		;OEORI_Instr_DR
	.s OrderDurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
	.s OrderDrugFormRowid=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",12)  ;
	.s OrderPriorRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8) ;OEORI_Priority_DR  //
	.s OrderSeqNo=$p(^OEORD(OrderRowid,"I",ChildSub,3),"^",4)
	.i OrderSeqNo["."  d
	..s OrderSeqNo=$p(OrderSeqNo,".",1)
	..s OrderMasterSeqNo=$p(OrderSeqNo,".",1)
	.e  d
	..s OrderMasterSeqNo=""
	.s OrderRowNum=""
	
	.s Para1=OrderARCIMRowid_"!"_OrderDoseQty_"!"_OrderDoseUOMRowid
    .s Para1=Para1_"!"_OrderFreqRowid_"!"_OrderDurRowid_"!"_OrderInstrRowid_"!"_OrderDrugFormRowid_"!"_OrderPriorRowid_"!"_OrderSeqNo_"!"_OrderRowNum_"!"_OrderMasterSeqNo
	.i OrderStr="" s OrderStr=Para1
	.e  s OrderStr=OrderStr_"^"_Para1
	
	s ^DHCXPTest("GetIPOrders")="EpisodeID"_","_OrderStr
	
	q OrderStr
}

}
