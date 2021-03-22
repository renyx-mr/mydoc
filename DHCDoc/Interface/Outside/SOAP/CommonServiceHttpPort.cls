Class DHCDoc.Interface.Outside.SOAP.CommonServiceHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method getPhynumList(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getPhynumList").Invoke($this,"",.in0)
}

Method ishave(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ishave").Invoke($this,"",.in0)
}

Method saveJingmaduRecord(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveJingmaduRecord").Invoke($this,"",.in0)
}

Method saveKangjunyaoRecord(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveKangjunyaoRecord").Invoke($this,"",.in0)
}

Method saveOperation(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveOperation").Invoke($this,"",.in0)
}

Method savePhysician(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("savePhysician").Invoke($this,"",.in0)
}

Method saveRecord(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveRecord").Invoke($this,"",.in0)
}

Method saveShoumaRecord(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveShoumaRecord").Invoke($this,"",.in0)
}

/// Non-default attributeFormQualified for types XML namespace.
Parameter ATTRIBUTEQUALIFIED = 1;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.3:8080/services/CommonService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.physician.dtoa.dhcc.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "CommonService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
