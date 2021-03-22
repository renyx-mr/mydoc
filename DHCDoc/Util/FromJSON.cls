/// 名称: DHCDoc.Util.FromJSON（来源：DHCHAI.Utils.FromJSON）
/// 描述: 解析json串为json对象
/// 编写者：tanjishan
/// 编写日期: 2018-06-12
Class DHCDoc.Util.FromJSON Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock ]
{

/// 特殊符号
Parameter JsonChars = "{[:,]}";

Property Data As %String(MAXLEN = "") [ MultiDimensional ];

/// 行计数器
Property Row As %Integer;

/// 列计数器
Property Col As %Integer;

/// 当前字符
Property Char As %String;

/// 引号标识“"”
Property CharS As %String;

/// 子字符串
Property SubStr As %String(MAXLEN = "");

/// 是否结束
Property AtEnd As %Boolean;

/// 封装JSON解析服务
ClassMethod %FromJSON(json) As %ArrayOfDataTypes
{
	Set obj=##class(DHCDoc.Util.FromJSON).%New()
	If obj'="" Do obj.%Close()
	Do obj.SetData(json)
	Quit obj.GetData()
}

/// 加载JSON数据
Method SetData(inputJson) As %String
{
	Set %this.Row=0
	Set %this.Col=0
	Set %this.AtEnd=0
	Kill i%Data
	
	Set Count=0
	If $IsObject(inputJson) {
		//输入参数->JSON数据流
		try {
			Do inputJson.Rewind()
			While ('inputJson.AtEnd) {
				Set tmpStr=inputJson.ReadLine(1000)     //Readline()
				Continue:tmpStr=""
				Set Count=Count+1
				Set i%Data(Count)=tmpStr
			}
		} catch {}
	} Else {
		//输入参数->JSON字符串
		Set Count=Count+1
		Set i%Data(Count)=inputJson
	}
	Quit Count
}

/// 解析JSON数据为数组
Method GetData() As %ArrayOfDataTypes
{
	Set json=##Class(%ArrayOfDataTypes).%New()
	Do ..Next()
    If (%this.Char="{"){
	    Set json=..getJSONObject()
	} ElseIf (%this.Char = "[") {
		Set json=..getJSONArray()
	} Else {
		//Json格式错误
	}
	Quit json
}

/// 移动流数据指针位置
Method Next()
{
	Set %this.Char=""
	Set %this.CharS=""
	Set %this.SubStr=""
	If $g(i%Data(%this.Row))="" {
		Set %this.Row=$o(i%Data(%this.Row))
		Set:%this.Row="" %this.AtEnd=1  //表示结束
		Set %this.Col=0
	}
	Quit:%this.AtEnd //退出
	
	Set iData=$g(i%Data(%this.Row))
	While '%this.AtEnd {
		Set %this.Col=%this.Col+1
		If %this.Col>$l(iData) {
			Set %this.Row=$o(i%Data(%this.Row))
			Set:%this.Row="" %this.AtEnd=1  //表示结束
			Set %this.Col=1
			Set iData=$g(i%Data(%this.Row))
		}
		Quit:%this.AtEnd //退出
		
		Set %this.Char=$e(iData,%this.Col,%this.Col)
		Continue:%this.Char=""
		Continue:(%this.CharS'="""")&(%this.Char=" ")  //非字符串内空格-->过滤
		Quit:(%this.CharS'="""")&(..#JsonChars[%this.Char)	//非字符串内特殊符号{[:,]}-->退出
		
		Continue:(%this.CharS="""""")  //表示双引号之外异常内容处理
		If %this.Char="""" {
			If %this.CharS="" {
				Set %this.CharS=%this.Char
			} ElseIf %this.CharS="""" {
				If ($e(%this.SubStr,*)="\") {
					Set %this.SubStr=%this.SubStr_%this.Char
				} Else {
					Set %this.CharS=""""""
				}
			}
		} Else {
			Set %this.SubStr=%this.SubStr_%this.Char
		}
	}
	Quit //退出
}

