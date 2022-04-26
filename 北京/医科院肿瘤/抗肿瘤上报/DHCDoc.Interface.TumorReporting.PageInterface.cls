Class DHCDoc.Interface.TumorReporting.PageInterface Extends %RegisteredObject
{

/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).PushInterfaceInfoCom("CS")
ClassMethod PushInterfaceInfoCom(type As %String) As %String
{
	q:(type="") -1
	s (IP,Port,appKey,url)=""

	i ($ZCONVERT(type,"U")="ZS") d
	.s IP="16.22.26.77"
	.s Port = "30103"   ;正式端口
	.s appKey="ajNLOHF3dERoMmhob1FNSi9ZTFpJUT09"
	.s url="http://16.22.26.77:30103/ngdoctor/dss/rest/data/recv"
	e  d
	.s IP="16.22.26.77"
	.s Port = "30105"   ;测试端口
	.s appKey="ajNLOHF3dERoMmhob1FNSi9ZTFpJUT09"
	.s url="http://16.22.26.77:30105/ngdoctor/dss/rest/data/recv"
	q IP_"^"_Port_"^"_appKey_"^"_url
}

/// OperateType 操作类型*（Insert:保存诊断,Delete:删除诊断)
/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).PushDiagInfoCom("Insert","12325875","21061","207","12325875||7^12325875||8")
ClassMethod PushDiagInfoCom(OperateType As %String, EpisodeID As %String, UserId As %String, LocId As %String, DiagItemRowStr As %String)
{
	s ^TempRen("PushDiagInfoCom")=$lb(OperateType,EpisodeID,UserId,LocId,DiagItemRowStr)
	s $ZTRAP="PushDiagInfoComErr"
	s interfacestr=##class(DHCDoc.Interface.TumorReporting.PageInterface).PushInterfaceInfoCom("CS")
	q:(interfacestr=-1) "0"
    s strRes = "1",loccode="",locdr="",flag=""
	s locdr=LocId ;$g(%session.Data("LOGON.CTLOCID"))
	s:locdr'="" loccode=$p($g(^CTLOC(locdr)),"^",1)
	s:loccode'="" flag=##class(web.DHCDocCTCommon).GetSet("CTLOCYYKJCONTROL",loccode,"",2) ;权限配置 注意没有配置科室返回空值
	s:flag'="" flag=$$ALPHAUP^SSUTIL4(flag)
	q:(flag'="Y") strRes
    
	/*
	s request = ##class(%Net.HttpRequest).%New()
	s request.Timeout = 10
	s request.Server = $p(interfacestr,"^",1)
	;s request.Server = "16.22.26.79"  ;已作废
	s request.Port = $p(interfacestr,"^",2)	;"80"
	//s request.ContentType="text/html; charset=UTF-8"
	s request.ContentType="application/json"
	do request.SetHeader("appKey",$p(interfacestr,"^",3))
	;do request.SetHeader("apiCode","A0000001")
	//编码格式
	s request.ContentCharset = "UTF-8" 
	s url=$p(interfacestr,"^",4)	;"http://16.22.26.77/dss/rest/data/recv"
	*/
	s request = ##class(%Net.HttpRequest).%New()
	s request.Timeout = 10
	s request.Server = $p(interfacestr,"^",1)
	s request.Port = $p(interfacestr,"^",2)
	s request.ContentType="application/json"
	do request.SetHeader("appKey",$p(interfacestr,"^",3))
	//编码格式
	s request.ContentCharset = "UTF-8" 
	s url=$p(interfacestr,"^",4)
	
    s strData=..GetDiagInfoCom(OperateType,EpisodeID,UserId,LocId,DiagItemRowStr)
    d request.EntityBody.Write(strData)
    s flg=request.Post(url)
	if $system.Status.IsError(flg) {
		s Error = $system.Status.GetErrorText(flg)
		if (Error["#6059")
		{
			 s Error = "网络异常。"_Error
		}
		s strRes = "0"
		q strRes
	}
	q strRes
PushDiagInfoComErr
	s $ZTRAP=""
	q "0"
}

ClassMethod GetDiagInfoCom(OperateType As %String, EpisodeID As %String, UserId As %String, LocId As %String, DiagItemRowStr As %String)
{
	s OutputInfoObj=##class(%DynamicObject).%New()
	s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(EpisodeID)
	d OutputInfoObj.%Set("patientId",OneAdmObj.PatientId)
	d OutputInfoObj.%Set("visitSn",OneAdmObj.VisitSn)
	d OutputInfoObj.%Set("doctorId",$p($g(^SSU("SSUSR",UserId)),"^",1))
	d OutputInfoObj.%Set("deptId",$p($g(^CTLOC(LocId)),"^",22))
	s PatientInfo=##class(%DynamicObject).%New()
	d PatientInfo.%Set("gender",OneAdmObj.Gender)
	d PatientInfo.%Set("birthDate",OneAdmObj.DateOfBirth)
	
	;原传输婚姻状况字段，传输错误。以下通过就诊，更正数据。  20220406  zhx add
	;d PatientInfo.%Set("maritalStatus",OneAdmObj.AdmissionDiseaseName)
	s papmi=$p(^PAADM(EpisodeID),"^",1)
	s maritalID=$p(^PAPER(papmi,"PER",2),"^",3)
	s maritalStatus=$case(maritalID,"21":"10","22":"20","23":"21","24":"22","25":"23","26":"30","27":"40",:"90")
	;s maritalStatus=$p(^CT("MAR",maritalID),"^",2)	;为了明确传输婚姻状况，直接传婚姻状态。不采用字典Code转换推送给对方，防止字典对照错误。
	d PatientInfo.%Set("maritalStatus",maritalStatus)
	
	d PatientInfo.%Set("pregnancyStatus","")
	d OutputInfoObj.%Set("patientInfo",PatientInfo)
	s DataPacket=[]
	s OneDataPacket=##class(%DynamicObject).%New()
	d OneDataPacket.%Set("tableCode","b02_3")
	s Data=[]
	for DiagItemRowInd=1:1:$l(DiagItemRowStr,"^"){
		s OneMRDiagnosRow=$p(DiagItemRowStr,"^",DiagItemRowInd)
		continue:OneMRDiagnosRow=""
		s OneData=##class(%DynamicObject).%New()
		; patient_id	患者ID(与b02_1一定有值)	00931222	患者在本院的唯一标识	文本	varchar(100)	是
		d OneData.%Set("patient_id",OneAdmObj.PatientId)
		; visit_sn	单次就诊唯一标识号(与b02_1强关联)	00931222|4623477|1门诊	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|就诊类型、患者ID|门诊号|就诊次数|就诊类型。	文本	varchar(100)	是
		d OneData.%Set("visit_sn",EpisodeID)
		; visit_type	就诊类型	门诊	就诊类型：住院、门诊	文本	varchar(50)	是
		d OneData.%Set("visit_type",OneAdmObj.VisitType)
		; visit_card_no	就诊卡号	153898	患者在本医院就诊时使用的就诊卡号	文本	varchar(100)	是
		d OneData.%Set("visit_card_no",OneAdmObj.VisitCardNo)
		; medical_record_no	病案号	869881	患者在本院就诊时使用的病案号	文本	varchar(100)
		d OneData.%Set("medical_record_no",OneAdmObj.MedicalRecordNo)	
		; outpatient_no	门诊号	4623477	患者门诊就诊时对应的门诊号或者病历号	文本	varchar(100)	是（就诊类型为门诊）
		d OneData.%Set("outpatient_no",OneAdmObj.OutpatientNo)
		; visit_times	就诊次数	1	本院门诊次数	文本	varchar(50)	是（就诊类型为门诊）
		d OneData.%Set("visit_times",OneAdmObj.VisitTimes)
		; inpatient_no	住院号	4623477	患者住院号	文本	varchar(100)	是（就诊类型为住院）
		d OneData.%Set("inpatient_no",OneAdmObj.InpatientNo)
		; hospitalization_times	住院次数	1	住院次数	文本	varchar(50)	是（就诊类型为住院）
		d OneData.%Set("hospitalization_times",OneAdmObj.HospitalizationTimes)
		; name	患者姓名	张三	患者姓名	文本	varchar(100)	是
		d OneData.%Set("name",OneAdmObj.Name)
		; diag_id	诊断ID号	10431	诊断表唯一ID	文本	varchar(100)	是
		d OneData.%Set("diag_id",OneMRDiagnosRow)
		; diag_serial_number	诊断序号	1	诊断顺序号	文本	varchar(100)	是
		d OneData.%Set("diag_serial_number",$p(OneMRDiagnosRow,"^",2))
		; diag_type	诊断类型	出院诊断	门诊诊断、入院诊断、出院诊断、其他诊断	文本	varchar(100)	是
		s DiaTypeDr="",DiaType=""
		s SubRowid=$G(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2),"TYP",0))
		if SubRowid'="" s DiaTypeDr=$G(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2),"TYP",SubRowid))
		i DiaTypeDr'="" Set DiaType=$P($G(^MRC("DTYP",DiaTypeDr)),"^",2)
		d OneData.%Set("diag_type",DiaType)
		; diag_status	诊断状态	初步诊断	初步诊断、疑似诊断、修正诊断、确诊诊断	文本	varchar(100)
		d OneData.%Set("diag_status","")	
		; diag_code	诊断编码	C34.901		文本	varchar(100)
		s CodeRowid=$p(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2)),"^",1)
		d OneData.%Set("diag_code",$p($g(^MRC("ID",+CodeRowid)),"^",9))	
		; diag_name	诊断名称	右肺下叶小细胞癌		文本	text	是
		d OneData.%Set("diag_name",$p($g(^MRC("ID",+CodeRowid)),"^",2))	
		; diag_explanation	诊断说明	右肺下叶小细胞癌，未见癌转移	诊断情况详细说明	文本	text
		d OneData.%Set("diag_explanation",$g(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2),"DES",1)))	
		; diag_datetime	诊断时间	2018-01-12 11:32:11	需符合【yyyy-MM-dd HH:mm:ss】格式	日期	datetime	
		s diagdate=$zd($p(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2)),"^",7),3)
		s diagtime=$zt($p(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2)),"^",8))
		d OneData.%Set("diag_datetime",diagdate_" "_diagtime)
		; confirmed_diag_mark	是否明确诊断	是	是否是确诊诊断，请填写是或否	文本	varchar(50)	
		d OneData.%Set("confirmed_diag_mark","")
		; maindiag_mark	是否主要诊断	否	是否是主要诊断，请填写是或否	文本	varchar(50)	
		s MaindiagMark="否"
		s MainDiagFlag=$p($g(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2),1)),"^",20)
		s:MainDiagFlag="Y" MaindiagMark="是"
		d OneData.%Set("maindiag_mark",MaindiagMark)
		; diag_doctor_no	诊断医生代码	1021		文本	varchar(100)	是
		s AddUserDr=$p($g(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2),1)),"^",18)
		s DiagDoctorNo=""
		s:AddUserDr'="" DiagDoctorNo=$p($g(^SSU("SSUSR",+AddUserDr)),"^",1)
		d OneData.%Set("diag_doctor_no",DiagDoctorNo)
		; diag_doctor_name	诊断医生名称			文本	varchar(100)
		s DiagDoctorDesc=""
		s:AddUserDr'="" DiagDoctorDesc=$p($g(^SSU("SSUSR",+AddUserDr)),"^",2)
		d OneData.%Set("diag_doctor_name",DiagDoctorDesc)	
		; extend_data1	扩展字段1		用于填写补充信息	文本	text
		d OneData.%Set("extend_data1","")	
		; extend_data2	扩展字段2		用于填写补充信息	文本	text	
		d OneData.%Set("extend_data2","")
		; record_status	记录状态	1	1正常 0作废	数值	int	是
		// Insert:保存诊断,Delete:删除诊断
		d OneData.%Set("record_status",$case(OperateType,"Insert":"1","Delete":"0",:""))
		; record_datetime	记录创建时间		需符合【yyyy-MM-dd HH:mm:ss】格式	日期	datetime
		s MRDiagnosDate=$p($g(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2))),"^",7)
		s MRdiagnosTime=$p($g(^MR(+OneMRDiagnosRow,"DIA",$P(OneMRDiagnosRow,"||",2))),"^",8)	
		d OneData.%Set("record_datetime",##class(websys.Conversions).DateLogicalToHtml(MRDiagnosDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(MRdiagnosTime))
		; record_update_datetime	记录更新时间		需符合【yyyy-MM-dd HH:mm:ss】格式	日期	datetime	
		d OneData.%Set("record_update_datetime","")
		d Data.%Push(OneData)
	}
	d OneDataPacket.%Set("data",Data)
	d DataPacket.%Push(OneDataPacket)
	d OutputInfoObj.%Set("dataPacket",DataPacket)
	b ;a02
	q OutputInfoObj.%ToJSON()
}

