Class DHCDoc.GetInfo.Entry.PAAdm Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊ID
Property PAADMRowID As %String(TRUNCATE = 1);

/// 就诊号
Property PAADMADMNo As %String(TRUNCATE = 1);

/// 病人ID(指向PA_PatMas)
Property PAADMPAPMIDR As %String(TRUNCATE = 1);

/// ?
Property PAADMPatTypeDR As %String(TRUNCATE = 1);

/// 就诊科室ID (指向CT_Loc)
Property PAADMDepCodeDR As %String(TRUNCATE = 1);

/// 就诊科室Code
Property PAADMDepCode As %String(TRUNCATE = 1);

/// 就诊科室描述
Property PAADMDepDesc As %String(TRUNCATE = 1);

/// 就诊通道指针(指向PAC_AdmCategory)
Property PAADMAdmCategDR As %String(TRUNCATE = 1);

/// 就诊通道Code
Property PAADMAdmCategCode As %String(TRUNCATE = 1);

/// 就诊通道描述
Property PAADMAdmCategDesc As %String(TRUNCATE = 1);

/// 就诊日期
Property PAADMAdmDate As %String(TRUNCATE = 1);

/// 就诊时间
Property PAADMAdmTime As %String(TRUNCATE = 1);

/// 就诊类型
Property PAADMType As %String(TRUNCATE = 1);

/// 就诊来源指针(指向PACAdmSource)
Property PAADMAdmSrcDR As %String(TRUNCATE = 1);

/// 就诊来源Code
Property PAADMAdmSrcCode As %String(TRUNCATE = 1);

/// 就诊来源描述
Property PAADMAdmSrcDesc As %String(TRUNCATE = 1);

/// 就诊**?
Property PAADMSpecialtyDR As %String(TRUNCATE = 1);

/// 就诊医生指针(指向CT_CareProv)
Property PAADMAdmDocCodeDR As %String(TRUNCATE = 1);

/// 就诊医生Code
Property PAADMAdmDocCode As %String(TRUNCATE = 1);

/// 就诊医生描述
Property PAADMAdmDocDesc As %String(TRUNCATE = 1);

/// 就诊**？指针(指向PAC_AdmSourceRef)
Property PAADMSourceRefDR As %String(TRUNCATE = 1);

/// 就诊**？Code
Property PAADMSourceRefCode As %String(TRUNCATE = 1);

/// 就诊**？描述
Property PAADMSourceRefDesc As %String(TRUNCATE = 1);

/// 就诊**?
Property PAADMExpAdmDate As %String(TRUNCATE = 1);

/// 预就诊标志
Property PAADMPreAdmitted As %String(TRUNCATE = 1);

/// ***？
Property PAADMRefDocCodeDR As %String(TRUNCATE = 1);

/// 出院日期
Property PAADMDischgDate As %String(TRUNCATE = 1);

/// 出院时间
Property PAADMDischgTime As %String(TRUNCATE = 1);

/// 出院医生指针(指向CT_CareProv)
Property PAADMDischgDocDR As %String(TRUNCATE = 1);

/// 出院医生Code
Property PAADMDischgDocCode As %String(TRUNCATE = 1);

/// 出院医生描述
Property PAADMDischgDocDesc As %String(TRUNCATE = 1);

/// 就诊状态
Property PAADMVisitStatus As %String(TRUNCATE = 1);

/// 就诊***？指针(指向CT_Disposit)
Property PAADMDisposDR As %String(TRUNCATE = 1);

/// 就诊***？Code
Property PAADMDisposCode As %String(TRUNCATE = 1);

/// 就诊***？描述
Property PAADMDisposDesc As %String(TRUNCATE = 1);

/// 就诊健康区域指针(指向CT_HealthCareRegion)
Property PAADMHCRDR As %String(TRUNCATE = 1);

/// 就诊健康区域Code
Property PAADMHCRCode As %String(TRUNCATE = 1);

/// 就诊健康区域描述
Property PAADMHCRDesc As %String(TRUNCATE = 1);

/// 就诊***指针？(指向PA_TrafficAccident)
Property PAADMTrafficAccidentDR As %String(TRUNCATE = 1);

/// 就诊***Code
Property PAADMTrafficAccidentCode As %String(TRUNCATE = 1);

/// 就诊***描述
Property PAADMTrafficAccidentDesc As %String(TRUNCATE = 1);

/// 就诊***?
Property PAADMShowInFutureEpisode As %String(TRUNCATE = 1);

/// 就诊***?
Property PAADMConfidential As %String(TRUNCATE = 1);

/// 就诊***?
Property PAADMExpLOS As %String(TRUNCATE = 1);

