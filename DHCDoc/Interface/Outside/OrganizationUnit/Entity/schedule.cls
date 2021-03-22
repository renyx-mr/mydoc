Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 排班 Id（院内系统）
Property scheduleId As %String(TRUNCATE = 1);

/// 出诊日期（格式 yyyyMM-dd）
Property scheduleDate As %String(TRUNCATE = 1);

/// 预约开始时间（格式 hh:mm:ss)
Property scheduleStartTime As %String(TRUNCATE = 1);

/// 预约结束时间（格式 hh:mm:ss)
Property scheduleEndTime As %String(TRUNCATE = 1);

/// 医生 Id（院内系统）
Property providerId As %String(TRUNCATE = 1);

/// 医生所属科室 Id（院内系统）
Property departmentId As %String(TRUNCATE = 1);

/// 患者支付费用（元）
Property patientCharge As %String(TRUNCATE = 1);

/// 总号源数
Property totalCount As %String(TRUNCATE = 1);

/// 剩余号源数
Property availableCount As %String(TRUNCATE = 1);

/// 挂号类别（1 和 2 作为预留，暂不使用，3 普通、 4 专家、 5 特需）
Property appointmentTypeId As %String(TRUNCATE = 1);

/// 是否停诊（false 否 true 是）
Property isOutOfService As %String(TRUNCATE = 1);

/// 附加信息，如专科名
Property comment As %String(TRUNCATE = 1);

}
