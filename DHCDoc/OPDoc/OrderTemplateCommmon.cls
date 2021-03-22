Class DHCDoc.OPDoc.OrderTemplateCommmon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
   creator:宋春莉
   date:2016-07-27
   desc:新版西药(草药)模板公共类
*/
/// creator:宋春莉
/// date:2016-07-27
/// input:用户ID 安全组ID 科室ID 上下文 模板类型 医院ID  session['LOGON.REGION'] ,session['LOGON.SITECODE']
/// output:返回医嘱模板数据 
/// w ##class(DHCDoc.OPDoc.OrderTemplateCommmon).GetOEPrefTabs("600","126","63","WNewOrderEntry184","User.SSUser","2","","DHCHEALTH","1")
/// w ##class(DHCDoc.OPDoc.OrderTemplateCommmon).GetOEPrefTabs("153","134","15","WNewOrderEntry184","User.CTLoc","2","","DHCHEALTH")
ClassMethod GetOEPrefTabs(UserID As %String, GroupID As %String, LocID As %String, CONTEXT As %String = "", objectType As %String = "", HospID As %String = "", Region As %String = "", SITECODE As %String = "")
{
	n data,t,LOGONLOCDESC,ActiveObject,type,SaveContextActive,SaveContextAs
	n ChartID,eprChart
	// 新版医嘱录入 s XCONTEXT="WNewOrderEntry" 住院184 
	// 新版草药录入 s XCONTEXT="W50007"
	d ##class(websys.Component).GetComponentMessages(.t,"OEOrder.PrefTabs.EditList")
	s PrefType="",objectReference="",data=""
	if objectType="User.SSUser" {
		s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(LocID)
		s objectReference=UserID
	}
	if objectType="User.CTLoc" s objectReference=LocID
	if objectType="User.CTHospital" s objectReference=HospID
	s appKey="ORDER"_CONTEXT_PrefType
	s appSubKey="OEOrder.PrefTabs.EditList"
	if (objectType'=""){
		s data=##class(websys.Preferences).GetData(objectType,objectReference,appKey,appSubKey)
		if data="" {
			s appKey="ORDER"_PrefType
			s data=##class(websys.Preferences).GetData(objectType,objectReference,appKey,appSubKey)
		}
	}else{
		s key="ORDER"
	    s subkey="OEOrder.PrefTabs.EditList"
		s data=##class(websys.Preferences).GetDataExPlus(UserID,GroupID,SITECODE,LocID,CONTEXT,.ActiveObject,key,subkey,.ActiveContext,"","")
	}
	s ^tmpscl("data")=data
	Q data
}

/// 解析医嘱模板数据 
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.OrderTemplateCommmon","GetOEPrefTabsTrees","153","134","15","WNewOrderEntry184","User.SSUser","2","","DHCHEALTH")
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.OrderTemplateCommmon","GetOEPrefTabsTrees","153","134","15","WNewOrderEntry184","User.CTLoc","2","","DHCHEALTH")
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.OrderTemplateCommmon","GetOEPrefTabsTrees","4634","28","7","WNewOrderEntry184","User.CTLoc","2","","DHCHEALTH","296")
Query GetOEPrefTabsTrees(UserID As %String, GroupID As %String, LocID As %String, CONTEXT As %String = "", objectType As %String = "", HospID As %String = "", Region As %String = "", SITECODE As %String = "", EpisodeID As %String) As %Query(ROWSPEC = "id:%String,pId:%String,name:%String,eleid:%String,RealStock:%String") [ SqlProc ]
{
}

