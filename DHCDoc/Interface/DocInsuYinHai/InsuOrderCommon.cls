Class DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon Extends %RegisteredObject
{

Parameter HospitalCode = 10000205;

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).FormatPrice(".34")
ClassMethod FormatPrice(Price As %String) As %String
{
	if (Price[".")&&($p(Price,".",1)="") s Price="0"_Price
	Q Price
}

ClassMethod InputOrdItemInfo(OrdItemId As %String)
{
	s InputOrdObj=##class(%ArrayOfDataTypes).%New()
	//d InsertOrdObj.SetAt("1","AAE428")
	// AKC220	VARCHAR(20)	医嘱单据ID	否	医嘱单据ID
	d InputOrdObj.SetAt(OrdItemId,"AKC220")
	// AKC222	VARCHAR(40)	打包项目ID	否	如果是打包项目则必传打包项目ID，否则为空
	d InputOrdObj.SetAt(OrdItemId,"AKC222")
	// YKC610	VARCHAR(32)	费用明细ID	否	
	d InputOrdObj.SetAt(OrdItemId,"YKC610")
	q InputOrdObj
}

ClassMethod GetInsertOrderInfo(AdmId As %String, OrderItemStr As %String, UserID As %String, DeptID As %String)
{
    //s InsertOrderStr=""
    s PatientID=$p(^PAADM(AdmId),"^",1)
    s AdmType=$p(^PAADM(AdmId),"^",4)
    s MRNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,AdmType) //病历号
    s DataObj=##class(%ListOfDataTypes).%New()
    for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
        s OrderDate=$p(OrderItemOne,"^",46)
		s OrderTime=$p(OrderItemOne,"^",47)	;医嘱时间
		s PriorRowid=$p(OrderItemOne,"^",3)	;医嘱类型
		s ARCIMRowid=$p(OrderItemOne,"^",1)	;药品ID
		s DoseQty=$p(OrderItemOne,"^",12)
		s DoseUOMRowid=$p(OrderItemOne,"^",13)	;每次给药剂量
		s InstrRowid=$p(OrderItemOne,"^",17)	;给药途径
		s FreqRowid=$p(OrderItemOne,"^",15)	;给药频率
		s PackQty=$p(OrderItemOne,"^",6)	;发药数量
		s OrderPackUOMRowid=$p(OrderItemOne,"^",55)	;发药数量单位
		s unitprice=$p(OrderItemOne,"^",7)	;单价
		s OrderStDate=$p(OrderItemOne,"^",4)
		s OrderStTime=$p(OrderItemOne,"^",5)	;医嘱生效时间
		s EndDate=$p(OrderItemOne,"^",26)
		s EndTime=$p(OrderItemOne,"^",27)	;医嘱失效时间
		s DurRowid=$p(OrderItemOne,"^",16)	;疗程
		s NotifyClinician=$p(OrderItemOne,"^",30)	;紧急标志
		s OrderNeedPIVAFlag=$p(OrderItemOne,"^",48)	;静配标志
		s SkinTest=$p(OrderItemOne,"^",21)	;皮试标志
		s SpeedFlowRate=$p(OrderItemOne,"^",36)
		s FlowRateUnitDR=$p(OrderItemOne,"^",45)	;给药速度
		//s orderid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;医嘱id
		s groupno=$p(OrderItemOne,"^",19)
		if (groupno="") s groupno=$p(OrderItemOne,"^",20)	;组号
		//s recipeid=EpisodeID_"^"_UserID_"^"_+$h_"^"_$p($h,",",2)	;处方ID
		//s recipeitemid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;处方明细编号
		s ArrayObj=##class(%ArrayOfDataTypes).%New()
        s InsertOrdObj=##class(%ArrayOfDataTypes).%New()
        // AKC190	VARCHAR(100)	住院流水号	是	医院内部住院号（医院内唯一）
        d InsertOrdObj.SetAt(MRNo,"AKC190")
        // AAE428	VARCHAR(6)	明细类型（码值）	是	系统码值：1表示处方明细；2表示费用明细
        d InsertOrdObj.SetAt("1","AAE428")
        // AAE429	VARCHAR(6)	送审数据类型（码值）	是	系统码值：0表示历史数据；1表示当次送审数据
        d InsertOrdObj.SetAt("1","AAE429")
        // AKC220	VARCHAR(40)	医嘱明细ID	是	医嘱明细ID,如果是打包项目则传包ID
        d InsertOrdObj.SetAt("","AKC220")
        // AKC221	VARCHAR(21)	医嘱单据发生时间	是	格式: yyyy-MM-dd HH:mm:ss
        set DateStr=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
        d InsertOrdObj.SetAt(DateStr,"AKC221")
        // AAE036	VARCHAR(21)	医嘱明细发生时间	是	医生下医嘱后保存到HIS系统的时间。格式: yyyy-MM-dd HH:mm:ss
        d InsertOrdObj.SetAt(DateStr,"AAE036")
        // AKC310	VARCHAR(32)	医嘱明细ID	是	医生下医嘱生成的ID
        d InsertOrdObj.SetAt("","AKC310")
        // AAZ603	VARCHAR(6)	医嘱明细状态（码表）	是	系统码表，1有效,0无效
        d InsertOrdObj.SetAt("1","AAZ603")
        // AAE310	VARCHAR(21)	医嘱开始执行时间	是	格式: yyyy-MM-dd HH:mm:ss
        s OrderDate=##class(websys.Conversions).DateHtmlToLogical(OrderDate)
		s OrderTime=##class(websys.Conversions).TimeHtmlToLogical(OrderTime)
        d InsertOrdObj.SetAt(OrderStDate_""_OrderStTime,"AAE310")
        // AAE311	VARCHAR(21)	医嘱结束执行时间	是	格式: yyyy-MM-dd HH:mm:ss
        d InsertOrdObj.SetAt("","AAE311")
        // APE896	VARCHAR(6)	项目明细类型	否	如：1.自费,2.报销等
        Set OrderCoverMainIns=$p(OrderItemOne,"^",23)
        if OrderCoverMainIns="Y" s OrderCoverMainIns="2"
        e  s OrderCoverMainIns="1"
        d InsertOrdObj.SetAt(OrderCoverMainIns,"APE896")
        // AKE003	VARCHAR(6)	医保三大目录类别（码表）	是	系统码表，1药品，2诊疗项目，3服务设施，4医用材料
        d InsertOrdObj.SetAt("1","AKE003")
        // AKE001	VARCHAR(50)	医保三大目录统一项目编码	是	医保三大目录统一项目编码
        d InsertOrdObj.SetAt("86901660000907","AKE001")
        // AKE002	VARCHAR(100)	医保三大目录统一项目名称	是	医保三大目录统一项目名称
        d InsertOrdObj.SetAt("复方氨基酸注射液(18AA)","AKE002")
        // AKC515	VARCHAR(50)	医院项目编码	是	院内收费项目编码
        d InsertOrdObj.SetAt("","AKC515")
        // AKE006	VARCHAR(100)	医院项目名称	是	医院内部项目名称,如果是打包项目则为包名称
        s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
        d InsertOrdObj.SetAt(ARCIMDesc,"AKE006")
        // AKA063	VARCHAR(6)	项目类别代码	否	医嘱项目类别代码，比如“01”。
        s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
        s OrdCatDR=$p($g(^ARC("IC",ItemCatDR)),"^",8) // OECOrderCategory
        // AKA064	VARCHAR(6)	项目类别名称	否	医嘱项目类别名称。比如”西药”。
		d InsertOrdObj.SetAt($case(OrdCatDR,"1":"A","2":"B","3":"B","14":"C","13":"D","6":"F","8":"H",:"Z"),"AKA063")
        // AKA064	VARCHAR(6)	项目类别名称	否	医嘱项目类别名称。比如”西药”。
		d InsertOrdObj.SetAt($case(OrdCatDR,"1":"西药","2":"中药","3":"中药","14":"化验","13":"检查","6":"手术","8":"输血",:"其他"),"AKA064")
        // AKC226	VARCHAR(10)	数量	是	数量，精度0.00
        // AKC226	VARCHAR(10)	数量	是	数量，精度0.00
        if (PackQty="") s PackQty="1"
        d InsertOrdObj.SetAt(PackQty,"AKC226")
        // AKE130	VARCHAR(20)	数量单位	是	数量单位或计价单位
        ;发药数量单位
        s packunit=""
        if (OrderPackUOMRowid'="") s packunit=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
        d InsertOrdObj.SetAt(packunit,"AKE130")
        // AKC225	VARCHAR(30)	单价	是	单价，默认为0，精度0.0000
        s unitprice=..FormatPrice(unitprice)
        d InsertOrdObj.SetAt(unitprice*PackQty,"AKC225")
        // AKB065	VARCHAR(22)	医疗费总额合计	是	发生金额，默认为0，精度0.0000
        d InsertOrdObj.SetAt("","AKB065")
        // AKA074	VARCHAR(200)	规格	是	
        s specification=""
	    s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	    if (InciRowid'="") s specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
        d InsertOrdObj.SetAt(specification,"AKA074")
        // AKA207	VARCHAR(6) 	手术标志（码表）	是	系统码表，0否，1是
        s AnaesthesiaID=$p(OrderItemOne,"^",37)
        if (AnaesthesiaID'="") s AnaesthesiaID="1"
        e  s AnaesthesiaID="0"
        d InsertOrdObj.SetAt(AnaesthesiaID,"AKA207")
        // AKA208	VARCHAR(6)	出院带药标志（码表）	是	系统码表，0否，1是
        s ordertype="0"
        s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
		if (PriorCode="OUT") s ordertype="1"
        d InsertOrdObj.SetAt(ordertype,"AKA208")
        // AKC229	VARCHAR(5)	用药天数	是	默认为0，精度0.0
        s duration=""
	    if (DurRowid'="") s duration=$p($g(^PHCDU(DurRowid)),"^",3)
        d InsertOrdObj.SetAt(duration,"AKC229")
        // AKA072	VARCHAR(20)	给药频率	是	
        d InsertOrdObj.SetAt(specification,"AKA072")
        // AKA504	VARCHAR(100)	给药频率单位	是	如：天
        s drugusingfreq=""
        s:FreqRowid'="" drugusingfreq=$p(^PHCFR(FreqRowid),"^",3)
        d InsertOrdObj.SetAt(drugusingfreq,"AKA504")
        // AKA181	VARCHAR(50)	给药途径	是	口服，鼻饲等
        s drugadminroutename=""
        s:InstrRowid'="" drugadminroutename=$p($g(^PHCIN(InstrRowid)),"^",2)
        d InsertOrdObj.SetAt(drugadminroutename,"AKA181")
        // AKA503	VARCHAR(100)	给药方式	是	餐前，餐后等
        d InsertOrdObj.SetAt("","AKA503")
        // AKA071	VARCHAR(18)	给药剂量	是	默认为0，精度0.00
        d InsertOrdObj.SetAt(DoseQty,"AKA071")
        // AKE131	VARCHAR(50)	给药剂量单位	是	如：片
        s DoseUOMDesc=""
        s:DoseUOMRowid'="" DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
        d InsertOrdObj.SetAt(DoseUOMDesc,"AKE131")
        // AAZ263	VARCHAR(20)	开单医生编号	是	开单医护人员编号
        s orderdocid=$p($g(^SSU("SSUSR",UserID)),"^",1)
        d InsertOrdObj.SetAt(orderdocid,"AKA074")
        // AAC003	VARCHAR(100)	开单医生名称	是	开单医护人员名称
        s orderdocname=$p($g(^SSU("SSUSR",UserID)),"^",2)
        d InsertOrdObj.SetAt(orderdocname,"AAC003")
        // AAZ307	VARCHAR(20)	开单科室编号	是	开单科室代码
        s orderdeptCode=$p($g(^CTLOC(DeptID)),"^",1)
        d InsertOrdObj.SetAt(orderdeptCode,"AAZ307")
        // AAE386	VARCHAR(100)	开单科室名称	是	开单科室名称
        s orderdeptname=$p($g(^CTLOC(DeptID)),"^",2)
		if (orderdeptname["-") s orderdeptname=$p(orderdeptname,"-",2)
        d InsertOrdObj.SetAt(orderdeptname,"AAE386")
        //按照医嘱输出收费项
        s TariffDR=0
        for {
            s TariffDR=$o(^DHCOLT(0,"ARTTA",ARCIMRowid,TariffDR))
            q:TariffDR=""
            s ArrayObj=##class(%ArrayOfDataTypes).%New()
            // AKE003	VARCHAR(6)	医保三大目录类别（码表）	是	系统码表，1药品，2诊疗项目，3服务设施，4医用材料
            d OrdItemObj.SetAt("","AKE003")
            // AKE001	VARCHAR(50)	医保三大目录统一项目编码	是	医保三大目录统一项目编码
            d OrdItemObj.SetAt("1","AKE001")
            // AKE002	VARCHAR(100)	医保三大目录统一项目名称	是	医保三大目录统一项目名称
            d OrdItemObj.SetAt("药品","AKE002")
            // AKC515	VARCHAR(50)	医院项目编码	是	院内收费项目编码
            d OrdItemObj.SetAt("","AKC515")
            d ArrayObj.SetAt(InsertOrdObj,"HOSPITALDETAILS")
            d DataObj.Insert(ArrayObj)
        }
        //d ArrayObj.SetAt(InsertOrdObj,"HOSPITALDETAILS")
        //d DataObj.Insert(ArrayObj)
        //s InsertOrderStr=InsertOrderStr_##class(DHCDoc.Util.XMLParse).ObjToXML(InsertOrdObj,"HOSPITALDETAILS","").Read()
    }
    q ##class(DHCDoc.Util.FromXML).Arr2XML(DataObj).Read()
}

ClassMethod GetOrderInfo(AdmId As %String)
{
    //s OrderInfoStr=""
    s PatientID=$p(^PAADM(AdmId),"^",1)
    s OrderRowid=$o(^OEORD(0,"Adm",+AdmId,0))
    s PatientID=$p(^PAADM(AdmId),"^",1)
    s AdmType=$p(^PAADM(AdmId),"^",4)
    s MRNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,AdmType) //病历号
    s DataObj=##class(%ListOfDataTypes).%New()
	s ChildSub=0
	for  {
        //s ChildSub=$o(^OEORDi(0,"StDt",+$h,OrderRowid,ChildSub))
        s ChildSub=$o(^OEORD(OrderRowid,"I",ChildSub))
        q:ChildSub=""
        continue:'$d(^OEORD(OrderRowid,"I",ChildSub))
		s MyARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
		continue:MyARCIMRowid=""
		//s DrugFlag=..CheckIsDrugItem(MyARCIMRowid)
		//continue:DrugFlag'="Y"
		continue:MyARCIMRowid=""
        //s OrderRowid=+OEORIRowId,ChildSub=$p(OEORIRowId,"||",2)
		s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
		if (OrderDate="") s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",17)
		if (OrderTime="") s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱时间
		s PriorRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8)	;医嘱类型
		s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)	;药品ID
		s DoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
		s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;每次给药剂量
		s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)	;给药途径
		s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)	;给药频率
		s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)	;发药数量
		s OrderPackUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
		if (OrderPackUOMRowid="") s OrderPackUOMRowid=DoseUOMRowid	;发药数量单位
		s OrderStDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s unitprice=$p(##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,OrderStDate,"","","","","",""),"^",4)	;单价
		s OrderStTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱生效时间
		s EndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
		s EndTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",15)	;医嘱失效时间
		s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)	;疗程
		s NotifyClinician=$p(^OEORD(OrderRowid,"I",ChildSub,11),"^",55)	;紧急标志
		s OrderNeedPIVAFlag=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",16)	;住院静配标志
		s SkinTest=$p($g(^OEORD(OrderRowid,"I",ChildSub,5)),"^",2)	;皮试标志
		s SpeedFlowRate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",17)
		s FlowRateUnitDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,6)),"^",8)	;给药速度
		//s orderid=OEORIRowId	;医嘱id
		s groupno=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
		//if (groupno="") s groupno=OEORIRowId	;组号
		s recipeid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",14)	;处方ID
		
		s UserID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
		s DeptID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",2)
		//s recipeitemid=OEORIRowId	;处方明细编号
		
        s OrdItemObj=##class(%ArrayOfDataTypes).%New()
        // AKC190	VARCHAR(100)	住院流水号	是	医院内部住院号（医院内唯一）
        d OrdItemObj.SetAt(AdmId,"AKC190")
        // AAE428	VARCHAR(6)	明细类型（码值）	是	系统码值：1表示处方明细；2表示费用明细
        d OrdItemObj.SetAt("1","AAE428")
        // AAE429	VARCHAR(6)	送审数据类型（码值）	是	系统码值：0表示历史数据；1表示当次送审数据
        d OrdItemObj.SetAt("0","AAE429")
        // AKC220	VARCHAR(40)	医嘱明细ID	是	医嘱明细ID,如果是打包项目则传包ID
        d OrdItemObj.SetAt(OrderRowid_"||"_ChildSub,"AKC220")
        // AKC221	VARCHAR(21)	医嘱单据发生时间	是	格式: yyyy-MM-dd HH:mm:ss
        set DateStr=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
        d OrdItemObj.SetAt(DateStr,"AKC221")
        // AAE036	VARCHAR(21)	医嘱明细发生时间	是	医生下医嘱后保存到HIS系统的时间。格式: yyyy-MM-dd HH:mm:ss
        d OrdItemObj.SetAt(DateStr,"AAE036")
        // AKC310	VARCHAR(32)	医嘱明细ID	是	医生下医嘱生成的ID
        d OrdItemObj.SetAt(OrderRowid_"||"_ChildSub,"AKC310")
        // AAZ603	VARCHAR(6)	医嘱明细状态（码表）	是	系统码表，1有效,0无效
        d OrdItemObj.SetAt("1","AAZ603")
        // AAE310	VARCHAR(21)	医嘱开始执行时间	是	格式: yyyy-MM-dd HH:mm:ss
        s OrderDate=##class(websys.Conversions).DateHtmlToLogical(OrderDate)
		s OrderTime=##class(websys.Conversions).TimeHtmlToLogical(OrderTime)
        d OrdItemObj.SetAt(OrderStDate_" "_OrderStTime,"AAE310")
        // AAE311	VARCHAR(21)	医嘱结束执行时间	是	格式: yyyy-MM-dd HH:mm:ss
        s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
		s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
        d OrdItemObj.SetAt(EndDate_" "_EndTime,"AAE311")
        // APE896	VARCHAR(6)	项目明细类型	否	如：1.自费,2.报销等
        Set OrderCoverMainIns=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",3)
        if OrderCoverMainIns="Y" s OrderCoverMainIns="2"
        e  s OrderCoverMainIns="1"
        d OrdItemObj.SetAt(OrderCoverMainIns,"APE896")
        /*// AKE003	VARCHAR(6)	医保三大目录类别（码表）	是	系统码表，1药品，2诊疗项目，3服务设施，4医用材料
        d OrdItemObj.SetAt("","AKE003")
        // AKE001	VARCHAR(50)	医保三大目录统一项目编码	是	医保三大目录统一项目编码
        d OrdItemObj.SetAt("1","AKE001")
        // AKE002	VARCHAR(100)	医保三大目录统一项目名称	是	医保三大目录统一项目名称
        d OrdItemObj.SetAt("药品","AKE002")
        // AKC515	VARCHAR(50)	医院项目编码	是	院内收费项目编码
        d OrdItemObj.SetAt("","AKC515")*/
        // AKE006	VARCHAR(100)	医院项目名称	是	医院内部项目名称,如果是打包项目则为包名称
        s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
        d OrdItemObj.SetAt(ARCIMDesc,"AKE006")
        // AKA063	VARCHAR(6)	项目类别代码	否	医嘱项目类别代码，比如“01”。
        s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
        s OrdCatDR=$p($g(^ARC("IC",ItemCatDR)),"^",8) // OECOrderCategory
        d OrdItemObj.SetAt($case(OrdCatDR,"1":"A","2":"B","3":"B","14":"C","13":"D","6":"F","8":"H",:"Z"),"AKA063")
        // AKA064	VARCHAR(6)	项目类别名称	否	医嘱项目类别名称。比如”西药”。
		d OrdItemObj.SetAt($case(OrdCatDR,"1":"西药","2":"中药","3":"中药","14":"化验","13":"检查","6":"手术","8":"输血",:"其他"),"AKA064")
        // AKC226	VARCHAR(10)	数量	是	数量，精度0.00
        if (PackQty="") s PackQty="1"
        d OrdItemObj.SetAt(PackQty,"AKC226")
        // AKE130	VARCHAR(20)	数量单位	是	数量单位或计价单位
        ;发药数量单位
        s packunit=""
        if (OrderPackUOMRowid'="") s packunit=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
        d OrdItemObj.SetAt(packunit,"AKE130")
        // AKC225	VARCHAR(30)	单价	是	单价，默认为0，精度0.0000
        s unitprice=..FormatPrice(unitprice)
        d OrdItemObj.SetAt(unitprice*PackQty,"AKC225")
        // AKB065	VARCHAR(22)	医疗费总额合计	是	发生金额，默认为0，精度0.0000
        d OrdItemObj.SetAt("","AKB065")
        // AKA074	VARCHAR(200)	规格	是	
        s specification=""
	    s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	    if (InciRowid'="") s specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
        d OrdItemObj.SetAt(specification,"AKA074")
        // AKA207	VARCHAR(6) 	手术标志（码表）	是	系统码表，0否，1是
        s AnaesthesiaID=$p($g(^OEORD(OrderRowid,"I",ChildSub,4)),"^",9)
        if (AnaesthesiaID'="") s AnaesthesiaID="1"
        e  s AnaesthesiaID="0"
        d OrdItemObj.SetAt(AnaesthesiaID,"AKA207")
        // AKA208	VARCHAR(6)	出院带药标志（码表）	是	系统码表，0否，1是
        s ordertype="0"
        s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
		if (PriorCode="OUT") s ordertype="1"
        d OrdItemObj.SetAt(ordertype,"AKA208")
        // AKC229	VARCHAR(5)	用药天数	是	默认为0，精度0.0
        s duration=""
	    if (DurRowid'="") s duration=$p($g(^PHCDU(DurRowid)),"^",3)
        d OrdItemObj.SetAt(duration,"AKC229")
        // AKA072	VARCHAR(20)	给药频率	是	
        d OrdItemObj.SetAt(specification,"AKA072")
        // AKA504	VARCHAR(100)	给药频率单位	是	如：天
        s drugusingfreq=""
        s:FreqRowid'="" drugusingfreq=$p(^PHCFR(FreqRowid),"^",3)
        d OrdItemObj.SetAt(drugusingfreq,"AKA504")
        // AKA181	VARCHAR(50)	给药途径	是	口服，鼻饲等
        s drugadminroutename=""
        s:InstrRowid'="" drugadminroutename=$p($g(^PHCIN(InstrRowid)),"^",2)
        d OrdItemObj.SetAt(drugadminroutename,"AKA181")
        // AKA503	VARCHAR(100)	给药方式	是	餐前，餐后等
        d OrdItemObj.SetAt("","AKA503")
        // AKA071	VARCHAR(18)	给药剂量	是	默认为0，精度0.00
        d OrdItemObj.SetAt(DoseQty,"AKA071")
        // AKE131	VARCHAR(50)	给药剂量单位	是	如：片
        s DoseUOMDesc=""
        s:DoseUOMRowid'="" DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
        d OrdItemObj.SetAt(DoseUOMDesc,"AKE131")
        // AAZ263	VARCHAR(20)	开单医生编号	是	开单医护人员编号
        s orderdocid=""
        s:UserID'="" orderdocid=$p($g(^SSU("SSUSR",UserID)),"^",1)
        d OrdItemObj.SetAt(orderdocid,"AKA074")
        // AAC003	VARCHAR(100)	开单医生名称	是	开单医护人员名称
        s orderdocname=""
        s:UserID'="" orderdocname=$p($g(^SSU("SSUSR",UserID)),"^",2)
        d OrdItemObj.SetAt(orderdocname,"AAC003")
        // AAZ307	VARCHAR(20)	开单科室编号	是	开单科室代码
        s orderdeptCode=""
        s:DeptID'="" orderdeptCode=$p($g(^CTLOC(DeptID)),"^",1)
        d OrdItemObj.SetAt(orderdeptCode,"AAZ307")
        // AAE386	VARCHAR(100)	开单科室名称	是	开单科室名称
        s orderdeptname=""
        s:DeptID'="" orderdeptname=$p($g(^CTLOC(DeptID)),"^",2)
		if (orderdeptname["-") s orderdeptname=$p(orderdeptname,"-",2)
        d OrdItemObj.SetAt(orderdeptname,"AAE386")
        //按照医嘱输出收费项
        s TariffDR=0
        for {
            s TariffDR=$o(^DHCOLT(0,"ARTTA",MyARCIMRowid,TariffDR))
            q:TariffDR=""
            s ArrayObj=##class(%ArrayOfDataTypes).%New()
            // AKE003	VARCHAR(6)	医保三大目录类别（码表）	是	系统码表，1药品，2诊疗项目，3服务设施，4医用材料
            d OrdItemObj.SetAt("","AKE003")
            // AKE001	VARCHAR(50)	医保三大目录统一项目编码	是	医保三大目录统一项目编码
            d OrdItemObj.SetAt("1","AKE001")
            // AKE002	VARCHAR(100)	医保三大目录统一项目名称	是	医保三大目录统一项目名称
            d OrdItemObj.SetAt("药品","AKE002")
            // AKC515	VARCHAR(50)	医院项目编码	是	院内收费项目编码
            d OrdItemObj.SetAt("","AKC515")
            d ArrayObj.SetAt(OrdItemObj,"HOSPITALDETAILS")
            d DataObj.Insert(ArrayObj)
        }
        /*s OLTRowId=0
        //s ^DHCOLT(0,"ARTTA",{OLT_ARCIM_DR},{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})  
        for {
            s OLTRowId=$o(s ^DHCOLT(0,"ARTTA",MyARCIMRowid,{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId}) )
        }*/
        d ArrayObj.SetAt(OrdItemObj,"HOSPITALDETAILS")
        d DataObj.Insert(ArrayObj)
        //s OrderInfoStr=OrderInfoStr_##class(DHCDoc.Util.XMLParse).ObjToXML(OrdItemObj,"HOSPITALDETAILS","").Read()
    }
    q ##class(DHCDoc.Util.FromXML).Arr2XML(DataObj).Read()
}

ClassMethod GetPatDiagnsInfo(AdmId As %String)
{
    //s PatDiagnsStr=""
    s MRAdmRowid=$p($g(^PAADM(AdmId)),"^",61)
    s DataObj=##class(%ListOfDataTypes).%New()
    i MRAdmRowid'="" {
        s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
        For {
			Quit:'obj.Next()
            s Desc=obj.Data("MRDIAICDCodeDRDesc")
            s Rowid=obj.Data("ID")
            s CodeRowId=obj.Data("MRDIAICDCodeDR")
            continue:CodeRowId=""   //lgl+诊断只填描述也能过去导致
            s ArrayObj=##class(%ArrayOfDataTypes).%New()
            s DiagList=##class(%ArrayOfDataTypes).%New()
            // AKA174	VARCHAR(6)	疾病诊断编码体系（码表）	是	系统码表，1 ICD10，2中医病证,3自制编码,9其他
            s CodeRowid=obj.Data("MRDIAICDCodeDR")
            s BillFlag1="" 
	        s BillFlag3=""
            s DiagnosCat=""
            i CodeRowid'="" {
	            s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	            s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
            }
            if (BillFlag3="Y")&&(BillFlag1'="Y"){
                d DiagList.SetAt("2","AKA174")
            }else{
                d DiagList.SetAt("1","AKA174")
            }
            // AKA015	VARCHAR(6)	诊断类型（码表）	是	系统码表，1入院诊断,2出院诊断，
            // 3诊间诊断,9其他
            s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	        if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
            /*if (MRDiagnosTypeDr'=""){
                s MRDiagnosType=$case(MRDiagnosTypeDr,"4":"1","1":"2",:"9")
                s DiagList.%Set("AKA015",$case(MRDiagnosTypeDr,"4":"1","1":"2",:"9"))
            }*/
            d DiagList.SetAt($case(MRDiagnosTypeDr,"4":"1","1":"2",:"9"),"AKA015")
            // AKA120	VARCHAR(50)	诊断编码	否	诊断编码
            s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
            d DiagList.SetAt(MRCIDCode,"AKA120")
            s CodeRowid=obj.Data("MRDIAICDCodeDR")
            // AKA121	VARCHAR(100)	诊断名称	是	诊断名称
            s Desc=obj.Data("MRDIAICDCodeDRDesc")
            d DiagList.SetAt(Desc,"AKA121")
            // AAZ263	VARCHAR(50)	诊断医护人员编号	是	诊断医护人员编号
            s AddUserDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",18)
            d:AddUserDr'="" DiagList.SetAt($p(^SSU("SSUSR",+AddUserDr),"^",1),"AAZ263")
            // AAC003	VARCHAR(100)	诊断医护人员名称	是	诊断医护人员名称
            d:AddUserDr'="" DiagList.SetAt($p(^SSU("SSUSR",+AddUserDr),"^",2),"AAC003")
            // AKA016	VARCHAR(6)	是否主诊断（码表）	是	系统码表，0否,1是
            s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
            i MainDiagFlag="Y" d DiagList.SetAt("1","AKA016")
	        e  d DiagList.SetAt("0","AKA016")
            // AKA019	VARCHAR(6)	中西医诊断标识（码表）	是	系统码表，1中医,2西医,9其他
            i BillFlag3'="Y"{
                d DiagList.SetAt("2","AAE036")
            }else{
                d DiagList.SetAt("1","AAE036")
            }
            // AAE036	VARCHAR(21)	诊断录入时间	是	诊断录入时间，格式: yyyy-MM-dd HH:mm:ss
            s MRDiagnosDate=obj.Data("MRDIADate")
	        s MRdiagnosTime=obj.Data("MRDIATime")
            s:MRDiagnosDate'="" MRDiagnosDate=##class(websys.Conversions).DateLogicalToHtml(MRDiagnosDate)
            s:MRdiagnosTime'="" MRdiagnosTime=$zt(MRdiagnosTime,1)
            d DiagList.SetAt(MRDiagnosDate_" "_MRdiagnosTime,"AAE036")
            d ArrayObj.SetAt(DiagList,"DIAGNOSE")
            d DataObj.Insert(ArrayObj)
            //s PatDiagnsStr=PatDiagnsStr_##class(DHCDoc.Util.XMLParse).ObjToXML(DiagList,"HOSPITALMAI","").Read()
        }
    }
    q ##class(DHCDoc.Util.FromXML).Arr2XML(DataObj).Read()
}

