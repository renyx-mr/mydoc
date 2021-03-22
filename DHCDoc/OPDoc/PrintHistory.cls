Class DHCDoc.OPDoc.PrintHistory Extends %Persistent
{

/// Created by lihaihong@20160811 for logging the print info of OEItem
Property OEItemID As %String;

Property OperatorID As %String;

Property PrintCount As %Integer;

Property LastPrintDateTime As %String;

Property MenuCode As %String;

Index mainIndex On (OEItemID, OperatorID, MenuCode);

// d ##class(DHCDoc.OPDoc.PrintHistory).Test()

ClassMethod Test()
{
	w ##class(DHCDoc.OPDoc.PrintHistory).Record("11^22")
	w ##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount("11")
}

ClassMethod GetPrintCount(OEItemID, type As %String = "") As %Integer
{
	s Index=$I(^tempscl("GetPrintCount"))
	s ^tempscl("GetPrintCount",Index)=OEItemID_","_type
	q:OEItemID="" 0
	q:'$d(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_OEItemID)) 0
	s sum=0
	s opId="" f  s opId=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_OEItemID,opId)) q:opId=""  d
	.s mv="" f  s mv=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_OEItemID,opId,mv)) q:mv=""  d
	..s id="" f  s id=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_OEItemID,opId,mv,id)) q:id=""  d
	...s i=$lg(^DHCDoc.OPDoc.PrintHistoryD(id),4)
	...s printType=$lg(^DHCDoc.OPDoc.PrintHistoryD(id),6)
	...q:(printType'=type)&&(type'="")
	...s sum=sum+i
	q sum
}

// d ##class(DHCDoc.OPDoc.PrintHistory).GetPrintMenue("280||1^280||10^280||2^280||6^280||7^280||9")

ClassMethod GetPrintMenue(OEItemID) As %Integer
{
	q:OEItemID="" ""
	s len=$l(OEItemID,"^")
	k map
	w "{"
	s count=0
	f i=1:1:$l(OEItemID,"^") d
	.s oe=$p(OEItemID,"^",i)
	.q:'$d(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe))
	.s opId="" f  s opId=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe,opId)) q:opId=""  d
	..s mv="" f  s mv=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe,opId,mv)) q:mv=""  d
	...q:$d(map(mv))
	...s map(mv)=""
	...w:count>0 ","
	...w """"_$e(mv,2,$l(mv))_""":true"
	...s count=count+1
	w "}"
	q ""
}

// d ##class(DHCDoc.OPDoc.PrintHistory).Record("223||3^223||5","CFZ.223||3trueCFZ.223||5trueCFD.223||3trueCFD.223||5trueSYD.223||3trueSYD.223||5true")

ClassMethod Record(oeList, menuOERalation = "", operator = "NULL", selectedListRows As %String = "") As %Integer
{
	s ^tempscl("Record")=oeList_","_menuOERalation_","_operator_","_selectedListRows
	q:oeList="" 0
	q:menuOERalation="" 0
	s:operator="" operator="NULL"
	s:selectedListRows'="" selectedListRows="^"_selectedListRows_"^"
	;s menuOERalation=^testlhh ;=menuOERalation
	k OEMenueMap
	f i=1:1:$l(menuOERalation,$char(1)) d
	.s a=$p(menuOERalation,$char(1),i)
	.q:a=""
	.s a=$p(a,$char(2),1)
	.s mv=$p(a,".",1)
	.s oeid=$p(a,".",2)
	.s OEMenueMap(oeid,mv)=""
	s len=$l(oeList,"^")
	s saveCount=0
	f i=1:1:$l(oeList,"^") d
	.s oe=$p(oeList,"^",i)
	.q:'$d(OEMenueMap(oe))
	.s mv="" f  s mv=$o(OEMenueMap(oe,mv)) q:mv=""  d
	..s PrescNo=$p($g(^OEORD(+oe,"I",$p(oe,"||",2),1)),"^",14)
	..s EpisodeID=$p(^OEORD(+oe),"^",1)
	..s ReqID=""
	..i mv="JCDMZ" s ReqID=$o(^DHCAPREP(0,"OrdItem",oe,""))
	..i mv="BLDMZ" s ReqID=$o(^DHCAPPPM(0,"OrdItem",oe,""))
	..i mv["CF" s PrintType=PrescNo_mv
	..e  s PrintType=EpisodeID_mv
	..i selectedListRows'="" s PrintType=PrintType_ReqID
	..q:(selectedListRows'="")&&(selectedListRows'[("^"_PrintType_"^"))
	..i ( ('$d(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe))) || ('$d(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe," "_operator))) || ('$d(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe," "_operator," "_mv)))) d
	...s pc=1
	...s ph=##class(DHCDoc.OPDoc.PrintHistory).%New()
	...s ph.OEItemID=oe
	...s ph.OperatorID=operator
	...s ph.LastPrintDateTime=$h
	...s ph.PrintCount=pc
	...s ph.MenuCode=mv
	...s ret=ph.%Save()
	...s saveCount=saveCount+ret
	..e  d
	...s id=$o(^DHCDoc.OPDoc.PrintHistoryI("mainIndex"," "_oe," "_operator," "_mv,""))
	...s list=^DHCDoc.OPDoc.PrintHistoryD(id)
	...s pc=$lg(list,4)
	...s $list(list,4)=pc+1
	...s ^DHCDoc.OPDoc.PrintHistoryD(id)=list
	...s saveCount=saveCount+1
	q saveCount=len
}

Storage Default
{
<Data name="PrintHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEItemID</Value>
</Value>
<Value name="3">
<Value>OperatorID</Value>
</Value>
<Value name="4">
<Value>PrintCount</Value>
</Value>
<Value name="5">
<Value>LastPrintDateTime</Value>
</Value>
<Value name="6">
<Value>MenuCode</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.OPDoc.PrintHistoryD</DataLocation>
<DefaultData>PrintHistoryDefaultData</DefaultData>
<IdLocation>^DHCDoc.OPDoc.PrintHistoryD</IdLocation>
<IndexLocation>^DHCDoc.OPDoc.PrintHistoryI</IndexLocation>
<StreamLocation>^DHCDoc.OPDoc.PrintHistoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
