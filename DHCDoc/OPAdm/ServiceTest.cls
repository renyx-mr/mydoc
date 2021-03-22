Class DHCDoc.OPAdm.ServiceTest Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:    nikang
/// Desc:       对外预约挂号接口测试类业务
/// CreateTime：2017-08-18
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("CardManager","FindPatientCard","<Request><TradeCode>3013</TradeCode><IDType>01</IDType><IDNo>430105199201254314</IDNo><PatientName>周傳荃</PatientName><CardTypeCode>02</CardTypeCode><PatientCard>430105199201254314</PatientCard><UserID>457</UserID><TerminalID></TerminalID></Request>")
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("","QueryDepartmentGroup","")
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("SelfReg","QueryDepartment","<Request><TradeCode>1012</TradeCode><ExtUserID>457</ExtUserID><DepartmentGroupCode>71</DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><HospitalId>1</HospitalId></Request>")
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("SelfReg","LockOrder","")
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("Other","OPRegReturn","<Request><TradeCode>1003</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>457</ExtUserID><AdmNo>2190</AdmNo><TransactionId></TransactionId><RefundType></RefundType></Request>")
/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("SelfReg","OPRegister","<Request><TradeCode>1101</TradeCode><TransactionId>DHC1708210920000016</TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode></ScheduleItemCode><ExtUserID>457</ExtUserID><PatientCard></PatientCard><CardType>02</CardType><PatientID></PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>450</PayFee><QueueNo></QueueNo></Request>")
/// 这个方法在XECUTE xstr 时返回的RtnObj Undefined,无法解析,已解决，类增加属性[ Not ProcedureBlock ]
ClassMethod DoInterfaceMethod(ClassType As %String, MethodName As %String, RequestStr As %String)
{
	set ^tmpnk("DoInterfaceMethod")=ClassType_"^"_MethodName_"^"_RequestStr
	s RequestStr=$tr(RequestStr," ","")
	set jsonstr=""
	set ClassName=""
	if ClassType="CardManager"{
		set ClassName="DHCExternalService.CardInterface.CardManager"
	}else{
		set ClassName="DHCExternalService.RegInterface.SelfRegMethods"	
	}
	
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId(ClassName_"||"_MethodName)
	if (flag=0)
	{
		s jsonstr="<Response><ResultCode>-1</ResultCode><ResultContent>未找到调用方法</ResultContent></Response>"
		s jsonstr="{"_"""result"""_":"_""""_jsonstr_""""_"}"
		Q jsonstr
	}
	
	set RtnObj=""
	
	set RequestStr=$tr(RequestStr," ","")
	set RequestStr=$tr(RequestStr,$c(10),"")
	set RequestStr=$tr(RequestStr,$c(13),"")

	set xstr="##class("_ClassName_")."_MethodName_"("	
	set xstr=xstr_""""_RequestStr_""""
	set xstr="s RtnObj="_xstr
	set xstr=xstr_")"
	XECUTE xstr
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	s jsonstr=OutputStream.Read()
	s jsonstr="{"_"""result"""_":"_""""_jsonstr_""""_"}"
	
	Q jsonstr
}

/// w ##class(DHCDoc.OPAdm.ServiceTest).DoInterfaceMethod("FindPatientCard","<Request><TradeCode>3013</TradeCode><IDType>01</IDType><IDNo>430105199201254314</IDNo><PatientName>周傳荃</PatientName><CardTypeCode>02</CardTypeCode><PatientCard>430105199201254314</PatientCard><UserID>ZZJ001</UserID><TerminalID>84001066</TerminalID></Request>")
ClassMethod DoInterfaceMethodBak(MethodName As %String, RequestStr As %String)
{
	set ^tmpnk("DoInterfaceMethodBak")=MethodName_"^"_RequestStr
	set jsonstr=""
	set RequestStr=$tr(RequestStr," ","")
	set RequestStr=$tr(RequestStr,$c(10),"")
	set RequestStr=$tr(RequestStr,$c(13),"")
	
	if MethodName="FindPatientCard"{
		set RtnObj=##class(DHCExternalService.CardInterface.CardManager).FindPatientCard(RequestStr)
	}elseif MethodName="SavePatientCard"{
		set RtnObj=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(RequestStr)
	}elseif MethodName="UpdatePatInfo"{
		set RtnObj=##class(DHCExternalService.CardInterface.CardManager).UpdatePatInfo(RequestStr)
	}elseif MethodName="QueryDepartmentGroup"{
		set RtnObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartmentGroup(RequestStr)
	}

	b ;RtnObj
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	s jsonstr=OutputStream.Read()
	s jsonstr="{"_"""result"""_":"_""""_jsonstr_""""_"}"
	
	Q jsonstr
}

