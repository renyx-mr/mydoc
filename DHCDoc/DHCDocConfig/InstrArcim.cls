/// creator:郭宝平
/// date:2015-02-21
/// desc:医生站设置程序->用法绑定相关医嘱的设定
///      根据登录科室判断所在医院来定节点值是否包含医院ID
///   自动关联医嘱绑定:  
///        门诊绑定:  医嘱绑定 ^DHCDocConfig("InstrArcim",InstrRowId)  ,输液费标识:^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)   
/// 		   住院绑定： 医嘱绑定 ^DHCDocConfig("InstrIPArcim",InstrRowId)  ,输液费标识:^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId) 
///   手动选择关联医嘱绑定:  
///        门诊绑定:  医嘱绑定 ^DHCDocConfig("InstrArcimSel",InstrRowId)  
/// 		   住院绑定： 医嘱绑定 ^DHCDocConfig("InstrIPArcimSel",InstrRowId)      
Class DHCDoc.DHCDocConfig.InstrArcim Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      郭宝平
/// CreatDate：    2015-03-03
/// Description:： 查询用法    
/// Input：         无
/// Output：        
/// Return：       
Query FindInstr(InstrAlias As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String")
{
}

ClassMethod FindInstrExecute(ByRef qHandle As %Binary, InstrAlias As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindInstr","wy")
	s ^TMP("FindInstr")=InstrAlias
	s InstrAlias=$$ALPHAUP^SSUTIL4(InstrAlias)
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s PHCINDesc="" f  s PHCINDesc=$o(^PHCIN(0,"Desc1",PHCINDesc)) q:(PHCINDesc="")  d
 	.s PHCINRowId="" f  s PHCINRowId=$o(^PHCIN(0,"Desc1",PHCINDesc,PHCINRowId)) q:(PHCINRowId="")  d
	..q:'$D(^PHCIN(PHCINRowId))
	..s InstrCode=$p(^PHCIN(PHCINRowId),"^",1)
	..s InstrDesc=$p(^PHCIN(PHCINRowId),"^",2)
	..s InstrDesc2=$p(^PHCIN(PHCINRowId),"^",3)
	..q:InstrDesc2["饮片"
	..Q:(InstrAlias'="")&&($$ALPHAUP^SSUTIL4(InstrCode)'[InstrAlias)&&($$ALPHAUP^SSUTIL4(InstrDesc)'[InstrAlias)&&($$ALPHAUP^SSUTIL4(InstrDesc2)'[InstrAlias)
	..s InstrDesc=InstrCode_"-"_InstrDesc
	..s InstrDesc=..TR(InstrDesc)	
	..s InstrDesc=..EvalJSON(InstrDesc)	
	..Do OutputRowFindInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstr
	set Data=$lb($g(PHCINRowId),$g(InstrDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrExecute ]
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

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

/// 查询所有医嘱项目
Query FindAllItem() As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureAppConfig","FindAllItem")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s ArcimMaster=""  for  set ArcimMaster=$o(^ARCIM(ArcimMaster)) q:ArcimMaster=""  d
	.s ArcimChild=""  for  set ArcimChild=$o(^ARCIM(ArcimMaster,ArcimChild)) q:ArcimChild=""  d
	..q:'$d(^ARCIM(ArcimMaster,ArcimChild))
	..s ArcimDesc=$P($g(^ARCIM(ArcimMaster,ArcimChild,1)),"^",2)
	..s ArcimDesc=..TR(ArcimDesc)	
	..s ArcimDesc=..EvalJSON(ArcimDesc)
	..s ArcimID=ArcimMaster_"||"_ArcimChild
	..s ArcAlias=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,""))
	..s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	..s:ArcAlias'="" ArcimDesc=ArcAlias_"-"_ArcimDesc
	.d OutputRowFindAllItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
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

Query FindOPInstrArcim(InstrRowId As %String, Hospital As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,ByDay:%String,InfusionFeeFlag:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindOPInstrArcimExecute(ByRef qHandle As %Binary, InstrRowId As %String, Hospital As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindOPInstrArcim",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    //Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s:Hospital'="" InstrRowId=InstrRowId_"||"_Hospital
    b ;绑定的材料设置
    s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
    .;按天
    .s ByDay=$p($p(AppendItemStr,"^",count),"!",2)
    .s ByDay=$case(ByDay,1:"Y",:"")
    .;输液费标识
    .s InfusionFeeFlag=$p($p(AppendItemStr,"^",count),"!",3)
    .s InfusionFeeFlag=$case(InfusionFeeFlag,1:"Y",:"")
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",4)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.Do OutputRowFindOPInstrArcim
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPInstrArcim
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),$g(ByDay),$g(InfusionFeeFlag),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPInstrArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPInstrArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPInstrArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPInstrArcimExecute ]
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

ClassMethod SaveOPInstrArcim(InstrRowId As %String, ArcimId As %String, ByDay As %String, InfusionFeeFlag As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	n (InstrRowId,ArcimId,ByDay,InfusionFeeFlag,LocRowId,curEditRow,UseLocRowId)
	q:(InstrRowId="")||(ArcimId="") 100
	s ^tempslc("SaveOPInstrArcim")=InstrRowId_","_ArcimId_","_ByDay_","_InfusionFeeFlag_","_LocRowId_","_curEditRow_","_UseLocRowId
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",4)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){ //新增
        if AppendItemStr="" s AppendItemStr=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
        else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
	}
    s ^DHCDocConfig("InstrArcim",InstrRowId)=AppendItemStr
    ;按当次输液最大次数收输液费(输液次数必须) 设置
    s InfusionFeeStr=$g(^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId))
    if InfusionFeeStr=""  s InfusionFeeStr=ArcimId
    else  s InfusionFeeStr=InfusionFeeStr_"^"_ArcimId
    s ^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    Q 0
}

/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteOPInstrArcim("97||2&524||1")
ClassMethod DeleteOPInstrArcim(InstrArcimId As %String) As %String
{
	n (InstrArcimId)
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
	s InfusionFeeStr=$g(^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId))
	s NewAppendItemStr="",NewInfusionFeeStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s AppendItem=$p(AppendItemStr,"^",count)
    .s ArcimRowid=$p(AppendItem,"!")
    .s InstrLocRowId=$p(AppendItem,"!",4)
    .q:ArcimRowid=""
    .//q:ArcimId=ArcimRowid
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=AppendItem
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_AppendItem
    .if NewInfusionFeeStr="" s NewInfusionFeeStr=ArcimRowid
    .else  s NewInfusionFeeStr=NewInfusionFeeStr_"^"_ArcimRowid
    s ^DHCDocConfig("InstrArcim",InstrRowId)=NewAppendItemStr
    s ^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    q 0
}

Query FindIPInstrArcim(InstrRowId As %String, Hospital As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,ByDay:%String,InfusionFeeFlag:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindIPInstrArcimExecute(ByRef qHandle As %Binary, InstrRowId As %String, Hospital As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindIPInstrArcim",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    //Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s:Hospital'="" InstrRowId=InstrRowId_"||"_Hospital
    b ;绑定的材料设置
    s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
    .;按天
    .s ByDay=$p($p(AppendItemStr,"^",count),"!",2)
    .s ByDay=$case(ByDay,1:"Y",:"")
    .;输液费标识
    .s InfusionFeeFlag=$p($p(AppendItemStr,"^",count),"!",3)
    .s InfusionFeeFlag=$case(InfusionFeeFlag,1:"Y",:"")
    .s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",4)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID	
	.Do OutputRowFindIPInstrArcim
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindIPInstrArcim
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),$g(ByDay),$g(InfusionFeeFlag),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindIPInstrArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIPInstrArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIPInstrArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIPInstrArcimExecute ]
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

/// 住院自动关联医嘱
/// 1. 保存关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).SaveIPInstrArcim()
ClassMethod SaveIPInstrArcim(InstrRowId As %String, ArcimId As %String, ByDay As %String, InfusionFeeFlag As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	n (InstrRowId,ArcimId,ByDay,InfusionFeeFlag,LocRowId,curEditRow,UseLocRowId)
	q:(InstrRowId="")||(ArcimId="") 100
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	//s ^tempscl("SaveIPInstrArcim")=InstrRowId_","_ArcimId_","_ByDay_","_InfusionFeeFlag_","_LocRowId_","_curEditRow
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",4)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId
	}
    s ^DHCDocConfig("InstrIPArcim",InstrRowId)=AppendItemStr
    ;按当次输液最大次数收输液费(输液次数必须) 设置
    s InfusionFeeStr=$g(^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId))
    if InfusionFeeStr=""  s InfusionFeeStr=ArcimId
    else  s InfusionFeeStr=InfusionFeeStr_"^"_ArcimId
    s ^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    Q 0
}

