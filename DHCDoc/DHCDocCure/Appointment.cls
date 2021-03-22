/// 治疗流程--预约类
Class DHCDoc.DHCDocCure.Appointment Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  判断执行记录是否已经被预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus("265||191||1")
ClassMethod GetExecResultAppStatus(OEORERowId As %String) As %String
{
   n (OEORERowId)
   s AppFlag=0
   q:OEORERowId="" AppFlag
   s DCARowId=$o(^DHCDocCure(0,"OEORE",OEORERowId,""))
   i DCARowId'=""  d
   .s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,""))
   .i DCAAChildSub'=""  d
   ..s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
   ..s DCAAStatus=$p(Data,"^",7)
   ..i (DCAAStatus="I")||(DCAAStatus="A")  s AppFlag=1
   q AppFlag
}

ClassMethod GetExecCureAppStatus(OEORERowId As %String) As %String
{
   n (OEORERowId)
   s AppFlag=""
   q:OEORERowId="" AppFlag
   s DCARowId=$o(^DHCDocCure(0,"OEORE",OEORERowId,""))
   i DCARowId'=""  d
   .s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,""))
   .i DCAAChildSub'=""  d
   ..s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
   ..s DCAAStatus=$p(Data,"^",7)
   ..s AppFlag=DCAAStatus_"^"_DCARowId_"||"_DCAAChildSub
   q AppFlag
}

/// 建立预约-为多人进行预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).AppInsertBroker("7396!7417!7418^1597^M^5")
ClassMethod AppInsertBroker(ParaStr As %String) As %String
{
	s ^tmpnk("AppInsertBroker")=ParaStr
	s InsertRet=0
	s DCARowIdStr=$P(ParaStr,"^",1)
	s CureRBASId=$P(ParaStr,"^",2)
	s DCARowIdLen=$l(DCARowIdStr,"!")
	s ParaS=$p(ParaStr,"^",2,$l(ParaStr,"^"))
	
	s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(CureRBASId)),"^",4)
	s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(CureRBASId)),"^",9)
	s MaxNumber=$p($g(^DHCDocCureRBCResSchdule(CureRBASId)),"^",10)
	s DDCRSTimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(CureRBASId)),"^",5)
	s StartTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	;停诊的资源则不能预约
	if (DDCRSStatus'="N")
	{ 
			Quit "101"
	}
	if (DDCRSDate<+$h)||((DDCRSDate=+$h)&&(StartTime<$p($h,",",2)))
	{
			Quit "102"
	}
	;判断最大预约数是否已经预约完
	s AppedNumber=..GetRBCResSchduleAppedNum(CureRBASId)
	if +AppedNumber=MaxNumber
	{
			Quit "106"
	}
	s ErrorRet=""
	for mycount=1:1:DCARowIdLen{
		s aDCARowId=$P(DCARowIdStr,"!",mycount)
		s NewPara=aDCARowId+"^"+ParaS
		s ret=..AppInsertHUI(NewPara)
		if ret'=0{
			s errinfo=""
			s ApplyInfo=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(aDCARowId)
			if ApplyInfo'="" {
				s CureAppInfo=$p(ApplyInfo,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(ApplyInfo,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
				;s err=ret
				if (ret=100) s err="有参数为空"
				else  if (ret=101) s err="停诊的排班不能预约."
				else  if (ret=102) s err="此排班已经过了预约时间,不能预约."
				else  if (ret=103) s err="该申请单包含的项目数量已经约完."
				else  if ((ret=104)||(value=105)) s err="插入执行记录错误."
				else  if (ret=106) s err="此排班已预约完,不能再预约."
				else  if (ret=107) s err="该申请存在有效的预约未治疗的记记录,不能重复预约."
				else  if (value=108) s err="该申请医嘱未缴费,无法进行预约."
				else  if (value=202) s err="该申请为直接执行治疗医嘱,不可预约."
				else  s err="未知错误,错误代码-"+ret
				s errinfo=PatientName_"-"_ArcimDesc_"预约失败,失败原因@"_err
			}
			
			if ErrorRet="" s ErrorRet=errinfo
			else  s ErrorRet=ErrorRet_" "_errinfo
		}
	}
	b ;ErrorRet
	if ErrorRet'="" s InsertRet=ErrorRet
	q InsertRet
}

