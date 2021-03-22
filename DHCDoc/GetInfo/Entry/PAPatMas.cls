Class DHCDoc.GetInfo.Entry.PAPatMas Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人ID
Property PAPMIRowId As %String(TRUNCATE = 1);

/// 登记号
Property PAPMINo As %String(TRUNCATE = 1);

/// 证件号码
Property PAPMIID As %String(TRUNCATE = 1);

/// 患者姓名
Property PAPMIName As %String(TRUNCATE = 1);

Property PAPMIName2 As %String(TRUNCATE = 1);

/// 患者姓名拼音
Property PAPMIAlias As %String(TRUNCATE = 1);

/// 联系人电话
Property PAPMIForeignPhoneNo As %String(TRUNCATE = 1);

/// 住院登记号
Property PAPMIIPNo As %String(TRUNCATE = 1);

/// 门诊登记号
Property PAPMIOPNo As %String(TRUNCATE = 1);

/// 出生日期
Property PAPMIDOB As %String(TRUNCATE = 1);

/// ****？
Property PAPMIEstAgeYear As %String(TRUNCATE = 1);

/// ****？
Property PAPMIEstAgeMonth As %String(TRUNCATE = 1);

/// ****？
Property PAPMIEstAgeTmStmp As %String(TRUNCATE = 1);

/// 性别指针(指向CT_Sex)
Property PAPMISexDR As %String(TRUNCATE = 1);

/// 性别Code
Property PAPMISexCode As %String(TRUNCATE = 1);

/// 性别描述
Property PAPMISexDesc As %String(TRUNCATE = 1);

/// 性别描述
Property PAPMISoundex As %String(TRUNCATE = 1);

/// 第一语言指针(指向SS_Language)
Property PAPMILangPrimDR As %String(TRUNCATE = 1);

/// 第一语言Code
Property PAPMILangPrimCode As %String(TRUNCATE = 1);

/// 第一语言描述
Property PAPMILangPrimDesc As %String(TRUNCATE = 1);

/// ****？
Property PAPMIActive As %String(TRUNCATE = 1);

/// **？指针(指向PAC_PatientCategory)
Property PAPMIPatCategoryDR As %String(TRUNCATE = 1);

/// ***？Code
Property PAPMIPatCategoryCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMIPatCategoryDesc As %String(TRUNCATE = 1);

/// ****？
Property PAPMIHomeClinicNo As %String(TRUNCATE = 1);

/// ****？
Property PAPMINxtOPAdmNo As %String(TRUNCATE = 1);

/// ****？
Property PAPMILangPrintDR As %String(TRUNCATE = 1);

/// ****？
Property PAPMIRemark As %String(TRUNCATE = 1);

/// 第二语言指针(指向SS_Language)
Property PAPMILangSecondDR As %String(TRUNCATE = 1);

/// 第二语言Code
Property PAPMILangSecondCode As %String(TRUNCATE = 1);

/// 第二语言描述
Property PAPMILangSecondDesc As %String(TRUNCATE = 1);

/// 患者死亡标志
Property PAPMIDeceased As %String(TRUNCATE = 1);

/// 患者死亡日期
Property PAPMIDeceasedDate As %String(TRUNCATE = 1);

/// 患者死亡时间
Property PAPMIDeceasedTime As %String(TRUNCATE = 1);

/// 患者黑名单标志
Property PAPMIBlackList As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Mother)
Property PAPMIMotherDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIMotherCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMIMotherDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_RefDoctor)
Property PAPMIRefDocDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIRefDocCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMIRefDocDesc As %String(TRUNCATE = 1);

/// 患者病案号(目前弃用,改统一调用医政组接口)
Property PAPMIMedicare As %String(TRUNCATE = 1);

/// 医保号
Property PAPMIName3 As %String(TRUNCATE = 1);

/// ***?
Property PAPMIRefund As %String(TRUNCATE = 1);

/// 更新人指针(指向SS_User)
Property PAPMIUserUpdate As %String(TRUNCATE = 1);

/// 更新人Code
Property PAPMIUserUpdateCode As %String(TRUNCATE = 1);

