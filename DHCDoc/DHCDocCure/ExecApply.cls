Class DHCDoc.DHCDocCure.ExecApply Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.ExecApply","FindCureExecList","12")
/// DCARowId,OEORERowID,PapmiNo,PatientName,ArcimDesc,OEOREExStDate,OEOREStatus,OEOREQty,OEOREUpUser,OEOREExDate
Query FindCureExecList(DCARowId As %String, OnlyNoExcute As %String, OnlyExcute As %String = "") As %Query(ROWSPEC = "DCARowId:%String,OEORERowID:%String,PapmiNo:%String,PatientName:%String,ArcimDesc:%String,OEOREExStDate:%String,OEOREStatus:%String,OEOREQty:%String,OEOREUpUser:%String,OEOREExDate:%String,ApplyDate:%String,OEOREType:%String")
{
}

ClassMethod FindCureExecListExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, OnlyNoExcute As %String, OnlyExcute As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindCureExecListExecute")=DCARowIdStr
	if DCARowIdStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DCARowIdLen=$l(DCARowIdStr,"!")
	for mycount=1:1:DCARowIdLen{
		s DCARowId=$P(DCARowIdStr,"!",mycount)
		Set CureData=$g(^DHCDocCure(DCARowId))
		Set Adm=$p(CureData,"^",1)
		continue:Adm=""
		Set PatientId=$P($G(^PAADM(Adm)),"^",1)
		s PapmiNo=##Class(web.PAPatMas).GetRegistration(PatientId)
 		s PatientName=$P($G(^PAPER(PatientId,"ALL")),"^",1)
		Set OrderId=$p(CureData,"^",2)
		continue:OrderId=""
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		continue:ArcimId=""
		continue:##class(DHCDoc.DHCDocCure.Apply).CheckActiveExec(OrderId)=0
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s AdmType=$case(AdmType,"I":"住院","E":"急诊","O":"门诊",:"")
		s ApplyDate=$p(CureData,"^",5)
		s ApplyTime=$p(CureData,"^",6)
		s ApplyDate=##class(websys.Conversions).DateLogicalToHtml(ApplyDate) ;$zd(ApplyDate,3)
		s ApplyTime=$zt(ApplyTime)
		s ApplyDate=ApplyDate_" "_ApplyTime
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		;continue:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
		s OrdPHFreqDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),2)),"^",4)
		s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
		s Priority=$p(^OECPR(PriorityDR),"^",2)
		s Priority=$tr(Priority,"医嘱","")
		s AdmType=AdmType_Priority
		s floop=0
		s OrderPar=+OrderId
		s OrderChild=$p(OrderId,"||",2)
		s OrderExecChild=0
		f  s OrderExecChild=$o(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild)) Q:OrderExecChild=""  d
		.s OEORERowID=OrderId_"||"_OrderExecChild
		.s execdata=$g(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild))
		.s OEOREStatus=$p(execdata,"^",16)
		.s OEOREStatusCode=""
		.s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1),OEOREStatus=$p(^OEC("STAT",OEOREStatus),"^",2)
		.Q:(OnlyNoExcute="ON")&&(OEOREStatusCode'="")
		.Q:(OnlyExcute="Y")&&(OEOREStatusCode'="F")
		.s OEOREExStDate=$p(execdata,"^",1)
		.s:OEOREExStDate'="" OEOREExStDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExStDate) ;$zd(OEOREExStDate,3)
		.s OEOREExStTime=$p(execdata,"^",2)
		.s:OEOREExStTime'="" OEOREExStTime=$zt(OEOREExStTime,1)
		.s OEOREExStDate=OEOREExStDate_" "_OEOREExStTime
		.;s OEOREQty=$p(execdata,"^",4)
		.;s OEOREAdminQty=$p(execdata,"^",5)
		.s OEOREQty=..GetQtyByExecID(OEORERowID)
		.i OrdPHFreqDR="" d
		..;s OEOREQty=OEOREAdminQty
		..;s RefQtyInfo=+(##class(web.DHCOPBillOERefundQty).GetRefundQTY(OrderId,""))
		..;s OEOREQty=OEOREQty-RefQtyInfo
		.s OEOREUpUser=$p(execdata,"^",15)
		.s:OEOREUpUser'="" OEOREUpUser=$p(^CTPCP(OEOREUpUser,1),"^",2)
		.s OEOREExDate=$p(execdata,"^",19)
		.s:OEOREExDate'="" OEOREExDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExDate) ;$zd(OEOREExDate,3)
		.s OEOREExTime=$p(execdata,"^",20)
		.s:OEOREExTime'="" OEOREExTime=$zt(OEOREExTime,1)
		.s OEOREExDate=OEOREExDate_" "_OEOREExTime
		.s floop=floop+1
		.if floop>1 d
		..;s PapmiNo="",PatientName="",ApplyDate="",ArcimDesc="-"
		..s ApplyDate="<font style='color:red'>-</font>"
		.d OutputRowCureExec
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCureExec
	set Data=$lb(DCARowId,OEORERowID,PapmiNo,PatientName,ArcimDesc,OEOREExStDate,OEOREStatus,OEOREQty,OEOREUpUser,OEOREExDate,ApplyDate,AdmType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureExecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureExecListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureExecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureExecListExecute ]
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

ClassMethod GetQtyByExecID(ExecRowID)
{
	new (ExecRowID)
	set OrderID=+ExecRowID
	set OrderSubID=$p(ExecRowID,"||",2)
	set OrderExecSubID=$p(ExecRowID,"||",3)
	set OrdPHFreqDR=$p($g(^OEORD(+OrderID,"I",OrderSubID,2)),"^",4)
	set OrdExecData=$g(^OEORD(OrderID,"I",OrderSubID,"X",OrderExecSubID))
	set OEOREQty=$p(OrdExecData,"^",4)
	set OEOREAdminQty=$p(OrdExecData,"^",5)
	if OrdPHFreqDR="" d
	.set OEOREQty=OEOREAdminQty
	Quit OEOREQty
}

ClassMethod UpdateQtyByExecID(ExecRowID, Qty)
{
	new (ExecRowID,Qty)

	set execobj=##class(User.OEOrdExec).%OpenId(ExecRowID)
	set PhQtyOrd=execobj.OEOREPhQtyOrd
	set AdminQty=execobj.OEOREQtyAdmin
	if AdminQty>Qty set execobj.OEOREQtyAdmin=Qty
	else  set execobj.OEOREPhQtyOrd=Qty
	
	set sc=execobj.%Save()
	If $$$ISERR(sc){
	    Quit "-101"
    }
	do execobj.%Close()
	
	Quit 0
}

ClassMethod CheckBeforeUpdateExec(DCARowId As %String, UserID As %String)
{
	n (DCARowId,UserID)
	Q:DCARowId="" "申请单信息不能传入为空"
	Q:'$D(^DHCDocCure(DCARowId)) "-1^不存在订单信息"
	Q:UserID="" "操作员信息不存在"
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	Q:ApplyStatus="F" "已经完成的申请单不能进行操作."
	Q:ApplyStatus="C" "已经撤销的申请单不能进行操作."
	Set CureData=$g(^DHCDocCure(+DCARowId))
	Set Adm=$p(CureData,"^",1)
	Q:Adm="" "申请单就诊为空"
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set AdmType=$p($g(^PAADM(Adm)),"^",2)
	Set OrderId=$p(CureData,"^",2)
	q:OrderId="" "申请单对应医嘱为空"
	s Ordbilled=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",5)
	q:(AdmType'="I")&(Ordbilled'="P") "医嘱未缴费,不能执行"
	q ""
}

/// Desc:执行/撤销执行配置为“直接执行”的治疗申请
/// Input:DCARowId:申请单ID UserID:操作用户ID EexcNum:执行数量 Type:执行类型(执行Or撤销执行) Resource:操作来源(执行Or添加治疗记录) OEOREDRStr:执行记录ID
/// w ##class(DHCDoc.DHCDocCure.ExecApply).FinishCureApply(12,4661,2,"E","","324||2||1")
ClassMethod FinishCureApply(DCARowId As %String, UserID As %String, EexcNum As %String, Type As %String, Resource As %String = "", OEOREDRStr As %String = "", LocDeptDr As %String = "") As %String
{
	s ^tmpnk("FinishCureApply")=DCARowId_"^"_UserID_"^"_EexcNum_"^"_Type_"^"_Resource_"^"_OEOREDRStr_"^"_LocDeptDr
	s checkret=..CheckBeforeUpdateExec(DCARowId,UserID)
	Q:checkret'="" checkret
	s AppEexcNum=+$p(^DHCDocCure(DCARowId),"^",15)
	if Type="C" s EexcNum=-EexcNum
	s AppEexcNum=AppEexcNum+EexcNum
	Set CureData=$g(^DHCDocCure(+DCARowId))
	Set OrderId=$p(CureData,"^",2)
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	s OrderQty=+##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(OrderId) ;$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	S AppedSum=+##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s DocCureUseBase=+(##class(web.DHCDocConfig).GetConfigNode("DocCureUseBase"))
	s Statu="F"
	if (Type'="E")!(AppEexcNum=0)!(AppEexcNum<OrderQty)!(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
		s Statu=ApplyStatus
	}
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	S FinishDate="",FinishTime=""
	if (Statu="F"){
		s FinishDate=NowDate
		s FinishTime=NowTime
	}
	Ts
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:Statu,DCA_UpdateUser_DR=:UserID,DCA_FinishUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime,DCA_ExecNum=:AppEexcNum where DCA_RowId=:DCARowId)
	s myrtn=SQLCODE
	if myrtn'=0{
		Tro
		Q myrtn_" "_"更新申请单信息错误"
	}else{
		&sql(insert into sqluser.DHC_DocCure_AppExecChange(DCAEC_ParRef,DCAEC_Date,DCAEC_Time,DCAEC_User_DR,DCAEC_Type,DCAEC_ExecNum,DCAEC_LastUpdateDate,DCAEC_LastUpdateTime) 
   		values(:DCARowId,:NowDate,:NowTime,:UserID,:Type,:EexcNum,:NowDate,:NowTime))
   		
   		s myrtn=SQLCODE
		if myrtn'=0{
			Tro
			Q myrtn_" "_"插入申请单执行变更记录错误"
		}
	}
	b ;点击执行(撤销执行除外)的时候会将呼叫状态清空
	if Type="E"{
		s ret=##class(DHCDoc.DHCDocCure.Appointment).UpdateTreatCallStatus(DCARowId,"")
		if ret
	    {
		    Trollback
			Quit ret
		}
		d ##class(DHCDoc.DHCDocCure.Triage).UpdateTriageStatus(DCARowId,UserID)
	}
	
	if Resource=""{
		if OEOREDRStr=""{
			Trollback
			Q "-800"_" "_"执行记录为空"	
		}
		
		s ctpcpId=$p(^SSU("SSUSR",UserID),"^",14)
		if ctpcpId=""{
			Trollback
			Q "-801"_" "_"医护人员信息出错"	
		}
		if Type="E"{
			s NewStatusCode="F"
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","E",0))  
		}elseif Type="S"{
			s NewStatusCode="D"	
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","D",0))	
		}else{
			s NewStatusCode="C"	
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","C",0))  
		}
		s OEOREDR=OEOREDRStr
		s myrtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,NewStatusCode,UserID,"","","","","",LocDeptDr)
		if myrtn'=0{
			Trollback
			Q myrtn_" "_"更新执行记录错误"	
		}
		
		;&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
	    ;if SQLCODE{
		;    Trollback
		;	Quit SQLCODE_" "_"更新OE_OrdExecExt"
		;}
	
	}
	Tc
	q myrtn
}

}