/// d ##class(DHCDoc.OPAdm.ServiceTest).FindListByService("QueryDepartmentGroup","")
/// d ##class(DHCDoc.OPAdm.ServiceTest).FindListByService("QueryDepartment","")
ClassMethod GetJsonStrByService(MethodName As %String, RequestStr As %String)
{
	set ^tmpnk("FindListByService")=MethodName_"^"_RequestStr
	set jsonstr=""
	set RequestStr=$tr(RequestStr," ","")
	set RequestStr=$tr(RequestStr,$c(10),"")
	set RequestStr=$tr(RequestStr,$c(13),"")
	
	
	set ClassName="DHCExternalService.RegInterface.SelfRegMethods"
	
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId(ClassName_"||"_MethodName)
	if (flag=0)
	{
		s jsonstr="[]"
		Q jsonstr
	}
	set xstr="##class("_ClassName_")."_MethodName_"("	
	set xstr=xstr_""""_RequestStr_""""
	set xstr="s RtnObj="_xstr
	set xstr=xstr_")"
	XECUTE xstr
	if (MethodName="QueryDepartmentGroup")!(MethodName="QueryDepartment"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s aRtnObj=RtnObj.Departments.GetAt(count)
			s ajsonstr=##class(ext.util.JsonObject).ObjToJson(aRtnObj)
			if jsonstr="" s jsonstr=ajsonstr
			else  s jsonstr=jsonstr_","_ajsonstr
		}
	}elseif MethodName="QueryDoctor"{
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s aRtnObj=RtnObj.Departments.GetAt(count)
			s ajsonstr=##class(ext.util.JsonObject).ObjToJson(aRtnObj)
			if jsonstr="" s jsonstr=ajsonstr
			else  s jsonstr=jsonstr_","_ajsonstr
		}
	}elseif MethodName="QueryAdmSchedule"{
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s aRtnObj=RtnObj.Departments.GetAt(count)
			s ajsonstr=##class(ext.util.JsonObject).ObjToJson(aRtnObj)
			if jsonstr="" s jsonstr=ajsonstr
			else  s jsonstr=jsonstr_","_ajsonstr
		}
	}
	
	s jsonstr="["_jsonstr_"]"
	
	w jsonstr
}

