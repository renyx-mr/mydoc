Class DHCDoc.Interface.DaLianHuaXin.InsuInterface Extends %RegisteredObject
{

ClassMethod GetHospInfoObj(HospDr As %String, FixMedinsCode As %String)
{
	s HsopObj=##class(%DynamicObject).%New()
	; fixmedins_code	定点医药机构编号	字符型	32		Y	规则：医保下发的定点医疗机构编号
	d HsopObj.%Set("fixmedins_code","H21021301867")
	; name	医院名称	字符型	128		Y	
	d HsopObj.%Set("name",$p($g(^CT("HOSP",HospDr)),"^",2))
	; short_name	医院名称简称	字符型	64		Y	
	d HsopObj.%Set("short_name",$p($g(^CT("HOSP",HospDr)),"^",2))
	; website	医院网站	字符型	128			
	d HsopObj.%Set("website","")
	; level	医院等级，	字符型	2	Y	Y	
	d HsopObj.%Set("level","02")
	; desc	医院介绍	字符型	2000	
	d HsopObj.%Set("desc","")		
	; special	医院专长	字符型	256			
	d HsopObj.%Set("special","")
	; regrules	预约规则	字符型	2000			
	d HsopObj.%Set("regrules","")
	; max_reg_days	最大预约天数	字符型	10		Y	
	d HsopObj.%Set("max_reg_days","7")
	; nature	医院性质	字符型	1		Y	
	d HsopObj.%Set("nature","1")
	; start_reg_time	开始预约时间	字符型	5			格式：HH:MI
	d HsopObj.%Set("start_reg_time","")
	; end_reg_time	停止预约时间	字符型	5			格式：HH:MI
	d HsopObj.%Set("end_reg_time","")
	; stop_book_timea	上午停止取号时间	字符型	5			格式：HH:MI
	d HsopObj.%Set("stop_book_timea","")
	; stop_book_timep	下午停止取号时间	字符型	5			格式HH:MI
	d HsopObj.%Set("stop_book_timep","")
	; branch_flag	是否按分院区挂号	字符型	1		Y	0—否，1— 是；为1时 BRANCH_INFO集合不允许为空
	d HsopObj.%Set("branch_flag","0")
	; weibo	医院微博地址	字符型	128			
	d HsopObj.%Set("weibo","")
	q HsopObj
	; branch_id	分院区ID	字符型	32		Y	
	; branch_name	分院区名称	字符型	128		Y	
	; address	分院区地址	字符型	128		Y	
	; tel	分院区联系电话	字符型	32		Y	
	; longitude	所在位置经度	字符型	12			例：113.452472
	; latitude	所在位置纬度	字符型	12			例：23.111814
}

ClassMethod GetCTLocMajorObj(CTLocMajorDr As %String, LocHospDr As %String)
{
	s CTLocMajorObj=##class(%DynamicObject).%New()
	; dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一ID
	d CTLocMajorObj.%Set("dept_id",CTLocMajorDr)
	; dept_name	科室名称	字符型	128		Y	
	d CTLocMajorObj.%Set("dept_name",$p($g(^DHCCTLoc(CTLocMajorDr)),"^",1))
	; branch_flag	是否按分院区挂号	字符型	1		Y	0—否，1— 是；为1时 BRANCH_ID不允许为空
	d CTLocMajorObj.%Set("branch_flag","0")
	; branch_id	分院ID	字符型	32			
	d CTLocMajorObj.%Set("branch_id",LocHospDr)
	; parent_id	上级科室ID	字符型	32		Y	顶级时为-1
	d CTLocMajorObj.%Set("parent_id","-1")
	; desc	介绍	字符型	2000			
	d CTLocMajorObj.%Set("desc","")
	; expertise	科室主治	字符型	128			
	d CTLocMajorObj.%Set("expertise","")
	; level	科室等级	字符型	2		Y	1-一级，2二级，二级科室为可以排班挂号的科室，需要至少存在一个包含二级科室的一级科室。
	d CTLocMajorObj.%Set("level","1")
	; address	科室所在位置	字符型	256		
	d CTLocMajorObj.%Set("address","")	
	; status	状态	字符型	1		Y	1-正常 2注销
	d CTLocMajorObj.%Set("status","1")
	; rule	科室预约规则说明	字符型	128			
	d CTLocMajorObj.%Set("rule","")
	; dept_ybid	科室医保编码	字符型	50			医保中心备案科室编码，二级科室必填
	d CTLocMajorObj.%Set("dept_ybid","")
	; dept_type	科别	字符型	50			二级科室必填
	d CTLocMajorObj.%Set("dept_type","")
	q CTLocMajorObj
	;q CTLocMajorObj.%ToJSON()
}

ClassMethod GetDeptInfoObj(DeptDr As %String, CTLocMajor As %String)
{
	s DeptObj=##class(%DynamicObject).%New()
	; dept_id	科室ID	字符型	32		Y	HIS系统中科室唯一ID
	d DeptObj.%Set("dept_id",DeptDr)
	; dept_name	科室名称	字符型	128		Y	
	d DeptObj.%Set("dept_name",$p($g(^CTLOC(DeptDr)),"^",2))
	; branch_flag	是否按分院区挂号	字符型	1		Y	0—否，1— 是；为1时 BRANCH_ID不允许为空
	d DeptObj.%Set("branch_flag","0")
	; branch_id	分院ID	字符型	32			
	d DeptObj.%Set("branch_id","")
	; parent_id	上级科室ID	字符型	32		Y	顶级时为-1
	d DeptObj.%Set("parent_id",CTLocMajor)
	; desc	介绍	字符型	2000			
	d DeptObj.%Set("desc","")
	; expertise	科室主治	字符型	128			
	d DeptObj.%Set("expertise","")
	; level	科室等级	字符型	2		Y	1-一级，2二级，二级科室为可以排班挂号的科室，需要至少存在一个包含二级科室的一级科室。
	d DeptObj.%Set("level","2")
	; address	科室所在位置	字符型	256	
	set LocAddress=""
	set AddDr=$o(^CTLOC(DeptDr,"ADDR",""),-1)
	if (AddDr'="") set LocAddress=$get(^CTLOC(DeptDr,"ADDR",AddDr))	
	d DeptObj.%Set("address",LocAddress)	
	; status	状态	字符型	1		Y	1-正常 2注销
	d DeptObj.%Set("status","1")
	; rule	科室预约规则说明	字符型	128			
	d DeptObj.%Set("rule","")
	; dept_ybid	科室医保编码	字符型	50			医保中心备案科室编码，二级科室必填
	d DeptObj.%Set("dept_ybid",##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",$p($g(^CTLOC(DeptDr)),"^",1),6))
	; dept_type	科别	字符型	50			二级科室必填
	d DeptObj.%Set("dept_type","")
	q DeptObj
	;q DeptObj.%ToJSON()
}

/// 获取排班信息
ClassMethod GetRBASRecObjByRBASObj(ScheduleObj As User.RBApptSchedule, DHCRBASObj As User.DHCRBApptSchedule, AppRegMethodCode As %String)
{
	s RegTimeList=##class(%Library.DynamicArray).%New()
	s RegTimeObj=##class(%DynamicObject).%New()
	; reg_id	排班ID	字符型	32		Y	如果存在分时，那么挂号的排班ID以分参数代码	参数名称	参数类型	参数长度	代码标识	是否必填	说明	时接口里返回的排班ID为准（院内唯一）
	d RegTimeObj.%Set("reg_id",ScheduleObj.%Id())
	; time_flag	时段	字符型	1	Y	Y	\
	s ASTimeRangeDR=DHCRBASObj.ASTimeRangeDRGetObjectId()
    // 1	上午 2	下午 3	晚上
    s ASTimeRangeDR=$case(ASTimeRangeDR,"1":"1","2":"2","3":"3",:"1")
	d RegTimeObj.%Set("time_flag",ASTimeRangeDR)
	; reg_status	出诊状态	字符型	1		Y	0-停诊 1出诊 2-暂未开放
	d RegTimeObj.%Set("reg_status","1")
	; total	该时段可挂号源总数	字符型	20		Y	不限号源数量默认传-1
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ScheduleObj.%Id())
    s APPSeqNoCount=..GetAppSeqNo(ScheduleObj.%Id(),AppRegMethodCode)
    i APPSeqNoCount=0 s APPSeqNoCount="-1"
	d RegTimeObj.%Set("total",APPSeqNoCount)
	; over_count	该时段剩余号源数	字符型	20		Y	不限号源数量默认传-1
	s AppAllNumber=##class(web.DHCRBAppointment).GetAvailableNum(ScheduleObj.%Id(),RegType,AppRegMethodCode)
	d RegTimeObj.%Set("over_count",AppAllNumber)
	; reg_level	排班类别	字符型	1		Y	1-普通 2专家 3-急诊
	d RegTimeObj.%Set("reg_level","1")
	; sex_limit	班次性别限制	字符型	1			0-全部 1男 2-女
	d RegTimeObj.%Set("sex_limit","")
	; age_limit_max	班次年龄上限	字符型	3			最大值150
	d RegTimeObj.%Set("age_limit_max","")
	; age_limit_min	班次年龄下线	字符型	3			最小值0
	d RegTimeObj.%Set("age_limit_min","")
	; get_doctor_address	就诊地点	字符型	64			
	d RegTimeObj.%Set("get_doctor_address","")
	; get_reg_address	取号地点	字符型	64			
	d RegTimeObj.%Set("get_reg_address","")
	; get_reg_time	取号时间	字符型	20			格式：HH24MI-HH24MI
	d RegTimeObj.%Set("get_reg_time","")
	; istime	是否有分时	字符型	1		Y	0-否 1是
	s TimeRangeFlag=DHCRBASObj.ASTimeRangeFlag
    s TimeRangeFlag=$case(TimeRangeFlag,"Y":"1",:"0")
	d RegTimeObj.%Set("istime",TimeRangeFlag)
	s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ScheduleObj.%Id(),"")
	s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService("",ScheduleObj.%Id(),SerIdStr)
    s RegConDisId=""
    if (RegConDisId=""){
		 s RegConDisIdPara="^"_ScheduleObj.%Id()_"^^"_""
		 s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	}
    
    s FeeDetail=[]  ;##class(%GlobalCharacterStream).%New()
    ;;2
    i SerIdStr'="" {
        f i=1:1:$l(SerIdStr,"^") {
            s TarArcimId=$P(SerIdStr,"^",i)
            //^DHCOLT(0,"ARCIM",{OLT_ARCIM_DR},{OLT_Inst_DR}_"Z",{OLT_StartDate},{OLT_RowId})
            s TarifStartDate=0
            for {
	            s TarifStartDate=$o(^DHCOLT(0,"ARCIM",TarArcimId,"Z",TarifStartDate))
	            q:TarifStartDate=""
	            continue:TarifStartDate>+$H
	            s OLTRowId=0
	            for {
		            s OLTRowId=$o(^DHCOLT(0,"ARCIM",TarArcimId,"Z",TarifStartDate,OLTRowId))
		            q:OLTRowId=""
		            s TarifEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
		            continue:(TarifEndDate'="")&&(TarifEndDate<+$H)
		            s TariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
                        s TarPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(TariffDR,"2")
                        //s ^DHCINTIM({INTIM_Rowid})=
                        s InsuCode="",InsuDesc="",DetailMiPortion=""
                        s INTCTRowid=0 ;$o(^DHCINTCT("0","DHCTID",TariffDR,""),-1)
                        /*for {
                            s INTCTRowid=$o(^DHCINTCT("0","DHCTID",TariffDR,INTCTRowid))
                            q:INTCTRowid=""
                            s InsuDr=$p($g(^DHCINTCT(INTCTRowid)),"^",4)
                            continue:InsuDr=""
                            s InsuCode=$p($g(^DHCINTIM(InsuDr)),"^",27)
                            s InsuDesc=$p($g(^DHCINTIM(InsuDr)),"^",4)
                            s DetailMiPortion=$p($g(^DHCINTIM(InsuDr)),"^",17)
                        }*/
                        s TarItmLinkInsu=##class(web.DHCINSUPort).TarItmLinkInsu(TariffDR,"62","","","")
                        s FeeDetailObj=##class(%DynamicObject).%New()
                        ; detail_name	费用项目医保名称	字符型	30		Y	医保目录项目名称
                        d FeeDetailObj.%Set("detail_name",$p(TarItmLinkInsu,"^",12))
                        ; detail_code	费用医保项目编码	字符型	32		Y	将国家编码和省级编码合并为一个字
                        d FeeDetailObj.%Set("detail_code",$p(TarItmLinkInsu,"^",13))
                        ; detail_amout	项目金额	数值型	10，2		Y	单位：元
                        d FeeDetailObj.%Set("detail_amout",TarPrice)
                        ; detail_hitem_no	院端项目代码	字符型	23		Y	
                        d FeeDetailObj.%Set("detail_hitem_no",$P($G(^DHCTARI(TariffDR)),"^",1))
                        
                        d FeeDetail.%Push(FeeDetailObj)
	            }
            }
        }
    }
    d RegTimeObj.%Set("fee_detail",FeeDetail)
	d RegTimeList.%Push(RegTimeObj)
	q RegTimeList
}

/// 得到预约限额
/// w ##class(web.DHCRBAppointment).GetAppSeqNo("1||14","APP","WIN","2",30600,32400)
ClassMethod GetAppSeqNo(RBASId As %String, APPMethodCode As %String = "", HospitalID As %String = "")
{
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s AvailableNum=0
	i APPMethodCode=""  s APPMethodCode="WIN"
	s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
	s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
	s AppMaxQty=""
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
		Q:ASQSub=""  
		s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
		if (ASMethodID=AppMethodID) {
			s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s AppReserveQty=0
		}
	}
	if (AppMaxQty'="") s AppQty=AppMaxQty
	q AppQty
}

}