/// 2.删除关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteIPInstrArcim("47&6||1")
ClassMethod DeleteIPInstrArcim(InstrArcimId As %String) As %String
{
	n (InstrArcimId)
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
	s InfusionFeeStr=$g(^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId))
	s NewAppendItemStr="",NewInfusionFeeStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s AppendItem=$p(AppendItemStr,"^",count)
    .s ArcimRowid=$p(AppendItem,"!")
    .s InstrLocRowId=$p(AppendItem,"!",4)
    .q:ArcimRowid=""
    .//q:ArcimId=ArcimRowid
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=AppendItem
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_AppendItem
    .if NewInfusionFeeStr="" s NewInfusionFeeStr=ArcimRowid
    .else  s NewInfusionFeeStr=NewInfusionFeeStr_"^"_ArcimRowid
    
    s ^DHCDocConfig("InstrIPArcim",InstrRowId)=NewAppendItemStr
    s ^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    q 0
}

Query FindOPInstrArcimSel(InstrRowId As %String, HospitalId As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindOPInstrArcimSelExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospitalId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindOPInstrArcimSel",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!",1)
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",2)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.Do OutputRowFindOPInstrArcimSel
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPInstrArcimSel
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPInstrArcimSelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPInstrArcimSelExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPInstrArcimSelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPInstrArcimSelExecute ]
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

