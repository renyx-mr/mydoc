Class DHCDoc.Renyx.DLJZYYHosp Extends %RegisteredObject
{

ClassMethod CheckDishOrdTime(AdmDr As %String, StartDate As %String, Time As %String, EndDate As %String)
{
	s OrderDr=$o(^OEORD(0,"Adm",AdmDr,""))
	
	q:OrderDr="" "1^未找到该就诊的医嘱记录。"
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s Time=##class(websys.Conversions).TimeHtmlToLogical(Time)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	;获取出院以及死亡医嘱
	s dischargeNeedArcimStr=##class(web.DHCDischargeHistory).GetDischargeNeedArcim("dischargeNeedArcim")
	s deathDischargeNeedArcimStr=##class(web.DHCDischargeHistory).GetDischargeNeedArcim("deathDischargeNeedArcim")
	s NeedCheckArcimStr=""
	i dischargeNeedArcimStr'="" s NeedCheckArcimStr=dischargeNeedArcimStr
	i deathDischargeNeedArcimStr'="" s NeedCheckArcimStr=NeedCheckArcimStr_"^"_deathDischargeNeedArcimStr
	
	s RetStr="0"
	s Childsub=0
	f OrdDate = StartDate:1:EndDate{
		s Childsub=$o(^OEORDi(0,"StDt",OrdDate,OrderDr,Childsub))
		//s Childsub=$o(^OEORDi(0,"StDtTm1",OrderDr,Date,Time,Childsub))
		q:Childsub=""
		q:+RetStr=1
		;过滤出院和死亡医嘱
		s ItmMastDr=$p($g(^OEORD(OrderDr,"I",Childsub,1)),"^",2)
		continue:("^"_NeedCheckArcimStr_"^")[("^"_ItmMastDr_"^")
		s SubStatusCode=##class(appcom.OEOrdItem).GetStatusCode(OrderDr_"||"_Childsub)
		//s SubStatusDesc=$case(SubStatusCode,"V":"核实","U":"作废","C":"撤销","E":"执行","D":"停止","I":"未激活")
		continue:(SubStatusCode="U")||(SubStatusCode="C")
		s ctpcprowid=$p($g(^OEORD(OrderDr,"I",Childsub,1)),"^",11)
		i ctpcprowid'="" {
			s CTPCPCarPrvTpDR = $p(^CTPCP(ctpcprowid,1),"^",4)
			s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
			continue:CTCPTInternalType="NURSE" ;isNurse=1
		}
		s OrdStartDate=$p($g(^OEORD(OrderDr,"I",Childsub,1)),"^",9)
		s OrdStartTime=$p($g(^OEORD(OrderDr,"I",Childsub,1)),"^",10)
		continue:((OrdStartDate=StartDate)&&(OrdStartTime<Time))
		s RetStr="1^开始时间之后存在有效的医嘱。"
	}
	q RetStr
}

ClassMethod UpdateOrdItemStartDateTime(OrdItemDr As %String, UpdateDate As %String, UpdateTime As %String, UserId As %String)
{
	s OrdDr=+OrdItemDr
	s OrdSub=$p(OrdItemDr,"||",2)
	s UpdateDate=##class(websys.Conversions).DateHtmlToLogical(UpdateDate)
	s UpdateTime=##class(websys.Conversions).TimeHtmlToLogical(UpdateTime)
	q:(UpdateDate="")||(UpdateTime="") "-1"
	q:'$d(^OEORD(OrdDr,"I",OrdSub,1)) "-1"
	s ItmMastDr=$p($g(^OEORD(OrdDr,"I",OrdSub,1)),"^",2)
	q:ItmMastDr="" "-1"
	s dischargeNeedArcimStr=##class(web.DHCDischargeHistory).GetDischargeNeedArcim("dischargeNeedArcim")
	s deathDischargeNeedArcimStr=##class(web.DHCDischargeHistory).GetDischargeNeedArcim("deathDischargeNeedArcim")
	s NeedCheckArcimStr=""
	i dischargeNeedArcimStr'="" s NeedCheckArcimStr=dischargeNeedArcimStr
	i deathDischargeNeedArcimStr'="" s NeedCheckArcimStr=NeedCheckArcimStr_"^"_deathDischargeNeedArcimStr
	q:("^"_NeedCheckArcimStr_"^")[("^"_ItmMastDr_"^") "-1"
	s OrdCreateDate=$p($g(^OEORD(OrdDr,"I",OrdSub,3)),"^",7)
	s OrdCreateTime=$p($g(^OEORD(OrdDr,"I",OrdSub,1)),"^",17)
	s OrdDate="",OrdTime=""
	if (UpdateDate>OrdCreateDate){
		s OrdDate=UpdateDate
	}elseif(UpdateDate=OrdCreateDate){
		if (UpdateTime>=OrdCreateTime){
			s OrdTime=UpdateTime
		} 
	}
	if (OrdDate)="" s OrdDate=OrdCreateDate
	if (OrdTime)="" s OrdTime=OrdCreateTime
	s date=+$h,time=$p($h,",",2)
	&SQL(Update SQLUser.OE_OrdItem 
		Set OEORI_Date=:OrdDate,
		OEORI_TimeOrd=:OrdTime,
		OEORI_SttDat=:UpdateDate,
		OEORI_SttTim=:UpdateTime,
		OEORI_UpdateDate=:date,
		OEORI_UpdateTime=:time,
		OEORI_UserUpdate=:UserId
		Where OEORI_RowId=:OrdItemDr)
	Q SQLCODE
}

}
