/// Hosptal:四川攀钢集团医院
/// Description:  通用环球医疗集团有限公司_预约挂号功能对接接口
/// CreateDate:20200510
/// Creator:nikang
Class DHCDoc.Interface.Outside.OrganizationUnit.SelfReg Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

ClassMethod StopSchedulePush(ASRowId)
{
	s OutPutObj=##class(%DynamicObject).%New()
	; scheduleIdList array 是 停诊医生的排班 Id列表["10001", "10002", "10003"]
	s ScheduleIdArr=[]
	d ScheduleIdArr.%Push(ASRowId)
	s OutPutObj.OutPutObj=ScheduleIdArr
	; comment string 否 附加消息 停诊通知
	s OutPutObj.comment="停诊通知"
	s JsonStr=OutPutObj.%ToJSON()
	q JsonStr
}

/// 获取排班信息
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetSchedule("{""date"":""2020-07-11""}","WX")/// 获取排班信息
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetSchedule("{""date"":""2021-05-13""}","HLWYH")
ClassMethod GetSchedule(JsonInput, ExtUserID)
{
	s ^tmplyr("222",ExtUserID)=JsonInput
	s $ZTRAP="GetScheduleErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s ScheduleDate=obj.date
	s DepartmentCode=obj.DepartmentCode
	s DoctorCode=obj.DoctorCode
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	if (UserID=""){
		s OutputObj.responseCode="-1001"
		s OutputObj.respongseText="His未维护可用用户"
		q OutputObj	
	}
	if ScheduleDate=""{
		s OutputObj.responseCode="-1002"
		s OutputObj.respongseText="请传入排班日期"
		q OutputObj	
	}
	s ScheduleDate=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).DateConvertHis(ScheduleDate)
	if ScheduleDate="-1"{
		s OutputObj.responseCode="-1003"
		s OutputObj.respongseText="排班日期格式错误"
		q OutputObj	
	}
	s StartDate=ScheduleDate
	s EndDate=ScheduleDate
	s GroupRowId=$p($g(^SSU("SSUSR",UserID)),"^",5)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupRowId,"DHC")){
		s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupRowId,"DHC")),"^",1)
	}
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	;b ;hhr h3
	s RecordCount=0
	s TimeRangeId=""
	s PatientID=""
	if DepartmentCode=""{
		set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,"O^E","2")
		//b ;;;;12
		set myDeptNum=$length(myOPDeptStr,"^")
		for loop=1:1:myDeptNum
		{
			set myOneDeptStr=$piece(myOPDeptStr,"^",loop)
			set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
			continue:DepartmentCode=""
			set flag=0
			set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResRowId)) Q:ResRowId=""  d
			.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
			.s flag=1
			if ((flag=0)&&(GroupResRowIdStr'="")){
				continue
			}
			;b ;hhr h4
			d GetOneSchedule
		}
	}else{
		d GetOneSchedule	
	}
	if RecordCount=0 {
		s MySchedule=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
		s MySchedule.data=" "
		do OutputObj.ScheduleData.Insert(MySchedule)
	}
	//b ;;;1
	d OutputObj.XMLExportToString(.Input)
	Q OutputObj
GetScheduleErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetSchedule调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
	;b ;00
	Q OutputObj
    q OutputObj