/// 就诊***?指针(指向RB_Appointment)
Property PAADMDischargeAppointDR As %String(TRUNCATE = 1);

/// 就诊***？指针(指向CT_RefClin)
Property PAADMRefClinicDR As %String(TRUNCATE = 1);

/// 就诊***？Code
Property PAADMRefClinicCode As %String(TRUNCATE = 1);

/// 就诊***？描述
Property PAADMRefClinicDesc As %String(TRUNCATE = 1);

/// 住院数字(住院记录 1 其它记录0)
Property PAADMInPatNo As %String(TRUNCATE = 1);

/// 急诊数字(急诊记录 1 其它记录0)
Property PAADMEmergencyNo As %String(TRUNCATE = 1);

/// 预就诊数字
Property PAADMPreAdmNo As %String(TRUNCATE = 1);

/// 门诊转住院标志
Property PAADMConvertedFromOut As %String(TRUNCATE = 1);

/// 就诊优先级指针(指向CT_Acuity)
Property PAADMPriorityDR As %String(TRUNCATE = 1);

/// 就诊优先级Code
Property PAADMPriorityCode As %String(TRUNCATE = 1);

/// 就诊优先级描述
Property PAADMPriorityDesc As %String(TRUNCATE = 1);

/// 预就诊日期
Property PAADMPreAdmitDate As %String(TRUNCATE = 1);

/// 预就诊日期
Property PAADMPreAdmitTime As %String(TRUNCATE = 1);

/// ***？
Property PAADMIsolate As %String(TRUNCATE = 1);

/// ***？
Property PAADMEmergencyDate As %String(TRUNCATE = 1);

/// ***？
Property PAADMEmergencyTime As %String(TRUNCATE = 1);

/// ***？
Property PAADMPaidEmergencySurcharge As %String(TRUNCATE = 1);

/// ***？指针(指向PA_Adm)
Property PAADMOriginalAdmissionDR As %String(TRUNCATE = 1);

/// ***？
Property PAADMMealPreference As %String(TRUNCATE = 1);

/// ***？
Property PAADMOrder As %String(TRUNCATE = 1);

/// 创建日期
Property PAADMCreateDate As %String(TRUNCATE = 1);

/// 创建时间
Property PAADMCreateTime As %String(TRUNCATE = 1);

/// 创建人指针(指向SS_User)
Property PAADMCreateUser As %String(TRUNCATE = 1);

/// 创建人Code
Property PAADMCreateUserCode As %String(TRUNCATE = 1);

/// 创建人描述
Property PAADMCreateUserDesc As %String(TRUNCATE = 1);

/// 就诊备注
Property PAADMRemark As %String(TRUNCATE = 1);

/// ***?
Property PAADMBillFlag As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefExpiryDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefApprovNo As %String(TRUNCATE = 1);

/// ***?
Property PAADMTypeofPatientCalc As %String(TRUNCATE = 1);

/// 最终出院日期
Property PAADMEstimDischargeDate As %String(TRUNCATE = 1);

/// 最终出院时间
Property PAADMEstimDischargeTime As %String(TRUNCATE = 1);

/// 出院条件指针(指向PAC_DischCondit)
Property PAADMDischCondDR As %String(TRUNCATE = 1);

/// 出院条件Code
Property PAADMDischCondCode As %String(TRUNCATE = 1);

/// 出院条件Desc
Property PAADMDischCondDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMOtherDischType As %String(TRUNCATE = 1);

/// ***指针？指向(PAC_InfectionType)
Property PAADMInfectDR As %String(TRUNCATE = 1);

/// ***？code
Property PAADMInfectCode As %String(TRUNCATE = 1);

/// ***？描述
Property PAADMInfectDesc As %String(TRUNCATE = 1);

/// ***？
Property PAADMOtherInfectType As %String(TRUNCATE = 1);

/// ***?
Property PAADMEstimOperDate As %String(TRUNCATE = 1);

/// ***?指针(指向ORC_Operation)
Property PAADMOperDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMOperCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMOperDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMUrgent As %String(TRUNCATE = 1);

/// 复诊标志
Property PAADMAdmReadm As %String(TRUNCATE = 1);

/// ***指针?(指向PAC_RoomType)
Property PAADMRoomTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRoomTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRoomTypeDesc As %String(TRUNCATE = 1);

/// ***指针?(指向ARC_ItemCat)
Property PAADMDietTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMDietTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMDietTypeDesc As %String(TRUNCATE = 1);

/// 指向MR_Adm
Property PAADMMainMRADMDR As %String(TRUNCATE = 1);

/// ****指针?(指向MR_Adm)
Property PAADMStudentMRADMDR As %String(TRUNCATE = 1);

