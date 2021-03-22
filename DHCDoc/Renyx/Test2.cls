Class DHCDoc.Renyx.Test2 Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

/// w ##class(DHCDoc.Renyx.Test2).Test()
ClassMethod Test()
{
	s obj={"true":false}
	//s obj.Tr = ##class(%Library.Boolean).XSDToLogical(1) ;"true"
	//s obj.Tr=1
	d obj.%Set("a",1,"boolean")
	d obj.%Set("b",0,"boolean")
	s obj.tr=3
	s json=obj.%ToJSON()
	//w "{""tr"":true,""TR"":""4""}"
	q json
}

/// d ##class(DHCDoc.Renyx.Test2).Test1()
ClassMethod Test1()
{
	s test1=1
	s test2=2
	s test3=3
	s temp="a("_test1_","_test3_")"
	//s temp="a(test1,test3)"
	x ("(a) s a("_test1_","_test2_")=1",.a)
	x ("(a) s "_temp_"=2",.a)
	zw a
}

/// w ##class(DHCDoc.Renyx.Test2).GetTianQi()
ClassMethod GetTianQi()
{
	s Soap=##class(WeatherWebService.WeatherWebServiceSoap).%New()
	s Soap.Timeout=5
	s Ret=Soap.getSupportCity("12")
	b ;;;12
	q Ret.Read()
}

}