/// 建立预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).AppInsertHUI("261^847^M^4852")
ClassMethod AppInsertHUI(Para As %String, JSONType As %String = "") As %String
{
    s ^TMP("AppInsert")=Para
	s rtn=100
	s DCARowId=$P(Para,"^",1)
	s RBASId=$P(Para,"^",2)
	s ReqType=$P(Para,"^",3)
	s UserDR=$P(Para,"^",4)
	if (DCARowId="")||(RBASId="")||(ReqType=""){
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	s DCAOEORIDR="",Adm=""
	Set object = ##class(User.DHCDocCureApp).%OpenId(DCARowId)
	i $IsObject(object) {
		Set DCAOEORIDR=object.DCAOEORIDR.%Id()
		Set Adm=object.DCAAdmDR.%Id()
	}
	d object.%Close()
	if DCAOEORIDR=""{
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	s AdmType=""
	s billed=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3),"^",5)
	s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
	if (AdmType'="I")&&(billed'="P"){
		s rtn="108"	
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	
	s PriorityDR=$p($g(^OEORD(+DCAOEORIDR,"I",+$p(DCAOEORIDR,"||",2),1)),"^",8)
	if '##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) {
		s rtn="109"	
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)	
	}
	s ArcimId=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1),"^",2)
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
	if DDCISRowid=""{
		s rtn="201"	
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)	
	}
	s ApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",9)
	if ApplyExecFlag="Y"{
		s rtn="202"	
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}else{
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
			s rtn="203"	
			Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
		}	
	}
	
	s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",4)
	s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",9)
	s MaxNumber=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",10)
	s DDCRSTimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",5)
	s StartTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	;停诊的资源则不能预约
	if (DDCRSStatus'="N")
	{ 
		s rtn="101"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	if (DDCRSDate<+$h)||((DDCRSDate=+$h)&&(StartTime<$p($h,",",2)))
	{
		s rtn="102"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	;判断最大预约数是否已经预约完
	s AppedNumber=..GetRBCResSchduleAppedNum(RBASId)
	if +AppedNumber=MaxNumber
	{
		s rtn="106"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	b ;判断申请单已经预约的数量
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	s NoAppTimes=$p($p(rtn,$c(1),2),"^",11)
	if +NoAppTimes=0
	{
		s rtn="103"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	
	;判断排班的预约情况
	s LastDCAAChildSub="",LastDCAAChildSubF=""
	for  s LastDCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSub),-1) q:(LastDCAAChildSub="")!(LastDCAAChildSubF'="")  d
	.s LastDCAARBASId=$p(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSub),"^",1)
	.s LastDCAARBASDate=$p($g(^DHCDocCureRBCResSchdule(LastDCAARBASId)),"^",4)
	.Q:LastDCAARBASDate'=DDCRSDate
	.s LastDCAAChildSubF=LastDCAAChildSub
	s LastOEOREDRStartTime=""
	if (LastDCAAChildSubF'=""){
		s LastDCAAOEOREDR=$p(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSubF),"^",2)
		if (LastDCAAOEOREDR'="") s LastOEOREDRStartTime=$p(^OEORD(+LastDCAAOEOREDR,"I",$p(LastDCAAOEOREDR,"||",2),"X",$p(LastDCAAOEOREDR,"||",3)),"^",2)
	    if (LastOEOREDRStartTime'="") s StartTime=LastOEOREDRStartTime+10
	}
	Tstart
	;s InsSeqNo=+$g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",0))+1
	s oeori = +DCAOEORIDR
 	s suboeori = $p(DCAOEORIDR,"||",2)
	s hdate = ##class(websys.Conversions).DateHtmlToLogical(DDCRSDate) //$zdh(exDate,1)
	s InsSeqNo=1
	s htime=0 f  s htime= $o(^OEORDi(0,"Date",oeori,hdate,htime)) q:htime=""  d
	.s child = 0 f  s child=$o(^OEORDi(0,"Date",oeori,hdate,htime,suboeori,child))  q:child=""  d
	..s InsSeqNo=InsSeqNo+1
	b ;InsSeqNo
	s err=$$InsOEORE^DHCOEOrdExec(DCAOEORIDR,DDCRSDate,StartTime,1,0,1,InsSeqNo,"","","")
	if err
	{ 
		Trollback
		s rtn="104"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	s OEOREChild=$o(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",""),-1)
	if OEOREChild=""
	if err
	{ 
		Trollback
		s rtn="105"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	s OEORERowId=DCAOEORIDR_"||"_OEOREChild
	s finDCAA=0
	s DCAAChildSub=""
	f  s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,DCAAChildSub)) q:DCAAChildSub=""  d
	.s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
	.Q:DCAAStatus'="I"
	.s finDCAA=1
	;if DCAAChildSub'="" 
	if finDCAA=1 
	{
		Trollback
		s rtn="107"
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	k PLIST
	s PLIST(0)=DCARowId
	s PLIST(3)=RBASId
	s PLIST(4)=OEORERowId
	s PLIST(5)=UserDR
	s PLIST(6)=+$H
	s PLIST(7)=$P($H,",",2)
	s PLIST(8)="M"
	s PLIST(9)="I"
	&sql(insert into SQLUser.DHC_DocCureAppArrive values :PLIST())
	
	if SQLCODE
	{
		Trollback
		s rtn=SQLCODE
		Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
	}
	d ##class(DHCDoc.DHCDocCure.Triage).UpdateTriageStatus(DCARowId,UserDR)
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s IsNeedBillFlag=0
	s BillAfterUpdate=##Class(web.DHCDocConfig).GetConfigNode("CheckIPDeposit")
	if (PAADMType="I") {
		i BillAfterUpdate="1" s IsNeedBillFlag=1
	}else{
		if (PAADMType="E"){
			s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
			s StayPayMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
			if " 1 2 "[(" "_PatCurStat_" "){
				if (BillAfterUpdate="1"){
					s IsNeedBillFlag=1
			    }elseif(StayPayMode="1"){
				    //DHC_SOPFConfig OPFC_StayChargeMode 0 现金模式 1押金模式
				    s IsNeedBillFlag=1
				}
			}
		}
	}
	i IsNeedBillFlag=1 s billrtn=##Class(web.UDHCJFBILL).BILLN(Adm,UserDR,"")
	Tcommit
	s rtn=0
	Q ##class(DHCDoc.DHCDocCure.Common).EvalJson(rtn,JSONType)
}

ClassMethod AppInsert(Para As %String) As %String
{
    s ^TMP("AppInsert")=Para
	s rtn=100
	s DCARowId=$P(Para,"^",1)
	s RBASId=$P(Para,"^",2)
	s ReqType=$P(Para,"^",3)
	s UserDR=$P(Para,"^",4)
	Q:(DCARowId="")||(RBASId="")||(ReqType="") rtn
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Set DCAOEORIDR=$p(CureData,"^",2)
	//Q:DCAOEORIDR="" rtn
	
	s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",4)
	s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",9)
	s MaxNumber=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",10)
	s DDCRSTimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",5)
	s StTime=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",6) //排班上的开始日期
	s EndTime=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",7) //排班上的结束日期
	s:StTime="" StTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	s:EndTime="" EndTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",4)
	;停诊的资源则不能预约
	if (DDCRSStatus'="N")
	{ 
			Quit "101"
	}
	;lxz 时间日期判断错误修改
	if (DDCRSDate<+$h)||((DDCRSDate=+$h)&&(($p($h,",",2)<StTime)||($p($h,",",2)>EndTime)))
	{
			Quit "102"
	}
	;判断最大预约数是否已经预约完
	s AppedNumber=..GetRBCResSchduleAppedNum(RBASId)
	if +AppedNumber=MaxNumber
	{
			Quit "106"
	}
	b ;判断申请单已经预约的数量
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	s NoAppTimes=$p($p(rtn,$c(1),2),"^",11)
	if +NoAppTimes=0
	{
			Quit "103"
	}
	Tstart
	
	//lxz 走手工申请单的不进行医嘱关联
	s OEORERowId=""
	if (DCAOEORIDR'=""){
		;判断排班的预约情况
		;增加执行记录对应预约
	 	s OEOREChildSub=$O(^OEORDi(0,"Date",+DCAOEORIDR,DDCRSDate,StartTime,$P(DCAOEORIDR,"||",2),0))
		if OEOREChildSub'="" s StartTime=StartTime+10
		s err=$$InsOEORE^DHCOEOrdExec(DCAOEORIDR,DDCRSDate,StartTime,1,0,1,1,"","","")
		if err
		{ 
			Trollback
			Quit "104"
		}
		s OEOREChild=$o(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",""),-1)
		if OEOREChild=""
		if err
		{ 
			Trollback
			Quit "105"
		}
		s OEORERowId=DCAOEORIDR_"||"_OEOREChild
		s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,""))
		if DCAAChildSub'="" 
		{
			Trollback
			Quit "105"
		}
	}
	k PLIST
	s PLIST(0)=DCARowId
	s PLIST(3)=RBASId
	s PLIST(4)=OEORERowId
	s PLIST(5)=UserDR
	s PLIST(6)=+$H
	s PLIST(7)=$P($H,",",2)
	s PLIST(8)="M"
	s PLIST(9)="I"
	&sql(insert into SQLUser.DHC_DocCureAppArrive values :PLIST())
	if SQLCODE
	{
		Trollback
		Quit SQLCODE
	}
	Tcommit
	Q 0
}

/// 预约到达
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetRBCResSchduleAppedNum("818")
ClassMethod GetRBCResSchduleAppedNum(RBASId As %String, JSONType As %String = "")
{
	n (RBASId,JSONType)
	q:RBASId="" 0
	s AppedNum=0
	s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RBASId,DCARowId))  Q:DCARowId=""  d
	.s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RBASId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
	..s DCAARowId=DCARowId_"||"_DCAAChildSub
	..s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	..q:(DCAAStatus="C")
	..s AppedNum=AppedNum+1
	q ##class(DHCDoc.DHCDocCure.Common).EvalJson(AppedNum,JSONType)
}

/// 预约到达
ClassMethod AppArrive(DCAARowId As %String, UserDR As %String, LogonLocDr As %String)
{
	Q:(DCAARowId="")||(UserDR="") 100
	Tstart
	;预约到达需要执行对应执行记录
	Set Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s NewStatusCode="F"
	s myrtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,NewStatusCode,UserDR,"","","","","",LogonLocDr)
	if myrtn
    {
	    Trollback
		Quit myrtn
	}
	s StatusRowId=$O(^OEC("OSTAT",0,"Code","E",0))  
	&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
    if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	k PLIST
	s PLIST(9)="A"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	
	
	s ret=..UpdateTreatCallStatus(DCAARowId,"")
	if ret
    {
	    Trollback
		Quit ret
	}
	Tcommit
	Q 0
}

/// 取消预约
/// /// w ##class(DHCDoc.DHCDocCure.Appointment).AppCancelBatch("24048||3",5)
ClassMethod AppCancelBatch(DCAARowIdStr As %String, UserDR As %String = "") As %String
{
	s ^tmpnk("AppCancelBatch")=DCAARowIdStr
	s retstr=""
	s DCAARowIdStrLen=$l(DCAARowIdStr,"^")
	for count=1:1:DCAARowIdStrLen{
		s DCAARowId=$p(DCAARowIdStr,"^",count)
		s ret=..AppCancelHUI(DCAARowId,UserDR)
		s msg=""
		b ;0
		if ret="0" s msg=""
		else  if ret="100" s msg="入参为空"
		else  if ret="101" s msg="预约状态不是已预约的记录不能取消"
		else  s msg="取消失败:"_ret	
		b ;1
		if msg'=""{	
			s Data=..GetCureAppointment(DCAARowId)
			s ASData=$p(Data,$c(1),1)
			s AppData=$p(Data,$c(1),2)
			s DDCRSDate=$p(ASData,"^",5)   //预约日期

			s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCAARowId)
			s ArcimDesc="",PatientNo="",PatientName=""
			if (CureAppStr'=""){
				s CureAppInfo=$p(CureAppStr,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(CureAppStr,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
			}
			s msg="患者姓名:"_PatientName_" 预约日期:"_DDCRSDate_" "_msg
			
			if retstr="" s retstr=msg
			else  s retstr=retstr_","_msg
		}
	}
	q retstr
}

/// Decs:  取消预约方法
/// Input: DCAARowId:治疗预约ID UserDR:操作用户 
/// 	   SpecFlag:是否调用停执行记录((appcom.OEOrdExec).UpdateStatus方法中调用传入此参数,防止相互调用陷入死循环)
/// Output:
ClassMethod AppCancelHUI(DCAARowId As %String, UserDR As %String = "", SpecFlag As %String = "") As %String
{
	n (DCAARowId,UserDR,SpecFlag)
	s ^TMP("AppCancel")=DCAARowId_"^"_UserDR
	Q:(DCAARowId="")||(UserDR="") 100
	;取消预约需要撤销执行对应执行记录
	Set Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s DCAAStatus=$p(Data,"^",7)
	if DCAAStatus'="I"
    {
		Quit 101
	}
	;if (OEOREDR="") Q 100
	
	Tstart
	//s StatusRowId=$O(^OEC("OSTAT",0,"Code","U",0))  
	//&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
	/*if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	} */
	k PLIST
	s PLIST(9)="C"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	//取消预约时，先改变预约记录状态，否则停止执行记录时预约记录还是预约状态而失败
	if ((OEOREDR'="")&&(SpecFlag="")){
		s OEOREStatusRowId=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",16)
		if OEOREStatusRowId'="" s OEOREStatusCode=$P($G(^OEC("STAT",OEOREStatusRowId)),"^",1)
		s BillStatus=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",6)
		if (($g(OEOREStatusCode)="F")||(BillStatus="P"))
		{
			Trollback
			Q 102
		}
		s rtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"D",UserDR,+$H,"","")
		if rtn'=0{
			Trollback
			Quit rtn
		}
	}
	Tcommit
	Q 0
}

/// Desc:旧版取消预约方法
ClassMethod AppCancel(DCAARowId As %String, UserDR As %String = "") As %String
{
	n (DCAARowId,UserDR)
	s ^TMP("AppCancel")=DCAARowId_"^"_UserDR
	Q:(DCAARowId="")||(UserDR="") 100
	;取消预约需要撤销执行对应执行记录
	Set Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s DCAAStatus=$p(Data,"^",7)
	if DCAAStatus'="I"
    {
		Quit 101
	}
	Tstart
	k PLIST
	s PLIST(9)="C"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	
	;lxz 如果医嘱不为空的时候在按照医嘱的流程进行处理
	if (OEOREDR'=""){
		s OEOREStatusRowId=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",16)
		if OEOREStatusRowId'="" s OEOREStatusCode=$P($G(^OEC("STAT",OEOREStatusRowId)),"^",1)
		s BillStatus=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",6)
		if (($g(OEOREStatusCode)="F")||(BillStatus="P"))
		{
			Q 102
		}
		
		s StatusRowId=$O(^OEC("OSTAT",0,"Code","U",0))  
		&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
	    if SQLCODE
	    {
		    Trollback
			Quit SQLCODE
		} 
	}
	
	Tcommit
	Q 0
}

/// 取单个治疗申请单预约信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(867)
ClassMethod GetApplyAppInfo(DCARowId) As %String
{
	n (DCARowId)
	Quit:DCARowId="" ""
	s AppedSum=0,ArriveedSum=0
	s DCAAChildSub=0 for  Set DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
	.s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
	.q:Data=""
	.s DCAAStatus=$p(Data,"^",7)   //预约状态
	.q:(DCAAStatus'="I")&&(DCAAStatus'="A")
    .s AppedSum=AppedSum+1
    .i DCAAStatus="A" s ArriveedSum=ArriveedSum+1
	q AppedSum_"^"_ArriveedSum
}

/// 取治疗申请单单条预约信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment("1||4")
ClassMethod GetCureAppointment(DCAARowId) As %String
{
	n (DCAARowId)
	Quit:DCAARowId="" ""
	Set Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s DCAARBASDR=$p(Data,"^",1)  //资源排班ID
	s ASData=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(DCAARBASDR)
	s OEOREDR=$p(Data,"^",2)  //执行表关联
	s ReqUserDR=$p(Data,"^",3)  //预约操作人
	s:ReqUserDR'="" ReqUser=$p($g(^SSU("SSUSR",ReqUserDR)),"^",2)
	s ReqDate=$p(Data,"^",4)  //预约操作日期
	;s:ReqDate'="" ReqDate=$zd(ReqDate,1)
	s ReqDate=##class(websys.Conversions).DateLogicalToHtml(ReqDate)
	s ReqTime=$p(Data,"^",5)  //预约操作时间
	s:ReqTime'="" ReqTime=$zt(ReqTime,2)
	s ReqType=$p(Data,"^",6)  //预约方式
	s ReqType=$case(ReqType,"A":"自动","M":"手动",:"")
	s DCAAStatus=$p(Data,"^",7)  //预约状态
	s DCAAStatus=$case(DCAAStatus,"I":"已预约","A":"已治疗","C":"取消预约",:"")
	s LastUpdateUserDR=$p(Data,"^",8)  //更新人
	s:LastUpdateUserDR'="" LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	s LastUpdateDate=$p(Data,"^",9)  //更新日期
	;s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,1)
	s LastUpdateDate=##class(websys.Conversions).DateLogicalToHtml(LastUpdateDate)
	s LastUpdateTime=$p(Data,"^",10)  //更新时间
	s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,2)
	s CurDate=$zd(+$h,3)
	s CurTime=$zt($p($h,",",2),2)
	s CurDateTime=CurDate_" "_CurTime
	s CallStatus=$p(Data,"^",12)  //预约方式
	if CallStatus="Y" s CallStatus="正在呼叫"
	else  s CallStatus=""
	s AppData=DCAARBASDR_"^"_OEOREDR_"^"_ReqUserDR_"^"_$g(ReqUser)_"^"_ReqDate_"^"_ReqTime_"^"_ReqType_"^"_DCAAStatus_"^"_LastUpdateUserDR_"^"_$g(LastUpdateUser)_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_CurDateTime_"^"_CallStatus
	q ASData_$c(1)_AppData
}

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindAppointmentList","24","")
Query FindAppointmentList(DCARowId As %String, QueryState As %String) As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String")
{
}