/// ****？
Property PAADMConfidentMessage As %String(TRUNCATE = 1);

/// 就诊预约方法指针(指向RBC_AppointMethod)
Property PAADMApptMethodDR As %String(TRUNCATE = 1);

/// 就诊预约方法Code
Property PAADMApptMethodCode As %String(TRUNCATE = 1);

/// 就诊预约方法Desc
Property PAADMApptMethodDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMOrderTime As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ReferralType)
Property PAADMReferralType As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMReferralTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMReferralTypeDesc As %String(TRUNCATE = 1);

/// 预约记录表指针(指向RB_Appointment)
Property PAADMAppointDR As %String(TRUNCATE = 1);

/// 当前就诊诊室指针(指向PACRoom)
Property PAADMCurrentRoomDR As %String(TRUNCATE = 1);

/// 当前就诊诊室Code
Property PAADMCurrentRoomCode As %String(TRUNCATE = 1);

/// 当前就诊诊室描述
Property PAADMCurrentRoomDesc As %String(TRUNCATE = 1);

/// 当前就诊病区指针(指向PAC_Ward)
Property PAADMCurrentWardDR As %String(TRUNCATE = 1);

/// 当前就诊病区Code
Property PAADMCurrentWardCode As %String(TRUNCATE = 1);

/// 当前就诊病区Desc
Property PAADMCurrentWardDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefAdmDR As %String(TRUNCATE = 1);

/// 初复诊标志
Property PAADMFirstOrReadmis As %String(TRUNCATE = 1);

/// 就诊床位指针(指向PAC_Bed)
Property PAADMCurrentBedDR As %String(TRUNCATE = 1);

/// 就诊床位Code
Property PAADMCurrentBedCode As %String(TRUNCATE = 1);

/// 就诊床位描述
Property PAADMCurrentBedDesc As %String(TRUNCATE = 1);

/// 临时就诊科室指针(指向CT_Loc)
Property PAADMTempLocDR As %String(TRUNCATE = 1);

/// 临时就诊科室Code
Property PAADMTempLocCode As %String(TRUNCATE = 1);

/// 临时就诊科室描述
Property PAADMTempLocDesc As %String(TRUNCATE = 1);

/// ***?指向(PA_Adm)
Property PAADMMotherAdmDR As %String(TRUNCATE = 1);

/// ***?
Property PAADMMedicalDischarge As %String(TRUNCATE = 1);

/// ***?
Property PAADMConvertDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMConvertTime As %String(TRUNCATE = 1);

/// ****指针?(指向CT_CareProv)
Property PAADMMedDischDocDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAADMMedDischDocCode As %String(TRUNCATE = 1);

/// ****?Desc
Property PAADMMedDischDocDesc As %String(TRUNCATE = 1);

/// ***?指针(PAC_RefDoctor)
Property PAADMRefDocListDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefDocListCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAADMRefDocListDesc As %String(TRUNCATE = 1);

/// 婚姻状况指针(指向CT_Marital)
Property PAADMMaritalStatusDR As %String(TRUNCATE = 1);

/// 婚姻状况Code
Property PAADMMaritalStatusCode As %String(TRUNCATE = 1);

/// 婚姻状况Desc
Property PAADMMaritalStatusDesc As %String(TRUNCATE = 1);

/// ***指针？(指向CT_HealthCareArea)
Property PAADMHCADR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMHCACode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAADMHCADesc As %String(TRUNCATE = 1);

/// 国家指针(指向CT_Region)
Property PAADMRegionDR As %String(TRUNCATE = 1);

/// 国家Code
Property PAADMRegionCode As %String(TRUNCATE = 1);

/// 国家Desc
Property PAADMRegionDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Process)
Property PAADMCurrentProcessDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMCurrentProcessCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAADMCurrentProcessDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Process)
Property PAADMPreviousProcessDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPreviousProcessCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAADMPreviousProcessDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PACEpisodeSubType)
Property PAADMEpissubtypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMEpissubtypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAADMEpissubtypeDesc As %String(TRUNCATE = 1);

/// 就诊费别指针(指向PAC_AdmReason)
Property PAADMAdmReasonDR As %String(TRUNCATE = 1);

/// 就诊费别Code
Property PAADMAdmReasonCode As %String(TRUNCATE = 1);

/// 就诊费别Desc
Property PAADMAdmReasonDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_CauseOfInjury)
Property PAADMCauseInjDR As %String(TRUNCATE = 1);

/// **?Code
Property PAADMCauseInjCode As %String(TRUNCATE = 1);

/// **?Desc
Property PAADMCauseInjDesc As %String(TRUNCATE = 1);

/// **?
Property PAADMEmergencyStatus As %String(TRUNCATE = 1);

