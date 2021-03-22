Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "card";

Parameter XMLIGNORENULL = 0;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 标识类型 (1-预留2-预留 3-院内就诊卡 4-电子健康卡5-门诊号码)
Property identifierTypeId As %String(TRUNCATE = 1);

/// 标识号 37060200990002
Property identifierText As %String(TRUNCATE = 1);

/// 是否处于可用状态 true
Property isValid As %String(TRUNCATE = 1);

/// 创建日期 yyyy-MM-dd
Property createDate As %String(TRUNCATE = 1);

/// 创建时间 HH:mm:ss
Property createTime As %String(TRUNCATE = 1);

/// 上一次使用该标识的日期
Property lastUsedDate As %String(TRUNCATE = 1);

/// 上一次使用该标识时间
Property lastUsedTime As %String(TRUNCATE = 1);

/// 该 identifier 所对应的 HIS 系统标识
Property mappedPatientHisId As %String(TRUNCATE = 1);

}
