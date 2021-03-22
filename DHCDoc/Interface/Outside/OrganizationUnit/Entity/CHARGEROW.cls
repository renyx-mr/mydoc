Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.CHARGEROW Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医生列表
Property ROW As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.Row(XMLNAME = "ROW", XMLPROJECTION = "ELEMENT");

}
