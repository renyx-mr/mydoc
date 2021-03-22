/// 名称:    DHCDoc.GetInfo.Service.Alloc
/// 描述:    分诊相关业务信息获取接口公共类
/// 编写者:  宋春莉
/// 编写日期:2016.11.22
Class DHCDoc.GetInfo.Service.Alloc [ Abstract ]
{

/// 描述:    分诊相关信息获取接口公共方法
/// 编写者:  宋春莉
/// 编写日期:2016.11.26
/// w ##class(DHCDoc.GetInfo.Service.Alloc).GetAllocInfo()
ClassMethod GetAllocInfo(QueID As %String) As %RegisteredObject
{
	  q ##class(DHCDoc.GetInfo.Method.Business.Alloc).GetAllocInfo(QueID)
}

}
