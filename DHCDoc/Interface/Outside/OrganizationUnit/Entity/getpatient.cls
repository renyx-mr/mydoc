Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.getpatient Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 预约记录 Id患者 ID 类型(1-预留2-预留3-身份证号)
Property patientIdTypeId As %String(TRUNCATE = 1);

/// 患者 ID 11011118860506
Property patientId As %String(TRUNCATE = 1);

/// 患者在 HIS 系统的标识
Property patientHistId As %String(TRUNCATE = 1);

/// 患者姓氏 张
Property patientFamilyName As %String(TRUNCATE = 1);

/// 患者名字 三
Property patientGivenName As %String(TRUNCATE = 1);

/// 患者姓名 张三
Property patientFullName As %String(TRUNCATE = 1);

/// 患者性别（1 未知、 2 其它、 3女、 4 男）
Property patientGenderTypeId As %String(TRUNCATE = 1);

/// 患者手机号 18811112222
Property patientMobileNumber As %String(TRUNCATE = 1);

/// 患者居住地址
Property patientResidenceAddress As %String(TRUNCATE = 1);

/// 患者在院内系统开立的就诊标识列表就诊标识列表响应参数
Property patientIdentifierList As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard(XMLITEMNAME = "ones", XMLNAME = "patientIdentifierList", XMLPROJECTION = "COLLECTION");

}
