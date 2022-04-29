Class DHCDoc.Interface.TumorReporting.ComQuery Extends %RegisteredObject
{

/// B02-1.患者就诊基本信息表
/// patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,visit_datetime,medical_record_no,inpatient_no,hospitalization_times,admission_datetime,discharge_datetime,visit_doctor_no,name,gender,patient_gender,date_of_birth,occupation_code,occupation_name,nationality,ethnicity,education,marital_status,newbron_mark,certificate_type,certificate_no,health_card_type,health_card_no,insurance_type,insurance_no,residence_province,residence_city,residence_county,current_address,phone_no,phone_no2,email,weixin,contact_person1,contact_phone_no1,contact_person2,contact_phone_no2,abo_blood_type,rh_blood_type,hospital_id,hospital_name,hospital_level,is_discharge,patien_identity,blood_type_s,blood_type_e,height,weight,newborn_date,newborn_weight,newborn_current_weight,is_drug_allergy,allergy_drug_code,allergy_drug_name,patient_pregnant,patient_lactating,in_bed_no,out_bed_no,imdept_code,imdept_name,transferDept_code,transferDept_name,dept_code,dept_name,doctor_group_code,doctor_group_name,doctor_code,doctor_name,hospital_time,leave_hospital_type,is_upload_date,admission_disease_id,admission_disease_name,discharge_disease_id,discharge_disease_name,discharge_reason,tsblbs,diagnose_position1,diagnose_position2,is_pathological_examination,pathology_code,is_hospital_infected,hospital_infected_code,disease_type,special_disease_code,discharge_outcome,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.TumorReporting.ComQuery","DIPatientInfo","2021-11-04","2021-11-04")
/// CALL web_DHCENS_BLL_ZLSB_TransInfo_Method.UploadZLData_DIPatientInfo("2021-11-04","2021-11-04")
/// OEORI_ItmMast_DRd ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetSubsort","48","")
/// Query DIPatientInfo(StartDate As %Date, EndDate As %Date) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,visit_datetime,medical_record_no,inpatient_no,hospitalization_times,admission_datetime,discharge_datetime,visit_doctor_no,name,gender,patient_gender,date_of_birth,occupation_code,occupation_name,nationality,ethnicity,education,marital_status,newbron_mark,certificate_type,certificate_no,health_card_type,health_card_no,insurance_type,insurance_no,residence_province,residence_city,residence_county,current_address,phone_no,phone_no2,email,weixin,contact_person1,contact_phone_no1,contact_person2,contact_phone_no2,abo_blood_type,rh_blood_type,hospital_id,hospital_name,hospital_level,is_discharge,patien_identity,blood_type_s,blood_type_e,height,weight,newborn_date,newborn_weight,newborn_current_weight,is_drug_allergy,allergy_drug_code,allergy_drug_name,patient_pregnant,patient_lactating,in_bed_no,out_bed_no,imdept_code,imdept_name,transferDept_code,transferDept_name,dept_code,dept_name,doctor_group_code,doctor_group_name,doctor_code,doctor_name,hospital_time,leave_hospital_type,is_upload_date,admission_disease_id,admission_disease_name,discharge_disease_id,discharge_disease_name,discharge_reason,tsblbs,diagnose_position1,diagnose_position2,is_pathological_examination,pathology_code,is_hospital_infected,hospital_infected_code,disease_type,special_disease_code,discharge_outcome,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc, SqlViewName = DIPatientInfo ]
Query DIPatientInfo(StartDate As %Date, EndDate As %Date) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,visit_datetime,medical_record_no,inpatient_no,hospitalization_times,admission_datetime,discharge_datetime,visit_doctor_no,name,gender,date_of_birth,occupation_code,occupation_name,nationality,ethnicity,education,marital_status,newbron_mark,certificate_type,certificate_no,health_card_type,health_card_no,insurance_type,insurance_no,residence_province,residence_city,residence_county,current_address,phone_no,phone_no2,email,weixin,contact_person1,contact_phone_no1,contact_person2,contact_phone_no2,abo_blood_type,rh_blood_type,hospital_id,hospital_name,hospital_level,is_discharge,patien_identity,blood_type_s,blood_type_e,height,weight,newborn_date,newborn_weight,newborn_current_weight,is_drug_allergy,allergy_drug_code,allergy_drug_name,patient_pregnant,patient_lactating,in_bed_no,out_bed_no,imdept_code,imdept_name,transferDept_code,transferDept_name,dept_code,dept_name,doctor_group_code,doctor_group_name,doctor_code,doctor_name,hospital_time,leave_hospital_type,is_upload_date,admission_disease_id,admission_disease_name,admission_date,discharge_disease_id,discharge_disease_name,discharge_reason,discharge_date,tsblbs,diagnose_position1,diagnose_position2,is_pathological_examination,pathology_code,is_hospital_infected,hospital_infected_code,disease_type,special_disease_code,discharge_outcome,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc, SqlViewName = DIPatientInfo ]
{
}

