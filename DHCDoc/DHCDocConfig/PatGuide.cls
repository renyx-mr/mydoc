/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 导诊单配置业务类
Class DHCDoc.DHCDocConfig.PatGuide Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 保存/更新导诊单配置HUI
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).DBSave(1)
ClassMethod DBSave(inPara As %String) As %String
{
	n (inPara)
	s PGId = 		$p(inPara,"^",1)
	s PGType = 		$p(inPara,"^",2)
	s PGPrj = 		$p(inPara,"^",3)
	s PGOrdLoc = 	$p(inPara,"^",4)
	s PGAcceptLoc = $p(inPara,"^",5)
	s PGSTime = 	$p(inPara,"^",6)
	s PGETime = 	$p(inPara,"^",7)
	s PGSite = 		$p(inPara,"^",8)
	s PGIsDetail = 	$p(inPara,"^",9)
	i PGSTime'="" s PGSTime = $zth(PGSTime,2)
	i PGETime'="" s PGETime = $zth(PGETime,2)
	i PGId = "" s PGOBJ = ##class(User.DHCDocPatGuide).%New()
	e  s PGOBJ = ##class(User.DHCDocPatGuide).%OpenId(PGId)
	s PGOBJ.PGType = PGType
	s PGOBJ.PGPrjDR = PGPrj
	s PGOBJ.PGOrdLoc = PGOrdLoc
	s PGOBJ.PGAcceptLoc = PGAcceptLoc
	s PGOBJ.PGSTime = PGSTime
	s PGOBJ.PGETime = PGETime
	s PGOBJ.PGSite = PGSite
	s PGOBJ.PGIsDetail = PGIsDetail
	s sc = PGOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		TRollback
		Quit "-100"
	}
		
	q PGOBJ.%Id()
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 删除导诊单配置HUI
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).DBDelete(1)
ClassMethod DBDelete(PGId As %String) As %String
{
	n (PGId)
	q:PGId="" -1
	TS
		&SQL(DELETE FROM SQLUser.DHC_DocPatGuide WHERE PG_RowId=:PGId)
	i SQLCODE {
		TRO
		Q "-2"
	}
	TC
	q SQLCODE
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 保存温馨提示配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).DBSaveTip()
ClassMethod DBSaveTip(hospId As %String, value As %String)
{
	n (hospId,value)
	s mRtn = 0
	s ^CF.DOC.CommonD("PatGuide","Tips",hospId) = value
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 删除温馨提示配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).DBDeleteTip()
ClassMethod DBDeleteTip(id)
{
	n (id)
	s mRtn = 0
	k ^CF.DOC.CommonD("PatGuide","Tips",id)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 温馨提示是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).HasTip(2)
ClassMethod HasTip(hospId)
{
	n (hospId)
	s mRtn = 0
	s id = ""
	f  s id = $o(^CF.DOC.CommonD("PatGuide","Tips",id)) q:(id="")||(mRtn=1)  d
	.i hospId = id s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 导诊配置是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).HasPatGuide("OECat","1")
ClassMethod HasPatGuide(inType = "", inPrj = "", inOrdLoc = "", inAcceptLoc = "")
{
	n (inType,inPrj,inOrdLoc,inAcceptLoc)
	s mRtn = 0
	q:(inType="")||(inPrj="") mRtn
	i inOrdLoc'="" {
		s PGId = ""
		f  s PGId = $o(^CF.DOC.PatGuideI("TypeOrdLoc",inType,inOrdLoc,PGId),-1) q:(PGId="")||(mRtn=1)  d
		.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
		.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
		.s PGPrj =  $p(^CF.DOC.PatGuide(PGId),"^",2)
		.q:PGPrj'=inPrj
		.i (PGOrdLoc=inOrdLoc)&&(inAcceptLoc=PGAcceptLoc) s mRtn=1
	}
	Q:mRtn=1 mRtn
	
	i inAcceptLoc'="" {
		s PGId = ""
		f  s PGId = $o(^CF.DOC.PatGuideI("TypeAcceptLoc",inType,inAcceptLoc,PGId),-1) q:(PGId="")||(mRtn=1)  d
		.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
		.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
		.s PGPrj =  $p(^CF.DOC.PatGuide(PGId),"^",2)
		.q:PGPrj'=inPrj
		.i (PGOrdLoc=inOrdLoc)&&(inAcceptLoc=PGAcceptLoc) s mRtn=1
	}
	Q:mRtn=1 mRtn
	
	s PGId = ""
	f  s PGId = $o(^CF.DOC.PatGuideI("TypePrj",inType,inPrj,PGId),-1) q:(PGId="")||(mRtn=1)  d
	.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
	.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
	.q:(PGOrdLoc'="")||(PGAcceptLoc'="")||(inOrdLoc'="")||(inAcceptLoc'="")
	.s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 根据类型和项目DR获取项目描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).GetPrjDesc("OECatItem",1)
