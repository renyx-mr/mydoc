Class 陕西.中铁西安.打印自费同意书
{

/// 获取自费医嘱的打印数据
ClassMethod GetPrintOrdItemInfo(EpisodeID As %String, OrdItemDrStr As %String)
{
    Set PrintTemp=""
    Set templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)

    Quit:templateId="" ""
    Set PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId,17)
    Set MyList=[]
    Set ListArrCount=0
    For OrdItemDrInd=1:1:$LENGTH(OrdItemDrStr,"^"){
        Set OneOrderStr=$PIECE(OrdItemDrStr,"^",OrdItemDrInd)
        s OrderDr=$P(OneOrderStr,"*",2)
		Continue:OrderDr=""
        s ArcimRowId=$p(OneOrderStr,"*",1)
		continue:ArcimRowId=""
        s OEORDRowId=+OrderDr
        s OEORIChildsub=$p(OrderDr,"||",2)
        s Subscript=$p(ArcimRowId,"||",1)
        s Version=$p(ArcimRowId,"||",2)
        s OrderDate=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
        s OrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
        s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",3)
        s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
        s CTUOMDesc=""
        i DoseUOM'="" s CTUOMDesc=$p($g(^CT("UOM",DoseUOM)),"^",2) //剂量单位
        s OrdPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(OrderDr)
        s QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,9)),"^",4) //整包装数量
        s SumFee=""
        s PriorRowId=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",8)
        s OrderPriorFlag = ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowId)
        s:OrderPriorFlag'="1" SumFee=QtyPackUOM*OrdPrice
        s OrderList(OEORIChildsub)=OrderDate_"^"_ARCIMDesc_"^"_DoseUOM_"^"_OrdPrice_"^"_QtyPackUOM_"^"_SumFee
        Set ListArrCount=ListArrCount+1
    }
    q:ListArrCount=0 ""
    s PrintDataAll=[]
    s PatInfoStr=..GetPatBaseInfo(EpisodeID)
    s onepage={}
    s AdmDep=$p(PatInfoStr,"^",3)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
    s dataobj = ##class(%DynamicObject).%New() 
    ;数据转换
	k MyList
	s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.OrderList,PageOnLine,1,0,.MyList)
	s pagedr=0
	for {  
		s pagedr=$O(MyList(pagedr)) Q:pagedr=""
		s PrintPage="第 "_pagedr_" 页  共 "_PageNum_" 页"
		s dataobj.PrintPage=PrintPage
		s subdr=0
		s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","freq":"","induration":"","phOrdQtyUnit":"","price":""}
		s one.ArcimDesc="项目名称"
		s one.doseQtyUnit="单次数量"
		s one.phOrdQtyUnit="总量"
		s one.price="小计"
		s one.freq="频次"
		s one.induration="疗程"
		d dataobj.MyList.%Push(one)
		for {
			s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""  
			s order=$G(MyList(pagedr,subdr))
			;s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","phOrdQtyUnit":"","price":"","ArcimDesc1":"","doseQtyUnit1":"","phOrdQtyUnit1":"","price1":""}
			s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","freq":"","induration":"","phOrdQtyUnit":"","price":""}
			s one.ArcimDesc=$p(order,"^",1)
			s one.doseQtyUnit=$p(order,"^",2)
			s one.phOrdQtyUnit=$p(order,"^",3)
			s one.price=$p(order,"^",4)
			s one.freq=$p(order,"^",5)
			s one.induration=$p(order,"^",6)
			d dataobj.MyList.%Push(one)
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
	}
    q PrintDataAll.%ToJSON()
}

}
