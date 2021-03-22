Class DHCDoc.GanSuProvincialPlatform.SelRegMethod Extends %RegisteredObject
{

/// 查询科室信息
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetDeptInfo("<Request><Type>1</Type></Request>")
ClassMethod GetDeptInfo(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetDeptInfoErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s InType=InputObj.Type
	if (InType'="1")&&(InType'="2")&&(InType'="4") q $$GetDeptInfoErrMag("请传入正确的类型")
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	;q:UserID="" $$GetDeptInfoErrMag("没有找到用户")
	s AdmType=$case(InType,"1":"","2":"O","4":"E")
	;if AdmType="" q $$GetDeptInfoErrMag
	s OutPutObj={}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
	s HospitalId=$p($g(^SSU("SSUSR",UserID)),"^",98)
	set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,AdmType,HospitalId)
	b 
	s Dept=[]
	set myDeptNum=$length(myOPDeptStr,"^")
	b ;001
	for i=1:1:myDeptNum
	{
		set myOneDeptStr=$piece(myOPDeptStr,"^",i)
		set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
		set DepartmentName=$piece(myOneDeptStr,$C(1),2)
		if (DepartmentName["-") d
		.set DepartmentName=$piece(DepartmentName,"-",1)
		set LocAddress=""
		set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
		if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
		set flag=0
		set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResRowId)) Q:ResRowId=""  d
 		.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 		.s flag=1
		if ((flag=0)&&(GroupResRowIdStr'="")) continue
		;科室挂号年龄限制将取“挂号设置-挂号科室扩展设置”
		;$p(^DHCOPRegConfig("OPRegDepExpand",LocID),"^",3)
		set DepartmentAgeLimit=$p($g(^DHCOPRegConfig("OPRegDepExpand",DepartmentCode)),"^",3)
		set DepartmentDepDR=$p(^CTLOC(DepartmentCode),"^",19)
		s DepInfo={}
		s DepInfo.DeptId=DepartmentCode
		s DepInfo.DeptName=DepartmentName
		s DepInfo.AdmitAddress=LocAddress
		s DepInfo.CategoryId=""
		s DepInfo.CategoryName=""
		s DepInfo.Description=""
		d Dept.%Push(DepInfo)
		;s OutPutObj=
	}
	if ($l(Dept)<=0){
		q $$GetDeptInfoErrMag("没有查到可用数据")
	}
	s OutPutObj.Depts=Dept
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
	;s OutObj=##class(%GlobalCharacterStream).%New()
	;d OutObj.Write("查找失败")
	;q OutObj
GetDeptInfoErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	;s OutStream=##class(%GlobalCharacterStream).%New()
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
	;d OutStream.Write("查找失败")
	;q OutStream
}

/// 获取医生信息
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetDocInfo("<Request><DeptId>0</DeptId></Request>")
ClassMethod GetDocInfo(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetDocInfoErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s DepartmentCode=InputObj.DeptId
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	if (UserID=""){
		q $$GetDocInfoErrMag("没有此操作用户")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
	i DepartmentCode="" q $$GetDocInfoErrMag("科室代码不能都为空.")
	s OutPutObj={}
	s Doctor=[]
	Set rs1=##class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:FindResDoc")
	Set Status=0
	If rs1.QueryIsValid() { 
		Set Status=rs1.Execute(DepartmentCode,UserID,"")
		If 'Status Quit
		While rs1.Next() {
			set DocDesc=rs1.GetData(1)
			set DocCode=rs1.GetData(2)
			set DocID=rs1.GetData(3)
			set ResRowid=rs1.GetData(4)
			set DeptId=rs1.GetData(5)
			set DeptDesc=rs1.GetData(6)
			set DocProveTypeDesc=rs1.GetData(7)
			set DocProveTypeID=rs1.GetData(8)
			set DocIntruduction=rs1.GetData(9)
			set flag=0
			set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTPCP",DocID,DeptId,ResRowId)) Q:ResRowId=""  d
 			.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 			.s flag=1
			if ((flag=0)&&(GroupResRowIdStr'="")) continue
			s DoctorObj={}
			s DoctorObj.DoctorId=DocID
			s DoctorObj.DoctorName=DocDesc
			s DoctorObj.DoctorTitle=""
			s DoctorObj.DeptId=DeptId
			s DoctorObj.DeptName=DeptDesc
			s DoctorObj.Description=""
			d Doctor.%Push(DoctorObj)
		}
	}
	if ($l(Doctor)<=0){
		q $$GetDocInfoErrMag("没有查到可用的医生信息")
	}
	s OutPutObj.Doctors=Doctor
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetDocInfoErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 查询排班信息
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetScheduledInfo("<Request><DoctorId></DoctorId><DeptId></DeptId><StartDate>2020-08-20</StartDate><EndDate>2020-08-30</EndDate></Request>")
ClassMethod GetScheduledInfo(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetScheduledInfoErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	
	s DoctorCode=InputObj.DoctorId
	s DepartmentCode=InputObj.DeptId
	s StartDate=InputObj.StartDate
	s EndDate=InputObj.EndDate
	i StartDate="" {
		q $$GetScheduledInfoErrMag("开始日期不能都为空.")
		
	}else{
		i $l(StartDate,"-")'=3 {
			q $$GetScheduledInfoErrMag("开始日期格式不对.")
		}
	}
	i EndDate="" {
		q $$GetScheduledInfoErrMag("结束日期不能都为空.")
	}else{
		i $l(EndDate,"-")'=3 {
			q $$GetScheduledInfoErrMag("结束日期格式不对.")
		}
	}
	i DepartmentCode="" {
		;q $$GetScheduledInfoErrMag("科室代码不能都为空.")
	}
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GroupRowId=$p($g(^SSU("SSUSR",UserID)),"^",5)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s OutPutObj={}
	s Scheduled=[]
	s ResID=0
	f {
		s ResID=$o(^RB("RES",ResID))
		q:ResID=""
		s RESCTLOCDR=$p($g(^RB("RES",ResID)),"^",1)
		continue:RESCTLOCDR=""
		Continue:(DepartmentCode'="")&(DepartmentCode'=RESCTLOCDR)
		s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
		Continue:ResCTPCPDR=""
		Continue:(DoctorCode'="")&(DoctorCode'=ResCTPCPDR)
		s Date=StartDate-1
		for {
			s Date=$O(^RBAS(0,"Date",Date)) q:(Date="")||(Date>EndDate)
			s Sub=0
			for{
				s Sub=$o(^RBAS(0,"Date",Date,ResID,Sub)) q:Sub=""
				
				s RBASID=ResID_"||"_Sub
				s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
				s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
				//预约不显示之前和当天的
				continue:ASDate<=+$H
				;不显示当前时段以前的号
				Continue:(ASDate=+$H)&&(SessEndTime<$p($h,",",2))
				
				s RBASObj=##class(User.RBApptSchedule).%OpenId(RBASID)
				s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
				continue:DHCRBASObj.ASStatusDR.ASSCode="S" ;"-1^停诊"
				continue:DHCRBASObj.ASStatusDR.ASSCode="TR" ;"-1^被替诊"
				continue:DHCRBASObj.ASStatusDR.ASSCode="PS" ;"-1^中途停诊"
				continue:DHCRBASObj.ASStatusDR.ASSCode="SPSA" ;"-1^只停正号"
				continue:RBASObj.ASIrregularFlag="A"  ;"-1^不规则排班"
				s OutRBASObj=..GetRBASRecObjByRBASObj(RBASObj,DHCRBASObj,"APP",AppRegMethodCode)
				continue:+OutRBASObj.LimitNum<=0
				d Scheduled.%Push(OutRBASObj)
				/*s OutObj.SchedId=RBASID	;号源编号
				s OutObj.OrderDate=$ZD(RBASObj.ASDate,3)	;预约日期
				s OutObj.OrderSort=DHCRBASObj.ASTimeRangeDR.TRDesc	;预约班别
				s OutObj.DoctorId=RBASObj.ASRESParRef.RESCTPCPDRGetObjectId()	;医生主键
				s OutObj.DoctorName=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPDesc	;医生姓名
				s OutObj.DeptId=RBASObj.ASRESParRef.RESCTLOCDRGetObjectId()	    ;科室编码
				s OutObj.DeptName=RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc	;科室名称
				s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASID,"","")
				s OutObj.Fee=$p(DocResValue,"^",12)	    ;挂号费
				s OutObj.LimitNum	;可预约数量
				s OutObj.ConsumeNum	;已预约数量
				s OutObj.Status="1"	    ;状态标识1:有效  2:停诊*/
			}
		}
	}
	if ($l(Scheduled)<=0){
		q $$GetScheduledInfoErrMag("未查出可用排班信息")
	}
	s OutPutObj.Scheduleds=Scheduled
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetScheduledInfoErrMag(ErrText="")
	b 
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 查询时段信息
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetScheduledTime("<Request><SchedId>599||32</SchedId></Request>")
ClassMethod GetScheduledTime(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetScheduledTimeErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s ScheduleItemCode=InputObj.SchedId
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s OutPutObj={}
	s Time=[]
	if ScheduleItemCode'="" {
		if ($l(ScheduleItemCode,"||")'=2){
			q $$GetScheduledTimeErrMag("排班ID格式不正确")
		}
		s RBASObject=##class(User.RBApptSchedule).%OpenId(ScheduleItemCode)
		if '$IsObject(RBASObject)
		{
			q $$GetScheduledTimeErrMag("排班不存在")
		}
		Set DHCRBASObject = ##class(User.DHCRBApptSchedule).%OpenId(ScheduleItemCode)
		if $IsObject(DHCRBASObject.ASStatusDR)	
		{
			s ASStatus=DHCRBASObject.ASStatusDR.ASSCode
			if (ASStatus="S")||(ASStatus="TR")
			{
	    		q $$GetScheduledTimeErrMag("排班已经停诊或替诊")
			}
		}
		s TimeRangeFlag=DHCRBASObject.ASTimeRangeFlag
		if (TimeRangeFlag'="Y"){
			q $$GetScheduledTimeErrMag("该排班未有分时段信息")
		}
		s ASLoad=RBASObject.ASLoad
		s AvailSeqNoStr=##class(DHCExternalService.RegInterface.SelfRegMethods).GetAvailSeqNoStr(ScheduleItemCode,AppRegMethodCode)
		s AvailSeqNoStr=$p(AvailSeqNoStr,"^")
		s ASTRRegNumStr=DHCRBASObject.ASTRRegNumStr
		s ASTRRegInfoStr=DHCRBASObject.ASTRRegInfoStr
		s ASTRRegNumStr=DHCRBASObject.ASTRRegNumStr
		s ASTRRegInfoStr=DHCRBASObject.ASTRRegInfoStr
		s ASTRRegInfoStrLen=$l(ASTRRegInfoStr,",")
		f mycount=1:1:ASTRRegInfoStrLen{
			s OneTimeRange=$p(ASTRRegInfoStr,",",mycount)
			s OneRegNumRange=$p(ASTRRegNumStr,",",mycount)
			s RBASRecObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetRBASRecTimeObj(RBASObject,OneTimeRange,OneRegNumRange,AvailSeqNoStr)
			s AvailableLeftNum=RBASRecObj.AvailableLeftNum
			continue:+AvailableLeftNum=0
			s RBASTimeObj={}
			s RBASTimeObj.StartTime=RBASRecObj.StartTime
			s RBASTimeObj.EndTime=RBASRecObj.EndTime
			s RBASTimeObj.LimitNum=RBASRecObj.AvailableLeftNum
			s RBASTimeObj.ConsumeNum=+RBASRecObj.AvailableTotalNum-+RBASRecObj.AvailableLeftNum
			d Time.%Push(RBASTimeObj)
		}
	}else{
		q $$GetScheduledTimeErrMag("未查询到排班信息")
	}
	if ($l(Time)<=0){
		q $$GetScheduledTimeErrMag("该排班分时段号源已挂完")
	}
	s OutPutObj.Times=Time
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetScheduledTimeErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 获取医院当日排班相关信息<Request><SchedId>599||32</SchedId></Request>
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetRegisterInfo("<Request><SchedId>599||32</SchedId></Request>")
ClassMethod GetRegisterInfo(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetRegisterInfoErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s DoctorCode=InputObj.DoctorId
	s DepartmentCode=InputObj.DeptId
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s OutPutObj={}
	s Scheduled=[]
	s ResID=0
	f {
		s ResId=$o(^RB("RES",ResID))
		q:ResId=""
		s RESCTLOCDR=$p($g(^RB("RES",ResID)),"^",1)
		continue:RESCTLOCDR=""
		Continue:(DepartmentCode'="")&(DepartmentCode'=RESCTLOCDR)
		s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
		Continue:ResCTPCPDR=""
		Continue:(DoctorCode'="")&(DoctorCode'=ResCTPCPDR)
		s Sub=0
		for{
			s Sub=$o(^RBAS(0,"Date",+$h,ResID,Sub)) q:Sub=""
			s RBASID=ResID_"||"_Sub
			s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
			s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
			;不显示当前时段以前的号
			Continue:(ASDate=+$H)&&(SessEndTime<$p($h,",",2))
				
			s RBASObj=##class(User.RBApptSchedule).%OpenId(RBASID)
			s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
			continue:DHCRBASObj.ASStatusDR.ASSCode="S" ;"-1^停诊"
			continue:DHCRBASObj.ASStatusDR.ASSCode="TR" ;"-1^被替诊"
			continue:DHCRBASObj.ASStatusDR.ASSCode="PS" ;"-1^中途停诊"
			continue:DHCRBASObj.ASStatusDR.ASSCode="SPSA" ;"-1^只停正号"
			continue:RBASObj.ASIrregularFlag="A"  ;"-1^不规则排班"
			s OutRBASObj=..GetRBASRecObjByRBASObj(RBASObj,DHCRBASObj,"APP",AppRegMethodCode)
			continue:+OutRBASObj.LimitNum<=0
			d Scheduled.%Push(OutRBASObj)
		}
	}
	if ($l(Scheduled)<=0){
		q $$GetRegisterInfoErrMag("未查出可用排班信息")
	}
	s OutPutObj.Scheduleds=Scheduled
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetRegisterInfoErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 获取医院当日排班分时段相关信息
ClassMethod GetRegisterTime(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetRegisterTimeErrMag"
	/*s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s ScheduleItemCode=InputObj.SchedId
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s OutPutObj={}
	s Time=[]*/
	q ..GetScheduledTime(XMLRequest)
GetRegisterTimeErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

ClassMethod GetRBASRecObjByRBASObj(RBASObj As User.RBApptSchedule, DHCRBASObj As User.DHCRBApptSchedule, RegType As %String, AppRegMethodCode As %String)
{
	s OutObj={}
	s OutObj.SchedId=RBASObj.%Id()	;号源编号
	s OutObj.OrderDate=$ZD(RBASObj.ASDate,3)	;预约日期
	s OutObj.OrderSort=DHCRBASObj.ASTimeRangeDR.TRDesc	;预约班别
	s OutObj.DoctorId=RBASObj.ASRESParRef.RESCTPCPDRGetObjectId()	;医生主键
	s OutObj.DoctorName=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPDesc	;医生姓名
	s OutObj.DeptId=RBASObj.ASRESParRef.RESCTLOCDRGetObjectId()	    ;科室编码
	s OutObj.DeptName=RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc	;科室名称
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASObj.%Id(),"","")
	s OutObj.Fee=$p(DocResValue,"^",12)	    ;挂号费
	if $g(RegType)="APP" {
		s AvailableNumStr=##class(DHCExternalService.RegInterface.SelfRegMethods).GetAvailSeqNoStrWithOutForm(RBASObj.%Id(),RegType,AppRegMethodCode)
	}else{
		s AvailableNumStr=##class(DHCExternalService.RegInterface.SelfRegMethods).GetAvailSeqNoStrWithOutForm(RBASObj.%Id(),RegType)
	}
	s OutObj.LimitNum=""	;可预约数量
	s OutObj.ConsumeNum=""	;已预约数量
	if $p(AvailableNumStr,"^",1)'=""{
		s mySeqNoStr=AvailableNumStr
		;可用号串^预约(正号)限额^剩余号数量
		s AvailableNumStr=$p(mySeqNoStr,"^",1)
		s AvailableTotal=$p(mySeqNoStr,"^",2)
		s AvailableLeft=$p(mySeqNoStr,"^",3)
		s OutObj.LimitNum=AvailableLeft	;可预约数量
		s OutObj.ConsumeNum=+AvailableTotal-+AvailableLeft	;已预约数量
	}
	
	s OutObj.Status="1"	    ;状态标识1:有效  2:停诊
	q OutObj
}

/// 获取医院排班停诊相关信息
ClassMethod GetScheduledStop(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetScheduledStopErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TransactionId=InputObj.TradeId	;交易流水号
GetScheduledStopErrMag(ErrText="")
	if (ErrText="") s ErrText="查询失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

// 至此查询系统信息接口已处理完

/// 预约请求接口
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecOrderConfirm("<Request><TradeId>202007280001</TradeId><PatientId>0000000001</PatientId><Telphone></Telphone><CardNO>0000000001</CardNO><SchedId>599||32</SchedId><StartTime>08:30</StartTime><EndTime>09:00</EndTime></Request>").Read()
ClassMethod ExecOrderConfirm(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecOrderConfirmErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TransactionId=InputObj.TradeId	;交易流水号
	s PatientNo=InputObj.PatientId	;患者主键
	s TransactionId=InputObj.Telphone	;电话号码
	s CardNo=InputObj.CardNO	;就诊卡号
	s ScheduleItemCode=InputObj.SchedId	;排班编码
	s StartTime=InputObj.StartTime	;排班开始时间
	s EndTime=InputObj.EndTime	;排班结束时间
	if UserID="" {
		q $$ExecOrderConfirmErrMag("操作员不存在")
	}
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	if (PatientID=""){
		q $$ExecOrderConfirmErrMag("未查询到患者的基本信息请先建卡")
	}
	s CarDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""))
	s myCardNo=$p($g(^DHCCARD("CF",CarDr)),"^",2)
	if (myCardNo'=CardNo){
		q $$ExecOrderConfirmErrMag("请输入正确的患者信息")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	;是否启用分时段
	s LockUseTimeRangeFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"LockUseTimeRange"))
	if (ScheduleItemCode=""){
		q $$ExecOrderConfirmErrMag("排班记录标识不能为空")
	}
	if ($l(ScheduleItemCode,"||")'=2){
		q $$ExecOrderConfirmErrMag("排班ID格式不正确")
	}
	s ASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
	if (+ASDate<+$h){
		q $$ExecOrderConfirmErrMag("不可挂出当日之前的排班")
	}
	;是否启用提前挂号配置
	s AppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg"))
	if (AppRegFlag=0)&&(+ASDate'=+$h){
		q $$ExecOrderConfirmErrMag("不可挂出当日号之外的排班")
	}
	s AdmDate=$P(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2)),"^",1)
	s TRRowId=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",17)
	if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	s DTRRowId=##class(DHCExternalService.RegInterface.SelfRegMethods).GetTimeRangeByTime($p($h,",",2))
	s:DTRRowId'="" Desc=$P(^DHCTimeRange(DTRRowId),"^",2)
	if '((+AdmDate)>(+$h)){
		if '($g(Desc)="下午")&&($g(TRDesc)="上午")&&((+AdmDate)=(+$h)){
			q $$ExecOrderConfirmErrMag("不可预约当日或已失效排班")
		}
	}
	S MethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s MethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if MethodCode="" s MethodCode="WIN"

	s InsertQueueNo=""
	s AdmitRange=StartTime_"-"_EndTime
	if (AdmitRange'="")&&(InsertQueueNo=""){
		s InsertQueueNo=##class(DHCExternalService.RegInterface.SelfRegMethods).GetSeqNoByTimeRange(ScheduleItemCode,AdmitRange,MethodCode)
	}
	s ret=##class(web.DHCOPAdmReg).OPAppBroker("","",PatientID , ScheduleItemCode , InsertQueueNo, UserID,"", MethodCode)
	s OutPutObj={}
	if ($p(ret,"^",1)="0"){
		s APPTRowId=$p(ret,"^",2)
		s QueueNo=$p(ret,"^",3)
		s printData=##class(web.DHCOPAdmReg).GetAppPrintData(APPTRowId)
		s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(APPTRowId)
		s FeeStr="||1||0||0"
		i NeedAppFee="1" s FeeStr="||1||0||1"
		s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		b ;w "."_APPTRowId_".",!
		s Sum=##class(web.DHCOPAdmReg).GetScheduleFee(APPTRowId,AdmReason,+$H,FeeStr)
		s LocDr=$p(^RB("RES",+APPTRowId),"^",1)
		s AdmitAddress=$g(^CTLOC(LocDr,"ADDR",1))
		s OutPutObj.OrderId=APPTRowId	;预约流水号
		s OutPutObj.Fee=Sum	;挂号费
		s OutPutObj.Sequence=$p(printData,"^",5)	;就诊序号
		s OutPutObj.ConsumeNum=""	;该号源剩余数量
		s OutPutObj.VisitTime=$p(printData,"^",18)	;就诊时间
		s OutPutObj.CancelTime=""	;最晚取消时间
		s OutPutObj.SecurityCode=""	;挂号机取号密码
	}
	else{

		s errmsg=""
		if (ret=-201){
			s errmsg="ADMInsertFail"
		}elseif (ret=-202){
			s errmsg="FailGetQueueNo"
		}elseif (ret=2121){
			s errmsg="UpdateAppStatusFail"
		}elseif (ret=-206){
			s errmsg="PriceArcOrderInsertFail"
		}elseif (ret=-207){
			s errmsg="chrhfeeOrderInsertFail"
		}elseif (ret=-208){
			s errmsg="AppOrderInsertFail"
		}elseif (ret=-210){
			s errmsg="FailCharge"
		}elseif (ret=-211){
			s errmsg="RegFeeInsertFail"
		}elseif (ret=-212){
			s errmsg="QueueInsertFail"
		}elseif (ret=-220){
			s errmsg="StatusIsCancel"
		}elseif (ret=-221){
			s errmsg="StatusIsArrival"
		}elseif (ret=-222){
			s errmsg="UpdateStatusFail"
		}elseif (ret=-302){
			s errmsg="超过每人每天挂相同医生限额"
		}
		elseif (ret=-223){
			s errmsg="AppNotExist"
		}
		elseif (ret=-230){
			s errmsg="UpdateFile"
		}
		q $$ExecOrderConfirmErrMag("预约失败"_ret_errmsg)
	}
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="预约成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecOrderConfirmErrMag(ErrText="")
	if (ErrText="") s ErrText="预约失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 预约取消接口