ClassMethod DIPatientInfoExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $G(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    s AdmTypeStr="O^E^I"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    
			    d OutPatientInfo
		    }
	    }
	 
 
	    
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatientInfo
	s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(AdmId)
	s PatientId=OneAdmObj.PatientId
	s VisitSn=OneAdmObj.VisitSn
	s VisitType=OneAdmObj.VisitType
	s VisitCardNo=OneAdmObj.VisitCardNo
	s OutpatientNo=OneAdmObj.OutpatientNo
	s VisitTimes=OneAdmObj.VisitTimes
	s VisitDatetime=OneAdmObj.VisitDatetime
	s MedicalRecordNo=OneAdmObj.MedicalRecordNo
	s InpatientNo=OneAdmObj.InpatientNo
	s HospitalizationTimes=OneAdmObj.HospitalizationTimes
	s AdmissionDatetime=OneAdmObj.AdmissionDatetime
	s DischargeDatetime=OneAdmObj.DischargeDatetime
	s VisitDoctorNo=OneAdmObj.VisitDoctorNo
	s Name=OneAdmObj.Name
	s Gender=OneAdmObj.Gender
	s PatientGender=OneAdmObj.PatientGender
	s DateOfBirth=OneAdmObj.DateOfBirth
	s OccupationCode=OneAdmObj.OccupationCode
	s OccupationName=OneAdmObj.OccupationName
	s Nationality=OneAdmObj.Nationality
	s Ethnicity=OneAdmObj.Ethnicity	
	s Education=OneAdmObj.Education
	s AdmissionDiseaseName=OneAdmObj.AdmissionDiseaseName
	s NewbronMark=OneAdmObj.NewbronMark
	s AdmissionDiseaseName=OneAdmObj.AdmissionDiseaseName
	s CertificateNo=OneAdmObj.CertificateNo
	s HealthCardType=OneAdmObj.HealthCardType
	s HealthCardNo=OneAdmObj.HealthCardNo
	s InsuranceType=OneAdmObj.InsuranceType
	s InsuranceNo=OneAdmObj.InsuranceNo
	s ResidenceProvince=OneAdmObj.ResidenceProvince
	s ResidenceCity=OneAdmObj.ResidenceCity
	s ResidenceCounty=OneAdmObj.ResidenceCounty
	s CurrentAddress=OneAdmObj.CurrentAddress
	s PhoneNo=OneAdmObj.PhoneNo
	s PhoneNo2=OneAdmObj.PhoneNo2
	s Email=OneAdmObj.Email
	s weixin=OneAdmObj.weixin
	s ContactPerson1=OneAdmObj.ContactPerson1
	s ContactPhoneNo1=OneAdmObj.ContactPhoneNo1
	s ContactPerson2=OneAdmObj.ContactPerson2
	s ContactPhoneNo2=OneAdmObj.ContactPhoneNo2
	s AboBloodType=OneAdmObj.AboBloodType
	s RhBloodType=OneAdmObj.RhBloodType
	s HospitalId=OneAdmObj.HospitalId
	s HospitalName=OneAdmObj.HospitalName
	s HospitalName="中国医学科学院肿瘤医院"
	s HospitalLevel=OneAdmObj.HospitalLevel
	s isdischarge=OneAdmObj.IsDischarge
	s PatienIdentity=OneAdmObj.PatienIdentity
	s BloodTypeS=OneAdmObj.BloodTypeS
	s BloodTypeE=OneAdmObj.BloodTypeE	
	s Height=OneAdmObj.Height	
	s Weight=OneAdmObj.Weight
	s newbornDate=OneAdmObj.newbornDate
	s NewbornWeight=OneAdmObj.NewbornWeight	
	s NewbornCurrentWeight=OneAdmObj.NewbornCurrentWeight
	s IsDrugAllergy=OneAdmObj.IsDrugAllergy
	s AllergyDrugCode=OneAdmObj.AllergyDrugCode
	s AllergyDrugName=OneAdmObj.AllergyDrugName
	s PatientPregnant=OneAdmObj.PatientPregnant
	s PatientLactating=OneAdmObj.PatientLactating
	s InBedNo=OneAdmObj.InBedNo
	s InBedNo=OneAdmObj.InBedNo
	s ImdeptCode=OneAdmObj.ImdeptCode
	s ImdeptName=OneAdmObj.ImdeptName
	s TransferDeptCode=OneAdmObj.TransferDeptCode
	s TransferDeptName=OneAdmObj.TransferDeptName
	s DeptCode=OneAdmObj.DeptCode
	s DeptName=OneAdmObj.DeptName
	s DoctorGroupCode=OneAdmObj.DoctorGroupCode
	s DoctorGroupName=OneAdmObj.DoctorGroupName
	s DoctorCode=OneAdmObj.DoctorCode
	s DoctorName=OneAdmObj.DoctorName
	s HospitalTime=OneAdmObj.HospitalTime
	s LeaveHospitalType=OneAdmObj.LeaveHospitalType
	s IsUploadDate=OneAdmObj.IsUploadDate
	s AdmissionDiseaseId=OneAdmObj.AdmissionDiseaseId
	s AdmissionDiseaseName=OneAdmObj.AdmissionDiseaseName
	s AdmissionDiseaseId=OneAdmObj.AdmissionDiseaseId
	s AdmissionDiseaseName=OneAdmObj.AdmissionDiseaseName
	s DischargeReason=OneAdmObj.DischargeReason
	s Tsblbs=OneAdmObj.Tsblbs
	s DiagnosePosition1=OneAdmObj.DiagnosePosition1
	s DiagnosePosition2=OneAdmObj.DiagnosePosition2
	s IsPathologicalExamination=OneAdmObj.IsPathologicalExamination
	s PathologyCode=OneAdmObj.PathologyCode
	s IsHospitalInfected=OneAdmObj.IsHospitalInfected
	s HospitalInfectedCode=OneAdmObj.HospitalInfectedCode
	s DiseaseType=OneAdmObj.DiseaseType
	s SpecialDiseaseCode=OneAdmObj.SpecialDiseaseCode
	s DischargeOutcome=OneAdmObj.DischargeOutcome
	s ExtendData1=OneAdmObj.ExtendData1
	s ExtendData2=OneAdmObj.ExtendData2
	s RecordStatus=OneAdmObj.RecordStatus
	s YYID=OneAdmObj.YYID
	s YYUPDATETIME=OneAdmObj.YYUPDATETIME
	s YYCREATETIME=OneAdmObj.YYCREATETIME
	;set Data=$lb(patientid,visitsn,visittype,visitcardno,outpatientno,visittimes,visitdatetime,medicalrecordno,inpatientno,hospitalizationtimes,admissiondatetime,dischargedatetime,visitdoctorno,name,gender,dateofbirth,occupationcode,occupationname,nationality,ethnicity,education,maritalstatus,newbronmark,certificatetype,certificateno,healthcardtype,healthcardno,insurancetype,insuranceno,residenceprovince,residencecity,residencecounty,currentaddress,phoneno,phoneno2,email,weixin,contactperson1,contactphoneno1,contactperson2,contactphoneno2,abobloodtype,rhbloodtype,hospitalid,hospitalname,hospitallevel,isdischarge,patienidentity,bloodtypes,bloodtypee,height,weight,newborndate,newbornweight,newborncurrentweight,isdrugallergy,allergydrugcode,allergydrugname,patientpregnant,patientlactating,inbedno,outbedno,imdeptcode,imdeptname,transferDeptcode,transferDeptname,deptcode,deptname,doctorgroupcode,doctorgroupname,doctorcode,doctorname,hospitaltime,leavehospitaltype,isuploaddate,admissiondiseaseid,admissiondiseasename,admissiondate,dischargediseaseid,dischargediseasename,dischargereason,dischargedate,tsblbs,diagnoseposition1,diagnoseposition2,ispathologicalexamination,pathologycode,ishospitalinfected,hospitalinfectedcode,diseasetype,specialdiseasecode,dischargeoutcome,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME) 																																
	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,VisitDatetime,MedicalRecordNo,InpatientNo,HospitalizationTimes,AdmissionDatetime,DischargeDatetime,VisitDoctorNo,Name,Gender,DateOfBirth,OccupationCode,OccupationName,Nationality,Ethnicity,Education,maritalstatus,NewbronMark,certificatetype,CertificateNo,HealthCardType,HealthCardNo,InsuranceType,InsuranceNo,ResidenceProvince,ResidenceCity,ResidenceCounty,CurrentAddress,PhoneNo,PhoneNo2,Email,weixin,ContactPerson1,ContactPhoneNo1,ContactPerson2,ContactPhoneNo2,AboBloodType,RhBloodType,HospitalId,HospitalName,HospitalLevel,isdischarge,PatienIdentity,BloodTypeS,BloodTypeE,Height,Weight,newbornDate,NewbornWeight,NewbornCurrentWeight,IsDrugAllergy,AllergyDrugCode,AllergyDrugName,PatientPregnant,PatientLactating,InBedNo,InBedNo,ImdeptCode,ImdeptName,TransferDeptCode,TransferDeptName,DeptCode,DeptName,DoctorGroupCode,DoctorGroupName,DoctorCode,DoctorName,HospitalTime,LeaveHospitalType,IsUploadDate,AdmissionDiseaseId,AdmissionDiseaseName,admissiondate,AdmissionDiseaseId,AdmissionDiseaseName,DischargeReason,dischargedate,Tsblbs,DiagnosePosition1,DiagnosePosition2,IsPathologicalExamination,PathologyCode,IsHospitalInfected,HospitalInfectedCode,DiseaseType,SpecialDiseaseCode,DischargeOutcome,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DIPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DIPatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DIPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DIPatientInfoExecute ]
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
	Quit $$$OK
}

