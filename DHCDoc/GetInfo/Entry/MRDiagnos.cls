Class DHCDoc.GetInfo.Entry.MRDiagnos Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 诊断ID
Property MRDIARowId As %String(TRUNCATE = 1);

/// ICD诊断指针(指向MRC_ICDDx)
Property MRDIAICDCodeDR As %String(TRUNCATE = 1);

/// ICD诊断Code
Property MRDIAICDCode As %String(TRUNCATE = 1);

/// ICD诊断描述
Property MRDIAICDDesc As %String(TRUNCATE = 1);

/// 诊断?
Property MRDIADateDetect As %String(TRUNCATE = 1);

/// 诊断**指针 (指向MRC_ICDStat)
Property MRDIAICDStatusDR As %String(TRUNCATE = 1);

/// 诊断**Code
Property MRDIAICDStatusCode As %String(TRUNCATE = 1);

/// 诊断**描述
Property MRDIAICDStatusDesc As %String(TRUNCATE = 1);

/// 诊断**?
Property MRDIAWorkRelated As %String(TRUNCATE = 1);

/// 下诊断医生指针 (指向CT_CareProv)
Property MRDIADocCodeDR As %String(TRUNCATE = 1);

/// 下诊断医生Code
Property MRDIADocCode As %String(TRUNCATE = 1);

/// 下诊断医生描述
Property MRDIADocDesc As %String(TRUNCATE = 1);

/// 诊断**？指针(指向MRC_SuppICD)
Property MRDIAICDSupDR As %String(TRUNCATE = 1);

/// 诊断**？Code
Property MRDIAICDSupCode As %String(TRUNCATE = 1);

/// 诊断**？描述
Property MRDIAICDSupDesc As %String(TRUNCATE = 1);

/// 非ICD诊断描述
Property MRDIADesc As %String(TRUNCATE = 1);

/// 下诊断日期
Property MRDIADate As %String(TRUNCATE = 1);

/// 下诊断时间
Property MRDIATime As %String(TRUNCATE = 1);

/// 诊断状态指针(指向MRC_DiagnosStatus)
Property MRDIADiagStatDR As %String(TRUNCATE = 1);

/// 诊断状态Code
Property MRDIADiagStatCode As %String(TRUNCATE = 1);

/// 诊断状态描述
Property MRDIADiagStatDesc As %String(TRUNCATE = 1);

/// 证型指针(指向MRC_DiagnosSignSymptom)
Property MRDIASignSymDR As %String(TRUNCATE = 1);

/// 证型Code
Property MRDIASignSymCode As %String(TRUNCATE = 1);

/// 证型Desc
Property MRDIASignSymDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADRGOrder As %String(TRUNCATE = 1);

/// 诊断更新人指针(指向SS_User)
Property MRDIAUpdateUserDR As %String(TRUNCATE = 1);

/// 诊断更新人Code
Property MRDIAUpdateUserCode As %String(TRUNCATE = 1);

/// 诊断更新人名称
Property MRDIAUpdateUserDesc As %String(TRUNCATE = 1);

/// 诊断**指针?(指向MRC_DiagnosisGroup1)
Property MRDIADiagnosisGroup1DR As %String(TRUNCATE = 1);

/// 诊断**Code?
Property MRDIADiagnosisGroup1Code As %String(TRUNCATE = 1);

/// 诊断**名称?
Property MRDIADiagnosisGroup1Desc As %String(TRUNCATE = 1);

/// 诊断**指针?(指向MRC_DiagnosisGroup1)
Property MRDIADiagnosisGroup2DR As %String(TRUNCATE = 1);

/// 诊断**Code?
Property MRDIADiagnosisGroup2Code As %String(TRUNCATE = 1);

/// 诊断**名称?
Property MRDIADiagnosisGroup2Desc As %String(TRUNCATE = 1);

/// 诊断**指针?(指向PAC_StageClassification)
Property MRDIAStageClasDR As %String(TRUNCATE = 1);

/// 诊断**Code?
Property MRDIAStageClasCode As %String(TRUNCATE = 1);

/// 诊断**名称?
Property MRDIAStageClasDesc As %String(TRUNCATE = 1);

/// 诊断**?指针 (指向PAC_Tumour)
Property MRDIATumourDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIATumourCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIATumourDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_LymphNode)
Property MRDIALymphNodeDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIALymphNodeCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIALymphNodeDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_DistalMetastasis)
Property MRDIADistalMetDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIADistalMetCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIADistalMetDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_VenousInvasion)
Property MRDIAVenInvasionDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIAVenInvasionCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIAVenInvasionDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_LymphInvasion)
Property MRDIALymphInvasDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIALymphInvasCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIALymphInvasDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_MalignancyGrade)
Property MRDIAMalGradeDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIAMalGradeCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIAMalGradeDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_ResidualTumour)
Property MRDIAResTumDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIAResTumCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIAResTumDesc As %String(TRUNCATE = 1);

/// 诊断**? (指向PAC_Stage)
Property MRDIAStagesDR As %String(TRUNCATE = 1);