/// 更新人描述
Property PAPMIUserUpdateDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_TraceOutcome)
Property PAPMITraceStatusDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMITraceStatusCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMITraceStatusDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_MedicareSuffix)
Property PAPMIMedicareSuffixDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIMedicareSuffixCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMIMedicareSuffixDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPMIMedicareCode As %String(TRUNCATE = 1);

/// ***?
Property PAPMIAllergy As %String(TRUNCATE = 1);

/// ***?
Property PAPMIConcessionCardNo As %String(TRUNCATE = 1);

/// ***?
Property PAPMIConcessionCardExpDate As %String(TRUNCATE = 1);

/// ***?
Property PAPMISafetyNetCardNo As %String(TRUNCATE = 1);

/// ***?
Property PAPMISafetyNetCardExpDate As %String(TRUNCATE = 1);

/// 患者身份证号
Property PAPMIDVAnumber As %String(TRUNCATE = 1);

/// 证件类型指针(指向PAC_CardType)
Property PAPMICardTypeDR As %String(TRUNCATE = 1);

/// 证件类型Code
Property PAPMICardTypeCode As %String(TRUNCATE = 1);

/// 证件类型描述
Property PAPMICardTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPMIMedicareExpDate As %String(TRUNCATE = 1);

/// ***?
Property PAPMICHCPatient As %String(TRUNCATE = 1);

/// ***?
Property PAPMIEstimatedDeathDate As %String(TRUNCATE = 1);

/// ***?
Property PAPMIBatallion As %String(TRUNCATE = 1);

/// 医联卡
Property PAPMIHealthFundNo As %String(TRUNCATE = 1);

/// 出生国家指针(指向CT_Country)
Property PAPMICountryOfBirthDR As %String(TRUNCATE = 1);

/// 出生国家Code
Property PAPMICountryOfBirthCode As %String(TRUNCATE = 1);

/// 出生国家描述
Property PAPMICountryOfBirthDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Title)
Property PAPMITitleDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMITitleCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMITitleDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PreferredLanguage)
Property PAPMIPrefLanguageDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIPrefLanguageCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPMIPrefLanguageDesc As %String(TRUNCATE = 1);

/// 国家指针(指向CT_Region)
Property PAPMICTRegionDR As %String(TRUNCATE = 1);

/// 国家Code
Property PAPMICTRegionCode As %String(TRUNCATE = 1);

/// 国家描述
Property PAPMICTRegionDesc As %String(TRUNCATE = 1);

/// 省现在指针(指向CT_Province)
Property PAPMICTProvinceDR As %String(TRUNCATE = 1);

/// 省现在Code
Property PAPMICTProvinceCode As %String(TRUNCATE = 1);

/// 省现在描述
Property PAPMICTProvinceDesc As %String(TRUNCATE = 1);

/// 门诊病例号(目前弃用)
Property PAPMIGovernCardNo As %String(TRUNCATE = 1);

/// ****?
Property PAPMIInsuranceCardHolder As %String(TRUNCATE = 1);

/// 城市现住指针(指向CT_CityArea)
Property PAPMICityAreaDR As %String(TRUNCATE = 1);

/// 城市现住Code
Property PAPMICityAreaCode As %String(TRUNCATE = 1);

/// 城市现住描述
Property PAPMICityAreaDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPMIResponsibleForPayment As %String(TRUNCATE = 1);

/// 工作单位
Property PAPMISecondPhone As %String(TRUNCATE = 1);

/// 邮箱
Property PAPMIEmail As %String(TRUNCATE = 1);

/// 移动电话
Property PAPMIMobPhone As %String(TRUNCATE = 1);

/// ***?
Property PAPMIAuxInsTypeDR As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_IndigStatus)
Property PAPMIIndigStatDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIIndigStatCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPMIIndigStatDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPMIGPText As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_RefDoctorClinic)
Property PAPMIDentistClinicDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIDentistClinicCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPMIDentistClinicDesc As %String(TRUNCATE = 1);

/// 协和国际医疗部就诊卡标志
Property PAPMIVIPFlag As %String(TRUNCATE = 1);

