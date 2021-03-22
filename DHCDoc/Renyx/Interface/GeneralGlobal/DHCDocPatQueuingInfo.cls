Class DHCDoc.Interface.GeneralGlobal.DHCDocPatQueuingInfo Extends %RegisteredObject
{
/// /s MenuBGColor="#017BCE"
/// /	s MenuSelectedBGColor="#0063A7"
/// /	s LeftMenuBGColor="#0063A7"
/// zw $replace($replace($zts,",",""),".","") 时间戳
/// w ##Class(DHCDoc.Interface.GeneralGlobal.DHCDocPatQueuingInfo).GetPatientQueuingInfo("{""patientIdTypeId"" : ""3"",""patientId"" : ""110111188605069875"",""patientName"" : ""张三""}")
ClassMethod GetPatientQueuingInfo(InputStr As %String)
{
	s $ztrap="GetPatientQueuingInfoErr"
	s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	//s PatientIdTypeId=InputObj.get("patientIdTypeId")
	s PatientIdTypeId=InputObj.patientIdTypeId
	s PatientId=InputObj.patientId
	s PatientName=InputObj.patientName
	s DHCCardDr=$o(^DHCCARDi("CF",0,"CardTypeNo",PatientIdTypeId,PatientId,0))
	if DHCCardDr="" q "-1"
	s PatId=$p($g(^DHCCARD("CF",DHCCardDr)),"^",4)
	q:PatId="" "-1"
	s PatName=$p($g(^PAPER(PatId,"ALL")),"^",1)
	q:PatName'=PatientName "-1"
	s AdmTypeStr="O^E"
	//s OutputObj={}
	s DataList=[]
	for i=1:1:$l(AdmTypeStr){
		s AdmType=$p($g(AdmTypeStr),"^",i)
		s AdmDr=0
		for{
			s AdmDr=$o(^PAPERdr(PatId,"ADM",AdmType,AdmDr))
			q:AdmDr=""
			s AdmDate=$p($g(^PAADM(AdmDr)),"^",6)
			continue:AdmDate'=+$h
			continue:VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
			continue:VisitStatus'="A"
			d DataList.%Push(..GetAdmInfo(AdmDr))
		}
	}
	s OutputObj={}
	if (DataList.%Size()>0){
		s OutputObj=..GetOutPutObj("0","获取数据成功")
		s OutputObj.data=DataList
	}else{
		s OutputObj=..GetOutPutObj("1","获取数据失败")
	}
	q OutputObj
GetPatientQueuingInfoErr
	q ..GetOutPutObj("1","获取数据失败")
}

/// w ##Class(DHCDoc.Interface.GeneralGlobal.DHCDocPatQueuingInfo).GetQueuingInfoByIdList("{""queuingIdList"" : [""100001"",""100002""]}")
ClassMethod GetQueuingInfoByIdList(InputStr As %String)
{
	s $ztrap="GetQueuingInfoByIdListErr"
	s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	//s PatientIdTypeId=InputObj.get("patientIdTypeId")
	s QueuingIdList=InputObj.queuingIdList
	//s OutputObj={}
	s DataList=[]
	for Num =0:1:(QueuingIdList.%Size()-1){
		s QueueDr=QueuingIdList.%Get(Num)
		continue:'$d(^User.DHCQueueD(QueueDr))
		s AdmDr=$List(^User.DHCQueueD(QueueDr),11)
		//Set QueObj=##Class(User.DHCQueue).%OpenId(QueueDr)
		//continue:'$IsObject(QueObj)
		d DataList.%Push(..GetAdmInfo(AdmDr))
	}
	if (DataList.%Size()>0){
		s OutputObj=..GetOutPutObj("0","获取数据成功")
		s OutputObj.data=DataList
	}else{
		s OutputObj=..GetOutPutObj("1","获取数据失败")
	}
	q OutputObj
GetQueuingInfoByIdListErr
	q ..GetOutPutObj("1","获取数据失败")
}

/// d ##Class(DHCDoc.Interface.GeneralGlobal.DHCDocPatQueuingInfo).UpdateQueuingInfo()
ClassMethod UpdateQueuingInfo(QueDrStr As %String)
{
	q:(QueDrStr="")!(QueDrStr="undefined") ""
	s OutPutObj={}
	s OutPutObj.queuingIdList=[]
	for i=1:1:$l(QueDrStr,"^"){
		continue:$p(QueDrStr,"^",i)=""
		d OutPutObj.queuingIdList.%Push($p(QueDrStr,"^",i))
	}
	//w OutPutObj.%ToJSON()
	s RetStr=""
	s RetObj=##class(%DynamicObject).%FromJSON(RetStr)
	s RetCode=RetObj.responseCode
	s RetDesc=RetObj.responseText
	s RetQueuingIdList=RetObj.queuingIdList
	s RetQueDr=""
	for Num =0:1:(RetQueuingIdList.%Size()-1){
		continue:RetQueuingIdList.%Get(Num)=""
		if RetQueDr="" s RetQueDr=RetQueuingIdList.%Get(Num)
		else  s RetQueDr=RetQueDr_"^"_RetQueuingIdList.%Get(Num)
	}
	q RetStr
}

ClassMethod GetOutPutObj(ResponseCode As %String, ResponseTest As %String)
{
	s OutPutObj={}
	/// responseCode int 是 响应返回码（0 成功、1 失败）0 0
	s OutPutObj.responseCode=ResponseCode
	/// responseText string 否 相应返回码描述 获取数据成功
	s OutPutObj.responseText=ResponseTest
	/// responseTimestamp long 否 服务器当前时间戳（从1970-01-01 00:00:00 1548656999970到当前时间的毫秒数）
	s OutPutObj.responseCode=..GetTimeStamp()
	s OutPutObj.data=" "
	q OutPutObj
}

/// w ##Class(DHCDoc.Interface.GeneralGlobal.DHCDocPatQueuingInfo).GetTimeStamp()
ClassMethod GetTimeStamp()
{
	s TimeStamp=$zts
	s Day=+$p($zts,",",1)-+$zdh("1970-1-1",3)
	s TimeStamp=((Day*24*3600)+$p($zts,",",2))*1000
	q TimeStamp
}

ClassMethod GetAdmInfo(AdmDr As %String)
{
	s AdmObj={}
	/// queuingId string 是 排队记录 Id（院内系统）100001
	s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmDr,0))
	//q:QueRowId=""
	Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	Quit:'$IsObject(QueObj) AdmObj
	Set StatusName=QueObj.QueStateDr.PersName
	Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="等候呼叫")) AdmObj
	s AdmObj.queuingId=DHCQueueDr
	/// positionInQueue int 是 排队序号 11
	s AdmObj.positionInQueue=QueObj.QueNo
	/// positionInService Int 是 当前序号 6
	s AdmObj.positionInService=QueObj.QueNo
	/// queueType string 否 排队类别（如：A类/B 类）B 类
	s AdmObj.queueType=""
	/// queueStatusId int 是 排队状态（1 和 2作为预留，暂不使用，3 已报到、4待服务、5 服务中、6 已过号）4
	s AdmObj.queueStatusId=""
	if (StatusName="等候")!(StatusName="复诊") s AdmObj.queueStatusId=3
	if (StatusName="过号") s AdmObj.queueStatusId=6
	if (StatusName="等候呼叫") s AdmObj.queueStatusId=4
	if (StatusName="正在呼叫") s AdmObj.queueStatusId=5
	/// checkInDate string 是 报到日期（格式yyyy-MM-dd）2020-09-23
	s AdmObj.checkInDate=""
	/// checkInTime string 是 报到时间（格式hh:mm:ss，24 小时制）08:00:00
	s AdmObj.checkInTime=""
	if (StatusName="等候")!(StatusName="复诊"){
		s AdmObj.checkInDate=$zd(QueObj.QueStateDate,3)
		s AdmObj.checkInTime=$zd(QueObj.QueStateTime,2)
	}
	/// outpatientVisitId string 是 门诊号（或就诊号，院内系统）000001
	s AdmObj.outpatientVisitId=AdmDr
	/// departmentId string 是 挂号科室 Id（院内系统）101
	s AdmObj.departmentId=""
	Set LocDr=$P($g(^PAADM(AdmDr)),"^",4)
	s:LocDr'="" AdmObj.departmentId=$P($g(^CTLOC(LocDr)),"^",1)
	/// departmentName string 是 科室名称 外科
	s AdmObj.departmentName=""
	s:LocDr'="" AdmObj.departmentId=$P($g(^CTLOC(LocDr)),"^",2)
	/// departmentLocation string 否 科室位置 门诊三层
	s AdmObj.departmentLocation=""
	/// providerId string 是 挂号医生 Id（院内系统）1001
	s AdmObj.patientIdTypeId=""
	Set DoctorDr=$P($g(^PAADM(AdmDr)),"^",9)
	s:DoctorDr'="" AdmObj.patientIdTypeId=$P($g(^CTPCP(Doctor,1)),"^",1)
	/// providerName string 是 医生姓名 刘晶晶
	s AdmObj.providerName=""
	s:DoctorDr'="" AdmObj.providerName=$P($g(^CTPCP(Doctor,1)),"^",2)
	Set PatientID=$P(^PAADM(AdmDr),"^",1)
	/// patientName string 是 患者姓名 张三
	s AdmObj.patientName=$P(^PAPER(PatientID,"ALL"),"^",1)
	/// patientMobileNumber string 是 患者手机号 18811112222
	s AdmObj.patientMobileNumber=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	/// patientIdTypeId int 是 患者 Id 类型（1、2、4 和 5 预留，暂不使用，3 身份证号,63电子健康卡）
	s AdmObj.patientIdTypeId="1"
	/// patientId string 是 患者 Id 110111188605069875
	Set AdmObj.patientId=$P(^PAPER(PatientID,"PAT",1),"^",1)
	/// estimatedServiceTime string 否 预计就诊时间（格式 hh:mm:ss，24小时制）14:00:00
	s AdmObj.estimatedServiceTime=""
	/// updateDate string 否 记录更新日期（格式 yyyy-MM-dd）2018-05-01
	s AdmObj.updateDate=""
	/// updateTime string 否 记录更新时间（格式 hh:mm:ss，24小时制）10:00:00
	s AdmObj.updateDate=""
    d QueObj.%Close()
	q AdmObj
}
}

