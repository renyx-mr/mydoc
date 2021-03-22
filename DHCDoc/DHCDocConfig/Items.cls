Class DHCDoc.DHCDocConfig.Items Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 查询医嘱大类
Query GetCategoryList() As %Query(ROWSPEC = "ORCATRowId:%String,ORCATDesc:%String")
{
}

ClassMethod GetCategoryListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetCategoryList")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    s ORCATRowId=0 f  s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId)) q:ORCATRowId=""  d
    .s ORCATDesc=$p(^OEC("ORCAT",ORCATRowId),"^",2)
	.Do OutputRowGetCategoryList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCategoryList
	set Data=$lb($g(ORCATRowId),$g(ORCATDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱大类查询医嘱子类
Query GetOrdCategoryList(ORCATRowId As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String")
{
}

ClassMethod GetOrdCategoryListExecute(ByRef qHandle As %Binary, ORCATRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetOrdCategoryList")
	Set repid=$I(^CacheTemp)
    Set ind=1  
    s ARCICRowId=0 f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .s ARCICOrdCatDR=$p(^ARC("IC",ARCICRowId),"^",8)
    .q:(ORCATRowId'="")&&(ARCICOrdCatDR'=ORCATRowId)
	.Do OutputRowGetOrdCategoryList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOrdCategoryList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOrdCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdCategoryListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 查询医嘱项
Query GetItemList(Item As %String = "", ARCICRowId As %String = "") As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,ARCIMType:%String,ARCICDesc:%String,ORCATDesc:%String")
{
}

ClassMethod GetItemListExecute(ByRef qHandle As %Binary, Item As %String = "", ARCICRowId As %String = "") As %Status
{
	s ^tmpscl("GetItemList")=Item_","_ARCICRowId
	;w ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetItemList","","",5,"")
	Set repid=$I(^CacheTemp)
    Set ind=1  
	k ^TempARCIMRowIDStr("GetItemList",$j) 
	//#dim rs As %ResultSet
	s rs1= 	##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	s GroupID=%session.Data("LOGON.GROUPID")
	d rs1.Execute(Item,GroupID,"",ARCICRowId)
	while(rs1.Next()){
		s ARCIMDesc=rs1.GetData(1)
		s ARCIMRowID = rs1.GetData(2)
		s ARCIMType=rs1.GetData(4)
		continue:$d(^TempARCIMRowIDStr("GetItemList",$j,ARCIMRowID))
		s ^TempARCIMRowIDStr("GetItemList",$j,ARCIMRowID)=ARCIMRowID
        if (ARCIMType="ARCIM"){
	        s ARCIMType="医嘱项"
	        s ARCIMItemCatDR=$p($g(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1)),"^",10)
	    }elseif(ARCIMType="ARCOS"){
		    s ARCIMType="医嘱套"
		    s ARCIMItemCatDR=$p(^ARCOS(ARCIMRowID),"^",9)
		}
		s ARCICDesc=$p(^ARC("IC",ARCIMItemCatDR),"^",2)
		s ARCICOrdCatDR=$p(^ARC("IC",ARCIMItemCatDR),"^",8)
        s ORCATDesc=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
		d OutputRowGetItemList
	}
	k ^TempARCIMRowIDStr("GetItemList",$j)
	d rs1.%Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItemList
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(ARCIMType),$g(ARCICDesc),$g(ORCATDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱项查询绑定的医嘱项目
Query GetAppendItemList(ARCIMRowId As %String) As %Query(ROWSPEC = "DHCIARowid:%String,AddItmDR:%String,AddItmDesc:%String,DHCIAQty:%String,DHCIALoc:%String,DHCIALocId:%String,DHCIARecLoc:%String,DHCIARecLocId:%String")
{
}

ClassMethod GetAppendItemListExecute(ByRef qHandle As %Binary, ARCIMRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetAppendItemList",312)
	Set repid=$I(^CacheTemp)
    Set ind=1  
    s DHCIARowid=0  f  s DHCIARowid=$o(^DHCItmMastAdd("0","ARCIM",ARCIMRowId,DHCIARowid)) q:DHCIARowid=""  d
    .s AddItmDR=$p(^DHCItmMastAdd(DHCIARowid),"^",2)
    .s AddItmDesc=$p(^ARCIM(+AddItmDR,$p(AddItmDR,"||",2),1),"^",2)
    .s DHCIAQty=$p(^DHCItmMastAdd(DHCIARowid),"^",3)
    .s LocId=$p(^DHCItmMastAdd(DHCIARowid),"^",4)
    .s RecLocId=$p(^DHCItmMastAdd(DHCIARowid),"^",5)
    .s LocDesc=""
    .if LocId'="" do
    ..s LocDesc=$p(^CTLOC(LocId),"^",2)
    .s RecLocDesc=""
    .if RecLocId'="" do
    ..s RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	.Do OutputRowGetAppendItemList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAppendItemList
	set Data=$lb($g(DHCIARowid),$g(AddItmDR),$g(AddItmDesc),$g(DHCIAQty),LocDesc,LocId,RecLocDesc,RecLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemListExecute ]
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

/// w ##class(DHCDoc.DHCDocConfig.Items).saveAppendItem("","12830||1","1264||1",1,"2","3") 
ClassMethod saveAppendItem(Rowid As %String = "", ARCIMRowID As %String = "", AddARCIMRowID As %String = "", OrdQty As %String = "", LocId As %String = "", RecLocId As %String = "") As %String
{
	S ^tempsaveAppendItem=Rowid_","_ARCIMRowID_","_AddARCIMRowID_","_OrdQty_","_LocId_","_RecLocId
	s arcimcode=""
	&sql(select ARCIM_Code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:AddARCIMRowID)
	q:arcimcode="" "-2"
	s find=..FindAppendItem(Rowid,ARCIMRowID,AddARCIMRowID,LocId)
	if (find'=""){
		//if (Rowid'="")&&(Rowid'=find){
			Quit -1	
		//}
	}
	if (Rowid=""){
		&sql(insert into SQLUSER.DHC_ItmAdd (DHCIA_Itm_DR,DHCIA_AddItm_DR,DHCIA_Qty,DHCIA_Loc_DR,DHCIA_RecLoc_DR)values 
			(:ARCIMRowID,:AddARCIMRowID,:OrdQty,:LocId,:RecLocId))
		b ;1212
	}else{
		&sql(update SQLUSER.DHC_ItmAdd set DHCIA_AddItm_DR=:AddARCIMRowID,DHCIA_Qty=:OrdQty,DHCIA_Loc_DR=:LocId,DHCIA_RecLoc_DR=:RecLocId  where DHCIA_Rowid=:Rowid )
     
	}
	q SQLCODE
}

ClassMethod deleteAppendItem(Rowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$deleteAppendItem^DHCItmMast(Rowid)
	zn "dhc-app"
	q rtn
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱项查询别名
Query GetAliasByArcim(ARCIMRowId As %String) As %Query(ROWSPEC = "ALIASRowId:%String,ALIASText:%String,selected")
{
}

ClassMethod GetAliasByArcimExecute(ByRef qHandle As %Binary, ARCIMRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetAliasByArcim",312)
	Set repid=$I(^CacheTemp)
    Set ind=1  
    if ($l(ARCIMRowId,"||")=2) d
    .s ALIASRowId=0 f  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""  d
    ..d GetAlias(ALIASRowId)
    else  d
    .s ALIASRowId=0 f  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCOS",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""  d
    ..d GetAlias(ALIASRowId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAliasByArcim
	set Data=$lb($g(ALIASRowId),$g(ALIASText),selected)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetAlias(ALIASRowId)
   s ALIASText=$p(^ARC("ALIAS",ALIASRowId),"^",6)
   s ALIASDateFrom=$p(^ARC("ALIAS",ALIASRowId),"^",12)
   s ALIASDateTo=$p(^ARC("ALIAS",ALIASRowId),"^",13)
   q:(ALIASDateFrom'="")&&(ALIASDateFrom>+$h)
   q:(ALIASDateTo'="")&&(ALIASDateTo<=+$h)
   s selected=0
   Do OutputRowGetAliasByArcim
}

ClassMethod GetAliasByArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasByArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAliasByArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasByArcimExecute ]
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

ClassMethod FindAppendItem(Rowid As %String, ArcimId As %String, AddArcimId As %String, LocId As %String)
{
	s DHCIARowid=""
	s Id=0
	for  s Id=$o(^DHCItmMastAdd("0","ARCIM",ArcimId,Id)) Quit:Id=""  do
	.s AddArcimRowid=$p(^DHCItmMastAdd(Id),"^",2)
	.s LocRowid=$p(^DHCItmMastAdd(Id),"^",4)
	.s RecLocRowid=$p(^DHCItmMastAdd(Id),"^",5)
	.Quit:(Id=Rowid)&&(Rowid'="")
	.if (AddArcimId=AddArcimRowid)&&(LocRowid=LocId) s DHCIARowid=Id  //||(LocRowid="")
	
	Quit DHCIARowid
}

/// @附加医嘱设定(按医嘱),绑定医嘱指定了科室，则按照指定科室医嘱产生，未指定的则按未指定科室产生绑定医嘱
/// @ArcimId 医嘱项ID UserLoc开单科室ID
/// return 绑定医嘱串
/// w ##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem("1811||1","")
ClassMethod GetItmAddItem(ARCIMRowid As %String, UserLoc As %String) As %String
{
	  s UserLocAppendItemStr="",AllLocAppendItemStr=""
	  s DHCIARowid=0
	  For {
			s DHCIARowid=$o(^DHCItmMastAdd("0","ARCIM",ARCIMRowid,DHCIARowid)) q:DHCIARowid=""
			s DHCIAAddItmDR=$p(^DHCItmMastAdd(DHCIARowid) ,"^",2)
			s DHCIAQty=$p(^DHCItmMastAdd(DHCIARowid) ,"^",3)
			i (+DHCIAQty=0) s DHCIAQty=1
			s DHCIALocId=$p(^DHCItmMastAdd(DHCIARowid) ,"^",4)
			s DHCIARecLocId=$p(^DHCItmMastAdd(DHCIARowid) ,"^",5)
			s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$c(1)_DHCIARecLocId
			if (DHCIALocId=UserLoc){
				i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
				e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
			}else{
				if (DHCIALocId=""){
					i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
					e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
				}
			}
	   }
	   Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	   Q AllLocAppendItemStr
}

}
