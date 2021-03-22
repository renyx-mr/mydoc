/// 治疗站提供给其他产品组的接口方法
Class DHCDoc.DHCDocCure.OutInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:nikang
/// Desc：根据医嘱ID获得治疗申请已经预约或者执行的数量，计费组需根据此方法限制部分退费可申请的数量
/// Input:OEORIRowID 医嘱ID
/// OutPut:治疗申请已经预约或者执行的数量
/// Debug:w ##class(DHCDoc.DHCDocCure.OutInterface).GetCureExecQty("3382||5")
ClassMethod GetCureExecQty(OEORIRowID As %String)
{
	new (OEORIRowID)
	set CureExecQty=0
	Quit:OEORIRowID="" 0
	set DCARowID=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))	
	Quit:DCARowID="" 0
	set ArcimId=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1)),"^",2)
	Quit:ArcimId="" 0
	set DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
	Quit:DDCISRowid="" 0
	set PriorityDR=$p($g(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),1)),"^",8)
	set ShortOrderPrior=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR)
	Quit:ShortOrderPrior'=1 0
	set ApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",9)
	set DocCureUseBase=+(##class(web.DHCDocConfig).GetConfigNode("DocCureUseBase"))
	if DocCureUseBase=1 s ApplyExecFlag="Y"
	if ApplyExecFlag'="Y" {
		set CureAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowID)
		set CureExecQty=$p(CureAppInfo,"^")
	}else{
		set OrderExecChild=0
		for  set OrderExecChild=$o(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),"X",OrderExecChild)) Q:OrderExecChild=""  d
		.set execdata=$g(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),"X",OrderExecChild))
		.set OEOREStatus=$p(execdata,"^",16)
		.set OEOREStatusCode=""
		.set:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
		.Quit:OEOREStatusCode'="F"
		.set OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEORIRowID_"||"_OrderExecChild)
		.set CureExecQty=CureExecQty+OEOREQty	
	}
	Quit CureExecQty
}

}