/// **?
Property PAADMSeenDate As %String(TRUNCATE = 1);

/// **?
Property PAADMSeenTime As %String(TRUNCATE = 1);

/// 挂号收费标志
Property PAADMRegistrationFee As %String(TRUNCATE = 1);

/// ***?指针(指向BLC_ReasonNotRegFee)
Property PAADMReasonNotRegFee As %String(TRUNCATE = 1);

/// **?Code
Property PAADMReasonNotRegFeeCode As %String(TRUNCATE = 1);

/// **?Desc
Property PAADMReasonNotRegFeeDesc As %String(TRUNCATE = 1);

/// **?
Property PAADMSpecialCategory As %String(TRUNCATE = 1);

/// **?
Property PAADMSpecialDocument As %String(TRUNCATE = 1);

/// ***?指针(指向PA_TrafficAccident)
Property PAADMLabourAccidentDR As %String(TRUNCATE = 1);

/// **?Code
Property PAADMLabourAccidentCode As %String(TRUNCATE = 1);

/// **?Desc
Property PAADMLabourAccidentDesc As %String(TRUNCATE = 1);

/// **?
Property PAADMFlaggedPatient As %String(TRUNCATE = 1);

/// ***?指针(指向PA_WaitingList)
Property PAADMWaitListDR As %String(TRUNCATE = 1);

/// **?Code
Property PAADMWaitListCode As %String(TRUNCATE = 1);

/// **?Desc
Property PAADMWaitListDesc As %String(TRUNCATE = 1);

/// **?
Property PAADMFamilyDoctor As %String(TRUNCATE = 1);

/// **?
Property PAADMReadOnly As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Person)
Property PAADMPersonResponsiblePayment As %String(TRUNCATE = 1);

/// **?
Property PAADMVerified As %String(TRUNCATE = 1);

/// 完成就诊标志
Property PAADMCompleted As %String(TRUNCATE = 1);

/// ***?指针 (指向CT_HealthCareProvider)
Property PAADMHCPDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMHCPCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMHCPDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向CT_RefClin)
Property PAADMRefClinToDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefClinToCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRefClinToDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMAdmRef As %String(TRUNCATE = 1);

/// ***?指针 (指向MRC_ICDDx)
Property PAADMSeriousDisease As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMSeriousDiseaseCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMSeriousDiseaseDesc As %String(TRUNCATE = 1);

/// 中途结算日期
Property PAADMMedDischDate As %String(TRUNCATE = 1);

/// 中途结算时间
Property PAADMMedDischTime As %String(TRUNCATE = 1);

/// 发病日期
Property PAADMTriageDate As %String(TRUNCATE = 1);

/// 发病时间
Property PAADMTriageTime As %String(TRUNCATE = 1);

/// ***时间?
Property PAADMLikelihoodAdmit As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_HumanIntent)
Property PAADMHumanIntentDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMHumanIntentCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMHumanIntentDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_PlaceOfInjury)
Property PAADMPlaceOfInjDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPlaceOfInjCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPlaceOfInjDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_ActivityWhenInjured)
Property PAADMActivityInjuredDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMActivityInjuredCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMActivityInjuredDesc As %String(TRUNCATE = 1);

/// 职业指针 (指向CT_Occupation)
Property PAADMOccupationDR As %String(TRUNCATE = 1);

/// 职业Code
Property PAADMOccupationCode As %String(TRUNCATE = 1);

/// 职业描述
Property PAADMOccupationDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMPersonRespPayment As %String(TRUNCATE = 1);

/// ***?
Property PAADMRequestMR As %String(TRUNCATE = 1);

/// ***?
Property PAADMInpatBedReqDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMInpatBedReqTime As %String(TRUNCATE = 1);

/// ***?
Property PAADMCClass As %String(TRUNCATE = 1);

/// ***?
Property PAADMUpdateDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMUpdateTime As %String(TRUNCATE = 1);

/// 更新人 (指向SS_User)
Property PAADMUpdateUserDR As %String(TRUNCATE = 1);

/// 更新人Code
Property PAADMUpdateUserCode As %String(TRUNCATE = 1);

/// 更新人描述
Property PAADMUpdateUserDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_RefDoctorClinic)
Property PAADMRefDocClinicDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefDocClinicCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRefDocClinicDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向RB_Resource)
Property PAADMCurrentResourceDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMCurrentResourceCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMCurrentResourceDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMConfirmReferral As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_ReferralPeriod)
Property PAADMRefPeriodDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefPeriodCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRefPeriodDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_OSVisitorStatus)
Property PAADMOSVisitStatusDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMOSVisitStatusCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMOSVisitStatusDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateRefDecision As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_RefReceiptMethod)
Property PAADMMethodRefDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMMethodRefCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMMethodRefDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_ReferralPriority)
Property PAADMReferralPriorityDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMReferralPriorityCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMReferralPriorityDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_TumourSiteGroup)
Property PAADMTumourSiteGroupDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMTumourSiteGroupCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMTumourSiteGroupDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_ReasonDelayDischarge)
Property PAADMReasonDelDischDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMReasonDelDischCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMReasonDelDischDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMHospChaplainVisitReq As %String(TRUNCATE = 1);

