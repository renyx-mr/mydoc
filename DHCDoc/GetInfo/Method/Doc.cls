/// 名称:    DHCDoc.GetInfo.Method.Doc
/// 描述:    医生（诊断、医嘱）相关信息获取公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
/// 继承:
Class DHCDoc.GetInfo.Method.Doc Extends %RegisteredObject
{

/// 描述:    医嘱相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.23
/// w ##class(DHCDoc.GetInfo.Method.Doc).GetOrdInfo()
ClassMethod GetOrdInfo(OEORIRowID As %String) As DHCDoc.GetInfo.Entry.OEOrdItem
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.OEOrdItem).%New()
	s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID)
	if $ISOBJECT(OrdObj) {
		s OutputObj.OEORIRowId=OEORIRowID
		s OutputObj.ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
		Q:(OutputObj.ARCIMRowId="") OutputObj
		s ArcItmObj=##class(User.ARCItmMast).%OpenId(OutputObj.ARCIMRowId)
		s OutputObj.ARCIMCode=ArcItmObj.ARCIMCode
		s OutputObj.ARCIMDesc=ArcItmObj.ARCIMDesc
		do ArcItmObj.%Close()
		s OutputObj.OEORIOrdDeptDR=OrdObj.OEORIOrdDeptDR
		if $ISOBJECT(OutputObj.OEORIOrdDeptDR) {
			s OutputObj.OEORIOrdDeptDR=OrdObj.OEORIOrdDeptDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIOrdDeptDR)
			if $ISOBJECT(LocObj) {
				s OutputObj.OEORIOrdDeptCode=LocObj.CTLOCCode
			    s OutputObj.OEORIOrdDeptDesc=LocObj.CTLOCDesc
			    do LocObj.%Close()
			}
		}
		s OutputObj.OEORIPrescType=OrdObj.OEORIPrescType
		s OutputObj.OEORIItemStatDR=OrdObj.OEORIItemStatDR.%Id()
		s OECStatusObj=##class(User.OECOrderStatus).%OpenId(OutputObj.OEORIItemStatDR)
		if $ISOBJECT(OECStatusObj) {
		   s OutputObj.OEORIItemStatCode=OECStatusObj.OSTATCode
		   s OutputObj.OEORIItemStatDesc=OECStatusObj.OSTATDesc
		   do OECStatusObj.%Close()
		}
		
		s OutputObj.OEORIDoctorDR=OrdObj.OEORIDoctorDR
		if $ISOBJECT(OutputObj.OEORIDoctorDR){
			s OutputObj.OEORIDoctorDR=OrdObj.OEORIDoctorDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIDoctorDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIDoctorCode=DocObj.CTPCPCode
			   s OutputObj.OEORIDoctorDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
			
		}
		s OutputObj.OEORISttDat=OrdObj.OEORISttDat
		s OutputObj.OEORISttTim=OrdObj.OEORISttTim
		s OutputObj.OEORIPriorityDR=OrdObj.OEORIPriorityDR.%Id()
		s OECPriorityObj=##class(User.OECPriority).%OpenId(OutputObj.OEORIPriorityDR)
		if $ISOBJECT(OECPriorityObj) {
		   s OutputObj.OEORIPriorityCode=OECPriorityObj.OECPRCode
		   s OutputObj.OEORIPriorityDesc=OECPriorityObj.OECPRDesc
		   do OECPriorityObj.%Close()
		}
		s OutputObj.OEORIPHFreqDR=OrdObj.OEORIPHFreqDR
		if $ISOBJECT(OutputObj.OEORIPHFreqDR){
			s OutputObj.OEORIPHFreqDR=OrdObj.OEORIPHFreqDR.%Id()
			s FreqObj=##class(User.PHCFreq).%OpenId(OutputObj.OEORIPHFreqDR)
			if $ISOBJECT(FreqObj) {
			   s OutputObj.OEORIPHFreqCode=FreqObj.PHCFRCode
			   s OutputObj.OEORIPHFreqDesc=FreqObj.PHCFRDesc1
			   do FreqObj.%Close()
			}
		}
		s OutputObj.OEORIInstrDR=OrdObj.OEORIInstrDR
		if $ISOBJECT(OutputObj.OEORIInstrDR){
			s OutputObj.OEORIInstrDR=OrdObj.OEORIInstrDR.%Id()
			s InstrObj=##class(User.PHCInstruc).%OpenId(OutputObj.OEORIInstrDR)
			if $ISOBJECT(InstrObj) {
			   s OutputObj.OEORIInstrCode=InstrObj.PHCINCode
			   s OutputObj.OEORIInstrDesc=InstrObj.PHCINDesc1
			   do InstrObj.%Close()
			}
		}
		s OutputObj.OEORIUnitDR=OrdObj.OEORIUnitDR
		if $ISOBJECT(OutputObj.OEORIUnitDR){
			s OutputObj.OEORIUnitDR=OrdObj.OEORIUnitDR.%Id()
			s UnitObj=##class(User.CTUOM).%OpenId(OutputObj.OEORIUnitDR)
			if $ISOBJECT(UnitObj) {
			   s OutputObj.OEORIUnitCode=UnitObj.CTUOMCode
			   s OutputObj.OEORIUnitDesc=UnitObj.CTUOMDesc
			   do UnitObj.%Close()
			}
		}
		s OutputObj.OEORIPhQtyOrd=OrdObj.OEORIPhQtyOrd
		s OutputObj.OEORIXDate=OrdObj.OEORIXDate
		s OutputObj.OEORIDuratDR=OrdObj.OEORIDuratDR
		if $ISOBJECT(OutputObj.OEORIDuratDR){
			s OutputObj.OEORIDuratDR=OrdObj.OEORIDuratDR.%Id()
			s DurObj=##class(User.PHCDuration).%OpenId(OutputObj.OEORIDuratDR)
			if $ISOBJECT(DurObj) {
			   s OutputObj.OEORIDuratCode=DurObj.PHCDUCode
			   s OutputObj.OEORIDuratDesc=DurObj.PHCDUDesc1
			   do DurObj.%Close()
			}
		}
		s OutputObj.OEORIRemarks=OrdObj.OEORIRemarks
		s OutputObj.OEORIPhSpecInstr=OrdObj.OEORIPhSpecInstr
		s OutputObj.OEORIBillDesc=OrdObj.OEORIBillDesc
		s OutputObj.OEORIUnitCost=OrdObj.OEORIUnitCost
		s OutputObj.OEORIDRCrossDR=OrdObj.OEORIDRCrossDR
		if $ISOBJECT(OutputObj.OEORIDRCrossDR){
			s OutputObj.OEORIDRCrossDR=OrdObj.OEORIDRCrossDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIDRCrossDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIDRCrossCode=DocObj.CTPCPCode
			   s OutputObj.OEORIDRCrossDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}
		s OutputObj.OEORIXTime=OrdObj.OEORIXTime
		s OutputObj.OEORIQty=OrdObj.OEORIQty
		s OutputObj.OEORIDepType=OrdObj.OEORIDepType
		s OutputObj.OEORILinkToOrder=OrdObj.OEORILinkToOrder
		s OutputObj.OEORIDepProcNotes=OrdObj.OEORIDepProcNotes
		s OutputObj.OEORIInsBillConditDR=OrdObj.OEORIInsBillConditDR
		if $ISOBJECT(OutputObj.OEORIInsBillConditDR){
			s OutputObj.OEORIInsBillConditDR=OrdObj.OEORIInsBillConditDR.%Id()
			s InsuCovObj=##class(User.ARCInsurCoverStatus).%OpenId(OutputObj.OEORIInsBillConditDR)
			if $ISOBJECT(InsuCovObj) {
			   s OutputObj.OEORIInsBillConditCode=InsuCovObj.INSCOVCode
			   s OutputObj.OEORIInsBillConditDesc=InsuCovObj.INSCOVDesc
			   do InsuCovObj.%Close()
			}
		}
		s OutputObj.OEORICoverMainIns=OrdObj.OEORICoverMainIns
		s OutputObj.OEORIPortEquipReq=OrdObj.OEORIPortEquipReq
		s OutputObj.OEORIAdministerSkinTest=OrdObj.OEORIAdministerSkinTest
		s OutputObj.OEORINeedleGaugeDR=OrdObj.OEORINeedleGaugeDR
		if $ISOBJECT(OutputObj.OEORINeedleGaugeDR){
			s OutputObj.OEORINeedleGaugeDR=OrdObj.OEORINeedleGaugeDR.%Id()
			s OECNeedlGObj=##class(User.OECNeedleGauge).%OpenId(OutputObj.OEORINeedleGaugeDR)
			if $ISOBJECT(OECNeedlGObj) {
			   s OutputObj.OEORINeedleGaugeCode=OECNeedlGObj.NEDGCode
			   s OutputObj.OEORINeedleGaugeDesc=OECNeedlGObj.NEDGDesc
			   do OECNeedlGObj.%Close()
			}
		}
		s OutputObj.OEORIIntervalDR=OrdObj.OEORIIntervalDR
		s OutputObj.OEORISpeedFlowValue=OrdObj.OEORISpeedFlowValue
		s OutputObj.OEORINeedleTypeDR=OrdObj.OEORINeedleTypeDR
		if $ISOBJECT(OutputObj.OEORINeedleTypeDR){
			s OutputObj.OEORINeedleTypeDR=OrdObj.OEORINeedleTypeDR.%Id()
			s NeedleTypeObj=##class(User.OECNeedleType).%OpenId(OutputObj.OEORINeedleTypeDR)
			if $ISOBJECT(NeedleTypeObj) {
			   s OutputObj.OEORINeedleTypeCode=NeedleTypeObj.NEDTCode
			   s OutputObj.OEORINeedleTypeDesc=NeedleTypeObj.NEDTDesc
			   do NeedleTypeObj.%Close()
			}
		}
		s OutputObj.OEORIBodySiteDR=OrdObj.OEORIBodySiteDR
		if $ISOBJECT(OutputObj.OEORIBodySiteDR){
			s OutputObj.OEORIBodySiteDR=OrdObj.OEORIBodySiteDR.%Id()
			s BodySiteObj=##class(User.OECBodySite).%OpenId(OutputObj.OEORIBodySiteDR)
			if $ISOBJECT(BodySiteObj) {
			   s OutputObj.OEORIBodySiteCode=BodySiteObj.BODSCode
			   s OutputObj.OEORIBodySiteDesc=BodySiteObj.BODSDesc
			   do BodySiteObj.%Close()
			}
		}
		s OutputObj.OEORIWhoGoWhere=OrdObj.OEORIWhoGoWhere
		s OutputObj.OEORIOperCategoryDR=OrdObj.OEORIOperCategoryDR
		if $ISOBJECT(OutputObj.OEORIOperCategoryDR){
			s OutputObj.OEORIOperCategoryDR=OrdObj.OEORIOperCategoryDR.%Id()
			s OPCategoryObj=##class(User.ORCOperationCategory).%OpenId(OutputObj.OEORIOperCategoryDR)
			if $ISOBJECT(OPCategoryObj) {
			   s OutputObj.OEORIOperCategoryCode=OPCategoryObj.CATEGCode
			   s OutputObj.OEORIOperCategoryDesc=OPCategoryObj.CATEGDesc
			   do OPCategoryObj.%Close()
			}
		}
		s OutputObj.OEORIPrescNo=OrdObj.OEORIPrescNo
		s OutputObj.OEORIConsultDepDR=OrdObj.OEORIConsultDepDR
		if $ISOBJECT(OutputObj.OEORIConsultDepDR){
			s OutputObj.OEORIConsultDepDR=OrdObj.OEORIConsultDepDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIConsultDepDR)
			if $ISOBJECT(LocObj) {
			   s OutputObj.OEORIConsultDepCode=LocObj.CTLOCCode
			   s OutputObj.OEORIConsultDepDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.OEORIConsultDrDR=OrdObj.OEORIConsultDrDR
		if $ISOBJECT(OutputObj.OEORIConsultDrDR){
			s OutputObj.OEORIConsultDrDR=OrdObj.OEORIConsultDrDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIConsultDrDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIConsultDrCode=DocObj.CTPCPCode
			   s OutputObj.OEORIConsultDrDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}
		s OutputObj.OEORIUnit=OrdObj.OEORIUnit
		s OutputObj.OEORITime=OrdObj.OEORITime
		s OutputObj.OEORIUnitHrs=OrdObj.OEORIUnitHrs
		s OutputObj.OEORISpeedFlowRate=OrdObj.OEORISpeedFlowRate
		s OutputObj.OEORIFlowQty=OrdObj.OEORIFlowQty
		s OutputObj.OEORIRecDepDR=OrdObj.OEORIRecDepDR
		if $ISOBJECT(OutputObj.OEORIRecDepDR){
			s OutputObj.OEORIRecDepDR=OrdObj.OEORIRecDepDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIRecDepDR)
			if $ISOBJECT(LocObj) {
			   s OutputObj.OEORIRecDepCode=LocObj.CTLOCCode
			   s OutputObj.OEORIRecDepDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.OEORIBilled=OrdObj.OEORIBilled
		s OutputObj.OEORISeqNo=OrdObj.OEORISeqNo
		s OutputObj.OEORIAdmInsuranceDR=OrdObj.OEORIAdmInsuranceDR
		if $ISOBJECT(OutputObj.OEORIAdmInsuranceDR){
			s OutputObj.OEORIAdmInsuranceDR=OrdObj.OEORIAdmInsuranceDR.%Id()
			s InsuObj=##class(User.PAAdmInsurance).%OpenId(OutputObj.OEORIAdmInsuranceDR)
			if $ISOBJECT(InsuObj) {
			   s OutputObj.OEORIAdmInsuranceCode="" //InsuObj
			   s OutputObj.OEORIAdmInsuranceDesc="" //InsuObj.CTLOCDesc
			   do InsuObj.%Close()
			}
		}
		s OutputObj.OEORIPrice=OrdObj.OEORIPrice
		s OutputObj.OEORICollectedBy=OrdObj.OEORICollectedBy
		if $ISOBJECT(OutputObj.OEORICollectedBy){
			s OutputObj.OEORICollectedBy=OrdObj.OEORICollectedBy.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORICollectedBy)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORICollectedByCode=DocObj.CTPCPCode 
			   s OutputObj.OEORICollectedByDesc=DocObj.CTPCPDesc
			   do DocObj.%Close() 
			}
		}
		s OutputObj.OEORIDate=OrdObj.OEORIDate
		s OutputObj.OEORINoOrdersLink=OrdObj.OEORINoOrdersLink
		s OutputObj.OEORIOrderTypeDR=OrdObj.OEORIOrderTypeDR
		if $ISOBJECT(OutputObj.OEORIOrderTypeDR){
			s OutputObj.OEORIOrderTypeDR=OrdObj.OEORIOrderTypeDR.%Id()
			s OrdTypeObj=##class(User.OECOrderType).%OpenId(OutputObj.OEORIOrderTypeDR)
			if $ISOBJECT(OrdTypeObj) {
			   s OutputObj.OEORIOrderTypeCode=OrdTypeObj.TYPCode 
			   s OutputObj.OEORIOrderTypeDesc=OrdTypeObj.TYPDesc 
			   do OrdTypeObj.%Close()
			}
		}
		s OutputObj.OEORIPRN=OrdObj.OEORIPRN
		s OutputObj.OEORIDoseQty=OrdObj.OEORIDoseQty
		s OutputObj.OEORIARCOSDR=OrdObj.OEORIARCOSDR
		if $ISOBJECT(OutputObj.OEORIARCOSDR){
			s OutputObj.OEORIARCOSDR=OrdObj.OEORIARCOSDR.%Id()
			s ARCOrdSetsObj=##class(User.ARCOrdSets).%OpenId(OutputObj.OEORIARCOSDR)
			if $ISOBJECT(ARCOrdSetsObj) {
			   s OutputObj.OEORIARCOSCode=ARCOrdSetsObj.ARCOSCode 
			   s OutputObj.OEORIARCOSDesc=ARCOrdSetsObj.ARCOSDesc 
			   do ARCOrdSetsObj.%Close()
			}
		}
		s OutputObj.OEORILinkNo=OrdObj.OEORILinkNo
		s OutputObj.OEORILabEpisodeNo=OrdObj.OEORILabEpisodeNo
		s OutputObj.OEORILabEpisodeSetup=OrdObj.OEORILabEpisodeSetup
		s OutputObj.OEORITimeOrd=OrdObj.OEORITimeOrd
		s OutputObj.OEORIRefundQty=OrdObj.OEORIRefundQty
		s OutputObj.OEORIRefundType=OrdObj.OEORIRefundType
		s OutputObj.OEORIARPBLItemDR=OrdObj.OEORIARPBLItemDR
		if $ISOBJECT(OutputObj.OEORIARPBLItemDR){
			s OutputObj.OEORIARPBLItemDR=OrdObj.OEORIARPBLItemDR.%Id()
			s ARChargeObj=##class(User.ARPatBillGroupCharges).%OpenId(OutputObj.OEORIARPBLItemDR)
			if $ISOBJECT(ARChargeObj) {
			   s OutputObj.OEORIARPBLItemCode="" //ARChargeObj
			   s OutputObj.OEORIARPBLItemDesc="" //ARChargeObj 
			   do ARChargeObj.%Close()
			}
		}
		s OutputObj.OEORIXCTCPDR=OrdObj.OEORIXCTCPDR
		if $ISOBJECT(OutputObj.OEORIXCTCPDR){
			s OutputObj.OEORIXCTCPDR=OrdObj.OEORIXCTCPDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIARPBLItemDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIXCTCPCode=DocObj.CTPCPCode
			   s OutputObj.OEORIXCTCPDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}
		s OutputObj.OEORIReasonRefundDR=OrdObj.OEORIReasonRefundDR
		if $ISOBJECT(OutputObj.OEORIReasonRefundDR){
			s OutputObj.OEORIReasonRefundDR=OrdObj.OEORIReasonRefundDR.%Id()
			s RefundReasonObj=##class(User.BLCReasonForRefund).%OpenId(OutputObj.OEORIReasonRefundDR)
			if $ISOBJECT(RefundReasonObj) {
			   s OutputObj.OEORIReasonRefundCode=RefundReasonObj.RFRCode
			   s OutputObj.OEORIReasonRefundDesc=RefundReasonObj.RFRDesc
			   do RefundReasonObj.%Close()
			}
		}
		s OutputObj.OEORIReturnToStock=OrdObj.OEORIReturnToStock
		s OutputObj.OEORIMealTypeDR=OrdObj.OEORIMealTypeDR
		if $ISOBJECT(OutputObj.OEORIMealTypeDR){
			s OutputObj.OEORIMealTypeDR=OrdObj.OEORIMealTypeDR.%Id()
			s MealTypeObj=##class(User.DTCMealType).%OpenId(OutputObj.OEORIMealTypeDR)
			if $ISOBJECT(MealTypeObj) {
			   s OutputObj.OEORIMealTypeCode=MealTypeObj.MEALTCode
			   s OutputObj.OEORIMealTypeDesc=MealTypeObj.MEALTDesc
			   do MealTypeObj.%Close()
			}
			
		}
		s OutputObj.OEORIRiceTypeDR=OrdObj.OEORIRiceTypeDR
		if $ISOBJECT(OutputObj.OEORIRiceTypeDR){
			s OutputObj.OEORIRiceTypeDR=OrdObj.OEORIRiceTypeDR.%Id()
			s RiceTypeObj=##class(User.DTCRiceType).%OpenId(OutputObj.OEORIRiceTypeDR)
			if $ISOBJECT(RiceTypeObj) {
			   s OutputObj.OEORIRiceTypeCode=RiceTypeObj.RICCode
			   s OutputObj.OEORIRiceTypeDesc=RiceTypeObj.RICDesc
			   do RiceTypeObj.%Close()
			}
			
		}
		s OutputObj.OEORIVolumeDR=OrdObj.OEORIRiceTypeDR
		if $ISOBJECT(OutputObj.OEORIVolumeDR){
			s OutputObj.OEORIVolumeDR=OrdObj.OEORIVolumeDR.%Id()
			s DTCVObj=##class(User.DTCVolume).%OpenId(OutputObj.OEORIVolumeDR)
			if $ISOBJECT(DTCVObj) {
			   s OutputObj.OEORIVolumeCode=DTCVObj.VOLCode
			   s OutputObj.OEORIVolumeDesc=DTCVObj.VOLDesc
			   do DTCVObj.%Close()
			}
		}
		s OutputObj.OEORIEnergyDR=OrdObj.OEORIEnergyDR
		if $ISOBJECT(OutputObj.OEORIEnergyDR){
			s OutputObj.OEORIEnergyDR=OrdObj.OEORIEnergyDR.%Id()
			s DTCEObj=##class(User.DTCEnergy).%OpenId(OutputObj.OEORIEnergyDR)
			if $ISOBJECT(DTCEObj) {
			   s OutputObj.OEORIEnergyCode=DTCEObj.ENECode
			   s OutputObj.OEORIEnergyDesc=DTCEObj.ENEDesc
			   do DTCEObj.%Close()
			}
		}
		s OutputObj.OEORIProtein=OrdObj.OEORIProtein
		s OutputObj.OEORIFat=OrdObj.OEORIFat
		s OutputObj.OEORICarbohydrate=OrdObj.OEORICarbohydrate
		s OutputObj.OEORIDelayMeal=OrdObj.OEORIDelayMeal
		s OutputObj.OEORIDateTime=OrdObj.OEORIDateTime
		s OutputObj.OEORIAnaestDR=OrdObj.OEORIAnaestDR
		if $ISOBJECT(OutputObj.OEORIAnaestDR){
			s OutputObj.OEORIAnaestDR=OrdObj.OEORIAnaestDR.%Id()
			s ORAnObj=##class(User.ORAnaesthesia).%OpenId(OutputObj.OEORIAnaestDR)
			if $ISOBJECT(ORAnObj) {
			   s OutputObj.OEORIAnaestCode="" //ORAnObj
			   s OutputObj.OEORIAnaestDesc="" //ORAnObj
			   do ORAnObj.%Close()
			}
		}
		s OutputObj.OEORIAnaOperDR=OrdObj.OEORIAnaOperDR
		if $ISOBJECT(OutputObj.OEORIAnaOperDR){
			s OutputObj.OEORIAnaOperDR=OrdObj.OEORIAnaOperDR.%Id()
			s ORAnaObj=##class(User.ORAnaestOperation).%OpenId(OutputObj.OEORIAnaOperDR)
			if $ISOBJECT(ORAnaObj) {
			   s OutputObj.OEORIAnaOperCode="" 
			   s OutputObj.OEORIAnaOperDesc="" 
			   do ORAnaObj.%Close()
			}
		}
		s OutputObj.OEORIPasterizeFood=OrdObj.OEORIPasterizeFood
		s OutputObj.OEORISterilizeUtelsis=OrdObj.OEORISterilizeUtelsis
        s OutputObj.OEORIRVIChargeDR=OrdObj.OEORIRVIChargeDR
		if $ISOBJECT(OutputObj.OEORIRVIChargeDR){
			s OutputObj.OEORIRVIChargeDR=OrdObj.OEORIRVIChargeDR.%Id()
			s ORViObj=##class(User.RVIInsCoBillCharges).%OpenId(OutputObj.OEORIRVIChargeDR)
			if $ISOBJECT(ORViObj) {
			   s OutputObj.OEORIRVIChargeCode="" //ORViObj.
			   s OutputObj.OEORIRVIChargeCode="" 
			   do ORViObj.%Close()
			}
		}	
		s OutputObj.OEORIResultFlag=OrdObj.OEORIResultFlag
		s OutputObj.OEORIRMFreqDR=OrdObj.OEORIRMFreqDR
		if $ISOBJECT(OutputObj.OEORIRMFreqDR){
			s OutputObj.OEORIRMFreqDR=OrdObj.OEORIRMFreqDR.%Id()
			s FreqObj=##class(User.PHCFreq).%OpenId(OutputObj.OEORIRMFreqDR)
			if $ISOBJECT(FreqObj) {
			   s OutputObj.OEORIRMFreqCode=FreqObj.PHCFRCode
			   s OutputObj.OEORIRMFreqDesc=FreqObj.PHCFRDesc1
			   do FreqObj.%Close()
			}
		}	
		s OutputObj.OEORIRMDuratDR=OrdObj.OEORIRMDuratDR
		if $ISOBJECT(OutputObj.OEORIRMDuratDR){
			s OutputObj.OEORIRMDuratDR=OrdObj.OEORIRMDuratDR.%Id()
			s DurObj=##class(User.PHCDuration).%OpenId(OutputObj.OEORIRMDuratDR)
			if $ISOBJECT(DurObj) {
			   s OutputObj.OEORIRMDuratCode=DurObj.PHCDUCode
			   s OutputObj.OEORIRMDuratDesc=DurObj.PHCDUDesc1
			   do DurObj.%Close()
			}
		}
		s OutputObj.OEORIDateExecuted=OrdObj.OEORIDateExecuted
		s OutputObj.OEORITimeExecuted=OrdObj.OEORITimeExecuted
		s OutputObj.OEORIUserExecuted=OrdObj.OEORIUserExecuted
		if $ISOBJECT(OutputObj.OEORIUserExecuted){
			s OutputObj.OEORIUserExecuted=OrdObj.OEORIUserExecuted.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIUserExecuted)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIUserExecutedCode=UserObj.PHCDUCode
			   s OutputObj.OEORIUserExecutedDesc=UserObj.PHCDUDesc1
			   do UserObj.%Close()
			}
		}
		s OutputObj.OEORIAPPTDR=OrdObj.OEORIAPPTDR
		if $ISOBJECT(OutputObj.OEORIAPPTDR){
			s OutputObj.OEORIAPPTDR=OrdObj.OEORIAPPTDR.%Id()
			s RBApptObj=##class(User.RBAppointment).%OpenId(OutputObj.OEORIAPPTDR)
			if $ISOBJECT(RBApptObj) {
			   s OutputObj.OEORIAPPTCode="" //UserObj.PHCDUCode
			   s OutputObj.OEORIAPPTDesc="" //UserObj.PHCDUDesc1
			   do RBApptObj.%Close()
			}
		}
		s OutputObj.OEORIDRGOrder=OrdObj.OEORIDRGOrder
		s OutputObj.OEORIUserAdd=OrdObj.OEORIAPPTDR
		if $ISOBJECT(OutputObj.OEORIAPPTDR){
			s OutputObj.OEORIUserAdd=OrdObj.OEORIUserAdd.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIUserAdd)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIUserAddCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIUserAddDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.OEORIUserDepartmentDR=OrdObj.OEORIUserDepartmentDR
		if $ISOBJECT(OutputObj.OEORIUserDepartmentDR){
			s OutputObj.OEORIUserDepartmentDR=OrdObj.OEORIUserDepartmentDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIUserDepartmentDR)
			if $ISOBJECT(LocObj) {
			   s OutputObj.OEORIUserDepartmentCode=LocObj.CTLOCCode
			   s OutputObj.OEORIUserDepartmentDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.OEORIUserAuthorise=OrdObj.OEORIUserAuthorise
		s OutputObj.OEORIAuthComments=OrdObj.OEORIAuthComments
		s OutputObj.OEORIDispensingTimes=OrdObj.OEORIDispensingTimes
        s OutputObj.OEORIFlowRateUnitDR=OrdObj.OEORIFlowRateUnitDR
		if $ISOBJECT(OutputObj.OEORIFlowRateUnitDR){
			s OutputObj.OEORIFlowRateUnitDR=OrdObj.OEORIFlowRateUnitDR.%Id()
			s SpeedFlowRObj=##class(User.OECSpeedFlowRate).%OpenId(OutputObj.OEORIFlowRateUnitDR)
			if $ISOBJECT(SpeedFlowRObj) {
			   s OutputObj.OEORIFlowRateUnitCode=SpeedFlowRObj.SFRCode
			   s OutputObj.OEORIFlowRateUnitDesc=SpeedFlowRObj.SFRDesc
			   do SpeedFlowRObj.%Close()
			}
		}
		s OutputObj.OEORIConsCategDR=OrdObj.OEORIConsCategDR
		if $ISOBJECT(OutputObj.OEORIConsCategDR){
			s OutputObj.OEORIConsCategDR=OrdObj.OEORIConsCategDR.%Id()
			s OECCCaObj=##class(User.OECConsultCateg).%OpenId(OutputObj.OEORIConsCategDR)
			if $ISOBJECT(OECCCaObj) {
			   s OutputObj.OEORIConsCategCode=OECCCaObj.CONSCode
			   s OutputObj.OEORIConsCategDesc=OECCCaObj.CONSDesc
			   do OECCCaObj.%Close()
			}
		}	
		s OutputObj.OEORIDoctorExecutedDR=OrdObj.OEORIDoctorExecutedDR
		if $ISOBJECT(OutputObj.OEORIDoctorExecutedDR){
			s OutputObj.OEORIDoctorExecutedDR=OrdObj.OEORIDoctorExecutedDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIConsCategDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIDoctorExecutedCode=DocObj.CTPCPCode
			   s OutputObj.OEORIDoctorExecutedDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}	
		s OutputObj.OEORIDiscountAmt=OrdObj.OEORIDiscountAmt
		s OutputObj.OEORIDiscountPerc=OrdObj.OEORIDiscountPerc
		s OutputObj.OEORIDiscountDate=OrdObj.OEORIDiscountDate
		s OutputObj.OEORIDiscountTime=OrdObj.OEORIDiscountTime
        s OutputObj.OEORIDiscountDoctorDR=OrdObj.OEORIDiscountDoctorDR
		if $ISOBJECT(OutputObj.OEORIDiscountDoctorDR){
			s OutputObj.OEORIDiscountDoctorDR=OrdObj.OEORIDiscountDoctorDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIDiscountDoctorDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIDiscountDoctorCode=DocObj.CTPCPCode
			   s OutputObj.OEORIDiscountDoctorDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}
		s OutputObj.OEORIDiscountReason=OrdObj.OEORIDiscountReason
		s OutputObj.OEORICost=OrdObj.OEORICost
		s OutputObj.OEORIFinDate=OrdObj.OEORIFinDate
		s OutputObj.OEORILabTestSetRow=OrdObj.OEORILabTestSetRow
		s OutputObj.OEORIRefClnDR=OrdObj.OEORIRefClnDR
		if $ISOBJECT(OutputObj.OEORIRefClnDR){
			s OutputObj.OEORIRefClnDR=OrdObj.OEORIRefClnDR.%Id()
			s CTRefCObj=##class(User.CTRefClin).%OpenId(OutputObj.OEORIDiscountDoctorDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIRefClnCode=CTRefCObj.CTRFCCode
			   s OutputObj.OEORIRefClnDesc=CTRefCObj.CTRFCDesc
			   do CTRefCObj.%Close()
			}
		}
		s OutputObj.OEORIHICClaimNo=OrdObj.OEORIHICClaimNo
		s OutputObj.OEORIRefClnDR=OrdObj.OEORIRefClnDR
		if $ISOBJECT(OutputObj.OEORIRefClnDR){
			s OutputObj.OEORIRefClnDR=OrdObj.OEORIRefClnDR.%Id()
			s CTRefCObj=##class(User.CTRefClin).%OpenId(OutputObj.OEORIRefClnDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIRefClnCode=CTRefCObj.CTRFCCode
			   s OutputObj.OEORIRefClnDesc=CTRefCObj.CTRFCDesc
			   do CTRefCObj.%Close()
			}
		}
		s OutputObj.OEORIHICClaimNo=OrdObj.OEORIHICClaimNo
		s OutputObj.OEORIMainOeEntDR=OrdObj.OEORIMainOeEntDR
		if $ISOBJECT(OutputObj.OEORIMainOeEntDR){
			s OutputObj.OEORIMainOeEntDR=OrdObj.OEORIMainOeEntDR.%Id()
			s OEEntObj=##class(User.OEOrdEnt).%OpenId(OutputObj.OEORIMainOeEntDR)
			if $ISOBJECT(OEEntObj) {
			   s OutputObj.OEORIMainOeEntCode="" //OEEntObj
			   s OutputObj.OEORIMainOeEntDesc=""
			   do OEEntObj.%Close()
			}
		}
		s OutputObj.OEORIPharmacyStatus=OrdObj.OEORIPharmacyStatus
        s OutputObj.OEORIUserUpdate=OrdObj.OEORIUserUpdate
		if $ISOBJECT(OutputObj.OEORIUserUpdate){
			s OutputObj.OEORIUserUpdate=OrdObj.OEORIUserUpdate.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIUserUpdate)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIUserUpdateCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIUserUpdateDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.OEORICollectionDepDR=OrdObj.OEORICollectionDepDR
		if $ISOBJECT(OutputObj.OEORICollectionDepDR){
			s OutputObj.OEORICollectionDepDR=OrdObj.OEORICollectionDepDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORICollectionDepDR)
			if $ISOBJECT(LocObj) {
			   s OutputObj.OEORICollectionDepCode=LocObj.CTLOCCode
			   s OutputObj.OEORICollectionDepDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.OEORIExpectedCollDate=OrdObj.OEORIExpectedCollDate
		s OutputObj.OEORIExpectedCollTime=OrdObj.OEORIExpectedCollTime
		s OutputObj.OEORILab1=OrdObj.OEORILab1
		s OutputObj.OEORILab2=OrdObj.OEORILab2
		s OutputObj.OEORIMaxNumberOfRepeats=OrdObj.OEORIMaxNumberOfRepeats
		s OutputObj.OEORIAccessionNumber=OrdObj.OEORIAccessionNumber
		s OutputObj.OEORIResultRef=OrdObj.OEORIResultRef
        s OutputObj.OEORIClinPathwaysDR=OrdObj.OEORIClinPathwaysDR
		if $ISOBJECT(OutputObj.OEORIClinPathwaysDR){
			s OutputObj.OEORIClinPathwaysDR=OrdObj.OEORIClinPathwaysDR.%Id()
			s MRPathWObj=##class(User.MRClinicalPathWays).%OpenId(OutputObj.OEORICollectionDepDR)
			if $ISOBJECT(MRPathWObj) {
			   s OutputObj.OEORIClinPathwaysCode="" //MRPathWObj
			   s OutputObj.OEORIClinPathwaysDesc=""
			   do MRPathWObj.%Close()
			}
		}
		s OutputObj.OEORIResultGroup=OrdObj.OEORIResultGroup
		s OutputObj.OEORIStockBatches=OrdObj.OEORIStockBatches
        s OutputObj.OEORIAssistantDR=OrdObj.OEORIAssistantDR
		if $ISOBJECT(OutputObj.OEORIAssistantDR){
			s OutputObj.OEORIAssistantDR=OrdObj.OEORIAssistantDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIAssistantDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIAssistantCode=DocObj.CTPCPCode
			   s OutputObj.OEORIAssistantDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}	
		s OutputObj.OEORIQtyPackUOM=OrdObj.OEORIQtyPackUOM
		s OutputObj.OEORIDateRead=OrdObj.OEORIDateRead
		s OutputObj.OEORITimeRead=OrdObj.OEORITimeRead
		s OutputObj.OEORIUserReadDR=OrdObj.OEORIUserReadDR
		if $ISOBJECT(OutputObj.OEORIUserReadDR){
			s OutputObj.OEORIUserReadDR=OrdObj.OEORIUserReadDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIUserReadDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIUserReadCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIUserReadDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.OEORIAlertReasonDR=OrdObj.OEORIAlertReasonDR
		if $ISOBJECT(OutputObj.OEORIAlertReasonDR){
			s OutputObj.OEORIAlertReasonDR=OrdObj.OEORIAlertReasonDR.%Id()
			s OECAlertObj=##class(User.OECAlertReason).%OpenId(OutputObj.OEORIAlertReasonDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIAlertReasonCode=OECAlertObj.ALRCode
			   s OutputObj.OEORIAlertReasonDesc=OECAlertObj.ALRDesc
			   do OECAlertObj.%Close()
			}
		}
		s OutputObj.OEORIEndDate=OrdObj.OEORIEndDate
        s OutputObj.OEORIEndTime=OrdObj.OEORIEndTime
        s OutputObj.OEORIAdmLocDR=OrdObj.OEORIAdmLocDR
		if $ISOBJECT(OutputObj.OEORIAdmLocDR){
			s OutputObj.OEORIAdmLocDR=OrdObj.OEORIAdmLocDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIAdmLocDR)
			if $ISOBJECT(LocObj) {
			   s OutputObj.OEORIAdmLocCode=LocObj.CTLOCCode
			   s OutputObj.OEORIAdmLocDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}	
		s OutputObj.OEORIContactCareProv=OrdObj.OEORIContactCareProv
		s OutputObj.OEORIFillerNo=OrdObj.OEORIFillerNo
		s OutputObj.OEORIVarianceReasonDR=OrdObj.OEORIVarianceReasonDR
		if $ISOBJECT(OutputObj.OEORIVarianceReasonDR){
			s OutputObj.OEORIVarianceReasonDR=OrdObj.OEORIVarianceReasonDR.%Id()
			s MRCVObj=##class(User.MRCVarianceReason).%OpenId(OutputObj.OEORIVarianceReasonDR)
			if $ISOBJECT(MRCVObj) {
			   s OutputObj.OEORIVarianceReasonCode=MRCVObj.VRCode
			   s OutputObj.OEORIVarianceReasonDesc=MRCVObj.VRDesc
			   do MRCVObj.%Close()
			}
		}
		s OutputObj.OEORIAuthorisedDate=OrdObj.OEORIAuthorisedDate
		s OutputObj.OEORIExamStartTime=OrdObj.OEORIExamStartTime
		s OutputObj.OEORIPatientIDChecked=OrdObj.OEORIPatientIDChecked
		s OutputObj.OEORIPreExamUser=OrdObj.OEORIPreExamUser
		s OutputObj.OEORIExposureKV=OrdObj.OEORIExposureKV
		s OutputObj.OEORIExposuremAs=OrdObj.OEORIExposuremAs
		s OutputObj.OEORIScreeningTime=OrdObj.OEORIScreeningTime
        s OutputObj.OEORITypeSizeOfFilmsUsedDR=OrdObj.OEORITypeSizeOfFilmsUsedDR
		if $ISOBJECT(OutputObj.OEORITypeSizeOfFilmsUsedDR){
			s OutputObj.OEORITypeSizeOfFilmsUsedDR=OrdObj.OEORITypeSizeOfFilmsUsedDR.%Id()
			s OECFTypeObj=##class(User.OECFilmTypeSize).%OpenId(OutputObj.OEORITypeSizeOfFilmsUsedDR)
			if $ISOBJECT(OECFTypeObj) {
			   s OutputObj.OEORITypeSizeOfFilmsUsedCode=OECFTypeObj.FTSCode
			   s OutputObj.OEORITypeSizeOfFilmsUsedDesc=OECFTypeObj.FTSDesc
			   do OECFTypeObj.%Close()
			}
		}
		s OutputObj.OEORILMPDate=OrdObj.OEORILMPDate
		s OutputObj.OEORITypeSizeOfFilmsRejectedDR=OrdObj.OEORITypeSizeOfFilmsRejectedDR
		if $ISOBJECT(OutputObj.OEORITypeSizeOfFilmsRejectedDR){
			s OutputObj.OEORITypeSizeOfFilmsRejectedDR=OrdObj.OEORITypeSizeOfFilmsRejectedDR.%Id()
			s OECFTypeObj=##class(User.OECFilmTypeSize).%OpenId(OutputObj.OEORITypeSizeOfFilmsRejectedDR)
			if $ISOBJECT(OECFTypeObj) {
			   s OutputObj.OEORITypeSizeOfFilmsRejectedCode=OECFTypeObj.FTSCode
			   s OutputObj.OEORITypeSizeOfFilmsRejectedDesc=OECFTypeObj.FTSDesc
			   do OECFTypeObj.%Close()
			}
		}
		s OutputObj.OEORIRBResourceDR=OrdObj.OEORIRBResourceDR
		if $ISOBJECT(OutputObj.OEORIRBResourceDR){
			s OutputObj.OEORIRBResourceDR=OrdObj.OEORIRBResourceDR.%Id()
			s RBResObj=##class(User.RBResource).%OpenId(OutputObj.OEORIRBResourceDR)
			if $ISOBJECT(RBResObj) {
			   s OutputObj.OEORIRBResourceCode=RBResObj.RESCode
			   s OutputObj.OEORIRBResourceDesc=RBResObj.RESDesc
			   do RBResObj.%Close()
			}
		}
		s OutputObj.OEORIFilmReasonForRejectionDR=OrdObj.OEORIFilmReasonForRejectionDR
		if $ISOBJECT(OutputObj.OEORIFilmReasonForRejectionDR){
			s OutputObj.OEORIFilmReasonForRejectionDR=OrdObj.OEORIFilmReasonForRejectionDR.%Id()
			s OECFReaObj=##class(User.OECFilmReasonForReject).%OpenId(OutputObj.OEORIFilmReasonForRejectionDR)
			if $ISOBJECT(OECFReaObj) {
			   s OutputObj.OEORIFilmReasonForRejectionCode=OECFReaObj.FRRCode
			   s OutputObj.OEORIFilmReasonForRejectionDesc=OECFReaObj.FRRDesc
			   do OECFReaObj.%Close()
			}
		}
		s OutputObj.OEORIContrastTypeDR=OrdObj.OEORIContrastTypeDR
		if $ISOBJECT(OutputObj.OEORIContrastTypeDR){
			s OutputObj.OEORIContrastTypeDR=OrdObj.OEORIContrastTypeDR.%Id()
			s OECFConTypeObj=##class(User.OECFilmContrastType).%OpenId(OutputObj.OEORIContrastTypeDR)
			if $ISOBJECT(OECFConTypeObj) {
			   s OutputObj.OEORIContrastTypeCode=OECFConTypeObj.FCTCode
			   s OutputObj.OEORIContrastTypeDesc=OECFConTypeObj.FCTDesc
			   do OECFConTypeObj.%Close()
			}
		}
		s OutputObj.OEORIContrastVolume=OrdObj.OEORIContrastVolume
		s OutputObj.OEORIContrastExpiryDate=OrdObj.OEORIContrastExpiryDate
		s OutputObj.OEORIContrastBatchNumber=OrdObj.OEORIContrastBatchNumber
		s OutputObj.OEORIInjectionTime=OrdObj.OEORIInjectionTime
		s OutputObj.OEORIPersonInjectDR=OrdObj.OEORIPersonInjectDR
		if $ISOBJECT(OutputObj.OEORIPersonInjectDR){
			s OutputObj.OEORIPersonInjectDR=OrdObj.OEORIPersonInjectDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIPersonInjectDR)
			if $ISOBJECT(OECFConTypeObj) {
			   s OutputObj.OEORIPersonInjectCode=DocObj.CTPCPCode
			   s OutputObj.OEORIPersonInjectDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		}
		s OutputObj.OEORIPregnancyCheck=OrdObj.OEORIPregnancyCheck
		s OutputObj.OEORIIsotopeDose=OrdObj.OEORIIsotopeDose
		s OutputObj.OEORIPostExamUser=OrdObj.OEORIPostExamUser
		s OutputObj.OEORIAuthorisedTime=OrdObj.OEORIAuthorisedTime
		s OutputObj.OEORIHotReportRequired=OrdObj.OEORIHotReportRequired
		s OutputObj.OEORIWaitListDR=OrdObj.OEORIWaitListDR
		if $ISOBJECT(OutputObj.OEORIWaitListDR){
			s OutputObj.OEORIWaitListDR=OrdObj.OEORIWaitListDR.%Id()
			s PAWListObj=##class(User.PAWaitingList).%OpenId(OutputObj.OEORIWaitListDR)
			if $ISOBJECT(PAWListObj) {
			   s OutputObj.OEORIWaitListCode=""
			   s OutputObj.OEORIWaitListDesc=""
			   do PAWListObj.%Close()
			}
		}
		s OutputObj.OEORIEpisArriveDate=OrdObj.OEORIEpisArriveDate
		s OutputObj.OEORIEpisArriveTime=OrdObj.OEORIEpisArriveTime
		s OutputObj.OEORIAbnormal=OrdObj.OEORIAbnormal
		s OutputObj.OEORIUpdateDate=OrdObj.OEORIUpdateDate
		s OutputObj.OEORIUpdateTime=OrdObj.OEORIUpdateTime
		s OutputObj.OEORINoConsentOverrideReasDR=OrdObj.OEORINoConsentOverrideReasDR
		if $ISOBJECT(OutputObj.OEORINoConsentOverrideReasDR){
			s OutputObj.OEORINoConsentOverrideReasDR=OrdObj.OEORINoConsentOverrideReasDR.%Id()
			s OECcONObj=##class(User.OECOverReasonNonConsent).%OpenId(OutputObj.OEORINoConsentOverrideReasDR)
			if $ISOBJECT(OECcONObj) {
			   s OutputObj.OEORINoConsentOverrideReasCode=OECcONObj.ORNCCode
			   s OutputObj.OEORINoConsentOverrideReasDesc=OECcONObj.ORNCDesc
			   do OECcONObj.%Close()
			}
		}
		s OutputObj.OEORINoOrderedBags=OrdObj.OEORINoOrderedBags
        s OutputObj.OEORICurrSampleExpiry=OrdObj.OEORICurrSampleExpiry
        s OutputObj.OEORIReasOrdCMVNegBlood=OrdObj.OEORIReasOrdCMVNegBlood
        s OutputObj.OEORICompXMatchReq=OrdObj.OEORICompXMatchReq
        s OutputObj.OEORIAutologousBloodReq=OrdObj.OEORIAutologousBloodReq
        s OutputObj.OEORIPatConsentObtained=OrdObj.OEORIPatConsentObtained
        s OutputObj.OEORIBBTAG1=OrdObj.OEORIBBTAG1
        s OutputObj.OEORIBBTAG2=OrdObj.OEORIBBTAG2
        s OutputObj.OEORIBBTAG3=OrdObj.OEORIBBTAG3
        s OutputObj.OEORIBBTAG4=OrdObj.OEORIBBTAG4
        s OutputObj.OEORIBBTAG5=OrdObj.OEORIBBTAG5
        s OutputObj.OEORIBBExtCode=OrdObj.OEORIBBExtCode
        s PACAdmReaObj=##class(User.PACAdmReason).%OpenId(OutputObj.OEORIBBExtCode)
		if $ISOBJECT(PACAdmReaObj) {
			s OutputObj.OEORIReasonCode=PACAdmReaObj.REACode
			s OutputObj.OEORIReasonDesc=PACAdmReaObj.READesc
			do PACAdmReaObj.%Close()
		}
		s OutputObj.OEORIRefDocDR=OrdObj.OEORIRefDocDR
		if $ISOBJECT(OutputObj.OEORIRefDocDR){
			s OutputObj.OEORIRefDocDR=OrdObj.OEORIRefDocDR.%Id()
			s RefDocObj=##class(User.PACRefDoctor).%OpenId(OutputObj.OEORIRefDocDR)
			if $ISOBJECT(OECcONObj) {
			   s OutputObj.OEORIRefDocCode=RefDocObj.REFDCode
			   s OutputObj.OEORIRefDocDesc=RefDocObj.REFDDesc
			   do RefDocObj.%Close()
			}
		}
		s OutputObj.OEORIBBStatus=OrdObj.OEORIBBStatus
	    s OutputObj.OEORIActionDR=OrdObj.OEORIActionDR
		if $ISOBJECT(OutputObj.OEORIActionDR){
			s OutputObj.OEORIActionDR=OrdObj.OEORIActionDR.%Id()
			s OECAcObj=##class(User.OECAction).%OpenId(OutputObj.OEORIActionDR)
			if $ISOBJECT(OECAcObj) {
			   s OutputObj.OEORIActionCode=OECAcObj.ACTCode
			   s OutputObj.OEORIActionDesc=OECAcObj.ACTDesc
			   do OECAcObj.%Close()
			}
		}
		s OutputObj.OEORIResultComments=OrdObj.OEORIResultComments
		s OutputObj.OEORIAllergyReasonDR=OrdObj.OEORIAllergyReasonDR
		if $ISOBJECT(OutputObj.OEORIAllergyReasonDR){
			s OutputObj.OEORIAllergyReasonDR=OrdObj.OEORIAllergyReasonDR.%Id()
			s PACAReaObj=##class(User.PACAllergyReason).%OpenId(OutputObj.OEORIAllergyReasonDR)
			if $ISOBJECT(PACAReaObj) {
			   s OutputObj.OEORIAllergyReasonCode=PACAReaObj.ALRGREACode
			   s OutputObj.OEORIAllergyReasonDesc=PACAReaObj.ALRGREADesc
			   do PACAReaObj.%Close()
			}
		}
		s OutputObj.OEORILabAction=OrdObj.OEORILabAction
		s OutputObj.OEORILabVolume=OrdObj.OEORILabVolume
		s OutputObj.OEORILabSeqNo=OrdObj.OEORILabSeqNo
		s OutputObj.OEORIPlacerNo=OrdObj.OEORIPlacerNo
		s OutputObj.OEORISentInExtract=OrdObj.OEORISentInExtract
		s OutputObj.OEORISeriesNo=OrdObj.OEORISeriesNo
		s OutputObj.OEORILabReceiveDate=OrdObj.OEORILabReceiveDate
		s OutputObj.OEORILabReceiveTime=OrdObj.OEORILabReceiveTime
		s OutputObj.OEORIPostExamUserHospDR=OrdObj.OEORIPostExamUserHospDR
		if $ISOBJECT(OutputObj.OEORIPostExamUserHospDR){
			s OutputObj.OEORIPostExamUserHospDR=OrdObj.OEORIPostExamUserHospDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.OEORIPostExamUserHospDR)
			if $ISOBJECT(HosObj) {
			   s OutputObj.OEORIPostExamUserHospCode=HosObj.HOSPCode
			   s OutputObj.OEORIPostExamUserHospDesc=HosObj.HOSPDesc
			   do HosObj.%Close()
			}
		}
		s OutputObj.OEORIPreExamUserHospDR=OrdObj.OEORIPreExamUserHospDR
		if $ISOBJECT(OutputObj.OEORIPreExamUserHospDR){
			s OutputObj.OEORIPreExamUserHospDR=OrdObj.OEORIPreExamUserHospDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.OEORIPreExamUserHospDR)
			if $ISOBJECT(HosObj) {
			   s OutputObj.OEORIPreExamUserHospCode=HosObj.HOSPCode
			   s OutputObj.OEORIPreExamUserHospDesc=HosObj.HOSPDesc
			   do HosObj.%Close()
			}
		}
        s OutputObj.OEORIUserAuthoriseHospDR=OrdObj.OEORIUserAuthoriseHospDR
		if $ISOBJECT(OutputObj.OEORIUserAuthoriseHospDR){
			s OutputObj.OEORIUserAuthoriseHospDR=OrdObj.OEORIUserAuthoriseHospDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.OEORIUserAuthoriseHospDR)
			if $ISOBJECT(HosObj) {
			   s OutputObj.OEORIUserAuthoriseHospCode=HosObj.HOSPCode
			   s OutputObj.OEORIUserAuthoriseHospDesc=HosObj.HOSPDesc
			   do HosObj.%Close()
			}
		}	
		s OutputObj.OEORIUserAddHospDR=OrdObj.OEORIUserAddHospDR
		if $ISOBJECT(OutputObj.OEORIUserAddHospDR){
			s OutputObj.OEORIUserAddHospDR=OrdObj.OEORIUserAddHospDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.OEORIUserAddHospDR)
			if $ISOBJECT(HosObj) {
			   s OutputObj.OEORIUserAddHospCode=HosObj.HOSPCode
			   s OutputObj.OEORIUserAddHospDesc=HosObj.HOSPDesc
			   do HosObj.%Close()
			}
		}	
		s OutputObj.OEORITheatreRequired=OrdObj.OEORITheatreRequired
		s OutputObj.OEORITheatreDate=OrdObj.OEORITheatreDate
		s OutputObj.OEORITestSetComments=OrdObj.OEORITestSetComments
		s OutputObj.OEORIReturnDate=OrdObj.OEORIReturnDate
		s OutputObj.OEORIReturnTime=OrdObj.OEORIReturnTime
		s OutputObj.OEORIReturnUserDR=OrdObj.OEORIReturnUserDR
		if $ISOBJECT(OutputObj.OEORIReturnUserDR){
			s OutputObj.OEORIReturnUserDR=OrdObj.OEORIReturnUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIReturnUserDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIReturnUserCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIReturnUserDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}	
		s OutputObj.OEORIOEORIDR=OrdObj.OEORIOEORIDR
		if $ISOBJECT(OutputObj.OEORIOEORIDR){
			s OutputObj.OEORIOEORIDR=OrdObj.OEORIOEORIDR.%Id()
		}
		s OutputObj.OEORIDayBookAccessionNo=OrdObj.OEORIDayBookAccessionNo
		s OutputObj.OEORIDayBookSpecimen=OrdObj.OEORIDayBookSpecimen
		s OutputObj.OEORIUnitsCollected=OrdObj.OEORIUnitsCollected
		s OutputObj.OEORIIncompleteCollection=OrdObj.OEORIIncompleteCollection
		s OutputObj.OEORIUserUnReadDR=OrdObj.OEORIUserUnReadDR
		if $ISOBJECT(OutputObj.OEORIUserUnReadDR){
			s OutputObj.OEORIUserUnReadDR=OrdObj.OEORIUserUnReadDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIUserUnReadDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIUserUnReadCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIUserUnReadCode=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}	
		s OutputObj.OEORIDateUnRead=OrdObj.OEORIDateUnRead
		s OutputObj.OEORITimeUnread=OrdObj.OEORITimeUnread
		s OutputObj.OEORIReasonNotCollected=OrdObj.OEORIReasonNotCollected
		s OutputObj.OEORIPostExamStartTime=OrdObj.OEORIPostExamStartTime
        s OutputObj.OEORIIndicTransfusionDR=OrdObj.OEORIIndicTransfusionDR
		if $ISOBJECT(OutputObj.OEORIIndicTransfusionDR){
			s OutputObj.OEORIIndicTransfusionDR=OrdObj.OEORIIndicTransfusionDR.%Id()
			s OECIndTObj=##class(User.OECIndicationTransfusion).%OpenId(OutputObj.OEORIIndicTransfusionDR)
			if $ISOBJECT(OECIndTObj) {
			   s OutputObj.OEORIIndicTransfusionCode=OECIndTObj.INDTRANSFCode
			   s OutputObj.OEORIIndicTransfusionDesc=OECIndTObj.INDTRANSFDesc
			   do OECIndTObj.%Close()
			}
		}   
		s OutputObj.OEORIClinicallySignificant=OrdObj.OEORIClinicallySignificant
		s OutputObj.OEORISensitivitiesSignoff=OrdObj.OEORISensitivitiesSignoff
        s OutputObj.OEORIContOrderAfterDischarge=OrdObj.OEORIContOrderAfterDischarge   
		s OutputObj.OEORIRouteDR=OrdObj.OEORIRouteDR
		if $ISOBJECT(OutputObj.OEORIRouteDR){
			s OutputObj.OEORIRouteDR=OrdObj.OEORIRouteDR.%Id()
			s OECRObj=##class(User.OECRoute).%OpenId(OutputObj.OEORIRouteDR)
			if $ISOBJECT(OECIndTObj) {
			   s OutputObj.OEORIRouteCode=OECRObj.ROUTECode
			   s OutputObj.OEORIRouteDesc=OECRObj.ROUTEDesc
			   do OECRObj.%Close()
			}
		} 
		s OutputObj.OEORIPendingStatusDR=OrdObj.OEORIPendingStatusDR
		if $ISOBJECT(OutputObj.OEORIPendingStatusDR){
			s OutputObj.OEORIPendingStatusDR=OrdObj.OEORIPendingStatusDR.%Id()
			s OECOStaObj=##class(User.OECOrderStatus).%OpenId(OutputObj.OEORIPendingStatusDR)
			if $ISOBJECT(OECIndTObj) {
			   s OutputObj.OEORIPendingStatusCode=OECOStaObj.OSTATCode
			   s OutputObj.OEORIPendingStatusDesc=OECOStaObj.OSTATDesc
			   do OECOStaObj.%Close()
			}
		} 
		s OutputObj.OEORIAuthoriseClinicianDR=OrdObj.OEORIAuthoriseClinicianDR
		if $ISOBJECT(OutputObj.OEORIAuthoriseClinicianDR){
			s OutputObj.OEORIAuthoriseClinicianDR=OrdObj.OEORIAuthoriseClinicianDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.OEORIAuthoriseClinicianDR)
			if $ISOBJECT(DocObj) {
			   s OutputObj.OEORIAuthoriseClinicianCode=DocObj.CTPCPCode
			   s OutputObj.OEORIAuthoriseClinicianDesc=DocObj.CTPCPDesc
			   do DocObj.%Close()
			}
		} 
		s OutputObj.OEORINotify=OrdObj.OEORINotify
		s OutputObj.OEORINotifyClinician=OrdObj.OEORINotifyClinician
		s OutputObj.OEORIPACClinicDR=OrdObj.OEORIPACClinicDR
		if $ISOBJECT(OutputObj.OEORIPACClinicDR){
			s OutputObj.OEORIPACClinicDR=OrdObj.OEORIPACClinicDR.%Id()
			s PACClObj=##class(User.PACClinic).%OpenId(OutputObj.OEORIPACClinicDR)
			if $ISOBJECT(PACClObj) {
			   s OutputObj.OEORIPACClinicCode=PACClObj.CLNCode
			   s OutputObj.OEORIPACClinicDesc=PACClObj.CLNDesc
			   do PACClObj.%Close()
			}
		} 
		s OutputObj.OEORIResultUpdateDate=OrdObj.OEORIResultUpdateDate
		s OutputObj.OEORIResultUpdateTime=OrdObj.OEORIResultUpdateTime
		s OutputObj.OEORIResultUpdateUserDR=OrdObj.OEORIResultUpdateUserDR
		if $ISOBJECT(OutputObj.OEORIResultUpdateUserDR){
			s OutputObj.OEORIResultUpdateUserDR=OrdObj.OEORIResultUpdateUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIResultUpdateUserDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORIResultUpdateUserCode=UserObj.SSUSRInitials
			   s OutputObj.OEORIResultUpdateUserDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		} 
		s OutputObj.OEORIResultUpdateHospitalDR=OrdObj.OEORIResultUpdateHospitalDR
		if $ISOBJECT(OutputObj.OEORIResultUpdateHospitalDR){
			s OutputObj.OEORIResultUpdateHospitalDR=OrdObj.OEORIResultUpdateHospitalDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.OEORIResultUpdateHospitalDR)
			if $ISOBJECT(HosObj) {
			   s OutputObj.OEORIResultUpdateHospitalCode=HosObj.HOSPCode
			   s OutputObj.OEORIResultUpdateHospitalDesc=HosObj.HOSPDesc
			   do HosObj.%Close()
			}
		} 
		s OutputObj.OEORIEligibilityStatus=OrdObj.OEORIEligibilityStatus
		s OutputObj.OEORIRecLocVerified=OrdObj.OEORIRecLocVerified
		s OutputObj.OEORIResultAvailable=OrdObj.OEORIResultAvailable
		s OutputObj.OEORIExternalPrimarySpecSite=OrdObj.OEORIExternalPrimarySpecSite
		s OutputObj.OEORIExternalSecondarySpecSite=OrdObj.OEORIExternalSecondarySpecSite
        s OutputObj.OEORIExternalRefDoctorDR=OrdObj.OEORIExternalRefDoctorDR
		if $ISOBJECT(OutputObj.OEORIExternalRefDoctorDR){
			s OutputObj.OEORIExternalRefDoctorDR=OrdObj.OEORIExternalRefDoctorDR.%Id()
			s RefDocObj=##class(User.PACRefDoctor).%OpenId(OutputObj.OEORIExternalRefDoctorDR)
			if $ISOBJECT(RefDocObj) {
			   s OutputObj.OEORIExternalRefDoctorCode=RefDocObj.REFDCode
			   s OutputObj.OEORIExternalRefDoctorDesc=RefDocObj.REFDDesc
			   do RefDocObj.%Close()
			}
		} 
		s OutputObj.OEORIResultAvailableDate=OrdObj.OEORIResultAvailableDate
		s OutputObj.OEORIManufacturerOrderDR=OrdObj.OEORIManufacturerOrderDR
		if $ISOBJECT(OutputObj.OEORIManufacturerOrderDR){
			s OutputObj.OEORIManufacturerOrderDR=OrdObj.OEORIManufacturerOrderDR.%Id()
			s INFacOrdObj=##class(User.INManufactureOrder).%OpenId(OutputObj.OEORIManufacturerOrderDR)
			if $ISOBJECT(INFacOrdObj) {
			   s OutputObj.OEORIManufacturerOrderCode=""
			   s OutputObj.OEORIManufacturerOrderDesc=""
			   do INFacOrdObj.%Close()
			}
		} 	
		s OutputObj.OEORIHL7ResultStatus=OrdObj.OEORIHL7ResultStatus
		s OutputObj.OEORIHL7ResultDate=OrdObj.OEORIHL7ResultDate
		s OutputObj.OEORIHL7ResultTime=OrdObj.OEORIHL7ResultTime
		s OutputObj.OEORIFreqDelay=OrdObj.OEORIFreqDelay
		s OutputObj.OEORICancelReasonDR=OrdObj.OEORICancelReasonDR
		if $ISOBJECT(OutputObj.OEORICancelReasonDR){
			s OutputObj.OEORICancelReasonDR=OrdObj.OEORICancelReasonDR.%Id()
			s CancReaObj=##class(User.OECCancelReason).%OpenId(OutputObj.OEORICancelReasonDR)
			if $ISOBJECT(CancReaObj) {
			   s OutputObj.OEORICancelReasonCode=CancReaObj.CANCREACode
			   s OutputObj.OEORICancelReasonDesc=CancReaObj.CANCREADesc
			   do CancReaObj.%Close()
			}
		} 
		s OutputObj.OEORILabelText=OrdObj.OEORILabelText
		s OutputObj.OEORISpecialtyDR=OrdObj.OEORISpecialtyDR
		if $ISOBJECT(OutputObj.OEORISpecialtyDR){
			s OutputObj.OEORISpecialtyDR=OrdObj.OEORISpecialtyDR.%Id()
			s CTSpecObj=##class(User.CTSpec).%OpenId(OutputObj.OEORISpecialtyDR)
			if $ISOBJECT(CTSpecObj) {
			   s OutputObj.OEORISpecialtyCode=CTSpecObj.CTSPCCode
			   s OutputObj.OEORISpecialtyDesc=CTSpecObj.CTSPCDesc
			   do CTSpecObj.%Close()
			}
		} 
		s OutputObj.OEORIAdminRouteDR=OrdObj.OEORIAdminRouteDR
		if $ISOBJECT(OutputObj.OEORIAdminRouteDR){
			s OutputObj.OEORIAdminRouteDR=OrdObj.OEORIAdminRouteDR.%Id()
			s PHCRouteObj=##class(User.PHCAdministrationRoute).%OpenId(OutputObj.OEORIAdminRouteDR)
			if $ISOBJECT(PHCRouteObj) {
			   s OutputObj.OEORIAdminRouteCode=PHCRouteObj.ADMRCode
			   s OutputObj.OEORIAdminRouteDesc=PHCRouteObj.ADMRDesc
			   do PHCRouteObj.%Close()
			}
		} 
		s OutputObj.OEORIPRNMaxDose24hrs=OrdObj.OEORIPRNMaxDose24hrs
		s OutputObj.OEORIPRNTotNumberDosesAll=OrdObj.OEORIPRNTotNumberDosesAll
		s OutputObj.OEORIPRNIndication=OrdObj.OEORIPRNIndication
		s OutputObj.OEORIPregnant=OrdObj.OEORIPregnant
		s OutputObj.OEORILDMP=OrdObj.OEORILDMP
		s OutputObj.OEORIWeeksPregnant=OrdObj.OEORIWeeksPregnant
		s OutputObj.OEORIDayOfCycle=OrdObj.OEORIDayOfCycle
		s OutputObj.OEORILtClinicalCondition=OrdObj.OEORILtClinicalCondition
		s OutputObj.OEORIQuestionnaire=OrdObj.OEORIQuestionnaire
		s OutputObj.OEORISupplierContactedDate=OrdObj.OEORISupplierContactedDate
		s OutputObj.OEORISupplierContactedTime=OrdObj.OEORISupplierContactedTime
		s OutputObj.OEORIProsReceivedDate=OrdObj.OEORIProsReceivedDate
		s OutputObj.OEORIProsReceivedTime=OrdObj.OEORIProsReceivedTime
		s OutputObj.OEORIProsBatchNo=OrdObj.OEORIProsBatchNo
		s OutputObj.OEORIProsSerialNo=OrdObj.OEORIProsSerialNo
		s OutputObj.OEORIProsSupplier=OrdObj.OEORIProsSupplier
		s OutputObj.OEORIExpiryDate=OrdObj.OEORIExpiryDate
		s OutputObj.OEORISize=OrdObj.OEORISize
        s OutputObj.OEORIImplantTypeDR=OrdObj.OEORIImplantTypeDR
		if $ISOBJECT(OutputObj.OEORIImplantTypeDR){
			s OutputObj.OEORIImplantTypeDR=OrdObj.OEORIImplantTypeDR.%Id()
			s OECImpObj=##class(User.OECImplantType).%OpenId(OutputObj.OEORIImplantTypeDR)
			if $ISOBJECT(OECImpObj) {
			   s OutputObj.OEORIImplantTypeCode=OECImpObj.IMPLCode
			   s OutputObj.OEORIImplantTypeDesc=OECImpObj.IMPLDesc
			   do OECImpObj.%Close()
			}
		} 
		s OutputObj.OEORIReadyToBill=OrdObj.OEORIReadyToBill
		s OutputObj.OEORIDietFlag=OrdObj.OEORIDietFlag
		s OutputObj.OEORIActivity=OrdObj.OEORIActivity
		s OutputObj.OEORIView=OrdObj.OEORIView
		s OutputObj.OEORIDSReportFlag=OrdObj.OEORIDSReportFlag
		s OutputObj.OEORIResultDSReportFlag=OrdObj.OEORIResultDSReportFlag
		s OutputObj.OEORIPrescRepExpiryDate=OrdObj.OEORIPrescRepExpiryDate
		s OutputObj.OEORIPrescRepNumberDays=OrdObj.OEORIPrescRepNumberDays
		s OutputObj.OEORIMaxRepeats=OrdObj.OEORIMaxRepeats
		s OutputObj.OEORICurrRepeatNumber=OrdObj.OEORICurrRepeatNumber
		s OutputObj.OEORICategDR=OrdObj.OEORICategDR
		if $ISOBJECT(OutputObj.OEORICategDR){
			s OutputObj.OEORICategDR=OrdObj.OEORICategDR.%Id()
			s OECCateObj=##class(User.OECOrderCategory).%OpenId(OutputObj.OEORICategDR)
			if $ISOBJECT(OECCateObj) {
			   s OutputObj.OEORICategCode=OECCateObj.ORCATCode
			   s OutputObj.OEORICategDesc=OECCateObj.ORCATDesc
			   do OECCateObj.%Close()
			}
		} 
		s OutputObj.OEORIConsultDR=OrdObj.OEORIConsultDR
		if $ISOBJECT(OutputObj.OEORIConsultDR){
			s OutputObj.OEORIConsultDR=OrdObj.OEORIConsultDR.%Id()
			s ConsObj=##class(User.PAPersonConsultSetCons).%OpenId(OutputObj.OEORIConsultDR)
			if $ISOBJECT(ConsObj) {
			   s OutputObj.OEORIConsultCode=""
			   s OutputObj.OEORIConsultDesc=""
			   do ConsObj.%Close()
			}
		} 
		s OutputObj.OEORIAnnotationDR=OrdObj.OEORIAnnotationDR
		if $ISOBJECT(OutputObj.OEORIAnnotationDR){
			s OutputObj.OEORIAnnotationDR=OrdObj.OEORIAnnotationDR.%Id()
			s OEAnObj=##class(User.OEAnnotation).%OpenId(OutputObj.OEORIAnnotationDR)
			if $ISOBJECT(OEAnObj) {
			   s OutputObj.OEORIAnnotationCode="" //OEAnObj.ANNOTText
			   s OutputObj.OEORIAnnotationDesc=OEAnObj.ANNOTText
			   do OEAnObj.%Close()
			}
		} 
		s OutputObj.OEORISkinTestOutcomeDR=OrdObj.OEORISkinTestOutcomeDR
		if $ISOBJECT(OutputObj.OEORISkinTestOutcomeDR){
			s OutputObj.OEORISkinTestOutcomeDR=OrdObj.OEORISkinTestOutcomeDR.%Id()
			s PHCSkinTOObj=##class(User.PHCSkinTestOutcome).%OpenId(OutputObj.OEORISkinTestOutcomeDR)
			if $ISOBJECT(PHCSkinTOObj) {
			   s OutputObj.OEORISkinTestOutcomeCode=PHCSkinTOObj.SKTOCode //OEAnObj.ANNOTText
			   s OutputObj.OEORISkinTestOutcomeDesc=PHCSkinTOObj.SKTODesc
			   do PHCSkinTOObj.%Close()
			}
		} 
		s OutputObj.OEORILTSpecCode=OrdObj.OEORILTSpecCode
		s OutputObj.OEORILTSiteCode=OrdObj.OEORILTSiteCode
		s OutputObj.OEORIRetentionDays=OrdObj.OEORIRetentionDays
		s OutputObj.OEORIPackOverReasonDR=OrdObj.OEORIPackOverReasonDR
		if $ISOBJECT(OutputObj.OEORIPackOverReasonDR){
			s OutputObj.OEORIPackOverReasonDR=OrdObj.OEORIPackOverReasonDR.%Id()
			s PackReaObj=##class(User.PHCPackingOverrideReason).%OpenId(OutputObj.OEORIPackOverReasonDR)
			if $ISOBJECT(PackReaObj) {
			   s OutputObj.OEORIPackOverReasonCode=PackReaObj.PKORCode //OEAnObj.ANNOTText
			   s OutputObj.OEORIPackOverReasonDesc=PackReaObj.PKORDesc
			   do PackReaObj.%Close()
			}
		} 
		s OutputObj.OEORIUrgentReport=OrdObj.OEORIUrgentReport
		s OutputObj.OEORIPhoneOrder=OrdObj.OEORIPhoneOrder
		s OutputObj.OEORISecondOrderingUserDR=OrdObj.OEORISecondOrderingUserDR
		if $ISOBJECT(OutputObj.OEORISecondOrderingUserDR){
			s OutputObj.OEORISecondOrderingUserDR=OrdObj.OEORISecondOrderingUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORISecondOrderingUserDR)
			if $ISOBJECT(UserObj) {
			   s OutputObj.OEORISecondOrderingUserCode=UserObj.SSUSRInitials //OEAnObj.ANNOTText
			   s OutputObj.OEORISecondOrderingUserDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.OEORIDatePOAuthorised=OrdObj.OEORIDatePOAuthorised
		s OutputObj.OEORITimePOAuthorised=OrdObj.OEORITimePOAuthorised
		s OutputObj.OEORIDateAuthReq=OrdObj.OEORIDateAuthReq
		s OutputObj.OEORITimeAuthReq=OrdObj.OEORITimeAuthReq
		s OutputObj.OEORIAnaestAgentDR=OrdObj.OEORIAnaestAgentDR
		if $ISOBJECT(OutputObj.OEORIAnaestAgentDR){
			s OutputObj.OEORIAnaestAgentDR=OrdObj.OEORIAnaestAgentDR.%Id()
			s ORAgentObj=##class(User.ORAnaestAgent).%OpenId(OutputObj.OEORIAnaestAgentDR)
			if $ISOBJECT(ORAgentObj) {
			   s OutputObj.OEORIAnaestAgentCode=""
			   s OutputObj.OEORIAnaestAgentDesc=""
			   do ORAgentObj.%Close()
			}
		}
		s OutputObj.OEORIOriginalOrderDR=OrdObj.OEORIOriginalOrderDR
		if $ISOBJECT(OutputObj.OEORIOriginalOrderDR){
			s OutputObj.OEORIOriginalOrderDR=OrdObj.OEORIOriginalOrderDR.%Id()
		}
		s OutputObj.OEORIExamAbandonReasonDR=OrdObj.OEORIExamAbandonReasonDR
		if $ISOBJECT(OutputObj.OEORIExamAbandonReasonDR){
			s OutputObj.OEORIExamAbandonReasonDR=OrdObj.OEORIExamAbandonReasonDR.%Id()
			s OECReaObj=##class(User.OECExamAbandonReason).%OpenId(OutputObj.OEORIAnaestAgentDR)
			if $ISOBJECT(OECReaObj) {
			   s OutputObj.OEORIExamAbandonReasonCode=OECReaObj.REABCode
			   s OutputObj.OEORIExamAbandonReasonDesc=OECReaObj.REABDesc
			   do OECReaObj.%Close()
			}
		}
		s OutputObj.OEORIResultExist=OrdObj.OEORIResultExist
		s OutputObj.OEORIPreparationTime=OrdObj.OEORIPreparationTime
		s OutputObj.OEORIPersonnel=OrdObj.OEORIPersonnel
		s OutputObj.OEORIComment1=OrdObj.OEORIComment1
		s OutputObj.OEORIComment2=OrdObj.OEORIComment2
		s OutputObj.OEORIComment3=OrdObj.OEORIComment3
		s OutputObj.OEORIRadiationDoesUnitDR=OrdObj.OEORIRadiationDoesUnitDR
		if $ISOBJECT(OutputObj.OEORIRadiationDoesUnitDR){
			s OutputObj.OEORIRadiationDoesUnitDR=OrdObj.OEORIRadiationDoesUnitDR.%Id()
			s OECRDoseUObj=##class(User.OECRadiologyDoseUnits).%OpenId(OutputObj.OEORIRadiationDoesUnitDR)
			if $ISOBJECT(OECRDoseUObj) {
			   s OutputObj.OEORIRadiationDoesUnitCode=OECRDoseUObj.RDUCode
			   s OutputObj.OEORIRadiationDoesUnitDesc=OECRDoseUObj.RDUDesc
			   do OECRDoseUObj.%Close()
			}
		}
		s OutputObj.OEORIReasonRejectPrescDR=OrdObj.OEORIReasonRejectPrescDR
		if $ISOBJECT(OutputObj.OEORIReasonRejectPrescDR){
			s OutputObj.OEORIReasonRejectPrescDR=OrdObj.OEORIReasonRejectPrescDR.%Id()
			s OECRRejObj=##class(User.OECReasonRejectPresc).%OpenId(OutputObj.OEORIReasonRejectPrescDR)
			if $ISOBJECT(OECRRejObj) {
			   s OutputObj.OEORIReasonRejectPrescCode=OECRRejObj.REJPRCode
			   s OutputObj.OEORIReasonRejectPrescDesc=OECRRejObj.REJPRDesc
			   do OECRRejObj.%Close()
			}
		}
		s OutputObj.OEORIDemandNumber=OrdObj.OEORIDemandNumber
		s OutputObj.OEORIRadiologyStatus=OrdObj.OEORIRadiologyStatus
		s OutputObj.OEORIInsertDate=OrdObj.OEORIInsertDate
		s OutputObj.OEORIInsertTime=OrdObj.OEORIInsertTime
		s OrdExtObj=##class(User.OEOrdItemExt).%OpenId(OEORIRowID)
	    if $ISOBJECT(OrdExtObj) {
		    s OutputObj.OEORIExecuteDateStr=OrdExtObj.OEORIExecuteDateStr
		    s OutputObj.OEORIRBASDR=OrdExtObj.OEORIRBASDR
		    if $ISOBJECT(OutputObj.OEORIRBASDR) {
			    s OutputObj.OEORIRBASDR=OrdExtObj.OEORIRBASDR.%Id()
			}
			s OutputObj.OEORIInsurCatDR=OrdExtObj.OEORIInsurCatDR
			if $ISOBJECT(OutputObj.OEORIInsurCatDR) {
				s OutputObj.OEORIInsurCatDR=OrdExtObj.OEORIInsurCatDR.%Id()
				s InsuCatObj=##class(User.INSUTarItems).%OpenId(OutputObj.OEORIInsurCatDR)
				if $ISOBJECT(InsuCatObj) {
				   s OutputObj.OEORIInsurCatCode=InsuCatObj.INTIMsfxmbm
				   s OutputObj.OEORIInsurCatDesc=InsuCatObj.INTIMxmmc
				   do InsuCatObj.%Close()
				}
			}
			s OutputObj.OEORIStopDripFlag=OrdExtObj.OEORIStopDripFlag
			s OutputObj.OEORIStopDripDate=OrdExtObj.OEORIStopDripDate
			s OutputObj.OEORIStopDripTime=OrdExtObj.OEORIStopDripTime
			s OutputObj.OEORIStopDripUserDR=OrdExtObj.OEORIStopDripUserDR
			if $ISOBJECT(OutputObj.OEORIStopDripUserDR) {
				s OutputObj.OEORIStopDripUserDR=OrdExtObj.OEORIStopDripUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIStopDripUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIStopDripUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIStopDripUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIStage=OrdExtObj.OEORIStage
			s OutputObj.OEORIOMProcNote=OrdExtObj.OEORIOMProcNote
			s OutputObj.OEORIPEProjectDR=OrdExtObj.OEORIPEProjectDR
			if $ISOBJECT(OutputObj.OEORIPEProjectDR) {
				s OutputObj.OEORIPEProjectDR=OrdExtObj.OEORIPEProjectDR.%Id()
				s PilotProObj=##class(User.DHCDocPilotProject).%OpenId(OutputObj.OEORIPEProjectDR)
				if $ISOBJECT(PilotProObj) {
				   s OutputObj.OEORIPEProjectCode=PilotProObj.PPCode
				   s OutputObj.OEORIPEProjectDesc=PilotProObj.PPDesc
				   do PilotProObj.%Close()
				}
			}
			s OutputObj.OEORINutritionDrugFlag=OrdExtObj.OEORINutritionDrugFlag
			s OutputObj.OEORIDispWeekTime=OrdExtObj.OEORIDispWeekTime
			s OutputObj.OEORIPackUOM=OrdExtObj.OEORIPackUOM
			if $ISOBJECT(OutputObj.OEORIPackUOM) {
				s OutputObj.OEORIPackUOM=OrdExtObj.OEORIPackUOM.%Id()
				s CTUomObj=##class(User.CTUOM).%OpenId(OutputObj.OEORIPackUOM)
				if $ISOBJECT(CTUomObj) {
				   s OutputObj.OEORIPackUOMCode=CTUomObj.CTUOMCode
				   s OutputObj.OEORIPackUOMDesc=CTUomObj.CTUOMDesc
				   do CTUomObj.%Close()
				}
			}
			s OutputObj.OEORIMaterialNo=OrdExtObj.OEORIMaterialNo
			s OutputObj.OEORIMedUnitDR=OrdExtObj.OEORIMedUnitDR
			if $ISOBJECT(OutputObj.OEORIMedUnitDR) {
				s OutputObj.OEORIMedUnitDR=OrdExtObj.OEORIMedUnitDR.%Id()
				s LocMUObj=##class(User.DHCCTLocMedUnit).%OpenId(OutputObj.OEORIMedUnitDR)
				if $ISOBJECT(LocMUObj) {
				   s OutputObj.OEORIMedUnitCode=LocMUObj.CTMUCode
				   s OutputObj.OEORIMedUnitDesc=LocMUObj.CTMUDesc
				   do LocMUObj.%Close()
				}
			}
			s OutputObj.OEORINeedPIVAFlag=OrdExtObj.OEORINeedPIVAFlag
			s OutputObj.OEORIEMStayFlag=OrdExtObj.OEORIEMStayFlag
			s OutputObj.OEORITarget=OrdExtObj.OEORITarget
			s OutputObj.OEORIPayorAduitFlag=OrdExtObj.OEORIPayorAduitFlag
			s OutputObj.OEORIPrePrescDR=OrdExtObj.OEORIPrePrescDR
			s OutputObj.OEORILocalInfusionQty=OrdExtObj.OEORILocalInfusionQty
			s OutputObj.OEORILabEpisodeNoStr=OrdExtObj.OEORILabEpisodeNoStr
			s OutputObj.OEORIOtherFlags=OrdExtObj.OEORIOtherFlags
			s OutputObj.OEORIPrintFlag=OrdExtObj.OEORIPrintFlag
			s OutputObj.OEORIPriceFlag=OrdExtObj.OEORIPriceFlag
			s OutputObj.OEORIPriceInputFlag=OrdExtObj.OEORIPriceInputFlag
            s OutputObj.OEORIMRDIADR=OrdExtObj.OEORIMRDIADR
			if $ISOBJECT(OutputObj.OEORIMRDIADR) {
				s OutputObj.OEORIMRDIADR=OrdExtObj.OEORIMRDIADR.%Id()
			}			
			s OutputObj.OEORIStopReasonDR=OrdExtObj.OEORIStopReasonDR
			if $ISOBJECT(OutputObj.OEORIStopReasonDR) {
				s OutputObj.OEORIStopReasonDR=OrdExtObj.OEORIStopReasonDR.%Id()
				s RefReaObj=##class(User.BLCReasonForRefund).%OpenId(OutputObj.OEORIStopReasonDR)
				if $ISOBJECT(RefReaObj) {
				   s OutputObj.OEORIStopReasonCode=RefReaObj.RFRCode
				   s OutputObj.OEORIStopReasonDesc=RefReaObj.RFRDesc
				   do RefReaObj.%Close()
				}
			}
			s OutputObj.OEORIWeekFreqDatTimStr=OrdExtObj.OEORIWeekFreqDatTimStr
			s OutputObj.OEORIOldPrice=OrdExtObj.OEORIOldPrice
			s OutputObj.OEORIUseInLocDR=OrdExtObj.OEORIUseInLocDR
			if $ISOBJECT(OutputObj.OEORIUseInLocDR) {
				s OutputObj.OEORIUseInLocDR=OrdExtObj.OEORIUseInLocDR.%Id()
				s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIUseInLocDR)
				if $ISOBJECT(LocObj) {
				   s OutputObj.OEORIUseInLocCode=LocObj.CTLOCCode
				   s OutputObj.OEORIUseInLocDesc=LocObj.CTLOCDesc
				   do LocObj.%Close()
				}
			}
			s OutputObj.OEORISelfOMFlag=OrdExtObj.OEORISelfOMFlag
			s OutputObj.OEORIRefundAuditFlag=OrdExtObj.OEORIRefundAuditFlag
			s OutputObj.OEORIRefundAuditUserDR=OrdExtObj.OEORIRefundAuditUserDR
			if $ISOBJECT(OutputObj.OEORIRefundAuditUserDR) {
				s OutputObj.OEORIRefundAuditUserDR=OrdExtObj.OEORIRefundAuditUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIRefundAuditUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIRefundAuditUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIRefundAuditUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIRefundAuditDate=OrdExtObj.OEORIRefundAuditDate
			s OutputObj.OEORIRefundAuditTime=OrdExtObj.OEORIRefundAuditTime
			s OutputObj.OEORIRefundReason=OrdExtObj.OEORIRefundReason
			if $ISOBJECT(OutputObj.OEORIRefundReason) {
				s OutputObj.OEORIRefundReason=OrdExtObj.OEORIRefundReason.%Id()
				s RefReaObj=##class(User.DHCINVOPRefReason).%OpenId(OutputObj.OEORIRefundReason)
				if $ISOBJECT(RefReaObj) {
				   s OutputObj.OEORIRefundReasonCode=RefReaObj.RFRCode
				   s OutputObj.OEORIRefundReasonDesc=RefReaObj.RFRDesc
				   do RefReaObj.%Close()
				}
			}
			s OutputObj.OEORIRefundAuditLocDR=OrdExtObj.OEORIRefundAuditLocDR
			if $ISOBJECT(OutputObj.OEORIRefundAuditLocDR) {
				s OutputObj.OEORIRefundAuditLocDR=OrdExtObj.OEORIRefundAuditLocDR.%Id()
				s LocObj=##class(User.CTLoc).%OpenId(OutputObj.OEORIRefundAuditLocDR)
				if $ISOBJECT(LocObj) {
				   s OutputObj.OEORIRefundAuditLocCode=LocObj.CTLOCCode
				   s OutputObj.OEORIRefundAuditLocDesc=LocObj.CTLOCDesc
				   do LocObj.%Close()
				}
			}
			s OutputObj.OEORIDoctorConfirmFlag=OrdExtObj.OEORIDoctorConfirmFlag
			s OutputObj.OEORIDoctorConfirmDate=OrdExtObj.OEORIDoctorConfirmDate
			s OutputObj.OEORIDoctorConfirmTime=OrdExtObj.OEORIDoctorConfirmTime
			s OutputObj.OEORIDoctorConfirmUserDR=OrdExtObj.OEORIDoctorConfirmUserDR
			if $ISOBJECT(OutputObj.OEORIDoctorConfirmUserDR) {
				s OutputObj.OEORIDoctorConfirmUserDR=OrdExtObj.OEORIDoctorConfirmUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIDoctorConfirmUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIDoctorConfirmUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIDoctorConfirmUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIChargeToOwnFlag=OrdExtObj.OEORIChargeToOwnFlag
			s OutputObj.OEORIChargeToOwnUserDR=OrdExtObj.OEORIChargeToOwnUserDR
			if $ISOBJECT(OutputObj.OEORIChargeToOwnUserDR) {
				s OutputObj.OEORIChargeToOwnUserDR=OrdExtObj.OEORIChargeToOwnUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIChargeToOwnUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIChargeToOwnUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIChargeToOwnUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIChargeToOwnDate=OrdExtObj.OEORIChargeToOwnDate
			s OutputObj.OEORIChargeToOwnTime=OrdExtObj.OEORIChargeToOwnTime
		    s OutputObj.OEORIDisconUserDR=OrdExtObj.OEORIDisconUserDR
			if $ISOBJECT(OutputObj.OEORIDisconUserDR) {
				s OutputObj.OEORIDisconUserDR=OrdExtObj.OEORIDisconUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIDisconUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIDisconUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIDisconUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIDisconDate=OrdExtObj.OEORIDisconDate
			s OutputObj.OEORIDisconTime=OrdExtObj.OEORIDisconTime
			s OutputObj.OEORISeeUserDR=OrdExtObj.OEORISeeUserDR
			if $ISOBJECT(OutputObj.OEORISeeUserDR) {
				s OutputObj.OEORISeeUserDR=OrdExtObj.OEORISeeUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORISeeUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORISeeUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORISeeUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORISeeDate=OrdExtObj.OEORISeeDate
			s OutputObj.OEORISeeTime=OrdExtObj.OEORISeeTime
			s OutputObj.OEORIExceedReasonDR=OrdExtObj.OEORIExceedReasonDR
			if $ISOBJECT(OutputObj.OEORIExceedReasonDR) {
				s OutputObj.OEORIExceedReasonDR=OrdExtObj.OEORIExceedReasonDR.%Id()
				s ExeceedReaObj=##class(User.DHCDocExceedReason).%OpenId(OutputObj.OEORIExceedReasonDR)
				if $ISOBJECT(ExeceedReaObj) {
				   s OutputObj.OEORIExceedReasonCode=ExeceedReaObj.DHCExceedCode
				   s OutputObj.OEORIExceedReasonDesc=ExeceedReaObj.DHCExceedDesc
				   do ExeceedReaObj.%Close()
				}
			}
			s OutputObj.OEORISeeType=OrdExtObj.OEORISeeType
			s OutputObj.OEORISeeRemark=OrdExtObj.OEORISeeRemark
			s OutputObj.OEORIPracticeConfirmDate=OrdExtObj.OEORIPracticeConfirmDate
			s OutputObj.OEORIPracticeConfirmTime=OrdExtObj.OEORIPracticeConfirmTime
			s OutputObj.OEORIPracticeConfirmUserDR=OrdExtObj.OEORIPracticeConfirmUserDR
			if $ISOBJECT(OutputObj.OEORIPracticeConfirmUserDR) {
				s OutputObj.OEORIPracticeConfirmUserDR=OrdExtObj.OEORIPracticeConfirmUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.OEORIPracticeConfirmUserDR)
				if $ISOBJECT(UserObj) {
				   s OutputObj.OEORIPracticeConfirmUserCode=UserObj.SSUSRInitials
				   s OutputObj.OEORIPracticeConfirmUserDesc=UserObj.SSUSRName
				   do UserObj.%Close()
				}
			}
			s OutputObj.OEORIOutsourcingFlag=OrdExtObj.OEORIOutsourcingFlag
			s OutputObj.OEORIBodyPart=OrdExtObj.OEORIBodyPart
			s OutputObj.OEORITarCatRowId=OrdExtObj.OEORITarCatRowId
			if $ISOBJECT(OutputObj.OEORITarCatRowId) {
				s OutputObj.OEORITarCatRowId=OrdExtObj.OEORITarCatRowId.%Id()
				s TarObj=##class(User.DHCTarItem).%OpenId(OutputObj.OEORITarCatRowId)
				if $ISOBJECT(TarObj) {
				   s OutputObj.OEORITarCatCode=TarObj.TARICode
				   s OutputObj.OEORITarCatCode=TarObj.TARIDesc
				   do TarObj.%Close()
				}
			}
			s OutputObj.OEORIExtOrgCode=OrdExtObj.OEORIExtOrgCode
			do OrdExtObj.%Close()
		}
	    do OrdObj.%Close()
	}
	Q OutputObj
}

/// 描述:    诊断相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.24
/// w ##class(DHCDoc.GetInfo.Method.Doc).GetDiagnosInfo()
ClassMethod GetDiagnosInfo(MRDIARowId As %String) As DHCDoc.GetInfo.Entry.MRDiagnos
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.MRDiagnos).%New()
	s DiagObj=##class(User.MRDiagnos).%OpenId(MRDIARowId)
	if $ISOBJECT(DiagObj) {
		s OutputObj.MRDIARowId=MRDIARowId
		s OutputObj.MRDIAICDCodeDR=DiagObj.MRDIAICDCodeDR
		if $ISOBJECT(OutputObj.MRDIAICDCodeDR) {
			s OutputObj.MRDIAICDCodeDR=DiagObj.MRDIAICDCodeDR.%Id()
			s ICDDxObj=##class(User.MRCICDDx).%OpenId(OutputObj.MRDIAICDCodeDR)
			if $ISOBJECT(ICDDxObj) {
				s OutputObj.MRDIAICDCode=ICDDxObj.MRCIDCode
				s OutputObj.MRDIAICDDesc=ICDDxObj.MRCIDDesc
				do ICDDxObj.%Close()
			}
		}
		s OutputObj.MRDIADateDetect=DiagObj.MRDIADateDetect
		s OutputObj.MRDIAICDStatusDR=DiagObj.MRDIAICDStatusDR
		if $ISOBJECT(OutputObj.MRDIAICDStatusDR) {
			s OutputObj.MRDIAICDStatusDR=DiagObj.MRDIAICDStatusDR.%Id()
			s ICDStatObj=##class(User.MRCICDStat).%OpenId(OutputObj.MRDIAICDStatusDR)
			if $ISOBJECT(ICDStatObj) {
				s OutputObj.MRDIAICDStatusCode=ICDStatObj.MRCISCode
				s OutputObj.MRDIAICDStatusDesc=ICDStatObj.MRCISDesc
				do ICDStatObj.%Close()
			}
		}
		s OutputObj.MRDIAWorkRelated=DiagObj.MRDIAWorkRelated
		s OutputObj.MRDIADocCodeDR=DiagObj.MRDIADocCodeDR
		if $ISOBJECT(OutputObj.MRDIADocCodeDR) {
			s OutputObj.MRDIADocCodeDR=DiagObj.MRDIADocCodeDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.MRDIADocCodeDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.MRDIADocCode=DocObj.CTPCPCode
				s OutputObj.MRDIADocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.MRDIAICDSupDR=DiagObj.MRDIAICDSupDR
		if $ISOBJECT(OutputObj.MRDIAICDSupDR) {
			s OutputObj.MRDIAICDSupDR=DiagObj.MRDIAICDSupDR.%Id()
			s SupICDObj=##class(User.MRCSuppICD).%OpenId(OutputObj.MRDIAICDSupDR)
			if $ISOBJECT(SupICDObj) {
				s OutputObj.MRDIAICDSupCode=SupICDObj.MRCSICode
				s OutputObj.MRDIAICDSupDesc=SupICDObj.MRCSIDesc
				do SupICDObj.%Close()
			}
		}
		s OutputObj.MRDIADesc=DiagObj.MRDIADesc
		s OutputObj.MRDIADate=DiagObj.MRDIADate
		s OutputObj.MRDIATime=DiagObj.MRDIATime
		s OutputObj.MRDIADiagStatDR=DiagObj.MRDIADiagStatDR
		if $ISOBJECT(OutputObj.MRDIADiagStatDR) {
			s OutputObj.MRDIADiagStatDR=DiagObj.MRDIADiagStatDR.%Id()
			s DiagstatusObj=##class(User.MRCDiagnosStatus).%OpenId(OutputObj.MRDIADiagStatDR)
			if $ISOBJECT(DiagstatusObj) {
				s OutputObj.MRDIADiagStatCode=DiagstatusObj.DSTATCode
				s OutputObj.MRDIADiagStatDesc=DiagstatusObj.DSTATDesc
				do DiagstatusObj.%Close()
			}
		}
		s OutputObj.MRDIASignSymDR=DiagObj.MRDIASignSymDR
		if $ISOBJECT(OutputObj.MRDIASignSymDR) {
			s OutputObj.MRDIASignSymDR=DiagObj.MRDIASignSymDR.%Id()
			s SympObj=##class(User.MRCDiagnosSignSymptom).%OpenId(OutputObj.MRDIASignSymDR)
			if $ISOBJECT(SympObj) {
				s OutputObj.MRDIASignSymCode=SympObj.DSYMCode
				s OutputObj.MRDIASignSymDesc=SympObj.DSYMDesc
				do SympObj.%Close()
			}
		}
		s OutputObj.MRDIADRGOrder=DiagObj.MRDIADRGOrder
		s OutputObj.MRDIAUpdateUserDR=DiagObj.MRDIAUpdateUserDR
		if $ISOBJECT(OutputObj.MRDIAUpdateUserDR) {
			s OutputObj.MRDIAUpdateUserDR=DiagObj.MRDIAUpdateUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.MRDIAUpdateUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.MRDIAUpdateUserCode=UserObj.SSUSRInitials
				s OutputObj.MRDIAUpdateUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.MRDIADiagnosisGroup1DR=DiagObj.MRDIADiagnosisGroup1DR
		if $ISOBJECT(OutputObj.MRDIADiagnosisGroup1DR) {
			s OutputObj.MRDIADiagnosisGroup1DR=DiagObj.MRDIADiagnosisGroup1DR.%Id()
			s DiagGroupObj=##class(User.MRCDiagnosisGroup1).%OpenId(OutputObj.MRDIADiagnosisGroup1DR)
			if $ISOBJECT(DiagGroupObj) {
				s OutputObj.MRDIADiagnosisGroup1Code=DiagGroupObj.GRP1Code
				s OutputObj.MRDIADiagnosisGroup1Desc=DiagGroupObj.GRP1Desc
				do DiagGroupObj.%Close()
			}
		}
		s OutputObj.MRDIADiagnosisGroup2DR=DiagObj.MRDIADiagnosisGroup2DR
		if $ISOBJECT(OutputObj.MRDIADiagnosisGroup2DR) {
			s OutputObj.MRDIADiagnosisGroup2DR=DiagObj.MRDIADiagnosisGroup2DR.%Id()
			s DiagGroupObj=##class(User.MRCDiagnosisGroup1).%OpenId(OutputObj.MRDIADiagnosisGroup2DR)
			if $ISOBJECT(DiagGroupObj) {
				s OutputObj.MRDIADiagnosisGroup2Code=DiagGroupObj.GRP1Code
				s OutputObj.MRDIADiagnosisGroup2Desc=DiagGroupObj.GRP1Desc
				do DiagGroupObj.%Close()
			}
		}
		s OutputObj.MRDIAStageClasDR=DiagObj.MRDIAStageClasDR
		if $ISOBJECT(OutputObj.MRDIAStageClasDR) {
			s OutputObj.MRDIAStageClasDR=DiagObj.MRDIAStageClasDR.%Id()
			s StageClassFObj=##class(User.PACStageClassification).%OpenId(OutputObj.MRDIAStageClasDR)
			if $ISOBJECT(StageClassFObj) {
				s OutputObj.MRDIAStageClasCode=StageClassFObj.STCLCode
				s OutputObj.MRDIAStageClasDesc=StageClassFObj.STCLDesc
				do StageClassFObj.%Close()
			}
		}
		s OutputObj.MRDIATumourDR=DiagObj.MRDIATumourDR
		if $ISOBJECT(OutputObj.MRDIATumourDR) {
			s OutputObj.MRDIATumourDR=DiagObj.MRDIATumourDR.%Id()
			s PACTumObj=##class(User.PACTumour).%OpenId(OutputObj.MRDIATumourDR)
			if $ISOBJECT(PACTumObj) {
				s OutputObj.MRDIATumourCode=PACTumObj.TUMCode
				s OutputObj.MRDIATumourDesc=PACTumObj.TUMDesc
				do PACTumObj.%Close()
			}
		}
		s OutputObj.MRDIALymphNodeDR=DiagObj.MRDIALymphNodeDR
		if $ISOBJECT(OutputObj.MRDIALymphNodeDR) {
			s OutputObj.MRDIALymphNodeDR=DiagObj.MRDIALymphNodeDR.%Id()
			s PACLNodeObj=##class(User.PACLymphNode).%OpenId(OutputObj.MRDIALymphNodeDR)
			if $ISOBJECT(PACLNodeObj) {
				s OutputObj.MRDIALymphNodeCode=PACLNodeObj.LYMNCode
				s OutputObj.MRDIALymphNodeDesc=PACLNodeObj.LYMNDesc
				do PACLNodeObj.%Close()
			}
		}
		s OutputObj.MRDIADistalMetDR=DiagObj.MRDIADistalMetDR
		if $ISOBJECT(OutputObj.MRDIADistalMetDR) {
			s OutputObj.MRDIADistalMetDR=DiagObj.MRDIADistalMetDR.%Id()
			s PACMObj=##class(User.PACDistalMetastasis).%OpenId(OutputObj.MRDIADistalMetDR)
			if $ISOBJECT(PACMObj) {
				s OutputObj.MRDIADistalMetCode=PACMObj.DISMCode
				s OutputObj.MRDIADistalMetDesc=PACMObj.DISMDesc
				do PACMObj.%Close()
			}
		}
		s OutputObj.MRDIAVenInvasionDR=DiagObj.MRDIAVenInvasionDR
		if $ISOBJECT(OutputObj.MRDIAVenInvasionDR) {
			s OutputObj.MRDIAVenInvasionDR=DiagObj.MRDIAVenInvasionDR.%Id()
			s PACVinObj=##class(User.PACVenousInvasion).%OpenId(OutputObj.MRDIAVenInvasionDR)
			if $ISOBJECT(PACVinObj) {
				s OutputObj.MRDIAVenInvasionCode=PACVinObj.VENICode
				s OutputObj.MRDIAVenInvasionDesc=PACVinObj.VENIDesc
				do PACVinObj.%Close()
			}
		}
		s OutputObj.MRDIALymphInvasDR=DiagObj.MRDIALymphInvasDR
		if $ISOBJECT(OutputObj.MRDIALymphInvasDR) {
			s OutputObj.MRDIALymphInvasDR=DiagObj.MRDIALymphInvasDR.%Id()
			s PACLinObj=##class(User.PACLymphInvasion).%OpenId(OutputObj.MRDIALymphInvasDR)
			if $ISOBJECT(PACLinObj) {
				s OutputObj.MRDIALymphInvasCode=PACLinObj.LYMICode
				s OutputObj.MRDIALymphInvasDesc=PACLinObj.LYMIDesc
				do PACLinObj.%Close()
			}
		}
		s OutputObj.MRDIAMalGradeDR=DiagObj.MRDIAMalGradeDR
		if $ISOBJECT(OutputObj.MRDIAMalGradeDR) {
			s OutputObj.MRDIAMalGradeDR=DiagObj.MRDIAMalGradeDR.%Id()
			s PACMGradeObj=##class(User.PACMalignancyGrade).%OpenId(OutputObj.MRDIAMalGradeDR)
			if $ISOBJECT(PACMGradeObj) {
				s OutputObj.MRDIAMalGradeCode=PACMGradeObj.MALGCode
				s OutputObj.MRDIAMalGradeDesc=PACMGradeObj.MALGDesc
				do PACMGradeObj.%Close()
			}
		}
		s OutputObj.MRDIAResTumDR=DiagObj.MRDIAResTumDR
		if $ISOBJECT(OutputObj.MRDIAResTumDR) {
			s OutputObj.MRDIAResTumDR=DiagObj.MRDIAResTumDR.%Id()
			s PACRTuObj=##class(User.PACResidualTumour).%OpenId(OutputObj.MRDIAResTumDR)
			if $ISOBJECT(PACRTuObj) {
				s OutputObj.MRDIAResTumCode=PACRTuObj.RESTUMCode
				s OutputObj.MRDIAResTumDesc=PACRTuObj.RESTUMDesc
				do PACRTuObj.%Close()
			}
		}
		s OutputObj.MRDIAStagesDR=DiagObj.MRDIAStagesDR
		if $ISOBJECT(OutputObj.MRDIAStagesDR) {
			s OutputObj.MRDIAStagesDR=DiagObj.MRDIAStagesDR.%Id()
			s PACStageObj=##class(User.PACStage).%OpenId(OutputObj.MRDIAStagesDR)
			if $ISOBJECT(PACStageObj) {
				s OutputObj.MRDIAStagesCode=PACStageObj.STGCode
				s OutputObj.MRDIAStagesDesc=PACStageObj.STGDesc
				do PACStageObj.%Close()
			}
		}
		s OutputObj.MRDIATumourSize=DiagObj.MRDIATumourSize
		s OutputObj.MRDIATumourNotes=DiagObj.MRDIATumourNotes
		s OutputObj.MRDIAMRDIADR=DiagObj.MRDIAMRDIADR
		if $ISOBJECT(OutputObj.MRDIAMRDIADR) {
			s OutputObj.MRDIAMRDIADR=DiagObj.MRDIAMRDIADR.%Id()
			s ICDDxObj=##class(User.MRCICDDx).%OpenId(OutputObj.MRDIAMRDIADR)
			if $ISOBJECT(ICDDxObj) {
				s OutputObj.MRDIAMRDIADRCode=ICDDxObj.MRCIDDesc
		        s OutputObj.MRDIAMRDIADRDesc=ICDDxObj.MRCIDCode
		        if (OutputObj.MRDIAMRDIADRDesc=""){
			        s OutputObj.MRDIAMRDIADRDesc=ICDDxObj.MRCIDDesc
			    }
			    do ICDDxObj.%Close()
			}
		}
		s OutputObj.MRDIADaggerAster=DiagObj.MRDIADaggerAster
		s OutputObj.MRDIAFirstInset=DiagObj.MRDIAFirstInset
		s OutputObj.MRDIAPrefix=DiagObj.MRDIAPrefix
		s OutputObj.MRDIAMappedICDDR=DiagObj.MRDIAMappedICDDR
		if $ISOBJECT(OutputObj.MRDIAMappedICDDR) {
			s OutputObj.MRDIAMappedICDDR=DiagObj.MRDIAMappedICDDR.%Id()
			s MRCICDObj=##class(User.MRCICDDx).%OpenId(OutputObj.MRDIAMappedICDDR)
			if $ISOBJECT(MRCICDObj) {
				s OutputObj.MRDIAMappedICDCode=MRCICDObj.MRCIDCode
				s OutputObj.MRDIAMappedICDDesc=MRCICDObj.MRCIDDesc
				do MRCICDObj.%Close()
			}
		}
		s OutputObj.MRDIAContractFlagDR=DiagObj.MRDIAContractFlagDR
		if $ISOBJECT(OutputObj.MRDIAContractFlagDR) {
			s OutputObj.MRDIAContractFlagDR=DiagObj.MRDIAContractFlagDR.%Id()
			s MRCConObj=##class(User.MRCContractFlag).%OpenId(OutputObj.MRDIAContractFlagDR)
			if $ISOBJECT(MRCConObj) {
				s OutputObj.MRDIAContractFlagCode=MRCConObj.CONTFLCode
				s OutputObj.MRDIAContractFlagDesc=MRCConObj.CONTFLDesc
				do MRCICDObj.%Close()
			}
		}
		s OutputObj.MRDIAUpdateHospitalDR=DiagObj.MRDIAUpdateHospitalDR
		if $ISOBJECT(OutputObj.MRDIAUpdateHospitalDR) {
			s OutputObj.MRDIAUpdateHospitalDR=DiagObj.MRDIAUpdateHospitalDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.MRDIAUpdateHospitalDR)
			if $ISOBJECT(HosObj) {
				s OutputObj.MRDIAUpdateHospitalCode=HosObj.HOSPCode
				s OutputObj.MRDIAUpdateHospitalDesc=HosObj.HOSPDesc
				do HosObj.%Close()
			}
		}
		s OutputObj.MRDIAUpdateDate=DiagObj.MRDIAUpdateDate
		s OutputObj.MRDIAUpdateTime=DiagObj.MRDIAUpdateTime
		s OutputObj.MRDIATumourUpdateDate=DiagObj.MRDIATumourUpdateDate
		s OutputObj.MRDIATumourUpdateTime=DiagObj.MRDIATumourUpdateTime
		s OutputObj.MRDIATumourUpdateUserDR=DiagObj.MRDIATumourUpdateUserDR
		if $ISOBJECT(OutputObj.MRDIATumourUpdateUserDR) {
			s OutputObj.MRDIATumourUpdateUserDR=DiagObj.MRDIATumourUpdateUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.MRDIATumourUpdateUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.MRDIATumourUpdateUserCode=UserObj.SSUSRInitials
				s OutputObj.MRDIATumourUpdateUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.MRDIATumourUpdateHospitalDR=DiagObj.MRDIATumourUpdateHospitalDR
		if $ISOBJECT(OutputObj.MRDIATumourUpdateHospitalDR) {
			s OutputObj.MRDIATumourUpdateHospitalDR=DiagObj.MRDIATumourUpdateHospitalDR.%Id()
			s HosObj=##class(User.CTHospital).%OpenId(OutputObj.MRDIATumourUpdateHospitalDR)
			if $ISOBJECT(HosObj) {
				s OutputObj.MRDIATumourUpdateHospitalCode=HosObj.HOSPCode
				s OutputObj.MRDIATumourUpdateHospitalDesc=HosObj.HOSPDesc
				do HosObj.%Close()
			}
		}
		s OutputObj.MRDIAUserCreatedDR=DiagObj.MRDIAUserCreatedDR
		if $ISOBJECT(OutputObj.MRDIAUserCreatedDR) {
			s OutputObj.MRDIAUserCreatedDR=DiagObj.MRDIAUserCreatedDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.MRDIAUserCreatedDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.MRDIAUserCreatedCode=UserObj.SSUSRInitials
				s OutputObj.MRDIAUserCreatedDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.MRDIADeletionReasonDR=DiagObj.MRDIADeletionReasonDR
		if $ISOBJECT(OutputObj.MRDIADeletionReasonDR) {
			s OutputObj.MRDIADeletionReasonDR=DiagObj.MRDIADeletionReasonDR.%Id()
			s ReaChangeObj=##class(User.PACReasonForChangePatData).%OpenId(OutputObj.MRDIADeletionReasonDR)
			if $ISOBJECT(ReaChangeObj) {
				s OutputObj.MRDIADeletionReasonCode=ReaChangeObj.RCHCode
				s OutputObj.MRDIADeletionReasonDesc=ReaChangeObj.RCHDesc
				do ReaChangeObj.%Close()
			}
		}
		s OutputObj.MRDIAPrimaryTumourSiteDR=DiagObj.MRDIAPrimaryTumourSiteDR
		if $ISOBJECT(OutputObj.MRDIAPrimaryTumourSiteDR) {
			s OutputObj.MRDIAPrimaryTumourSiteDR=DiagObj.MRDIAPrimaryTumourSiteDR.%Id()
			s OECBSiteObj=##class(User.OECBodySite).%OpenId(OutputObj.MRDIAPrimaryTumourSiteDR)
			if $ISOBJECT(OECBSiteObj) {
				s OutputObj.MRDIAPrimaryTumourSiteCode=OECBSiteObj.BODSCode
				s OutputObj.MRDIAPrimaryTumourSiteDesc=OECBSiteObj.BODSDesc
				do OECBSiteObj.%Close()
			}
		}
		s OutputObj.MRDIAQuestionnaire=DiagObj.MRDIAQuestionnaire
		s OutputObj.MRDIAAliasDiagText=DiagObj.MRDIAAliasDiagText
		s OutputObj.MRDIAAccidentDate=DiagObj.MRDIAAccidentDate
		s OutputObj.MRDIADSReportFlag=DiagObj.MRDIADSReportFlag
		s OutputObj.MRDIARiskEvaluationDR=DiagObj.MRDIARiskEvaluationDR
		if $ISOBJECT(OutputObj.MRDIARiskEvaluationDR) {
			s OutputObj.MRDIARiskEvaluationDR=DiagObj.MRDIARiskEvaluationDR.%Id()
			s MRCPObj=##class(User.MRCRiskEvalParam).%OpenId(OutputObj.MRDIARiskEvaluationDR)
			if $ISOBJECT(MRCPObj) {
				s OutputObj.MRDIARiskEvaluationCode=MRCPObj.REPCode
				s OutputObj.MRDIARiskEvaluationDesc=MRCPObj.REPDesc
				do MRCPObj.%Close()
			}
		}
		s OutputObj.MRDIADateDiagnosisIdentif=DiagObj.MRDIADateDiagnosisIdentif
		s OutputObj.MRDIAConsultDR=DiagObj.MRDIAConsultDR
		if $ISOBJECT(OutputObj.MRDIAConsultDR) {
			s OutputObj.MRDIAConsultDR=DiagObj.MRDIAConsultDR.%Id()
			s PAPSetConObj=##class(User.PAPersonConsultSetCons).%OpenId(OutputObj.MRDIAConsultDR)
			if $ISOBJECT(PAPSetConObj) {
				s OutputObj.MRDIAConsultCode="" //PAPSetConObj
				s OutputObj.MRDIAConsultDesc="" //PAPSetConObj
				do PAPSetConObj.%Close()
			}
		}
		s OutputObj.MRDIABodySiteDR=DiagObj.MRDIABodySiteDR
		if $ISOBJECT(OutputObj.MRDIABodySiteDR) {
			s OutputObj.MRDIABodySiteDR=DiagObj.MRDIABodySiteDR.%Id()
			s OECBSiteObj=##class(User.OECBodySite).%OpenId(OutputObj.MRDIABodySiteDR)
			if $ISOBJECT(OECBSiteObj) {
				s OutputObj.MRDIABodySiteCode=OECBSiteObj.BODSCode
				s OutputObj.MRDIABodySiteDesc=OECBSiteObj.BODSDesc
				do OECBSiteObj.%Close()
			}
		}
		s OutputObj.MRDIALateralityDR=DiagObj.MRDIALateralityDR
		if $ISOBJECT(OutputObj.MRDIALateralityDR) {
			s OutputObj.MRDIALateralityDR=DiagObj.MRDIALateralityDR.%Id()
			s PACLObj=##class(User.PACLaterality).%OpenId(OutputObj.MRDIALateralityDR)
			if $ISOBJECT(PACLObj) {
				s OutputObj.MRDIALateralityCode=PACLObj.LATERCode
				s OutputObj.MRDIALateralityDesc=PACLObj.LATERDesc
				do PACLObj.%Close()
			}
		}
		s OutputObj.MRDIASeverityDR=DiagObj.MRDIASeverityDR
		if $ISOBJECT(OutputObj.MRDIASeverityDR) {
			s OutputObj.MRDIASeverityDR=DiagObj.MRDIASeverityDR.%Id()
			s MRCSObj=##class(User.MRCSeverity).%OpenId(OutputObj.MRDIASeverityDR)
			if $ISOBJECT(MRCSObj) {
				s OutputObj.MRDIASeverityCode=MRCSObj.SEVCode
				s OutputObj.MRDIASeverityDesc=MRCSObj.SEVDesc
				do MRCSObj.%Close()
			}
		}
		s OutputObj.MRDIADurationNum=DiagObj.MRDIADurationNum
		s OutputObj.MRDIADurationUnit=DiagObj.MRDIADurationUnit
		s OutputObj.MRDIAActive=DiagObj.MRDIAActive
		s OutputObj.MRDIAOnsetDate=DiagObj.MRDIAOnsetDate
		s OutputObj.MRDIAOnsetTime=DiagObj.MRDIAOnsetTime
		s OutputObj.MRDIAEndDate=DiagObj.MRDIAEndDate
		s OutputObj.MRDIAEndTime=DiagObj.MRDIAEndTime
		s OutputObj.MRDIATimeDiagnosisIdentif=DiagObj.MRDIATimeDiagnosisIdentif
		s OutputObj.MRDIAApproximate=DiagObj.MRDIAApproximate
		s OutputObj.MRDIAMainDiagFlag=DiagObj.MRDIAMainDiagFlag
		do DiagObj.%Close()
	}
	Q OutputObj
}

}