ClassMethod FindAppointmentListExecute(ByRef qHandle As %Binary, DCARowId As %String, QueryState As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindAppointmentList")=DCARowId_","_QueryState
	if DCARowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
	.s DCAARowId=DCARowId_"||"_DCAAChildSub
	.s Statu=$P(^DHCDocCure(+DCARowId,"Arrive",DCAAChildSub),"^",7)
	.s Sub=$Case(Statu,"I":1,"A":2,"C":3,:4)  //排序查看预约记录
	.s ListFindAppointment(Sub,DCAARowId)=1
	s Sub1=0
	f  s Sub1=$O(ListFindAppointment(Sub1)) Q:Sub1=""  d
	.s Sub2=0
	.f  s Sub2=$O(ListFindAppointment(Sub1,Sub2)) Q:Sub2=""  d
	..s DCAARowId=Sub2
	..d OutputRowApplyAppointment
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApplyAppointment
	s Data=..GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	set Data=$lb(DCAARowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindAppointmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppointmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppointmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppointmentListExecute ]
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
	Quit $$$OK
}

/// 治疗工作台工作列表
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",182,1905,"05/12/2017","05/12/2017","","","")
Query FindCurrentAppointmentList(LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", DHCDocApplyNo As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,DHCDocApplyNoGet:%String")
{
}