/// ***?
Property PAADMOwnMinisterIndicator As %String(TRUNCATE = 1);

/// ***?
Property PAADMGuaranteeAdmDate As %String(TRUNCATE = 1);

/// ***?指针 (指向PAC_AEArrivalMode)
Property PAADMAEArrivalModeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMAEArrivalModeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMAEArrivalModeDesc As %String(TRUNCATE = 1);

/// ***?指针 (指向CT_CareProv)
Property PAADMInternalRefDocDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMInternalRefDocCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMInternalRefDocDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMHomerID As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefDrConsent As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_AdmissionMethod)
Property PAADMAdmMethodDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMAdmMethodCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMAdmMethodDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateHCPRequestSent As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateHCPreceived As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_HCPPriority)
Property PAADMHCPPriorityDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMHCPPriorityCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMHCPPriorityDesc As %String(TRUNCATE = 1);

/// ***?指针(指向RBC_AppointTransport)
Property PAADMAppointTransportDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMAppointTransportCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMAppointTransportDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMPoliceDivision As %String(TRUNCATE = 1);

/// ***?
Property PAADMSpecificLoc As %String(TRUNCATE = 1);

/// ***?
Property PAADMChaplainName As %String(TRUNCATE = 1);

/// ***?
Property PAADMChaplainChurchAddress As %String(TRUNCATE = 1);

/// ***?
Property PAADMChaplainPhone As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateOfEntry As %String(TRUNCATE = 1);

/// ***?
Property PAADMInterviewedBy As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateOfInterview As %String(TRUNCATE = 1);

/// ***?
Property PAADMInterviewRec As %String(TRUNCATE = 1);

/// ***?
Property PAADMOverseasVisitor As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Country)
Property PAADMOSVCountryFromDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMOSVCountryFromCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMOSVCountryFromDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMOtherHospital As %String(TRUNCATE = 1);

/// ***?
Property PAADMPermanentResident As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateReceived As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_SourceOfAttendance)
Property PAADMSourceOfAttendDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMSourceOfAttendCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMSourceOfAttendDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_MajorIncident)
Property PAADMMajorIncidentDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMMajorIncidentCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMMajorIncidentDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMReportDate As %String(TRUNCATE = 1);

/// ***?指针(指向ARC_ItemCat)
Property PAADMOESubCatDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMOESubCatCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMOESubCatDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ReferralStatus)
Property PAADMRefStatDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRefStatCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefStatDesc As %String(TRUNCATE = 1);

/// ***?指针(指向RTC_PostDischargeStatus)
Property PAADMPostDischStatusDR As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPostDischStatusCode As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPostDischStatusDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_WLReasonNotAvail)
Property PAADMDNAReason As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMDNAReasonCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMDNAReasonDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMNursingNotesFlag As %String(TRUNCATE = 1);

/// 退号原因指针(指向PAC_AdmCancelReason)
Property PAADMCancelReasonDR As %String(TRUNCATE = 1);

/// 退号原因Code
Property PAADMCancelReasonCode As %String(TRUNCATE = 1);

/// 退号原因描述
Property PAADMCancelReasonDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentRecFundInfo As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentPatSatisfSurve As %String(TRUNCATE = 1);

/// ***?
Property PAADMFrequentAdmissions As %String(TRUNCATE = 1);

/// ***?
Property PAADMDischComments As %String(TRUNCATE = 1);

/// ***?
Property PAADMPatientContacted As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_LikelyTransferoutICU)
Property PAADMLikelyTransICUDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMLikelyTransICUCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMLikelyTransICUDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMEstDischConfirmed As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PatientClassification)
Property PAADMPatClassifDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPatClassifCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPatClassifDesc As %String(TRUNCATE = 1);

/// ***?指针(指向SS_User)
Property PAADMConvertUserDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMConvertUserCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMConvertUserDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_InPatAdmissionType)
Property PAADMInPatAdmTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMInPatAdmTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMInPatAdmTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMAdmissionFIM As %String(TRUNCATE = 1);

/// ***?
Property PAADMDischargeFIM As %String(TRUNCATE = 1);

/// ***?
Property PAADMRelated As %String(TRUNCATE = 1);

