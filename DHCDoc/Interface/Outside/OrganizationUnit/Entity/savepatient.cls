Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.savepatient Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// His患者标识
Property patientHisId As %String(TRUNCATE = 1);

/// His门诊号码
Property outpatientId As %String(TRUNCATE = 1);

}