/// 诊断信息  ----  ms
/// patient_id,visit_sn,visit_type,visit_card_no,medical_record_no,outpatient_no,visit_times,inpatient_no,hospitalization_times,name,diag_id,diag_serial_number,diag_type,diag_code,diag_name,diag_explanation,diag_datetime,confirmed_diag_mark,maindiag_mark,diag_doctor_no,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,VisitType,VisitCardNo,MedicalRecordNo,OutpatientNo,VisitTimes,InpatientNo,HospitalizationTimes,Name,DiagId,DiagSerialNumber,DiaType,DiagCode,DiagName,DiagExplanation,DiagDatetime,ConfirmedDiagMark,MaindiagMark,DiagDoctorNo,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("web.DHCENS.BLL.ZLSB.TransInfo.Method.UploadZLData","AdmDiagnosInfo","2021-11-04","2021-11-04")
/// CALL web_DHCENS_BLL_ZLSB_TransInfo_Method.UploadZLData_AdmDiagnosInfo("2021-11-04","2021-11-04")
Query AdmDiagnosInfo(StartDate As %Date, EndDate As %Date) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,medical_record_no,outpatient_no,visit_times,inpatient_no,hospitalization_times,name,diag_id,diag_serial_number,diag_type,diag_code,diag_name,diag_explanation,diag_datetime,confirmed_diag_mark,maindiag_mark,diag_doctor_no,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc, SqlViewName = DIPatientInfo ]
{
}

