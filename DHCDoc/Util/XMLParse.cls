/// 对于xml处理的公共工具类，主要针对：JSON，XML，对象之间的相互转换
/// 2019-08-20
Class DHCDoc.Util.XMLParse Extends (%RegisteredObject, %XML.Adaptor)
{

/// XML字符串或者流转对象
/// s obj=##class(XML.Parse).XMLToObj("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>")
ClassMethod XMLToObj(XMLStream) As %DynamicObject
{
	s JsonStr=..XMLToJSON(XMLStream)
	s obj=##class(%DynamicObject).%FromJSON(JsonStr)
	Q obj
}

/// XML字符串或者流转JSON流
/// w ##class(XML.Parse).XMLToJSON("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>")
ClassMethod XMLToJSON(XMLStream) As %GlobalCharacterStream
{
	s Stream=##class(%GlobalCharacterStream).%New()
	if $IsObject(XMLStream) s sc = ##class(%XML.TextReader).ParseStream(XMLStream,.reader)
	else  s sc = ##class(%XML.TextReader).ParseString(XMLStream,.reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			s Type=reader.NodeType,Path=reader.Path
			if Type="element"{
				s ParentPath=$P(Path,"/",1,$L(Path,"/")-1)
				if ParentPath'=""{
					s PList(ParentPath,"LeftSymbol")="{"
					s ParentParentPath=$P(ParentPath,"/",1,$L(ParentPath,"/")-1)
					if ParentParentPath'=""{
						if PList(ParentParentPath,"LeftSymbol")="{"{
							s PList(ParentPath,"LeftSymbol")="["
						}
					}
				}
			}elseif Type="endelement"{
				s LeftSymbol=$G(PList(Path,"LeftSymbol"))
				s RightSymbol=$CASE(LeftSymbol,"{":"}","[":"]",:"")
				s Value=$G(PList(Path,"Value"))
				if Value'=""{
					s Value=LeftSymbol_$G(PList(Path,"Value"))_RightSymbol
					i LeftSymbol="[" s Value=""""_reader.Name_""":"_Value
					s ParentPath=$P(Path,"/",1,$L(Path,"/")-1)
					if ParentPath'=""{
						i $G(PList(ParentPath,"Value"))="" s PList(ParentPath,"Value")=Value
						e  s PList(ParentPath,"Value")=PList(ParentPath,"Value")_","_Value
					}else{
						if 'Stream.%IsNull() d Stream.Write(",")
						d Stream.Write(Value)
					}
				}
				k PList(Path)
			}else{
				s Name=$P(Path,"/",$L(Path,"/"))
				s PList(Path,"Value")=""""_Name_""":"""_reader.Value_""""
			}
		}
	}
	if Stream.%IsNull() d Stream.Write("{}")
	Q Stream
}

/// JSON字符串或流转XML流
/// w ##class(XML.Parse).JSONToXML(str,"Request").Read()
ClassMethod JSONToXML(JSONStream, RootName, NodeList) As %GlobalCharacterStream
{
	s obj=##class(%DynamicObject).%FromJSON(JSONStream)
	Q ..ObjToXML(obj,RootName,.NodeList)
}

/// 对象转XML流
/// w ##class(XML.Parse).ObjToXML(obj,"Request",.NodeList).Read()
ClassMethod ObjToXML(obj, RootName, NodeList) As %GlobalCharacterStream
{
	s Stream=##class(%GlobalCharacterStream).%New()
	s HideNode=""
	s HideNode=$G(NodeList(RootName,"HideNode"))
	i 'HideNode d Stream.Write("<"_RootName_">")
	s iter=obj.%GetIterator()
	while iter.%GetNext(.key,.value){
		if $IsObject(value){
			if $ClassName(obj)="%Library.DynamicArray"{
				s key=$G(NodeList(RootName,"ChildNode"))
				s:key="" key=$E(RootName,1,$L(RootName)-1)
			}
			d Stream.CopyFrom(..ObjToXML(value,key,.NodeList))
		}else{
			d Stream.Write("<"_key_">"_value_"</"_key_">")
		}
	}
	i 'HideNode d Stream.Write("</"_RootName_">")
	Q Stream
}

/// w ##Class(DHCDoc.Util.XMLParse).Test()
ClassMethod Test()
{
	s OutputObj={}
	s OutputObj.ResultCode=0
	s OutputObj.ResultContent="成功"
	s RecordArr=[]
	for i=1,2{
		s RecordObj={}
		s RecordObj.RegNum=i
		s RecordObj.NowSeq=i+1
		s List=[]
		for i=3,4{
			s obj={}
			s obj.val1=i
			s obj.val2=i+1
			d List.%Push(obj)
		}
		s RecordObj.List1=List
		d RecordArr.%Push(RecordObj)
	}
	s OutputObj.WaitList=RecordArr
	s NodeList("WaitList","ChildNode")="MyNode1"
	s NodeList("WaitList","Hide")=1
	s NodeList("List1","ChildNode")="MyNode2"
	s NodeList("List1","Hide")=1
	b 
	Q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutputObj,"Response","").Read()
}

ClassMethod Test2()
{
	s OutputObj={
		"returnCode":0,
		"returnMsg":"成功",
		"returnData":[{
			"doctorId":"1691",
			"doctorName":"内分泌普通号","branchName":"","deptId":"7",
			"deptName":"内分泌门诊","doctorTitle":"普通号","doctorGender":"",
			"regScheduleInfos":[{
				"scheduleNo":"4001||529","regDate":"2019-07-04","regWeekDay":"Thursday",
				"scheduleType":"A","regStatus":"OPEN","regTotalCount":"100",
				"regleaveCount":"100","regFee":100,"treatFee":500,"isTimeReg":"N"
				},{
					"scheduleNo":"4001||1007","regDate":"2019-07-04","regWeekDay":"Thursday",
					"scheduleType":"P","regStatus":"OPEN","regTotalCount":"100",
					"regleaveCount":"100","regFee":100,"treatFee":500,"isTimeReg":"N"
				}]
			}]
		}
	s NodeList("returnData","ChildNode")="doctorInfo"
	s NodeList("regScheduleInfos","ChildNode")="regScheduleInfo"
	s NodeList("regScheduleInfos","HideNode")=1
	Q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutputObj,"Response",.NodeList).Read()
}

}
