Class DHCDoc.GetInfo.Entry.OEOrdItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱RowId
Property OEORIRowId As %String(TRUNCATE = 1);

/// 医嘱项RowId
Property ARCIMRowId As %String(TRUNCATE = 1);

/// 医嘱项Code
Property ARCIMCode As %String(TRUNCATE = 1);

/// 医嘱项描述
Property ARCIMDesc As %String(TRUNCATE = 1);

/// 就诊科室(住院是病区、门诊是科室)指向（CT_Loc）
Property OEORIOrdDeptDR As %String(TRUNCATE = 1);

/// 就诊科室Code
Property OEORIOrdDeptCode As %String(TRUNCATE = 1);

/// 就诊科室描述
Property OEORIOrdDeptDesc As %String(TRUNCATE = 1);

Property OEORIPrescType As %String(TRUNCATE = 1);

/// 医嘱状态指针(指向OEC_OrderStatus)
Property OEORIItemStatDR As %String(TRUNCATE = 1);

/// 医嘱状态Code
Property OEORIItemStatCode As %String(TRUNCATE = 1);

/// 医嘱状态描述
Property OEORIItemStatDesc As %String(TRUNCATE = 1);

/// 开医嘱医生指针（指向CT_CareProv）
Property OEORIDoctorDR As %String(TRUNCATE = 1);

/// 开医嘱医生Code
Property OEORIDoctorCode As %String(TRUNCATE = 1);

/// 开医嘱医生描述
Property OEORIDoctorDesc As %String(TRUNCATE = 1);

/// 医嘱开始日期
Property OEORISttDat As %String(TRUNCATE = 1);

/// 医嘱开始时间
Property OEORISttTim As %String(TRUNCATE = 1);

/// 医嘱优先级指针(指向OEC_Priority)
Property OEORIPriorityDR As %String(TRUNCATE = 1);

/// 医嘱优先级Code
Property OEORIPriorityCode As %String(TRUNCATE = 1);

/// 医嘱优先级描述
Property OEORIPriorityDesc As %String(TRUNCATE = 1);

/// 医嘱频次指针(指向PHC_Freq)
Property OEORIPHFreqDR As %String(TRUNCATE = 1);

/// 医嘱频次Code
Property OEORIPHFreqCode As %String(TRUNCATE = 1);

/// 医嘱频次描述
Property OEORIPHFreqDesc As %String(TRUNCATE = 1);

/// 医嘱用法指针(指向PHC_Instruc)
Property OEORIInstrDR As %String(TRUNCATE = 1);

/// 医嘱用法Code
Property OEORIInstrCode As %String(TRUNCATE = 1);

/// 医嘱用法描述
Property OEORIInstrDesc As %String(TRUNCATE = 1);

/// 医嘱剂量单位指针(指向CT_UOM)
Property OEORIUnitDR As %String(TRUNCATE = 1);

/// 医嘱剂量单位Code
Property OEORIUnitCode As %String(TRUNCATE = 1);

/// 医嘱剂量单位描述
Property OEORIUnitDesc As %String(TRUNCATE = 1);

/// 医嘱基本单位数量(根据单次剂量*频次*疗程计算所得)
Property OEORIPhQtyOrd As %String(TRUNCATE = 1);

/// 医嘱停止日期
Property OEORIXDate As %String(TRUNCATE = 1);

/// 医嘱疗程指针(指向PHC_Duration)
Property OEORIDuratDR As %String(TRUNCATE = 1);

/// 医嘱疗程Code
Property OEORIDuratCode As %String(TRUNCATE = 1);

/// 医嘱疗程描述
Property OEORIDuratDesc As %String(TRUNCATE = 1);

/// ?
Property OEORIRemarks As %String(TRUNCATE = 1);

/// 医嘱草药用法
Property OEORIPhSpecInstr As %String(TRUNCATE = 1);

/// 自定义价格医嘱描述 ?
Property OEORIBillDesc As %String(TRUNCATE = 1);

/// 自定义价格医嘱总价
Property OEORIUnitCost As %String(TRUNCATE = 1);

/// (指向CT_CareProv)  ?
Property OEORIDRCrossDR As %String(TRUNCATE = 1);

/// Code  ?
Property OEORIDRCrossCode As %String(TRUNCATE = 1);

/// 描述  ?
Property OEORIDRCrossDesc As %String(TRUNCATE = 1);

/// 医嘱停止时间
Property OEORIXTime As %String(TRUNCATE = 1);

/// 医嘱长嘱首次数量
Property OEORIQty As %String(TRUNCATE = 1);

/// 科室类型 目前没用?
Property OEORIDepType As %String(TRUNCATE = 1);

/// 目前没用?
Property OEORILinkToOrder As %String(TRUNCATE = 1);

/// 医嘱备注
Property OEORIDepProcNotes As %String(TRUNCATE = 1);

/// 医嘱 (指向ARC_InsurCoverStatus) ?
Property OEORIInsBillConditDR As %String(TRUNCATE = 1);

/// 医嘱  ***Code ?
Property OEORIInsBillConditCode As %String(TRUNCATE = 1);

/// 医嘱 ***Desc ?
Property OEORIInsBillConditDesc As %String(TRUNCATE = 1);

/// 医嘱医保标志
Property OEORICoverMainIns As %String(TRUNCATE = 1);

/// 医嘱*** ? 目前默认为N
Property OEORIPortEquipReq As %String(TRUNCATE = 1);

/// 医嘱皮试标志
Property OEORIAdministerSkinTest As %String(TRUNCATE = 1);

