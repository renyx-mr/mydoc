Import SQLUser

Class DHCDoc.OPDoc.CMOrdListCommon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:	2016-07-21
/// input:	需要返回的数组指针
/// return:	数组指针
/// desc:   获取草药医嘱录入列设置,提供给双击列多弹出的设置页面
/// d ##class(DHCDoc.OPDoc.CMOrdListCommon).GetListColSet()
ClassMethod GetListColSet(ByRef ConfigAry As %String)
{
	n (ConfigAry)
	s Count=0
	s DOGRowId=""
	s child=""
	s DOPRowID=$o(^DHCDocOGi("Code","UDHCOEOrderCHNMEDEntry",0))
	i DOPRowID'="" s child=$o(^DHCDocOGi("Code","UDHCOEOrderCHNMEDEntry",DOPRowID,0))
	i child'="" s DOGRowId=DOPRowID_"||"_child
	Set rset=##Class(%ResultSet).%New("DHCDoc.OPDoc.CMOrdListCommon:GetOrderListSet")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(DOGRowId)
		If 'Status Quit
		While (rset.Next()) {
			s rowid=rset.GetDataByName("rowid")
		    s code=rset.GetDataByName("code")
		    s desc=rset.GetDataByName("desc")
		    s expression=rset.GetDataByName("expression")
		    s colwidth=rset.GetDataByName("colwidth")
		    s hidden=rset.GetDataByName("hidden")
		    s sort=0
		    s Count=Count+1
		    s ConfigAry(Count)=code_"^"_desc_"^"_Count_"^"_colwidth_"^"_hidden_"^"_sort_"^"_expression
		    //w ConfigAry(Count),!
		}
		d rset.Close()
	}
	q
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.CMOrdListCommon","GetOrderListSet")
Query GetOrderListSet(DOGRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,expression:%String,colwidth:%String,hidden:%String") [ SqlProc ]
{
}

ClassMethod GetOrderListSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderListSetExecute(ByRef qHandle As %Binary, DOGRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOGRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s OPRowId=$p(DOGRowId,"||",1)
	s child=$p(DOGRowId,"||",2)
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOLS(OPRowId,child,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",2)
 	.s expression=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",3)
 	.s colwidth=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",4)
 	.s hidden=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",5)
 	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OPRowId_"||"_child_"||"_Rowid,Code,Desc,expression,colwidth,hidden)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderListSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:	2016-07-21
/// input:	
/// return:	
/// desc:   根据列头设置得到草药医嘱录入的表格配置对象
/// d ##class(web.DHCDocOrderListCommon).ReadListColSet()
ClassMethod ReadListColSet(classname As %String, classmethod As %String, ByRef colNames As %String, ByRef colModelAry As %String, ByRef ParamAry As %String, context As %String) As %String
{
	q:(classname="")||(classmethod="") ""
	n (%session,classname,classmethod,colNames,colModelAry,ParamAry,context)
	;s LookupListComponetId = $o(^websys.ComponentI("UniqueNameIndex","WEBSYSLOOKUPLIST",0))
	s context="K"_classname_"."_classmethod_"."_context
	
	s SessionStr=""
	
	i %session,$d(%session.Data) {
		s SessionStr=%session.Get("LOGON.SITECODE")_"^"_%session.Get("LOGON.USERID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.CTLOCID")
		s SessionStr=SessionStr_"^"_%session.Get("CONTEXT")_"^"_%session.Get("LOGON.WARDID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.LANGID")
	}
	
	k ConfigAry
	d ##class(DHCDoc.OPDoc.CMOrdListCommon).GetListColSet(.ConfigAry)
	k SortQueue			
	s uSet=""
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.;s uSet=##class(websys.Preferences).GetDataExLE(1,1,"","",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 SortQueue(myIdx,idx)=1,hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)	
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.s pageSize=$lg(rowsSet,1)
	s ^tmphiddenPlist=uSet
	;排序,所有隐藏列排在后面,显示列按设置显示
	;SortConfigAry为临时排序数组,Loop为原ConfigAry数组计数器,不会重复;所以只要取到Loop可以直接使用ConfigAry(Loop)取值
	k SortConfigAry
	s uSet=1
	i uSet'="" {
		s Loop=0
		for {
			s Loop=$O(ConfigAry(Loop)) Q:Loop=""
			i $g(hiddenPlist(Loop))="" {
				//2014-04-15
				s SortConfigAry(999,Loop)=$g(ConfigAry(Loop))
			}else{
				s SortNum=$o(SortQueue(Loop,0))
				s SortConfigAry(+SortNum,Loop)=$g(ConfigAry(Loop))
			} 
		}
	}
	s SortNum=""
	for {
		s SortNum=$O(SortConfigAry(SortNum)) Q:SortNum=""
		s Loop=0
		for {
			s Loop=$O(SortConfigAry(SortNum,Loop)) Q:Loop=""
			s OneItem=$g(ConfigAry(Loop))
			s name=$p(OneItem,"^",1)
			s cap=$p(OneItem,"^",2)
			s col=$p(OneItem,"^",3)
			s wid=$p(OneItem,"^",4)
			s isHidden=$p(OneItem,"^",5)
			i (isHidden="Y")||(cap="") s cap=name
			s sort=$p(OneItem,"^",6)
			s expression=$p(OneItem,"^",7)
			i '$d(colNames) {
				s colNames=cap
			}else{
				s colNames=colNames_","_cap
			}
			//i (uSet'=""),$g(hiddenPlist(Loop))="" s isHidden="Y"
		
			;转换
			i isHidden="Y" s isHidden="true"
			e  s isHidden="false"
			;多语言转换
			s CurLangID=$p(SessionStr,"^",8)
			i CurLangID'="",$p($g(^SS("LAN",CurLangID)),"^",2)'="Chinese" {
				s cap=##class(web.DHCDocUtil).GetTranslatedStr(CurLangID,cap)
			}
			k ColCFAry
			s ColCFAry("name")=name
			s ColCFAry("cap")=cap
			s ColCFAry("col")=col
			s ColCFAry("wid")=wid
			s ColCFAry("isHidden")=isHidden
			s ColCFAry("sort")=sort
			s ClassName=$p(expression,".",1,$l(expression,".")-1)
			s MethodName=$p(expression,".",$l(expression,"."))
			s colModelAry(cap)="{}"
			s ExpStr=""
			i $d(ParamAry(name)) s ExpStr=$g(ParamAry(name))
			i ClassName'="" {
				
				;判断方法是否存在
				s CLSObj=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
				if $IsObject(CLSObj) {
					s ^peng("111")=333
					if $d(^oddDEF(CLSObj.%Id(),"m",MethodName)) {
						s colModelAry(cap)=$CLASSMETHOD(ClassName,MethodName,SessionStr,.ColCFAry,ExpStr)
					}
				}
			}
		}
	}

	q
}

}
