Class DHCDoc.Interface.RegInterface.SelfRegMethods Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ExtUserCode = "APP01";

Parameter IDCardTypeCode = 01;

Parameter CardTypeCode = 01;

/// w ##class(DHCDoc.Interface.RegInterface.SelfRegMethods).Test("<REQ><Hospid>123</Hospid><PAY><rew>1</rew></PAY><PAY><rew>2</rew></PAY></REQ>")
ClassMethod Test(InputXml As %String)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
	set iter = InputObj.PAY.%GetIterator()
	// 添加解析子集
	for OnePayInd=1:1:$l(InputXml,"</PAY>"){
		s OnePayXML=$p(InputXml,"</PAY>",OnePayInd)
		continue:OnePayXML'["<PAY>"
		s OnePayXML="<PAY>"_$p(OnePayXML,"<PAY>",2)_"</PAY>"
		s OnePayObj=##class(DHCDoc.Util.XMLParse).XMLToObj(OnePayXML,"PAY")
		continue:'$IsObject(OnePayObj)
		b 
	}
	q 123
}

/// 2.1.3.1 缴费信息推送接口
ClassMethod PayOrder(InputXml As %String)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    ; ORDER_TYPE	REQ	String(1)	√	订单类型，1-诊间，2-挂号
    s OrderType=InputObj.%Get("ORDER_TYPE")
    if (OrderType="2"){
	    q ..OPRegister(InputXml)
    }else{
    }
}
/// 2.1.2.1 医院信息查询接口(GetHosInfo)
ClassMethod GetHosInfo(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    // HOS_ID	REQ	String(32)	√	医院ID，规则：医保下发的定点医疗机构编号
    s HospId=InputObj.%Get("HOS_ID")
    if (HospId'=""){

    }
    s HsopObj=##class(%DynamicObject).%New()
    s HOSPRowId=0
    for {
        s HOSPRowId=$o(^CT("HOSP",HOSPRowId))
        q:HOSPRowId=""
        s DateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
        continue:(DateFrom<+$h)
        s DateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
        continue:(DateTo>=+$h)
        // HOS_ID	RES	String(32)	√	医院ID，规则：医保下发的定点医疗机构编号
        d HsopObj.%Set("HOS_ID",HOSPRowId)
        // NAME	RES	String(128)	√	医院名称
        d HsopObj.%Set("NAME",$p($g(^CT("HOSP",HOSPRowId)),"^",2))
        // SHORT_NAME	RES	String(64)	√	医院名称简称
        d HsopObj.%Set("HOS_ID",$p($g(^CT("HOSP",HOSPRowId)),"^",1))
        // WEBSITE	RES	String(128)		医院网站
        d HsopObj.%Set("HOS_ID","")
        // LEVEL	RES	String(2)	√	医院等级，详见 “医院等级”
        d HsopObj.%Set("LEVEL","02")
        // DESC	RES	String(2000)		医院介绍
        d HsopObj.%Set("RES","")
        // SPECIAL	RES	String(256)		医院专长
        d HsopObj.%Set("SPECIAL","")
        // MAX_REG_DAYS	RES	Int	√	最大预约天数
        d HsopObj.%Set("MAX_REG_DAYS","7")
        // NATURE	RES	String(1)	√	医院性质，详见 “医院性质”
        d HsopObj.%Set("NATURE","1")
        // WEIBO	RES	String(128)		医院微博地址
        d HsopObj.%Set("WEIBO","")
        // START_REG_TIME	RES	String(5)		开始预约时间，格式：HH:MI
        d HsopObj.%Set("START_REG_TIME","")
        // END_REG_TIME	RES	String(5)		停止预约时间，格式：HH:MI
        d HsopObj.%Set("END_REG_TIME","")
        // STOP_BOOK_TIMEA	RES	String(5)		上午停止取号时间，格式：HH:MI
        d HsopObj.%Set("STOP_BOOK_TIMEA","")
        // STOP_BOOK_TIMEP	RES	String(5)		下午停止取号时间，格式：HH:MI
        d HsopObj.%Set("STOP_BOOK_TIMEP","")
        // BRANCH_FLAG	RES	String(1)	√	是否按分院区挂号，0—否，1—是；为1时，BRANCH_INFO集合不允许为空
        d HsopObj.%Set("BRANCH_FLAG","0")
    }
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(HsopObj,"RES","")
    // HOS_ID	RES	String(32)	√	医院ID，规则：医保下发的定点医疗机构编号
    // NAME	RES	String(128)	√	医院名称
    // SHORT_NAME	RES	String(64)	√	医院名称简称
    // WEBSITE	RES	String(128)		医院网站
    // LEVEL	RES	String(2)	√	医院等级，详见 “医院等级”
    // DESC	RES	String(2000)		医院介绍
    // SPECIAL	RES	String(256)		医院专长
    // MAX_REG_DAYS	RES	Int	√	最大预约天数
    // NATURE	RES	String(1)	√	医院性质，详见 “医院性质”
    // WEIBO	RES	String(128)		医院微博地址
    // START_REG_TIME	RES	String(5)		开始预约时间，格式：HH:MI
    // END_REG_TIME	RES	String(5)		停止预约时间，格式：HH:MI
    // STOP_BOOK_TIMEA	RES	String(5)		上午停止取号时间，格式：HH:MI
    // STOP_BOOK_TIMEP	RES	String(5)		下午停止取号时间，格式：HH:MI
    // BRANCH_FLAG	RES	String(1)	√	是否按分院区挂号，0—否，1—是；为1时，BRANCH_INFO集合不允许为空
    // BRANCH_INFO	RES	List 节点		分院区信息集合
    // BRANCH_ID	BRANCH_INFO	String(32)	√	分院区ID
    // BRANCH_NAME	BRANCH_INFO	String(128)	√	分院区名称
    // ADDRESS	BRANCH_INFO	String(128)	√	分院区地址
    // TEL	BRANCH_INFO	String(32)	√	分院区联系电话
    // LONGITUDE	BRANCH_INFO	String(12)		所在位置经度，例：113.452472 
    // LATITUDE	BRANCH_INFO	String(12)		所在位置纬度，例：23.111814 
    // SUBHOSPITALNO	BRANCH_INFO	String (2)	√	子门诊标识，规则：医保下发的定点医疗机构子门诊标识，总院标识需传0，其他子门诊标识按医保下发上传。
}
/// 2.1.2.2 科室查询接口(GetDeptInfo)
ClassMethod GetDeptInfo(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    // HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    // DEPT_ID	REQ	String(32)	√	科室ID，HIS系统中科室唯一ID，为-1时查询所有科室信息，为0时查询所有一级科室信息，为其他时查本科室以及所有子科室信息
    s DeptId=InputObj.%Get("DEPT_ID")
    s UserID=..GetUserIdByUserCode(..#ExtUserCode) //##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
    s OutPutObj=##class(%GlobalCharacterStream).%New()
    d OutPutObj.Write("<RES>")
    s DeptCount=0
    s DeptList=[]
    if (DeptId="-1"){
        set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,"O",HospId)
		set myDeptNum=$length(myOPDeptStr,"^")
		for i=1:1:myDeptNum
		{
			set myOneDeptStr=$piece(myOPDeptStr,"^",i)
			set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
			continue:DepartmentCode=""
			set DepartmentName=$piece(myOneDeptStr,$C(1),2)
			if (DepartmentName["-") d
			.set DepartmentName=$piece(DepartmentName,"-",1)
			set LocAddress=""
			set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
			if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
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
            for {
                s CTLocMajor=$o(^DHCCTLoc(CTLocMajor))
                q:(CTLocMajor="")!(LocFlag="1")
                s LocHospDr=$p($g(^DHCCTLoc(CTLocMajor)),"^",5)
                continue:(LocHospDr'="")&&(LocHospDr'=HospId)
                s CTMLNRowid=0
                for {
                    Set CTMLNRowid=$O(^DHCCTLoc(CTLocMajor,"MINOR",CTMLNRowid)) 
                    q:(CTMLNRowid="")!(LocFlag="1")
                    Set CTLMNCTLocDR=$p($g(^DHCCTLoc(CTLocMajor,"MINOR",CTMLNRowid)),"^",1)
                    continue:CTLMNCTLocDR'=DepartmentCode
                    s LocFlag="1"
                }
            }
            s DeptCount=DeptCount+1
            s DeptObj=##class(%DynamicObject).%New()
            // DEPT_ID	DEPT_LIST	String(32)	√	科室ID，HIS系统中科室唯一ID
            d DeptObj.%Set("DEPT_ID",DepartmentCode)
            // DEPT_NAME	DEPT_LIST	String(128)	√	科室名称
            d DeptObj.%Set("DEPT_NAME",$p($g(^CTLOC(CTLMNCTLocDR)),"^",2))
            // BRANCH_FLAG	DEPT_LIST	String(1)	√	是否按分院区挂号，0—否，1—是；为1时， BRANCH_ID不允许为空
            d DeptObj.%Set("BRANCH_FLAG","1")
            // BRANCH_ID	DEPT_LIST	String(32)		分院ID
            d DeptObj.%Set("BRANCH_ID",$p($g(^CTLOC(CTLMNCTLocDR)),"^",22))
            // PARENT_ID	DEPT_LIST	String(32)	√	上级科室ID，顶级时为-1
            d DeptObj.%Set("PARENT_ID",CTLocMajor)
            // DESC	DEPT_LIST	String(2000)		介绍
            d DeptObj.%Set("DESC","")
            // EXPERTISE	DEPT_LIST	String(128)		科室主治
            d DeptObj.%Set("EXPERTISE","")
            // LEVEL	DEPT_LIST	String(2)	√	科室等级，1-一级，2-二级，二级科室为可以排班挂号的科室，需要至少存在一个包含二级科室的一级科室。
            d DeptObj.%Set("LEVEL","2")
            // ADDRESS	DEPT_LIST	String（256)		科室所在位置
            d DeptObj.%Set("ADDRESS",LocAddress)
            // STATUS	DEPT_LIST	String(1)	√	状态，1-正常 2-注销
            d DeptObj.%Set("STATUS","1")
            // RULE	DEPT_LIST	String(128)		科室预约规则说明
            d DeptObj.%Set("RULE","")
            // DEPT_YBID	DEPT_LIST	String(50)		科室医保编码，医保中心备案科室编码，二级科室必填
            d DeptObj.%Set("DEPT_YBID",$p($g(^CTLOC(CTLMNCTLocDR)),"^",1))
            //d DeptList.%Push(DeptObj)
            d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(DeptObj,"DEPT_LIST","").Read())
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
            s DeptCount=DeptCount+1
            s DeptObj=##class(%DynamicObject).%New()
            // DEPT_ID	DEPT_LIST	String(32)	√	科室ID，HIS系统中科室唯一ID
            d DeptObj.%Set("DEPT_ID",CTLocMajor)
            // DEPT_NAME	DEPT_LIST	String(128)	√	科室名称
            d DeptObj.%Set("DEPT_NAME",$p($g(^DHCCTLoc(CTLocMajor)),"^",2))
            // BRANCH_FLAG	DEPT_LIST	String(1)	√	是否按分院区挂号，0—否，1—是；为1时， BRANCH_ID不允许为空
            d DeptObj.%Set("BRANCH_FLAG","1")
            // BRANCH_ID	DEPT_LIST	String(32)		分院ID
            d DeptObj.%Set("BRANCH_ID",LocHospDr)
            // PARENT_ID	DEPT_LIST	String(32)	√	上级科室ID，顶级时为-1
            d DeptObj.%Set("PARENT_ID","-1")
            // DESC	DEPT_LIST	String(2000)		介绍
            d DeptObj.%Set("DESC","")
            // EXPERTISE	DEPT_LIST	String(128)		科室主治
            d DeptObj.%Set("EXPERTISE","")
            // LEVEL	DEPT_LIST	String(2)	√	科室等级，1-一级，2-二级，二级科室为可以排班挂号的科室，需要至少存在一个包含二级科室的一级科室。
            d DeptObj.%Set("LEVEL","1")
            // ADDRESS	DEPT_LIST	String（256)		科室所在位置
            d DeptObj.%Set("ADDRESS","")
            // STATUS	DEPT_LIST	String(1)	√	状态，1-正常 2-注销
            d DeptObj.%Set("STATUS","1")
            // RULE	DEPT_LIST	String(128)		科室预约规则说明
            d DeptObj.%Set("RULE","")
            // DEPT_YBID	DEPT_LIST	String(50)		科室医保编码，医保中心备案科室编码，二级科室必填
            d DeptObj.%Set("DEPT_YBID",$p($g(^DHCCTLoc(CTLocMajor)),"^",1))
            //d DeptList.%Push(DeptObj)
            d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(DeptObj,"DEPT_LIST","").Read())
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
            if DepartmentCode'="" Set DepartmentCode=$p($g(^CTLOC(CTLMNCTLocDR)),"^",1)
			Set CTLMNIsActive=$p($g(^DHCCTLoc(DeptId,"MINOR",CTMLNRowid)),"^",2)
			Continue:CTLMNIsActive'=1
			set flag=0
			set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",CTLMNCTLocDR,ResRowId)) Q:ResRowId=""  d
 			.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 			.s flag=1
 			if ((flag=0)&&(GroupResRowIdStr'="")) continue
 			set ExistDepSchedule=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(CTLMNCTLocDR,StartDate,EndDate)
			;查科室过滤没有排班的科室
			continue:(ExistDepSchedule=0)
 			Set DepartmentHospCode=$p($g(^CTLOC(CTLMNCTLocDR)),"^",22)
			continue:(DepartmentHospCode'="")&&(HospId'=DepartmentHospCode)
            set LocAddress=""
			set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
			if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
            s DeptCount=DeptCount+1
            s DeptObj=##class(%DynamicObject).%New()
            // DEPT_ID	DEPT_LIST	String(32)	√	科室ID，HIS系统中科室唯一ID
            d DeptObj.%Set("DEPT_ID",CTLMNCTLocDR)
            // DEPT_NAME	DEPT_LIST	String(128)	√	科室名称
            d DeptObj.%Set("DEPT_NAME",DepartmentName)
            // BRANCH_FLAG	DEPT_LIST	String(1)	√	是否按分院区挂号，0—否，1—是；为1时， BRANCH_ID不允许为空
            d DeptObj.%Set("BRANCH_FLAG","1")
            // BRANCH_ID	DEPT_LIST	String(32)		分院ID
            d DeptObj.%Set("BRANCH_ID",DepartmentHospCode)
            // PARENT_ID	DEPT_LIST	String(32)	√	上级科室ID，顶级时为-1
            d DeptObj.%Set("PARENT_ID",DeptId)
            // DESC	DEPT_LIST	String(2000)		介绍
            d DeptObj.%Set("DESC","")
            // EXPERTISE	DEPT_LIST	String(128)		科室主治
            d DeptObj.%Set("EXPERTISE","")
            // LEVEL	DEPT_LIST	String(2)	√	科室等级，1-一级，2-二级，二级科室为可以排班挂号的科室，需要至少存在一个包含二级科室的一级科室。
            d DeptObj.%Set("LEVEL","2")
            // ADDRESS	DEPT_LIST	String（256)		科室所在位置
            d DeptObj.%Set("ADDRESS",LocAddress)
            // STATUS	DEPT_LIST	String(1)	√	状态，1-正常 2-注销
            d DeptObj.%Set("STATUS","1")
            // RULE	DEPT_LIST	String(128)		科室预约规则说明
            d DeptObj.%Set("RULE","")
            // DEPT_YBID	DEPT_LIST	String(50)		科室医保编码，医保中心备案科室编码，二级科室必填
            d DeptObj.%Set("DEPT_YBID",DepartmentCode)
            //d DeptList.%Push(DeptObj)
            d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(DeptObj,"DEPT_LIST","").Read())
        }
    }
    d OutPutObj.Write("<COUNT>"_DeptCount_"</COUNT></RES>")
    q OutPutObj
    s OutPutObj=##class(%DynamicObject).%New()
    d OutPutObj.%Set("COUNT",DeptCount)
    d OutPutObj.%Set("DEPT_LIST",DeptList)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 2.1.2.3 医生查询接口(GetDoctorInfo)
ClassMethod GetDoctorInfo(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"RES")
    // HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    // DEPT_ID	REQ	String(32)	√	科室ID，HIS系统中科室唯一ID，为-1时查所有科室医生
    s DeptId=InputObj.%Get("DEPT_ID")
    // DOCTOR_ID	REQ	String(32)	√	医生ID，HIS系统中医生唯一ID，为-1时查询该科室下所有医生，否则查指定某个医生信息
    s DoctorId=InputObj.%Get("DOCTOR_ID")
    s UserID=..GetUserIdByUserCode(..#ExtUserCode) //##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")) d
	.s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
    //i DepartmentCode="" d ..SetOutputCode(.OutputObj,"-101202","科室代码不能都为空.") q OutputObj
    s OutPutObj=##class(%GlobalCharacterStream).%New()
    d OutPutObj.Write("<RES>")
	Set rs1=##class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:FindResDoc")
    s:DoctorId="-1" DoctorId=""
    s:DeptId="-1" DeptId=""
	Set Status=0
    s DocCount=0
    s DocList=[]
	If rs1.QueryIsValid() { 
		Set Status=rs1.Execute(DeptId,UserID,DoctorId)
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
            s DocCount=DocCount+1
            s DocObj=##class(%DynamicObject).%New()
            ; DEPT_ID	DOCTOR_LIST	String(32)	√	科室ID，医生所属排班科室
            d DocObj.%Set("DEPT_ID",DeptId)
            ; DOCTOR_ID	DOCTOR_LIST	String(32)	√	医生ID，HIS系统中医生唯一ID
            d DocObj.%Set("DOCTOR_ID",DocID)
            ; NAME	DOCTOR_LIST	String(128)	√	医生名称
            d DocObj.%Set("NAME",DocDesc)
            ; IDCARD	DOCTOR_LIST	String(20)		医生身份证号
            d DocObj.%Set("IDCARD","")
            ; DESC	DOCTOR_LIST	String(500)		介绍
            d DocObj.%Set("DESC","")
            ; SPECIAL	DOCTOR_LIST	String(128)		医生擅长
            d DocObj.%Set("SPECIAL","")
            ; JOB_TITLE	DOCTOR_LIST	String(32)	√	医生职称
            d DocObj.%Set("JOB_TITLE",DocProveTypeDesc)
            ; REG_FEE	DOCTOR_LIST	Number(10)	√	挂号费用，单位：分
            d DocObj.%Set("REG_FEE","")
            ; STATUS	DOCTOR_LIST	String(1)	√	状态，1-正常 2-注销
            d DocObj.%Set("STATUS","1")
            ; SEX	DOCTOR_LIST	String(1)	√	性别，详见 “性别”
            d DocObj.%Set("SEX","")
            ; BIRTHDAY	DOCTOR_LIST	String(20)		出生日期，格式：YYYY-MM-DD
            d DocObj.%Set("BIRTHDAY","")
            ; MOBILE	DOCTOR_LIST	String(20)		手机号码
            d DocObj.%Set("MOBILE","")
            ; TEL	DOCTOR_LIST	String(20)		办公室号码
            d DocObj.%Set("TEL","")
            ; DOCTOR_YBID	DOCTOR_LIST	String(50)		医师医保编码，医保中心备案医师编码
            d DocObj.%Set("DOCTOR_YBID","")
            //d DocList.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(DocObj,"DOCTOR_LIST",""))
            d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(DocObj,"DOCTOR_LIST","").Read())
        }
    }
    d OutPutObj.Write("<COUNT>"_DocCount_"</COUNT></RES>")
    q OutPutObj
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("DOCTOR_LIST",DocList)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
GetDoctorInfoErr()
}

