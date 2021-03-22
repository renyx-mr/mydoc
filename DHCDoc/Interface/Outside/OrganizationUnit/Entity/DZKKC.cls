Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.DZKKC Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// PatientMsg
Property PatientMsg As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.PatientMsg(XMLITEMNAME = "PatientMsg", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

/// FeeMsg
Property FeeMsg As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.FeeMsg(XMLITEMNAME = "FeeMsg", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

}