/// 医嘱 *** ? (指向OEC_NeedleGauge)
Property OEORINeedleGaugeDR As %String(TRUNCATE = 1);

/// 医嘱 ***Code ?
Property OEORINeedleGaugeCode As %String(TRUNCATE = 1);

/// 医嘱 ***Desc ?
Property OEORINeedleGaugeDesc As %String(TRUNCATE = 1);

/// 医嘱 *** ?
Property OEORIIntervalDR As %String(TRUNCATE = 1);

/// 医嘱 *** ?
Property OEORISpeedFlowValue As %String(TRUNCATE = 1);

/// 医嘱 *** ? (指向OEC_NeedleType)
Property OEORINeedleTypeDR As %String(TRUNCATE = 1);

/// 医嘱 *** Code? 
Property OEORINeedleTypeCode As %String(TRUNCATE = 1);

/// 医嘱 *** Desc? 
Property OEORINeedleTypeDesc As %String(TRUNCATE = 1);

/// 医嘱 *** ? (指向OEC_BodySite)
Property OEORIBodySiteDR As %String(TRUNCATE = 1);

/// 医嘱 ***Code ? 
Property OEORIBodySiteCode As %String(TRUNCATE = 1);

/// 医嘱 ***Desc ? 
Property OEORIBodySiteDesc As %String(TRUNCATE = 1);

/// 医嘱 Patient To Doctor ? 目前除挂号医嘱为空外，其他为P
Property OEORIWhoGoWhere As %String(TRUNCATE = 1);

/// 手术医嘱级别指针 (指向ORC_OperationCategory)
Property OEORIOperCategoryDR As %String(TRUNCATE = 1);

/// 手术医嘱级别Code
Property OEORIOperCategoryCode As %String(TRUNCATE = 1);

/// 手术医嘱级别描述
Property OEORIOperCategoryDesc As %String(TRUNCATE = 1);

/// 医嘱处方号
Property OEORIPrescNo As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(CT_Loc)
Property OEORIConsultDepDR As %String(TRUNCATE = 1);

/// 医嘱***Code? 
Property OEORIConsultDepCode As %String(TRUNCATE = 1);

/// 医嘱***Desc? 
Property OEORIConsultDepDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?(指向CT_CareProv)
Property OEORIConsultDrDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIConsultDrCode As %String(TRUNCATE = 1);

/// 医嘱***描述?
Property OEORIConsultDrDesc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIUnit As %String(TRUNCATE = 1);

/// 开医嘱时间,目前停用此字段
Property OEORITime As %String(TRUNCATE = 1);

/// 医嘱*** ?
Property OEORIUnitHrs As %String(TRUNCATE = 1);

/// 医嘱输液流速
Property OEORISpeedFlowRate As %String(TRUNCATE = 1);

/// 医嘱*** ?
Property OEORIFlowQty As %String(TRUNCATE = 1);

/// 医嘱接收科室指针(指向CT_Loc)
Property OEORIRecDepDR As %String(TRUNCATE = 1);

/// 医嘱接收科室Code
Property OEORIRecDepCode As %String(TRUNCATE = 1);

/// 医嘱接收科室Desc
Property OEORIRecDepDesc As %String(TRUNCATE = 1);

/// 医嘱收费标志
Property OEORIBilled As %String(TRUNCATE = 1);

/// 医嘱序号
Property OEORISeqNo As %String(TRUNCATE = 1);

/// 医嘱 *** 指针 ?(指向PA_AdmInsurance)
Property OEORIAdmInsuranceDR As %String(TRUNCATE = 1);

/// 医嘱 *** Code?
Property OEORIAdmInsuranceCode As %String(TRUNCATE = 1);

/// 医嘱 *** Desc ?
Property OEORIAdmInsuranceDesc As %String(TRUNCATE = 1);

/// 自定义价格医嘱价格
Property OEORIPrice As %String(TRUNCATE = 1);

/// 医嘱  ***？ 指针(指向 CT_CareProv)
Property OEORICollectedBy As %String(TRUNCATE = 1);

/// 医嘱  ***Code？ 
Property OEORICollectedByCode As %String(TRUNCATE = 1);

/// 医嘱  ***Desc？ 
Property OEORICollectedByDesc As %String(TRUNCATE = 1);

/// 开医嘱日期
Property OEORIDate As %String(TRUNCATE = 1);

/// No Orders Link  ? 目前赋值为空
Property OEORINoOrdersLink As %String(TRUNCATE = 1);

/// 医嘱***？指针(指向OEC_OrderType)
Property OEORIOrderTypeDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIOrderTypeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIOrderTypeDesc As %String(TRUNCATE = 1);

/// 患者门诊登记号(取值字段PAPMI_OPNo)
Property OEORIPRN As %String(TRUNCATE = 1);

/// 医嘱单次剂量
Property OEORIDoseQty As %String(TRUNCATE = 1);

/// 医嘱套ID 指针(指向ARC_OrdSets)
Property OEORIARCOSDR As %String(TRUNCATE = 1);

/// 医嘱Code
Property OEORIARCOSCode As %String(TRUNCATE = 1);

/// 医嘱套描述
Property OEORIARCOSDesc As %String(TRUNCATE = 1);

/// 医嘱*** ？ 目前为空
Property OEORILinkNo As %String(TRUNCATE = 1);

/// 检验医嘱标本号 
Property OEORILabEpisodeNo As %String(TRUNCATE = 1);

/// Lab Episode Setup flag
Property OEORILabEpisodeSetup As %String(TRUNCATE = 1);

/// 开医嘱时间
Property OEORITimeOrd As %String(TRUNCATE = 1);

