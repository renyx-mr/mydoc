/// Hosptal:四川攀钢集团医院
/// Description:  通用环球医疗集团有限公司_预约挂号功能对接接口
/// CreateDate:20200510
/// Creator:nikang
Class DHCDoc.Interface.Outside.OrganizationUnit.SelfReg Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

Parameter CardType = 07;
ClassMethod ReturnRegister()
{
	s ExtUserID=##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).#ExtUserID
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	s DefaultDeptDR=$p($g(^SSU("SSUSR",UserID)),"^",4)
	s GroupRowId=$p($g(^SSU("SSUSR",UserID)),"^",5)
	s HospitalDR=""
	s:DefaultDeptDR'="" HospitalDR=$p($g(^CTLOC(DefaultDeptDR)),"^",22)
	s AdmDate=$h-1
	s AdmId =0
	For {
		Set AdmId = $ORDER(^PAADMi("PAADM_AdmDate",AdmDate,AdmId))
		Quit:AdmId=""
		s CreateUser=$p(^PAADM(AdmId),"^",43)
		continue:UserID'=CreateUser
		s VisitStatus=$p(^PAADM(AdmId),"^",20)
		continue:VisitStatus'="A"
		d $$CancelOPRegist
	}
	q ""
CancelOPRegist
	s EpisodeID=" "_AdmId
	S RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",EpisodeID,0))
	q:RegfeeRowId=""
	s CancelOPRegistRtn=##class(web.DHCOPAdmReg).CancelOPRegist(RegfeeRowId,UserID,GroupRowId,DefaultDeptDR,"","N","",HospitalDR)
	d:+CancelOPRegistRtn'=0 ##class(DHCDoc.Log.Common).General("Insert","web.DHCOPAdmReg","CancelOPRegist","互联网自动退号接口调用失败","RetReg"_RegfeeRowId,$tr(CancelOPRegistRtn,"^",","))
	d:+CancelOPRegistRtn=0 ##class(DHCDoc.Log.Common).General("Insert","web.DHCOPAdmReg","CancelOPRegist","互联网自动退号接口调用成功","RetReg"_RegfeeRowId,$tr(CancelOPRegistRtn,"^",","))
	; 调用计费组的退费接口 
	q
}
/// 获取排班信息
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
			s OneAdmScheduleObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOneAdmSchedule(ASRowId,PatientID,AppRegMethodCode,"APP")
			//b ;;2
			if $IsObject(OneAdmScheduleObj) {
				;b:ASRowId["1152||325"
				
				;Continue:(ExtUserID="HLWYH")&&((OneAdmScheduleObj.DoctorCode'="375")&&(OneAdmScheduleObj.DoctorCode'="335")) ;QJH 2021-01-12先开放苗涛的号 
				;Continue:(ExtUserID="HLWYH")&&((OneAdmScheduleObj.DoctorCode'="375")&&(OneAdmScheduleObj.DoctorCode'="406"))  ;QJH 2021-01-12先开放苗涛主任 + 马国耀 的号 
				// 分时段数据
				;w ASRowId,!
				s SessRowid=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2))),"^",12)
				s TRStr=$g(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")) ;$g(^RB("RES",+SessRowid,"DATE",$p(SessRowid,"||",2),"SESS",$p(SessRowid,"||",3),"DHC"))
				s TRRegNumStr=$p(TRStr,"^",24)
				s TRRegTimeStr=$p(TRStr,"^",25)
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
	 					s EndNum=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"AQ",AQRowid),"^",2)
	 				}
	 			s SeqNoCount=EndNum-StartNum+1
				;w "TRStr=="_TRStr,!
				if (TRRegNumStr'=""){
					s QueueNO=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")),"^",4)
					s (ASQQty,ASQStartNum,startFlag)=0
				    &SQL(SELECT ASQ_Qty, ASQ_StartNum INTO:ASQQty,:ASQStartNum FROM SQLUser.DHC_RBApptScheduleAppQty WHERE ASQASParRef = :ASRowId AND ASQ_Method_DR = 1)
				    ;W ASQQty+ASQStartNum,!
				    s EndSeqNO = ASQQty+ASQStartNum-1
					s len=$l(TRRegNumStr,",")
					f i=1:1:len d
				    .s oneRegNumStr=$p(TRRegNumStr,",",i)
				    .s sRegNum=$p(oneRegNumStr,"-",1)
				    .s eRegNum=$p(oneRegNumStr,"-",2)
				    .q:(StartNum>eRegNum)!(EndNum<sRegNum)
				    .s oneRegTimeStr=$p(TRRegTimeStr,",",i)
				    .;w oneRegNumStr,!
				    .s EndRegNumCount=0
				    .i (($p(oneRegNumStr,"-",2)>=SeqNoCount)&&($p(oneRegNumStr,"-",1)<=SeqNoCount)) d
				    ..f oneRegNumStrStart=$p(oneRegNumStr,"-",1):1:$p(oneRegNumStr,"-",2) d
				    ...s:(oneRegNumStrStart<=SeqNoCount) EndRegNumCount = EndRegNumCount+1
					.s totalCount=$p(oneRegNumStr,"-",2)-$p(oneRegNumStr,"-",1)+1
					.;w EndRegNumCount_"^"_totalCount,!
					.s:EndRegNumCount'=0 totalCount=EndRegNumCount
					.s:(ASQStartNum'="")&&(startFlag=0) totalCount = eRegNum-ASQStartNum+1 s startFlag =1
					.s:(sRegNum<EndSeqNO)&&(EndSeqNO<eRegNum) totalCount = eRegNum-EndSeqNO
					.s usedCount=..GetUsedCount(oneRegNumStr,QueueNO)
					.;w oneRegNumStr_"^"_QueueNO_"^"_usedCount,!
					.s availableCount=totalCount-usedCount
					.;w "availableCount="_availableCount_"usedCount="_usedCount,!
					.s SttTime=$p(oneRegTimeStr,"-",1) ;$zt($zth($p(oneRegTimeStr,"-",1)))
					.s EndTime=$p(oneRegTimeStr,"-",2) ;$zt($zth($p(oneRegTimeStr,"-",2)))
					.;s SeqNoStatusStr = ##class(web.DHCOPAdmReg).GetSeqNoStatusStr(ASRowId,oneRegTimeStr)
					.;w SeqNoStatusStr,!
					.;f SeqNoStatusStrIndex=1:1:$l(SeqNoStatusStr,",") d
					.;s SeqNoStatus = $p(SeqNoStatusStr,",",SeqNoStatusStrIndex)
					.;q:SeqNoStatus=""
					.;q:($p(SeqNoStatus,":",1)<StartNum)!($p(SeqNoStatus,":",1)>EndNum)
					.;q:$p(SeqNoStatus,":",2)'=0 ;过滤掉不可用的号，环球要求只传可以用的
					.s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
					.;s OneScheduleObj.seqno=$p(SeqNoStatus,":",1)
					.;s OneScheduleObj.seqnoStatus=$p(SeqNoStatus,":",2)
					.s OneScheduleObj.scheduleId=ASRowId_"Z"_SttTime_":"_"00-"_EndTime_":"_"00" ;_$p(SeqNoStatus,":",1)
					.s OneScheduleObj.scheduleDate=$zd(ASDate,3)
					.s OneScheduleObj.scheduleStartTime=SttTime_":"_"00"
					.s OneScheduleObj.scheduleEndTime=EndTime_":"_"00"
					.s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
					.s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
					.;q:(ExtUserID="HLWYH")&&((OneScheduleObj.departmentId'="19")&&(OneScheduleObj.departmentId'="97")&&(OneScheduleObj.departmentId'="110")&&(OneScheduleObj.departmentId'="176")&&(OneScheduleObj.departmentId'="112"))
					.;w ExtUserID_OneScheduleObj.departmentId ,!
					.s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
					.s OneScheduleObj.totalCount=totalCount ;OneAdmScheduleObj.AvailableTotalNum //totalCount
					.s OneScheduleObj.availableCount=availableCount ;OneAdmScheduleObj.AvailableTotalNum //availableCount
					.s DoctorSessType=OneAdmScheduleObj.DoctorSessType
					.;i (DoctorSessType["普诊")||((DoctorSessType["普通")||(DoctorSessType["")) s DoctorSessType=3
					.;else  if DoctorSessType="特需" s DoctorSessType=5
					.;else  s DoctorSessType=4
					.i ((DoctorSessType["普诊")||(DoctorSessType["普通")||(DoctorSessType["主治")) s DoctorSessType=3
					.else  if DoctorSessType="特需" s DoctorSessType=5
					.else  if (DoctorSessType["主任")  s DoctorSessType=4
					.else  s DoctorSessType=3
					.s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
					.s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
					.s OneScheduleObj.comment=OneAdmScheduleObj.Note
					.d OutputObj.ScheduleData.Insert(OneScheduleObj)
					.s RecordCount=RecordCount+1
					
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
					i ((DoctorSessType["普诊")||(DoctorSessType["普通")||(DoctorSessType["主治")) s DoctorSessType=3
					else  if DoctorSessType="特需" s DoctorSessType=5
					else  if (DoctorSessType["主任")  s DoctorSessType=4
					else  s DoctorSessType=3
					s OneScheduleObj.appointmentTypeId=DoctorSessType ;挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
					s OneScheduleObj.isOutOfService=isOutOfService ;是否停诊（false 否 true 是）
					s OneScheduleObj.comment=OneAdmScheduleObj.Note
					do OutputObj.ScheduleData.Insert(OneScheduleObj)
					s RecordCount=RecordCount+1
				}
				
				/*s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
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
				s RecordCount=RecordCount+1*/
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
	s OutputObj.responseTextForUser=""          /////add  qjh
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	
	
	s (CardType,CardNo,PatientID)=""
	s PatCard=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetPatCard(patientIdTypeId,patientId)
	if $p(PatCard,"^",1)'=""{
		s PatientID=$p(PatCard,"^",1)	
	}else{
		s CardType=$p(PatCard,"^",2)	
		s CardNo=$p(PatCard,"^",3)		
	}
	s ScheduleItemCode = $p(ScheduleItemCode,"Z",1)
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
	//renyx    修改调用预约的锁号参数问题
	s LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(InputXML,"Y",PayModeCode)
	s ResultCode=LockOutputObj.ResultCode
	s ResultContent=LockOutputObj.ResultContent
    s responseTextForUser=LockOutputObj.ResultContent  ////add  qjh 	 
	do LockOutputObj.XMLExportToString(.a)
	
	if ResultCode="0"{
		s TransactionId=LockOutputObj.TransactionId
		s AppointObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appoint).%New()
		s AppointObj.appointmentId=TransactionId
		s obj={"ok":true,"err":false}
		s AppointObj.isOnlinePayRequired="false"
		if (..GetOnlinePayByASRowId(ScheduleItemCode))="1" s AppointObj.isOnlinePayRequired="true"
		s OutputObj.AppointData=AppointObj
		
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
		if CTLSRowID'=""{
			;预约来源,预约途径,联系电话,挂号类别,预约状态,是否可以取消预约,记录更新日期,记录更新时间
			s ^CTLS(CTLSRowID,"OrgUnit")=createSourceKey_"^"_createSourceTypeId_"^"_patientMobileNumber_"^"_appointmentTypeId_"^"_appointmentStatusId_"^"_isCancellable_"^"_updateDate_"^"_updateTime
		}
	}else{
		s OutputObj.responseCode=ResultCode	
		s OutputObj.respongseText=ResultContent	
		s OutputObj.responseTextForUser=ResultContent   ////add  qjh 	
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
		s ScheudleID=$p(JsonArray("scheduleIdList",myloop),"Z",1) ;;YYL  分时段排班  用Z 分割，原始排班后面通过 排班ID +“Z”+顺序号  
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
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegLockByPatient("{""patientIdTypeId"":""7"",""patientId"":""0000196511"",""startDate"":""2021-04-13"",""endDate"":""2021-05-13""}",10073)
ClassMethod GetRegLockByPatient(JsonInput, ExtUserID)
{
	s ^nk("GetRegLockByPatient")=$LB(JsonInput, ExtUserID)
	s $ZTRAP="GetRegLockByPatientErr"
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s patientIdTypeId=obj.patientIdTypeId
	s patientId=obj.patientId
	b ;patientId
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
	b   ;;;;qjh01
	s (CardType,CardNo,PatientID)=""
	s PatCard=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetPatCard(patientIdTypeId,patientId)
	b ;;;000000PatCard
	if $p(PatCard,"^",1)'=""{
		s PatientID=$p(PatCard,"^",1)	
	}else{
		s CardType=$p(PatCard,"^",2)	
		s PatientCard=$p(PatCard,"^",3)		
	}
	
	s myPatientID=""
	if PatientID'=""{
			b ;;PatientID
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientID,"U"),""))
		 	b ;;;myPatientID
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
/// /w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetAppointObj(1705)
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
	// 回传的排班ID要求和查询排班时的格式一致 Add by tyq 2021-07-09
	i $p(##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(Schedule,LockQueueNo)," ",2)'=""   d
	.s appobj.scheduleId=Schedule_"Z"_$p(##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(Schedule,LockQueueNo)," ",2) 
	.s appobj.scheduleStartTime=$P($P(appobj.scheduleId,"Z",2),"-",1)_":"_"00"  
	.s appobj.scheduleEndTime=$P($P(appobj.scheduleId,"Z",2),"-",2)_":"_"00" 
	.s appobj.scheduleId=$P($P(appobj.scheduleId,"Z",1),"-",1)_"Z"_""_appobj.scheduleStartTime_"-"_appobj.scheduleEndTime
	
	i $p(##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(Schedule,LockQueueNo)," ",2)=""   d
    
    .s appobj.scheduleStartTime=ASStartTime
	.s appobj.scheduleEndTime=ASEndTime
	.s appobj.scheduleId=Schedule_"Z"_appobj.scheduleStartTime_"-"_appobj.scheduleEndTime

    /*
	s appobj.scheduleId=Schedule_"Z"_$p(##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(Schedule,LockQueueNo)," ",2) 
	s appobj.scheduleDate=ASDate
	s appobj.scheduleStartTime=ASStartTime_":"_"00"
	s appobj.scheduleEndTime=ASEndTime_":"_"00"
	s appobj.departmentId=departmentId
	s appobj.providerId=providerId
	
	i appobj.scheduleId["Z"   d   ;add 不用qjh 开始时间，结束时间取分时段时间
	.s appobj.scheduleStartTime=$P($P(appobj.scheduleId,"Z",2),"-",1)_":"_"00"  
	.s appobj.scheduleEndTime=$P($P(appobj.scheduleId,"Z",2),"-",2)_":"_"00" 
	.s appobj.scheduleId=$P($P(appobj.scheduleId,"Z",1),"-",1)_"Z"_""_appobj.scheduleStartTime_"-"_appobj.scheduleEndTime
	. b ;;111
	*/   
	
	s appobj.scheduleDate=ASDate
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
	s obj={"ok":true,"err":false}
	s appobj.isOnlinePayRequired="false"
	if (..GetOnlinePayByASRowId(Schedule))="1" s appobj.isOnlinePayRequired="true"
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
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegBillInfo("{"appointmentId"":""DHC201117105934000103""},"")
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
		b ;;;;0033
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
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).RegBill("DHC210208084252074099","{ ""billStatusId"" : 5, ""paymentMethodId"" : 4,""billNumber""  : ""4200000781202102084047072087"",""billAmount""  : 9.5,""transactionNumber""  : ""20210208084252XYCH4930""}","WX","JTHLWWXZF")
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
			 b   ;;;paymentMethodId
			;s PayDetailsObj.TradeChannel="UM|"_myobj.paymentMethodld
			s PayDetailsObj.TradeChannel="UM|"_paymentMethodId
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
	if +LockScheduleTime=0 s LockScheduleTime=600
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

/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetMemberList("3","321102199605018111","张小山")
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetMemberList("{""patientIdTypeId"":3,""patientId"":""610422198903284017"",""patientName"":""屈建华""}","")
ClassMethod GetMemberList(JsonInput, ExtUserID)
{
	s $ZTRAP="GetMemberListErr"
	s ^Hhr("GetMemberListErr")=$LB(JsonInput, ExtUserID)	
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	s patientIdTypeId="",patientId="",patientName=""
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonInput,.JsonArray)
	s patientId = JsonArray("patientId")
	s patientIdTypeId = JsonArray("patientIdTypeId")
	s patientName = JsonArray("patientName")
	i patientIdTypeId="3" s patientIdTypeId="24"
	if (patientId=""){
		d ..SetOutputCode(.OutputObj,"-100","patientId不能为空！")
    	q OutputObj
	}
	if (patientIdTypeId=""){
		d ..SetOutputCode(.OutputObj,"-100","patientIdTypeId不能为空！")
    	q OutputObj
	}
	if (patientName=""){
		d ..SetOutputCode(.OutputObj,"-100","patientName不能为空！")
    	q OutputObj
	}
	if (patientIdTypeId=24){
		s PatId = $o(^PAPERi("DVA",patientId,""))
		if (PatId=""){
			d ..SetOutputCode(.OutputObj,"-100","此患者在HIS中不存在！")
    		q OutputObj
		}
		;s PatName = $p($g(^PAPER(PatId,"ALL")),"^",1)
		
	}
	s GetMemberListObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.GetMemberList).%New()
	s GetMemberListObj.memberHisId = "0"
	s GetMemberListObj.memberIdTypeId = $p($g(^PAPER(PatId,"ALL")),"^",25)
	s GetMemberListObj.memberId = $p($g(^PAPER(PatId,"PER",2)),"^",4)
	s GetMemberListObj.memberName = $p($g(^PAPER(PatId,"PER",2)),"^",13)
	s GetMemberListObj.memberMobileNumber = $p($g(^PAPER(PatId,"ALL")),"^",4)
	s GetMemberListObj.memberAddress = $p($g(^PAPER(PatId,"PER",1)),"^",1)
	s memberRelationId = $p($g(^PAPER(PatId,"EMP")),"^",4)
	s GetMemberListObj.memberRelationId = memberRelationId
	s GetMemberListObj.memberRelationName=""
	if (memberRelationId'=""){
		s GetMemberListObj.memberRelationName = $p($g(^CT("RLT",memberRelationId)),"^",2)
	}
	b ;;
	d OutputObj.GetMemberListData.Insert(GetMemberListObj)
	d OutputObj.XMLExportToString(.Input)
	Q OutputObj
	
GetMemberListErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","GetMemberListErr调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).UpdateFamilyMember("{""patientIdTypeId"":3,""patientId"":""610422198903284017"",""patientName"":""屈建华"",""memberTypeId"":""3"",""memberId"":""610622198903285017"",""memberName"":""测试"",""memberMobileNumber"":""18109209636"",""memberAddress"":""陕西咸阳"",""memberRelationId"":"""",""memberRelationName"":""}","").Read()
/// w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).UpdateFamilyMember(patientIdTypeId)
ClassMethod UpdateFamilyMember(JsonInput, ExtUserID)
{
	s $ZTRAP="UpdateFamilyMemberErr"
	s ^Hhr("UpdateFamilyMember")=$LB(JsonInput, ExtUserID)	
	b ;;1111
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	s patientIdTypeId="",patientId="",patientName="",membeIdTypeId="",memberId="",memberName="",memberMobileNumber="",memberAddress="",memberRelationId="",memberRelationName=""
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonInput,.JsonArray)
	s patientId = JsonArray("patientId")
	s patientIdTypeId = JsonArray("patientIdTypeId")
	i patientIdTypeId="3" s patientIdTypeId="24"
	s patientName = JsonArray("patientName")
	b ;;---
	s memberTypeId = JsonArray("memberTypeId")
	b ;--0
	i memberTypeId="3" s memberTypeId="24"
	s memberId = JsonArray("memberId")
	s memberName = JsonArray("memberName")
	s memberMobileNumber = JsonArray("memberMobileNumber")
	s memberAddress = JsonArray("memberAddress")
	s memberRelationId = JsonArray("memberRelationId")
	s memberRelationName = JsonArray("memberRelationName")
	if (memberRelationId=""){
		d ..SetOutputCode(.OutputObj,"-100","memberRelationId"_"不能为空！")
    	q OutputObj
	}
	if (memberMobileNumber=""){
		d ..SetOutputCode(.OutputObj,"-100","memberMobileNumber"_"不能为空！")
    	q OutputObj
	}
	if (memberName=""){
		d ..SetOutputCode(.OutputObj,"-100","memberName"_"不能为空！")
    	q OutputObj
	}
	if (memberId=""){
		d ..SetOutputCode(.OutputObj,"-100","memberId"_"不能为空！")
    	q OutputObj
	}
	if (memberTypeId=""){
		d ..SetOutputCode(.OutputObj,"-100","memberTypeId不能为空！")
    	q OutputObj
	}
	if (patientId=""){
		d ..SetOutputCode(.OutputObj,"-100","patientId不能为空！")
    	q OutputObj
	}
	if (patientIdTypeId=""){
		d ..SetOutputCode(.OutputObj,"-100","patientIdTypeId不能为空！")
    	q OutputObj
	}
	if (patientName=""){
		d ..SetOutputCode(.OutputObj,"-100","patientName不能为空！")
    	q OutputObj
	}
	if (patientIdTypeId=24){
		s PatId = $o(^PAPERi("DVA",patientId,""))
		if (PatId=""){
			d ..SetOutputCode(.OutputObj,"-100","此患者在HIS中不存在！")
    		q OutputObj
		}
		;s PatName = $p($g(^PAPER(PatId,"ALL")),"^",1)
		
	}
	b ;;;111
	
	s $p(^PAPER(PatId,"ALL"),"^",25) = memberTypeId
	s $p(^PAPER(PatId,"PER",2),"^",4) = memberId
	s $p(^PAPER(PatId,"PER",2),"^",13) = memberName
	s $p(^PAPER(PatId,"ALL"),"^",4) = memberMobileNumber
	s $p(^PAPER(PatId,"PER",1),"^",1) = memberAddress
	s $p(^PAPER(PatId,"EMP"),"^",4) = memberRelationId
	s UpdateFamilyMemberList=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.UpdateFamilyMemberList).%New()

	s UpdateFamilyMemberList.memberHisId = ""
	s UpdateFamilyMemberList.memberIdTypeId = memberTypeId
	s UpdateFamilyMemberList.memberId = memberId
	s UpdateFamilyMemberList.memberName = memberName
	
	d OutputObj.GetMemberListData.Insert(UpdateFamilyMemberList)
	d OutputObj.XMLExportToString(.Input)
	Q OutputObj
	
UpdateFamilyMemberErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","UpdateFamilyMemberErr调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetUsedCount("1180||1||9","asd")
ClassMethod GetUsedCount(RegNumStr As %String, QueueNO As %String) As %String
{
	s $zt="Err"
	//s RegNumStr="8-14"	;8-14
	//s QueueNO="1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:1,9:3,10:0,11:0,12:0,13:0,14:0,15:0,16:0,17:0,18:0,19:0,20:0,21:0,22:0,23:0,24:0,25:0,26:0,27:0,28:0,29:0,30:0"
	s UsedCount=0
	;s ^tmp("QueueNO",$j)=QueueNO
	q:(RegNumStr="")||(QueueNO="") UsedCount
	s QueueNO = $p(QueueNO,$c(1),1)
	f i=$p(RegNumStr,"-",1):1:$p(RegNumStr,"-",2) d
    .f k=1:1:$l(QueueNO,",") d
    ..s No=$p($p(QueueNO,",",k),":",1)
    ..;w "no=="_No,!
    ..q:No'=i
    ..s status=$p($p(QueueNO,",",k),":",2)
    ..;w "status=="_status,!
    ..s:status'=0 UsedCount=UsedCount+1
	q UsedCount
Err
	s $zt=""
	q 0
}

ClassMethod UpdatePatientInfoNew(JsonInput, ExtUserID)
{
	s $ZTRAP="UpdatePatientInfoErr"
UpdatePatientInfoErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","UpdatePatientInfoErr调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// 根据联系人获获取患者信息  
ClassMethod GetPatientInfo(JsonInput, ExtUserID)
{
	s $ZTRAP="GetPatientInfoErr"
	s ^nk("GetPatientInfo")=$LB(JsonInput, ExtUserID)
	s obj=##class(DHCDoc.Util.XMLParse).XMLToObj(##class(DHCDoc.Util.XMLParse).JSONToXML(JsonInput,"Request"))
	s PatCredType =obj.patientIdTypeId	;int	否（当为普通患者时必填）	患者ID类型(患 者 ID 类 型 （1，2，4 和 5，8，9，10 预留，暂不使 用，3 身份证 号，6 电子健 康卡，7 患者 在 HIS 系统的 标识，11-院内 就诊卡号 ）) 		3
	s patientId =obj.patientId	;string	否（当为普通患者时必填）	患者ID		110111188605069875，
	s PatName =obj.patientName	;string	否（当为新生儿患者时必填）	患者姓名		张三
	s PatPhoneNo =obj.patientMobileNumber	;string	否（当为新生儿患者时必填）	预留手机号		18811112222
	s PatBrith =obj.birthDate	;string	否	出生日期(格式 yyyy-MM-dd)		2021-03-16
	s ForeignIdType =obj.reservedParentIdentifierTypeId	;int	否（当为新生儿患者时必填））	患者ID类型(1-预留2-预留3-身份证号)		3
	s ForeignIdNo =obj.reservedParentIdentifier	;string	否（当为新生儿患者时必填）	预留家长身份证		110111188605069875
	s ForeignName =obj.reservedParentName	;string	否（ 当为新生儿患者时必填）	预留家长姓名		张三  
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="获取数据成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	if (ForeignIdType=""){
    	d ..SetOutputCode(.OutputObj,"-1001","联系人ID类型不能为空")
		q OutputObj
	}
	/*
	if (patientId=""){
    	d ..SetOutputCode(.OutputObj,"-1001","联系人ID不能为空")
		q OutputObj
	}
	*/
	if (ForeignName=""){
    	d ..SetOutputCode(.OutputObj,"-1001","联系人姓名不能为空")
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
	s PatientIDStr=""
	if ForeignIdType=3{
		;s IDCardType=..#IDCardType
		s IDCardType="24"
		s PatCredType="24"
		;s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType)
		;s PatCredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,PatCredType)
		s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
		d GetPatientIDStrByForeignInfo
		//s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,patientId,"",GetPatientIDRule)
	}
	
	/*if PatCredType="11"
	{
			
		/*&sql(DECLARE PatientIDStr CURSOR FOR
		SELECT CF_PAPMI_DR
		INTO :PatientIDStr
		FROM SQLUser.DHC_CardRef WHERE CF_CardNo=:patientId  AND CF_CardType_DR='2' and CF_ActiveFlag='N'  )
		s CardType=..#CardType
		s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
		s CFRowid=0
		for {
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",patientId,CFRowid)) Q:CFRowid=""
			s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			s PatientCardType=$p(^DHCCARDTYPEDef(CFCardTypeDR),"^",1)   ;1卡类型
			Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s PatientIDStr=$p(^DHCCARD("CF",CFRowid),"^",4)
		}
	}*/
	
	if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-330002","该身份证号信息在系统中未找到")
	s myPatientID=""
	set PatientIDStrLen=$l(PatientIDStr,"^")
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		;b ;11
		continue:myPatientID=""
		/*if ('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID))) {
			s OutputObj.responseCode="-330002"
			s OutputObj.respongseText="该身份证号信息在系统中未找到"
		}*/
		//continue:('$D(^DHCCARDi("CF",0,"TypePAPMINO","26",myPatientID)))
		Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		//医保号
		set PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
		set Sex=""
		set SexCode=$p(^PAPER(myPatientID,"ALL"),"^",7)
		i SexCode'="" set Sex=$p(^CT("SEX",SexCode),"^",2)
		set DOB=$p(^PAPER(myPatientID,"ALL"),"^",6)
		set DocumentID=$p(^PAPER(myPatientID,"PAT",1),"^",22)
		set AddressId=$o(^PAPER(myPatientID,"PER","ADD",""),-1)
		set Address=""
		set:AddressId'="" Address=$g(^PAPER(myPatientID,"PER","ADD",AddressId))
		set IDTypeDesc=""
		set IDTypeCode=$p(^PAPER(myPatientID,"PAT",3),"^",7)
		if IDTypeCode'="" set IDTypeDesc=$p(^PAC("CARD",IDTypeCode),"^",7)
		set IDNo=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
		s TelephoneNo=$p(^PAPER(myPatientID,"PER",1),"^",11)
		s Mobile=$p($g(^PAPER(myPatientID,"PER",4)),"^",21)
		if Mobile="" s Mobile=TelephoneNo
		s patientId=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
		s PatinetNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		s PatObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.getpatient).%New()
		s PatObj.patientIdTypeId="" ;patientIdTypeId
		s PatObj.patientId=patientId
		s PatObj.patientHisId=PatinetNo
		s PatObj.patientFamilyName=$e(PatientName,1,1)
		s PatObj.patientGivenName=$e(PatientName,2,$l(PatientName))
		;s PatObj.patientFullName=PatientName
		s PatObj.patientName=PatientName
		
		s PatObj.patientGenderTypeId=$case(Sex,"男":4,"女":3,:1) ;（1 未知、 2 其它、 3女、 4 男）
		s PatObj.patientMobileNumber=Mobile
		s PatObj.patientResidenceAddress=Address
		s PatObj.patientName=PatientName
		
		s PatientCardID=""
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:PatientCardID=""
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
			s CFDate=$p(^DHCCARD("CF",PatientCardID),"^",7)
			s CFTime=$p(^DHCCARD("CF",PatientCardID),"^",8)
			;Continue:((CFCardTypeDR'=16)&(CFCardTypeDR'=26))  ;身份证和电子健康卡
			s CardObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard).%New()
		    s CardObj.identifierTypeId=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetOutCardType(CFCardTypeDR) ;(1-预留2-预留 3-院内就诊卡 4-电子健康卡 5-门诊号码)
			i CFCardTypeDR=24  s CardObj.identifierTypeId=6
			i CFCardTypeDR=25  s CardObj.identifierTypeId=8
			i CFCardTypeDR=2  s CardObj.identifierTypeId=3
			;e  s CardObj.identifierTypeId=3    ;;标识类型 (1-预留2-预留3-院内就诊卡 4-电子健康卡 8-院内虚拟卡)
			s CardObj.identifierText=PatientCard
			s CardObj.isValid="true"
			s CardObj.createDate=$zd(CFDate,3)
			s CardObj.createTime=$zt(CFTime,1)
			s CardObj.lastUsedDate=$zd(CFDate,3)
			s CardObj.lastUsedTime=$zt(CFTime,1)
			s CardObj.mappedPatientHisId=PatinetNo
			d PatObj.patientIdentifierList.Insert(CardObj)
			
			d CardObj.%Close()
		}
		s OutputObj.PatientData=PatObj
		d OutputObj.%Close()
	}
	
	Q OutputObj
GetPatientIDStrByForeignInfo
	&sql(DECLARE PatByForeignList CURSOR FOR
		SELECT PAPER_RowId
		INTO :PatientId
		FROM SQLUser.PA_Person WHERE PAPER_ForeignId=:ForeignName AND PAPER_ForeignCountry=:ForeignIdNo 
			
	)
	&SQL(OPEN PatByForeignList)
	s intNum=0
 	For {
	 	&SQL(FETCH PatByForeignList) 
	 	QUIT:SQLCODE
	 	 b ;;;; PatientId
		s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
		continue:ActiveFlag="N"

	 	s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )
		;continue:(PatCredNo'="")&&(PatCredNo'=PAPMIDVAnumber)
		s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
		;continue:(PatCredType'="")&&(myCredTypeID'=PatCredType)
		s CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
		continue:(PatName'="")&&(PatName'=CurName) 
		if (PatientIDStr="") s PatientIDStr=PatientId
		else  s PatientIDStr=PatientIDStr_"^"_PatientId
 	}
 	&SQL(CLOSE PatByForeignList)
	q
GetPatientInfoErr
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	d ..SetOutputCode(.OutputObj,"-100","SavePatient调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

ClassMethod GetPatIdStrByForeignInfo(ForeignName As %String, ForeignIdNo As %String, ForeignIDCardType As %String, PatCredNo As %String = "", IDCardType As %String = "", PatName As %String = "", CardTypeID As %String = "")
{
	&sql(DECLARE PatIDListByForeign CURSOR FOR
		SELECT PAPER_RowId
		INTO :PatientId
		FROM SQLUser.PA_Person WHERE PAPER_ForeignId=:ForeignName AND PAPER_ForeignCountry=:ForeignIdNo 
		--AND PAPER_ForeignCardTypeDR=:ForeignIDCardType
	)
	&SQL(OPEN PatIDListByForeign)
	//b ;;;111
	s MyPatIDStr=""
	s intNum=0
	s HadFlag=0
	s Total=0
	s CurStatus=""
	s MyPatientId=""
 	For {
	 	&SQL(FETCH PatIDListByForeign) 
	 	QUIT:SQLCODE
		s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
		continue:ActiveFlag="N"
	 	s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )
		continue:(PatCredNo'="")&&(PatCredNo'=PAPMIDVAnumber)
		s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
		continue:(IDCardType'="")&&(myCredTypeID'=IDCardType)
		s CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
		continue:(PatName'="")&&(PatName'=CurName)
		s CurCardType=""
		f  s CurCardType=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientId,CurCardType)) 	q:(CurCardType="")  d
		.s CardID=0
		.f  s CardID=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientId,CurCardType,CardID)) 	q:(CardID="")  d
		..s Status=$P(^DHCCARD("CF",CardID),"^",10)
		..;s Status="D"
		..q:(Status'="N")&&(Status'="S")&&(Status'="UA")
		..s:CurCardType=CardTypeID HadFlag=1
		..s CurStatus=Status
		s MyPatientId=PatientId
		if (MyPatIDStr="") s MyPatIDStr=PatientId
		else  s MyPatIDStr=MyPatIDStr_"^"_PatientId
 	}
 	&SQL(CLOSE PatIDListByForeign)
	q HadFlag_"^"_MyPatientId_"^"_CurStatus_"^"_MyPatIDStr
}

ClassMethod GetScheduleold(JsonInput, ExtUserID)
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
		;b ;;;;12
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
	b ;;;1
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
	}
	else
	{
		s val=DepartmentCode_"^"_UserID_"^^^"_TimeRangeId_"^"_DoctorCode_"^"_GroupRowId_"^^false^^^1^^^1"
	}
	;b ;hhr val
	s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
	;查询时间段的预约排班信息
	;s rs=##Class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:OPDocList")
	i rs.QueryIsValid() { 
		Set Status=rs.Execute(val)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
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
			Continue:(ASDate=+$H)&&(SessEndTime<$p($h,",",2))
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
			s OneAdmScheduleObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOneAdmSchedule(ASRowId,PatientID,AppRegMethodCode,"APP")
			if $IsObject(OneAdmScheduleObj) {
				
				
				s OneScheduleObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule).%New()
				;b ;hhr OneScheduleObj
				s OneScheduleObj.scheduleId=ASRowId
				s OneScheduleObj.scheduleDate=$zd(ASDate,3)
				s OneScheduleObj.scheduleStartTime=$zt(SessStartTime,1)
				s OneScheduleObj.scheduleEndTime=$zt(SessEndTime,1)
				s OneScheduleObj.providerId=OneAdmScheduleObj.DoctorCode
				;Continue:(OneScheduleObj.providerId'="406")&&(OneScheduleObj.providerId'="827")  ;QJH 2021-01-12先开放苗涛+李润林教授的号 
				;b   ;; DoctorCode
				s OneScheduleObj.departmentId=OneAdmScheduleObj.DepartmentCode
				s OneScheduleObj.patientCharge=$fn(OneAdmScheduleObj.Fee,"",2)
				s OneScheduleObj.totalCount=OneAdmScheduleObj.AvailableTotalNum
				s OneScheduleObj.availableCount=OneAdmScheduleObj.AvailableLeftNum
				s DoctorSessType=OneAdmScheduleObj.DoctorSessType
				;i (DoctorSessType["普诊")||((DoctorSessType["普通")) s DoctorSessType=3
				;else  if DoctorSessType="特需" s DoctorSessType=5
				;else  s DoctorSessType=4
				i ((DoctorSessType["普诊")||(DoctorSessType["普通")||(DoctorSessType["主治")) s DoctorSessType=3
				else  if DoctorSessType="特需" s DoctorSessType=5
				else  if (DoctorSessType["主任")  s DoctorSessType=4
				else  s DoctorSessType=3
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

ClassMethod GetOnlinePayByASRowId(ASRowId As %String)
{
	s RetStr="0"
	s AsDocId=$P(^RB("RES",+ASRowId),"^",2)
	s RegisterInsertArcItem=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","RegisterInsert")
	if (RegisterInsertArcItem'=""){
		for ArcItemInd=1:1:$l(RegisterInsertArcItem,","){
			s OneArcItemInfo=$p(RegisterInsertArcItem,",")
			continue:OneArcItemInfo=""
			continue:AsDocId'=$p(OneArcItemInfo,"!",1)
			s RetStr="1"
		}
	}
	q RetStr
}

}