GetOneSchedule
	;挂号科室^用户ID^预约日期^PatientID^查询时段
	;挂号医生^安全组ID^费别ID^诊断类别ID^查询时段，上下午？
	;亚专业^是否显示停诊^优惠类型
	if (StartDate>+$H)
	{
		s val=DepartmentCode_"^"_UserID_"^"_$zd(StartDate,3)_"^^"_TimeRangeId_"^"_DoctorCode_"^"_GroupRowId_"^^false^^^1"
		// renyx 日期大于当天修改号源方式  AppRegMethodCode
		//s AppRegMethodCode="WEB"   ;   RYx  2021-05-19 增加取网络预约号院，注释掉取窗口预约
	}
	else
	{
		
		s val=DepartmentCode_"^"_UserID_"^^^"_TimeRangeId_"^"_DoctorCode_"^"_GroupRowId_"^^false^^^1^^^1"
	}
	;hhr val
	s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
	 ;b  ;查询时间段的预约排班信息
	;s rs=##Class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:OPDocList")
	i rs.QueryIsValid() { 
		Set Status=rs.Execute(val,"1")
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		;3
		While rs.Next() {
			s ASRowId=rs.GetDataByName("ASRowId")
			s Load=rs.GetDataByName("Load")
			;b ;hhr Load
			continue:Load=0
			s RegedCount=rs.GetDataByName("RegedCount")
			s AppLoad=rs.GetDataByName("AppLoad")
			s AppedCount=rs.GetDataByName("AppedCount")
			continue:+ASRowId=0
			s ResID=+ASRowId
			s Sub=$p(ASRowId,"||",2)
			s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
			s SessStartTime=$p($g(^RBAS(ResID,Sub)),"^",4)
			s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
			;不显示当前时段以前的号
			;Continue:(ASDate=+$H)&&(SessEndTime<$p($h,",",2))
			Continue:(EndDate'="")&&(ASDate>EndDate)
			s status=$P($G(^RBAS(ResID,Sub,"DHC")),"^",10)
			s statuscode=""
			i status'="" {
				s statuscode=$P(^DHCRBCASStatus(status),"^",1)
			}
			s isOutOfService="false"
			if ("^S^TR^PS^"[("^"_statuscode_"^")){
				s isOutOfService="true"
			}
			s OneAdmScheduleObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOneAdmSchedule(ASRowId,PatientID,AppRegMethodCode)
			//b ;;2
			if $IsObject(OneAdmScheduleObj) {
				;b:ASRowId["1152||325"
				;Continue:(ExtUserID="HLWYH")&&(OneAdmScheduleObj.DoctorCode'="375") ;QJH 2021-01-12先开放苗涛的号 
				Continue:(ExtUserID="HLWYH")&&((OneAdmScheduleObj.DoctorCode'="375")&&(OneAdmScheduleObj.DoctorCode'="406"))  ;QJH 2021-01-12先开放苗涛主任 + 马国耀 的号 
				// 分时段数据
				;w ASRowId,!
				s SessRowid=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2))),"^",12)
				s TRStr=$g(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")) ;$g(^RB("RES",+SessRowid,"DATE",$p(SessRowid,"||",2),"SESS",$p(SessRowid,"||",3),"DHC"))
				s TRRegNumStr=$p(TRStr,"^",24)
				s TRRegTimeStr=$p(TRStr,"^",25)
				s StartNum=0
				s EndNum=0
				s APPMethodRowId=$O(^RBC("APTM",0,"Code",AppRegMethodCode,0))
				For{
					Set AQRowid=$o(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid))
					Quit:AQRowid=""
					s APPMethodDR=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",1)
					continue:(APPMethodRowId'="")&&(APPMethodRowId'=APPMethodDR)
					s StartNum=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",3)
					s Num=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",2)
					s EndNum=StartNum+Num
				}
				s SeqNoCount=EndNum-StartNum+1
				s OneScheduleObj={} //##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
				s OneScheduleObj.scheduleId=ASRowId
				s OneScheduleObj.scheduleDate=$zd(ASDate,3)
				s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
				s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
				s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
				s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
				s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
				s OneScheduleObj.totalCount=SeqNoCount //OneAdmScheduleObj.AvailableTotalNum
				s OneScheduleObj.availableCount=SeqNoCount //OneAdmScheduleObj.AvailableLeftNum
				s DoctorSessType=OneAdmScheduleObj.DoctorSessType
				i (DoctorSessType["普诊")||((DoctorSessType["普通")) s DoctorSessType=3
				else  if DoctorSessType="特需" s DoctorSessType=5
				else  s DoctorSessType=4
				s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
				s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
				s OneScheduleObj.comment=OneAdmScheduleObj.Note
				if (TRRegNumStr'=""){
					do OutputObj.ScheduleData.Insert(OneScheduleObj)
					s RecordCount=RecordCount+1
					f i=1:1:$l(TRRegNumStr,",") {
						s oneRegNumStr=$p(TRRegNumStr,",",i)
				    	s sRegNum=$p(oneRegNumStr,"-",1)
				    	s eRegNum=$p(oneRegNumStr,"-",2)
				    	continue:(StartNum>eRegNum)!(EndNum<sRegNum)
				    	s oneRegTimeStr=$p(TRRegTimeStr,",",i)
						s totalCount=$p(oneRegNumStr,"-",2)-$p(oneRegNumStr,"-",1)+1
						s usedCount=..GetUsedCount(oneRegNumStr,QueueNO)
						s availableCount=totalCount-usedCount
						s SttTime=$p(oneRegTimeStr,"-",1) ;$zt($zth($p(oneRegTimeStr,"-",1)))
						s EndTime=$p(oneRegTimeStr,"-",2) ;$zt($zth($p(oneRegTimeStr,"-",2)))
						s SeqNoStatusStr = ##class(web.DHCOPAdmReg).GetSeqNoStatusStr(ASRowId,oneRegTimeStr)
						f SeqNoStatusStrIndex=1:1:$l(SeqNoStatusStr,",") {
							s SeqNoStatus = $p(SeqNoStatusStr,",",SeqNoStatusStrIndex)
							q:SeqNoStatus=""
							s OneScheduleObj.seqno=$p(SeqNoStatus,":",1)
							s OneScheduleObj.seqnoStatus=$p(SeqNoStatus,":",2)
							s OneScheduleObj.scheduleStartTime=SttTime
							s OneScheduleObj.scheduleEndTime=EndTime
							do OutputObj.ScheduleData.Insert(OneScheduleObj)
							s RecordCount=RecordCount+1
						}
					}
				}else{
				do OutputObj.ScheduleData.Insert(OneScheduleObj)
				s RecordCount=RecordCount+1
				}
				;w "TRStr=="_TRStr,!
				/*if (TRRegNumStr'=""){
					Set AQRowid=0
	 				//Set AQStr=""
	 				s StartNum=0
	 				s EndNum=0
	 				s APPMethodRowId=$O(^RBC("APTM",0,"Code",AppRegMethodCode,0))
	 				For{
		 				Set AQRowid=$o(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid))
		 				Quit:AQRowid=""
						s APPMethodDR=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",1)
						continue:(APPMethodRowId'="")&&(APPMethodRowId'=APPMethodDR)
	 					s StartNum=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",3)
	 					s Num=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",2)
	 					s EndNum=StartNum+Num
	 				}
	 				
					s QueueNO=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")),"^",4)
					s len=$l(TRRegNumStr,",")
					f i=1:1:len d
				    .s oneRegNumStr=$p(TRRegNumStr,",",i)
				    .s sRegNum=$p(oneRegNumStr,"-",1)
				    .s eRegNum=$p(oneRegNumStr,"-",2)
				    .q:(StartNum>eRegNum)!(EndNum<sRegNum)
				    .s oneRegTimeStr=$p(TRRegTimeStr,",",i)
					.s totalCount=$p(oneRegNumStr,"-",2)-$p(oneRegNumStr,"-",1)+1
					.s usedCount=..GetUsedCount(oneRegNumStr,QueueNO)
					.s availableCount=totalCount-usedCount
					.s SttTime=$p(oneRegTimeStr,"-",1) ;$zt($zth($p(oneRegTimeStr,"-",1)))
					.s EndTime=$p(oneRegTimeStr,"-",2) ;$zt($zth($p(oneRegTimeStr,"-",2)))
					.s SeqNoStatusStr = ##class(web.DHCOPAdmReg).GetSeqNoStatusStr(ASRowId,oneRegTimeStr)
					.f SeqNoStatusStrIndex=1:1:$l(SeqNoStatusStr,",") d
					..s SeqNoStatus = $p(SeqNoStatusStr,",",SeqNoStatusStrIndex)
					..q:SeqNoStatus=""
					..s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
					..s OneScheduleObj.seqno=$p(SeqNoStatus,":",1)
					..s OneScheduleObj.seqnoStatus=$p(SeqNoStatus,":",2)
					..s OneScheduleObj.scheduleId=ASRowId
					..s OneScheduleObj.scheduleDate=$zd(ASDate,3)
					..s OneScheduleObj.scheduleStartTime=SttTime
					..s OneScheduleObj.scheduleEndTime=EndTime
					..s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
					..s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
					..s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
					..s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum //totalCount
					..s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableTotalNum //availableCount
					..s DoctorSessType=OneAdmScheduleObj.DoctorSessType
					..i (DoctorSessType["普诊")||((DoctorSessType["普通")) s DoctorSessType=3
					..else  if DoctorSessType="特需" s DoctorSessType=5
					..else  s DoctorSessType=4
					..s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
					..s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
					..s OneScheduleObj.comment=OneAdmScheduleObj.Note
					..d OutputObj.ScheduleData.Insert(OneScheduleObj)
					..s RecordCount=RecordCount+1
					
				}else{
					s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
					s OneScheduleObj.scheduleId=ASRowId
					s OneScheduleObj.scheduleDate=$zd(ASDate,3)
					s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
					s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
					s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
					s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
					s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
					s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum
					s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableLeftNum
					s DoctorSessType=OneAdmScheduleObj.DoctorSessType
					i (DoctorSessType["普诊")||((DoctorSessType["普通")) s DoctorSessType=3
					else  if DoctorSessType="特需" s DoctorSessType=5
					else  s DoctorSessType=4
					s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
					s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
					s OneScheduleObj.comment=OneAdmScheduleObj.Note
					do OutputObj.ScheduleData.Insert(OneScheduleObj)
					s RecordCount=RecordCount+1
				}*/
				
				s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
				s OneScheduleObj.scheduleId=ASRowId
				s OneScheduleObj.scheduleDate=$zd(ASDate,3)
				s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
				s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
				s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
				
				;b;; DoctorCode
				s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
				s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
				s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum
				s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableLeftNum
				s DoctorSessType=OneAdmScheduleObj.DoctorSessType
				i (DoctorSessType["普诊")||((DoctorSessType["普通")) s DoctorSessType=3
				else  if DoctorSessType="特需" s DoctorSessType=5
				else  s DoctorSessType=4
				s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
				s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
				s OneScheduleObj.comment=OneAdmScheduleObj.Note
				do OutputObj.ScheduleData.Insert(OneScheduleObj)
				s RecordCount=RecordCount+1
			}
		}
	}
	
	Q
}

/// 预约登记
/// 对应HIS锁号功能
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).RegLock("{""scheduleId"":""1846||16"",""scheduleDate"":""2020-07-11"",""scheduleStartTime"":""07:30:00"",""scheduleEndTime"":""11:30:00"",""departmentId"":""7"",""providerId"":""1056"",""createSourceKey"":""UM"",""createSourceTypeId"":6,""patientFamilyName"":""李"",""patientGivenName"":""艳蓉"",""pati   entFullName"":""李艳蓉"",""patientMobileNumber"":""18687809001"",""patientIdType   Id"":3,""patientId"":""530111198807203840"",""appointmentId"":"""",""appointmentSerialNumber"":"""",""appointmentTypeId"":""4"",""appointmentStatusId"":""4"",""isCancellable"":""true"",""updateDate"":"""",""updateTime"":""""}"_$c(10,10),"WX","JTHLWWXZF")
ClassMethod RegLock(JsonInput, ExtUserID, PayModeCode)
{
	s ^nk("RegLockOutSide")=$LB(JsonInput, ExtUserID, PayModeCode)
	s $ZTRAP="RegLockErr"
	s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRt).%New()
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s ScheduleItemCode=obj.scheduleId
	s scheduleDate=obj.scheduleDate
	s scheduleStartTime=obj.scheduleStartTime
	s scheduleEndTime=obj.scheduleEndTime
	s departmentId=obj.departmentId
	s providerId=obj.providerId
	s createSourceKey=obj.createSourceKey ;预约来源（若为环球医疗，则值为“UM”）
	s createSourceTypeId=obj.createSourceTypeId ;预约途径(1 和 2作为预留，暂不使用，3 Web、 4App-android、 5App-ios、 6Wechat)
	s patientFullName=obj.patientFullName ;患者姓名 张三
	s patientMobileNumber=obj.patientMobileNumber ;患者手机号 18811112222
	s patientIdTypeId=obj.patientIdTypeId ;患者 Id 类型（1、2、 4 和 5 预留，暂不使用，3 身份证号,6 电子健康卡,7 HIS系统ID）
	s patientId=obj.patientId ;患者 Id
	s appointmentId=obj.appointmentId ;预约记录 Id
	s appointmentSerialNumber=obj.appointmentSerialNumber ;预约序列号
	s appointmentTypeId=obj.appointmentTypeId ;挂号类别
	s appointmentStatusId=obj.appointmentStatusId ;预约状态（1 和 2作为预留， 暂不使用， 3 已申请预约、 4 已预约、 5已过期、 6 已取消）
	s isCancellable=obj.isCancellable ;是否可以取消预约（true 是 false否）
	s updateDate=obj.updateDate ;记录更新日期（格式 yyyy-MMdd）
	s updateTime=obj.updateTime ;记录更新时间（格式 hh:mm:ss）

	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="预约登记成功"
	
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	
	s (CardType,CardNo,PatientID)=""
	s PatCard=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetPatCard(patientIdTypeId,patientId)
	if $p(PatCard,"^",1)'=""{
		s PatientID=$p(PatCard,"^",1)	
	}else{
		s CardType=$p(PatCard,"^",2)	
		s CardNo=$p(PatCard,"^",3)		
	}

	s InputObj.ScheduleItemCode=ScheduleItemCode
	s InputObj.ExtUserID=ExtUserID
	s AdmLocDr=$P(^RB("RES",+ScheduleItemCode),"^",1) ;科室ID
	s hopitalID=$P(^CTLOC(AdmLocDr),"^",22) ;医院 id
	s InputObj.CardNo=CardNo
	s InputObj.CardType=CardType
	s InputObj.LockQueueNo=appointmentSerialNumber
	s InputObj.PatientID=PatientID
	s InputObj.BeginTime=scheduleStartTime
	s InputObj.EndTime=scheduleEndTime
	s InputObj.Mobile=patientMobileNumber
	s InputObj.HospitalID=hopitalID
	;因为用户是平台写死传入的WX,在此作处理根据预约的科室来判断，如果是密地则传入WXMD
	if (ExtUserID="WX")&&(hopitalID=3) s InputObj.ExtUserID="WXMD"
	do InputObj.XMLExportToString(.InputXML,"Request")
	s LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(InputXML,"Y",PayModeCode)
	s ResultCode=LockOutputObj.ResultCode
	s ResultContent=LockOutputObj.ResultContent
	do LockOutputObj.XMLExportToString(.a)
	
	if ResultCode="0"{
		s TransactionId=LockOutputObj.TransactionId
		s AppointObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appoint).%New()
		s AppointObj.appointmentId=TransactionId
		s OutputObj.AppointData=AppointObj
		
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
		if CTLSRowID'=""{
			;预约来源,预约途径,联系电话,挂号类别,预约状态,是否可以取消预约,记录更新日期,记录更新时间
			s ^CTLS(CTLSRowID,"OrgUnit")=createSourceKey_"^"_createSourceTypeId_"^"_patientMobileNumber_"^"_appointmentTypeId_"^"_appointmentStatusId_"^"_isCancellable_"^"_updateDate_"^"_updateTime
		}
	}else{
		s OutputObj.responseCode=ResultCode	
		s OutputObj.respongseText=ResultContent	
	}
	do OutputObj.XMLExportToString(.b)
	b
	Q OutputObj
RegLockErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","RegLock调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据排班列表List查询预约列表
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetBookReg("{""scheduleIdList"":[""10001"", ""10002"", ""10003""]}","getAppListBySche")
ClassMethod GetRegLockBySchedule(JsonInput, ExtUserID)
{
	
	s $ZTRAP="GetRegLockByScheduleErr"
	;scheduleIdList:["10001", "10002", "10003"]
	s ^lyr("GetRegLockBySchedule")=$lb(JsonInput,ExtUserID)
	s JsonInput=$tr(JsonInput,$C(10,9),"")
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	s RecordCount=0
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonInput,.JsonArray)
	s myloop=0
	for{
		s myloop=$o(JsonArray("scheduleIdList",myloop))
		Q:myloop=""	
		s ScheudleID=JsonArray("scheduleIdList",myloop)
		Q:'$d(^RB("RES",+ScheudleID))
		s PatNo=""
		f  s PatNo=$o(^CTLS(0,"SchedulePatNo",ScheudleID,PatNo)) q:PatNo=""  d
		.s CTLSRowID=""
		.f  s CTLSRowID=$o(^CTLS(0,"SchedulePatNo",ScheudleID,PatNo,CTLSRowID)) q:CTLSRowID=""  d
		..Q:'$d(^CTLS(CTLSRowID))
		..s myobj=..GetAppointObj(CTLSRowID)
		..if $IsObject(myobj) d
		...d OutputObj.AppointListData.Insert(myobj)
		...s RecordCount=RecordCount+1
	}
	
	Q OutputObj
GetRegLockByScheduleErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRegLockBySchedule调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据患者ID 查询预约列表
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegLockByPatient("{""patientIdTypeId"":""3"",""patientId"":""530111198807203840"",""startDate"":""2020-07-01"",""endDate"":""2020-07-06""}","WX")
ClassMethod GetRegLockByPatient(JsonInput, ExtUserID)
{
	s ^nk("GetRegLockByPatient")=$LB(JsonInput, ExtUserID)
	s $ZTRAP="GetRegLockByPatientErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s patientIdTypeId=obj.patientIdTypeId
	s patientId=obj.patientId
	s StartDate=obj.startDate
	s EndDate=obj.endDate
	
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1001","操作员信息为空")
		q OutputObj
	}
	i StartDate="" {
		d ..SetOutputCode(.OutputObj,"-1002","开始日期不能都为空.")
		q OutputObj
	}else{
		i $l(StartDate,"-")'=3 {
			d ..SetOutputCode(.OutputObj,"-1002","开始日期格式不对.")
			q OutputObj
		}else{
			s StartDate=$zdh(StartDate,3)	
		}
	}
	i EndDate="" {
		;d ..SetOutputCode(.OutputObj,"-1003","结束日期不能都为空.")
		;q OutputObj
	}else{
		i $l(EndDate,"-")'=3 {
			d ..SetOutputCode(.OutputObj,"-1003","结束日期格式不对.")
			q OutputObj
		}
		s EndDate=$zdh(EndDate,3)	
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	
	s (CardType,CardNo,PatientID)=""
	s PatCard=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetPatCard(patientIdTypeId,patientId)
	if $p(PatCard,"^",1)'=""{
		s PatientID=$p(PatCard,"^",1)	
	}else{
		s CardType=$p(PatCard,"^",2)	
		s PatientCard=$p(PatCard,"^",3)		
	}
	
	s myPatientID=""
	if PatientID'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientID,"U"),""))
	}else{
		if PatientCard'=""{
			s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
			s myPatientID=##Class(DHCExternalService.RegInterface.SelfRegMethods).getPatIDByCardInfo(CardType,PatientCard)
		}
	}
	b ;
	if myPatientID=""{
		d ..SetOutputCode(.OutputObj,"-1004","系统中未查询到对应患者信息")
		q OutputObj
	}
	s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
	s RecordCount=0
	s Schedule="" 
	f  s Schedule=$o(^CTLS(0,"PatNoSchedule",PatientNo,Schedule)) q:Schedule=""  d
	
	.Q:'$d(^RB("RES",+Schedule))
	.s CTLSRowID=""
	.f  s CTLSRowID=$o(^CTLS(0,"PatNoSchedule",PatientNo,Schedule,CTLSRowID)) q:CTLSRowID=""  d
	
	..Q:'$d(^CTLS(CTLSRowID))
	..s UpdateDate=$p(^CTLS(CTLSRowID),"^",4)

	..Q:(StartDate'="")&&(StartDate>UpdateDate)
	..Q:(EndDate'="")&&(EndDate'>UpdateDate)
	..s myobj=..GetAppointObj(CTLSRowID)
	..b
	..if $IsObject(myobj) d
	...d OutputObj.AppointListData.Insert(myobj)
	...s RecordCount=RecordCount+1
	Q OutputObj
	do OutputObj.XMLExportToString(.yy)
	b ;p
GetRegLockByPatientErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRegLockByPatient调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据预约登记ID 查询预约列表
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetBookReg("{""appointmentId"":""DHC200515150205000005"","getAppListBySche")
ClassMethod GetRegLockById(JsonInput, ExtUserID)
{
	s $ZTRAP="GetRegLockByIdErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s appointmentId =obj.appointmentId 
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	if (appointmentId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约记录ID不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""),-1)
	if CTLSRowID=""{
    	d ..SetOutputCode(.OutputObj,"-1003","此预约记录ID未找到预约登记信息")
		q OutputObj
	}
	
	s myobj=..GetAppointObj(CTLSRowID)
	if $IsObject(myobj) d
	.s OutputObj.AppointListData1=myobj
	
	q OutputObj
GetRegLockByIdErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRegLockById调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据锁号记录ID获取预约信息
/// /w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetAppointObj(27)
ClassMethod GetAppointObj(CTLSRowID) As DHCDoc.Interface.Outside.OrganizationUnit.Entity.appointList
{
	s CTLSOBJ=##class(User.CTLockSchedule).%OpenId(CTLSRowID)
	s Schedule=CTLSOBJ.CTSchedule
	s LockQueueNo=CTLSOBJ.CTLockQueueNo
	s UpdateDate=CTLSOBJ.CTUpdateDate
	s UpdateTime=CTLSOBJ.CTUpdatTime
	s ActiveFlag=CTLSOBJ.CTActiveFlag
	s HISAdmDr=CTLSOBJ.CTHISAdmDr
	s HISTradeNo=CTLSOBJ.CTHISTradeNo
	s LastUpdatUser=CTLSOBJ.CTLastUpdatUser
	s PatientNo=CTLSOBJ.CTPatNo
	d CTLSOBJ.%Close()
	if HISAdmDr'=""{
		Set PatientID=$p(^PAADM(HISAdmDr),"^",1)
	}else{
		Set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}
	Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //病人姓名
	s OrgUnitStr=$g(^CTLS(CTLSRowID,"OrgUnit"))
	s appointmentStatusId=3
	s isCancellable="true"
	if HISAdmDr'=""{
		s VisitStatus=""
		s VisitStatus=$P($G(^PAADM(HISAdmDr)),"^",20)
		s AdmDate=$P($G(^PAADM(HISAdmDr)),"^",6)
		i AdmDate>+$h  s isCancellable="true"
		else  s isCancellable="false"
		s appointmentStatusId=4
		
		if VisitStatus'="A"{
			s appointmentStatusId=6
			s isCancellable="false"
			
		}
	}else{
		if ActiveFlag'="Y"{
			if LastUpdatUser="P" s appointmentStatusId=6   //P患者自动解锁
			else  if LastUpdatUser="D" s appointmentStatusId=5  //超时解锁
			s isCancellable="false"	
			
		}	
	}
	b
	s RBASObj=##class(User.RBApptSchedule).%OpenId(Schedule)
	Q:'$IsObject(RBASObj) ""
	s ASDate=RBASObj.ASDate
	s ASDate=$zd(ASDate,3)
	s ASStartTime=RBASObj.ASSessStartTime
	s:ASStartTime'="" ASStartTime=$ZT(ASStartTime,1) 
	s ASEndTime=RBASObj.ASSessEndTime
	s:ASEndTime'="" ASEndTime=$ZT(ASEndTime,1) 
	s departmentId=RBASObj.ASRESParRef.RESCTLOCDRGetObjectId()
	s providerId=RBASObj.ASRESParRef.RESCTPCPDRGetObjectId()
	d RBASObj.%Close()
	
	;预约来源,预约途径,联系电话,挂号类别,预约状态,是否可以取消预约,记录更新日期,记录更新时间
	;s ^CTLS(CTLSRowID,"OrgUnit")=createSourceKey_"^"_createSourceTypeId_"^"_patientMobileNumber_"^"_appointmentTypeId_"^"_appointmentStatusId_"^"_isCancellable_"^"_updateDate_"^"_updateTime
	s appobj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appointList).%New()
	s appobj.appointmentId=HISTradeNo
	s appobj.appointmentSerialNumber=LockQueueNo
	s appobj.appointmentTypeId=$p(OrgUnitStr,"^",4)
	s appobj.appointmentStatusId=appointmentStatusId ;3 已申请预约、 4 已预约、 5已过期、 6 已取消
	s appobj.scheduleId=Schedule
	s appobj.scheduleDate=ASDate
	s appobj.scheduleStartTime=ASStartTime
	s appobj.scheduleEndTime=ASEndTime
	s appobj.departmentId=departmentId
	s appobj.providerId=providerId
	
	
	s appobj.createSourceKey=$p(OrgUnitStr,"^",1)
	s appobj.createSourceTypeId=$p(OrgUnitStr,"^",2)
	s appobj.patientFamilyName=$e(PatName,1,1)
	s appobj.patientGivenName=$e(PatName,2,$l(PatName))
	s appobj.patientFullName=PatName
	s appobj.patientMobileNumber=$p(OrgUnitStr,"^",3)
	s appobj.patientIdTypeId=7 ;Id 类型（1、2、 4 和 5 预留，暂不使用， 3 身份证号,6 电子健康卡,7 His系统ID）
	s appobj.patientId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
	s appobj.isCancellable=isCancellable ;是否可以取消预约 true 是 false
	s appobj.updateDate=$ZD(UpdateDate,3) 
	s appobj.updateTime=$ZT(UpdateTime,1) 

	Q appobj
}