/// 医嘱退回数量 
Property OEORIRefundQty As %String(TRUNCATE = 1);

/// 医嘱退回类型 
Property OEORIRefundType As %String(TRUNCATE = 1);

/// 医嘱 *** ?指针(指向AR_PatBillGroupCharges)
Property OEORIARPBLItemDR As %String(TRUNCATE = 1);

/// 医嘱 *** Code?
Property OEORIARPBLItemCode As %String(TRUNCATE = 1);

/// 医嘱 *** 描述?
Property OEORIARPBLItemDesc As %String(TRUNCATE = 1);

/// 停止医生指针 (指向 CT_CareProv)
Property OEORIXCTCPDR As %String(TRUNCATE = 1);

/// 停止医生Code
Property OEORIXCTCPCode As %String(TRUNCATE = 1);

/// 停止医生描述
Property OEORIXCTCPDesc As %String(TRUNCATE = 1);

/// 医嘱停止原因指针 (指向BLC_ReasonForRefund)
Property OEORIReasonRefundDR As %String(TRUNCATE = 1);

/// 医嘱停止原因coe
Property OEORIReasonRefundCode As %String(TRUNCATE = 1);

/// 医嘱停止原因描述
Property OEORIReasonRefundDesc As %String(TRUNCATE = 1);

/// 医嘱***? Return To Stock Flag
Property OEORIReturnToStock As %String(TRUNCATE = 1);

/// 进餐类型 指针(指向DTC_MealType)
Property OEORIMealTypeDR As %String(TRUNCATE = 1);

/// 进餐类型 Code
Property OEORIMealTypeCode As %String(TRUNCATE = 1);

/// 进餐类型 描述
Property OEORIMealTypeDesc As %String(TRUNCATE = 1);

/// 医嘱***？ 指针(指向DTC_RiceType)
Property OEORIRiceTypeDR As %String(TRUNCATE = 1);

/// 医嘱***Code？ 
Property OEORIRiceTypeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？ 
Property OEORIRiceTypeDesc As %String(TRUNCATE = 1);

/// 医嘱***？ 指针(指向DTC_Volume)
Property OEORIVolumeDR As %String(TRUNCATE = 1);

/// 医嘱***Code？ 
Property OEORIVolumeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？ 
Property OEORIVolumeDesc As %String(TRUNCATE = 1);

/// 医嘱***？ 指针(指向DTC_Energy)
Property OEORIEnergyDR As %String(TRUNCATE = 1);

/// 医嘱***Code？ 
Property OEORIEnergyCode As %String(TRUNCATE = 1);

/// 医嘱***描述？ 
Property OEORIEnergyDesc As %String(TRUNCATE = 1);

/// 医嘱***？ 
Property OEORIProtein As %String(TRUNCATE = 1);

/// 医嘱***？ 
Property OEORIFat As %String(TRUNCATE = 1);

/// 医嘱***？ 
Property OEORICarbohydrate As %String(TRUNCATE = 1);

/// 推迟进餐标志 
Property OEORIDelayMeal As %String(TRUNCATE = 1);

/// 开医嘱日期和时间(以","分割) 
Property OEORIDateTime As %String(TRUNCATE = 1);

/// 医嘱*** ?指针(指向OR_Anaesthesia)
Property OEORIAnaestDR As %String(TRUNCATE = 1);

/// 医嘱***Code
Property OEORIAnaestCode As %String(TRUNCATE = 1);

/// 医嘱***描述
Property OEORIAnaestDesc As %String(TRUNCATE = 1);

/// 医嘱*** ?指针(指向OR_AnaestOperation)
Property OEORIAnaOperDR As %String(TRUNCATE = 1);

/// 医嘱***Code
Property OEORIAnaOperCode As %String(TRUNCATE = 1);

/// 医嘱***描述
Property OEORIAnaOperDesc As %String(TRUNCATE = 1);

/// 医嘱*** ?
Property OEORIPasterizeFood As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORISterilizeUtelsis As %String(TRUNCATE = 1);

/// 医嘱*** ?指针(指向RVI_InsCoBillCharges)
Property OEORIRVIChargeDR As %String(TRUNCATE = 1);

/// 医嘱***Code
Property OEORIRVIChargeCode As %String(TRUNCATE = 1);

/// 医嘱***描述
Property OEORIRVIChargeDesc As %String(TRUNCATE = 1);

/// 医嘱***? 目前默认为A
Property OEORIResultFlag As %String(TRUNCATE = 1);

/// 医嘱 ***? 指向(PHC_Freq)
Property OEORIRMFreqDR As %String(TRUNCATE = 1);

/// 医嘱***Code
Property OEORIRMFreqCode As %String(TRUNCATE = 1);

/// 医嘱***描述
Property OEORIRMFreqDesc As %String(TRUNCATE = 1);

/// 医嘱 ***? 指向(PHC_Duration)
Property OEORIRMDuratDR As %String(TRUNCATE = 1);

/// 医嘱***Code
Property OEORIRMDuratCode As %String(TRUNCATE = 1);

/// 医嘱***描述
Property OEORIRMDuratDesc As %String(TRUNCATE = 1);

/// 医嘱执行日期
Property OEORIDateExecuted As %String(TRUNCATE = 1);

/// 医嘱执行时间
Property OEORITimeExecuted As %String(TRUNCATE = 1);

/// 医嘱执行人指针 (指向SS_User)
Property OEORIUserExecuted As %String(TRUNCATE = 1);

/// 医嘱执行人Code
Property OEORIUserExecutedCode As %String(TRUNCATE = 1);