ClassMethod GetOEPrefTabsTreesExecute(ByRef qHandle As %Binary, UserID As %String, GroupID As %String, LocID As %String, CONTEXT As %String = "", objectType As %String = "", HospID As %String = "", Region As %String = "", SITECODE As %String = "", EpisodeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	k ^tmpscl($j)
	s num=1
	Set qHandle=$lb(0,repid,0)
    ;;d ##class(DHCDoc.OPDoc.OrderTemplateCommmon).GetOEPrefTabs(UserID,GroupID,LocID,CONTEXT,objectType,HospID,Region,SITECODE)
	;i ^tmpscl=""  d ResetVariables1
	;;s TABLIST=$list(^tmpscl("data"),3)
    ;i TABLIST=""  d ResetVariables1
    
    s Tabsdata=##class(DHCDoc.OPDoc.OrderTemplateCommmon).GetOEPrefTabs(UserID,GroupID,LocID,CONTEXT,objectType,HospID,Region,SITECODE)
    if (Tabsdata=""){
	    Quit $$$OK	
	}
	s TABLIST=$list(Tabsdata,3)
	s groupitemDelim=$C(28)
	s itemdataDelim=$C(4)
	s tabgroupDelim=$C(1)
	for i=1:1:$listlength(TABLIST) {
		;读取标签
		s tbidlen=2-$L(i)
	    s tbidValue=$E("00",1,tbidlen)_i
		s Tab=$lg(TABLIST,i)
	    s tabname=$p(Tab,tabgroupDelim,1)
	    s eleid=""
	    s id=tbidValue
	    s name=tabname
	    s pId="0"
	    s RealStock=""
	    d OutputRow14
		i (tabname'=""){
			s $p(Tab,tabgroupDelim,1)="",Tab=$e(Tab,$l(tabgroupDelim)+1,$l(Tab))
			for j=1:1:$L(Tab,$c(1)){
				s nameId=##Class(epr.PreferencesQuery).GetOETabGroupName(Tab,j)
				;读取标签页
		        s idlen=2-$L(j)
			    s idValue=tbidValue_$E("00",1,idlen)_j
				Set rset=##class(%ResultSet).%New("DHCDoc.OPDoc.OrderTemplateCommmon:FindOETabItems")
				d rset.Execute(Tab,j,1)
				;s ^mll("data")=Tab_","_j_","
	            s k=1
	            Set columns = rset.GetColumnCount()
	            While (rset.Next()) {
		            ;读取标签页内容
		            s itemvalue=rset.GetDataByName("values")
					s itemordertype=$p(itemvalue,$C(4),9)
	                s arcim=$p(itemvalue,$C(4),3)
	                ; s ^ml("data")=itemordertype_","_arcim_","_itemvalue_","_EpisodeID
	                ;"M,13806||1,ARCIM"_$c(4,4)_"13806||1"_$c(4,4,4,4,4,4)_"M"_$c(4,4,4,4,4,4,4,4)
	                i itemordertype="R" d
                    .s RealStock=##Class(web.DHCDocOrderEntry).GetRealStock(EpisodeID,arcim) ;判断库存
                    e  s RealStock=1
                    s itemlen=2-$L(k)
			        s itemValue=idValue_$E("0000",1,itemlen)_k
		            s eleid=rset.GetData(1)
					s id=itemValue
					s name=rset.GetData(2)
					s pId=idValue
                   
					s k=k+1
					d OutputRow14
			   }
			   d rset.Close()
			   i k>1{
				   	s eleid=""
					s id=idValue
					s name=nameId
					s pId=tbidValue
					s RealStock=""
					d OutputRow14
				   }
			}
		}
		
	}
    s num=0
    f  s num=$o(^tmpscl($j,"id",num)) q:num=""  d
    .s data=$g(^tmpscl($j,"id",num))
    .i 
    .s id=$list(data,1)
    .s pId=$list(data,2)
    .s name=$list(data,3)
    .s name=##class(web.DHCDocUtil).EvalJSON(name)
    .s eleid=$list(data,4)
    .s eleid=$REPLACE(eleid,$c(4),"^")
    .s RealStock=$list(data,5)
    .d OutputRow13
    k ^tmpscl($j)
    k ^tmpcount($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutputRow13	
	set Data=$lb(id,pId,name,eleid,RealStock)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
OutputRow14
	s ^tmpscl($j,"id",num)=$lb(id,pId,name,eleid,RealStock)
	s num=num+1
	quit
ResetVariables1
	set (id,pId,name,eleid,RealStock)=""
	quit
}

ClassMethod GetOEPrefTabsTreesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOEPrefTabsTreesExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOEPrefTabsTreesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOEPrefTabsTreesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOETabItemsClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOETabItemsFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOETabItemsExecute(ByRef qHandle As %Library.Binary, TABITEMS As %Library.String = "", groupno As %Library.Integer = 0, getDetails As %Library.Boolean = 0) As %Library.Status
{
	n (qHandle,TABITEMS, groupno, getDetails, SSGroupID, EpisodeID , formulary)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	
	;
	s Values="",Desc=""
	s Items=$P(TABITEMS,$C(1),groupno)
	s len=$l(Items,$C(28))
	for i=2:1:len  {
		s ItemStr=$P(Items,$C(28),i)
		continue:ItemStr=""
		s ordertype=$P(ItemStr,$C(4),1)
		s itemrowid=$P(ItemStr,$C(4),2)
		continue:itemrowid=""
		s Values=itemrowid
		if ordertype="ARCIM" {
			continue:##class(web.DHCDocOrderEntry).ValARCItem(itemrowid)'=0
			s Baseuomdesc=""
			s FormDurRowid=""
			s tmpitemrowid=itemrowid
			s PartInfo=""
			if $P(tmpitemrowid,"*",2)="S" {
				;新产品的【部位、体位和后处理描述串^部位和体位串^后处理ID】
				s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR($P(tmpitemrowid,"*",3,$L(tmpitemrowid,"*")),"*","^"))
			}
			if (tmpitemrowid["*") s tmpitemrowid=$p(tmpitemrowid,"*",1)
			s ItemCatDR=$p(^ARCIM(+tmpitemrowid,$p(tmpitemrowid,"||",2),1),"^",10)
			
			s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
			Set inci=$o(^INCI(0,"ARCIM_DR",+tmpitemrowid,""))
			if inci'="" {
				s baseuom=$p(^INCI(inci,1),"^",10)
	    		i baseuom'="" s Baseuomdesc=..GetUOMDesc(baseuom)
			}
	    	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(tmpitemrowid)
	    	i DrgformRowid'="" s FormDurRowid=$p($g(^PHCD(+DrgformRowid,"DF",$P(DrgformRowid,"||",2),1)),"^",8)
			s Desc=$p($g(^ARCIM(+tmpitemrowid,$p(tmpitemrowid,"||",2),1)),"^",2)
			s Desc=Desc_PartInfo
			i getDetails=1 {
				s Values="ARCIM"_$C(4,4)_itemrowid_$C(4,4,4,4)_Baseuomdesc_$C(4)_FormDurRowid_$C(4)_ordertype_$C(4,4,4,4,4,4,4,4)
				//s Values="ARCIM"_"^"_itemrowid_"^"_Baseuomdesc_"^"_FormDurRowid_"^"_ordertype
			}else{
				s Values="ARCIM"_$C(4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4)
			//s Values="ARCIM"_"^"_itemrowid
			}
		}else{
			if (itemrowid="undefined") continue
			continue:##class(web.DHCDocOrderEntry).ValARCOS(itemrowid)'=0
			s Desc=$p(^ARCOS(itemrowid),"^",2)
			i getDetails=1 {
				;s Values="ARCOS"_"^"_itemrowid
				s Values="ARCOS"_$C(4,4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4,4,4)
			}else{
				;s Values="ARCOS"_"^"_itemrowid
				s Values="ARCOS"_$C(4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
			}
		}
	    do OuputRow221 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow221
	set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindOETabItemsFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOETabItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// brings back each item for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
/// accepts a boolean 'getDetails' to determine whether to fetch extra details against ecah item.
/// getDetails = 0 (default) for preferences setup.
/// getDetails = 1 in order entry screen (oeorder.entry.redrawprefs.csp)
/// s tab=^tmpone
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindOETabItems",tab,1,1)
Query FindOETabItems(TABITEMS As %Library.String, groupno As %Library.Integer, getDetails As %Library.Boolean) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

ClassMethod GetUOMDesc(UOMRowid As %String, UserLanguage As %String = "") As %String
{
	Q:UOMRowid="" ""
	if UserLanguage="EN" {
		Q $P($g(^CT("UOM",UOMRowid)),"^",3)
	}else{
		Q $P($g(^CT("UOM",UOMRowid)),"^",2)
	}
}

}
