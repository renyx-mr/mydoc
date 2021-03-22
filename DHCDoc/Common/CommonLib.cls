/// creator:郭荣勇
/// date:2014-09-29
/// desc:医生站产品线HTML的head中引用的js和css
Class DHCDoc.Common.CommonLib Extends %RegisteredObject
{

Parameter EasyUIPath = "/scripts_lib/jquery-easyui-1.3.5/";

// Parameter EasyUIPath = "/scripts_lib/jquery-easyui-1.5.2/";

Parameter CommonPath = "/scripts/dhcdocconfig/";

Parameter BootstrapPath = "/scripts_lib/bootstrap-3.3.5/";

Parameter FontAwesomePath = "/scripts_lib/Font-Awesome-4.6.3/";

/// 导入BootStrap库文件
ClassMethod LoadBootstrapLib()
{
	//Set cspUrl=%request.URL
	//s pre=$EXTRACT(cspUrl,1,$F(cspUrl,"csp")-5)
	/*Set cspFix = $p(cspUrl,"/csp/",2)
	Set cspFixLevel = $l(cspFix,"/")
	Set pre = ".."
	for i=2:1:cspFixLevel{
		Set pre = pre_"/.."
	}*/
	
	//<!--Bootstrap css-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#BootstrapPath_"css/bootstrap.min.css"" />"
    
    //<!--Font-Awesome-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#FontAwesomePath_"css/font-awesome.min.css"" />"
    
	//<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#BootstrapPath_"js/jquery-1.11.0.min.js""></script>"
    
    //<!-- Include all compiled plugins (below), or include individual files as needed -->
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#BootstrapPath_"js/bootstrap.min.js""></script>"
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#BootstrapPath_"customplugins/jquery.bootstrap.min.js""></script>"
    
   /* s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#BootstrapPath_"css/bootstrap.min.css"" />"
    
    //<!--Font-Awesome-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#FontAwesomePath_"css/font-awesome.min.css"" />"
    
	//<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"js/jquery-1.11.0.min.js""></script>"
    
    //<!-- Include all compiled plugins (below), or include individual files as needed -->
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"js/bootstrap.min.js""></script>"
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"customplugins/jquery.bootstrap.min.js""></script>"*/
    
    f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// 导入easyUI公共js及css
ClassMethod LoadCommonLib()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/default/easyui.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/icon.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/color.css"" />"
	//<!-- 第三方插件CSS end  -->
	
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jquery-1.8.0.js""></script>"
	//s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jqueryEasyUI-1.3.5.js""></script>"	
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jquery.easyui.min.js""></script>"
	//<!-- 第三方插件 end  -->
    // 公用JS
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#CommonPath_"dhcdoc.config.common.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#CommonPath_"dhcdoc.config.commonutil.js""></script>"		


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// 导入美康js及css
ClassMethod LoadMKLib()
{
	/*
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/default/easyui.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/icon.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/color.css"" />"
	//<!-- 第三方插件CSS end  -->
	
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jquery-1.8.0.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jqueryEasyUI-1.3.5.js""></script>"	
	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	*/
	q
}

}