/// 解析json对象
Method getJSONObject() As %ArrayOfDataTypes
{
	Set jsonObj=##Class(%ArrayOfDataTypes).%New()
	While '%this.AtEnd {
		Do ..Next()
		Set key="",val=""
		Set key=..getKey()
		If (%this.Char=":"){
			Do ..Next()
			Set val=..getVal()
		}
		//If (key'="")&(val'=""){
		//空值也要有输出
		If (key'=""){
			Do jsonObj.SetAt(val,key)
		}
		Continue:%this.Char=","  //如果是,继续
		Quit:%this.Char="}"  //如果是}结束
		Quit //程序错误
    }
    Quit jsonObj
}

/// 解析josn数组
Method getJSONArray() As %ListOfDataTypes
{
	Set jsonArr=##Class(%ArrayOfDataTypes).%New()
	While '%this.AtEnd {
		Do ..Next()
		Set val=..getVal()
		If val'="" {
			Do jsonArr.SetAt(val,jsonArr.Count()+1)
		}
		Continue:%this.Char=","  //如果是,继续
		Quit:%this.Char="]"  //如果是}结束
		Quit //程序错误
	}
	Quit jsonArr
}

/// 获取json键值关键字
Method getKey() As %String
{
	Quit ..evalStr(%this.SubStr)
}

/// 获取json键值结果
Method getVal() As %String
{
	If (%this.Char="{"){
		Set val=..getJSONObject()
		Do ..Next()
	} ElseIf (%this.Char="["){
		Set val=..getJSONArray()
		Do ..Next()
	} Else {
		Set val=..evalStr(%this.SubStr)
	}
	Quit val
}