/// 医嘱执行人描述
Property OEORIUserExecutedDesc As %String(TRUNCATE = 1);

/// 医嘱预约指针 ？(指向RB_Appointment)
Property OEORIAPPTDR As %String(TRUNCATE = 1);

/// 医嘱预约指针code ？
Property OEORIAPPTCode As %String(TRUNCATE = 1);

/// 医嘱预约指针 Desc？
Property OEORIAPPTDesc As %String(TRUNCATE = 1);

/// 医嘱诊断类别
Property OEORIDRGOrder As %String(TRUNCATE = 1);

/// 医嘱录入人指针(指向SS_User)
Property OEORIUserAdd As %String(TRUNCATE = 1);

/// 医嘱录入人Code
Property OEORIUserAddCode As %String(TRUNCATE = 1);

/// 医嘱录入人描述
Property OEORIUserAddDesc As %String(TRUNCATE = 1);

/// 医嘱录入科室指针(指向CT_Loc)
Property OEORIUserDepartmentDR As %String(TRUNCATE = 1);

/// 医嘱录入科室Code
Property OEORIUserDepartmentCode As %String(TRUNCATE = 1);

/// 医嘱录入科室Desc
Property OEORIUserDepartmentDesc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIUserAuthorise As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIAuthComments As %String(TRUNCATE = 1);

/// 医嘱分发时间
Property OEORIDispensingTimes As %String(TRUNCATE = 1);

/// 医嘱输液流速单位指针(指向OEC_SpeedFlowRate)
Property OEORIFlowRateUnitDR As %String(TRUNCATE = 1);

/// 医嘱输液流速单位Code
Property OEORIFlowRateUnitCode As %String(TRUNCATE = 1);

/// 医嘱输液流速单位描述
Property OEORIFlowRateUnitDesc As %String(TRUNCATE = 1);

/// 医嘱***? 指针(指向OEC_ConsultCateg)
Property OEORIConsCategDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIConsCategCode As %String(TRUNCATE = 1);

/// 医嘱***?描述
Property OEORIConsCategDesc As %String(TRUNCATE = 1);

/// 医嘱执行医生 指针(指向CTCareProv)
Property OEORIDoctorExecutedDR As %String(TRUNCATE = 1);

/// 医嘱执行医生Code
Property OEORIDoctorExecutedCode As %String(TRUNCATE = 1);

/// 医嘱执行医生描述
Property OEORIDoctorExecutedDesc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIDiscountAmt As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIDiscountPerc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIDiscountDate As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIDiscountTime As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(CT_CareProv)
Property OEORIDiscountDoctorDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIDiscountDoctorCode As %String(TRUNCATE = 1);

/// 医嘱***描述? 
Property OEORIDiscountDoctorDesc As %String(TRUNCATE = 1);

/// 医嘱***? 
Property OEORIDiscountReason As %String(TRUNCATE = 1);

/// 医嘱***? 
Property OEORICost As %String(TRUNCATE = 1);

/// 医嘱结束日期(根据医嘱riwid,医嘱开始日期,疗程,OEORI_RMDurat_DR 计算所得)
Property OEORIFinDate As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORILabTestSetRow As %String(TRUNCATE = 1);

/// 医嘱***指针?(指向CT_RefClin)
Property OEORIRefClnDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIRefClnCode As %String(TRUNCATE = 1);

/// 医嘱***Desc?
Property OEORIRefClnDesc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIHICClaimNo As %String(TRUNCATE = 1);

/// 医嘱***指针?(指向OE_OrdEnt)
Property OEORIMainOeEntDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIMainOeEntCode As %String(TRUNCATE = 1);

/// 医嘱***描述?
Property OEORIMainOeEntDesc As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIPharmacyStatus As %String(TRUNCATE = 1);

/// 医嘱更新人指针 指向(SS_User)
Property OEORIUserUpdate As %String(TRUNCATE = 1);

/// 医嘱更新人Code 
Property OEORIUserUpdateCode As %String(TRUNCATE = 1);

/// 医嘱更新人描述
Property OEORIUserUpdateDesc As %String(TRUNCATE = 1);

/// 医嘱***?指针 指向(CT_Loc)
Property OEORICollectionDepDR As %String(TRUNCATE = 1);

/// 医嘱***Code ? 
Property OEORICollectionDepCode As %String(TRUNCATE = 1);

/// 医嘱***描述 ?
Property OEORICollectionDepDesc As %String(TRUNCATE = 1);

/// 医嘱***日期 ?
Property OEORIExpectedCollDate As %String(TRUNCATE = 1);

/// 医嘱***时间?
Property OEORIExpectedCollTime As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORILab1 As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORILab2 As %String(TRUNCATE = 1);

/// 医嘱最大重复次数
Property OEORIMaxNumberOfRepeats As %String(TRUNCATE = 1);

/// 医嘱***数?
Property OEORIAccessionNumber As %String(TRUNCATE = 1);

/// 医嘱***?
Property OEORIResultRef As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(MRC_linicalPathWays)
Property OEORIClinPathwaysDR As %String(TRUNCATE = 1);

/// 医嘱***Code? 
Property OEORIClinPathwaysCode As %String(TRUNCATE = 1);

/// 医嘱***描述? 
Property OEORIClinPathwaysDesc As %String(TRUNCATE = 1);

/// 医嘱***? 
Property OEORIResultGroup As %String(TRUNCATE = 1);

/// 医嘱***? 
Property OEORIStockBatches As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(CT_CareProv)
Property OEORIAssistantDR As %String(TRUNCATE = 1);

