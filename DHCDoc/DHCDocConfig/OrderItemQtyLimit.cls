Class DHCDoc.DHCDocConfig.OrderItemQtyLimit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 收费类别与处方类型
Query GetPAADMPrescTypeList() As %Query(ROWSPEC = "AILRowid:%String,PAADMType:%String,PAADMTypeDesc:%String,BillType:%String,BillTypeDesc:%String,PrescType:%String,PrescTypeDesc:%String,Default:%String")
{
}

ClassMethod GetPAADMPrescTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderItemQtyLimit","GetPAADMPrescTypeList")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    s AILRowid=0  f  s AILRowid=$o(^DHCPAADMPrescType(AILRowid)) q:AILRowid=""  d
    .s PAADMType=$p(^DHCPAADMPrescType(AILRowid),"^",1)
    .i PAADMType="O" s PAADMTypeDesc="门诊"
    .i PAADMType="I" s PAADMTypeDesc="住院"
    .i PAADMType="E" s PAADMTypeDesc="急诊"
    .i PAADMType="H" s PAADMTypeDesc="体检"
    .i PAADMType="N" s PAADMTypeDesc="新生儿"
    .s BillType=$p(^DHCPAADMPrescType(AILRowid),"^",2)
    .q:'$d(^PAC("ADMREA",BillType))
    .s BillTypeDesc=$p(^PAC("ADMREA",BillType),"^",2)
    .s PrescType=$p(^DHCPAADMPrescType(AILRowid),"^",3)
    .s PrescTypeDesc=$p(^DHCPrescriptType(PrescType),"^",2)
    .s Default=$p(^DHCPAADMPrescType(AILRowid),"^",4)
	.Do OutputRowGetPAADMPrescTypeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPAADMPrescTypeList
	set Data=$lb($g(AILRowid),$g(PAADMType),$g(PAADMTypeDesc),$g(BillType),$g(BillTypeDesc),$g(PrescType),$g(PrescTypeDesc),$g(Default))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPAADMPrescTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAADMPrescTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAADMPrescTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAADMPrescTypeListExecute ]
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
	s rtn=$$delete^DHCPAADMPrescType(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod insert(Str As %String) As %String
{
	s find=..find("",Str)
	q:find=0 "-1"
	k PLIST
	s PLIST(2)=$p(Str,"^",1)
	s PLIST(3)=$p(Str,"^",2)
	s PLIST(4)=$p(Str,"^",3)
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(7)=$p(Str,"^",6)
	s PLIST(8)=$p(Str,"^",7)
	s PLIST(9)=$p(Str,"^",8)
	zn "dhc-data"
	s rtn=$$insert^DHCPAADMPrescType()
	zn "dhc-app"
	q rtn
}

ClassMethod update(Rowid As %String, Str As %String) As %String
{
	s find=..find(Rowid,Str)
	q:find=0 "-1"
	k PLIST
	s PLIST(2)=$p(Str,"^",1)
	s PLIST(3)=$p(Str,"^",2)
	s PLIST(4)=$p(Str,"^",3)
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(7)=$p(Str,"^",6)
	s PLIST(8)=$p(Str,"^",7)
	s PLIST(9)=$p(Str,"^",8)
	zn "dhc-data"
	s rtn=$$update^DHCPAADMPrescType(Rowid)
	zn "dhc-app"
	q rtn
}

/// w ##class(DHCDoc.DHCDocConfig.OrderItemQtyLimit).find("","O^1^1^^^^^N")
ClassMethod find(Rowid As %String, Str As %String) As %String
{
	k PLIST
	s PAADMTypeRowid=$p(Str,"^",1)
	s BillType=$p(Str,"^",2)
	s PrescType=$p(Str,"^",3)
	zn "dhc-data"
	s find=$$find^DHCPAADMPrescType(PAADMTypeRowid,BillType,PrescType)
	if (find=0)&&(Rowid'=""){
		if (Rowid=PLIST(1)) s find=100
	}
	zn "dhc-app"
	q find
}

Query FindBillTypeConfig(value As %String) As %Query(ROWSPEC = "BillTypeRowid:%String,BillTypeDesc:%String,selected:%Boolean")
{
}

ClassMethod FindBillTypeConfigExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	s ^tempscl("value")=value
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderItemQtyLimit","FindBillTypeConfig","QuickAdmBillType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BillTypeRowid=0
    f  s BillTypeRowid=$o(^PAC("ADMREA",BillTypeRowid)) q:BillTypeRowid=""  d
    .s BillTypeDesc=$p(^PAC("ADMREA",BillTypeRowid),"^",2)
    .s selected=0
    .i (value'="")&&(BillTypeRowid=value) s selected=1
	.Do OutputRowFindBillTypeConfig
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindBillTypeConfig
	set Data=$lb($g(BillTypeRowid),$g(BillTypeDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindBillTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBillTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillTypeConfigExecute ]
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

}
