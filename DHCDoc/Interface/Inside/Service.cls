/// creator:guorongyong
/// date:2016-07-13
/// desc:和东华内部系统的接口类【主要是提供给其他产品组的接口】,仅医生站,不包括建卡,挂号,分诊与内部的接口
Class DHCDoc.Interface.Inside.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:      郭荣勇
/// CreatDate:    2018.08.14
/// Description:  获取门急诊医嘱先诊疗后付费标识(执行科室在医嘱未收费情况下按此接口判断是否可执行)
/// Table:        
/// Input:        OEORIRowId:医嘱明细表RowId,	ExpStr：待扩展(以^分割)
/// Return:       flag^msg; flag:Y 是,N 不是; msg:成功或错误信息
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetPreCureAfterPayFlag("2||1")
ClassMethod GetPreCureAfterPayFlag(OEORIRowId As %String, ExpStr As %String = "")
{
	n (OEORIRowId,ExpStr)
	s $zt="GetPreCureAfterPayFlagErr"
	Q:OEORIRowId="" $$SetOutMsg("N","OEORIRowId参数不能为空")
	s Adm=$p(^OEORD(+OEORIRowId),"^",1)
	s AdmReasonDR=$p(^PAADM(Adm,1),"^",7)
	s Ord=+OEORIRowId,Chl=$p(OEORIRowId,"||",2)
	;判断留观
	s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	if (" 1 2 "[(" "_StayStatus_" ")) Q $$SetOutMsg("Y","留观状态患者后付费")
	
	;判断先诊疗后收费统一设置,有风险,暂不放开
	;s OrderReadyToBillFlag=##class(web.DHCDocConfig).GetConfigNode("OrderReadyToBillFlag")
	;if OrderReadyToBillFlag=1 Q $$SetOutMsg("Y","全院统一先诊疗后付费开关已打开")
	
	;判断医嘱先诊疗后付费标识(急诊押金结算标识等)
	s OEORIReadyToBillFlag=$P($g(^OEORD(Ord,"I",Chl,12)),"^",26)
	if OEORIReadyToBillFlag="Y" Q $$SetOutMsg("Y","医嘱先诊疗后付费标识(急诊押金结算标识等)")
	
	;是否急诊绿色通道就诊(新产品组提供接口)
	s GreenRecFlag=##class(web.DHCEMInterfaceCom).checkGreenRec(Adm)
	if GreenRecFlag=1 Q $$SetOutMsg("Y","急诊绿色通道就诊")
	
	q $$SetOutMsg("N","不是先诊疗后付费医嘱")

	
SetOutMsg(flag,msg)
	Q flag_"^"_msg
GetPreCureAfterPayFlagErr
	Q $$SetOutMsg("N","程序异常:"_$zerror)
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  产生检验条码和处方号
/// Table:        
/// Input:        AdmId:就诊RowId   UserID:用户ID	ExpStr：就诊科室Rowid(CT_Loc)^
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GenPresno("747886||227") 
ClassMethod GenPresno(AdmId As %String, UserId As %String, ExpStr As %String = "")
{
	n (AdmId,UserId,ExpStr)
	
	Set AdmLocId=$p(^PAADM(AdmId),"^",4)
	Set AutoPresc=$$getconfignode^DHCDocConfig("PrescByAuto")
	if AutoPresc="1" Do presno3^DHCaOET1(AdmId,UserId,AdmLocId)
	e  d presno1^DHCaOET1(AdmId,UserId,AdmLocId)
	
	q
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  【私有接口,未经产品组允许不得使用】更新医嘱信息【接收科室,】
/// Table:        
/// Input:        oeitm:医嘱RowId   UserID:用户ID
/// Return:       0 成功; 非0 不成功
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).UpdateOEORI("747886||227") 
ClassMethod UpdateOEORI(OEORIRowId As %String, UserId As %String, NewInfo As %String) As %String
{
	n (OEORIRowId,UserId,NewInfo)
	Q:NewInfo="" 0
	Q:OEORIRowId="" "-1"
	Q:$l(OEORIRowId,"||")'=2 "-2"
	
	;接收科室ID
	s RecDepId=$p(NewInfo,"^",1)
    &sql(Update SQLUser.OE_OrdItem set OEORI_RecDep_DR=:RecDepId Where OEORI_RowId=:OEORIRowId)
    if SQLCODE {
	    d ##class(DHCDoc.Log.Common).General("Update","DHCDoc.Interface.Inside.Service","UpdateOEORI","更新医嘱信息失败",OEORIRowId,"SQL错误信息:"_$g(%mdiag(1)))
    }
    
    Q SQLCODE
}

/// lxz 
/// desc 获取身份证设备硬件参数
/// OutPut 设备参数配置ID^设备描述
/// w ##class(DHCDoc.Interface.Inside.Service).GetIECreat()
ClassMethod GetIECreat() As %String
{
	s Str=""
	s myGRowID=$o(^DHCCARDHARDCOMi("GROUP",0,"IE",0))
	s myMRowID=0
	f  s myMRowID=$o(^DHCCARDHARDCOMi("MANAGER",0,"CG",myGRowID,myMRowID))  q:(myMRowID="")  d
	.s myDateTo=+$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",15)
	.q:((+myDateTo'=0)&&(myDateTo<+$h))
	.s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)
	.s myMDesc=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",2)
	.s myHCTypeDR=myMRowID
	.s Str=myMRowID_"^"_myMDesc
	q Str
}

ClassMethod FindEMROPItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 入参：就诊号，草药标识:CHMED 为草药,"" 为西药,Business：业务代码(SaveOrder/Finish)
/// 出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
ClassMethod FindEMROPItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Status
{
 	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems",11150695,"")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	if CHMEDFlag="CHMED" {
	 	;得到草药数据
	 	d getCHMEDEMRData()
 	}else{
	 	;得到非草药数据
	 	d getEMRData()
 	}
	
	s SeqNo=0
	s adm=0 for  s adm=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm)) q:adm=""  d
	.s mas=0 for  s mas=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)) q:mas=""  d
	.. s s1=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)
	.. q:s1=""
	.. i s1'="" d 
	.. .s SeqNo=SeqNo+1
	.. .s $List(s1,24)=SeqNo
	.. .s Data=s1
	.. .d OutputRow4
	.. s SubSeqCount=0
	.. s sub=0  for  s sub=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)) q:sub=""  d
	.. . s s2=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)
	.. . i s1="" d
	.. . . s SeqNo= SeqNo+1
	.. . . s $List(s2,24)=SeqNo
	.. . . s Data=s2
	.. . . d OutputRow4
	.. . e  d
	.. . . s SubSeqCount=SubSeqCount+1
	.. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	.. . . s $List(s2,24)=SubSeqNo
	.. . . s Data=s2
	.. . . d OutputRow4
	 K ^CacheTemp("DHCAdmOrdItem",$j,"adm")
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
getEMRData()
	s ret=""
	Set OrderId=$o(^OEORD(0,"Adm",EpisodeID,0))
	if OrderId="" Quit ""
	Set sub=0
	for  Set sub=$o(^OEORD(OrderId,"I",sub)) Quit:sub=""  do
	.d GetOrdItemInfo(OrderId,sub)
 	
 	q
GetOrdItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""
	;检验自动绑定上的医嘱不显示
	s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
	Q:LinkLabNo'="" ""
	;留观医生下的医嘱不同步到病历
	s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
	Q:EMStayFlag="1"
	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	 
 	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s ReqPartDesc=##Class(web.DHCEMInterface).GetExaReqPartDesc(OrderId_"||"_sub)
 	if (ReqPartDesc'="") s OrderName=OrderName_ReqPartDesc
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=$zt(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	i OrderDoseUOMRowid'="" D
 	.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
	Q:(PHPrescType=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"
	e  s TypeClass="其他"
	
	s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(OrderId_"||"_sub)
	s skintestremark=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrderId_"||"_sub)
    s:skintestremark'="" ordremark=skintestremark_" "_ordremark
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s qty=""
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s:dsp'="" qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc*/
	
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderChl)=Data1
	e  d
	.if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)) d
	..s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)=""
	.s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
 	q 1
IsMedicalRecords(OEORI)
	s ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	;是否上医嘱单,统一调用护理组方法判断
	;s rtn=##class(web.DHCNurseInterface).IfInOrderSheet(OEORI)
	;i rtn'="Y" q 0
	s OrderCategory=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",10)
	i ItemCatDR'="" {
		s OrderCategoryDR=$P(^ARC("IC",ItemCatDR),"^",8)
		i OrderCategoryDR'="" s OrderCategory=$p(^OEC("ORCAT",OrderCategoryDR),"^",2)
	}
	s OEORIBindSource=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC"),"^",41)
	Q:OEORIBindSource'="" 0
	;材料不上医嘱单
	;i OrderCategory["材料" q 0
	
	;特殊的一些项目不上医嘱单,特殊处理
	i $g(^DHCDocLocalSysP("OPDoc.MedicalRecords.SpecARCIM"))[("^"_ARCIM_"^") q 0
	
	q 1
getCHMEDEMRData()
	s QUE1RowID=""
	f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
	.q:'$d(^PAQUE1(QUE1RowID))
	.q:'$d(^PAQUE1(QUE1RowID,"DHC"))
	.s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
    .q:prestype'=3
    .//非医护人员录入不显示
	.s AddUser=$P(^PAQUE1(QUE1RowID,"DHC"),"^",3)
	.s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
	.s CareProvType=$zcvt(CareProvType,"U")
	.q:CareProvType'="DOCTOR"
	.s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
	.s insdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",11)
    .s Instruc=""
    .i insdr'="" s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
    .s durdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",10)
    .s facotor=""
    .i durdr'="" s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    .s orderqty=$p(^PAQUE1(QUE1RowID,"DHC"),"^",13) ;用量
    .s CHMEDNotes="共"_facotor_"剂"_"  用法:"_Instruc_"   一次用量:"_orderqty
	.s OEORDRowId="",prescOrdNum=0, Ordret="",stopflag=0
	.f  s OEORDRowId=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub="" 
	..f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
	...s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    ...q:ItemStat="4"
	...d getCHOrderItemInfo(OEORDRowId,OEORIChildsub)
	
	q
getCHOrderItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""

	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	
	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=$zt(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	;s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	;i OrderDoseUOMRowid'="" D
 	;.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
    if Phcdf'="" s OrderDoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),OrderDoseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderDoseUOMRowid)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
	Q:(PHPrescType'=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"	s ArcService=""	
	e  s TypeClass="其他"
	///e  i (" Service S ")[(" "_ServerMaterial_" ") s TypeClass="检查"
	s ordremark=OrderDepProcNote
	s skintestremark=""
	s actiondr=$p(^OEORD(OrderId,"I",sub,11),"^",21) 
	i actiondr'="" s skintestremark=$p(^OEC("ACT",actiondr),"^",2)
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc_" "_Spec*/
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderChl)=Data1
	e  d
	.if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)) d
	..s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)=""
	.s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
	q	
	 