/// ***?指针(指向CT_CareProv)
Property PAADMTreatingDrDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMTreatingDrCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMTreatingDrDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ContractSpokIdentifier)
Property PAADMContractSpokeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMContractSpokeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMContractSpokeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ContractType)
Property PAADMContractTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMContractTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMContractTypeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ContractRole)
Property PAADMContractRoleDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMContractRoleCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMContractRoleDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_FundingArrangement)
Property PAADMFundingArrangementDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMFundingArrangementCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMFundingArrangementDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_BillingMethod)
Property PAADMBillingMethodDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMBillingMethodCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMBillingMethodDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PalliativeCareState)
Property PAADMPalliativeCareDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPalliativeCareCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPalliativeCareDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_BedMobility)
Property PAADMBedMobilityDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMBedMobilityCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMBedMobilityDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_Toileting)
Property PAADMToiletingDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMToiletingCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMToiletingDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_Transferring)
Property PAADMTransferDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMTransferCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMTransferDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_Eating)
Property PAADMEatingDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMEatingCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMEatingDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMRUGTotal As %String(TRUNCATE = 1);

/// ***?
Property PAADMBarthelScore As %String(TRUNCATE = 1);

/// ***?
Property PAADMDischargeBarthelScore As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ClinicalSubProgram)
Property PAADMClinicalSubProgramDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMClinicalSubProgramCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMClinicalSubProgramDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ReAdmissionToRehab)
Property PAADMReadmToRehabDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMReadmToRehabCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMReadmToRehabDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMOnsetDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMMiniMentalAssScore As %String(TRUNCATE = 1);

/// ***?指针(指向CT_CareProv)
Property PAADMTriageNurseDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMTriageNurseCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMTriageNurseDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_StatePPP)
Property PAADMStatePPPDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMStatePPPCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMStatePPPDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDaySurgeryType As %String(TRUNCATE = 1);

/// ***?
Property PAADMTransferFacility As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ApptBookingSystem)
Property PAADMAppointBookingSystemDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMAppointBookingSystemCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMAppointBookingSystemDesc As %String(TRUNCATE = 1);

/// 新生儿母亲所在病区***?指针(指向PAC_Ward)
Property PAADMParentWardDR As %String(TRUNCATE = 1);

/// 新生儿母亲所在病区***?Code
Property PAADMParentWardCode As %String(TRUNCATE = 1);

/// 新生儿母亲所在病区***?描述
Property PAADMParentWardDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PatAcuity)
Property PAADMPatAcuityDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPatAcuityCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPatAcuityDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_AdmReason)
Property PAADMSecondaryReasonDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMSecondaryReasonCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMSecondaryReasonDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateDischHosp As %String(TRUNCATE = 1);

/// ***?指针(指向CT_CareProv)
Property PAADMCaseManagerDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMCaseManagerCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMCaseManagerDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateFirstAppt As %String(TRUNCATE = 1);

/// ***?
Property PAADMLastContactFamily As %String(TRUNCATE = 1);

/// ***?
Property PAADMRejectionReason As %String(TRUNCATE = 1);

/// ***?
Property PAADMLongStay As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Loc)
Property PAADMInternalRefLocDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMInternalRefLocCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMInternalRefLocDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDatePatRefferedAssess As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateSocialWorkerAlloc As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateSocialWorkerCompleted As %String(TRUNCATE = 1);

/// ***?
Property PAADMDateAssessmentCompleted As %String(TRUNCATE = 1);

/// ***?
Property PAADMSocialWorkerName As %String(TRUNCATE = 1);

/// ***?
Property PAADMPatDestination As %String(TRUNCATE = 1);

/// ***?
Property PAADMDelayReason As %String(TRUNCATE = 1);

/// ***?
Property PAADMHasCommunSocWorker As %String(TRUNCATE = 1);

/// ***?
Property PAADMHasFunding As %String(TRUNCATE = 1);

/// ***?
Property PAADMAutocodeRequired As %String(TRUNCATE = 1);

/// ***?指针(指向CT_SocWorkerCentre)
Property PAADMSocialWorkerCentreDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMSocialWorkerCentreCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMSocialWorkerCentreDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_LocalAuthority)
Property PAADMLocalAuthorityDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMLocalAuthorityCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMLocalAuthorityDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_NonGovOrg)
Property PAADMNonGovOrgDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMNonGovOrgCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMNonGovOrgDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMTempLocDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMTempLocTime As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_QualificationStatus)
Property PAADMQualifStatusDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMQualifStatusCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMQualifStatusDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_SuspectCancerType)
Property PAADMSuspectCancerTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMSuspectCancerTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMSuspectCancerTypeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Pregnancy)
Property PAADMPregnancyDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMPregnancyCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMPregnancyDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_NonGovOrg)
Property PAADMRefToNonGovDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRefToNonGovCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRefToNonGovDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefToNGOContactName As %String(TRUNCATE = 1);

