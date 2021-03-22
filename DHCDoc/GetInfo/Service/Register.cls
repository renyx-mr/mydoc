/// 名称:    DHCDoc.GetInfo.Service.Register
/// 描述:    挂号相关业务信息获取接口公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
Class DHCDoc.GetInfo.Service.Register [ Abstract ]
{

/// 描述:    就诊相关信息获取接口公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.26
/// w ##class(DHCDoc.GetInfo.Service.Register).GetPAAdmInfo()
ClassMethod GetPAAdmInfo(PAADMRowID As %String) As %RegisteredObject
{
	  q ##class(DHCDoc.GetInfo.Method.Business.Register).GetPAAdmInfo(PAADMRowID)
}

}
