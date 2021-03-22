Class DHCDoc.OPDoc.TreatPrintConfigQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// Query TreatPrintConfig() As %Query(ROWSPEC = "id:%String,pId:%String,name:%String,eleId:%String,value:%String,displaynum:%Integer,nocheck:%Boolean,checkable:%Boolean,isactive:%Boolean,open:%Boolean,expandmethodforloadingtable:%String,issendmessage:%Boolean,iconstyle:%String,fontstyle:%String,clickevent:%String,urlobject:%String,iconexpression:%String,previewxmlname:%String,printmethod:%String") [ SqlProc ]

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.TreatPrintConfigQuery","TreatPrintConfig","1")
Query TreatPrintConfig(ActiveOrNo As %String, EpisodeID As %String) As %Query(ROWSPEC = "id:%String,pId:%String,name:%String,eleId:%String,value:%String,displaynum:%Integer,nocheck:%Boolean,checked:%Boolean,isactive:%Boolean,open:%Boolean,expandMethodForLoadingTable:%String,issendmessage:%Boolean,icon:%String,fontstyle:%String,clickevent:%String,urlObject:%String,urlStyle:%String,iconExpression:%String,previewxmlname:%String,printmethod:%String,pName:%String") [ SqlProc ]
{
}

ClassMethod TreatPrintConfigExecute(ByRef qHandle As %Binary, ActiveOrNo As %String = "", EpisodeID As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="SELECT * FROM SQLUser.DocCFTreatPrintMainInfo "
	if ActiveOrNo="" {
	    s sqlStr=sqlStr_"WHERE (IsActive='1' OR IsActive='0') "
    }else{
	    s sqlStr=sqlStr_"WHERE (IsActive = '"_ActiveOrNo_"') "
    }
	s sqlStr=sqlStr_"ORDER BY DisplayNum "
	
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	s mySOPRowID=$o(^DHCSOPFCON(0)) 
	s PrtGuideFlag=$p(^DHCSOPFCON(mySOPRowID),"^",43)
	While(resultStr.Next()){
		s id = resultStr.Data("TreatPrintMainID")
		s pId   = resultStr.Data("PId")
		if (pId=0) s pName="无"
		else  s pName=$list(^User.DocCFTreatPrintMainInfoD(pId),3)
		s name = resultStr.Data("DirectoryName")
		s eleId  = resultStr.Data("ElementId")
		s value  = resultStr.Data("Value")
		//门诊收费配置-》门诊系统参数配置-》打印导诊单
		if (value="DZD")&&(PrtGuideFlag'="D")&&(EpisodeID'="") continue
		s displaynum = resultStr.Data("DisplayNum")
		s nocheck = resultStr.Data("noCheckbox")
		s checked  = resultStr.Data("CheckAble")
		if (value="MZBL")&&(EpisodeID'=""){
			;调用电子病历接口判断是否默认勾选
			s InstancePrintedStatus=##Class(EMRservice.HISInterface.HisData).GetInstancePrintedStatus(EpisodeID)
			k TempCongeriesArr
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(InstancePrintedStatus,.TempCongeriesArr)
			if ($g(TempCongeriesArr("hasNoPrinted"))>=1){
				s checked=1
			}else{
				s checked=0
			}
			k TempCongeriesArr
		}
		s isactive   = resultStr.Data("IsActive")
		s open   = resultStr.Data("IsExpand")
		s expandMethodForLoadingTable=resultStr.Data("ExpandMethodForLoadingTable")
		s issendmessage = resultStr.Data("IsSendMessage")
		s icon  = resultStr.Data("IconStyle")
		s fontstyle  = resultStr.Data("FontStyle")
		s clickevent = resultStr.Data("ClickEvent")
		s urlObject  = resultStr.Data("URLObject")
		s urlStyle   = resultStr.Data("URLStyle")
		s iconExpression = resultStr.Data("IconExpression")
		s previewxmlname = resultStr.Data("PreviewXMLName")
		s printmethod    = resultStr.Data("PrintMethod")
	d OutputRow1
	}
	
	quit $$$OK
	
OutputRow1	
	set Data=$lb(id,pId,name,eleId,value,displaynum,nocheck,checked,isactive,open,expandMethodForLoadingTable,issendmessage,icon,fontstyle,clickevent,urlObject,urlStyle,iconExpression,previewxmlname,printmethod,pName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TreatPrintConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TreatPrintConfigExecute ]
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

ClassMethod TreatPrintConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TreatPrintConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