/// 医嘱***Code? 
Property OEORIAssistantCode As %String(TRUNCATE = 1);

/// 医嘱***描述? 
Property OEORIAssistantDesc As %String(TRUNCATE = 1);

/// 医嘱整包装数量 
Property OEORIQtyPackUOM As %String(TRUNCATE = 1);

/// 医嘱***日期?
Property OEORIDateRead As %String(TRUNCATE = 1);

/// 医嘱***时间?
Property OEORITimeRead As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(SS_User)
Property OEORIUserReadDR As %String(TRUNCATE = 1);

/// 医嘱***Code? 
Property OEORIUserReadCode As %String(TRUNCATE = 1);

/// 医嘱***描述? 
Property OEORIUserReadDesc As %String(TRUNCATE = 1);

/// 医嘱***指针? 指向(OEC_AlertReason)
Property OEORIAlertReasonDR As %String(TRUNCATE = 1);

/// 医嘱***Code? 
Property OEORIAlertReasonCode As %String(TRUNCATE = 1);

/// 医嘱***描述? 
Property OEORIAlertReasonDesc As %String(TRUNCATE = 1);

/// 医嘱结束日期
Property OEORIEndDate As %String(TRUNCATE = 1);

/// 医嘱结束日期
Property OEORIEndTime As %String(TRUNCATE = 1);

/// 患者就诊科室指针 指向(CT_Loc)
Property OEORIAdmLocDR As %String(TRUNCATE = 1);

/// 患者就诊科室Code
Property OEORIAdmLocCode As %String(TRUNCATE = 1);

/// 患者就诊科室描述
Property OEORIAdmLocDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIContactCareProv As %String(TRUNCATE = 1);

/// 滚医嘱来源 首医嘱!!上一条医嘱
Property OEORIFillerNo As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(MRC_VarianceReason)
Property OEORIVarianceReasonDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIVarianceReasonCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIVarianceReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIAuthorisedDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExamStartTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPatientIDChecked As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPreExamUser As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExposureKV As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExposuremAs As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIScreeningTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_FilmTypeSize)
Property OEORITypeSizeOfFilmsUsedDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORITypeSizeOfFilmsUsedCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORITypeSizeOfFilmsUsedDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILMPDate As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_FilmTypeSize)
Property OEORITypeSizeOfFilmsRejectedDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORITypeSizeOfFilmsRejectedCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORITypeSizeOfFilmsRejectedDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(RB_Resource)
Property OEORIRBResourceDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIRBResourceCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIRBResourceDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_FilmReasonForReject)
Property OEORIFilmReasonForRejectionDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIFilmReasonForRejectionCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIFilmReasonForRejectionDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_FilmContrastType)
Property OEORIContrastTypeDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIContrastTypeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIContrastTypeDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIContrastVolume As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIContrastExpiryDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIContrastBatchNumber As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIInjectionTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_CareProv)
Property OEORIPersonInjectDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIPersonInjectCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPersonInjectDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPregnancyCheck As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIIsotopeDose As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPostExamUser As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIAuthorisedTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIHotReportRequired As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(PA_WaitingList)
Property OEORIWaitListDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIWaitListCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIWaitListDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIEpisArriveDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIEpisArriveTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIAbnormal As %String(TRUNCATE = 1);

/// 医嘱更新日期
Property OEORIUpdateDate As %String(TRUNCATE = 1);

/// 医嘱更新时间
Property OEORIUpdateTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_OverReasonNonConsent)
Property OEORINoConsentOverrideReasDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORINoConsentOverrideReasCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORINoConsentOverrideReasDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORINoOrderedBags As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORICurrSampleExpiry As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIReasOrdCMVNegBlood As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORICompXMatchReq As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIAutologousBloodReq As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPatConsentObtained As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBTAG1 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBTAG2 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBTAG3 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBTAG4 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBTAG5 As %String(TRUNCATE = 1);

/// 医嘱费别 取PAC_AdmReason表ID
Property OEORIBBExtCode As %String(TRUNCATE = 1);

/// 医嘱费别Code
Property OEORIReasonCode As %String(TRUNCATE = 1);

/// 医嘱费别描述 
Property OEORIReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(PAC_RefDoctor)
Property OEORIRefDocDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIRefDocCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIRefDocDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIBBStatus As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_Action)
Property OEORIActionDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIActionCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIActionDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultComments As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(PAC_AllergyReason)
Property OEORIAllergyReasonDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIAllergyReasonCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIAllergyReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILabAction As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILabVolume As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILabSeqNo As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPlacerNo As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISentInExtract As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISeriesNo As %String(TRUNCATE = 1);

/// 检验医嘱接收日期
Property OEORILabReceiveDate As %String(TRUNCATE = 1);

/// 检验医嘱接收时间
Property OEORILabReceiveTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_Hospital)
Property OEORIPostExamUserHospDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIPostExamUserHospCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPostExamUserHospDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_Hospital)
Property OEORIPreExamUserHospDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIPreExamUserHospCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPreExamUserHospDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_Hospital)
Property OEORIUserAuthoriseHospDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIUserAuthoriseHospCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIUserAuthoriseHospDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_Hospital)
Property OEORIUserAddHospDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIUserAddHospCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIUserAddHospDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITheatreRequired As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITheatreDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITestSetComments As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIReturnDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIReturnTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(SS_User)
Property OEORIReturnUserDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIReturnUserCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIReturnUserDesc As %String(TRUNCATE = 1);

