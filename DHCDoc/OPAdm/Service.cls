/// creator：:郭荣勇
/// date：2017-06-08
/// desc：收集和编写预约挂号产品线的针对IMedical的服务类,即HIS内部接口服务类
Class DHCDoc.OPAdm.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2016.6.15
/// desc:标准取消挂号接口,提供给东华内部系统使用
/// input:参考《HIS标准接口定义.doc》
/// output:参考《HIS标准接口定义.doc》
ClassMethod ICancelOPRegist(EpisodeID As %String = "", UserRowId As %String = "", GroupRowId As %String = "", LogonLocRowId As %String = "", ByRef NewInvoiceId As %String, ReturnMR As %String = "", ReturnReasonDr As %String = "") [ ProcedureBlock = 0 ]
{
	n (EpisodeID,UserRowId,GroupRowId,LogonLocRowId,NewInvoiceId,ReturnMR,ReturnReasonDr)
	
	Q ##class(web.DHCOPAdmReg).ICancelOPRegist(EpisodeID,UserRowId,GroupRowId,LogonLocRowId,NewInvoiceId,ReturnMR,ReturnReasonDr)
}

/// creator:郭荣勇
/// date:2016.6.15
/// desc:医生站直接挂号接口 提供给新产品研发组
/// input:
/// output:ret_"^"_EpisodeID_"^"_mradm : ret 0 成功,其他 失败；EpisodeID 就诊Rowid；mradm	MR_Adm的Rowid
ClassMethod OPDocRapidRegistNewBroker(PatientID As %Library.String = "", ASRowId As %Library.String = "", AdmReason As %String, FeeStr As %String = "", user As %Library.String = "", group As %Library.String = "", LocID As %String = "", DocRowId As %String = "", TimeRangeRowId As %String = "", PayModeCode As %Library.String = "", AccRowId As %Library.String = "") As %String [ ProcedureBlock = 0 ]
{
	n (PatientID,ASRowId,AdmReason,FeeStr,user,group,LocID,DocRowId,TimeRangeRowId,PayModeCode,AccRowId,%session)
	Q ##class(web.DHCOPAdmReg).OPDocRapidRegistNewBroker(PatientID,ASRowId,AdmReason,FeeStr,user,group,LocID,DocRowId,TimeRangeRowId,PayModeCode,AccRowId,%session)
}

/// creator:郭荣勇
/// date:2016.6.15
/// desc:更新挂号表中的发票数据--用于欠费补回
/// input:AdmID 就诊ID InvoiceId 新挂号发票表ID
/// Output: 0 成功 其他失败
ClassMethod UpdateRegistionFeeInv(AdmID As %String, InvoiceId As %String) As %String
{
	n (AdmID,InvoiceId)
	Q ##class(web.DHCOPAdmReg).OPDocRapidRegistNewBroker(AdmID,InvoiceId)
}

}