ClassMethod AdmDiagnosInfoExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCENS.BLL.TransInfo.Method.PUMCHUpload","INPatientInfo","2017-11-19","2017-11-19")
	Set repid=$I(^CacheTemp)
	If $G(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    for Date=StartDate:1:EndDate{
	    s AdmId="" 
		f {
			s AdmId=$O(^PAADMi("PAADM_AdmDate",Date,AdmId)) 
			q:AdmId=""
			s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(AdmId)
			; patient_id	患者ID(与b02_1一定有值)	00931222	患者在本院的唯一标识	文本	varchar(100)	是
			; PatientId,VisitSn,VisitType,VisitCardNo,MedicalRecordNo,OutpatientNo,VisitTimes,InpatientNo,HospitalizationTimes,Name
			s PatientId=OneAdmObj.PatientId
			; visit_sn	单次就诊唯一标识号(与b02_1强关联)	00931222|4623477|1门诊	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|就诊类型、患者ID|门诊号|就诊次数|就诊类型。	文本	varchar(100)	是
			s VisitSn=OneAdmObj.VisitSn
			; visit_type	就诊类型	门诊	就诊类型：住院、门诊	文本	varchar(50)	是
			s VisitType=OneAdmObj.VisitType
			; visit_card_no	就诊卡号	153898	患者在本医院就诊时使用的就诊卡号	文本	varchar(100)	是
			s VisitCardNo=OneAdmObj.VisitCardNo
			; medical_record_no	病案号	869881	患者在本院就诊时使用的病案号	文本	varchar(100)
			s MedicalRecordNo=OneAdmObj.MedicalRecordNo
			; outpatient_no	门诊号	4623477	患者门诊就诊时对应的门诊号或者病历号	文本	varchar(100)	是（就诊类型为门诊）
			s OutpatientNo=OneAdmObj.OutpatientNo
			; visit_times	就诊次数	1	本院门诊次数	数值	int	是（就诊类型为门诊）
			s VisitTimes=OneAdmObj.VisitTimes
			; inpatient_no	住院号	4623477	患者住院号	文本	varchar(100)	是（就诊类型为住院）
			s InpatientNo=OneAdmObj.InpatientNo
			; hospitalization_times	住院次数	1	住院次数	数值	varchar(20)	是（就诊类型为住院）
			s HospitalizationTimes=OneAdmObj.HospitalizationTimes
			; name	患者姓名	张三	患者姓名	文本	varchar(100)	是
			s Name=OneAdmObj.Name
			s MradmRowid=$P($g(^PAADM(AdmId)),"^",61)
			set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
			d obj.Execute(MradmRowid)
			For{
				Quit:('obj.Next())
				s Rowid=obj.Data("ID")
				s CodeRowid=obj.Data("MRDIAICDCodeDR")
				continue:CodeRowid=""
				s DiagDesc=obj.Data("MRDIAICDCodeDRDesc")
				; diag_id	诊断ID号	10431	诊断表唯一ID	文本	varchar(100)	是
				; DiagId,DiagSerialNumber,DiaType,DiagCode,DiagName,DiagExplanation,DiagDatetime,ConfirmedDiagMark,
				; MaindiagMark,DiagDoctorNo,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
				s DiagId=Rowid
				; diag_serial_number	诊断序号	1	诊断顺序号	文本	varchar(100)	是
				s DiagSerialNumber=$p(Rowid,"^",2)
				; diag_type	诊断类型	出院诊断	门诊诊断、入院诊断、出院诊断、其他诊断	文本	varchar(100)	是
				s DiaTypeDr="",DiaType=""
				s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
				if SubRowid'="" s DiaTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
				i DiaTypeDr'="" Set DiaType=$P($G(^MRC("DTYP",DiaTypeDr)),"^",2)
				; diag_code	诊断编码	C34.901		文本	varchar(100)
				s DiagCode=$p($g(^MRC("ID",+CodeRowid)),"^",9)	
				; diag_name	诊断名称	右肺下叶小细胞癌		文本	varchar(100)	是
				s DiagName=$p($g(^MRC("ID",+CodeRowid)),"^",2)
				; diag_explanation	诊断说明	右肺下叶小细胞癌，未见癌转移	诊断情况详细说明	文本	varchar(100)
				s DiagExplanation=""	
				; diag_datetime	诊断时间	2018-01-12 11:32:11	符合【yyyy-MM-dd HH:mm:ss】的格式	日期	datetime
				s MRDiagnosDate=obj.Data("MRDIADate")
				s MRdiagnosTime=obj.Data("MRDIATime")
				s DiagDatetime=	##class(websys.Conversions).DateLogicalToHtml(MRDiagnosDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(MRdiagnosTime)
				; confirmed_diag_mark	是否明确诊断	是	是否是确诊诊断，请填写是或否	文本	varchar(50)	
				s ConfirmedDiagMark=""
				; maindiag_mark	是否主要诊断	否	是否是主要诊断，请填写是或否	文本	varchar(50)	
				s MaindiagMark="否"
				s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
				s:MainDiagFlag="Y" MaindiagMark="是"
				; diag_doctor_no	诊断医生代码	1021		文本	varchar(100)	是
				s AddUserDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",18)
				s DiagDoctorNo=""
				s:AddUserDr'="" DiagDoctorNo=$p($g(^SSU("SSUSR",+AddUserDr)),"^",1)
				; extend_data1	扩展字段1		用于填写补充信息	文本	text
				s ExtendData1=""	
				; extend_data2	扩展字段2		用于填写补充信息	文本	text
				s ExtendData2=""	
				; record_status	记录状态	1	1正常 0作废	数值	int	是
				s RecordStatus="1"
				; YY_ID	数据唯一标识			文本	varchar(100)	是\
				s YYID=Rowid
				; YY_UPDATE_TIME	数据更新时间(增量采集时间)			日期	datetime	是
				s YYUPDATETIME=DiagDatetime
				; YY_CREATE_TIME	数据创建时间			日期	datetime	是
				s YYCREATETIME=DiagDatetime
				d OutAdmDiagnosInfo
			}
		}
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAdmDiagnosInfo
 	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,MedicalRecordNo,OutpatientNo,VisitTimes,InpatientNo,HospitalizationTimes,Name,DiagId,DiagSerialNumber,DiaType,DiagCode,DiagName,DiagExplanation,DiagDatetime,ConfirmedDiagMark,MaindiagMark,DiagDoctorNo,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod AdmDiagnosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmDiagnosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AdmDiagnosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmDiagnosInfoExecute ]
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
	Quit $$$OK
}

/// --住院医嘱记录
/// B10-1 住院医嘱记录
/// patient_id,visit_sn,medical_record_no,inpatient_no,hospitalization_times,order_sn,request_no,order_given_time,order_confirm_time,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,visit_dept_code,visit_dept_name,order_start_datetime,order_end_datetime,executive_dept_code,executive_dept_name,order_type,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency_name,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,num_of_order,num_of_order_unit,herbal_note,order_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,MedicalRecordNo,InpatientNo,HospitalizationTimes,OrderSn,RequestNo,OrderGivenTime,OrderConfirmTime,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,VisitDeptCode,VisitDeptName,OrderStartDatetime,OrderEndDatetime,ExecutiveDeptCode,ExecutiveDeptName,OrderType,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,FrequencyName,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,NumOfOrder,NumOfOrderUnit,HerbalNote,OrderNote,DrugFlag,Manufac,TradeName,ExtendData1,RxtendRata2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.TumorReporting.ComQuery","GetIPOEOrderInfo","2019-10-01","2019-10-02")
/// CALL DHCDoc_Interface_TumorReporting.ComQuery_GetIPOEOrderInfo("2019-10-01","2019-10-02")
Query GetIPOEOrderInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,medical_record_no,inpatient_no,hospitalization_times,order_sn,request_no,order_given_time,order_confirm_time,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,visit_dept_code,visit_dept_name,order_start_datetime,order_end_datetime,executive_dept_code,executive_dept_name,order_type,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency_name,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,num_of_order,num_of_order_unit,herbal_note,order_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc ]
{
}