/// 住院自动关联医嘱
/// 1. 保存关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).SaveIPInstrArcim(50,"1811||1",2,0,2)
ClassMethod SaveOPInstrArcimSel(InstrRowId As %String, ArcimId As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	n (InstrRowId,ArcimId,LocRowId,curEditRow,UseLocRowId)
	q:(InstrRowId="")||(ArcimId="") 100
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    b //90
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_UseLocRowId
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_UseLocRowId
	}
	/*for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p(AppendItemStr,"^",count)
    .q:ArcimRowid=""
    .if ArcimId=ArcimRowid  s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
    if AppendItemStr="" s AppendItemStr=ArcimId
    else  s AppendItemStr=AppendItemStr_"^"_ArcimId*/
    s ^DHCDocConfig("InstrArcimSel",InstrRowId)=AppendItemStr
    Q 0
}

/// 2.删除关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteIPInstrArcimSel("47&6||1")
ClassMethod DeleteOPInstrArcimSel(InstrArcimId As %String) As %String
{
	n (InstrArcimId)
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
	s NewAppendItemStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!",1)
    .q:ArcimRowid=""
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=ArcimRowid_"!"_InstrLocRowId
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_ArcimRowid_"!"_InstrLocRowId
    s ^DHCDocConfig("InstrArcimSel",InstrRowId)=NewAppendItemStr
    q 0
}