/// 关联主医嘱ID (指向OE_OrdItem)
Property OEORIOEORIDR As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDayBookAccessionNo As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDayBookSpecimen As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIUnitsCollected As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIIncompleteCollection As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(SS_User)
Property OEORIUserUnReadDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIUserUnReadCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIUserUnReadDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDateUnRead As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITimeUnread As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIReasonNotCollected As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPostExamStartTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_IndicationTransfusion)
Property OEORIIndicTransfusionDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIIndicTransfusionCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIIndicTransfusionDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIClinicallySignificant As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISensitivitiesSignoff As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIContOrderAfterDischarge As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_Route)
Property OEORIRouteDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIRouteCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIRouteDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(OEC_OrderStatus)
Property OEORIPendingStatusDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIPendingStatusCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPendingStatusDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_CareProv)
Property OEORIAuthoriseClinicianDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIAuthoriseClinicianCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIAuthoriseClinicianDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORINotify As %String(TRUNCATE = 1);

/// 医嘱是否加急
Property OEORINotifyClinician As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(PAC_Clinic)
Property OEORIPACClinicDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIPACClinicCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPACClinicDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultUpdateDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultUpdateTime As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(SS_User)
Property OEORIResultUpdateUserDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIResultUpdateUserCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIResultUpdateUserDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(CT_Hospital)
Property OEORIResultUpdateHospitalDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIResultUpdateHospitalCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIResultUpdateHospitalDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIEligibilityStatus As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIRecLocVerified As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultAvailable As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExternalPrimarySpecSite As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExternalSecondarySpecSite As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(PAC_RefDoctor)
Property OEORIExternalRefDoctorDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIExternalRefDoctorCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIExternalRefDoctorDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultAvailableDate As %String(TRUNCATE = 1);

/// 医嘱***指针 指向(INManufactureOrder)
Property OEORIManufacturerOrderDR As %String(TRUNCATE = 1);

/// 医嘱***Code？
Property OEORIManufacturerOrderCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIManufacturerOrderDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIHL7ResultStatus As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIHL7ResultDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIHL7ResultTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIFreqDelay As %String(TRUNCATE = 1);

/// 医嘱取消原因指针 指向(OEC_CancelReason)
Property OEORICancelReasonDR As %String(TRUNCATE = 1);

/// 医嘱取消原因Code
Property OEORICancelReasonCode As %String(TRUNCATE = 1);

/// 医嘱取消原因描述
Property OEORICancelReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILabelText As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(CT_Spec)
Property OEORISpecialtyDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORISpecialtyCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORISpecialtyDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(PHC_AdministrationRoute)
Property OEORIAdminRouteDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIAdminRouteCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIAdminRouteDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPRNMaxDose24hrs As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPRNTotNumberDosesAll As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPRNIndication As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPregnant As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILDMP As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIWeeksPregnant As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDayOfCycle As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILtClinicalCondition As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIQuestionnaire As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISupplierContactedDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISupplierContactedTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIProsReceivedDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIProsReceivedTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIProsBatchNo As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIProsSerialNo As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIProsSupplier As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIExpiryDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORISize As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OECImplantType)
Property OEORIImplantTypeDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIImplantTypeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIImplantTypeDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIReadyToBill As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDietFlag As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIActivity As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIView As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDSReportFlag As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultDSReportFlag As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPrescRepExpiryDate As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPrescRepNumberDays As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIMaxRepeats As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORICurrRepeatNumber As %String(TRUNCATE = 1);

/// 医嘱大类指针 指向(OEC_OrderCategory)
Property OEORICategDR As %String(TRUNCATE = 1);

/// 医嘱大类Code
Property OEORICategCode As %String(TRUNCATE = 1);

/// 医嘱大类描述
Property OEORICategDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(PAPersonConsultSetCons)
Property OEORIConsultDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIConsultCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIConsultDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OEAnnotation)
Property OEORIAnnotationDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIAnnotationCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIAnnotationDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(PHC_SkinTestOutcome)
Property OEORISkinTestOutcomeDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORISkinTestOutcomeCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORISkinTestOutcomeDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILTSpecCode As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORILTSiteCode As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIRetentionDays As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(PHC_PackingOverrideReason)
Property OEORIPackOverReasonDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIPackOverReasonCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIPackOverReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIUrgentReport As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPhoneOrder As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(SSUser)
Property OEORISecondOrderingUserDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORISecondOrderingUserCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORISecondOrderingUserDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDatePOAuthorised As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITimePOAuthorised As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDateAuthReq As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORITimeAuthReq As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(ORAnaestAgent)
Property OEORIAnaestAgentDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIAnaestAgentCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIAnaestAgentDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OE_OrdItem)
Property OEORIOriginalOrderDR As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OEC_ExamAbandonReason)
Property OEORIExamAbandonReasonDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIExamAbandonReasonCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIExamAbandonReasonDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIResultExist As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPreparationTime As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIPersonnel As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIComment1 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIComment2 As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIComment3 As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OECRadiologyDoseUnits)
Property OEORIRadiationDoesUnitDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIRadiationDoesUnitCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIRadiationDoesUnitDesc As %String(TRUNCATE = 1);

/// 医嘱***指针 ?指向(OEC_ReasonRejectPresc)
Property OEORIReasonRejectPrescDR As %String(TRUNCATE = 1);

/// 医嘱***Code?
Property OEORIReasonRejectPrescCode As %String(TRUNCATE = 1);

/// 医嘱***描述？
Property OEORIReasonRejectPrescDesc As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIDemandNumber As %String(TRUNCATE = 1);

