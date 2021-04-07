Class web.DHCDocHLYYDHC Extends %RegisteredObject
{

/// Creator:      renyx
/// CreatDate:    2021-3-30
/// Description:  审核医嘱后,调用新产品组保存接口
/// Input:        EpisodeID:就诊表RowId  OrderStr:审核返回医嘱串  ExpStr:扩展串,用户id^msgID:(唯一标识)
/// Return:       新产品组返回信息
ClassMethod SaveHLYYInfo(EpisodeID As %String, OrderStr As %String, ExpStr As %String)
{
	s UserId = $p(ExpStr,"^",1)
	s MsgId = $p(ExpStr,"^",2)
	s Date=$zd(+$h,3)
	s Time=$zt($p($h,"2"),1)
	q ##Class(web.DHCCKBService).FeedBack(MsgId, UserId, date, time, ordItemStr, userType)
}

/// Creator:      renyx
/// CreatDate:    2021-3-30
/// Description: 获取患者的基本信息
/// Input:        EpisodeID:就诊表RowId  
/// Return:       患者信息串	
ClassMethod GetPrescInfo(EpisodeID As %String)
{
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    else  s PatientSex=""
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=$ZD($G(PatientDOB),3)
    
    //&SQL(Select PAPMI_No into :PatientNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
    s Height="" ;身高
    s Weight="" ;体重
    s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)    
    s PAAdmReason=""  // 费别 (医保,自费) 
    If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	s BloodPress=""    // 血压  
    s SpecGrps=""    //特殊人群 
    s ProfessProp=""  // 职业
     s OccupationDR=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
    s:OccupationDR'="" ProfessProp=$p($g(^CT("OCC",OccupationDR)),"^",2)
    s PatType=""  // 患者类别(门诊,住院,急诊) 
    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
    s PatType=$CASE(PAAdmType,"E":"急诊","O":"门诊","I":"住院")
    s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
    s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
    s PatLoc=EpisodeLocCode  // 就诊科室
    s AdmDocCodeDR=$p($g(^PAADM(EpisodeID)),"^",9)
    s DocDesc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
    s MainDoc=DocDesc  // 主管医生
    s Hospital="" // 医院(登录信息)
    s Profess="" // 职称(登录用户)
    s Group="" //  安全组  
    s LgCtLoc="" // 登录科室 2020/12/1
    s LgUser="" // 登录用户  2020/12/1
    s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
    if (MRAdmRowid'="") {
        s Height=$p($g(^MR(MRAdmRowid,"PRO",1)),"^",20)
        s Weight=$p($g(^MR(MRAdmRowid,"PRO",1)),"^",27)
        s SpecGrps=$p($g(^MR(MRAdmRowid,"DHC")),"^",8)
        s BloodPress=$p($g(^MR(MRAdmRowid,"PRO",1)),"^",4)_"~"_$p($g(^MR(MRAdmRowid,"PRO",1)),"^",5)
    }
    s PatInfo=PatientID_"^"_PatientName_"^"_PatientSex_"^"_PatientBirthday_"^"_Height_"^"_Weight
    s PatInfo=PatInfo_"^"_PAAdmReason_"^"_BloodPress_"^"_SpecGrps_"^"_ProfessProp_"^"_PatType
    s PatInfo=PatInfo_"^"_PatLoc_"^"_DocDesc_"^"_Hospital_"^"_Profess_"^"_Group
    s PatInfo=PatInfo_"^"_LgCtLoc_"^"_LgUser
    q PatInfo
}

