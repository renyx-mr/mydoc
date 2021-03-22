Class DHCDoc.Interface.Outside.OrganizationUnit.Entity.appbillinfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 预约记录 Id（院内系统
Property appointmentId As %String(TRUNCATE = 1);

/// 账单号 P2019011812352412
Property billNumber As %String(TRUNCATE = 1);

/// 支付状态（1 和2 作为预留， 暂不使用， 3 等待支付、 4 支付中、 5 支付成功、 6 支付失败、 7 支付已取消、 8 已申请退款、 9 退款处理中、 10 退款成功、 11 退款失败、 12 退款已取消）
Property billStatusId As %String(TRUNCATE = 1);

/// 账单金额（元） 25.00
Property billAmount As %String(TRUNCATE = 1);

/// 账单支付方式
Property paymentMethodId As %String(TRUNCATE = 1);

/// 支付过期日期（格式 yyyyMM-dd）
Property paymentExpirationDate As %String(TRUNCATE = 1);

/// 支付过期时间
Property paymentExpirationTime As %String(TRUNCATE = 1);

/// 记录更新日期
Property updateDate As %String(TRUNCATE = 1);

/// 记录更新时间
Property updateTime As %String(TRUNCATE = 1);

}
