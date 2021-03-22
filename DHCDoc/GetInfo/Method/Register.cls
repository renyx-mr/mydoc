/// 名称:    DHCDoc.GetInfo.Method.Register
/// 描述:    挂号相关信息获取公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
/// 继承:
Class DHCDoc.GetInfo.Method.Register Extends %RegisteredObject
{

/// 描述:    就诊表相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.23
/// w ##class(DHCDoc.GetInfo.Method.Register).GetPAAdmInfo()
ClassMethod GetPAAdmInfo(PAADMRowID As %String) As DHCDoc.GetInfo.Entry.PAAdm
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.PAAdm).%New()
	s AdmObj=##class(User.PAAdm).%OpenId(PAADMRowID)
	if $ISOBJECT(AdmObj) {
		s OutputObj.PAADMRowID=PAADMRowID
		s OutputObj.PAADMADMNo=AdmObj.PAADMADMNo
		s OutputObj.PAADMPAPMIDR=AdmObj.PAADMPAPMIDR
		if $ISOBJECT(OutputObj.PAADMPAPMIDR) {
			s OutputObj.PAADMPAPMIDR=AdmObj.PAADMPAPMIDR.%Id()
		}
		s OutputObj.PAADMPatTypeDR=AdmObj.PAADMPatTypeDR
		s OutputObj.PAADMDepCodeDR=AdmObj.PAADMDepCodeDR
		if $ISOBJECT(OutputObj.PAADMDepCodeDR) {
			s OutputObj.PAADMDepCodeDR=AdmObj.PAADMDepCodeDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.PAADMDepCodeDR)
			if $ISOBJECT(LocObj) {
				s OutputObj.PAADMDepCode=LocObj.CTLOCCode
				s OutputObj.PAADMDepDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.PAADMAdmCategDR=AdmObj.PAADMAdmCategDR
		if $ISOBJECT(OutputObj.PAADMAdmCategDR) {
			s OutputObj.PAADMAdmCategDR=AdmObj.PAADMAdmCategDR.%Id()
			s AdmCatObj=##class(User.PACAdmCategory).%OpenId(OutputObj.PAADMAdmCategDR)
			if $ISOBJECT(LocObj) {
				s OutputObj.PAADMAdmCategCode=AdmCatObj.ADMCATCode
				s OutputObj.PAADMAdmCategDesc=AdmCatObj.ADMCATDesc
				do AdmCatObj.%Close()
			}
		}
		s OutputObj.PAADMAdmDate=AdmObj.PAADMAdmDate
		s OutputObj.PAADMAdmTime=AdmObj.PAADMAdmTime
		s OutputObj.PAADMType=AdmObj.PAADMType
		s OutputObj.PAADMAdmSrcDR=AdmObj.PAADMAdmSrcDR
		if $ISOBJECT(OutputObj.PAADMAdmSrcDR) {
			s OutputObj.PAADMAdmSrcDR=AdmObj.PAADMAdmSrcDR.%Id()
			s AdmSourceCatObj=##class(User.PACAdmSource).%OpenId(OutputObj.PAADMAdmSrcDR)
			if $ISOBJECT(AdmSourceCatObj) {
				s OutputObj.PAADMAdmSrcCode=AdmSourceCatObj.ADSOUCode
				s OutputObj.PAADMAdmSrcDesc=AdmSourceCatObj.ADSOUDesc
				do AdmSourceCatObj.%Close()
			}
		}
		s OutputObj.PAADMSpecialtyDR=AdmObj.PAADMSpecialtyDR
		s OutputObj.PAADMAdmDocCodeDR=AdmObj.PAADMAdmDocCodeDR
		if $ISOBJECT(OutputObj.PAADMAdmDocCodeDR) {
			s OutputObj.PAADMAdmDocCodeDR=AdmObj.PAADMAdmDocCodeDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMAdmDocCodeDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMAdmDocCode=DocObj.CTPCPCode
				s OutputObj.PAADMAdmDocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMSourceRefDR=AdmObj.PAADMSourceRefDR
		if $ISOBJECT(OutputObj.PAADMSourceRefDR) {
			s OutputObj.PAADMSourceRefDR=AdmObj.PAADMSourceRefDR.%Id()
			s AdmSrcRefObj=##class(User.PACAdmSourceRef).%OpenId(OutputObj.PAADMSourceRefDR)
			if $ISOBJECT(AdmSrcRefObj) {
				s OutputObj.PAADMSourceRefCode=AdmSrcRefObj.ADSRFCode
				s OutputObj.PAADMSourceRefDesc=AdmSrcRefObj.ADSRFDesc
				do AdmSrcRefObj.%Close()
			}
		}
		s OutputObj.PAADMExpAdmDate=AdmObj.PAADMExpAdmDate
		s OutputObj.PAADMPreAdmitted=AdmObj.PAADMPreAdmitted
		s OutputObj.PAADMRefDocCodeDR=AdmObj.PAADMRefDocCodeDR
		s OutputObj.PAADMDischgDate=AdmObj.PAADMDischgDate
		s OutputObj.PAADMDischgTime=AdmObj.PAADMDischgTime
		s OutputObj.PAADMDischgDocDR=AdmObj.PAADMDischgDocDR
		if $ISOBJECT(OutputObj.PAADMDischgDocDR) {
			s OutputObj.PAADMDischgDocDR=AdmObj.PAADMDischgDocDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMDischgDocDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMDischgDocCode=DocObj.CTPCPCode
				s OutputObj.PAADMDischgDocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMVisitStatus=AdmObj.PAADMDischgDocDR
		s OutputObj.PAADMDisposDR=AdmObj.PAADMDisposDR
		if $ISOBJECT(OutputObj.PAADMDisposDR) {
			s OutputObj.PAADMDisposDR=AdmObj.PAADMDisposDR.%Id()
			s DispositObj=##class(User.CTDisposit).%OpenId(OutputObj.PAADMDisposDR)
			if $ISOBJECT(DispositObj) {
				s OutputObj.PAADMDisposCode=DispositObj.CTDSPCode
				s OutputObj.PAADMDisposDesc=DispositObj.CTDSPDesc
				do DispositObj.%Close()
			}
		}
		s OutputObj.PAADMHCRDR=AdmObj.PAADMHCRDR
		if $ISOBJECT(OutputObj.PAADMHCRDR) {
			s OutputObj.PAADMHCRDR=AdmObj.PAADMHCRDR.%Id()
			s HealRegObj=##class(User.CTHealthCareRegion).%OpenId(OutputObj.PAADMHCRDR)
			if $ISOBJECT(HealRegObj) {
				s OutputObj.PAADMHCRCode=HealRegObj.HCRCode
				s OutputObj.PAADMHCRDesc=HealRegObj.HCRDesc
				do HealRegObj.%Close()
			}
		}
		s OutputObj.PAADMTrafficAccidentDR=AdmObj.PAADMTrafficAccidentDR
		if $ISOBJECT(OutputObj.PAADMTrafficAccidentDR) {
			s OutputObj.PAADMTrafficAccidentDR=AdmObj.PAADMTrafficAccidentDR.%Id()
			s PatTrafObj=##class(User.PATrafficAccident).%OpenId(OutputObj.PAADMTrafficAccidentDR)
			if $ISOBJECT(PatTrafObj) {
				s OutputObj.PAADMTrafficAccidentCode="" //PatTrafObj
				s OutputObj.PAADMTrafficAccidentDesc="" //PatTrafObj
				do PatTrafObj.%Close()
			}
		}
		s OutputObj.PAADMShowInFutureEpisode=AdmObj.PAADMShowInFutureEpisode
		s OutputObj.PAADMConfidential=AdmObj.PAADMConfidential
		s OutputObj.PAADMExpLOS=AdmObj.PAADMExpLOS
		s OutputObj.PAADMDischargeAppointDR=AdmObj.PAADMDischargeAppointDR
		if $ISOBJECT(OutputObj.PAADMDischargeAppointDR) {
			s OutputObj.PAADMDischargeAppointDR=AdmObj.PAADMDischargeAppointDR.%Id()
		}
		s OutputObj.PAADMRefClinicDR=AdmObj.PAADMRefClinicDR
		if $ISOBJECT(OutputObj.PAADMRefClinicDR) {
			s OutputObj.PAADMRefClinicDR=AdmObj.PAADMRefClinicDR.%Id()
			s CTRefCObj=##class(User.CTRefClin).%OpenId(OutputObj.PAADMRefClinicDR)
			if $ISOBJECT(CTRefCObj) {
				s OutputObj.PAADMRefClinicCode=CTRefCObj.CTRFCCode
				s OutputObj.PAADMRefClinicDesc=CTRefCObj.CTRFCDesc
				do CTRefCObj.%Close()
			}
		}
		s OutputObj.PAADMInPatNo=AdmObj.PAADMInPatNo
		s OutputObj.PAADMEmergencyNo=AdmObj.PAADMEmergencyNo
		s OutputObj.PAADMPreAdmNo=AdmObj.PAADMPreAdmNo
		s OutputObj.PAADMConvertedFromOut=AdmObj.PAADMConvertedFromOut
		s OutputObj.PAADMPriorityDR=AdmObj.PAADMPriorityDR
		if $ISOBJECT(OutputObj.PAADMPriorityDR) {
			s OutputObj.PAADMPriorityDR=AdmObj.PAADMPriorityDR.%Id()
			s CTAcuityObj=##class(User.CTAcuity).%OpenId(OutputObj.PAADMPriorityDR)
			if $ISOBJECT(CTAcuityObj) {
				s OutputObj.PAADMPriorityCode=CTAcuityObj.CTACUCode
				s OutputObj.PAADMPriorityDesc=CTAcuityObj.CTACUDesc
				do CTAcuityObj.%Close()
			}
		}
		s OutputObj.PAADMPreAdmitDate=AdmObj.PAADMPreAdmitDate
		s OutputObj.PAADMPreAdmitTime=AdmObj.PAADMPreAdmitTime
		s OutputObj.PAADMIsolate=AdmObj.PAADMIsolate
		s OutputObj.PAADMEmergencyDate=AdmObj.PAADMEmergencyDate
		s OutputObj.PAADMEmergencyTime=AdmObj.PAADMEmergencyTime
		s OutputObj.PAADMPaidEmergencySurcharge=AdmObj.PAADMPaidEmergencySurcharge
        s OutputObj.PAADMOriginalAdmissionDR=AdmObj.PAADMOriginalAdmissionDR
		if $ISOBJECT(OutputObj.PAADMOriginalAdmissionDR) {
			s OutputObj.PAADMOriginalAdmissionDR=AdmObj.PAADMOriginalAdmissionDR.%Id()
		}	
		s OutputObj.PAADMMealPreference=AdmObj.PAADMMealPreference
		s OutputObj.PAADMOrder=AdmObj.PAADMOrder
		s OutputObj.PAADMCreateDate=AdmObj.PAADMCreateDate
		s OutputObj.PAADMCreateTime=AdmObj.PAADMCreateTime
        s OutputObj.PAADMCreateUser=AdmObj.PAADMCreateUser
		if $ISOBJECT(OutputObj.PAADMCreateUser) {
			s OutputObj.PAADMCreateUser=AdmObj.PAADMCreateUser.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMCreateUser)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAADMCreateUserCode=UserObj.SSUSRInitials
				s OutputObj.PAADMCreateUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}	
		s OutputObj.PAADMRemark=AdmObj.PAADMRemark
		s OutputObj.PAADMBillFlag=AdmObj.PAADMBillFlag
		s OutputObj.PAADMRefDate=AdmObj.PAADMRefDate
		s OutputObj.PAADMRefExpiryDate=AdmObj.PAADMRefExpiryDate
        s OutputObj.PAADMRefApprovNo=AdmObj.PAADMRefApprovNo
		s OutputObj.PAADMTypeofPatientCalc=AdmObj.PAADMTypeofPatientCalc
		s OutputObj.PAADMEstimDischargeDate=AdmObj.PAADMEstimDischargeDate
        s OutputObj.PAADMEstimDischargeTime=AdmObj.PAADMEstimDischargeTime
        s OutputObj.PAADMDischCondDR=AdmObj.PAADMDischCondDR
		if $ISOBJECT(OutputObj.PAADMDischCondDR) {
			s OutputObj.PAADMDischCondDR=AdmObj.PAADMDischCondDR.%Id()
			s DisConObj=##class(User.PACDischCondit).%OpenId(OutputObj.PAADMDischCondDR)
			if $ISOBJECT(DisConObj) {
				s OutputObj.PAADMDischCondCode=DisConObj.DISCONCode
				s OutputObj.PAADMDischCondDesc=DisConObj.DISCONDesc
				do DisConObj.%Close()
			}
		}	
		s OutputObj.PAADMOtherDischType=AdmObj.PAADMOtherDischType
		s OutputObj.PAADMInfectDR=AdmObj.PAADMInfectDR
		if $ISOBJECT(OutputObj.PAADMInfectDR) {
			s OutputObj.PAADMInfectDR=AdmObj.PAADMInfectDR.%Id()
			s InfecTypeObj=##class(User.PACInfectionType).%OpenId(OutputObj.PAADMInfectDR)
			if $ISOBJECT(InfecTypeObj) {
				s OutputObj.PAADMInfectCode=InfecTypeObj.INFECCode
				s OutputObj.PAADMInfectDesc=InfecTypeObj.INFECDesc
				do InfecTypeObj.%Close()
			}
		}
		s OutputObj.PAADMOtherInfectType=AdmObj.PAADMOtherInfectType
		s OutputObj.PAADMEstimOperDate=AdmObj.PAADMEstimOperDate
		s OutputObj.PAADMOperDR=AdmObj.PAADMOperDR
		if $ISOBJECT(OutputObj.PAADMOperDR) {
			s OutputObj.PAADMOperDR=AdmObj.PAADMOperDR.%Id()
			s ORCOperObj=##class(User.ORCOperation).%OpenId(OutputObj.PAADMOperDR)
			if $ISOBJECT(ORCOperObj) {
				s OutputObj.PAADMOperCode=ORCOperObj.OPERCode
				s OutputObj.PAADMOperDesc=ORCOperObj.OPERDesc
				do ORCOperObj.%Close()
			}
		}
		s OutputObj.PAADMUrgent=AdmObj.PAADMUrgent
		s OutputObj.PAADMAdmReadm=AdmObj.PAADMAdmReadm
		s OutputObj.PAADMRoomTypeDR=AdmObj.PAADMRoomTypeDR
		if $ISOBJECT(OutputObj.PAADMRoomTypeDR) {
			s OutputObj.PAADMRoomTypeDR=AdmObj.PAADMRoomTypeDR.%Id()
			s RoomTypeObj=##class(User.PACRoomType).%OpenId(OutputObj.PAADMRoomTypeDR)
			if $ISOBJECT(RoomTypeObj) {
				s OutputObj.PAADMRoomTypeCode=RoomTypeObj.ROOMTCode
				s OutputObj.PAADMRoomTypeDesc=RoomTypeObj.ROOMTDesc
				do RoomTypeObj.%Close()
			}
		}
		s OutputObj.PAADMDietTypeDR=AdmObj.PAADMDietTypeDR
		if $ISOBJECT(OutputObj.PAADMDietTypeDR) {
			s OutputObj.PAADMDietTypeDR=AdmObj.PAADMDietTypeDR.%Id()
			s ARCItemCatObj=##class(User.ARCItemCat).%OpenId(OutputObj.PAADMDietTypeDR)
			if $ISOBJECT(ARCItemCatObj) {
				s OutputObj.PAADMDietTypeCode=ARCItemCatObj.ARCICCode
				s OutputObj.PAADMDietTypeDesc=ARCItemCatObj.ARCICDesc
				do ARCItemCatObj.%Close()
			}
		}
		s OutputObj.PAADMMainMRADMDR=AdmObj.PAADMMainMRADMDR
		if $ISOBJECT(OutputObj.PAADMMainMRADMDR) {
			s OutputObj.PAADMMainMRADMDR=AdmObj.PAADMMainMRADMDR.%Id()
		}
		s OutputObj.PAADMStudentMRADMDR=AdmObj.PAADMStudentMRADMDR
		if $ISOBJECT(OutputObj.PAADMStudentMRADMDR) {
			s OutputObj.PAADMStudentMRADMDR=AdmObj.PAADMStudentMRADMDR.%Id()
		}
		s OutputObj.PAADMConfidentMessage=AdmObj.PAADMConfidentMessage
		s OutputObj.PAADMApptMethodDR=AdmObj.PAADMApptMethodDR
		if $ISOBJECT(OutputObj.PAADMApptMethodDR) {
			s OutputObj.PAADMApptMethodDR=AdmObj.PAADMApptMethodDR.%Id()
			s AppointMethodObj=##class(User.RBCAppointMethod).%OpenId(OutputObj.PAADMApptMethodDR)
			if $ISOBJECT(AppointMethodObj) {
				s OutputObj.PAADMApptMethodCode=AppointMethodObj.APTMCode
				s OutputObj.PAADMApptMethodDesc=AppointMethodObj.APTMDesc
				do AppointMethodObj.%Close()
			}
		}
		s OutputObj.PAADMOrderTime=AdmObj.PAADMOrderTime
		s OutputObj.PAADMReferralType=AdmObj.PAADMReferralType
		if $ISOBJECT(OutputObj.PAADMReferralType) {
			s OutputObj.PAADMReferralType=AdmObj.PAADMReferralType.%Id()
			s RefTypeObj=##class(User.PACReferralType).%OpenId(OutputObj.PAADMReferralType)
			if $ISOBJECT(RefTypeObj) {
				s OutputObj.PAADMReferralTypeCode=RefTypeObj.REFTCode
				s OutputObj.PAADMReferralTypeDesc=RefTypeObj.REFTDesc
				do RefTypeObj.%Close()
			}
		}
		s OutputObj.PAADMAppointDR=AdmObj.PAADMAppointDR
		if $ISOBJECT(OutputObj.PAADMAppointDR) {
			s OutputObj.PAADMAppointDR=AdmObj.PAADMAppointDR.%Id()
		}
		s OutputObj.PAADMCurrentRoomDR=AdmObj.PAADMCurrentRoomDR
		if $ISOBJECT(OutputObj.PAADMCurrentRoomDR) {
			s OutputObj.PAADMCurrentRoomDR=AdmObj.PAADMCurrentRoomDR.%Id()
			s PACRoomObj=##class(User.PACRoom).%OpenId(OutputObj.PAADMCurrentRoomDR)
			if $ISOBJECT(PACRoomObj) {
				s OutputObj.PAADMCurrentRoomCode=PACRoomObj.ROOMCode
				s OutputObj.PAADMCurrentRoomDesc=PACRoomObj.ROOMDesc
				do PACRoomObj.%Close()
			}
		}
		s OutputObj.PAADMCurrentWardDR=AdmObj.PAADMCurrentWardDR
		if $ISOBJECT(OutputObj.PAADMCurrentWardDR) {
			s OutputObj.PAADMCurrentWardDR=AdmObj.PAADMCurrentWardDR.%Id()
			s PACWardObj=##class(User.PACWard).%OpenId(OutputObj.PAADMCurrentWardDR)
			if $ISOBJECT(PACWardObj) {
				s OutputObj.PAADMCurrentWardCode=PACWardObj.WARDCode
				s OutputObj.PAADMCurrentWardDesc=PACWardObj.WARDDesc
				do PACWardObj.%Close()
			}
		}
		s OutputObj.PAADMRefAdmDR=AdmObj.PAADMRefAdmDR
		s OutputObj.PAADMFirstOrReadmis=AdmObj.PAADMFirstOrReadmis
		s OutputObj.PAADMCurrentBedDR=AdmObj.PAADMCurrentBedDR
		if $ISOBJECT(OutputObj.PAADMCurrentBedDR) {
			s OutputObj.PAADMCurrentBedDR=AdmObj.PAADMCurrentBedDR.%Id()
			s PACBedObj=##class(User.PACBed).%OpenId(OutputObj.PAADMCurrentBedDR)
			if $ISOBJECT(PACBedObj) {
				s OutputObj.PAADMCurrentBedCode=PACBedObj.BEDCode
				s OutputObj.PAADMCurrentBedDesc=PACBedObj.BEDCode
				do PACBedObj.%Close()
			}
		}
		s OutputObj.PAADMTempLocDR=AdmObj.PAADMTempLocDR
		if $ISOBJECT(OutputObj.PAADMTempLocDR) {
			s OutputObj.PAADMTempLocDR=AdmObj.PAADMTempLocDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.PAADMTempLocDR)
			if $ISOBJECT(LocObj) {
				s OutputObj.PAADMTempLocCode=LocObj.CTLOCCode
				s OutputObj.PAADMTempLocDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.PAADMMotherAdmDR=AdmObj.PAADMMotherAdmDR
		if $ISOBJECT(OutputObj.PAADMMotherAdmDR) {
			s OutputObj.PAADMMotherAdmDR=AdmObj.PAADMMotherAdmDR.%Id()
		}
		s OutputObj.PAADMMedicalDischarge=AdmObj.PAADMMedicalDischarge
		s OutputObj.PAADMConvertDate=AdmObj.PAADMConvertDate
		s OutputObj.PAADMConvertTime=AdmObj.PAADMConvertTime
		s OutputObj.PAADMMedDischDocDR=AdmObj.PAADMMedDischDocDR
		if $ISOBJECT(OutputObj.PAADMMedDischDocDR) {
			s OutputObj.PAADMMedDischDocDR=AdmObj.PAADMMedDischDocDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMMedDischDocDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMMedDischDocCode=DocObj.CTPCPCode
				s OutputObj.PAADMMedDischDocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMRefDocListDR=AdmObj.PAADMRefDocListDR
		if $ISOBJECT(OutputObj.PAADMRefDocListDR) {
			s OutputObj.PAADMRefDocListDR=AdmObj.PAADMRefDocListDR.%Id()
			s RefDocObj=##class(User.PACRefDoctor).%OpenId(OutputObj.PAADMRefDocListDR)
			if $ISOBJECT(RefDocObj) {
				s OutputObj.PAADMRefDocListCode=RefDocObj.REFDCode
				s OutputObj.PAADMRefDocListDesc=RefDocObj.REFDDesc
				do RefDocObj.%Close()
			}
		}
		s OutputObj.PAADMMaritalStatusDR=AdmObj.PAADMMaritalStatusDR
		if $ISOBJECT(OutputObj.PAADMMaritalStatusDR) {
			s OutputObj.PAADMMaritalStatusDR=AdmObj.PAADMMaritalStatusDR.%Id()
			s CTMarObj=##class(User.CTMarital).%OpenId(OutputObj.PAADMMaritalStatusDR)
			if $ISOBJECT(CTMarObj) {
				s OutputObj.PAADMMaritalStatusCode=CTMarObj.CTMARCode
				s OutputObj.PAADMMaritalStatusDesc=CTMarObj.CTMARDesc
				do CTMarObj.%Close()
			}
		}
		s OutputObj.PAADMHCADR=AdmObj.PAADMHCADR
		if $ISOBJECT(OutputObj.PAADMHCADR) {
			s OutputObj.PAADMHCADR=AdmObj.PAADMHCADR.%Id()
			s CTHealObj=##class(User.CTHealthCareArea).%OpenId(OutputObj.PAADMHCADR)
			if $ISOBJECT(CTHealObj) {
				s OutputObj.PAADMHCACode=CTHealObj.HCACode
				s OutputObj.PAADMHCADesc=CTHealObj.HCADesc
				do CTHealObj.%Close()
			}
		}
		s OutputObj.PAADMRegionDR=AdmObj.PAADMRegionDR
		if $ISOBJECT(OutputObj.PAADMRegionDR) {
			s OutputObj.PAADMRegionDR=AdmObj.PAADMRegionDR.%Id()
			s CTRegionObj=##class(User.CTRegion).%OpenId(OutputObj.PAADMRegionDR)
			if $ISOBJECT(CTRegionObj) {
				s OutputObj.PAADMRegionCode=CTRegionObj.CTRGCode
				s OutputObj.PAADMRegionDesc=CTRegionObj.CTRGDesc
				do CTRegionObj.%Close()
			}
		}
		s OutputObj.PAADMCurrentProcessDR=AdmObj.PAADMCurrentProcessDR
		if $ISOBJECT(OutputObj.PAADMCurrentProcessDR) {
			s OutputObj.PAADMCurrentProcessDR=AdmObj.PAADMCurrentProcessDR.%Id()
			s PAProObj=##class(User.PAProcess).%OpenId(OutputObj.PAADMCurrentProcessDR)
			if $ISOBJECT(PAProObj) {
				s OutputObj.PAADMCurrentProcessCode="" //PAProObj.
				s OutputObj.PAADMCurrentProcessDesc="" //PAProObj.CTRGDesc
				do PAProObj.%Close()
			}
		}
		s OutputObj.PAADMPreviousProcessDR=AdmObj.PAADMPreviousProcessDR
		if $ISOBJECT(OutputObj.PAADMPreviousProcessDR) {
			s OutputObj.PAADMPreviousProcessDR=AdmObj.PAADMPreviousProcessDR.%Id()
			s PAProObj=##class(User.PAProcess).%OpenId(OutputObj.PAADMPreviousProcessDR)
			if $ISOBJECT(PAProObj) {
				s OutputObj.PAADMPreviousProcessCode="" //PAProObj.
				s OutputObj.PAADMPreviousProcessDesc="" //PAProObj.CTRGDesc
				do PAProObj.%Close()
			}
		}
		s OutputObj.PAADMEpissubtypeDR=AdmObj.PAADMEpissubtypeDR
		if $ISOBJECT(OutputObj.PAADMEpissubtypeDR) {
			s OutputObj.PAADMEpissubtypeDR=AdmObj.PAADMEpissubtypeDR.%Id()
			s PACSubTypeObj=##class(User.PACEpisodeSubType).%OpenId(OutputObj.PAADMEpissubtypeDR)
			if $ISOBJECT(PACSubTypeObj) {
				s OutputObj.PAADMEpissubtypeCode=PACSubTypeObj.SUBTCode
				s OutputObj.PAADMEpissubtypeDesc=PACSubTypeObj.SUBTDesc
				do PACSubTypeObj.%Close()
			}
		}
		s OutputObj.PAADMAdmReasonDR=AdmObj.PAADMAdmReasonDR
		if $ISOBJECT(OutputObj.PAADMAdmReasonDR) {
			s OutputObj.PAADMAdmReasonDR=AdmObj.PAADMAdmReasonDR.%Id()
			s AdmReasonObj=##class(User.PACAdmReason).%OpenId(OutputObj.PAADMAdmReasonDR)
			if $ISOBJECT(AdmReasonObj) {
				s OutputObj.PAADMAdmReasonCode=AdmReasonObj.REACode
				s OutputObj.PAADMAdmReasonDesc=AdmReasonObj.READesc
				do AdmReasonObj.%Close()
			}
		}
		s OutputObj.PAADMCauseInjDR=AdmObj.PAADMCauseInjDR
		if $ISOBJECT(OutputObj.PAADMCauseInjDR) {
			s OutputObj.PAADMCauseInjDR=AdmObj.PAADMCauseInjDR.%Id()
			s PACCauInjObj=##class(User.PACCauseOfInjury).%OpenId(OutputObj.PAADMCauseInjDR)
			if $ISOBJECT(PACCauInjObj) {
				s OutputObj.PAADMCauseInjCode=PACCauInjObj.INJUCode
				s OutputObj.PAADMCauseInjDesc=PACCauInjObj.INJUDesc
				do PACCauInjObj.%Close()
			}
		}
		s OutputObj.PAADMEmergencyStatus=AdmObj.PAADMEmergencyStatus
		s OutputObj.PAADMSeenDate=AdmObj.PAADMSeenDate
		s OutputObj.PAADMSeenTime=AdmObj.PAADMSeenTime
		s OutputObj.PAADMRegistrationFee=AdmObj.PAADMRegistrationFee
		if $ISOBJECT(OutputObj.PAADMRegistrationFee) {
			s OutputObj.PAADMRegistrationFee=AdmObj.PAADMRegistrationFee.%Id()
			s BLCReaNotRefFeeObj=##class(User.BLCReasonNotRegFee).%OpenId(OutputObj.PAADMRegistrationFee)
			if $ISOBJECT(BLCReaNotRefFeeObj) {
				s OutputObj.PAADMReasonNotRegFeeCode=BLCReaNotRefFeeObj.REGFEECode
				s OutputObj.PAADMReasonNotRegFeeDesc=BLCReaNotRefFeeObj.REGFEEDesc
				do BLCReaNotRefFeeObj.%Close()
			}
		}
		s OutputObj.PAADMSpecialCategory=AdmObj.PAADMSpecialCategory
		s OutputObj.PAADMSpecialDocument=AdmObj.PAADMSpecialDocument
        s OutputObj.PAADMLabourAccidentDR=AdmObj.PAADMLabourAccidentDR
		if $ISOBJECT(OutputObj.PAADMLabourAccidentDR) {
			s OutputObj.PAADMLabourAccidentDR=AdmObj.PAADMLabourAccidentDR.%Id()
			s PATAccObj=##class(User.PATrafficAccident).%OpenId(OutputObj.PAADMLabourAccidentDR)
			if $ISOBJECT(PATAccObj) {
				s OutputObj.PAADMLabourAccidentCode="" //PATAccObj.
				s OutputObj.PAADMLabourAccidentDesc="" //PATAccObj.REGFEEDesc
				do PATAccObj.%Close()
			}
		}
		s OutputObj.PAADMFlaggedPatient=AdmObj.PAADMFlaggedPatient
		s OutputObj.PAADMWaitListDR=AdmObj.PAADMWaitListDR
		if $ISOBJECT(OutputObj.PAADMWaitListDR) {
			s OutputObj.PAADMWaitListDR=AdmObj.PAADMWaitListDR.%Id()
			s PAWaitObj=##class(User.PAWaitingList).%OpenId(OutputObj.PAADMWaitListDR)
			if $ISOBJECT(PAWaitObj) {
				s OutputObj.PAADMWaitListCode=""
				s OutputObj.PAADMWaitListDesc="" //PATAccObj.REGFEEDesc
				do PAWaitObj.%Close()
			}
		}
		s OutputObj.PAADMFamilyDoctor=AdmObj.PAADMFamilyDoctor
		s OutputObj.PAADMReadOnly=AdmObj.PAADMReadOnly
		s OutputObj.PAADMPersonResponsiblePayment=AdmObj.PAADMPersonResponsiblePayment
		if $ISOBJECT(OutputObj.PAADMPersonResponsiblePayment) {
			s OutputObj.PAADMPersonResponsiblePayment=AdmObj.PAADMPersonResponsiblePayment.%Id()
		}
		s OutputObj.PAADMVerified=AdmObj.PAADMVerified
		s OutputObj.PAADMCompleted=AdmObj.PAADMCompleted
		s OutputObj.PAADMHCPDR=AdmObj.PAADMHCPDR
		if $ISOBJECT(OutputObj.PAADMHCPDR) {
			s OutputObj.PAADMHCPDR=AdmObj.PAADMHCPDR.%Id()
			s CTHealCareObj=##class(User.CTHealthCareProvider).%OpenId(OutputObj.PAADMHCPDR)
			if $ISOBJECT(CTHealCareObj) {
				s OutputObj.PAADMHCPCode=CTHealCareObj.HCPCode
				s OutputObj.PAADMHCPDesc=CTHealCareObj.HCPDesc
				do CTHealCareObj.%Close()
			}
		}
		s OutputObj.PAADMRefClinToDR=AdmObj.PAADMRefClinToDR
		if $ISOBJECT(OutputObj.PAADMRefClinToDR) {
			s OutputObj.PAADMRefClinToDR=AdmObj.PAADMRefClinToDR.%Id()
			s CTRefCObj=##class(User.CTRefClin).%OpenId(OutputObj.PAADMRefClinToDR)
			if $ISOBJECT(CTRefCObj) {
				s OutputObj.PAADMRefClinToCode=CTRefCObj.CTRFCCode
				s OutputObj.PAADMRefClinToDesc=CTRefCObj.CTRFCDesc
				do CTRefCObj.%Close()
			}
		}
		s OutputObj.PAADMAdmRef=AdmObj.PAADMAdmRef
		s OutputObj.PAADMSeriousDisease=AdmObj.PAADMSeriousDisease
		if $ISOBJECT(OutputObj.PAADMSeriousDisease) {
			s OutputObj.PAADMSeriousDisease=AdmObj.PAADMSeriousDisease.%Id()
			s ICDDxObj=##class(User.MRCICDDx).%OpenId(OutputObj.PAADMSeriousDisease)
			if $ISOBJECT(ICDDxObj) {
				s OutputObj.PAADMSeriousDiseaseCode=ICDDxObj.MRCIDCode
				s OutputObj.PAADMSeriousDiseaseDesc=ICDDxObj.MRCIDDesc
				do ICDDxObj.%Close()
			}
		}
		s OutputObj.PAADMMedDischDate=AdmObj.PAADMMedDischDate
		s OutputObj.PAADMMedDischTime=AdmObj.PAADMMedDischTime
		s OutputObj.PAADMTriageDate=AdmObj.PAADMTriageDate
		s OutputObj.PAADMTriageTime=AdmObj.PAADMTriageTime
		s OutputObj.PAADMLikelihoodAdmit=AdmObj.PAADMLikelihoodAdmit
		s OutputObj.PAADMHumanIntentDR=AdmObj.PAADMHumanIntentDR
		if $ISOBJECT(OutputObj.PAADMHumanIntentDR) {
			s OutputObj.PAADMHumanIntentDR=AdmObj.PAADMHumanIntentDR.%Id()
			s PACHumObj=##class(User.PACHumanIntent).%OpenId(OutputObj.PAADMHumanIntentDR)
			if $ISOBJECT(PACHumObj) {
				s OutputObj.PAADMHumanIntentCode=PACHumObj.HUMINTCode
				s OutputObj.PAADMHumanIntentDesc=PACHumObj.HUMINTDesc
				do PACHumObj.%Close()
			}
		}
		s OutputObj.PAADMPlaceOfInjDR=AdmObj.PAADMPlaceOfInjDR
		if $ISOBJECT(OutputObj.PAADMPlaceOfInjDR) {
			s OutputObj.PAADMPlaceOfInjDR=AdmObj.PAADMPlaceOfInjDR.%Id()
			s PACPOfInJObj=##class(User.PACPlaceOfInjury).%OpenId(OutputObj.PAADMPlaceOfInjDR)
			if $ISOBJECT(PACPOfInJObj) {
				s OutputObj.PAADMPlaceOfInjCode=PACPOfInJObj.PLINJCode
				s OutputObj.PAADMPlaceOfInjDesc=PACPOfInJObj.PLINJDesc
				do PACPOfInJObj.%Close()
			}
		}
		s OutputObj.PAADMActivityInjuredDR=AdmObj.PAADMActivityInjuredDR
		if $ISOBJECT(OutputObj.PAADMActivityInjuredDR) {
			s OutputObj.PAADMActivityInjuredDR=AdmObj.PAADMActivityInjuredDR.%Id()
			s PACAwHenInJObj=##class(User.PACActivityWhenInjured).%OpenId(OutputObj.PAADMActivityInjuredDR)
			if $ISOBJECT(PACAwHenInJObj) {
				s OutputObj.PAADMActivityInjuredCode=PACAwHenInJObj.ACTINJCode
				s OutputObj.PAADMActivityInjuredDesc=PACAwHenInJObj.ACTINJDesc
				do PACAwHenInJObj.%Close()
			}
		}
		s OutputObj.PAADMOccupationDR=AdmObj.PAADMOccupationDR
		if $ISOBJECT(OutputObj.PAADMOccupationDR) {
			s OutputObj.PAADMOccupationDR=AdmObj.PAADMOccupationDR.%Id()
			s CTOccPationObj=##class(User.CTOccupation).%OpenId(OutputObj.PAADMOccupationDR)
			if $ISOBJECT(CTOccPationObj) {
				s OutputObj.PAADMOccupationCode=CTOccPationObj.CTOCCCode
				s OutputObj.PAADMOccupationDesc=CTOccPationObj.CTOCCDesc
				do CTOccPationObj.%Close()
			}
		}
		s OutputObj.PAADMPersonRespPayment=AdmObj.PAADMPersonRespPayment
		s OutputObj.PAADMRequestMR=AdmObj.PAADMRequestMR
		s OutputObj.PAADMInpatBedReqDate=AdmObj.PAADMInpatBedReqDate
		s OutputObj.PAADMInpatBedReqTime=AdmObj.PAADMInpatBedReqTime		
		s OutputObj.PAADMCClass=AdmObj.PAADMCClass
		s OutputObj.PAADMUpdateDate=AdmObj.PAADMUpdateDate
		s OutputObj.PAADMUpdateTime=AdmObj.PAADMUpdateTime
		s OutputObj.PAADMUpdateUserDR=AdmObj.PAADMUpdateUserDR
		if $ISOBJECT(OutputObj.PAADMUpdateUserDR) {
			s OutputObj.PAADMUpdateUserDR=AdmObj.PAADMUpdateUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMUpdateUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAADMUpdateUserCode=UserObj.SSUSRInitials
				s OutputObj.PAADMUpdateUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.PAADMRefDocClinicDR=AdmObj.PAADMRefDocClinicDR
		if $ISOBJECT(OutputObj.PAADMRefDocClinicDR) {
			s OutputObj.PAADMRefDocClinicDR=AdmObj.PAADMRefDocClinicDR.%Id()
			s PACRefDocCObj=##class(User.PACRefDoctorClinic).%OpenId(OutputObj.PAADMRefDocClinicDR)
			if $ISOBJECT(PACRefDocCObj) {
				s OutputObj.PAADMRefDocClinicCode=PACRefDocCObj.CLNCode
				s OutputObj.PAADMRefDocClinicDesc=PACRefDocCObj.CLNCode
				do PACRefDocCObj.%Close()
			}
		}
		s OutputObj.PAADMCurrentResourceDR=AdmObj.PAADMCurrentResourceDR
		if $ISOBJECT(OutputObj.PAADMCurrentResourceDR) {
			s OutputObj.PAADMCurrentResourceDR=AdmObj.PAADMCurrentResourceDR.%Id()
			s RBResObj=##class(User.RBResource).%OpenId(OutputObj.PAADMCurrentResourceDR)
			if $ISOBJECT(RBResObj) {
				s OutputObj.PAADMCurrentResourceCode=RBResObj.RESCode
				s OutputObj.PAADMCurrentResourceDesc=RBResObj.RESDesc
				do RBResObj.%Close()
			}
		}
		s OutputObj.PAADMConfirmReferral=AdmObj.PAADMConfirmReferral
		s OutputObj.PAADMRefPeriodDR=AdmObj.PAADMRefPeriodDR
		if $ISOBJECT(OutputObj.PAADMRefPeriodDR) {
			s OutputObj.PAADMRefPeriodDR=AdmObj.PAADMRefPeriodDR.%Id()
			s PACRefPObj=##class(User.PACReferralPeriod).%OpenId(OutputObj.PAADMRefPeriodDR)
			if $ISOBJECT(PACRefPObj) {
				s OutputObj.PAADMRefPeriodCode=PACRefPObj.REFPERCode
				s OutputObj.PAADMRefPeriodDesc=PACRefPObj.REFPERDesc
				do PACRefPObj.%Close()
			}
		}
		s OutputObj.PAADMOSVisitStatusDR=AdmObj.PAADMOSVisitStatusDR
		if $ISOBJECT(OutputObj.PAADMOSVisitStatusDR) {
			s OutputObj.PAADMOSVisitStatusDR=AdmObj.PAADMOSVisitStatusDR.%Id()
			s PACOSVStaObj=##class(User.PACOSVisitorStatus).%OpenId(OutputObj.PAADMOSVisitStatusDR)
			if $ISOBJECT(PACOSVStaObj) {
				s OutputObj.PAADMOSVisitStatusCode=PACOSVStaObj.OVSCode
				s OutputObj.PAADMOSVisitStatusDesc=PACOSVStaObj.OVSDesc
				do PACOSVStaObj.%Close()
			}
		}
		s OutputObj.PAADMDateRefDecision=AdmObj.PAADMDateRefDecision
		s OutputObj.PAADMMethodRefDR=AdmObj.PAADMMethodRefDR
		if $ISOBJECT(OutputObj.PAADMMethodRefDR) {
			s OutputObj.PAADMMethodRefDR=AdmObj.PAADMMethodRefDR.%Id()
			s PACRefMethObj=##class(User.PACRefReceiptMethod).%OpenId(OutputObj.PAADMMethodRefDR)
			if $ISOBJECT(PACRefMethObj) {
				s OutputObj.PAADMMethodRefCode=PACRefMethObj.REFMETHCode
				s OutputObj.PAADMMethodRefDesc=PACRefMethObj.REFMETHDesc
				do PACRefMethObj.%Close()
			}
		}
		s OutputObj.PAADMReferralPriorityDR=AdmObj.PAADMReferralPriorityDR
		if $ISOBJECT(OutputObj.PAADMReferralPriorityDR) {
			s OutputObj.PAADMReferralPriorityDR=AdmObj.PAADMReferralPriorityDR.%Id()
			s PACRefPriObj=##class(User.PACReferralPriority).%OpenId(OutputObj.PAADMReferralPriorityDR)
			if $ISOBJECT(PACRefPriObj) {
				s OutputObj.PAADMReferralPriorityCode=PACRefPriObj.REFPRICode
				s OutputObj.PAADMReferralPriorityDesc=PACRefPriObj.REFPRIDesc
				do PACRefPriObj.%Close()
			}
		}
		s OutputObj.PAADMTumourSiteGroupDR=AdmObj.PAADMTumourSiteGroupDR
		if $ISOBJECT(OutputObj.PAADMTumourSiteGroupDR) {
			s OutputObj.PAADMTumourSiteGroupDR=AdmObj.PAADMTumourSiteGroupDR.%Id()
			s PACTSiteGObj=##class(User.PACTumourSiteGroup).%OpenId(OutputObj.PAADMTumourSiteGroupDR)
			if $ISOBJECT(PACTSiteGObj) {
				s OutputObj.PAADMTumourSiteGroupCode=PACTSiteGObj.TUMSGCode
				s OutputObj.PAADMTumourSiteGroupDesc=PACTSiteGObj.TUMSGDesc
				do PACTSiteGObj.%Close()
			}
		}
		s OutputObj.PAADMReasonDelDischDR=AdmObj.PAADMReasonDelDischDR
		if $ISOBJECT(OutputObj.PAADMReasonDelDischDR) {
			s OutputObj.PAADMTumourSiteGroupDR=AdmObj.PAADMReasonDelDischDR.%Id()
			s PACReaDDObj=##class(User.PACReasonDelayDischarge).%OpenId(OutputObj.PAADMReasonDelDischDR)
			if $ISOBJECT(PACReaDDObj) {
				s OutputObj.PAADMReasonDelDischCode=PACReaDDObj.READELCode
				s OutputObj.PAADMReasonDelDischDesc=PACReaDDObj.READELDesc
				do PACReaDDObj.%Close()
			}
		}
		s OutputObj.PAADMHospChaplainVisitReq=AdmObj.PAADMHospChaplainVisitReq
		s OutputObj.PAADMOwnMinisterIndicator=AdmObj.PAADMOwnMinisterIndicator
		s OutputObj.PAADMGuaranteeAdmDate=AdmObj.PAADMGuaranteeAdmDate
		s OutputObj.PAADMAEArrivalModeDR=AdmObj.PAADMAEArrivalModeDR
		if $ISOBJECT(OutputObj.PAADMAEArrivalModeDR) {
			s OutputObj.PAADMAEArrivalModeDR=AdmObj.PAADMAEArrivalModeDR.%Id()
			s PACArrModeObj=##class(User.PACAEArrivalMode).%OpenId(OutputObj.PAADMAEArrivalModeDR)
			if $ISOBJECT(PACArrModeObj) {
				s OutputObj.PAADMAEArrivalModeCode=PACArrModeObj.AEARMCode
				s OutputObj.PAADMAEArrivalModeDesc=PACArrModeObj.AEARMDesc
				do PACArrModeObj.%Close()
			}
		}
		s OutputObj.PAADMInternalRefDocDR=AdmObj.PAADMInternalRefDocDR
		if $ISOBJECT(OutputObj.PAADMInternalRefDocDR) {
			s OutputObj.PAADMInternalRefDocDR=AdmObj.PAADMInternalRefDocDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMInternalRefDocDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMInternalRefDocCode=DocObj.CTPCPCode
				s OutputObj.PAADMInternalRefDocDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMHomerID=AdmObj.PAADMHomerID
		s OutputObj.PAADMRefDrConsent=AdmObj.PAADMRefDrConsent
		s OutputObj.PAADMAdmMethodDR=AdmObj.PAADMAdmMethodDR
		if $ISOBJECT(OutputObj.PAADMAdmMethodDR) {
			s OutputObj.PAADMAdmMethodDR=AdmObj.PAADMAdmMethodDR.%Id()
			s PACAMethodObj=##class(User.PACAdmissionMethod).%OpenId(OutputObj.PAADMAdmMethodDR)
			if $ISOBJECT(PACAMethodObj) {
				s OutputObj.PAADMAdmMethodCode=PACAMethodObj.ADMETHCode
				s OutputObj.PAADMAdmMethodDesc=PACAMethodObj.ADMETHDesc
				do PACAMethodObj.%Close()
			}
		}
		s OutputObj.PAADMDateHCPRequestSent=AdmObj.PAADMDateHCPRequestSent
		s OutputObj.PAADMDateHCPreceived=AdmObj.PAADMDateHCPreceived
		s OutputObj.PAADMHCPPriorityDR=AdmObj.PAADMHCPPriorityDR
		if $ISOBJECT(OutputObj.PAADMHCPPriorityDR) {
			s OutputObj.PAADMHCPPriorityDR=AdmObj.PAADMHCPPriorityDR.%Id()
			s PACHCPPriObj=##class(User.PACHCPPriority).%OpenId(OutputObj.PAADMHCPPriorityDR)
			if $ISOBJECT(PACAMethodObj) {
				s OutputObj.PAADMHCPPriorityCode=PACHCPPriObj.HCPPCode
				s OutputObj.PAADMHCPPriorityDesc=PACHCPPriObj.HCPPDesc
				do PACAMethodObj.%Close()
			}
		}
		s OutputObj.PAADMAppointTransportDR=AdmObj.PAADMAppointTransportDR
		if $ISOBJECT(OutputObj.PAADMAppointTransportDR) {
			s OutputObj.PAADMAppointTransportDR=AdmObj.PAADMAppointTransportDR.%Id()
			s RBCATransObj=##class(User.RBCAppointTransport).%OpenId(OutputObj.PAADMAppointTransportDR)
			if $ISOBJECT(RBCATransObj) {
				s OutputObj.PAADMAppointTransportCode=RBCATransObj.APTRCode
				s OutputObj.PAADMAppointTransportDesc=RBCATransObj.APTRDesc
				do RBCATransObj.%Close()
			}
		}
		s OutputObj.PAADMPoliceDivision=AdmObj.PAADMPoliceDivision
		s OutputObj.PAADMSpecificLoc=AdmObj.PAADMSpecificLoc
		s OutputObj.PAADMChaplainName=AdmObj.PAADMChaplainName
		s OutputObj.PAADMChaplainChurchAddress=AdmObj.PAADMChaplainChurchAddress
		s OutputObj.PAADMChaplainPhone=AdmObj.PAADMChaplainPhone
		s OutputObj.PAADMDateOfEntry=AdmObj.PAADMDateOfEntry
		s OutputObj.PAADMInterviewedBy=AdmObj.PAADMInterviewedBy
		s OutputObj.PAADMDateOfInterview=AdmObj.PAADMDateOfInterview
		s OutputObj.PAADMInterviewRec=AdmObj.PAADMInterviewRec
		s OutputObj.PAADMOverseasVisitor=AdmObj.PAADMOverseasVisitor
        s OutputObj.PAADMOSVCountryFromDR=AdmObj.PAADMOSVCountryFromDR
		if $ISOBJECT(OutputObj.PAADMOSVCountryFromDR) {
			s OutputObj.PAADMOSVCountryFromDR=AdmObj.PAADMOSVCountryFromDR.%Id()
			s CTCountryObj=##class(User.CTCountry).%OpenId(OutputObj.PAADMOSVCountryFromDR)
			if $ISOBJECT(CTCountryObj) {
				s OutputObj.PAADMOSVCountryFromCode=CTCountryObj.CTCOUCode
				s OutputObj.PAADMOSVCountryFromDesc=CTCountryObj.CTCOUDesc
				do CTCountryObj.%Close()
			}
		}
		s OutputObj.PAADMOtherHospital=AdmObj.PAADMOtherHospital
		s OutputObj.PAADMPermanentResident=AdmObj.PAADMPermanentResident
        s OutputObj.PAADMDateReceived=AdmObj.PAADMDateReceived	
		s OutputObj.PAADMSourceOfAttendDR=AdmObj.PAADMSourceOfAttendDR
		if $ISOBJECT(OutputObj.PAADMSourceOfAttendDR) {
			s OutputObj.PAADMSourceOfAttendDR=AdmObj.PAADMSourceOfAttendDR.%Id()
			s PACSOfAObj=##class(User.PACSourceOfAttendance).%OpenId(OutputObj.PAADMSourceOfAttendDR)
			if $ISOBJECT(PACSOfAObj) {
				s OutputObj.PAADMSourceOfAttendCode=PACSOfAObj.ATTENDCode
				s OutputObj.PAADMSourceOfAttendDesc=PACSOfAObj.ATTENDDesc
				do PACSOfAObj.%Close()
			}
		}
		s OutputObj.PAADMMajorIncidentDR=AdmObj.PAADMMajorIncidentDR
		if $ISOBJECT(OutputObj.PAADMMajorIncidentDR) {
			s OutputObj.PAADMMajorIncidentDR=AdmObj.PAADMMajorIncidentDR.%Id()
			s PAMInObj=##class(User.PAMajorIncident).%OpenId(OutputObj.PAADMMajorIncidentDR)
			if $ISOBJECT(PAMInObj) {
				s OutputObj.PAADMMajorIncidentCode=""
				s OutputObj.PAADMMajorIncidentDesc=""
				do PAMInObj.%Close()
			}
		}
		s OutputObj.PAADMReportDate=AdmObj.PAADMReportDate
		s OutputObj.PAADMOESubCatDR=AdmObj.PAADMOESubCatDR
		if $ISOBJECT(OutputObj.PAADMOESubCatDR) {
			s OutputObj.PAADMOESubCatDR=AdmObj.PAADMOESubCatDR.%Id()
			s ARCItemCatObj=##class(User.ARCItemCat).%OpenId(OutputObj.PAADMOESubCatDR)
			if $ISOBJECT(ARCItemCatObj) {
				s OutputObj.PAADMOESubCatCode=ARCItemCatObj.ARCICCode
				s OutputObj.PAADMOESubCatDesc=ARCItemCatObj.ARCICDesc
				do ARCItemCatObj.%Close()
			}
		}
		s OutputObj.PAADMRefStatDR=AdmObj.PAADMRefStatDR
		if $ISOBJECT(OutputObj.PAADMRefStatDR) {
			s OutputObj.PAADMRefStatDR=AdmObj.PAADMRefStatDR.%Id()
			s PACRefStaObj=##class(User.PACReferralStatus).%OpenId(OutputObj.PAADMRefStatDR)
			if $ISOBJECT(PACRefStaObj) {
				s OutputObj.PAADMRefStatCode=PACRefStaObj.RSTCode
				s OutputObj.PAADMRefStatDesc=PACRefStaObj.RSTDesc
				do PACRefStaObj.%Close()
			}
		}
		s OutputObj.PAADMPostDischStatusDR=AdmObj.PAADMPostDischStatusDR
		if $ISOBJECT(OutputObj.PAADMPostDischStatusDR) {
			s OutputObj.PAADMPostDischStatusDR=AdmObj.PAADMPostDischStatusDR.%Id()
			s RTCDStaObj=##class(User.RTCPostDischargeStatus).%OpenId(OutputObj.PAADMPostDischStatusDR)
			if $ISOBJECT(RTCDStaObj) {
				s OutputObj.PAADMPostDischStatusCode=RTCDStaObj.MRSTATCode
				s OutputObj.PAADMPostDischStatusDesc=RTCDStaObj.MRSTATDesc
				do RTCDStaObj.%Close()
			}
		}
		s OutputObj.PAADMDNAReason=AdmObj.PAADMDNAReason
		if $ISOBJECT(OutputObj.PAADMDNAReason) {
			s OutputObj.PAADMDNAReason=AdmObj.PAADMDNAReason.%Id()
			s PACWLReaObj=##class(User.PACWLReasonNotAvail).%OpenId(OutputObj.PAADMDNAReason)
			if $ISOBJECT(PACWLReaObj) {
				s OutputObj.PAADMDNAReasonCode=PACWLReaObj.REACode
				s OutputObj.PAADMDNAReasonDesc=PACWLReaObj.READesc
				do PACWLReaObj.%Close()
			}
		}
		s OutputObj.PAADMNursingNotesFlag=AdmObj.PAADMNursingNotesFlag
		s OutputObj.PAADMCancelReasonDR=AdmObj.PAADMCancelReasonDR
		if $ISOBJECT(OutputObj.PAADMCancelReasonDR) {
			s OutputObj.PAADMCancelReasonDR=AdmObj.PAADMCancelReasonDR.%Id()
			s PACAdmCanReaObj=##class(User.PACAdmCancelReason).%OpenId(OutputObj.PAADMCancelReasonDR)
			if $ISOBJECT(PACAdmCanReaObj) {
				s OutputObj.PAADMCancelReasonCode=PACAdmCanReaObj.ADMCRCode
				s OutputObj.PAADMCancelReasonDesc=PACAdmCanReaObj.ADMCRDesc
				do PACAdmCanReaObj.%Close()
			}
		}
		s OutputObj.PAADMConsentRecFundInfo=AdmObj.PAADMConsentRecFundInfo
		s OutputObj.PAADMConsentPatSatisfSurve=AdmObj.PAADMConsentPatSatisfSurve
		s OutputObj.PAADMFrequentAdmissions=AdmObj.PAADMFrequentAdmissions
		s OutputObj.PAADMDischComments=AdmObj.PAADMDischComments
		s OutputObj.PAADMPatientContacted=AdmObj.PAADMPatientContacted
		s OutputObj.PAADMLikelyTransICUDR=AdmObj.PAADMLikelyTransICUDR
		if $ISOBJECT(OutputObj.PAADMLikelyTransICUDR) {
			s OutputObj.PAADMLikelyTransICUDR=AdmObj.PAADMLikelyTransICUDR.%Id()
			s PACLTransICUObj=##class(User.PACLikelyTransferoutICU).%OpenId(OutputObj.PAADMLikelyTransICUDR)
			if $ISOBJECT(PACLTransICUObj) {
				s OutputObj.PAADMLikelyTransICUCode=PACLTransICUObj.LTICUCode
				s OutputObj.PAADMLikelyTransICUDesc=PACLTransICUObj.LTICUDesc
				do PACLTransICUObj.%Close()
			}
		}
		s OutputObj.PAADMEstDischConfirmed=AdmObj.PAADMEstDischConfirmed
		s OutputObj.PAADMPatClassifDR=AdmObj.PAADMPatClassifDR
		if $ISOBJECT(OutputObj.PAADMPatClassifDR) {
			s OutputObj.PAADMPatClassifDR=AdmObj.PAADMPatClassifDR.%Id()
			s PACPtClaObj=##class(User.PACPatientClassification).%OpenId(OutputObj.PAADMPatClassifDR)
			if $ISOBJECT(PACPtClaObj) {
				s OutputObj.PAADMPatClassifCode=PACPtClaObj.PCLASSCode
				s OutputObj.PAADMPatClassifDesc=PACPtClaObj.PCLASSDesc
				do PACPtClaObj.%Close()
			}
		}
		s OutputObj.PAADMConvertUserDR=AdmObj.PAADMConvertUserDR
		if $ISOBJECT(OutputObj.PAADMConvertUserDR) {
			s OutputObj.PAADMConvertUserDR=AdmObj.PAADMConvertUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMConvertUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAADMConvertUserCode=UserObj.SSUSRInitials
				s OutputObj.PAADMConvertUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.PAADMInPatAdmTypeDR=AdmObj.PAADMInPatAdmTypeDR
		if $ISOBJECT(OutputObj.PAADMInPatAdmTypeDR) {
			s OutputObj.PAADMInPatAdmTypeDR=AdmObj.PAADMInPatAdmTypeDR.%Id()
			s PACInPatTypeObj=##class(User.PACInPatAdmissionType).%OpenId(OutputObj.PAADMInPatAdmTypeDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAADMInPatAdmTypeCode=PACInPatTypeObj.IPATCode
				s OutputObj.PAADMInPatAdmTypeDesc=PACInPatTypeObj.IPATDesc
				do PACInPatTypeObj.%Close()
			}
		}
		s OutputObj.PAADMAdmissionFIM=AdmObj.PAADMAdmissionFIM
		s OutputObj.PAADMDischargeFIM=AdmObj.PAADMDischargeFIM
		s OutputObj.PAADMRelated=AdmObj.PAADMRelated
		s OutputObj.PAADMTreatingDrDR=AdmObj.PAADMTreatingDrDR
		if $ISOBJECT(OutputObj.PAADMTreatingDrDR) {
			s OutputObj.PAADMTreatingDrDR=AdmObj.PAADMTreatingDrDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMTreatingDrDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMTreatingDrCode=DocObj.CTPCPCode
				s OutputObj.PAADMTreatingDrDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMContractSpokeDR=AdmObj.PAADMContractSpokeDR
		if $ISOBJECT(OutputObj.PAADMContractSpokeDR) {
			s OutputObj.PAADMContractSpokeDR=AdmObj.PAADMContractSpokeDR.%Id()
			s PACConSpoIObj=##class(User.PACContractSpokIdentifier).%OpenId(OutputObj.PAADMContractSpokeDR)
			if $ISOBJECT(PACConSpoIObj) {
				s OutputObj.PAADMContractSpokeCode=PACConSpoIObj.CSICode
				s OutputObj.PAADMContractSpokeDesc=PACConSpoIObj.CSIDesc
				do PACConSpoIObj.%Close()
			}
		}
		s OutputObj.PAADMContractTypeDR=AdmObj.PAADMContractTypeDR
		if $ISOBJECT(OutputObj.PAADMContractTypeDR) {
			s OutputObj.PAADMContractTypeDR=AdmObj.PAADMContractTypeDR.%Id()
			s PACConTypeObj=##class(User.PACContractType).%OpenId(OutputObj.PAADMContractTypeDR)
			if $ISOBJECT(PACConTypeObj) {
				s OutputObj.PAADMContractTypeCode=PACConTypeObj.CONTRTYPECode
				s OutputObj.PAADMContractTypeDesc=PACConTypeObj.CONTRTYPEDesc
				do PACConTypeObj.%Close()
			}
		}
		s OutputObj.PAADMContractRoleDR=AdmObj.PAADMContractRoleDR
		if $ISOBJECT(OutputObj.PAADMContractRoleDR) {
			s OutputObj.PAADMContractRoleDR=AdmObj.PAADMContractRoleDR.%Id()
			s PACConRObj=##class(User.PACContractRole).%OpenId(OutputObj.PAADMContractRoleDR)
			if $ISOBJECT(PACConRObj) {
				s OutputObj.PAADMContractRoleCode=PACConRObj.CONTROLCode
				s OutputObj.PAADMContractRoleDesc=PACConRObj.CONTROLDesc
				do PACConRObj.%Close()
			}
		}
		s OutputObj.PAADMFundingArrangementDR=AdmObj.PAADMFundingArrangementDR
		if $ISOBJECT(OutputObj.PAADMFundingArrangementDR) {
			s OutputObj.PAADMFundingArrangementDR=AdmObj.PAADMFundingArrangementDR.%Id()
			s PACFunArrObj=##class(User.PACFundingArrangement).%OpenId(OutputObj.PAADMFundingArrangementDR)
			if $ISOBJECT(PACFunArrObj) {
				s OutputObj.PAADMFundingArrangementCode=PACFunArrObj.FUNDARCode
				s OutputObj.PAADMFundingArrangementDesc=PACFunArrObj.FUNDARDesc
				do PACFunArrObj.%Close()
			}
		}
		s OutputObj.PAADMBillingMethodDR=AdmObj.PAADMBillingMethodDR
		if $ISOBJECT(OutputObj.PAADMBillingMethodDR) {
			s OutputObj.PAADMBillingMethodDR=AdmObj.PAADMBillingMethodDR.%Id()
			s PACBillMethodObj=##class(User.PACBillingMethod).%OpenId(OutputObj.PAADMBillingMethodDR)
			if $ISOBJECT(PACBillMethodObj) {
				s OutputObj.PAADMBillingMethodCode=PACBillMethodObj.BLMCode
				s OutputObj.PAADMBillingMethodDesc=PACBillMethodObj.BLMDesc
				do PACBillMethodObj.%Close()
			}
		}
		s OutputObj.PAADMPalliativeCareDR=AdmObj.PAADMPalliativeCareDR
		if $ISOBJECT(OutputObj.PAADMPalliativeCareDR) {
			s OutputObj.PAADMPalliativeCareDR=AdmObj.PAADMPalliativeCareDR.%Id()
			s PACPallCStateObj=##class(User.PACPalliativeCareState).%OpenId(OutputObj.PAADMPalliativeCareDR)
			if $ISOBJECT(PACPallCStateObj) {
				s OutputObj.PAADMPalliativeCareCode=PACPallCStateObj.PCSCode
				s OutputObj.PAADMPalliativeCareDesc=PACPallCStateObj.PCSDesc
				do PACPallCStateObj.%Close()
			}
		}
		s OutputObj.PAADMBedMobilityDR=AdmObj.PAADMBedMobilityDR
		if $ISOBJECT(OutputObj.PAADMBedMobilityDR) {
			s OutputObj.PAADMBedMobilityDR=AdmObj.PAADMBedMobilityDR.%Id()
			s PACBedMObj=##class(User.PACBedMobility).%OpenId(OutputObj.PAADMBedMobilityDR)
			if $ISOBJECT(PACBedMObj) {
				s OutputObj.PAADMBedMobilityCode=PACBedMObj.BMCode
				s OutputObj.PAADMBedMobilityDesc=PACBedMObj.BMDesc
				do PACBedMObj.%Close()
			}
		}
		s OutputObj.PAADMToiletingDR=AdmObj.PAADMToiletingDR
		if $ISOBJECT(OutputObj.PAADMToiletingDR) {
			s OutputObj.PAADMToiletingDR=AdmObj.PAADMToiletingDR.%Id()
			s PACToiletObj=##class(User.PACToileting).%OpenId(OutputObj.PAADMToiletingDR)
			if $ISOBJECT(PACToiletObj) {
				s OutputObj.PAADMToiletingCode=PACToiletObj.TOILCode
				s OutputObj.PAADMToiletingDesc=PACToiletObj.TOILDesc
				do PACToiletObj.%Close()
			}
		}
		s OutputObj.PAADMTransferDR=AdmObj.PAADMTransferDR
		if $ISOBJECT(OutputObj.PAADMTransferDR) {
			s OutputObj.PAADMTransferDR=AdmObj.PAADMTransferDR.%Id()
			s PACTransObj=##class(User.PACTransferring).%OpenId(OutputObj.PAADMTransferDR)
			if $ISOBJECT(PACTransObj) {
				s OutputObj.PAADMTransferCode=PACTransObj.TRANSFCode
				s OutputObj.PAADMTransferDesc=PACTransObj.TRANSFDesc
				do PACTransObj.%Close()
			}
		}
		s OutputObj.PAADMEatingDR=AdmObj.PAADMEatingDR
		if $ISOBJECT(OutputObj.PAADMEatingDR) {
			s OutputObj.PAADMEatingDR=AdmObj.PAADMEatingDR.%Id()
			s PACEatObj=##class(User.PACEating).%OpenId(OutputObj.PAADMEatingDR)
			if $ISOBJECT(PACEatObj) {
				s OutputObj.PAADMEatingCode=PACEatObj.EATCode
				s OutputObj.PAADMEatingDesc=PACEatObj.EATDesc
				do PACEatObj.%Close()
			}
		}
		s OutputObj.PAADMRUGTotal=AdmObj.PAADMRUGTotal
		s OutputObj.PAADMBarthelScore=AdmObj.PAADMBarthelScore
		s OutputObj.PAADMDischargeBarthelScore=AdmObj.PAADMDischargeBarthelScore
		s OutputObj.PAADMClinicalSubProgramDR=AdmObj.PAADMClinicalSubProgramDR
		if $ISOBJECT(OutputObj.PAADMClinicalSubProgramDR) {
			s OutputObj.PAADMClinicalSubProgramDR=AdmObj.PAADMClinicalSubProgramDR.%Id()
			s PACCSubPObj=##class(User.PACClinicalSubProgram).%OpenId(OutputObj.PAADMClinicalSubProgramDR)
			if $ISOBJECT(PACCSubPObj) {
				s OutputObj.PAADMClinicalSubProgramCode=PACCSubPObj.CSPCode
				s OutputObj.PAADMClinicalSubProgramDesc=PACCSubPObj.CSPDesc
				do PACCSubPObj.%Close()
			}
		}
		s OutputObj.PAADMReadmToRehabDR=AdmObj.PAADMReadmToRehabDR
		if $ISOBJECT(OutputObj.PAADMReadmToRehabDR) {
			s OutputObj.PAADMReadmToRehabDR=AdmObj.PAADMReadmToRehabDR.%Id()
			s PACReaObj=##class(User.PACReAdmissionToRehab).%OpenId(OutputObj.PAADMReadmToRehabDR)
			if $ISOBJECT(PACReaObj) {
				s OutputObj.PAADMReadmToRehabCode=PACReaObj.RTRCode
				s OutputObj.PAADMReadmToRehabDesc=PACReaObj.RTRDesc
				do PACReaObj.%Close()
			}
		}
		s OutputObj.PAADMOnsetDate=AdmObj.PAADMOnsetDate
		s OutputObj.PAADMMiniMentalAssScore=AdmObj.PAADMMiniMentalAssScore
		s OutputObj.PAADMTriageNurseDR=AdmObj.PAADMTriageNurseDR
		if $ISOBJECT(OutputObj.PAADMTriageNurseDR) {
			s OutputObj.PAADMTriageNurseDR=AdmObj.PAADMTriageNurseDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMTriageNurseDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMTriageNurseCode=DocObj.CTPCPCode
				s OutputObj.PAADMTriageNurseDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMStatePPPDR=AdmObj.PAADMStatePPPDR
		if $ISOBJECT(OutputObj.PAADMStatePPPDR) {
			s OutputObj.PAADMStatePPPDR=AdmObj.PAADMStatePPPDR.%Id()
			s PACStaPPPObj=##class(User.PACStatePPP).%OpenId(OutputObj.PAADMStatePPPDR)
			if $ISOBJECT(PACStaPPPObj) {
				s OutputObj.PAADMStatePPPCode=PACStaPPPObj.SPPPCode
				s OutputObj.PAADMStatePPPDesc=PACStaPPPObj.SPPPDesc
				do PACStaPPPObj.%Close()
			}
		}
		s OutputObj.PAADMDaySurgeryType=AdmObj.PAADMDaySurgeryType
		s OutputObj.PAADMTransferFacility=AdmObj.PAADMTransferFacility
		s OutputObj.PAADMAppointBookingSystemDR=AdmObj.PAADMAppointBookingSystemDR
		if $ISOBJECT(OutputObj.PAADMAppointBookingSystemDR) {
			s OutputObj.PAADMAppointBookingSystemDR=AdmObj.PAADMAppointBookingSystemDR.%Id()
			s PACApptObj=##class(User.PACApptBookingSystem).%OpenId(OutputObj.PAADMAppointBookingSystemDR)
			if $ISOBJECT(PACApptObj) {
				s OutputObj.PAADMAppointBookingSystemCode=PACApptObj.APPTBSCode
				s OutputObj.PAADMAppointBookingSystemDesc=PACApptObj.APPTBSDesc
				do PACApptObj.%Close()
			}
		}
		s OutputObj.PAADMParentWardDR=AdmObj.PAADMParentWardDR
		if $ISOBJECT(OutputObj.PAADMParentWardDR) {
			s OutputObj.PAADMParentWardDR=AdmObj.PAADMParentWardDR.%Id()
			s PACWardObj=##class(User.PACWard).%OpenId(OutputObj.PAADMParentWardDR)
			if $ISOBJECT(PACWardObj) {
				s OutputObj.PAADMParentWardCode=PACWardObj.WARDCode
				s OutputObj.PAADMParentWardDesc=PACWardObj.WARDDesc
				do PACWardObj.%Close()
			}
		}
		s OutputObj.PAADMPatAcuityDR=AdmObj.PAADMPatAcuityDR
		if $ISOBJECT(OutputObj.PAADMPatAcuityDR) {
			s OutputObj.PAADMPatAcuityDR=AdmObj.PAADMPatAcuityDR.%Id()
			s PACPatObj=##class(User.PACPatAcuity).%OpenId(OutputObj.PAADMPatAcuityDR)
			if $ISOBJECT(PACPatObj) {
				s OutputObj.PAADMPatAcuityCode=PACPatObj.ACUCode
				s OutputObj.PAADMPatAcuityDesc=PACPatObj.ACUDesc
				do PACPatObj.%Close()
			}
		}
		s OutputObj.PAADMSecondaryReasonDR=AdmObj.PAADMSecondaryReasonDR
		if $ISOBJECT(OutputObj.PAADMSecondaryReasonDR) {
			s OutputObj.PAADMSecondaryReasonDR=AdmObj.PAADMSecondaryReasonDR.%Id()
			s PACAdmReaObj=##class(User.PACAdmReason).%OpenId(OutputObj.PAADMSecondaryReasonDR)
			if $ISOBJECT(PACAdmReaObj) {
				s OutputObj.PAADMSecondaryReasonCode=PACAdmReaObj.REACode
				s OutputObj.PAADMSecondaryReasonDesc=PACAdmReaObj.READesc
				do PACAdmReaObj.%Close()
			}
		}
		s OutputObj.PAADMDateDischHosp=AdmObj.PAADMDateDischHosp
		s OutputObj.PAADMCaseManagerDR=AdmObj.PAADMCaseManagerDR
		if $ISOBJECT(OutputObj.PAADMCaseManagerDR) {
			s OutputObj.PAADMCaseManagerDR=AdmObj.PAADMCaseManagerDR.%Id()
			s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAADMCaseManagerDR)
			if $ISOBJECT(DocObj) {
				s OutputObj.PAADMCaseManagerCode=DocObj.CTPCPCode
				s OutputObj.PAADMCaseManagerDesc=DocObj.CTPCPDesc
				do DocObj.%Close()
			}
		}
		s OutputObj.PAADMDateFirstAppt=AdmObj.PAADMDateFirstAppt
		s OutputObj.PAADMLastContactFamily=AdmObj.PAADMLastContactFamily
		s OutputObj.PAADMRejectionReason=AdmObj.PAADMRejectionReason
		s OutputObj.PAADMLongStay=AdmObj.PAADMLongStay
		s OutputObj.PAADMInternalRefLocDR=AdmObj.PAADMInternalRefLocDR
		if $ISOBJECT(OutputObj.PAADMInternalRefLocDR) {
			s OutputObj.PAADMInternalRefLocDR=AdmObj.PAADMInternalRefLocDR.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.PAADMInternalRefLocDR)
			if $ISOBJECT(LocObj) {
				s OutputObj.PAADMInternalRefLocCode=LocObj.CTLOCCode
				s OutputObj.PAADMInternalRefLocDesc=LocObj.CTLOCDesc
				do LocObj.%Close()
			}
		}
		s OutputObj.PAADMDatePatRefferedAssess=AdmObj.PAADMDatePatRefferedAssess
		s OutputObj.PAADMDateSocialWorkerAlloc=AdmObj.PAADMDateSocialWorkerAlloc
		s OutputObj.PAADMDateSocialWorkerCompleted=AdmObj.PAADMDateSocialWorkerCompleted
		s OutputObj.PAADMDateAssessmentCompleted=AdmObj.PAADMDateAssessmentCompleted
		s OutputObj.PAADMSocialWorkerName=AdmObj.PAADMSocialWorkerName
		s OutputObj.PAADMPatDestination=AdmObj.PAADMPatDestination
		s OutputObj.PAADMDelayReason=AdmObj.PAADMDelayReason
		s OutputObj.PAADMHasCommunSocWorker=AdmObj.PAADMHasCommunSocWorker
		s OutputObj.PAADMHasFunding=AdmObj.PAADMHasFunding
		s OutputObj.PAADMAutocodeRequired=AdmObj.PAADMAutocodeRequired
        s OutputObj.PAADMSocialWorkerCentreDR=AdmObj.PAADMSocialWorkerCentreDR
		if $ISOBJECT(OutputObj.PAADMSocialWorkerCentreDR) {
			s OutputObj.PAADMSocialWorkerCentreDR=AdmObj.PAADMSocialWorkerCentreDR.%Id()
			s CTSocWCenObj=##class(User.CTSocWorkerCentre).%OpenId(OutputObj.PAADMSocialWorkerCentreDR)
			if $ISOBJECT(CTSocWCenObj) {
				s OutputObj.PAADMSocialWorkerCentreCode=CTSocWCenObj.SWCCode
				s OutputObj.PAADMSocialWorkerCentreDesc=CTSocWCenObj.SWCDesc
				do CTSocWCenObj.%Close()
			}
		}	
		s OutputObj.PAADMLocalAuthorityDR=AdmObj.PAADMLocalAuthorityDR
		if $ISOBJECT(OutputObj.PAADMLocalAuthorityDR) {
			s OutputObj.PAADMLocalAuthorityDR=AdmObj.PAADMLocalAuthorityDR.%Id()
			s CTLocAuObj=##class(User.CTLocalAuthority).%OpenId(OutputObj.PAADMLocalAuthorityDR)
			if $ISOBJECT(CTLocAuObj) {
				s OutputObj.PAADMLocalAuthorityCode=CTLocAuObj.LOCAUTHCode
				s OutputObj.PAADMLocalAuthorityDesc=CTLocAuObj.LOCAUTHDesc
				do CTLocAuObj.%Close()
			}
		}
		s OutputObj.PAADMNonGovOrgDR=AdmObj.PAADMNonGovOrgDR
		if $ISOBJECT(OutputObj.PAADMNonGovOrgDR) {
			s OutputObj.PAADMNonGovOrgDR=AdmObj.PAADMNonGovOrgDR.%Id()
			s PACNonGObj=##class(User.PACNonGovOrg).%OpenId(OutputObj.PAADMNonGovOrgDR)
			if $ISOBJECT(PACNonGObj) {
				s OutputObj.PAADMNonGovOrgCode=PACNonGObj.NGOCode
				s OutputObj.PAADMNonGovOrgDesc=PACNonGObj.NGODesc
				do PACNonGObj.%Close()
			}
		}
		s OutputObj.PAADMTempLocDate=AdmObj.PAADMTempLocDate
		s OutputObj.PAADMTempLocTime=AdmObj.PAADMTempLocTime
		s OutputObj.PAADMQualifStatusDR=AdmObj.PAADMQualifStatusDR
		if $ISOBJECT(OutputObj.PAADMQualifStatusDR) {
			s OutputObj.PAADMQualifStatusDR=AdmObj.PAADMQualifStatusDR.%Id()
			s PACQStaObj=##class(User.PACQualificationStatus).%OpenId(OutputObj.PAADMQualifStatusDR)
			if $ISOBJECT(PACQStaObj) {
				s OutputObj.PAADMQualifStatusCode=PACQStaObj.QUALCode
				s OutputObj.PAADMQualifStatusDesc=PACQStaObj.QUALDesc
				do PACQStaObj.%Close()
			}
		}
		s OutputObj.PAADMSuspectCancerTypeDR=AdmObj.PAADMSuspectCancerTypeDR
		if $ISOBJECT(OutputObj.PAADMSuspectCancerTypeDR) {
			s OutputObj.PAADMSuspectCancerTypeDR=AdmObj.PAADMSuspectCancerTypeDR.%Id()
			s PACSuObj=##class(User.PACSuspectCancerType).%OpenId(OutputObj.PAADMSuspectCancerTypeDR)
			if $ISOBJECT(PACSuObj) {
				s OutputObj.PAADMSuspectCancerTypeCode=PACSuObj.CANCCode
				s OutputObj.PAADMSuspectCancerTypeDesc=PACSuObj.CANCDesc
				do PACQStaObj.%Close()
			}
		}
		s OutputObj.PAADMPregnancyDR=AdmObj.PAADMPregnancyDR
		if $ISOBJECT(OutputObj.PAADMPregnancyDR) {
			s OutputObj.PAADMPregnancyDR=AdmObj.PAADMPregnancyDR.%Id()
			s PAPreObj=##class(User.PAPregnancy).%OpenId(OutputObj.PAADMPregnancyDR)
			if $ISOBJECT(PAPreObj) {
				s OutputObj.PAADMPregnancyCode="" //PAPreObj.
				s OutputObj.PAADMPregnancyDesc="" //PAPreObj.CANCDesc
				do PAPreObj.%Close()
			}
		}
		s OutputObj.PAADMRefToNonGovDR=AdmObj.PAADMRefToNonGovDR
		if $ISOBJECT(OutputObj.PAADMRefToNonGovDR) {
			s OutputObj.PAADMRefToNonGovDR=AdmObj.PAADMRefToNonGovDR.%Id()
			s PACNonGovObj=##class(User.PACNonGovOrg).%OpenId(OutputObj.PAADMRefToNonGovDR)
			if $ISOBJECT(PAPreObj) {
				s OutputObj.PAADMRefToNonGovCode=PACNonGovObj.NGOCode
				s OutputObj.PAADMRefToNonGovDesc=PACNonGovObj.NGODesc
				do PACNonGovObj.%Close()
			}
		}
		s OutputObj.PAADMRefToNGOContactName=AdmObj.PAADMRefToNGOContactName
		s OutputObj.PAADMRefOrgAddress=AdmObj.PAADMRefOrgAddress
		s OutputObj.PAADMDischgHospital=AdmObj.PAADMDischgHospital
		s OutputObj.PAADMHospitalDR=AdmObj.PAADMHospitalDR
		if $ISOBJECT(OutputObj.PAADMHospitalDR) {
			s OutputObj.PAADMHospitalDR=AdmObj.PAADMHospitalDR.%Id()
			s CTHospObj=##class(User.CTHospital).%OpenId(OutputObj.PAADMHospitalDR)
			if $ISOBJECT(CTHospObj) {
				s OutputObj.PAADMHospitalCode=CTHospObj.HOSPCode
				s OutputObj.PAADMHospitalDesc=CTHospObj.HOSPDesc
				do CTHospObj.%Close()
			}
		}
		s OutputObj.PAADMViewablebyEpCareProv=AdmObj.PAADMViewablebyEpCareProv
		s OutputObj.PAADMMaternityVisTypeDR=AdmObj.PAADMMaternityVisTypeDR
		if $ISOBJECT(OutputObj.PAADMMaternityVisTypeDR) {
			s OutputObj.PAADMMaternityVisTypeDR=AdmObj.PAADMMaternityVisTypeDR.%Id()
			s PACMTypeObj=##class(User.PACMaternityVisitType).%OpenId(OutputObj.PAADMMaternityVisTypeDR)
			if $ISOBJECT(PACMTypeObj) {
				s OutputObj.PAADMMaternityVisTypeCode=PACMTypeObj.MATVTCode
				s OutputObj.PAADMMaternityVisTypeDesc=PACMTypeObj.MATVTDesc
				do PACMTypeObj.%Close()
			}
		}
		s OutputObj.PAADMLabClinicalCondition=AdmObj.PAADMLabClinicalCondition
		s OutputObj.PAADMTelephoneActive=AdmObj.PAADMTelephoneActive
		s OutputObj.PAADMCodingUpdateDate=AdmObj.PAADMCodingUpdateDate
		s OutputObj.PAADMCodingUpdateTime=AdmObj.PAADMCodingUpdateTime
		s OutputObj.PAADMCodingUpdateUserDR=AdmObj.PAADMCodingUpdateUserDR
		if $ISOBJECT(OutputObj.PAADMCodingUpdateUserDR) {
			s OutputObj.PAADMCodingUpdateUserDR=AdmObj.PAADMCodingUpdateUserDR.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMCodingUpdateUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAADMCodingUpdateUserCode=UserObj.SSUSRInitials
				s OutputObj.PAADMCodingUpdateUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.PAADMCreatePreadmission=AdmObj.PAADMCreatePreadmission
        s OutputObj.PAADMBookLocReady=AdmObj.PAADMBookLocReady
		s OutputObj.PAADMDaysCarriedForward=AdmObj.PAADMDaysCarriedForward
		s OutputObj.PAADMRBCCancelReasonDR=AdmObj.PAADMRBCCancelReasonDR
		if $ISOBJECT(OutputObj.PAADMRBCCancelReasonDR) {
			s OutputObj.PAADMRBCCancelReasonDR=AdmObj.PAADMRBCCancelReasonDR.%Id()
			s RBCReaForCancObj=##class(User.RBCReasonForCancel).%OpenId(OutputObj.PAADMRBCCancelReasonDR)
			if $ISOBJECT(RBCReaForCancObj) {
				s OutputObj.PAADMRBCCancelReasonCode=RBCReaForCancObj.RFCCode
				s OutputObj.PAADMRBCCancelReasonDesc=RBCReaForCancObj.RFCDesc
				do RBCReaForCancObj.%Close()
			}
		}
		s OutputObj.PAADMUpdateUserHospitalDR=AdmObj.PAADMUpdateUserHospitalDR
		if $ISOBJECT(OutputObj.PAADMUpdateUserHospitalDR) {
			s OutputObj.PAADMUpdateUserHospitalDR=AdmObj.PAADMUpdateUserHospitalDR.%Id()
			s HospObj=##class(User.CTHospital).%OpenId(OutputObj.PAADMUpdateUserHospitalDR)
			if $ISOBJECT(HospObj) {
				s OutputObj.PAADMUpdateUserHospitalCode=HospObj.HOSPCode
				s OutputObj.PAADMUpdateUserHospitalDesc=HospObj.HOSPDesc
				do HospObj.%Close()
			}
		}
		s OutputObj.PAADMConsentDVA=AdmObj.PAADMConsentDVA
		s OutputObj.PAADMConsentWorkCompens=AdmObj.PAADMConsentWorkCompens
		s OutputObj.PAADMConsentMotorVehicle=AdmObj.PAADMConsentMotorVehicle
		s OutputObj.PAADMConsentDepOfDefence=AdmObj.PAADMConsentDepOfDefence
		s OutputObj.PAADMConsentFeedback=AdmObj.PAADMConsentFeedback
		s OutputObj.PAADMPrevInPatAdmPalliativeCare=AdmObj.PAADMPrevInPatAdmPalliativeCare
		s OutputObj.PAADMPrevNonInPatPalliativeCare=AdmObj.PAADMPrevNonInPatPalliativeCare
		s OutputObj.PAADMDoctorLetterNotes=AdmObj.PAADMDoctorLetterNotes
		s OutputObj.PAADMPatientLetterNotes=AdmObj.PAADMPatientLetterNotes
		s OutputObj.PAADMAuditLetterResponse=AdmObj.PAADMAuditLetterResponse
		s OutputObj.PAADMUsualAccomDR=AdmObj.PAADMUsualAccomDR
		if $ISOBJECT(OutputObj.PAADMUsualAccomDR) {
			s OutputObj.PAADMUsualAccomDR=AdmObj.PAADMUsualAccomDR.%Id()
			s PACUAccObj=##class(User.PACUsualAccomodation).%OpenId(OutputObj.PAADMUsualAccomDR)
			if $ISOBJECT(PACUAccObj) {
				s OutputObj.PAADMUsualAccomCode=PACUAccObj.USACCCode
				s OutputObj.PAADMUsualAccomDesc=PACUAccObj.USACCDesc
				do PACUAccObj.%Close()
			}
		}
		s OutputObj.PAADMFinDischDate=AdmObj.PAADMFinDischDate
		s OutputObj.PAADMFinDischTime=AdmObj.PAADMFinDischTime
		s OutputObj.PAADMInjuryIncidentDate=AdmObj.PAADMInjuryIncidentDate
        s OutputObj.PAADMPAAdm2DR=AdmObj.PAADMPAAdm2DR
		if $ISOBJECT(OutputObj.PAADMPAAdm2DR) {
			s OutputObj.PAADMPAAdm2DR=AdmObj.PAADMPAAdm2DR.%Id()
		}
		s AdmExtObj=##class(User.PAAdmExt).%OpenId(PAADMRowID)
	    if $ISOBJECT(AdmExtObj) {
		    s OutputObj.PAADMCheckInsued=AdmExtObj.PAADMCheckInsued
		    s OutputObj.PAADMCheckInsuUserDR=AdmExtObj.PAADMCheckInsuUserDR
		    if $ISOBJECT(OutputObj.PAADMUsualAccomDR) {
				s OutputObj.PAADMCheckInsuUserDR=AdmExtObj.PAADMCheckInsuUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMCheckInsuUserDR)
				if $ISOBJECT(UserObj) {
					s OutputObj.PAADMCheckInsuUserCode=UserObj.SSUSRInitials
					s OutputObj.PAADMCheckInsuUserDesc=UserObj.SSUSRName
					do UserObj.%Close()
				}
			}
			s OutputObj.PAADMCheckInsurDate=AdmExtObj.PAADMCheckInsurDate
			s OutputObj.PAADMCheckInsurTime=AdmExtObj.PAADMCheckInsurTime
			s OutputObj.PAADMTransferFlag=AdmExtObj.PAADMTransferFlag
			s OutputObj.PAADMCTEscortUnits=AdmExtObj.PAADMCTEscortUnits
			s OutputObj.PAADMEscortPerson=AdmExtObj.PAADMEscortPerson
			s OutputObj.PAADMNotDistDrugsFlag=AdmExtObj.PAADMNotDistDrugsFlag
			s OutputObj.PAADMBregType=AdmExtObj.PAADMBregType
            s OutputObj.PAADMArriveDepDR=AdmExtObj.PAADMArriveDepDR
		    if $ISOBJECT(OutputObj.PAADMArriveDepDR) {
				s OutputObj.PAADMArriveDepDR=AdmExtObj.PAADMArriveDepDR.%Id()
				s LocObj=##class(User.CTLoc).%OpenId(OutputObj.PAADMArriveDepDR)
				if $ISOBJECT(LocObj) {
					s OutputObj.PAADMArriveDepCode=LocObj.CTLOCCode
					s OutputObj.PAADMArriveDepDesc=LocObj.CTLOCDesc
					do LocObj.%Close()
				}
			}	
			s OutputObj.PAADMRecallFlag=AdmExtObj.PAADMRecallFlag
			s OutputObj.PAADMReturnFlag=AdmExtObj.PAADMReturnFlag
			s OutputObj.PAADMILIFlag=AdmExtObj.PAADMILIFlag
            s OutputObj.PAADMAntibApplyEm=AdmExtObj.PAADMAntibApplyEm
			s OutputObj.PAADMAdmWay=AdmExtObj.PAADMAdmWay
			s OutputObj.PAADMMedApplyFlag=AdmExtObj.PAADMMedApplyFlag
            s OutputObj.PAADMAusFlag=AdmExtObj.PAADMAusFlag
            s OutputObj.PAADMAusUserDR=AdmExtObj.PAADMAusUserDR
		    if $ISOBJECT(OutputObj.PAADMAusUserDR) {
				s OutputObj.PAADMAusUserDR=AdmExtObj.PAADMAusUserDR.%Id()
				s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAADMAusUserDR)
				if $ISOBJECT(UserObj) {
					s OutputObj.PAADMAusUserCode=UserObj.SSUSRInitials
					s OutputObj.PAADMAusUserDesc=UserObj.SSUSRName
					do UserObj.%Close()
				}
			}	
			s OutputObj.PAADMAusDate=AdmExtObj.PAADMAusDate
			s OutputObj.PAADMAusTime=AdmExtObj.PAADMAusTime
			s OutputObj.PAADMAusRemark=AdmExtObj.PAADMAusRemark
            s OutputObj.PAADMSpecPersonFlag=AdmExtObj.PAADMSpecPersonFlag
            s OutputObj.PAADMInsuPersonType=AdmExtObj.PAADMInsuPersonType
            s OutputObj.PAADMDiagnosCatDR=AdmExtObj.PAADMDiagnosCatDR
		    if $ISOBJECT(OutputObj.PAADMDiagnosCatDR) {
				s OutputObj.PAADMDiagnosCatDR=AdmExtObj.PAADMDiagnosCatDR.%Id()
				s DiagCatObj=##class(User.DHCDiagnosCat).%OpenId(OutputObj.PAADMDiagnosCatDR)
				if $ISOBJECT(DiagCatObj) {
					s OutputObj.PAADMDiagnosCatCode=DiagCatObj.DCCode
					s OutputObj.PAADMDiagnosCatDesc=DiagCatObj.DCDesc
					do DiagCatObj.%Close()
				}
			}  
			s OutputObj.PAADMRegConDisDR=AdmExtObj.PAADMRegConDisDR
		    if $ISOBJECT(OutputObj.PAADMRegConDisDR) {
				s OutputObj.PAADMRegConDisDR=AdmExtObj.PAADMRegConDisDR.%Id()
				s RegConObj=##class(User.DHCRegConDisCount).%OpenId(OutputObj.PAADMRegConDisDR)
				if $ISOBJECT(RegConObj) {
					s OutputObj.PAADMRegConDisDode=RegConObj.RCDCode
					s OutputObj.PAADMRegConDisDesc=RegConObj.RCDDesc
					do RegConObj.%Close()
				}
			} 
			s OutputObj.PAADMFirstTreatFlag=AdmExtObj.PAADMFirstTreatFlag 
			s OutputObj.PAADMOPReturnReasonDR=AdmExtObj.PAADMOPReturnReasonDR
		    if $ISOBJECT(OutputObj.PAADMOPReturnReasonDR) {
				s OutputObj.PAADMOPReturnReasonDR=AdmExtObj.PAADMOPReturnReasonDR.%Id()
				s ReturnReaObj=##class(User.DHCOPReturnReason).%OpenId(OutputObj.PAADMOPReturnReasonDR)
				if $ISOBJECT(ReturnReaObj) {
					s OutputObj.PAADMOPReturnReasonCode=ReturnReaObj.ReturnCode
					s OutputObj.PAADMOPReturnReasonDesc=ReturnReaObj.ReturnDesc
					do ReturnReaObj.%Close()
				}
			}     
			s OutputObj.PAADMDischgOrderId=AdmExtObj.PAADMDischgOrderId
		    if $ISOBJECT(OutputObj.PAADMDischgOrderId) {
				s OutputObj.PAADMDischgOrderId=AdmExtObj.PAADMDischgOrderId.%Id()
				s OrdItemObj=##class(User.OEOrdItem).%OpenId(OutputObj.PAADMDischgOrderId)
				if $ISOBJECT(OrdItemObj) {
					s ArcItemObj=##class(User.ARCItmMast).%OpenId(OrdItemObj.OEORIItmMastDR.%Id())
					if $ISOBJECT(ArcItemObj) {
						s OutputObj.PAADMDischgOrderCode=ArcItemObj.ARCIMCode
						s OutputObj.PAADMDischgOrderDesc=ArcItemObj.ARCIMDesc
						do ArcItemObj.%Close()
					}
					do OrdItemObj.%Close()
				}
			} 	
			s OutputObj.PAADMDischargeDate=AdmExtObj.PAADMDischargeDate
			s OutputObj.PAADMDischargeTime=AdmExtObj.PAADMDischargeTime
			s OutputObj.PAADMAdminDate=AdmExtObj.PAADMAdminDate
			s OutputObj.PAADMAdminTime=AdmExtObj.PAADMAdminTime		
            s OutputObj.PAADMAdminLoc=AdmExtObj.PAADMAdminLoc
		    if $ISOBJECT(OutputObj.PAADMAdminLoc) {
				s OutputObj.PAADMAdminLoc=AdmExtObj.PAADMAdminLoc.%Id()
				s LocObj=##class(User.CTLoc).%OpenId(OutputObj.PAADMAdminLoc)
				if $ISOBJECT(LocObj) {
					s OutputObj.PAADMAdminLocCode=LocObj.CTLOCCode
					s OutputObj.PAADMAdminLocDesc=LocObj.CTLOCDesc
					do LocObj.%Close()
				}
			} 			
			s OutputObj.PAADMAdminWard=AdmExtObj.PAADMAdminWard
		    if $ISOBJECT(OutputObj.PAADMAdminWard) {
				s OutputObj.PAADMAdminWard=AdmExtObj.PAADMAdminWard.%Id()
				s WardObj=##class(User.PACWard).%OpenId(OutputObj.PAADMAdminWard)
				if $ISOBJECT(WardObj) {
					s OutputObj.PAADMAdminWardCode=WardObj.WARDCode
					s OutputObj.PAADMAdminWardDesc=WardObj.WARDDesc
					do WardObj.%Close()
				}
			} 
		    do AdmExtObj.%Close()
	    }
		do AdmObj.%Close()
	}
	Q OutputObj
}

/// 描述:    挂号流水表相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.24
/// w ##class(DHCDoc.GetInfo.Method.Register).GetRegistrationFeeInfo()
ClassMethod GetRegistrationFeeInfo(RegfeeRowId As %String) As DHCDoc.GetInfo.Entry.DHCRegistrationFee
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.DHCRegistrationFee).%New()
	s RegistObj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	if $ISOBJECT(RegistObj) {
		s OutputObj.ID=RegfeeRowId
		s OutputObj.RegfeeAdmDr=RegistObj.RegfeeAdmDr
		s OutputObj.RegfeeArcDr=RegistObj.RegfeeArcDr
        s OutputObj.RegfeeArcPrice=RegistObj.RegfeeArcPrice
        s OutputObj.RegfeeBespFlag=RegistObj.RegfeeBespFlag
        s OutputObj.RegfeeDate=RegistObj.RegfeeDate
        s OutputObj.RegfeeDepDr=RegistObj.RegfeeDepDr
        s LocObj=##class(User.CTLoc).%OpenId(OutputObj.RegfeeDepDr)
		if $ISOBJECT(LocObj) {
			s OutputObj.RegfeeDepCode=LocObj.CTLOCCode
			s OutputObj.RegfeeDepDesc=LocObj.CTLOCDesc
		}
		do LocObj.%Close()
		s OutputObj.RegfeeDoFlag=RegistObj.RegfeeDoFlag 
        s OutputObj.RegfeeDocDr=RegistObj.RegfeeDocDr
        s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.RegfeeDocDr)
		if $ISOBJECT(DocObj) {
			s OutputObj.RegfeeDocCode=DocObj.CTPCPCode
			s OutputObj.RegfeeDocDesc=DocObj.CTPCPDesc
		}
		do DocObj.%Close()
        s OutputObj.RegfeeLookPrice=RegistObj.RegfeeLookPrice
        s OutputObj.RegfeeName=RegistObj.RegfeeName
        s OutputObj.RegfeeNo=RegistObj.RegfeeNo
        s OutputObj.RegfeePrint=RegistObj.RegfeePrint
        s OutputObj.RegfeeRBASDr=RegistObj.RegfeeRBASDr
        s OutputObj.RegfeeRoomDr=RegistObj.RegfeeRoomDr
        s RoomObj=##class(User.PACRoom).%OpenId(OutputObj.RegfeeDocDr)
		if $ISOBJECT(RoomObj) {
			s OutputObj.RegfeeRoomCode=RoomObj.ROOMCode
			s OutputObj.RegfeeRoomDesc=RoomObj.ROOMDesc
			do RoomObj.%Close()
		}
		s OutputObj.RegfeeSessionTypeDr=RegistObj.RegfeeSessionTypeDr
        s SessTypeObj=##class(User.RBCSessionType).%OpenId(OutputObj.RegfeeSessionTypeDr)
		if $ISOBJECT(SessTypeObj) {
			s OutputObj.RegfeeSessionTypeCode=SessTypeObj.SESSCode
			s OutputObj.RegfeeSessionTypeDesc=SessTypeObj.SESSDesc
			do SessTypeObj.%Close()
		}
        s OutputObj.RegfeeTime=RegistObj.RegfeeTime
        s OutputObj.RegfeeTimeRangeDr=RegistObj.RegfeeTimeRangeDr
        s TimeRangeObj=##class(User.DHCTimeRange).%OpenId(OutputObj.RegfeeTimeRangeDr)
		if $ISOBJECT(TimeRangeObj) {
			s OutputObj.RegfeeTimeRangeCode=TimeRangeObj.TRCode
			s OutputObj.RegfeeTimeRangeDesc=TimeRangeObj.TRDesc
			do TimeRangeObj.%Close()
		}
        s OutputObj.RegfeeUserDr=RegistObj.RegfeeUserDr
        s UserObj=##class(User.SSUser).%OpenId(OutputObj.RegfeeUserDr)
		if $ISOBJECT(UserObj) {
			s OutputObj.RegfeeUserCode=UserObj.SSUSRInitials
			s OutputObj.RegfeeUserDesc=UserObj.SSUSRName
			do UserObj.%Close()
		}
        s OutputObj.Regfeetemp1=RegistObj.Regfeetemp1
        s OutputObj.Regfeetemp2=RegistObj.Regfeetemp2
        s OutputObj.RegTransferFlag=RegistObj.RegTransferFlag
        s OutputObj.RegTransferReDoc=RegistObj.RegTransferReDoc
        s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.RegTransferReDoc)
		if $ISOBJECT(DocObj) {
			s OutputObj.RegTransferReDocCode=DocObj.CTPCPCode
			s OutputObj.RegTransferReDocDesc=DocObj.CTPCPDesc
			do DocObj.%Close()
		}
        s OutputObj.RegfeeInsuAdmDr=RegistObj.RegfeeInsuAdmDr
        s OutputObj.RegfeeInsuCash=RegistObj.RegfeeInsuCash
        s OutputObj.RegfeeInsuCount=RegistObj.RegfeeInsuCount
        s OutputObj.RegfeeInsuFund=RegistObj.RegfeeInsuFund
        s OutputObj.RegfeeInsuOverallPlanning=RegistObj.RegfeeInsuOverallPlanning
        s OutputObj.RegfeeInsuOther=RegistObj.RegfeeInsuOther
        s OutputObj.RegfeeInsuCoDR=RegistObj.RegfeeInsuCoDR
        s OutputObj.RegfeeInsuCoProDR=RegistObj.RegfeeInsuCoProDR
        s OutputObj.RegfeeInsuCoPatPay=RegistObj.RegfeeInsuCoPatPay
        s OutputObj.RegfeePrintUserDR=RegistObj.RegfeePrintUserDR
        if $ISOBJECT(OutputObj.RegfeePrintUserDR) {
	        s OutputObj.RegfeePrintUserDR=RegistObj.RegfeePrintUserDR.%Id()
	        s UserObj=##class(User.SSUser).%OpenId(OutputObj.RegfeePrintUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.RegfeePrintUserCode=UserObj.SSUSRInitials
				s OutputObj.RegfeePrintUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
	    }
	    s OutputObj.RegfeePrintDate=RegistObj.RegfeePrintDate
        s OutputObj.RegfeePrintTime=RegistObj.RegfeePrintTime
        s OutputObj.RegfeeInvReportDR=RegistObj.RegfeeInvReportDR
        if $ISOBJECT(OutputObj.RegfeeInvReportDR) {
	        s OutputObj.RegfeeInvReportDR=RegistObj.RegfeeInvReportDR.%Id()
	    }
        s OutputObj.RegfeeHandinUserDR=RegistObj.RegfeeHandinUserDR
        if $ISOBJECT(OutputObj.RegfeeHandinUserDR) {
	        s OutputObj.RegfeeHandinUserDR=RegistObj.RegfeeHandinUserDR.%Id()
	        s UserObj=##class(User.SSUser).%OpenId(OutputObj.RegfeeHandinUserDR)
			if $ISOBJECT(UserObj) {
				s OutputObj.RegfeeHandinUserCode=UserObj.SSUSRInitials
				s OutputObj.RegfeeHandinUserDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
	    }
	    s OutputObj.RegfeeHandinDate=RegistObj.RegfeeHandinDate
	    s OutputObj.RegfeeHandinTime=RegistObj.RegfeeHandinTime
	    s OutputObj.RegfeeMethodSeqNo=RegistObj.RegfeeMethodSeqNo
	    s OutputObj.RegfeeTransactionId=RegistObj.RegfeeTransactionId
        do RegistObj.%Close()
	}
	Q OutputObj
}

}
