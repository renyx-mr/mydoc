Class DHCDoc.Interface.RongWeiZhongBang.QueryCommon Extends (%RegisteredObject, %XML.Adaptor)
{
/// call web_DHCENS_BLL_QCInterface.Dataexchangeorg_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryAdmRegInfo_TM_OUT_REG("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryAdmRegInfo","2019-01-02","2020-01-01")
Query QueryDeptInfo() As %Query(ROWSPEC = "dept_code,dept_name,pinyin_mnem") [ SqlProc, SqlViewName = dept_info ]
{
}
ClassMethod QueryDeptInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDeptInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.RongWeiZhongBang.QueryCommon","QueryDeptInfoExecute")
ClassMethod QueryDeptInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s DeptId=0
    for {
        s DeptId=$o(^RB("RES",0,"CTLOC",DeptId))
        q:DeptId=""
        s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
        s DeptName=$p($g(^CTLOC(DeptId)),"^",2)
        s DeptDesc=$p($g(^CTLOC(DeptId)),"^",43)
        d DeptInfoOutputRow
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DeptInfoOutputRow      
	set Data=$lb(DeptCode,DeptName,DeptDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryDeptInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDeptInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
}

/// call web_DHCENS_BLL_QCInterface.Dataexchangeorg_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryAdmRegInfo_TM_OUT_REG("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryAdmRegInfo","2019-01-02","2020-01-01")
Query QueryDocInfo() As %Query(ROWSPEC = "doctor_code,doctor_name,doctor_postitle,dept_code") [ SqlProc, SqlViewName = doctor_info ]
{
}
ClassMethod QueryDocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.RongWeiZhongBang.QueryCommon","QueryDeptInfoExecute")
ClassMethod QueryDocInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s DocId=0
    for {
        s DocId=$o(^RB("RES",0,"CTPCP",DocId))
        q:DocId=""
        s UserId=$o(^SSU("SSUSR",0,"CTPCP",DocId,0))
        continue:UserId=""
        s DeptId=0
        for {
            s DeptId=$o(^RB("RES",0,"CTPCP",DocId,DeptId))
            q:DeptId=""
            s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
            s UserName=$p($g(^SSU("SSUSR",UserId)),"^",2)
            s DocPostitle=""
            if (DocId'=""){
                s CTPCPCarPrvTpDR = $p($g(^CTPCP(DocId,1)),"^",4)
                s DocPostitle = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
            }
            if (DocPostitle'["普"){
                s DocPostitle="1"
            }else{
                s DocPostitle="0"
            }
            s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
            d DocInfoOutputRow
        }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DocInfoOutputRow      
	set Data=$lb(UserCode,UserName,DocPostitle,DeptCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryDocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
}

/// call web_DHCENS_BLL_QCInterface.Dataexchangeorg_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryAdmRegInfo_TM_OUT_REG("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryAdmRegInfo","2019-01-02","2020-01-01")
Query QueryPatQueueInfo() As %Query(ROWSPEC = "reg_id,treat_card_no,healthcare_card_no,pat_code,pat_name,pat_sex,doctor_code,doctor_name,dept_code,dept_name,prof_code,prof_name,reg_type,reg_grade,reg_fee,reg_seq_no,reg_time,status,call_time,reception_time,wait_nobiz_date,noon_flag,withdraw_flag,is_jz,times") [ SqlProc, SqlViewName = reg_info ]
{
}
ClassMethod QueryPatQueueInfoClose(ByRef qHandle As %Binary,SatarDate As %String ="", EndDate As %String = "") As %Status [ PlaceAfter = QueryPatQueueInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.RongWeiZhongBang.QueryCommon","QueryPatQueueInfo")
ClassMethod QueryPatQueueInfoExecute(ByRef qHandle As %Binary,SatarDate As %String ="", EndDate As %String ="") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s:SatarDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(SatarDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:SatarDate="" SatarDate=+$h
    s:EndDate="" EndDate=+$H
    for QueueDate=StartDate:1:EndDate{
        s QueDr=0
        for {
            s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr))
            q:QueDr=""
            s DHCQueObj=##class(User.DHCQueue).%OpenId(QueDr)
            if $IsObject(DHCQueObj){
                ; reg_id varchar 50 √ 挂号信息唯一标记
                s RegId=QueDr
                s PAAdmId=DHCQueObj.QuePaadmDrGetObjectId()
                ; treat_card_no varchar 50 × 患者就诊卡号
                s RegCardNo=DHCQueObj.QuePersonId
                ; healthcare_card_no varchar 50 × 患者医保卡号
                s InsuCardNo=""
                ; pat_code varchar 50 × 患者 HIS 编号
                s PatCode=DHCQueObj.QuePersonId
                ; pat_name varchar 50 × 患者姓名
                s PatName=DHCQueObj.QueName
                ; pat_sex varchar 50 × 患者性别
                s PatDr=$P(^PAADM(PAAdmId),"^")
                s PatSex=""
                s PatSexDR=$p($g(^PAPER(PatDr,"ALL")),"^",7)
			    i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
                ; doctor_code varchar 50 × 预约医生编号
                s QueDocDr=DHCQueObj.QueDocDrGetObjectId()
                s UserId=$o(^SSU("SSUSR",0,"CTPCP",QueDocDr,0))
                //s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
                s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
                ; doctor_name varchar 50 × 预约医生姓名
                s UserName=$P($g(^SSU("SSUSR",UserId)),"^",2)
                ; dept_code varchar 50 × 预约科室编号
                s DeptId=DHCQueObj.QueDepDrGetObjectId()
                s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
                ; dept_name varchar 50 × 预约科室名称
                s DeptName=$p($g(^CTLOC(DeptId)),"^",1)
                ; prof_code varchar 50 × 预约专业代码
                s ProfCode=""
                ; prof_name varchar 50 × 预约专业名称
                s ProfName=""
                ; reg_type varchar 50 × 预约挂号类型（专家、普通等）
                s RegType=DHCQueObj.QueMarkDr.CTPCPDesc
                ; reg_grade varchar 50 × 预约挂号级别（主任医师、副主任医师等）
                s CTPCPCarPrvTpDesc=""
                if (QueDocDr'=""){
                    s CTPCPCarPrvTpDR = $p($g(^CTPCP(QueDocDr,1)),"^",4)
                    s CTPCPCarPrvTpDesc = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
                }
                ; reg_fee decimal 10,2 × 挂号费
                s RegFee=""
                ; reg_seq_no int 11 × 预约挂号序号
                s ApSeqNo=DHCQueObj.QueNo
                ; reg_time datetime 50 × 挂号时间
                s RegTime=##class(websys.Conversions).DateLogicalToHtml(DHCQueObj.QueDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(DHCQueObj.QueTime)
                ; status varchar 1 × 诊疗状态（未报道、已报道、已呼叫、已就诊）
                s QueState=DHCQueObj.QueStateDr.PersName ;GetObjectId()
                s QueStatus=$case(QueState,"到达":"已就诊","等候":"已报道","复诊":"已报道",:"未报道")
                ; call_time datetime × 呼叫时间
                s CallTime=##class(websys.Conversions).DateLogicalToHtml(DHCQueObj.QueWaitCallDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(DHCQueObj.QueWaitCallTime)
                ; reception_time datetime × 报到时间
                s RecpetionTime=""
                s TimesCount=0
                s QSChildSub=0
                for {
                    s QSChildSub=$o(^DHCQueueStatus(QueDr,QSChildSub))
                    q:QSChildSub=""
                    s QSStatus=$p($g(^DHCQueueStatus(QueDr,QSChildSub)),"^",4)
                    s QSStatusDesc=$list(^User.DHCPerStateD(QSStatus),4)
                    if (QSStatusDesc="等候"){
                        s RecpetionTime=##class(websys.Conversions).DateLogicalToHtml($p($g(^DHCQueueStatus(QueDr,QSChildSub)),"^",1))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^DHCQueueStatus(QueDr,QSChildSub)),"^",2))
                    }
                    if (QSStatusDesc="到达"){
                        s TimesCount=TimesCount+1
                    }
                }
                ; wait_no int 11 × 等候序号
                s SeqNo=DHCQueObj.QueNo	
                ; biz_date varchar 8 × 预约就诊日期
                s BizDate=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(PAAdmId)),"^",6))
                ; noon_flag varchar 1 × 预约就诊时段上下午标识
                s RegRangeTime=""
                Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM"," "_PAAdmId,""))
                if (RegfeeDr'=""){
                    set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
                    i $g(RegRangeTimeDr)'="" {
                        set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
                    }
                }
                ; withdraw_flag varchar 1 × 患者退号标识
                s VisitStatus=$p($g(^PAADM(PAAdmId)),"^",20)
                s WithdrawFlag=""
                s:VisitStatus="A" WithdrawFlag="N"
                s:VisitStatus="C" WithdrawFlag="Y"
                ; is_jz int 1 × 是否接诊标识（1 为已接，0 为未接）
                if (QueState="到达"){
                    s IsJZFlag="1"
                }else{
                    s IsJZFlag="0"
                }
                ; times varchar 10 × 接诊次数
                d PatQueueInfoOutputRow
            }
        }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatQueueInfoOutputRow    
	set Data=$lb(RegId,RegCardNo,InsuCardNo,PatCode,PatName,PatSex,UserCode,UserName,DeptCode,DeptName,ProfCode,ProfName,RegType,CTPCPCarPrvTpDesc,RegFee,ApSeqNo,RegTime,QueStatus,CallTime,RecpetionTime,SeqNo,BizDate,RegRangeTime,WithdrawFlag,IsJZFlag,TimesCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryPatQueueInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatQueueInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
}

}