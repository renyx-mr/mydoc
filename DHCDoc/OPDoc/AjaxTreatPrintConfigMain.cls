Class DHCDoc.OPDoc.AjaxTreatPrintConfigMain Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetTreatPIdConfigData")
	{
  		w ..GetTreatPIdConfigData()
  		
	}
   if (action = "RemoveTreatPrintConfigData")
	{
		w ..RemoveTreatPrintConfigData()	
	}
	if (action="IsActive")
	{
		w ..IsActive()	
	}
	Quit $$$OK
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).GetTreatPIdConfigData()     
ClassMethod GetTreatPIdConfigData() As %String
{
	s json="["_"{""id"":"""_0_""",""des"":"""_"无"_"""}"
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="SELECT TreatPrintMainID, DirectoryName FROM SQLUser.DocCFTreatPrintMainInfo where PId=0 "
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
		//if count>0 s json=json_","
		s json=json_","
		s json=json_"{""id"":"""_result.Data("TreatPrintMainID")_""",""des"":"""_result.Data("DirectoryName")_"""}"
		s count=count+1
	}
	q json_"]"
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:保存配置数据
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).SaveTreatPrintConfigData() 
ClassMethod SaveTreatPrintConfigData(Str As %String) As %String
{
	s ^tempscl("str")=Str
	s selID=$p(Str,$c(1),1)
	s PId=$p(Str,$c(1),2)
	s DirectoryName = $p(Str,$c(1),3)
	s ElementId     = $p(Str,$c(1),4)
	s Value         = $p(Str,$c(1),5)
	s noCheckbox    = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),6))
	s CheckAble     = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),7))
	s IsExpand      = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),8))
	s ExpandMethodForLoadingTable = $p(Str,$c(1),9)
	s IsSendMessage = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),10))
	s IconStyle     = $p(Str,$c(1),11)
	s FontStyle     = $p(Str,$c(1),12)
	s ClickEvent    = $p(Str,$c(1),13)
	s URLObject     = $p(Str,$c(1),14)
	s URLStyle      = $p(Str,$c(1),15)
	s IconExpression= $p(Str,$c(1),16)
	s PreviewXMLName= $p(Str,$c(1),17)
	s PrintMethod   = $p(Str,$c(1),18)
	if (selID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFTreatPrintMainInfo)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
		&SQL(INSERT INTO SQLUser.DocCFTreatPrintMainInfo (PId, DirectoryName, ElementId, Value, DisplayNum, noCheckbox, CheckAble, 
	 IsActive, IsExpand, ExpandMethodForLoadingTable, IsSendMessage, IconStyle, FontStyle, ClickEvent, URLObject, URLStyle, IconExpression, PreviewXMLName, PrintMethod) 
		values (:PId,:DirectoryName,:ElementId,:Value,:DisplayNum,:noCheckbox,:CheckAble,'1',:IsExpand,:ExpandMethodForLoadingTable,:IsSendMessage,:IconStyle,
		:FontStyle,:ClickEvent,:URLObject,:URLStyle,:IconExpression,:PreviewXMLName,:PrintMethod))
	}else{
		&SQL(Update SQLUser.DocCFTreatPrintMainInfo set PId=:PId,DirectoryName=:DirectoryName,ElementId=:ElementId,Value=:Value,noCheckbox=:noCheckbox,
		CheckAble=:CheckAble,IsExpand=:IsExpand,ExpandMethodForLoadingTable=:ExpandMethodForLoadingTable,IsSendMessage=:IsSendMessage,IconStyle=:IconStyle,
		FontStyle=:FontStyle,ClickEvent=:ClickEvent,URLObject=:URLObject,URLStyle=:URLStyle,IconExpression=:IconExpression,PreviewXMLName=:PreviewXMLName,PrintMethod=:PrintMethod
		 WHERE TreatPrintMainID=:selID)
	}
	q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).RemoveTreatPrintConfigData() 
ClassMethod RemoveTreatPrintConfigData(Str As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		s nowdt=+$h
		&SQL(Update SQLUser.DocCFTreatPrintMainInfo set DisplayNum=:index WHERE TreatPrintMainID=:ID)
	}
	Q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-27
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).IsActive() 
ClassMethod IsActive(ID As %String, IsActive As %String) As %String
{
	&SQL(Update SQLUser.DocCFTreatPrintMainInfo set IsActive=:IsActive WHERE TreatPrintMainID=:ID)
	q SQLCODE
}

}