/// 诊断**? code
Property MRDIAStagesCode As %String(TRUNCATE = 1);

/// 诊断**? 描述
Property MRDIAStagesDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIATumourSize As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIATumourNotes As %String(TRUNCATE = 1);

/// 关联主诊断id (指向MR_Diagnos)
Property MRDIAMRDIADR As %String(TRUNCATE = 1);

/// 关联主诊断Code
Property MRDIAMRDIADRCode As %String(TRUNCATE = 1);

/// 关联主诊断描述
Property MRDIAMRDIADRDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADaggerAster As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAFirstInset As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAPrefix As %String(TRUNCATE = 1);

/// 诊断***指针 (指向MRC_ICDDx)
Property MRDIAMappedICDDR As %String(TRUNCATE = 1);

/// 诊断***Code
Property MRDIAMappedICDCode As %String(TRUNCATE = 1);

/// 诊断***描述
Property MRDIAMappedICDDesc As %String(TRUNCATE = 1);

/// 诊断***指针 (指向MRC_ContractFlag)
Property MRDIAContractFlagDR As %String(TRUNCATE = 1);

/// 诊断***Code
Property MRDIAContractFlagCode As %String(TRUNCATE = 1);

/// 诊断***描述
Property MRDIAContractFlagDesc As %String(TRUNCATE = 1);

/// 诊断更新医院指针 (指向CT_Hospital)
Property MRDIAUpdateHospitalDR As %String(TRUNCATE = 1);

/// 诊断更新医院Code
Property MRDIAUpdateHospitalCode As %String(TRUNCATE = 1);

/// 诊断更新医院描述
Property MRDIAUpdateHospitalDesc As %String(TRUNCATE = 1);

/// 诊断更新日期
Property MRDIAUpdateDate As %String(TRUNCATE = 1);

/// 诊断更新时间
Property MRDIAUpdateTime As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIATumourUpdateDate As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIATumourUpdateTime As %String(TRUNCATE = 1);

/// 诊断***指针 (指向SS_User)
Property MRDIATumourUpdateUserDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIATumourUpdateUserCode As %String(TRUNCATE = 1);

/// 诊断***描述 ?
Property MRDIATumourUpdateUserDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向CT_Hospital)
Property MRDIATumourUpdateHospitalDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIATumourUpdateHospitalCode As %String(TRUNCATE = 1);

/// 诊断****描述?
Property MRDIATumourUpdateHospitalDesc As %String(TRUNCATE = 1);

/// 诊断录入人指针? (指向SS_User)
Property MRDIAUserCreatedDR As %String(TRUNCATE = 1);

/// 诊断录入人Code?
Property MRDIAUserCreatedCode As %String(TRUNCATE = 1);

/// 诊断录入人描述?
Property MRDIAUserCreatedDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向PAC_ReasonForChangePatData)
Property MRDIADeletionReasonDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIADeletionReasonCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIADeletionReasonDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向OEC_BodySite)
Property MRDIAPrimaryTumourSiteDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIAPrimaryTumourSiteCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIAPrimaryTumourSiteDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAQuestionnaire As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAAliasDiagText As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAAccidentDate As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADSReportFlag As %String(TRUNCATE = 1);

/// 诊断***指针? (指向MRC_RiskEvalParam)
Property MRDIARiskEvaluationDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIARiskEvaluationCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIARiskEvaluationDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADateDiagnosisIdentif As %String(TRUNCATE = 1);

/// 诊断***指针? (指向PA_PersonConsultSetCons)
Property MRDIAConsultDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIAConsultCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIAConsultDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向OEC_BodySite)
Property MRDIABodySiteDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIABodySiteCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIABodySiteDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向PAC_Laterality)
Property MRDIALateralityDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIALateralityCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIALateralityDesc As %String(TRUNCATE = 1);

/// 诊断***指针? (指向MRC_Severity)
Property MRDIASeverityDR As %String(TRUNCATE = 1);

/// 诊断***Code?
Property MRDIASeverityCode As %String(TRUNCATE = 1);

/// 诊断***描述?
Property MRDIASeverityDesc As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADurationNum As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIADurationUnit As %String(TRUNCATE = 1);

/// 诊断***？
Property MRDIAActive As %String(TRUNCATE = 1);

/// 发病日期
Property MRDIAOnsetDate As %String(TRUNCATE = 1);

/// 发病时间
Property MRDIAOnsetTime As %String(TRUNCATE = 1);

/// 诊断结束日期
Property MRDIAEndDate As %String(TRUNCATE = 1);

/// 诊断结束日期
Property MRDIAEndTime As %String(TRUNCATE = 1);

/// 诊断****？
Property MRDIATimeDiagnosisIdentif As %String(TRUNCATE = 1);

/// 诊断****？
Property MRDIAApproximate As %String(TRUNCATE = 1);

/// 主诊断标志
Property MRDIAMainDiagFlag As %String(TRUNCATE = 1);

}
