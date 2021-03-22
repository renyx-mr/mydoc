/// 名称:    DHCDoc.GetInfo.Service.Doc
/// 描述:    医生(诊断、医嘱)相关业务信息获取接口公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
Class DHCDoc.GetInfo.Service.Doc [ Abstract ]
{

/// 描述:    医嘱相关信息获取接口公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.26
/// w ##class(DHCDoc.GetInfo.Service.Doc).GetOrdInfo()
ClassMethod GetOrdInfo(OEORIRowID As %String) As %RegisteredObject
{
	  q ##class(DHCDoc.GetInfo.Method.Business.Doc).GetOrdInfo(OEORIRowID)
}

/// 描述:    诊断相关信息获取接口公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.26
/// w ##class(DHCDoc.GetInfo.Service.Doc).GetDiagnosInfo()
ClassMethod GetDiagnosInfo(MRDIARowId As %String) As %RegisteredObject
{
	  q ##class(DHCDoc.GetInfo.Method.Business.Doc).GetDiagnosInfo(MRDIARowId)
}

}