Query FindIPInstrArcimSel(InstrRowId As %String, HospitalId As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindIPInstrArcimSelExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospitalId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindIPInstrArcimSel",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",2)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.Do OutputRowFindIPInstrArcimSel
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindIPInstrArcimSel
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindIPInstrArcimSelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIPInstrArcimSelExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIPInstrArcimSelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIPInstrArcimSelExecute ]
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

ClassMethod SaveIPInstrArcimSel(InstrRowId As %String, ArcimId As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	n (InstrRowId,ArcimId,LocRowId,curEditRow,UseLocRowId)
	q:(InstrRowId="")||(ArcimId="") 100
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q

    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_UseLocRowId
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_UseLocRowId
	}
	/*for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p(AppendItemStr,"^",count)
    .q:ArcimRowid=""
    .if ArcimId=ArcimRowid  s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
    if AppendItemStr="" s AppendItemStr=ArcimId
    else  s AppendItemStr=AppendItemStr_"^"_ArcimId*/
    s ^DHCDocConfig("InstrIPArcimSel",InstrRowId)=AppendItemStr
    Q 0
}

ClassMethod DeleteIPInstrArcimSel(InstrArcimId As %String) As %String
{
	n (InstrArcimId)
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
	s NewAppendItemStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=ArcimRowid_"!"_InstrLocRowId
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_ArcimRowid_"!"_InstrLocRowId
    s ^DHCDocConfig("InstrIPArcimSel",InstrRowId)=NewAppendItemStr
    q 0
}

