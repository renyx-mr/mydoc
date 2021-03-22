/// 名称:    DHCDoc.GetInfo.Public.EPMI
/// 描述:    主索引信息获取
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
Class DHCDoc.GetInfo.Public.EPMI [ Abstract ]
{

/// 描述:    分诊相关信息获取公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.25
/// w ##class(DHCDoc.GetInfo.Public.EPMI).GetPatBaseInfo()
ClassMethod GetPatBaseInfo(PatientID As %String) As DHCDoc.GetInfo.Entry.PAPatMas
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.PAPatMas).%New()
	s PatMasObj=##class(User.PAPatMas).%OpenId(PatientID)
	if $ISOBJECT(PatMasObj) {
		s OutputObj.PAPMIRowId=PatientID
		s OutputObj.PAPMINo=PatMasObj.PAPMINo
		s OutputObj.PAPMIID=PatMasObj.PAPMIID
		s OutputObj.PAPMIName=PatMasObj.PAPMIName
		s OutputObj.PAPMIName2=PatMasObj.PAPMIName2
		s OutputObj.PAPMIAlias=PatMasObj.PAPMIAlias
		s OutputObj.PAPMIForeignPhoneNo=PatMasObj.PAPMIForeignPhoneNo
		s OutputObj.PAPMIIPNo=PatMasObj.PAPMIIPNo
		s OutputObj.PAPMIOPNo=PatMasObj.PAPMIOPNo
		s OutputObj.PAPMIDOB=PatMasObj.PAPMIDOB
		s OutputObj.PAPMIEstAgeYear=PatMasObj.PAPMIEstAgeYear
		s OutputObj.PAPMIEstAgeMonth=PatMasObj.PAPMIEstAgeMonth
		s OutputObj.PAPMIEstAgeTmStmp=PatMasObj.PAPMIEstAgeTmStmp
		s OutputObj.PAPMISexDR=PatMasObj.PAPMISexDR
		if $ISOBJECT(OutputObj.PAPMISexDR) {
			s OutputObj.PAPMISexDR=PatMasObj.PAPMISexDR.%Id()
			s SexObj=##class(User.CTSex).%OpenId(OutputObj.PAPMISexDR)
			if $ISOBJECT(SexObj) {
				s OutputObj.PAPMISexCode=SexObj.CTSEXCode
				s OutputObj.PAPMISexDesc=SexObj.CTSEXDesc
				do SexObj.%Close()
			}
		}
		s OutputObj.PAPMISoundex=PatMasObj.PAPMISoundex
		s OutputObj.PAPMILangPrimDR=PatMasObj.PAPMILangPrimDR
		if $ISOBJECT(OutputObj.PAPMILangPrimDR) {
			s OutputObj.PAPMILangPrimDR=PatMasObj.PAPMILangPrimDR.%Id()
			s LanguageObj=##class(User.SSLanguage).%OpenId(OutputObj.PAPMILangPrimDR)
			if $ISOBJECT(LanguageObj) {
				s OutputObj.PAPMILangPrimCode=LanguageObj.CTLANCode
				s OutputObj.PAPMILangPrimDesc=LanguageObj.CTLANDesc
				do LanguageObj.%Close()
			}
		}
		s OutputObj.PAPMIActive=PatMasObj.PAPMIActive
		s OutputObj.PAPMIPatCategoryDR=PatMasObj.PAPMIPatCategoryDR
		if $ISOBJECT(OutputObj.PAPMIPatCategoryDR) {
			s OutputObj.PAPMIPatCategoryDR=PatMasObj.PAPMIPatCategoryDR.%Id()
			s PatCatObj=##class(User.PACPatientCategory).%OpenId(OutputObj.PAPMIPatCategoryDR)
			if $ISOBJECT(PatCatObj) {
				s OutputObj.PAPMIPatCategoryCode=PatCatObj.PCATCode
				s OutputObj.PAPMIPatCategoryDesc=PatCatObj.PCATDesc
				do PatCatObj.%Close()
			}
		}
		s OutputObj.PAPMIHomeClinicNo=PatMasObj.PAPMIHomeClinicNo
		s OutputObj.PAPMINxtOPAdmNo=PatMasObj.PAPMINxtOPAdmNo
		s OutputObj.PAPMILangPrintDR=PatMasObj.PAPMILangPrintDR
		s OutputObj.PAPMIRemark=PatMasObj.PAPMIRemark
		s OutputObj.PAPMILangSecondDR=PatMasObj.PAPMILangSecondDR
		if $ISOBJECT(OutputObj.PAPMILangSecondDR) {
			s OutputObj.PAPMILangSecondDR=PatMasObj.PAPMILangSecondDR.%Id()
			s LanguageObj=##class(User.SSLanguage).%OpenId(OutputObj.PAPMILangSecondDR)
			if $ISOBJECT(PatCatObj) {
				s OutputObj.PAPMILangSecondCode=LanguageObj.CTLANCode
				s OutputObj.PAPMILangSecondDesc=LanguageObj.CTLANDesc
				do LanguageObj.%Close()
			}
		}
		s OutputObj.PAPMIDeceased=PatMasObj.PAPMIDeceased
		s OutputObj.PAPMIDeceasedDate=PatMasObj.PAPMIDeceasedDate
		s OutputObj.PAPMIDeceasedTime=PatMasObj.PAPMIDeceasedTime
		s OutputObj.PAPMIBlackList=PatMasObj.PAPMIBlackList
		s OutputObj.PAPMIMotherDR=PatMasObj.PAPMIMotherDR
		if $ISOBJECT(OutputObj.PAPMIMotherDR) {
		   s OutputObj.PAPMIMotherDR=PatMasObj.PAPMIMotherDR.%Id()	
		   s PAMotherObj=##class(User.PAMother).%OpenId(OutputObj.PAPMIMotherDR)
			if $ISOBJECT(PAMotherObj) {
				s OutputObj.PAPMIMotherCode=""
				s OutputObj.PAPMIMotherDesc=""
				do PAMotherObj.%Close()
			}
		}
		s OutputObj.PAPMIRefDocDR=PatMasObj.PAPMIRefDocDR
		if $ISOBJECT(OutputObj.PAPMIRefDocDR) {
		   s OutputObj.PAPMIRefDocDR=PatMasObj.PAPMIRefDocDR.%Id()	
		   s PACRefDObj=##class(User.PACRefDoctor).%OpenId(OutputObj.PAPMIRefDocDR)
			if $ISOBJECT(PACRefDObj) {
				s OutputObj.PAPMIRefDocCode=PACRefDObj.REFDCode
				s OutputObj.PAPMIRefDocDesc=PACRefDObj.REFDDesc
				do PACRefDObj.%Close()
			}
		}
		s OutputObj.PAPMIMedicare=PatMasObj.PAPMIMedicare
		s OutputObj.PAPMIName3=PatMasObj.PAPMIName3
		s OutputObj.PAPMIRefund=PatMasObj.PAPMIRefund
		s OutputObj.PAPMIUserUpdate=PatMasObj.PAPMIUserUpdate
		if $ISOBJECT(OutputObj.PAPMIUserUpdate) {
		   s OutputObj.PAPMIUserUpdate=PatMasObj.PAPMIUserUpdate.%Id()	
		   s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAPMIUserUpdate)
			if $ISOBJECT(UserObj) {
				s OutputObj.PAPMIUserUpdateCode=UserObj.SSUSRInitials
				s OutputObj.PAPMIUserUpdateDesc=UserObj.SSUSRName
				do UserObj.%Close()
			}
		}
		s OutputObj.PAPMITraceStatusDR=PatMasObj.PAPMITraceStatusDR
		if $ISOBJECT(OutputObj.PAPMITraceStatusDR) {
		   s OutputObj.PAPMITraceStatusDR=PatMasObj.PAPMITraceStatusDR.%Id()	
		   s PACTOutCObj=##class(User.PACTraceOutcome).%OpenId(OutputObj.PAPMITraceStatusDR)
			if $ISOBJECT(PACTOutCObj) {
				s OutputObj.PAPMITraceStatusCode=PACTOutCObj.TRACECode
				s OutputObj.PAPMITraceStatusDesc=PACTOutCObj.TRACEDesc
				do PACTOutCObj.%Close()
			}
		}
		s OutputObj.PAPMIMedicareSuffixDR=PatMasObj.PAPMIMedicareSuffixDR
		if $ISOBJECT(OutputObj.PAPMIMedicareSuffixDR) {
		   s OutputObj.PAPMIMedicareSuffixDR=PatMasObj.PAPMIMedicareSuffixDR.%Id()	
		   s PACMedObj=##class(User.PACMedicareSuffix).%OpenId(OutputObj.PAPMIMedicareSuffixDR)
			if $ISOBJECT(PACMedObj) {
				s OutputObj.PAPMIMedicareSuffixCode=PACMedObj.MEDSUFCode
				s OutputObj.PAPMIMedicareSuffixDesc=PACMedObj.MEDSUFDesc
				do PACMedObj.%Close()
			}
		}
		s OutputObj.PAPMIMedicareCode=PatMasObj.PAPMIMedicareCode
		//s OutputObj.PAPMIAllergy=PatMasObj.PAPMIAllergy
		s OutputObj.PAPMIAllergy=PatMasObj.ChildPAAllergy
		///PAPMIAllergy.Count(); obj=PAPMIAllergy.GetAt(i);
		s OutputObj.PAPMIConcessionCardNo=PatMasObj.PAPMIConcessionCardNo
		s OutputObj.PAPMIConcessionCardExpDate=PatMasObj.PAPMIConcessionCardExpDate
		s OutputObj.PAPMISafetyNetCardNo=PatMasObj.PAPMISafetyNetCardNo
		s OutputObj.PAPMISafetyNetCardExpDate=PatMasObj.PAPMISafetyNetCardExpDate
		s OutputObj.PAPMIDVAnumber=PatMasObj.PAPMIDVAnumber
        s OutputObj.PAPMICardTypeDR=PatMasObj.PAPMICardTypeDR
		if $ISOBJECT(OutputObj.PAPMICardTypeDR) {
		   s OutputObj.PAPMICardTypeDR=PatMasObj.PAPMICardTypeDR.%Id()	
		   s CardTypeObj=##class(User.PACCardType).%OpenId(OutputObj.PAPMICardTypeDR)
			if $ISOBJECT(CardTypeObj) {
				s OutputObj.PAPMICardTypeCode=CardTypeObj.CARDCode
				s OutputObj.PAPMICardTypeDesc=CardTypeObj.CARDDesc
				do CardTypeObj.%Close()
			}
		}
		s OutputObj.PAPMIMedicareExpDate=PatMasObj.PAPMIMedicareExpDate
		s OutputObj.PAPMICHCPatient=PatMasObj.PAPMICHCPatient
		s OutputObj.PAPMIEstimatedDeathDate=PatMasObj.PAPMIEstimatedDeathDate
		s OutputObj.PAPMIBatallion=PatMasObj.PAPMIBatallion
		s OutputObj.PAPMIHealthFundNo=PatMasObj.PAPMIHealthFundNo
        s OutputObj.PAPMICountryOfBirthDR=PatMasObj.PAPMICountryOfBirthDR
		if $ISOBJECT(OutputObj.PAPMICountryOfBirthDR) {
		   s OutputObj.PAPMICountryOfBirthDR=PatMasObj.PAPMICountryOfBirthDR.%Id()	
		   s CountryObj=##class(User.CTCountry).%OpenId(OutputObj.PAPMICountryOfBirthDR)
			if $ISOBJECT(CountryObj) {
				s OutputObj.PAPMICountryOfBirthCode=CountryObj.CTCOUCode
				s OutputObj.PAPMICountryOfBirthDesc=CountryObj.CTCOUDesc
				do CountryObj.%Close()
			}
		}
		s OutputObj.PAPMITitleDR=PatMasObj.PAPMITitleDR
		if $ISOBJECT(OutputObj.PAPMITitleDR) {
		   s OutputObj.PAPMITitleDR=PatMasObj.PAPMITitleDR.%Id()	
		   s CTTitleObj=##class(User.CTTitle).%OpenId(OutputObj.PAPMITitleDR)
			if $ISOBJECT(CTTitleObj) {
				s OutputObj.PAPMITitleCode=CTTitleObj.TTLCode
				s OutputObj.PAPMITitleDesc=CTTitleObj.TTLDesc
				do CTTitleObj.%Close()
			}
		}
		s OutputObj.PAPMIPrefLanguageDR=PatMasObj.PAPMIPrefLanguageDR
		if $ISOBJECT(OutputObj.PAPMIPrefLanguageDR) {
		   s OutputObj.PAPMIPrefLanguageDR=PatMasObj.PAPMIPrefLanguageDR.%Id()	
		   s LanguageObj=##class(User.PACPreferredLanguage).%OpenId(OutputObj.PAPMIPrefLanguageDR)
			if $ISOBJECT(LanguageObj) {
				s OutputObj.PAPMIPrefLanguageCode=LanguageObj.CTLANCode
				s OutputObj.PAPMIPrefLanguageDesc=LanguageObj.CTLANDesc
				do LanguageObj.%Close()
			}
		}
		s OutputObj.PAPMICTRegionDR=PatMasObj.PAPMICTRegionDR
		if $ISOBJECT(OutputObj.PAPMICTRegionDR) {
		   s OutputObj.PAPMICTRegionDR=PatMasObj.PAPMICTRegionDR.%Id()	
		   s CTRegionObj=##class(User.CTRegion).%OpenId(OutputObj.PAPMICTRegionDR)
			if $ISOBJECT(CTRegionObj) {
				s OutputObj.PAPMICTRegionCode=CTRegionObj.CTRGCode
				s OutputObj.PAPMICTRegionDesc=CTRegionObj.CTRGDesc
				do CTRegionObj.%Close()
			}
		}	
		s OutputObj.PAPMICTProvinceDR=PatMasObj.PAPMICTProvinceDR
		if $ISOBJECT(OutputObj.PAPMICTProvinceDR) {
		   s OutputObj.PAPMICTProvinceDR=PatMasObj.PAPMICTProvinceDR.%Id()	
		   s CTProviceObj=##class(User.CTProvince).%OpenId(OutputObj.PAPMICTProvinceDR)
			if $ISOBJECT(CTProviceObj) {
				s OutputObj.PAPMICTProvinceCode=CTProviceObj.PROVCode
				s OutputObj.PAPMICTProvinceDesc=CTProviceObj.PROVDesc
				do CTProviceObj.%Close()
			}
		}
		s OutputObj.PAPMIGovernCardNo=PatMasObj.PAPMIGovernCardNo
		s OutputObj.PAPMIInsuranceCardHolder=PatMasObj.PAPMIInsuranceCardHolder
		s OutputObj.PAPMICityAreaDR=PatMasObj.PAPMICityAreaDR
		if $ISOBJECT(OutputObj.PAPMICityAreaDR) {
		   s OutputObj.PAPMICityAreaDR=PatMasObj.PAPMICityAreaDR.%Id()	
		   s CTCityAreaObj=##class(User.CTCityArea).%OpenId(OutputObj.PAPMICityAreaDR)
			if $ISOBJECT(CTCityAreaObj) {
				s OutputObj.PAPMICityAreaCode=CTCityAreaObj.CITAREACode
				s OutputObj.PAPMICityAreaDesc=CTCityAreaObj.CITAREADesc
				do CTCityAreaObj.%Close()
			}
		}
		s OutputObj.PAPMISecondPhone=PatMasObj.PAPMISecondPhone
		s OutputObj.PAPMIEmail=PatMasObj.PAPMIEmail
		s OutputObj.PAPMIMobPhone=PatMasObj.PAPMIMobPhone
		s OutputObj.PAPMIAuxInsTypeDR=PatMasObj.PAPMIAuxInsTypeDR
		s OutputObj.PAPMIIndigStatDR=PatMasObj.PAPMIIndigStatDR
		if $ISOBJECT(OutputObj.PAPMIIndigStatDR) {
		   s OutputObj.PAPMIIndigStatDR=PatMasObj.PAPMIIndigStatDR.%Id()	
		   s PACIStaObj=##class(User.PACIndigStatus).%OpenId(OutputObj.PAPMIIndigStatDR)
			if $ISOBJECT(PACIStaObj) {
				s OutputObj.PAPMIIndigStatCode=PACIStaObj.INDSTCode
				s OutputObj.PAPMIIndigStatDesc=PACIStaObj.INDSTDesc
				do PACIStaObj.%Close()
			}
		}
		s OutputObj.PAPMIGPText=PatMasObj.PAPMIGPText
		s OutputObj.PAPMIDentistClinicDR=PatMasObj.PAPMIDentistClinicDR
		if $ISOBJECT(OutputObj.PAPMIDentistClinicDR) {
		   s OutputObj.PAPMIDentistClinicDR=PatMasObj.PAPMIDentistClinicDR.%Id()	
		   s PACRefDObj=##class(User.PACRefDoctorClinic).%OpenId(OutputObj.PAPMIDentistClinicDR)
			if $ISOBJECT(PACRefDObj) {
				s OutputObj.PAPMIDentistClinicCode=PACRefDObj.REFDCode
				s OutputObj.PAPMIDentistClinicDesc=PACRefDObj.REFDDesc
				do PACRefDObj.%Close()
			}
		}
		s OutputObj.PAPMIVIPFlag=PatMasObj.PAPMIVIPFlag
		s OutputObj.PAPMIGPOrgAddress=PatMasObj.PAPMIGPOrgAddress
		s OutputObj.PAPMICityBirthDR=PatMasObj.PAPMICityBirthDR
		if $ISOBJECT(OutputObj.PAPMICityBirthDR) {
		   s OutputObj.PAPMICityBirthDR=PatMasObj.PAPMICityBirthDR.%Id()	
		   s CTCityObj=##class(User.CTCity).%OpenId(OutputObj.PAPMICityBirthDR)
			if $ISOBJECT(CTCityObj) {
				s OutputObj.PAPMICityBirthCode=CTCityObj.CTCITCode
				s OutputObj.PAPMICityBirthDesc=CTCityObj.CTCITDesc
				do CTCityObj.%Close()
			}
		}
		s OutputObj.PAPMICTHCADR=PatMasObj.PAPMICTHCADR
		if $ISOBJECT(OutputObj.PAPMICTHCADR) {
		   s OutputObj.PAPMICTHCADR=PatMasObj.PAPMICTHCADR.%Id()	
		   s CTHealCareObj=##class(User.CTHealthCareArea).%OpenId(OutputObj.PAPMICTHCADR)
			if $ISOBJECT(CTHealCareObj) {
				s OutputObj.PAPMICTHCACode=CTHealCareObj.HCACode
				s OutputObj.PAPMICTHCADesc=CTHealCareObj.HCADesc
				do CTHealCareObj.%Close()
			}
		}
		s OutputObj.PAPMIRequireAssistanceMeal=PatMasObj.PAPMIRequireAssistanceMeal
		s OutputObj.PAPMIRequireAssistanceMenu=PatMasObj.PAPMIRequireAssistanceMenu
		s OutputObj.PAPMIPensionTypeDR=PatMasObj.PAPMIPensionTypeDR
		if $ISOBJECT(OutputObj.PAPMIPensionTypeDR) {
		   s OutputObj.PAPMIPensionTypeDR=PatMasObj.PAPMIPensionTypeDR.%Id()	
		   s PACPTypeObj=##class(User.PACPensionType).%OpenId(OutputObj.PAPMIPensionTypeDR)
			if $ISOBJECT(PACPTypeObj) {
				s OutputObj.PAPMIPensionTypeCode=PACPTypeObj.PENSTYPECode
				s OutputObj.PAPMIPensionTypeDesc=PACPTypeObj.PENSTYPEDesc
				do PACPTypeObj.%Close()
			}
		}
		s OutputObj.PAPMIMother1DR=PatMasObj.PAPMIMother1DR
		if $ISOBJECT(OutputObj.PAPMIMother1DR) {
		   s OutputObj.PAPMIMother1DR=PatMasObj.PAPMIMother1DR.%Id()	
		   s MPersonObj=##class(User.PAPerson).%OpenId(OutputObj.PAPMIMother1DR)
		   if $ISOBJECT(MPersonObj) {
				s OutputObj.PAPMIPensionTypeDesc=MPersonObj.PAPERName
				do MPersonObj.%Close()
			}
		}
		s OutputObj.PAPMIHealthCardExpiryDate=PatMasObj.PAPMIHealthCardExpiryDate
		s OutputObj.PAPMIName4=PatMasObj.PAPMIName4
		s OutputObj.PAPMIName5=PatMasObj.PAPMIName5
		s OutputObj.PAPMIName6=PatMasObj.PAPMIName6
		s OutputObj.PAPMIName7=PatMasObj.PAPMIName7
		s OutputObj.PAPMIName8=PatMasObj.PAPMIName8
		do PatMasObj.%Close()
		s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
		if $ISOBJECT(PersonObj) {
			s OutputObj.PAPERName=PersonObj.PAPERName
			s OutputObj.PAPERName2=PersonObj.PAPERName2
			s OutputObj.PAPERSoundex3=PersonObj.PAPERSoundex3
			s OutputObj.PAPERForeignPhone=PersonObj.PAPERForeignPhone
			s OutputObj.PAPERDob=PersonObj.PAPERDob
            s OutputObj.PAPERSexDR=PersonObj.PAPERSexDR
			if $ISOBJECT(OutputObj.PAPERSexDR) {
			   s OutputObj.PAPERSexDR=PersonObj.PAPERSexDR.%Id()	
			   s SexObj=##class(User.CTSex).%OpenId(OutputObj.PAPERSexDR)
			   if $ISOBJECT(SexObj) {
				    s OutputObj.PAPERSexCode=SexObj.CTSEXCode
					s OutputObj.PAPERSexDesc=SexObj.CTSEXDesc
					do SexObj.%Close()
				}
			}		
			s OutputObj.PAPERDeceased=PersonObj.PAPERDeceased
			s OutputObj.PAPERForeignCity=PersonObj.PAPERForeignCity
            s OutputObj.PAPERForeignPostCode=PersonObj.PAPERForeignPostCode	
			s OutputObj.PAPERMaritalDR=PersonObj.PAPERMaritalDR
			if $ISOBJECT(OutputObj.PAPERMaritalDR) {
			   s OutputObj.PAPERMaritalDR=PersonObj.PAPERMaritalDR.%Id()	
			   s MaritalObj=##class(User.CTMarital).%OpenId(OutputObj.PAPERMaritalDR)
			   if $ISOBJECT(MaritalObj) {
				    s OutputObj.PAPERMaritalCode=MaritalObj.CTMARCode
					s OutputObj.PAPERMaritalDesc=MaritalObj.CTMARDesc
					do MaritalObj.%Close()
				}
			}
			s OutputObj.PAPEREducationDR=PersonObj.PAPEREducationDR
			if $ISOBJECT(OutputObj.PAPEREducationDR) {
			   s OutputObj.PAPEREducationDR=PersonObj.PAPEREducationDR.%Id()	
			   s EducationObj=##class(User.CTEducation).%OpenId(OutputObj.PAPEREducationDR)
			   if $ISOBJECT(EducationObj) {
				    s OutputObj.PAPEREducationCode=EducationObj.EDUCode
					s OutputObj.PAPEREducationDesc=EducationObj.EDUDesc
					do EducationObj.%Close()
				}
			}
			s OutputObj.PAPERNationDR=PersonObj.PAPERNationDR
			if $ISOBJECT(OutputObj.PAPERNationDR) {
			   s OutputObj.PAPERNationDR=PersonObj.PAPERNationDR.%Id()	
			   s NationObj=##class(User.CTNation).%OpenId(OutputObj.PAPERNationDR)
			   if $ISOBJECT(NationObj) {
				    s OutputObj.PAPERNationCode=NationObj.CTNATCode
					s OutputObj.PAPERNationDesc=NationObj.CTNATDesc
					do NationObj.%Close()
				}
			}
			s OutputObj.PAPERReligionDR=PersonObj.PAPERReligionDR
			if $ISOBJECT(OutputObj.PAPERReligionDR) {
			   s OutputObj.PAPERReligionDR=PersonObj.PAPERReligionDR.%Id()	
			   s ReligionObj=##class(User.CTReligion).%OpenId(OutputObj.PAPERReligionDR)
			   if $ISOBJECT(ReligionObj) {
				    s OutputObj.PAPERReligionCode=ReligionObj.CTRLGCode
					s OutputObj.PAPERReligionDesc=ReligionObj.CTRLGDesc
					do ReligionObj.%Close()
				}
			}
			s OutputObj.PAPERLangPrimDR=PersonObj.PAPERLangPrimDR
			if $ISOBJECT(OutputObj.PAPERLangPrimDR) {
			   s OutputObj.PAPERLangPrimDR=PersonObj.PAPERLangPrimDR.%Id()	
			   s LanguageObj=##class(User.SSLanguage).%OpenId(OutputObj.PAPERLangPrimDR)
			   if $ISOBJECT(LanguageObj) {
				    s OutputObj.PAPERLangPrimCode=LanguageObj.CTLANCode
					s OutputObj.PAPERLangPrimDesc=LanguageObj.CTLANDesc
					do LanguageObj.%Close()
				}
			}
			s OutputObj.PAPERForeignAddress=PersonObj.PAPERForeignAddress
			s OutputObj.PAPERSoundex2=PersonObj.PAPERSoundex2
			s OutputObj.PAPERStName=PersonObj.PAPERStName
			s OutputObj.PAPERInsTypeDR=PersonObj.PAPERInsTypeDR
			if $ISOBJECT(OutputObj.PAPERInsTypeDR) {
			   s OutputObj.PAPERInsTypeDR=PersonObj.PAPERInsTypeDR.%Id()	
			   s InsuTypeObj=##class(User.ARCInsuranceType).%OpenId(OutputObj.PAPERInsTypeDR)
			   if $ISOBJECT(InsuTypeObj) {
				    s OutputObj.PAPERInsTypeCode=InsuTypeObj.INSTCode
					s OutputObj.PAPERInsTypeDesc=InsuTypeObj.INSTDesc
					do InsuTypeObj.%Close()
				}
			}
			s OutputObj.PAPERSoundex1=PersonObj.PAPERSoundex1
			s OutputObj.PAPERCityCodeDR=PersonObj.PAPERCityCodeDR
			if $ISOBJECT(OutputObj.PAPERCityCodeDR) {
			   s OutputObj.PAPERCityCodeDR=PersonObj.PAPERCityCodeDR.%Id()	
			   s CTCityObj=##class(User.CTCity).%OpenId(OutputObj.PAPERCityCodeDR)
			   if $ISOBJECT(CTCityObj) {
				    s OutputObj.PAPERCityCodeCode=CTCityObj.CTCITCode
					s OutputObj.PAPERCityCodeDesc=CTCityObj.CTCITDesc
					do CTCityObj.%Close()
				}
			}
			s OutputObj.PAPERStateCodeDR=PersonObj.PAPERStateCodeDR
			if $ISOBJECT(OutputObj.PAPERStateCodeDR) {
			   s OutputObj.PAPERStateCodeDR=PersonObj.PAPERStateCodeDR.%Id()	
			   s CTStateObj=##class(User.CTState).%OpenId(OutputObj.PAPERStateCodeDR)
			   if $ISOBJECT(CTStateObj) {
				    s OutputObj.PAPERStateCodeCode=CTStateObj.CTSTTCode
					s OutputObj.PAPERStateCodeDesc=CTStateObj.CTSTTDesc
					do CTStateObj.%Close()
				}
			}
			s OutputObj.PAPERZipDR=PersonObj.PAPERZipDR
			if $ISOBJECT(OutputObj.PAPERZipDR) {
			   s OutputObj.PAPERZipDR=PersonObj.PAPERZipDR.%Id()	
			   s CTZipObj=##class(User.CTZip).%OpenId(OutputObj.PAPERZipDR)
			   if $ISOBJECT(CTZipObj) {
				    s OutputObj.PAPERZipCode=CTZipObj.CTZIPCode
					s OutputObj.PAPERZipDesc=CTZipObj.CTZIPDesc
					do CTZipObj.%Close()
				}
			}
			s OutputObj.PAPERTelO=PersonObj.PAPERTelO
			s OutputObj.PAPERSocialStatusDR=PersonObj.PAPERSocialStatusDR
			if $ISOBJECT(OutputObj.PAPERSocialStatusDR) {
			   s OutputObj.PAPERSocialStatusDR=PersonObj.PAPERSocialStatusDR.%Id()	
			   s CTSocialStaObj=##class(User.CTSocialStatus).%OpenId(OutputObj.PAPERSocialStatusDR)
			   if $ISOBJECT(CTSocialStaObj) {
				    s OutputObj.PAPERSocialStatusCode=CTSocialStaObj.SSCode
					s OutputObj.PAPERSocialStatusDesc=CTSocialStaObj.SSDesc
					do CTSocialStaObj.%Close()
				}
			}
			s OutputObj.PAPERTelH=PersonObj.PAPERTelH
			s OutputObj.PAPERForeignCountry=PersonObj.PAPERForeignCountry
			s OutputObj.PAPERCountryDR=PersonObj.PAPERCountryDR
			if $ISOBJECT(OutputObj.PAPERCountryDR) {
			   s OutputObj.PAPERCountryDR=PersonObj.PAPERCountryDR.%Id()	
			   s CTCountryObj=##class(User.CTCountry).%OpenId(OutputObj.PAPERCountryDR)
			   if $ISOBJECT(CTCountryObj) {
				    s OutputObj.PAPERCountryCode=CTCountryObj.CTCOUCode
					s OutputObj.PAPERCountryDesc=CTCountryObj.CTCOUDesc
					do CTCountryObj.%Close()
				}
			}
			s OutputObj.PAPERInsCardOwner=PersonObj.PAPERInsCardOwner
			s OutputObj.PAPEROccupationDR=PersonObj.PAPEROccupationDR
			if $ISOBJECT(OutputObj.PAPEROccupationDR) {
			   s OutputObj.PAPEROccupationDR=PersonObj.PAPEROccupationDR.%Id()	
			   s CTOccupationObj=##class(User.CTOccupation).%OpenId(OutputObj.PAPEROccupationDR)
			   if $ISOBJECT(CTOccupationObj) {
				    s OutputObj.PAPEROccupationCode=CTOccupationObj.CTOCCCode
					s OutputObj.PAPEROccupationDesc=CTOccupationObj.CTOCCDesc
					do CTOccupationObj.%Close()
				}
			}
			s OutputObj.PAPERFamilyDoctorDR=PersonObj.PAPERFamilyDoctorDR
			if $ISOBJECT(OutputObj.PAPERFamilyDoctorDR) {
			   s OutputObj.PAPERFamilyDoctorDR=PersonObj.PAPERFamilyDoctorDR.%Id()	
			   s PACRefDocObj=##class(User.PACRefDoctor).%OpenId(OutputObj.PAPERFamilyDoctorDR)
			   if $ISOBJECT(PACRefDocObj) {
				    s OutputObj.PAPERFamilyDoctorCode=PACRefDocObj.REFDCode
					s OutputObj.PAPERFamilyDoctorDesc=PACRefDocObj.REFDDesc
					do PACRefDocObj.%Close()
				}
			}
			s OutputObj.PAPERRemark=PersonObj.PAPERRemark
			s OutputObj.PAPERDeceasedDate=PersonObj.PAPERDeceasedDate
			s OutputObj.PAPERForeignId=PersonObj.PAPERForeignId
			s OutputObj.PAPERCountryBirthDR=PersonObj.PAPERCountryBirthDR
			if $ISOBJECT(OutputObj.PAPERCountryBirthDR) {
			   s OutputObj.PAPERCountryBirthDR=PersonObj.PAPERCountryBirthDR.%Id()	
			   s CTCountryObj=##class(User.CTCountry).%OpenId(OutputObj.PAPERCountryBirthDR)
			   if $ISOBJECT(CTCountryObj) {
				    s OutputObj.PAPERCountryBirthCode=CTCountryObj.CTCOUCode
					s OutputObj.PAPERCountryBirthDesc=CTCountryObj.CTCOUDesc
					do CTCountryObj.%Close()
				}
			}
			s OutputObj.PAPEREstAgeYear=PersonObj.PAPEREstAgeYear
			s OutputObj.PAPEREstAgeMonth=PersonObj.PAPEREstAgeMonth
			s OutputObj.PAPEREstAgeTmStmp=PersonObj.PAPEREstAgeTmStmp
			s OutputObj.PAPERDeceasedTime=PersonObj.PAPERDeceasedTime
			s OutputObj.PAPERRegionBirthDR=PersonObj.PAPERRegionBirthDR
			if $ISOBJECT(OutputObj.PAPERRegionBirthDR) {
			   s OutputObj.PAPERRegionBirthDR=PersonObj.PAPERRegionBirthDR.%Id()	
			   s CTRegionObj=##class(User.CTRegion).%OpenId(OutputObj.PAPERRegionBirthDR)
			   if $ISOBJECT(CTRegionObj) {
				    s OutputObj.PAPERRegionBirthCode=CTRegionObj.CTRGCode
					s OutputObj.PAPERRegionBirthDesc=CTRegionObj.CTRGDesc
					do CTRegionObj.%Close()
				}
			}
			
			s OutputObj.PAPERDebtorDR=PersonObj.PAPERDebtorDR
			if $ISOBJECT(OutputObj.PAPERDebtorDR) {
			   s OutputObj.PAPERDebtorDR=PersonObj.PAPERDebtorDR.%Id()	
			   s ARCDebtorObj=##class(User.ARCDebtor).%OpenId(OutputObj.PAPERDebtorDR)
			   if $ISOBJECT(ARCDebtorObj) {
				    s OutputObj.PAPERDebtorCode=ARCDebtorObj.ARCDRCode
					s OutputObj.PAPERDebtorDesc=ARCDebtorObj.ARCDRCode
					do ARCDebtorObj.%Close()
				}
			}
			s OutputObj.PAPERInsuranceCardHolder=PersonObj.PAPERInsuranceCardHolder
			s OutputObj.PAPERProvinceBirthDR=PersonObj.PAPERProvinceBirthDR
			if $ISOBJECT(OutputObj.PAPERProvinceBirthDR) {
			   s OutputObj.PAPERProvinceBirthDR=PersonObj.PAPERProvinceBirthDR.%Id()	
			   s CTProvinceObj=##class(User.CTProvince).%OpenId(OutputObj.PAPERProvinceBirthDR)
			   if $ISOBJECT(CTProvinceObj) {
				    s OutputObj.PAPERProvinceBirthCode=CTProvinceObj.PROVCode
					s OutputObj.PAPERProvinceBirthDesc=CTProvinceObj.PROVDesc
					do CTProvinceObj.%Close()
				}
			}
			s OutputObj.PAPEREmplTypeDR=PersonObj.PAPEREmplTypeDR
			if $ISOBJECT(OutputObj.PAPEREmplTypeDR) {
			   s OutputObj.PAPEREmplTypeDR=PersonObj.PAPEREmplTypeDR.%Id()	
			   s PACEmployTypeObj=##class(User.PACEmployeeType).%OpenId(OutputObj.PAPEREmplTypeDR)
			   if $ISOBJECT(PACEmployTypeObj) {
				    s OutputObj.PAPEREmplTypeCode=PACEmployTypeObj.EPECode
					s OutputObj.PAPEREmplTypeDesc=PACEmployTypeObj.EPEDesc
					do PACEmployTypeObj.%Close()
				}
			}
			s OutputObj.PAPERJobTitle=PersonObj.PAPERJobTitle
			s OutputObj.PAPEREmplRelatedTo=PersonObj.PAPEREmplRelatedTo
			s OutputObj.PAPERCTRLTDR=PersonObj.PAPERCTRLTDR
			if $ISOBJECT(OutputObj.PAPERCTRLTDR) {
			   s OutputObj.PAPERCTRLTDR=PersonObj.PAPERCTRLTDR.%Id()	
			   s CTRelationObj=##class(User.CTRelation).%OpenId(OutputObj.PAPERCTRLTDR)
			   if $ISOBJECT(CTRelationObj) {
				    s OutputObj.PAPERCTRLTCode=CTRelationObj.CTRLTCode
					s OutputObj.PAPERCTRLTDesc=CTRelationObj.CTRLTDesc
					do CTRelationObj.%Close()
				}
			}
			s OutputObj.PAPEREmployeeNo=PersonObj.PAPEREmployeeNo
			s OutputObj.PAPEREmplDepDR=PersonObj.PAPEREmplDepDR
			if $ISOBJECT(OutputObj.PAPEREmplDepDR) {
			   s OutputObj.PAPEREmplDepDR=PersonObj.PAPEREmplDepDR.%Id()	
			   s CTLocObj=##class(User.CTLoc).%OpenId(OutputObj.PAPEREmplDepDR)
			   if $ISOBJECT(CTLocObj) {
				    s OutputObj.PAPEREmplDepCode=CTLocObj.CTLOCCode
					s OutputObj.PAPEREmplDepDesc=CTLocObj.CTLOCDesc
					do CTLocObj.%Close()
				}
			}
			s OutputObj.PAPERDiscDateFrom=PersonObj.PAPERDiscDateFrom
			s OutputObj.PAPERDiscDateTo=PersonObj.PAPERDiscDateTo
			s OutputObj.PAPERDiscTypeDR=PersonObj.PAPERDiscTypeDR
			if $ISOBJECT(OutputObj.PAPERDiscTypeDR) {
			   s OutputObj.PAPERDiscTypeDR=PersonObj.PAPERDiscTypeDR.%Id()	
			   s ARCDiscTypeObj=##class(User.ARCDiscType).%OpenId(OutputObj.PAPERDiscTypeDR)
			   if $ISOBJECT(ARCDiscTypeObj) {
				    s OutputObj.PAPERDiscTypeCode=ARCDiscTypeObj.ARCDICode
					s OutputObj.PAPERDiscTypeDesc=ARCDiscTypeObj.ARCDIDesc
					do ARCDiscTypeObj.%Close()
				}
			}
			s OutputObj.PAPEROutstandAmt=PersonObj.PAPEROutstandAmt
			s OutputObj.PAPEREmployeeFunction=PersonObj.PAPEREmployeeFunction
			if $ISOBJECT(OutputObj.PAPEREmployeeFunction) {
			   s OutputObj.PAPEREmployeeFunction=PersonObj.PAPEREmployeeFunction.%Id()	
			   s CTEmpFunObj=##class(User.CTEmpFunc).%OpenId(OutputObj.PAPEREmployeeFunction)
			   if $ISOBJECT(CTEmpFunObj) {
				    s OutputObj.PAPEREmployeeFunctionCode=CTEmpFunObj.CTEMFCode
					s OutputObj.PAPEREmployeeFunctionDesc=CTEmpFunObj.CTEMFDesc
					do CTEmpFunObj.%Close()
				}
			}
			s OutputObj.PAPEREmployeeCompany=PersonObj.PAPEREmployeeCompany
			if $ISOBJECT(OutputObj.PAPEREmployeeCompany) {
			   s OutputObj.PAPEREmployeeCompany=PersonObj.PAPEREmployeeCompany.%Id()	
			   s CTCompanyObj=##class(User.CTCompany).%OpenId(OutputObj.PAPEREmployeeCompany)
			   if $ISOBJECT(CTCompanyObj) {
				    s OutputObj.PAPEREmployeeCompanyCode=CTCompanyObj.CTCOCode
					s OutputObj.PAPEREmployeeCompanyDesc=CTCompanyObj.CTCODesc
					do CTCompanyObj.%Close()
				}
			}
			s OutputObj.PAPEREmployeeCoContract=PersonObj.PAPEREmployeeCoContract
			if $ISOBJECT(OutputObj.PAPEREmployeeCoContract) {
			   s OutputObj.PAPEREmployeeCoContract=PersonObj.PAPEREmployeeCoContract.%Id()	
			   s CTCompanyContractObj=##class(User.CTCompanyContract).%OpenId(OutputObj.PAPEREmployeeCoContract)
			   if $ISOBJECT(CTCompanyContractObj) {
				    s OutputObj.PAPEREmployeeCoContractCode=CTCompanyContractObj.CONTCode
					s OutputObj.PAPEREmployeeCoContractDesc=CTCompanyContractObj.CONTCode
					do CTCompanyContractObj.%Close()
				}
			}
			s OutputObj.PAPERGuardian1DR=PersonObj.PAPERGuardian1DR
			if $ISOBJECT(OutputObj.PAPERGuardian1DR) {
			   s OutputObj.PAPERGuardian1DR=PersonObj.PAPERGuardian1DR.%Id()
			}
			s OutputObj.PAPERGuardian2DR=PersonObj.PAPERGuardian2DR
			if $ISOBJECT(OutputObj.PAPERGuardian2DR) {
			   s OutputObj.PAPERGuardian2DR=PersonObj.PAPERGuardian2DR.%Id()
			}
			s OutputObj.PAPEROutstandingDate=PersonObj.PAPEROutstandingDate
			s OutputObj.PAPERExpectedPayDate=PersonObj.PAPERExpectedPayDate
			s OutputObj.PAPERBillCode=PersonObj.PAPERBillCode
			s OutputObj.PAPERNokName=PersonObj.PAPERNokName
			s OutputObj.PAPERNokPhone=PersonObj.PAPERNokPhone
			s OutputObj.PAPERNokText=PersonObj.PAPERNokText
			s OutputObj.PAPERNokCTRLTDR=PersonObj.PAPERNokCTRLTDR
			if $ISOBJECT(OutputObj.PAPERNokCTRLTDR) {
			   s OutputObj.PAPERNokCTRLTDR=PersonObj.PAPERNokCTRLTDR.%Id()	
			   s CTRelationObj=##class(User.CTRelation).%OpenId(OutputObj.PAPERNokCTRLTDR)
			   if $ISOBJECT(CTRelationObj) {
				    s OutputObj.PAPERNokCTRLTCode=CTRelationObj.CTRLTCode
					s OutputObj.PAPERNokCTRLTDesc=CTRelationObj.CTRLTDesc
					do CTRelationObj.%Close()
				}
			}
			s OutputObj.PAPERCTRegionDR=PersonObj.PAPERCTRegionDR
			if $ISOBJECT(OutputObj.PAPERCTRegionDR) {
			   s OutputObj.PAPERCTRegionDR=PersonObj.PAPERCTRegionDR.%Id()	
			   s CTRegionObj=##class(User.CTRegion).%OpenId(OutputObj.PAPERCTRegionDR)
			   if $ISOBJECT(CTRegionObj) {
				    s OutputObj.PAPERCTRegionCode=CTRegionObj.CTRGCode
					s OutputObj.PAPERCTRegionDesc=CTRegionObj.CTRGDesc
					do CTRegionObj.%Close()
				}
			}
			s OutputObj.PAPERCTProvinceDR=PersonObj.PAPERCTProvinceDR
			if $ISOBJECT(OutputObj.PAPERCTProvinceDR) {
			   s OutputObj.PAPERCTProvinceDR=PersonObj.PAPERCTProvinceDR.%Id()	
			   s CTProvinceObj=##class(User.CTProvince).%OpenId(OutputObj.PAPERCTProvinceDR)
			   if $ISOBJECT(CTProvinceObj) {
				    s OutputObj.PAPERCTProvinceCode=CTProvinceObj.PROVCode
					s OutputObj.PAPERCTProvinceDesc=CTProvinceObj.PROVDesc
					do CTProvinceObj.%Close()
				}
			}
			s OutputObj.PAPERCTHCADR=PersonObj.PAPERCTHCADR
			if $ISOBJECT(OutputObj.PAPERCTHCADR) {
			   s OutputObj.PAPERCTHCADR=PersonObj.PAPERCTHCADR.%Id()	
			   s CTHealthCareAreaObj=##class(User.CTHealthCareArea).%OpenId(OutputObj.PAPERCTHCADR)
			   if $ISOBJECT(CTHealthCareAreaObj) {
				    s OutputObj.PAPERCTHCACode=CTHealthCareAreaObj.HCACode
					s OutputObj.PAPERCTHCADesc=CTHealthCareAreaObj.HCADesc
					do CTHealthCareAreaObj.%Close()
				}
			}
			s OutputObj.PAPERCityBirthDR=PersonObj.PAPERCityBirthDR
			if $ISOBJECT(OutputObj.PAPERCityBirthDR) {
			   s OutputObj.PAPERCityBirthDR=PersonObj.PAPERCityBirthDR.%Id()	
			   s CTCityObj=##class(User.CTCity).%OpenId(OutputObj.PAPERCityBirthDR)
			   if $ISOBJECT(CTCityObj) {
				    s OutputObj.PAPERCityBirthCode=CTCityObj.CTCITCode
					s OutputObj.PAPERCityBirthDesc=CTCityObj.CTCITDesc
					do CTCityObj.%Close()
				}
			}
			s OutputObj.PAPERName3=PersonObj.PAPERName3
			s OutputObj.PAPERGovernCardNo=PersonObj.PAPERGovernCardNo
			s OutputObj.PAPERFromThisArea=PersonObj.PAPERFromThisArea
			s OutputObj.PAPERForeignNotes=PersonObj.PAPERForeignNotes
			s OutputObj.PAPERReasonForChangeData=PersonObj.PAPERReasonForChangeData
			s OutputObj.PAPERUserUpdate=PersonObj.PAPERUserUpdate
			if $ISOBJECT(OutputObj.PAPERUserUpdate) {
			   s OutputObj.PAPERUserUpdate=PersonObj.PAPERUserUpdate.%Id()	
			   s SSUserObj=##class(User.SSUser).%OpenId(OutputObj.PAPERUserUpdate)
			   if $ISOBJECT(SSUserObj) {
				    s OutputObj.PAPERUserUpdateCode=SSUserObj.SSUSRInitials
					s OutputObj.PAPERUserUpdateDesc=SSUserObj.SSUSRName
					do SSUserObj.%Close()
				}
			}
			s OutputObj.PAPERExemptionNumber=PersonObj.PAPERExemptionNumber
			s OutputObj.PAPERCityAreaDR=PersonObj.PAPERCityAreaDR
			if $ISOBJECT(OutputObj.PAPERCityAreaDR) {
			   s OutputObj.PAPERCityAreaDR=PersonObj.PAPERCityAreaDR.%Id()	
			   s CTCityAreaObj=##class(User.CTCityArea).%OpenId(OutputObj.PAPERCityAreaDR)
			   if $ISOBJECT(CTCityAreaObj) {
				    s OutputObj.PAPERCityAreaCode=CTCityAreaObj.CITAREACode
					s OutputObj.PAPERCityAreaDesc=CTCityAreaObj.CITAREADesc
					do CTCityAreaObj.%Close()
				}
			}
			s OutputObj.PAPERComplement=PersonObj.PAPERComplement
			s OutputObj.PAPERMotherDR=PersonObj.PAPERMotherDR
			if $ISOBJECT(OutputObj.PAPERMotherDR) {
			   s OutputObj.PAPERMotherDR=PersonObj.PAPERMotherDR.%Id()	
			}
			s OutputObj.PAPERFatherDR=PersonObj.PAPERFatherDR
			if $ISOBJECT(OutputObj.PAPERFatherDR) {
			   s OutputObj.PAPERFatherDR=PersonObj.PAPERFatherDR.%Id()	
			}
			s OutputObj.PAPERFamilyGroupDR=PersonObj.PAPERFamilyGroupDR
			if $ISOBJECT(OutputObj.PAPERFamilyGroupDR) {
			   s OutputObj.PAPERFamilyGroupDR=PersonObj.PAPERFamilyGroupDR.%Id()	
			   s PACFamilyGroupObj=##class(User.PACFamilyGroup).%OpenId(OutputObj.PAPERFamilyGroupDR)
			   if $ISOBJECT(PACFamilyGroupObj) {
				    s OutputObj.PAPERFamilyGroupCode=PACFamilyGroupObj.FAMCode
					s OutputObj.PAPERFamilyGroupDesc=PACFamilyGroupObj.FAMDesc
					do PACFamilyGroupObj.%Close()
				}
			}
			s OutputObj.PAPERDiscretOutsTypeDR=PersonObj.PAPERDiscretOutsTypeDR
			if $ISOBJECT(OutputObj.PAPERDiscretOutsTypeDR) {
			   s OutputObj.PAPERDiscretOutsTypeDR=PersonObj.PAPERDiscretOutsTypeDR.%Id()	
			   s ARCDisretOutstTypeObj=##class(User.ARCDisretOutstType).%OpenId(OutputObj.PAPERDiscretOutsTypeDR)
			   if $ISOBJECT(ARCDisretOutstTypeObj) {
				    s OutputObj.PAPERDiscretOutsTypeCode=ARCDisretOutstTypeObj.DOUTSCode
					s OutputObj.PAPERDiscretOutsTypeDesc=ARCDisretOutstTypeObj.DOUTSDesc
					do ARCDisretOutstTypeObj.%Close()
				}
			}
			s OutputObj.PAPERHCPDR=PersonObj.PAPERHCPDR
			if $ISOBJECT(OutputObj.PAPERHCPDR) {
			   s OutputObj.PAPERHCPDR=PersonObj.PAPERHCPDR.%Id()	
			   s CTHealthCareProviderObj=##class(User.CTHealthCareProvider).%OpenId(OutputObj.PAPERHCPDR)
			   if $ISOBJECT(CTHealthCareProviderObj) {
				    s OutputObj.PAPERHCPCode=CTHealthCareProviderObj.HCPCode
					s OutputObj.PAPERHCPDesc=CTHealthCareProviderObj.HCPDesc
					do CTHealthCareProviderObj.%Close()
				}
			}
			s OutputObj.PAPERSecondPhone=PersonObj.PAPERSecondPhone
			s OutputObj.PAPERNokAddress1=PersonObj.PAPERNokAddress1
			s OutputObj.PAPERNokCityDR=PersonObj.PAPERNokCityDR
			if $ISOBJECT(OutputObj.PAPERNokCityDR) {
			   s OutputObj.PAPERNokCityDR=PersonObj.PAPERNokCityDR.%Id()	
			   s CTCityObj=##class(User.CTCity).%OpenId(OutputObj.PAPERNokCityDR)
			   if $ISOBJECT(CTCityObj) {
				    s OutputObj.PAPERNokCityCode=CTCityObj.CTCITCode
					s OutputObj.PAPERNokCityDesc=CTCityObj.CTCITDesc
					do CTCityObj.%Close()
				}
			}
			s OutputObj.PAPERNokZipDR=PersonObj.PAPERNokZipDR
			if $ISOBJECT(OutputObj.PAPERNokZipDR) {
			   s OutputObj.PAPERNokZipDR=PersonObj.PAPERNokZipDR.%Id()	
			   s CTZipObj=##class(User.CTZip).%OpenId(OutputObj.PAPERNokZipDR)
			   if $ISOBJECT(CTZipObj) {
				    s OutputObj.PAPERNokZipCode=CTZipObj.CTZIPCode
					s OutputObj.PAPERNokZipDesc=CTZipObj.CTZIPCityDesc
					do CTZipObj.%Close()
				}
			}
			s OutputObj.PAPERNokAddress2=PersonObj.PAPERNokAddress2
			s OutputObj.PAPEREmail=PersonObj.PAPEREmail
			s OutputObj.PAPERTitleDR=PersonObj.PAPERTitleDR
			if $ISOBJECT(OutputObj.PAPERTitleDR) {
			   s OutputObj.PAPERTitleDR=PersonObj.PAPERTitleDR.%Id()	
			   s CTTitleObj=##class(User.CTTitle).%OpenId(OutputObj.PAPERTitleDR)
			   if $ISOBJECT(CTTitleObj) {
				    s OutputObj.PAPERTitleCode=CTTitleObj.TTLCode
					s OutputObj.PAPERTitleDesc=CTTitleObj.TTLDesc
					do CTTitleObj.%Close()
				}
			}
			s OutputObj.PAPERMobPhone=PersonObj.PAPERMobPhone
			s OutputObj.PAPERIndigStatDR=PersonObj.PAPERIndigStatDR
			if $ISOBJECT(OutputObj.PAPERIndigStatDR) {
			   s OutputObj.PAPERIndigStatDR=PersonObj.PAPERIndigStatDR.%Id()	
			   s PACIndigStatusObj=##class(User.PACIndigStatus).%OpenId(OutputObj.PAPERIndigStatDR)
			   if $ISOBJECT(PACIndigStatusObj) {
				    s OutputObj.PAPERIndigStatCode=PACIndigStatusObj.INDSTCode
					s OutputObj.PAPERIndigStatDesc=PACIndigStatusObj.INDSTDesc
					do PACIndigStatusObj.%Close()
				}
			}
			s OutputObj.PAPERAuxInsTypeDR=PersonObj.PAPERAuxInsTypeDR
			if $ISOBJECT(OutputObj.PAPERAuxInsTypeDR) {
			   s OutputObj.PAPERAuxInsTypeDR=PersonObj.PAPERAuxInsTypeDR.%Id()	
			   s ARCAuTypeObj=##class(User.ARCAuxilInsurType).%OpenId(OutputObj.PAPERAuxInsTypeDR)
			   if $ISOBJECT(ARCAuTypeObj) {
				    s OutputObj.PAPERAuxInsTypeCode=ARCAuTypeObj.AUXITCode
					s OutputObj.PAPERAuxInsTypeDesc=ARCAuTypeObj.AUXITDesc
					do ARCAuTypeObj.%Close()
				}
			}
			s OutputObj.PAPERPrefLanguageDR=PersonObj.PAPERPrefLanguageDR
			if $ISOBJECT(OutputObj.PAPERPrefLanguageDR) {
			   s OutputObj.PAPERPrefLanguageDR=PersonObj.PAPERPrefLanguageDR.%Id()	
			   s PACLanguObj=##class(User.PACPreferredLanguage).%OpenId(OutputObj.PAPERPrefLanguageDR)
			   if $ISOBJECT(PACLanguObj) {
				    s OutputObj.PAPERPrefLanguageCode=PACLanguObj.PREFLCode
					s OutputObj.PAPERPrefLanguageDesc=PACLanguObj.PREFLDesc
					do PACLanguObj.%Close()
				}
			}
			s OutputObj.PAPERPatTypeDR=PersonObj.PAPERPatTypeDR
			if $ISOBJECT(OutputObj.PAPERPatTypeDR) {
			   s OutputObj.PAPERPatTypeDR=PersonObj.PAPERPatTypeDR.%Id()	
			   s PACPatTypeObj=##class(User.PACPatientType).%OpenId(OutputObj.PAPERPatTypeDR)
			   if $ISOBJECT(PACPatTypeObj) {
				    s OutputObj.PAPERPatTypeCode=PACPatTypeObj.PTYPECode
					s OutputObj.PAPERPatTypeDesc=PACPatTypeObj.PTYPEDesc
					do PACPatTypeObj.%Close()
				}
			}
			s OutputObj.PAPERUpdateDate=PersonObj.PAPERUpdateDate
			s OutputObj.PAPERUpdateTime=PersonObj.PAPERUpdateTime
			s OutputObj.PAPERGLFlag=PersonObj.PAPERGLFlag
			s OutputObj.PAPERFamilyDoctorClinicDR=PersonObj.PAPERFamilyDoctorClinicDR
			if $ISOBJECT(OutputObj.PAPERFamilyDoctorClinicDR) {
			   s OutputObj.PAPERFamilyDoctorClinicDR=PersonObj.PAPERFamilyDoctorClinicDR.%Id()	
			   s PACRefDocCObj=##class(User.PACRefDoctorClinic).%OpenId(OutputObj.PAPERFamilyDoctorClinicDR)
			   if $ISOBJECT(PACRefDocCObj) {
				    s OutputObj.PAPERFamilyDoctorClinicCode=PACRefDocCObj.CLNCode
					s OutputObj.PAPERFamilyDoctorClinicDesc=PACRefDocCObj.CLNCode
					do PACRefDocCObj.%Close()
				}
			}
			s OutputObj.PAPERDonatedOrgansOnDeath=PersonObj.PAPERDonatedOrgansOnDeath
			s OutputObj.PAPERWhoNotified=PersonObj.PAPERWhoNotified
			s OutputObj.PAPERLocationOfDeath=PersonObj.PAPERLocationOfDeath
			s OutputObj.PAPEREstDOB=PersonObj.PAPEREstDOB
			s OutputObj.PAPERStayingPermanently=PersonObj.PAPERStayingPermanently
			s OutputObj.PAPERDateOfEntry=PersonObj.PAPERDateOfEntry
			s OutputObj.PAPERCountryCameFromDR=PersonObj.PAPERCountryCameFromDR
			if $ISOBJECT(OutputObj.PAPERCountryCameFromDR) {
			   s OutputObj.PAPERCountryCameFromDR=PersonObj.PAPERCountryCameFromDR.%Id()	
			   s CTCountryObj=##class(User.CTCountry).%OpenId(OutputObj.PAPERCountryCameFromDR)
			   if $ISOBJECT(CTCountryObj) {
				    s OutputObj.PAPERCountryCameFromCode=CTCountryObj.CTCOUCode
					s OutputObj.PAPERCountryCameFromDesc=CTCountryObj.CTCOUDesc
					do CTCountryObj.%Close()
				}
			}
			s OutputObj.PAPERNationalResident=PersonObj.PAPERNationalResident
			s OutputObj.PAPEROSVStatusDR=PersonObj.PAPEROSVStatusDR
			if $ISOBJECT(OutputObj.PAPEROSVStatusDR) {
			   s OutputObj.PAPEROSVStatusDR=PersonObj.PAPEROSVStatusDR.%Id()	
			   s PACOSVStaObj=##class(User.PACOSVisitorStatus).%OpenId(OutputObj.PAPEROSVStatusDR)
			   if $ISOBJECT(PACOSVStaObj) {
				    s OutputObj.PAPEROSVStatusCode=PACOSVStaObj.OVSCode
					s OutputObj.PAPEROSVStatusDesc=PACOSVStaObj.OVSDesc
					do PACOSVStaObj.%Close()
				}
			}
			s OutputObj.PAPERInterviewedBy=PersonObj.PAPERInterviewedBy
			s OutputObj.PAPERDateOfInterview=PersonObj.PAPERDateOfInterview
			s OutputObj.PAPERDateAdded=PersonObj.PAPERDateAdded
			s OutputObj.PAPERUserAddedDR=PersonObj.PAPERUserAddedDR
			if $ISOBJECT(OutputObj.PAPERUserAddedDR) {
			   s OutputObj.PAPERUserAddedDR=PersonObj.PAPERUserAddedDR.%Id()	
			   s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAPERUserAddedDR)
			   if $ISOBJECT(UserObj) {
				    s OutputObj.PAPERUserAddedCode=UserObj.SSUSRInitials
					s OutputObj.PAPERUserAddedDesc=UserObj.SSUSRName
					do UserObj.%Close()
				}
			}
			s OutputObj.PAPERPAPMIDR=PersonObj.PAPERPAPMIDR
			if $ISOBJECT(OutputObj.PAPERPAPMIDR) {
			   s OutputObj.PAPERPAPMIDR=PersonObj.PAPERPAPMIDR.%Id()
			}
			s OutputObj.PAPERNOKBusPhone=PersonObj.PAPERNOKBusPhone
			s OutputObj.PAPERLastUpdateHospitalDR=PersonObj.PAPERLastUpdateHospitalDR
			if $ISOBJECT(OutputObj.PAPERLastUpdateHospitalDR) {
			   s OutputObj.PAPERLastUpdateHospitalDR=PersonObj.PAPERLastUpdateHospitalDR.%Id()	
			   s CTHospitalObj=##class(User.CTHospital).%OpenId(OutputObj.PAPERLastUpdateHospitalDR)
			   if $ISOBJECT(CTHospitalObj) {
				    s OutputObj.PAPERLastUpdateHospitalCode=CTHospitalObj.HOSPCode
					s OutputObj.PAPERLastUpdateHospitalDesc=CTHospitalObj.HOSPDesc
					do CTHospitalObj.%Close()
				}
			}
			s OutputObj.PAPERDoctorDeclaredDR=PersonObj.PAPERDoctorDeclaredDR
			if $ISOBJECT(OutputObj.PAPERDoctorDeclaredDR) {
			   s OutputObj.PAPERDoctorDeclaredDR=PersonObj.PAPERDoctorDeclaredDR.%Id()	
			   s DocObj=##class(User.CTCareProv).%OpenId(OutputObj.PAPERDoctorDeclaredDR)
			   if $ISOBJECT(DocObj) {
				    s OutputObj.PAPERDoctorDeclaredCode=DocObj.CTPCPCode
					s OutputObj.PAPERDoctorDeclaredDesc=DocObj.CTPCPDesc
					do DocObj.%Close()
				}
			}
			s OutputObj.PAPERNOKInformed=PersonObj.PAPERNOKInformed
			s OutputObj.PAPERProcuratorFiscalInformed=PersonObj.PAPERProcuratorFiscalInformed
			s OutputObj.PAPERInterpreterRequired=PersonObj.PAPERInterpreterRequired
			s OutputObj.PAPERPrevHACCEligible=PersonObj.PAPERPrevHACCEligible
			s OutputObj.PAPERUsualRoundDR=PersonObj.PAPERUsualRoundDR
			if $ISOBJECT(OutputObj.PAPERUsualRoundDR) {
			   s OutputObj.PAPERUsualRoundDR=PersonObj.PAPERUsualRoundDR.%Id()	
			   s ResourceObj=##class(User.RBResource).%OpenId(OutputObj.PAPERUsualRoundDR)
			   if $ISOBJECT(ResourceObj) {
				    s OutputObj.PAPERUsualRoundCode=ResourceObj.RESCode
					s OutputObj.PAPERUsualRoundDesc=ResourceObj.RESDesc
					do ResourceObj.%Close()
				}
			}
			s OutputObj.PAPEREmploymentStatDR=PersonObj.PAPEREmploymentStatDR
			if $ISOBJECT(OutputObj.PAPEREmploymentStatDR) {
			   s OutputObj.PAPEREmploymentStatDR=PersonObj.PAPEREmploymentStatDR.%Id()	
			   s PACEmStaObj=##class(User.PACEmploymentStatus).%OpenId(OutputObj.PAPEREmploymentStatDR)
			   if $ISOBJECT(PACEmStaObj) {
				    s OutputObj.PAPEREmploymentStatCode=PACEmStaObj.EMPLSTCode
					s OutputObj.PAPEREmploymentStatDesc=PACEmStaObj.EMPLSTDesc
					do PACEmStaObj.%Close()
				}
			}
			s OutputObj.PAPERSourceOfIncomeDR=PersonObj.PAPERSourceOfIncomeDR
			if $ISOBJECT(OutputObj.PAPERSourceOfIncomeDR) {
			   s OutputObj.PAPERSourceOfIncomeDR=PersonObj.PAPERSourceOfIncomeDR.%Id()	
			   s PACSouOfInCObj=##class(User.PACSourceOfIncome).%OpenId(OutputObj.PAPERSourceOfIncomeDR)
			   if $ISOBJECT(PACSouOfInCObj) {
				    s OutputObj.PAPERSourceOfIncomeCode=PACSouOfInCObj.SRCINCCode
					s OutputObj.PAPERSourceOfIncomeDesc=PACSouOfInCObj.SRCINCDesc
					do PACSouOfInCObj.%Close()
				}
			}
			s OutputObj.PAPERLivingArrangementDR=PersonObj.PAPERLivingArrangementDR
			if $ISOBJECT(OutputObj.PAPERLivingArrangementDR) {
			   s OutputObj.PAPERLivingArrangementDR=PersonObj.PAPERLivingArrangementDR.%Id()	
			   s PACLArrObj=##class(User.PACLivingArrangement).%OpenId(OutputObj.PAPERLivingArrangementDR)
			   if $ISOBJECT(PACLArrObj) {
				    s OutputObj.PAPERLivingArrangementCode=PACLArrObj.LIVARRCode
					s OutputObj.PAPERLivingArrangementDesc=PACLArrObj.LIVARRDesc
					do PACLArrObj.%Close()
				}
			}
			s OutputObj.PAPERResidenceStatusDR=PersonObj.PAPERResidenceStatusDR
			if $ISOBJECT(OutputObj.PAPERResidenceStatusDR) {
			   s OutputObj.PAPERResidenceStatusDR=PersonObj.PAPERResidenceStatusDR.%Id()	
			   s PACRStaObj=##class(User.PACResidenceStatus).%OpenId(OutputObj.PAPERResidenceStatusDR)
			   if $ISOBJECT(PACRStaObj) {
				    s OutputObj.PAPERResidenceStatusCode=PACRStaObj.RESIDCode
					s OutputObj.PAPERResidenceStatusDesc=PACRStaObj.RESIDDesc
					do PACRStaObj.%Close()
				}
			}
			s OutputObj.PAPERTransportUsedDR=PersonObj.PAPERTransportUsedDR
			if $ISOBJECT(OutputObj.PAPERTransportUsedDR) {
			   s OutputObj.PAPERTransportUsedDR=PersonObj.PAPERTransportUsedDR.%Id()	
			   s UserObj=##class(User.SSUser).%OpenId(OutputObj.PAPERTransportUsedDR)
			   if $ISOBJECT(UserObj) {
				    s OutputObj.PAPERTransportUsedCode=UserObj.SSUSRInitials
					s OutputObj.PAPERTransportUsedDesc=UserObj.SSUSRName
					do UserObj.%Close()
				}
			}
			s OutputObj.PAPERCancerReg=PersonObj.PAPERCancerReg
			s OutputObj.PAPERBloodTypeDR=PersonObj.PAPERBloodTypeDR
			if $ISOBJECT(OutputObj.PAPERBloodTypeDR) {
			   s OutputObj.PAPERBloodTypeDR=PersonObj.PAPERBloodTypeDR.%Id()	
			   s PACBloodTypeObj=##class(User.PACBloodType).%OpenId(OutputObj.PAPERBloodTypeDR)
			   if $ISOBJECT(PACBloodTypeObj) {
				    s OutputObj.PAPERBloodTypeCode=PACBloodTypeObj.BLDTCode
					s OutputObj.PAPERBloodTypeDesc=PACBloodTypeObj.BLDTDesc
					do PACBloodTypeObj.%Close()
				}
			}
			s OutputObj.PAPEREffDateCurrAddress=PersonObj.PAPEREffDateCurrAddress
			s OutputObj.PAPERFeedBackConsent=PersonObj.PAPERFeedBackConsent
			s OutputObj.PAPERAusSouthSeaIslanderDR=PersonObj.PAPERAusSouthSeaIslanderDR
			if $ISOBJECT(OutputObj.PAPERAusSouthSeaIslanderDR) {
			   s OutputObj.PAPERAusSouthSeaIslanderDR=PersonObj.PAPERAusSouthSeaIslanderDR.%Id()	
			   s PACASSLanObj=##class(User.PACAusSouthSeaIslander).%OpenId(OutputObj.PAPERAusSouthSeaIslanderDR)
			   if $ISOBJECT(PACASSLanObj) {
				    s OutputObj.PAPERAusSouthSeaIslanderCode=PACASSLanObj.ASSISCode
					s OutputObj.PAPERAusSouthSeaIslanderDesc=PACASSLanObj.ASSISDesc
					do PACASSLanObj.%Close()
				}
			}
			s OutputObj.PAPEROccupation=PersonObj.PAPEROccupation
			s OutputObj.PAPERIncompleteRegistration=PersonObj.PAPERIncompleteRegistration
			s OutputObj.PAPERFamilyLinkText=PersonObj.PAPERFamilyLinkText
			s OutputObj.PAPERDVAExpiryDate=PersonObj.PAPERDVAExpiryDate
			s OutputObj.PAPERPensionCardExpiryDate=PersonObj.PAPERPensionCardExpiryDate
			s OutputObj.PAPERReversedBy=PersonObj.PAPERReversedBy
     		s OutputObj.PAPERHospitalDR=PersonObj.PAPERHospitalDR
			if $ISOBJECT(OutputObj.PAPERHospitalDR) {
			   s OutputObj.PAPERHospitalDR=PersonObj.PAPERHospitalDR.%Id()	
			   s HospObj=##class(User.CTHospital).%OpenId(OutputObj.PAPERHospitalDR)
			   if $ISOBJECT(HospObj) {
				    s OutputObj.PAPERHospitalCode=HospObj.HOSPCode
					s OutputObj.PAPERHospitalDesc=HospObj.HOSPDesc
					do HospObj.%Close()
				}
			}	
			s OutputObj.PAPERName4=PersonObj.PAPERName4
			s OutputObj.PAPERName5=PersonObj.PAPERName5
			s OutputObj.PAPERName6=PersonObj.PAPERName6
     		s OutputObj.PAPERName7=PersonObj.PAPERName7
			s OutputObj.PAPERName8=PersonObj.PAPERName8
			s OutputObj.PAPERDentalDisplay=PersonObj.PAPERDentalDisplay
			s OutputObj.PAPERFeedbackConsentDate=PersonObj.PAPERFeedbackConsentDate
     		s OutputObj.PAPERAddress2=PersonObj.PAPERAddress2
			s OutputObj.PAPERPassportNumber=PersonObj.PAPERPassportNumber
			s OutputObj.PAPERDependChildrenDR=PersonObj.PAPERDependChildrenDR
			if $ISOBJECT(OutputObj.PAPERDependChildrenDR) {
			   s OutputObj.PAPERDependChildrenDR=PersonObj.PAPERDependChildrenDR.%Id()	
			   s PACDepObj=##class(User.PACDependentChildren).%OpenId(OutputObj.PAPERDependChildrenDR)
			   if $ISOBJECT(PACDepObj) {
				    s OutputObj.PAPERDependChildrenCode=PACDepObj.DEPCHLCode
					s OutputObj.PAPERDependChildrenDesc=PACDepObj.DEPCHLDesc
					do PACDepObj.%Close()
				}
			}
			s OutputObj.PAPERPreferredContactMethod=PersonObj.PAPERPreferredContactMethod
			s OutputObj.PAPERContactNotes=PersonObj.PAPERContactNotes
			s OutputObj.PAPERAccomSettingDR=PersonObj.PAPERAccomSettingDR
			if $ISOBJECT(OutputObj.PAPERAccomSettingDR) {
			   s OutputObj.PAPERAccomSettingDR=PersonObj.PAPERAccomSettingDR.%Id()	
			   s PACAccSetObj=##class(User.PACAccomSetting).%OpenId(OutputObj.PAPERAccomSettingDR)
			   if $ISOBJECT(PACAccSetObj) {
				    s OutputObj.PAPERAccomSettingCode=PACAccSetObj.ACCOMSCode
					s OutputObj.PAPERAccomSettingDesc=PACAccSetObj.ACCOMSDesc
					do PACAccSetObj.%Close()
				}
			}
			s OutputObj.PAPERPhoto=PersonObj.PAPERPhoto
			s OutputObj.PAPERPDSSerialNumber=PersonObj.PAPERPDSSerialNumber
			s OutputObj.PAPEREmployeeDateFrom=PersonObj.PAPEREmployeeDateFrom
			s OutputObj.PAPEREmployeeDateTo=PersonObj.PAPEREmployeeDateTo
			s OutputObj.PAPEREmployeeGrade=PersonObj.PAPEREmployeeGrade
			s OutputObj.PAPERHouseBuildingNo=PersonObj.PAPERHouseBuildingNo
			s OutputObj.PAPERAppartmentNo=PersonObj.PAPERAppartmentNo
			s OutputObj.PAPERGravida=PersonObj.PAPERGravida
			s OutputObj.PAPERPara=PersonObj.PAPERPara
			s OutputObj.PAPERMiscarriage=PersonObj.PAPERMiscarriage
			s OutputObj.PAPERTOP=PersonObj.PAPERTOP
			s OutputObj.PAPERPreTerm=PersonObj.PAPERPreTerm
			s OutputObj.PAPERMultBirth=PersonObj.PAPERMultBirth
			s OutputObj.PAPERLivingChild=PersonObj.PAPERLivingChild
			s OutputObj.PAPERSpecNeedStatDR=PersonObj.PAPERSpecNeedStatDR
			if $ISOBJECT(OutputObj.PAPERSpecNeedStatDR) {
			   s OutputObj.PAPERSpecNeedStatDR=PersonObj.PAPERSpecNeedStatDR.%Id()	
			   s PACSNeedStaObj=##class(User.PACSpecialNeedsStatus).%OpenId(OutputObj.PAPERSpecNeedStatDR)
			   if $ISOBJECT(PACSNeedStaObj) {
				    s OutputObj.PAPERSpecNeedStatCode=PACSNeedStaObj.SNSCode
					s OutputObj.PAPERSpecNeedStatDesc=PACSNeedStaObj.SNSDesc
					do PACSNeedStaObj.%Close()
				}
			}
			s OutputObj.PAPERSNSLastReviewDate=PersonObj.PAPERSNSLastReviewDate
			s OutputObj.PAPERSNSNextReviewDate=PersonObj.PAPERSNSNextReviewDate
			s OutputObj.PAPERSNSLastLiveUpdDate=PersonObj.PAPERSNSLastLiveUpdDate
			s OutputObj.PAPERPostCode=PersonObj.PAPERPostCode
			s OutputObj.PAPERIDDocTypeDR=PersonObj.PAPERIDDocTypeDR
			if $ISOBJECT(OutputObj.PAPERIDDocTypeDR) {
			   s OutputObj.PAPERIDDocTypeDR=PersonObj.PAPERIDDocTypeDR.%Id()	
			   s PACIDDocTypeObj=##class(User.PACIDDocType).%OpenId(OutputObj.PAPERIDDocTypeDR)
			   if $ISOBJECT(PACIDDocTypeObj) {
				    s OutputObj.PAPERIDDocTypeCode=PACIDDocTypeObj.IDDTCode
					s OutputObj.PAPERIDDocTypeDesc=PACIDDocTypeObj.IDDTDesc
					do PACIDDocTypeObj.%Close()
				}
			}
			s OutputObj.PAPERDocNumber=PersonObj.PAPERDocNumber
			s OutputObj.PAPERChineseName=PersonObj.PAPERChineseName
			s OutputObj.PAPERNoChinName=PersonObj.PAPERNoChinName
			s OutputObj.PAPERCCC1=PersonObj.PAPERCCC1
			s OutputObj.PAPERCCC2=PersonObj.PAPERCCC2
			s OutputObj.PAPERCCC3=PersonObj.PAPERCCC3
			s OutputObj.PAPERCCC4=PersonObj.PAPERCCC4
			s OutputObj.PAPERCCC5=PersonObj.PAPERCCC5
			s OutputObj.PAPERCCC6=PersonObj.PAPERCCC6
			s OutputObj.PAPERChineseAddress=PersonObj.PAPERChineseAddress
			s OutputObj.PAPERChineseDistrict=PersonObj.PAPERChineseDistrict
			s OutputObj.PAPERChineseArea=PersonObj.PAPERChineseArea
			s OutputObj.PAPERPager=PersonObj.PAPERPager
			s OutputObj.PAPERFax=PersonObj.PAPERFax
			s OutputObj.PAPERPhotoDocument=PersonObj.PAPERPhotoDocument
			s OutputObj.PAPEREmail2=PersonObj.PAPEREmail2
			do PersonObj.%Close()
			do PatMasObj.%Close()
	    }
	}
	Q OutputObj
}

}