/// w ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecOrderCancel("<Request><TradeId>202007280001</TradeId><PatientId>0000000001</PatientId><OrderId>599||32||1</OrderId></Request>").Read()
ClassMethod ExecOrderCancel(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecOrderCancelErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TradeId=InputObj.TradeId
	s PatientId=InputObj.PatientId
	s OrderId=InputObj.OrderId
	if (OrderId=""){
		q $$ExecOrderCancelErrMag("预约记录ID不能为空")
	}
	if UserID="" {
		q $$ExecOrderCancelErrMag("操作员不存在")
	}
	TS
	s rtn=##class(web.DHCRBAppointment).CancelAppointment(OrderId,UserID)
	if (+rtn'=0) 
	{
		TRO
		q $$ExecOrderCancelErrMag("取消预约失败,Code:"_rtn)
	}
	TC
	s OutPutObj={}
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="取消成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecOrderCancelErrMag(ErrText="")
	if (ErrText="") s ErrText="取消预约失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 预约记录查询接口
ClassMethod GetOrderList(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetOrderListErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s PatientNo=InputObj.PatientId	;患者主键
	s OrderId=InputObj.OrderId	;预约流水号
	s StartDate=InputObj.StartDate	;开始日期
	s EndDate=InputObj.EndDate	;结束日期
	i StartDate="" {
		q $$GetOrderListErrMag("开始日期不能都为空.")
		
	}else{
		i $l(StartDate,"-")'=3 {
			q $$GetOrderListErrMag("开始日期格式不对.")
		}
	}
	i EndDate="" {
		q $$GetOrderListErrMag("结束日期不能都为空.")
	}else{
		i $l(EndDate,"-")'=3 {
			q $$GetOrderListErrMag("结束日期格式不对.")
		}
	}
	if (UserID=""){
		q $$GetOrderListErrMag("操作员代码为空")
	}
	s myPatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	if (myPatientID=""){
		q $$GetOrderListErrMag("病人记录不存在")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s:EndDate'="" EndDate=$zdh(EndDate,3)
	s OutPutObj={}
	s Order=[]
	s ResRowId=0  
	f  {
		s ResRowId=$O(^RBAS("APPT_Date",ResRowId)) 
		Q:ResRowId=""
		s AppDate=(StartDate-1) 
		f  {
			s AppDate=$O(^RBAS("APPT_Date",ResRowId,AppDate)) 
			Q:(AppDate="")!((EndDate'="")&&(+AppDate>EndDate))
			s AppTime=0 
			f {
				s AppTime=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime)) 
				Q:AppTime=""
				s ASChild=0 
				f { 
					s ASChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild))
					Q:ASChild=""
					s APPChild=0 
					f { 
						s APPChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild,APPChild)) 
						Q:APPChild=""
						continue:'$D(^RB("RES",ResRowId))
						continue:(EndDate'="")&(+AppDate>EndDate)
						continue:(StartDate'="")&(StartDate>+AppDate)
						s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
						continue:(OrderId'="")&&(OrderId'=APPTRowId)
						s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
						;预约人姓名
						s AppPatientID=$P(Appt,"^",2)
						continue:'$D(^PAPER(AppPatientID))
						continue:(myPatientID'="")&&(AppPatientID'=myPatientID)
						s StatusCode=$P(Appt,"^",3)
						;continue:(StatusCode="J")
						s StatusDesc=$s(StatusCode="J":"3",StatusCode="I":"0",StatusCode="A":"1",StatusCode="X":"2")
						s ApptObj={}
						;s PatNo=$p(^PAPER(myPatientID,"PAT",1),"^",2) //登记号
						s ApptOrderObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetApptObjByRBASObj(APPTRowId,myPatientID)
						s ApptObj.PatientId=$p(^PAPER(myPatientID,"PAT",1),"^",2)	;患者编码
						s ApptObj.DeptId=ApptOrderObj.Department	;科室编码
						s ApptObj.DoctorId=ApptOrderObj.Doctor	;医生编码
						s ApptObj.OrderDate=ApptOrderObj.OrderApptDate	;预约日期
						s ApptObj.OrderId=APPTRowId	;预约流水号
						s ApptObj.Fee=ApptOrderObj.RegFee	;挂号费
						s ApptObj.Sequence=ApptOrderObj.SeqCode	;就诊序号
						s ApptObj.VisitTime=ApptOrderObj.AdmitDate	;就诊时间
						s ApptObj.CancelTime=""	;最晚取消时间
						s ApptObj.SecurityCode=""	;挂号机取号密码
						s ApptObj.State=StatusDesc	;预约单状态0:未就诊 1:已就诊2:已取消 3:已违约
						s PayState=0
						if ApptOrderObj.PayFlag="P" s PayState=1 
						s ApptObj.PayState=PayState	;预约单支付状态0:未支付 1:已支付
						d Order.%Push(ApptObj)
					}
				}
			}
		}
	}
	s OutPutObj.Orders=Order
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetOrderListErrMag(ErrText="")
	if (ErrText="") s ErrText="查询失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 当日挂号锁号接口