ClassMethod GetPrjDesc(prjType, prjDr)
{
	n (prjType,prjDr)
	s mRtn = ""
	if prjType = "BB" {
		if $d(^DHCLISBSVersion(1)) {
			s mRtn = $lg($g(^dbo.BTSpecimenD(prjDr)),3)
		} else {
			s mRtn = $p(^TTAB("SPEC",prjDr),"\",1)
		}
	}
	if prjType = "OECat" {
		s mRtn = $p(^OEC("ORCAT",prjDr),"^",2)
	}
	if prjType = "OECatItem" {
		s mRtn = $p(^ARC("IC",prjDr),"^",2)
	}
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 获取导诊单配置信息
/// IN  : 
/// OUT : 开始时间^接受时间^是否显示明细^导诊位置
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).GetPatGuideInfo("OECat","1")
ClassMethod GetPatGuideInfo(inType = "", inPrj = "", inOrdLoc = "", inAcceptLoc = "") As %String
{
	n (inType,inPrj,inOrdLoc,inAcceptLoc)
	s mRtn = ""
	q:(inType = "")||(inPrj = "") mRtn
	s findFlag = 0
	i inOrdLoc '= "" {
		s PGId = ""
		f  s PGId = $o(^CF.DOC.PatGuideI("TypeOrdLoc",inType,inOrdLoc,PGId),-1) q:(PGId="")||(findFlag=1)  d
		.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
		.s PGPrj =  $p(^CF.DOC.PatGuide(PGId),"^",2)
		.q:PGPrj'=inPrj
		.s PGSTime = $p(^CF.DOC.PatGuide(PGId),"^",5)
		.s PGETime = $p(^CF.DOC.PatGuide(PGId),"^",6)
		.s PGSite = $p(^CF.DOC.PatGuide(PGId),"^",7)
		.s PGIsDetail = $p(^CF.DOC.PatGuide(PGId),"^",8)
		.q:(inAcceptLoc'="")&&(inAcceptLoc'=PGAcceptLoc)
		.i (inAcceptLoc'="")&&(inAcceptLoc=PGAcceptLoc) s findFlag = 1,mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
		.i (inAcceptLoc="") s findFlag = 1,mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
	}
	Q:findFlag=1 mRtn
	
	i inAcceptLoc '= "" {
		s PGId = ""
		f  s PGId = $o(^CF.DOC.PatGuideI("TypeAcceptLoc",inType,inAcceptLoc,PGId),-1) q:(PGId="")||(findFlag=1)  d
		.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
		.s PGPrj =  $p(^CF.DOC.PatGuide(PGId),"^",2)
		.q:PGPrj'=inPrj
		.s PGSTime = $p(^CF.DOC.PatGuide(PGId),"^",5)
		.s PGETime = $p(^CF.DOC.PatGuide(PGId),"^",6)
		.s PGSite = $p(^CF.DOC.PatGuide(PGId),"^",7)
		.s PGIsDetail = $p(^CF.DOC.PatGuide(PGId),"^",8)
		.s mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
		.q:(inOrdLoc'="")&&(inOrdLoc'=PGOrdLoc)
		.i (inOrdLoc'="")&&(inOrdLoc=PGOrdLoc) s findFlag = 1,mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
		.i (inOrdLoc="") s findFlag = 1,mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
	}
	Q:findFlag=1 mRtn
	
	s PGId = ""
	f  s PGId = $o(^CF.DOC.PatGuideI("TypePrj",inType,inPrj,PGId),-1) q:(PGId="")||(findFlag=1)  d
	.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
	.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
	.q:(PGOrdLoc'="")||(PGAcceptLoc'="")||(inOrdLoc'="")||(inAcceptLoc'="")
	.s PGSTime = $p(^CF.DOC.PatGuide(PGId),"^",5)
	.s PGETime = $p(^CF.DOC.PatGuide(PGId),"^",6)
	.s PGSite = $p(^CF.DOC.PatGuide(PGId),"^",7)
	.s PGIsDetail = $p(^CF.DOC.PatGuide(PGId),"^",8)
	.s findFlag = 1,mRtn = PGSTime_"^"_PGETime_"^"_PGIsDetail_"^"_PGSite
	
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 获取医院温馨提示
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PatGuide).GetHospTip(2)
ClassMethod GetHospTip(hospId) As %String
{
	n (hospId)
	q $g(^CF.DOC.CommonD("PatGuide","Tips",hospId))
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 根据类型获取项目描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryPrjDesc","BB")
Query QryPrjDesc(inType, OECatDR = "") As %Query(CONTAINID = 1, ROWSPEC = "id,desc,ContactName")
{
}

ClassMethod QryPrjDescExecute(ByRef qHandle As %Binary, inType, OECatDR = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i inType=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//标本
	i inType="BB" {
		i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
		i $d(^DHCLISBSVersion(1)) {
	   	 	s HospitalCode=$g(HospitalCode)
			s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
			i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
			i $l(HospitalDR) {
				s SPECstr=""
				s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
				.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
				.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
				.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
				.s id=SpecimenDR
				.s ContactName=SPECCode_"-"_SPECDesc
				.s desc=SPECDesc
				.d OutputRow1
			}
    	}else{
			s SpecRowid=""
			s SpecDesc=""
			f  s SpecRowid=$O(^TTAB("SPEC",SpecRowid)) q:SpecRowid=""  d
			.s SpecDesc=$p(^TTAB("SPEC",SpecRowid),"\",1)
			.q:(SpecDesc="")&&(SpecRowid=0)
			.s id=SpecRowid
			.s ContactName=""
			.s desc=SPECDesc
			.d OutputRow1
		}
	}
	//医嘱大类
	i inType="OECat" {
		s OrdCatRowID=""
		f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
		.s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
		.q:(OrdCatDesc="")&&(OrdCatRowID=0)
		.s id=OrdCatRowID
		.s desc=OrdCatDesc
		.s ContactName=""
		.d OutputRow1
	}
	//医嘱子类
	i inType="OECatItem" {
		q:OECatDR=""
		s ItemCatRowID=""
		f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OECatDR,ItemCatRowID)) q:ItemCatRowID=""  d
		.s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
		.q:(ItemCatDesc="")&&(ItemCatRowID=0)
		.s id=ItemCatRowID
		.s desc=ItemCatDesc
		.s ContactName=""
		.d OutputRow1
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow1
	set Data=$lb(id,desc,ContactName)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
}

ClassMethod QryPrjDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrjDescExecute ]
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
 Else  {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrjDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrjDescExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 根据类型获取导诊单配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryPatGuide","")
Query QryPatGuide(inType = "", inOrdLoc = "", inAcceptLoc = "") As %Query(CONTAINID = 1, ROWSPEC = "PGId,PGType,PGTypeDesc,PGPrjDR,PGPrj,PGOrdLoc,PGOrdLocDesc,PGAcceptLoc,PGAcceptLocDesc,PGSTime,PGETime,PGSite,PGIsDetail,OECat")
{
}

ClassMethod QryPatGuideExecute(ByRef qHandle As %Binary, inType = "", inOrdLoc = "", inAcceptLoc = "") As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	s (PGType,PGTypeDesc,PGPrjDR,PGPrj,PGOrdLoc,PGOrdLocDesc,PGAcceptLoc,PGAcceptLocDesc,PGSTime,PGETime,PGSite) = ""
	i inType="" s inType = "OECat^医嘱大类,OECatItem^医嘱子类,BB^标本"
	s Len=$l(inType,",")
	f i = 1:1:Len {
		s PGId = ""
		s Record = $p(inType,",",i)
		s PGType = $p(Record,"^",1)
		s PGTypeDesc = $p(Record,"^",2)
		f  s PGId = $o(^CF.DOC.PatGuideI("PGType",PGType,PGId)) q:PGId=""  d
		.s PGPrjDR = $p(^CF.DOC.PatGuide(PGId),"^",2)
		.s PGPrj = ..GetPrjDesc(PGType,PGPrjDR)
		.s OECat = "",PGOrdLocDesc="",PGAcceptLocDesc=""
		.i (PGType="OECatItem")&&(PGPrj'="") s OECat = $p(^ARC("IC",PGPrjDR),"^",8)
		.s PGOrdLoc = $p(^CF.DOC.PatGuide(PGId),"^",3)
		.q:(inOrdLoc'="")&&(inOrdLoc'=PGOrdLoc)
		.i PGOrdLoc '= ""  s PGOrdLocDesc = $p(^CTLOC(PGOrdLoc),"^",2)
		.s PGAcceptLoc = $p(^CF.DOC.PatGuide(PGId),"^",4)
		.q:(inAcceptLoc'="")&&(inAcceptLoc'=PGAcceptLoc)
		.i PGAcceptLoc '= ""  s PGAcceptLocDesc = $p(^CTLOC(PGAcceptLoc),"^",2)
		.s PGSTime = $p(^CF.DOC.PatGuide(PGId),"^",5)
		.i PGSTime'="" s PGSTime=$zt(PGSTime,2)
		.s PGETime = $p(^CF.DOC.PatGuide(PGId),"^",6)
		.i PGETime'="" s PGETime=$zt(PGETime,2)
		.s PGSite = $p(^CF.DOC.PatGuide(PGId),"^",7)
		.s PGIsDetail = $p(^CF.DOC.PatGuide(PGId),"^",8)
		.d OutputRow2
		
	}
	
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow2
	set Data = $lb(PGId,PGType,PGTypeDesc,PGPrjDR,PGPrj,PGOrdLoc,PGOrdLocDesc,PGAcceptLoc,PGAcceptLocDesc,PGSTime,PGETime,PGSite,PGIsDetail,OECat)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryPatGuideFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatGuideExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPatGuideClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatGuideExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryPrjType")
Query QryPrjType() As %Query(CONTAINID = 1, ROWSPEC = "code,desc")
{
}

ClassMethod QryPrjTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	
 	s inType = "OECat^医嘱大类,OECatItem^医嘱子类,BB^标本"
	s Len=$l(inType,",")
	f i = 1:1:Len {
		s Record = $p(inType,",",i)
		s code = $p(Record,"^",1)
		s desc = $p(Record,"^",2)
		d OutputRow3
	}
	
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow3
	set Data = $lb(code,desc)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryPrjTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrjTypeExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrjTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrjTypeExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryLoc")
Query QryLoc() As %Query(CONTAINID = 1, ROWSPEC = "id,desc,ContactName")
{
}

ClassMethod QryLocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	
 	s rowid=0 f  s rowid=$O(^CTLOC(rowid)) q:rowid=""  d	
	.s id=rowid
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.s CTContactNameTem=""
	.i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2,$L(CTDesc,"-"))
	.s CTDesc=$TR(CTDesc,"-")
	.s desc=CTDesc
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.s ContactName=CTContactName
	.d OutputRow4
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow4
	set Data = $lb(id,desc,ContactName)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 温馨提示查询
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryTip")
Query QryTip() As %Query(CONTAINID = 1, ROWSPEC = "id,typeDesc,desc")
{
}

ClassMethod QryTipExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	//旧版本：^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",hospId)
 	//新版本：^CF.DOC.CommonD("PatGuide","Tips",hospId)=""
 	s hospId=""
	f  s hospId=$o(^CF.DOC.CommonD("PatGuide","Tips",hospId)) q:hospId=""  d
	.s typeDesc=$p(^CT("HOSP",hospId),"^",2)
	.s id=hospId
	.s desc=$g(^CF.DOC.CommonD("PatGuide","Tips",hospId))
	.d OutputRow5
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow5
	set Data = $lb(id,typeDesc,desc)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryTipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTipExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryTipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTipExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询医院
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PatGuide","QryHosp")
Query QryHosp() As %Query(CONTAINID = 1, ROWSPEC = "id,desc,ContactName")
{
}

ClassMethod QryHospExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	s HospRowid=""
	f  s HospRowid=$O(^CT("HOSP",HospRowid)) q:HospRowid=""  d
	.s HospDesc=$p(^CT("HOSP",HospRowid),"^",2)
	.q:(HospDesc="")&&(HospRowid=0)	
	.s id=HospRowid
	.s desc=HospDesc
	.s ContactName=""
	.d OutputRow6
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow6
	set Data = $lb(id,desc,ContactName)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
