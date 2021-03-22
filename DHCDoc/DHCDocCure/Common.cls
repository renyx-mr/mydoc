Class DHCDoc.DHCDocCure.Common Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetOrderPrior(OrderId As %String)
{
	s LongFlag=0
	Q:OrderId="" LongFlag
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	Q:PriorityDR="" LongFlag
	Q ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
}

/// Desc:根据申请单ID获取病人的就诊ID及病人主索引ID	
ClassMethod GetPatAdmIDByDCA(DCARowId As %String)
{
	Set ret=""
	Quit:DCARowId="" ret
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Quit:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set ret=Adm_"^"_PatientId
	Quit ret
}

/// 清理治疗基础数据
/// d ##class(DHCDoc.DHCDocCure.Common).ClearBaseDHCDocCure()
ClassMethod ClearBaseDHCDocCure()
{
	;清理治疗基础数据----start
	;治疗子类配置
	k ^DHCDocConfig("DHCDocCureItemCat")
	;治疗科室配置
	k ^DHCDocConfig("DHCDocCureLocStr")
	;治疗是否启用分诊配置
	k ^DHCDocConfig("DHCDocCureNeedTriage")
	
	;治疗项目设置
	k ^DHCDocCureItemSet
	;治疗关联科室配置
	k ^DHCDocCureLinkLoc
	k ^DHCDocCureLinkLoci
	;治疗资源计划
	k ^DHCDocCureRBCResPlan
	;治疗排班记录
	k ^DHCDocCureRBCResSchdule
	;治疗服务组配置
	k ^DHCDocCureRBCServiceGroupSet
	;治疗时间段配置
	k ^DHCDocCureRBCTimePeriodSet
	;治疗分配资源配置
	k ^DHCDocCureTR
	k ^DHCDocCureTRi
	;清理治疗基础数据----end
}

/// 清理治疗业务数据
/// d ##class(DHCDoc.DHCDocCure.Common).ClearDataDHCDocCure()
ClassMethod ClearDataDHCDocCure()
{
	;清理治疗业务数据----start
	;治疗申请单、预约记录、治疗记录
	k ^DHCDocCure 
	;治疗分配
	k ^DHCDocCureTRI
	k ^DHCDocCureTRIi
	;预约记录状态改变变化表
	k ^DHCDocCureAASTAT
	k ^DHCDocCureAASTATi
	;清理治疗业务数据----end
}

ClassMethod EvalJson(val, type As %String = "")
{
	s rtn=""
	if (type="JSON"){
		s rtn="{"_"""result"""_":"_""""_val_""""_"}"
	}else{
		s rtn=val
	}
	q rtn
}

ClassMethod CureEvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ##class(ext.util.String).Replace(mystr,"\", "\\")
	
	s mystr = ##class(ext.util.String).Replace(mystr,"""", "\""")
	
	//s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(8), "\b") 			// 退格(BS)
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(9), "\t")
	
	;s mystr = ..Replace(mystr,$c(10), "\n")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(12), "") // FF(NP from feed, new page)
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(13), "\r")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(14), "") //SO(shift out)  
	//32之前是不可见字符
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(0), "")
	q mystr
}

/// w ##class(DHCDoc.DHCDocCure.Common).DateLogicalToHtml() $h
ClassMethod DateLogicalToHtml(h As %String = "")
{
	if h="" s h=+$H
	s Date=##class(websys.Conversions).DateLogicalToHtml(h)	
	Q Date
}

}
