Class DHCDoc.Interface.Hemodialysis.ComInterface Extends %RegisteredObject
{

/// w ##class(DHCDoc.Interface.Hemodialysis.ComInterface).GetPatInfo("0000000004")
ClassMethod GetPatInfo(PatientNo As %String)
{
	s OutPatInfoObj=##class(%DynamicObject).%New()
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	q:PatientID="" OutPatInfoObj.%ToJSON()
	; PATIENT_ID 患者 ID（主索引） 关键 VARCHAR2
	s PatId=##class(web.PAPatMas).GetRegistration(PatientID)
	d OutPatInfoObj.%Set("PATIENT_ID",PatId)
	; NAME 姓名 关键 VARCHAR2
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	d OutPatInfoObj.%Set("NAME",Name)
	; SEX_CODE 性别（M\F） 关键 VARCHAR2
	s PatSexDR=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	s SexName=""
	s:PatSexDR'="" SexName=$p(^CT("SEX",PatSexDR),"^",2)
	s SexName=$case(SexName,"男":"M",:"F")
	d OutPatInfoObj.%Set("SEX_CODE",SexName)
	; BIRTHDAY 出生日 关键 DATE
	s Birth=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s BirthDate=$zd(Birth,3)
	d OutPatInfoObj.%Set("BIRTHDAY",BirthDate)
	; MCARD_NO 社会保险证号码 重要 VARCHAR2
	s MCardNo=""
	d OutPatInfoObj.%Set("MCARD_NO",MCardNo)
	; IDENNO 身份证号 关键 VARCHAR2
	s IDCardNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	d OutPatInfoObj.%Set("IDENNO",IDCardNo)
	; ADDRESS 籍贯/通讯地址 关键 VARCHAR2
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 
	d OutPatInfoObj.%Set("ADDRESS",Address)
	; LINKMAN_NAME 联系人 关键 VARCHAR2
	s LinkManName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
	d OutPatInfoObj.%Set("LINKMAN_NAME",LinkManName)
	; LINKMAN_TEL 联系人电话 关键 VARCHAR2
	s LinkManTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	d OutPatInfoObj.%Set("LINKMAN_TEL",LinkManTel)
	; HOSPITAL_ID 医院 ID 关键 VARCHAR2
	; "PER",5"^"41
	s HospitalId=$p($g(^PAPER(PatientID,"PER",5)),"^",41)
	s HospitalCode=""
	s:HospitalId'="" HospitalCode=$p($g(^CT("HOSP",HospitalId)),"^",1)
	d OutPatInfoObj.%Set("HOSPITAL_ID",HospitalCode)
	q OutPatInfoObj.%ToJSON()
}

/// w ##class(DHCDoc.Interface.Hemodialysis.ComInterface).CheckPatInHospital("0000000004")
ClassMethod CheckPatInHospital(PatientNo As %String)
{
	s CheckPatInHospObj=##class(%DynamicObject).%New()
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	q:PatientID="" CheckPatInHospObj.%ToJSON()
	; PATIENT_ID 患者 ID（主索引） 关键 VARCHAR2
	s PatId=##class(web.PAPatMas).GetRegistration(PatientID)
	d CheckPatInHospObj.%Set("PATIENT_ID",PatId)
	; NAME 患者姓名 关键 VARCHAR2
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	d CheckPatInHospObj.%Set("NAME",Name)
	; ISINPATIENT 当前是否住院（1：是，0：否） 关键 VARCHAR2
	s IsInPatient=##class(web.DHCDocOrderCommon).CheckPatInIPAdmission(PatientID)
	d CheckPatInHospObj.%Set("ISINPATIENT",""_IsInPatient)
	; INPATIENT_DEPT 住院科室名称（若当前不是住院状态，则返回空值）关键VARCHAR2
	s InPatientDept="",InPatientDeptCode=""
	if (IsInPatient="1"){
		s LastAdmId=..GetLastAdmId(PatientID,"I")
		if (LastAdmId'=""){
			s DeptCodeDR=$p($g(^PAADM(LastAdmId)),"^",4)
			s:DeptCodeDR'="" InPatientDept=$p($g(^CTLOC(DeptCodeDR)),"^",2)
			s:DeptCodeDR'="" InPatientDeptCode=$p($g(^CTLOC(DeptCodeDR)),"^",1)
		}
	}
	d CheckPatInHospObj.%Set("INPATIENT_DEPT",InPatientDept)
	; INPATIENT_DEPT_CODE 住院科室名代码（若当前不是住院状态，则返回空值）关键VARCHAR2
	d CheckPatInHospObj.%Set("INPATIENT_DEPT_CODE",InPatientDeptCode)
	; HOSPITAL_ID 医院 ID 关键 VARCHAR2
	s HospitalId=$p($g(^PAPER(PatientID,"PER",5)),"^",41)
	s HospitalCode=""
	s:HospitalId'="" HospitalCode=$p($g(^CT("HOSP",HospitalId)),"^",1)
	d CheckPatInHospObj.%Set("HOSPITAL_ID",HospitalCode)
	q CheckPatInHospObj.%ToJSON()
}

/// w ##class(DHCDoc.Interface.Hemodialysis.ComInterface).GetAdmList("0000000004")
ClassMethod GetAdmList(PatientNo As %String)
{
	s GetAdmListObj=##class(%DynamicObject).%New()
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	q:PatientID="" GetAdmListObj.%ToJSON()
	// ^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	s AdmInfoList=[] //##class(%ArrayOfDataTypes).%New()
	s AdmTypeStr="O^E^I"
	for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
		s AdmType=$p(AdmTypeStr,"^",AdmTypeInd)
		s AdmId =0
		for{
			s AdmId=$o(^PAPERdr(PatientID,"ADM",AdmType,AdmId))
			q:AdmId=""
			s OneAdmObj=##class(%DynamicObject).%New()
			; REGEIST_NO 就诊号 关键 VARCHAR2
			d OneAdmObj.%Set("REGEIST_NO",AdmId)
			; REGEIST_TYPE 就诊类型（0：门诊 1：住院 2：其他） 关键 VARCHAR2
			s AdmTypeDesc=$case(AdmType,"O":"门诊","I":"住院",:"其他")
			d OneAdmObj.%Set("REGEIST_TYPE",AdmTypeDesc)
			; REGEIST_DATE 注册时间 关键 DATE
			s CreateDate=$p($g(^PAADM(AdmId)),"^",41)
			s CreateTime=$p($g(^PAADM(AdmId)),"^",42)
			d OneAdmObj.%Set("REGEIST_DATE",$zd(CreateDate,3)_" "_$zd(CreateTime,2))
			; REGEIST_DEPT 挂号/住院科室 关键 VARCHAR2
			s DeptCodeDR=$p($g(^PAADM(AdmId)),"^",4)
			s PatientDept=""
			s:DeptCodeDR'="" PatientDept=$p($g(^CTLOC(DeptCodeDR)),"^",2)
			d OneAdmObj.%Set("REGEIST_DEPT",PatientDept)
			d AdmInfoList.%Push(OneAdmObj.%ToJSON())
		}
	}
	d GetAdmListObj.%Set("AdmInfoList",AdmInfoList)
	q GetAdmListObj.%ToJSON()
}

ClassMethod GetLastAdmId(PatId As %String, AdmType As %String)
{
	s RetAdmId=""
	s AdmId=0
	for{
		s AdmId=$o(^PAADMi("PAADM_Type",AdmType,AdmId),-1)
		q:(AdmId="")!(RetAdmId'="")
		s VisitStatus=$p($g(^PAADM(AdmId)),"^",20)
		continue:VisitStatus'="A"
		s RetAdmId=AdmId
	}
	q RetAdmId
}

}
