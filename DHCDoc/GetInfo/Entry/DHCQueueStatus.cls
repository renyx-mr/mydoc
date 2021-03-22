Class DHCDoc.GetInfo.Entry.DHCQueueStatus Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 状态变化表ID
Property QSRowId As %String(TRUNCATE = 1);

/// 状态改变日期
Property QSDate As %String(TRUNCATE = 1);

/// 状态改变时间
Property QSTime As %String(TRUNCATE = 1);

/// 状态改变医生指针(指向CT_CareProv)
Property QSDocDr As %String(TRUNCATE = 1);

/// 状态改变医生Code
Property QSDocCode As %String(TRUNCATE = 1);

/// 状态改变医生描述
Property QSDocDesc As %String(TRUNCATE = 1);

/// 改变后状态指针(指向DHC_PerState)
Property QSStatus As %String(TRUNCATE = 1);

/// 改变后状态Code
Property QSStatusCode As %String(TRUNCATE = 1);

/// 改变后状态描述
Property QSStatusDesc As %String(TRUNCATE = 1);

/// 状态改变操作人指针(指向SS_User)
Property QSUpUserID As %String(TRUNCATE = 1);

/// 状态改变操作人Code
Property QSUpUserCode As %String(TRUNCATE = 1);

/// 状态改变操作人描述
Property QSUpUserDesc As %String(TRUNCATE = 1);

}