ClassMethod ExecLockConfirm(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecLockConfirmErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TransactionId=InputObj.TradeId	;交易流水号
	s PatientNo=InputObj.PatientId	;患者主键
	s Telphone=InputObj.Telphone	;电话号码
	s PatientCard=InputObj.CardNO	;就诊卡号
	s ScheduleItemCode=InputObj.SchedId	;排班编码
	s BeginTime=InputObj.StartTime	;排班开始时间
	s EndTime=InputObj.EndTime	;排班结束时间
	if (UserID=""){
    	q $$ExecLockConfirmErrMag("操作员信息为空")
	}
	if (TransactionId=""){
		q $$ExecLockConfirmErrMag("唯一的交易流水号不能为空")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s NotUseLockRegFlag=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"NotUseLockReg")
	if (NotUseLockRegFlag=1){
		q $$ExecLockConfirmErrMag("锁号功能未启用")
	}
	s CheckRegTimeFlag=##class(DHCExternalService.RegInterface.RegManager).CheckRegTime(GroupID)
	i CheckRegTimeFlag=0{
		q $$ExecLockConfirmErrMag("当前时间无法挂号.")
	}
	if (ScheduleItemCode=""){
		q $$ExecLockConfirmErrMag("排班记录标识不能为空")
	}
	if ($l(ScheduleItemCode,"||")'=2){
		q $$ExecLockConfirmErrMag("排班ID格式不正确")
	}
	s ASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
	if (+ASDate<+$h){
		q $$ExecLockConfirmErrMag("不可挂出当日之前的排班")
	}
	;是否启用提前挂号配置
	s AppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg"))
	if (AppRegFlag=0)&&(+ASDate'=+$h){
		q $$ExecLockConfirmErrMag("不可挂出当日号之外的排班")
	}
	s object=##class(User.RBApptSchedule).%OpenId(ScheduleItemCode)
	if '$IsObject(object)
	{
    	q $$ExecLockConfirmErrMag("排班不存在")
	}
	d object.%Close()
	Set object = ##class(User.DHCRBApptSchedule).%OpenId(ScheduleItemCode)
	set ASTimeRangeFlag=object.ASTimeRangeFlag
	if $IsObject(object.ASStatusDR)	
	{
		s ASStatus=object.ASStatusDR.ASSCode
		if (ASStatus="S")||(ASStatus="TR")
		{
    		q $$ExecLockConfirmErrMag("排班已经停诊或替诊")
		}
	}
	d object.%Close()
	s myPatientID=""
	if PatientNo'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}
	;else{
		s CardPatDr=""
		if PatientCard'=""{
			s CFRowid=0
			for {
				s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
				s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
				Continue:CFActive'="N"
				s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
				;Continue:(CardType'="")&(CardType'=CFCardTypeDR)
				s CardPatDr=$p(^DHCCARD("CF",CFRowid),"^",4)
			}
		}
	;}
	if (CardPatDr'=myPatientID){
		q $$ExecLockConfirmErrMag("患者信息错误")
	}
	s PatCatDr=$p(^PAPER(myPatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	if (PatCatDr="")&&('$d(^CT("SS",PatCatDr))){
		q $$ExecLockConfirmErrMag("您的病人类型有误,请前往窗口修改病人类型")
	}
	s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg"))
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg"))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				q $$ExecLockConfirmErrMag("目前不支持医保病人挂号，请到窗口挂号")
			}else{
				s SelfAdmReason=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason")
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					q $$ExecLockConfirmErrMag("请联系管理员维护自费费别")
				}
				s DefaultBillType=SelfAdmReason
			}
			
		}
	}
	s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)

	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ScheduleItemCode)
	;s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s AdmReason=+DefaultBillType
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(ScheduleItemCode,AdmReason,myPatientID)
	s RegFee=$p(DocResValue,"^",12)
	s CheckupFee=$p(DocResValue,"^",14)
	s OtherFee=(+$p(DocResValue,"^",20))+(+$p(DocResValue,"^",15))+(+$p(DocResValue,"^",18))+(+$p(DocResValue,"^",16))
	s Fee=RegFee+CheckupFee+OtherFee //总挂号费
	s SessionTypeDr=$P($G(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2),"DHC")),"^",6)
	s SessionTypeDesc=""
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	;if TransactionId'=""{
		s HisTradeNo=TransactionId
	;}else{
		;s HisTradeNo=PayOrdId
	;}
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	;是否启用分时段
	s LockUseTimeRangeFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"LockUseTimeRange"))
	s LockQueueNo=""
	s EPMark=##class(web.DHCRBResource).GetEPMarkFlag(+ScheduleItemCode)
		i (EPMark'=1)
		{
			s LimitRet=##class(web.DHCOPAdmReg).CheckRegCountLimit(myPatientID,ScheduleItemCode)
			if (LimitRet'=0)
			{
    			if LimitRet="-301" s ErrorMsg="超过每人每天挂号总数限额"
    			else  if LimitRet="-302" s ErrorMsg="超过每人每天挂相同医生的号数限制"
    			else  if LimitRet="-304" s ErrorMsg="超过每人该时段可挂号限额!不能进行挂号和预约."
    			else  if LimitRet="-305" s ErrorMsg="超过每人该时段可挂相同科室限额!不能进行挂号和预约"
    			else  s ErrorMsg=LimitRet
    			TRO
    			q $$ExecLockConfirmErrMag(ErrorMsg)
			}
			s LockLimitRet=##class(web.DHCLockSchedule).GetPADayLockCount(myPatientID,ScheduleItemCode)
			s LockSameASCount=$P(LockLimitRet,"^",3)	
			if +LockSameASCount>0 
			{
				s ErrorMsg="您有此科室医生待付费挂号记录,请付费!"
				TRO
    			q $$ExecLockConfirmErrMag(ErrorMsg)
			}
		}
		if (LockUseTimeRangeFlag=1){
			if (LockQueueNo="")&&(ASTimeRangeFlag="Y")&&((BeginTime="")!(EndTime="")){
				TRO
				q $$ExecLockConfirmErrMag("该排班存在分时段信息,请选择分时段信息")
			}
			s AdmitRange=BeginTime_"-"_EndTime
			if (ASTimeRangeFlag="Y")&&(LockQueueNo="")&&(BeginTime'="")&&(EndTime'=""){
				s LockQueueNo=##class(DHCExternalService.RegInterface.SelfRegMethods).GetSeqNoByTimeRange(ScheduleItemCode,AdmitRange,AppRegMethodCode)
				if +LockQueueNo=0
				{
	    			TRO
	    			q $$ExecLockConfirmErrMag("该时段号源号已挂完")
				}
			}
		}
	    if (LockQueueNo="")
	    {
			s LockQueueNo=##class(web.DHCRBAppointment).GetSeqNo(ScheduleItemCode,RegType,AppRegMethodCode)
			if +LockQueueNo=0
			{
    			TRO
    			q $$ExecLockConfirmErrMag("号已挂完")
			}
	    }else{
			s LockQueueNo=##class(web.DHCRBAppointment).GetSpecSeqNo(ScheduleItemCode,LockQueueNo,RegType,AppRegMethodCode)
			if +LockQueueNo=0
			{
    			TRO
    			if LockUseTimeRangeFlag=1 q $$ExecLockConfirmErrMag("该时段号已挂完")
    			else  q $$ExecLockConfirmErrMag("该号已被他人支付")
			}    
		}
		
		s:HisTradeNo="" HisTradeNo=##class(DHCExternalService.RegInterface.SelfRegMethods).SetLockTradeNo(PatientNo)
		s CurrData=+$h
		s CurrTime=$p($h,",",2)
		&sql(insert into SQLUser.CT_LockSchedule (CT_PatNo,CT_Schedule,CT_LockQueueNo,
					CT_UpdateDate,CT_UpdatTime,CT_UserID,CT_ActiveFlag,CT_HisTradeNo) values (:PatientNo,
					:ScheduleItemCode,:LockQueueNo,:CurrData,:CurrTime,:UserID,'Y',:HisTradeNo))
		if SQLCODE 
		{
			TRO
			q $$ExecLockConfirmErrMag("加号失败,稍后请再次尝试")
		}
	;s RegId=%ROWID
	s LockScheduleTime=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime"))
	s:LockScheduleTime=0 LockScheduleTime=600
	s OutPutObj={}
	s OutPutObj.RegId=HisTradeNo	;锁号标识
	s OutPutObj.Fee=Fee	;挂号费
	s OutPutObj.Sequence=LockQueueNo	;就诊序号
	s OutPutObj.VisitTime=$zd(ASDate,3)	;就诊时间
	s OutPutObj.CancelTime=""	;最晚取消时间
	s OutPutObj.SecurityCode=""	;挂号机取号密码
	s OutPutObj.ExpireTime=LockScheduleTime ;锁号有效时长(秒)
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="锁号成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecLockConfirmErrMag(ErrText="")
	if (ErrText="") s ErrText="锁号失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 当日挂号解锁接口
ClassMethod ExecUnlockCancel(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecUnlockCancelErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	S TradeId=InputObj.TradeId	;接口流水号
	S RegId=InputObj.RegId	;锁号标识
	;q:'$d(^CTLS(RegId)) $$ExecUnlockCancelErrMag("未找到该条锁号记录")
	if (RegId=""){
		q $$ExecUnlockCancelErrMag("锁号标识不能为空")
	}
	s HisTradeNo=RegId
	s (ScheduleItemCode,PatientNo,LockQueueNo)=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",HisTradeNo,""),-1)
	if CTLSRowID'=""{
		s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
		s QueueNo=$p(^CTLS(CTLSRowID),"^",3)
		s LockPatientNo=$p(^CTLS(CTLSRowID),"^",1)
		i LockQueueNo="" s LockQueueNo=QueueNo
		i ScheduleItemCode="" s ScheduleItemCode=LockScheduleItemCode
		i PatientNo="" s PatientNo=LockPatientNo
	}else{
		q $$ExecUnlockCancelErrMag("该订单已失效")
	}
	d ##class(web.DHCLockSchedule).UnLockSchedule(ScheduleItemCode,PatientNo,LockQueueNo)
	s OutPutObj={}
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="取消成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecUnlockCancelErrMag(ErrText="")
	if (ErrText="") s ErrText="解锁失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 当日挂号请求接口
ClassMethod ExecRegisterConfirm(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecRegisterConfirmErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TransactionId=InputObj.TradeId	;接口流水号
	s RegId=InputObj.RegId	;锁号标识
	s PayModeCode=InputObj.PaymentType	;支付类型1:支付宝  2:微信
	s PayFee=InputObj.Cost	;支付金额
	s PlatTradeId=InputObj.PlatTradeId	;平台交易流水号
	q:'$d(^CTLS(RegId)) $$ExecRegisterConfirmErrMag("未找到该条锁号记录")
	s HisTradeNo=RegId
	s (ScheduleItemCode,PatientID,LockQueueNo)=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",HisTradeNo,""),-1)
	if CTLSRowID'=""{
		s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
		s QueueNo=$p(^CTLS(CTLSRowID),"^",3)
		s LockPatientNo=$p(^CTLS(CTLSRowID),"^",1)
		i LockQueueNo="" s LockQueueNo=QueueNo
		i ScheduleItemCode="" s ScheduleItemCode=LockScheduleItemCode
		i PatientID="" s PatientNo=LockPatientNo
	}else{
		q $$ExecRegisterConfirmErrMag("该订单已失效")
	}
	if UserID=""{
		q $$ExecRegisterConfirmErrMag("系统操作用户不能都为空.")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	;s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	s NotUseLockRegFlag=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"NotUseLockReg")
	if (NotUseLockRegFlag'=1){
		;如果移动订单号由第三方生成，则这里的HISTradNo为第三方生成的订单号
		;实际PayOrderId已弃用
		if (TransactionId="")
		{
			q $$ExecRegisterConfirmErrMag("订单不能为空")
		}
		
		s QueueNoActive=##class(web.DHCLockSchedule).CheckQueueNoActive(TransactionId,"","",PatientID)
		b ;QueueNoActive
		s QueueNoActiveFlag=$p(QueueNoActive,"^",1)
		s QueueNoActiveStr=$p(QueueNoActive,"^",2)
		if QueueNoActiveFlag'=1{
			if (QueueNoActiveFlag="Reg"){
				q $$ExecRegisterConfirmErrMag("该号已支付,请尝试重新生成订单.")
			}elseif (QueueNoActiveFlag="OutActiveTime"){
				q $$ExecRegisterConfirmErrMag("该号超时未支付,已被系统自动失效,请尝试重新生成订单.")
			}elseif (QueueNoActiveFlag="NotSamePerson"){
				q $$ExecRegisterConfirmErrMag("该号已被他人锁定,请尝试重新生成订单.")
			}elseif (QueueNoActiveFlag="-100"){
				q $$ExecRegisterConfirmErrMag("订单在系统中不存在,请尝试重新生成订单.")
			}elseif (QueueNoActiveFlag="-101"){
				q $$ExecRegisterConfirmErrMag("锁号错误,请尝试重新生成订单.")
			}else{
				q $$ExecRegisterConfirmErrMag("该订单已失效,请尝试重新生成订单")
			}
			
		}else{
			s ScheduleItemCode=$p(QueueNoActiveStr,"!",1)
			s InsertQueueNo=$p(QueueNoActiveStr,"!",2)
			i PatientID="" s PatientID=$p(QueueNoActiveStr,"!",3)
		}
	}else{
		s CheckRegTimeFlag=##class(DHCExternalService.RegInterface.RegManager).CheckRegTime(GroupID)
		i CheckRegTimeFlag=0{
			q $$ExecRegisterConfirmErrMag("当前时间无法挂号.")
		}
	}
	set PatientID=$Order(^PAPERi("PAPMI_PatNo",PatientID,0))
	if PatientID=""{
		q $$ExecRegisterConfirmErrMag("病人ID不存在")
	}
	s Patient=PatientID   //_"^N"
	s PatNo=$p(^PAPER(Patient,"PAT",1),"^",1)
	
	if ScheduleItemCode="" {
		q $$ExecRegisterConfirmErrMag("排班记录标识不能为空.")
	}
	if PayModeCode=""{
		q $$ExecRegisterConfirmErrMag("支付方式不能都为空.")
	}
	if PayFee=""{
		q $$ExecRegisterConfirmErrMag("挂号费不能都为空.")
	}
	;挂号
	s RBAS=ScheduleItemCode
	s ASDate=$P($G(^RBAS(+RBAS,$p(RBAS,"||",2))),"^",1) 
	if (+ASDate<+$h){
		q $$ExecRegisterConfirmErrMag("不可挂出当日之前的排班")
	}
	s AppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg"))
	if (AppRegFlag=0)&&(+ASDate'=+$h){
		q $$ExecRegisterConfirmErrMag("不可挂出当日号之外的排班")
	}
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	
	s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg"))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg"))
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				q $$ExecRegisterConfirmErrMag("目前不支持医保病人挂号，请到窗口挂号")
			}else{
				s SelfAdmReason=(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason"))
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					q $$ExecRegisterConfirmErrMag("请联系管理员维护自费费别")
				}
				s DefaultBillType=SelfAdmReason
			}
			
		}
	}
	set AdmReason=DefaultBillType
	if (AdmReason="") set AdmReason=##Class(DHCExternalService.RegInterface.GetRelate).GetAdmReason()

	;w RBASObj.%Id()_","_DefaultBillType_","_PatientID,!
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBAS,DefaultBillType,PatientID)
	s TotalFee=$p(DocResValue,"^",12)	//1
	s CheckFee=$p(DocResValue,"^",14)  //2
	s HoliFee=$p(DocResValue,"^",16)  //3
	s AppFee=$p(DocResValue,"^",18)   //4
	s ReCheckFee=$p(DocResValue,"^",15)  //6
	s OtherFee=$p(DocResValue,"^",20)  //6
	s TotalFee=(+TotalFee)+(+CheckFee)+(+HoliFee)+(+AppFee)+(+ReCheckFee)+(+OtherFee) //总挂号费
	
	;s ^tan("PayFee")=TotalFee_"^"_PayFee
	if (+TotalFee'=+PayFee)
	{
		q $$ExecRegisterConfirmErrMag("总费用金额错误")
	}
	s FeeStr=TotalFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||0||"_ReCheckFee_"||0"
	
	s PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if PayModeCode=""{
		q $$ExecRegisterConfirmErrMag("系统中未找到此支付方式.")
	}
	i PayModeCode'="" d
	.s PayModeCode=$P(^CT("CTPM",PayModeCode),"^",1)
	;s PayModeCode=PayModeCode_"^"_PayCardNo_"^"_UserID_"^"_HospitalId
	s PatientCard=""
	s DHCCardDr=^DHCCARDi("CF",0,"PAPMIDR",PatientID,0)
	s:DHCCardDr'="" PatientCard=$p($g(^DHCCARD("CF",DHCCardDr)),"^",2)
	set AccInfo=##class(DHCExternalService.RegInterface.RegManager).getaccinfofromcardno(PatientCard,"0")
	s AccRowId=$piece(AccInfo,"^",2)
	;s UserID=UserID
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s AdmDep=$p($g(^RB("RES",+RBAS)),"^",1)
	s ret=##class(web.DHCOPAdmReg).IsEmergency(AdmDep)
	s:(+ret=0) AdmType="O"
	s:(+ret=1) AdmType="E"
	s Left=$piece(AccInfo,"^",4)
	s CashPay=PayFee
	if (Left<CashPay)&&(PayModeCode="CPP"){
		q $$ExecRegisterConfirmErrMag("卡余额不足,请充值.")
	}

	s TabFreeRegFlag=""
	s TabFreeCheckFlag=""
	s InsuJoinStr=InputObj.PayInsuFeeStr	;医保挂号返回信息串，需与HIS窗口医保挂号返回串字段顺序严格一致。
	s DiagnosCatRowId="" ;$p(InsuJoinStr,"^",3)
	s DiscountFactor=""
	;PayBankCode	银行代码
	;PayCardNo	银行卡卡号
	;PayFee	支付费用
	;TransactionId 交易流水号
	;根据银医卡接口需要确定如下四个参数如何使用
	;号源平台传过来的费用和his计算费用的比较
	s PayBankCode=InputObj.PayBankCode
	s PayCardNo=InputObj.PayCardNo
	s PayFee=InputObj.PayFee
	s TransactionId=InputObj.TransactionId
	
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s SourceType=""
	if (NotUseLockRegFlag'=1){
		s SourceType="LOCK"
	}
	TS
	;Patient RBAS UserID GroupID
	///PatientID , ASRowId , AdmReason , QueueNo , FeeStr , PayModeCode , AccRowId , user , group , AdmType , DiagnosCatRowId , FreeRegFlag , FreeCheckFlag , ByRef RegfeeRowId , InsuJoinStr , DiscountFactor , TAPPTRowID , UnBillFlag , TabPCLRowID , ApptMethodCode , SourceType , RegConDisId 
	///PatientID As %String, ASRowId As %Library.String = "", AdmReason, QueueNo, FeeStr, PayModeCode, AccRowId , user , group , AdmType , DiagnosCatRowId , FreeRegFlag , FreeCheckFlag, , ByRef InsuJoinStr As %String = "", ByRef DiscountFactor As %String = "", InsuAdmInfoDr As %String = "", CorUnit As %String = "", InsuInfo As %String="", FreeRegFlagVal As %String="", TSAccRowId As %String="")
	s ret=##class(web.DHCOPAdmReg).OPRegistBroker(Patient,RBAS,AdmReason,InsertQueueNo,FeeStr,PayModeCode,AccRowId,UserID,GroupID,AdmType,DiagnosCatRowId,TabFreeRegFlag,TabFreeCheckFlag,"",InsuJoinStr,DiscountFactor,"","","",AppRegMethodCode,SourceType)
	s retFlag=$P(ret,"$",1)
	i (retFlag'=0){
		s errmsg=""
		if (retFlag="-201") s errmsg="插入就诊记录失败"
		if (retFlag="-202") s errmsg="该医生号别已挂完"
		if (retFlag="-2121") s errmsg="更新预约状态失败"
		if (retFlag="-2122") s errmsg="系统繁忙"
		if (retFlag="-206") s errmsg="挂号费用插入失败"
		if (retFlag="-207") s errmsg="chrhfeeOrderInsertFail"
		if (retFlag="-208") s errmsg="holiOrderInsertFail"
		if (retFlag="-209") s errmsg="预约记录插入失败"
		if (retFlag="-210") s errmsg="计费失败"
		if (retFlag="-211") s errmsg="扣除挂号费失败"
		if (retFlag="-212") s errmsg="插入顺序号失败"
		if (retFlag="-301") s errmsg="超过每人每天挂号总数限额"
		if (retFlag="-302") s errmsg="超过每人每天挂相同医生的号数限制"
		if (retFlag="-401") s errmsg="还未到达规定的挂号时间"
		if (retFlag="-402") s errmsg="还未到达预约时间"
		if (retFlag="-403") s errmsg="还未到达挂出加号的时间"
		if (retFlag="-404") s errmsg="ExceedTREndTime"
		if (retFlag="-2010") s errmsg="UpdateINSUAdmInfoFail"
		if (retFlag="-304") s errmsg="超过每人该时段可挂号限额!不能进行挂号和预约."
    	if (retFlag="-305") s errmsg="超过每人该时段可挂相同科室限额!不能进行挂号和预约"
		s errmsg=retFlag_"-挂号失败:"_errmsg
		TRO
		q $$ExecRegisterConfirmErrMag(errmsg)
	}
	
	s ret=$P(ret,"$",2)
	s AdmDr=$p(ret,"^",1)
	S RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmDr,""))
    
	if (InsertQueueNo'=""){
		s myLockRowID=""
		s LockRowID=0
		for {
			s LockRowID=$o(^CTLS(0,"SchedulePatNo",RBAS,PatNo,LockRowID))
			q:LockRowID=""
			s LockQueueNo=$p(^CTLS(LockRowID),"^",3)
			continue:InsertQueueNo'=LockQueueNo
			s HISAdmDr=$p(^CTLS(LockRowID),"^",9)
			continue:HISAdmDr'=""	//已付费了,这种情况应该只有p5的版本会出现吧	
			s myLockRowID=LockRowID
		}
		if (myLockRowID'=""){
			&sql(update SQLUser.CT_LockSchedule Set CT_HISAdmDr=:AdmDr
	         where CT_LSRowID=:myLockRowID
			)
		}
		
	}
	
	s TradeID=""
	s RegOrderFee=$P(ret,"^",17)
	s RegOrderFee=$tr(RegOrderFee," ","")
	s RegOrderFee=+RegOrderFee
	s PayModeDr=$o(^CT("CTPM",0,"Code",PayModeCode,0))
	s JFPayMode=" "_PayModeDr
	//renyx 计费待处理
	/*if $d(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",JFPayMode)){
		if (PayFee>0) {
			Set TradeType="OP"
			set Papmi=""
			if AdmDr'="" set Papmi=$p(^PAADM(AdmDr),"^",1)
			Set TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_""_"^"_TradeType_"^"_Papmi
			Set InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(PatientCard,AdmDr,"","C",PayFee,TExpstr)
			Set RetCode=$p(InsTraderInfo,"^",1)
			if (+RetCode'=0){
		    	do ..SetOutputCode(.OutputObj,"-110226","生成交易流水号失败！")
		    	TRO
				quit OutputObj
		    }
		    Set OrderNo=$p(InsTraderInfo,"^",3)
			Set IBPRowID=$p(InsTraderInfo,"^",2)
			set InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
			;PayDetailsObj 未定义.......... 医生站组织还是第三方传？？？？
			Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceId,.PayDetailsObj,TExpstr)
			If (RetCode'=0){
				do ..SetOutputCode(.OutputObj,"-110226","保存交易信息失败！"_RetCode)
		    	TRO
				quit OutputObj
			}
		}
	}*/
	TC
	s OutPutObj={}
	s OutPutObj.OrderId=AdmDr	;预约流水号   //就诊流水号
	s OutPutObj.Sequence=$P(ret,"^",8)	;就诊序号
	s OutPutObj.VisitTime=$p(ret,"^",7)	;就诊时间
	s OutPutObj.CancelTime=""	;最晚取消时间
	s OutPutObj.SecurityCode=""	;挂号机取号密码

	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="挂号成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecRegisterConfirmErrMag(ErrText="")
	if (ErrText="") s ErrText="挂号失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 当日挂号取消接口
