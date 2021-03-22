Class DHCDoc.DHCDocCure.Apply Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断医嘱是否是治疗项目
/// w ##class(DHCDoc.DHCDocCure.Apply).CheckItem("8935||1")
ClassMethod CheckItem(ItemMastId, LocId)
{
	s Flag=0
	q:(ItemMastId="")||(LocId="") 0
	s ItemFlag=..GetCureItemFlag(ItemMastId)
	if ItemFlag=1{
		s LocFlag=..GetCureLocFlag(LocId)
		if LocFlag=1{
			s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ItemMastId,""))
			if DDCISRowid'=""{
				s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
				if ManualApply'="Y" s Flag=1
			}
		}
	}
	
	q Flag
}

/// 判断医嘱是否是治疗项目
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag("8935||1")
ClassMethod GetCureItemFlag(ARCIMRowId As %String) As %String
{
	n (ARCIMRowId)
	s Flag=0
	q:ARCIMRowId="" Flag
	s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
	q:ItemCatRowid="" Flag
	s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat")) 
	if ("^"_DHCDocCureItemCatStr_"^")[("^"_ItemCatRowid_"^") s Flag=1
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ARCIMRowId,""))
	if DDCISRowid="" s Flag=0
	q Flag
}

/// 判断科室是否是治疗科室
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag("8935||1")
ClassMethod GetCureLocFlag(LocId As %String) As %String
{
	n (LocId)
	s Flag=0
	q:LocId="" Flag
	s CureLocStr=$g(^DHCDocConfig("DHCDocCureLocStr")) 
	if CureLocStr="" s Flag=1 q Flag
	if ("^"_CureLocStr_"^")[("^"_LocId_"^") s Flag=1
	q Flag
}

/// 生成治疗申请单  审核单和医嘱一对一  
/// 1.生成申请单
/// w ##class(DHCDoc.DHCDocCure.Apply).CreateCureApply(2318,"1989||6",1)
ClassMethod CreateCureApply(EpisodeID As %String, OrderId As %String, UserID As %String) As %String
{
	n (EpisodeID,OrderId,UserID)
	;s ^TMP("SaveCureApply")=EpisodeID_","_UserID_","_OrderId
	Quit:EpisodeID="" 0
	Quit:OrderId="" 0
	s err=0
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	Lock ^DHCDocCureApply("NO",+$H)
	s NO=$I(^DHCDocCureApply("NO",+$H))
	Lock -^DHCDocCureApply("NO",+$H)
	s DCANO=$tr($ZD(NowDate,3),"-","")_$E("0000",1,4-$L(NO))_NO ;申请单号
	;1.新增申请单
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=OrderId
	s PLIST(4)="A"
	s PLIST(5)=UserID
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)
	s PLIST(19)=DCANO
	b ;PLIST
	&sql(insert into SQLUser.DHC_DocCureApp values :PLIST())
	if SQLCODE 
	{
		s err=SQLCODE
		s ErrMsg="插入治疗申请单表失败"_"$"_EpisodeID_","_OrderId_","_UserID
		d ##class(DHCDoc.Log.Common).General("Insert","DHCDoc.DHCDocCure.Apply","CreateCureApply",ErrMsg,OrderId,err) 
		Q err
	}
  Q err_"^"_%ROWID
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckAfterInit(669,"4634^7^28")
/// 治疗申请单界面初始化完成后,返回给界面的一些提示信息.
ClassMethod CheckAfterInit(EpisodeID As %String, ExpStr As %String, JSONFlag As %String = "JSON")
{
	n (EpisodeID,ExpStr,JSONFlag)
	s ^tmpnk("CheckAfterInit")=EpisodeID_","_ExpStr
	s Adm=EpisodeID
	s ret=0
	if (Adm=""){
		s ret="就诊信息为空"
		q ##class(DHCDoc.DHCDocCure.Common).EvalJson(ret,JSONFlag)	
	}
	
	s OPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("OPAdmDayLimit")
	i OPAdmDayLimit="" s OPAdmDayLimit=1
	s USERID=$p(ExpStr,"^",1)
	s CTLOCID=$p(ExpStr,"^",2)
	s GroupID=$p(ExpStr,"^",3)
	;不受就诊有效天数限制
	s NoAdmValidDaysLimit=##Class(web.DHCDocConfig).GetConfigNode1("NoAdmValidDaysLimit",GroupID)
	;住院有主管医生才能录医嘱
 	s CFIPNeedDoctor=##Class(web.DHCDocConfig).GetConfigNode("IPNeedDoctor")
	s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(Adm)
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(USERID)
 	s CareProvType=$zcvt(CareProvType,"U")
	s warning=""
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(Adm)
	s (PilotProCareFlag,PilotProCare)=""
	s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
 	s FinFlag=$p($g(^PAADM(Adm)),"^",45)
 	s PAADMDate=$p($g(^PAADM(Adm)),"^",6)
 	s PAADMTime=$p($g(^PAADM(Adm)),"^",7)
 	s PAADMDocDR=$p($g(^PAADM(Adm)),"^",9)
 	s PAADMBedDR=$p($g(^PAADM(Adm)),"^",73)
 	s today=$P($h,",",1)
 	s DocID=$P(^SSU("SSUSR",USERID),"^",14)
 	s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(Adm)
 	s IfPilotAdm=$p(PilotAdmInfo,"^",1)
 	s AdmPPRowId=$p(PilotAdmInfo,"^",2)
 	i AdmPPRowId'="" d
 	. s PilotProCareFlag=##Class(web.PilotProject.DHCDocPilotProCommon).IsPilotProCareFlag(AdmPPRowId,USERID)
 	. s PilotProCareInfo=##Class(web.PilotProject.DHCDocPilotProCommon).GetPilotProCare(AdmPPRowId)
 	. s PilotProCare=$p(PilotProCareInfo,"^",2)
 	s LogonLocAdmTypeLimitInfo=##Class(web.DHCDocOrderCommon).CheckLogonLocAdmTypeLimit(CTLOCID,PAAdmType)
 	i (LogonLocAdmTypeLimitInfo'="") d
 	. s warning=LogonLocAdmTypeLimitInfo
 	if (warning'="") s ret=warning
 	if ret'=0 q ##class(DHCDoc.DHCDocCure.Common).EvalJson(ret,JSONFlag)
 	
 	i (PAAdmType="I") d
 	. i (PAADMBedDR="")&(CurrentDischargeStatus'="B") d
 	. . s warning="此病人未分配床位,不允许开医嘱."
 	. i (PAADMDocDR="")&&(CFIPNeedDoctor=1) d
 	. . s warning="此病人未分配医生,不允许开医嘱." 
 	. s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(Adm)
 	. i OrderUnabled=1 d
 	. . s warning="此病人正在结算中,不允许再开医嘱."
 	. i FinFlag="Y" d
 	. . s warning="此病人已结算出院,不允许再开医嘱."
 	. i ((HaveMidDischarged=1)&&(CareProvType="DOCTOR")&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) d
 	. . s warning="此病人已做医疗结算,不允许医生再开医嘱."
 	. i ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="")&(CurrentDischargeStatus'="B") d
 	. . s warning="此病人已做最终结算,不允许医护人员再开医嘱."
 	e  d
 	. i (" 1 2 "[(" "_GetStayStatusFlag_" "))&&(VisitStatus="D") d
 	. . s warning="此病人已结算出院,不允许再开医嘱."
 	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCDocOrderCommon"_"||"_"IsLoginAdmLoc")
 	if (flag=1){
 	;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
 	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(CTLOCID,Adm)
 	}
 	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCDocOrderCommon"_"||"_"GetVisitTimeToDay")
 	if (flag=1){
 	s LimitTimeStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(Adm)
	s:(VisitStatus="C")&(PAAdmType="O") warning="此病人已退号,不允许再开医嘱."
	i (+LimitTimeStr'=0)&(PAAdmType="O") d
	. s:(IfPilotAdm'=1)&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1)&&(LoginAdmLocFlag="Y") warning="此就诊记录的挂号日期在"_$p(LimitTimeStr,"^",3)_$p(LimitTimeStr,"^",2)_"以前,不允许再开医嘱."
	i (+LimitTimeStr'=0)&(PAAdmType="E")&&(NoAdmValidDaysLimit'=1) d
	. s warning="此就诊记录的挂号时间在"_$p(LimitTimeStr,"^",3)_$p(LimitTimeStr,"^",2)_"以前,不允许再开医嘱." 
 	}else{
	 	i ((VisitStatus="C")!((OPAdmDayLimit'=0)&(today-PAADMDate>(OPAdmDayLimit-1))))&(PAAdmType="O") d
 	. s IfPilotAdm=##Class(web.PilotProject.DHCDocPilotProCommon).CheckPilotAdm(Adm)
 	. i VisitStatus="C" s warning="此病人已退号,不允许再开医嘱."
 	. e  i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1)  s warning="此就诊记录的挂号日期在"_OPAdmDayLimit_"天以前,不允许再开医嘱."
 	i (PAAdmType="E")&&(" 1 2 "'[(" "_GetStayStatusFlag_" "))&&(IfPilotAdm'=1) d
 	. i ##class(web.DHCDocOrderCommon).CheckOEtime(PAADMDate,PAADMTime)=1 d
	 	. .s warning="此就诊记录的挂号时间在24小时以前,不允许再开医嘱."
 	}
 	if (warning'="") s ret=warning
 	
 	q ##class(DHCDoc.DHCDocCure.Common).EvalJson(ret,JSONFlag)
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckBeforeInsert(1,"5487||1","6^7^126")
/// 治疗申请插医嘱前的判断.
ClassMethod CheckBeforeInsert(EpisodeID As %String, ArcimRowid As %String, ExpStr As %String)
{
	n (EpisodeID,ArcimRowid,ExpStr)
	s Adm=EpisodeID
	s ret=0
	if (Adm=""){
		s ret="就诊信息为空"
		q ##class(DHCDoc.DHCDocCure.Common).EvalJson(ret,"JSON")	
	}
	s USERID=$p(ExpStr,"^",1)
	s CTLOCID=$p(ExpStr,"^",2)
	s GroupID=$p(ExpStr,"^",3)
	
	;按照医嘱项上的门诊用药、急诊用药、住院用药标志来检测医嘱项是否可用
	s CheckArcimTypeStr=##class(web.DHCDocOrderCommon).CheckArcimType(ArcimRowid,EpisodeID)
	;得到医嘱的性别/年龄限制 1 限制,0非限制
	s PAPMIRowid=$P(^PAADM(EpisodeID),"^",1)
	s PatDOB=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",6)
	s SexId=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",7)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s ASCheckStr=##class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ArcimRowid,SexId,Age)
	s ASCheckStr=$tr(ASCheckStr,$c(2),"!")
	s ret=CheckArcimTypeStr_"^"_ASCheckStr
 	
 	q ##class(DHCDoc.DHCDocCure.Common).EvalJson(ret,"JSON")
}

/// w ##class(DHCDoc.DHCDocCure.Apply).InsertCureApply(671,"6610||1",2,116,44,2,1,4634,7,"4^28")
ClassMethod InsertCureApply(EpisodeID, ArcimRowid, OrderQty, BillingUOM, OrderRecDepRowid, ApplyPlan, ApplyRemark, USERID, CTLOCID, ExpStr)
{
	s ^tmpnk("InsertCureApply")=EpisodeID_","_ArcimRowid_","_OrderQty_","_BillingUOM_","_OrderRecDepRowid_","_ApplyPlan_","_ApplyRemark_","_USERID_","_CTLOCID_","_ExpStr
	s CureItemFlag="",CureLocFlag="",ManualApply=""
	s BillTypeRowid=$p(ExpStr,"^",1)
	s GroupID=$p(ExpStr,"^",2)
	s check=$$CheckInsert(EpisodeID,ArcimRowid,OrderRecDepRowid)
	if check'=0 q check
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",0))
	s OrderDate=$zd(+$h,4)
	s OrderTime=$zt($p($h,",",2),1)
	s OrderCoverMainIns="N"
	s OrderPackUOMRowid=BillingUOM
	
 	s UnitPrice=..GetPrice(EpisodeID,ArcimRowid,OrderRecDepRowid,OrderPackUOMRowid,"")
 	b ;1
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	s Orderprice=""
	s OrderItem=ArcimRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderDate_"^"_OrderTime
	s OrderItem=OrderItem_"^"_OrderQty_"^"_UnitPrice
	s OrderItem=OrderItem_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_OrderQty_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_"1"_"^"_"N"_"^"_""_"^"_OrderCoverMainIns
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_"N"_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_OrderDate_"^"_OrderTime_"^"_"N"_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_"N"_"^"_""_"^"_OrderPackUOMRowid
	s DCARowIDRet=""
	s DocID=$p(^SSU("SSUSR",USERID),"^",14)
	Ts
	s insret="0^"
	s Ret=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,OrderItem,USERID,CTLOCID,DocID,"","0^^")
	If (Ret'=0)&&(Ret'=100){
		f k=1:1:$l(Ret,"^")-1 {
	      s OrdID=$p($p(Ret,"^",k),"*",2)
	      i OrdID="" continue
	      ;s ArcimID=$P($G(^OEORD(+OrdID,"I",$P(OrdID,"||",2),1)),"^",2)
	      ;s ReLocId=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
	      ;s CureItemFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimID)
	      ;s CureLocFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(ReLocId)
	      ;取用是否手动申请配置
	      ;s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimID,""))
	      ;s ManualApply=""
		  ;if DDCISRowid'=""{
		  ;	s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
		  ;}
	      if (CureItemFlag=1)&&(CureLocFlag=1)&&(ManualApply="Y"){	
		      s insret=..CreateCureApply(EpisodeID,OrdID, USERID)
		      s DCARowID=$p(insret,"^",2)
		      if DCARowID="" s insret="101^插入申请单失败"
		      else  d ##class(DHCDoc.DHCDocCure.Apply).SaveCureApply(DCARowID,ApplyPlan, ApplyRemark, USERID)
		  }else{
			  ;将控制提前,防止出现空医嘱
			  ;if (CureItemFlag=0) s insret="102^非治疗类医嘱"
			  ;else  if (CureLocFlag=0) s insret="102^非治疗类接收科室"
			  ;else  if (ManualApply'="Y") s insret="102^非需手动申请治疗类医嘱"
		  }
		}
	}else{
		s insret="100^插入医嘱失败"	
	}
	if +insret'=0{
		tro	
	}else{
		tc	
	}
	q insret
CheckInsert(Adm,arcim,recdepid)
	b ;n (Adm,arcim,recdepid)
	s ret=0
	s ExpStr=USERID_"^"_CTLOCID_"^"_GroupID
	s ret=..CheckAfterInit(Adm,ExpStr,"")
 	if (ret'=0){
	 	s ret="102^"_ret
 		q ret
 	}
 	
 	
	;取用是否手动申请配置
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",arcim,""))
	s ManualApply=""
	if DDCISRowid'=""{
		s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
		if (ManualApply'="Y") s ret="102^该医嘱项非需手动申请治疗类医嘱"
	}
	s CureItemFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(arcim)
	s CureLocFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(recdepid)
	if (CureItemFlag=0) s ret="102^该医嘱项所属子类非治疗类医嘱"
	if (CureLocFlag=0) s ret="102^所选接收科室非治疗类接收科室"
	q ret
}

ClassMethod GetPrice(EpisodeID, ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid, OrdRowID)
{
	n (EpisodeID, ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid,OrdRowID)
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",0))
	s AdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,OrderRecDepRowid)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s itmPriceExpStr=""
	s oeore=""
	s itmPriceExpStr=OrdRowID_"^"_oeore_"^"_EpisodeID_"^"_OrderRecDepRowid_"^"_""
	s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, AdmReasonDR, ArcimRowid, +$h, OrderPriorRowid, "", "", "",PAADMRegConDisDR,OrderPackUOMRowid,itmPriceExpStr) 
	s UnitPrice=$p(UnitPrice,"^",1)
 	s UnitPrice=$tr(UnitPrice," ","")
 	q UnitPrice
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CancelCureApplyByStopOrd("3382||3",1)
ClassMethod CancelCureApplyByStopOrd(OEORDRowId As %String, UserID As %String)
{
	n (OEORDRowId,UserID)
	q:OEORDRowId="" 0
	s DCARowID=$o(^DHCDocCure(0,"OEORI",OEORDRowId,""))	
	Q:DCARowID="" 0
	
	;这会取到的状态是0，不行
	/*s RePay=##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR(OEORDRowId)
	s RePay=$p(RePay,"^")
	s ^tmpnk("RePay",1)=OEORDRowId_"^"_RePay
	Q:RePay="1" 0*/
	;(RePay,"0":"","1":"部分退费","2":"全部退费")
	
	;计费先停，状态改为了D，这会调用了停医嘱方法， 之后又会判断是否部分退,把医嘱状态改回V 不行
	s OrderAdm=$p($g(^OEORD(+OEORDRowId)),"^",1)
	s AdmType=$p($g(^PAADM(OrderAdm)),"^",2)
	if (AdmType'="I"){
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+OEORDRowId,"I",+$p(OEORDRowId,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		s OrdPHFreqDR=$p($g(^OEORD(+OEORDRowId,"I",$p(OEORDRowId,"||",2),2)),"^",4)
		Set RefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORDRowId,"")
		;部分退费数量=实际退费数量+申请退费数量
		Set ToalRefQty=$p(RefQtyInfo,"^",1)
		Set AppRefQty=$p(RefQtyInfo,"^",2)
		Set TotalQty=+$p($g(^OEORD(+OEORDRowId,"I",$p(OEORDRowId,"||",2),1)),"^",12)
		b ;如果总退费数量小于医嘱总数量时, 为部分退费
		if (OrderStatusCode="D")&&((+ToalRefQty)<(+TotalQty)){
			s OrderExecChild=""
			f  s OrderExecChild=$o(^OEORD(+OEORDRowId,"I",$p(OEORDRowId,"||",2),"X",OrderExecChild),-1) Q:(OrderExecChild="")!(AppRefQty'>0)  d
			.s OEOREDR=OEORDRowId_"||"_OrderExecChild
			.s execdata=$g(^OEORD(+OEORDRowId,"I",$p(OEORDRowId,"||",2),"X",OrderExecChild))
			.s OEOREStatus=$p(execdata,"^",16)
			.s OEOREStatusCode=""
			.s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
			.Q:(OEOREStatusCode="F")!(OEOREStatusCode="D")
			.s OEOREQty=$p(execdata,"^",4)
			.s OEOREAdminQty=$p(execdata,"^",5)
			.i OrdPHFreqDR="" d
			..s OEOREQty=OEOREAdminQty
			.;申请退费数量大于等于当前执行数量 则将执行记录停止执行
			.b ;申请退费数量小于当前执行数量 则将执行记录更新数量
			.if OEOREQty'>AppRefQty d
			..d ##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"D",UserID,"","","","")
			.else  d
			..s UpdateQty=OEOREQty-AppRefQty
			..d ##class(DHCDoc.DHCDocCure.ExecApply).UpdateQtyByExecID(OEOREDR,UpdateQty)
			.set AppRefQty=AppRefQty-OEOREQty
			Q 0	
		}
	}
	s ret=..CancelCureApply(DCARowID,UserID)
	q ret
}

ClassMethod CancelTriaged(DCARowId As %String, UserID As %String)
{
	n (DCARowId,UserID)
	s TriChildSub=0
	for  s TriChildSub=$o(^DHCDocCureTRI(DCARowId,"Triage",TriChildSub)) Q:TriChildSub=""  d
	.s TRIRowID=DCARowID_"||"_TriChildSub
	.d ##class(DHCDoc.DHCDocCure.Triage).CancelTriaged(TRIRowID,UserID)
	q 0
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CancelCureApply(43,6)
ClassMethod CancelCureApply(DCARowId As %String, UserID As %String)
{
	s ^TMP("DeleteCureApp")=DCARowId_"^"_UserID
	Q:DCARowId="" 0
	
	s ret=..CheckData(DCARowId,"C")
	
	q:$g(ret)'="" ret
	//停医嘱
	/*
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	//Set DCAOEORIDR=$p(CureAppInfo,"^",7)
	//Set DCAText1=$p(CureAppInfo,"^",8) //治疗项目附加费用
	s ret=0
	s DCACChildSub=0
	for{
		s DCACChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub))
		q:DCACChildSub=""
		s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
		q:ret'=0
		if (DCAOEORIDR'=""){
			s Adm=$p(^OEORD(+DCAOEORIDR),"^")
			s AdmType=$p(^PAADM(Adm),"^",2)
			if (AdmType="I"){
				s ret=##class(appcom.OEOrdItem).UnUse(DCAOEORIDR,UserID)
			}else{
				s ret=##class(web.DHCOEOrdItem).Stop(DCAOEORIDR,UserID)
			}
		}
		
	}
	Q:ret'=0 ret
	;账单
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	*/
	s CureDate=+$h
	s CureTime=$p($h,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status="C",DCA_UpdateDate=:CureDate,DCA_UpdateTime=:CureTime,DCA_UpdateUser_DR=:UserID where DCA_RowId=:DCARowId)
	Q SQLCODE
}

/// 取单个治疗申请单剩余的可预约次数
/// w ##class(DHCDoc.DHCDocCure.Apply).GetApplyNoAppTimes(867)
ClassMethod GetApplyNoAppTimes(DCARowId) As %String
{
	n (DCARowId)
	Quit:DCARowId="" 0
	s CureAppInfo=""
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Q:Adm="" 0
	Set OrderId=$p(CureData,"^",2)
	q:OrderId="" 0
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	q:ArcimId="" 0
	s OrderQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
	s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes
	s ApplyFinishTimes=+$p(ApplyAppInfo,"^",2)
	s ApplyNoFinishTimes=+ApplyAppedTimes-ApplyFinishTimes	
	q ApplyNoAppTimes
}

/// 取单个治疗申请单信息
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(5)
ClassMethod GetCureApplyBak(DCARowId) As %String
{
	n (DCARowId)
	Quit:DCARowId="" ""
	s CureAppInfo=""
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Q:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set OrderId=$p(CureData,"^",2)
	s OrderStatus="核实",OrderStatusCode="V",OrdReLocId="",OrderReLoc=""
	//如果是自动插入申请单走医嘱的按照医嘱获取数据处理，不插入医嘱的按照申请单信息处理
	if OrderId'="" d
	.s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	.s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
	.s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	.s OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	.If OrdReLocId'="" d
	..s OrderReLoc=$P($G(^CTLOC(OrdReLocId)),"^",2)
	..i $P(OrderReLoc,"-",2)'="" s OrderReLoc=$P(OrderReLoc,"-",2)
	.s OrderQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	else  d
	.s ArcimId=$P(CureData,"^",12)
	.s OrdReLocId=$P(CureData,"^",13)
	.If OrdReLocId'="" d
	..s OrderReLoc=$P($G(^CTLOC(OrdReLocId)),"^",2)
	..i $P(OrderReLoc,"-",2)'="" s OrderReLoc=$P(OrderReLoc,"-",2)
	.s OrderQty=+$P(CureData,"^",14)
	.s:OrderQty=0 OrderQty=99999
	
	q:ArcimId="" ""
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	q:(OrderStatusCode'="V")&&(OrderStatusCode'="E") ""

	s ApplyStatusCode=$p(CureData,"^",3)
	s ApplyStatus=$case(ApplyStatusCode,"A":"预约","V":"到达","C":"取消","F":"完成",:"")
	s ApplyUser=$p(CureData,"^",4)
	s:ApplyUser'="" ApplyUser=$P(^SSU("SSUSR",ApplyUser),"^",2)
	s ApplyDate=$p(CureData,"^",5)
	s ApplyTime=$p(CureData,"^",6)
	s:ApplyDate'="" ApplyDate=$zd(ApplyDate,3)
	s:ApplyTime'="" ApplyTime=$zt(ApplyTime)
	s ApplyDate=ApplyDate
	s AppLoc=""
	s AppLocDr=$P(CureData,"^",15) //申请增加科室
	s:AppLocDr'="" AppLoc=$P($G(^CTLOC(AppLocDr)),"^",2)
	i $P(AppLoc,"-",2)'="" s AppLoc=$P(AppLoc,"-",2)
	s InsertDate=$P(CureData,"^",16) //申请增加日期
	s:InsertDate'="" InsertDate=$ZD(InsertDate,3)
	s InsertTime=$P(CureData,"^",17) //申请增加时间
	s:InsertTime'="" InsertTime=$ZT(InsertTime,2)
	s DocCurNO=$P(CureData,"^",18) //申请增加号

	s BillingUOM=""
	s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	if BillingUOMDR'="" s BillingUOM=$p(^CT("UOM",BillingUOMDR),"^",2)

	s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
	s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes
	s ApplyFinishTimes=+$p(ApplyAppInfo,"^",2)
	s ApplyNoFinishTimes=+ApplyAppedTimes-ApplyFinishTimes
	s ApplyRemarks=$p(CureData,"^",10)
	s ApplyPlan=$p(CureData,"^",11)
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	s CureAppInfo=ArcimDesc_"^"_OrderStatus_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_OrdReLocId_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_ApplyRemarks_"^"_ApplyPlan_"^"_Adm
	s CureAppInfo=CureAppInfo_"^"_AppLoc_"^"_InsertDate_"^"_InsertTime_"^"_DocCurNO_"^"_ArcimId_"^"_ApplyTime_"^"_AppLocDr_"^"_ApplyStatusCode
	q PatientInfo_$c(1)_CureAppInfo
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(250)
/// Desc:  根据申请单ID获取申请单信息
/// Input: DCARowId申请单ID SpecFlag特殊处理,传1医嘱名拼写停止信息
/// OutPut:
ClassMethod GetCureApply(DCARowId, SpecFlag As %String = "") As %String
{
	n (DCARowId,SpecFlag)
	Quit:DCARowId="" ""
	s CureAppInfo=""
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Q:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set OrderId=$p(CureData,"^",2)
	q:OrderId="" ""
	s AdmType=$p($g(^PAADM(Adm)),"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	q:ArcimId="" ""
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	
	s OrderStatus="",OrderStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",13)
	s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimId,""))
	q:DDCISRowid="" ""
	s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	s ApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",9)
	s OrderReLoc=""
	s OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	If OrdReLocId'="" d
	.s OrderReLoc=$P($G(^CTLOC(OrdReLocId)),"^",2)
	.i $P(OrderReLoc,"-",2)'="" s OrderReLoc=$P(OrderReLoc,"-",2)
	s OrderAddDept=""
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	If OrderAddDeptDr'="" d
	.s OrderAddDept=$P($G(^CTLOC(OrderAddDeptDr)),"^",2)
	.i $P(OrderAddDept,"-",2)'="" s OrderAddDept=$P(OrderAddDept,"-",2)
	;s OrderQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s DocCureUseBase=+(##class(web.DHCDocConfig).GetConfigNode("DocCureUseBase"))
	if DocCureUseBase=1 s ApplyExecFlag="Y"
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) {
		if ApplyExecFlag="Y" s ApplyExec="直接执行"
		else  s ApplyExec="可预约"
	}else{
		s ApplyExec="直接执行(长期)"
	}
	
	s Ordbilled=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3),"^",5)
	;ControlFlag为0.界面上执行按钮不可操作
	s ControlFlag=0
	s AdmStatus=$P($g(^PAADM(Adm)),"^",20)
	i (AdmType'="I"){
		i (Ordbilled'="P") s Ordbilled="否"
		else  s Ordbilled="是"
	}else{
		s Ordbilled="在院"
		if AdmStatus="D" s Ordbilled="已出院"
	}
	if SpecFlag="1"{
		if (Ordbilled'="否")&&(ApplyExec["直接执行"){
			s ControlFlag=1
		}
		if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
			s check=..CheckActiveExec(OrderId)
			if (ApplyExec["直接执行")&&(check=0){
				;医嘱已停止或作废且执行记录都已经处理完就不让操作了?
				;s ControlFlag=0
			}
			s ArcimDesc=ArcimDesc_"<font color=red>"_"("_OrderStatus_")"_"</font>"
		}
		;q:(check=0) ""
	}
	
	s ActiveQtyStr=..GetOrderActiveQty(OrderId)
	s OrderQty=$p(ActiveQtyStr,"^",1)
	s BillingUOM=$p(ActiveQtyStr,"^",2)
	
 	s UnitPrice=..GetPrice(Adm,ArcimId,OrdReLocId,"",OrderId)
 	s UnitPrice=$p(UnitPrice,"^",1)
 	s UnitPrice=$j($g(UnitPrice),11,2)
 	s UnitPrice=$tr(UnitPrice," ","")
 	s Subscript=$p(ArcimId,"||",1)
 	s Version=$p(ArcimId,"||",2)
 	s ItemCat=$p(^ARCIM(Subscript,Version,1),"^",10) //取子分类
 	s OrderType=$p(^ARC("IC",ItemCat),"^",7)
 	s ItemCatDesc=$p(^ARC("IC",ItemCat),"^",2)
 	i OrderType="P" s UnitPrice=$p($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",25)
 	s OrderBillTypeRowid=$p($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),11)),"^",18)
 	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
 	s OrdPrice=$j($g(UnitPrice)*OrderQty,11,2)
 	s OrdPrice=$tr(OrdPrice," ","")
 	if ApplyExec="直接执行(长期)"{
	 	s OrdPrice="-"
 	}
	s ApplyStatus=$p(CureData,"^",3)
	s ApplyStatus=$case(ApplyStatus,"A":"申请","V":"到达","C":"取消","F":"完成","D":"已分配",:"")
	s ApplyUser=$p(CureData,"^",4)
	s:ApplyUser'="" ApplyUser=$P(^SSU("SSUSR",ApplyUser),"^",2)
	s ApplyDate=$p(CureData,"^",5)
	s ApplyTime=$p(CureData,"^",6)
	;s ApplyDate=$zd(ApplyDate,3)
	s ApplyDate=##class(websys.Conversions).DateLogicalToHtml(ApplyDate)
	s ApplyTime=$zt(ApplyTime)
	s ApplyDate=ApplyDate_" "_ApplyTime
	s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
	s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes
	s ApplyFinishTimes=+$p(ApplyAppInfo,"^",2)
	s ApplyNoFinishTimes=+ApplyAppedTimes-ApplyFinishTimes
	s ApplyRemarks=$p(CureData,"^",10)
	s ApplyPlan=$p(CureData,"^",11)
	s FinishUserDr=$p(CureData,"^",12)
	s FinishUser=""
	s:FinishUserDr'="" FinishUser=$P(^SSU("SSUSR",FinishUserDr),"^",2)
	s CallStatus=$p(CureData,"^",16)
	if CallStatus="Y" s CallStatus="正在呼叫"
	else  s CallStatus=""
	s HistoryRes=##class(DHCDoc.DHCDocCure.Triage).GetHistoryRes(DCARowId)
	if HistoryRes'=""{
		s TRData=$g(^DHCDocCureTR(+HistoryRes,"TR",$p(HistoryRes,"||",2)))
		s DDCTRCTLocDr=$p(TRData,"^",1)
		s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
		if DDCTRCTLoc["-" s DDCTRCTLoc=$p(DDCTRCTLoc,"-",2)
		s DDCTRResDr=$p(TRData,"^",2)
		s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
		s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
		s HistoryRes=DDCTRCTLoc_"-"_DDCTRCTPCP
	}
	s ApplyNo=$p(CureData,"^",18)
	s CurrentDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s CurrentTime=$zt($p($h,",",2),2)
	s SysCurrentDateTime=CurrentDate_" "_CurrentTime
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	s CureAppInfo=ArcimDesc_"^"_OrderStatus_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc
	s CureAppInfo=CureAppInfo_"^"_OrdReLocId_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes
	s CureAppInfo=CureAppInfo_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_ApplyRemarks_"^"_ApplyPlan
	s CureAppInfo=CureAppInfo_"^"_Adm_"^"_OrdPrice_"^"_Ordbilled_"^"_UnitPrice_"^"_FinishUser
	s CureAppInfo=CureAppInfo_"^"_ServiceGroupDR_"^"_CallStatus_"^"_ApplyExec_"^"_ControlFlag_"^"_HistoryRes
	s CureAppInfo=CureAppInfo_"^"_OrderAddDept_"^"_OrderBillType_"^"_SysCurrentDateTime_"^"_DDCISRowid_"^"_ItemCatDesc
	s CureAppInfo=CureAppInfo_"^"_ApplyNo
	q PatientInfo_$c(1)_CureAppInfo
}

ClassMethod GetOrderActiveQty(OrderId)
{
	n (OrderId)
	s OrderAdm=$p(^OEORD(+OrderId),"^",1)
	s AdmType=$p($g(^PAADM(OrderAdm)),"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	q:ArcimId="" ""
	s OrderDoseQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	s OrderDoseUnitID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),2)),"^",3)
	s OrderDoseUnit=""
	s:OrderDoseUnitID'="" OrderDoseUnit=$p(^CT("UOM",OrderDoseUnitID),"^",2)
	s OrderPackQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),9)),"^",4)
	s BillingUOM="",OrderQty=0,PackUOMDesc=""
	s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	;协议单位
	s ProtocolPackUOMDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		s BillingUOMDR=ProtocolPackUOMDR
	}
	if BillingUOMDR'="" s BillingUOM=$p(^CT("UOM",BillingUOMDR),"^",2)
	s BaseUOMDesc=""
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	i INCIRowid'="" {
		s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
		s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	}
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s convFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
	if AdmType="I"  {
		if (##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
			s OrderQty=""
			;s BillingUOM=""
		}else{
			if (OrderPackQty'=""){
				s OrderQty=OrderPackQty
			}else{
				s OrderPackQty=OrderDoseQty
				s OrderQty=OrderDoseQty
				s:OrderDoseUnit'="" BillingUOM=OrderDoseUnit
			}
		}
	}else{
		i (+OrderPackQty'=0) {
			s OrderQty=OrderPackQty*convFac
			s:BaseUOMDesc'="" BillingUOM=BaseUOMDesc
		}else{
			s OrderQty=OrderDoseQty
			s:OrderDoseUnit'="" BillingUOM=OrderDoseUnit
		}
		s pqty=""
		s pbrowid=0
		f  {
			s pbrowid=$o(^DHCPBi(0,"OEORI",OrderId,pbrowid)) 
			q:pbrowid=""
			continue:$d(^DHCPB(pbrowid))=10 ;add hujunbin 15.2.5
			continue:$d(^DHCPB(pbrowid))=0 ;add hujunbin 15.2.5
			s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
			s pb=pbrowid
			s pbosub=0
			f  {
				s pbosub=$o(^DHCPBi(0,"OEORI",OrderId,pbrowid,pbosub))
				q:pbosub=""
				continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
				s pbo=^DHCPB(pbrowid,"O",pbosub)
				s pbbillqty=$p(pbo,"^",5)
				s pbrefundqty=$p(pbo,"^",6)
				s pqty=pqty+pbbillqty+pbrefundqty
			}
		}
		i +pqty'=0 s OrderQty=pqty
	}
	q OrderQty_"^"_BillingUOM
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckActiveExec("1534||83")
ClassMethod CheckActiveExec(OEOrdID)
{
	n (OEOrdID)
	s ret=1
	s order=+OEOrdID
	s AdmID=$p(^OEORD(order),"^",1)
	s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	s ordItem=$p(OEOrdID,"||",2)
	s OrderStatus="",OrderStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(order,"I",ordItem,1)),"^",13)
	s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
		if AdmType'="I"{
			s ret=0	
		}else{
			s ret=0	
			s orderExecId=""
			f  s orderExecId=$O(^OEORD(order,"I",ordItem,"X",orderExecId),-1) q:(orderExecId="")!(ret=1)  d
			.q:orderExecId=0
			.s str = ^OEORD(order,"I",ordItem,"X",orderExecId)	
			.s ExecStateDR= $p(str,"^",16)
			.i +ExecStateDR>0 s TExecState = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	;OEC_Order_AdminStatus
			.e  s TExecState = "未执行",TExecStateCode="未执行"
			.if (TExecState="未执行")!(TExecStateCode="F") s ret=1
		}
	}	
	q ret
}

