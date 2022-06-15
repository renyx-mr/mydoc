Class DHCDoc.Interface.DaLianHuaXin.InsuCommon Extends %RegisteredObject
{

Parameter ExtUserCode = "cashier";

Parameter IDCardTypeCode = 01;

Parameter CardTypeCode = 01;

/// 1.1.2.1 【G0002】医院查询接口
/// w ##class(DHCDoc.Interface.DaLianHuaXin.InsuCommon).GetHospInfo("{""input"":{""req"":{""fixmedins_code"":""H21021301867""}},""infno"":""G0002"",""msgid"":null,""mdtrtarea_admvs"":null,""insuplc_admdvs"":"""",""recer_sys_code"":null,""dev_no"":"""",""dev_safe_info"":"""",""cainfo"":"""",""signtype"":null,""infver"":null,""opter_type"":null,""opter"":null,""opter_name"":null,""inf_time"":null,""fixmedins_code"":null,""fixmedins_name"":""2022-05-20 15:15:45"",""sign_no"":""""}")
ClassMethod GetHospInfo(InputJson As %String)
{
	s ^tempRen("GetHospInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s ^tempszd("hospid")=InputObj
	s InputObj=InputObj.%Get("req")
	// fixmedins_code 定点医药机构编号	字符型	32		Y	规则：医保下发的定点医疗机构编号
	s FixMedinsCode=InputObj.%Get("fixmedins_code")
	//s ^tempszd("hospid")=FixMedinsCode
	s OutputObj=##class(%DynamicObject).%New()
	s HOSPRowId=0
    for {
        s HOSPRowId=$o(^CT("HOSP",HOSPRowId))
        q:HOSPRowId=""
        continue:$p($g(^CT("HOSP",HOSPRowId)),"^",2)["分院"
        s DateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
        continue:(DateFrom'="")&(DateFrom>+$h)
        s DateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
        continue:(DateTo'="")&(DateTo<=+$h)
        continue:FixMedinsCode'="H21021301867"
        s HospObj=##class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetHospInfoObj(HOSPRowId,FixMedinsCode)
        d OutputObj.%Set("res",HospObj)
    }
    q OutputObj.%ToJSON()
}

/// 2.1.1.2 【G0003】科室查询接口
ClassMethod GetDeptInfo(InputJson As %String)
{
	s ^tempRen("GetDeptInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	// fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
    s HospId=$case(HospId,"H21021301867":"2",:"")
    // dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一 ID，为-1 时查询所有科室信息，为0时查询所有一级科室信息，为其他时查本科室以及所有子科室信息
    s DeptId=InputObj.%Get("dept_id")
    s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(..#ExtUserCode)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
	s OutPutObj=##class(%DynamicObject).%New()
	s DeptList=[]
	if (DeptId="-1"){
	    s CTLocMajor=0
        for {
            s CTLocMajor=$o(^DHCCTLoc(CTLocMajor))
            q:CTLocMajor=""
            s LocHospDr=$p($g(^DHCCTLoc(CTLocMajor)),"^",5)
            continue:(LocHospDr'="")&&(LocHospDr'=HospId)
            s StartDate=$p($g(^DHCCTLoc(CTLocMajor)),"^",3)
            s EndDate=$p($g(^DHCCTLoc(CTLocMajor)),"^",4)
            continue:(StartDate'="")&&(StartDate>+$h)
            continue:(EndDate'="")&&(EndDate<=+$h)
            d DeptList.%Push(##class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetCTLocMajorObj(CTLocMajor,LocHospDr))
        }
        set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,"O",HospId)
		set myDeptNum=$length(myOPDeptStr,"^")
		for i=1:1:myDeptNum
		{
			set myOneDeptStr=$piece(myOPDeptStr,"^",i)
			set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
			continue:DepartmentCode=""
			//continue:DepartmentCode'="科室id"
			set DepartmentName=$piece(myOneDeptStr,$C(1),2)
			if (DepartmentName["-") d
			.set DepartmentName=$piece(DepartmentName,"-",1)
			set flag=0
			set ResRowId=0  
            f  {
                s ResRowId=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResRowId)) 
                Q:(ResRowId="")||(flag="1")
                continue:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
                s flag=1
            }
			if ((flag=0)&&(GroupResRowIdStr'="")) continue
            s LocFlag="0"
            s CTLocMajor=0
            s MyCTLocMajor=""
            for {
                s CTLocMajor=$o(^DHCCTLoc(CTLocMajor))
                q:(CTLocMajor="")!(LocFlag="1")
                s LocHospDr=$p($g(^DHCCTLoc(CTLocMajor)),"^",5)
                //continue:(LocHospDr'="")&&(LocHospDr'=HospId)
                s CTMLNRowid=0
                for {
                    Set CTMLNRowid=$O(^DHCCTLoc(CTLocMajor,"MINOR",CTMLNRowid)) 
                    q:(CTMLNRowid="")!(LocFlag="1")
                    Set CTLMNCTLocDR=$p($g(^DHCCTLoc(CTLocMajor,"MINOR",CTMLNRowid)),"^",1)
                    continue:CTLMNCTLocDR'=DepartmentCode
                    s MyCTLocMajor=CTLocMajor
                    s LocFlag="1"
                }
            }
            d DeptList.%Push(##class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetDeptInfoObj(DepartmentCode,MyCTLocMajor))
		}
	}elseif(DeptId="0"){
        s CTLocMajor=0
        for {
            s CTLocMajor=$o(^DHCCTLoc(CTLocMajor))
            q:CTLocMajor=""
            s LocHospDr=$p($g(^DHCCTLoc(CTLocMajor)),"^",5)
            continue:(LocHospDr'="")&&(LocHospDr'=HospId)
            s StartDate=$p($g(^DHCCTLoc(CTLocMajor)),"^",3)
            s EndDate=$p($g(^DHCCTLoc(CTLocMajor)),"^",4)
            continue:(StartDate'="")&&(StartDate>+$h)
            continue:(EndDate'="")&&(EndDate<=+$h)
            d DeptList.%Push(##class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetCTLocMajorObj(CTLocMajor,LocHospDr))
        }
	}else{
        //s LocHospDr=$p(^DHCCTLoc(DeptId),"^",5)
        //q:(LocHospDr'="")&&(LocHospDr'=HospId)
        s CTMLNRowid=0
        for {
			Set CTMLNRowid=$O(^DHCCTLoc(DeptId,"MINOR",CTMLNRowid)) q:CTMLNRowid=""
			Set CTLMNCTLocDR=$p($g(^DHCCTLoc(DeptId,"MINOR",CTMLNRowid)),"^",1)
			Set DepartmentName=""
            Set DepartmentCode=""
			if CTLMNCTLocDR'="" Set DepartmentName=$p($g(^CTLOC(CTLMNCTLocDR)),"^",2)
            if CTLMNCTLocDR'="" Set DepartmentCode=$p($g(^CTLOC(CTLMNCTLocDR)),"^",1)
			Set CTLMNIsActive=$p($g(^DHCCTLoc(DeptId,"MINOR",CTMLNRowid)),"^",2)
			Continue:CTLMNIsActive'=1
			set flag=0
			set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",CTLMNCTLocDR,ResRowId)) Q:ResRowId=""  d
 			.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 			.s flag=1
 			if ((flag=0)&&(GroupResRowIdStr'="")) continue
 			s StartDate=$p($g(^DHCCTLoc(DeptId)),"^",3)
            s EndDate=$p($g(^DHCCTLoc(DeptId)),"^",4)
 			//set ExistDepSchedule=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(CTLMNCTLocDR,StartDate,EndDate)
			;查科室过滤没有排班的科室
			//continue:(ExistDepSchedule=0)
 			Set DepartmentHospCode=$p($g(^CTLOC(CTLMNCTLocDR)),"^",22)
			continue:(DepartmentHospCode'="")&&(HospId'=DepartmentHospCode)
            set LocAddress=""
			set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
			if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
			d DeptList.%Push(##class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetDeptInfoObj(DepartmentCode,DepartmentHospCode))
        }
	}
	s ResObj=##class(%DynamicObject).%New()
    d ResObj.%Set("dept_list",DeptList)
    ///d OutPutObj.%Set("res",ResObj)
    q ResObj.%ToJSON()
}

/// 2.1.1.3 【G0004】医生查询接口
ClassMethod GetDoctorInfo(InputJson As %String)
{
	s ^tempRen("GetDoctorInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
    s HospId=$case(HospId,"H21021301867":"2",:"")
    ; dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一 ID，为-1 时查询所有科室信息，为0时查询所有一级科室信息，为其他时查本科室以及所有子科室信息
    s DeptId=InputObj.%Get("dept_id")
    ; doctor_id	医生ID	字符型	32		Y	HIS系统中医生唯一 ID，为-1 时查询该科室下所有医生，否则查指定某个医生信息
    s DoctorId=InputObj.%Get("doctor_id")
    s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(..#ExtUserCode)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
    //i DepartmentCode="" d ..SetOutputCode(.OutputObj,"-101202","科室代码不能都为空.") q OutputObj
	Set rs1=##class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:FindResDoc")
    s:DoctorId="-1" DoctorId=""
    s:DeptId="-1" DeptId=""
    s OutPutObj=##class(%DynamicObject).%New()
    s DocCount=0
    s DocList=[]
	If rs1.QueryIsValid() { 
		Set Status=rs1.Execute(DeptId,UserID,DoctorId)
		If 'Status Quit
		While rs1.Next() {
			set DocDesc=rs1.GetData(1)
			continue:(DocDesc["普通")!(DocDesc["专家")
			set DocCode=rs1.GetData(2)
			set DocID=rs1.GetData(3)
			s UserId=$o(^SSU("SSUSR",0,"CTPCP",DocID,""))
			continue:UserId=""
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
            s DocCount=DocCount+1
            s DocObj=##class(%DynamicObject).%New()
            ; dept_id	DOCTOR_LIST	String(32)	√	科室ID，医生所属排班科室
            d DocObj.%Set("dept_id",DeptId)
            ; doctor_id	DOCTOR_LIST	String(32)	√	医生ID，HIS系统中医生唯一ID
            d DocObj.%Set("doctor_id",DocID)
            ; name	DOCTOR_LIST	String(128)	√	医生名称
            d DocObj.%Set("name",DocDesc)
            ; idcard	DOCTOR_LIST	String(20)		医生身份证号
            d DocObj.%Set("idcard","")
            ; desc	DOCTOR_LIST	String(500)		介绍
            d DocObj.%Set("desc","")
            ; special	DOCTOR_LIST	String(128)		医生擅长
            d DocObj.%Set("special","")
            ; job_title	DOCTOR_LIST	String(32)	√	医生职称
            d DocObj.%Set("job_title",DocProveTypeDesc)
            ; reg_fee	DOCTOR_LIST	Number(10)	√	挂号费用，单位：分
            s RegFee=0,ArcimIdStr=""
            if (DocProveTypeID'=""){
	            s Child=0 
	            f  {
		            s Child=$O(^RBC("SESS",DocProveTypeID,"SER",Child)) 
		            q:(Child="")  
		            s ArcimId=$p($G(^RBC("SESS",DocProveTypeID,"SER",Child)),"^",1)
		            continue:ArcimId=""
		            ;i ArcimIdStr="" s ArcimIdStr=ArcimId
					;e  s ArcimIdStr=ArcimIdStr_"^"_ArcimId
					s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,+$h,"","","","","",""),"^",4)
					s RegFee=RegFee+BillPrice
	            }
            }
            
            d DocObj.%Set("reg_fee",RegFee)
            ; status	DOCTOR_LIST	String(1)	√	状态，1-正常 2-注销
            d DocObj.%Set("status","1")
            ; sex	DOCTOR_LIST	String(1)	√	性别，详见 “性别”
            s SexDr= $p($g(^CTPCP(DocID,3)),"^",34)
            s SexDesc=""
            s:SexDr'="" SexDesc=$p($g(^CT("SEX",SexDr)),"^",2)
            s SexDesc=$case(SexDesc,"女":"0","男":"1",:"2")
            d DocObj.%Set("sex",SexDesc)
            ; birthday	DOCTOR_LIST	String(20)		出生日期，格式：YYYY-MM-DD
            d DocObj.%Set("birthday","")
            ; mobile	DOCTOR_LIST	String(20)		手机号码
            d DocObj.%Set("mobile","")
            ; tel	DOCTOR_LIST	String(20)		办公室号码
            d DocObj.%Set("tel","")
            ; doctor_ybid	DOCTOR_LIST	String(50)		医师医保编码，医保中心备案医师编码
            d DocObj.%Set("doctor_ybid",##class(web.DHCCLCareProv).GetDoctorCodeByDescNews(DocDesc))
            d DocList.%Push(DocObj)
        }
    }
    s ResObj=##class(%DynamicObject).%New()
    d ResObj.%Set("doctor_list",DocList)
    //d OutPutObj.%Set("res",ResObj)
    q ResObj.%ToJSON()
}

/// 2.1.1.4 【G0005】排班信息查询接口
ClassMethod GetRegInfo(InputJson As %String)
{
	s ^tempRen("GetRegInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
	; dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一 ID，为-1 时查询所有科室信息，为0时查询所有一级科室信息，为其他时查本科室以及所有子科室信息
    s DeptId=InputObj.%Get("dept_id")
    ; doctor_id	医生ID	字符型	32		Y	HIS系统中医生唯一 ID，为-1 时查询该科室下所有医生，否则查指定某个医生信息
    s DoctorId=InputObj.%Get("doctor_id")
    ; start_date	排班开始日期	字符型	20		Y	格式：YYYY-MM-DD
    s StartDate=InputObj.%Get("start_date")
    ; end_date	排班结束日期	字符型	20		Y	格式：YYYY-MM-DD
	s EndDate=InputObj.%Get("end_date")
	;s EndDate=InputObj.%Get("END_DATE")
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:StartDate="" StartDate=+$h
    s:EndDate="" EndDate=+$h
    s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(..#ExtUserCode)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    s OutPutObj=##class(%DynamicObject).%New()
    s AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s RegDoctorList=[]
	s ResID=0
    for {
        s ResID=$O(^RB("RES",0,"CTLOC",DeptId,ResID)) q:ResID=""
        s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
        Continue:ResCTPCPDR=""
        s UserId=$o(^SSU("SSUSR",0,"CTPCP",ResCTPCPDR,""))
		continue:UserId=""
        Continue:(DoctorId'="-1")&(DoctorId'=ResCTPCPDR)
        s DocProveDesc=$p(^CTPCP(ResCTPCPDR,1),"^",4)
        continue:(DocProveDesc["普通")!(DocProveDesc["专家")
        s DocProveTypeDesc=""
        s DocProveTypeID=$p(^CTPCP(ResCTPCPDR,1),"^",4)
        s:DocProveTypeID'="" DocProveTypeDesc=$p(^CT("CPT",DocProveTypeID),"^",2)
        continue:DocProveTypeDesc["护"
        for Date=StartDate:1:EndDate{
            //s AdmScheduleList=##class(%GlobalCharacterStream).%New()
            s Time=""
            for {
                s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")
                s Sub=0
                for {
                    s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")
                    s RBASID=ResID_"||"_Sub
                    s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
                    s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
                    ;不显示当前时段以前的号
                    Continue:(ASDate=+$H)&&(SessEndTime<$p($h,",",2))
                    s RBASServiceCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",7)
                    //Continue:(ServiceCode'="")&(ServiceCode'=RBASServiceCode)
                    s RBASSessionCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",17)
                    s ScheduleObj=##class(User.RBApptSchedule).%OpenId(RBASID)
	                s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	                continue:DHCRBASObj.ASStatusDR.ASSCode="S" ;"-1^停诊"
	                continue:DHCRBASObj.ASStatusDR.ASSCode="TR" ;"-1^被替诊"
	                continue:DHCRBASObj.ASStatusDR.ASSCode="PS" ;"-1^中途停诊"
	                continue:DHCRBASObj.ASStatusDR.ASSCode="SPSA" ;"-1^只停正号"
	                s RegDoctorObj=##class(%DynamicObject).%New()
	                ; doctor_id	医生ID	字符型	32		Y	
	                d RegDoctorObj.%Set("doctor_id",ResCTPCPDR)
	                ; name	医生名称	字符型	128		Y
	                s DocDesc=$p(^CTPCP(ResCTPCPDR,1),"^",2)
	                d RegDoctorObj.%Set("name",DocDesc)	
	                ; job_title	医生职称	字符型	32		Y	
					d RegDoctorObj.%Set("job_title",DocProveTypeDesc)
					s RegList=[]
					s RegObj=##class(%DynamicObject).%New()
					; reg_date	出诊日期	字符型	20		Y	格式：YYYY-MM-DD
					s RegDate=##class(websys.Conversions).DateLogicalToHtml(Date)
					d RegObj.%Set("reg_date",RegDate)
					; reg_weekday	出诊日期对应星期	字符型	16		Y	如：星期五
					s WeekDay=$zd(Date,10)
                    s WeekDay="星期"_$case(WeekDay,"0":"七","1":"一","2":"二","3":"三","4":"四","5":"五","6":"六")
					d RegObj.%Set("reg_weekday",WeekDay)
					s RegTimeList=##Class(DHCDoc.Interface.DaLianHuaXin.InsuInterface).GetRBASRecObjByRBASObj(ScheduleObj,DHCRBASObj,AppRegMethodCode)
					d RegObj.%Set("reg_time_list",RegTimeList)
					d RegList.%Push(RegObj)
					d RegDoctorObj.%Set("reg_list",RegList)
	                d RegDoctorList.%Push(RegDoctorObj)
	                d ScheduleObj.%Close()
	                d DHCRBASObj.%Close()
                }
            }
        }
    }
    s ResObj=##class(%DynamicObject).%New()
    d ResObj.%Set("reg_doctor_list",RegDoctorList)
    //d OutPutObj.%Set("res",ResObj)
    q ResObj.%ToJSON()
}

/// 2.1.1.5 【G0006】排班分时查询接口
ClassMethod GetTimeRegInfo(InputJson As %String)
{
	s ^tempRen("GetTimeRegInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
	s InputObj=InputObj.%Get("req")
	; dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一 ID，为-1 时查询所有科室信息，为0时查询所有一级科室信息，为其他时查本科室以及所有子科室信息
    s DeptId=InputObj.%Get("dept_id")
    ; doctor_id	医生ID	字符型	32		Y	HIS系统中医生唯一 ID，为-1 时查询该科室下所有医生，否则查指定某个医生信息
    s DoctorId=InputObj.%Get("doctor_id")
    ; reg_date	出诊日期	字符型	20		Y	格式：YYYY-MM-DD
    s RegDate=InputObj.%Get("reg_date")
    s RegDate=##class(websys.Conversions).DateHtmlToLogical(RegDate)
    ; time_flag	时段	字符型	2	Y	Y	为-1时查询当天所有分时排班
    s TimeFlag=InputObj.%Get("time_flag")
    s OutPutObj=##class(%DynamicObject).%New()
    s TimeRegList=[]
	if (DeptId'="")&&(RegDate'=""){
        s ResRowId=0
        for {
            s ResRowId=$O(^RB("RES",0,"CTLOC",DeptId,ResRowId)) q:ResRowId=""
            s ResCTPCPDR=$p($g(^RB("RES",ResRowId)),"^",2)
            Continue:ResCTPCPDR=""
            Continue:(DoctorId'="-1")&(DoctorId'=ResCTPCPDR)
            s Childsub=0
            for {
                s Childsub=$o(^RBAS(0,"Date",RegDate,ResRowId,Childsub))
                q:Childsub=""
                continue:RegDate<+$h
                s TimeRangeDR=$p($g(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
                //continue:(TimeFlag'="-1")&&(" 1 2 3 "'[TimeRangeDR)&&(TimeRangeDR'=TimeFlag)
                s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
                ;正号串与加号串
                s RBASRowId=ResRowId_"||"_Childsub
                s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
                s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
                s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ResRowId_"||"_Childsub)
                s RegTotal=""
                if (RegType="APP"){
                    s StartNo=$p(^RBAS(ResRowId,Childsub),"^",10)
                    s:StartNo="" StartNo=1
                    s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
                    s EndNo=StartNo+AppQty-1
                    s RegTotal=AppQty
                    //s MastLeftQty=AppQty-myMethodUsedQty
                }else{
                    s StartNo=1
                    s EndNo=$l(NormalQueueNoStr,",")
                    s RegTotal=EndNo
                }
                s ASTimeRangeDR=$case(TimeRangeDR,"1":"1","2":"2","3":"3",:"-1")
                s SessStartTime=$p($g(^RBAS(ResRowId,Childsub)),"^",4)
                s SessStartTime=##class(websys.Conversions).TimeLogicalToHtml(SessStartTime)
                s SessEndTime=$p($g(^RBAS(ResRowId,Childsub)),"^",5)
                s SessEndTime=##class(websys.Conversions).TimeLogicalToHtml(SessEndTime)
                s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)
                if (TRFlag="Y"){
                    s ASTRSub=0 for {
                        s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
                        q:ASTRSub=""
                        s starttime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
                        continue:(RegDate=+$h)&&(starttime<$p($h,",",2))
                        s starttime=##class(websys.Conversions).TimeLogicalToHtml(starttime)
                        s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
                        
                        s endtime=##class(websys.Conversions).TimeLogicalToHtml(endtime)
                        s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
                        s AvailableNum=##class(web.DHCRBAppointment).GetAvailableNum(RBASRowId,RegType,"WIN","",starttime,endtime)
                        s RBASTimeObj=##class(%DynamicObject).%New()
                        ; time_flag	时段	字符型	1	Y	Y
                        d RBASTimeObj.%Set("time_flag",ASTimeRangeDR)	
                        ; begin_time	分时开始时间	字符型	5		Y	格式：HH24:MI
                        d RBASTimeObj.%Set("begin_time",starttime)
                        ; end_time	分时结束时间	字符型	5		Y	格式：HH24:MI
                        d RBASTimeObj.%Set("end_time",endtime)
                        ; total	该时段可挂号源总数	整型			Y	不限号源数量默认传 -1
                        d RBASTimeObj.%Set("total",TRLoad)
                        ; over_count	该时段剩余号源数	整型			Y	不限号源数量默认参数代码	参数名称	参数类型	参数长度	代码标识	是否必填	说明传 -1
                        d RBASTimeObj.%Set("over_count",AvailableNum)
                        ; reg_id	排班ID	字符型	32		Y	院内唯一
                        d RBASTimeObj.%Set("reg_id",ResRowId_"||"_Childsub_"||"_ASTRSub)
                        d TimeRegList.%Push(RBASTimeObj)
                    }
                }else{
	                s RBASTimeObj=##class(%DynamicObject).%New()
	                ; time_flag	时段	字符型	1	Y	Y	
	                d RBASTimeObj.%Set("time_flag",ASTimeRangeDR)
                    ; begin_time	分时开始时间	字符型	5		Y	格式：HH24:MI
                    d RBASTimeObj.%Set("begin_time",SessStartTime)
                    ; end_time	分时结束时间	字符型	5		Y	格式：HH24:MI
                    d RBASTimeObj.%Set("end_time",SessEndTime)
                    ; total	该时段可挂号源总数	整型			Y	不限号源数量默认传 -1
                    d RBASTimeObj.%Set("total",RegTotal)
                    ; over_count	该时段剩余号源数	整型			Y	不限号源数量默认参数代码	参数名称	参数类型	参数长度	代码标识	是否必填	说明传 -1
                     s AvailableNum=##class(web.DHCRBAppointment).GetAvailableNum(RBASRowId,RegType,"WIN","","13:00","14:00")
                    d RBASTimeObj.%Set("over_count",AvailableNum)
                    ; reg_id	排班ID	字符型	32		Y	院内唯一
                    d RBASTimeObj.%Set("reg_id",RBASRowId)
	                d TimeRegList.%Push(RBASTimeObj)
                }
            }
        }
	}
	s ResObj=##class(%DynamicObject).%New()
    d ResObj.%Set("time_reg_list",TimeRegList)
    //d OutPutObj.%Set("res",ResObj)
	q ResObj.%ToJSON()
}

/// 2.1.1.6 【G0007】预挂号接口
/// q ##class(DHCDoc.Interface.DaLianHuaXin.InsuCommon).OrderReg()
ClassMethod OrderReg(InputJson As %String)
{
	s ^tempRen("GetTimeRegInfo")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; order_id	平台订单号	字符型	32		Y
	s OrderId=InputObj.%Get("order_id")	
	; channel_id	挂号渠道ID	字符型	1	Y	Y\
	s ChannelId=InputObj.%Get("channel_id")		
	; is_reg	是否为预约挂号	字符型	1		Y	1-当天挂号 2-预约挂号（直接挂号）
	s IsReg=InputObj.%Get("is_reg")	
	; pati_type	患者类型	字符型	1		Y	1-普通 2医保 3-其他
	s PatiType=InputObj.%Get("pati_type")	
	; reg_id	排班ID	字符型	32		Y	由上个接口得到（院内唯一）
	s RegId=InputObj.%Get("reg_id")	
	; reg_level	排班类别	字符型	1			1-普通 2专家 3-急诊
	s RegLevel=InputObj.%Get("reg_level")	
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
	s HospId=$case(HospId,"H21021301867":"2",:"")	
	; dept_id	科室ID	字符型	32		
	s DeptId=InputObj.%Get("DeptId")		
	; doctor_id	医生ID	字符型	32		
	s DoctorId=InputObj.%Get("doctor_id")		
	; reg_date	出诊日期	字符型	20			格式：YYYY-MM-DD
	s RegDate=InputObj.%Get("reg_date")	
	; time_flag	时段	字符型	1	Y	
	s TimeFlag=InputObj.%Get("time_flag")		
	; begin_time	分时开始时间	字符型	5			格式：HH24:MI
	s BeginTime=InputObj.%Get("begin_time")	
	; end_time	分时结束时间	字符型	5			格式：HH24:MI
	s EndTime=InputObj.%Get("end_time")	
	if ($l(RegId,"||")=3){
	    s BeginTime=$P(^RBAS(+RegId,$p(RegId,"||",2),"ASTR",$p(RegId,"||",3)),"^",1)
        s BeginTime=##class(websys.Conversions).TimeLogicalToHtml(BeginTime)
        s EndTime=$P(^RBAS(+RegId,$p(RegId,"||",2),"ASTR",$p(RegId,"||",3)),"^",2)
        s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
    }
    s RegId=+RegId_"||"_$p(RegId,"||",2)
	; reg_type	挂号类型	字符型	1	Y	Y	
	s RegType=InputObj.%Get("reg_type")	
	; reg_fee	挂号费用	数值型	10，2		Y	单位：元
	s RegFee=InputObj.%Get("reg_fee")	
	; idcard_no	患者证件号码	字符型	20			挂号类型是为本人和为他人挂号时必填，为没有身份证的子女挂号时可以为空
	s IDCardNo=InputObj.%Get("idcard_no")	
	; name	患者姓名	字符型	32		Y	
	s Name=InputObj.%Get("name")	
	; sex	患者性别	字符型	1	Y	Y	
	s Sex=InputObj.%Get("sex")	
	; birthday	患者出生日期	字符型	20		Y	格式：YYYY-MM-DD
	s BirthDay=InputObj.%Get("birthday")	
	; address	患者所在地	字符型	128			
	s Address=InputObj.%Get("address")	
	; mobile	患者手机号码	字符型	20			
	s Mobile=InputObj.%Get("mobile")	
	; oper_idcard_no	挂号人身份证号码	字符型	20		Y	
	s OPerIDCardNo=InputObj.%Get("oper_idcard_no")	
	; oper_name	挂号人姓名	字符型	32		Y	
	s OPerName=InputObj.%Get("oper_name")	
	; oper_mobile	挂号人手机号码	字符型	20		Y	
	s OPerMobile=InputObj.%Get("oper_mobile")	
	; order_time	下单时间	字符型	20		Y	格式：YYYY-MM-D DHH24:MI:SS
	s OrderTime=InputObj.%Get("order_time")	
	; res_content	人员基本信息接口返回报文	字符型	4000		Y	结构按照【医疗保障信息平台定点医药机构接口规范(基线版)】人员基本信息返回值
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(..#ExtUserCode)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
    if Name=""{
		q $$OrderRegErr("200911","患者姓名不能为空")
	}
    if (RegType="1")!(RegType="3"){
        ;根据患者信息进行查询 
        if IDCardNo=""{
            q $$OrderRegErr("200911","患者证件号码不能为空")
        }
        s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("",..#IDCardTypeCode)
        s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,IDCardNo,Name)
    }else{
        // s ^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
        s OPerIDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("",..#IDCardTypeCode)
        s PatientIDStr=$$GetPatientIDStrByForeignInfo
    }
    if $l(PatientIDStr,"^")>1 q $$OrderRegErr("200904","院内多个用户档案，请到医院处理")
    i '$d(^PAPER(+PatientIDStr,"ALL"))  {
        s InsertCardObj=$$CreatePatientCard
        if (InsertCardObj.ResultCode="0"){
            s PatientIDStr=InsertCardObj.PatientID
        }else{
            q $$OrderRegErr("200903",InsertCardObj.ResultContent)
        }
    }
    s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRt).%New()
    s InputObj.ScheduleItemCode=RegId
	s InputObj.ExtUserID=..#ExtUserCode
	s AdmLocDr=$P(^RB("RES",+RegId),"^",1) ;科室ID
	s hopitalID=$P(^CTLOC(AdmLocDr),"^",22) ;医院 id
	s InputObj.CardNo=""
	s InputObj.CardType=""
	s InputObj.LockQueueNo=""
	s InputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(+PatientIDStr) // +PatientIDStr
	s InputObj.BeginTime=BeginTime
	s InputObj.EndTime=EndTime
	s InputObj.Mobile=Mobile
	s InputObj.HospitalID=hopitalID
    s InputObj.TransactionId=OrderId
	;因为用户是平台写死传入的WX,在此作处理根据预约的科室来判断，如果是密地则传入WXMD
	do InputObj.XMLExportToString(.InputXML,"Request")
	s LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(InputXML)
	if LockOutputObj.ResultCode'="0"{
        s ResultCode=$case(LockOutputObj.ResultCode,:"-1")
        q $$OrderRegErr(ResultCode,LockOutputObj.ResultContent)
	}
    /*s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
		if CTLSRowID'=""{
			;预约来源,预约途径,联系电话,挂号类别,预约状态,是否可以取消预约,记录更新日期,记录更新时间
			s ^CTLS(CTLSRowID,"OrgUnit")=createSourceKey_"^"_createSourceTypeId_"^"_patientMobileNumber_"^"_appointmentTypeId_"^"_appointmentStatusId_"^"_isCancellable_"^"_updateDate_"^"_updateTime
		}*/
    //s AppointObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appoint).%New()
    //s AppointObj.appointmentId=TransactionId
    //s OutputObj.AppointData=AppointObj
    s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(+PatientIDStr)
    s OutPutObj=##class(%DynamicObject).%New()
    s ResObj=##class(%DynamicObject).%New()
    ; pay_serial	医院订单号	字符型	32		Y	
    d ResObj.%Set("pay_serial",LockOutputObj.TransactionId)
    ; hosp_patient_id	医院病人ID	字符型	32		Y	
    d ResObj.%Set("hosp_patient_id",PatientNo)
    ; hosp_serial_num	医院候诊号	字符型	32			
    d ResObj.%Set("hosp_serial_num",LockOutputObj.LockQueueNo)
    ; hosp_getreg_date	医院取号时间段或时间点	字符型	32			格式：HH24MI-HH24MI
    d ResObj.%Set("hosp_getreg_date","")
    ; hosp_see_doct_addr	医院就诊地址	字符型	256			
    d ResObj.%Set("hosp_see_doct_addr","")
    ; ipt_otp_no	医院病历号或门诊号	字符型	32		Y	就诊唯一标识
    d ResObj.%Set("ipt_otp_no","")
    d OutPutObj.%Set("res",ResObj)
	q OutPutObj.%ToJSON()
GetPatientIDStrByForeignInfo
	&sql(DECLARE PatByForeignList CURSOR FOR
		SELECT PAPER_RowId
		INTO :PatientId
		FROM SQLUser.PA_Person WHERE PAPER_ForeignId=:OPerName AND PAPER_ForeignCountry=:OPerIDCardNo
		AND PAPER_ForeignCardTypeDR=:OPerIDCardType
	)
	&SQL(OPEN PatByForeignList)
	s intNum=0
 	For {
	 	&SQL(FETCH PatByForeignList) 
	 	QUIT:SQLCODE
		s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
		continue:ActiveFlag="N"
	 	s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )
		;continue:(PatCredNo'="")&&(PatCredNo'=PAPMIDVAnumber)
		s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
		;continue:(IDCardType'="")&&(myCredTypeID'=IDCardType)
		s CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
		continue:(Name'="")&&(Name'=CurName)
		if (PatientIDStr="") s PatientIDStr=PatientId
		else  s PatientIDStr=PatientIDStr_"^"_PatientId
 	}
 	&SQL(CLOSE PatByForeignList)
	q PatientIDStr
CreatePatientCard
    Set InputObj=##class(DHCExternalService.CardInterface.Entity.SavePatientCardRt).%New()
	;set InputObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	set InputObj.Address=Address
	Set InputObj.TradeCode="3014"
	set InputObj.CardTypeCode=..#CardTypeCode
	set InputObj.PatientCard=""
	set InputObj.SecurityNo=""
	set InputObj.PatientName=Name
	set InputObj.Sex=$case(Sex,"1":"1","0":"2",:"0")
	set InputObj.DOB=BirthDay
	set InputObj.IDType=..#IDCardTypeCode
	set InputObj.IDNo=IDCardNo
	set InputObj.Mobile=Mobile
	set InputObj.UserID=..#ExtUserCode
	Set InputObj.TerminalID=""
	set InputObj.CardDepositAmt=""
	set InputObj.PayModeCode=""
	set InputObj.PayBankCode=""
	set InputObj.PayCardNo=""
	set InputObj.PayTradeStr=""
    ; 1-普通 2-医保 3-其他
	set InputObj.PatientType=$case(PatiType,"2":"12",:"01")
	set InputObj.ChargeDepositAmt=""
	set InputObj.AccountPassword=""
	set InputObj.TheArea=""
	set InputObj.BankTradeInfo=""
	set InputObj.IsSpecialFlag=""
	set InputObj.SecurityNo=""
	set InputObj.TelephoneNo=Mobile
    ;  联系人姓名，手机号 ，证件号待添加
    set InputObj.ContactName=OPerName
    set InputObj.ContactTelNo=OPerMobile
	do InputObj.XMLExportToString(.InputXML,"Request")
	b ;hhr inserterr1
	s InsertRet=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(InputXML)
	q InsertRet
OrderRegErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="预挂号失败"
    s OutPutObj=##class(%DynamicObject).%New()
    s MsgErr=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d MsgErr.%Set("code",ErrCode)
    d MsgErr.%Set("remark",ErrText)
    d OutPutObj.%Set("res",MsgErr)
    q OutPutObj.%ToJSON()
}

/// 2.1.1.7 【G0008】挂号取消接口
ClassMethod CancelReg(InputJson As %String)
{
	s ^tempRen("CancelReg")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
    s HospId=$case(HospId,"H21021301867":"2",:"")
	; order_id	平台订单号	字符型	32		Y	
	s OrderId=InputObj.%Get("order_id")
	; cancel_date	取消时间	字符型	20		Y	格式：YYYY-MM-D DHH24:MI:SS
	s CancelDate=InputObj.%Get("cancel_date")
	; cancel_remark	取消原因	字符型	512		
	s CancelRemark=InputObj.%Get("cancel_remark")
	s UserId=##class(DHCExternalService.RegInterface.GetRelate).GetUser(..#ExtUserCode)
	s RegFeeRowId="",ADMDr=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",OrderId,""),-1)
	s RefundBillNo=""
	if (CTLSRowID=""){
		q $$CancelRegErr("201001","该订单已失效")
		
	}
	s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
	if HISAdmDr'=""{
		q $$CancelRegErr("201002","该订单已支付")
	}
	s PatientNo=$p(^CTLS(CTLSRowID),"^",1)
	s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	if (myPatientID=""){
		q $$CancelRegErr("201003","指定有效患者信息")
	}
    s ScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
    if (ScheduleItemCode=""){
	    q $$CancelRegErr("201003","排班记录标识不能为空")
	}
    s LockQueueNo=$p(^CTLS(CTLSRowID),"^",3)
    if (LockQueueNo=""){
	    q $$CancelRegErr("201003","取消订单时,顺序号不得为空")
	}
    d ##class(web.DHCLockSchedule).UnLockSchedule(ScheduleItemCode,PatientNo,LockQueueNo)
    s OutPutObj=##class(%DynamicObject).%New()
    s ResObj=##class(%DynamicObject).%New()
    ; code	业务响应码	字符型	32		Y
    d ResObj.%Set("code","0")	
    ; remark	备注	字符型	32		Y	
	d ResObj.%Set("remark","取消成功")
    d OutPutObj.%Set("res",ResObj)
	q OutPutObj.%ToJSON()
CancelRegErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="取消锁号失败"
    s OutPutObj=##class(%DynamicObject).%New()
    s MsgErr=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d MsgErr.%Set("code",ErrCode)
    d MsgErr.%Set("remark",ErrText)
    d OutPutObj.%Set("res",MsgErr)
    q OutPutObj.%ToJSON()
}

/// 2.1.1.8 【G0009】挂号退款请求接口
ClassMethod Refund(InputJson As %String)
{
	s ^tempRen("Refund")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; fixmedins_code	定点医药机构编号	字符型	32		Y	
	s HospId=InputObj.%Get("fixmedins_code")
    s HospId=$case(HospId,"H21021301867":"2",:"")
	; order_id	平台订单号	字符型	32		Y	
	s OrderId=InputObj.%Get("order_id")
	; hosp_order_id	医院订单号	字符型	32	
	s HospOrderId=InputObj.%Get("hosp_order_id")		
	; refund_remark	退款原因	字符型	512		
	s RefundRemark=InputObj.%Get("refund_remark")	
	s RegFeeRowId="",ADMDr=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",OrderId,""),-1)
	s RefundBillNo=""
	// renyx 根据项目要求先不允许退号
	 q $$RefundErr("201107","医院不允许退款")
	if (CTLSRowID'=""){
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
		if (ADMDr'=""){
			s RegFeeRowId=$o(^User.DHCRegistrationFeeI("ADM"," "_ADMDr,""))
		}
	}else{
        q $$RefundErr("201101","该订单号对应记录不存在")
	}
    if RegFeeRowId=""{
        q $$RefundErr("201101","挂号记录不存在")
	}
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
                q $$RefundErr("201107","该挂号记录请先到窗口撤销集中打印发票")
			}
		}
		s PayMode=$p(^DHCINVPRT(InvoiceId,"P",1),"^")   
        Set PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
	}
	if (InvPrtFlag="P"){
        q $$RefundErr("201107","该挂号记录发票已打印,请到窗口进行退号")
	}
	s CheckAdmDiagnosInfo=##class(web.DHCOPAdmReg).CheckAdmDiagnos(ADMDr)
	if (+CheckAdmDiagnosInfo="1"){
		q $$RefundErr("201107",$p(CheckAdmDiagnosInfo,"^",2))
	}
	s OPRegReturnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRq).%New()
    s OPRegReturnObj.ExtUserID=..#ExtUserCode
    s OPRegReturnObj.HospitalId=HospId
    s OPRegReturnObj.TransactionId=OrderId
    s OPRegReturnObj.AdmNo=ADMDr
	do OPRegReturnObj.XMLExportToString(.InputXML,"Request")
	s RegReturnOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegReturn(InputXML)
	if RegReturnOutputObj.ResultCode'="0"{
		q $$RefundErr(RegReturnOutputObj.ResultCode,RegReturnOutputObj.ResultContent)
	}
	s:InvoiceId'="" ^tempren("StrikeDivideAndAdmInfo","Ret")=##class(web.DHCINSUPort).StrikeDivideAndAdmInfo(InvoiceId)
	s SetHISTradeNo=RegReturnOutputObj.SetHISTradeNo
	//s:SetHISTradeNo'="" ^tempren("SetHISTradeNo","Ret")=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo($p(SetHISTradeNo,",",1),$p(SetHISTradeNo,",",2),$p(SetHISTradeNo,",",3),$p(SetHISTradeNo,",",4),$p(SetHISTradeNo,",",5),$p(SetHISTradeNo,",",6))
	s ^tempren("SetHISTradeNo")=SetHISTradeNo
	s OutPutObj=##class(%DynamicObject).%New()
	s ResObj=##class(%DynamicObject).%New()
	; hosp_refund_id	医院退款单号	字符型	32		Y	
	d ResObj.%Set("hosp_refund_id",InvoiceId)
	; refund_flag	退款标志	字符型	32		Y	0-失败 1成功（平台执行退款）2-院内已退现
	d ResObj.%Set("refund_flag","1")
	d OutPutObj.%Set("res",ResObj)
	q OutPutObj.%ToJSON()
RefundErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="取消挂号请求失败"
    if (ErrCode="201107") s ErrText="医院不允许退款"
    s OutPutObj=##class(%DynamicObject).%New()
    s MsgErr=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d MsgErr.%Set("remark",ErrText)
    d MsgErr.%Set("refund_flag","0")
    d OutPutObj.%Set("res",MsgErr)
    q OutPutObj.%ToJSON()
}

/// 2.1.2.1 【G0010】缴费信息推送接口
ClassMethod OPRegister(InputJson As %String)
{
	s ^tempRen("OPRegister")=InputJson
	s InputObj=##class(%DynamicObject).%FromJSON(InputJson)
	s InputObj=InputObj.%Get("input")
	s InputObj=InputObj.%Get("req")
	; fixmedins_code	定点医药机构编号	字符型	32		Y
	s HospId=InputObj.%Get("fixmedins_code")
    s HospId=$case(HospId,"H21021301867":"2",:"")	
	; psn_cert_type	人员证件类型	字符型	6	Y	Y	02 身份证
	s PsnCertType=InputObj.%Get("psn_cert_type")
	; certno	身份证号	字符型	18		Y	
	s IDNo=InputObj.%Get("certno")
	; ipt_otp_no	门诊号	字符型	31		Y	
	s HospMedicalNum=InputObj.%Get("ipt_otp_no")
	; psn_no	人员编号	字符型	30		Y	医保结算必填
	s PsnNo=InputObj.%Get("psn_no")
	; pay_serial	缴费单号	字符型	32		Y	本次缴费唯一标识，从院端获得
	s PaySerial=InputObj.%Get("pay_serial")
	; pay_total_fee	总金额	数值型	10,2		Y	单位：元
	s PayTotalFee=InputObj.%Get("pay_total_fee")
	; pay_actual_fee	个人自付金额	数值型	10,2		Y	
	s PayActualFee=InputObj.%Get("pay_actual_fee")
	; pay_mi_fee	医疗统筹支付金额	数值型	10,2		Y	
	s PayMiFee=InputObj.%Get("pay_mi_fee")
	; pay_mi_acc_fee	医保账户支付金额	数值型	10,2		Y	
	s PayMiAccFee=InputObj.%Get("pay_mi_acc_fee")
	; order_type	订单类型	字符型	1		Y	1-诊间，2挂号
	s OrderType=InputObj.%Get("order_type")
	; order_id	平台订单号	字符型	32		Y	
	s OrderId=InputObj.%Get("order_id")
	; serial_num	流水号，第三方支付流水号、银行流水号等	字符型	32		Y	有第三方交易必填
	s SerialNum=InputObj.%Get("serial_num")
	; pay_date	交易日期，银行、第三方支付等	字符型	10		Y	格式：YYYY-MM-D D，有第三方交易必填
	s PayDate=InputObj.%Get("pay_date")
	; pay_time	交易时间，银行、第三方支付等	字符型	8		Y	格式：HH24MISS，
	s PayTime=InputObj.%Get("pay_time")
	s:PayTime'="" PayTime=$e(PayTime,1,2)_":"_$e(PayTime,3,4)_":"_$e(PayTime,5,6)
	; pay_channel_id	支付渠道ID	字符型	2		Y	1-微信支付，2-支付宝支付，3银联支付，4-农行支付，99-其他支付，有第三方交易必填
	s PayChannelId=InputObj.%Get("pay_channel_id")
	s PayAdmReason=""
    if (PayChannelId'=""){
        s PayModeCode=$case(PayChannelId,"1":"APPWECHATPAY","2":"APPALIPAY")
    }else{
        s PayModeCode="APPYB",PayAdmReason="63"
    }
	; pay_res_code	交易响应代码	字符型	32		Y	银行、第三方支付等返回的结果码，有第三方交易必填
	s PayResCode=InputObj.%Get("pay_res_code")
	; pay_res_desc	交易响应描述	字符型	256		Y	银行、第三方支付等返回的结果描述
	s PayResDesc=InputObj.%Get("pay_res_desc")
	; dise_codg	病种编码	字符型	30	Y		
	s DiseCodg=InputObj.%Get("dise_codg")
	; pay_satus	缴费类型	字符型	2			-1 退款 0 缴费（冲账必填）
	s PaySatus=InputObj.%Get("fixmedins_code")
	; mdtrtinfo	门诊就诊信息	字符型	4000			结构按照基线版文档文档门诊就诊信息上传A
	s Mdtrtinfo=InputObj.%Get("mdtrtinfo")
	; setl_content	结算信息	字符型	4000			结构按照基线版文档本地门诊结算A
	s SetlContent=InputObj.%Get("setl_content")
	; feedetail	门诊费用明细信息上传	字符型	4000			结构按照【医疗保障信息平台定点医药机构接口规范(基线版)】门诊费用明
	s Feedetail=InputObj.%Get("feedetail")
	;医保参数待添加
    s PayInsuFeeStr=##class(web.DHCINSUPort).PayOrder(InputJson,"","REG")
    s:PayInsuFeeStr[$c(2) PayInsuFeeStr=$replace(PayInsuFeeStr,$c(2),"|")
    s CTLSRowID=$o(^CTLS(0,"HISTradNo",OrderId,""),-1)
    if (CTLSRowID="") q $$OPRegisterErr("99","该订单号对应记录不存在")
    /*s RefundBillNo=""
	if (CTLSRowID=""){
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
	}else{
        q $$OPRegisterErr("99","该订单号对应记录不存在")
	}*/
    set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
    if (ADMDr'="") q $$OPRegisterErr("99","该订单号已经支付取号")
    s ScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
    s PatientNo=$p(^CTLS(CTLSRowID),"^",1)
    s QueueNo=$p(^CTLS(CTLSRowID),"^",3)
    if (PatientNo="")||(ScheduleItemCode="")||(QueueNo="") q $$OPRegisterErr("99","该订单号无效不能使用")
    //s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
    s OPRegisterObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRq).%New()
    s OPRegisterObj.TransactionId=OrderId
    s OPRegisterObj.TerminalID=""
    s OPRegisterObj.ScheduleItemCode=ScheduleItemCode
    s OPRegisterObj.ExtUserID=..#ExtUserCode
    s OPRegisterObj.PatientID=PatientNo
    s OPRegisterObj.PayModeCode=PayModeCode
    s OPRegisterObj.PayFee=PayTotalFee
    s OPRegisterObj.QueueNo=QueueNo
    s OPRegisterObj.PayInsuFeeStr=PayInsuFeeStr
    
    s RESRowid=+$p(^CTLS(CTLSRowID),"^",2)  ;资源表ID
    s AdmLocDr=$P(^RB("RES",RESRowid),"^",1) ;科室ID
    s hopitalID=$P(^CTLOC(AdmLocDr),"^",22) ;医院 id
    ;因为用户是平台写死传入的WX,在此作处理根据预约的科室来判断，如果是密地则传入WXMD
    //if (ExtUserID="WX")&&(hopitalID=3) s InputObj.ExtUserID="WXMD"
    s OPRegisterObj.HospitalId=hopitalID
    s OPRegisterObj.PayAdmReason=PayAdmReason
    s PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    s PayDetailsObj.PayModeCode=PayModeCode
    s PayDetailsObj.TradeChannel="INSUAPP"
    s PayDetailsObj.PayAccountNo=SerialNum
    s PayDetailsObj.PayAmt=PayActualFee
    s PayDetailsObj.OutPayNo=SerialNum
    s PayDetailsObj.PayChannel=""
    s PayDetailsObj.POSPayStr=""
    s PayDetailsObj.PayDate=PayDate
    s PayDetailsObj.PayTime=PayTime
    //do PayDetailsObj.XMLExportToString(.PayDetailsXML,"PayDetails")
    s OPRegisterObj.PayDetails=PayDetailsObj
    s OPRegisterXML=""
    do OPRegisterObj.XMLExportToString(.OPRegisterXML,"Request")
    s ^tempren("OPRegisterXML")=OPRegisterXML
    Set RegisterOutObj=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister(OPRegisterXML)
	if RegisterOutObj.ResultCode'="0"{
        q $$OPRegisterErr(RegisterOutObj.ResultCode,RegisterOutObj.ResultContent)
    }
    q $$OPRegisterErr("0","业务成功")
OPRegisterErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="99"
    if (ErrText="") s ErrText="缴费信息推送失败（挂号）"
    s OutPutObj=##class(%DynamicObject).%New()
    s ResObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d ResObj.%Set("code",ErrCode)
    d ResObj.%Set("remark",ErrText)
    d OutPutObj.%Set("res",ResObj)
    q OutPutObj.%ToJSON()
}

/// 1.1.1.1 【G0001】待结算明细查询接口
ClassMethod PushInfo(AdmId As %String, OrderStr As %String)
{
	s ^tempRen("PushInfo")=$lb(AdmId,OrderStr)
	s OutPutObj=##class(%DynamicObject).%New()
    s ResObj=##class(%DynamicObject).%New()
	; fixmedins_code 定点医药机构编号 字符型 32 
	d ResObj.%Set("fixmedins_code","H21021301867")
	s DataInfo=##class(%DynamicArray).%New()
	s PatDr=$p($g(^PAADM(AdmId)),"^")
    f i=1:1:$l(OrderStr,"^") 
	{
		S OrderIDGet=$P(OrderStr,"^",i)
		//s OrderIDGet=$P(OneOrderStr,"*",2)
		Continue:OrderIDGet=""
		s OrderInfoObj=##Class(%DynamicObject).%New()
		; psn_cert_type 人员证件类型 字符型 6 YY0
		d OrderInfoObj.%Set("psn_cert_type","02")
		; certno 身份证号 字符型 18Y
		d OrderInfoObj.%Set("certno",$p($g(^PAPER(PatDr,"PAT",3)),"^",6))
		; psn_no 人员编号 字符型 30医保编号，医保患者必填
		s EmpNo=$p(##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(AdmId),"^",2)
		d OrderInfoObj.%Set("psn_no",EmpNo)
		; ipt_otp_no 门诊号 字符型 32 Y
		d OrderInfoObj.%Set("psn_cert_type",AdmId)
		; push_type 推送类型 字符型 2 Y1-待缴费提醒，2-取药检查引导信息
		d OrderInfoObj.%Set("psn_cert_type","1")
		; push_id 推送信息的 ID 字符型 32即待缴费信息的缴费单号
		d OrderInfoObj.%Set("psn_cert_type",OrderIDGet)
		; push_content 推送内容 字符型 100
		d OrderInfoObj.%Set("psn_cert_type","您有一笔新的待缴费提醒,请核对并支付")
		d DataInfo.%Push(OrderInfoObj)
	}
	d ResObj.%Set("data_info","DataInfo")
	d OutPutObj.%Set("res",ResObj)
    j ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000063",OutPutObj.%ToJSON(),"6001^3")
}

}