/// 对JSON数据字符特殊字符处理
ClassMethod evalStr(instr As %String) As %String
{
	Quit:(instr="") instr
	
	//特殊字符处理
	//Set instr = $ZCVT(instr,"I","JSON")
	Set instr = ..Replace(instr, "\u0000", $c(0))
	Set instr = ..Replace(instr, "\u0001", $c(1))
	Set instr = ..Replace(instr, "\u0002", $c(2))
	Set instr = ..Replace(instr, "\u0003", $c(3))
	Set instr = ..Replace(instr, "\u0004", $c(4))
	Set instr = ..Replace(instr, "\u0005", $c(5))
	Set instr = ..Replace(instr, "\u0006", $c(6))
	Set instr = ..Replace(instr, "\u0007", $c(7))
	Set instr = ..Replace(instr, "\b", $c(8))       //Backspace
	Set instr = ..Replace(instr, "\t", $c(9))       //Tab 空白
	Set instr = ..Replace(instr, "\n", $c(10))      //换行
	Set instr = ..Replace(instr, "\u000b", $c(11))
	Set instr = ..Replace(instr, "\f", $c(12))      //换页 空白
	Set instr = ..Replace(instr, "\r", $c(13))      //回车
	Set instr = ..Replace(instr, "\u000e", $c(14))
	Set instr = ..Replace(instr, "\u000f", $c(15))
	Set instr = ..Replace(instr, "\u0010", $c(16))
	Set instr = ..Replace(instr, "\u0011", $c(17))
	Set instr = ..Replace(instr, "\u0012", $c(18))
	Set instr = ..Replace(instr, "\u0013", $c(19))
	Set instr = ..Replace(instr, "\u0014", $c(20))
	Set instr = ..Replace(instr, "\u0015", $c(21))
	Set instr = ..Replace(instr, "\u0016", $c(22))
	Set instr = ..Replace(instr, "\u0017", $c(23))
	Set instr = ..Replace(instr, "\u0018", $c(24))
	Set instr = ..Replace(instr, "\u0019", $c(25))
	Set instr = ..Replace(instr, "\u001a", $c(26))
	Set instr = ..Replace(instr, "\u001b", $c(27))
	Set instr = ..Replace(instr, "\u001c", $c(28))
	Set instr = ..Replace(instr, "\u001d", $c(29))
	Set instr = ..Replace(instr, "\u001e", $c(30))
	Set instr = ..Replace(instr, "\u001f", $c(31))
	Set instr = ..Replace(instr, "\\", "\")
	Set instr = ..Replace(instr, "\""", """")
	Quit instr
}

ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	Quit ##class(DHCHAI.Utils.CommonSrv).Replace(instr,substr,replacement)
}

/// 测试输出方法
ClassMethod OutputJsonTest(json As %ArrayOfDataTypes, head As %String = "") As %String
{
	Set key=""
	For {
		Set value=json.GetNext(.key)
		Quit:key=""
		
		Set data=json.GetAt(key)
		if $IsObject(data){
			w head_key_" = "_data,!
			Do ..OutputJsonTest(data,head_"-")
		} else {
			w head_key_" = "_data,!
		}
	}
	Quit 1
}

/// Do ##Class(DHCDoc.Util.FromJSON).Test()
ClassMethod Test()
{
	New
	set jsonStr = "{""Doc_Title"":""AAA"",""Patient_Id"":{""aaa"":1,""666"":""cc""},""msg"":""aaa""}"
	;Set jsonStr="{""Doc_Title"":""AAA"",""Patient_Id"":[5,{""AA"":""CC"",""BB"":56,""CC"":[{""123"":233}]},""77"",8],""Hospital_Id"":{""aaa"":1,""666"":{""12"":12,""13"":13,""14"":[1,""22"",3,4]},""bbb"":2},""Doc_Content"":444,""222"":444}"
	
	//%DynamicAbstractObject
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(jsonStr)
	Set jsonResult=##class(DHCHAI.RMES.AnalysisSrv).ChangeJsonObject(jsonObject)
	Do ..OutputJsonTest(jsonResult,"-")
	
	Write "*************************************",!
	b
	//FromJSON
	Set jsonResult=##Class(DHCDoc.Util.FromJSON).%FromJSON(jsonStr)
	Do ..OutputJsonTest(jsonResult,"-")
	Quit
}

/// Do ##Class(DHCDoc.Util.FromJSON).SetTestData()
ClassMethod SetTestData(jsonStream, note)
{
	Set num=$i(^TMP("JSON",note))
	While ('jsonStream.AtEnd){
		Set num2=$i(^TMP("JSON",note,num))
		Set ^TMP("JSON",note,num,num2)=jsonStream.Read(1000)
	}
	Quit
}

/// Do ##Class(DHCDoc.Util.FromJSON).Test2("XXX",4)
ClassMethod Test2(note, num)
{
	Quit:(note="")||(num="")
	
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
	Do jsonStream.Clear()
    Do jsonStream.Rewind()
    For num2=1:1:1 {
		Do jsonStream.Write($g(^TMP("JSON",note,num,num2)))
    }
	
	Set jsonResult=##Class(DHCDoc.Util.FromJSON).%FromJSON(jsonStream)
	Do ..OutputJsonTest(jsonResult,"-")
	Quit
}

/// d ##Class(DHCDoc.Util.FromJSON).Test()
ClassMethod Test3() As %String
{
	/*
	s a(1,"Error")=0
	s a(1,"ErrorCode")="成功"
	s a(2,"Error")=1
	s a(2,"ErrorCode")="失败"
	w ##Class(web.DHCOEOrdItemView).GetArrJson(.a),!
	
	s b("Error")=0
	s b("ErrorCode")="成功"
	s b("List",1,"Code")=1
	s b("List",2,"Code")=1
	w ##Class(web.DHCOEOrdItemView).GetArrJson(.b),!
	*/
	s c("CallBakFunS",1,"CallBakFunCode")="SetStartDateEnbale"
	s c("CallBakFunS",1,"CallBakFunParams")=0
	s c("ErrCode")=0
	s c("ErrMsg")=""
	s c("OrdListInfo","ARCIMShowOEMessageFlag")=""
	s c("OrdListInfo","ARCOSSubCatRowid")=80
	w ##Class(DHCDoc.Util.FromJSON).GetArrJson(.c),!
}

/// w ##Class(DHCDoc.Util.FromJSON).GetArrJson(.a)
/// 将数组转化为Json
/// 数组转JSON效率异常的底，注意要尽量少用
ClassMethod GetArrJson(ByRef ParmArr) As %String
{
	s JsonStr=""
	s IsArr=1
	s Node=""
	for {
		s Node=$o(ParmArr(Node))
		q:(Node="")
		if (+Node'=Node){
			s IsArr=0
			q
		}
	}
	s Node=""
	for {
		s Node=$o(ParmArr(Node))
		q:(Node="")
		if (JsonStr'=""){
			s JsonStr=JsonStr_","
		}
		if (IsArr=0){
			s JsonStr=JsonStr_""""_Node_""":"
		}
		s DataStruct=$D(ParmArr(Node))
		if (DataStruct="11")||(DataStruct="10")||(IsArr=1){
			k SubNode
			m SubNode=ParmArr(Node)
			s SubJsonStr=..GetArrJson(.SubNode)
			//s JsonStr=JsonStr_"["_SubJsonStr_"]"
			
			s JsonStr=JsonStr_SubJsonStr
		}else{
			s val=$G(ParmArr(Node))
			//s val=##class(ext.util.String).EvalJSON(val)
			s JsonStr=JsonStr_""""_val_""""
		}
	}
	if (IsArr=1){
		s JsonStr="["_JsonStr_"]"
	}else{
		s JsonStr="{"_JsonStr_"}"
	}
	q JsonStr
}

