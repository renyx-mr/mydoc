Class DHCDoc.DHCDocConfig.DiagnosCat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->特殊诊断分类 特殊诊断列表
Query GetDiagnosCat() As %Query(ROWSPEC = "DCRowid:%String,DCCode:%String,DCDesc:%String,DCPAADMType:%String,PAADMType:%String,DCBillType:%String,BillType:%String,DCDuration:%String,Duration:%String,DCType:%String,Type:%String")
{
}

ClassMethod GetDiagnosCatExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DiagnosCat","GetDiagnosCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    //q:InstrRowId="" ""
	s DCRowid=0 
	f  s DCRowid=$o(^DHCDiagnosCat(DCRowid)) q:DCRowid=""  d
	.s DCCode=$p(^DHCDiagnosCat(DCRowid),"^",6)
	.s DCDesc=$p(^DHCDiagnosCat(DCRowid),"^",1)
	.s DCPAADMType=$p(^DHCDiagnosCat(DCRowid),"^",2)
	.s PAADMType=""
	.i DCPAADMType="I" s PAADMType="InPatient"
	.i DCPAADMType="O" s PAADMType="OutPatient"
	.i DCPAADMType="E" s PAADMType="Emergency"
	.s DCBillType=$p(^DHCDiagnosCat(DCRowid),"^",3)
	.s BillType=""
	.i DCBillType'="" s BillType=$p(^PAC("ADMREA",DCBillType),"^",2)
	.s DCDuration=$p(^DHCDiagnosCat(DCRowid),"^",4)
	.s Duration=""
	.i DCDuration'="" s Duration=$p(^PHCDU(DCDuration),"^",3)
	.s DCType=$p(^DHCDiagnosCat(DCRowid),"^",5)
	.s Type=""
	.i DCType="S" s Type="特殊病"
	.i DCType="M" s Type="慢性病"
	.i DCType="C" s Type="押金"
	.Do OutputRowGetDiagnosCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnosCat
	set Data=$lb($g(DCRowid),$g(DCCode),$g(DCDesc),$g(DCPAADMType),$g(PAADMType),$g(DCBillType),$g(BillType),$g(DCDuration),$g(Duration),$g(DCType),$g(Type))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosCatExecute ]
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

ClassMethod delete(Rowid As %String) As %String
{
	&sql(delete from SQLUser.DHC_DiagnosCat where DC_Rowid=:Rowid)
	q SQLCODE
}

ClassMethod insert(str As %String) As %String
{
	 K PLIST(1)
	 s PLIST(2)=$p(str,"!",2)
	 s PLIST(3)=$p(str,"!",3)
	 s PLIST(4)=$p(str,"!",4)
	 Q:'$d(^PAC("ADMREA",$p(str,"!",4))) "-1"
	 s PLIST(5)=$p(str,"!",5)
	 Q:'$d(^PHCDU($p(str,"!",5))) "-2"
	 s PLIST(6)=$p(str,"!",6)
	 s PLIST(7)=$p(str,"!",1)
	 &sql(insert into SQLUser.DHC_DiagnosCat values :PLIST())
	 q SQLCODE
}

// w ##class(DHCDoc.DHCDocConfig.DiagnosCat).update(22,"01!测试2!I!1!112!M")