ClassMethod GetCureAppPatInfo(Adm As %String)
{
	Q:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)	
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	Q PatientInfo
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetPatientBaseInfo("",644)
ClassMethod GetPatientBaseInfo(DCARowId, adm)
{
	s ^tmpnk("GetPatientBaseInfo")=DCARowId_"^"_adm
	s name="",bedno="",age="",sex="",weight="",ipno="",insu="",ipdate=""
	q:(DCARowId="")&&(adm="") ""
	if (DCARowId'="") d
	.Set CureData=$g(^DHCDocCure(DCARowId))
	.Set Adm=$p(CureData,"^",1)
	.if adm="" s adm=Adm
	s papmi = +^PAADM(adm)
	q:'$d(^PAPER(papmi)) ""
	S CONTEXT = "" ;$g(%session.Data("CONTEXT"))	
	s:$d(^PAPER(papmi,"ALL")) name = $p(^PAPER(papmi,"ALL"),"^",1)
	s:$d(^PAADM(adm)) beddr = $p(^PAADM(adm),"^",73)
	s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)	
	s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	s weight=##class(web.DHCDocInPatientList).GetWeight(adm)
	s age = ##class(web.DHCDocMainOrderInterface).GetPatientAge(papmi,adm)

	s regno = ##class(web.PAPatMas).GetRegistration(papmi)
	s ipno = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(adm)
	s insu = $p(^PAADM(adm,1),"^",7) ;PAADMAdmReasonDR
	s:insu'="" insu=$p(^PAC("ADMREA",insu),"^",2)
	s ipdate = $p(^PAADM(adm),"^",6)
	if ipdate'="" {
		Set ipDays = +$h-ipdate
		set ipdate=$zd(ipdate,3)
		set baseInfoAdmDays=ipDays
		if (baseInfoAdmDays=0) set baseInfoAdmDays=1
	}
	s admInfo=##Class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(adm) 
	s ipDays=$p(admInfo,"^",12)
	s charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(adm)
	Set mradm=$P(^PAADM(adm),"^",61)
	Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)
	if ($l(Diagnosis)>10){
		Set Diagnosis=$e(Diagnosis,1,10)_"..."
	}
	s isEstDisch = ##class(web.DHCDocMain).isEstDisch(adm)
	set IconProfile=$ZCVT(##class(web.DHCDocMain).ShowIcon("MAP",adm_"^^^"_papmi,CONTEXT),"O","HTML")	//加图表菜单
	s admDept = $p(^PAADM(adm),"^",4)
	s:+admDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(admDept)
	s Tel=$p($g(^PAPER(papmi,"PER",1)),"^",11)
	s PatientCompany=$g(^PAPER(papmi,"PER","ADD",1))
	s ret=name_"^"_bedno_"^"_age_"^"_sex_"^"_weight
	s ret=ret_"^"_ipno_"^"_insu_"^"_ipdate_"^"_isEstDisch_"^"_IconProfile
	s ret=ret_"^"_regno_"^"_ipDays_"^"_charge_"^"_Diagnosis_"^"_baseInfoAdmDays
	s ret=ret_"^"_Tel_"^"_PatientCompany
	q ret
}

