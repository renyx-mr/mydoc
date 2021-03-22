Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.department Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 机构单元 Id（院内系统）
Property organizationUnitId As %String(TRUNCATE = 1);

/// 机构单元名称
Property organizationUnitName As %String(TRUNCATE = 1);

/// 机构单元地点
Property organizationUnitAddress As %String(TRUNCATE = 1);

/// 是否提供线上服务 true
Property isOnlineServiceEnabled As %String(TRUNCATE = 1);

/// 机构单元级别（1，2和 3 作为保留，暂不使用、 4 医院、 5 院区、 6 科室、 7 二级科室）
Property levelId As %String(TRUNCATE = 1);

/// 上级机构单元 Id（如果 levelId 为 4，则parentId 是 0
Property parentId As %String(TRUNCATE = 1);

}
