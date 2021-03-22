/// creator:谭吉善
/// date:2017-05-27
/// desc:医生站设置程序->新草药录入设置
Class DHCDoc.DHCDocConfig.CMDocConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      谭吉善
/// CreatDate：    2017-05-27
/// Description:： 查询草药处方类型
Query FindCMPrescType() As %Query(ROWSPEC = "Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod FindCMPrescTypeExecute(ByRef qHandle As %Binary) As %Status
{

	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindCMPrescType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Code=0
    for {
		s Code=$O(^DHCDocConfig("CMPrescTypeList",Code))
		q:Code=""
		s Desc=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",1)
		s Active=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)
		i Active="" s Active="Y"
		d OutputRowFindCMPrescType
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCMPrescType
	set Data=$lb(Code,Desc,Active)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCMPrescTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCMPrescTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCMPrescTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCMPrescTypeExecute ]
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

/// --------------------------
Query FindInstrLinkOrderQty(InstrucRowId As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod FindInstrLinkOrderQtyExecute(ByRef qHandle As %Binary, InstrucRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindInstrLinkOrderQty",15)
	s ^tan("FindInstrLinkOrderQty")=InstrucRowId
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (InstrucRowId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    
    s ILDRowId=0
    for {
		s ILDRowId=$o(^PHCINLD(0,"Instruc",InstrucRowId,ILDRowId))
		Q:ILDRowId=""
		s ILDDosageDr=$p(^PHCINLD(ILDRowId),"^",2)
		continue:ILDDosageDr=""
		s PHCDODesc=$p(^PHCDO(ILDDosageDr),"^",3)
		
		d OutputRowFindInstrLinkOrderQty
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrLinkOrderQty
	set Data=$lb(ILDDosageDr,PHCDODesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrLinkOrderQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrLinkOrderQtyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrLinkOrderQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrLinkOrderQtyExecute ]
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

ClassMethod DelCMPrescType(Code As %String) As %String
{
	kill ^DHCDocConfig("CMPrescTypeList",Code)
	kill ^DHCDocConfig(Code)
	q Code
}

ClassMethod ActiveCMPrescType(Code As %String) As %String
{
	if $D(^DHCDocConfig("CMPrescTypeList",Code)){
		s Active=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)
		i Active="" s Active="Y"
		
		s NewActive=$CASE(Active,"Y":"N",:"Y")
		s $P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)=NewActive
	}
	
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).SaveCMPrescType("FormulaItemCat","协定处方")
ClassMethod SaveCMPrescType(Code As %String, Desc As %String) As %String
{
	s ^tan("SaveCMPrescType")=Code_","_Desc
	if $D(^DHCDocConfig("CMPrescTypeList",Code)){
		q "-1"
	}
	if $D(^DHCDocConfig(Code)){
		q "-2"
	}
	s ^DHCDocConfig("CMPrescTypeList",Code)=Desc_"^Y"
	s ^DHCDocConfig(Code)=0
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).GetCMPrescDetails("CNMedKLItemCat")
ClassMethod GetCMPrescDetails(Code As %String) As %String
{
	n (Code)
	q:Code="" "-100"
	s Sep="#"
	s OutPutStr=""
	//附加医嘱
	s CNMedAppendItem=$G(^DHCDocConfig(Code,"CNMedAppendItem"))
	s CNMedAppendItemDesc=""
	if (+CNMedAppendItem>0) s CNMedAppendItemDesc=$p(^ARCIM(+CNMedAppendItem,$p(CNMedAppendItem,"||",2),1),"^",2)
	//代煎费
	s CNMedCookModeFeeItem=$G(^DHCDocConfig(Code,"CNMedCookModeFeeItem"))
	s CNMedCookModeFeeItemDesc=""
	if (+CNMedCookModeFeeItem>0) s CNMedCookModeFeeItemDesc=$p(^ARCIM(+CNMedCookModeFeeItem,$p(CNMedCookModeFeeItem,"||",2),1),"^",2)
	//默认频次
	s CNMedDefaultFrequence=$G(^DHCDocConfig(Code,"CNMedDefaultFrequence"))
	//默认用法
	s CNMedDefaultInstruction=$G(^DHCDocConfig(Code,"CNMedDefaultInstruction"))
	//默认疗程
	s CNMedDefaultDuration=$G(^DHCDocConfig(Code,"CNMedDefaultDuration"))
	//子类
	s CNItemCat=$G(^DHCDocConfig(Code))
	//s CNItemCat=$Replace(CNItemCat,"^","")
	//默认用量
	s DefaultQtyID=$G(^DHCDocConfig(Code,"DefaultQty"))
	//代煎接收科室
	s CNMedCookDep=$G(^DHCDocConfig(Code,"CNMedCookDep"))
	//代煎接收科室
	s EPCNMedCookDep=$G(^DHCDocConfig(Code,"EPCNMedCookDep"))
	//自动计算附加材料数量
	s CNMedAppendItemQtyCalcu=$G(^DHCDocConfig(Code,"CNMedAppendItemQtyCalcu"))
	//住院自动增加代煎费
	s IPCookModeFeeNoAutoAdd=$G(^DHCDocConfig(Code,"IPCookModeFeeNoAutoAdd"))
	//是否显示明细
	s ApperFormulaItem=$G(^DHCDocConfig(Code,"ApperFormulaItem"))
	//是否打印明细
	s PrintFormulaItem=$G(^DHCDocConfig(Code,"PrintFormulaItem"))
	//默认接受科室
	s CNMedNormDefaultRefLoc=$G(^DHCDocConfig(Code,"CNMedNormKLRefLoc"))
	//住院默认接受科室
	s CNMedNormIPDefaultRefLoc=$G(^DHCDocConfig(Code,"IPCNMedNormKLRefLoc"))
	//禁用代煎勾选
	s NotAllowChangeCook=$G(^DHCDocConfig(Code,"NotAllowChangeCook"))
	//住院默认处方类型
	s IPDefaultCMPrescType=$G(^DHCDocConfig(Code,"IPDefaultCMPrescType"))
	//门诊默认处方类型
	s OPDefaultCMPrescType=$G(^DHCDocConfig(Code,"OPDefaultCMPrescType"))
	//1-5
	s OutPutStr="0"_Sep_CNMedAppendItem_Sep_CNMedCookModeFeeItem_Sep_CNMedDefaultFrequence_Sep_CNMedDefaultInstruction
	//6-10
	s OutPutStr=OutPutStr_Sep_CNMedDefaultDuration_Sep_CNItemCat_Sep_DefaultQtyID_Sep_CNMedCookDep_Sep_EPCNMedCookDep
	//11-15
	s OutPutStr=OutPutStr_Sep_CNMedAppendItemQtyCalcu_Sep_IPCookModeFeeNoAutoAdd_Sep_ApperFormulaItem_Sep_PrintFormulaItem_Sep_CNMedNormDefaultRefLoc
	//16-20
	s OutPutStr=OutPutStr_Sep_NotAllowChangeCook
	s OutPutStr=OutPutStr_Sep_CNMedAppendItemDesc_Sep_CNMedCookModeFeeItemDesc
	//19-21
	s OutPutStr=OutPutStr_Sep_CNMedNormIPDefaultRefLoc_Sep_IPDefaultCMPrescType_Sep_OPDefaultCMPrescType
	
	q OutPutStr
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).SaveCMPrescDetails("CNMedKLItemCat","##46#42#41#16^79^84#13###0#0#0#0#310#1##1#1")
ClassMethod SaveCMPrescDetails(PrescTypeCode As %String, DetailsInfo As %String) As %String
{
	s ^tan("SaveCMPrescDetails")=PrescTypeCode_","_DetailsInfo
	q:PrescTypeCode="" "-100^无效的处方类型代码"
	
	s CNMedAppendItem=$P(DetailsInfo,"#",1)
	s CNMedCookModeFeeItem=$P(DetailsInfo,"#",2)
	s CNMedDefaultFrequence=$P(DetailsInfo,"#",3)
	s CNMedDefaultInstruction=$P(DetailsInfo,"#",4)
	s CNMedDefaultDuration=$P(DetailsInfo,"#",5)
	
	s CNItemCat=$P(DetailsInfo,"#",6)
	s DefaultQtyID=$P(DetailsInfo,"#",7)
	s CNMedCookDep=$P(DetailsInfo,"#",8)
	s EPCNMedCookDep=$P(DetailsInfo,"#",9)
	s CNMedAppendItemQtyCalcu=$P(DetailsInfo,"#",10)
	
	s IPCookModeFeeNoAutoAdd=$P(DetailsInfo,"#",11)
	s ApperFormulaItem=$P(DetailsInfo,"#",12)
	s PrintFormulaItem=$P(DetailsInfo,"#",13)
	s CNMedNormDefaultRefLoc=$P(DetailsInfo,"#",14)
	s NotAllowChangeCook=$P(DetailsInfo,"#",15)
	s CNMedNormIPDefaultRefLoc=$P(DetailsInfo,"#",16)
	s IPDefaultCMPrescType=$P(DetailsInfo,"#",17)
	s OPDefaultCMPrescType=$P(DetailsInfo,"#",18)
	
	s ErrMsg=""
	if (IPDefaultCMPrescType="1")||(OPDefaultCMPrescType="1"){
		s Code=0
	    for {
			s Code=$O(^DHCDocConfig("CMPrescTypeList",Code))
			q:Code=""
			s Desc=$P($G(^DHCDocConfig("CMPrescTypeList",Code)),"^",1)
			if (PrescTypeCode=Code){continue}
			if (IPDefaultCMPrescType="1")&&($G(^DHCDocConfig(Code,"IPDefaultCMPrescType"))=1){
				s ErrMsg=Desc_"已置默认住院处方类型"
			}
			if (OPDefaultCMPrescType="1")&&($G(^DHCDocConfig(Code,"OPDefaultCMPrescType"))=1){
				s ErrMsg=Desc_"已置默认门诊处方类型"
			}
		}
	}
	q:(ErrMsg'="") "-100^"_ErrMsg
	//附加医嘱
	if (CNMedAppendItem["||")||(CNMedAppendItem=""){
		s ^DHCDocConfig(PrescTypeCode,"CNMedAppendItem")=CNMedAppendItem
	}
	//代煎费
	if (CNMedCookModeFeeItem["||")||(CNMedCookModeFeeItem=""){
		s ^DHCDocConfig(PrescTypeCode,"CNMedCookModeFeeItem")=CNMedCookModeFeeItem
	}
	//默认频次
	s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultFrequence")=CNMedDefaultFrequence
	//默认用法
	s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultInstruction")=CNMedDefaultInstruction
	//默认疗程
	s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultDuration")=CNMedDefaultDuration
	//子类
	s ^DHCDocConfig(PrescTypeCode)=CNItemCat
	//默认用量
	s ^DHCDocConfig(PrescTypeCode,"DefaultQty")=DefaultQtyID
	//代煎接收科室
	s ^DHCDocConfig(PrescTypeCode,"CNMedCookDep")=CNMedCookDep
	//代煎接收科室
	s ^DHCDocConfig(PrescTypeCode,"EPCNMedCookDep")=EPCNMedCookDep
	//自动计算附加材料数量
	s ^DHCDocConfig(PrescTypeCode,"CNMedAppendItemQtyCalcu")=CNMedAppendItemQtyCalcu
	//住院自动增加代煎费
	s ^DHCDocConfig(PrescTypeCode,"IPCookModeFeeNoAutoAdd")=IPCookModeFeeNoAutoAdd
	//是否显示明细
	s ^DHCDocConfig(PrescTypeCode,"ApperFormulaItem")=ApperFormulaItem
	//是否打印明细
	s ^DHCDocConfig(PrescTypeCode,"PrintFormulaItem")=PrintFormulaItem
	//默认接受科室
	s ^DHCDocConfig(PrescTypeCode,"CNMedNormKLRefLoc")=CNMedNormDefaultRefLoc
	//禁用代煎勾选
	s ^DHCDocConfig(PrescTypeCode,"NotAllowChangeCook")=NotAllowChangeCook
	//住院默认接受科室
	s ^DHCDocConfig(PrescTypeCode,"IPCNMedNormKLRefLoc")=CNMedNormIPDefaultRefLoc
	//住院默认处方类型
	s ^DHCDocConfig(PrescTypeCode,"IPDefaultCMPrescType")=IPDefaultCMPrescType
	//门诊默认处方类型
	s ^DHCDocConfig(PrescTypeCode,"OPDefaultCMPrescType")=OPDefaultCMPrescType
	q 0
}

}
