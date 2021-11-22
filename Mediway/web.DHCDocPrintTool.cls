/// 模板对象
/// 把打印数据转为JSON对象
/// w ##class(web.DHCDocPrintTool).getXMLJSONObj("DHCOutPhPYDXY","")
/// input XMLName 模板名称  MesaObj 组织的数据对象
/// return json 对象模式
ClassMethod getXMLJSONObj(XMLName, MesaObj As %DynamicObject) As %DynamicObject
{
	n (XMLName,MesaObj)
   //获取打印模板对象
   Q:XMLName="" ""
   s XMLName=$zcvt(XMLName,"U")
   s XMLName=" "_XMLName
   s Id=$O(^User.DHCXMLPConfigI("XPCFlagIndex",XMLName,0))
   s XMLC=##class(User.DHCXMLPConfig).%OpenId(Id)
   s XMLStr=XMLC.XPCFileData.Read()
   ;组织txt数据
   s TxtData=$P(XMLStr,"<TxtData",2)
   s TxtData=$P(TxtData,"</TxtData>",1)
   s printdata={"data":{}}
   for i=1:1:$L(TxtData,"<txtdatapara")  d
   .s sub=$P(TxtData,"<txtdatapara",i)
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .;s one={}
   .s Printvalue=MesaObj.%Get(name)
   .Q:Printvalue=""
   .;s rtn=one.%Set(name,Printvalue)
   .d printdata.data.%Set(name,Printvalue)
   
    ;组织PICData数据
   s PICData=$P(XMLStr,"<PICData",2)
   s PICData=$P(PICData,"</PICData>",1)
   for i=1:1:$L(PICData,"<PICdatapara")  d
   .s sub=$P(PICData,"<PICdatapara ",i)
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .;s one={}
   .s Printvalue=MesaObj.%Get(name)
   .Q:Printvalue=""
   .;s rtn=one.%Set(name,Printvalue)
   .d printdata.data.%Set(name,Printvalue)
   
   ;获取List节点
   k LisNote
   s ListData=$P(XMLStr,"<ListData",2,9999)
   s ListData=$P(ListData,"</ListData>",1)
   for i=1:1:$L(ListData,"<Listdatapara")  d
   .s sub=$P(ListData,"<Listdatapara",i)
   .Q:sub=""
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .s defaultvalue=$$getnamecode("defaultvalue")
   .s printvalue=$$getnamecode("printvalue")
   .Q:name=""
   .s num=$I(LisNote(0))
   .s LisNote(num)=name
   
   ;获取List的值
   s printdataList={"MyList":[]}
   if $IsObject(MesaObj.MyList){
	   s size=MesaObj.MyList.%Size()
	   for i=0:1:(size-1)  d
	   .s onelistobj=MesaObj.MyList.%Get(i)
	   .s one={}
	   .s find=""
	   .s num1=0
	   .f  s num1=$O(LisNote(num1)) Q:num1=""  d
	   ..s name=$G(LisNote(num1))
	   ..s printvalue=onelistobj.%Get(name)
	   ..s valein=[]
	   ..d valein.%Push(printvalue)
	   ..d one.%Set(name,valein)
	   ..s find="Y"
	   .i find="Y"  d
	   ..d printdataList.MyList.%Push(one) 
   }
   s printdata.data.MyList=##class(%DynamicArray).%New()
   s printdata.data.MyList=printdataList.MyList
   q printdata.data
getnamecode(code)
	s value1=$tr($P($P($P(sub,code,2)," ",1),"=",2),"""","")
	s value1=$tr(value1," ","")
	q value1
}