/// ***?
Property PAPMIGPOrgAddress As %String(TRUNCATE = 1);

/// 出生城市指针(指向CT_City)
Property PAPMICityBirthDR As %String(TRUNCATE = 1);

/// 出生城市Code
Property PAPMICityBirthCode As %String(TRUNCATE = 1);

/// 出生城市Desc
Property PAPMICityBirthDesc As %String(TRUNCATE = 1);

/// 合同单位指针(指向CT_HealthCareArea)
Property PAPMICTHCADR As %String(TRUNCATE = 1);

/// 合同单位Code
Property PAPMICTHCACode As %String(TRUNCATE = 1);

/// 合同单位Desc
Property PAPMICTHCADesc As %String(TRUNCATE = 1);

/// ****?
Property PAPMIRequireAssistanceMeal As %String(TRUNCATE = 1);

/// ****?
Property PAPMIRequireAssistanceMenu As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PensionType)
Property PAPMIPensionTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPMIPensionTypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPMIPensionTypeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Person)
Property PAPMIMother1DR As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPMIMother1Desc As %String(TRUNCATE = 1);

/// ****?
Property PAPMIHealthCardExpiryDate As %String(TRUNCATE = 1);

/// ****?
Property PAPMIName4 As %String(TRUNCATE = 1);

/// ****?
Property PAPMIName5 As %String(TRUNCATE = 1);

/// ****?
Property PAPMIName6 As %String(TRUNCATE = 1);

/// ****?
Property PAPMIName7 As %String(TRUNCATE = 1);

/// ****?
Property PAPMIName8 As %String(TRUNCATE = 1);

/// 以下是PaPerson表字段
/// 患者姓名
Property PAPERName As %String(TRUNCATE = 1);

/// 患者姓名2
Property PAPERName2 As %String(TRUNCATE = 1);

/// ***?
Property PAPERSoundex3 As %String(TRUNCATE = 1);

/// 联系人电话
Property PAPERForeignPhone As %String(TRUNCATE = 1);

/// 出生日期
Property PAPERDob As %String(TRUNCATE = 1);

/// 患者性别指针(指向CT_Sex)
Property PAPERSexDR As %String(TRUNCATE = 1);

/// 患者性别Code
Property PAPERSexCode As %String(TRUNCATE = 1);

/// 患者性别描述
Property PAPERSexDesc As %String(TRUNCATE = 1);

/// 患者死亡
Property PAPERDeceased As %String(TRUNCATE = 1);

/// 行政区域
Property PAPERForeignCity As %String(TRUNCATE = 1);

/// 联系人邮编
Property PAPERForeignPostCode As %String(TRUNCATE = 1);

/// 婚姻状况指针(指向CT_Marital)
Property PAPERMaritalDR As %String(TRUNCATE = 1);

/// 婚姻状况Code
Property PAPERMaritalCode As %String(TRUNCATE = 1);

/// 婚姻状况描述
Property PAPERMaritalDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Education)
Property PAPEREducationDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPEREducationCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPEREducationDesc As %String(TRUNCATE = 1);

/// 民族指针(指向CT_Nation)
Property PAPERNationDR As %String(TRUNCATE = 1);

/// 民族Code
Property PAPERNationCode As %String(TRUNCATE = 1);

/// 民族描述
Property PAPERNationDesc As %String(TRUNCATE = 1);

/// 宗教指针(指向CT_Religion)
Property PAPERReligionDR As %String(TRUNCATE = 1);

/// 宗教Code
Property PAPERReligionCode As %String(TRUNCATE = 1);

/// 宗教描述
Property PAPERReligionDesc As %String(TRUNCATE = 1);

/// ***?指针(指向SS_Language)
Property PAPERLangPrimDR As %String(TRUNCATE = 1);

/// **?Code
Property PAPERLangPrimCode As %String(TRUNCATE = 1);

/// **?描述
Property PAPERLangPrimDesc As %String(TRUNCATE = 1);

/// 联系人地址
Property PAPERForeignAddress As %String(TRUNCATE = 1);

