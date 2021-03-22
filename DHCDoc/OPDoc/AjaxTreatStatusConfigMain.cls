Class DHCDoc.OPDoc.AjaxTreatStatusConfigMain Extends %CSP.Page
{

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfigMain).GetConfigData()     
ClassMethod GetConfigData() As %String
{
	
	s jsonitem=""
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="SELECT TreatStatusConfigMainID AS Rowid, CSPname, DefiDesc, IsActive FROM SQLUser.DocCFTreatStatusMainInfo"
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
	    s count=count+1
		s jsonitem=jsonitem_"{""Rowid"":"""_result.Data("Rowid")_""",""CSPname"":"""_result.Data("CSPname")_""",""DefiDesc"":"""_result.Data("DefiDesc")_""",""IsActive"":"""_result.Data("IsActive")_"""},"
	}
	i jsonitem'="" d
	.s jsonitem=$E(jsonitem,1,$L(jsonitem)-1) 
	.s json="{""total"":"""_count_""",""rows"":["_jsonitem_"]}"
	e  d
	.s json="{""total"":""0"",""rows"":[]}"
	;s json="[{""Rowid"":"""",""Code"":"""",""CSPname"":"""",""DefiDesc"":"""",""IsActive"":""""}]"
	q json
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:修改病人显示配置数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfigMain).AddConfigData("CSP,101,测试") 
ClassMethod AddConfigData() As %String
{
	s Code     = $Get(%request.Data("Code",1),"")
	s CSPname  = $Get(%request.Data("CSPname",1),"")
	s DefiDesc = $Get(%request.Data("DefiDesc",1),"")
	s IsActive = $Get(%request.Data("IsActive",1),"")

	&SQL(INSERT INTO SQLUser.DocCFTreatStatusMainInfo (CSPname,DefiDesc,IsActive) values (:CSPname,:DefiDesc,'1'))
	q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfigMain).UpdateConfigData() 
///  TreatStatusConfigMainCode, CSPname, DefiDesc, IsActive
ClassMethod UpdateConfigData() As %String
{
	s selID = $Get(%request.Data("selID",1),"")
	q:selID="" "1"
	s CSPname  = $Get(%request.Data("CSPname",1),"")
	s DefiDesc = $Get(%request.Data("DefiDesc",1),"")
	
	&SQL(Update SQLUser.DocCFTreatStatusMainInfo set CSPname=:CSPname,DefiDesc=:DefiDesc WHERE TreatStatusConfigMainID=:selID)
	q SQLCODE
}

ClassMethod SaveConfigData(Str)
{
	s ID=$p(Str,$C(1),1)
	s CSPname=$p(Str,$C(1),2)
	s DefiDesc=$p(Str,$C(1),3)
	if (ID=""){
		&SQL(INSERT INTO SQLUser.DocCFTreatStatusMainInfo (CSPname,DefiDesc,IsActive) values (:CSPname,:DefiDesc,'1'))
	}else{
		&SQL(Update SQLUser.DocCFTreatStatusMainInfo set CSPname=:CSPname,DefiDesc=:DefiDesc WHERE TreatStatusConfigMainID=:ID)
	}
	q SQLCODE
}

ClassMethod DelConfigData(ID As %String) As %String
{
	&SQL(delete SQLUser.DocCFTreatStatusMainInfo where TreatStatusConfigMainID=:ID)
	q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatStatusConfigMain).IsActive() 
ClassMethod IsActive(ID As %String, IsActive As %String) As %String
{
	&SQL(Update SQLUser.DocCFTreatStatusMainInfo set IsActive=:IsActive WHERE TreatStatusConfigMainID=:ID)
	q SQLCODE
}

}
