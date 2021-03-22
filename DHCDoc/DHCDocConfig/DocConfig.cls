Class DHCDoc.DHCDocConfig.DocConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询用法      
Query Find(value As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","Find","CNMedItemPhSpecInstr")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=$g(^DHCDocConfig(value))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$p(Data,$c(1),1)
    .s Desc=$p(Data,$c(1),2)
	.Do OutputRowFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	set Data=$lb($g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询使用频率
Query FindCHNPHFrequence() As %Query(ROWSPEC = "CPFRowid:%String,CPFFrequence:%String,CPFFactor:%String,CPFDefault:%String")
{
}

ClassMethod FindCHNPHFrequenceExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCHNPHFrequence")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s CPFRowid=0
    f  s CPFRowid=$o(^DHCCHNPHFre(CPFRowid)) q:CPFRowid=""  d
    .s CPFFrequenceDR=$p(^DHCCHNPHFre(CPFRowid),"^",1)
    .s CPFFrequence=$p(^PHCFR(CPFFrequenceDR),"^",3)
    .s CPFFactor=$p(^DHCCHNPHFre(CPFRowid),"^",2)
    .s CPFDefault=$p(^DHCCHNPHFre(CPFRowid),"^",3)
	.Do OutputRowFindCHNPHFrequence
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCHNPHFrequence
	set Data=$lb($g(CPFRowid),$g(CPFFrequence),$g(CPFFactor),$g(CPFDefault))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCHNPHFrequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCHNPHFrequenceExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCHNPHFrequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCHNPHFrequenceExecute ]
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
/// desc:医生站设置程序->草药录入设置 保存使用频率
ClassMethod saveFrequence(FreqDr As %String, Factor As %String, Default As %String)
{
	zn "dhc-data"
	s rtn=$$findFrequence^DHCCHNPHFrequence(FreqDr)
	i rtn=0  zn "dhc-app"  q "-1"
	k PLIST
	s PLIST(2)=FreqDr
	s PLIST(3)=Factor
	s PLIST(4)=Default
	s rtn=$$insert^DHCCHNPHFrequence()
	zn "dhc-app"
	q rtn
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 删除使用频率
ClassMethod deleteFrequence(Rowid As %String)
{
	zn "dhc-data"
	s rtn=$$delete^DHCCHNPHFrequence(Rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod test()
{
	zn "dhc-data"
	s rtn=0
	
	i rtn=0  zn "dhc-app" quit -1
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询所有医嘱项目
Query FindDefaultItem(value As %String = "", Desc As %String = "", MaxFindNum As %String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDefaultItemExecute(ByRef qHandle As %Binary, value As %String = "", Desc As %String = "", MaxFindNum As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindDefaultItem","","wss","")
	s ^lxz=value_","_Desc_","_MaxFindNum
	s:(value="")||($ZCVT(value,"U")="NULL") value="NULL"
	s Desc=$ZCVT(Desc,"U")
	s FindTopNum=100000000
	if MaxFindNum'="" s FindTopNum=+MaxFindNum
	s FindNUm=0
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (value="NULL")&&(Desc=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ALIASText=$e(Desc,1,$l(Desc)-1)
	f  s ALIASText=$o(^ARC("ALIAS",0,"DescVI",ALIASText_" ")) q:((ALIASText="")||(FindNUm>=FindTopNum))  d
	.q:$e(ALIASText,1,$l(Desc))'=$e(Desc,1,$l(Desc))
	.s ALIASDesc=""
	.f  s ALIASDesc=$o(^ARC("ALIAS",0,"DescVI",ALIASText,ALIASDesc))  q:((ALIASDesc="")||(FindNUm>=FindTopNum))  d
	..s ALIASRowId=0
	..f  s ALIASRowId=$o(^ARC("ALIAS",0,"DescVI",ALIASText,ALIASDesc,ALIASRowId)) q:((ALIASRowId="")||(FindNUm>=FindTopNum))  d
	...s ArcimID=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
	...q:'$d(^ARCIM(+ArcimID,$p(ArcimID,"||",2)))
	...i ArcimID=$g(^DHCDocConfig(value)) s selected=1
	...e  s selected=0
	...s ArcimDesc=$P($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	...s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
	...s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
	...q:ArcimDesc=""
	...s FindNUm=FindNUm+1
	...d OutputRowFindDefaultItem
	//^ARC("ALIAS",0,"DescVI",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	
	/*s ArcimMaster=""  for  set ArcimMaster=$o(^ARCIM(ArcimMaster)) q:((ArcimMaster="")||(FindNUm>=FindTopNum))  d
	.s ArcimChild=""  for  set ArcimChild=$o(^ARCIM(ArcimMaster,ArcimChild)) q:((ArcimChild="")||(FindNUm>=FindTopNum))  d
	..q:+ArcimChild<1
	..q:'$d(^ARCIM(ArcimMaster,ArcimChild))
	..s selected=0
	..i ArcimMaster_"||"_ArcimChild=$g(^DHCDocConfig(value)) s selected=1
	..s ArcimDesc=$P($g(^ARCIM(ArcimMaster,ArcimChild,1)),"^",2)
	..s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
	..s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
	..q:ArcimDesc=""
	..s ArcimID=ArcimMaster_"||"_ArcimChild
	..s ArcAlias=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,""))
	..s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	..Q:(Desc'="")&&($ZCVT(Desc,"U")'=$E($ZCVT(ArcAlias,"U"),1,$L($ZCVT(Desc,"U"))))
	..s:ArcAlias'="" ArcimDesc=ArcAlias_"-"_ArcimDesc
	..s FindNUm=FindNUm+1
	..d OutputRowFindDefaultItem*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDefaultItem
	Set Data=$lb(ArcimID,ArcimDesc,selected)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindDefaultItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDefaultItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDefaultItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDefaultItemExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询所有草药用法列表
Query FindInstrList(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindInstrList","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s KeyValue=..GetKeyValue(value)    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i ("^"_KeyValue_"^")[("^"_InstrRowID_"^") s selected=1
	.Do OutputRowFindInstrList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrList
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrListExecute ]
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
/// desc:医生站设置程序->草药录入设置 返回设置值 
ClassMethod getDefaultData(value As %String) As %String
{
	s rtn=$g(^DHCDocConfig(value))
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod getOrdBillCheckData(node As %String, value As %String) As %String
{
	s rtn=$g(^DHCDocOrderBillConfig(node,value))
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod saveOrdBillCheckData(Coninfo As %String, node As %String) As %String
{
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d 
	..s node1=$p(evNoteinfo,$C(1),1)
	..s value=$p(evNoteinfo,$C(1),2)
	..s ^DHCDocOrderBillConfig(node,node1)=value
	q 0
}

ClassMethod getLabSttTime(value As %String, HospId As %String) As %String
{
	if ($g(^DHCDocConfig("UseHospSepLabConfig"))=1)&&(HospId="") s HospId=$g(^DHCDocConfig("MainHospital"))
	if (HospId=""){
		s rtn=$g(^DHCDocConfig(value))
	}else{
		s rtn=$g(^DHCDocConfig(value,HospId))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod GetLabOtherCheck(Node As %String, HospId As %String) As %String
{
	if ($g(^DHCDocConfig("UseHospSepLabConfig"))=1)&&(HospId="") s HospId=$g(^DHCDocConfig("MainHospital"))
	if (HospId=""){
		s str=$g(^DHCDocConfig(Node))
	}else{
		s str=$g(^DHCDocConfig(Node,HospId))
	}
	if (str="") s str=0
	q str
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询草药医嘱可用优先级
Query FindCNMedPrior(value As %String) As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedPriorExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedPrior","CNMedPrior")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s CNMedPriorListStr=$g(^DHCDocConfig(value))
 	.s selected=0
 	.s:("^"_CNMedPriorListStr_"^")[("^"_OECPRRowId_"^") selected=1
	.Do OutputRowFindCNMedPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedPriorExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询账单大类
Query FindARCBillGrp(value As %String) As %Query(ROWSPEC = "ARCBGRowId:%String,ARCBGDesc:%String,selected:%Boolean")
{
}

ClassMethod FindARCBillGrpExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindARCBillGrp","CHNPHBillSub")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCBGRowId=0
 	f  s ARCBGRowId=$o(^ARCBG(ARCBGRowId)) q:ARCBGRowId=""  d
 	.s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2)
 	.q:ARCBGDesc=""
 	.s ARCBillGrpStr=$g(^DHCDocConfig(value))
 	.s selected=0
 	.s:ARCBGRowId=$p(ARCBillGrpStr,"||") selected=1
 	.//s:("^"_ARCBillGrpStr_"^")[("^"_ARCBGRowId_"^") selected=1
	.Do OutputRowFindARCBillGrp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindARCBillGrp
	set Data=$lb($g(ARCBGRowId),$g(ARCBGDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindARCBillGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCBillGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindARCBillGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCBillGrpExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询账单子类
Query FindARCBillSub(value As %String) As %Query(ROWSPEC = "ARCSGRowId:%String,ARCSGDesc:%String,selected:%Boolean")
{
}

ClassMethod FindARCBillSubExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindARCBillSub","CHNPHBillSub")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCBillGrpStr=$g(^DHCDocConfig(value))
    s ARCBGRowId=0
 	f  s ARCBGRowId=$o(^ARCBG(ARCBGRowId)) q:ARCBGRowId=""  d
 	.q:(ARCBGRowId'=$p(ARCBillGrpStr,"||"))&&(ARCBillGrpStr'="")
 	.s ARCSGChildSub=0
 	.f  s ARCSGChildSub=$o(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub)) q:ARCSGChildSub=""  d
 	..s ARCSGDesc=$p($g(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub)),"^",2)
 	..q:ARCSGDesc=""
 	..s selected=0
 	..s:(ARCBGRowId_"||"_ARCSGChildSub)=ARCBillGrpStr selected=1
 	..s ARCSGRowId=ARCBGRowId_"||"_ARCSGChildSub
	..Do OutputRowFindARCBillSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindARCBillSub
	set Data=$lb($g(ARCSGRowId),$g(ARCSGDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindARCBillSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCBillSubExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindARCBillSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCBillSubExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询包装方式
Query FindCNMedCookMode(value As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,ArcOrd:%String,ActiveFlag:%String,ArcOrdID:%String")
{
}

ClassMethod FindCNMedCookModeExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	//"02"_$c(1)_"代煎"_$c(1)_"0"_$c(1)_"1^01"_$c(1)_"自煎"_$c(1)_"0"_$c(1)_"1^03"_$c(1)_"加工膏方"_$c(1)_"0"_$c(1)_"1"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookMode","CNMedCookMode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=$g(^DHCDocConfig(value))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$p(Data,$c(1),1)
    .s Desc=$p(Data,$c(1),2)
    .s ArcOrdID=$p(Data,$c(1),3)
    .s:ArcOrdID=0 ArcOrdID=""
    .s ArcOrd=""
    .i ArcOrdID'="" s ArcOrd=$p(^ARCOS(ArcOrdID),"^",2)
    .s ActiveFlag=$p(Data,$c(1),4)
    .i ActiveFlag="1" s ActiveFlag="Y"
    .else  s ActiveFlag="N"
	.Do OutputRowFindCNMedCookMode
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookMode
	set Data=$lb($g(Code),$g(Desc),$g(ArcOrd),$g(ActiveFlag),$g(ArcOrdID))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询可用医嘱套列表
Query FindArcOrd() As %Query(ROWSPEC = "ARCOSRowId:%String,ARCOSDesc:%String")
{
}

ClassMethod FindArcOrdExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindArcOrd")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s ARCOSRowId=0
 	f  s ARCOSRowId=$o(^ARCOS(ARCOSRowId)) q:ARCOSRowId=""  d
 	.s str=$g(^ARCOS(ARCOSRowId))
 	.s ARCOSDesc=$p(str,"^",2)
 	.s ARCOSEffDateFrom=$p(str,"^",15)
 	.s ARCOSEffDateTo=$p(str,"^",16)
 	.q:(ARCOSEffDateFrom>+$h)&&(ARCOSEffDateFrom'="")
 	.q:(ARCOSEffDateTo'="")&&(ARCOSEffDateTo<=+$h)
 	.s ArcAlias=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,""))
	.s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	.s:ArcAlias'="" ARCOSDesc=ArcAlias_"-"_ARCOSDesc
	.Do OutputRowFindArcOrd
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcOrd
	set Data=$lb($g(ARCOSRowId),$g(ARCOSDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcOrdExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询接受科室
Query FindDep(value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected=0
 	.i value'="" d
 	..s:("^"_$g(^DHCDocConfig(value))_"^")[("^"_CTLOCRowID_"^") selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
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
/// desc:医生站设置程序->草药录入设置 根据就诊类型查询对应的药物使用方式
Query FindAdmTypeInstr(AdmType As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindAdmTypeInstrExecute(ByRef qHandle As %Binary, AdmType As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindAdmTypeInstr","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i AdmType'="" d
	..s:("^"_$g(^DHCDocConfig("AdmTypeInstr",AdmType))_"^")[("^"_InstrRowID_"^") selected=1
	.Do OutputRowFindAdmTypeInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAdmTypeInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAdmTypeInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmTypeInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmTypeInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmTypeInstrExecute ]
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
/// desc:医生站设置程序->草药录入设置 根据子类查询药物加工方式
Query FindCNMedCookModeByCat(CatDr As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedCookModeByCatExecute(ByRef qHandle As %Binary, CatDr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookModeByCat","")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s Str=$g(^DHCDocConfig("CNMedCookMode"))
 	F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$tr($p(Data,$c(1),1),0,"")
    .s Desc=$p(Data,$c(1),2)
	.s selected=0
	.i CatDr'="" d
	..s:("^"_$g(^DHCDocConfig("ItemCatCookMode",CatDr))_"^")[("^"_Code_"^") selected=1
	.Do OutputRowFindCNMedCookModeByCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookModeByCat
	set Data=$lb($g(Code),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeByCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeByCatExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询颗粒设置用法
Query FindInstrByKL(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindInstrByKL","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i InstrRowID=$g(^DHCDocConfig("CNMedNormKL",value,"InStr")) s selected=1
	.Do OutputRowFindInstrByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrByKL
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrByKLExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询颗粒加工方式
Query FindCNMedCookModeByKL(value As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedCookModeByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	//"02"_$c(1)_"代煎"_$c(1)_"0"_$c(1)_"1^01"_$c(1)_"自煎"_$c(1)_"0"_$c(1)_"1^03"_$c(1)_"加工膏方"_$c(1)_"0"_$c(1)_"1"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookModeByKL","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=$g(^DHCDocConfig("CNMedCookMode"))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$tr($p(Data,$c(1),1),0,"")
    .s Desc=$p(Data,$c(1),2)
    .s selected=0
    .i Code=$g(^DHCDocConfig("CNMedNormKL",value,"Cookmode")) s selected=1
	.Do OutputRowFindCNMedCookModeByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookModeByKL
	set Data=$lb($g(Code),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeByKLExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询颗粒对应接受科室
Query FindCNMedNormKLRefLoc(value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedNormKLRefLocExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedNormKLRefLoc","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected=0
 	.s:$d(^DHCDocConfig("CNMedNormKL",value,CTLOCRowID)) selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindCNMedNormKLRefLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedNormKLRefLoc
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedNormKLRefLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedNormKLRefLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedNormKLRefLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedNormKLRefLocExecute ]
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
/// desc:医生站设置程序->草药录入设置 查询颗粒对应的子类
Query FindCatListByKL(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCatListByKL","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.i value'="" d
	..q:'$d(^DHCDocConfig("CNMedNormKL"))
 	..s Loc=$o(^DHCDocConfig("CNMedNormKL",value,""))
 	..s FrequencedItemCatListStr=$g(^DHCDocConfig("CNMedNormKL",value,Loc))
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatListByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListByKL
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListByKLExecute ]
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
/// desc:医生站设置程序->草药录入设置 保存普通 颗粒设置
ClassMethod saveCNMedNormKL(Input As %String) As %String
{
	//CNMedNormKL As %String,InStr As %String,Cookmode As %String,RefLoc As %String,ItemCatStr As %String
	Set CNMedNormKL=$p(Input,"$",1)
	Set ItemCatStr=$p(Input,"$",5)
	Set RefLoc=$p(Input,"$",4)
	Set InStr=$p(Input,"$",2)
	Set Cookmode=$p(Input,"$",3)
	Quit:RefLoc=""
	k ^DHCDocConfig("CNMedNormKL",CNMedNormKL)
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,RefLoc)=ItemCatStr
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,"InStr")=InStr
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,"Cookmode")=Cookmode
	q 0
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 保存子类对应药物加工方式
ClassMethod saveItemCatCookMode(Input As %String) As %String
{
	s Node=$p(Input,"$",1)
	s Node1=$p(Input,"$",2)
	s NodeValue=$p(Input,"$",3)
	Set ^DHCDocConfig(Node,Node1)=NodeValue
	q 0
}

/// creator:lxz
/// desc:医生站设置程序->草药录入设置 医嘱单插入的长期医嘱
Query FindCNMedLongOrder() As %Query(ROWSPEC = "IDOut:%String,DescOut:%String,ArcimID:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedLongOrder")
ClassMethod FindCNMedLongOrderExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s IDOut=0
    f  s IDOut=$o(^DHCDocConfig("CNMedAddLongOrder",IDOut)) q:IDOut=""  d
    .s ArcimID=$G(^DHCDocConfig("CNMedAddLongOrder",IDOut))
    .s ArcimDesc=""
    .s:ArcimID'="" ArcimDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
   	.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
	.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
	.q:ArcimDesc=""
	.Do OutputFindCNMedLongOrder
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFindCNMedLongOrder
	set Data=$lb($g(IDOut),$g(ArcimDesc),ArcimID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedLongOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedLongOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedLongOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedLongOrderExecute ]
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

/// creator:lxz
/// desc:保存对应医嘱单插入的长期医嘱
ClassMethod saveCNMedAddLongOrder(ArcimID As %String) As %String
{
	Q:ArcimID="" "-1"
	s ID=$I(^DHCDocConfig("CNMedAddLongOrder"))
	s ^DHCDocConfig("CNMedAddLongOrder",ID)=ArcimID
	q 0
}

/// creator:lxz
/// desc:医生站设置程序->草药录入设置 删除应医嘱单插入的长期医嘱
ClassMethod deleteCNMedAddLongOrder(Rowid As %String) As %String
{
	q:Rowid="" "-1"
	k ^DHCDocConfig("CNMedAddLongOrder",Rowid)
	q 0
}

/// lxz 返回给草药录入界面使用 需要增加的长期医嘱
/// w ##class(DHCDoc.DHCDocConfig.DocConfig).FindAddLongArcim()
ClassMethod FindAddLongArcim() As %String
{
	s ArcimStr=""
	s IDOut=0
    f  s IDOut=$o(^DHCDocConfig("CNMedAddLongOrder",IDOut)) q:IDOut=""  d
    .s ArcimID=$G(^DHCDocConfig("CNMedAddLongOrder",IDOut))
    .s ArcimDesc=""
    .s:ArcimID'="" ArcimDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
    .Q:ArcimDesc=""
    .if ArcimStr="" s ArcimStr=ArcimID_"^"_ArcimDesc
    .else  s ArcimStr=ArcimStr_"!"_ArcimID_"^"_ArcimDesc
    q ArcimStr
}

ClassMethod GetKeyValue(key As %String) As %String
{
	n (key)
	q:key="" ""
	s IllegalExpress=0
	s Expression="KeyValue=$G(^DHCDocConfig("
	for i=1:1:$L(key,",") {
		if (i=1){
			s Expression=Expression_""""_$P(key,",",i)_""""
		}else{
			s Expression=Expression_","""_$P(key,",",i)_""""
		}
		if ($P(key,",",i)=""){
			s IllegalExpress=1
		}
	}
	if (IllegalExpress=1){
		q ""
	}
	s Expression=Expression_"))"
	s @Expression
	q KeyValue
}

}
