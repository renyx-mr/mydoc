Class web.DHCDocHLYYInterface Extends %RegisteredObject
{

/// w ##class(web.DHCDocHLYYInterface).Init()
ClassMethod Init(AdmDepRowid As %String, Layout = "OEOrd") As %String
{
	k RetjsonAry
	s HLYYAdmDep=##Class(web.DHCDocConfig).GetConfigNode("DTAdmDep")    //合理用药科室权限
 	Set DTDepNotDoUpLoad="0"
 	Set HLYYYDTS="0"       //药典提示
 	Set HLYYXHZY="0"       //相互作用
 	Set HLYYUpLoad="0"     //下医嘱审核
 	Set HLYYInterface="0"  //合理用药标志
 	Set CurrCompanyCode=""
 	//获取美康审查方式
 	s McSynCheckMode=##Class(web.DHCDocConfig).GetConfigNode("McSynCheckMode")
 	//合理用药涉及的后台数据获取或保存方法
 	s GetPrescXML=""
 	s GetDTYDTS=""
 	s BaseInfo=""
 	//初始化需返回的数组值
 	s RetjsonAry("HLYYInterface")=$g(HLYYInterface)
	s RetjsonAry("CurrCompanyCode")=$g(CurrCompanyCode)
	s RetjsonAry("DTDepNotDoUpLoad")=$g(DTDepNotDoUpLoad)
	s RetjsonAry("McSynCheckMode")=$g(McSynCheckMode)
	s RetjsonAry("GetPrescXML")=$g(GetPrescXML)
	s RetjsonAry("GetDTYDTS")=$g(GetDTYDTS)
	s RetjsonAry("BaseInfo")=$g(BaseInfo)
 	
 	s CurrCompany=##Class(web.DHCDocConfig).GetConfigNode("CurrCompany")
 	s DTCheckCNMed=##class(web.DHCDocConfig).GetConfigNode("DTCheckCNMed")
	s CurrCompanyCode=$p(CurrCompany,"^",2)   //合理用药厂商选择
	s CurrCompanyCode=$$ALPHAUP^SSUTIL4(CurrCompanyCode)
	if CurrCompanyCode="" {
		Quit ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
	}
	if (Layout="CMOEOrd")&&(DTCheckCNMed'="1"){
		Quit ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
	}
 	i (HLYYAdmDep'="")&("^"_HLYYAdmDep_"^"[("^"_AdmDepRowid_"^")){
	 	Set HLYYInterface="1"
	 	;按产家代码新增载入函数,在此自动根据产家代码执行
	 	set ExecLoadCompanyFileMothod="set ret=..Load"_CurrCompanyCode_"()"
	 	x ExecLoadCompanyFileMothod
	 	
	 	;按版本处理后台数据获取或保存方法
	 	s GetPrescXML="web.DHCDocHLYY"_CurrCompanyCode_".GetPrescXML"
	 	s GetDTYDTS="web.DHCDocHLYY"_CurrCompanyCode_"GetDTYDTS"
	 	s BaseInfo="web.DHCDocHLYY"_CurrCompanyCode_"GetBaseInfo"
	 	s RetjsonAry("GetPrescXML")=##Class(%CSP.Page).Encrypt($lb(GetPrescXML))
		s RetjsonAry("GetDTYDTS")=##Class(%CSP.Page).Encrypt($lb(GetDTYDTS))
		s RetjsonAry("BaseInfo")=##Class(%CSP.Page).Encrypt($lb(BaseInfo))
		
	 	s DTDepNotDoStr=##Class(web.DHCDocConfig).GetConfigNode1("DTAdmDep",AdmDepRowid)
	 	s DTDepNotDoYDTS=$p(DTDepNotDoStr,"^",1)
	 	s DTDepNotDoXHZY=$p(DTDepNotDoStr,"^",2)
		s DTDepNotDoUpLoad=$p(DTDepNotDoStr,"^",3)
		
		;引用不同厂家或同厂家不同版本的js
		w "<script type='text/javascript' src='../scripts/dhcdoc/DHCDocHLYY"_CurrCompanyCode_".js'></script>",!
		 	
	}
	
	s RetjsonAry("HLYYInterface")=$g(HLYYInterface)
	s RetjsonAry("CurrCompanyCode")=$g(CurrCompanyCode)
	s RetjsonAry("DTDepNotDoUpLoad")=$g(DTDepNotDoUpLoad)
	
	Q ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
}

/// 加载美康程序
ClassMethod LoadMK()
{
	w "<link rel='stylesheet' type='text/css' href='../CUSTOM/PassJs/McCssAll.css' />" ,!  
	w "<script type='text/javascript' src='../CUSTOM/PassJs/McConfig.js'></script>",!
	w "<script type='text/javascript' src='../CUSTOM/PassJs/McJsAll.js'></script>",!
	Quit 1
}

/// 加载大通程序
ClassMethod LoadDT()
{
	w "<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>"
    w "</object>"
    Q 1
}

/// 加载大通BS版本程序
ClassMethod LoadDTBS()
{
	w "<object id='DtObject' style='display:none' classid='clsid:862DC7EE-F440-4093-B591-E5FCAE890162' codebase = '../addins/client/CRMS_UIForMS.CAB#version=1.0.0.1#RegisterServer=yes#DestDir=""'>"
    w "</object>"
    Q 1
}

/// 加载新产品组的合理用药
ClassMethod LoadDHC()
{
	w "<link rel='stylesheet' href='../scripts/dhcnewpro/dhcckb/css/pdss.css'/>" ,!  
	w "<script type='text/javascript' src='../scripts/dhcnewpro/dhcckb/pdss.js'></script>",!
	Quit 1
}

///加载嘉和美康的合理用药  
ClassMethod LoadJHMK()
{
	w "<script type='text/javascript' src='es5-shim.js' charset='utf-8'></script>"
	w "<script type='text/javascript' src='sockjs.js' charset='utf-8'></script>"
	w "<script type='text/javascript' src='savedata.js' charset='utf-8'></script>"
    Q 1
}

ClassMethod GetArcimInfo(ARCIMRowid As %String) As %String
{
	s OrderName=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",2)
	s ARCIMCode=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",1)
	q ARCIMCode_"^"_OrderName
}

}
