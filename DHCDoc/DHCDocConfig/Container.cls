Class DHCDoc.DHCDocConfig.Container Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->检验容器关联医嘱设置 查询容器
Query GetContainerList(HospitalCode As %String = "") As %Query(ROWSPEC = "ConCode:%String,ConDesc:%String,BloodFlag:%String,BloodFlagDesc:%String")
{
}

ClassMethod GetContainerListExecute(ByRef qHandle As %Binary, HospitalCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Container","GetContainerList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
    i $d(^DHCLISBSVersion(1)) {
	    s HospitalCode=$g(HospitalCode)
		s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
		i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
		i $l(HospitalDR) {
			s Constr=""
			s Con="" f  s Con=$o(^dbo.BTContainerI("IndexCode",HospitalDR,Con)) q:Con=""  d
			.s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,Con,""))
			.s ConCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
			.s ConDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
			.s BloodFlag=$p($g(^DHCDocLabLI("CON",ConCode,"DHC")),"\",1)
			.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
			.Do OutputRowGetContainerList
		}
    }else{
	 	s ConCode="" f  s ConCode=$o(^DHCDocLabLI("CON",ConCode)) q:ConCode=""  d
		.s ConDesc=$p($g(^DHCDocLabLI("CON",ConCode)),"\",1)
		.s BloodFlag=$p($g(^DHCDocLabLI("CON",ConCode,"DHC")),"\",1)
		.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
		.Do OutputRowGetContainerList
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetContainerList
	set Data=$lb($g(ConCode),$g(ConDesc),$g(BloodFlag),$g(BloodFlagDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetContainerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContainerListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetContainerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContainerListExecute ]
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

Query GetBloodFlagList(ConCode As %String) As %Query(ROWSPEC = "BloodFlag:%String,BloodFlagDesc:%String,selected:%Boolean")
{
}

ClassMethod GetBloodFlagListExecute(ByRef qHandle As %Binary, ConCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Container","GetBloodFlagList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BloodFlagStr="1^2^3^4"
    For i=1:1:$l(BloodFlagStr,"^") d
    .s BloodFlag=$p(BloodFlagStr,"^",i)
	.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
	.s selected=0
	.i ConCode'="" d
	..i $p($g(^DHCDocLabLI("CON",ConCode,"DHC")),"\",1)=BloodFlag  s selected=1
	.Do OutputRowGetBloodFlagList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetBloodFlagList
	set Data=$lb($g(BloodFlag),$g(BloodFlagDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetBloodFlagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBloodFlagListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBloodFlagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBloodFlagListExecute ]
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
/// date:2015-05-04
/// desc:医生站设置程序->检验容器关联医嘱设置 根据容器查询关联医嘱
Query GetItemByConCode(ConCode As %String) As %Query(ROWSPEC = "SPECIARCIMDR:%String,SPECIARCIMDesc:%String,SPECIQty:%String,rowid:%String")
{
}

ClassMethod GetItemByConCodeExecute(ByRef qHandle As %Binary, ConCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Container","GetItemByConCode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    zn "dhc-data"
    i ConCode'="" d
	.s SPECIChildsub=0  f  s SPECIChildsub=$o(^DHCDocLabLI("CON",ConCode,"Item",SPECIChildsub)) q:SPECIChildsub=""  d
	..s SPECIARCIMDR=$p($g(^DHCDocLabLI("CON",ConCode,"Item",SPECIChildsub)),"^",1)
	..s SPECIARCIMDesc=$p($g(^ARCIM(+SPECIARCIMDR,$p(SPECIARCIMDR,"||",2),1)),"^",2)
	..s SPECIQty=$p($g(^DHCDocLabLI("CON",ConCode,"Item",SPECIChildsub)),"^",2)
	..Do OutputRowGetItemByConCode
	zn "dhc-app"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItemByConCode
	set Data=$lb($g(SPECIARCIMDR),$g(SPECIARCIMDesc),$g(SPECIQty),ConCode_"||"_SPECIChildsub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetItemByConCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemByConCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemByConCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemByConCodeExecute ]
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

ClassMethod Delete(rowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCCTContainerLinkItem(rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod Insert(code As %String, arcrowid As %String, qty As %String) As %String
{
	s CONIChildsub=0,Find=0
	f  s CONIChildsub=$o(^DHCDocLabLI("CON",code,"Item",CONIChildsub)) q:(CONIChildsub="")||(Find=1)  d
	.s ARCIMDr=$p(^DHCDocLabLI("CON",code,"Item",CONIChildsub),"^",1)
	.i ARCIMDr=arcrowid s Find=1
	q:Find=1 "-1"
	if '$D(^ARCIM($P(arcrowid,"||",1))){
		q "-2"
	}
	zn "dhc-data"
	s rtn=$$Insert^DHCCTContainerLinkItem(code,arcrowid,qty)
	zn "dhc-app"
	q rtn
}

ClassMethod updateContainerBloodFlag(rowid, BloodFlag)
{
	s $P(^DHCDocLabLI("CON",rowid,"DHC"),"\",1)=BloodFlag
	q 0
}

ClassMethod GetBloodFlagDesc(BloodFlagCode As %String) As %String
{
	s BloodFlagDesc=""
	s:BloodFlag=1 BloodFlagDesc="静脉统一采血"
	s:BloodFlag=2 BloodFlagDesc="按容器取血"
	s:BloodFlag=3 BloodFlagDesc="动脉统一采血"
	s:BloodFlag=4 BloodFlagDesc="末梢统一采血"
	q BloodFlagDesc
}

}
