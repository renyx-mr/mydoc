Class DHCDoc.Renyx.DHCOPAdmReg Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

/// 插入核算检测医嘱
/// w ##class(web.DHCOPAdmReg).AutoInsrtDiaAndOrd(20754356)
/// 1://设置是否自动插入诊断和医嘱 按照患者所挂号别进行设置  RBASDr 为RB_Resource表的ID
/// s ^DHCDocAutoInsrtDiaAndOrd(RBASDr)="Y"
/// 2: 设置对应号别再插入项目的时候所需内容,如果不配置按照默认走 配置按照配置走:
/// 医嘱诊断录入科室^录入人^录入项目^项目接收科室^诊断
/// s ^DHCDocAutoInsrtDiaAndOrd(RBASDr,"needmes")="defloc^defUser^ArcimID^reloc^icdDr"
/// 
ClassMethod AutoInsrtDiaAndOrd(EpisodeID) As %String
{
	
	s AdmLoc=$P($G(^PAADM(EpisodeID)),"^",4)
	s HospitalDesc="北京积水潭医院"
	s HospitalDesc=$p($g(^CTLOC(AdmLoc)),"^",22)
	s:HospitalDesc'="" HospitalDesc=$P(^CT("HOSP",HospitalDesc),"^",2) //北京积水潭医院(回龙观)
	s rbres=""
	
	&SQL(SELECT RegfeeRBASDr into :rbres FROM SQLUser.DHCRegistrationFee WHERE RegfeeAdmDr=:EpisodeID)
	
	Q:SQLCODE'=0 "-1"
	Q:+rbres=0 "0"
	Q:$G(^DHCDocAutoInsrtDiaAndOrd(+rbres))="" "0"
	
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	
	//设置默认值----------
	s defloc="594" //医嘱录入科室
	s defUser="9568" //医嘱录入人
	s ArcimID="12003||1" //录入的医嘱项目
	s reloc="655" //医嘱项目接收科室
	s icdDr="46561" //ICD诊断
	s defadereason=""
	
	//按照对应的配置走
	if ($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes"))'=""){
		s ndefloc=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",1)
		s ndefUser=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",2)
		s nArcimID=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",3)
		s nreloc=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",4)
		s nicdDr=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",5)
		s defadereason=$P($G(^DHCDocAutoInsrtDiaAndOrd(+rbres,"needmes")),"^",6)
		
		s:ndefloc'="" defloc=ndefloc
		s:ndefUser'="" defUser=ndefUser
		s:nArcimID'="" ArcimID=nArcimID
		s:nreloc'="" reloc=nreloc
		s:nicdDr'="" icdDr=nicdDr
	}
	s specimen="" 
	s specstr=##class(web.DHCDocOrderCommon).GetLabSpec(ArcimID)
	if specstr'=""  d
	.f spec1=1:1:$L(specstr,$C(2))  d
	..s onespec=$P(specstr,$c(2),spec1)
	..s def=$P(onespec,$c(3),5)
	..if def="Y"  d
	...s specimen=$P(onespec,$c(3),1)
	
	s DocID=$P(^SSU("SSUSR",defUser),"^",14)
	
	;费别按照患者就诊费别走
	s BillTypeRowid=$p($G(^PAADM(EpisodeID,1)),"^",7) 
	;查询费别处方对照
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O",BillTypeRowid)
	s firstbill="" s defbill=""
	for i=1:1:$L(PrescriptTypes,"||")  d
	.s onepresc=$P(PrescriptTypes,"||",i)
	.Q:onepresc=""
	.s:firstbill="" firstbill=$P(onepresc,"!",5)
	.s PrescTypeDefault=$P(onepresc,"!",8)
	.if PrescTypeDefault="Y" d
	..s defbill= $P(onepresc,"!",5)
	if (defbill'=""){
		s BillTypeRowid=defbill
	}elseif(firstbill'=""){
		s BillTypeRowid=firstbill
	}
	
	s:defadereason'="" BillTypeRowid=defadereason
	
	

	s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14)
	s ShortOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s OrderType=""
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	
	s diatypedr=$O(^MRC("DTYP",0,"Code","OP",0))
	s diastatu=$O(^MRC("DSTAT",0,"Desc","确诊",0))
	//诊断
	//LogDepRowid_","_MRAdmRowid_","_ICDCodeRowid_","_UserRowid_","_MRDIADesc_","_MRDiagTypeDesc
	s rtn=##class(web.DHCDocDiagnosEntryV8).InsertMRDiagnos(mradm,"^^"_icdDr_"^"_diatypedr_"^N^"_diastatu_"^"_$ZD(+$H,3)_"^^^false","^^^^F^^^^1^CZ^^^N^N",defloc,defUser)
	;s rtn=##class(web.DHCMRDiagnos).InsertMRDiagnos(defloc,mradm,icdDr,defUser,"","")
	s nowdate=$ZD(+$H,4)
	s nowtime=$Zt($P($H,",",2),1)
	s OrdItemStr=ArcimID_"^"_OrderType_"^"_ShortOrderPriorRowid_"^"_nowdate_"^"_nowtime_"^1^^"_reloc_"^"_BillTypeRowid_"^^^^^1^^^^^^1^N^^Y^^^^^"_specimen_"^^N^^^^^^^^^^^^^^^^" //_nowdate_"^"_nowtime_"^N^^^^^N^^"_ARCIMBillingUOM_"^^N^^^^^^^"
	
	s rtn=##class(web.DHCOEOrdItem).InsertOrderItem(EpisodeID,OrdItemStr,defUser,defloc,DocID)
	
	s rtn=##class(web.DHCDocOrderEntry).SetArrivedStatus(EpisodeID,DocID,defloc,defUser)
	
	
	q 0
}

}