/// ****?
Property PAPERSoundex2 As %String(TRUNCATE = 1);

/// 地址
Property PAPERStName As %String(TRUNCATE = 1);

/// 医保类型指针？(指向ARC_InsuranceType)
Property PAPERInsTypeDR As %String(TRUNCATE = 1);

/// 医保类型Code?
Property PAPERInsTypeCode As %String(TRUNCATE = 1);

/// 医保类型描述？
Property PAPERInsTypeDesc As %String(TRUNCATE = 1);

/// ****?
Property PAPERSoundex1 As %String(TRUNCATE = 1);

/// 城市现住指针？(指向CT_City)
Property PAPERCityCodeDR As %String(TRUNCATE = 1);

/// 城市现住Code?
Property PAPERCityCodeCode As %String(TRUNCATE = 1);

/// 城市现住描述？
Property PAPERCityCodeDesc As %String(TRUNCATE = 1);

/// ***指针？(指向CT_State)
Property PAPERStateCodeDR As %String(TRUNCATE = 1);

/// ***Code?
Property PAPERStateCodeCode As %String(TRUNCATE = 1);

/// ***描述？
Property PAPERStateCodeDesc As %String(TRUNCATE = 1);

/// 邮编指针(指向CT_Zip)
Property PAPERZipDR As %String(TRUNCATE = 1);

/// 邮编Code
Property PAPERZipCode As %String(TRUNCATE = 1);

/// 邮编描述
Property PAPERZipDesc As %String(TRUNCATE = 1);

/// 单位电话
Property PAPERTelO As %String(TRUNCATE = 1);

/// 社会地位指针(指向CT_SocialStatus)
Property PAPERSocialStatusDR As %String(TRUNCATE = 1);

/// 社会地位Code
Property PAPERSocialStatusCode As %String(TRUNCATE = 1);

/// 社会地位描述
Property PAPERSocialStatusDesc As %String(TRUNCATE = 1);

/// 家庭电话
Property PAPERTelH As %String(TRUNCATE = 1);

/// 联系人身份证号
Property PAPERForeignCountry As %String(TRUNCATE = 1);

/// 国家指针(指向CT_Country)
Property PAPERCountryDR As %String(TRUNCATE = 1);

/// 国家Code
Property PAPERCountryCode As %String(TRUNCATE = 1);

/// 国家描述
Property PAPERCountryDesc As %String(TRUNCATE = 1);

/// ****?
Property PAPERInsCardOwner As %String(TRUNCATE = 1);

/// 职业指针(指向CT_Occupation)
Property PAPEROccupationDR As %String(TRUNCATE = 1);

/// 职业Code
Property PAPEROccupationCode As %String(TRUNCATE = 1);

/// 职业描述
Property PAPEROccupationDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_RefDoctor)
Property PAPERFamilyDoctorDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERFamilyDoctorCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERFamilyDoctorDesc As %String(TRUNCATE = 1);

/// 备注
Property PAPERRemark As %String(TRUNCATE = 1);

/// 死亡日期
Property PAPERDeceasedDate As %String(TRUNCATE = 1);

/// 联系人
Property PAPERForeignId As %String(TRUNCATE = 1);

/// 出生国家指针(指向CT_Country)
Property PAPERCountryBirthDR As %String(TRUNCATE = 1);

/// 出生国家Code
Property PAPERCountryBirthCode As %String(TRUNCATE = 1);

/// 出生国家描述
Property PAPERCountryBirthDesc As %String(TRUNCATE = 1);

/// ***？
Property PAPEREstAgeYear As %String(TRUNCATE = 1);

/// ***？
Property PAPEREstAgeMonth As %String(TRUNCATE = 1);

/// ***？
Property PAPEREstAgeTmStmp As %String(TRUNCATE = 1);

/// 死亡时间
Property PAPERDeceasedTime As %String(TRUNCATE = 1);

/// 出生区域指针(指向CT_Region)
Property PAPERRegionBirthDR As %String(TRUNCATE = 1);

/// 出生区域Code
Property PAPERRegionBirthCode As %String(TRUNCATE = 1);

