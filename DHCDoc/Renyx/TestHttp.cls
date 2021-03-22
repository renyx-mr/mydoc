Class DHCDoc.Renyx.TestHttp Extends %RegisteredObject
{

ClassMethod Test()
{
}

/// w ##class(DHCDoc.Renyx.TestHttp).test1()
ClassMethod test1()
{
	set $Ztrap="Exception"
	s tResponse=##class(%Net.HttpRequest).%New()
	set tmpInput=##class(%GlobalCharacterStream).%New()
	//set json = "{""patientIdTypeId"":""3"",""patientId"":""130282199208220025"",""patientFamilyName"":""张"",""patientGivenName"":""硕"",""patientFullName"":""张硕"",""saleOrderGroupId"":""4097""}"
	set json = "{""patientIdTypeId"":3,""patientId"":""110109198711290011"",""patientHisId"":""P100010001"",""patientName"":""王冰"",""patientGenderTypeId"":""4"",""patientMobileNumber"":""13810067362"",""healthCardId"":""A4E0374BCBEAB40E4D66AB5078B44XXX"",""contextTypeId"":3}"
	do tmpInput.Write(json)
	//Set tResponse.Server="https://dev2.unihealths.com"
	set tResponse.Server="dev1.unihealths.com"
	//Set tResponse.Port="443"
	//set tResponse.Https="true"
	set tResponse.Https=1
	set tResponse.SSLConfiguration="SSLClient"
	//set tResponse.Authorization="Presc"
	;do tResponse.SetHeader("Authorization","Basic YWRtaW46Y3hJUXhUSFZ2SXI1ZFlSRw==")
	do tResponse.SetHeader("Authorization","Basic YWRtaW46bGZpZGJ3ZWU=")
	Do tResponse.ContentTypeSet("application/json")
	s tResponse.SSLCheckServerIdentity = 0
	Do tResponse.EntityBody.CopyFrom(tmpInput)
	Set tResponse.Timeout=5
	b ; 2
	do tResponse.Post("/CT-TestDemo/XHealthWebService/incoming/patient/complex/createPatient")
	b ; 11
	
	s XML=tResponse.HttpResponse.Data
	b ;;;;;123
	do XML.OutputToDevice()
	Quit 1
Exception
	Quit $ze
}

}
