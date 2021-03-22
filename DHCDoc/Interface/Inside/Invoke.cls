/// creator:guorongyong
/// date:2016-05-13
/// desc:和东华内部系统的接口类【主要是调用其他产品组的接口】,仅医生站,不包括建卡,挂号,分诊与内部的接口
Class DHCDoc.Interface.Inside.Invoke Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  得到检查项目有的申请单信息,也用于判断检查项目是否可撤销或者作废
/// Table:        
/// Input:        oeitm:医嘱RowId   UserID:用户ID
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId("747886||227") 
ClassMethod GetTmInfoByOrderRowId(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	q:OEORIRowId="" ""
	
	s OutInfo=""
	;1. Pis检查项目
	s OutInfo=##class(web.DHCPisApplicationSheet).GetTmInfoByOrderRowId(OEORIRowId)
	;2. 病历检查项目判断
	
	;3. RIS检查项目判断,RIS已经在停止或者作废的时候自动取消了申请单
	
	Q OutInfo
}

/// Creator:      郭荣勇
/// CreatDate:    2017.04.1
/// Description:  撤销,作废,停止 操作发起推送接口交易,eg:第三方医技系统消息推送
/// Table:        
/// Input:        oeitm:医嘱RowId UserID:用户ID
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.Invoke).CancelOrdInterface("747886||227") 
ClassMethod CancelOrdInterface(OEORIRowId As %String, UserID As %String = "", status As %String = "") As %String
{
	n (OEORIRowId,UserID,status)
	q:OEORIRowId="" ""
	
	s OutRet=""
	;1. 调用平台组接口,内部服务总线
	s OutRet=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPORDERITEMINFO",OEORIRowId)
	;2. 调用检查申请取消接口
	s OutRet=##Class(web.DHCEMInterface).StopOrderInvExaReqNo(OEORIRowId,"",UserID)
	;3. pacs工作站停医嘱接口申请单
	s OutRet=##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OEORIRowId)
	s OutRet=##class(web.DHCRisResourceApptSchudle).CancelBook(OEORIRowId)
	if (status'=""){
		;调用医政接口改变临床路径医嘱状态
		s adm=$p(^OEORD(+OEORIRowId),"^",1)
		d ##class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatus(adm,status,OEORIRowId,UserID)
	}
	Q OutRet
}

}