/// 获取插入的医嘱信息  
/// 入参为就诊id ,医嘱串，类型
ClassMethod GetInsertItemOrder(EpisodeID As %String, OrderStr As %String, HLYYLayOut As %String = "")
{
    s OrderInfo=""
	if (HLYYLayOut="CMOEOrd") {
		s OrderStr=..ConvertCMOEOrdToOEOrd(EpisodeID,OrderStr)
	}
	s InsertOrderStr=..GetOrdersInfo(EpisodeID,OrderStr)
	
    s HisOrderStr=..GetVerifiedOrdersInfo(EpisodeID)
    if (InsertOrderStr'="") s OrderInfo=InsertOrderStr
    if (HisOrderStr'="") s OrderInfo=OrderInfo_$C(2)_HisOrderStr
    q OrderInfo
}

/// 获取待插入的医嘱信息
ClassMethod GetOrdersInfo(EpisodeID As %String, OrderItemStr As %String)
{
	s OrdersInfo=""
	k MasterSeqNo
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s OrderType=$p(OrderItemOne,"^",2)
		continue:OrderType'="R"
        s SeqNo=$p(OrderItemOne,"^",20)
        ;药品ID
		s ARCIMRowId=$p(OrderItemOne,"^",1)
		continue:ARCIMRowId=""
		;药品名称
		s PhDesc=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",2)
		;剂型
		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowId)
        s FormProp=""
        s:InciRowid'="" FormProp=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
        ;每次给药剂量
		s OnceDose=$p(OrderItemOne,"^",12)
		s DoseUOMRowid=$p(OrderItemOne,"^",13)
		s Unit=""
		s:DoseUOMRowid'="" Unit=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
        ;给药途径
		s DrugPreMet=""
		s InstrRowid=$p(OrderItemOne,"^",17)
		if (InstrRowid'="") s DrugPreMet=$p($g(^PHCIN(InstrRowid)),"^",2)
        ;给药频率
		s DrugFreq=""
		s FreqRowid=$p(OrderItemOne,"^",15)
		if (FreqRowid'="") s DrugFreq=$p(^PHCFR(FreqRowid),"^",3)
		;疗程
		s Treatment=""
		s DurRowid=$p(OrderItemOne,"^",16)
		if (DurRowid'="") s Treatment=$p($g(^PHCDU(DurRowid)),"^",3)
		s id=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",1)
		;关联序号
		s LinkSeqNo=""
		s OrderMasterSeqNo=$p(OrderItemOne,"^",19)
		if (OrderMasterSeqNo'=""){
            s MasterSeqNo(OrderMasterSeqNo)=+$g(MasterSeqNo(OrderMasterSeqNo))+1
            s LinkSeqNo=OrderMasterSeqNo_"."_$g(MasterSeqNo(OrderMasterSeqNo))
        }
		;医嘱时间
		s OrdDate=$p(OrderItemOne,"^",46)
		s IsFirstUseProp=""
		;给药速度
		s DurgSpeedProp=$p(OrderItemOne,"^",36)
        ;给药速度单位
        s DrugSpeedPropUnit=""
		s FlowRateUnitDR=$p(OrderItemOne,"^",45)
		if (FlowRateUnitDR'="") s DrugSpeedPropUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
		s OrdEndDate=$p(OrderItemOne,"^",26)
		s InsertOrder=SeqNo_"^"_PhDesc_"^"_FormProp_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq
		s InsertOrder=InsertOrder_"^"_Treatment_"^"_id_"^"_LinkSeqNo_"^"_OrdDate_"^"_IsFirstUseProp
		s InsertOrder=InsertOrder_"^"_DurgSpeedProp_"^"_DrugSpeedPropUnit_"^"_OrdEndDate
        i OrdersInfo="" s OrdersInfo=InsertOrder
		e  s OrdersInfo=OrdersInfo_$C(1)_InsertOrder
	}
	
	Q OrdersInfo
}

/// 获取已经审核的医嘱信息
ClassMethod GetVerifiedOrdersInfo(EpisodeID As %String)
{
	
	s DrugItemNum=0
	s VerifiedOrdersInfo=""
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,0))
    k LinOrdItemL
	s ChildSub=0
	for  {
        s ChildSub=$o(^OEORDi(0,"StDt",+$h,OrderRowid,ChildSub))
        q:ChildSub=""
        continue:'$d(^OEORD(OrderRowid,"I",ChildSub))
		s MyARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
		continue:MyARCIMRowid=""
		s DrugFlag=..CheckIsDrugItem(MyARCIMRowid)
		continue:DrugFlag'="Y"
		continue:MyARCIMRowid=""
		s SeqNo=ChildSub
		;药品名称
		s id=$p($g(^ARCIM(+MyARCIMRowid,$p(MyARCIMRowid,"||",2),1)),"^",1)
		s PhDesc=$p($g(^ARCIM(+MyARCIMRowid,$p(MyARCIMRowid,"||",2),1)),"^",2)
		;剂型
		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+MyARCIMRowid)
        s FormProp=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
        ;每次给药剂量
		s OnceDose=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
		s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)
		s Unit=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
        ;给药途径
		s DrugPreMet=""
		s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)
		if (InstrRowid'="") s DrugPreMet=$p($g(^PHCIN(InstrRowid)),"^",2)
		;给药频率
		s DrugFreq=""
		s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)
		if (FreqRowid'="") s DrugFreq=$p(^PHCFR(FreqRowid),"^",3)
		;疗程
		s Treatment=""
		s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
		if (DurRowid'="") s Treatment=$p($g(^PHCDU(DurRowid)),"^",3)
		;关联序号
		s LinkOrdItem=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
        s LinkSeqNo=""
        if (LinkOrdItem'=""){
			s LinkOrdItemNo=$p(LinkOrdItem,"||",2)
            s LinOrdItemL(LinkOrdItemNo)=+$g(LinOrdItemL(LinkOrdItemNo))+1
            s LinkSeqNo=LinkOrdItemNo_"."_$g(LinOrdItemL(LinkOrdItemNo))
        }
		//医嘱时间
		s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
		if (OrderDate="") s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s OrdDate=$zd(OrderDate,3)
		s IsFirstUseProp=""
		;给药速度
		s DurgSpeedProp=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",17)
		
        ;给药速度单位
        s DrugSpeedPropUnit=""
		s FlowRateUnitDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,6)),"^",8)
		if (FlowRateUnitDR'="") s DrugSpeedPropUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
		s OrdEndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
        s:OrdEndDate'="" OrdEndDate=$zd(OrdEndDate,3)
		s HisOrder=SeqNo_"^"_PhDesc_"^"_FormProp_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq
		s HisOrder=HisOrder_"^"_Treatment_"^"_id_"^"_LinkSeqNo_"^"_OrdDate_"^"_IsFirstUseProp
		s HisOrder=HisOrder_"^"_DurgSpeedProp_"^"_DrugSpeedPropUnit_"^"_OrdEndDate
        i VerifiedOrdersInfo="" s VerifiedOrdersInfo=HisOrder
		e  s VerifiedOrdersInfo=VerifiedOrdersInfo_$C(1)_HisOrder
	}
	Q VerifiedOrdersInfo
}

