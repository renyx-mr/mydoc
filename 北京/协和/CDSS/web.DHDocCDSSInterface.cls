Class web.DHDocCDSSInterface Extends %RegisteredObject
{

/// w ##class(web.DHDocCDSSInterface).Init(30)
ClassMethod Init(AdmDepRowid As %String, Layout = "OEOrd")
{
	s CDSSInterface="0"  //Cdss开启标志
	s CurrCompanyCode="JHMK"
	s CDSSOpenAdmDeptFlag=##class(DHCDoc.DHCDocConfig.LocalConfig).CheckExitLocalConfigValue("OPDoc","CDSSOpenAdmDept",AdmDepRowid,",")
	if (CDSSOpenAdmDeptFlag="1"){
		s CDSSInterface="1"
		;按产家代码新增载入函数,在此自动根据产家代码执行
	 	set ExecLoadCompanyFileMothod="set ret=..Load"_CurrCompanyCode_"()"
	 	x ExecLoadCompanyFileMothod
		;引用不同厂家或同厂家不同版本的js
		w "<script type='text/javascript' src='../scripts/DHCDocHLYY"_CurrCompanyCode_".js'></script>",!
	}
	q CDSSInterface_"^"_Layout
}

/// 加载嘉和美康的合理用药  
ClassMethod LoadJHMK()
{
	w "<script type='text/javascript' src='http://10.160.60.74:8099/es5-shim.js' charset='utf-8'></script>",!
	w "<script type='text/javascript' src='http://10.160.60.74:8099/sockjs.js' charset='utf-8'></script>",!
	w "<script type='text/javascript' src='http://10.160.60.74:8099/savedata.js' charset='utf-8'></script>",!
    Q 1
}

/// d ##class(web.DHDocCDSSInterface).LoadInit(30)
ClassMethod LoadInit(AdmDepRowid As %String)
{
	 s CDSSInterface="0"  //Cdss开启标志
	s CurrCompanyCode="JHMK"
	s CDSSOpenAdmDeptFlag=##class(DHCDoc.DHCDocConfig.LocalConfig).CheckExitLocalConfigValue("OPDoc","CDSSOpenAdmDept",AdmDepRowid,",")
	if (CDSSOpenAdmDeptFlag="1"){
		s CDSSInterface="1"
	}
	q CDSSInterface
}

}
