Class DHCDoc.OPDoc.CMOrderListConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod OrderName1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:xItem_lookuphandler},{type:'click',fn:xItem_lookuphandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderName2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:xItem_lookuphandler},{type:'click',fn:xItem_lookuphandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderName3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:xItem_lookuphandler},{type:'click',fn:xItem_lookuphandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderName4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:xItem_lookuphandler},{type:'click',fn:xItem_lookuphandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseQty1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseQty2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseQty3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseQty4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:Columnfocushandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPhSpecInstr1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPhSpecInstr=$p(ExpStr,"^",1)
	if OrderPhSpecInstr="" s OrderPhSpecInstr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderPhSpecInstr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPhSpecInstrchangehandler},{type:'focus',fn:Columnfocushandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:2}"	
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPhSpecInstr2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPhSpecInstr=$p(ExpStr,"^",1)
	if OrderPhSpecInstr="" s OrderPhSpecInstr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderPhSpecInstr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPhSpecInstrchangehandler},{type:'focus',fn:Columnfocushandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:2}"	
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPhSpecInstr3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPhSpecInstr=$p(ExpStr,"^",1)
	if OrderPhSpecInstr="" s OrderPhSpecInstr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderPhSpecInstr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPhSpecInstrchangehandler},{type:'focus',fn:Columnfocushandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:2}"	
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPhSpecInstr4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPhSpecInstr=$p(ExpStr,"^",1)
	if OrderPhSpecInstr="" s OrderPhSpecInstr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderPhSpecInstr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPhSpecInstrchangehandler},{type:'focus',fn:Columnfocushandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:2}"	
	s Str=Str_"}"
	q Str
}

// 草药录入 隐藏元素 属性设置 必须是编辑模式，否则无法确定元素对象

ClassMethod OrderPrice1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPrice2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPrice3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPrice4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderARCIMID1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderARCIMID2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderARCIMID3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderARCIMID4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderItemID1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderItemID2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderItemID3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderItemID4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderSum1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderSum2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderSum3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderSum4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHiddenPara1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHiddenPara2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHiddenPara3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHiddenPara4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseUOM1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"sortable:false"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseUOM2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"sortable:false"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseUOM3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"sortable:false"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseUOM4(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"sortable:false"
	s Str=Str_"}"
	q Str
}

}