ClassMethod update(Rowid As %String, str As %String) As %String
{
	s Desc=$p(str,"!",2)
	s PAADMTypeRowid=$p(str,"!",3)
	s BillTypeRowid=$p(str,"!",4)
	Q:'$d(^PAC("ADMREA",BillTypeRowid)) "-1"
	s DurationRowid=$p(str,"!",5)
	Q:'$d(^PHCDU(DurationRowid)) "-2"
	s DiagCatTypeRowid=$p(str,"!",6)
	s Code=$p(str,"!",1)
	&sql(update SQLUser.DHC_DiagnosCat set DC_Desc=:Desc,DC_PAADMType=:PAADMTypeRowid,DC_BillType_DR=:BillTypeRowid,DC_Duration_DR=:DurationRowid,DC_Type=:DiagCatTypeRowid,DC_Code=:Code where DC_Rowid=:Rowid )
	q SQLCODE
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->特殊诊断分类 诊断明细
Query GetDiagnosCatDetail(DCRowid As %String) As %Query(ROWSPEC = "DiagnosCatDetailID:%String,DCDDiagnosDR:%String,MRCIDDesc:%String,MRCIDCode:%String")
{
}

ClassMethod GetDiagnosCatDetailExecute(ByRef qHandle As %Binary, DCRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DiagnosCat","GetDiagnosCatDetail",)
	Set repid=$I(^CacheTemp)
    Set ind=1
	s DCDChildSub=0 
	f  s DCDChildSub=$o(^DHCDiagnosCat(DCRowid,"Detail",DCDChildSub)) q:DCDChildSub=""  d
	.s DCDDiagnosDR=$p(^DHCDiagnosCat(DCRowid,"Detail",DCDChildSub),"^",1)
	.s MRCIDDesc=$p(^MRC("ID",DCDDiagnosDR),"^",2)
	.s MRCIDCode=$p(^MRC("ID",DCDDiagnosDR),"^",1)
	.s DiagnosCatDetailID=DCRowid_"||"_DCDChildSub
	.Do OutputRowGetDiagnosCatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnosCatDetail
	set Data=$lb($g(DiagnosCatDetailID),$g(DCDDiagnosDR),$g(MRCIDDesc),$g(MRCIDCode))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosCatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosCatDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosCatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosCatDetailExecute ]
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

ClassMethod insertDetail(CatRowid As %String, ICDDr As %String) As %String
{
	  s id=""
	  &sql(select DCD_Rowid into :id from SQLUser.DHC_DiagnosCatDetail where DCD_Diagnos_DR=:ICDDr and DCD_DC_ParRef=:CatRowid)
	  q:id'="" "-1"
	  K PLIST(1)
	  s PLIST(0)=CatRowid
	  s PLIST(3)=ICDDr
	  &sql(insert into SQLUser.DHC_DiagnosCatDetail values :PLIST())
      q SQLCODE
}

ClassMethod updateDetail(Rowid As %String) As %String
{
	  s DiagnoseRowid=PLIST(3)
	  &sql(update SQLUser.DHC_DiagnosCatDetail set DCD_Diagnos_DR=:DiagnoseRowid where DCD_Rowid=:Rowid )
	  q SQLCODE
}

ClassMethod deleteDetail(Rowid As %String) As %String
{
	 &sql(delete from SQLUser.DHC_DiagnosCatDetail where DCD_Rowid=:Rowid)
	 q SQLCODE
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->特殊诊断分类 医嘱明细
Query GetDiagnosCatItem(DCRowid As %String) As %Query(ROWSPEC = "DiagnosCatItemID:%String,DCIARCIMDR:%String,ARCIMDesc:%String,DCIDurationDR:%String,PHCDUDesc:%String,DCIYearMaxQty:%String,DCIMonthMaxQty:%String")
{
}

ClassMethod GetDiagnosCatItemExecute(ByRef qHandle As %Binary, DCRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DiagnosCat","GetDiagnosCatItem",)
	Set repid=$I(^CacheTemp)
    Set ind=1
	s DCDChildSub=0 
	f  s DCDChildSub=$o(^DHCDiagnosCat(DCRowid,"Item",DCDChildSub)) q:DCDChildSub=""  d
	.s DCIARCIMDR=$p(^DHCDiagnosCat(DCRowid,"Item",DCDChildSub),"^",1)
	.s ARCIMDesc=""
	.s:DCIARCIMDR'="" ARCIMDesc=$p(^ARCIM(+DCIARCIMDR,$p(DCIARCIMDR,"||",2),1),"^",2)
	.s DCIDurationDR=$p(^DHCDiagnosCat(DCRowid,"Item",DCDChildSub),"^",2)
	.s PHCDUDesc=""
	.s:DCIDurationDR'="" PHCDUDesc=$p(^PHCDU(DCIDurationDR),"^",3)
	.s DCIYearMaxQty=$p(^DHCDiagnosCat(DCRowid,"Item",DCDChildSub),"^",3)
	.s DCIMonthMaxQty=$p(^DHCDiagnosCat(DCRowid,"Item",DCDChildSub),"^",4)
	.s DiagnosCatItemID=DCRowid_"||"_DCDChildSub
	.Do OutputRowGetDiagnosCatItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDiagnosCatItem
	set Data=$lb($g(DiagnosCatItemID),$g(DCIARCIMDR),$g(ARCIMDesc),$g(DCIDurationDR),$g(PHCDUDesc),$g(DCIYearMaxQty),$g(DCIMonthMaxQty))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDiagnosCatItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosCatItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosCatItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosCatItemExecute ]
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

ClassMethod deleteItem(Rowid As %String) As %String
{
	 &sql(delete from SQLUser.DHC_DiagnosCatItem where DCI_Rowid=:Rowid)
	 q SQLCODE
}

ClassMethod insertItem(CatRowid As %String, str As %String) As %String
{
	 K PLIST
	 s PLIST(3)=$p(str,",",1)
	 s PLIST(4)=$p(str,",",2)
	 s PLIST(5)=$p(str,",",3)
	 s PLIST(6)=$p(str,",",4)
	 s PLIST(0)=CatRowid
	 b 
	 &sql(insert into SQLUser.DHC_DiagnosCatItem values :PLIST())
	 q SQLCODE
}

ClassMethod updateItem(Rowid As %String, str As %String) As %String
{
	  s ItemRowid=$p(str,",",1)
      s DurationRowid=$p(str,",",2)
      s YearMaxQty=$p(str,",",3)
      s MonthMaxQty=$p(str,",",4)
	&sql(update SQLUser.DHC_DiagnosCatItem set DCI_ARCIM_DR=:ItemRowid,DCI_Duration_DR=:DurationRowid,DCI_YearMaxQty=:YearMaxQty,DCI_MonthMaxQty=:MonthMaxQty where DCI_Rowid=:Rowid )
	q SQLCODE
}

}