/// 出生区域描述
Property PAPERRegionBirthDesc As %String(TRUNCATE = 1);

/// ***?指针(指向ARC_Debtor)
Property PAPERDebtorDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERDebtorCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERDebtorDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERInsuranceCardHolder As %String(TRUNCATE = 1);

/// 出生省份指针(指向CTProvince)
Property PAPERProvinceBirthDR As %String(TRUNCATE = 1);

/// 出生省份Code
Property PAPERProvinceBirthCode As %String(TRUNCATE = 1);

/// 出生省份描述
Property PAPERProvinceBirthDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_EmployeeType)
Property PAPEREmplTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPEREmplTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPEREmplTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERJobTitle As %String(TRUNCATE = 1);

/// ***?
Property PAPEREmplRelatedTo As %String(TRUNCATE = 1);

/// 关系指针(指向CT_Relation)
Property PAPERCTRLTDR As %String(TRUNCATE = 1);

/// 关系Code
Property PAPERCTRLTCode As %String(TRUNCATE = 1);

/// 关系描述
Property PAPERCTRLTDesc As %String(TRUNCATE = 1);

/// 工号
Property PAPEREmployeeNo As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Loc)
Property PAPEREmplDepDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPEREmplDepCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPEREmplDepDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERDiscDateFrom As %String(TRUNCATE = 1);

/// ***?
Property PAPERDiscDateTo As %String(TRUNCATE = 1);

/// ***?指针(指向ARC_DiscType)
Property PAPERDiscTypeDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERDiscTypeCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERDiscTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPEROutstandAmt As %String(TRUNCATE = 1);

/// 病人级别指针(指向CT_EmpFunc)
Property PAPEREmployeeFunction As %String(TRUNCATE = 1);

/// 病人级别Code
Property PAPEREmployeeFunctionCode As %String(TRUNCATE = 1);

/// 病人级别描述
Property PAPEREmployeeFunctionDesc As %String(TRUNCATE = 1);

/// 集团、单位指针(指向CT_Company)
Property PAPEREmployeeCompany As %String(TRUNCATE = 1);

///  集团、单位Code
Property PAPEREmployeeCompanyCode As %String(TRUNCATE = 1);

///  集团、单位描述
Property PAPEREmployeeCompanyDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_CompanyContract)
Property PAPEREmployeeCoContract As %String(TRUNCATE = 1);

/// ***?Code
Property PAPEREmployeeCoContractCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPEREmployeeCoContractDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Person)
Property PAPERGuardian1DR As %String(TRUNCATE = 1);

/// ***?指针(指向PA_Person)
Property PAPERGuardian2DR As %String(TRUNCATE = 1);

/// ***?
Property PAPEROutstandingDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERExpectedPayDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERBillCode As %String(TRUNCATE = 1);

/// ***?
Property PAPERNokName As %String(TRUNCATE = 1);

/// ***?
Property PAPERNokPhone As %String(TRUNCATE = 1);

/// ***?
Property PAPERNokText As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Relation)
Property PAPERNokCTRLTDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERNokCTRLTCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERNokCTRLTDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Region)
Property PAPERCTRegionDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERCTRegionCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERCTRegionDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Province)
Property PAPERCTProvinceDR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERCTProvinceCode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERCTProvinceDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_HealthCareArea)
Property PAPERCTHCADR As %String(TRUNCATE = 1);

/// ***?Code
Property PAPERCTHCACode As %String(TRUNCATE = 1);

/// ***?描述
Property PAPERCTHCADesc As %String(TRUNCATE = 1);

/// 出生城市指针(指向CT_City)
Property PAPERCityBirthDR As %String(TRUNCATE = 1);

/// 出生城市Code
Property PAPERCityBirthCode As %String(TRUNCATE = 1);

/// 出生城市描述
Property PAPERCityBirthDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERName3 As %String(TRUNCATE = 1);

/// 门诊病历号
Property PAPERGovernCardNo As %String(TRUNCATE = 1);

/// ****?
Property PAPERFromThisArea As %String(TRUNCATE = 1);

