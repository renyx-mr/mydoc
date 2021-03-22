Class DHCDoc.DHCDocConfig.PAOrderItemQty Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetPAOrderItemQtyList(PatType As %String, PaadmType As %String, SIIRowid As %String) As %Query(ROWSPEC = "PITRowid:%String,PAADMType:%String,PAADMTypeDesc:%String,PatientTypeDR:%String,PatientType:%String,PITSIIDR:%String,TARCDesc:%String,PITAllowQty:%String,PITlimitType:%String,PITlimitTypeDesc:%String")
{
}

ClassMethod GetPAOrderItemQtyListExecute(ByRef qHandle As %Binary, PatType As %String, PaadmType As %String, SIIRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PAOrderItemQty","GetPAOrderItemQtyList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i PatType'="" d
    .s PITRowid=0
    .f  s PITRowid=$o(^DHCPAItemQtyi("PatientType",PatType,PITRowid)) q:PITRowid=""  d
    ..d OutPutRow(PITRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    i PatType'="" Quit $$$OK
    
    i PaadmType'="" d
    .s PITRowid=0
    .f  s PITRowid=$o(^DHCPAItemQtyi("PAADMType",PaadmType,PITRowid)) q:PITRowid=""  d
    ..d OutPutRow(PITRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    i PaadmType'="" Quit $$$OK
    
    i SIIRowid'="" d
    .s PITRowid=0
    .f  s PITRowid=$o(^DHCPAItemQtyi("SII",SIIRowid,PITRowid)) q:PITRowid=""  d
    ..d OutPutRow(PITRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    i SIIRowid'="" Quit $$$OK
    
    s PITRowid=0 f  s PITRowid=$o(^DHCPAItemQty(PITRowid)) q:PITRowid=""  d
    .d OutPutRow(PITRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPAOrderItemQtyList
	set Data=$lb($g(PITRowid),$g(PAADMType),$g(PAADMTypeDesc),$g(PatientTypeDR),$g(PatientType),$g(PITSIIDR),$g(TARCDesc),$g(PITAllowQty),$g(PITlimitType),$g(PITlimitTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
OutPutRow(PITRowid)
   s PAADMType=$p(^DHCPAItemQty(PITRowid),"^",1)
   q:(PaadmType'=PAADMType)&&(PaadmType'="")
   s:PAADMType="O" PAADMTypeDesc="门诊"
   s:PAADMType="E" PAADMTypeDesc="急诊"
   s:PAADMType="I" PAADMTypeDesc="住院"
   s:PAADMType="N" PAADMTypeDesc="新生儿"
   s:PAADMType="H" PAADMTypeDesc="体检"
   s PatientTypeDR=$p(^DHCPAItemQty(PITRowid),"^",2)
   q:(PatType'=PatientTypeDR)&&(PatType'="")
   s PatientType=$p(^CT("SS",PatientTypeDR),"^",2)
   s PITSIIDR=$p(^DHCPAItemQty(PITRowid),"^",3)
   q:(SIIRowid'=PITSIIDR)&&(SIIRowid'="")
   s TARCDesc=$p(^DHCTarC("CC",PITSIIDR),"^",2)
   s PITAllowQty=$p(^DHCPAItemQty(PITRowid),"^",4)
   s PITlimitType=$p(^DHCPAItemQty(PITRowid),"^",5)
   i PITlimitType="S" s PITlimitTypeDesc="本科本日"
   e  s PITlimitTypeDesc="本日"
   Do OutputRowGetPAOrderItemQtyList
}

ClassMethod GetPAOrderItemQtyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAOrderItemQtyListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAOrderItemQtyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAOrderItemQtyListExecute ]
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

/// 收费项目大类
Query GetTarCateList() As %Query(ROWSPEC = "TARCRowId:%String,TARCDesc:%String")
{
}

ClassMethod GetTarCateListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PAOrderItemQty","GetTarCateList")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    s TARCRowId=0
    f  s TARCRowId=$o(^DHCTarC("CC",TARCRowId)) q:TARCRowId=""  d
    .s TARCDesc=$p(^DHCTarC("CC",TARCRowId),"^",2)
	.Do OutputRowGetTarCateList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetTarCateList
	set Data=$lb($g(TARCRowId),$g(TARCDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetTarCateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarCateListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTarCateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarCateListExecute ]
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

ClassMethod delete(Rowid) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCPAOrderItemQty(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod save(Rowid As %String, str As %String) As %String
{
	//var Str=PatientType+"!"+PAADMType+"!"+SIIRowid+"!"+AllowQty+"!"+LimitType;
	s PAADMTypeRowid=$p(str,"!",2)
	s PatientTypeRowid=$p(str,"!",1)
	s SIIRowid=$p(str,"!",3)
	s find=1
	i Rowid="" d
	.zn "dhc-data"
	.s find=$$find^DHCPAOrderItemQty(PAADMTypeRowid,PatientTypeRowid,SIIRowid)
	.zn "dhc-app"
	q:(find=0) "-1"
	k PLIST
	s PLIST(3)=PatientTypeRowid
	s PLIST(2)=PAADMTypeRowid
	s PLIST(4)=SIIRowid
	s PLIST(5)=$p(str,"!",4)
	s PLIST(6)=$p(str,"!",5)
	zn "dhc-data"
	if (Rowid=""){
		s rtn=$$insert^DHCPAOrderItemQty()
	}else{
		s rtn=$$update^DHCPAOrderItemQty(Rowid)
	}
	zn "dhc-app"
	q rtn
}

Storage Default
{
<Data name="PAOrderItemQtyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.DHCDAF86.PAOrderItemQtyD</DataLocation>
<DefaultData>PAOrderItemQtyDefaultData</DefaultData>
<IdLocation>^DHCDoc.DHCDAF86.PAOrderItemQtyD</IdLocation>
<IndexLocation>^DHCDoc.DHCDAF86.PAOrderItemQtyI</IndexLocation>
<StreamLocation>^DHCDoc.DHCDAF86.PAOrderItemQtyS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
