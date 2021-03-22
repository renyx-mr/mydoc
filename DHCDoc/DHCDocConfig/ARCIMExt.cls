Class DHCDoc.DHCDocConfig.ARCIMExt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod getARCIMConfig(ArcimRowId As %String) As %String
{
	s rtn=$G(^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),"DHC"))
	i rtn="" s rtn="0^0^0"
	//s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod saveARCIMConfig(ArcimRowId As %String, val As %String) As %String
{
	s ^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),"DHC")=val
	//按该医嘱开始日期停止长期医嘱,用单独的global记录维护的医嘱项,以方便查询
	if ($p(val,"^",3)=1){
		s ^DHCDocConfig("StopAfterAllLongOrder",ArcimRowId)=1
	}else{
		k ^DHCDocConfig("StopAfterAllLongOrder",ArcimRowId)
	}
	//不能被自动停止的长期费用医嘱
    if ($p(val,"^",2)=1){
		s ^DHCDocConfig("NotAutoStopLongOrder",ArcimRowId)=1
	}else{
		k ^DHCDocConfig("NotAutoStopLongOrder",ArcimRowId)
	}
	q 0
}

}
