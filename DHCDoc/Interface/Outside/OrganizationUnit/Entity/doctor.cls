Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.doctor Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医生 Id（院内系统） 1001
Property providerId As %String(TRUNCATE = 1);

/// 医生姓氏 扁
Property providerFamilyName As %String(TRUNCATE = 1);

/// 医生名 鹊
Property providerGivenName As %String(TRUNCATE = 1);

/// 医生姓名 扁鹊
Property providerFullName As %String(TRUNCATE = 1);

/// 医生性别（1 未知、 2其它、 3 女、 4 男）
Property providerGenderTypeId As %String(TRUNCATE = 1);

/// 医生身份证号 11011119860
Property providerResidentId As %String(TRUNCATE = 1);

/// 医生工号 20015
Property providerEmployeeId As %String(TRUNCATE = 1);

/// 医生职称（1 预留，暂不使用，2 其它、 3 主任医师、 4 主任中医师、 5 副主任医师、 6副主任中医师、 7 主治医师、 8 主治中医师、9 住院医师、 10 医师、 11 助理医师
Property providerLicenseTypeId As %String(TRUNCATE = 1);

/// 如果providerLicenseTypeId 为 2，则该参数应该有值
Property providerLicenseTypeName As %String(TRUNCATE = 1);

/// 医生介绍
Property providerDescription As %String(TRUNCATE = 1);

/// 医生所属主要执业科室Id（院内系统）
Property primaryDepartmentId As %String(TRUNCATE = 1);

/// 医生擅长（以“|” 作为分隔符
Property providerExpertiseName As %String(TRUNCATE = 1);

}