/// 推送数据总接口
/// OperateType 操作类型*（ Check ：医嘱保存前的筛查， Save ：保存后的医嘱串， Update ：修改删除的医嘱id传），  后续参数同各功能接口，原有的入参不变
/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).PushDataComInfo("Save",2947754,11980506,21061,4,"8980||1*11972707||136*V*^",1)
/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).PushDataComInfo("Update","2970055","11971245","21061","28131","11962040||129","0")
ClassMethod PushDataComInfo(OperateType As %String, PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrderInfo As %String, RecordStatus As %String)
{
    s $ZTRAP="PushDataComInfoErr"
	s interfacestr=##class(DHCDoc.Interface.TumorReporting.PageInterface).PushInterfaceInfoCom("CS")
	q:(interfacestr=-1) "0"
    s strRes = "1",loccode="",locdr="",flag=""
	s locdr=LocId ;$g(%session.Data("LOGON.CTLOCID"))
	s:locdr'="" loccode=$p($g(^CTLOC(locdr)),"^",1)
	s:loccode'="" flag=##class(web.DHCDocCTCommon).GetSet("CTLOCYYKJCONTROL",loccode,"",2) ;权限配置 注意没有配置科室返回空值
	s:flag'="" flag=$$ALPHAUP^SSUTIL4(flag)
	q:(flag'="Y") strRes
	
	
	/*;旧版程序备份
    s request = ##class(%Net.HttpRequest).%New()
	s request.Timeout = 10
	;s request.Server = "16.22.26.77"	;壹永正式库地址
	s request.Server = "16.22.26.79"	;壹永测试库地址
	s request.Port = "80"
	//s request.ContentType="text/html; charset=UTF-8"
	s request.ContentType="application/json"
	do request.SetHeader("appKey","GI8ZfmHKtreFpSmG")
	do request.SetHeader("apiCode","A000001")
	//编码格式
	s request.ContentCharset = "UTF-8" 
	;s url="http://16.22.26.77/dss/rest/data/recv"	;壹永正式库地址
	s url="http://16.22.26.79/dss/rest/data/recv"	;壹永测试库地址
 	*/


	s request = ##class(%Net.HttpRequest).%New()
	s request.Timeout = 10
	s request.Server = $p(interfacestr,"^",1)
	s request.Port = $p(interfacestr,"^",2)
	s request.ContentType="application/json"
	do request.SetHeader("appKey",$p(interfacestr,"^",3))
	//编码格式
	s request.ContentCharset = "UTF-8" 
	s url=$p(interfacestr,"^",4)
	
	
   s strData=""
    if (OperateType="Check"){
        s strData=..GetOrderInfoCom(PatientId,EpisodeID,UserId,LocId,OrderInfo,RecordStatus)
    }elseif(OperateType="Save"){
        s strData=..GetSaveOrderInfoCom(PatientId,EpisodeID,UserId,LocId,OrderInfo,RecordStatus)
    }elseif(OperateType="Update"){
        s strData=..GetUpdateOrderInfoCom(PatientId,EpisodeID,UserId,LocId,OrderInfo,RecordStatus)
    }
    s strData=$replace(strData,"\","")
    s ^tmpzhx("PushDataComInfoold",1)=strData
    d request.EntityBody.Write(strData)
    s flg=request.Post(url)
	if $system.Status.IsError(flg) {
		s Error = $system.Status.GetErrorText(flg)
		if (Error["#6059")
		{
			 s Error = "网络异常。"_Error
		}
		s strRes = "0"
		q strRes
		//q "{""status"":"""_$system.Status.GetErrorCodes(flg)_""",""message"":"""_Error_"""}"
	}
	s Data=request.HttpResponse.Data
	
	s strRData=""
	While 'Data.AtEnd {
		s strRData=strRData_Data.Read(5000)
	}
    s ^tmpzhx("PushDataComInfoold",2)=strRData
    q strRes
PushDataComInfoErr
    s $ZTRAP=""
    q "0"
}

///  csp初始化需要调用的内容
ClassMethod LoginInit(UserId As %String, LocId As %String, EpisodeID As %String = "")
{
	s EpisodeType=$p($g(^PAADM(EpisodeID)),"^")
	s hospitalization=1
	w "<script src='http://172.17.1.103:5001/client_app_ifrme/index.js?deptType=1&hospitalization=1'></script>",!
	w "<script src='../scripts/dhcdoc/TumorReportingOrdItem'></script>",!
}

/// 1.2.2.1 系统窗体加载入参
ClassMethod GetInitMessage(PatientId As %String, EpisodeID As %String, OutType As %String = "")
{
	s OutputInfoObj=##class(%DynamicObject).%New()
	; patientId	患者ID	String	患者ID	是	80271534
	s PatientNo=##Class(web.PAPatMas).GetRegistration(PatientId)
	d OutputInfoObj.%Set("patientId",PatientNo)
	; visitSn	患者唯一就诊id	String	患者唯一就诊id	是	830127
	d OutputInfoObj.%Set("visitSn",EpisodeID)
	; content	医嘱内容	List<String>	医嘱内容	是	[‘医嘱内容’]
	q:(OutType="JavaScriptJson") OutputInfoObj.%ToJSON()
	q OutputInfoObj
}

/// 保存前的医嘱预警筛查
/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).GetOrderInfoCom(10,628,12175,55,"1812||1^R^3^2021-02-22^17:41:08^1^110.0000^106^2^717||1^^50^269^50^18^1^16^1^^1^N^^Y^^^^^^^N^^x2^1^^^^^^^^^^^^^2021-02-22^17:41:08^N^^^^^N^^4^^N^^^^^^^^N^1^^0^^^^110.0000^^^^^^1^N^^^"_$c(1)_"16895||1^N^3^2021-02-22^17:41:17^^286.0000^105^2^^^^^0.3^^^^^^2^N^^Y^^^^^^^N^^^^^^^^^^^^^^^^2021-02-22^17:41:17^N^^^^^N^^116^^N^^^^^^^^N^2^^0^^^^85.8^^^^^^1^N^^^",1)
ClassMethod GetOrderInfoCom(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrderItemStr As %String, RecordStatus As %String)
{
	s OutOrderInfoComObj=..GetInitMessage(PatientId,EpisodeID) //##class(%DynamicObject).%New()
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutOrderInfoComObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutOrderInfoComObj.%Set("deptId",LocCode)
    s EpisodeType=$p($g(^PAADM(EpisodeID)),"^",2)
    
    ;2022-04-11 add start
	s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(EpisodeID)
    s PatientInfo=##class(%DynamicObject).%New()
	d PatientInfo.%Set("gender",OneAdmObj.Gender)
	d PatientInfo.%Set("birthDate",OneAdmObj.DateOfBirth)
	s papmi=$p(^PAADM(EpisodeID),"^",1)
	s maritalID=$p(^PAPER(papmi,"PER",2),"^",3)
	s maritalStatus=$case(maritalID,"21":"10","22":"20","23":"21","24":"22","25":"23","26":"30","27":"40",:"90")
	;s maritalStatus=$p(^CT("MAR",maritalID),"^",2)	;为了明确传输婚姻状况，直接传婚姻状态。不采用字典Code转换推送给对方，防止字典对照错误。
	d PatientInfo.%Set("maritalStatus",maritalStatus)
	d PatientInfo.%Set("pregnancyStatus","")
	d OutOrderInfoComObj.%Set("patientInfo",PatientInfo)
    ;2022-04-11 add end
	
    ;s DataPacket=[],Content=[]		;2022-04-11 壹永科技杨路飞确认不传content
    s DataPacket=[]
    s DataPacket=[],Content=[]
    s InExpStr=UserId_"^"_LocId_"^"_RecordStatus
    s TableCode=$case(EpisodeType,"I":"b10_1",:"b14_1")
    s OneOrderItemObj=##class(%DynamicObject).%New()
	d OneOrderItemObj.%Set("tableCode",TableCode)
	s ItemObjList=[]
    s DrugItemNum=0
    for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s ARCIMRowid=$p(OrderItemOne,"^",1)
		s DrugItemNum=DrugItemNum+1
		Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		;continue:" R X L "'[OrderType		;控制传输医嘱的类型
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		;d Content.%Push(ARCIMDesc)	;2022-04-11 壹永科技杨路飞确认不传content
		s GetItemObj=..SetItemObj(PatientId,EpisodeID,OrderItemOne,"",InExpStr)
		//d OneOrderItemObj.%Set("data",GetItemObj.%ToJSON())
		//s OneOrderItemObj.data=GetItemObj
		d ItemObjList.%Push(GetItemObj)
	}
	s OneOrderItemObj.data=ItemObjList
	d DataPacket.%Push(OneOrderItemObj)
    //d OutOrderInfoComObj.%Set("content",Content)
    ;s OutOrderInfoComObj.content=Content	;2022-04-11 壹永科技杨路飞确认不传content
    //d OutOrderInfoComObj.%Set("dataPacket",DataPacket)
    s OutOrderInfoComObj.dataPacket=DataPacket
    // "extend1": "",
    d OutOrderInfoComObj.%Set("extend1","")
    // "extend2": "",
    d OutOrderInfoComObj.%Set("extend2","")
    // "planCode": "S0000001"
	b ;d OutOrderInfoComObj.%Set("planCode","S00000001")	;2022-04-11 壹永科技杨路飞确认不传planCode
	q OutOrderInfoComObj.%ToJSON()
}

