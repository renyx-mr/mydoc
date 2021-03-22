Class DHCDoc.Interface.Outside.OrganizationUnit.Factory.Base Extends %RegisteredObject
{

Property code As %Decimal [ Private ];

Method codeGet() As %Decimal [ ServerOnly = 1 ]
{
	s code=i%code
	Quit code
}

Method codeSet(Arg As %Decimal) As %Status [ ServerOnly = 1 ]
{
	s ..code=Arg
	Quit $$$OK
}

Method GetResult() [ Abstract ]
{
	Q ""
}

}
