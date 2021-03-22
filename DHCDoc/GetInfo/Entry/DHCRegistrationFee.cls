Class DHCDoc.GetInfo.Entry.DHCRegistrationFee Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 挂号流水表ID
Property ID As %String(TRUNCATE = 1);

/// 就诊表ID
Property RegfeeAdmDr As %String(TRUNCATE = 1);

/// ***?
Property RegfeeArcDr As %String(TRUNCATE = 1);

/// 挂号总费用
Property RegfeeArcPrice As %String(TRUNCATE = 1);

/// ***?目前默认 No
Property RegfeeBespFlag As %String(TRUNCATE = 1);

/// 挂号日期
Property RegfeeDate As %String(TRUNCATE = 1);

/// 挂号科室 (取自CT_Loc)
Property RegfeeDepDr As %String(TRUNCATE = 1);

/// 挂号科室Code
Property RegfeeDepCode As %String(TRUNCATE = 1);

/// 挂号科室描述
Property RegfeeDepDesc As %String(TRUNCATE = 1);

/// ***?
Property RegfeeDoFlag As %String(TRUNCATE = 1);

/// 挂号医生 (取自CT_Careprov)
Property RegfeeDocDr As %String(TRUNCATE = 1);

/// 挂号医生Code
Property RegfeeDocCode As %String(TRUNCATE = 1);

/// 挂号医生Desc
Property RegfeeDocDesc As %String(TRUNCATE = 1);

/// 诊查费
Property RegfeeLookPrice As %String(TRUNCATE = 1);

/// 患者姓名
Property RegfeeName As %String(TRUNCATE = 1);

/// 排号
Property RegfeeNo As %String(TRUNCATE = 1);

/// ***?
Property RegfeePrint As %String(TRUNCATE = 1);

/// 排班记录
Property RegfeeRBASDr As %String(TRUNCATE = 1);

/// 诊室 (取自PAC_Room)
Property RegfeeRoomDr As %String(TRUNCATE = 1);

/// 诊室Code
Property RegfeeRoomCode As %String(TRUNCATE = 1);

/// 诊室描述
Property RegfeeRoomDesc As %String(TRUNCATE = 1);

/// 就诊号级别 (取自RBC_SessionType)
Property RegfeeSessionTypeDr As %String(TRUNCATE = 1);

/// 就诊号级别Code
Property RegfeeSessionTypeCode As %String(TRUNCATE = 1);

/// 就诊号级别描述
Property RegfeeSessionTypeDesc As %String(TRUNCATE = 1);

/// 挂号时间
Property RegfeeTime As %String(TRUNCATE = 1);

/// 时段 (取自DHC_TimeRange)
Property RegfeeTimeRangeDr As %String(TRUNCATE = 1);

/// 时段Code
Property RegfeeTimeRangeCode As %String(TRUNCATE = 1);

/// 时段描述
Property RegfeeTimeRangeDesc As %String(TRUNCATE = 1);

/// 操作人(取自SS_User)
Property RegfeeUserDr As %String(TRUNCATE = 1);

/// 操作人Code
Property RegfeeUserCode As %String(TRUNCATE = 1);

/// 操作人描述
Property RegfeeUserDesc As %String(TRUNCATE = 1);

/// 发票RowId
Property Regfeetemp1 As %String(TRUNCATE = 1);

/// ***?
Property Regfeetemp2 As %String(TRUNCATE = 1);

/// 转诊纪录
Property RegTransferFlag As %String(TRUNCATE = 1);

/// 转诊医生(取自CT_Careprov)
Property RegTransferReDoc As %String(TRUNCATE = 1);

/// 转诊医生Code
Property RegTransferReDocCode As %String(TRUNCATE = 1);

/// 转诊医生Desc
Property RegTransferReDocDesc As %String(TRUNCATE = 1);

/// 医保挂号关联insu_divide表ID
Property RegfeeInsuAdmDr As %String(TRUNCATE = 1);

/// 现金支付(医保)
Property RegfeeInsuCash As %String(TRUNCATE = 1);

/// 账户支付(医保)
Property RegfeeInsuCount As %String(TRUNCATE = 1);

/// 基金支付(医保)
Property RegfeeInsuFund As %String(TRUNCATE = 1);

/// 统筹支付(医保)
Property RegfeeInsuOverallPlanning As %String(TRUNCATE = 1);

/// 其他支付(医保)
Property RegfeeInsuOther As %String(TRUNCATE = 1);

/// 保险公司(保险)
Property RegfeeInsuCoDR As %String(TRUNCATE = 1);

/// 自付比例(保险)
Property RegfeeInsuCoProDR As %String(TRUNCATE = 1);

/// 自负比例付款金额(保险)
Property RegfeeInsuCoPatPay As %String(TRUNCATE = 1);

/// 打印用户指针(指向SS_User)
Property RegfeePrintUserDR As %String(TRUNCATE = 1);

/// 打印用户Code
Property RegfeePrintUserCode As %String(TRUNCATE = 1);

/// 打印用户描述
Property RegfeePrintUserDesc As %String(TRUNCATE = 1);

/// 打印日期
Property RegfeePrintDate As %String(TRUNCATE = 1);

/// 打印时间
Property RegfeePrintTime As %String(TRUNCATE = 1);

/// 取票结算关联指针(指向DHC_INVPRTReports)
Property RegfeeInvReportDR As %String(TRUNCATE = 1);

/// 取票结算用户指针(指向SS_User)
Property RegfeeHandinUserDR As %String(TRUNCATE = 1);

/// 取票结算用户Code
Property RegfeeHandinUserCode As %String(TRUNCATE = 1);

/// 取票结算用户描述
Property RegfeeHandinUserDesc As %String(TRUNCATE = 1);

/// 取票结算日期
Property RegfeeHandinDate As %String(TRUNCATE = 1);

/// 取票结算时间
Property RegfeeHandinTime As %String(TRUNCATE = 1);

/// 预约方式来源的序号,用于在挂号重新排序后的序号.适用不改变原来的序号规则,重新产生客户化的排序序号
Property RegfeeMethodSeqNo As %String;

/// 交易流水号,用于第三方接口的交易流水号存储
Property RegfeeTransactionId As %String;

}
