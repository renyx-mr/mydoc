Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.FeeMsg Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 费用明细主键ID*
Property ID As %String(TRUNCATE = 1, XMLNAME = "ID");

/// 收费来源（1门诊，2住院）
Property CHARGESOURCE As %String(TRUNCATE = 1, XMLNAME = "CHARGE_SOURCE");

/// 收费/退费标识（1收费，2退费）*
Property CHARGEFLAG As %String(TRUNCATE = 1, XMLNAME = "CHARGE_FLAG");

/// 申请科室编码*
Property DEPTCODE As %String(TRUNCATE = 1, XMLNAME = "DEPT_CODE");

/// 申请科室名称
Property DEPTNAME As %String(TRUNCATE = 1, XMLNAME = "DEPT_NAME");

/// 执行科室编码*
Property EXECDEPTCODE As %String(TRUNCATE = 1, XMLNAME = "EXEC_DEPT_CODE");

/// 执行科室名称
Property EXECDEPTNAME As %String(TRUNCATE = 1, XMLNAME = "EXEC_DEPT_NAME");

/// 材料消耗科室编码*
Property CONSUMEDEPTCODE As %String(TRUNCATE = 1, XMLNAME = "CONSUME_DEPT_CODE");

/// 开嘱医生编号
Property DOCTORCODE As %String(TRUNCATE = 1, XMLNAME = "DOCTOR_CODE");

/// 开嘱医生名字
Property DOCTORNAME As %String(TRUNCATE = 1, XMLNAME = "DOCTOR_NAME");

/// 发票号
Property INVOICENO As %String(TRUNCATE = 1, XMLNAME = "INVOICE_NO");

/// 项目分类
Property ITEMCLASS As %String(TRUNCATE = 1, XMLNAME = "ITEM_CLASS");

/// 收费项目代码*
Property ITEMCODE As %String(TRUNCATE = 1, XMLNAME = "ITEM_CODE");

/// 收费项目名称*
Property ITEMNAME As %String(TRUNCATE = 1, XMLNAME = "ITEM_NAME");

/// 收费项目规格*
Property ITEMSPEC As %String(TRUNCATE = 1, XMLNAME = "ITEM_SPEC");

/// 单位*
Property UNITS As %String(TRUNCATE = 1, XMLNAME = "UNITS");

/// 单价*
Property PRICE As %String(TRUNCATE = 1, XMLNAME = "PRICE");

/// 数量*
Property AMOUNT As %String(TRUNCATE = 1, XMLNAME = "AMOUNT");

/// 费用*
Property COSTS As %String(TRUNCATE = 1, XMLNAME = "COSTS");

/// 收费时间*
Property FEEDATE As %String(TRUNCATE = 1, XMLNAME = "FEE_DATE");

/// 物资系统产品ID*
Property PRODUCTID As %String(TRUNCATE = 1, XMLNAME = "PRODUCT_ID");

}