ClassMethod FindCurrentAppointmentListExecute(ByRef qHandle As %Binary, LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", DHCDocApplyNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindCurrentAppointmentList")=LocId_","_UserId_","_StartDate_","_EndDate_","_PatientID_","_ServiceGroupId_","_QueryStatus
	if (LocId="")||(UserId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	if StartDate="" s StartDate=+$h
	else  s StartDate=$zdh(StartDate,1)
	if EndDate="" s EndDate=+$h
	else  s EndDate=$zdh(EndDate,1)
	
	;lxz 如果治疗科室高压氧排班室设备则无法显示 显示可使将要做的全部项目
	s FindResRowId=""
	s DoctorId=##class(web.SSUser).GetDefaultCareProvider(UserId)
	if DoctorId'=""  d
	.;s FindResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LocId,""))
	
	
	;if DoctorId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;if ResRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;lxz 如果申请单不为空按照申请单进行查询
	if DHCDocApplyNo'=""  d
	.s DCARowId=0 
	.for  s DCARowId=$o(^DHCDocCure(0,"DCANO",DHCDocApplyNo,DCARowId)) q:DCARowId=""  d
	..s OrdReLocId=$P(^DHCDocCure(DCARowId),"^",13)
	..Q:(OrdReLocId'=LocId)&&(OrdReLocId'="") ;lxz 如果接收科室不为空按照接收科室进行查询
	..s DCAAChildSub=0
	..f  s DCAAChildSub=$O(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) Q:DCAAChildSub=""  d
	...s DCAARowId=DCARowId_"||"_DCAAChildSub
	...s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	...q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
	...d OutputRowCurrentAppointmentList
	else  d
	.for ASDate=StartDate:1:EndDate  d
	..s ResRowId=0
	..f  s ResRowId=$O(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) Q:ResRowId=""  d
	...Q:(FindResRowId'="")&&(FindResRowId'=ResRowId)
	...s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
	....s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
	....Q:DDCRSStatus'="N"
	....s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
	....Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	....s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
	.....s OrdReLocId=$P(^DHCDocCure(DCARowId),"^",13)
	.....Q:(OrdReLocId'="")&&(OrdReLocId'=LocId) ;lxz 如果接收科室不为空按照接收科室进行查询
	.....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	.....s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
	.....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	.....Q:(PatientID'="")&&(PatientID'=PapmiDr)
	.....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
	......s DCAARowId=DCARowId_"||"_DCAAChildSub
	......s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	......q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
	......d OutputRowCurrentAppointmentList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCurrentAppointmentList
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s DHCDocApplyNoGet=$p(CureAppInfo,"^",20) ;预约单号
	s Data=..GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	;门诊未收费的医嘱不能做治疗
	s:OEOREDR'="" billed=$p(^OEORD(+OEOREDR,"I",$p(OEOREDR,"||",2),3),"^",5)
	q:(OEOREDR'="")&&(AdmType'="I")&&($G(billed)'="P")
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	set Data=$lb(DCAARowId,$g(PatientNo),$g(PatientName),$g(PatientSex),$g(PatientAge),$g(PatientTel),$g(AdmType),$g(AdmDep),$g(ArcimDesc),DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,DHCDocApplyNoGet)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCurrentAppointmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrentAppointmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrentAppointmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrentAppointmentListExecute ]
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
	Quit $$$OK
}

