Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.GZKKC Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// DATABATCH
Property DATABATCH As %String(TRUNCATE = 1, XMLNAME = "DATA_BATCH");

/// CHARGEROW
Property CHARGEROW As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.CHARGEROW(XMLITEMNAME = "CHARGEROW", XMLNAME = "CHARGEROW", XMLPROJECTION = "ELEMENT");

}
