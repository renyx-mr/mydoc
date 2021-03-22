Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.appointList1 Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 预约记录 Id（院内系统
Property appointmentId As %String(TRUNCATE = 1);

/// 预约序列号 1
Property appointmentSerialNumber As %String(TRUNCATE = 1);

/// 挂号类别（1 和 2作为预留， 暂不使用， 3 普通、 4 专家、 5 特需）
Property appointmentTypeId As %String(TRUNCATE = 1);

/// 预约状态（1 和 2作为预留， 暂不使用， 3 已申请预约、 4 已预约、 5已过期、 6 已取消）
Property appointmentStatusId As %String(TRUNCATE = 1);

/// 排班 Id（院内系统）
Property scheduleId As %String(TRUNCATE = 1);

/// 预约日期 yyyy-MM-dd
Property scheduleDate As %String(TRUNCATE = 1);

/// 预约开始时间 hh:mm:ss
Property scheduleStartTime As %String(TRUNCATE = 1);

/// 预约结束时间 hh:mm:ss
Property scheduleEndTime As %String(TRUNCATE = 1);

/// 预约科室 Id
Property departmentId As %String(TRUNCATE = 1);

/// 预约医生 Id 为空说明排班是科室排班，不为空则为医生排班
Property providerId As %String(TRUNCATE = 1);

/// 预约来源（若为环球医疗，则值为“UM”）
Property createSourceKey As %String(TRUNCATE = 1);

/// 预约途径(1 和 2作为预留，暂不使用， 3 Web、 4App-android、 5App-ios、 6Wechat)
Property createSourceTypeId As %String(TRUNCATE = 1);

/// 患者姓氏 张
Property patientFamilyName As %String(TRUNCATE = 1);

/// 患者名 三
Property patientGivenName As %String(TRUNCATE = 1);

/// 患者姓名 张三
Property patientFullName As %String(TRUNCATE = 1);

/// 患者手机号 18811112222
Property patientMobileNumber As %String(TRUNCATE = 1);

/// 患者 Id 类型（1、2、 4 和 5 预留，暂不使用， 3 身份证号,6 电子健康卡）
Property patientIdTypeId As %String(TRUNCATE = 1);

/// 患者 Id
Property patientId As %String(TRUNCATE = 1);

/// 是否可以取消预约 true 是 false
Property isCancellable As %String(TRUNCATE = 1);

/// 记录更新日期
Property updateDate As %String(TRUNCATE = 1);

/// 记录更新时间
Property updateTime As %String(TRUNCATE = 1);

}
