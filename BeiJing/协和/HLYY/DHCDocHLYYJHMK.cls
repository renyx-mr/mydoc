Class web.DHCDocHLYYJHMK Extends %RegisteredObject
{

ClassMethod GetPrescInfo(EpisodeID As %String, UserId As %String, LocId As %String)
{
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    ;登记号
    s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",2)
    ;患者姓名
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    ;就诊次
    s Visit="1"
    ;科室编码
    s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
    ;科室描述
    s UserDesc=$p($g(^SSU("SSUSR",UserId)),"^",2)
    s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
    s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
    s CTPCPRowid=$P(^SSU("SSUSR",UserId),"^",14)
    // 用户职称
    s CTPCPCarPrvTpDesc=""
    if (CTPCPRowid'=""){
        s CTPCPCarPrvTpDR = $p(^CTPCP(CTPCPRowid,1),"^",4)
        if (CTPCPCarPrvTpDR'="") s CTPCPCarPrvTpDesc=$p($g(^CTPCP(ctpcprowid,1)),"^",2)
    }
    q PatNo_"^"_PatientName_"^"_Visit_"$"_UserCode_"^"_UserDesc_"^"_LocDesc_"^"_CTPCPCarPrvTpDesc
}

ClassMethod GetPatAdmInfo(EpisodeID As %String)
{
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    ;患者姓名
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    ;性别
    s PatientSex=""
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    s:PatientSexDr'="" PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    ;出生日期
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=$ZD($G(PatientDOB),3)
    ;就诊时间
    s AdmDateStr=""
    s AdmLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    ;就诊科室编码
    s AdmLocCode=$p($g(^CTLOC(AdmLocID)),"^",1)
    ;就诊科室描述
    s AdmLocDesc=$p($g(^CTLOC(AdmLocID)),"^",2)
    s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    s AdmDocCodeDR=$p($g(^PAADM(EpisodeID)),"^",9)
    ;就诊医生编码
    s DocCode=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",1)
    ;就诊医生描述
    s DocDesc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
    q EpisodeID_"^"_PatientName_"^"_PatientSex_"^"_PatientBirthday_"^"_AdmDateStr
        _"^"_AdmLocCode_"^"_AdmLocDesc_"^"_DocCode_"^"_DocDesc
}

ClassMethod GetOrdersInfo(OrderItemStr As %String)
{
	s VerifiedOrdersInfo=""
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s OrderType=$p(OrderItemOne,"^",2)
        ;药品ID
		s ARCIMRowId=$p(OrderItemOne,"^",1)
		continue:ARCIMRowId=""
        ;药品编码
        s ArcItemCode=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",1)
        ;药品名称
		s ArcItemDesc=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",2)
        ;药品类型编码
        Set ItemCatDR=$p(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1),"^",10)
        s ArcItemTypeCode=$P($g(^ARC("IC",ItemCatDR)),"^",1)
        ;药品类型描述
        s ArcItemTypeDesc=$P($g(^ARC("IC",ItemCatDR)),"^",2)
        ;医嘱号
        s OrderNo=""
        ;规格
        s Specification=""
	    s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowId)
	    if (InciRowid'="") s Specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
        ;医嘱开始时间
        s OrderStartDateStr=$p(OrderItemOne,"^",4)_" "_$p(OrderItemOne,"^",5)
        ;医嘱结束时间
        s OrderEndDateStr=$p(OrderItemOne,"^",26)_" "_$p(OrderItemOne,"^",27)
        ;持续时间
        s DurRowid=$p(OrderItemOne,"^",16)
        s Duration=""
        ;持续时间单位
        //s DurRowid=$p(OrderItemOne,"^",16)
        s DurationUnit=""
	    if (DurRowid'=""){
            s DurationInfo=$p($g(^PHCDU(DurRowid)),"^",3)
            s Duration=+DurationInfo
            s DurationUnit=$p(DurationInfo,Duration,"2")
        }
        ;开立医嘱类型
        s PriorRowid=$p(OrderItemOne,"^",3)
        s OrderType="临时医嘱"
        s:PriorRowid'="" OrderType=$p($g(^OECPR(PriorRowid)),"^",2)
        ;药品剂型
        s Preparation=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
        ;用药剂量
        s DoseQty=$p(OrderItemOne,"^",12)
        ;剂量单位
        s DoseUOMRowid=$p(OrderItemOne,"^",13)
        s DoseUOMDesc=""
        s:DoseUOMRowid'="" DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
        ;总剂量
        s PackQty=$p(OrderItemOne,"^",6)	;发药数量
        if (PackQty="") s PackQty="1"
        ;总剂量单位
        s OrderPackUOMRowid=$p(OrderItemOne,"^",55)	;发药数量单位
        s PackUnit=""
	    if (OrderPackUOMRowid'="") s PackUnit=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
        ;执行频次名称
        s DrugFreqDesc=""
		s FreqRowid=$p(OrderItemOne,"^",15)
		if (FreqRowid'="") s DrugFreqDesc=$p(^PHCFR(FreqRowid),"^",3)
        ;执行频次编码
        s DrugFreq=""
		if (FreqRowid'="") s DrugFreq=$p(^PHCFR(FreqRowid),"^",1)
        ;医嘱状态
        s OrderStatus="审核"
        ;医嘱下达时间
        s OrderDateStr=$p(OrdItem,"^",46)_" "_$p(OrdItem,"^",47)
        ;给药途径和方法
        s DrugPreMet=""
		s InstrRowid=$p(OrderItemOne,"^",17)
		if (InstrRowid'="") s DrugPreMet=$p($g(^PHCIN(InstrRowid)),"^",2)
        s OrdersInfo=ArcItemCode_"^"_ArcItemDesc_"^"_ArcItemTypeCode_"^"_ArcItemTypeDesc_"^"_OrderNo
        s OrdersInfo=OrdersInfo_"^"_Specification_"^"_OrderStartDateStr_"^"_OrderEndDateStr_"^"_Duration_"^"_DurationUnit
        s OrdersInfo=OrdersInfo_"^"_OrderType_"^"_Preparation_"^"_DoseQty_"^"_DoseUOMDesc_"^"_PackQty
        s OrdersInfo=OrdersInfo_"^"_PackUnit_"^"_DrugFreqDesc_"^"_DrugFreq_"^"_OrderStatus_"^"_OrderDateStr
        s OrdersInfo=OrdersInfo_"^"_DrugPreMet
        i VerifiedOrdersInfo="" s VerifiedOrdersInfo=OrdersInfo
		e  s VerifiedOrdersInfo=VerifiedOrdersInfo_$C(1)_OrdersInfo
    }
    q VerifiedOrdersInfo
}

ClassMethod GetDiagnosInfo(DiagItemStr)
{
	s DiagnosInfo=""
	for i=1:1:$l(DiagItemStr,$c(1)) {
		s OneAddDiagItem=$p(DiagItemStr,$c(1),i)
		continue:OneAddDiagItem=""
		;诊断备注
		s MRDIADesc=$p(OneAddDiagItem,"^",2)
		s ICDCodeRowid=$p(OneAddDiagItem,"^",3)
		;诊断编码 和 诊断描述
		s ICDCode="",ICDDesc="",DiagFlagDesc=""
		if (ICDCodeRowid'=""){
			s MRCIDCode=$p($g(^MRC("ID",ICDCodeRowid)),"^",4)
			s MRCIDDesc=$p($g(^MRC("ID",ICDCodeRowid)),"^",2)
			//s BillFlag1=$P($G(^MRC("ID",ICDCodeRowid)),"^",13)
			
			s BillFlag3=$P($g(^MRC("ID",ICDCodeRowid)),"^",15)
			i BillFlag3'="Y"  s DiagFlagDesc="西医诊断"
			else  s DiagFlagDesc="中医诊断"
		}
		s num=i
		s Date=$p(OneAddDiagItem,"^",7)
		if (MRDIADesc'=""){
			s DescType=$P(MRDIADesc,"#",2)
			s MRDIADesc=$P(MRDIADesc,"#",1)
			s DiagFlagDesc=$case(DescType,"1":"西医诊断",:"中医诊断")
			s ICDDesc=MRDIADesc
		}
		s DiagSub="",DiagType=""
		s DiagnosStr=MRDIADesc_"^"_ICDCode_"^"_ICDDesc_"^"_num_"^"_Date
		s DiagnosStr=DiagnosStr_"^"_DiagFlagDesc_"^"_DiagSub_"^"_DiagType
		i DiagnosInfo="" s VerifiedOrdersInfo=OrdersInfo
		e  s DiagnosInfo=DiagnosInfo_$C(1)_OrdersInfo
	}
	q DiagnosInfo
}

}