ClassMethod GetHospitalDesc(HosID As %String)
{
	Q:HosID="" ""
	Set Hospital=$P($G(^CT("HOSP",HosID)),"^",2)	
	Q Hospital
}

/// 更新治疗申请单信息 --用于病人申请单列表
/// 在治疗申请单查询界面的更新只能更新对应备注信息和治疗计划
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(867)
ClassMethod SaveCureApply(DCARowId As %String, ApplyPlan As %String, ApplyRemark As %String, UserID As %String) As %String
{
	Quit:DCARowId="" 0
	;更新申请单
	k PLIST
	s PLIST(8)=UserID
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	s PLIST(11)=ApplyRemark
	s PLIST(12)=ApplyPlan
	&sql(update SQLUser.DHC_DocCureApp values :PLIST() where DCA_RowId=:DCARowId)
	Q SQLCODE
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询单个病人治疗申请单列表
/// Table: 		  	DHC_DocCureApp
/// Input：        EpisodeID:就诊ID  PatientID  LongOnLoc 按照传入的登录科室和接收科室作比较 outCancel 是否输出已经撤销的申请
/// 修改 lxz 2017-05-12  
Query FindCureApplyList(EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "") As %Query(ROWSPEC = "DCARowId:%String,ArcimDesc:%String,OrdStatus:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,OrdReLocId:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,ApplyRemarks:%String,ApplyPlan:%String,Adm:%String,AppLoc:%String,InsertDate:%String,InsertTime:%String,DocCurNO:%String,PapmiNo:%String,PatName:%String,Sex:%String,Pattype:%String,Tel:%String,GovNo:%String")
{
}

ClassMethod FindCureApplyListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindCureApplyList",13349882)
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	k OnePerson
	if DocApplayNo'=""  d
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"DCANO",DocApplayNo,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..s OnePerson(DCARowId)=1
	else  if PatientID'=""  d
	.;传入患者ID按照患者查询订单
	.s PAPMIID=PatientID
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....Q:(outCancel="Y")&(ApplyStatus'="C")
	....Q:(FinishDis="Y")&(ApplyStatus'="F")
	....Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	....s OnePerson(DCARowId)=1
	else  if EpisodeID'=""  d
	.;传入就诊按照就诊查询患者所有订单
	.s PAPMIID=$P(^PAADM(EpisodeID),"^",1)
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....Q:(outCancel="Y")&(ApplyStatus'="C")
	....Q:(FinishDis="Y")&(ApplyStatus'="F") 
	....Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	....s OnePerson(DCARowId)=1
	else  d
	.;为空查询半年内的预约治疗单
	.for DateAplay=(+$H-(30*6)):1:+$H  d
	..s DCARowId=0
	..f  s DCARowId=$O(^DHCDocCure(0,"ApplyDate",DateAplay,DCARowId)) Q:DCARowId=""  d
	...Set CureData=$g(^DHCDocCure(DCARowId))
	...Q:CureData=""
	...Set PAAdm=$p(CureData,"^",1)
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	...Q:(outCancel="Y")&(ApplyStatus'="C")
	...Q:(FinishDis="Y")&(ApplyStatus'="F") 
	...Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	...s OnePerson(DCARowId)=1
	
	s DCARowId=""
	f  s DCARowId=$O(OnePerson(DCARowId),-1) Q:DCARowId=""  d
	.s rtn=..GetCureApply(DCARowId,"1")
	.Q:rtn="" 
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s OrderStatus=$p(CureAppInfo,"^",2)
	.s OrderQty=$p(CureAppInfo,"^",3)
	.s BillingUOM=$p(CureAppInfo,"^",4)
	.s OrderReLoc=$p(CureAppInfo,"^",5)
	.s OrdReLocId=$p(CureAppInfo,"^",6)
	.Q:(LongOnLoc'="")&&(LongOnLoc'=OrdReLocId)&&(DocApplayNo="")
	.s ApplyStatus=$p(CureAppInfo,"^",7)
	.s ApplyUser=$p(CureAppInfo,"^",8)
	.s ApplyDate=$p(CureAppInfo,"^",9)
	.s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	.s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	.s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	.s ApplyNoFinishTimes=$p(CureAppInfo,"^",13)
	.s ApplyRemarks=$p(CureAppInfo,"^",14)
	.s ApplyPlan=$p(CureAppInfo,"^",15)
	.s Adm=$p(CureAppInfo,"^",16)
	.s AppLoc=$p(CureAppInfo,"^",17)
	.s InsertDate=$p(CureAppInfo,"^",18)
	.s InsertTime=$p(CureAppInfo,"^",19)
	.s DocCurNO=$p(CureAppInfo,"^",20)
	.
	.s PatMesage=$p(rtn,$c(1),1)
	.s PapmiNo=$P(PatMesage,"^",2)
	.s PatName=$P(PatMesage,"^",3)
	.s Sex=$P(PatMesage,"^",4)
	.s Pattype=$P(PatMesage,"^",7)
	.s Tel=$P(PatMesage,"^",25)
	.s GovNo=$P(PatMesage,"^",24)
	.d OutputRowApply
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApply 
	set Data=$lb(DCARowId,ArcimDesc,OrderStatus,OrderQty,BillingUOM,OrderReLoc,OrdReLocId,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,ApplyRemarks,ApplyPlan,Adm,AppLoc,InsertDate,InsertTime,DocCurNO,PapmiNo,PatName,Sex,Pattype,Tel,GovNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      nikang
/// CreatDate：    2018-03-20
/// Description:   审查是否有权限查看治疗申请单,若启用分诊,则只能查询到分配到本人名下的申请单。
/// Table: 		   DHC_DocCureApp
/// Input：        DCARowID:申请单ID TriageFlag:分诊标记
/// OutPut: 	   0-无权限 1-可以查看
/// Debug:		   w ##class(DHCDoc.DHCDocCure.Apply).CheckCureApplyPermission(201,7,4636)
ClassMethod CheckCureApplyPermission(DCARowId As %String, LogonLocID As %String, LogonUerID As %String)
{
	Q:DCARowId="" 0
	;是否启用分诊配置
	s DHCDocCureNeedTriage=+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureNeedTriage"))
	Q:DHCDocCureNeedTriage'=1 1
	s LogonCTPCPID=$p(^SSU("SSUSR",LogonUerID),"^",14)
	Q:LogonCTPCPID="" 0
	s ret=0
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub)) Q:DDCTChildSub=""  d
	.s DDCTRBASDR=$p(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub),"^",1)
	.s DDCTRParRef=+DDCTRBASDR
	.s DDCTRChildSub=$p(DDCTRBASDR,"||",2)
	.s DDCTStatus=$p(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub),"^",5)
	.Q:DDCTStatus="C"
	.s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	.s RowID=DDCTRParRef_"||"_DDCTRChildSub
	.s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
	.s DDCTRCTLocDr=$p(TRData,"^",1)
	.s DDCTRResDr=$p(TRData,"^",2)
	.s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	.if (LogonLocID=DDCTRCTLocDr)&&(LogonCTPCPID=DDCTRCTPCPDr) s ret=1
	q ret
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 治疗科室查询本科室治疗申请单列表
/// Table: 		  DHC_DocCureApp
/// Input：        EpisodeID:就诊ID
/// 
Query FindAllCureApplyList(PatientID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,PatOther")
{
}

ClassMethod FindAllCureApplyListExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAllCureApplyList",1425)
	s ^TMP("FindAllCureApplyList")=PatientID_","_StartDate_","_EndDate
	Set repid=$I(^CacheTemp)
	Set ind=1
	if StartDate'=""  s StartDate=$zdh(StartDate,1)
	else  s StartDate=+$h
	if EndDate'=""  s EndDate=$zdh(EndDate,1)
	else  s EndDate=+$h
	if PatientID'=""  d
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...Q:'$d(^DHCDocCure(0,"Adm",PAAdm))
	...;Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	...;Quit:PatLoc'=LocID
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:AdmVisitStatus="C"
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....Q:(ApplyStatus="C")
	....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	....Quit:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
	....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	
	....d OutputRowFindAllCureApply
	if PatientID'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	For QueryDate=StartDate:1:EndDate Do
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..Q:(QueryStatus'="")&&(QueryStatus'=ApplyStatus)
	..d OutputRowFindAllCureApply
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowFindAllCureApply
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'="" d
	.s AdmType=$P(^PAADM(Adm),"^",2)
	.s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	.s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	s rtn=..GetCureApply(DCARowId,"1")
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) 
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType
	set Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,PatOther)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindAllCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllCureApplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// lxz 通过就诊获取患者基本信息-医生填写申请单使用
ClassMethod getPatMesageByPaadm(PAADM As %String) As %String
{
	Q:PAADM=""
	s PatientId=$P($G(^PAADM(PAADM)),"^",1)
	Q:PatientId=""
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	q PatientInfo
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 医生站和治疗工作室查询就诊记录进行就诊记录的诊疗计划预约
/// Table: 		   PAAMD
/// Input：        PatientID:患者ID StartDate 就诊开始日期 EndDate 就诊结束日期
/// 
Query FindAdm(PatientID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "PAAdm:%String,PatientID:%String,Name:%String,PAPMINO:%String,Sex:%String,Phone:%String,Age:%String,AdmType:%String,AdmLoc:%String,AdmDoc:%String,AdmDate:%String,DCANum:%String,DiaDesc:%String")
{
}

ClassMethod FindAdmExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAdm",123,"","")
	s ^TMP("FindAdm")=PatientID_","_StartDate_","_EndDate
	Set repid=$I(^CacheTemp)
	Set ind=1
	s:StartDate["-" StartDate=$ZDH(StartDate,3)
	s:StartDate["/" StartDate=$ZDH(StartDate,4)
	s:EndDate["-" EndDate=$ZDH(EndDate,3)
	s:EndDate["/" EndDate=$ZDH(EndDate,4)
	s (Name,PAPMINO,Sex,Phone,Age)=""
	k AdmList
	
	//查询患者所有的就诊
	if PatientID'=""  d
	.s PatStr=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientID)
	.s Name=$P(PatStr,"^",3)
	.s PAPMINO=$P(PatStr,"^",2)
	.s Sex=$P(PatStr,"^",4)
	.s Phone=$P(PatStr,"^",25)
	.s Age=$P(PatStr,"^",5)
	.
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s AdmDate=$P($G(^PAADM(PAAdm)),"^",6)
	...s AdmList(AdmDate,PAAdm)=1
	
	//倒序输出就诊
	s AdmDateub=""
	f  s AdmDateub=$O(AdmList(AdmDateub),-1) Q:AdmDateub=""  d
	.s PAAdm=""
	.f  s PAAdm=$O(AdmList(AdmDateub,PAAdm),-1) Q:PAAdm=""  d
	..s AdmLoc=""
	..s AdmLocID=$P($G(^PAADM(PAAdm)),"^",4)
	..s:AdmLocID'="" AdmLoc=$P($G(^CTLOC(AdmLocID)),"^",2)
	..s AdmType=$P($G(^PAADM(PAAdm)),"^",2)
	..Q:"OEI"'[AdmType
	..s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"其他")
	..s AdmDoc=""
	..s AdmDocDr=$P($G(^PAADM(PAAdm)),"^",9)
	..s:AdmDocDr'="" AdmDoc=$P(^CTPCP(AdmDocDr,1),"^",2)
	..Q:(StartDate'="")&&(AdmDate<StartDate)
	..Q:(EndDate'="")&&(AdmDate>EndDate)
	..s:AdmDateub'="" AdmDate=$zd(AdmDateub,3)
	..s DCANum=0
	..s DCAID=0
	..f  s DCAID=$O(^DHCDocCure(0,"Adm",PAAdm,DCAID)) Q:DCAID=""  d
	...s Statu=$P(^DHCDocCure(DCAID),"^",3)
	...Q:Statu'="A"
	...s DCANum=(DCANum+1)
	..s DiaDesc=$$getAllDia(PAAdm)
	..d OutputRowAdm
	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowAdm
	
	set Data=$lb(PAAdm,PatientID,Name,PAPMINO,Sex,Phone,Age,AdmType,AdmLoc,AdmDoc,AdmDate,DCANum,DiaDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
getAllDia(Adm)
	s MrDiaDesc="" 
	s MrID=$P($G(^PAADM(Adm)),"^",61)
	s SubID=0
	f  s SubID=$O(^MR(MrID,"DIA",SubID)) Q:SubID=""  d
	.s Diagid=$P(^MR(MrID,"DIA",SubID),"^",1)
	.if Diagid'=""  d
	..if MrDiaDesc="" s MrDiaDesc=$P($G(^MRC("ID",Diagid)),"^",2)
	..else  s MrDiaDesc=MrDiaDesc_","_$P($G(^MRC("ID",Diagid)),"^",2)
	.else  d
	..s Note=$P(^MR(MrID,"DIA",SubID,"DES",1),"^",1)
	..Q:Note=""
	..if MrDiaDesc="" s MrDiaDesc=Note
	..else  s MrDiaDesc=MrDiaDesc_","_Note
	q MrDiaDesc
}

ClassMethod FindAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 治疗申请单查询医嘱项目使用
/// Table: 		   Arcim
/// Input：        Desc 项目描述 可以为空
/// 
Query FindArcim(Desc As %String = "") As %Query(ROWSPEC = "Arcim:%String,ArcimID:%String")
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindArcim","")
	s ^TMP("FindArcim")=Desc
	Set repid=$I(^CacheTemp)
	Set ind=1
	s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat")) 
	for i=1:1:$L(DHCDocCureItemCatStr,"^")  d
	.s SubCat=$P(DHCDocCureItemCatStr,"^",i)
	.Q:SubCat=""  
	.s Sub1=0
	.f  s Sub1=$O(^ARCIM(0,"ARCIC_DR",SubCat,Sub1)) Q:Sub1=""  d
	..s Sub2=0
	..f  s Sub2=$O(^ARCIM(0,"ARCIC_DR",SubCat,Sub1,Sub2)) Q:Sub2=""  d
	...s ArcimID=Sub1_"||"_Sub2
	...s Arcim=$P(^ARCIM(Sub1,Sub2,1),"^",2)
	...s stopdate=+$p($G(^ARCIM(Sub1,Sub2,7)),"^",1)
	...Q:(stopdate'=0)&&(stopdate<+$H)
	...s Find="N"
	...if Desc="" d
	....s Find="Y"
	...else  d
	....s Sub3=0
	....f  s Sub3=$O(^ARC("ALIAS",0,"ARCIM",Sub1_"||"_Sub2,Sub3)) Q:Sub3=""  d
	.....s SubDesc=$P(^ARC("ALIAS",Sub3),"^",6)
	.....if $E($ZCVT(SubDesc,"U"),1,$L($ZCVT(Desc,"U")))=$ZCVT(Desc,"U")  d
	......s Find="Y"
	....if Find="N"  d
	.....s:$E($ZCVT(Arcim,"U"),1,$L($ZCVT(Desc,"U")))=$ZCVT(Desc,"U") Find="Y"
	...Q:Find'="Y"
	...
	...d OutputRowArcim
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowArcim
	
	set Data=$lb(Arcim,ArcimID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 治疗申请单查询医嘱项目使用接收科室
/// Table: 		   Arcim
/// Input：        Desc 项目描述 可以为空
/// 
Query FindArcimReloc(ArcimID As %String = "", AdmID As %String = "", UserID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "RelocDesc:%String,Reloc:%String,selected:%Boolean")
{
}

ClassMethod FindArcimRelocExecute(ByRef qHandle As %Binary, ArcimID As %String = "", AdmID As %String = "", UserID As %String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^lxz1=ArcimID_","_AdmID_","_UserID_","_LocID
	///4893||1,,,110
	//d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindArcimReloc","4893||1","","",110)
	if (ArcimID'="")&&(LocID'="")  d
	.s CureLocStr=$g(^DHCDocConfig("DHCDocCureLocStr")) 
	.s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocID,ArcimID,"")
	.s Leng1=$L(RecLocStr,$C(2))
	.b ;1
	.//医嘱项目下医嘱接收科室
	.for i=1:1:Leng1  d
	..s SubReloc=$P(RecLocStr,$C(2),i)
	..s Reloc=$P(SubReloc,$C(1),1)
	..s RelocDesc=$P(SubReloc,$C(1),2)
	..s Default=$P(SubReloc,$C(1),3)
	..s Defaul=$case(Default,"Y":1,1:1,:0)
	..s Defaul=1
	..Q:("^"_CureLocStr_"^")'[("^"_Reloc_"^")
	..d OutputRowArcimRelLoc
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowArcimRelLoc
	set Data=$lb(RelocDesc,Reloc,Defaul)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindArcimRelocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimRelocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimRelocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimRelocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// lxz  生成治疗申请单 区别CreateCureApply 
/// dese：CreateCureApplyNew需要医生填写申请单  
/// CreateCureApply 的使用是医嘱录入反插入生成申请单
ClassMethod CreateCureApplyNew(InsertStr As %String) As %String
{
	n (InsertStr)
	s $ZT="ErrorCreat"
	s DCAAdmDR=$P(InsertStr,"^",1) ;就诊ID
	s DCAAppUserDR=$P(InsertStr,"^",2) ;治疗单申请人
	s AppLocDR=$P(InsertStr,"^",3) ;申请人科室
	s DCAAppDate=$P(InsertStr,"^",4) ;申请治疗开始日期
	s Remark=$P(InsertStr,"^",5) ;备注
	s DCAAppPlan=$P(InsertStr,"^",6) ;治疗计划
	s ArcimID=$P(InsertStr,"^",7) ;申请项目
	s ArcimReloc=$P(InsertStr,"^",8) ;接收科室
	s DCANum=+$P(InsertStr,"^",9) ;申请次数
	S:DCANum=0 DCANum=99999
	S DCAAppDate=$ZDH(DCAAppDate,3)
	
	
	s DCAStatus="A"
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	s NO=$I(^DHCDocCureApplay("NO",+$H))
	s DCANO=$tr($ZD(NowDate,3),"-","")_$E("0000",1,4-$L(NO))_NO ;申请单号
	
	/*&SQL(Insert into SQLUser.DHC_DocCureApp(
		DCA_Adm_DR,DCA_Status,DCA_AppUser_DR,DCA_AppLocDR,DCA_AppDate,DCA_UpdateUser_DR,
		DCA_UpdateDate,DCA_UpdateTime,DCA_Remark,DCA_AppPlan,DCA_Arcim,DCA_ReLoc,DCA_Num,
		DCA_NO
	) values(
		:DCAAdmDR,:DCAStatus,:DCAAppUserDR,:AppLocDR,:DCAAppDate,:DCAAppUserDR,
		:NowDate,:NowTime,:Remark,:DCAAppPlan,:ArcimID,:ArcimReloc,:DCANum,:DCANO)
	)
	if SQLCODE
	{
		q SQLCODE_"^"_""
	}*/
  	Q SQLCODE_"^"_%ROWID
ErrorCreat
	q "-1^"_$ZE
}

/// 更新治疗申请单信息用于填写治疗单的更新
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(867)
ClassMethod UpdateCureApply(DCARowId As %String, UserID As %String, UpdateStr As %String) As %String
{
	Quit:DCARowId="" "-1"
	;更新申请单
	s ApplyRemark=$P(UpdateStr,"^",1) 
	s ApplyPlan=$P(UpdateStr,"^",2) 
	s DCAAppDate=$P(UpdateStr,"^",3) 
	s ArcimID=$P(UpdateStr,"^",4)
	s ArcimReloc=$P(UpdateStr,"^",5)
	
	s DCAAppDate=$ZDH(DCAAppDate,3)
	k PLIST
	s PLIST(6)=DCAAppDate
	s PLIST(8)=UserID
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	s PLIST(11)=ApplyRemark
	s PLIST(12)=ApplyPlan
	s PLIST(13)=ArcimID
	s PLIST(14)=ArcimReloc
	
	&sql(update SQLUser.DHC_DocCureApp values :PLIST() where DCA_RowId=:DCARowId)
	Q SQLCODE
}

/// lxz 撤销 申请单 
ClassMethod CancelCureApplyNew(DCARowId As %String, UserID As %String) As %String
{
	Q:DCARowId="" "-1^订单信息不能传入为空"
	Q:'$D(^DHCDocCure(DCARowId)) "-1^不存在订单信息"
	Q:UserID="" "-1^操作员信息不存在"
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	Q:ApplyStatus="C" "-1^已经是撤销状态"
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	Q:ApplyStatus="F" "-1^已经完成的申请单不能撤销"
	
	s Str=..CheckData(DCARowId,"C")
	s FindArriveNum=+$P(Str,"^",2)
	Q:(FindArriveNum>0) "-1^申请单的预约治疗记录已经存在到达的记录，如有需要请联系治疗室设置申请记录为完成。不能进行撤销操作!"
	
	
	s Statu="C"
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status= :Statu,DCA_UpdateUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime where DCA_RowId=:DCARowId)
	q SQLCODE
}

/// lxz 完成 申请单 
ClassMethod FinishCureApply(DCARowId As %String, UserID As %String, Type As %String = "") As %String
{
	
	Q:DCARowId="" "-1^申请单信息不能为空"
	Q:'$D(^DHCDocCure(DCARowId)) "-1^不存在该申请单信息"
	Q:UserID="" "-1^操作员信息不存在"
	if Type="" s Type="F"
	s ret=..CheckData(DCARowId,Type)
	Q:ret'="" ret
	
	if Type="CF"{
		;撤消完成的时候 应该置为 A 还是 D
		s DHCDocCureNeedTriage=+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureNeedTriage"))
		if DHCDocCureNeedTriage=1{
			s Type="D"	
		}else{
			s Type="A"	
		}
	}
	
	s Statu=Type
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status= :Statu,DCA_UpdateUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime,DCA_FinishDate=:NowDate,DCA_FinishTime=:NowTime where DCA_RowId=:DCARowId)
	q SQLCODE
}

/// lxz 增加申请单医嘱记录  在选中预约记录的时候录入医嘱
/// input DCAARowId 预约ID  OrderID医嘱ID
ClassMethod InsertAppOrder(DCAARowId As %String, OrderID As %String) As %String
{
	s $ZT="InsertAppOrderError"
	n (DCAARowId,OrderID)
	Q:DCAARowId="" 0
	Q:OrderID="" 0
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	s ParRef=+DCAARowId
	s Adduser=$P(^OEORD(+OrderID,"I",$P(OrderID,"||",2),7),"^",2)
	&sql(insert into SQLUser.DHC_DocCureAppOrder 
	(DCAO_ParRef,DCAO_EORI_DR,DCAO_UpdateUserDR,DCAO_UpdateDate,DCAO_UpdateTime,DCAO_AplayDr)
	values(:ParRef,:OrderID,:Adduser,:NowDate,:NowTime,:DCAARowId)
	)
	q SQLCODE
InsertAppOrderError
	q 0
}

/// desc DCAARowId 申请单ID  Statu 将要设置的申请单状态 PAPMIID 患者ID InsertStr 申请单新增时的新增数据
/// 当Statu=A时申请单新增 匹配接收科室下是否还存在有效的申请单
/// 当Statu=C 或者F 的时候提示 申请单信息
/// w ##class(DHCDoc.DHCDocCure.Apply).CheckData("194","F")
ClassMethod CheckData(DCARowId As %String, Statu As %String, InsertStr As %String = "") As %String
{
	n (DCARowId,Statu,InsertStr)
	;s ^lxz1=DCAARowId_","_Statu_","_InsertStr
	Set CureData=$g(^DHCDocCure(DCARowId))
	if (Statu="A"){
		;插入预约单的时候查询是否存在相同接收科室的申请单
		s PAPMIID=""
		s DCAAdmDR=$P(InsertStr,"^",1) ;就诊ID
		s:DCAAdmDR'="" PAPMIID=$P($G(^PAADM(DCAAdmDR)),"^",1)
		s DCAAppUserDR=$P(InsertStr,"^",2) ;治疗单申请人
		s AppLocDR=$P(InsertStr,"^",3) ;申请人科室
		s DCAAppDate=$P(InsertStr,"^",4) ;申请治疗开始日期
		s Remark=$P(InsertStr,"^",5) ;备注
		s DCAAppPlan=$P(InsertStr,"^",6) ;治疗计划
		s ArcimID=$P(InsertStr,"^",7) ;申请项目
		s ArcimReloc=$P(InsertStr,"^",8) ;接收科室
		s DCANum=+$P(InsertStr,"^",9) ;申请次数
		s FindActiveFlag="N"
		if PAPMIID'=""  d
		.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
		..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
		...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
		...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
		....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		....Q:ApplyStatus'="A"
		....s Str=..GetCureApply(DCARowId)
		....s ApplayMes=$P(Str,$C(1),2)
		....s ApplyReloc=$P(ApplayMes,6)
		....if AppLocDR=AppLocDR  d
		.....s FindActiveFlag="Y"
		Q FindActiveFlag

	}elseif (Statu="C"){
		s ApplyStatus=$p(CureData,"^",3)
		;已完成的申请单不允许撤销
		Q:ApplyStatus="F" "101"
		;已撤销的申请单不允许撤销
		Q:ApplyStatus="C" "103"
		;已分配的申请单不允许撤销
		Q:ApplyStatus="D" "104"
		s count=0
		s CureOrderId=$p(CureData,"^",2)
		s OEOREChild=0
		for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) q:OEOREChild=""  d
		.s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		.s ChangeStatus=""
		.s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		.s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		.if ChangeStatus="F" s count=count+1
		;存在已执行的执行记录的申请单不允许撤销
		q:$g(count)>0 102	
		;当进生申请单的撤销或者完成操作的时候进行判断还有多少未到达的申请单预约记录
		s FindArriveNum=0
		s FinAppNum=0
		if DCARowId'=""  d
		.s AppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		.s FinAppNum=$p(AppInfo,"^",1)
		.s FindArriveNum=$p(AppInfo,"^",2)
		if (FinAppNum>0)!(FindArriveNum>0) Q 100
	}elseif (Statu="F"){
		s ApplyStatus=$p(CureData,"^",3)
		Q:ApplyStatus="F" "-101^该申请已经完成,不能再次完成."
		Q:ApplyStatus="C" "-103^已经撤销的申请单不能进行完成操作."
		
		s count=0
		s CureOrderId=$p(^DHCDocCure(DCARowId),"^",2)
		s OEOREChild=0
		for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) q:OEOREChild=""  d
		.s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		.s ChangeStatus=""
		.s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		.s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		.if ChangeStatus="" s count=count+1
		q:$g(count)>0 "-102^存在有效的未完成治疗记录."
		s FindArriveNum=0
		s FinAppNum=0
		if DCARowId'=""  d
		.s AppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		.s FinAppNum=$p(AppInfo,"^",1)
		.s FindArriveNum=$p(AppInfo,"^",2)
		if (FinAppNum-FindArriveNum>0) Q "104^存在未治疗的预约记录."
	}elseif (Statu="CF"){
		s ApplyStatus=$p(CureData,"^",3)
		Q:ApplyStatus'="F" "-101^该申请不是完成状态,无需撤消完成."
	}
	q ""
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 查询预约记录中录入的医嘱记录
/// Table: 		   DHC_DocCureAppOrder
/// Input：        DHCAARowID 预约记录ID
/// 
Query FindOrder(DHCAARowID As %String = "") As %Query(ROWSPEC = "OrderName:%String,statDesc:%String,OrderNum:%String,OrderBilled:%String,OrderRecDep:%String,UserAdd:%String,UserDepart:%String,DateTime:%String,Order:%String,DHCAOrdeID:%String,Adm:%String")
{
}

ClassMethod FindOrderExecute(ByRef qHandle As %Binary, DHCAARowID As %String) As %Status
{
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindOrder","")
	Set repid=$I(^CacheTemp)
	Set ind=1
	if +DHCAARowID'=0  d
	.Set CureData=$g(^DHCDocCure(+DHCAARowID))
	.Set Adm=$p(CureData,"^",1)
	.s SubOrderDi=0
	.f  s SubOrderDi=$O(^DHCDocCure(+DHCAARowID,"OrderApplayDr",DHCAARowID,SubOrderDi)) Q:SubOrderDi=""  d
	..s DHCAOrdeID=+DHCAARowID_"||"_SubOrderDi
	..s DataStr=$G(^DHCDocCure(+DHCAARowID,"Order",SubOrderDi))
	..s Order=$P(DataStr,"^",1)
	..Q:Order=""
	..s OrderID=+Order
	..s SubID=$P(Order,"||",2)
	..s Statu=$P(DataStr,"^",2)
	..s Adduser=$P(DataStr,"^",3)
	..s InsertDate=$P(DataStr,"^",4)
	..s InsertTime=$P(DataStr,"^",5)
	..s Mark=$P(DataStr,"^",6)
	..s ApplayID=$P(DataStr,"^",7)
	..s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	..s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2) 
	..s statcode="V"
	..s statDesc="核实"
	..s TtemStat=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",13) 
	..i TtemStat'="" d
	...s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	...s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2) 
	..s OrderBilled=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",5)
	..;下医嘱人
	..s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1) 
	..if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	..;下医嘱科室
	..s UserDepart=""  
	..s UserDepartId=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",2)
	..If UserDepartId'=""  d
	...Set UserDepart=$P($G(^CTLOC(UserDepartId)),"^",2)
	...if UserDepart["-" s UserDepart=$P(UserDepart,"-",2)
	..;接收科室
	..s OrderRecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6) ;OEORI_RecDep_DR
	..s OrderRecDep=""
	..if OrderRecDepRowid'="" s OrderRecDep=$P(^CTLOC(OrderRecDepRowid),"^",2)
	..if OrderRecDep["-" s OrderRecDep=$P(OrderRecDep,"-",2)
	..s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	..s OrderType=""
	..if ItemCatDr'="" d
	...s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	..s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4)
	..s OrderPackUOM=""
	..s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14)
	..s:ARCIMBillingUOM'="" OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOM),"^",2)
	..i OrderType'="R" d
	...s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	...s OrderPackQty=DoseqtySum
	..s OrderNum=OrderPackQty_OrderPackUOM
	..s OrderDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",7)	;下医嘱日期
	..if OrderDate'="" s OrderDate=$zd(OrderDate,3)
	..s OrderTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",17)	;下医嘱时间
	..S:OrderTime'="" OrderTime=$ZT(OrderTime,2)
	..s DateTime=OrderDate_" "_OrderTime
	..d OutputRowOrder
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowOrder
	
	set Data=$lb(OrderName,statDesc,OrderNum,OrderBilled,OrderRecDep,UserAdd,UserDepart,DateTime,Order,DHCAOrdeID,Adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// desc：取治疗关联科室配置(包含自身关联的其他科室以及关联到自身科室的科室)
/// Creator:nikang
/// CreateTime:20180313
/// Debug:w ##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(44)
ClassMethod GetLinkLoc(LocID)
{
	q:LocID="" ""
	s ret=""
	s RowID=""
	f  s RowID=$o(^DHCDocCureLinkLoci(0,"MAINLOC",LocID,RowID)) q:RowID=""  d
	.s LinkLocID=$p(^DHCDocCureLinkLoc(RowID),"^",2)
	.if ret="" s ret=LinkLocID
	.else  s ret=ret_"^"_LinkLocID
	s MainLocRowID=""
	f  s MainLocRowID=$o(^DHCDocCureLinkLoci(0,"LINKLOC",LocID,MainLocRowID)) q:MainLocRowID=""  d
	.if ret="" s ret=MainLocRowID
	.else  s ret=ret_"^"_MainLocRowID
	if ret="" s ret=LocID
	else  s ret=ret_"^"_LocID
	q ret
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "医嘱名称:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,医嘱子类:%String,价格:%String,基本药物:%String,计价单位:%String,库存数:%String,打包数:%String,通用名:%String,在途数:%String,收费规定:%String,医保类别:%String,自付比例:%String,接收科室:%String,代码:%String")
{
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItem","%lhn",100)
ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
  
   n OEOrderRS
  if Category'="on" 
  {
   set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
   d OEOrderRS.Execute(Item,GroupID,"","","","","","","","","","","",%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.HOSPID"),"")
   Set columns = OEOrderRS.GetColumnCount()
   If $SYSTEM.Status.IsOK(OEOrderRS)
   {
	   while (OEOrderRS.Next())
      {
	
		continue:OEOrderRS.GetData(4)="ARCOS"
		
		s Data=""	
		for i=1:1:columns {
			s $List(Data,i)=OEOrderRS.GetData(i)
		}
		s ArcimRowid1=OEOrderRS.GetData(2)
		s ItemCatRowid1=$p($g(^ARCIM(+ArcimRowid1,$p(ArcimRowid1,"||",2),1)),"^",10)
		continue:(SubCategory="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimRowid1)'=1)
		s $List(Data,17)=ItemCatRowid1
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
   
      }
   }
   d OEOrderRS.Close()
 
   s OEOrderRS=""
   }else{ 
   n OEOrderRS
   set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpItem")
   d OEOrderRS.Execute(Item,GroupID,"","","","ALL","","","","","","","","","","")
   Set columns = OEOrderRS.GetColumnCount()
   If $SYSTEM.Status.IsOK(OEOrderRS)
   {
	   while (OEOrderRS.Next())
      {
	
		continue:OEOrderRS.GetData(4)="ARCOS"
		
		s Data=""	
		for i=1:1:columns {
			s $List(Data,i)=OEOrderRS.GetData(i)
		}
		s ArcimRowid1=OEOrderRS.GetData(2)
		continue:(SubCategory="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimRowid1)'=1)
		s ItemCatRowid1=$p($g(^ARCIM(+ArcimRowid1,$p(ArcimRowid1,"||",2),1)),"^",10)
		s $List(Data,17)=ItemCatRowid1
		s $List(Data,20)=""
		s $List(Data,21)=OEOrderRS.GetData(20)
		s $List(Data,22)=OEOrderRS.GetData(21)
		s $List(Data,23)=OEOrderRS.GetData(22)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
   
      }
   }
   d OEOrderRS.Close()
   s OEOrderRS=""
   }
   Set QHandle=$lb(0,repid,0)
   Quit $$$OK
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindAllItem(Alias As %String, CureItemFlag As %String = "", GroupID As %Library.String = "", EpisodeID As %Library.String = "", UserRowId As %Library.String = "", ManualApply As %Library.String = "", SubCategory As %Library.String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean,DDCISRowid:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary, Alias As %String, CureItemFlag As %String = "", GroupID As %Library.String = "", EpisodeID As %Library.String = "", UserRowId As %Library.String = "", ManualApply As %Library.String = "", SubCategory As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAllItem","")
	s ^tmpnk("find")=Alias_","_CureItemFlag_","_SubCategory
	Set repid=$I(^CacheTemp)
	if (SubCategory="")&&(Alias="")	Set qHandle=$lb(0,repid,0) Quit $$$OK
	Set ind=1
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d rs1.Execute(Alias,GroupID,"",SubCategory,"","","",EpisodeID,"","",UserRowId)
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		s ARCIMType=rs1.GetData(4)
		;s str=$G(^ARCIM(+ArcimID,$P(ArcimID,"||",2),"DHC"))
		s DDCISRowid=$o(^DHCDocCureItemSet(0,"ItmMast",ArcimID,""))
		s FManualApply=""
		s:DDCISRowid'="" FManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
		continue:(ManualApply="on")&&(FManualApply'="Y")
		continue:(CureItemFlag="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimID)'=1)
		s selected=0
		continue:ARCIMType="ARCOS"
		d OutputRowFindAllItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	Set Data=$lb(ArcimID,ArcimDesc,selected,DDCISRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CombListFind(CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "") As %Query(ROWSPEC = "CombDesc:%String,CombValue:%String,selected:%Boolean")
{
}

ClassMethod CombListFindExecute(ByRef qHandle As %Binary, CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "") As %Status
{
	;s $ZT="ErrorCombListFind"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","CombListFind","DHCDocOrderRecLoc","","","0","4235","7")
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","CombListFind","SubCategory","","","0","4235","7")
	s ^tmpnk("CombListFindExecute",CombName)=CombName_"^"_Inpute1_"^"_Inpute2_"^"_Inpute3_"^"_Inpute4_"^"_Inpute5_"^"_Inpute6
	k TempList
	if (CombName="DHCDocOrderRecLoc"){
		s ARCIMRowid=Inpute1
		s OrderDepRowid=""
		s RecLocStr=""
		s EpisodeID=Inpute4
		s CurLogonDep=Inpute5
		i OrderDepRowid="" {
			i CurLogonDep'="" s CFRecLocByLogonLoc=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CurLogonDep,1)
		    i CFRecLocByLogonLoc=1 s OrderDepRowid=CurLogonDep
		}
		if (RecLocStr="")&&(ARCIMRowid'=""){
			i OrderDepRowid'="" s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(OrderDepRowid,ARCIMRowid,"")
			e  s RecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,ARCIMRowid,"")
		}
		;s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ARCIMRowid)
		s LenR=$L(RecLocStr,$c(2))
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(RecLocStr,$c(2),J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			continue:+(##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(SRowID))'=1
			s SDesc=$P(SUStr,$C(1),2)
			s Default=$P(SUStr,$C(1),3)
			if (Inpute3=1) {
				if (Inpute2=SRowID) s Default=1
				else  s Default=0
			}else{
				//if (Default="Y") s Default=1
			    //e  s Default=0
			    s Default=0 //默认or不默认？
			}
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default
		}
	}elseif(CombName="CureItemPlan"){
		;治疗方案模板
		s DefaultComb="0"
		s DDCISRowid=Inpute1
	 	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.CureItemSet:FindCureItemPlan")
	 	do rset.Execute(DDCISRowid)
	 	While (rset.Next()) {
			s CombDesc=rset.GetData(1)
			s CombValue=rset.GetData(3)
			s Sub=$O(TempList(""),-1)+1
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb
		}
	 	d rset.Close()
	}elseif(CombName="SubCategory"){
		;医嘱子类
		s DefaultComb="0"
	 	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindCatList")
	 	do rset.Execute()
	 	While (rset.Next()) {
		 	s CureFlag=rset.GetData(3)
		 	continue:CureFlag'=1
			s CombDesc=rset.GetData(2)
			s CombValue=rset.GetData(1)
			s Sub=$O(TempList(""),-1)+1
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb
		}
	 	d rset.Close()
	}elseif (CombName="OrderBillType"){
		s EpisodeID=Inpute1
		s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
		s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s PrescriptTypeStr=""
		s DefaultType=""
		if (BillTypeID'=""){
			s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType)
			// ^ 分割第二个为默认
			//1:自费;2:省医保^1:自费
			s DefaultType=$p(PrescriptTypeStr,"^",2)
			s PrescriptTypeStr=$p(PrescriptTypeStr,"^",1)
			if DefaultType'="" s DefaultType=$p(DefaultType,":",1)
		}
		;s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ARCIMRowid)
		s LenR=$L(PrescriptTypeStr,";")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(PrescriptTypeStr,";",J)
			s SRowID=$P(SUStr,":",1)
			Continue:SRowID=""
			s SDesc=$P(SUStr,":",2)
			s Default=0
			if (DefaultType=SRowID) s Default=1
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default
		}
	}
	
	//统一输出接口
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub0=0
 	f  s Sub0=$O(TempList(Sub0)) Q:Sub0=""  d
 	.s CombDesc=$P($G(TempList(Sub0)),"^",1)
 	.s CombValue=$P($G(TempList(Sub0)),"^",2)
 	.s DefaultComb=$P($G(TempList(Sub0)),"^",3)
 	.d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CombDesc,CombValue,DefaultComb)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ErrorCombListFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod CombListFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CombListFindExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CombListFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CombListFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      NIKANG
/// CreatDate：    2017-12-20
/// Description:： 治疗科室查询本科室治疗申请单列表
/// Table: 		  DHC_DocCureApp
/// Input：        EpisodeID:就诊ID
/// 
Query FindAllCureApplyListHUI(PatientID As %String, StartDate As %String, EndDate As %String, outCancel As %String = "", FinishDis As %String = "", PatName As %String = "", TriageFlag As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,ServiceGroup:%String,ServiceGroupID:%String,CallStatus:%String,ApplyExec:%String,ControlFlag:%String,HistoryTriRes:%String,PatOther:%String,OrdUnitPrice:%String,ApplyNo:%String")
{
}

/// 入参TriageFlag："Y",表示分诊台查询申请单调用Query，outCancel为界面勾选已分配标示，FinishDis为界面勾选全部标示
/// 入参TriageFlag："", 表示预约工作台查询申请单调用Query，outCancel为界面勾选已取消标示，FinishDis为界面勾选完成标示
/// 入参TriageFlag："ALL", 表示治疗患者信息查询,不做权限控制
ClassMethod FindAllCureApplyListHUIExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String, outCancel As %String = "", FinishDis As %String = "", PatName As %String = "", TriageFlag As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAllCureApplyListHUI","","2018-06-11","","","","once","N","7","4636")
	s ^TMP("FindAllCureApplyList")=$lb(PatientID,StartDate,EndDate,outCancel,FinishDis,PatName,TriageFlag,LogLocID,LogUserID,ApplyNo,LongOrdPriority)
	Set repid=$I(^CacheTemp)
	Set ind=1
	s DHCDocCureNeedTriage=+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureNeedTriage"))
	if (TriageFlag="Y")&&(DHCDocCureNeedTriage=0){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK	
	}
	;if $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,1)
	;else  if $l(StartDate,"-")=3  s StartDate=$zdh(StartDate,3)
	s DateFormat=##class(websys.Conversions).DateFormat()
	if StartDate'="" s StartDate=$zdh(StartDate,DateFormat)
	;else  s StartDate=+$h
	;if $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,1)
	;else  if $l(EndDate,"-")=3  s EndDate=$zdh(EndDate,3)
	if EndDate'="" s EndDate=$zdh(EndDate,DateFormat)
	;else  s EndDate=+$h
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
	s LogLocIDStr=..GetLinkLoc(LogLocID)
	;按登记号查询
	if PatientID'=""  d
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...Q:'$d(^DHCDocCure(0,"Adm",PAAdm))
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	....Quit:AdmVisitStatus="C"
	....s QuitFlag=$$CheckQuit()
	....Q:QuitFlag=1
	....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	....Quit:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
	....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	....d OutputRowFindAllCureApplyHUI
	if PatientID'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;按治疗申请单号查询
	if ApplyNo'=""  d
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"AppNo",ApplyNo,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..s QuitFlag=$$CheckQuit()
	..Q:QuitFlag=1
	..d OutputRowFindAllCureApplyHUI
	if ApplyNo'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;按长嘱当日需执行医嘱查询,无需按日期检索,但随着日期及数据量的增大，该索引效率会越来越差
	if LongOrdPriority="Y" d
	.s LOrdItemID=0 for  s LOrdItemID=$o(^DHCDocCure(0,"LONGOEORI",LOrdItemID)) q:LOrdItemID=""  d
	..s OrderStatusCode=""
	..s OrdStatusDR=$p($g(^OEORD(+LOrdItemID,"I",+$p(LOrdItemID,"||",2),1)),"^",13)
	..s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	..Q:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
	..s FindNull="1"
	..s ExecID=0
	..f  s ExecID=$O(^OEORDi(0,"OrdItem",+LOrdItemID,$P(LOrdItemID,"||",2),+$H,ExecID)) Q:ExecID=""  d
	...s FindNull="0"
	..Q:FindNull="1" ;当日没有需要执行的执行记录退出
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"LONGOEORI",LOrdItemID,DCARowId)) q:DCARowId=""  d
	...s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	...s QuitFlag=$$CheckQuit()
	...Q:QuitFlag=1
	...d OutputRowFindAllCureApplyHUI
	if LongOrdPriority="Y" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;按姓名查询
	if PatName'=""  d
	.s PatName=$tr(PatName," ","")
	.s PatName=$zcvt(PatName,"U")
	.s PersonRowId=""
	.for PersonRowId=$o(^PAPERi("PAPER_PatName",PatName,PersonRowId)) q:PersonRowId=""  d
	..Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	...Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	....Q:'$d(^DHCDocCure(0,"Adm",PAAdm))
	....s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	.....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	.....s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	.....Quit:AdmVisitStatus="C"
	.....s QuitFlag=$$CheckQuit()
	.....Q:QuitFlag=1
	.....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	.....Quit:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
	.....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	.....d OutputRowFindAllCureApplyHUI
	if PatName'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;按日期查询
	s:StartDate="" StartDate=+$h
	s:EndDate="" EndDate=+$h
	For QueryDate=StartDate:1:EndDate Do
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..s QuitFlag=$$CheckQuit()
	..Q:QuitFlag=1
	..d OutputRowFindAllCureApplyHUI
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
CheckQuit()
	s QuitFlag=0
	if TriageFlag="ALL" Q QuitFlag
	;分诊界面查询
	if TriageFlag="Y" d
	.s:(outCancel="Y")&(ApplyStatus'="D") QuitFlag=1 ;已分配
	.s:(FinishDis="Y")&(ApplyStatus'="A")&(ApplyStatus'="D") QuitFlag=1 ;全部查询
	.s:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A")) QuitFlag=1 ;界面不勾选,只查未分配
	;预约界面查询
	else  d
	.s:'(##class(DHCDoc.DHCDocCure.Apply).CheckCureApplyPermission(DCARowId,LogLocID,LogUserID)) QuitFlag=1
	.if (DHCDocCureNeedTriage=1) d
	..s:(outCancel="Y")&(ApplyStatus'="C") QuitFlag=1 ;已撤销
	..s:(FinishDis="Y")&(ApplyStatus'="F") QuitFlag=1 ;完成
	..s:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="D")) QuitFlag=1 ;界面不勾选,只查已分配
	.else  d
	..s:(outCancel="Y")&(ApplyStatus'="C") QuitFlag=1 ;已撤销
	..s:(FinishDis="Y")&(ApplyStatus'="F") QuitFlag=1 ;完成
	..s:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A")) QuitFlag=1 ;界面不勾选,只查预约
	q QuitFlag
OutputRowFindAllCureApplyHUI
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'="" d
	.s AdmType=$P(^PAADM(Adm),"^",2)
	.s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	.s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	.if AdmDep["-" s AdmDep=$p(AdmDep,"-",2)
	s rtn=..GetCureApply(DCARowId,"1")
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	;Q:OrdReLocId'=%session.Get("LOGON.CTLOCID")
	Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_OrdReLocId_"^"))
	s CureApplyNo=$p(CureAppInfo,"^",31) 
	Q:(ApplyNo'="")&&(ApplyNo'=CureApplyNo)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) 
	s OrdPrice=$p(CureAppInfo,"^",17) 
	s OrdBilled=$p(CureAppInfo,"^",18) 
	s OrdUnitPrice=$p(CureAppInfo,"^",19) 
	s ServiceGroup=$p(CureAppInfo,"^",21) 
	s CallStatus=$p(CureAppInfo,"^",22) 
	s ApplyExec=$p(CureAppInfo,"^",23) 
	s ControlFlag=$p(CureAppInfo,"^",24) 
	s HisToryTriRes=$p(CureAppInfo,"^",25) 
	if PatientTel="" s PatientTel="-"
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType_"("_AdmDep_")"
	s DDCRSServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(ServiceGroup)),"^",2)
	set Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,DDCRSServiceGroupDesc,ServiceGroup,CallStatus,ApplyExec,ControlFlag,HisToryTriRes,PatOther,OrdUnitPrice,CureApplyNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindAllCureApplyListHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllCureApplyListHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllCureApplyListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllCureApplyListHUIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      nikang
/// CreatDate：    2017-12-20
/// Description:： 查询单个病人治疗申请单列表
/// Table: 		  DHC_DocCureApp
/// Input：        EpisodeID:就诊ID
/// 
Query FindCureApplyListHUI(EpisodeID As %String) As %Query(ROWSPEC = "DCARowId:%String,ArcimDesc:%String,OrdStatus:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,OrdReLocId:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String")
{
}

ClassMethod FindCureApplyListHUIExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindCureApplyList",1425)
	Set repid=$I(^CacheTemp)
	Set ind=1
	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=..GetLinkLoc(LogLocID)
	s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",EpisodeID,DCARowId)) q:DCARowId=""  d
	.s rtn=..GetCureApply(DCARowId,"1")
	.Q:rtn="" 
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s OrderStatus=$p(CureAppInfo,"^",2)
	.s OrderQty=$p(CureAppInfo,"^",3)
	.s BillingUOM=$p(CureAppInfo,"^",4)
	.s OrderReLoc=$p(CureAppInfo,"^",5)
	.s OrdReLocId=$p(CureAppInfo,"^",6)
	.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_OrdReLocId_"^"))
	.s ApplyStatus=$p(CureAppInfo,"^",7)
	.s ApplyUser=$p(CureAppInfo,"^",8)
	.s ApplyDate=$p(CureAppInfo,"^",9)
	.s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	.s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	.s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	.s ApplyNoFinishTimes=$p(CureAppInfo,"^",13)
	.s OrdPrice=$p(CureAppInfo,"^",17)
	.s OrdBilled=$p(CureAppInfo,"^",18)
	.d OutputRowApplyHUI
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApplyHUI 
	set Data=$lb(DCARowId,ArcimDesc,OrderStatus,OrderQty,BillingUOM,OrderReLoc,OrdReLocId,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureApplyListHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyListHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyListHUIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCureApplyNo(DCARowId As %String)
{
	N (DCARowId)
	Set CureData=$g(^DHCDocCure(DCARowId))
	s ApplyNo=$p(CureData,"^",18)
	Q ApplyNo
}

}