/// ***?
Property PAADMRefOrgAddress As %String(TRUNCATE = 1);

/// ***?
Property PAADMDischgHospital As %String(TRUNCATE = 1);

/// 就诊医院指针(指向CT_Hospital)
Property PAADMHospitalDR As %String(TRUNCATE = 1);

/// 就诊医院Code
Property PAADMHospitalCode As %String(TRUNCATE = 1);

/// 就诊医院描述
Property PAADMHospitalDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMViewablebyEpCareProv As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_MaternityVisitType)
Property PAADMMaternityVisTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMMaternityVisTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMMaternityVisTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMLabClinicalCondition As %String(TRUNCATE = 1);

/// ***?
Property PAADMTelephoneActive As %String(TRUNCATE = 1);

/// ***?
Property PAADMCodingUpdateDate As %String(TRUNCATE = 1);

/// ***?
Property PAADMCodingUpdateTime As %String(TRUNCATE = 1);

/// ***?指针(指向SS_User)
Property PAADMCodingUpdateUserDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMCodingUpdateUserCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMCodingUpdateUserDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMCreatePreadmission As %String(TRUNCATE = 1);

/// ***?
Property PAADMBookLocReady As %String(TRUNCATE = 1);

/// ***?
Property PAADMDaysCarriedForward As %String(TRUNCATE = 1);

/// ***?指针(指向RBC_ReasonForCancel)
Property PAADMRBCCancelReasonDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMRBCCancelReasonCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMRBCCancelReasonDesc As %String(TRUNCATE = 1);

/// 更新人所在医院指针(指向CT_Hospital)
Property PAADMUpdateUserHospitalDR As %String(TRUNCATE = 1);

/// 更新人所在医院Code
Property PAADMUpdateUserHospitalCode As %String(TRUNCATE = 1);

/// 更新人所在医院描述
Property PAADMUpdateUserHospitalDesc As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentDVA As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentWorkCompens As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentMotorVehicle As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentDepOfDefence As %String(TRUNCATE = 1);

/// ***?
Property PAADMConsentFeedback As %String(TRUNCATE = 1);

/// ***?
Property PAADMPrevInPatAdmPalliativeCare As %String(TRUNCATE = 1);

/// ***?
Property PAADMPrevNonInPatPalliativeCare As %String(TRUNCATE = 1);

/// ***?
Property PAADMDoctorLetterNotes As %String(TRUNCATE = 1);

/// ***?
Property PAADMPatientLetterNotes As %String(TRUNCATE = 1);

/// ***?
Property PAADMAuditLetterResponse As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_UsualAccomodation)
Property PAADMUsualAccomDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAADMUsualAccomCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAADMUsualAccomDesc As %String(TRUNCATE = 1);

/// 最终结算日期
Property PAADMFinDischDate As %String(TRUNCATE = 1);

/// 最终结算时间
Property PAADMFinDischTime As %String(TRUNCATE = 1);

/// ***?
Property PAADMInjuryIncidentDate As %String(TRUNCATE = 1);

/// ***?指针(指向PAAdm2)
Property PAADMPAAdm2DR As %String(TRUNCATE = 1);

/// 以下是User.PAAdmExt 就诊扩展表字段
/// 是否医保标志
Property PAADMCheckInsued As %String(TRUNCATE = 1);

/// 核对人指针(指向SS_User)
Property PAADMCheckInsuUserDR As %String(TRUNCATE = 1);

/// 核对人Code
Property PAADMCheckInsuUserCode As %String(TRUNCATE = 1);

/// 核对人描述
Property PAADMCheckInsuUserDesc As %String(TRUNCATE = 1);

/// 核对日期
Property PAADMCheckInsurDate As %String(TRUNCATE = 1);

/// 核对时间
Property PAADMCheckInsurTime As %String(TRUNCATE = 1);

/// 转诊标识
Property PAADMTransferFlag As %String(TRUNCATE = 1);

/// 送押单位(仅公安医院使用)
Property PAADMCTEscortUnits As %String(TRUNCATE = 1);

/// 送押民警(仅公安医院使用)
Property PAADMEscortPerson As %String(TRUNCATE = 1);

/// 不配药标识
Property PAADMNotDistDrugsFlag As %String(TRUNCATE = 1);

/// 预约类型(VB版本用)
Property PAADMBregType As %String(TRUNCATE = 1);

/// 就诊到达科室指针(指向CT_Loc)
Property PAADMArriveDepDR As %String(TRUNCATE = 1);