ClassMethod GetIPOEOrderInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    s AdmTypeStr="I"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    q:AdmId'="9620985"
				s OrderRowid=$o(^OEORD(0,"Adm",AdmId,0))
				continue:OrderRowid=""
				s ItemSub=0
				for{
					s ItemSub = $o(^OEORD(OrderRowid,"I",ItemSub))
					q:ItemSub=""
					s OneOEORIRowID=OrderRowid_"||"_ItemSub
					d OutIPOEOrderInfo
				}
			}
	    }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutIPOEOrderInfo
	s OneItemObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetOrderInfo(AdmId,OneOEORIRowID)
	s PatientId=OneItemObj.PatientId
	s VisitSn=OneItemObj.VisitSn
	s MedicalRecordNo=OneItemObj.MedicalRecordNo
	s InpatientNo=OneItemObj.InpatientNo
	s HospitalizationTimes=OneItemObj.HospitalizationTimes
	s OrderSn=OneItemObj.OrderSn
	s RequestNo=OneItemObj.RequestNo
	s OrderGivenTime=OneItemObj.OrderGivenTime
	s OrderConfirmTime=OneItemObj.OrderConfirmTime
	s OrderDeptCode=OneItemObj.OrderDeptCode
	s OrderDeptName=OneItemObj.OrderDeptName
	s OrderDoctorNo=OneItemObj.OrderDoctorNo
	s TechnicalTitle=OneItemObj.TechnicalTitle
	s JobTitle=OneItemObj.JobTitle
	s VisitDeptCode=OneItemObj.VisitDeptCode
	s VisitDeptName=OneItemObj.VisitDeptName
	s OrderStartDatetime=OneItemObj.OrderStartDatetime
	s OrderEndDatetime=OneItemObj.OrderEndDatetime
	s ExecutiveDeptCode=OneItemObj.ExecutiveDeptCode
	s ExecutiveDeptName=OneItemObj.ExecutiveDeptName
	s OrderType=OneItemObj.OrderType
	s OrderClassCode=OneItemObj.OrderClassCode
	s OrderClassName=OneItemObj.OrderClassName
	s OrderItemCode=OneItemObj.OrderItemCode
	s OrderItemName=OneItemObj.OrderItemName
	s OrderGroupNo=OneItemObj.OrderGroupNo
	s Dose=OneItemObj.Dose
	s DoseUnit=OneItemObj.DoseUnit
	s Form=OneItemObj.Form
	s Spec=OneItemObj.Spec
	s FrequencyCode=OneItemObj.FrequencyCode
	s FrequencyName=OneItemObj.FrequencyName
	s AdministrationRoute=OneItemObj.AdministrationRoute
	s LiquidConfiguration=OneItemObj.LiquidConfiguration
	s InjectionType=OneItemObj.InjectionType
	s DrugOrder=OneItemObj.DrugOrder
	s DrugCompatibility=OneItemObj.DrugCompatibility
	s InfusionDuration=OneItemObj.InfusionDuration
	s NumOfOrder=OneItemObj.NumOfOrder
	s NumOfOrderUnit=OneItemObj.NumOfOrderUnit
	s HerbalNote=OneItemObj.HerbalNote
	s OrderNote=OneItemObj.OrderNote
	s DrugFlag=OneItemObj.DrugFlag
	s Manufac=OneItemObj.Manufac
	s TradeName=OneItemObj.TradeName
	s ExtendData1=OneItemObj.ExtendData1
	s RxtendRata2=OneItemObj.RxtendRata2
	s RecordStatus=OneItemObj.RecordStatus
	s YYID=OneItemObj.YYID
	s YYUPDATETIME=OneItemObj.YYUPDATETIME
	s YYCREATETIME=OneItemObj.YYCREATETIME
	set Data=$lb(PatientId,VisitSn,MedicalRecordNo,InpatientNo,HospitalizationTimes,OrderSn,RequestNo,OrderGivenTime,OrderConfirmTime,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,VisitDeptCode,VisitDeptName,OrderStartDatetime,OrderEndDatetime,ExecutiveDeptCode,ExecutiveDeptName,OrderType,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,FrequencyName,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,NumOfOrder,NumOfOrderUnit,HerbalNote,OrderNote,DrugFlag,Manufac,TradeName,ExtendData1,RxtendRata2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetIPOEOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPOEOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIPOEOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPOEOrderInfoExecute ]
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
	Quit $$$OK
}

/// 12.恶性肿瘤患者门诊诊疗挂号记录
/// B12-1 门诊患者信息表
/// patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,name,regis_sn,regis_datetime,visit_datetime,first_visit_mark,regis_method_code,regis_method,regis_type_code,regis_type,regis_charge_price,regis_paid_price,regis_dept_code,regis_dept_name,visit_doctor_no,technical_title,job_title,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,Name,RegisSn,RegisDatetime,VisitDatetime,FirstVisitMark,RegisMethodCode,RegisMethod,RegisTypeCode,RegisType,RegisChargePrice,RegisPaidPrice,RegisDeptCode,RegisDeptName,VisitDoctorNo,TechnicalTitle,JobTitle,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("web.DHCENS.BLL.ZLSB.TransInfo.Method.UploadZLData","OPRegist","2021-11-04","2021-11-04")
/// CALL web_DHCENS_BLL_ZLSB_TransInfo_Method.UploadZLData_OPRegist("2021-11-04","2021-11-04")
Query OPRegist(StartDate As %Date, EndDate As %Date) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,name,regis_sn,regis_datetime,visit_datetime,first_visit_mark,regis_method_code,regis_method,regis_type_code,regis_type,regis_charge_price,regis_paid_price,regis_dept_code,regis_dept_name,visit_doctor_no,technical_title,job_title,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc, SqlViewName = OPRegist ]
{
}