OutputRow4
	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindEMROPItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2018.03.14
/// Description:  【私有接口,定向,电子病历组调用】提供医嘱数据数据给门诊电子病历【仅限门诊】
/// Table:        
/// Input:        入参：就诊号，是否草药标识(CHMED 为草药,空 为非草药)，业务代码(SaveOrder/Finish)
/// Return:       出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","166","","")
Query FindEMROPItems(EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,ordremark:%String,skintestremark:%String,TypeClass:%String,CHMEDNotes:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","5","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MRADMID="" {  
	    d ResetDiagnosListVar
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	Set rsObj=##Class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")
	If rsObj.QueryIsValid() { 
		 Set Status=rsObj.Execute(MRADMID,ICDType,DiagnosTypeCode)
		 If 'Status Quit
		 While rsObj.Next() {
			 Set DiagnosDesc=rsObj.GetData(1)
			 Set DiagnosValue=rsObj.GetData(2)
			 Set DiagnosCodeRowid=rsObj.GetData(3)
			 Set DiagnosMRDesc=rsObj.GetData(4)
			 Set DiagnosICDCode=rsObj.GetData(5)
			 Set DiagnosType=rsObj.GetData(6)
			 Set DiagnosDate=rsObj.GetData(7)
			 Set DiagnosOnsetDate=rsObj.GetData(8)
			 Set DiagStat=rsObj.GetData(9)
			 Set DiagnosLeavel=rsObj.GetData(10)
			 Set MainDiagFlag=rsObj.GetData(11)
			 
			 ;w !,DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag
 			 ;ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期 诊断状态 诊断级别 主诊断标识(Y/N)
			 d DiagnosListOutput
		 }
	}
	kill rsObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DiagnosListOutput
	set Data=$lb(DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag)  //
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetDiagnosListVar
	set (DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosNote,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag)=""
	quit
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2018.03.20
/// Description:  获取本次就诊诊断记录
/// Table:        
/// Input:        入参：MR_Adm表Rowid，是否获取中医诊断.(1 中医,空或0 西医)，诊断类型代码.(空 获取全部,不为空 获取指定诊断代码的诊断)
/// Return:       出参：ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期 诊断状态描述 诊断级别(数字)
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","166","","")
Query DiagnosList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %Query(ROWSPEC = "DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate:%String,DiagStat:%String,DiagnosLeavel:%String,MainDiagFlag:%String")
{
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.23
/// Description:  【私有接口,未经产品组允许不得使用】批量替换医嘱套中的医嘱项目
/// Table:        
/// Input:        入参：需要替换的医嘱项id，新医嘱项id
/// Return:       出参：0 成功；非0失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).ReplaceARCOSItem("747886||227") 
ClassMethod ReplaceARCOSItem(OldArcimRowID As %String, NewArcimRowID As %String) As %String
{
	n (OldArcimRowID, NewArcimRowID)
	s ret=##Class(web.DHCArcositm).upacosarcim(OldArcimRowID, NewArcimRowID)
	q ret
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.23
/// Description:  【私有接口,未经产品组允许不得使用】批量替换医嘱模板中的医嘱项目
/// Table:        
/// Input:        入参：需要替换的医嘱项id，新医嘱项id
/// Return:       出参：0 成功；非0失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).ReplacePreferItem("836||1","1346||1") 
ClassMethod ReplacePreferItem(OldArcimRowID As %String, NewArcimRowID As %String) As %String
{
	n (OldArcimRowID, NewArcimRowID)
	s ret=0
	k OutPutData
 	s groupitemDelim=$C(28)
	s itemdataDelim=$C(4)
	s tabgroupDelim=$C(1)
 	s AppKeyDesc="%ORDER%"
	&sql(declare QueryPrefer cursor  for 
		select distinct ID,AppKey,AppSubKey,Data,ObjectReference,ObjectType
    	from websys.Preferences WHERE (AppKey like :AppKeyDesc))
	&sql(open QueryPrefer)
	for{
		&sql(fetch QueryPrefer into :ID,:AppKey,:AppSubKey,:Data,:ObjectReference,:ObjectType)
		q:SQLCODE
		s TABLIST=$lg(Data,3)
		for i=1:1:$listlength(TABLIST){
			s TABLIST(i)=$listget(TABLIST,i)
		}
		///TABLIST()存储的表列表数据
		///先遍历表列表
		s LISTTabsRowID=0
		for {
			s LISTTabsRowID=$o(TABLIST(LISTTabsRowID))
			q:LISTTabsRowID=""
			s Desc=$P(TABLIST(LISTTabsRowID),tabgroupDelim,1)
			if (TABLIST(LISTTabsRowID)[("ARCIM"_$c(4)_OldArcimRowID)){
				s OutPutData($o(OutPutData(""),-1)+1)=ID_"||"_LISTTabsRowID_"^"_Desc_"^"_ObjectReference_"^"_ObjectType
			}
		}
	}
	&sql(close QueryPrefer)
	s Index=0
	for {
		s Index=$O(OutPutData(Index))
		q:Index=""
		s val=$G(OutPutData(Index))
		s IDStr=$P(val,"^",1)
		s RowID=$p(IDStr,"||",1)
		s LISTTabsRowID=$p(IDStr,"||",2)
		
		s obj=##Class(websys.Preferences).%OpenId(RowID)
		continue:('$IsObject(obj))
		s Data=obj.Data
		s TABLIST=$lg(Data,3)
		///TABLIST()存储的表列表数据
		for i=1:1:$listlength(TABLIST){
			s TABLIST(i)=$listget(TABLIST,i)
		}
		continue:'$d(TABLIST(LISTTabsRowID)) //"-5^表列表数据不存在"
		continue:(TABLIST(LISTTabsRowID)'[("ARCIM"_$c(4)_OldArcimRowID)) //"-10^表列表数据中未查询到原始医嘱"
		s TABLIST(LISTTabsRowID)=$replace(TABLIST(LISTTabsRowID),"ARCIM"_$c(4)_OldArcimRowID,"ARCIM"_$c(4)_NewArcimRowID)
		s $list(TABLIST,LISTTabsRowID)=TABLIST(LISTTabsRowID)
		s $list(Data,3)=TABLIST
		s obj.Data=Data
		
		s save=obj.%Save(0)
		d obj.%Close()
		i (save'=1){
			s ret=ret=1
		}
	}
	q ret
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.29
/// Description:  获取病人过敏信息
/// Table:        
/// Input:        入参：PatientID患者主索引ID
/// Return:       出参：见文档《HIS标准接口定义.doc》
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","166")
Query Allergies(PatientID As %String) As websys.Query(ROWSPEC = "RowID:%String,Category:%String,Allergen:%String,ALGItem:%String,tag:%String,ALGItemRowID:%String,NatureOfReaction:%String,Severity:%String,SeverityColour:%String,OnsetDate:%Date,OnsetDateFreeText:%String,CareProvider:%String,InActive:%Boolean,OnsetDateText:%String,RowHexColour:%String,LastUpdateDate:%Date,LastUpdateTime:%Time,LastUpdateUser:%String,LastUpdateHospital:%String,Status:%String,ExternalID:%String,LastUpdateUserRole:%String,LastUpdateUserId:%String,Comments:%String,ALGFreeTextAllergy:%String,DrugSpecific:%Boolean,ALGDSReportFlag:%Boolean,HiddenFields:%String")
{
}

ClassMethod AllergiesExecute(ByRef qHandle As %Binary, PatientID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","142")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if PatientID="" {  
	    d ResetAllergiesVar
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set rsObj=##Class(%ResultSet).%New("web.DHCPAAllergy:Allergies")
	If rsObj.QueryIsValid() {
		 Set Status=rsObj.Execute(PatientID)
		 If 'Status Quit
		 While rsObj.Next() {
			s RowID=rsObj.GetData(1)
			//过敏分类
			s Category=rsObj.GetData(2)
			//自定义过敏分类
			s Allergen=rsObj.GetData(3)
			//过敏源名称
			s ALGItem=rsObj.GetData(4)
			//分类
			s tag=rsObj.GetData(25)
			s ALGItemRowID=""
			s ALGTypeDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",9)	;PACAllergy
			s ALGPHCGEDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",4) ;通用名 PHC_Generic
			s ALGPHCDMDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",27) ;药学项 PHC_DrgMast
			s:ALGTypeDR'="" ALGItemRowID=ALGTypeDR
			s:ALGPHCGEDR'="" ALGItemRowID=ALGPHCGEDR,tag="G"
			s:ALGPHCDMDR'="" ALGItemRowID=ALGPHCDMDR,tag="P"
			//拮抗反应
			s NatureOfReaction=rsObj.GetData(5)
			//严重
			s Severity=rsObj.GetData(6)
			//严重颜色
			s SeverityColour=rsObj.GetData(7)
			//发作日期-系统日期
			s OnsetDate=rsObj.GetData(8)
			//发作日期文字补充
			s OnsetDateFreeText=rsObj.GetData(9)
			//医护人员
			s CareProvider=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",1)
			if (CareProvider'=""){
				s CareProvider=$P($G(^CTPCP(CareProvider,1)),"^",2)
			}
			//未激活标志 Y/N
			s InActive=rsObj.GetData(11)
			//发作日期描述
			s OnsetDateText=rsObj.GetData(12)
			//不明
			s RowHexColour=rsObj.GetData(13)
			//最近一次更新日期
			s LastUpdateDate=rsObj.GetData(14)
			//最近一次更新时间
			s LastUpdateTime=rsObj.GetData(15)
			//最近一次更新人
			s LastUpdateUser=rsObj.GetData(16)
			//最近一次更新医院描述
			s LastUpdateHospital=rsObj.GetData(17)
			//状态
			s Status=rsObj.GetData(18)
			s Status=##class(websys.StandardTypeItem).GetDescription("AllergyStatus",Status)
			//医嘱项id
			s ExternalID=rsObj.GetData(19)
			//最后更新用户
			s LastUpdateUserRole=rsObj.GetData(20)
			//最后更新用户ID
			s LastUpdateUserId=rsObj.GetData(21)
			//过敏情况补充
			s Comments=rsObj.GetData(22)
			//
			s ALGFreeTextAllergy=rsObj.GetData(23)
			//是否药品YN
			s DrugSpecific=rsObj.GetData(24)
			//不明
			s ALGDSReportFlag=rsObj.GetData(26)
			//不明
			s HiddenFields=rsObj.GetData(27)
			 
			d AllergiesOutput
		}
	}
	kill rsObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AllergiesOutput
	set Data=$lb(RowID,Category,Allergen,ALGItem,ALGItemRowID,tag,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,ALGDSReportFlag,HiddenFields)  //
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetAllergiesVar
	set (RowID,Category,Allergen,ALGItem,ALGItemRowID,tag,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,ALGDSReportFlag,HiddenFields)=""
	quit
}

/// Creator:      谭吉善
/// CreatDate:    2018.05.02
/// Description:  医保控费获取医嘱信息接口方法
/// Table:        
/// Input:        OEORIRowId:医嘱ID
/// Return:       中草药单复方标志(0是单方，1是复方)^给药途径代码^给药途径描述(口服、注射等)^药品标志(Y为药品)^处方号^用药天数^出院带药标志^处方费别
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GenOrdInfoByInsuCost("91||201") 
ClassMethod GenOrdInfoByInsuCost(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	s OrderID=$P(OEORIRowId,"||",1)
	s SubID=$P(OEORIRowId,"||",2)
	q:(SubID="")||(OrderID="") ""
	q:'$D(^OEORD(OrderID,"I",SubID,1)) ""
	s ARCIMRowID=$p(^OEORD(OrderID,"I",SubID,1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s IsCNMedItem=##Class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowID)
	s OrderPrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14)
	s OrderPrescSeqNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",15)
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	s OrderDurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6) ;OEORI_Durat_DR
	s OrderInstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7) ; OEORI_Instr_DR
	s PriorityDR = $p($g(^OEORD(OrderID,"I",SubID,1)),"^",8)
	s OrderBillTypeRowid=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18)
	
	s SDFlag=0
	if (IsCNMedItem=1)&&($P(OrderPrescSeqNo,"/",2)>1){
		s SDFlag=1
	}
	s (OrderInstrCode,OrderInstrDesc)=""
	if (OrderInstrRowid'=""){
		s OrderInstrDesc=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
		s OrderInstrCode=$P($g(^PHCIN(OrderInstrRowid)),"^",1)
	}
	s DrugFlag="N"
	if (OrderType="R"){
		s DrugFlag="Y"
	}
	s OEORIPriorityCode=$p(^OECPR(PriorityDR),"^",1)
	s OUTFlag=0
	if (OEORIPriorityCode["OUT"){
		s OUTFlag=1
	}
	s OrderDurFactory=1
	if (OrderDurRowid'=""){
		s OrderDurFactory=$P(^PHCDU(OrderDurRowid),"^",2)
	}
	s OutPutInfo=SDFlag_"^"_OrderInstrCode_"^"_OrderInstrDesc_"^"_DrugFlag_"^"_OrderPrescNo_"^"_OrderDurFactory_"^"_OUTFlag_"^"_OrderBillTypeRowid
	
	q OutPutInfo
}

/// Creator:      宋春莉
/// CreatDate:    2018.08.23
/// Description:  取患者本次就诊生理指标Code+描述
/// Table:        
/// Input:        AdmId:就诊RowId
/// Return:      Code_"^"_描述_"^"_id
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetPhysiologicalCycle("4182") 
ClassMethod GetPhysiologicalCycle(AdmId As %String)
{
	n (AdmId)
	s mradm=$p(^PAADM(AdmId),"^",61)
	s PhysiologicalCycleId=$p(^MR(mradm,"DHC"),"^",9)
	q:PhysiologicalCycleId="" "^"
	s desc=$p($g(^DHCPHYC(PhysiologicalCycleId)),"^",2)
	s code=$p($g(^DHCPHYC(PhysiologicalCycleId)),"^",1)
	q code_"^"_desc_"^"_PhysiologicalCycleId
}

/// Creator:      屈坚
/// CreatDate:    2018.11.23
/// Description:  护士分床时默认插入管床医生的上级医生和主(副)任医生
/// Table:        
/// Input:        UserID:管床医生的UserID, LocID:科室id, Adm:就诊RowId
/// Return:      0为成功
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).InsertDefinedThreeCheckDoc("4634","110","305") 
ClassMethod InsertDefinedThreeCheckDoc(UserID As %String, LocID As %String, Adm As %String)
{
	n (UserID,LocID,Adm)
	s rtn=##class(web.DHCDocThreeCheckListAdm).InsertDefinedThreeCheck(UserID,LocID,Adm)
	q rtn
}

/// Creator:      屈坚
/// CreatDate:    2018.11.23
/// Description:  得到该病人的管床医生的上级医生和主(副)任医生
/// Table:        
/// Input:        UserID:管床医生的UserID, LocID:科室id, Adm:就诊RowId
/// Return:      json串 [{"UserID":"4808","UserDesc":"陆玉梅","Type":"主(副)任医师"},{"UserID":"5007","UserDesc":"王耀锋","Type":"上级医师"}]
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("4634","110","305")
ClassMethod GetAdmThreeCheckDoc(UserID As %String = "", LocID As %String, Adm As %String)
{
	n (UserID,LocID,Adm)
	if UserID="" {
		s AdmDoc=$P(^PAADM(Adm),"^",9) 
		s UserID=$O(^SSU("SSUSR",0,"CTPCP",AdmDoc,""),-1)
		}
	s json="["
	Set rset = ##class(%ResultSet).%New("web.DHCDocThreeCheckListAdm:FindThreeDocAdm")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set rs = rset.Execute(UserID,LocID,Adm)
	While (rset.Next()) {
		s ActiveFlag=$g(rset.Data("ActiveFlag"))
		continue:ActiveFlag'="Y"
		s UserIDDR=$g(rset.Data("UserID"))
		s UserDesc=$g(rset.Data("UserDesc"))
		s TypeDesc=$g(rset.Data("Type"))
		if TypeDesc="主(副)任医师" s Type=3
		if TypeDesc="上级医师" s Type=2
		s OneJsonData="{""UserID"":"""_$g(UserIDDR)_""",""UserDesc"":"""_$g(UserDesc)_""",""Type"":"""_$g(Type)_""",""TypeDesc"":"""_$g(TypeDesc)_""""
		s OneJsonData=OneJsonData_"}"
		if json="[" s json=json_OneJsonData
		else  s json=json_","_OneJsonData
		}
	s UserDesc=$p(^SSU("SSUSR",UserID),"^",2)
	s OneJsonData="{""UserID"":"""_$g(UserID)_""",""UserDesc"":"""_$g(UserDesc)_""",""Type"":"""_"1"_""",""TypeDesc"":"""_"管床医师"_""""
	s OneJsonData=OneJsonData_"}"
	if json="[" s json=json_OneJsonData
	else  s json=json_","_OneJsonData
	s json=json_"]"
	q json
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.14
/// Description:  判断是否为皮试用法医嘱
/// Table:        
/// Input:       医嘱id
/// Return:      0：非皮试用法医嘱 1：皮试用法医嘱
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr()
ClassMethod CheckOrdIsSkinInstr(OEORIRowId As %String)
{
	Q:OEORIRowId="" 0
	s OrderInstrRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),2)),"^",7)
	Q:OrderInstrRowid="" 0
	;皮试用法
	s SkinTestInstr=##Class(web.DHCDocConfig).GetConfigNode("SkinTestInstr")
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	if (SkinTestInstr'="")&&(SkinTestInstr[("^"_OrderInstrRowid_"^")){
		Q 1
	}
	Q 0
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.17
/// Description:  判断就诊是否存在草药或西药医嘱
/// Table:        
/// Input:       就诊ID
/// Return:      0：不存在 1：存在
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist()
ClassMethod CheckOrdIsExist(EpisodeID As %String, CHMEDFlag As %String = "")
{
	s rtn=0
	Set OrderId=$o(^OEORD(0,"Adm",EpisodeID,0))
	if OrderId="" Quit rtn
	Set sub=0
	for  {
		Set sub=$o(^OEORD(OrderId,"I",sub)) 
		Quit:(sub="")||(rtn=1)
		s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
		continue:OrderStatusRowid="" 
		s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
		continue:(ItemStatCode'="V")&&(ItemStatCode'="E")
		s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
	 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
	 	continue:(checkrtn="Reg")||(checkrtn="Check") 
	 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
	 	continue:DoctorDR=""
	 	;非医生录入的医嘱退出
		s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
		s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
		continue:(DoctorType'="DOCTOR") 
		;检验自动绑定上的医嘱不显示
		s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
		continue:LinkLabNo'="" 
		;留观医生下的医嘱不同步到病历
		s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
		continue:EMStayFlag="1"
		continue:'$$IsMedicalRecord(OrderId_"||"_sub)
		s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10) 
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
		continue:(PHPrescType=3)&&(CHMEDFlag'="CHMED") 
		continue:(PHPrescType'=3)&&(CHMEDFlag="CHMED") 
		s rtn=1
	}
	Q rtn
IsMedicalRecord(OEORI)
	s ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	;是否上医嘱单,统一调用护理组方法判断
	;s rtn=##class(web.DHCNurseInterface).IfInOrderSheet(OEORI)
	;i rtn'="Y" q 0
	s OrderCategory=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",10)
	i ItemCatDR'="" {
		s OrderCategoryDR=$P(^ARC("IC",ItemCatDR),"^",8)
		i OrderCategoryDR'="" s OrderCategory=$p(^OEC("ORCAT",OrderCategoryDR),"^",2)
	}
	s OEORIBindSource=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC"),"^",41)
	Q:OEORIBindSource'="" 0
	;材料不上医嘱单
	;i OrderCategory["材料" q 0
	
	;特殊的一些项目不上医嘱单,特殊处理
	i $g(^DHCDocLocalSysP("OPDoc.MedicalRecords.SpecARCIM"))[("^"_ARCIM_"^") q 0
	
	q 1
}

}