/// 2.1.2.4 排班信息查询接口(GetRegInfo)
ClassMethod GetRegInfo(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    // HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    // DEPT_ID	REQ	String(32)	√	科室ID，HIS系统中科室唯一ID 
    s DeptId=InputObj.%Get("DEPT_ID")
    // DOCTOR_ID	REQ	String(32)	√	医生ID，HIS系统中医生唯一ID，为-1时查询科室ID下所有医生排班
    s DoctorId=InputObj.%Get("DOCTOR_ID")
    // START_DATE	REQ	String(20)	√	排班开始日期，格式：YYYY-MM-DD
    s StartDate=InputObj.%Get("START_DATE")
    // END_DATE	REQ	String(20)	√	排班结束日期，格式：YYYY-MM-DD
    s EndDate=InputObj.%Get("END_DATE")
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndRegDate=##class(websys.Conversions).DateHtmlToLogical(EndRegDate)
    s:StartDate="" StartDate=+$h
    s:EndRegDate="" EndRegDate=+$h
    s UserID=..GetUserIdByUserCode(..#ExtUserCode) //##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    //s GroupRowId=$p($g(^SSU("SSUSR",UserID)),"^",5)
    s OutPutObj=##class(%GlobalCharacterStream).%New()
    d OutPutObj.Write("<RES>")
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
    //s:DoctorId="-1" DoctorId=""
    s ResID=0
    for {
        s ResID=$O(^RB("RES",0,"CTLOC",DeptId,ResID)) q:ResID=""
        s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
        Continue:ResCTPCPDR=""
        Continue:(DoctorId'="-1")&(DoctorId'=ResCTPCPDR)
        ; REG_DOCTOR_LIST	RES	List 节点	√	有排班医生集合
        d OutPutObj.Write("<REG_DOCTOR_LIST>")
        ; DOCTOR_ID	REG_DOCTOR_LIST	String(32)	√	医生ID
        d OutPutObj.Write("<DOCTOR_ID>"_ResCTPCPDR_"</DOCTOR_ID>")
        ; NAME	REG_DOCTOR_LIST	String(128)	√	医生名称
        s DocDesc=$p(^CTPCP(ResCTPCPDR,1),"^",2)
        d OutPutObj.Write("<NAME>"_DocDesc_"</NAME>")
        ; JOB_TITLE	REG_DOCTOR_LIST	String(32)	√	医生职称（必传）
        s DocProveTypeDesc=""
        s DocProveTypeID=$p(^CTPCP(ResCTPCPDR,1),"^",4)
        s:DocProveTypeID'="" DocProveTypeDesc=$p(^CT("CPT",DocProveTypeID),"^",2)
        d OutPutObj.Write("<JOB_TITLE>"_DocProveTypeDesc_"</JOB_TITLE>")
        s Date=StartDate-1
        for {
            s Date=$O(^RBAS(ResID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)
            ; REG_LIST	REG_DOCTOR_LIST	List 节点	√	出诊日期集合
            d OutPutObj.Write("<REG_LIST>")
            s RegAdmDateObj=##class(%DynamicObject).%New()
            ; REG_DATE	REG_LIST	String(20)	√	出诊日期，格式：YYYY-MM-DD
            ; ##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",6))
            //d RegAdmDateObj.%Set("REG_DATE",##class(websys.Conversions).DateLogicalToHtml(Date))
            s RegDate=##class(websys.Conversions).DateLogicalToHtml(Date)
            d OutPutObj.Write("<REG_DATE>"_RegDate_"</REG_DATE>")
            ; REG_WEEKDAY	REG_LIST	String(16)	√	出诊日期对应星期，如：星期五
            s WeekDay=$zd(Date,10)
            s WeekDay="星期"_$case(WeekDay,"0":"七","1":"一","2":"二","3":"三","4":"四","5":"五","6":"六")
            d OutPutObj.Write("<REG_WEEKDAY>"_WeekDay_"</REG_WEEKDAY>")
            //s AdmScheduleList=##class(%GlobalCharacterStream).%New()
            s Time=""
            for {
                s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")
                s Sub=0
                for {
                    s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")  d
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
	                continue:Obj.ASIrregularFlag="A" ;"-1^不规则排班"
                    s OneAdmScheduleObj=$$GetRBASRecObjByRBASObj(ScheduleObj,DHCRBASObj)
                    //d OutPutObj.%Set("DOCTOR_LIST",DocList)
                    //q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
                    //Continue:(SessionCode'="")&(SessionCode'=RBASSessionCode)
                    /*if $IsObject(OneAdmScheduleObj) {
                        //d AdmScheduleList.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(OneAdmScheduleObj,"REG_TIME_LIST",""))
                        d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(OneAdmScheduleObj,"FEE_DETAIL","").Read())
                    }*/
                }
            }
            d OutPutObj.Write("</REG_LIST>")
            //d OutScheduleObj.%Set("FEE_DETAIL",AdmScheduleList) 
        }
        d OutPutObj.Write("</REG_DOCTOR_LIST>")
    }
    d OutPutObj.Write("</RES>")
    q OutPutObj
GetRBASRecObjByRBASObj(ScheduleObj,DHCRBASObj)
    d OutPutObj.Write("<REG_TIME_LIST>")
    s OutScheduleObj=##class(%DynamicObject).%New()
    ; REG_TIME_LIST	REG_LIST	List 节点	√	医生上午、下午、晚上排班信息集合
    ; REG_ID	REG_TIME_LIST	String(32)	√	排班ID，如果存在分时，那么挂号的排班ID以分时接口里返回的排班ID为准（院内唯一）
    d OutScheduleObj.%Set("REG_ID",ScheduleObj.%Id())
    ; TIME_FLAG	REG_TIME_LIST	String(1)	√	时段，详见 “时段”
    s ASTimeRangeDR=DHCRBASObj.ASTimeRangeDRGetObjectId()
    // 1	上午 2	下午 3	晚上
    s ASTimeRangeDR=$case(ASTimeRangeDR,"1":"1","2":"2","3":"4",:"-1")
    d OutScheduleObj.%Set("TIME_FLAG",ASTimeRangeDR)
    ; REG_STATUS	REG_TIME_LIST	String(1)	√	出诊状态，0-停诊 1-出诊 2-暂未开放 
    d OutScheduleObj.%Set("REG_STATUS","1")
    ; TOTAL	REG_TIME_LIST	Int	√	该时段可挂号源总数，不限号源数量默认传-1
    s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ScheduleObj.%Id())
    s APPSeqNoCount=##class(web.DHCRBAppointment).GetAppSeqNo(ScheduleObj.%Id(),APPMethodCode)
    d OutScheduleObj.%Set("REG_STATUS",ScheduleObj.ASLoad)
    d:RegType="APP" OutScheduleObj.%Set("TOTAL",APPSeqNoCount)
    ; OVER_COUNT	REG_TIME_LIST	Int	√	该时段剩余号源数，不限号源数量默认传-1
    s APPMethodCode="WIN"
    s AppAllNumber=##class(web.DHCRBAppointment).GetAvailableNum(ScheduleObj.%Id(),RegType,APPMethodCode)
    d OutScheduleObj.%Set("OVER_COUNT",AppAllNumber)
    ; REG_LEVEL	REG_TIME_LIST	String(1)	√	排班类别：1-普通 2-专家 3-急诊
    ; ^RBC("SESS")
    s RBCSessionType=ScheduleObj.ASSessionTypeDR.SESSDesc
    d OutScheduleObj.%Set("REG_STATUS","1")
    ; SEX_LIMIT	REG_TIME_LIST	String(1)		班次性别限制：0-全部 1-男 2-女
    d OutScheduleObj.%Set("SEX_LIMIT","")
    ; AGE_LIMIT_MAX	REG_TIME_LIST	Int		班次年龄上限，最大值150
    d OutScheduleObj.%Set("AGE_LIMIT_MAX","")
    ; AGE_LIMIT_MIN	REG_TIME_LIST	Int		班次年龄下线，最小值0
    d OutScheduleObj.%Set("AGE_LIMIT_MIN","")
    ; GET_DOCTOR_ADDRESS	REG_TIME_LIST	String(64)		就诊地点
    d OutScheduleObj.%Set("GET_DOCTOR_ADDRESS","")
    ; GET_REG_ADDRESS	REG_TIME_LIST	String(64)		取号地点
    d OutScheduleObj.%Set("GET_REG_ADDRESS","")
    ; GET_REG_TIME	REG_TIME_LIST	String(20)		取号时间，格式：HH24MI-HH24MI
    d OutScheduleObj.%Set("GET_REG_TIME","")
    ; ISTIME	REG_TIME_LIST	String(1)	√	是否有分时，0-否  1-是
    s TimeRangeFlag=DHCRBASObj.ASTimeRangeFlag
    s TimeRangeFlag=$case(TimeRangeFlag,"Y":"1",:"0")
    d OutScheduleObj.%Set("ISTIME",TimeRangeFlag)
    s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ScheduleObj.%Id(),"")
	s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService("",ScheduleObj.%Id(),SerIdStr)
    s RegConDisId=""
    if (RegConDisId=""){
		 s RegConDisIdPara="^"_ASRowId_"^^"_""
		 s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	}
    d OutPutObj.Write($p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(OutScheduleObj,"Schedule","").Read(),"</Schedule>",1),"<Schedule>",2))
    s RegFeeList=[]  ;##class(%GlobalCharacterStream).%New()
    i SerIdStr'="" {
        f i=1:1:$l(SerIdStr,"^") {
            s ArcimId=$P(SerIdStr,"^",i)
            s TariffDR=0
            for {
                s TariffDR=$o(^DHCOLT(0,"ARTTA",ArcimId,TariffDR))
                q:TariffDR=""
                s StartDate=0
                for {
                    s StartDate=$o(^DHCOLT(0,"ARTTA",ArcimId,TariffDR,StartDate))
                    q:StartDate=""
                    s OLTRowId=0
                    for {
                        s OLTRowId=$o(^DHCOLT(0,"ARTTA",ArcimId,TariffDR,StartDate,OLTRowId))
                        q:OLTRowId=""
                        s TariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
                        s TarPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(TariffDR,hospid)
                        //s ^DHCINTIM({INTIM_Rowid})=
                        s InsuCode="",InsuDesc="",DetailMiPortion=""
                        s INTCTRowid=0 ;$o(^DHCINTCT("0","DHCTID",TariffDR,""),-1)
                        for {
                            s INTCTRowid=$o(^DHCINTCT("0","DHCTID",TariffDR,INTCTRowid))
                            q:INTCTRowid=""
                            s InsuDr=$p($g(^DHCINTCT(INTCTRowid)),"^",4)
                            continue:InsuDr=""
                            s InsuCode=$p($g(^DHCINTIM(InsuDr)),"^",27)
                            s InsuDesc=$p($g(^DHCINTIM(InsuDr)),"^",4)
                            s DetailMiPortion=$p($g(^DHCINTIM(InsuDr)),"^",17)
                        }
                        s RegFeeObj=##class(%DynamicObject).%New()
                        ; FEE_DETAIL	REG_TIME_LIST	List 节点	√	挂号费用信息集合
                        ; DETAIL_NAME	FEE_DETAIL	String(30)	√	费用项目医保名称（医保目录项目名称）
                        d RegFeeObj.%Set("DETAIL_NAME",InsuDesc)
                        ; DETAIL_CODE	FEE_DETAIL	String(23)	√	费用项目编码（医保目录项目代码）
                        d RegFeeObj.%Set("DETAIL_CODE",InsuCode)
                        ; DETAIL_CLASS	FEE_DETAIL	String(1)	√	医保项目统计分类，医保统一制定分类编码：A中草药费、B中成药费、C西药费、D检查费、E输氧费、F放射费、G手术费、H化验费、I诊疗费、J麻醉费、K床位费、L护理费、M材料费、N大检费、O特殊治疗费、X输血费、Y诊察费
                        d RegFeeObj.%Set("DETAIL_CLASS","Y")
                        ; DETAIL_MI_PROPORTION	FEE_DETAIL	String(6)	√	医保自费比例（大于等于0小于等于1，包括小数点在内，不能超过6位）
                        d RegFeeObj.%Set("DETAIL_MI_PROPORTION",DetailMiPortion)
                        ; DETAIL_AMOUT	FEE_DETAIL	Number(10，2)	√	项目金额
                        d RegFeeObj.%Set("DETAIL_AMOUT",TarPrice)
                        d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(RegFeeObj,"FEE_DETAIL","").Read())
                    }
                }
            }
        }
    }
    //d OutScheduleObj.%Set("FEE_DETAIL",RegFeeList)
    d OutPutObj.Write("</REG_TIME_LIST>")
    q
    //q OutScheduleObj
}

