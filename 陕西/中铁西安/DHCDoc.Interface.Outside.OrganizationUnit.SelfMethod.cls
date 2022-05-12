Class DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod Extends %RegisteredObject
{

/// .获取某时间段的所有就医(门急诊,住院等)列表信息
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetVisitList("{""startDate"": ""2022-05-11"",""endDate"": ""2022-05-13"",""providerId"": ""55"",""visitTypeIdList"": [3,5]}")
ClassMethod GetVisitList(JsonInput As %String, ExtUserID As %String = "")
{
    s InputObj=##Class(%DynamicObject).%FromJSON(JsonInput)
    ; startDate string 是 开始日期（格式:yyyy-MM-dd）2020-11-26
    s StartDate=InputObj.%Get("startDate")
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    ; endDate string 是 结束日期 (格式: yyyy-MM-dd)2020-11-30
    s EndDate=InputObj.%Get("endDate")
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ; providerId string 是 医生 id 15462
    s ProviderId=InputObj.%Get("providerId")
    ; visitTypeIdList array 是 问诊类型 id 列表 [3,5] 3门诊、4住院、5急诊
    s VisitTypeIdList=InputObj.%Get("visitTypeIdList")
    s AdmTypeStr=""
    for VisitTypeInd=0:1:(VisitTypeIdList.%Size()-1){
	    s AdmType=$case(VisitTypeIdList.%Get(VisitTypeInd),"3":"O","4":"I","5":"E",:"")
	    continue:AdmType=""
		s AdmTypeStr=AdmTypeStr_" "_AdmType
    }
    s DataObj=##class(%DynamicArray).%New()
    s AdmTypeStr=AdmTypeStr_" "
    for AdmDate=StartDate:1:EndDate{
	    s AdmDr=0
		for {
			s AdmDr=$o(^PAADMi("NNDoc",ProviderId,AdmDate,AdmDr))
			q:AdmDr=""
			s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
			b ;;;2
			continue:AdmTypeStr'[AdmType
			s VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
			//continue:VisitStatus'="A"
			s OneAdmObj=##class(%DynamicObject).%New()
			d GetOneAdmInfo
			d DataObj.%Push(OneAdmObj)
		}
    }
    s OutputObj=##class(%DynamicObject).%New()
    ; responseCode int 是 响应返回码（0 成功、1失败）0 0
    d OutputObj.%Set("responseCode","0")
    ; responseText string 否 相应返回码描述 获取数据成功
    d OutputObj.%Set("responseText","获取数据成功")
    ; responseTextForUser string 否 用户提示信息 获取就医列表信息成功
    d OutputObj.%Set("responseTextForUser","")
    ; responseTimestamp long 否 服务器当前时间戳（从1970-01-01 00:00:00到当前时间的毫秒数）1548656999970
    d OutputObj.%Set("responseTimestamp","")
    d OutputObj.%Set("data",DataObj)
    q OutputObj.%ToJSON()
GetOneAdmInfo
	; patientIdTypeId int 是 患者 Id 类型（1 和 2 预留，暂不使用，3 身份证号,4-电子健康卡，5-就诊卡）3 3
	d OneAdmObj.%Set("patientIdTypeId","3")
	; patientId string 是 患者 Id 110111188605069875
	s PatientId=$p($g(^PAADM(AdmDr)),"^",1)
	d OneAdmObj.%Set("patientId",PatientId)
	; patientName string 是 患者名称 张三
	d OneAdmObj.%Set("patientName",$p(^PAPER(PatientId,"ALL"),"^",1)) 
	; patientMobileNumber string 否 患者手机号 18210129293
	d OneAdmObj.%Set("patientMobileNumber",$p(^PAPER(PatientId,"PER",1),"^",11))
	; patientAge string 否 患者年龄 2846
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmDr)
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientId,"",AdmHospitalId)
	d OneAdmObj.%Set("patientId",OneAdmObj)
	; patientGenderTypeId int 是 患者性别（1 未知、2 其它、3 女、4 男）4
	set Sex=""
	set SexCode=$p(^PAPER(PatientId,"ALL"),"^",7)
	i SexCode'="" set Sex=$p($g(^CT("SEX",SexCode)),"^",2)
	d OneAdmObj.%Set("patientGenderTypeId",$case(Sex,"男":4,"女":3,:1))
	; visitId string 是 就医号(院内系统 Id) 1809
	d OneAdmObj.%Set("visitId",AdmDr)
	; visitTypeId int 是 就医类型(1 和 2 预留,暂不使用,3 门诊,4 住院,5 急诊)3
	d OneAdmObj.%Set("visitTypeId",$case(AdmType,"O":"3","I":"4","E":"5",:""))
	; visitStatusId int 是 就医状态(101 已申请预约, 102 已预约, 103 已挂号, 104 病人已离开, 105 已取消问诊, 106 问诊未开始, 107 问诊已开始, 108 问诊已结束, 201 已申请入院, 202 入院申请已核准, 203 已入院, 204 已申请出院 , 205 出院申请已核准, 206 已出院, 207 已取消住院)108
	; 约束(A:正常|C:退号、退院|D:出院|P:预住院)
	if (VisitStatus="I"){
		
		s VisitStatusId=$case(VisitStatus,"A":"203","C":"204",:"")
	}else{
		s VisitStatusId=$case(VisitStatus,"A":"103","C":"105",:"")
	}
	
	d OneAdmObj.%Set("visitStatusId",VisitStatusId)
	; isSubsequentVisit boolean是 是否复诊(false 否 , true 是)true
	s FirstOrReadmis=$p($g(^PAADM(AdmDr)),"^",72)
	s AdmReadm=$p($g(^PAADM(AdmDr)),"^",56)
	s isSubsequentVisit="false"
	s:(FirstOrReadmis="R")!(AdmReadm="R") isSubsequentVisit="true"
	d OneAdmObj.%Set("isSubsequentVisit",isSubsequentVisit)
	; initialVisitId string 否 首诊 ID（如果isSubsequentVisit=true，则该字段不能为空）1803
	s initialVisitId="false"
	s:(FirstOrReadmis="F") initialVisitId="true"
	d OneAdmObj.%Set("initialVisitId",initialVisitId)
	; queuingId string 否 排队号（如果类型为门、急诊且状态为已预约或者已挂号，则该字段不能为空）100001
	d OneAdmObj.%Set("queuingId","")
	; bedId string 否 床位号（如果类型为住院，则该字段不能为空）0024
	s CurrentRoomDR=$p($g(^PAADM(AdmDr)),"^",69)
	s RoomCode=""
	s:CurrentRoomDR'="" RoomCode=$p($g(^PAROOM(CurrentRoomDR)),"^",1)
	s CurrentBedDR=$p($g(^PAADM(AdmDr)),"^",73)
	s BedCode="",BedName=""
	s:CurrentBedDR'="" BedCode=$p($g(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2))),"^",1),BedName=$p($g(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2))),"^",2)
	d OneAdmObj.%Set("bedId",BedCode)
	; bedName string 否 床位名称（如果类型为住院，则该字段不能为空）4 号床位
	d OneAdmObj.%Set("bedName",BedName)
	; wardId string 否 病区号（如果类型为住院，则该字段不能为空）00347
	s CurrentWardDR=$p($g(^PAADM(AdmDr)),"^",70)
	s WardCode="",WardName=""
	s:CurrentWardDR'="" WardCode=$p($g(^PAWARD(CurrentWardDR)),"^",1)
	s:CurrentWardDR'="" WardName=$p($g(^PAWARD(CurrentWardDR)),"^",2)
	d OneAdmObj.%Set("wardId",WardCode)
	; wardName string 否 病区名称（如果类型为住院，则该字段不能为空）3 号病区
	d OneAdmObj.%Set("wardName",WardName)
	; visitDepartmentId string 是 科室 Id（院内系统） 101
	
	s AdmLocDr=$p($g(^PAADM(AdmDr)),"^",4)
    s AdmLocCode=$p($g(^CTLOC(AdmLocDr)),"^",1)
    s AdmLocDesc=$p($g(^CTLOC(AdmLocDr)),"^",2)
	d OneAdmObj.%Set("visitDepartmentId",AdmLocCode)
	; visitDepartmentName string 是 科室名称（院内系统） 内分泌科
	d OneAdmObj.%Set("visitDepartmentName",AdmLocDesc)
	; startDate string 是 开始日期（格式:yyyyMM-dd）2020-11-26
	s AdmDate=$p($g(^PAADM(AdmDr)),"^",6)
	d OneAdmObj.%Set("patientId",##class(websys.Conversions).DateLogicalToHtml(AdmDate))
	; startTime string 是 开始时间( 格式: HH:mm:ss, 24 小时制)16:00:00

	s AdmTime=$p($g(^PAADM(AdmDr)),"^",7)
	d OneAdmObj.%Set("patientId",##class(websys.Conversions).TimeLogicalToHtml(AdmTime))
	; endDate string 否 结束日期 ( 格式: yyyy-MM-dd)2020-11-30
	d OneAdmObj.%Set("patientId","")
	; endTime string 否 结束时间 ( 格式: HH:mm:ss, 24 小时制)18:30:31
	d OneAdmObj.%Set("patientId","")
	; primaryVisitReason string 是 主要主诉信息 咽痛，发热 2 天
	d OneAdmObj.%Set("primaryVisitReason","")
	; providerList array 是 医护人员列表，详见 providerList 医生子节点
	s ProviderList=##class(%DynamicArray).%New()
	s ProviderObj=##class(%DynamicObject).%New()
	; providerId string 是 医生 id 15462
	s AdmDocDR=$p($g(^PAADM(AdmDr)),"^",9)
    s AdmDocCode=$p($g(^CTPCP(AdmDocDR,1)),"^",1)
	d ProviderObj.%Set("providerId",AdmDocCode)
	; isPrimaryProvider boolean 是 是否是主治医生(false 否,true 是)true
	d ProviderObj.%Set("isPrimaryProvider","true")
	; providerName string 是 医生名字 张一生
	s AdmDocName=$p($g(^CTPCP(AdmDocDR,1)),"^",2)
	d ProviderObj.%Set("providerName",AdmDocName)
	d ProviderList.%Push(ProviderObj)
	d OneAdmObj.%Set("providerList",ProviderList)
	; diagnosisList array 是 诊断列表，详见 diagnosisList 诊断列表子节点
	s DiagnosisList=##class(%DynamicArray).%New()
	d GetDiagnosisList
	d OneAdmObj.%Set("diagnosisList",DiagnosisList)
	; appointmentId string 否 关于此次就医相关的预约Id 号(院内系统)100001
	d OneAdmObj.%Set("appointmentId","")
	; isChartingCompleted boolean是 就医记录是否已经完成( false 否, true 是)true
	d OneAdmObj.%Set("isChartingCompleted","true")
	; isChartingAllowed boolean是 是否允许录入就医记录，如诊断，医嘱等数据（如果isChartingCompleted=true，则此值为 false；如果isChartingCompleted=ffalse48alse，则此值可为 true或 false）
	d OneAdmObj.%Set("isChartingAllowed","false")
	q
GetDiagnosisList
	s MRAdmRowid=$P(^PAADM(AdmDr),"^",61)
	Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(MRAdmRowid)
		If 'Status Quit
		While (rset.Next()) {
			s MRDesc=rset.Data("MRDIAICDCodeDRDesc")
			s:MRDesc="" MRDesc=rset.Data("MRDIADesc")
			s MRCIDCode=rset.Data("MRDIAICDCodeDRCode")
			s DiagnosisObj=##class(%DynamicObject).%New()
			; ICD10Code string 否 诊断代码（符合ICD10 标准）A18.001
			d DiagnosisObj.%Set("ICD10Code",MRCIDCode)
			; diagnosisName string 是 诊断中文名称 骨结核
			d DiagnosisObj.%Set("diagnosisName",MRDesc)
			d DiagnosisList.%Push(DiagnosisObj)
		}
	}
	q
}

}