/// ****?
Property PAPERForeignNotes As %String(TRUNCATE = 1);

/// ****?
Property PAPERReasonForChangeData As %String(TRUNCATE = 1);

/// 更新人指针(指向SS_User)
Property PAPERUserUpdate As %String(TRUNCATE = 1);

/// 更新人Code
Property PAPERUserUpdateCode As %String(TRUNCATE = 1);

/// 更新人Desc
Property PAPERUserUpdateDesc As %String(TRUNCATE = 1);

/// ****?
Property PAPERExemptionNumber As %String(TRUNCATE = 1);

/// 地址县现住指针(指向CT_CityArea)
Property PAPERCityAreaDR As %String(TRUNCATE = 1);

/// 地址县现住Code
Property PAPERCityAreaCode As %String(TRUNCATE = 1);

/// 地址县现住Desc
Property PAPERCityAreaDesc As %String(TRUNCATE = 1);

/// ****？
Property PAPERComplement As %String(TRUNCATE = 1);

/// ****？指针(指向PA_Person)
Property PAPERResponsibleForPayment As %String(TRUNCATE = 1);

/// *母亲指针(指向PA_Person)
Property PAPERMotherDR As %String(TRUNCATE = 1);

/// 父亲指针(指向PA_Person)
Property PAPERFatherDR As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_FamilyGroup)
Property PAPERFamilyGroupDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERFamilyGroupCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERFamilyGroupDesc As %String(TRUNCATE = 1);

/// ***?指针(指向ARC_DisretOutstType)
Property PAPERDiscretOutsTypeDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERDiscretOutsTypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERDiscretOutsTypeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_HealthCareProvider)
Property PAPERHCPDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERHCPCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERHCPDesc As %String(TRUNCATE = 1);

/// 工作单位
Property PAPERSecondPhone As %String(TRUNCATE = 1);

/// ***?
Property PAPERNokAddress1 As %String(TRUNCATE = 1);

/// ***?指针(指向CT_City)
Property PAPERNokCityDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERNokCityCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERNokCityDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Zip)
Property PAPERNokZipDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERNokZipCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERNokZipDesc As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERNokAddress2 As %String(TRUNCATE = 1);

/// 电子邮箱
Property PAPEREmail As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Title)
Property PAPERTitleDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERTitleCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERTitleDesc As %String(TRUNCATE = 1);

/// 移动电话?
Property PAPERMobPhone As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_IndigStatus)
Property PAPERIndigStatDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERIndigStatCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERIndigStatDesc As %String(TRUNCATE = 1);

/// ***?指针(指向ARC_AuxilInsurType)
Property PAPERAuxInsTypeDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERAuxInsTypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERAuxInsTypeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PreferredLanguage)
Property PAPERPrefLanguageDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERPrefLanguageCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERPrefLanguageDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_PatientType)
Property PAPERPatTypeDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERPatTypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERPatTypeDesc As %String(TRUNCATE = 1);

/// 更新日期
Property PAPERUpdateDate As %String(TRUNCATE = 1);

/// 更新时间
Property PAPERUpdateTime As %String(TRUNCATE = 1);

/// ***？
Property PAPERGLFlag As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_RefDoctorClinic)
Property PAPERFamilyDoctorClinicDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERFamilyDoctorClinicCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERFamilyDoctorClinicDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERDonatedOrgansOnDeath As %String(TRUNCATE = 1);

/// ***?
Property PAPERWhoNotified As %String(TRUNCATE = 1);

/// ***?
Property PAPERLocationOfDeath As %String(TRUNCATE = 1);

/// ***?
Property PAPEREstDOB As %String(TRUNCATE = 1);

/// ***?
Property PAPERStayingPermanently As %String(TRUNCATE = 1);

/// ***?
Property PAPERDateOfEntry As %String(TRUNCATE = 1);

/// ***?指针(指向CT_Country)
Property PAPERCountryCameFromDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERCountryCameFromCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERCountryCameFromDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERNationalResident As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_OSVisitorStatus)
Property PAPEROSVStatusDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPEROSVStatusCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPEROSVStatusDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERInterviewedBy As %String(TRUNCATE = 1);