/// 2.1.2.5 排班分时查询接口(GetTimeRegInfo)
ClassMethod GetTimeRegInfo(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    // HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    // DEPT_ID	REQ	String(32)	√	科室ID，HIS系统中科室唯一ID 
    s DeptId=InputObj.%Get("DEPT_ID")
    // DOCTOR_ID	REQ	String(32)	√	医生ID，HIS系统中医生唯一ID，为-1时查询科室ID下所有医生排班
    s DoctorId=InputObj.%Get("DOCTOR_ID")
    ; REG_DATE	REQ	String(20)	√	出诊日期，格式：YYYY-MM-DD 
    s RegDate=InputObj.%Get("REG_DATE")
    s RegDate=##class(websys.Conversions).DateHtmlToLogical(RegDate)
    ; TIME_FLAG	REQ	String(2)	√	时段，见 “时段”，为-1时查询当天所有分时排班
    s TimeFlag=InputObj.%Get("TIME_FLAG")
    s OutPutObj=##class(%GlobalCharacterStream).%New()
    d OutPutObj.Write("<RES>")
    //s:DoctorId="-1" DoctorId=""
    //s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,DeptId,0))
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
                s TimeRangeDR=$p($g(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
                continue:(TimeFlag'="-1")&&(" 1 2 3 "'[TimeRangeDR)&&(TimeRangeDR'=TimeFlag)
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
                s ASTimeRangeDR=$case(TimeRangeDR,"1":"1","2":"2","3":"4",:"-1")
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
                        s starttime=##class(websys.Conversions).TimeLogicalToHtml(starttime)
                        s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
                        s endtime=##class(websys.Conversions).TimeLogicalToHtml(endtime)
                        s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
                        s AvailableNum=##class(web.DHCRBAppointment).GetAvailableNum(RBASRowId,RegType,"WIN","",starttime,endtime)
                        s RBASTimeObj=##class(%DynamicObject).%New()
                        ; TIME_REG_LIST	RES	List	√	医生排班分时信息集合
                        ; TIME_FLAG	TIME_REG_LIST	String(1)	√	时段，详见 “时段”
                        d RBASTimeObj.%Set("TIME_FLAG",ASTimeRangeDR)
                        ; BEGIN_TIME	TIME_REG_LIST	String(5)	√	分时开始时间，格式：HH24:MI
                        d RBASTimeObj.%Set("BEGIN_TIME",starttime)
                        ; END_TIME	TIME_REG_LIST	String(5)	√	分时结束时间，格式：HH24:MI
                        d RBASTimeObj.%Set("END_TIME",endtime)
                        ; TOTAL	TIME_REG_LIST	Int	√	该时段可挂号源总数，不限号源数量默认传 -1
                        d RBASTimeObj.%Set("TOTAL",TRLoad)
                        ; OVER_COUNT	TIME_REG_LIST	Int	√	该时段剩余号源数，不限号源数量默认传 -1
                        d RBASTimeObj.%Set("OVER_COUNT",AvailableNum)
                        ; REG_ID	TIME_REG_LIST	String(32)	√	排班ID（院内唯一）
                        d RBASTimeObj.%Set("REG_ID",RBASRowId)
                        d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(RBASTimeObj,"TIME_REG_LIST","").Read())
                    }
                    
                }else{
                    s RBASTimeObj=##class(%DynamicObject).%New()
                    ; TIME_REG_LIST	RES	List	√	医生排班分时信息集合
                    ; TIME_FLAG	TIME_REG_LIST	String(1)	√	时段，详见 “时段”
                    d RBASTimeObj.%Set("TIME_FLAG","")
                    ; BEGIN_TIME	TIME_REG_LIST	String(5)	√	分时开始时间，格式：HH24:MI
                    d RBASTimeObj.%Set("BEGIN_TIME",SessStartTime)
                    ; END_TIME	TIME_REG_LIST	String(5)	√	分时结束时间，格式：HH24:MI
                    d RBASTimeObj.%Set("END_TIME",SessEndTime)
                    ; TOTAL	TIME_REG_LIST	Int	√	该时段可挂号源总数，不限号源数量默认传 -1
                    d RBASTimeObj.%Set("TOTAL",RegTotal)
                    s AvailableNum=##class(web.DHCRBAppointment).GetAvailableNum(RBASRowId,RegType,"WIN","","13:00","14:00")
                    ; OVER_COUNT	TIME_REG_LIST	Int	√	该时段剩余号源数，不限号源数量默认传 -1
                    d RBASTimeObj.%Set("OVER_COUNT",AvailableNum)
                    ; REG_ID	TIME_REG_LIST	String(32)	√	排班ID（院内唯一）
                    d RBASTimeObj.%Set("REG_ID",RBASRowId)
                    d OutPutObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(RBASTimeObj,"TIME_REG_LIST","").Read())
                }
            }
        }
    }
    d OutPutObj.Write("</RES>")
    q OutPutObj
}