/// 获取诊断信息  
ClassMethod GetMRDiagnos(AdmId As %String)
{
   s MedCondInfo=""
   s MRAdmRowid=$p($g(^PAADM(AdmId)),"^",61)
	i MRAdmRowid'="" {
		s i=0
		s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For {
			Quit:'obj.Next()
            s Desc=obj.Data("MRDIAICDCodeDRDesc")
            s Rowid=obj.Data("ID")
            s CodeRowId=obj.Data("MRDIAICDCodeDR")
            continue:CodeRowId=""   //lgl+诊断只填描述也能过去导致
            i CodeRowId'="" {
                s Code=$P(^MRC("ID",CodeRowId),"^",4)
                s Code=$tr(Code,$c(0),"")
                
                s MedCond=Code_"^"_Desc
                i MedCondInfo="" s MedCondInfo=MedCond
                e  s MedCondInfo=MedCondInfo_$C(1)_MedCond
            }
        }

    }
    q MedCondInfo
}

/// 获取过敏信息  
ClassMethod GetAllergiesInfo(EpisodeID As %String)
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s AllergiesInfo=""
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s ChildSub=0 for {
		s ChildSub=$o(^PAPER(PatientID,"ALG",ChildSub))
		Q:ChildSub=""
		;过敏信息id
		s allergyid=PatientID_"||"_ChildSub
		;过敏物名称
		s DrgMastDr=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",27)
		continue:DrgMastDr=""
        s AllergyDode=$p($g(^PHCGE("GE",DrgMastDr)),"^",2)
		s AllergydDug=$p($g(^PHCGE("GE",DrgMastDr)),"^",2)
		;过敏信息状态
		s allergystatus="0"
		;记录时间
		s ALGDate=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",10)
		s ALGTime=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",15)
		s recordtime=$zd(ALGDate,3)_" "_$zt(ALGTime,1)
        s Allergies=AllergyDode_"^"_AllergyDode
		i AllergiesInfo="" s AllergiesInfo=Allergies
        e  s AllergiesInfo=AllergiesInfo_$C(1)_Allergies
	}
    q AllergiesInfo
}

/// 获取手术信息 
ClassMethod GetOperationsInfo(EpisodeID As %String)
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s OperationsInfo=""
	s opaRowid=0 
    for {
		s opaRowid=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaRowid))
		Q:opaRowid=""
		s opaStatus=$p($g(^DHCANOPArrange(opaRowid)),"^",27)
		continue:(opaStatus="D")||(opaStatus="C")
		s anaRowid=$p($g(^DHCANOPArrange(opaRowid)),"^",2)	;手术麻醉Id
		continue:anaRowid=""
		s anaopSub=0 for {
			s anaopSub=$o(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub))
			Q:anaopSub=""
			s curOperId=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub)),"^",6)	;手术表id
			continue:curOperId=""
			;手术id
			s Operationid=anaRowid_"||"_anaopSub
			;手术编码
			s Operationcode=$p($g(^ORC("OPER",curOperId)),"^",14)
			;手术名称
			s Operationname=$p($g(^ORC("OPER",curOperId)),"^",2)
            s Operation=Operationcode_"^"_Operationname
			i OperationsInfo="" s OperationsInfo=Operation
            e  s OperationsInfo=OperationsInfo_$C(1)_Operation
		}
	}
	Q OperationsInfo
}

/// Creator:      lvjun
/// CreatDate:    2020-12-20
/// Description:  判断是否是药品医嘱
/// Input:        ARCIMRowid:医嘱项id
/// Return:       Y:是  N:不是
/// Others:		  w ##class(web.DHCDocHLYYHZYY).CheckIsDrugItem("1||1")
ClassMethod CheckIsDrugItem(ARCIMRowid As %String) As %String
{
	s ^lj("CheckIsDrugItem")=ARCIMRowid
	s DrugFlag="N"
	Q:ARCIMRowid="" DrugFlag
	s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	Q:ItemCatDr="" DrugFlag
	s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
	if (OrderType="R") s DrugFlag="Y"
	Q DrugFlag
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
