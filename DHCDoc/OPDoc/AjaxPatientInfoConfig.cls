Class DHCDoc.OPDoc.AjaxPatientInfoConfig Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetPatientInfoConfigData")
	{
  		w ..GetPatientInfoConfigData()
  		
	}
   /*if (action = "AddPatientInfoConfig")
	{
		w ..AddPatientInfoConfig()	
	}
   if (action = "UpdatePatientInfoConfig")
	{
		w ..UpdatePatientInfoConfig()	
	}*/
   if (action = "RemovePatientInfoDisplay")
	{
		w ..RemovePatientInfoDisplay()	
	}
	if (action="IsActive")
	{
		w ..IsActive()	
	}
	Quit $$$OK
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回病人显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxPatientInfoConfig).GetPatientInfoConfigData()     
ClassMethod GetPatientInfoConfigData() As %String
{
	
	s jsonitem=""
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="select ID AS DT_RowId,DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive from SQLUser.DocCFPatientInfo"
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
	    s count=count+1
		s jsonitem=jsonitem_"{""DT_RowId"":"""_result.Data("DT_RowId")_""",""DisplayItem"":"""_result.Data("DisplayItem")_""",""Code"":"""_result.Data("Code")_""",""DisplayNum"":"""_result.Data("DisplayNum")_""",""ExecuteCode"":"""_result.Data("ExecuteCode")_""",""Style"":"""_result.Data("Style")_""",""Link"":"""_result.Data("Link")_""",""Operator"":"""_result.Data("Operator")_""",""OprDate"":"""_result.Data("OprDate")_""",""IsActive"":"""_result.Data("IsActive")_"""},"
	}
	i jsonitem'="" d
	.s jsonitem=$E(jsonitem,1,$L(jsonitem)-1) 
	.s json="{""total"":"""_count_""",""rows"":["_jsonitem_"]}"
	e  d
	.s json="{""total"":""0"",""rows"":[]}"
	;s json="[{""DT_RowId"":"""",""DisplayItem"":"""",""Code"":"""",""DisplayNum"":"""",""ExecuteCode"":"""",""Style"":"""",""Link"":"""",""Operator"":"""",""OprDate"":"""",""IsActive"":""""}]"
	q json
}

ClassMethod SavePatientInfoDisplay(Str As %String, AdmType As %String) As %String
{
	s ID=$p(Str,$C(1),1)
	s DisplayItem=$p(Str,$C(1),2)
	s Code=$p(Str,$C(1),3)
	s ExecuteCode=$p(Str,$C(1),4)
	s Style=$p(Str,$C(1),5)
	s Link=$p(Str,$C(1),6)
	s Operator=$p(Str,$C(1),7)
	s nowdt=+$h
	if (ID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFPatientInfo where AdmType=:AdmType)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
		&SQL(INSERT INTO SQLUser.DocCFPatientInfo (DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive,AdmType) values (:DisplayItem,:Code,:DisplayNum,:ExecuteCode,:Style,:Link,:Operator,:nowdt,'1',:AdmType))
	}else{
		&SQL(Update SQLUser.DocCFPatientInfo set DisplayItem=:DisplayItem,Code=:Code,ExecuteCode=:ExecuteCode,Style=:Style,Link=:Link,Operator=:Operator,OprDate=:nowdt WHERE ID=:ID and AdmType=:AdmType)
	}
	q SQLCODE
}

ClassMethod DelPatientInfoDisplay(ID As %String) As %String
{
	&SQL(delete SQLUser.DocCFPatientInfo where ID=:ID)
	q SQLCODE
}

ClassMethod RemovePatientInfoDisplay(Str As %String, UserID As %String, AdmType As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		s nowdt=+$h
		&SQL(Update SQLUser.DocCFPatientInfo set DisplayNum=:index,Operator=:UserID,OprDate=:nowdt WHERE ID=:ID and AdmType=:AdmType)
	}
	Q SQLCODE
}

ClassMethod IsActive(ID As %String, IsActive As %String, UserID As %String) As %String
{
	s ^temoscl("active")=ID_","_IsActive_","_UserID
	s nowdt=+$h
	&SQL(Update SQLUser.DocCFPatientInfo set IsActive=:IsActive,Operator=:UserID,OprDate=:nowdt WHERE ID=:ID)
	q SQLCODE
}

}