Query FindList(vMethodName As %String, RequestStr As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String,selected:%Boolean")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ServiceTest","FindList","QueryDoctor","<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>457</ExtUserID><DepartmentCode>349</DepartmentCode></Request>")
ClassMethod FindListExecute(ByRef qHandle As %Binary, MethodName As %String, RequestStr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ServiceTest","FindList","QueryOPAppArriveList","<Request><TradeCode>1005</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><PatientNo>0000000016</PatientNo><ExtUserID>457</ExtUserID><CardNo></CardNo><CardType>02</CardType><CredTypeCode></CredTypeCode><IDCardNo></IDCardNo><OrderApptStartDate></OrderApptStartDate><OrderApptEndDate></OrderApptEndDate><QueryDateFlag></QueryDateFlag><QueryUserType></QueryUserType><OrderStatus></OrderStatus><OrderCode></OrderCode></Request>")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ^tmpnk("FindList")=MethodName_"^"_RequestStr
    set jsonstr=""
	set RequestStr=$tr(RequestStr," ","")
	set RequestStr=$tr(RequestStr,$c(10),"")
	set RequestStr=$tr(RequestStr,$c(13),"")
	
	
	set ClassName="DHCExternalService.RegInterface.SelfRegMethods"
	
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId(ClassName_"||"_MethodName)
	if (flag=0)
	{
		s RowID=0
		s Desc="未找到相应方法"
		Do OutputRowFindList
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set xstr="##class("_ClassName_")."_MethodName_"("	
	set xstr=xstr_""""_RequestStr_""""
	set xstr="s RtnObj="_xstr
	set xstr=xstr_")"
	XECUTE xstr
	if (MethodName="QueryDepartmentGroup")!(MethodName="QueryDepartment"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s selected=0
			s aRtnObj=RtnObj.Departments.GetAt(count)
			s RowID=aRtnObj.DepartmentCode
			s Desc=aRtnObj.DepartmentName
			Do OutputRowFindList
		}
	}elseif (MethodName="QueryDoctor"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s selected=0
			s aRtnObj=RtnObj.Doctors.GetAt(count)
			s RowID=aRtnObj.DoctorCode
			s Desc=aRtnObj.DoctorName
			s Desc=$tr(Desc,"（","")
			s Desc=$tr(Desc,"）","")
			Do OutputRowFindList
		}
	}elseif (MethodName="QueryAdmSchedule"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s selected=0
			s aRtnObj=RtnObj.Schedules.GetAt(count)
			s RowID=aRtnObj.ScheduleItemCode
			s Desc=aRtnObj.ServiceDate_" "_aRtnObj.DepartmentName_" "_aRtnObj.DoctorName_" "_aRtnObj.SessionName_" 价格:"_(+aRtnObj.Fee)
			s Desc=$tr(Desc,"（","")
			s Desc=$tr(Desc,"）","")
			Do OutputRowFindList
		}
	}elseif (MethodName="QueryAdmOPReg"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s selected=0
			s aRtnObj=RtnObj.Orders.GetAt(count)
			s RowID=aRtnObj.AdmNo
			s ReturnFlag=(aRtnObj.ReturnFlag)
			if ReturnFlag="Y" s ReturnFlag="可退"
			else  s ReturnFlag="不可退"
			s Desc=aRtnObj.RegDate_" "_aRtnObj.PatName_" "_aRtnObj.Department_" "_(aRtnObj.Doctor)_" "_ReturnFlag
			s Desc=$tr(Desc,"（","")
			s Desc=$tr(Desc,"）","")
			Do OutputRowFindList
		}
	}elseif (MethodName="QueryOPAppArriveList"){
		set ResultCount=+RtnObj.RecordCount
		for count=1:1:ResultCount{
			s selected=0
			s aRtnObj=RtnObj.Orders.GetAt(count)
			s RowID=aRtnObj.OrderCode
			s OrderStatus=(aRtnObj.OrderStatus)
			if OrderStatus="normal" s OrderStatus="正常"
			else  s OrderStatus="已取消"
			s Desc=aRtnObj.AdmitDate_" "_aRtnObj.PatientNo_" "_aRtnObj.OrderApptUser_" "_aRtnObj.Department_" "_(aRtnObj.Doctor)_" "_OrderStatus
			s Desc=$tr(Desc,"（","")
			s Desc=$tr(Desc,"）","")
			Do OutputRowFindList
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindList
	set Data=$lb($g(RowID),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindListExecute ]
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

/// Desc:根据传入的xml传得到需要的Node节点的值
/// w ##class(DHCDoc.OPAdm.ServiceTest).GetValueByParseXml("<Response><TradeCode>10015</TradeCode><TransactionId>DHC1708081650000016</TransactionId><ResultCode>0</ResultCode><ResultContent>加号成功</ResultContent><LockQueueNo>51</LockQueueNo><ScheduleItemCode>497||1011</ScheduleItemCode><AdmDate>2017-08-09</AdmDate><AdmTime>白天</AdmTime><RegFee>0</RegFee></Response>","LockOrder","TransactionId")
ClassMethod GetValueByParseXml(XMLInput As %String, Flag As %String, Node As %String)
{
	if (Flag="LockOrder"){
		s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRp).%New()
	}
	d InputObj.XMLNodeDeserialize(.InputObj,"Response",XMLInput)
	s NodeValue=""
	s xstr="s NodeValue=InputObj."_Node
	x xstr
	s NodeValue="{"_"""result"""_":"_""""_NodeValue_""""_"}"
	Q NodeValue
}

ClassMethod GetCardNoLenByType(TypeCode As %String)
{
	Q:TypeCode="" ""
	s CardLen=+$p($g(^DHCCARDTYPEDef(TypeCode)),"^",17)
	Q CardLen
}

ClassMethod GetCardTypeCode(TypeRowID As %String)
{
	Q:TypeRowID="" ""
	s TypeCode=$p($g(^DHCCARDTYPEDef(TypeRowID)),"^",1)
	Q TypeCode
}

}
