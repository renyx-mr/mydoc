/// DHCDoc.GanSuProvincialPlatform.SelRegService
Class DHCDoc.GanSuProvincialPlatform.SelRegService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "GSSelRegService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO: 获取院内科室相关信息
Method GetDeptInfo(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetDeptInfo(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 获取院内医生相关信息
Method GetDocInfo(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetDocInfo(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 获取医院排班相关信息
Method GetScheduledInfo(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetScheduledInfo(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 获取医院排班分时段相关信息
Method GetScheduledTime(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetScheduledTime(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 预约请求接口
Method ExecOrderConfirm(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecOrderConfirm(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 预约取消接口
Method ExecOrderCancel(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecOrderCancel(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 预约记录查询接口
Method GetOrderList(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetOrderList(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 获取医院当日排班相关信息
Method GetRegisterInfo(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetRegisterInfo(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 获取医院当日排班分时段相关信息
Method GetRegisterTime(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetRegisterTime(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 当日挂号锁号接口
Method ExecLockConfirm(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecLockConfirm(XMLRequest)
	;do rtn.XMLExportToStream(.OutputStream,"Response")
	;quit OutputStream
}

/// TODO: 当日挂号解锁接口
Method ExecUnlockCancel(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecUnlockCancel(XMLRequest)
}

/// TODO: 当日挂号请求接口
Method ExecRegisterConfirm(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecRegisterConfirm(XMLRequest)
}

/// TODO: 当日挂号取消接口
Method ExecRegisterCancel(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).ExecRegisterCancel(XMLRequest)
}

/// TODO: 当日挂号记录查询接口
Method GetRegisterList(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetRegisterList(XMLRequest)
}

/// TODO: 获取医院排班停诊相关信息
Method GetScheduledStop(XMLRequest As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.GanSuProvincialPlatform.SelRegMethod).GetScheduledStop(XMLRequest)
}

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

}
