Class DHCDoc.GetInfo.Entry.DHCCardStatusChange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 状态变化表ID
Property CSCRowID As %String(TRUNCATE = 1);

/// 插入日期
Property CSCDate As %String(TRUNCATE = 1);

/// 插入时间
Property CSCTime As %String(TRUNCATE = 1);

/// 卡状态
Property CSCCurStatus As %String(TRUNCATE = 1);

/// 操作人(取自SS_User)
Property CSCUserDR As %String(TRUNCATE = 1);

/// 操作人Code
Property CSCUserCode As %String(TRUNCATE = 1);

/// 操作人描述
Property CSCUserDesc As %String(TRUNCATE = 1);

/// 操作电脑名称
Property CSCComputerIP As %String(TRUNCATE = 1);

/// 备注1
Property CSCNote1 As %String(TRUNCATE = 1);

/// 备注2
Property CSCNote2 As %String(TRUNCATE = 1);

/// 备注3
Property CSCNote3 As %String(TRUNCATE = 1);

/// 备注4
Property CSCNote4 As %String(TRUNCATE = 1);

/// 备注5
Property CSCNote5 As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人姓名
Property CSCRLName As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人证件号
Property CSCRLCredNo As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人地址
Property CSCRLAddress As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人联系电话
Property CSCRLPhoneNo As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人单据号码
Property CSCRLProof As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人备注
Property CSCRLRemark As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人证件类型指针(指向DHC_CredType)
Property CSCCredType As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人证件类型Code
Property CSCCredTypeCode As %String(TRUNCATE = 1);

/// 挂失、换卡、补卡、退卡人证件类型描述
Property CSCCredTypeDesc As %String(TRUNCATE = 1);

}
