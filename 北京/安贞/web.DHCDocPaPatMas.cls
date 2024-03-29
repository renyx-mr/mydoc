Class web.DHCDocPaPatMas Extends (%RegisteredObject, %XML.Adaptor)
{
/// call web_DHCENS_BLL_QCInterface.Dataexchangeorg_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryAdmRegInfo_TM_OUT_REG("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryAdmRegInfo","2019-01-02","2020-01-01")
Query QueryPaPatMasInfo() As %Query(ROWSPEC = "EID,EMPI_TYPE_CODE,EMPI_TYPE_NAME,PATIENT_IDENTIFIER,EMPI_LINK_TYPE_CODE,EMPI_LINK_TYPE_NAME,EMPI_LINK_SOURCE_CODE,EMPI_LINK_SOURCE_NAME,CARD_NO,PERSON_NAME,ALIAS_NAME,SEX_CODE,SEX_NAME,DATE_OF_BIRTH,IDENTITY_CODE,IDENTITY_NAME,CHARGE_TYPE_CODE,CHARGE_TYPE_NAME,INSURANCE_TYPE_CODE,INSURANCE_TYPE_NAME,BIRTH_PLACE,MULTI_BIRTH_IND,MULTI_BIRTH_ORDER,DEATH_IND,DEATH_TIME,MARITAL_STATUS_CODE,MARITAL_STATUS_NAME,ORGAN_DONOR_IND,DISABILITY_CODE,NATION_CODE,NATION_NAME,NATIONALITY_CODE,NATIONALITY_NAME,RELIGION_CODE,RELIGION_NAME,NATIVE_PROVINCE_CODE,NATIVE_PROVINCE_NAME,LANGUAGE_CODE,LANGUAGE_NAME,DEGREE_LEVEL_CODE,DEGREE_LEVEL_NAME,EDUCATION_LEVEL_CODE,EDUCATION_LEVEL_NAME,POLITICS_STATUS_CODE,POLITICS_STATUS_NAME,FINANCIAL_SITUATION,OCCUPATION_CODE,OCCUPATION_NAME,WORK_TIME,ID_CARD_TYPE_CODE,ID_CARD_TYPE_NAME,ID_CARD_NO,SSN,INSURANCE_NO,BUSINESS_PHONE_PHONE,HOME_PHONE,OTHER_PHONE,MOBILE,POSTCODE,MAILING_ADDR_PROVINCE_CODE,MAILING_ADDR_PROVINCE_NAME,MAILING_ADDR_CITY_CODE,MAILING_ADDR_CITY_NAME,MAILING_ADDR_COUNTY_CODE,MAILING_ADDR_COUNTY_NAME,MAILING_ADDR_STREET_CODE,MAILING_ADDR_STREET_NAME,MAILING_ADDRESS,FAMILY_ADDR_PROVINCE_CODE,FAMILY_ADDR_PROVINCE_NAME,FAMILY_ADDR_CITY_CODE,FAMILY_ADDR_CITY_NAME,FAMILY_ADDR_COUNTY_CODE,FAMILY_ADDR_COUNTY_NAME,EMPLOYER_COMPANY,EMPLOYER_POSTCODE,EMPLOYER_ADDRESS,NEXT_OF_KIN,RELATIONSHIP_CODE,RELATIONSHIP_NAME,NEXT_OF_KIN_PHONE,NEXT_OF_KIN_POST,NEXT_OF_KIN_ADDR,BLOOD_TYPE_CODE,BLOOD_TYPE_NAME,RH_BLOOD_CODE,RH_BLOOD_NAME,CONFIDENT_LEVEL_CODE,CONFIDENT_LEVEL_NAME,VIP_IND,REGISTRATION_TIME") [ SqlProc, SqlViewName = HDR_PAT_MASTER_INDEX ]
{
}
ClassMethod QueryPaPatMasInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPaPatMasInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.RongWeiZhongBang.QueryCommon","QueryPaPatMasInfoExecute")
ClassMethod QueryPaPatMasInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s PatId=0
    for {
        s PatId=$O(^PAPER(PatId))
        q:PatId=""
		s Active=$p($g(^PAPER(PatId,"PAT",1)),"^",6)
		q:Active="N"
		; EID	EMPI全局标识	ST	是	
		s EID=""		
		; EMPI_TYPE_CODE	EMPI患者标识类型编码	CD	是
		s EMPITYPECODE=""		
		; EMPI_TYPE_NAME	EMPI患者标识类型描述	CD	是
		s EMPITYPENAME=""
		; PATIENT_IDENTIFIER	患者标识	ST	是	
		s PATIENTIDENTIFIER	=PatId
		; EMPI_LINK_TYPE_CODE	患者标识关联类型编码	CD				关联的类型、手动、自动等
		s EMPILINKTYPECODE=""
		; EMPI_LINK_TYPE_NAME	患者标识关联类型描述	CD				关联的类型、手动、自动等
		s EMPILINKTYPENAME=""
		; EMPI_LINK_SOURCE_CODE	患者标识关联来源编码	CD				ADT、挂号、建卡等手动关联的来源
		s EMPILINKSOURCECODE=""
		; EMPI_LINK_SOURCE_NAME	患者标识关联来源描述	CD				ADT、挂号、建卡等手动关联的来源
		s EMPILINKSOURCENAME=""
		; CARD_NO	就诊卡号	ST	
		s CARDNO=$p($g(^PAPER(PatId,"PAT",1)),"^")
		; PERSON_NAME	姓名	ST	是	
		s PERSONNAME=$p($g(^PAPER(PatId,"ALL")),"^")
		; ALIAS_NAME	别名	ST	
		s ALIASNAME=$p($g(^PAPER(PatId,"ALL")),"^",2)
		; SEX_CODE	性别编码	CD	是
		s PatSexDR=$p($g(^PAPER(PatId,"ALL")),"^",7)
		s SEXCODE=""
		s:PatSexDR'="" SEXCODE=$p(^CT("SEX",PatSexDR),"^",1)
		; SEX_NAME	性别描述	CD	是	
		s SEXNAME=""
		s:PatSexDR'="" SEXNAME=$p(^CT("SEX",PatSexDR),"^",2)
		; DATE_OF_BIRTH	出生日期	D	是	
		s Birth=$p($g(^PAPER(PatId,"ALL")),"^",6)
		s DATEOFBIRTH=$zd(Birth,3)
		; IDENTITY_CODE	患者身份编码	CD		
		s IDENTITYCODE=""
		; IDENTITY_NAME	患者身份描述	CD		
		s IDENTITYNAME=""
		; CHARGE_TYPE_CODE	费别编码	CD	
		s CHARGETYPECODE=""
		; CHARGE_TYPE_NAME	费别描述	CD				
		s CHARGETYPENAME=""
		; INSURANCE_TYPE_CODE	医保类型编码	CD	
		s INSURANCETYPECODE=""
		; INSURANCE_TYPE_NAME	医保类型描述	CD				
		s INSURANCETYPENAME=""
		; BIRTH_PLACE	出生地点	ST	
		s BIRTHPLACE=""
		; MULTI_BIRTH_IND	双胞胎标记	BL				
		s MULTIBIRTHIND=""
		; MULTI_BIRTH_ORDER	双胞胎顺序	INT				
		s MULTIBIRTHORDER=""
		; DEATH_IND	死亡标记	BL				
		s DEATHIND=$p($g(^PAPER(PatId,"ALL")),"^",12)
		; DEATH_TIME	死亡时间	DT	
		s DeceasedDate=$p($g(^PAPER(PatId,"ALL")),"^",13)
		s DeceasedTime=$p($g(^PAPER(PatId,"ALL")),"^",8)	
		s DEATHTIME=""
		s:DEATHIND="Y" DEATHTIME=$zd(DeceasedDate,3)_" "_$zt(DeceasedTime,1)
		; MARITAL_STATUS_CODE	婚姻状态编码	CD	
		s MaritalDR=$p($g(^PAPER(PatId,"PER",2)),"^",3)		
		s MARITALSTATUSCODE=""
		s:MaritalDR'="" MARITALSTATUSCODE=$p($g(^CT("MAR",MaritalDR)),"^")
		; MARITAL_STATUS_NAME	婚姻状态描述	CD
		s MARITALSTATUSNAME=""
		s:MaritalDR'="" MARITALSTATUSNAME=$p($g(^CT("MAR",MaritalDR)),"^",2)
		; ORGAN_DONOR_IND	器官捐献者标记	BL				
		s ORGANDONORIND=""
		; DISABILITY_CODE	残疾码	ST				
		s DISABILITYCODE=""
		; NATION_CODE	国籍编码	CD	
		s CountryDR=$p($g(^PAPER(PatId,"PER",1)),"^",8)
		s NATIONCODE=""	
		s:CountryDR'="" NATIONCODE=$p($g(^CT("COU",CountryDR)),"^",1)
		; NATION_NAME	国籍描述	CD			
		s NATIONNAME=""
		s:CountryDR'="" NATIONNAME=$p($g(^CT("COU",CountryDR)),"^",2)
		; NATIONALITY_CODE	民族编码	CD				
		s NationDR=$p($g(^PAPER(PatId,"PER",2)),"^",1)
		s NATIONALITYCODE=""
		s:NationDR'="" NATIONALITYCODE=$p($g(^CT("NAT",NationDR)),"^",1)
		; NATIONALITY_NAME	民族描述	CD				
		s NATIONALITYNAME=""
		s:NationDR'="" NATIONALITYNAME=$p($g(^CT("NAT",NationDR)),"^",2)
		; RELIGION_CODE	宗教信仰编码	CD				
		s RELIGIONCODE=""
		; RELIGION_NAME	宗教信仰描述	CD				
		s RELIGIONNAME=""
		; NATIVE_PROVINCE_CODE	籍贯编码	CD		
		s NATIVEPROVINCECODE=""
		; NATIVE_PROVINCE_NAME	籍贯描述	CD				
		s NATIVEPROVINCENAME=""
		; LANGUAGE_CODE	语言编码	CD				
		s LANGUAGECODE=""
		; LANGUAGE_NAME	语言描述	CD				
		s LANGUAGENAME=""
		; DEGREE_LEVEL_CODE	最高学位编码	CD				
		s DEGREELEVELCODE=""
		; DEGREE_LEVEL_NAME	最高学位描述	CD				
		s DEGREELEVELNAME=""
		; EDUCATION_LEVEL_CODE	最高学历编码	CD				
		s EDUCATIONLEVELCODE=""
		; EDUCATION_LEVEL_NAME	最高学历描述	CD				
		s EDUCATIONLEVELNAME=""
		; POLITICS_STATUS_CODE	政治面貌编码	CD				
		s POLITICSSTATUSCODE=""
		; POLITICS_STATUS_NAME	政治面貌描述	CD				
		s POLITICSSTATUSNAME=""
		; FINANCIAL_SITUATION	经济状况	ST				
		s FINANCIALSITUATION=""
		; OCCUPATION_CODE	职业编码	CD				
		s OCCUPATIONCODE=""
		; OCCUPATION_NAME	职业描述	CD				
		s OCCUPATIONNAME=""
		; WORK_TIME	参加工作时间	D				
		s WORKTIME=""
		; ID_CARD_TYPE_CODE	证件类型编码	CD	
		s CardTypeDR=$p($g(^PAPER(PatId,"PAT",3)),"^"，7)		
		s IDCARDTYPECODE=""
		s:CardTypeDR'="" IDCARDTYPECODE=$p($g(^PAC("CARD",CardTypeDR)),"^",1)
		; IDCARDTYPENAME	证件类型描述	CD				
		s IDCARDTYPENAME=""
		s:CardTypeDR'="" IDCARDTYPENAME=$p($g(^PAC("CARD",CardTypeDR)),"^",2)
		; ID_CARD_NO	证件号码	ST				
		s IDCARDNO=$p($g(^PAPER(PatId,"PAT",3)),"^"，6)
		; SSN	社保号	ST				
		s SSN=""
		; INSURANCE_NO	医疗保险号	ST				
		s INSURANCENO=""
		; BUSINESSPHONEPHONE	单位电话	ST				
		s BUSINESSPHONEPHONE=""
		; HOME_PHONE	家庭电话	ST				
		s HOMEPHONE=""
		; OTHER_PHONE	其他电话	ST				
		s OTHERPHONE=$p($g(^PAPER(PatId,"PER",1)),"^",9)
		; MOBILE	手机	ST				
		s MOBILE=$p($g(^PAPER(PatId,"PER",1)),"^",11)
		; POSTCODE	邮编	ST				
		s POSTCODE=$p($g(^PAPER(PatId,"PER",4)),"^",19)
		; MAILING_ADDR_PROVINCE_CODE	联系地址省份编码	CD				
		s MAILINGADDRPROVINCECODE=""
		; MAILING_ADDR_PROVINCE_NAME	联系地址省份描述	CD				
		s MAILINGADDRPROVINCENAME=""
		; MAILING_ADDR_CITY_CODE	联系地址地市编码	CD				
		s MAILINGADDRCITYCODE=""
		; MAILING_ADDR_CITY_NAME	联系地址地市描述	CD				
		s MAILINGADDRCITYNAME=""
		; MAILING_ADDR_COUNTY_CODE	联系地址区县编码	CD				
		s MAILINGADDRCOUNTYCODE=""
		; MAILING_ADDR_COUNTY_NAME	联系地址区县描述	CD				
		s MAILINGADDRCOUNTYNAME=""
		; MAILING_ADDR_STREET_CODE	联系地址街道编码	CD				
		s MAILINGADDRSTREETCODE=""
		; MAILING_ADDR_STREET_NAME	联系地址街道描述	CD				
		s MAILINGADDRSTREETNAME=""
		; MAILING_ADDRESS	联系详细地址	ST				
		s MAILINGADDRESS=""
		; FAMILY_ADDR_PROVINCE_CODE	户籍所在地省份编码	CD				
		s FAMILYADDRPROVINCECODE=""
		; FAMILY_ADDR_PROVINCE_NAME	户籍所在地省份描述	CD				
		s FAMILYADDRPROVINCENAME=""
		; FAMILY_ADDR_CITY_CODE	户籍所在地地市编码	CD				
		s FAMILYADDRCITYCODE=""
		; FAMILY_ADDR_CITY_NAME	户籍所在地地市描述	CD				
		s FAMILYADDRCITYNAME=""
		; FAMILY_ADDR_COUNTY_CODE	户籍所在地区县编码	CD				
		s FAMILYADDRCOUNTYCODE=""
		; FAMILY_ADDR_COUNTY_NAME	户籍所在地区县描述	CD				
		s FAMILYADDRCOUNTYNAME=""
		; EMPLOYER_COMPANY	工作单位名称	ST				
		s EMPLOYERCOMPANY=$p($g(^PAPER(PatId,"PER",4)),"^",18)
		; EMPLOYER_POSTCODE	工作单位邮编	ST				
		s EMPLOYERPOSTCODE=""
		; EMPLOYER_ADDRESS	工作单位地址	ST				
		s EMPLOYERADDRESS=""
		; NEXT_OF_KIN	联系人	ST				
		s NEXTOFKIN=$p($g(^PAPER(PatId,"PER",2)),"^",13)
		; RELATIONSHIP_CODE	联系人与患者关系编码	CD				
		s CTRLTDR=$p($g(^PAPER(PatId,"EMP")),"^",4)
		s RELATIONSHIPCODE=""
		s:CTRLTDR'="" RELATIONSHIPCODE=$p($g(^CT("RLT",CTRLTDR)),"^",1)
		; RELATIONSHIP_NAME	联系人与患者关系描述	CD				
		s RELATIONSHIPNAME=""
		s:CTRLTDR'="" RELATIONSHIPNAME=$p($g(^CT("RLT",CTRLTDR)),"^",2)
		; NEXT_OF_KIN_PHONE	联系人电话	ST				
		s NEXTOFKINPHONE=$p($g(^PAPER(PatId,"ALL")),"^",4)
		; NEXT_OF_KIN_POST	联系人邮编	ST				
		s NEXTOFKINPOST=""
		; NEXT_OF_KIN_ADDR	联系人地址	ST				
		s NEXTOFKINADDR=$p($g(^PAPER(PatId,"PER",1)),"^",1)
		; BLOOD_TYPE_CODE	血型编码	CD	
		s BLOODTYPECODE=""			
		; BLOOD_TYPE_NAME	血型描述	CD	
		s BLOODTYPENAME=""			
		; RH_BLOOD_CODE	RH血型编码	CD	
		s RHBLOODCODE=""			
		; RH_BLOOD_NAME	RH血型描述	CD
		s RHBLOODNAME=""				
		; CONFIDENT_LEVEL_CODE	保密级别编码	CD	
		s CONFIDENTLEVELCODE=""			
		; CONFIDENT_LEVEL_NAME	保密级别描述	CD	
		s CONFIDENTLEVELNAME=""			
		; VIP_IND	VIP标志	BL		
		s VIPIND=""		
		; REGISTRATION_TIME	注册时间	DT				
		s REGISTRATIONTIME=""
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DeptInfoOutputRow      
	set Data=$lb(EID,EMPITYPECODE,EMPITYPENAME,PATIENTIDENTIFIER,EMPILINKTYPECODE,EMPILINKTYPENAME,EMPILINKSOURCECODE,EMPILINKSOURCENAME,CARDNO,PERSONNAME,ALIASNAME,SEXCODE,SEXNAME,DATEOFBIRTH,IDENTITYCODE,IDENTITYNAME,CHARGETYPECODE,CHARGETYPENAME,INSURANCETYPECODE,INSURANCETYPENAME,BIRTHPLACE,MULTIBIRTHIND,MULTIBIRTHORDER,DEATHIND,DEATHTIME,MARITALSTATUSCODE,MARITALSTATUSNAME,ORGANDONORIND,DISABILITYCODE,NATIONCODE,NATIONNAME,NATIONALITYCODE,NATIONALITYNAME,RELIGIONCODE,RELIGIONNAME,NATIVEPROVINCECODE,NATIVEPROVINCENAME,LANGUAGECODE,LANGUAGENAME,DEGREELEVELCODE,DEGREELEVELNAME,EDUCATIONLEVELCODE,EDUCATIONLEVELNAME,POLITICSSTATUSCODE,POLITICSSTATUSNAME,FINANCIALSITUATION,OCCUPATIONCODE,OCCUPATIONNAME,WORKTIME,IDCARDTYPECODE,IDCARDTYPENAME,IDCARDNO,SSN,INSURANCENO,BUSINESSPHONEPHONE,HOMEPHONE,OTHERPHONE,MOBILE,POSTCODE,MAILINGADDRPROVINCECODE,MAILINGADDRPROVINCENAME,MAILINGADDRCITYCODE,MAILINGADDRCITYNAME,MAILINGADDRCOUNTYCODE,MAILINGADDRCOUNTYNAME,MAILINGADDRSTREETCODE,MAILINGADDRSTREETNAMEMAILINGADDRESS,FAMILYADDRPROVINCECODE,FAMILYADDRPROVINCENAME,FAMILYADDRCITYCODE,FAMILYADDRCITYNAME,FAMILYADDRCOUNTYCODE,FAMILYADDRCOUNTYNAME,EMPLOYERCOMPANY,EMPLOYERPOSTCODE,EMPLOYERADDRESS,NEXTOFKIN,RELATIONSHIPCODE,RELATIONSHIPNAME,NEXTOFKINPHONE,NEXTOFKINPOST,NEXTOFKINADDR,BLOODTYPECODE,BLOODTYPENAME,RHBLOODCODE,RHBLOODNAME,CONFIDENTLEVELCODE,CONFIDENTLEVELNAME,VIPIND,REGISTRATIONTIME)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryPaPatMasInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPaPatMasInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
}
/// EID,EMPI_TYPE_CODE,EMPI_TYPE_NAME,PATIENT_IDENTIFIER,EMPI_LINK_TYPE_CODE,EMPI_LINK_TYPE_NAME,EMPI_LINK_SOURCE_CODE,EMPI_LINK_SOURCE_NAME,CARD_NO,PERSON_NAME,ALIAS_NAME,SEX_CODE,SEX_NAME,DATE_OF_BIRTH,IDENTITY_CODE,IDENTITY_NAME,CHARGE_TYPE_CODE,CHARGE_TYPE_NAME,INSURANCE_TYPE_CODE,INSURANCE_TYPE_NAME,BIRTH_PLACE,MULTI_BIRTH_IND,MULTI_BIRTH_ORDER,DEATH_IND,DEATH_TIME,MARITAL_STATUS_CODE,MARITAL_STATUS_NAME,ORGAN_DONOR_IND,DISABILITY_CODE,NATION_CODE,NATION_NAME,NATIONALITY_CODE,NATIONALITY_NAME,RELIGION_CODE,RELIGION_NAME,NATIVE_PROVINCE_CODE,NATIVE_PROVINCE_NAME,LANGUAGE_CODE,LANGUAGE_NAME,DEGREE_LEVEL_CODE,DEGREE_LEVEL_NAME,EDUCATION_LEVEL_CODE,EDUCATION_LEVEL_NAME,POLITICS_STATUS_CODE,POLITICS_STATUS_NAME,FINANCIAL_SITUATION,OCCUPATION_CODE,OCCUPATION_NAME,WORK_TIME,ID_CARD_TYPE_CODE,ID_CARD_TYPE_NAME,ID_CARD_NO,SSN,INSURANCE_NO,BUSINESS_PHONE_PHONE,HOME_PHONE,OTHER_PHONE,MOBILE,POSTCODE,MAILING_ADDR_PROVINCE_CODE,MAILING_ADDR_PROVINCE_NAME,MAILING_ADDR_CITY_CODE,MAILING_ADDR_CITY_NAME,MAILING_ADDR_COUNTY_CODE,MAILING_ADDR_COUNTY_NAME,MAILING_ADDR_STREET_CODE,MAILING_ADDR_STREET_NAME,MAILING_ADDRESS,FAMILY_ADDR_PROVINCE_CODE,FAMILY_ADDR_PROVINCE_NAME,FAMILY_ADDR_CITY_CODE,FAMILY_ADDR_CITY_NAME,FAMILY_ADDR_COUNTY_CODE,FAMILY_ADDR_COUNTY_NAME,EMPLOYER_COMPANY,EMPLOYER_POSTCODE,EMPLOYER_ADDRESS,NEXT_OF_KIN,RELATIONSHIP_CODE,RELATIONSHIP_NAME,NEXT_OF_KIN_PHONE,NEXT_OF_KIN_POST,NEXT_OF_KIN_ADDR,BLOOD_TYPE_CODE,BLOOD_TYPE_NAME,RH_BLOOD_CODE,RH_BLOOD_NAME,CONFIDENT_LEVEL_CODE,CONFIDENT_LEVEL_NAME,VIP_IND,REGISTRATION_TIME
}