/// ***?
Property PAPERDateOfInterview As %String(TRUNCATE = 1);

/// 插入日期
Property PAPERDateAdded As %String(TRUNCATE = 1);

/// 加入人指针(指向SS_User)
Property PAPERUserAddedDR As %String(TRUNCATE = 1);

/// 加入人Code
Property PAPERUserAddedCode As %String(TRUNCATE = 1);

/// 加入人Desc
Property PAPERUserAddedDesc As %String(TRUNCATE = 1);

/// 指向pa_patmas指针
Property PAPERPAPMIDR As %String(TRUNCATE = 1);

/// ***?
Property PAPERNOKBusPhone As %String(TRUNCATE = 1);

/// 最后一次更新人医院指针(指向CT_Hospital)
Property PAPERLastUpdateHospitalDR As %String(TRUNCATE = 1);

/// 最后一次更新人医院Code
Property PAPERLastUpdateHospitalCode As %String(TRUNCATE = 1);

/// 最后一次更新人医院描述
Property PAPERLastUpdateHospitalDesc As %String(TRUNCATE = 1);

/// ***?指针(指向CT_CareProv)
Property PAPERDoctorDeclaredDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERDoctorDeclaredCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERDoctorDeclaredDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERNOKInformed As %String(TRUNCATE = 1);

/// ***?
Property PAPERProcuratorFiscalInformed As %String(TRUNCATE = 1);

/// ***?
Property PAPERInterpreterRequired As %String(TRUNCATE = 1);

/// ***?
Property PAPERPrevHACCEligible As %String(TRUNCATE = 1);

/// ***?指针(指向RB_Resource)
Property PAPERUsualRoundDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERUsualRoundCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERUsualRoundDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_EmploymentStatus)
Property PAPEREmploymentStatDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPEREmploymentStatCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPEREmploymentStatDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_SourceOfIncome)
Property PAPERSourceOfIncomeDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERSourceOfIncomeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERSourceOfIncomeDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_LivingArrangement)
Property PAPERLivingArrangementDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERLivingArrangementCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERLivingArrangementDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_ResidenceStatus)
Property PAPERResidenceStatusDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERResidenceStatusCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERResidenceStatusDesc As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_TransportUsed)
Property PAPERTransportUsedDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERTransportUsedCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERTransportUsedDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERCancerReg As %String(TRUNCATE = 1);

/// 血型指针(指向PAC_BloodType)
Property PAPERBloodTypeDR As %String(TRUNCATE = 1);

/// 血型指针Code
Property PAPERBloodTypeCode As %String(TRUNCATE = 1);

/// 血型指针Desc
Property PAPERBloodTypeDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPEREffDateCurrAddress As %String(TRUNCATE = 1);

/// ***?
Property PAPERFeedBackConsent As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_AusSouthSeaIslander)
Property PAPERAusSouthSeaIslanderDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERAusSouthSeaIslanderCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERAusSouthSeaIslanderDesc As %String(TRUNCATE = 1);

/// ***?职业
Property PAPEROccupation As %String(TRUNCATE = 1);

/// ***?
Property PAPERIncompleteRegistration As %String(TRUNCATE = 1);

/// ***?
Property PAPERFamilyLinkText As %String(TRUNCATE = 1);

/// ***?
Property PAPERDVAExpiryDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERPensionCardExpiryDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERReversedBy As %String(TRUNCATE = 1);

/// 患者医院指针(指向CTHospital)
Property PAPERHospitalDR As %String(TRUNCATE = 1);

/// 患者医院Code
Property PAPERHospitalCode As %String(TRUNCATE = 1);

/// 患者医院Desc
Property PAPERHospitalDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERName4 As %String(TRUNCATE = 1);

/// ***?
Property PAPERName5 As %String(TRUNCATE = 1);

/// ***?
Property PAPERName6 As %String(TRUNCATE = 1);