ClassMethod OPRegistExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date) As %Status
{
 
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    /// 统一整理时间
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    ;^PAADMi("NNType",{PAADM_Type},{PAADM_AdmDate},{PAADM_RowID})
    ;b ;00
    s AdmTypeStr="O^E"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    ;b ;01
			    d OutOPRegist
		    }
	    }
	   /**
	   b ;01
	    s AdmId="" 
		f {
			s AdmId=$O(^PAADMi("PAADM_AdmDate",Date,AdmId)) 
			q:AdmId=""
			b ;02
			d OutOPRegist
		}
	 **/
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOPRegist
	s OneOPRegistObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetOPRegistInfo(AdmId)
	s PatientId=OneOPRegistObj.PatientId
	s VisitSn=OneOPRegistObj.VisitSn
	s VisitType=OneOPRegistObj.VisitType
	s VisitCardNo=OneOPRegistObj.VisitCardNo
	s OutpatientNo=OneOPRegistObj.OutpatientNo
	s VisitTimes=OneOPRegistObj.VisitTimes
	s Name=OneOPRegistObj.Name
	s RegisSn=OneOPRegistObj.RegisSn
	s RegisDatetime=OneOPRegistObj.RegisDatetime
	s VisitDatetime=OneOPRegistObj.VisitDatetime
	s FirstVisitMark=OneOPRegistObj.FirstVisitMark
	s RegisMethodCode=OneOPRegistObj.RegisMethodCode
	s RegisMethod=OneOPRegistObj.RegisMethod
	s RegisTypeCode=OneOPRegistObj.RegisTypeCode
	s RegisType=OneOPRegistObj.RegisType
	s RegisChargePrice=OneOPRegistObj.RegisChargePrice
	s RegisPaidPrice=OneOPRegistObj.RegisPaidPrice
	s RegisDeptCode=OneOPRegistObj.RegisDeptCode
	s RegisDeptName=OneOPRegistObj.RegisDeptName
	s VisitDoctorNo=OneOPRegistObj.VisitDoctorNo
	s TechnicalTitle=OneOPRegistObj.TechnicalTitle
	s JobTitle=OneOPRegistObj.JobTitle
	s ExtendData1=OneOPRegistObj.ExtendData1
	s ExtendData2=OneOPRegistObj.ExtendData2
	s RecordStatus=OneOPRegistObj.RecordStatus
	s YYID=OneOPRegistObj.YYID
	s YYUPDATETIME=OneOPRegistObj.YYUPDATETIME
	s YYCREATETIME=OneOPRegistObj.YYCREATETIME

	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,Name,RegisSn,RegisDatetime,VisitDatetime,FirstVisitMark,RegisMethodCode,RegisMethod,RegisTypeCode,RegisType,RegisChargePrice,RegisPaidPrice,RegisDeptCode,RegisDeptName,VisitDoctorNo,TechnicalTitle,JobTitle,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod OPRegistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPRegistExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPRegistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPRegistExecute ]
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
	Quit $$$OK
}

/// --门急诊医嘱记录
/// B14-1 门急诊医嘱记录
/// patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,order_sn,request_no,order_given_time,visit_dept_code,visit_dept_name,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,executive_dept_code,executive_dept_name,prescription_class_code,prescription_class_name,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,days_of_medication,total_dose,total_dose_unit,num_of_orders,num_of_orders_unit,order_note,herbal_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,OrderSn,RequestNo,OrderGivenTime,VisitDeptCode,VisitDeptName,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,ExecutiveDeptCode,ExecutiveDeptName,PrescriptionClassCode,PrescriptionClassName,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,Frequency,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,DaysOfMedication,TotalDose,TotalDoseUnit,NumOfOrders,NumOfOrdersUnit,OrderNote,HerbalNote,DrugFlag,Manufac,TradeName,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.TumorReporting.ComQuery","GetOPOEOrderInfo","2019-10-01","2019-10-02")
/// CALL DHCDoc_Interface_TumorReporting.ComQuery_GetOPOEOrderInfo("2019-10-01","2019-10-02")
Query GetOPOEOrderInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,order_sn,request_no,order_given_time,visit_dept_code,visit_dept_name,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,executive_dept_code,executive_dept_name,prescription_class_code,prescription_class_name,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,days_of_medication,total_dose,total_dose_unit,num_of_orders,num_of_orders_unit,order_note,herbal_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc ]
{
}

ClassMethod GetOPOEOrderInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    /// 统一整理时间
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    s AdmTypeStr="O^E"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    q:AdmId="9620915"
				s OrderRowid=$o(^OEORD(0,"Adm",AdmId,0))
				continue:OrderRowid=""
				s ItemSub=0
				for{
					s ItemSub = $o(^OEORD(OrderRowid,"I",ItemSub))
					q:ItemSub=""
					s OneOEORIRowID=OrderRowid_"||"_ItemSub
					b ;01
					d OutOPOEOrderInfo
				}
			}
	    }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOPOEOrderInfo
	s OneItemObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetOrderInfo(AdmId,OneOEORIRowID)
	s PatientId=OneItemObj.PatientId
	s VisitSn=OneItemObj.VisitSn
	s VisitType=OneItemObj.VisitType
	s VisitCardNo=OneItemObj.PatientId
	s OutpatientNo=AdmId
	s VisitTimes=OneItemObj.VisitTimes
	s OrderSn=OneItemObj.OrderSn
	s RequestNo=OneItemObj.RequestNo
	s OrderGivenTime=OneItemObj.OrderGivenTime
	s VisitDeptCode=OneItemObj.VisitDeptCode
	s:VisitDeptCode'="" VisitDeptCode=$p(^CTPCP(VisitDeptCode,1),"^",1)
	s VisitDeptName=OneItemObj.VisitDeptName
	s OrderDeptCode=OneItemObj.OrderDeptCode
	s OrderDeptName=OneItemObj.OrderDeptName
	s OrderDoctorNo=OneItemObj.OrderDoctorNo
	s TechnicalTitle=OneItemObj.TechnicalTitle
	s JobTitle=OneItemObj.JobTitle
	s ExecutiveDeptCode=OneItemObj.ExecutiveDeptCode
	s ExecutiveDeptName=OneItemObj.ExecutiveDeptName
	s PrescriptionClassCode=OneItemObj.OrderClassCode
	s PrescriptionClassName=OneItemObj.OrderClassName
	s OrderClassCode=OneItemObj.OrderClassCode
	s OrderClassName=OneItemObj.OrderClassName
	s OrderItemCode=OneItemObj.OrderItemCode
	s OrderItemName=OneItemObj.OrderItemName
	s OrderGroupNo=OneItemObj.OrderGroupNo
	s Dose=OneItemObj.Dose
	s DoseUnit=OneItemObj.DoseUnit
	s Form=OneItemObj.Form
	s Spec=OneItemObj.Spec
	s FrequencyCode=OneItemObj.FrequencyCode
	s Frequency=OneItemObj.FrequencyName
	s AdministrationRoute=OneItemObj.AdministrationRoute
	s LiquidConfiguration=OneItemObj.LiquidConfiguration
	s InjectionType=OneItemObj.InjectionType
	s DrugOrder=OneItemObj.DrugOrder
	s DrugCompatibility=OneItemObj.DrugCompatibility
	s InfusionDuration=OneItemObj.InfusionDuration
	s DaysOfMedication=""
	s DurRowid=$p($g(^OEORD(OrderRowid,"I",ItemSub,2)),"^",6)	;疗程
	s:DurRowid'="" DaysOfMedication=$p($g(^PHCDU(DurRowid)),"^",3)
	s TotalDose=""
	s TotalDoseUnit=""
	s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ItemSub,2)),"^",3)	;每次给药剂量
	s PackQty=$p($g(^OEORD(OrderRowid,"I",ItemSub,9)),"^",4)	;发药数量
	s OrderPackUOMRowid=$p($g(^OEORD(OrderRowid,"I",ItemSub,"DHC")),"^",13)
	if (OrderPackUOMRowid="") s OrderPackUOMRowid=DoseUOMRowid	;发药数量单位
	s:PackQty="" PackQty="1"
	s NumOfOrders=PackQty
	s NumOfOrdersUnit=""
	s:OrderPackUOMRowid'="" OrderPackUOMRowid=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
	s OrderNote=OneItemObj.OrderNote
	s HerbalNote=OneItemObj.HerbalNote
	s DrugFlag=OneItemObj.DrugFlag
	s Manufac=OneItemObj.Manufac
	s TradeName=OneItemObj.TradeName
	s ExtendData1=OneItemObj.ExtendData1
	s ExtendData2=OneItemObj.ExtendData2
	s RecordStatus=OneItemObj.RecordStatus
	s YYID=OneItemObj.YYID
	s YYUPDATETIME=OneItemObj.YYUPDATETIME
	s YYCREATETIME=OneItemObj.YYCREATETIME
	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,OrderSn,RequestNo,OrderGivenTime,VisitDeptCode,VisitDeptName,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,ExecutiveDeptCode,ExecutiveDeptName,PrescriptionClassCode,PrescriptionClassName,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,Frequency,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,DaysOfMedication,TotalDose,TotalDoseUnit,NumOfOrders,NumOfOrdersUnit,OrderNote,HerbalNote,DrugFlag,Manufac,TradeName,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOPOEOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPOEOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPOEOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPOEOrderInfoExecute ]
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
	Quit $$$OK
}