ClassMethod GetRBResAppCount(ARBASDR As %String)
{
	s Appcount=0
	Q:ARBASDR="" Appcount
	s DCAARowId=""
	f  s DCAARowId=$o(^DHCDocCure(0,"RBAS",ARBASDR,DCAARowId)) q:DCAARowId=""  d
	.s DCAAChildSub=""
	.f  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",ARBASDR,DCAARowId,DCAAChildSub)) q:DCAAChildSub=""  d
	..s DCAAStatus=$p(^DHCDocCure(DCAARowId,"Arrive",DCAAChildSub),"^",7)
	..Q:DCAAStatus="C"
	..s Appcount=Appcount+1
	q Appcount
}

/// Description:更新治疗记录呼叫状态
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetTreatCallInfo(6)
ClassMethod UpdateTreatCallStatus(DCAARowId, Status)
{
	n (DCAARowId,Status)
	s obj=""
	if DCAARowId["||"{
		s obj=##class(User.DHCDocCureAppArrive).%OpenId(DCAARowId)
		if $IsObject(obj){
			s obj.DCAACallStatus=Status
		}
	}else{
		s obj=##class(User.DHCDocCureApp).%OpenId(DCAARowId)
		if $IsObject(obj){
			s obj.DCACallStatus=Status
		}
	}
	s sc=obj.%Save()
	If $$$ISERR(sc){
	    Quit "-301"
    }
	d obj.%Close()
	
	q 0
}

/// Description:提供给叫号组接口，根据服务组ID得到当前处于呼叫状态的人员信息
/// Input:ServiceGroupId服务组ID,LocId科室ID
/// OutPut:当前处于呼叫状态的人员信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetTreatCallInfo(6,68)
ClassMethod GetTreatCallInfo(ServiceGroupId, LocId, SearchDate As %String = "")
{
	k ^DHCVISTreatCallN(+$h-1)
	s StartDate=+$h
	s EndDate=+$h
	s Info="",Str=""
	s ResRowId="" for  s ResRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) q:ResRowId=""  d
	.for ASDate=StartDate:1:EndDate  d
	..s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
	...s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
	...Q:DDCRSStatus'="N"
	...s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
	...Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	...s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId)) Q:DCARowId=""  d
	....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	....s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
	....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	....s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	....Q:rtn=""
	....s PatientInfo=$p(rtn,$c(1),1)
	....s PatientNo=$p(PatientInfo,"^",2)
	....s PatientName=$p(PatientInfo,"^",3)
	....//s PatientName=PatientNo_"-"_PatientName
	....s CureAppInfo=$p(rtn,$c(1),2)
	....s Project=$p(CureAppInfo,"^",1)   //项目
	....s Project=$tr(Project,"0123456789")
	....i Project["(" s Project=$p(Project,"(",1)
	....s State=$p(CureAppInfo,"^",2)     //预约
	....s GroupName=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupId)),"^",2)
	....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
	.....s DCAARowId=DCARowId_"||"_DCAAChildSub
	.....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	.....q:DCAAStatus'="I"
	.....s CallStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",12)
	.....q:CallStatus'="Y"
	.....s Str=GroupName_","_PatientName_","_Project_","_State
	.....i Info="" s Info=Str
	.....e  s Info=Info_","_Str
	.....//q:($D(^TempDHCVISTreatCall(+$h,"GetTreatCallInfo",ServiceGroupId))=1)
	.....s ^DHCVISTreatCallN(+$h,"GetTreatCallInfo",ServiceGroupId,PatientNo)=Str
	s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"CallStatus","Y",DCARowId)) Q:DCARowId=""  d
	.s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	.Q:rtn=""
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s ServiceGroupDR=$p(CureAppInfo,"^",21)
	.Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	.s CallStatus=$p(^DHCDocCure(DCARowId),"^",16)
	.s PatientInfo=$p(rtn,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	.s GroupName=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR)),"^",2)
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s Project=$p(CureAppInfo,"^",1)   //项目
	.s Project=$tr(Project,"0123456789")
	.i Project["(" s Project=$p(Project,"(",1)
	.s State=$p(CureAppInfo,"^",2)     //预约
	.s Str=GroupName_","_PatientName_"(现场号)"_","_Project_","_State
	.i Info="" s Info=Str
	.e  s Info=Info_","_Str
	.s ^DHCVISTreatCallN(+$h,"GetTreatCallInfo",ServiceGroupId,PatientNo)=Str
	q Info
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).GetAllCureAppointment(184)
ClassMethod GetAllCureAppointment(DCARowId, DCAARowIdStr As %String = "")
{
	n (DCARowId,DCAARowIdStr)
	Quit:DCARowId="" ""
	s mylist="",mystr=""
	s count=0
	if DCAARowIdStr s DCAARowIdStr="^"_DCAARowIdStr_"^"
	s DCAAChild=0
	for  s DCAAChild=$o(^DHCDocCure(+DCARowId,"Arrive",DCAAChild)) q:DCAAChild=""  d
	.s DCAARowId="^"_DCARowId_"||"_DCAAChild_"^"
	.Q:(DCAARowIdStr'="")&&(DCAARowIdStr'[DCAARowId)
	.Set Data=$g(^DHCDocCure(+DCARowId,"Arrive",DCAAChild))	
	.s DCAAStatus=$p(Data,"^",7)  //预约状态
	.q:DCAAStatus="C"
	.s DCAARBASDR=$p(Data,"^",1)  //资源排班ID
	.q:'$d(^DHCDocCureRBCResSchdule(DCAARBASDR))
	.s DocCureASData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
	.s ASDate=$p(DocCureASData,"^",4)  //出诊日期
	.s DDCRSTimeRangeDR=$p(DocCureASData,"^",5)  //排程出诊时段
	.s ASStartTime=$p(DocCureASData,"^",6)  //开始时间
	.s ASEndTime=$p(DocCureASData,"^",7)  //结束时间
	.s DDCRSLocDR=$p(DocCureASData,"^",2)  //排班科室ID
	.s DDCRSResSourceDR=$p(DocCureASData,"^",3)  //排班资源ID
	.s DDCRSLoc="",CTCareProv=""
	.i DDCRSLocDR'=""  d
	..s DDCRSLoc=$P($G(^CTLOC(DDCRSLocDR)),"^",2)
	..i $P(DDCRSLoc,"-",2)'="" s DDCRSLoc=$P(DDCRSLoc,"-",2)
	.i DDCRSResSourceDR'=""  d
	..s CTCareProvDr=$P($G(^RB("RES",DDCRSResSourceDR)),"^",2)
	..i CTCareProvDr'=""  d
	...s CTCareProv=$p($g(^CTPCP(CTCareProvDr,1)),"^",2)
	...i $P(CTCareProv,"-",2)'="" s CTCareProv=$P(CTCareProv,"-",2)
	
	.s ASDate=##class(websys.Conversions).DateLogicalToHtml(ASDate)
	.s ASTimeRangeDesc=""
	.i DDCRSTimeRangeDR'="" d
	..s ASTimeRangeDesc=$P($G(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",2)
	.s ASStartTime=$zt(ASStartTime,2)
	.s ASEndTime=$zt(ASEndTime,2)
	.s PrintData=ASDate_" "_ASStartTime_"-"_ASEndTime_"("_ASTimeRangeDesc_") "_DDCRSLoc_" "_CTCareProv
	.i mylist="" s mylist=PrintData
	.e  s mylist=mylist_"^"_PrintData
	.;以下为一行打印两条记录
	/*.s count=count+1
	.if count#2=1 d
	..s mystr=PrintData
	.e  d
	..s mystr=mystr_";  "_PrintData
	..i mylist="" s mylist=mystr
	..e  s mylist=mylist_"^"_mystr
	..s mystr=""
	i (count#2=1)&&(mystr'="") d
	.s mylist=mylist_"^"_mystr*/
	q mylist
}

ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	s ^tmpnk("OnTrigger")=parref_"^"_type
	;s $zt="AppArriveErr"
	s rtn=1
	s ParObj=##class(User.DHCDocCureAppArrive).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		if type="TAfterIns" {
			s Status=ParObj.DCAAStatus
			s UpUserID=ParObj.DCAAReqUserDRGetObjectId()
			s param=parref_"^"_Status_"^"_UpUserID
			;b ;ins
			s rtn=..InsertDHCStatus(param)
			i rtn=0 s rtn=1
			else  s rtn="ERROR"_rtn
		}
		if type="TAfterUpd" {
			;B ;TAfterUpd 1
			i $g(%e(9)) {
				s OldStatus=$g(%e(9))
				s NewStatus=$g(%d(9))
			}else{
				s OldStatus=""
				s NewStatus=ParObj.DCAAStatus
			}
			i OldStatus'=NewStatus { 
				s Status=ParObj.DCAAStatus
				s UpUserID=ParObj.DCAALastUpdateUserDRGetObjectId()
				s param=parref_"^"_Status_"^"_UpUserID
				s rtn=..InsertDHCStatus(param)
				;B ;TAfterUpd 2
				i rtn=0 s rtn=1
				else  s rtn="ERROR"_rtn
			}
		}
	}

	Q rtn
