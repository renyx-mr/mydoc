Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.common Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 响应返回码（0 成功、 1失败）
Property responseCode As %String(TRUNCATE = 1);

/// 相应返回码描述
Property respongseText As %String(TRUNCATE = 1);

/// 服务器当前时间戳（从1970-01-01 00:00:00到当前时间的毫秒数
Property responseTimestamp As %String(TRUNCATE = 1);

/// 科室列表
Property DeptData As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.department(XMLITEMNAME = "onedept", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

/// 医生列表
Property DoctorData As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.doctor(XMLITEMNAME = "onedoc", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

/// 排班列表
Property ScheduleData As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule(XMLITEMNAME = "onedoc", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

/// 预约登记
Property AppointData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.appoint(XMLNAME = "data");

/// 预约登记信息列表(单个)
Property AppointListData1 As DHCDoc.Interface.Outside.OrganizationUnit.Entity.appointList1(XMLNAME = "data");

/// 预约登记信息列表
Property AppointListData As list Of DHCDoc.Interface.Outside.OrganizationUnit.Entity.appointList(XMLITEMNAME = "one", XMLNAME = "data", XMLPROJECTION = "COLLECTION");

/// 更新预约登记信息
Property UpdateAppointData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.updappoint(XMLNAME = "data");

/// 获取预约账单信息
Property AppointBillData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.appbillinfo(XMLNAME = "data");

/// 挂号缴费更新账单信息
Property RegBillData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.appbill(XMLNAME = "data");

/// 获取退费账单号信息
Property RefBillData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.getrefundbillno(XMLNAME = "data");

/// 获取患者信息
Property PatientData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.getpatient(XMLNAME = "data");

/// 患者信息建档
Property SavePatientData As DHCDoc.Interface.Outside.OrganizationUnit.Entity.savepatient(XMLNAME = "data");

Property ScheduleData1 As DHCDoc.Interface.Outside.OrganizationUnit.Entity.schedule(XMLNAME = "data");

}