/// 就诊到达科室Code
Property PAADMArriveDepCode As %String(TRUNCATE = 1);

/// 就诊到达科室描述
Property PAADMArriveDepDesc As %String(TRUNCATE = 1);

/// 门诊招回标识
Property PAADMRecallFlag As %String(TRUNCATE = 1);

/// 退号申请
Property PAADMReturnFlag As %String(TRUNCATE = 1);

/// 流感样
Property PAADMILIFlag As %String(TRUNCATE = 1);

/// 抗生素申请加急标识(1 加急,其他 不加急)
Property PAADMAntibApplyEm As %String(TRUNCATE = 1);

/// 就诊方式代码(初诊/门诊复诊/出院复诊/急诊复诊/转诊/其他/未知CZ/MZFZ/CYFZ/JZFZ/ZZ/QT/WZ现肿瘤使用,用PAADM_ReadmToRehab_DR字段替代)
Property PAADMAdmWay As %String(TRUNCATE = 1);

/// 病历申请
Property PAADMMedApplyFlag As %String(TRUNCATE = 1);

/// 特批标识
Property PAADMAusFlag As %String(TRUNCATE = 1);

/// 特批人指针(指向SS_User)
Property PAADMAusUserDR As %String(TRUNCATE = 1);

/// 特批人Code
Property PAADMAusUserCode As %String(TRUNCATE = 1);

/// 特批人描述
Property PAADMAusUserDesc As %String(TRUNCATE = 1);

/// 特批日期
Property PAADMAusDate As %String(TRUNCATE = 1);

/// 特批时间
Property PAADMAusTime As %String(TRUNCATE = 1);

/// 特批备注
Property PAADMAusRemark As %String(TRUNCATE = 1);

/// 特殊病人就诊标识(1 特殊病人就诊,其他 非特殊病人就诊友谊干保楼,协和用)
Property PAADMSpecPersonFlag As %String(TRUNCATE = 1);

/// 读医保卡所得的医保病人类型
Property PAADMInsuPersonType As %String(TRUNCATE = 1);

/// 特病类别关联指针(指向DHC_DiagnosCat)
Property PAADMDiagnosCatDR As %String(TRUNCATE = 1);

/// 特病类别关联Code
Property PAADMDiagnosCatCode As %String(TRUNCATE = 1);

/// 特病类别关联描述
Property PAADMDiagnosCatDesc As %String(TRUNCATE = 1);

/// 挂号优惠设置关联指针(指向DHC_RegConDisCount)
Property PAADMRegConDisDR As %String(TRUNCATE = 1);

/// 挂号优惠设置关联Code
Property PAADMRegConDisDode As %String(TRUNCATE = 1);

/// 挂号优惠设置关联描述
Property PAADMRegConDisDesc As %String(TRUNCATE = 1);

/// 先诊疗后付费标志
Property PAADMFirstTreatFlag As %String(TRUNCATE = 1);

/// 退号原因指针(指向DHC_OPReturnReason)
Property PAADMOPReturnReasonDR As %String(TRUNCATE = 1);

/// 退号原因Code
Property PAADMOPReturnReasonCode As %String(TRUNCATE = 1);

/// 退号原因描述
Property PAADMOPReturnReasonDesc As %String(TRUNCATE = 1);

/// 出院关联医嘱ID指针(指向OE_OrdItem)
Property PAADMDischgOrderId As %String(TRUNCATE = 1);

/// 出院关联医嘱Code
Property PAADMDischgOrderCode As %String(TRUNCATE = 1);

/// 出院关联医嘱描述
Property PAADMDischgOrderDesc As %String(TRUNCATE = 1);

/// 出院日期
Property PAADMDischargeDate As %String(TRUNCATE = 1);

/// 出院时间
Property PAADMDischargeTime As %String(TRUNCATE = 1);

/// 入院日期
Property PAADMAdminDate As %String(TRUNCATE = 1);

/// 入院时间
Property PAADMAdminTime As %String(TRUNCATE = 1);

/// 入院科室指针(指向CT_Loc)
Property PAADMAdminLoc As %String(TRUNCATE = 1);

/// 入院科室ode
Property PAADMAdminLocCode As %String(TRUNCATE = 1);

/// 入院科室描述
Property PAADMAdminLocDesc As %String(TRUNCATE = 1);

/// 入院病区指针(指向PAC_Ward)
Property PAADMAdminWard As %String(TRUNCATE = 1);

/// 入院病区ode
Property PAADMAdminWardCode As %String(TRUNCATE = 1);

/// 入院病区描述
Property PAADMAdminWardDesc As %String(TRUNCATE = 1);

}