AppArriveErr
	Q 0
}

ClassMethod InsertDHCStatus(insertinfo)
{
 s DCAASParRef=$p(insertinfo,"^",1)
 i DCAASParRef="" Q -1
 s DCAASStatus=$p(insertinfo,"^",2)
 s DCAASUpUserID=$p(insertinfo,"^",3)
 s DCAASDate=$P($H,",",1)
 s DCAASTime=$P($H,",",2)
 TStart
   &sql(insert into sqluser.DHC_DocCureAppArriveStatus(DCAAS_ParRef,DCAAS_Date,DCAAS_Time,DCAAS_Status,DCAAS_UpUserID) 
   values(:DCAASParRef,:DCAASDate,:DCAASTime,:DCAASStatus,:DCAASUpUserID))
   ;b ;DHCQueueStatus
   i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
   q SQLCODE
}

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindAppointmentList","6!7")
Query FindAppointmentListHUI(DCARowId As %String, QueryState As %String, Type As %String = "") As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,ArcimDesc:%String,PatientNo:%String,PatientName:%String")
{
}

ClassMethod FindAppointmentListHUIExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, QueryState As %String, Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindAppointmentList")=DCARowIdStr_","_QueryState_","_Type
	if DCARowIdStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DCARowIdLen=$l(DCARowIdStr,"!")
	if (Type=""){
		for mycount=1:1:DCARowIdLen{
			s DCARowId=$P(DCARowIdStr,"!",mycount)
			s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
			.s DCAARowId=DCARowId_"||"_DCAAChildSub
			.s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
			.Q:(QueryState'="")&&(QueryState'[DCAAStatus)
			.d OutputRowApplyAppointmentHUI
		}
	}else{
		for mycount=1:1:DCARowIdLen{
			s DCAARowId=$P(DCARowIdStr,"!",mycount)
			continue:DCAARowId=""
			s DCARowId=+DCAARowId
			s DCAAChildSub=$p(DCARowId,"||",2)
			s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
			continue:(QueryState'="")&&(QueryState'[DCAAStatus)
			d OutputRowApplyAppointmentHUI
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApplyAppointmentHUI
	s Data=..GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCAARowId)
	s ArcimDesc="",PatientNo="",PatientName=""
	if (CureAppStr'=""){
		s CureAppInfo=$p(CureAppStr,$c(1),2)
		s ArcimDesc=$p(CureAppInfo,"^")
		s PatientInfo=$p(CureAppStr,$c(1),1)
		s PatientNo=$p(PatientInfo,"^",2)
		s PatientName=$p(PatientInfo,"^",3)
	}
	set Data=$lb(DCAARowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,ArcimDesc,PatientNo,PatientName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindAppointmentListHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppointmentListHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppointmentListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppointmentListHUIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish HUIFetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// HUIFetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 治疗工作台工作列表
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentListHUI",197,4833,"","12/12/2018","","","I")
Query FindCurrentAppointmentListHUI(LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", ApplyNo As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,OEOREDR:%String,ServiceGroupDR:%String,CallStatus:%String,PatOther:%String,CureApplyNo:%String")
{
}

ClassMethod FindCurrentAppointmentListHUIExecute(ByRef qHandle As %Binary, LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", ApplyNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindCurrentAppointmentList")=LocId_","_UserId_","_StartDate_","_EndDate_","_PatientID_","_ServiceGroupId_","_QueryStatus
	if (LocId="")||(UserId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	if StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) ;$zdh(StartDate,DateFormat)
	else  s StartDate=+$h
	if EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) ;$zdh(EndDate,DateFormat)
	else  s EndDate=+$h
	s DoctorId=##class(web.SSUser).GetDefaultCareProvider(UserId)
	if DoctorId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s CareProcType=""
	s CareProcTypeDr=$p(^CTPCP(DoctorId,1),"^",4)
	s:CareProcTypeDr'="" CareProcType=$p(^CT("CPT",CareProcTypeDr),"^",4)
	
	b ;治疗基础设置，治疗工作台是否只能查看预约到本人的预约记录
	s DHCDocCureWorkQrySelf=+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureWorkQrySelf"))
	if (DHCDocCureWorkQrySelf=1){
		s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LocId,""))
		if ResRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		for ASDate=StartDate:1:EndDate  d
		.s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
		..s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
		..Q:DDCRSStatus'="N"
		..s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
		..Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
		..s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
		...s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
		...s CureApplyNo=$p($g(^DHCDocCure(DCARowId)),"^",18)
		...Q:(ApplyNo'="")&&(CureApplyNo'=ApplyNo)
		...s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
		...s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		...s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
		...Q:(PatientID'="")&&(PatientID'=PapmiDr)
		...s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
		....s DCAARowId=DCARowId_"||"_DCAAChildSub
		....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
		....q:DCAAStatus="C"
		....q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
		....d OutputRowCurrentAppListHUI
	}else{
		s ResRowId="" for  s ResRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) q:ResRowId=""  d
		.for ASDate=StartDate:1:EndDate  d
		..s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
		...s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
		...Q:DDCRSStatus'="N"
		...s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
		...Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
		...s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
		....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
		....s CureApplyNo=$p($g(^DHCDocCure(DCARowId)),"^",18)
		....Q:(ApplyNo'="")&&(CureApplyNo'=ApplyNo)
		....s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
		....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
		....Q:(PatientID'="")&&(PatientID'=PapmiDr)
		....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
		.....s DCAARowId=DCARowId_"||"_DCAAChildSub
		.....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
		.....q:DCAAStatus="C"
		.....q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
		.....d OutputRowCurrentAppListHUI	
	}
	
	s myStartTime=0
	for  s myStartTime=$o(^||TMPSORT("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",myStartTime)) q:myStartTime=""  d
	.s myDCAARowId=""
	.for  s myDCAARowId=$o(^||TMPSORT("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",myStartTime,myDCAARowId)) q:myDCAARowId=""  d 
	..s Data1=$g(^||TMPSORT("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",myStartTime,myDCAARowId))
	..Set ^CacheTemp(repid,ind)=Data1
 	..Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCurrentAppListHUI
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s CureApplyNo=$p(CureAppInfo,"^",31) 
	s Data=..GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s SortStartTime=$zth(StartTime,3)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	;门诊未收费的医嘱不能做治疗
	s billed=$p(^OEORD(+OEOREDR,"I",$p(OEOREDR,"||",2),3),"^",5)
	q:(AdmType'="I")&&(billed'="P")
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CallStatus=$p(AppData,"^",14)
	s AdmTypeDesc=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType_"("_AdmDep_")"
	set Data=$lb(DCAARowId,$g(PatientNo),$g(PatientName),$g(PatientSex),$g(PatientAge),$g(PatientTel),$g(AdmTypeDesc),$g(AdmDep),$g(ArcimDesc),DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,OEOREDR,ServiceGroupDR,CallStatus,PatOther,CureApplyNo)
 	set ^||TMPSORT("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",SortStartTime,DCAARowId)=Data
 	;Set ^CacheTemp(repid,ind)=Data
 	;Set ind=ind+1
 	quit
}

ClassMethod FindCurrentAppointmentListHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrentAppointmentListHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrentAppointmentListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrentAppointmentListHUIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish HUIFetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// HUIFetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
