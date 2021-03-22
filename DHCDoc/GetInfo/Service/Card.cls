/// 名称:    DHCDoc.GetInfo.Service.Card
/// 描述:    卡管理相关业务信息获取接口公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
Class DHCDoc.GetInfo.Service.Card [ Abstract ]
{

/// 描述:    卡管理相关信息获取接口公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.26
/// w ##class(DHCDoc.GetInfo.Service.Card).GetCardInfo()
ClassMethod GetCardInfo(CFRowID As %String) As %RegisteredObject
{
	  q ##class(DHCDoc.GetInfo.Method.Business.Card).GetCardInfo(CFRowID)
}

}