ClassMethod GetHospitalInfo(AdmId As %String)
{
    s PatientID=$p($g(^PAADM(AdmId)),"^",1)
    set HospObj=##class(%DynamicObject).%New()
    // AKB020	VARCHAR(20)	医疗机构代码	是	社保系统内部医疗机构ID
    d HospObj.%Set("AKB020","10000205")
    // AKC190	VARCHAR(100)	住院流水号（HIS唯一）	是	医院内部住院号（HIS唯一，每次住院不一样）
    d HospObj.%Set("AKC190",AdmId)
    // AKC191	VARCHAR(100)	住院流水号	否	住院流水号（HIS界面展示的流水号）
    d HospObj.%Set("AKC191",AdmId)
    // YKE099	VARCHAR(20)	就诊卡号	否	就诊卡号，默认传999999999
    s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
    s PatientMedicareNo="" //就诊卡号
    i cfRowId'="" s PatientMedicareNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
    d HospObj.%Set("YKE099",PatientMedicareNo)
    // YKE098	VARCHAR(20)	床位号	是	床位号
    s BedNo=""
    s PAADMBedDR=$p($g(^PAADM(AdmId)),"^",73)
    if (PAADMBedDR'=""){
    	s BedNo=$P($G(^PAWARD(+PAADMBedDR,"BED",$P(PAADMBedDR,"||",2))),"^",1)
    }
    d HospObj.%Set("YKE098",$p(BedNo,"."))
    // AAC001	VARCHAR(20)	医保个人编号	否	医保个人编号
    d HospObj.%Set("AAC001","")
    // AAC003	VARCHAR(100)	患者姓名	是	患者姓名
    d HospObj.%Set("AAC003",$P($G(^PAPER(PatientID,"ALL")),"^",1))
    // AAC004	VARCHAR(2)	患者性别（码表）	是	系统码表， 1男，2女 ，9未知
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    s PatientSexDr=$case(PatientSexDr,"1":"1","2":"2",:"9")
    d HospObj.%Set("AAC004",PatientSexDr)
    // AAC006	VARCHAR(8)	出生日期	是	格式YYYYMMDD
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=$ZD($G(PatientDOB),3)
    d HospObj.%Set("AAC006",PatientBirthday)
    // AAC002	VARCHAR(18)	身份证号	否	
    d HospObj.%Set("AAC002","")
    // AAE141	VARCHAR(6)	医保类型（码表）	是	业务码值：详见医保类型
    d HospObj.%Set("AAE141","")
    // AAE140	VARCHAR(6)	险种类型（码表）	是	业务码值：详见 险种类型
    d HospObj.%Set("AAE140","")
    // AKC194	VARCHAR(21)	就诊时间	是	本次就诊的时间。格式: yyyy-MM-dd HH:mm:ss
    s AdmDateStr=$zd($p($g(^PAADM(AdmId)),"^",6),3)_" "_$zt($p($g(^PAADM(AdmId)),"^",7),1)
    d HospObj.%Set("AKC194",AdmDateStr)
    // AAE030	VARCHAR(21)	入院日期	是	门诊填就诊时间。格式: yyyy-MM-dd HH:mm:ss 
    s CreateDateStr=$zd($p($g(^PAADM(AdmId)),"^",41),3)_" "_$zt($p($g(^PAADM(AdmId)),"^",42),1)
    d HospObj.%Set("AAE030",CreateDateStr)
    // AKA130	VARCHAR(6)	医疗类别（码表）	否	业务码值：详见医疗类别
    d HospObj.%Set("AKA130","")
    // AAZ532	VARCHAR(30)	入院科室编码	是
    s EpisodeLocID=$p($g(^PAADM(AdmId)),"^",4)	
    d HospObj.%Set("AAZ532",EpisodeLocID) //$p($g(^CTLOC(EpisodeLocID)),"^",1))
    // AAE376	VARCHAR(100)	入院科室名称	是
    d HospObj.%Set("AAE376",$p($g(^CTLOC(EpisodeLocID)),"^",2))	
    // AAZ263	VARCHAR(30)	医护人员编码	是	主治医护人员的编码
    s AdmDocCodeDR=$p($g(^PAADM(AdmId)),"^",9)
    d HospObj.%Set("AAZ263",AdmDocCodeDR) //$p($g(^CTPCP(AdmDocCodeDR,1)),"^",1))
    // AAZ570	VARCHAR(100)	医护人员名称	是	主治医护人员的姓名
    d HospObj.%Set("AAZ570",$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2))
    // APE151	VARCHAR(3)	住院次数	是	指本院住院次数，大于0,且小于999，默认1
    d HospObj.%Set("APE151","1")
    // AKC264	decimal(16,2)	医疗总费用	是	本次住院发生的医疗总费用
    d HospObj.%Set("AKC264","")
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(HospObj,"HOSPITALMAIN","").Read()
}