/// 2.1.2.6 预挂号接口(OrderReg)
ClassMethod OrderReg(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    ; ORDER_ID	REQ	String(32)	√	平台订单号
    s OrderId=InputObj.%Get("ORDER_ID")
    ; CHANNEL_ID	REQ	String(1)	√	挂号渠道ID，详见 “挂号渠道”
    s ChannelId=InputObj.%Get("CHANNEL_ID")
    ; IS_REG	REQ	String(1)	√	是否为预约挂号，1-当天挂号 2-预约挂号（直接挂号）
    s IsReg=InputObj.%Get("IS_REG")
    ; PATI_TYPE	REQ	String(1)	√	患者类型：1-普通 2-医保 3-其他
    s PatiType=InputObj.%Get("PATI_TYPE")
    ; REG_ID	REQ	String(32)	√	排班ID，由上个接口得到（院内唯一）
    s RegId=InputObj.%Get("REG_ID")
    ; REG_LEVEL	REQ	String(1)		排班类别：1-普通 2-专家 3-急诊
    s RegLevel=InputObj.%Get("REG_LEVEL")
    ; HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    ; DEPT_ID	REQ	String(32)		科室ID
    s DeptId=InputObj.%Get("DEPT_ID")
    ; DOCTOR_ID	REQ	String(32)		医生ID
    s DoctorId=InputObj.%Get("DOCTOR_ID")
    ; REG_DATE	REQ	String(20)		出诊日期，格式YYYY-MM-DD
    s RegDate=InputObj.%Get("REG_DATE")
    ; TIME_FLAG	REQ	String(1)		时段，详见 “时段”
    s TimeFlag=InputObj.%Get("TIME_FLAG")
    ; BEGIN_TIME	REQ	String(5)		分时开始时间，格式：HH24:MI
    s BeginTime=InputObj.%Get("BEGIN_TIME")
    ; END_TIME	REQ	String(5)		分时结束时间，格式：HH24:MI
    s EndTime=InputObj.%Get("END_TIME")
    ; REG_TYPE	REQ	String(1)	√	挂号类型，详见 “挂号类型”
    s RegType=InputObj.%Get("REG_TYPE")
    ; REG_FEE	REQ	Number(10，2)	√	挂号费用
    s RegFee=InputObj.%Get("REG_FEE")
    ; IDCARD_NO	REQ	String(20)		患者证件号码，（挂号类型是为本人和为他人挂号时必填，为没有身份证的子女挂号时可以为空）
    s IDCardNo=InputObj.%Get("IDCARD_NO")
    ; CARD_TYPE	REQ	String(1)		患者卡类型，详见 “卡类型”
    ;1	院内诊疗卡2	市民卡3	社保卡/医保卡4	银行卡5	公费医疗证6	农合证7	健康卡8	就诊卡9	系统内部号99	其它卡
    s CardType=InputObj.%Get("CARD_TYPE")
    ; CARD_NO	REQ	String(32)		患者卡号
    s CardNo=InputObj.%Get("CARD_NO")
    ; NAME	REQ	String(32)	√	患者姓名
    s Name=InputObj.%Get("NAME")
    ; SEX	REQ	String(1)	√	患者性别，详见 “性别”
    s Sex=InputObj.%Get("SEX")
    ; BIRTHDAY	REQ	String(20)	√	患者出生日期，格式：YYYY-MM-DD
    s BirthDay=InputObj.%Get("BIRTHDAY")
    ; ADDRESS	REQ	String(128)		患者所在地
    s Address=InputObj.%Get("ADDRESS")
    ; MOBILE	REQ	String(20)		患者手机号码
    s Mobile=InputObj.%Get("MOBILE")
    ; OPER_IDCARD_NO	REQ	String(20)	√	挂号人身份证号码
    s OPerIDCardNo=InputObj.%Get("OPER_IDCARD_NO") 
    ; OPER_NAME	REQ	String(32)	√	挂号人姓名 
    s OPerName=InputObj.%Get("OPER_NAME")
    ; OPER_MOBILE	REQ	String(20)	√	挂号人手机号码 
    s OPerMobile=InputObj.%Get("OPER_MOBILE")
    ; ORDER_TIME	REQ	String(20)	√	下单时间，格式：YYYY-MM-DD HH24:MI:SS
    s OrderTime=InputObj.%Get("ORDER_TIME")
    s UserID=..GetUserIdByUserCode(..#ExtUserCode) //##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
    s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
    s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
    if Name=""{
		q $$OrderRegErr("200911","患者姓名不能为空")
	}
    ; 1	为本人挂号 2	为子女挂号 3	为他人挂号
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
            s PatientIDStr=InsertRet.PatientID
        }else{
            q $$OrderRegErr("200903",InsertRet.ResultContent)
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
	s InputObj.PatientID=+PatientIDStr
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
    s AppointObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.appoint).%New()
    s AppointObj.appointmentId=TransactionId
    s OutputObj.AppointData=AppointObj
    s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
    s OutPutObj=##class(%DynamicObject).%New()
    ; PAY_SERIAL	RES	String(32)	√	医院订单号
    d OutPutObj.%Set("PAY_SERIAL",LockOutputObj.TransactionId)
    ; HOSP_PATIENT_ID	RES	String(32)	√	医院病人ID
    d OutPutObj.%Set("HOSP_PATIENT_ID",PatientNo)
    ; HOSP_SERIAL_NUM	RES	String(32)		医院候诊号
    d OutPutObj.%Set("HOSP_SERIAL_NUM",LockOutputObj.LockQueueNo)
    ; HOSP_GETREG_DATE	RES	String(32)		医院取号时间段或时间点，格式：HH24MI-HH24MI
    d OutPutObj.%Set("HOSP_GETREG_DATE","")
    ; HOSP_SEE_DOCT_ADDR	RES	String(256)		医院就诊地址
    d OutPutObj.%Set("HOSP_SEE_DOCT_ADDR","")
    ; HOSP_MEDICAL_NUM	RES	String(32)	√	医院病历号或门诊号，就诊唯一标识
    d OutPutObj.%Set("HOSP_MEDICAL_NUM","")
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
    //q $$OrderRegErr("200911","系统中未找到对应信息")
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
		continue:(Name'="")&&(PatNameName'=CurName)
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
	set InputObj.PatientCard=patientId
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
    b ;hhr insertenderr
	s ResultCode=InsertRet.ResultCode
	s ResultContent=InsertRet.ResultContent
	if (ResultCode="0"){
		s InsertPatientID=InsertRet.PatientID
		s patientHisId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(InsertPatientID)
		s outpatientId=InsertPatientID
		s SavePatientObj.patientHisId=InsertPatientID
		s SavePatientObj.outpatientId=outpatientId
		s OutputObj.SavePatientData=SavePatientObj
	}else{
		s OutputObj.responseCode=ResultCode	
		s OutputObj.respongseText=ResultContent
	}
OrderRegErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="预挂号失败"
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("CODE",ErrCode)
    d OutPutObj.%Set("REMARK",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 2.1.2.7 挂号取消接口(CancelReg)
ClassMethod CancelReg(InputXml As %String)
{
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    // HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    // ORDER_ID	REQ	String(32)	√	平台订单号
    s OPerId=InputObj.%Get("ORDER_ID")
    // CANCEL_DATE	REQ	String(20)	√	取消时间，格式：YYYY-MM-DD HH24:MI:SS
    s CancelDate=InputObj.%Get("CANCEL_DATE")
    // CANCEL_REMARK	REQ	String(512)		取消原因
    s CancelRemark=InputObj.%Get("CANCEL_REMARK")
    s UserId=..GetUserIdByUserCode(..#ExtUserCode)
    s RegFeeRowId="",ADMDr=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",OPerId,""),-1)
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
    d OutPutObj.%Set("CODE","0")
    d OutPutObj.%Set("REMARK","取消成功")
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
CancelRegErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="取消锁号失败"
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("CODE",ErrCode)
    d OutPutObj.%Set("REMARK",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 2.1.2.8 挂号退款请求接口
ClassMethod Refund(InputXml As %String)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    ; REQ			√	根节点
    ; HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    ; ORDER_ID	REQ	String(32)	√	平台订单号
    s OrderId=InputObj.%Get("ORDER_ID")
    ; HOSP_ORDER_ID	REQ	String(32)		医院订单号
    s HospOrderId=InputObj.%Get("HOSP_ORDER_ID")
    ; REFUND_REMARK	REQ	String(512)		退款原因
    s RefundRemark=InputObj.%Get("REFUND_REMARK")
    s RegFeeRowId="",ADMDr=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",OrderId,""),-1)
	s RefundBillNo=""
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
	s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    // HOSP_REFUND_ID	RES	String(32)	√	医院退款单号
    d OutPutObj.%Set("HOSP_REFUND_ID","")
	// REFUND_FLAG	RES	String(32)	√	退款标志：0-失败 1-成功（平台执行退款）2-院内已退现
    d OutPutObj.%Set("REFUND_FLAG","1")
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
RefundErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="取消挂号请求失败"
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("CODE",ErrCode)
    d OutPutObj.%Set("REMARK",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 2.1.2.9 挂号退款通知接口(RegRefundOrder)
ClassMethod RegRefundOrder(InputXml As %String)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    ; REQ			√	根节点
    ; HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
    ; SUBHOSPITALNO	REQ	String(2)	√	子门诊标识
    ; ID_NO	REQ	String(18)	√	身份证号
    s IDNo=InputObj.%Get("ID_NO")
    ; EMP_NO	REQ	String(8)		医保号(个人编号) ，医保结算必填
    ; ORDER_ID	REQ	String(32)	√	平台订单号
    s OrderId=InputObj.%Get("ORDER_ID")
    s OPRegReturnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRq).%New()
    s OPRegReturnObj.ExtUserID=..#ExtUserCode
    s OPRegReturnObj.HospitalId=HospId
    s OPRegReturnObj.TransactionId=OrderId
    s RegFeeRowId="",ADMDr=""
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",OrderId,""),-1)
	s RefundBillNo=""
	if (CTLSRowID'=""){
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
	}else{
        q $$RegRefundOrderErr("201101","该订单号对应记录不存在")
	}
	if (ADMDr="") q $$RegRefundOrderErr("201101","该订单没有取号不能进行退号")
	s PatIDNo=""
	s PAPMIDR=$p($g(^PAADM(ADMDr)),"^",1)
	if (PAPMIDR'=""){
		s PatIDNo=$p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
	}
	if (PatIDNo'="")&(IDNo'="")&(PatIDNo'=IDNo) q $$RegRefundOrderErr("201101","该患者身份证于挂号身份证不对应，不能进行退号")
	do OPRegReturnObj.XMLExportToString(.InputXML,"Request")
	s RegReturnOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(InputXML)
	if RegReturnOutputObj.ResultCode'="0"{
		q $$RegRefundOrderErr(RegReturnOutputObj.ResultCode,RegReturnOutputObj.ResultContent)
	}
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
RegRefundOrderErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="-1"
    if (ErrText="") s ErrText="挂号退款通知失败"
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("CODE",ErrCode)
    d OutPutObj.%Set("REMARK",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 挂号缴费接口
ClassMethod OPRegister(InputXml As %String)
{
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    ; REQ			√	根节点
    ; HOS_ID	REQ	String(32)	√	医院ID
    s HospId=InputObj.%Get("HOS_ID")
	; SUBHOSPITALNO	REQ	String(2)	√	子门诊标识
	s OPAdmFlag=InputObj.%Get("SUBHOSPITALNO")
	; ID_NO	REQ	String(18)	√	身份证号
	s IDNo=InputObj.%Get("ID_NO")
	; HOSP_MEDICAL_NUM	REQ	String(32)		门诊号
	s HospMedicalNum=InputObj.%Get("HOSP_MEDICAL_NUM")
	; EMP_NO	REQ	String(8)		医保号(个人编号) ，医保结算必填
	s EmpNo=InputObj.%Get("EMP_NO")
	; PAY_SERIAL	REQ	String(32)	√	缴费单号（本次缴费唯一标识，从院端获得）
	s PaySerial=InputObj.%Get("PAY_SERIAL")
	; PAY_TOTAL_FEE	REQ	Number(10，2)	√	总金额
	s PayTotalFee=InputObj.%Get("PAY_TOTAL_FEE")
	; PAY_ACTUAL_FEE	REQ	Number(10，2)	√	个人自付金额
	s PayActualFee=InputObj.%Get("PAY_ACTUAL_FEE")
	; PAY_MI_FEE	REQ	Number(10，2)	√	医疗统筹支付金额
	s PayMiFee=InputObj.%Get("PAY_MI_FEE")
	; PAY_MI_ACC_FEE	REQ	Number(10，2)	√	医保账户支付金额
	s PayMiAccFee=InputObj.%Get("PAY_MI_ACC_FEE")
	; ORDER_TYPE	REQ	String(1)	√	订单类型，1-诊间，2-挂号
	//s HospId=InputObj.%Get("ORDER_TYPE")
	; ORDER_ID	REQ	String(32)	√	平台订单号
	s OrderId=InputObj.%Get("ORDER_ID")
	; SERIAL_NUM	REQ	String(32)		流水号（第三方支付流水号、银行流水号等），有第三方交易必填
	s SerialNum=InputObj.%Get("SERIAL_NUM")
	; PAY_DATE	REQ	String(10)		交易日期（银行、第三方支付等），格式：YYYY-MM-DD，有第三方交易必填
	s PayDate=InputObj.%Get("PAY_DATE")
	; PAY_TIME	REQ	String(8)		交易时间（银行、第三方支付等），格式：HH24MISS，有第三方交易必填
	s PayTime=InputObj.%Get("PAY_TIME")
	; PAY_CHANNEL_ID	REQ	String(2)		支付渠道ID，1-微信支付，2-支付宝支付，3-银联支付，4-农行支付，99-其他支付，有第三方交易必填
	s PayChannelId=InputObj.%Get("PAY_CHANNEL_ID")
    if (PayChannelId'=""){
        s PayModeCode=$case(PayChannelId,"1":"APPALIPAY","2":"APPWECHATPAY","3":"APPYL","4":"APPNH",:"APPQT")
    }else{
        s PayModeCode="APPYB"
    }
	; PAY_RES_CODE	REQ	String(32)		交易响应代码(银行、第三方支付等返回的结果码) ，有第三方交易必填
	s PayResCode=InputObj.%Get("PAY_RES_CODE")
	; PAY_RES_DESC	REQ	String(256)		交易响应描述(银行、第三方支付等返回的结果描述)
	s PayResDesc=InputObj.%Get("PAY_RES_DESC")
	; GLOBALSEQ	REQ	String(30)		报审单号（医保明细结算模式必填）
	s GLOBALSEQ=InputObj.%Get("GLOBALSEQ")
	; OPERNO	REQ	String(10)		操作员编码（医保明细结算模式必填）
	s OPerNo=InputObj.%Get("OPERNO")
	; PAY	REQ	子集	√	医保支付集合（医保当前结算模式专用，明细结算模式时为空）
	// 添加解析子集
	for OnePayInd=1:1:$l(InputXml,"</PAY>"){
		s OnePayXML=$p(InputXml,"</PAY>",OnePayInd)
		continue:OnePayXML'["<PAY>"
		s OnePayXML="<PAY>"_$p(OnePayXML,"<PAY>",2)_"</PAY>"
		s OnePayObj=##class(DHCDoc.Util.XMLParse).XMLToObj(OnePayXML,"PAY")
		continue:'$IsObject(OnePayObj)
		; HOSPITALNO	PAY	VARCHAR2(6)	√	医院代码
        ; SUBHOSPITALNO	PAY	VARCHAR2(1)	√	子门诊标识:取值a,b,c....表示子门诊，总院以空格补位
        ; EMPNO	PAY	VARCHAR2(10)	√	个人编号
        ; ICNO	PAY	VARCHAR2(10)	√	IC卡号
        ; ICSEQ	PAY	NUMBER(4,0)	√	治疗序号
        ; ORIGINAL_ICSEQ	PAY	NUMBER(4,0)	√	冲账序号
        ; PAYDATE	PAY	DATE	√	结算时间:精确到秒，数据返回后格式为yyyymmddhhmiss后面以空格补位
        ; INHOSNO	PAY	VARCHAR2(10)	√	住院病志号，门诊为门诊号
        ; EXAM_FEE	PAY	NUMBER(9,2)	√	诊察费
        ; CNMED_FEE	PAY	NUMBER(9,2)	√	草药费
        ; OFFI_FEE	PAY	NUMBER(9,2)	√	成药费
        ; WEST_FEE	PAY	NUMBER(9,2)	√	西药费
        ; TEST_FEE	PAY	NUMBER(9,2)	√	检查费
        ; TREAT_FEE	PAY	NUMBER(9,2)	√	治疗费
        ; BLOOD_FEE	PAY	NUMBER(9,2)	√	血费
        ; BLOOD_INDFEE	PAY	NUMBER(9,2)	√	血费自费
        ; LTEST_FEE	PAY	NUMBER(9,2)	√	大检费
        ; LTEST_INDFEE	PAY	NUMBER(9,2)	√	大检自费
        ; STREAT_FEE	PAY	NUMBER(9,2)	√	特殊治疗费
        ; STREAT_INDFEE	PAY	NUMBER(9,2)	√	特殊治疗自费
        ; INSURE_INDFEE	PAY	NUMBER(9,2)	√	保险内自费费用
        ; UNINSURE_INDFEE	PAY	NUMBER(9,2)	√	非医疗保险费用
        ; EMPACC	PAY	NUMBER(9,2)	√	结算后个人账户余额
        ; EMPSOCIAL	PAY	NUMBER(9,2)	√	结算后统筹支付累计
        ; EMPCHRONIC	PAY	NUMBER(9,2)	√	结算后门诊慢病统筹支付累计：门诊统筹结算时,表示结算后门诊统筹累计;门诊慢病结算时,表示结算后慢病统筹累计
        ; EMPHOSINSUBSUM	PAY	NUMBER(9,2)	√	结算后个人负担较重自付累计
        ; EMPSALVA	PAY	NUMBER(9,2)	√	结算后医疗救助累计
        ; EMPREMARK	PAY	NUMBER(9,2)	√	结算后门诊特药支付累计
        ; EMPBASEACC_BEFORE	PAY	NUMBER(9,2)	√	结算前基本账户余额
        ; EMPSUBACC_BEFORE	PAY	NUMBER(9,2)	√	结算前补充账户余额
        ; EMPSOCIAL_BEFORE	PAY	NUMBER(9,2)	√	结算前统筹支付累计
        ; EMPCHRONIC_BEFORE	PAY	NUMBER(9,2)	√	结算前门诊慢病统筹支付累计：门诊统筹结算时,表示结算前门诊统筹累计;门诊慢病结算时,表示结算前慢病统筹累计
        ; EMPHOSINSUM_BEFORE	PAY	NUMBER(9,2)	√	结算前个人负担较重自付累计
        ; EMPSALVA_BEFORE	PAY	NUMBER(9,2)	√	结算前医疗救助累计
        ; EMPREMARK_BEFORE	PAY	NUMBER(9,2)	√	结算前门诊特药支付累计
        ; EMPHOSINSUBBASE	PAY	NUMBER(9,2)	√	结算前个人负担较重补助支付累计
        ; EMPBASEACC_PAY	PAY	NUMBER(9,2)	√	本次基本个人账户支付
        ; EMPSUBACC_PAY	PAY	NUMBER(9,2)	√	本次补助个人账户支付
        ; EMPSOCIAL_PAY	PAY	NUMBER(9,2)	√	本次基本统筹支付
        ; EMPSOCIAL_CASH	PAY	NUMBER(9,2)	√	本次基本统筹自付
        ; EMPPATCH_PAY	PAY	NUMBER(9,2)	√	本次补充统筹支付
        ; EMPPATCH_CASH	PAY	NUMBER(9,2)	√	本次补充统筹自付
        ; EMPCHRONIC_PAY	PAY	NUMBER(9,2)	√	本次门诊慢病统筹支付
        ; EMPCHRONIC_CASH	PAY	NUMBER(9,2)	√	本次门诊慢病统筹自付
        ; EMPHOSINSUBPAY	PAY	NUMBER(9,2)	√	本次个人负担较重补助支付或居民大病保险支付
        ; GWY_SILLSTAND_PAY	PAY	NUMBER(9,2)	√	本次公务员起付标准补助支付
        ; GWY_SUBBASE_PAY	PAY	NUMBER(9,2)	√	本次公务员基本补助保险支付
        ; GWY_UNSUBBASE_PAY	PAY	NUMBER(9,2)	√	本次公务员非基本补助保险支付
        ; GWY_STREATPAY	PAY	NUMBER(9,2)	√	本次公务员特殊治疗补助支付
        ; SUBCOMMERCE_PAY	PAY	NUMBER(9,2)	√	本次商业保险补助支付
        ; ININSURE_INDCASH	PAY	NUMBER(9,2)	√	本次保险内自付
        ; OUTINSURE_INDCASH	PAY	NUMBER(9,2)	√	本次保险外自付
        ; EMPSALVAPAY	PAY	NUMBER(9,2)	√	本次医疗救助支付
        ; EMPREMARKPAY	PAY	NUMBER(9,2)	√	商业补充医疗保险支付
        ; EMPHOSINSUM	PAY	NUMBER(9,2)	√	本次个人负担较重补助起付部分
        ; SILL_STAND	PAY	NUMBER(9,2)	√	起付标准
        ; TRANSSHEETNO	PAY	VARCHAR2(6)		转诊单号
        ; KIND	PAY	VARCHAR2(1)	√	就诊分类
        ; EMPKIND2	PAY	VARCHAR2(1)	√	参保类别2
        ; EMPKIND3	PAY	VARCHAR2(1)	√	参保类别3
        ; EMPSOCIAL_AREA	PAY	VARCHAR2(1)	√	统筹区域
        ; EMPCLASSNO	PAY	VARCHAR2(1)	√	职工就医类别
        ; DIAGNOSENO	PAY	VARCHAR2(16)	√	诊断编码
        ; SICKNO	PAY	VARCHAR2(10)		科室编码
        ; DOCTORNO	PAY	VARCHAR2(8)		医师编码
        ; INDIDOCT	PAY	VARCHAR2(8)		主治医师编码
        ; MASTEDOCT	PAY	VARCHAR2(8)		主任医师编码
        ; OPID	PAY	VARCHAR2(8)		操作员代码
        ; DIAGNOSENAME	PAY	VARCHAR2(42)	√	诊断名称
        ; TREATFLAG	PAY	VARCHAR2(1)		治愈情况标识
        ; OUTHOSDATE	PAY	DATE	√	出院日期，门诊默认为结算日期
        ; TRANSDATE	PAY	DATE	√	传输时间
        ; ERRORCODE	PAY	VARCHAR2(10)	√	错误代码
	}
	; PAY_MX	REQ	子集	√	医保支付集合（医保明细结算模式专用，当前结算模式时为空）
	// 添加解析子集
	for OnePayMXInd=1:1:$l(InputXml,"</PAY_MX>"){
		s OnePayMXXML=$p(InputXml,"</PAY_MX>",OnePayMXInd)
		continue:OnePayMXXML'["<PAY_MX>"
		s OnePayMXXML="<PAY_MX>"_$p(OnePayMXXML,"<PAY_MX>",2)_"</PAY>"
		s OnePayMXObj=##class(DHCDoc.Util.XMLParse).XMLToObj(OnePayMXXML,"PAY_MX")
		continue:'$IsObject(OnePayMXObj)
		; TRANSDATE	PAY_MX	VARCHAR2(14)	√	中心结算时间
        ; BALTYPE	PAY_MX	VARCHAR2(1)		人员类别
        ; TYPE1	PAY_MX	VARCHAR2(1)		参保类别1
        ; TYPE2	PAY_MX	VARCHAR2(1)		参保类别2
        ; TYPE3	PAY_MX	VARCHAR2(1)		参保类别3
        ; INSURECASH	PAY_MX	Number(10,2)		自理费用
        ; SOCIALCASH	PAY_MX	Number(10,2)		统筹基金支付范围内费用
        ; OUTCASH	PAY_MX	Number(10,2)		自费费用
        ; OUTLIMITPRICE	PAY_MX	Number(10,2)		超限价自费金额
        ; SPECIALCASH	PAY_MX	Number(10,2)		特殊治疗费
        ; SPECIALINSURECASH	PAY_MX	Number(10,2)		特殊治疗自费
        ; BASEACC	PAY_MX	Number(10,2)	√	结算后基本账户余额
        ; SUBACC	PAY_MX	Number(10,2)	√	结算后补助账户余额
        ; SOCIAL	PAY_MX	Number(10,2)	√	结算后统筹累计
        ; CHRONICSOCIAL	PAY_MX	Number(10,2)	√	结算后慢病统筹累计
        ; BURDENCASHTOTAL	PAY_MX	Number(10,2)	√	结算后负担较重自付累计
        ; BURDENTOTAL	PAY_MX	Number(10,2)	√	结算后负担较重支付累计
        ; SALTOTAL	PAY_MX	Number(10,2)	√	结算后救助累计
        ; SERISOCIAL	PAY_MX	Number(10,2)	√	结算后大病统筹累计
        ; SJBIZMOREINSUREPAYTOTAL	PAY_MX	Number(10,2)	√	结算后商业补充医疗保内支付累计
        ; SJBIZMOREOUTPAYTOTAL	PAY_MX	Number(10,2)	√	结算后商业补充医疗保外支付累计
        ; BASEACCPAY	PAY_MX	Number(10,2)	√	基本账户支付
        ; SUBACCPAY	PAY_MX	Number(10,2)	√	补助账户支付
        ; SOCIALPAY	PAY_MX	Number(10,2)	√	基本统筹支付
        ; SOCIALOWNCASH	PAY_MX	Number(10,2)	√	基本统筹自付
        ; SUBSOCIALPAY	PAY_MX	Number(10,2)	√	补充统筹支付
        ; SUBSOCIALCASH	PAY_MX	Number(10,2)	√	补充统筹自付
        ; CHRONICSOCIALPAY	PAY_MX	Number(10,2)	√	慢病统筹支付
        ; CHRONIXSOCIALCASH	PAY_MX	Number(10,2)	√	慢病统筹自付
        ; BURDENPAY	PAY_MX	Number(10,2)	√	住院补助支付
        ; DENISERIPAY	PAY_MX	Number(10,2)	√	居民大病保险支付
        ; SERVTHRESHOLDPAY	PAY_MX	Number(10,2)	√	公务员起付标准补助支付
        ; SERVBASEPAY	PAY_MX	Number(10,2)	√	公务员基本补助支付
        ; SERVSUBPAY	PAY_MX	Number(10,2)	√	公务员非基本补助支付
        ; SERVSPECIALPAY	PAY_MX	Number(10,2)	√	公务员特殊治疗补助支付
        ; SALPAY	PAY_MX	Number(10,2)	√	医疗救助支付
        ; CADREGOVPAY	PAY_MX	Number(10,2)	√	离休单位支付
        ; CADRESOCIALPAY	PAY_MX	Number(10,2)	√	离休统筹支付
        ; CASHPAY	PAY_MX	Number(10,2)	√	个人现金支付
        ; THRESHOLD	PAY_MX	Number(10,2)	√	起付标准
        ; SJBIZMOREINSUREPAY	PAY_MX	Number(10,2)	√	本次商业补充医疗保内支付
        ; SJBIZMOREOUTPAY	PAY_MX	Number(10,2)	√	本次商业补充医疗保外支付
        ; CPFLAG	PAY_MX	VARCHAR2(1)	√	商业保险公司标志（‘1’人保健康，‘2’平安保险）
	}
    ;医保参数待添加
    s PayInsuFeeStr=""
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
    s PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    s PayDetailsObj.PayModeCode=PayModeCode
    s PayDetailsObj.TradeChannel=""
    s PayDetailsObj.PayAccountNo=SerialNum
    s PayDetailsObj.PayAmt=PayActualFee
    s PayDetailsObj.OutPayNo=SerialNum
    s PayDetailsObj.PayChannel=paymentMethodId
    s PayDetailsObj.POSPayStr=""
    s PayDetailsObj.PayDate=PayDate
    s PayDetailsObj.PayTime=PayTime
    do PayDetailsObj.XMLExportToString(.PayDetailsXML,"PayDetails")
    s OPRegisterObj.PayDetails=PayDetailsObj
    do OPRegisterObj.XMLExportToString(.OPRegisterXML,"Request")
    Set LockOutputObj=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister(OPRegisterXML)
	if LockOutputObj.ResultCode'="0"{
        q $$OPRegisterErr("",LockOutputObj.ResultContent)
    }
    q $$OPRegisterErr("0","业务成功")
OPRegisterErr(ErrCode,ErrText)
    if (ErrCode="") s ErrCode="99"
    if (ErrText="") s ErrText="缴费信息推送失败（挂号）"
    s OutPutObj=##class(%DynamicObject).%New()
    //d OutPutObj.%Set("COUNT",DepCount)
    d OutPutObj.%Set("CODE",ErrCode)
    d OutPutObj.%Set("REMARK",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"RES","")
}

/// 2.2.1.1 处方消息推送接口(PushInfo)
ClassMethod PushInfo(AdmId As %String, OrderStr As %String)
{
	;s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"REQ")
    s InputObj=##class(%GlobalCharacterStream).%New()
    d InputObj.Write("<RES>")
    ; REQ			√	根节点
    ; HOS_ID	REQ	String(32)	√	医院ID
    ;d InputObj.%Set("HOS_ID",2)
    d InputObj.Write("<HOS_ID>2</HOS_ID>")
    ; SUBHOSPITALNO	REQ	String(2)	√	子门诊O标识
    ;d InputObj.%Set("SUBHOSPITALNO","O")
    d InputObj.Write("<SUBHOSPITALNO>O</SUBHOSPITALNO>")
    s PatDr=$p($g(^PAADM(AdmId)),"^")
    f i=1:1:$l(OrderStr,"^") 
	{
		S OneOrderStr=$P(OrderStr,"^",i)
		s OrderIDGet=$P(OneOrderStr,"*",2)
		Continue:OrderIDGet=""
        s OrderInfoObj=##Class(%DynamicObject).%New()
        ; DATA_INFO	REQ	LIST节点	√	推送信息
        ; ID_NO	DATA_INFO	String(18)	√	身份证号
        d OrderInfoObj.%Set("PUSH_TYPE",$p($g(^PAPER(PatDr,"PAT",3)),"^",6))
        ; EMP_NO	DATA_INFO	String(8)	√	医保号(个人编号)
        d OrderInfoObj.%Set("EMP_NO",$p($g(^PAPER(PatDr,"PAT",3)),"^",12))
        ; HOSP_MEDICAL_NUM	DATA_INFO	String(32)	√	门诊号
        d OrderInfoObj.%Set("HOSP_MEDICAL_NUM",AdmId)
        ; PUSH_TYPE	DATA_INFO	Int	√	推送类型：1-待缴费提醒，2-取药检查引导信息
        d OrderInfoObj.%Set("PUSH_TYPE",2)
        ; PUSH_ID	DATA_INFO	String(32)		推送信息的ID（即待缴费信息的缴费单号）
        d OrderInfoObj.%Set("PUSH_ID",OrderIDGet)
        ; PUSH_CONTENT	DATA_INFO	String(100)	√	推送内容
        d OrderInfoObj.%Set("PUSH_CONTENT","")
        d InputObj.Write(##class(DHCDoc.Util.XMLParse).ObjToXML(OrderInfoObj,"DATA_INFO","").Read())
    }
    //添加平台接口的调用
}

/// 2.2.2.1 停诊通知接口(StopReg)（需要群发短信配合）
ClassMethod StopReg(AsRowId As %String)
{
    s RBASInputObj=##Class(%DynamicObject).%New()
    ; REQ			√	根节点
    ; HOS_ID	REQ	String(32)	√	医院ID
    d RBASInputObj.%Set("HOS_ID","2")
    ; DEPT_ID	REQ	String(32)	√	科室ID 
    s DeptId=$p($g(^RB("RES",+AsRowId)),"^",1)
    d RBASInputObj.%Set("DEPT_ID",DeptId)
    ; DOCTOR_ID	REQ	String(32)	√	医生ID 
    s DoctId=$p($g(^RB("RES",+AsRowId)),"^",2)
    d RBASInputObj.%Set("DOCTOR_ID",DoctId)
    ; REG_DATE	REQ	DateTime	√	停诊日期，格式：YYYY-MM-DD 
    s LastUpdateDate=$p($g(^RBAS(+AsRowId,$p(AsRowId,"||",2))),"^",23)
    s LastUpdateDate=##class(websys.Conversions).DateLogicalToHtml(LastUpdateDate)
    d RBASInputObj.%Set("REG_DATE",LastUpdateDate)
    ; TIME_FLAG	REQ	Int	√	时段，详见 “时段”
    s TimeRangeDR=$p($g(^RBAS(+AsRowId,$p(AsRowId,"||",2),"DHC")),"^",17)
    s ASTimeRangeDR=$case(TimeRangeDR,"1":"1","2":"2","3":"4",:"-1")
    d RBASInputObj.%Set("PUSH_CONTENT",ASTimeRangeDR)
    ; BEGIN_TIME	REQ	String(5)		停诊开始时间，格式：HH24:MI
    d RBASInputObj.%Set("PUSH_CONTENT","")
    ; END_TIME	REQ	String(5)		停诊结束时间，格式：HH24:MI
    d RBASInputObj.%Set("PUSH_CONTENT","")
    ; STOP_REMARK	REQ	String(512)		停诊原因
    d RBASInputObj.%Set("PUSH_CONTENT","")
    s InputXML=##class(DHCDoc.Util.XMLParse).ObjToXML(RBASInputObj,"REQ","")
    //添加平台接口的调用
}

ClassMethod GetUserIdByUserCode(UserCode As %String)
{
    q $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
}

}