/// 将标准json转换成数组结构
ClassMethod FromJSONToArr(JsonStr As %String, ByRef ParmArr)
{
	Set FromJSON=##Class(DHCDoc.Util.FromJSON).%FromJSON(JsonStr)
	k ParamArr
	d ..OutputJson(FromJSON,.ParmArr)
}

ClassMethod OutputJson(FromJSON As %ArrayOfDataTypes, ByRef ParmArr)
{
	Set key=""
	For {
		Set value=FromJSON.GetNext(.key)
		Quit:key=""
		Set data=FromJSON.GetAt(key)
		if $IsObject(data){
			k SubArr
			Do ..OutputJson(data,.SubArr)
			m ParmArr(key)=SubArr
		} else {
			s ParmArr(key)=data
		}
	}
}

/// d ##Class(DHCDoc.Util.FromJSON).WriteJsonLine(Json,"-")
/// s Json="{""Doc_Title"":""AAA"",""Patient_Id"":[5,{""AA"":""CC"",""BB"":56,""CC"":[{""123"":233}]},""77"",8],""Hospital_Id"":{""aaa"":1,""666"":{""12"":12,""13"":13,""14"":[1,""22"",3,4]},""bbb"":2},""Doc_Content"":444,""222"":444}"
/// s Json="{""Adm"":""315"",""OrderBillTypeRowid"":""1"",""LogonDep"":""""}"
ClassMethod WriteJsonLine(FromJSON As %ArrayOfDataTypes, Level As %String)
{
	Set key=""
	For {
		Set value=FromJSON.GetNext(.key)
		Quit:key=""
		Set data=FromJSON.GetAt(key)
		if $IsObject(data){
			Do ..WriteJsonLine(data,Level_"-")
			
		} elseif (data[":")&&(data["{") {
			Set data=##Class(DHCDoc.Util.FromJSON).%FromJSON(data)
			Do ..WriteJsonLine(data,Level_"-")
		}else {
			w Level_key_":"_data,!
		}
	}
}

}
