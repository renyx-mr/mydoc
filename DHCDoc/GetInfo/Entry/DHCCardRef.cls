Class DHCDoc.GetInfo.Entry.DHCCardRef Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 卡表ID
Property CFRowID As %String(TRUNCATE = 1);

/// 账户表ID指针(指向DHC_AccManager)
Property CFAccNoDR As %String(TRUNCATE = 1);

/// 卡号
Property CFCardNo As %String(TRUNCATE = 1);

/// 卡校验码
Property CFSecurityNO As %String(TRUNCATE = 1);

/// 病人ID(取自PA_Patmas)
Property CFPAPMIDR As %String(TRUNCATE = 1);

/// 证件号
Property CFIDCardNo As %String(TRUNCATE = 1);

/// 患者登记号
Property CFPAPMINo As %String(TRUNCATE = 1);

/// 建卡日期
Property CFDate As %String(TRUNCATE = 1);

/// 建卡时间
Property CFTime As %String(TRUNCATE = 1);

/// 建卡人(取自SS_User)
Property CFUserDR As %String(TRUNCATE = 1);

/// 建卡人Code
Property CFUserCode As %String(TRUNCATE = 1);

/// 建卡人描述
Property CFUserDesc As %String(TRUNCATE = 1);

/// 卡有效标志
Property CFActiveFlag As %String(TRUNCATE = 1);

/// 卡有效开始日期
Property CFDateFrom As %String(TRUNCATE = 1);

/// 卡有效截止日期
Property CFDateTo As %String(TRUNCATE = 1);

/// 卡无效操作日期
Property CFCancleDate As %String(TRUNCATE = 1);

/// 卡无效操作时间
Property CFCancleTime As %String(TRUNCATE = 1);

/// 卡无效操作人(取自SS_User)
Property CFCancleUserDR As %String(TRUNCATE = 1);

/// 卡无效操作人Code
Property CFCancleUserCode As %String(TRUNCATE = 1);

/// 卡无效操作人描述
Property CFCancleUserDesc As %String(TRUNCATE = 1);

/// 卡类型指针(指向DHC_CardTypeDef)
Property CFCardTypeDR As %String(TRUNCATE = 1);

/// 卡类型Code
Property CFCardTypeCode As %String(TRUNCATE = 1);

/// 卡类型描述
Property CFCardTypeDesc As %String(TRUNCATE = 1);

/// 卡关联发票ID指针(指向DHC_CardINVPRT)
Property CFCardINVPRTDR As %String(TRUNCATE = 1);

/// 发票类型
Property CFFareType As %String(TRUNCATE = 1);

/// CF_BankSignFlag 0未签约  1签约
Property CFBankSignFlag As %String(TRUNCATE = 1);

/// CF_BankCode 按照规定 工 01； 农 02； 中 03； 建 04  往后排
Property CFBankCode As %String(TRUNCATE = 1);

/// 状态变化记录
Property StatusChangeList As list Of DHCDoc.GetInfo.Entry.DHCCardStatusChange;

}
