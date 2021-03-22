Class DHCDoc.DHCDocConfig.AppendItemInItemCat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetAppendItemInItemCat(ItemSubCat As %String) As %Query(ROWSPEC = "ARCIMRowid:%String,ARCIMDesc:%String,Qty:%String,Loc:%String,LocId:%String,RecLoc:%String,RecLocId:%String,DHCICARowid:%String")
{
}

ClassMethod GetAppendItemInItemCatExecute(ByRef qHandle As %Binary, ItemSubCat As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.AppendItemInItemCat","GetAppendItemInItemCat","AppendItem")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    /*s ARCIMRowid=0
    F  s ARCIMRowid=$o(^DHCDocConfig("AppendItem",ARCIMRowid)) q:ARCIMRowid=""  d
    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
    .s Qty=$p($g(^DHCDocConfig("AppendItem",ARCIMRowid)),"^",1)
    .s LocId=$p($g(^DHCDocConfig("AppendItem",ARCIMRowid)),"^",2)
    .s RecLocId=$p($g(^DHCDocConfig("AppendItem",ARCIMRowid)),"^",3)
    .s Loc="",RecLoc=""
    .if LocId'="" do
    ..s Loc=$p(^CTLOC(LocId),"^",2)
    .if RecLocId'="" do
    ..s RecLoc=$p(^CTLOC(RecLocId),"^",2)*/
    if (ItemSubCat="" ){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s DHCICARowid=0
    f  s DHCICARowid=$o(^DHCItmSubCatAdd(0,"ItemCat",ItemSubCat,DHCICARowid)) q:DHCICARowid=""  d
    .s ARCIMRowid=$p(^DHCItmSubCatAdd(DHCICARowid),"^",2)
    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
    .s Qty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",3)
    .s LocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",4)
    .s RecLocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",5)
    .s RecLoc="",Loc=""
    .if LocId'="" do
    ..s Loc=$p(^CTLOC(LocId),"^",2)
    .if RecLocId'="" do
    ..s RecLoc=$p(^CTLOC(RecLocId),"^",2)
	.Do OutputRowGetAppendItemInItemCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAppendItemInItemCat
	set Data=$lb($g(ARCIMRowid),$g(ARCIMDesc),$g(Qty),Loc,LocId,RecLoc,RecLocId,DHCICARowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemInItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemInItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemInItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemInItemCatExecute ]
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

ClassMethod delete(DHCICARowid) As %String
{
	/*k ^DHCDocConfig(Node,Node1)
	q 0*/
	&sql(delete SQLUSER.DHC_ItmSubCatAdd where DHCICA_Rowid=:DHCICARowid)
	Q SQLCODE
}

ClassMethod FindAppendItem(DHCICARowid As %String, ItemSubCat As %String, ARCIMRowid As %String, LocId As %String)
{
	s id=0,ExistRowId=""
    f  s id=$o(^DHCItmSubCatAdd(0,"ItemCat",ItemSubCat,id)) q:(id="")||(ExistRowId'="")  d
    .s ItemMastDr=$p(^DHCItmSubCatAdd(id),"^",2)
    .s LocRowid=$p(^DHCItmSubCatAdd(id),"^",4)
    .Quit:(id=DHCICARowid)&&(DHCICARowid'="")
	.if (ARCIMRowid=ItemMastDr)&&(LocRowid=LocId) s ExistRowId=id  
	Q ExistRowId
}

ClassMethod save(DHCICARowid As %String = "", ItemSubCat, ARCIMRowid, Qty, LocId As %String = "", RecLocId As %String = "") As %String
{
	s ^tempscl("save")=DHCICARowid_","_ItemSubCat_","_ARCIMRowid_","_Qty_","_LocId_","_RecLocId
	s arcimcode=""
	&sql(select ARCIM_Code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:ARCIMRowid)
	Q:arcimcode="" "-2"
	s findRepeat=..FindAppendItem(DHCICARowid,ItemSubCat,ARCIMRowid,LocId)
	Q:findRepeat'="" "-1"
	if (DHCICARowid=""){
		&sql(insert into SQLUSER.DHC_ItmSubCatAdd (DHCICA_ItemCat_DR,DHCICA_AddItm_DR,DHCICA_Qty,DHCICA_Loc_DR,DHCICA_RecLoc_DR)values 
			(:ItemSubCat,:ARCIMRowid,:Qty,:LocId,:RecLocId))
	}else{
		&sql(update SQLUSER.DHC_ItmSubCatAdd set DHCICA_AddItm_DR=:ARCIMRowid,DHCICA_Qty=:Qty,DHCICA_Loc_DR=:LocId,DHCICA_RecLoc_DR=:RecLocId  where DHCICA_Rowid=:DHCICARowid )
	}
	Q SQLCODE
	/*if '$D(^ARCIM($P(ARCIMRowid,"||",1))){
		q "-2"
	}
	k ^TempDHCDocConfig(Node,$j)
	s Count=0,Find=0
	s AppenARCIMRowId=0
	for {
		s AppenARCIMRowId=$o(^DHCDocConfig(Node,AppenARCIMRowId))
		q:AppenARCIMRowId=""
		s Count=Count+1
		s UserLocId=$p($g(^DHCDocConfig(Node,AppenARCIMRowId)),"^",2)
		if (RowIndex'="")&&(Count=RowIndex){
			continue
		}
		i (ARCIMRowid=AppenARCIMRowId)&&((LocId=UserLocId)||(UserLocId="")) s Find=-1
		q:Find=-1
		s ^TempDHCDocConfig(Node,$j,AppenARCIMRowId)=$g(^DHCDocConfig(Node,AppenARCIMRowId))
	}
	if (Find=0){
		k ^DHCDocConfig(Node)
		s AppenARCIMRowId=0
		for {
			s AppenARCIMRowId=$o(^TempDHCDocConfig(Node,$j,AppenARCIMRowId))
			q:AppenARCIMRowId=""
			s ^DHCDocConfig(Node,AppenARCIMRowId)=$g(^TempDHCDocConfig(Node,$j,AppenARCIMRowId))
		}
		s ^DHCDocConfig(Node,ARCIMRowid)=Qty_"^"_LocId_"^"_RecLocId
	}
	k ^TempDHCDocConfig(Node,$j)
	q Find 
	//q:$d(^DHCDocConfig(Node,ARCIMRowid)) "-1"
	
	//s ^DHCDocConfig(Node,ARCIMRowid)=Qty_"^"_LocId_"^"_RecLocId
	//q 0*/
}

/// @附加医嘱设定(按子类),绑定医嘱指定了科室，则按照指定科室医嘱产生，未指定的则按未指定科室产生绑定医嘱
/// @ArcimId 医嘱项ID UserLoc开单科室ID
/// return 绑定医嘱串
/// w ##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem("1811||1","")
ClassMethod GetCatItmAddItem(ARCIMItemCatDR As %String, UserLoc As %String) As %String
{
	s UserLocAppendItemStr="",AllLocAppendItemStr=""
	s DHCICARowid=0
    f  s DHCICARowid=$o(^DHCItmSubCatAdd(0,"ItemCat",ARCIMItemCatDR,DHCICARowid)) q:DHCICARowid=""  d
    .s DHCIAAddItmDR=$p(^DHCItmSubCatAdd(DHCICARowid),"^",2)
    .s DHCIAQty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",3)
    .s DHCIALocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",4)
    .s DHCIARecLocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",5)
    .s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId //_$C(1)_index
    .if (DHCIALocId=UserLoc) d
    ..i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
    ..e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
    .else  if (DHCIALocId="") d
    ..i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
    ..e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
	  /*s DHCIAAddItmDR=0
		For {
			s DHCIAAddItmDR=$o(^DHCDocConfig("AppendItem",DHCIAAddItmDR)) q:DHCIAAddItmDR=""
			s DHCIAQty=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",1)
			s DHCIALocId=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",2)
			s DHCIARecLocId=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",3)
			i (+DHCIAQty=0) s DHCIAQty=1
			s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId_$C(1)_index
			if (DHCIALocId=UserLoc){
				i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
				e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
			}else{
				if (DHCIALocId=""){
					i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
					e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
				}
			}
		}*/
		Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	    Q AllLocAppendItemStr
}

}