/// 保存医嘱后的所需数据 
/// w ##class(DHCDoc.Interface.TumorReporting.PageInterface).GetSaveOrderInfoCom("1000526508",12296505,21061,4,"8980||1*11972707||136*V*^",1)
ClassMethod GetSaveOrderInfoCom(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrderStr As %String, RecordStatus As %String)
{
	s ^tmpzhx("GetSaveOrderInfoCom")=PatientId_"^"_EpisodeID_"^"_UserId_"^"_LocId_"^"_OrderStr_"^"_RecordStatus
	s OutOrderInfoComObj=..GetInitMessage(PatientId,EpisodeID) //##class(%DynamicObject).%New()
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutOrderInfoComObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutOrderInfoComObj.%Set("deptId",LocCode)
    s EpisodeType=$p($g(^PAADM(EpisodeID)),"^",2)
    
    ;2022-04-11 add start
	s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(EpisodeID)
    s PatientInfo=##class(%DynamicObject).%New()
	d PatientInfo.%Set("gender",OneAdmObj.Gender)
	d PatientInfo.%Set("birthDate",OneAdmObj.DateOfBirth)
	s papmi=$p(^PAADM(EpisodeID),"^",1)
	s maritalID=$p(^PAPER(papmi,"PER",2),"^",3)
	s maritalStatus=$case(maritalID,"21":"10","22":"20","23":"21","24":"22","25":"23","26":"30","27":"40",:"90")
	;s maritalStatus=$p(^CT("MAR",maritalID),"^",2)	;为了明确传输婚姻状况，直接传婚姻状态。不采用字典Code转换推送给对方，防止字典对照错误。
	d PatientInfo.%Set("maritalStatus",maritalStatus)
	d PatientInfo.%Set("pregnancyStatus","")
	d OutOrderInfoComObj.%Set("patientInfo",PatientInfo)
    ;2022-04-11 add end
	
    ;s DataPacket=[],Content=[]		;2022-04-11 壹永科技杨路飞确认不传content
    s DataPacket=[]
    s InExpStr=UserId_"^"_LocId_"^"_RecordStatus
    s TableCode=$case(EpisodeType,"I":"b10_1",:"b14_1")
    s OneOrderItemObj=##class(%DynamicObject).%New()
	d OneOrderItemObj.%Set("tableCode",TableCode)
	s ItemObjList=[]
    s DrugItemNum=0
    for i=1:1:$l(OrderStr,"^") {
		s OrderOne=$p(OrderStr,"^",i)
		continue:OrderOne=""
		s ARCIMRowid=$p(OrderOne,"*",1)
		continue:ARCIMRowid=""
		s OEORIRowId=$p(OrderOne,"*",2)
		continue:OEORIRowId=""
		s DrugItemNum=DrugItemNum+1
		Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		;continue:" R X L "'[OrderType		;控制传输医嘱的类型
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		;d Content.%Push(ARCIMDesc)	;2022-04-11 壹永科技杨路飞确认不传content
		s GetItemObj=..SetItemObj(PatientId,EpisodeID,"",OEORIRowId,InExpStr)
		//d OneOrderItemObj.%Set("data",GetItemObj.%ToJSON())
		d ItemObjList.%Push(GetItemObj)
	}
	s OneOrderItemObj.data=ItemObjList
	d DataPacket.%Push(OneOrderItemObj)
    //d OutOrderInfoComObj.%Set("content",Content)
    ;s OutOrderInfoComObj.content=Content	;2022-04-11 壹永科技杨路飞确认不传content
    s OutOrderInfoComObj.dataPacket=DataPacket //%Set("dataPacket",DataPacket)
    // "extend1": "",
    d OutOrderInfoComObj.%Set("extend1","")
    // "extend2": "",
    d OutOrderInfoComObj.%Set("extend2","")
    // "planCode": "S0000001"
	b ;d OutOrderInfoComObj.%Set("planCode","S00000001")	;2022-04-11 壹永科技杨路飞确认不传planCode
	q OutOrderInfoComObj.%ToJSON()
}

