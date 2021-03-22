Class DHCDoc.OPDoc.AjaxStreamlineConfig Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetStreamlineConfigData")
	{
  		w ..GetStreamlineConfigData()
  		
	}
   if (action = "RemoveStreamlineDisplay")
	{
		w ..RemoveStreamlineDisplay()	
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
/// w ##class(DHCDoc.OPDoc.AjaxStreamlineConfig).GetStreamlineConfigData()     
ClassMethod GetStreamlineConfigData() As %String
{
	
	s jsonitem=""
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="select ID,ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive from SQLUser.DocCFStreamlineInfo"
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
	    s count=count+1
		s jsonitem=jsonitem_"{""ID"":"""_result.Data("ID")_""",""ItemID"":"""_result.Data("ItemID")_""",""ItemName"":"""_result.Data("ItemName")_""",""ItemClick"":"""_result.Data("ItemClick")_""",""ConditionalExpre"":"""_result.Data("ConditionalExpre")_""",""StrLink"":"""_result.Data("StrLink")_""",""DisplayNum"":"""_result.Data("DisplayNum")_""",""Operator"":"""_result.Data("Operator")_""",""OprDate"":"""_result.Data("OprDate")_""",""IsActive"":"""_result.Data("IsActive")_"""},"
	}
	i jsonitem'="" d
	.s jsonitem=$E(jsonitem,1,$L(jsonitem)-1) 
	.s json="{""total"":"""_count_""",""rows"":["_jsonitem_"]}"
	e  d
	.s json="{""total"":""0"",""rows"":[]}"
	q json
}

ClassMethod SaveStreamlineConfig(Str As %String) As %String
{
	s ID=$p(Str,$C(1),1)
	s ItemID=$p(Str,$C(1),2)
	s ItemName=$p(Str,$C(1),3)
	s ItemClick=$p(Str,$C(1),4)
	s ConditionalExpre=$p(Str,$C(1),5)
	s StrLink=$p(Str,$C(1),6)
	s isRefresh=$p(Str,$C(1),7)
	s Operator=$p(Str,$C(1),8)
	s nowdt=+$h
	if (ID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFStreamlineInfo)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
		&SQL(INSERT INTO SQLUser.DocCFStreamlineInfo(ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive,isRefresh) values (:ItemID,:ItemName,:ItemClick,:ConditionalExpre,:StrLink,:DisplayNum,:Operator,:nowdt,'1',:isRefresh))
	}else{
		&SQL(Update SQLUser.DocCFStreamlineInfo set ItemID=:ItemID,ItemName=:ItemName,ItemClick=:ItemClick,ConditionalExpre=:ConditionalExpre,StrLink=:StrLink,Operator=:Operator,OprDate=:nowdt,isRefresh=:isRefresh WHERE ID=:ID)
	}
	q SQLCODE
}

ClassMethod DelStreamlineConfig(ID As %String) As %String
{
	&SQL(delete SQLUser.DocCFStreamlineInfo where ID=:ID)
	q SQLCODE
}

ClassMethod RemoveStreamlineDisplay(Str As %String, UserID As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		s nowdt=+$h
		&SQL(Update SQLUser.DocCFStreamlineInfo set DisplayNum=:index,Operator=:UserID,OprDate=:nowdt WHERE ID=:ID)
	}
	Q SQLCODE
}

ClassMethod IsActive(ID As %String, IsActive As %String, UserID As %String) As %String
{
	s nowdt=+$h
	&SQL(Update SQLUser.DocCFStreamlineInfo set IsActive=:IsActive,Operator=:UserID,OprDate=:nowdt WHERE ID=:ID)
	q SQLCODE
}

}
