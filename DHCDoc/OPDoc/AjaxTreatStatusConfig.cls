Class DHCDoc.OPDoc.AjaxTreatStatusConfig Extends %CSP.Page
{

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfig).GetTreatStatusConfigData()     
ClassMethod GetTreatStatusConfigData() As %String
{
	
	s jsonitem=""
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="select b.CSPname,a.TreatStatusConfigID AS RowId,a.toolId,a.name,a.DisplayNum,a.IsVisible,a.IsActive,a.iconStyle,a.iconRoute,a.customStyle, "
   			 _"a.URLconfig,a.statusChangeHandler,a.clickHandler,a.herSplitLine,a.verSplitLine from SQLUser.DocCFTreatStatusInfo a "
			 _"LEFT JOIN SQLUser.DocCFTreatStatusMainInfo b ON a.TreatStatusConfigMainID=b.TreatStatusConfigMainID "
	s sortStr="  ORDER BY a.DisplayNum"
	s sqlBase=sortStr_sqlBase
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
	    s count=count+1
		s jsonitem=jsonitem_"{""RowId"":"""_result.Data("RowId")_""",""CSPname"":"""_result.Data("CSPname")_""",""toolId"":"""_result.Data("toolId")_""",""name"":"""_result.Data("name")_""",""DisplayNum"":"""_result.Data("DisplayNum")_""",""IsVisible"":"""_result.Data("IsVisible")_""",""IsActive"":"""_result.Data("IsActive")_""",""iconStyle"":"""_result.Data("iconStyle")_""",""iconRoute"":"""_result.Data("iconRoute")_""",""customStyle"":"""_result.Data("customStyle")_""",""URLconfig"":"""_result.Data("URLconfig")_""",""statusChangeHandler"":"""_result.Data("statusChangeHandler")_""",""clickHandler"":"""_result.Data("clickHandler")_""",""herSplitLine"":"""_result.Data("herSplitLine")_""",""verSplitLine"":"""_result.Data("verSplitLine")_"""},"
	}
	i jsonitem'="" d
	.s jsonitem=$E(jsonitem,1,$L(jsonitem)-1) 
	.s json="{""total"":"""_count_""",""rows"":["_jsonitem_"]}"
	e  d
	.s json="{""total"":""0"",""rows"":[]}"
	;s json="[{""DT_RowId"":"""",""CSPname"":"""",""CSPname"":"""",""Code"":"""",""DisplayNum"":"""",""ExecuteCode"":"""",""Style"":"""",""Link"":"""",""Operator"":"""",""OprDate"":"""",""IsActive"":""""}]"
	q json
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfig).RemoveTreatStatusConfigData() 
ClassMethod RemoveTreatStatusConfigData(Str As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		&SQL(Update SQLUser.DocCFTreatStatusInfo set DisplayNum=:index WHERE TreatStatusConfigID=:ID)
	}
	Q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfig).IsActive() 
ClassMethod IsActive(ID As %String, IsActive As %String) As %String
{
	&SQL(Update SQLUser.DocCFTreatStatusInfo set IsActive=:IsActive WHERE TreatStatusConfigID=:ID)
	q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfig).IsVisible() 
ClassMethod IsVisible(ID As %String, IsVisible As %String) As %String
{
	&SQL(Update SQLUser.DocCFTreatStatusInfo set IsVisible=:IsVisible WHERE TreatStatusConfigID=:ID)
	q SQLCODE
}

ClassMethod DelTreatStatusConfigData(ID As %String) As %String
{
	&SQL(delete SQLUser.DocCFTreatStatusInfo where TreatStatusConfigID=:ID)
	q SQLCODE
}

ClassMethod SaveTreatStatusConfigData(cspId As %String, Str As %String) As %String
{
	s ID=$p(Str,$C(1),1)
	s toolId=$p(Str,$C(1),2)
	s name=$p(Str,$C(1),3)
	s iconStyle=$p(Str,$C(1),4)
	s iconRoute=$p(Str,$C(1),5)
	s customStyle=$p(Str,$C(1),6)
	s URLconfig=$p(Str,$C(1),7)
	s statusChangeHandler=$p(Str,$C(1),8)
	s clickHandler=$p(Str,$C(1),9)
	s herSplitLine=$p(Str,$C(1),10)
	s verSplitLine=$p(Str,$C(1),11)
	s activeStatus=$p(Str,$C(1),12)
	s disableStatus=$p(Str,$C(1),13)
	if (ID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFTreatStatusInfo)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
	    
		&SQL(INSERT INTO SQLUser.DocCFTreatStatusInfo (TreatStatusConfigMainID,toolId,name,DisplayNum,IsVisible,IsActive,iconStyle,
			iconRoute,customStyle,URLconfig,statusChangeHandler,clickHandler,herSplitLine,verSplitLine,activeStatus,disableStatus) 
		values (:cspId,:toolId,:name,:DisplayNum,'1','1',:iconStyle,:iconRoute,:customStyle,:URLconfig,:statusChangeHandler,
		:clickHandler,:herSplitLine,:verSplitLine,:activeStatus,:disableStatus))
	}else{
		&SQL(Update SQLUser.DocCFTreatStatusInfo set toolId=:toolId,name=:name,iconStyle=:iconStyle,iconRoute=:iconRoute,customStyle=:customStyle,URLconfig=:URLconfig,statusChangeHandler=:statusChangeHandler,
		clickHandler=:clickHandler,herSplitLine=:herSplitLine,verSplitLine=:verSplitLine,activeStatus=:activeStatus,disableStatus=:disableStatus WHERE TreatStatusConfigID=:ID)
	}
	q SQLCODE
}

}
