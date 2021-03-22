Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.PatientMsg Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 数据批次标识*
Property DATABATCH As %String(TRUNCATE = 1, XMLNAME = "DATA_BATCH");

/// 患者ID*
Property PATIENTID As %String(TRUNCATE = 1, XMLNAME = "PATIENT_ID");

/// 患者本次住院次数*
Property VISITID As %String(TRUNCATE = 1, XMLNAME = "VISIT_ID");

/// 患者名称*
Property NAME As %String(TRUNCATE = 1, XMLNAME = "NAME");

/// 患者性别
Property SEX As %String(TRUNCATE = 1, XMLNAME = "SEX");

/// 年龄
Property AGE As %String(TRUNCATE = 1, XMLNAME = "AGE");

/// 住院号
Property HOSPITALIZEDNO As %String(TRUNCATE = 1, XMLNAME = "HOSPITALIZED_NO");

/// 就诊卡号
Property MEDCARDNO As %String(TRUNCATE = 1, XMLNAME = "MED_CARD_NO");

/// 收费单据号
Property RCPTNO As %String(TRUNCATE = 1, XMLNAME = "RCPT_NO");

/// 病因诊断
Property PATIENTDIAGNOSE As %String(TRUNCATE = 1, XMLNAME = "PATIENT_DIAGNOSE");

/// 手术名称
Property OPERATIONNAME As %String(TRUNCATE = 1, XMLNAME = "OPERATION_NAME");

}