/// --常规检验记录
/// B17-1 常规检验记录
/// patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,order_sn,request_no,order_given_time,visit_dept_code,visit_dept_name,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,executive_dept_code,executive_dept_name,prescription_class_code,prescription_class_name,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,days_of_medication,total_dose,total_dose_unit,num_of_orders,num_of_orders_unit,order_note,herbal_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,OrderSn,RequestNo,OrderGivenTime,VisitDeptCode,VisitDeptName,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,ExecutiveDeptCode,ExecutiveDeptName,PrescriptionClassCode,PrescriptionClassName,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,Frequency,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,DaysOfMedication,TotalDose,TotalDoseUnit,NumOfOrders,NumOfOrdersUnit,OrderNote,HerbalNote,DrugFlag,Manufac,TradeName,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.TumorReporting.ComQuery","GetLabOrderInfo","2019-10-01","2019-10-02")
/// CALL DHCDoc_Interface_TumorReporting.ComQuery_GetLabOrderInfo("2019-10-01","2019-10-02")
Query GetLabOrderInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,medical_record_no,inpatient_no,hospitalization_times,name,apply_no,order_sn,apply_datetime,specimen_type_code,specimen_type_name,specimen_code,lab_sn,test_datetime,test_method_code,test_method,lab_type,item_group_code,item_group_name,report_no,report_datetime,extend_data1,extend_data2,record_status,record_datetime,record_update_datetime") [ SqlProc ]
{
}

ClassMethod GetLabOrderInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    /// 统一整理时间
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    s AdmTypeStr="O^E"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    q:AdmId="9620915"
				s OrderRowid=$o(^OEORD(0,"Adm",AdmId,0))
				continue:OrderRowid=""
				s ItemSub=0
				for{
					s ItemSub = $o(^OEORD(OrderRowid,"I",ItemSub))
					q:ItemSub=""
					s OneOEORIRowID=OrderRowid_"||"_ItemSub
					s TraType=##Class(web.DHCAPPInterface).GetTraCatType("^^"_OneOEORIRowID)
					continue:TraType'="L"
					d OutLabOrderInfo
				}
			}
	    }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLabOrderInfo
	s OneItemObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetLabOrderInfo(AdmId,OneOEORIRowID)
	s PatientId=OneItemObj.PatientId
	s VisitSn=OneItemObj.VisitSn
	s VisitType=OneItemObj.VisitType
	s VisitCardNo=OneItemObj.VisitCardNo
	s OutpatientNo=OneItemObj.OutpatientNo
	s VisitTimes=OneItemObj.VisitTimes
	s MedicalRecordNo=OneItemObj.MedicalRecordNo
	s InpatientNo=OneItemObj.InpatientNo
	s HospitalizationTimes=OneItemObj.HospitalizationTimes
	s Name=OneItemObj.Name
	s ApplyNo=OneItemObj.ApplyNo
	s OrderSn=OneItemObj.OrderSn
	s ApplyDatetime=OneItemObj.ApplyDatetime
	s SpecimenTypeCode=OneItemObj.SpecimenTypeCode
	s SpecimenTypeName=OneItemObj.SpecimenTypeName
	s SpecimenCode=OneItemObj.SpecimenCode
	s LabSn=OneItemObj.LabSn
	s TestDatetime=OneItemObj.TestDatetime
	s TestMethodCode=OneItemObj.TestMethodCode
	s TestMethod=OneItemObj.TestMethod
	s LabType=OneItemObj.LabType
	s ItemGroupCode=OneItemObj.ItemGroupCode
	s ItemGroupName=OneItemObj.ItemGroupName
	s ReportNo=OneItemObj.ReportNo
	s ReportDatetime=OneItemObj.ReportDatetime
	s ExtendData1=OneItemObj.ExtendData1
	s ExtendData2=OneItemObj.ExtendData2
	s RecordStatus=OneItemObj.RecordStatus
	s RecordDatetime=OneItemObj.RecordDatetime
	s RecordUpdateDatetime=OneItemObj.RecordUpdateDatetime
	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,MedicalRecordNo,InpatientNo,HospitalizationTimes,Name,ApplyNo,OrderSn,ApplyDatetime,SpecimenTypeCode,SpecimenTypeName,SpecimenCode,LabSn,TestDatetime,TestMethodCode,TestMethod,LabType,ItemGroupCode,ItemGroupName,ReportNo,ReportDatetime,ExtendData1,ExtendData2,RecordStatus,RecordDatetime,RecordUpdateDatetime) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLabOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLabOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabOrderInfoExecute ]
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
	Quit $$$OK
}

