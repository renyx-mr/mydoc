Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.Row Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 住院收费/门诊收费（0/1）
Property ISCLINICS As %String(TRUNCATE = 1, XMLNAME = "ISCLINICS");

/// HIS中的主单ID
Property HISORDERID As %String(TRUNCATE = 1, XMLNAME = "HIS_ORDER_ID");

/// 收费记录明细ID/退费记录明细ID
Property HISDETAILID As %String(TRUNCATE = 1, XMLNAME = "HIS_DETAIL_ID");

/// 计退费标志,0计费，1退费
Property REFUNDSIGN As %String(TRUNCATE = 1, XMLNAME = "REFUND_SIGN");

/// 物资系统耗材唯ID
Property BARCODEID As %String(TRUNCATE = 1, XMLNAME = "BARCODE_ID");

/// 物资系统耗材唯一码
Property BARCODE As %String(TRUNCATE = 1, XMLNAME = "BARCODE");

/// HIS执行科室CODE
Property DEPTCODE As %String(TRUNCATE = 1, XMLNAME = "DEPT_CODE");

/// HIS执行科室名称
Property DEPTNAME As %String(TRUNCATE = 1, XMLNAME = "DEPT_NAME");

/// HIS申请科室CODE
Property APPLICATIONDEPTCODE As %String(TRUNCATE = 1, XMLNAME = "APPLICATION_DEPT_CODE");

/// HIS申请科室名称
Property APPLICATIONDEPTNAME As %String(TRUNCATE = 1, XMLNAME = "APPLICATION_DEPT_NAME");

/// 患者ID
Property PATIENTID As %String(TRUNCATE = 1, XMLNAME = "PATIENT_ID");

/// 住院次数
Property SERIES As %String(TRUNCATE = 1, XMLNAME = "SERIES");

/// 患者编号
Property PATIENTCODE As %String(TRUNCATE = 1, XMLNAME = "PATIENT_CODE");

/// 患者姓名
Property PATIENTNAME As %String(TRUNCATE = 1, XMLNAME = "PATIENT_NAME");

/// 患者性别0未知,1,男,2,女
Property PATIENTSEX As %String(TRUNCATE = 1, XMLNAME = "PATIENT_SEX");

/// 年龄
Property PATIENTAGE As %String(TRUNCATE = 1, XMLNAME = "PATIENT_AGE");

/// 床位号
Property PATIENTBED As %String(TRUNCATE = 1, XMLNAME = "PATIENT_BED");

/// 住院时间
Property INHOSPITALDATE As %String(TRUNCATE = 1, XMLNAME = "IN_HOSPITAL_DATE");

/// 病因诊断
Property PATIENTDIAGNOSE As %String(TRUNCATE = 1, XMLNAME = "PATIENT_DIAGNOSE");

/// 经治医生CODE
Property DOCTORCODE As %String(TRUNCATE = 1, XMLNAME = "DOCTOR_CODE");

/// 经治医生姓名
Property DOCTORNAME As %String(TRUNCATE = 1, XMLNAME = "DOCTOR_NAME");

/// 医疗保险类别代码
Property CHARGETYPE As %String(TRUNCATE = 1, XMLNAME = "CHARGE_TYPE");

/// 医疗保险类别名称
Property CHARGENAME As %String(TRUNCATE = 1, XMLNAME = "CHARGE_NAME");

/// 手术医生编码
Property SURGEONCODE As %String(TRUNCATE = 1, XMLNAME = "SURGEON_CODE");

/// 手术医生姓名
Property SURGEONNAME As %String(TRUNCATE = 1, XMLNAME = "SURGEON_NAME");

/// 开单医生编码
Property BILLDOCTORCODE As %String(TRUNCATE = 1, XMLNAME = "BILL_DOCTOR_CODE");

/// 开单医生姓名
Property BILLDOCTORNAME As %String(TRUNCATE = 1, XMLNAME = "BILL_DOCTOR_NAME");

/// 操作人编码
Property OPERATORCODE As %String(TRUNCATE = 1, XMLNAME = "OPERATOR_CODE");

/// 操作人
Property OPERATORNAME As %String(TRUNCATE = 1, XMLNAME = "OPERATOR_NAME");

/// 主诊组ID
Property CLINICGROUPID As %String(TRUNCATE = 1, XMLNAME = "CLINIC_GROUP_ID");

/// 主诊组名称
Property CLINICGROUPNAME As %String(TRUNCATE = 1, XMLNAME = "CLINIC_GROUP_NAME");

/// 收费金额
Property ACCOUNT As %String(TRUNCATE = 1, XMLNAME = "ACCOUNT");

/// 使用日期
Property USEDDATE As %String(TRUNCATE = 1, XMLNAME = "USED_DATE");

/// 备注
Property REMARK As %String(TRUNCATE = 1, XMLNAME = "REMARK");

/// 创建时间
Property CREATEDATE As %String(TRUNCATE = 1, XMLNAME = "CREATE_DATE");

/// 退费时写入HIS相关收费明细ID，计费时可为空
Property HISUSEDDETAILID As %String(TRUNCATE = 1, XMLNAME = "HIS_USED_DETAIL_ID");

/// 最后有效日期
Property VALIDENDDATE As %String(TRUNCATE = 1, XMLNAME = "VALIDENDDATE");

}