/// ***?
Property PAPERName7 As %String(TRUNCATE = 1);

/// ***?
Property PAPERName8 As %String(TRUNCATE = 1);

/// ***?
Property PAPERDentalDisplay As %String(TRUNCATE = 1);

/// ***?
Property PAPERFeedbackConsentDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERAddress2 As %String(TRUNCATE = 1);

/// ***?
Property PAPERPassportNumber As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_DependentChildren)
Property PAPERDependChildrenDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERDependChildrenCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERDependChildrenDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERPreferredContactMethod As %String(TRUNCATE = 1);

/// ***?
Property PAPERContactNotes As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_AccomSetting)
Property PAPERAccomSettingDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERAccomSettingCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERAccomSettingDesc As %String(TRUNCATE = 1);

/// 患者照片
Property PAPERPhoto As %String(TRUNCATE = 1);

/// ***?
Property PAPERPDSSerialNumber As %String(TRUNCATE = 1);

/// ***?
Property PAPEREmployeeDateFrom As %String(TRUNCATE = 1);

/// ***?
Property PAPEREmployeeDateTo As %String(TRUNCATE = 1);

/// ***?
Property PAPEREmployeeGrade As %String(TRUNCATE = 1);

/// ***?
Property PAPERHouseBuildingNo As %String(TRUNCATE = 1);

/// ***?
Property PAPERAppartmentNo As %String(TRUNCATE = 1);

/// ***?
Property PAPERGravida As %String(TRUNCATE = 1);

/// ***?
Property PAPERPara As %String(TRUNCATE = 1);

/// ***?
Property PAPERMiscarriage As %String(TRUNCATE = 1);

/// ***?
Property PAPERTOP As %String(TRUNCATE = 1);

/// ***?
Property PAPERPreTerm As %String(TRUNCATE = 1);

/// ***?
Property PAPERMultBirth As %String(TRUNCATE = 1);

/// ***?
Property PAPERLivingChild As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_SpecialNeedsStatus)
Property PAPERSpecNeedStatDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERSpecNeedStatCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERSpecNeedStatDesc As %String(TRUNCATE = 1);

/// ***?
Property PAPERSNSLastReviewDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERSNSNextReviewDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERSNSLastLiveUpdDate As %String(TRUNCATE = 1);

/// ***?
Property PAPERPostCode As %String(TRUNCATE = 1);

/// ***?指针(指向PAC_IDDocType)
Property PAPERIDDocTypeDR As %String(TRUNCATE = 1);

/// ****?Code
Property PAPERIDDocTypeCode As %String(TRUNCATE = 1);

/// ***?Desc
Property PAPERIDDocTypeDesc As %String(TRUNCATE = 1);

/// DocNumber
Property PAPERDocNumber As %String(TRUNCATE = 1);

/// ChineseName
Property PAPERChineseName As %String(TRUNCATE = 1);

/// NoChinName
Property PAPERNoChinName As %String(TRUNCATE = 1);

/// CCC1
Property PAPERCCC1 As %String(TRUNCATE = 1);

/// CCC2
Property PAPERCCC2 As %String(TRUNCATE = 1);

/// CCC3
Property PAPERCCC3 As %String(TRUNCATE = 1);

/// CCC4
Property PAPERCCC4 As %String(TRUNCATE = 1);

/// CCC5
Property PAPERCCC5 As %String(TRUNCATE = 1);

/// CCC6
Property PAPERCCC6 As %String(TRUNCATE = 1);

/// ChineseAddress
Property PAPERChineseAddress As %String(TRUNCATE = 1);

/// ChineseDistrict
Property PAPERChineseDistrict As %String(TRUNCATE = 1);

/// ChineseArea
Property PAPERChineseArea As %String(TRUNCATE = 1);

/// Pager
Property PAPERPager As %String(TRUNCATE = 1);

/// Fax
Property PAPERFax As %String(TRUNCATE = 1);

/// PhotoDocument
Property PAPERPhotoDocument As %String(TRUNCATE = 1);

/// Email2
Property PAPEREmail2 As %String(TRUNCATE = 1);

}