/// 撤销停止删除医嘱后的所需数据 
ClassMethod GetUpdateOrderInfoCom(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrderStr As %String, RecordStatus As %String)
{
	s OutOrderInfoComObj=..GetInitMessage(PatientId,EpisodeID) //##class(%DynamicObject).%New()
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutOrderInfoComObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutOrderInfoComObj.%Set("deptId",LocCode)
    s EpisodeType=$p($g(^PAADM(EpisodeID)),"^",2)
    
    ;2022-04-11 add start
	s OneAdmObj=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetPatientInfoObj(EpisodeID)
    s PatientInfo=##class(%DynamicObject).%New()
	d PatientInfo.%Set("gender",OneAdmObj.Gender)
	d PatientInfo.%Set("birthDate",OneAdmObj.DateOfBirth)
	s papmi=$p(^PAADM(EpisodeID),"^",1)
	s maritalID=$p(^PAPER(papmi,"PER",2),"^",3)
	s maritalStatus=$case(maritalID,"21":"10","22":"20","23":"21","24":"22","25":"23","26":"30","27":"40",:"90")
	;s maritalStatus=$p(^CT("MAR",maritalID),"^",2)	;为了明确传输婚姻状况，直接传婚姻状态。不采用字典Code转换推送给对方，防止字典对照错误。
	d PatientInfo.%Set("maritalStatus",maritalStatus)
	d PatientInfo.%Set("pregnancyStatus","")
	d OutOrderInfoComObj.%Set("patientInfo",PatientInfo)
    ;2022-04-11 add end
	
    ;s DataPacket=[],Content=[]		;2022-04-11 壹永科技杨路飞确认不传content
    s DataPacket=[]
    s InExpStr=UserId_"^"_LocId_"^"_RecordStatus
    s TableCode=$case(EpisodeType,"I":"b10_1",:"b14_1")
    s OneOrderItemObj=##class(%DynamicObject).%New()
	d OneOrderItemObj.%Set("tableCode",TableCode)
	s ItemObjList=[]
    s DrugItemNum=0
    for i=1:1:$l(OrderStr,"^") {
		s OrderOne=$p(OrderStr,"^",i)
		continue:OrderOne=""
		s OEORIRowId=OrderOne
		continue:OEORIRowId=""
		s ARCIMRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
		continue:ARCIMRowid=""
		s DrugItemNum=DrugItemNum+1
		Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		;continue:" R X L "'[OrderType		;控制传输医嘱的类型
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		;d Content.%Push(ARCIMDesc)	;2022-04-11 壹永科技杨路飞确认不传content
		s GetItemObj=..SetItemObj(PatientId,EpisodeID,"",OEORIRowId,InExpStr)
		//d OneOrderItemObj.%Set("data",GetItemObj.%ToJSON())
		//s OneOrderItemObj.data=GetItemObj
		d ItemObjList.%Push(GetItemObj)
		
	}
	s OneOrderItemObj.data=ItemObjList
	d DataPacket.%Push(OneOrderItemObj)
    //d OutOrderInfoComObj.%Set("content",Content)
    ;s OutOrderInfoComObj.content=Content	;2022-04-11 壹永科技杨路飞确认不传content
    //d OutOrderInfoComObj.%Set("dataPacket",DataPacket)
    s OutOrderInfoComObj.dataPacket=DataPacket
    // "extend1": "",
    d OutOrderInfoComObj.%Set("extend1","")
    // "extend2": "",
    d OutOrderInfoComObj.%Set("extend2","")
    // "planCode": "S0000001"
	;d OutOrderInfoComObj.%Set("planCode","S00000001")	;2022-04-11 壹永科技杨路飞确认不传planCode
	q OutOrderInfoComObj.%ToJSON()
}