ClassMethod ExecRegisterCancel(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ExecRegisterCancelErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s TransactionId=InputObj.TradeId	;交易流水号
	s PatientId=InputObj.PatientId	;患者主键
	s AdmNo=InputObj.OrderId	;就诊流水号
	if UserID="" {
		q $$ExecRegisterCancelErrMag("操作员不存在")
	}
	
	if AdmNo="" {
		q $$ExecRegisterCancelErrMag("就诊流水号与His交易流水号不能都为空")
	}
	
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmNo,""))
	if RegFeeRowId="" {
		q $$ExecRegisterCancelErrMag("挂号记录不存在")
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s DefaultLoc=##class(DHCExternalService.RegInterface.GetRelate).GetLoc(UserID)
	s NewInvoiceId=""
	s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
	s Sum=0
	s InvPrtFlag=""
	Set PayMode="",PayModeCode=""
	i InvoiceId'=""{
		s Sum=$P(^DHCINVPRT(InvoiceId),"^",1)
		S ACCPINVDR=$P($G(^DHCINVPRT(InvoiceId)),"^",4)
		s InvPrtFlag=$P(^DHCINVPRT(InvoiceId),"^",3)
		if (ACCPINVDR'=""){
			S ACCPINVPrtFlag=$P($G(^DHCINVPRTAP(ACCPINVDR)),"^",2)
			if (ACCPINVPrtFlag="N"){
				q $$ExecRegisterCancelErrMag("该挂号记录请先到窗口撤销集中打印发票")
			}
		}

		s PayMode=$p(^DHCINVPRT(InvoiceId,"P",1),"^")   
        Set PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
	}
	if (InvPrtFlag="P"){
		q $$ExecRegisterCancelErrMag("该挂号记录发票已打印,请到窗口进行退号")
	}
	TS
	////`	RegFeeRowId, UserRowId, GroupRowId, LogonLocRowId, ByRef NewInvoiceId
	s rtn=##class(web.DHCOPAdmReg).CancelOPRegist(RegFeeRowId,UserID,GroupID,DefaultLoc,.NewInvoiceId)
	if (rtn'=0) 
	{
		TRO
		s ErrMsg=""
		if (rtn="diagnos"){
			s ErrMsg="已下诊断，不可退号"
		}elseif (rtn="cancel"){
			s ErrMsg="已退号"
		}elseif (rtn="overtime"){
			s ErrMsg="已过退号时间"
		}elseif (rtn="-200"){
			s ErrMsg="退费失败"
		}elseif (rtn="-204"){
			s ErrMsg="更新部分退费失败"
		}elseif (rtn="-201"){
			s ErrMsg="回置状态失败"
		}elseif (rtn="-210"){
			s ErrMsg="回退号源失败"
		}elseif (rtn="-202"){
			s ErrMsg="重置队列状态失败"
		}
		if ErrMsg="" s ErrMsg=rtn
		q $$ExecRegisterCancelErrMag("退号失败,"_ErrMsg)
	}
	Tc
	s OutPutObj={}
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="取消成功"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ExecRegisterCancelErrMag(ErrText="")
	if (ErrText="") s ErrText="取消挂号失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 当日挂号记录查询接口
ClassMethod GetRegisterList(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="GetRegisterListErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s PatientNo=InputObj.PatientId	;患者主键
	s AdmNo=InputObj.OrderId	;预约流水号
	s StartDate=InputObj.StartDate	;开始日期
	s EndDate=InputObj.EndDate	;结束日期
	if (UserID=""){
		q $$GetRegisterListErrMag("操作员代码为空")
	}
	i StartDate="" {
		q $$GetRegisterListErrMag("开始日期不能都为空.")
		
	}else{
		i $l(StartDate,"-")'=3 {
			q $$GetRegisterListErrMag("开始日期格式不对.")
		}
	}
	i EndDate="" {
		q $$GetRegisterListErrMag("结束日期不能都为空.")
	}else{
		i $l(EndDate,"-")'=3 {
			q $$GetRegisterListErrMag("结束日期格式不对.")
		}
	}
	s myPatientID=""
	if (PatientNo'=""){
		s myPatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		if (myPatientID=""){
			q $$GetRegisterListErrMag("病人记录不存在")
		}
	}
	s RegFeeId=""
	if (AdmNo'=""){
		set RegFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmNo,""))
	}
	s OutPutObj={}
	s Order=[]
	s RecordCount=0
	if (RegFeeId'=""){
		s AdmRowid=$list(^User.DHCRegistrationFeeD(RegFeeId),2)
		Set OrderObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetAdmInfoObj(AdmRowid,UserID)
		//if '$IsObject(OrderObj) q $$GetRegisterListErrMag("病人记录不存在")
		if $IsObject(OrderObj) {
			s AdmInfoObj={}
			s AdmInfoObj.PatientId=OrderObj.PatientID	;患者编码
			s AdmInfoObj.DeptId=OrderObj.DepartmentCode	;科室编码
			s AdmInfoObj.DoctorId=OrderObj.DoctorCode	;医生编码
			s AdmInfoObj.OrderDate=OrderObj.RegDate	;预约日期
			s AdmInfoObj.OrderId=OrderObj.AdmNo	;预约流水号
			s AdmInfoObj.Fee=OrderObj.RegFee	;挂号费
			s AdmInfoObj.Sequence=OrderObj.SeqCode	;就诊序号
			s AdmInfoObj.VisitTime=OrderObj.AdmitDate	;就诊时间
			s AdmInfoObj.CancelTime=""	;最晚取消时间
			s AdmInfoObj.SecurityCode=""	;挂号机取号密码
			s AdmInfoObj.State=OrderObj.Status	;预约单状态0:未就诊 1:已就诊2:已取消 3:已违约
			s RecordCount=RecordCount+1
			d Order.%Push(AdmInfoObj)
		}
		
	}else{
		f AdmDate=StartDate:1:EndDate{
			s AdmRowid=0
			f{
				s AdmRowid=$o(^PAADMi("PAADM_AdmDate",AdmDate,AdmRowid))
				q:AdmRowid=""
				s PatMasDr=$p($g(^PAADM(AdmRowid)),"^",1)
				continue:(myPatientID'="")&&(myPatientID'=PatMasDr)
				Set RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmRowid,0))
				continue:RegfeeRowId=""
				Set OrderObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetAdmInfoObj(AdmRowid,UserID)
				if $IsObject(OrderObj) {
					s AdmInfoObj={}
					s AdmInfoObj.PatientId=OrderObj.PatientID	;患者编码
					s AdmInfoObj.DeptId=OrderObj.DepartmentCode	;科室编码
					s AdmInfoObj.DoctorId=OrderObj.DoctorCode	;医生编码
					s AdmInfoObj.OrderDate=OrderObj.RegDate	;预约日期
					s AdmInfoObj.OrderId=OrderObj.AdmNo	;预约流水号
					s AdmInfoObj.Fee=OrderObj.RegFee	;挂号费
					s AdmInfoObj.Sequence=OrderObj.SeqCode	;就诊序号
					s AdmInfoObj.VisitTime=OrderObj.AdmitDate	;就诊时间
					s AdmInfoObj.CancelTime=""	;最晚取消时间
					s AdmInfoObj.SecurityCode=""	;挂号机取号密码
					s AdmInfoObj.State=OrderObj.Status	;预约单状态0:未就诊 1:已就诊2:已取消 3:已违约
					s RecordCount=RecordCount+1
					d Order.%Push(AdmInfoObj)
				}
			}
		}
	}
	if RecordCount'=0{
		s OutPutObj.ResultCode="0"
		s OutPutObj.Msg="查询成功"	
	}else{
		s OutPutObj.ResultCode="100"
		s OutPutObj.Msg="没有查询到挂号记录"	
	}
	s OutPutObj.Orders=Order
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetRegisterListErrMag(ErrText="")
	if (ErrText="") s ErrText="查询失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

}