Query GetHos() As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetHosExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","GetHos")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s HOSPRowId=0 f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""  d
 	.s HOSPDesc=$p(^CT("HOSP",HOSPRowId),"^",2)
 	.s selected=0
 	.i HOSPRowId=$g(^DHCDocConfig("MainHospital")) s selected=1
	.Do OutputRowGetHos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetHos
	set Data=$lb($g(HOSPRowId),$g(HOSPDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetHosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHosExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHosExecute ]
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

ClassMethod SaveArcimWardList(SaveQueryName As %String, SaveQueryID As %String, SaveInfo As %String, Index As %String) As %String
{
	s ^tempscl("SaveArcimWardList")=SaveQueryName_","_SaveQueryID_","_SaveInfo_","_Index
	//LocId+"^"+ArcimId+"^"+AppendType+"^"+ExecType+"^"+Active+"^"+additionalNum
	s LocId=$P(SaveInfo,"^",1)
	s ArcimId=$P(SaveInfo,"^",2)
	s AppendType=$P(SaveInfo,"^",3)
	s ExecType=$P(SaveInfo,"^",4)
	s Active=$P(SaveInfo,"^",5)
	s additionalNum=$P(SaveInfo,"^",6)
	s Qty=$P(SaveInfo,"^",7)
	s EndNum=$P(SaveInfo,"^",8)
	s ByHand=$P(SaveInfo,"^",9)
	s SingleNotFee=$P(SaveInfo,"^",10)
	q:(SaveQueryName="")||(SaveQueryID="")||(LocId="")||(ArcimId="")||(Qty<=0) -100
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") -200
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") -300
	if (SaveQueryName="Instr"){
		s rtn=""
		if (Index=""){
			s MaxLen=$O(^DHCDocConfig("InstrArcimWard",WardID,SaveQueryID,"A"),-1)
			for i=1:1:MaxLen {
				s data=$g(^DHCDocConfig("InstrArcimWard",WardID,SaveQueryID,i))
				s tmpArcimId=$p(data,"^",1)
				s tmpAppendType=$p(data,"^",2)
				s tmpExecType=$p(data,"^",3)
				s tmpActive=$p(data,"^",4)
				i data=$P(SaveInfo,"^",2,$L(SaveInfo,"^")) s rtn="-201" q
			}
			q:rtn'="" rtn
			s Index=$O(^DHCDocConfig("InstrArcimWard",WardID,SaveQueryID,"A"),-1)+1
		}
		s ^DHCDocConfig("InstrArcimWard",WardID,SaveQueryID,Index)=$P(SaveInfo,"^",2,$L(SaveInfo,"^"))
	}elseif (SaveQueryName="Arcim"){
		s rtn=""
		if (Index=""){
			s MaxLen=$O(^DHCDocConfig("ArcimWardAdd",WardID,SaveQueryID,"A"),-1)
			for i=1:1:MaxLen {
				s data=$g(^DHCDocConfig("ArcimWardAdd",WardID,SaveQueryID,i))
				s tmpArcimId=$p(data,"^",1)
				s tmpAppendType=$p(data,"^",2)
				s tmpExecType=$p(data,"^",3)
				s tmpActive=$p(data,"^",4)
				i data=$P(SaveInfo,"^",2,$L(SaveInfo,"^")) s rtn="-201" q
			}
			q:rtn'="" rtn
			s Index=$O(^DHCDocConfig("ArcimWardAdd",WardID,SaveQueryID,"A"),-1)+1
		}
		s ^DHCDocConfig("ArcimWardAdd",WardID,SaveQueryID,Index)=$P(SaveInfo,"^",2,$L(SaveInfo,"^"))
	}
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.InstrArcim).DeleteArcimWardList("Arcim","2093||1",31,1)
ClassMethod DeleteArcimWardList(SelName As %String, SelID As %String, LocId As %String, Index As %String) As %String
{
	s ^tan("DeleteArcimWardList")=SelName_","_SelID_","_LocId_","_Index
	q:(SelName="")||(SelID="")||(LocId="")||(Index="") -100
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") -200
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") -300
	if (SelName="Instr"){
		k ^DHCDocConfig("InstrArcimWard",WardID,SelID,Index)
	}elseif (SelName="Arcim"){
		k ^DHCDocConfig("ArcimWardAdd",WardID,SelID,Index)
	}
    q 0
}

Query FindArcimWardLink(LocId As %String, queryName As %String, QueryID As %String) As %Query(ROWSPEC = "Index:%String,ARCIMDesc:%String,InstrArcimId:%String,AppendType:%String,ExecType:%String,Active:%String,additionalNum:%String,Qty:%String,EndNum:%String,ByHand:%String,SingleNotFee:%String")
{
}

ClassMethod FindArcimWardLinkExecute(ByRef qHandle As %Binary, LocId As %String, queryName As %String, QueryID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindArcimWardLink",197,"Instr",50)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ^tan("FindArcimWardLink")=LocId_","_queryName_","_QueryID
    s CTLOCType=$P(^CTLOC(LocId),"^",13)
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
    if (queryName="")||(QueryID="")||(CTLOCType'="W")||(WardID="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if (queryName="Instr"){
		s Index=""
		for {
			s Index=$O(^DHCDocConfig("InstrArcimWard",WardID,QueryID,Index))
			q:Index=""
			if (+Index'=Index){
				continue
			}
			s Val=^(Index)
			//ArcimId+"^"+AppendType+"^"+ExecType+"^"+Active+"^"+additionalNum;
			
			d OutputRowFindArcimWardLink
			
		}
	}elseif (queryName="Arcim"){
		s Index=""
		for {
			s Index=$O(^DHCDocConfig("ArcimWardAdd",WardID,QueryID,Index))
			q:Index=""
			if (+Index'=Index){
				continue
			}
			s Val=^(Index)
			d OutputRowFindArcimWardLink
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcimWardLink
	s ArcimId=$P(Val,"^",1)
	s AppendType=$P(Val,"^",2)
	s ExecType=$P(Val,"^",3)
	s Active=$P(Val,"^",4)
	s additionalNum=$P(Val,"^",5)
	s Qty=$P(Val,"^",6)
	s EndNum=$P(Val,"^",7)
	s ByHand=$P(Val,"^",8)
	s SingleNotFee=$P(Val,"^",9)
	i SingleNotFee="" s SingleNotFee="Y"
	s ARCIMDesc=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",2)
	s InstrArcimId=ArcimId
	s AppendType=AppendType
	s ExecType=ExecType
	s Active=Active
	s additionalNum=additionalNum
	///无，医嘱描述，医嘱id，绑定途径(1:下医嘱绑定,2:执行绑定),
	///绑定方式(1:按天,2:按次),启用(Y\N)
	///起收数量（数字）
	set Data=$lb(Index,ARCIMDesc,InstrArcimId,AppendType,ExecType,Active,additionalNum,Qty,EndNum,ByHand,SingleNotFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimWardLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimWardLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimWardLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimWardLinkExecute ]
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

ClassMethod GetArcimWardLinkExpInfo(LocId As %String, queryName As %String, QueryID As %String) As %String
{
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	s ConfigName=""
	if (queryName="Instr"){
		s ConfigName="InstrArcimWard"
	}elseif (queryName="Arcim"){
		s ConfigName="ArcimWardAdd"
	}
	if (ConfigName="")||(WardID="")||(QueryID=""){
		q ""
	}
	s SingleNotFee=$G(^DHCDocConfig(ConfigName,WardID,QueryID,"SingleNotFee"))
	s Str=SingleNotFee
	q Str
}

ClassMethod SaveArcimWardLinkExpInfo(LocId As %String, queryName As %String, QueryID As %String, SaveInfo As %String) As %String
{
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	s ConfigName=""
	if (queryName="Instr"){
		s ConfigName="InstrArcimWard"
	}elseif (queryName="Arcim"){
		s ConfigName="ArcimWardAdd"
	}
	if (ConfigName="")||(WardID="")||(QueryID=""){
		q "100"
	}
	s SingleNotFee=$P(SaveInfo,"^",1)
	s ^DHCDocConfig(ConfigName,WardID,QueryID,"SingleNotFee")=SingleNotFee

	s Json="0"
	q Json
}

Query FindArcimWardList(LocId As %String, ArcimAlias As %String) As %Query(ROWSPEC = "ARCIMRowID:%String,ARCICDesc:%String,ARCIMDesc:%String")
{
}

ClassMethod FindArcimWardListExecute(ByRef qHandle As %Binary, LocId As %String, ArcimAlias As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindArcimWardList",31,"wssc")
	s ^TMP("FindArcimWardList")=LocId_","_ArcimAlias
	s ArcimAlias=$$ALPHAUP^SSUTIL4(ArcimAlias)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s CTLOCType=$P(^CTLOC(LocId),"^",13)
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
    if (CTLOCType'="W")||(WardID="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	if (ArcimAlias'=""){
	 	s ArcimMaster=""  for{
		 	set ArcimMaster=$o(^ARCIM(ArcimMaster))
		 	q:(ArcimMaster="")
		 	s ArcimChild=""  for{
			 	set ArcimChild=$o(^ARCIM(ArcimMaster,ArcimChild))
			 	q:((ArcimChild=""))
			 	continue:+ArcimChild<1
			 	s ArcimDesc=$P($g(^ARCIM(ArcimMaster,ArcimChild,1)),"^",2)
			 	s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
				s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
				s ARCIMRowID=ArcimMaster_"||"_ArcimChild
				continue:(##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowID)=1)
				s Find=0
				s ArcAlias=0
				for {
					s ArcAlias=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowID,ArcAlias))
					q:ArcAlias=""
					s ArcAliasD=$p(^ARC("ALIAS",ArcAlias),"^",6)
					if (($ZCVT(ArcimAlias,"U")=$E($ZCVT(ArcAliasD,"U"),1,$L($ZCVT(ArcimAlias,"U"))))){
						s Find=1
						q
					}
				}
				continue:(Find=0)
				s ARCIMDesc=ArcimDesc
				s ItemCatDr=$P(^ARCIM(ArcimMaster,ArcimChild,1),"^",10) 
				s ARCICDesc=$P(^ARC("IC",ItemCatDr),"^",2)	
				d OutputRowFindArcimWardList
		 	}
	 	}
	 	/*
		Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
		If rset.QueryIsValid() { 
			s GroupID=%session.Data("LOGON.GROUPID")
			Set Status=rset.Execute(ArcimAlias,GroupID,"","")
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s ARCIMRowID = rset.GetData(2)
				continue:(ARCIMRowID'["||")
				s ARCIMDesc=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",2)
				s ItemCatDr=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",10) 
				s ARCICDesc=$P(^ARC("IC",ItemCatDr),"^",2)				
				d OutputRowFindArcimWardList
			}
			d rset.Close()
		}
		*/
	}else{
		s ARCIMRowID=0
		for {
			s ARCIMRowID=$O(^DHCDocConfig("ArcimWardAdd",WardID,ARCIMRowID))
			q:ARCIMRowID=""
			continue:(ARCIMRowID'["||")
			s ARCIMDesc=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",2)
			s ItemCatDr=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",10) 
			s ARCICDesc=$P(^ARC("IC",ItemCatDr),"^",2)
			d OutputRowFindArcimWardList
		}
	}
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcimWardList
	s ARCIMDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ARCIMDesc)
	set Data=$lb($g(ARCIMRowID),$g(ARCICDesc),$G(ARCIMDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimWardListExecute ]
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

/// Input:        EpisodeID:就诊ID   ArcimRowId:医嘱项  InstrRowId:用法id  QueAppendType绑定方式(1:下医嘱绑定,2:执行绑定)
/// OutPut:需绑定医嘱列表:医嘱项id^绑定模式(1:一天一次,2:按次,按医嘱绑定只有按天，3按最大频次，10首次，11接瓶)^起始数量(按医嘱绑定无起始数量)^数量^配置方式(1:按医嘱；2:按用法)^仅成组医嘱绑定费用(1:是,0:全部)^截止数量(按医嘱绑定无截止数量，大于截止数量时不再绑定)^绑定方式(1自动绑定，2手工绑定)^不需要绑定的医嘱类型(^OECPR,RowID,_分割)$C(2)....$C(2)
/// w ##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(163,"157||144",18,"2")
ClassMethod GetArcimWardInfo(EpisodeID As %String, ArcimRowId As %String, InstrRowId As %String, QueAppendType As %String) As %String
{
	n (EpisodeID,ArcimRowId,InstrRowId,QueAppendType)
	s ArcimWardInfo=""
	s PatWard=$P(^PAADM(EpisodeID),"^",70)
	q:PatWard="" ""
	
	if (ArcimRowId'=""){
		s AppendOrdType=1
		s ConfigName="ArcimWardAdd"
		s SubName=ArcimRowId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(ConfigName,PatWard,SubName,Index))
			q:Index=""
			if (+Index'=Index){
				continue
			}
			s Val=^(Index)
			d SortData
		}
	}
	if (InstrRowId'=""){
		s AppendOrdType=2
		s ConfigName="InstrArcimWard"
		s SubName=InstrRowId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(ConfigName,PatWard,SubName,Index))
			q:Index=""
			if (+Index'=Index){
				continue
			}
			s Val=^(Index)
			d SortData
		}
	}
	q ArcimWardInfo
SortData
	s ArcimId=$P(Val,"^",1)
	s AppendType=$P(Val,"^",2)
	s ExecType=$P(Val,"^",3)
	s Active=$P(Val,"^",4)
	s additionalNum=$P(Val,"^",5)
	s Qty=$P(Val,"^",6)
	s EndNum=$P(Val,"^",7)
	s ByHand=$P(Val,"^",8)
	s NotLinkPriorStr=$G(^DHCDocConfig(ConfigName,PatWard,SubName,Index,"NotLinkPrior"))
	s NotLinkPriorStr=$TR(NotLinkPriorStr,"^","_")
	s SingleNotFee=$P(Val,"^",9)
	i (SingleNotFee="")||(SingleNotFee="Y") {
		s SingleNotFee="1"
	}else{
		s SingleNotFee="0"
	}
	q:(Active'="Y")
	q:(QueAppendType'=AppendType)
	//s SingleNotFee=$G(^DHCDocConfig(ConfigName,PatWard,SubName,"SingleNotFee"))
	if (ArcimWardInfo=""){
		s ArcimWardInfo=ArcimId_"^"_ExecType_"^"_additionalNum_"^"_Qty_"^"_AppendOrdType_"^"_SingleNotFee_"^"_EndNum_"^"_ByHand_"^"_NotLinkPriorStr
	}else{
		s ArcimWardInfo=ArcimWardInfo_$C(2)_ArcimId_"^"_ExecType_"^"_additionalNum_"^"_Qty_"^"_AppendOrdType_"^"_SingleNotFee_"^"_EndNum_"^"_ByHand_"^"_NotLinkPriorStr
	}	
	q
}

// w ##class(DHCDoc.DHCDocConfig.InstrArcim).CheckInstrAppendItemStr("3790||1!0!0!^3795||1!0!0!110^3790||1!0!0!110",110)

ClassMethod CheckInstrAppendItemStr(AppendItemStr As %String, UserLoc As %String, Type As %String = "") As %String
{
	Q:AppendItemStr="" ""
	s UserLocAppendItemStr="",AllLocAppendItemStr=""
	for i=1:1:$L(AppendItemStr,"^") {
		Set AppendItemNod=$p(AppendItemStr,"^",i)
		if (Type="NURADD"){
			Set InstrLocRowId=$P(AppendItemNod,"!",2)
		}else{
			Set InstrLocRowId=$P(AppendItemNod,"!",4)
		}
		
		if (InstrLocRowId=UserLoc){
			i UserLocAppendItemStr="" s UserLocAppendItemStr=AppendItemNod
			e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_AppendItemNod
		}else{
			if (InstrLocRowId=""){
				i AllLocAppendItemStr="" s AllLocAppendItemStr=AppendItemNod
				e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_AppendItemNod
			}
		}
	}
	Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	Q AllLocAppendItemStr
}

Query FindInstrArcimBPrior(SelName As %String, SelID As %String, LocId As %String, Index As %String) As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrArcimBPriorExecute(ByRef qHandle As %Binary, SelName As %String, SelID As %String, LocId As %String, Index As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindInstrArcimBPrior","Instr",50,197,1)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	s ^tan("FindInstrArcimBPrior")=SelName_","_SelID_","_LocId_","_Index
	q:(SelName="")||(SelID="")||(LocId="")||(Index="") $$$OK
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") $$$OK
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") $$$OK
	if (SelName="Instr"){
		s KeyValStr=$G(^DHCDocConfig("InstrArcimWard",WardID,SelID,Index,"NotLinkPrior"))
	}elseif (SelName="Arcim"){
		s KeyValStr=$G(^DHCDocConfig("ArcimWardAdd",WardID,SelID,Index,"NotLinkPrior"))
	}
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s selected=0
 	.s:(("^"_KeyValStr_"^")[("^"_OECPRRowId_"^")) selected=1
	.Do OutputRowFindInstrArcimBPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrArcimBPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrArcimBPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrArcimBPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrArcimBPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrArcimBPriorExecute ]
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

ClassMethod SaveInstrArcimBPrior(SelName As %String, SelID As %String, LocId As %String, Index As %String, PriorStr As %String) As %String
{
	q:(SelName="")||(SelID="")||(LocId="")||(Index="") -100
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") -200
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") -300
	if (SelName="Instr"){
		s ^DHCDocConfig("InstrArcimWard",WardID,SelID,Index,"NotLinkPrior")=PriorStr
	}elseif (SelName="Arcim"){
		s ^DHCDocConfig("ArcimWardAdd",WardID,SelID,Index,"NotLinkPrior")=PriorStr
	}
	q 0
}

}