/// 医嘱***？
Property OEORIRadiologyStatus As %String(TRUNCATE = 1);

/// 医嘱保存时系统日期
Property OEORIInsertDate As %String(TRUNCATE = 1);

/// 医嘱保存时系统时间
Property OEORIInsertTime As %String(TRUNCATE = 1);

/// 以下是User.OEOrdItemExt表 字段
/// 医嘱执行日期串
Property OEORIExecuteDateStr As %String(TRUNCATE = 1);

/// 资源排班记录指针 (指向RB_ApptSchedule)
Property OEORIRBASDR As %String(TRUNCATE = 1);

/// 医保类别指针 (取自INSU_TarItems)
Property OEORIInsurCatDR As %String(TRUNCATE = 1);

/// 医保类别Code
Property OEORIInsurCatCode As %String(TRUNCATE = 1);

/// 医保类别描述
Property OEORIInsurCatDesc As %String(TRUNCATE = 1);

/// 停止输液标志
Property OEORIStopDripFlag As %String(TRUNCATE = 1);

/// 停止输液日期
Property OEORIStopDripDate As %String(TRUNCATE = 1);

/// 停止输液时间
Property OEORIStopDripTime As %String(TRUNCATE = 1);

/// 停止输液操作人指针(指向SS_User)
Property OEORIStopDripUserDR As %String(TRUNCATE = 1);

/// 停止输液操作人代码
Property OEORIStopDripUserCode As %String(TRUNCATE = 1);

/// 停止输液操作人名字
Property OEORIStopDripUserDesc As %String(TRUNCATE = 1);

/// 医嘱阶段
Property OEORIStage As %String(TRUNCATE = 1);

/// 嘱托备注
Property OEORIOMProcNote As %String(TRUNCATE = 1);

/// 科研药理项目的指针 (取自DHC_DocPilotProject)
Property OEORIPEProjectDR As %String(TRUNCATE = 1);

/// 科研药理项目Code
Property OEORIPEProjectCode As %String(TRUNCATE = 1);

/// 科研药理项目描述
Property OEORIPEProjectDesc As %String(TRUNCATE = 1);

/// 营养药标志
Property OEORINutritionDrugFlag As %String(TRUNCATE = 1);

/// 星期频次的分发点
Property OEORIDispWeekTime As %String(TRUNCATE = 1);

/// 协议包装单位指针 (指向CT_Uom)
Property OEORIPackUOM As %String(TRUNCATE = 1);

/// 协议包装单位Code
Property OEORIPackUOMCode As %String(TRUNCATE = 1);

/// 协议包装单位描述
Property OEORIPackUOMDesc As %String(TRUNCATE = 1);

/// 高值材料条码
Property OEORIMaterialNo As %String(TRUNCATE = 1);

/// 医疗单元指针 (指向DHC_CTLocMedUnit)
Property OEORIMedUnitDR As %String(TRUNCATE = 1);

/// 医疗单元Code
Property OEORIMedUnitCode As %String(TRUNCATE = 1);

/// 医疗单元描述
Property OEORIMedUnitDesc As %String(TRUNCATE = 1);

/// 需要配液标志
Property OEORINeedPIVAFlag As %String(TRUNCATE = 1);

/// 留观状态标识
Property OEORIEMStayFlag As %String(TRUNCATE = 1);

/// 医嘱是”治疗/预防”  1:治疗  2:预防
Property OEORITarget As %String(TRUNCATE = 1);

/// 记账审核标识
Property OEORIPayorAduitFlag As %String(TRUNCATE = 1);

/// 预生成的处方指针 ？
Property OEORIPrePrescDR As %String(TRUNCATE = 1);

/// 本院输液次数
Property OEORILocalInfusionQty As %String(TRUNCATE = 1);

/// 所绑定的检验医嘱的检验号串,如抽血费
Property OEORILabEpisodeNoStr As %String(TRUNCATE = 1);

/// 特殊的本地化标识  1_$C(1)_1;华西第一个值为生成取药医嘱的标识
Property OEORIOtherFlags As %String(TRUNCATE = 1);

/// 打印导诊单标识
Property OEORIPrintFlag As %String(TRUNCATE = 1);

/// 需另划价标识 Y:代表将不计费，将有科室补录实际费用    Add In 北京协和
Property OEORIPriceFlag As %String(TRUNCATE = 1);

/// 已另划价标识 Y:代表已经另划价                        Add In 北京协和
Property OEORIPriceInputFlag As %String(TRUNCATE = 1);

/// 关联医嘱指针(指向MR_Diagnos)  主要用于医保适应症
Property OEORIMRDIADR As %String(TRUNCATE = 1);

/// 停医嘱原因关联指针(指向BLC_ReasonForRefund )
Property OEORIStopReasonDR As %String(TRUNCATE = 1);

/// 停医嘱原因关联Code
Property OEORIStopReasonCode As %String(TRUNCATE = 1);

/// 停医嘱原因关联描述
Property OEORIStopReasonDesc As %String(TRUNCATE = 1);

/// 周频次日期时间串
Property OEORIWeekFreqDatTimStr As %String(TRUNCATE = 1);

/// 老系统价格   其他系统数据迁移时价格
Property OEORIOldPrice As %String(TRUNCATE = 1);

/// 使用科室指针(指向CT_Loc)  下医嘱时指定检查科室去药房替病人领药
Property OEORIUseInLocDR As %String(TRUNCATE = 1);

/// 使用科室Code
Property OEORIUseInLocCode As %String(TRUNCATE = 1);

/// 使用科室Desc
Property OEORIUseInLocDesc As %String(TRUNCATE = 1);