/// --常规检查记录
/// B16-1 常规检查记录
/// patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,order_sn,request_no,order_given_time,visit_dept_code,visit_dept_name,order_dept_code,order_dept_name,order_doctor_no,technical_title,job_title,executive_dept_code,executive_dept_name,prescription_class_code,prescription_class_name,order_class_code,order_class_name,order_item_code,order_item_name,order_group_no,dose,dose_unit,form,spec,frequency_code,frequency,administration_route,liquid_configuration,injection_type,drug_order,drug_compatibility,infusion_duration,days_of_medication,total_dose,total_dose_unit,num_of_orders,num_of_orders_unit,order_note,herbal_note,drug_flag,manufac,trade_name,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME
/// PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,OrderSn,RequestNo,OrderGivenTime,VisitDeptCode,VisitDeptName,OrderDeptCode,OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,ExecutiveDeptCode,ExecutiveDeptName,PrescriptionClassCode,PrescriptionClassName,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,Frequency,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,DaysOfMedication,TotalDose,TotalDoseUnit,NumOfOrders,NumOfOrdersUnit,OrderNote,HerbalNote,DrugFlag,Manufac,TradeName,ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.TumorReporting.ComQuery","GetLabOrderInfo","2019-10-01","2019-10-02")
/// CALL DHCDoc_Interface_TumorReporting.ComQuery_GetLabOrderInfo("2019-10-01","2019-10-02")
Query GetPacsOrderInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,medical_record_no,inpatient_no,hospitalization_times,name,apply_no,order_sn,apply_datetime,apply_dept_code,apply_dept_name,exam_sn,exam_datetime,exam_type,exam_item_type,exam_item_code,exam_item_name,exam_sites,report_no,report_datetime,report_dept_code,report_dept_name,exam_diag_description,exam_diag_conclusion,qualitive_description,extend_data2,record_status,record_datetime,record_update_datetime") [ SqlProc ]
{
}

ClassMethod GetPacsOrderInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;s:StartDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ;s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:StartDate="" SatarDate=+$h-1
    ;s:EndDate="" EndDate=+$h-1
    /// 统一整理时间
    Set:StartDate="" StartDate=$h-1
    Set:EndDate="" EndDate=$h-1
    Set:StartDate["-" StartDate=$ZDH(StartDate,3)
    Set:EndDate["-" EndDate=$ZDH(EndDate,3)
    
    s AdmTypeStr="O^E"
    for Date=StartDate:1:EndDate{
	    for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		    s OneAdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		    s AdmId=0
		    for {
			    s AdmId=$o(^PAADMi("NNType",OneAdmType,Date,AdmId))
			    q:AdmId=""
			    q:AdmId="9620915"
				s OrderRowid=$o(^OEORD(0,"Adm",AdmId,0))
				continue:OrderRowid=""
				s ItemSub=0
				for{
					s ItemSub = $o(^OEORD(OrderRowid,"I",ItemSub))
					q:ItemSub=""
					s OneOEORIRowID=OrderRowid_"||"_ItemSub
					s TraType=##Class(web.DHCAPPInterface).GetTraCatType("^^"_OneOEORIRowID)
					continue:TraType'="E"
					b ;01
					d OutPacsOrderInfo
				}
			}
	    }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPacsOrderInfo
	s OneItemObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPacsOrderInfo(AdmId,OneOEORIRowID)
	s PatientId=OneItemObj.PatientId
	s VisitSn=OneItemObj.VisitSn
	s VisitType=OneItemObj.VisitType
	s VisitCardNo=OneItemObj.VisitCardNo
	s OutpatientNo=OneItemObj.OutpatientNo
	s VisitTimes=OneItemObj.VisitTimes
	s MedicalRecordNo=OneItemObj.MedicalRecordNo
	s InpatientNo=OneItemObj.InpatientNo
	s HospitalizationTimes=OneItemObj.HospitalizationTimes
	s Name=OneItemObj.Name
	s ApplyNo=OneItemObj.ApplyNo
	s OrderSn=OneItemObj.OrderSn
	s ApplyDatetime=OneItemObj.ApplyDatetime
	s ApplyDeptCode=OneItemObj.ApplyDeptCode
	s ApplyDeptName=OneItemObj.ApplyDeptName
	s ExamSn=OneItemObj.ExamSn
	s ExamDatetime=OneItemObj.ExamDatetime
	s ExamType=OneItemObj.ExamType
	s ExamItemType=OneItemObj.ExamItemType
	s ExamItemCode=OneItemObj.ExamItemCode
	s ExamItemName=OneItemObj.ExamItemName
	s ExamSites=OneItemObj.ExamSites
	s ReportNo=OneItemObj.ReportNo
	s ReportDatetime=OneItemObj.ReportDatetime
	s ReportDeptCode=OneItemObj.ReportDeptCode
	s ReportDeptName=OneItemObj.ReportDeptName
	s ExamDiagDescription=OneItemObj.ExamDiagDescription
	s ExamDiagConclusion=OneItemObj.ExamDiagConclusion
	s QualitiveDescription=OneItemObj.QualitiveDescription
	s ExtendData2=OneItemObj.ExtendData2
	s RecordStatus=OneItemObj.RecordStatus
	s RecordDatetime=OneItemObj.RecordDatetime
	s RecordUpdateDatetime=OneItemObj.RecordUpdateDatetime
	set Data=$lb(PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,MedicalRecordNo,InpatientNo,HospitalizationTimes,ApplyNo,OrderSn,ApplyDatetime,ApplyDeptCode,ApplyDeptName,ExamSn,ExamDatetime,ExamType,ExamItemType,ExamItemCode,ExamItemName,ExamSites,ReportNo,ReportDeptCode,ReportDeptName,ExamDiagDescription,ExamDiagConclusion,QualitiveDescription ,ExtendData2,RecordStatus,RecordDatetime,RecordUpdateDatetime) 																																
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPacsOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPacsOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPacsOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPacsOrderInfoExecute ]
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
	Quit $$$OK
}

}
