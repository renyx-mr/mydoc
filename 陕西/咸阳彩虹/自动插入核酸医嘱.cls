;renyx 添加核算检测号自动插入医嘱
	;配置串：号别id！医嘱项id！数量！科室id！开医嘱用户id！用法id
	s RegisterInsertArcItem=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","RegisterInsert")
	if (RegisterInsertArcItem'=""){
		for ArcItemInd=1:1:$l(RegisterInsertArcItem,","){
			s OneArcItemInfo=$p(RegisterInsertArcItem,",",ArcItemInd)
			continue:OneArcItemInfo=""
			continue:$p(OneArcItemInfo,"!",2)=""
			continue:AdmDoc'=$p(OneArcItemInfo,"!",1)
			continue:AdmDep'=$p(OneArcItemInfo,"!",4)
			s OnePackQty=$p(OneArcItemInfo,"!",3)
			s:OnePackQty="" OnePackQty="1"
			d ##class(web.DHCOPAdmRegLocal).InsertCovi19Order(EpisodeID,AdmDep,$p(OneArcItemInfo,"!",5),$p(OneArcItemInfo,"!",2),"",$p(OneArcItemInfo,"!",6),OnePackQty)
		}
	}
;修改退号
 w ##class(web.DHCOPAdmReg).CheckAdmDiagnos(4353)
 .s OtherFlags=$p($g(^OEORD(OrderRowId,"I",OrderChild,"DHC")),"^",23)
	.s OrdBilled=$p($g(^OEORD(OrderRowId,"I",OrderChild,3)),"^",5)
	.q:(OtherFlags="Reg")&&(OrdBilled'="P")
///核酸诊断
ClassMethod InsertCovi19MRDiagnos(EpisodeID, UserID, ICDRowID){
		s AdmDep=$P(^PAADM(EpisodeID),"^",4)
		s mrrowid=$p($G(^PAADM(EpisodeID)),"^",61)
		s MRDIAID=##class(web.DHCMRDiagnos).InsertMRDiagnos(AdmDep,mrrowid,ICDRowID,UserID,"","门诊诊断","","","","","","","","")
		if (+MRDIAID'=0){
			s Rtn=##class(web.DHCMRDiagnos).UpdateOnsetDate(MRDIAID,$ZD(+$H,3))
		}
}
/// 插入核酸医嘱
ClassMethod InsertCovi19Order(EpisodeID As %String, LocID As %String, UserID As %String, ARCIMRowID As %String, OrderLabSpecRowid As %String = "", OrderInstrRowid As %String = "", OrderPackQty As %String = "")
{
	q:EpisodeID="" ""
	s i=1
	s Number=1
	s ^TMP("InsertCovi19Order")=$Lb(EpisodeID,LocID,UserID,ARCIMRowID,OrderLabSpecRowid,OrderInstrRowid,OrderInstrRowid)
	Set OrderItemStr=""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	s AdmDep=$P(^PAADM(EpisodeID),"^",4)
	s OrderARCIMRowid=ARCIMRowID
	s OrderPackQty=OrderPackQty
	if (OrderPackQty="")  s OrderPackQty=1
	s ItemCatDr=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",10) 
	s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	s OrderPriorRowid=3
	s OrderStartDate=$zd($h,3)
	s OrderStartTime=$zt($P($h,",",2))
	s OrderPrice=""
	s GetLocRecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocID,OrderARCIMRowid)
	if (GetLocRecLocStr'=""){
		s OrderRecDepRowid=$P(GetLocRecLocStr,$c(1),1)
		s Len1=$l(GetLocRecLocStr,$c(2))
		for j=1:1:Len1{
			s OneLocRecStr=$P(GetLocRecLocStr,$C(2),j)
			s Defultflag=$p(OneLocRecStr,$C(1),3)
			if (Defultflag="Y"){
				s OrderRecDepRowid=$P(OneLocRecStr,$c(1),1)
				}
		}
	}
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s AdmReason=$P(^PAADM(EpisodeID,1),"^",7)
	s BillTypeRowid=AdmReason
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
	s OrderDrugFormRowid="",OrderDoseQty="",OrderDoseUOMRowid="",OrderFreqRowid="",OrderDurRowid=""
	s PHPrescType=""
	s OrderQtySum=OrderPackQty
	s OrderInstrRowid=OrderInstrRowid
	s OrderDepProcNotes=""
	s OrderMasterSeqNo=""
	Set ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	s OrderSeqNo=$$GetSeqNo^DHCDocOrderCommonNew(ord,+$h)+Number
	s OrderSkinTest="N"
	s OrderPhSpecInstr=""
	s OrderCoverMainIns=""
	s OrderActionRowid=""
	s OrderARCOSRowid=""
	s OrderEndDate=""
	s OrderEndTime=""
	s OrderLabSpecRowid=OrderLabSpecRowid
	if (OrderLabSpecRowid=""){
		s OrderLabSpecRowid=##class(web.DHCDocOrderCommon).GetLabSpec(OrderARCIMRowid)
		s OrderLabSpecRowid=$p(OrderLabSpecRowid,$c(3),1)
	}
	s OrderDurRowid=""
	s OrderItem=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate_"^"_OrderStartTime_"^"_OrderPackQty_"^"_OrderPrice
	s OrderItem=OrderItem_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
	s OrderItem=OrderItem_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
	s OrderItem=OrderItem_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
	s OrderItem=OrderItem_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid
	s OrderItemStr=OrderItem
	if (OrderItemStr'=""){
		s rtn=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,OrderItemStr,UserID,AdmDep,DocID)
		f i=1:1:$L(rtn,"^") 
		{
			S OneOrderStr=$P(rtn,"^",i)
			s oeitm=$P(OneOrderStr,"*",2)
			Continue:oeitm=""
			&SQL(Update SQLUser.OE_OrdItemExt set OEORI_OtherFlags="Reg" where OEORI_rowid=:oeitm)

			}
		}
	q 0
}
// 退费接口
/// d ##class(web.DHCOPAdmRegLocal).CancelOPRegistFee("303407")
ClassMethod CancelOPRegistFee(RegFeeRowId As %String)
{
	
	s ^TEMPQjh("CancelOPRegistFee")=RegFeeRowId
	s AdmId="",CreateUserDr="",InvoiceId=""
	&SQL(Select RegfeeAdmDr,RegfeeUserDr,Regfeetemp1
	   into :AdmId,:CreateUserDr,:InvoiceId
	   from SQLUser.DHCRegistrationFee 
	  Where %Id=:RegFeeRowId)
	s CreateUserCode=""
	s:CreateUserDr'="" CreateUserCode=$p($g(^SSU("SSUSR",CreateUserDr)),"^",1)
	if (CreateUserCode="HLWYH"){
		//s 
		s PatientID=$p($g(^PAADM(AdmId)),"^",1)
		s InputObj={}
		// patientIdTypeId int 是 患者 ID 类型(1-预 留 2-预留 3-身份证号) 3
		/// patientId string 是 患者 ID 110111188605069875
		// billId string 是 账单 ID，HIS 系 统内部的账单标识2003001
		// comment string 否 备注，例如退款 CT 检查取消
		
		s InputObj.patientIdTypeId="3"
		s InputObj.patientId=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
		b ;;;;
		s HISTradeID=##class(web.DHCOPAdmRegLocal).GetHISTradeID(InvoiceId)
		s InputObj.billId=HISTradeID
		b ;;;;;;;;;;-----
		s InputObj.comment="门诊窗口退挂号费"
		s InputStream=##class(%GlobalCharacterStream).%New()
		s InputJson=InputObj.%ToJSON()
		d InputStream.Write(InputJson)
		s RetStr= ##class(web.DHCENS.EnsHISService).SendMessageInfo22("MES0100",InputStream)
		b ;;w RetStr.Read()
	}
	q "0"
}

/// w ##class(web.DHCOPAdmRegLocal).GetHISTradeID(769627)
/// /通过第三方交易流水表的ETPHisPrtStr，获取ETP_HISTradeID
/// add qjh  2021-05-20
ClassMethod GetHISTradeID(ETPHisPrtStr As %String)
{
	s HISTradeID=""
	&SQL(SELECT ETP_HISTradeID  
	   into :HISTradeID
	   FROM SQLUser.DHC_BillExtTradePay 
	   WHERE  ETP_HisPrtStr=:ETPHisPrtStr)
	  q HISTradeID
}