/// 根据预约登记ID 更新预约登记记录
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).UpdateBookReg("DHC200705101912000085","{""appointmentStatusId"":6}","WX")
ClassMethod UpdateBookReg(appointmentId, JsonInput, ExtUserID)
{
  
    s ^nk("UpdateBookReg")=$LB(appointmentId, JsonInput,ExtUserID)
	s $ZTRAP="UpdateBookRegErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	;s appointmentId =obj.appointmentId 
	s appointmentStatusId =obj.appointmentStatusId 

	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	if (appointmentId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约记录ID不能为空")
		q OutputObj
	}
	;s appointmentStatusId=6
	if (appointmentStatusId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约状态代码不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	s AppointObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.updappoint).%New()
	;预约状态（1 和 2 作为预留， 暂不使用，3 已申请预约、 4 已预约、 5 已过期、 6已取消）
	if appointmentStatusId=6{
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""),-1)
		if CTLSRowID'=""{
			s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
			if HISAdmDr'=""{
				;退号
				s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRq).%New()
				s InputObj.ExtUserID=ExtUserID
				s InputObj.TransactionId=appointmentId
				s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""))
				s RESRowid=+$p(^CTLS(CTLSRowID),"^",2)  ;资源表ID
				s AdmLocDr=$P(^RB("RES",RESRowid),"^",1) ;科室ID
				s hopitalID=$P(^CTLOC(AdmLocDr),"^",22) ;医院 id
				;因为用户是平台写死传入的WX,在此作处理根据预约的科室来判断，如果是密地则传入WXMD
				if (ExtUserID="WX")&&(hopitalID=3) s InputObj.ExtUserID="WXMD"
				s InputObj.HospitalId=hopitalID
				
				do InputObj.XMLExportToString(.InputXML,"Request")
				s RegOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegReturn(InputXML)
				s ResultCode=RegOutputObj.ResultCode
				s ResultContent=RegOutputObj.ResultContent
				if ResultCode="0"{
					s AppointObj.appointmentId=appointmentId
				}else{
					b ;ooo
					s OutputObj.responseCode=ResultCode	
					s OutputObj.respongseText=ResultContent	
				}
			}else{
				;取消锁号
				s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRt).%New()
				s InputObj.ExtUserID=ExtUserID
				s InputObj.TransactionId=appointmentId
				do InputObj.XMLExportToString(.InputXML,"Request")
				s LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).UnLockOrder(InputXML)
				s ResultCode=LockOutputObj.ResultCode
				s ResultContent=LockOutputObj.ResultContent
				if ResultCode="0"{
					s TransactionId=LockOutputObj.TransactionId
					s AppointObj.appointmentId=appointmentId
				}else{
					s OutputObj.responseCode=ResultCode	
					s OutputObj.respongseText=ResultContent	
				}	
			}
		}else{
			s OutputObj.responseCode="-1000"	
			s OutputObj.respongseText="该预约记录ID对应记录不存在"		
		}
	}elseif appointmentStatusId=4{
		;支付 - 不做处理
		s AppointObj.appointmentId=appointmentId
	}
	s OutputObj.UpdateAppointData=AppointObj
	Q OutputObj
UpdateBookRegErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","UpdateBookReg调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据预约记录ID（锁号ID）获取账单信息
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegBillInfo("{"appointmentId"":""DHC200710194440000085""},"WX")
ClassMethod GetRegBillInfo(JsonInput, ExtUserID)
{
	s $ZTRAP="GetRegBillInfoErr"
	s ^templu("GetRegBillInfo")=$lb(JsonInput,ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s appointmentId =obj.appointmentId 
	s appointmentStatusId =obj.appointmentStatusId 
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	if (appointmentId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约记录ID不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	
	s BillInfoObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appbillinfo).%New()
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""),-1)
	if CTLSRowID'=""{
		s billNumber=""
		s paymentMethodId="1" ;账单支付方式
		s paymentExpirationDate=""
		s paymentExpirationTime=""
		s updateDate=""
		s updateTime=""
		s billStatusId=3 ;支付状态（1 和2 作为预留， 暂不使用， 3 等待支付、 4 支付中、 5 支付成功、 6 支付失败、 7 支付已取消、 8 已申请退款、 9 退款处理中、 10 退款成功、 11 退款失败、 12 退款已取消）
		s HISPatNo=$p(^CTLS(CTLSRowID),"^",1)
		s HISShedule=$p(^CTLS(CTLSRowID),"^",2)
		s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
		s updateDate=$p(^CTLS(CTLSRowID),"^",10)
		s updateTime=$p(^CTLS(CTLSRowID),"^",11)
		s billNumber=$p(^CTLS(CTLSRowID),"^",13)
		b ;002
		i $d(^DHCBILLETPi(0,"HISTradeID",billNumber)) d
		.s ETPId=$O(^DHCBILLETPi(0,"HISTradeID",billNumber,""))
		.s paymentMethodId=$P(^DHCBILLETP(ETPId),"^",46)
		b ;001
	
		s updateDate1=$p(^CTLS(CTLSRowID),"^",4)
		s updateTime1=$p(^CTLS(CTLSRowID),"^",5)
		s CancelLocTime=..GETTimecloc(updateDate1,updateTime1)
		s paymentExpirationDate=$zd($p(CancelLocTime,"^",1),3)
		s paymentExpirationTime=$zt($p(CancelLocTime,"^",2),1)
		s HISPatientID=$O(^PAPERi("PAPMI_PatNo",HISPatNo,0))
		s DefaultBillType=""
		if HISPatientID'=""{
			s PatCatDr=$p(^PAPER(HISPatientID,"PER",1),"^",10)
			s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
			s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		}
		if HISAdmDr'=""{
			s billStatusId=5	
			s VisitStatus=$P($G(^PAADM(HISAdmDr)),"^",20)	
			if VisitStatus'="A"{
				s billStatusId=10
			}
		}else{
			s QueueNoActive=##class(web.DHCLockSchedule).CheckQueueNoActive(appointmentId,"","","")
			b ;QueueNoActive
			s QueueNoActiveFlag=$p(QueueNoActive,"^",1)
			s QueueNoActiveStr=$p(QueueNoActive,"^",2)
			if QueueNoActiveFlag'=1{
				s billStatusId=7
				s paymentExpirationDate=$zd(updateDate,3)
				s paymentExpirationTime=$zt(updateTime,1)
			}
		}
		
		s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(HISShedule,DefaultBillType,HISPatientID)
		s TotalFee=$p(DocResValue,"^",12)	//1
		s CheckFee=$p(DocResValue,"^",14)  //2
		s HoliFee=$p(DocResValue,"^",16)  //3
		s AppFee=$p(DocResValue,"^",18)   //4
		s ReCheckFee=$p(DocResValue,"^",15)  //6
		s OtherFee=$p(DocResValue,"^",20)  //6
		s TotalFee=(+TotalFee)+(+CheckFee)+(+HoliFee)+(+AppFee)+(+ReCheckFee)+(+OtherFee)
		
		s BillInfoObj.appointmentId=appointmentId
		s BillInfoObj.billNumber=billNumber
		s BillInfoObj.billStatusId=billStatusId
		
		s BillInfoObj.billAmount=TotalFee
		s BillInfoObj.paymentMethodId=paymentMethodId
		s BillInfoObj.paymentExpirationDate=paymentExpirationDate
		s BillInfoObj.paymentExpirationTime=paymentExpirationTime
		i updateDate="" s updateDate=updateDate1
		i updateTime="" s updateTime=updateTime1
		s BillInfoObj.updateDate=$zd(updateDate,3)
		s BillInfoObj.updateTime=$zt(updateTime)
	}else{
		s OutputObj.responseCode="-1000"	
		s OutputObj.respongseText="该预约记录ID对应记录不存在"		
	}

	s OutputObj.AppointBillData=BillInfoObj
	Q OutputObj
GetRegBillInfoErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRegBillInfo调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 更新账单信息，
/// 第三方支付后调用his挂号接口，第三方退费后保存交易信息(退号业务调用在UpdateBookReg方法中)
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).RegBill("DHC200702220115000082","{ ""billStatusId"" : 5, ""paymentMethodId"" : 3,""billNumber""  : ""20200702220115DHCC0046"",""billAmount""  : 9,""transactionNumber""  : ""111111""}","WX","JTHLWWXZF")
ClassMethod RegBill(appointmentId, JsonInput, ExtUserID, PayModeCode)
{
	s $ZTRAP="RegBillErr"
	s ^nk("RegBillWX")=$LB(appointmentId, JsonInput, ExtUserID, PayModeCode)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	;s appointmentId =obj.appointmentId 
	;支付成功后，传的是5
	;取消的话，如果是没支付的预约传7，已支付的退费成功传10
	s billStatusId =obj.billStatusId ;支付状态（1 和 2作为预留， 暂不使用， 3 等待支付、4 支付中、 5 支付成功、 6 支付失败、 7 支付已取消、 8 已申请退款、 9 退款处理中、 10 退款成功、 11 退款失败、 12 退款已取消）
	s paymentMethodId =obj.paymentMethodId 
	
	s billNumber =obj.billNumber ;His交易流水号 
	s billAmount =obj.billAmount ;支付金额
	s transactionNumber =obj.transactionNumber ;交易流水号

	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	 
	if (appointmentId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约记录ID不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	if (billNumber=""){
    	d ..SetOutputCode(.OutputObj,"-1002","账单号billNumber不能为空")
		q OutputObj
	}
	if (transactionNumber=""){
    	d ..SetOutputCode(.OutputObj,"-1002","交易流水号transactionNumber不能为空")
		q OutputObj
	}
	if PayModeCode=""{
		d ..SetOutputCode(.OutputObj,"-1002","His需配置支付方式")
		q OutputObj
	}
	
	if (billStatusId'="5")&&(billStatusId'="10"){
		d ..SetOutputCode(.OutputObj,"-1003","无法处理5和10以外的状态")
		q OutputObj
	}
	s RegBillObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appbill).%New()
	
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""),-1)
	if CTLSRowID'=""{
		s myobj=..GetAppointObj(CTLSRowID)
		if $IsObject(myobj){
			s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
			s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRq).%New()
			s InputObj.TransactionId=myobj.appointmentId
			s InputObj.TerminalID="UM"
			s InputObj.ScheduleItemCode=myobj.scheduleId
			s InputObj.ExtUserID=ExtUserID
			s InputObj.PatientID=myobj.patientId
			s InputObj.PayModeCode=PayModeCode
			s InputObj.PayFee=billAmount
			s InputObj.QueueNo=myobj.appointmentSerialNumber
			
		    s RESRowid=+$p(^CTLS(CTLSRowID),"^",2)  ;资源表ID
			s AdmLocDr=$P(^RB("RES",RESRowid),"^",1) ;科室ID
			s hopitalID=$P(^CTLOC(AdmLocDr),"^",22) ;医院 id
			;因为用户是平台写死传入的WX,在此作处理根据预约的科室来判断，如果是密地则传入WXMD
			if (ExtUserID="WX")&&(hopitalID=3) s InputObj.ExtUserID="WXMD"
			s InputObj.HospitalId=hopitalID
				
			s PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
			s PayDetailsObj.PayModeCode=PayModeCode
			s PayDetailsObj.TradeChannel="UM"
			s PayDetailsObj.PayAccountNo=transactionNumber
			s PayDetailsObj.PayAmt=InputObj.PayFee
			s PayDetailsObj.OutPayNo=transactionNumber
			s PayDetailsObj.PayChannel=paymentMethodId
			s PayDetailsObj.POSPayStr=""
			s PayDetailsObj.PayDate=$zd(+$h,3)
			s PayDetailsObj.PayTime=$zt($p($h,",",2),1)
			do PayDetailsObj.XMLExportToString(.PayDetailsXML,"PayDetails")
			s InputObj.PayDetails=PayDetailsObj
			do InputObj.XMLExportToString(.InputXML,"Request")
			b ;p
			;就诊ID为空，则为缴费支付后调用挂号
			;否则为退费时调用，调用计费接口保存退费交易信息
			b ;hhr HISAdmDr
			if HISAdmDr=""{
				Set LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister(InputXML,"Y",billNumber)
				s ResultCode=LockOutputObj.ResultCode
				s ResultContent=LockOutputObj.ResultContent
				if ResultCode="0"{
					s RegBillObj.appointmentId=appointmentId
					s OutputObj.RegBillData=RegBillObj
				}else{
					s OutputObj.responseCode=ResultCode	
					s OutputObj.respongseText=ResultContent	
				}
			}else{
				Set RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_HISAdmDr,""))
				if RegFeeRowId=""{
					d ..SetOutputCode(.OutputObj,"-1009","该预约记录ID未查询到对应挂号缴费记录")
					q OutputObj	
				}
				Set InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
				if InvoiceId=""{
					d ..SetOutputCode(.OutputObj,"-1009","该预约记录ID未查询到对应发票记录")
					q OutputObj	
				}
				Set GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
				Set HospitalId=hopitalID
				Set TradeType="OP"
				Set PatientID=$p(^PAADM(HISAdmDr),"^",1)
				Set TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_""_"^"_TradeType_"^"_PatientID_"^"_""_"^"_HISAdmDr
				;Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(billNumber,InvoiceId,.PayDetailsObj,TExpstr)
				S ^Hhr("saveRefInfo")=$LB(billNumber,InvoiceId,PayDetailsObj,TExpstr)
				Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SaveRefInfo(billNumber,InvoiceId,.PayDetailsObj,TExpstr)
				If (RetCode'=0){
					do ..SetOutputCode(.OutputObj,"-110226","保存交易信息失败！"_RetCode)
					quit OutputObj
				}
				s RegBillObj.appointmentId=appointmentId
				s OutputObj.RegBillData=RegBillObj
			}
			
		}else{
			d ..SetOutputCode(.OutputObj,"-1009","该预约记录ID未查询到对应预约记录")
			q OutputObj
		}
	}else{
		d ..SetOutputCode(.OutputObj,"-1009","该预约记录ID未查询到对应预约记录")
		q OutputObj
	}
	
	Q OutputObj
RegBillErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","RegBill调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

ClassMethod GetRefundBillNo(JsonInput, ExtUserID)
{
	s $ZTRAP="GetRefundBillNoErr"
	s ^Hhr("GetRefundBillNo")=$LB(JsonInput, ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s appointmentId =obj.appointmentId 
	;s appointmentId = JsonInput
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	if (appointmentId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","预约记录ID不能为空")
		q OutputObj
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	s RegFeeRowId=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",appointmentId,""))
	s RefundBillNo=""
	if (CTLSRowID'=""){
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		s RefundBillNo=$p(^CTLS(CTLSRowID),"^",14)
		set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
		if (ADMDr'=""){
			s RegFeeRowId=$o(^User.DHCRegistrationFeeI("ADM"," "_ADMDr,""))
		}
	}else{
		d ..SetOutputCode(.OutputObj,"-1003","该预约记录ID对应记录不存在")
		q OutputObj
	}
	if RegFeeRowId=""{
		d ..SetOutputCode(.OutputObj,"-1004","挂号记录不存在")
		q OutputObj
	}
	if RefundBillNo=""{
		d ..SetOutputCode(.OutputObj,"-1005","获取退费账单号失败")
		q OutputObj
	}
	s RfBillObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.getrefundbillno).%New()
	s RfBillObj.appointmentId=appointmentId
	s RfBillObj.billRefundNumber=RefundBillNo
	s OutputObj.RefBillData=RfBillObj
	
	Q OutputObj
GetRefundBillNoErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetRefundBillNo调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 查询排班信息
/// 对应HIS锁号功能
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).QueryAdmSchedule("{""scheduleId"":""1674||10""}","WX")
ClassMethod QueryAdmSchedule(JsonInput, ExtUserID)
{
	s $ZTRAP="QueryAdmScheduleErr"
	s ^Hhr("QueryAdmSchedule")=$LB(JsonInput, ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s ScheduleIDStr=obj.scheduleId
	
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="排班信息查询成功"
	if ScheduleIDStr=""{
		s OutputObj.responseCode="-1002"
		s OutputObj.respongseText="请传入排班ID"
		q OutputObj	
	}
	s PatientID=""
	s AppRegMethodCode="WIN"
	s RecordCount=0
	set ScheduleLen=$length(ScheduleIDStr,",")
	for loop=1:1:ScheduleLen
	{
		set ScheduleID=$piece(ScheduleIDStr,",",loop)
		s OneAdmScheduleObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOneAdmSchedule(ScheduleID,PatientID,AppRegMethodCode)
		if $IsObject(OneAdmScheduleObj) {
			s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
			s OneScheduleObj.scheduleId=ScheduleID
			s OneScheduleObj.scheduleDate=OneAdmScheduleObj.ServiceDate
			s SessStartTime=$p($g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",4)
			s SessEndTime=$p($g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",5)
			s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
			s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
			s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
			s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
			s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
			s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum
			s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableLeftNum
			s AppoType="3"
			i OneAdmScheduleObj.DoctorSessType["主任" s AppoType="4"
			s OneScheduleObj.appointmentTypeId=AppoType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
			s status=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",10)
			s statuscode=""
			i status'="" {
				s statuscode=$P(^DHCRBCASStatus(status),"^",1)
			}
			s isOutOfService="false"
			if ("^S^TR^PS^"[("^"_statuscode_"^")){
				s isOutOfService="true"
			}
			s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
			s OneScheduleObj.comment=OneAdmScheduleObj.Note
			b ;hhr totalCount
			s OutputObj.ScheduleData1=OneScheduleObj
			s RecordCount=RecordCount+1
		}
	}
	
	d OutputObj.XMLExportToString(.Input)
	Q OutputObj
	
QueryAdmScheduleErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","QueryAdmSchedule调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GETTimecloc(65563,54852)
ClassMethod GETTimecloc(data As %String, time As %String)
{
	//i (data'="")||(time'="")
	s ^lyrzt("GETTimecloc")=data_"^"_time
	s datat=+$h
	s timet=$P($H,",",2)
	s LockScheduleTime=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime"))
	s timeloc=time+LockScheduleTime
	i (timeloc>86399)  d
	.s datat=data+1
	.S timet=timeloc-86399
	e  d
	.s datat=data
	.s timet=timeloc
	b
	Q datat_"^"_timet
}

/// 查询排班信息
/// 对应HIS锁号功能
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).QueryAdmScheduleNew("{""scheduleIdList"":[""1679||31"",""1679||46"",""1679||28"",""1679||43"",""1679||61"",""1679||64"",""1679||58"",""1679||25"",""1679||38"",""1679||53"",""1679||34"",""1679||49""]}","WX")
ClassMethod QueryAdmScheduleNew(JsonInput, ExtUserID)
{
	s $ZTRAP="QueryAdmScheduleErrNew"
	s ^Hhr("QueryAdmScheduleErrNew")=$LB(JsonInput, ExtUserID)	
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="排班信息查询成功"
	s PatientID=""
	s AppRegMethodCode="WIN"
	s RecordCount=0
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonInput,.JsonArray)
	s myloop=0
	for{
		s myloop=$o(JsonArray("scheduleIdList",myloop))
		Q:myloop=""	
		s ScheduleID=JsonArray("scheduleIdList",myloop)
		b ;hhr h3
		s OneAdmScheduleObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOneAdmSchedule(ScheduleID,PatientID,AppRegMethodCode)
		if $IsObject(OneAdmScheduleObj) {
			s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
			s OneScheduleObj.scheduleId=ScheduleID
			s OneScheduleObj.scheduleDate=OneAdmScheduleObj.ServiceDate
			s SessStartTime=$p($g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",4)
			s SessEndTime=$p($g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",5)
			s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
			s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
			s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
			s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
			s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
			s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum
			b ;hhr totalCount
			s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableLeftNum
			s AppoType="3"
			if OneAdmScheduleObj.DoctorSessType["主任" s AppoType="4"
			s OneScheduleObj.appointmentTypeId=AppoType   //OneAdmScheduleObj.DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
			s status=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",10)
			s statuscode=""
			i status'="" {
				s statuscode=$P(^DHCRBCASStatus(status),"^",1)
			}
			s isOutOfService="false"
			if ("^S^TR^PS^"[("^"_statuscode_"^")){
				s isOutOfService="true"
			}
			s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
			s OneScheduleObj.comment=OneAdmScheduleObj.Note
			d OutputObj.ScheduleData.Insert(OneScheduleObj)
			s RecordCount=RecordCount+1
		}
	}
	
	d OutputObj.XMLExportToString(.Input)
	Q OutputObj
	
QueryAdmScheduleErrNew
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","QueryAdmSchedule调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}
ClassMethod UpdatePatientInfo(JsonInput, ExtUserID)
{
	s $ZTRAP="UpdatePatientInfoErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s PatHisId=obj.patientHisId	;string	是	患者在HIS系统的标识		P101010100
	s PatIdType=obj.patientIdTypeId	;int	否（普通患者时必填）	患者ID类型(1-预留2-预留3-身份证号)		3
	s PatID=obj.patientId	;string	否（普通患者时必填）	患者ID		110111188605069875
	s PatCardNo=obj.medicalCardId	;string	否	就诊卡号		88605069
	s PatName=obj.patientName	;string	是	患者姓名		张三
	s PatPhoneNo=obj.patientMobileNumber	;string	否	患者手机号		18811112222
	s PatBrith=obj.birthDate	;string	否	出生日期(格式 yyyy-MM-dd)		2021-03-16
	s PatAddress=obj.patientResidenceAddress	;string	否	患者居住地址		北京市西城区复兴门外大街999号院11号楼3单元502室
	s ForeignIdType=obj.reservedParentIdentifierTypeId	;int	否（当为新生儿患者时必填））	患者ID类型(1-预留2-预留3-身份证号)		3
	s ForeignId=obj.reservedParentIdentifier	;string	否（当为新生儿患者时必填）	预留家长身份证Id		110111188605069875
	s ForeignName=obj.reservedParentName	;string	否（当为新生儿患者时必填）	预留家长姓名		张三
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	if (PatIdType=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID类型不能为空")
		q OutputObj
	}
	if (PatID=""){
    	d ..SetOutputCode(.OutputObj,"-1001","患者ID不能为空")
		q OutputObj
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1002","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	s IDCardType=""
	s IDType=..#IDCardType
	if (IDType'=""){
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType)
		i IDCardType=""{
			s RtnObj.ResultCode="-1"
			s RtnObj.ErrorMsg="证件类型没有对照"
			q RtnObj
		}
	}
	/*s PatientIDStr=""
	if PatIdType=3{
		s IDCardType=..#IDCardType
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType)
		s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
		s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,PatID,PatName,GetPatientIDRule)
	}
	if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-330002","该身份证号信息在系统中未找到")*/
	s myPatientID=""
	s PatientID=""
	set PatientIDStrLen=$l(PatientIDStr,"^")
	s CardTypeIdStr="16^26"
	s CardDr=0
	for CardTypeCount=1:1:$l(CardTypeIdStr,"^"){
		s OneCardTypeId=$o(CardTypeIdStr,"^",CardTypeCount)
		
		for{
			s CardDr=$o(^DHCCARDi("CF",0,"CardTypeNo",OneCardTypeId,PatCardNo,CardDr))
			q:CardDr=""
			s CFActive=$p($g(^DHCCARD("CF",CardDr)),"^",10)
			Continue:CFActive'="N"
			s PatientID=$p($g(^DHCCARD("CF",CardDr)),"^",4)
		}
	}
	/*for mycount=1:1:PatientIDStrLen{
		q:PatientID'=""
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		set PatActive=$p(^PAPER(myPatientID,"PAT",1),"^",6)
		;过滤未激活
		continue:PatActive="N"
		if ('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID))) {
			s OutputObj.responseCode="-330002"
			s OutputObj.respongseText="该身份证号信息在系统中未找到"
		}
		continue:('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID)))
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:(PatientCardID="")||(PatientID'="")
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s CardNo=$p(^DHCCARD("CF",PatientCardID),"^",5)
			continue:PatCardNo'=CardNo
			s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			Continue:((CFCardTypeDR'=16)&(CFCardTypeDR'=26))  ;身份证和电子健康卡
		}
	}*/
	if PatientID="" d ..SetOutputCode(.OutputObj,"-330002","该身份证号信息在系统中未找到")
	Ts
	s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
	s PatMasObj=##class(User.PAPatMas).%OpenId(PatientID)
	s CardObj=##class(User.DHCCardRef).%OpenId(CardDr)
	s OldInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PatientID)
	if '$IsObject(PersonObj){
		d ..SetOutputCode(.OutputObj,"-330002","该身份证号信息在系统中未找到")
	}else{
		if PatPhoneNo'=""{
			s PersonObj.PAPERMobPhone=PatPhoneNo
			s PersonObj.PAPERTelH=PatPhoneNo
		}	
		i PatAddress'=""{
			i PersonObj.PAPERStName.Count()=0{
				d PersonObj.PAPERStName.Clear()
				;s PersonObj.PAPERStName.GetAt(i)
				d PersonObj.PAPERStName.Insert(PatAddress)
			}
		}
		i PatID'=""{
			s PatMasObj.PAPMIDVAnumber=PatID
			;s IDCardType="1"
			i PatMasObj.PAPMICardTypeDRGetObjectId()="" d PatMasObj.PAPMICardTypeDRSetObjectId(IDCardType)
			if IDCardType="1" d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PatientID,PatID)
		}
		if PatBrith'="" s PersonObj.PAPERDob= $zdh(PatBrith,"3")
		if ForeignId'="" s PersonObj.PAPERForeignCountry=ForeignId
		if ForeignName'="" s PersonObj.PAPERForeignId=ForeignName
		s sc=PersonObj.%Save()
		If $$$ISERR(sc) {
			Do $System.Status.DisplayError(sc)
			Trollback
			d ..SetOutputCode(.OutputObj,"-330005","更新人员信息失败PAPerson")
			quit OutputObj
		}
		s sc=PatMasObj.%Save()
		If $$$ISERR(sc) {
			Do $System.Status.DisplayError(sc)
			Trollback
			d ..SetOutputCode(.OutputObj,"-330005","更新人员信息失败PAPatMas")
			quit OutputObj
		}
		s NewInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PatientID)
		s LogInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).CheckPatInfoUpdate(OldInfo,NewInfo)
		s Flag=##class(web.DHCBL.Patient.DHCPatientBuilder).AddDHCPatientUpdateLog(LogInfo,UserID)
		b ;3
		if Flag'=0{
			Trollback
			d ..SetOutputCode(.OutputObj,"-330005","更新人员信息日志失败")
			quit OutputObj
		}
		if $IsObject(CardObj){
			s CardObj.CFIDCardNo=PatID
			s sc=CardObj.%Save()
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError(sc)
				Trollback
				d ..SetOutputCode(.OutputObj,"-330005","更新人员信息失败PAPatMas")
				quit OutputObj
			}
			d CardObj.%Close()
		}
		d PatMasObj.%Close()
		d PersonObj.%Close()
		Tc
	}
	s ResultCode=InsertRet.ResultCode
	s ResultContent=InsertRet.ResultContent
	Q OutputObj
UpdatePatientInfoErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","UpdatePatientInfoErr调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

}
