Class DHCDoc.DHCDocConfig.SplitPrescriptSetting Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindPHCPOList() As %Query(ROWSPEC = "PORowId:%String,PODesc:%String,selected:%Boolean")
{
}

ClassMethod FindPHCPOListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SplitPrescriptSetting","FindPHCPOList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ID=0
 	f  s ID=$o(^PHCPO(ID)) q:ID=""  d
 	.s Desc=$p(^PHCPO(ID),"^",2)
 	.s selected=0
	.Do OutputRowFindPHCPOList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPHCPOList
	set Data=$lb($g(ID),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPHCPOListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPHCPOListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPHCPOListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPHCPOListExecute ]
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

/// Description:： 查询西药处方类型
Query FindSplitPrescType() As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod FindSplitPrescTypeExecute(ByRef qHandle As %Binary) As %Status
{
	/*
	s ^DHCDocConfig("SplitPrescType","MedItemCat")="西药"
	s ^DHCDocConfig("SplitPrescType","CPMedItemCat")="中成药"
	s ^DHCDocConfig("SplitPrescType","LimitMedItemCat")="精二类"
	s ^DHCDocConfig("SplitPrescType","PreciousDrugItemCat")="贵重药品子分类"
	s ^DHCDocConfig("SplitPrescType","DMJ1Cat")="毒麻精一"
	*/

	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SplitPrescriptSetting","FindSplitPrescType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Code=0
    for {
		s Code=$O(^DHCDocConfig("SplitPrescType",Code))
		q:Code=""
		s Desc=^DHCDocConfig("SplitPrescType",Code)
		d OutputRowFindSplitPrescType
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindSplitPrescType
	set Data=$lb(Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindSplitPrescTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSplitPrescTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSplitPrescTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSplitPrescTypeExecute ]
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

/// w ##Class(DHCDoc.DHCDocConfig.SplitPrescriptSetting).SaveSplitPrescType("FormulaItemCat","协定处方")
ClassMethod SaveSplitPrescType(Code As %String, Desc As %String) As %String
{
	if $D(^DHCDocConfig("SplitPrescType",Code)){
		q "-1"
	}
	s ^DHCDocConfig("SplitPrescType",Code)=Desc
	q 0
}

ClassMethod GetSplitPrescTypeDetails(Code As %String) As %String
{
	s Info="^^^^^^^^"
	if (Code=""){
		s Info=$TR(Info,"^",$C(1))
		q Info
	}
	s ItemCatStr=$G(^DHCDocConfig("SplitPrescType",Code,"ItemCat"))
	s Details=$G(^DHCDocConfig("SplitPrescType",Code,"Details"))
	if ($L(Details,"^")<3){
		s $P(Details,"^",3)=""
	}
	s POList=$G(^DHCDocConfig("SplitPrescType",Code,"POList"))
	
	s Info=ItemCatStr_$C(1)_Details_$C(1)_POList
	q Info
}

ClassMethod SaveSplitPrescTypeDetails(Code As %String, Info As %String) As %String
{
	s SplitPrescTypeItemCatStr=$P(Info,$C(1),1)
	s OtherInfo=$P(Info,$C(1),2)
	s SplitPrescTypePOList=$P(Info,$C(1),3)
	s ^DHCDocConfig("SplitPrescType",Code,"ItemCat")=SplitPrescTypeItemCatStr
	s ^DHCDocConfig("SplitPrescType",Code,"Details")=OtherInfo
	s ^DHCDocConfig("SplitPrescType",Code,"POList")=SplitPrescTypePOList
	q 0
}

ClassMethod DelSplitPrescType(Code As %String) As %String
{
	k ^DHCDocConfig("SplitPrescType",Code)
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.SplitPrescriptSetting).GetUnSplitPrescript()
ClassMethod GetUnSplitPrescript() As %String
{
	s PromptInfo=""
	
	s SaveSplitPrescriptItemCat=""
	s Code=0
    for {
		s Code=$O(^DHCDocConfig("SplitPrescType",Code))
		q:Code=""
		s ItemCatStr=$G(^DHCDocConfig("SplitPrescType",Code,"ItemCat"))
		if (SaveSplitPrescriptItemCat=""){
			s SaveSplitPrescriptItemCat=ItemCatStr
		}else{
			s SaveSplitPrescriptItemCat=SaveSplitPrescriptItemCat_"^"_ItemCatStr
		}
	}
	
	s ItemCatRowid=""
	for {
		s ItemCatRowid=$O(^ARC("IC",ItemCatRowid))
		q:(ItemCatRowid="")
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:(OrderType'="R")
		if ("^"_SaveSplitPrescriptItemCat_"^")[("^"_ItemCatRowid_"^"){
			continue
		}
		s ItemCatDesc=$P(^ARC("IC",ItemCatRowid),"^",2)
		if (PromptInfo=""){
			s PromptInfo=ItemCatDesc
		}else{
			s PromptInfo=PromptInfo_"^"_ItemCatDesc
		}
	}
	if (PromptInfo'=""){
		s PromptInfo="以下药物子类尚未维护对应的处方类型，可能造成分处方异常，请尽快核对："_PromptInfo
	}
	q PromptInfo
}

}
