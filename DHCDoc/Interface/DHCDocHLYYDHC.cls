/// 合理用药的后台数据获取类
Class DHCDoc.Interface.DHCDocHLYYDHC Extends web.DHCDocHLYY
{
/// w ##class(web.DHCHLYY).GetPrescInfo(8697,"265||1!0.5!109!4!63!8!265||1!5!1!1!","测试医生")
///  8697,265||1!0.5!109!4!63!8!265||1!5!1!1!,测试医生
///  ,26||1!0.2!109!5!63!2!26||1!3!3^1490||1!10!139!40!63!2!1490||1!3!4,唐骅		
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
    s PatInfo=PatInfo_"^"_PatLoc_"^"_DocDesc_"^"_Hospital_"^"_Profess_"^"_Groupe
    s PatInfo=PatInfo_"^"_LgCtLoc_"^"_LgUser
    q PatInfo
}
/// 获取插入的医嘱信息  
/// 入参为就诊id 
ClassMethod GetInsertItemOrder(EpisodeID As %String,OrderStr As %String) 
{
    s OrderInfo=""
	s InsertOrderStr=""
	s ItmCount=$l($g(OrderStr),"^")
    k MasterSeqNo
 	for i=1:1:ItmCount {
	    s OrderStr1=$P(OrderStr,"^",i)
	    s SeqNo=$P(OrderStr1,"!",10)	//医嘱序号	必需
        s ItmID=$P(OrderStr1,"!",1)
	    s ItmCode=$P(^ARCIM(+ItmID,$P(ItmID,"||",2),1),"^",1)
	    s ItmDesc=$P(^ARCIM(+ItmID,$P(ItmID,"||",2),1),"^",2)
	    s PhDesc=ItmDesc	//	药品名称	必需
        s DoseQty=$P(OrderStr1,"!",2)
	    s DoseQtyUOM=$P(OrderStr1,"!",3)
	    s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)
	    s FormProp=""	//	剂型	必需
	    s OnceDose=DoseQty	//	单次剂量	必需
	    s Unit	=DoseQtyUOMDesc	//单次剂量单位	必需
        s Instr=$P(OrderStr1,"!",6)
	    i Instr'="" {
		    s InstrCode=$P($G(^PHCIN(Instr)),"^",1)
		    s InstrDesc=$P($G(^PHCIN(Instr)),"^",2)
		    s:InstrCode["-" InstrCode=$p(InstrCode,"-",2)
		    s:InstrDesc["-" InstrDesc=$p(InstrDesc,"-",2)
	    }else{
		    s InstrCode=""
		    s InstrDesc=""
	    }
	    s DrugPreMet=InstrDesc	//	用法	必需
        s DrugFreq=1	//	频次	必需
        s Freq=$P(OrderStr1,"!",4)
	    if Freq'="" {
		    s DrugFreq=$P($G(^PHCFR(Freq)),"^",3)
		}
	   s Durationdr=$P(OrderStr1,"!",5)
		i Durationdr'="" s Duration=$p($g(^PHCDU(Durationdr)),"^",2)
		e  s Duration=1
	    s Treatment=Duration	//	疗程	必需
	    s id=ItmCode	//	标识	必需
	    s LinkSeqNo=$P(OrderStr1,"!",11)	//	关联序号(1, 1.1, 1.2)	必需
        if (LinkSeqNo'=""){
            s MasterSeqNo(LinkSeqNo)=+$g(MasterSeqNo(LinkSeqNo))+1
            s LinkSeqNo=LinkSeqNo_"."_$g(MasterSeqNo(LinkSeqNo))
        }else{
            s LinkSeqNo=""
        }
	    s OrdDate=$zd(+$h,3)	//	医嘱日期	必需
	    s IsFirstUseProp=""	//	是否首次(首次/非首次)	必需
	    s DurgSpeedProp=""	//	给药速度	必需
	    s DrugSpeedPropUnit=""	//	给药速度单位	必需
	    s OrdEndDate=""	//	医嘱停止日期	必需(2020/12/17增加)
        s InsertOrder=SeqNo_"^"_PhDesc_"^"_FormProp_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq
		s InsertOrder=InsertOrder_"^"_Treatment_"^"_id_"^"_LinkSeqNo_"^"_OrdDate_"^"_IsFirstUseProp
		s InsertOrder=InsertOrder_"^"_DurgSpeedProp_"^"_DrugSpeedPropUnit_"^"_OrdEndDate
        i InsertOrderStr="" s InsertOrderStr=InsertOrder
		e  s InsertOrderStr=InsertOrderStr_$C(1)_InsertOrder
    }
    s HisOrderStr=""
    s OrderRowid=""
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,0))
    k LinOrdItemL
	s ChildSub=0
	for  {
        s ChildSub=$o(^OEORDi(0,"StDt",+$h,OrderRowid,ChildSub))
        q:ChildSub=""
        continue:'$d(^OEORD(OrderRowid,"I",ChildSub))
        
        s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)
        s OrderARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)		;OEORI_ItmMast_DR
	    s ARCIMSubScript=$p(OrderARCIMRowid,"||",1)
	    s ARCIMSubVersion=$p(OrderARCIMRowid,"||",2)
        s OrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
	    continue:OrderType'="R"
        s SeqNo=ChildSub
	    s PhDesc=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)
        s FormProp=""
        s OnceDose=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
        s OrderDoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;OEORI_Unit_DR
	    continue:OrderDoseUOMRowid=""  
        
        s Unit=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2)
        s OrderInstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)
        s DrugPreMet=$P($G(^PHCIN(OrderInstrRowid)),"^",2)
        s OrderFreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)
        s DrugFreq=$P($G(^PHCFR(OrderFreqRowid)),"^",3)
        s OrderDurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
        s Treatment=$p($g(^PHCDU(OrderDurRowid)),"^",2)
        s id=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",1) 
        s LinkOrdItem=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
        s LinkSeqNo=""
        if (LinkOrdItem'=""){
            s LinOrdItemL($p(LinkOrdItem,"||",2))=+$g(LinOrdItemL($p(LinkOrdItem,"||",2)))+1
            s LinkSeqNo=$p(LinkOrdItem,"||",2)_"."_$g(LinOrdItemL($p(LinkOrdItem,"||",2)))
        }
        s OrdDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
        s:OrdDate'="" OrdDate=$zd(OrdDate,3)
        s IsFirstUseProp=""
        s DurgSpeedProp=""	//	给药速度	必需
	    s DrugSpeedPropUnit=""	//	给药速度单位	必需
        s OrdEndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
        s:OrdEndDate'="" OrdEndDate=$zd(OrdEndDate,3)
        s HisOrder=SeqNo_"^"_PhDesc_"^"_FormProp_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq
		s HisOrder=HisOrder_"^"_Treatment_"^"_id_"^"_LinkSeqNo_"^"_OrdDate_"^"_IsFirstUseProp
		s HisOrder=HisOrder_"^"_DurgSpeedProp_"^"_DrugSpeedPropUnit_"^"_OrdEndDate
        i HisOrderStr="" s HisOrderStr=HisOrder
		e  s HisOrderStr=HisOrderStr_$C(1)_HisOrder
    }
    s OrderInfo=InsertOrderStr_$C(2)_HisOrderStr
    q OrderInfo  //InsertOrderStr_$C(2)_HisOrderStr
}
///获取诊断信息  
ClassMethod GetMRDiagnos(AdmId As %String)
{
   s MedCondInfo=""
   s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmRowid'="" {
		s i=0
		s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For  Quit:'obj.Next()  {
            s Desc=obj.Data("MRDIAICDCodeDRDesc")
            s Rowid=obj.Data("ID")
            s CodeRowId=obj.Data("MRDIAICDCodeDR")
            continue:CodeRowId=""   ;lgl+诊断只填描述也能过去导致
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
}