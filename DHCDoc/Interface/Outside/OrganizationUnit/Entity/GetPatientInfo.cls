Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.GetPatientInfo Extends (%RegisteredObject, %XML.Adaptor)
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

/// patientName	string	是	患者姓名		张三
Property patientName As %String(TRUNCATE = 1);
/// patientGenderTypeId	int	是	患者性别（1未知、2其它、3女、4男）		4
Property patientGenderTypeId As %String(TRUNCATE = 1);
/// patientMobileNumber	string	是	患者手机号		18811112222
Property patientMobileNumber As %String(TRUNCATE = 1);
/// patientResidenceAddress	string	否	患者居住地址		北京市西城区复兴门外大街999号院11号楼3单元502室
Property patientResidenceAddress As %String(TRUNCATE = 1);
/// patientIdentifierList		否	患者在院内系统开立的就诊标识列表		
Property patientIdentifierList As %String(TRUNCATE = 1);
/// occupation	string	否	职业	 	农民
Property occupation As %String(TRUNCATE = 1);
/// birthDate	string	是	出生日期(格式 yyyy-MM-dd)	 	2017-11-28
Property birthDate As %String(TRUNCATE = 1);
/// age	string	是	年龄	 	30
Property age As %String(TRUNCATE = 1);
/// reservedParentIdentifierTypeId	int	否	患者ID类型(1-预留2-预留3-身份证号)		3
Property reservedParentIdentifierTypeId As %String(TRUNCATE = 1);
/// reservedParentIdentifier	string	否	预留家长身份证Id		110111188605069875
Property reservedParentIdentifier As %String(TRUNCATE = 1);
/// reservedParentName	string	否	预留家长姓名		张三
Property reservedParentName As %String(TRUNCATE = 1);

/// 患者在院内系统开立的就诊标识列表就诊标识列表响应参数
Property patientIdentifierList As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.patientcard(XMLITEMNAME = "ones", XMLNAME = "patientIdentifierList", XMLPROJECTION = "COLLECTION");

}