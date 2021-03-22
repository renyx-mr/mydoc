Class DHCDoc.DHCDocConfig.CNMedCode Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->常规设置 查询费别
Query FindBillTypeConfig(value As %String) As %Query(ROWSPEC = "BillTypeRowid:%String,BillTypeDesc:%String,BillTypeDuration:%String,DiagnosCatArcimAllow:%String,NotAllowItemInDuration:%String,BillTypeDurationDr:%String,selected:%Boolean")
{
}

ClassMethod FindBillTypeConfigExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindBillTypeConfig","QuickAdmBillType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BillTypeRowid=0
    f  s BillTypeRowid=$o(^PAC("ADMREA",BillTypeRowid)) q:BillTypeRowid=""  d
    .s BillTypeDesc=$p(^PAC("ADMREA",BillTypeRowid),"^",2)
    .s BillTypeDuration=""
    .s BillTypeDurationDr=$g(^DHCDocConfig("BillTypeDuration",BillTypeRowid))
    .s:BillTypeDurationDr'="" BillTypeDuration=$p(^PHCDU(BillTypeDurationDr),"^",1)
    .s DiagnosCatArcimAllow=$g(^DHCDocConfig("DiagnosCatArcimAllow",BillTypeRowid))
    .s DiagnosCatArcimAllow=$s(DiagnosCatArcimAllow=1:"Y",DiagnosCatArcimAllow=0:"N",1:"N")
    .s NotAllowItemInDuration=$g(^DHCDocConfig("NotAllowItemInDuration",BillTypeRowid))
    .s NotAllowItemInDuration=$s(NotAllowItemInDuration=1:"Y",NotAllowItemInDuration=0:"N",1:"N")
    .s selected=0
    .i value'="" d
    ..i ("^"_$g(^DHCDocConfig(value))_"^")[("^"_BillTypeRowid_"^")  s selected=1
	.Do OutputRowFindBillTypeConfig
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindBillTypeConfig
	set Data=$lb($g(BillTypeRowid),$g(BillTypeDesc),$g(BillTypeDuration),$g(DiagnosCatArcimAllow),$g(NotAllowItemInDuration),$g(BillTypeDurationDr),$g(selected))
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->常规设置 查询icd诊断列表
Query FindDiagnoseList(desc As %String) As %Query(ROWSPEC = "MRCIDRowId:%String,MRCIDDesc:%String")
{
}

ClassMethod FindDiagnoseListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindDiagnoseList")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s len=$l(desc)
    s control=$e(desc,len)
    i (control="#"){s desc=$e(desc,1,len-1)}
    s Rowid=0 f  s Rowid=$o(^MRC("ID",Rowid)) q:Rowid=""  d
	.s DateFrom=$P($G(^MRC("ID",Rowid)),"^",6)
	.s DateTo=$P($G(^MRC("ID",Rowid)),"^",7)
	.Q:(DateFrom'="")&&(DateFrom>+$H)
	.Q:(DateTo'="")&&(DateTo<+$H)
	.s desc=$ZCONVERT(desc,"U")
	.s desc1=$p(^MRC("ID",Rowid),"^",2)
	.s desc1=$ZCONVERT(desc1,"U")
	.s code=$p(^MRC("ID",Rowid),"^",1)
	.s rowid=Rowid
	.s MetastaticSite=$P($G(^MRC("ID",rowid)),"^",40) ;Y 肿瘤形态学编码 医生不使用
	.s IPCode=$P($G(^MRC("ID",rowid)),"^",41)  ;Injury/Poisoning 损伤中毒外部原因 医生不使用
	.Q:(MetastaticSite="Y")||(IPCode="Y")
	.Q:$d(^TMPAliasDiagnos($j,rowid))
	.s AliasRowid=0 f  s AliasRowid=$o(^MRC("ID",Rowid,"ALIAS",AliasRowid)) q:AliasRowid=""  d
	..s Alias=^MRC("ID",Rowid,"ALIAS",AliasRowid)
	..s Alias=$ZCONVERT(Alias,"U")
	..Q:$d(^TMPAliasDiagnos($j,rowid))
	..s desc1=Alias_"-"_desc1
	..i (control="#") s len1=$l(desc) s len2=$l(Alias) q:len1'=len2
	..i ((control="#")&&(Alias=desc)) Do OutputRowFindDiagnoseList
	..i ((control'="#")&&((Alias[(desc))||(desc1[(desc)))) Do OutputRowFindDiagnoseList
	kill ^TMPAliasDiagnos($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDiagnoseList
    set desc1=$tr(desc1,",","")
    set desc1=$tr(desc1," ","")
    set desc1=$tr(desc1,"	","")
    set desc1=##class(web.DHCDocUtil).EvalJSON($g(desc1))
	set Data=$lb($g(Rowid),$g(desc1))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDiagnoseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiagnoseListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDiagnoseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiagnoseListExecute ]
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
/// desc:医生站设置程序->常规设置 查询门诊科室
Query FindOPLoc(value As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindOPLocExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindOPLoc","QuickAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ADMLOCRowId=0
    f  s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""  d 
    .s ADMLOCAdmType=$p(^PAC("ADMLOC",ADMLOCRowId),"^",1)
    .q:ADMLOCAdmType'="O"
    .s LocID=$p(^PAC("ADMLOC",ADMLOCRowId),"^",2)
    .s LocDesc=$p(^CTLOC(LocID),"^",2)
    .s CTLocContactName=$P(^CTLOC(LocID),"^",43)
    .s LocDesc=CTLocContactName_" "_LocDesc
    .s selected=0
    .i value'="" d
    ..i LocID=$g(^DHCDocConfig(value))  s selected=1
	.Do OutputRowFindOPLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPLoc
	set Data=$lb($g(LocID),$g(LocDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPLocExecute ]
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
/// desc:医生站设置程序->常规设置 保存当前医院
ClassMethod SaveHosConfig(HosCode As %String, HosName As %String) As %String
{
	q:($d(^DHCDocConfig("HOSP",HosCode))) "-1"
	s ^DHCDocConfig("HOSP",HosCode)=HosName
	q 0
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->常规设置 查询费别允许的子类
Query GetAllowItemCatIDList(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod GetAllowItemCatIDListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","GetAllowItemCatIDList","QuickAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
    f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .s selected=0
    .i value'="" d
    ..i ARCICRowId=$g(^DHCDocConfig("AllowItemCatIDStr",value))  s selected=1
	.Do OutputRowGetAllowItemCatIDList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAllowItemCatIDList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllowItemCatIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllowItemCatIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
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
/// desc:医生站设置程序->常规设置 查询当前医院列表
Query GetCurHos(value As %String) As %Query(ROWSPEC = "HosCode:%String,HosName:%String,selected:%Boolean")
{
}

ClassMethod GetCurHosExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","GetCurHos","HOSP")
	Set repid=$I(^CacheTemp)
    Set ind=1
    k HosList
    s HosList(0)="北京友谊医院"_"^"_"YY"
    s HosList(1)="北京安贞医院"_"^"_"AZ"_"^"_"05110002"
    s HosList(2)="天津中医一附院"_"^"_"TJ"
    s HosList(3)="哈医大附属医院"_"^"_"HYD"
    s HosList(4)="南昌市第二医院"_"^"_"NC"
    s HosList(5)="江苏淮安医院"_"^"_"HA"
    s HosList(6)="安徽省省立医院"_"^"_"HF"
    s HosList(7)="宁波明州医院"_"^"_"NB"
    s HosList(8)="西安眼科"_"^"_"XA"
    s HosList(9)="韶关医院"_"^"_"SG"
    s HosList(10)="上海华山浦东分院"_"^"_"SHHSPD"
    s HosList(11)="北京积水潭医院"_"^"_"JST"
    s HosList(12)="北京中医院"_"^"_"BJZYY"
    s HosList(13)="福建厦门翔鹭医院"_"^"_"FJXMXL"
    s HosList(14)="医科院肿瘤医院"_"^"_"YKYZLYY"
    s HosList(15)="四川大学华西医院"_"^"_"SCDXHXYY"
    s HosList(16)= "四川大学华西二院"_"^"_"SCDXHXEY"
    s HosList(17)="广州正骨医院"_"^"_"GZZG"
    s HosList(18)="宁夏医学院附属医院"_"^"_"NXYXYFSYY"
    s HosList(19)="中国医科大附属第一医院"_"^"_"ZGYKDFSYY"
    s HosList(20)="北京妇产医院"_"^"_"BJFCYY"
    s HosList(21)= "北京地坛医院"_"^"_"BJDTYY"
    s HosList(22)="山东潍坊市人民医院"_"^"_"SDWFYY"
    s HosList(23)="中南大学湘雅二院"_"^"_"ZNDXXYEY"
    s HosList(24)= "深圳中医院"_"^"_"SZZYY"
    s HosList(25)="长春市妇产医院"_"^"_"CCSFCYY"
    s HosList(26)="浙江衢州人民医院"_"^"_"ZJQZRMYY"
    s HosList(27)="珠海市人民医院"_"^"_"ZHSRMYY"
    s HosList(28)="四川省妇幼保健院"_"^"_"SCSFY"
    s HosList(29)="山西大同三医院"_"^"_"SXDTSYY"
    s HosList(30)="湖南省肿瘤医院"_"^"_"HNSZLYY"
    s HosList(31)="上海市东方医院"_"^"_"SHSDFYY"
    s HosList(32)="南通大学附属医院"_"^"_"JSNTDXFSYY"
    s HosList(33)="山东烟台中医院"_"^"_"SDYTZYY"
    s HosList(34)="江苏徐州中心医院"_"^"_"JSXZZXYY"
    s HosList(35)="山东省立医院"_"^"_"SDSLYY"
    s HosList(36)= "兰大二院"_"^"_"LDEY"
    s HosList(37)="北京公安医院"_"^"_"BJGAYY"
    s HosList(38)="秦皇岛医院"_"^"_"QHDYY"
    s HosList(39)="青医附院黄岛分院"_"^"_"QYFYHDFY"
    s HosList(40)="温岭市第一人民医院"_"^"_"WLDYRMYY"
    s HosList(41)= "北京协和医院"_"^"_"BJXHYY"
    s HosList(42)="武汉市第一医院"_"^"_"WHSDYYY"
    s HosList(43)="中山大学附属第三医院"_"^"_"ZSSY"
    For i=0:1:43 d
    .s HosCode=$p(HosList(i),"^",2)
    .s HosName=$p(HosList(i),"^",1)
    .s selected=0
    .i value'="" d
    ..i HosCode_"^"_HosName=$p($g(^DHCDocConfig(value)),"^",1,2)  s selected=1
    .Do OutputRowGetCurHos
    s HosCode=""
    f  s HosCode=$o(^DHCDocConfig("HOSP",HosCode)) q:HosCode=""  d
    .s HosName=$g(^DHCDocConfig("HOSP",HosCode))
    .s selected=0
    .i value'="" d
    ..i HosCode_"^"_HosName=$p($g(^DHCDocConfig(value)),"^",1,2)  s selected=1
	.Do OutputRowGetCurHos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCurHos
	set Data=$lb($g(HosCode),$g(HosName),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCurHosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCurHosExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCurHosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCurHosExecute ]
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
/// desc:医生站设置程序->常规设置 默认病情诊断
ClassMethod getDefaultData() As %String
{
	s rtn=$g(^DHCDocConfig("DiagnoseRemarkICDDx"))
	s IcdDesc=""
	i rtn'="" s IcdDesc=$p(^MRC("ID",rtn),"^",2)
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_IcdDesc_""""_"}"
	q rtn
}

/// creator:宋春莉
/// date:2016-01-25
/// desc:医生站设置程序->常规设置 ->参数设置
Query FindDHCDocSysParamApp() As %Query(ROWSPEC = "DSPARowId:%String,DSPACode:%String,DSPADesc:%String")
{
}

ClassMethod FindDHCDocSysParamAppExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindBillTypeConfig","FindDHCDocSysParamApp")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DSPARowId=0
    f  s DSPARowId=$o(^DHCDocSYS("ParamSet",DSPARowId)) q:DSPARowId=""  d
    .s DSPACode=$p(^DHCDocSYS("ParamSet",DSPARowId),"^",1)
    .s DSPADesc=$p(^DHCDocSYS("ParamSet",DSPARowId),"^",2)
	.Do OutputRowFindDHCDocSysParamApp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDHCDocSysParamApp
	set Data=$lb($g(DSPARowId),$g(DSPACode),$g(DSPADesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDHCDocSysParamAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCDocSysParamAppExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDHCDocSysParamAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCDocSysParamAppExecute ]
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
/// date:2016-01-25
/// desc:医生站设置程序->常规设置 ->参数设置
Query FindDHCDocSysParamSet(DSPARowId As %String) As %Query(ROWSPEC = "DSPSRowId:%String,DSPSRangeType:%String,DSPSRangeTypeDesc:%String,DSPSRangeValue:%String,DSPSRangeValueDesc:%String,DSPSParamValue:%String,DSPSParamDesc:%String,DSPSHospitalDR:%String,DSPSHospital:%String,DSPSLocalFlag:%String")
{
}

ClassMethod FindDHCDocSysParamSetExecute(ByRef qHandle As %Binary, DSPARowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindDHCDocSysParamSet","FindDHCDocSysParamSet")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DSPSChildSub=0
    f  s DSPSChildSub=$o(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub)) q:DSPSChildSub=""  d
    .s DSPSRowId=DSPARowId_"||"_DSPSChildSub
    .s DSPSRangeType=$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",1)
    .s DSPSRangeValue=$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",2)
    .i DSPSRangeType="ALL" d
    ..s DSPSRangeTypeDesc="全院"
    ..s DSPSRangeValueDesc="ALL"
    .i DSPSRangeType="GRP" d
    ..s DSPSRangeTypeDesc="安全组"
    ..s DSPSRangeValueDesc=$p(^SSU("SSGRP",DSPSRangeValue),"^",1)
    .i DSPSRangeType="LOC" d
    ..s DSPSRangeTypeDesc="科室"
    ..s DSPSRangeValueDesc=$p(^CTLOC(DSPSRangeValue),"^",2)
    .i DSPSRangeType="USER" d
    ..s DSPSRangeTypeDesc="用户"
    ..s DSPSRangeValueDesc=$p(^SSU("SSUSR",DSPSRangeValue),"^",2)
    .s DSPSParamValue=$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",3)
    .s DSPSParamDesc=$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",4)
    .s DSPSHospitalDR=$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",5)
    .s DSPSHospital=""
    .s:DSPSHospitalDR'="" DSPSHospital=$p($g(^CT("HOSP",DSPSHospitalDR)),"^",2)
    .s DSPSLocalFlag =$p(^DHCDocSYS("ParamSet",DSPARowId,"S",DSPSChildSub),"^",6)
	.Do OutputRowFindDHCDocSysParamSet
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDHCDocSysParamSet
	set Data=$lb($g(DSPSRowId),$g(DSPSRangeType),$g(DSPSRangeTypeDesc),$g(DSPSRangeValue),$g(DSPSRangeValueDesc),$g(DSPSParamValue),$g(DSPSParamDesc),$g(DSPSHospitalDR),$g(DSPSHospital),$g(DSPSLocalFlag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDHCDocSysParamSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCDocSysParamSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDHCDocSysParamSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCDocSysParamSetExecute ]
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

Query FindDSPSRangeValue(DSPSRangeType As %String, Param As %String) As %Query(ROWSPEC = "RangeID:%String,RangeValue:%String,selected:%Boolean")
{
}

ClassMethod FindDSPSRangeValueExecute(ByRef qHandle As %Binary, DSPSRangeType As %String, Param As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindDSPSRangeValue","Group","门诊")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Param=$$ALPHAUP^SSUTIL4(Param)
    if (DSPSRangeType="ALL") d
    .s RangeID="ALL"
    .s RangeValue="ALL"
    .s selected=1
	.Do OutputRowFindDSPSRangeValue
	if (DSPSRangeType="GRP") d
	.s RangeID=0
	.f  s RangeID=$o(^SSU("SSGRP",RangeID)) q:RangeID=""  d
	..s RangeValue=$p(^SSU("SSGRP",RangeID),"^",1)
	..Q:(Param'="")&&(($$ALPHAUP^SSUTIL4(RangeValue))'[Param)
	..s selected=0
	..Do OutputRowFindDSPSRangeValue
	if (DSPSRangeType="USER") d
	.s RangeID=0
	.f  s RangeID=$o(^SSU("SSUSR",RangeID)) q:RangeID=""  d
	..s RangeValue=$p(^SSU("SSUSR",RangeID),"^",2)
	..Q:(Param'="")&&(($$ALPHAUP^SSUTIL4(RangeValue))'[Param)
	..s selected=0
	..Do OutputRowFindDSPSRangeValue
	if (DSPSRangeType="LOC") d
	.s RangeID=0
	.f  s RangeID=$o(^CTLOC(RangeID)) q:RangeID=""  d
	..s RangeValue=$p(^CTLOC(RangeID),"^",2)
	..Q:(Param'="")&&(($$ALPHAUP^SSUTIL4(RangeValue))'[Param)
	..s selected=0
	..Do OutputRowFindDSPSRangeValue
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDSPSRangeValue
	set Data=$lb($g(RangeID),$g(RangeValue),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDSPSRangeValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDSPSRangeValueExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDSPSRangeValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDSPSRangeValueExecute ]
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

ClassMethod InsertDHCDocSysParamSet(DSPARowId As %String, Str As %String) As %String
{
	s ^scl("g")=DSPARowId_","_Str
	s rtn=0
	s DSPSRangeType=$p(Str,"^",1)
	s DSPSRangeValue=$p(Str,"^",2)
	s DSPSParamValue=$p(Str,"^",3)
	s DSPSParamDesc=$p(Str,"^",4)
	s DSPSHospitalDR=$p(Str,"^",5)
	s DSPSLocalFlag=$p(Str,"^",6)
	Set object = ##class(User.DHCDocSysParamSet).%New(DSPARowId)
	Tstart
	i $IsObject(object) {
		d object.DHCDocSysParamAppParRefSetObjectId(DSPARowId)
		if (DSPSHospitalDR'="") d object.DSPSHospitalDRSetObjectId(DSPSHospitalDR)
		s object.DSPSRangeType=DSPSRangeType
		s object.DSPSRangeValue=DSPSRangeValue
		s object.DSPSParamValue=DSPSParamValue
		s object.DSPSParamDesc=DSPSParamDesc
		s object.DSPSLocalFlag=DSPSLocalFlag
		Set sc = object.%Save()
		If $$$ISERR(sc) {
			Trollback
			Do $System.Status.DisplayError(sc)
			Quit 100
		}else{
			s rtn=0
		}
		d object.%Close()
	}
	Tcommit
	q rtn
}

ClassMethod SaveDHCDocSysParamSet(DSPSRowId As %String, Str As %String) As %String
{
	s ^scl("g")=DSPSRowId_","_Str
	s rtn=0
	s DSPSRangeType=$p(Str,"^",1)
	s DSPSRangeValue=$p(Str,"^",2)
	s DSPSParamValue=$p(Str,"^",3)
	s DSPSParamDesc=$p(Str,"^",4)
	s DSPSHospitalDR=$p(Str,"^",5)
	s DSPSLocalFlag=$p(Str,"^",6)
	Set object = ##class(User.DHCDocSysParamSet).%OpenId(DSPSRowId)
	Tstart
	i $IsObject(object) {
		//d object.DHCDocSysParamAppParRefSetObjectId(DSPARowId)
		if (DSPSHospitalDR'="") d object.DSPSHospitalDRSetObjectId(DSPSHospitalDR)
		s object.DSPSRangeType=DSPSRangeType
		s object.DSPSRangeValue=DSPSRangeValue
		s object.DSPSParamValue=DSPSParamValue
		s object.DSPSParamDesc=DSPSParamDesc
		s object.DSPSLocalFlag=DSPSLocalFlag
		Set sc = object.%Save()
		If $$$ISERR(sc) {
			Trollback
			Do $System.Status.DisplayError(sc)
			Quit 100
		}else{
			s rtn=0
		}
		d object.%Close()
	}
	Tcommit
	q rtn
}

ClassMethod DeleteDHCDocSysParamSet(DSPSRowId As %String)
{
	&sql(delete SQLUser.DHC_DocSysParamSet where DSPS_RowId=:DSPSRowId)
	q SQLCODE
}

ClassMethod getDIADefaultData(value As %String)
{
	s rtn=$g(^DHCDocConfig(value))
	s DiaDesc=""
	i rtn'="" s DiaDesc=$p(^MRC("ID",rtn),"^",2)
	s rtn="{"_"""result"""_":"_""""_rtn_"^"_DiaDesc_""""_"}"
	q rtn
}

Query FindLoc(Type As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CNMedCode","FindOPLoc","QuickAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ADMLOCRowId=0
    f  s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""  d 
    .s ADMLOCAdmType=$p(^PAC("ADMLOC",ADMLOCRowId),"^",1)
    .q:("^"_Type_"^")'[("^"_ADMLOCAdmType_"^")
    .s LocID=$p(^PAC("ADMLOC",ADMLOCRowId),"^",2)
    .s LocDesc=$p(^CTLOC(LocID),"^",2)
    .s selected=0
	.Do OutputRowFindLoc
	if (Type="I"){
		s LocID=0
		f  s LocID=$o(^CTLOC(0,"LocType","W",LocID)) q:LocID=""  d
		.s ActiveFlag=$p(^CTLOC(LocID),"^",14)
		.q:ActiveFlag="N"
		.s CTLOCWardFlag=$p(^CTLOC(LocID),"^",5)
		.q:CTLOCWardFlag'="Y"
		.s DateActiveFrom=$p(^CTLOC(LocID),"^",24)
		.q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
		.s DateActiveTo=$p(^CTLOC(LocID),"^",25)
		.q:(DateActiveTo'="")&&(DateActiveTo<+$h)
		.s LocDesc=$p(^CTLOC(LocID),"^",2)
    	.s selected=0
    	.Do OutputRowFindLoc
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
    set ConnectName=$p(^CTLOC(LocID),"^",43)
    set LocDesc=ConnectName_" "_LocDesc
	set Data=$lb($g(LocID),$g(LocDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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