ClassMethod SetItemObj(PatientId As %String, EpisodeID As %String, OrderItemOne As %String, OEORIRowId As %String, ExpStr As %String)
{
	s UserID=$p(ExpStr,"^",1)
	s DeptID=$p(ExpStr,"^",2)
	s RecordStatus=$p(ExpStr,"^",3)
	if (OrderItemOne'="") {
		;预先
		s OrderDate=$p(OrderItemOne,"^",46)
		s OrderTime=$p(OrderItemOne,"^",47)	;医嘱时间
		s PriorRowid=$p(OrderItemOne,"^",3)	;医嘱类型
		s ARCIMRowid=$p(OrderItemOne,"^",1)	;药品ID
		s DoseQty=$p(OrderItemOne,"^",12)
		s DoseUOMRowid=$p(OrderItemOne,"^",13)	;每次给药剂量
		s InstrRowid=$p(OrderItemOne,"^",17)	;给药途径
		s FreqRowid=$p(OrderItemOne,"^",15)	;给药频率
		s PackQty=$p(OrderItemOne,"^",6)	;发药数量
		s OrderPackUOMRowid=$p(OrderItemOne,"^",55)	;发药数量单位
		s unitprice=$p(OrderItemOne,"^",7)	;单价
		s OrderStDate=$p(OrderItemOne,"^",4)
		s OrderStTime=$p(OrderItemOne,"^",5)	;医嘱生效时间
		s EndDate=$p(OrderItemOne,"^",26)
		s EndTime=$p(OrderItemOne,"^",27)	;医嘱失效时间
		s DurRowid=$p(OrderItemOne,"^",16)	;疗程
		s NotifyClinician=$p(OrderItemOne,"^",30)	;紧急标志
		s OrderNeedPIVAFlag=$p(OrderItemOne,"^",48)	;静配标志
		s SkinTest=$p(OrderItemOne,"^",21)	;皮试标志
		s SpeedFlowRate=$p(OrderItemOne,"^",36)
		s FlowRateUnitDR=$p(OrderItemOne,"^",45)	;给药速度
		s orderid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;医嘱id
		s groupno=$p(OrderItemOne,"^",19)
		if (groupno="") s groupno=$p(OrderItemOne,"^",20)	;组号
		s DepProcNotes=$p(OrderItemOne,"^",11)
		s recipeid=EpisodeID_"^"_UserID_"^"_+$h_"^"_$p($h,",",2)	;处方ID
		s recipeitemid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;处方明细编号
		;20220326 zhx add
		s orderstatus=RecordStatus
		s orderdoctorname=""
		s itemunitprice=unitprice
		s itemtotalprice=$fn(unitprice*unitprice,".",2)
	}else{
		;新增、撤销
		s OrderRowid=+OEORIRowId,ChildSub=$p(OEORIRowId,"||",2)
		s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
		if (OrderDate="") s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",17)
		if (OrderTime="") s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱时间
		s PriorRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8)	;医嘱类型
		s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)	;药品ID
		s DoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
		s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;每次给药剂量
		s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)	;给药途径
		s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)	;给药频率
		s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)	;发药数量
		s OrderPackUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
		if (OrderPackUOMRowid="") s OrderPackUOMRowid=DoseUOMRowid	;发药数量单位
		s OrderStDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s unitprice="" //$p(##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,OrderStDate,"","","","","",""),"^",4)	;单价
		s OrderStTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱生效时间
		s EndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
		s EndTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",15)	;医嘱失效时间
		s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)	;疗程
		s NotifyClinician=$p(^OEORD(OrderRowid,"I",ChildSub,11),"^",55)	;紧急标志
		s OrderNeedPIVAFlag=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",16)	;住院静配标志
		s SkinTest=$p($g(^OEORD(OrderRowid,"I",ChildSub,5)),"^",2)	;皮试标志
		s SpeedFlowRate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",17)
		s FlowRateUnitDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,6)),"^",8)	;给药速度
		s orderid=OEORIRowId	;医嘱id
		s groupno=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
		if (groupno="") s groupno=OEORIRowId	;组号
		s recipeid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",14)	;处方ID
		s UserID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
		s DeptID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",2)
		s DepProcNotes=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1))
		s recipeitemid=OEORIRowId	;处方明细编号
		;20220326 zhx add
		s orderstatus=RecordStatus
		s oeoridoctordr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",11)
		s orderdoctorname=""
		s:oeoridoctordr'="" orderdoctorname=$p($g(^CTPCP(oeoridoctordr,1)),"^",2)
		;s itemunitprice=""
		;s itemtotalprice=""

		set VerifyDate=$P(^OEORD(OrderRowid,"I",ChildSub,3),"^",7)
		set arcimId = $P(^OEORD(OrderRowid,"I",ChildSub,1),"^",2)
		set EpissubtypeDR=1 ;$P($g(^PAADM(VisitSn,1)),"^",6)
		s price=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","")	;单价(元)		XXX
		s itemunitprice=$fn(+price,"",2)
		
		//数量^单位^单位ID^数量(换算成基本单位)^基本单位^单位ID^实发数量^实发数量单位^发药状态
		s qtystr=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEORIRowId)
		s qty=$P(qtystr,"^",4)	;单次的基本单位数量
		s itemtotalprice=$fn(itemunitprice*qty,"",2)	;总金额(元)	单次的总金额，一天有多次用药，需要乘以频次。

	}
	s OutputObj=##class(%DynamicObject).%New()
	s PatientNo=##Class(web.PAPatMas).GetRegistration(PatientId)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	//"patient_id": "43655",
	//"visit_sn": "43655|4623477|2|住院",
	//"order_sn": "74471930001|12",
	//"order_dept_code": "15",
	//"order_dept_name": "内科",
	s AddUserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
    s DeptCode=$p($g(^CTLOC(DeptID)),"^",1)
    s DeptName=$p($g(^CTLOC(DeptID)),"^",2)
	//"order_start_datetime": "2018-12-1318:12:21",
	s OrderStartDatetime=##class(websys.Conversions).DateLogicalToHtml(OrderStDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrderStTime)
	//"order_type": "临时医嘱",
	s OrderType=$p($g(^OECPR(PriorRowid)),"^",1)
	//"order_class_code": "04",
	Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s ExecCategDR=$P(^ARC("IC",ItemCatDR),"^",9)
	s OrderClassCode=$p($g(^OEC("EXEC",ExecCategDR)),"^",1)
	//"order_class_name": "检查类医嘱",
	s OrderClassName=$p($g(^OEC("EXEC",ExecCategDR)),"^",1)
	//"order_item_code": "7438731",
	s ARCIMCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)
	//"order_item_name": "CT检查",
	s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	//"record_status": "1",
	//"YY_ID": "12348",
	//"YY_UPDATE_TIME": "2021-11-03 13:00:00",
	//"YY_CREATE_TIME": "2021-11-03 13:00:00"
	s CreateDateTime=##class(websys.Conversions).DateLogicalToHtml(OrderDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrderTime)
	d OutputObj.%Set("patient_id",PatientNo)
	d OutputObj.%Set("visit_sn",EpisodeID)
	if (AdmType="I"){
		//"inpatient_no": "4623477",
		//"hospitalization_times": "2",
		s HospitalizationTimes=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetVisitNum("I",PatientId)
		d OutputObj.%Set("inpatient_no",EpisodeID)
		d OutputObj.%Set("hospitalization_times",HospitalizationTimes)
		d OutputObj.%Set("order_start_datetime",OrderStartDatetime)
		d OutputObj.%Set("order_type",OrderType)
		;20220326 zhx add by b10_1 View
		d OutputObj.%Set("order_status",orderstatus)
		d OutputObj.%Set("order_doctor_name",orderdoctorname)
		d OutputObj.%Set("item_unit_price",itemunitprice)
		d OutputObj.%Set("item_total_price",itemtotalprice)
	}else{
		//"visit_type": "门诊",
		s VisitType=$case(AdmType,"E":"急诊",:"门诊")
		d OutputObj.%Set("visit_type",VisitType)
		//"visit_card_no": "153898",
		d OutputObj.%Set("visit_card_no",PatientNo)
		//"outpatient_no": "4623477",
		d OutputObj.%Set("outpatient_no",EpisodeID)
		//"visit_times": "1",
		s VisitTimes=##class(DHCDoc.Interface.TumorReporting.ComInterface).GetVisitNum("O^E",PatientId)
		d OutputObj.%Set("visit_times",VisitTimes)
		// order_given_time
        d OutputObj.%Set("order_given_time",CreateDateTime)
        // "order_doctor_no": "1346",
        d OutputObj.%Set("order_doctor_no",AddUserCode)
		;20220326 zhx add by b14_1 View
		d OutputObj.%Set("order_doctor_name",orderdoctorname)
	}
	if (OrderType="R"){
		//"dose": "4.0000",
		d OutputObj.%Set("dose",DoseQty)
		//"dose_unit": "mg",
		s DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
		d OutputObj.%Set("dose_unit",DoseUOMDesc)
		//"form": "片剂",
		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
		s Form=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
		d OutputObj.%Set("form",Form)
		if (AdmType="I"){
			//"spec": "250mg",
			s Spec=""
			s:InciRowid'="" Spec=##class(web.DHCSTKUTIL).GetSpec(InciRowid)
			d OutputObj.%Set("spec",Spec)
			//"frequency_code": "bid",
			s FrequencyCode=$p($g(^PHCFR(FreqRowid)),"^",1)
			d OutputObj.%Set("frequency_code",FrequencyCode)
			//"frequency_name": "一日两次",
			s FrequencyName=$p($g(^PHCFR(FreqRowid)),"^",3)
			d OutputObj.%Set("frequency_name",FrequencyName)
			//"order_note": "自备", DepProcNotes
			d OutputObj.%Set("order_note",DepProcNotes)
		}else{
            //"prescription_class_code": "15",
            s ItemCatCode=$P(^ARC("IC",ItemCatDR),"^",1)
            d OutputObj.%Set("prescription_class_code",ItemCatCode)
			//"prescription_class_name": "第一类精神药品处方",
			s ItemCatDesc=$P(^ARC("IC",ItemCatDR),"^",2)
			d OutputObj.%Set("prescription_class_code",ItemCatDesc)
			//"frequency_code": "bid",
			s FreqDesc=$p($g(^PHCFR(FreqRowid)),"^",3)
			d OutputObj.%Set("frequency_code",FreqDesc)
			//"administration_route": "口服",
			s InstrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
			d OutputObj.%Set("administration_route",InstrDesc)
			//"num_of_orders": "10",
			s:PackQty="" PackQty="1"
			d OutputObj.%Set("num_of_orders",PackQty)
			//"num_of_orders_unit": "片",
			s NumOfOrdersUnit=""
			s:OrderPackUOMRowid'="" NumOfOrdersUnit=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
			d OutputObj.%Set("administration_route",NumOfOrdersUnit)
			//"manufac": "拜耳",
			s Manufac=##class(web.DHCSTITMDESC).GetManfNameByInci(InciRowid)
			d OutputObj.%Set("manufac",Manufac)
		}
	}
	d OutputObj.%Set("order_sn",orderid)
	d OutputObj.%Set("order_dept_code",DeptCode)
	d OutputObj.%Set("order_dept_name",DeptName)
	d OutputObj.%Set("order_class_code",OrderClassCode)
	d OutputObj.%Set("order_class_name",OrderClassName)
	d OutputObj.%Set("order_item_code",ARCIMCode)
	d OutputObj.%Set("order_item_name",ARCIMDesc)
	d OutputObj.%Set("record_status",RecordStatus)
	d OutputObj.%Set("YY_ID",orderid)
	d OutputObj.%Set("record_update_datetime",$zd(+$H,3)_" "_$zt($p($H,",",2)))
	d OutputObj.%Set("record_datetime",$zd(+$H,3)_" "_$zt($p($H,",",2)))
	Q OutputObj
}