ClassMethod GetCommonInfo(TypeCode As %String, UpType As %String, LocId As %String, UserId As %String)
{
    s ComObj=##class(%DynamicObject).%New()
    /// VER	VARCHAR(20)	版本信息	是	版本为1.1 传定值2020-05
    d ComObj.%Set("VER","1.1")   ;.VER="1.1"
    /// YAB003	VARCHAR(20)	分中心编码	是	分中心编码，默认000000
    d ComObj.%Set("YAB003","140199")
    /// AGENTIP	VARCHAR(40)	客户端IP	是	客户端电脑IP地址
    d ComObj.%Set("AGENTIP","192.168.150.19")
    /// AGENTMAC	VARCHAR(40)	客户端mac	是	客户端电脑MAC地址
    d ComObj.%Set("AGENTMAC","54-BF-64-57-F3-7B")
    /// AKB020	VARCHAR(20)	医院编码	是	医疗机构编码
    d ComObj.%Set("AKB020","10000205")
    /// H_AAE141	VARCHAR(2)	医保类型	是	业务码表 详见医保类型
    d ComObj.%Set("H_AAE141","1")
    /// YQBZ	VARCHAR(100)	引擎标识	是	业务码表 详见引擎标识
    d ComObj.%Set("YQBZ","1")
    /// XXLXM	VARCHAR(6)	交易类别代码	是	交易类别代码
    /// 1001 门诊处方预审交易
    /// 2001 医师医嘱/手工计费交易
    /// 2007 获取医护人员对疑点数据的操作结果交易
    /// 2011 上传医护人员对疑点操作交易
    /// 3001 规则内涵查询交易
    /// 5001 获取已审核明细最晚发生时间交易
    /// 5004 费用明细撤销交易
    d ComObj.%Set("XXLXM",TypeCode)
    /// YWCJBM	VARCHAR(6)	业务场景编码	是	业务场景编码，系统码表
    /// 1门诊处方审核
    /// 2住院医嘱审核
    /// 3住院科室计费审核
    d ComObj.%Set("YWCJBM",UpType)
    /// H_AAE036	VARCHAR(20)	交易时间	是	格式： YYYY-MM-DD HH24:MI:SS
    s DateStr=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
    d ComObj.%Set("H_AAE036",DateStr)
    /// H_AAE011	VARCHAR(20)	操作人员编号	是	操作人员编号(HIS系统登录账号)
    d ComObj.%Set("H_AAE011",UserId) //$p($g(^SSU("SSUSR",UserId)),"^",1))
    /// H_KSBM	VARCHAR(50)	操作员科室编码	是	操作员科室编码
    d ComObj.%Set("H_KSBM",LocId) //$p($g(^CTLOC(LocId)),"^",1))
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(ComObj,"COMM","").Read()
    /// COMM	DATA	公共参数	是	公用传入参数结束的父节点
    /// INPA	DATA	传入参数起点	是	传入参数的起点结束节点
    /// RESULT	DATA	传出参数起点		传出参数的起点开始节点
    /// FLAG	VARCHAR(10)	成功或失败标志		成功：0 失败：-1
    /// MSG	VARCHAR(4000)	错误信息		函数执行失败信息，成功则为空
    /// RESULT	DATA	传出参数起点		传出参数的起点结束节点
}