/// 药品个人自带标识
Property OEORISelfOMFlag As %String(TRUNCATE = 1);

/// 门诊退费审核标志
Property OEORIRefundAuditFlag As %String(TRUNCATE = 1);

/// 门诊退费审核用户指针(指向SS_User)
Property OEORIRefundAuditUserDR As %String(TRUNCATE = 1);

/// 门诊退费审核用户Code
Property OEORIRefundAuditUserCode As %String(TRUNCATE = 1);

/// 门诊退费审核用户描述
Property OEORIRefundAuditUserDesc As %String(TRUNCATE = 1);

/// 门诊退费审核日期
Property OEORIRefundAuditDate As %String(TRUNCATE = 1);

/// 门诊退费审核时间
Property OEORIRefundAuditTime As %String(TRUNCATE = 1);

/// 门诊退费审核原因指针(指向DHC_INVOPRefReason)
Property OEORIRefundReason As %String(TRUNCATE = 1);

/// 门诊退费审核原因Code
Property OEORIRefundReasonCode As %String(TRUNCATE = 1);

/// 门诊退费审核原因描述
Property OEORIRefundReasonDesc As %String(TRUNCATE = 1);

/// 门诊退费审核科室指针(指向CT_Loc)
Property OEORIRefundAuditLocDR As %String(TRUNCATE = 1);

/// 门诊退费审核科室Code
Property OEORIRefundAuditLocCode As %String(TRUNCATE = 1);

/// 门诊退费审核科室描述
Property OEORIRefundAuditLocDesc As %String(TRUNCATE = 1);

/// 门诊科室审核标志  此标志用来决定后续是否能计费
Property OEORIDoctorConfirmFlag As %String(TRUNCATE = 1);

/// 门诊科室审核日期
Property OEORIDoctorConfirmDate As %String(TRUNCATE = 1);

/// 门诊科室审核时间
Property OEORIDoctorConfirmTime As %String(TRUNCATE = 1);

/// 门诊科室审核人指针(指向SS_User)
Property OEORIDoctorConfirmUserDR As %String(TRUNCATE = 1);

/// 门诊科室审核人Code
Property OEORIDoctorConfirmUserCode As %String(TRUNCATE = 1);

/// 门诊科室审核人描述
Property OEORIDoctorConfirmUserDesc As %String(TRUNCATE = 1);

/// 门诊记帐转自费标识
Property OEORIChargeToOwnFlag As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员指针(指针SS_User)
Property OEORIChargeToOwnUserDR As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员Code
Property OEORIChargeToOwnUserCode As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员描述
Property OEORIChargeToOwnUserDesc As %String(TRUNCATE = 1);

/// 门诊记帐转自费日期
Property OEORIChargeToOwnDate As %String(TRUNCATE = 1);

/// 门诊记帐转自费时间
Property OEORIChargeToOwnTime As %String(TRUNCATE = 1);

/// 停止医嘱处理护士指针(指向SS_User)
Property OEORIDisconUserDR As %String(TRUNCATE = 1);

/// 停止医嘱处理护士Code
Property OEORIDisconUserCode As %String(TRUNCATE = 1);

/// 停止医嘱处理护士描述
Property OEORIDisconUserDesc As %String(TRUNCATE = 1);

/// 停止医嘱处理日期
Property OEORIDisconDate As %String(TRUNCATE = 1);

/// 停止医嘱处理时间
Property OEORIDisconTime As %String(TRUNCATE = 1);

/// 医嘱处理护士指针(指向SS_User)
Property OEORISeeUserDR As %String(TRUNCATE = 1);

/// 医嘱处理护士Code
Property OEORISeeUserCode As %String(TRUNCATE = 1);

/// 医嘱处理护士描述
Property OEORISeeUserDesc As %String(TRUNCATE = 1);

/// 医嘱处理日期
Property OEORISeeDate As %String(TRUNCATE = 1);

/// 医嘱处理时间
Property OEORISeeTime As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因指针(指向DHC_DocExceedReason)
Property OEORIExceedReasonDR As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因Code
Property OEORIExceedReasonCode As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因描述
Property OEORIExceedReasonDesc As %String(TRUNCATE = 1);

/// 医嘱处理类型
Property OEORISeeType As %String(TRUNCATE = 1);

/// 医嘱处理备注
Property OEORISeeRemark As %String(TRUNCATE = 1);

/// 实习医嘱审核日期
Property OEORIPracticeConfirmDate As %String(TRUNCATE = 1);

/// 实习医嘱审核时间
Property OEORIPracticeConfirmTime As %String(TRUNCATE = 1);

/// 实习医嘱审核人指针(指向SS_User)
Property OEORIPracticeConfirmUserDR As %String(TRUNCATE = 1);

/// 实习医嘱审核人Code
Property OEORIPracticeConfirmUserCode As %String(TRUNCATE = 1);

/// 实习医嘱审核人名称
Property OEORIPracticeConfirmUserDesc As %String(TRUNCATE = 1);

/// 药品外购标识
Property OEORIOutsourcingFlag As %String(TRUNCATE = 1);

/// 部位@部位!体位!处理方法
Property OEORIBodyPart As %String(TRUNCATE = 1);

/// 物资收费项id (取自)
Property OEORITarCatRowId As %String(TRUNCATE = 1);

/// 物资收费项Code
Property OEORITarCatCode As %String(TRUNCATE = 1);

/// 物资收费项描述
Property OEORITarCatDesc As %String(TRUNCATE = 1);

/// 第三方插入标志
Property OEORIExtOrgCode As %String(TRUNCATE = 1);

}