/// Creator:      lvjun
/// CreatDate:    2020-12-12
/// Description:  将待审核草药数据串拼接成待审核西药数据串
/// Input:        EpisodeID:就诊表RowId  CMOEOrdStr:待审核草药数据串
/// Return:       待审核西药数据串
/// Others:       w ##class(web.DHCDocHLYYHZYY).ConvertCMOEOrdToOEOrd("4415774",$p(^lj("ConvertCMOEOrdToOEOrd"),",",2))
ClassMethod ConvertCMOEOrdToOEOrd(EpisodeID As %String, CMOEOrdStr As %String) As %String
{
	s ^lj("ConvertCMOEOrdToOEOrd")=EpisodeID_","_CMOEOrdStr
	s PrescStr=$p(CMOEOrdStr,$C(2),1)
	s CMItemStr=$p(CMOEOrdStr,$c(2),2)
	s PrescPriorRowid=$p(PrescStr,"^",1)
	s PrescDurRowid=$p(PrescStr,"^",2)
	s PrescInstrRowid=$p(PrescStr,"^",3)
	s PrescFreqRowid=$p(PrescStr,"^",4)
	s PrescCookMode=$p(PrescStr,"^",5)
	s PrescOrderQty=$p(PrescStr,"^",6)
	s PrescRecDepRowid=$p(PrescStr,"^",7)
	s PrescAdmReason=$p(PrescStr,"^",8)
	s PrescNotes=$p(PrescStr,"^",9)
	s PrescEmergency=$p(PrescStr,"^",10)
	s PrescStartDate=$p(PrescStr,"^",11)
	if (PrescStartDate="") s PrescStartDate=+$h
    else  s PrescStartDate=##class(websys.Conversions).DateHtmlToLogical(PrescStartDate)
    s PrescStartDate=$zd(PrescStartDate,3)
    s PrescStartTime=$p(PrescStr,"^",12)
    if (PrescStartTime="") s PrescStartTime=$p($h,",",2)
    else  s PrescStartTime=##class(websys.Conversions).TimeHtmlToLogical(PrescStartTime)
    s PrescStartTime=$zt(PrescStartTime,1)
    ;
    s OEOrdStr=""
	for ItemSeq=1:1:$l(CMItemStr,$c(1)) {
		s CMItemOne=$p(CMItemStr,$c(1),ItemSeq)
		continue:CMItemOne=""
		s ARCIMRowid=$p(CMItemOne,"^",1)
		continue:ARCIMRowid=""
		s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
		continue:OrderType'="R"
		s DoseQty=$p(CMItemOne,"^",2)
		s DurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
		s PackQty=DoseQty*DurFactor
		s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$h,"","","","","","")
		s UnitPrice=$p(OrderPrice,"^",4)
		s DoseUOMRowid=$p(CMItemOne,"^",3)
		if (DoseUOMRowid="") s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
		if (DoseUOMRowid="") {
			s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
			if (Phcdf'="") s DoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
		s PhSpecInstr=$p(CMItemOne,"^",4)
		s OrderSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime_"^"_ItemSeq
		s OrderMasterSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PrescPriorRowid_"^"_PrescStartDate_"^"_PrescStartTime_"^"_PackQty	;1-6
		s OEOrdOne=OEOrdOne_"^"_UnitPrice_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""_"^"_PrescFreqRowid	;7-14
		s OEOrdOne=OEOrdOne_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_""_"^"_OrderMasterSeqNo_"^"_OrderSeqNo	;15-20
		s $p(OEOrdOne,"^",22)=PhSpecInstr
		s $p(OEOrdOne,"^",30)=PrescEmergency
		s $p(OEOrdOne,"^",46)=PrescStartDate
		s $p(OEOrdOne,"^",47)=PrescStartTime
		s $p(OEOrdOne,"^",55)=DoseUOMRowid
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

/// 获取住院医嘱信息
ClassMethod GetIPOrdItemInfo(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrdItemInfo As %String, RecordStatus As %String)
{
	s OutIPOrdItemObj=..GetInitMessage(PatientId,EpisodeID)
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutIPOrdItemObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutIPOrdItemObj.%Set("deptId",LocCode)
    s DataPacket=[],Content=[]
    
    
    d OutIPOrdItemObj.%Set("content",Content)
    d OutIPOrdItemObj.%Set("dataPacket",DataPacket)
    // "extend1": "",
    d OutIPOrdItemObj.%Set("extend1","")
    // "extend2": "",
    d OutIPOrdItemObj.%Set("extend2","")
    // "planCode": "S0000001"
	d OutIPOrdItemObj.%Set("planCode","S00000001")
	q OutIPOrdItemObj.%ToJSON()
}

/// 获取门诊医嘱信息
ClassMethod GetOPOrdItemInfo(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrdItemInfo As %String, RecordStatus As %String)
{
	s OutOPOrdItemObj=..GetInitMessage(PatientId,EpisodeID)
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutOPOrdItemObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutOPOrdItemObj.%Set("deptId",LocCode)
    s DataPacket=[],Content=[]
    
    
    d OutOPOrdItemObj.%Set("content",Content)
    d OutOPOrdItemObj.%Set("dataPacket",DataPacket)
    // "extend1": "",
    d OutOPOrdItemObj.%Set("extend1","")
    // "extend2": "",
    d OutOPOrdItemObj.%Set("extend2","")
    // "planCode": "S0000001"
	d OutOPOrdItemObj.%Set("planCode","S00000001")
	q OutOPOrdItemObj.%ToJSON()
}

ClassMethod GetOPAppInfo(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrdItemInfo As %String, RecordStatus As %String)
{
	s OutOPAppObj=..GetInitMessage(PatientId,EpisodeID)
	// "doctorId": "3608310",
	s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	d OutOPAppObj.%Set("doctorId",UserCode)
    //"deptId": "7155333",
    s LocCode=$p($g(^CTLOC(LocId)),"^",1)
    d OutOPAppObj.%Set("deptId",LocCode)
    s DataPacket=[],Content=[]
    
    
    d OutOPAppObj.%Set("content",Content)
    d OutOPAppObj.%Set("dataPacket",DataPacket)
    // "extend1": "",
    d OutOPAppObj.%Set("extend1","")
    // "extend2": "",
    d OutOPAppObj.%Set("extend2","")
    // "planCode": "S0000001"
	d OutOPAppObj.%Set("planCode","S00000001")
	q OutOPAppObj.%ToJSON()
}

ClassMethod GetIPAppInfo(PatientId As %String, EpisodeID As %String, UserId As %String, LocId As %String, OrdItemInfo As %String, RecordStatus As %String)
{
	s OutIPAppObj=##class(%DynamicObject).%New()
	//"tableCode": "b10_1",
	d OutIPAppObj.%Set("tableCode","b10_1")
    //"data": [
    for{
	    
    }
    s Data=[]
	d OutIPAppObj.%Set("data",Data)
	q OutIPAppObj.%ToJSON()
}

}