/// Creator:      lvjun
/// CreatDate:    2020-12-12
/// Description:  将待审核草药数据串拼接成待审核西药数据串
/// Input:        EpisodeID:就诊表RowId  CMOEOrdStr:待审核草药数据串
/// Return:       待审核西药数据串
/// Others:       w ##class(web.DHCDocHLYYHZYY).ConvertCMOEOrdToOEOrd("4415774",$p(^lj("ConvertCMOEOrdToOEOrd"),",",2))
ClassMethod ConvertCMOEOrdToOEOrd(EpisodeID As %String, CMOEOrdStr As %String) As %String
{
	s ^lj("ConvertCMOEOrdToOEOrd")=EpisodeID_","_CMOEOrdStr
	s PrescStr=$p(CMOEOrdStr,$C(2),1)
	s CMItemStr=$p(CMOEOrdStr,$c(2),2)
	s PrescPriorRowid=$p(PrescStr,"^",1)
	s PrescDurRowid=$p(PrescStr,"^",2)
	s PrescInstrRowid=$p(PrescStr,"^",3)
	s PrescFreqRowid=$p(PrescStr,"^",4)
	s PrescCookMode=$p(PrescStr,"^",5)
	s PrescOrderQty=$p(PrescStr,"^",6)
	s PrescRecDepRowid=$p(PrescStr,"^",7)
	s PrescAdmReason=$p(PrescStr,"^",8)
	s PrescNotes=$p(PrescStr,"^",9)
	s PrescEmergency=$p(PrescStr,"^",10)
	s PrescStartDate=$p(PrescStr,"^",11)
	if (PrescStartDate="") s PrescStartDate=+$h
    else  s PrescStartDate=##class(websys.Conversions).DateHtmlToLogical(PrescStartDate)
    s PrescStartDate=$zd(PrescStartDate,3)
    s PrescStartTime=$p(PrescStr,"^",12)
    if (PrescStartTime="") s PrescStartTime=$p($h,",",2)
    else  s PrescStartTime=##class(websys.Conversions).TimeHtmlToLogical(PrescStartTime)
    s PrescStartTime=$zt(PrescStartTime,1)
    ;
    s OEOrdStr=""
	for ItemSeq=1:1:$l(CMItemStr,$c(1)) {
		s CMItemOne=$p(CMItemStr,$c(1),ItemSeq)
		continue:CMItemOne=""
		s ARCIMRowid=$p(CMItemOne,"^",1)
		continue:ARCIMRowid=""
		s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
		continue:OrderType'="R"
		s DoseQty=$p(CMItemOne,"^",2)
		s DurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
		s PackQty=DoseQty*DurFactor
		s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$h,"","","","","","")
		s UnitPrice=$p(OrderPrice,"^",4)
		s DoseUOMRowid=$p(CMItemOne,"^",3)
		if (DoseUOMRowid="") s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
		if (DoseUOMRowid="") {
			s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
			if (Phcdf'="") s DoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
		s PhSpecInstr=$p(CMItemOne,"^",4)
		s OrderSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime_"^"_ItemSeq
		s OrderMasterSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PrescPriorRowid_"^"_PrescStartDate_"^"_PrescStartTime_"^"_PackQty	;1-6
		s OEOrdOne=OEOrdOne_"^"_UnitPrice_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""_"^"_PrescFreqRowid	;7-14
		s OEOrdOne=OEOrdOne_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_""_"^"_OrderMasterSeqNo_"^"_OrderSeqNo	;15-20
		s $p(OEOrdOne,"^",22)=PhSpecInstr
		s $p(OEOrdOne,"^",30)=PrescEmergency
		s $p(OEOrdOne,"^",46)=PrescStartDate
		s $p(OEOrdOne,"^",47)=PrescStartTime
		s $p(OEOrdOne,"^",55)=DoseUOMRowid
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

}
