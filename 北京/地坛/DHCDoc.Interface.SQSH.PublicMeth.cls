Class DHCDoc.Interface.SQSH.PublicMeth Extends %Persistent
{

/// version 2 执行记录 1 医嘱版本 如需单独版本请联系产品组
Parameter version = 2;

/// 唯一ID-所在的位置 组织需要保存的串
Parameter StrLocation = 49;

/// 唯一ID-存储所在位置("LOCAL")
Parameter DataLocation = 4;

/// 门诊启用新版本--暂时未改造不用启用 如果需要启用请联系产品组
Parameter OPNewversion = 0;

/// 患者+就诊编码+医生唯一编码
ClassMethod GetOrderMesage(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage, needSend As %String = "") As DHCDoc.Interface.SQSH.DataPackage
{
	s needSend="N"
	Q:PAADMDr="" "-1"
	Q:OrderStr="" "-1"
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
	s MainPriseNO=PatNo_"||"_PAADMDr_"||"_UserID ;处方审核的唯一标志
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	s PriseType="门诊"
	s:PAADMType="E" PriseType="急诊"
	s:PAADMType="I" PriseType="住院"
	
	s OutObj=##class(DHCDoc.Interface.SQSH.DataPackage).%New()
	s OutObj.ResultCode=0
	s OutObj.ResultContent="成功"
	s OutObj.IP=IP ;IP地址
	
	b //获取患者基本信息
	s PatientInfoObj=..GetPatientInfoObj(PAADMDr)
	s OutObj.PatientInfo=PatientInfoObj
	
	b //获取患者诊断信息
	s DiagnosisesObj=..GetDiagnoseMesage(PAADMDr)
	s OutObj.DiaAllMesage=DiagnosisesObj
	
	b //处方信息
	s PresInfoObj=##class(DHCDoc.Interface.SQSH.List.PresInfo).%New()
	s PresInfoObj.Code=MainPriseNO //审核唯一标识（非空）
	s PresInfoObj.ClientType="c1" //客户端类型
	s PresInfoObj.CheckType="正式" //审核属性（正式or非正式）（非空）
	s PresInfoObj.Time=$ZD(+$H,3)_" "_$ZT($P($H,",",2),1) //审核时间（yyyy-MM-dd HH:MM:SS）（非空）
	s PresInfoObj.PrescriptionType=PriseType //处方类型（门诊、急诊)（非空、字典）
	s PresInfoObj.TotalPrice="" //单张处方总价
	s OutObj.PresInfo=PresInfoObj
	
	b //药品信息
	s FindOrderSave=""
	
	b //未审核信息提取
	d ..GetUnsaveMesageObj(PAADMDr,OrderStr,IP,UserID,CTLocID,OtherMesage,.FindOrderSave,.OutObj)
	
	b //发下要开的医嘱中存在药品信息 则提取已审核药品信息到数据中
	if (FindOrderSave="Y"){
		d ..GetSavedOrder(PAADMDr,.OutObj)
		s needSend="Y"
	}
	q OutObj
}

/// 未审核信息提取
ClassMethod GetUnsaveMesageObj(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage, FindOrderSave, OutObj As %ObjectHandle) As %String
{
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	if PAADMType'="I"  d
	.s Obj=..GetOrderMesageObj(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage,.FindOrderSave)
	.d OutObj.FeeItems.Insert(Obj)
	else   d
	.d ..IDGetOrderMesageObj(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage,.FindOrderSave,.OutObj)
	.
	q
}

/// 住院获取待审核信息
ClassMethod IDGetOrderMesageObj(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage, FindOrderSave, OutObj As %ObjectHandle) As DHCDoc.Interface.SQSH.List.FeeItems
{
		
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
	s MainPriseNO=PatNo_"||"_PAADMDr_"||"_UserID ;处方审核的唯一标志
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	
	s CTLocDesc=$P($G(^CTLOC(CTLocID)),"^",2) //科室描述
	s CTLocCode=$P($G(^CTLOC(CTLocID)),"^",1) //科室Code
	s CtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14) //医护人员
	s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s CtpcpName=""
	s:CtpcpDr'="" CtpcpName=$p($g(^CTPCP(CtpcpDr,1)),"^",2) //医生姓名
	s:CtpcpName="" CtpcpName=$p($g(^SSU("SSUSR",UserID)),"^",2) 
	
	s AdmReason="" //费别
	s AdmReasonId=$p(^PAADM(PAADMDr,1),"^",7)
	i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	s CtpcpType=$P(^CTPCP(CtpcpDr,1),"^",4)
	s CtpcpTypeDesc=""
	s:CtpcpType'="" CtpcpTypeDesc=$P($G(^CT("CPT",CtpcpType)),"^",2)
	
	//排序后输出
	k SaveList
	f sub=1:1:$L(OrderStr,$C(1))  d
	.s substr=$P(OrderStr,$C(1),sub)
	.Q:substr=""
	.s MasterSeqNo=$P(substr,"^",19)
	.s SeqNo=$P(substr,"^",20)
	.s OrderOnlyID=$P(substr,"^",..#StrLocation)
	.if MasterSeqNo'=""  d
	..s SaveList(MasterSeqNo,SeqNo)=substr
	.else  d
	..s SaveList(SeqNo)=substr
	
	//输出
	s FindOrderSave="N"
	s sub0=0
	f  s sub0=$O(SaveList(sub0)) Q:sub0=""  d
	.s substr=$G(SaveList(sub0))
	.s MainOrderOnlyID=$P(substr,"^",..#StrLocation)
	.d setoneDurIP(substr,MainOrderOnlyID)
	.s sub1=0
	.f  s sub1=$O(SaveList(sub0,sub1)) Q:sub1=""  d
	..s substr=$G(SaveList(sub0,sub1))
	..s OrderOnlyID=$P(substr,"^",..#StrLocation)
	..d setoneDurIP(substr,MainOrderOnlyID)
	q
setoneDurIP(substr,mainonlyid)
	if substr'=""  d
	.Q:substr=""
	.s startdate=$p(substr,"^",4)
	.i startdate="" s startdate=$P($H,",",1)
	.s startdate=##class(websys.Conversions).DateHtmlToLogical(startdate)
	.s FirstDayTimes=$p(substr,"^",33)
	.Q:((FirstDayTimes=0)&&(startdate=+$H)) //开始日期当日 首日次数为0 不推送
	.
	.
	.s OnlyID=$P(substr,"^",64)
	.s:OnlyID'="" MainPriseNO=OnlyID
	.s FeeItemsObj=##class(DHCDoc.Interface.SQSH.List.FeeItems).%New()
	.s FeeItemsObj.PrescriptionId=MainPriseNO //处方唯一标识（非空）
	.s FeeItemsObj.DoctorDepartmentId=CTLocCode //开方科室Id
	.s FeeItemsObj.DoctorDepartmentName=CTLocDesc //开方科室名称
	.s FeeItemsObj.DoctorLevel=CtpcpTypeDesc //开方医师级别
	.s FeeItemsObj.DoctorId=SSUSRInitials //开方医师编号
	.s FeeItemsObj.DoctorName=CtpcpName //开方医师姓名
	.s FeeItemsObj.PrescriptionDate=$ZD(+$H,3)_" "_$ZT($P($H,",",2),1) //开方时间（格式）
	.s FeeItemsObj.DispenseDepartmentId="" //发药科室Id
	.s FeeItemsObj.DispenseDepartmentName="" //发药科室名称
	.s FeeItemsObj.DispenseDoctorId="" //发药医生ID
	.s FeeItemsObj.DispenseDoctorName="" //发药医生名称
	.s FeeItemsObj.DispenseDate="" //发药日期(2013-03-29)（格式）
	.s FeeItemsObj.Insurance=AdmReason //医保属性
	.s FeeItemsObj.Remark="" //处方备注
	.;b ;111
	.;--------------
	.s ARCIMRowid=$P(substr,"^",1)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.Q:OrdType'="R"
	.s priorRowid=$p(substr,"^",3)
	.s PriorCode=$p($g(^OECPR(priorRowid)),"^",1)
	.s Freqdr=$P(substr,"^",15) //频次
	.s:Freqdr'="" Freqdesc=$P($G(^PHCFR(Freqdr)),"^",3)
	.s Instrdr=$P(substr,"^",17) //用法
	.s:Instrdr'="" InstrDesc=$P($G(^PHCIN(Instrdr)),"^",2) 
	.s DoseQty=$P(substr,"^",12) //单次剂量
	.s DoseUomdr=$P(substr,"^",13) //单次剂量单位
	.s:DoseUomdr'="" DoseUom=$P(^CT("UOM",DoseUomdr),"^",2)
	.s OrderDurRowid=$P(substr,"^",16) //疗程
	.s:OrderDurRowid'="" OrderDur=$P($G(^PHCDU(OrderDurRowid)),"^",3)
	.s OrderSkinTest=$P(substr,"^",21) //皮试
	.s Skin=$case(OrderSkinTest,"Y":1,:0)
	.s DrugRemark=$P(substr,"^",11) //备注
	.s PackQty=$P(substr,"^",6) //整包装单位
	.s BillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	.s:BillUOMRowid'="" BillUomDesc=$P($G(^CT("UOM",BillUOMRowid)),"^",2) //计价单位
	.s MasterSeqNo=$P(substr,"^",19)
	.s:MasterSeqNo="" MasterSeqNo=$P(substr,"^",20)
	.s:mainonlyid'="" MasterSeqNo=mainonlyid //按照主医嘱的唯一ID设置
	.s (rtninci,genedesc,goodsname,form,manf,BillUom,Spec)=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid) //获取库存项ID
	.if INCIRowid'=""  d
	..s rtninci=..getInciInfo(INCIRowid)
	..s genedesc=$P(rtninci,"^",1) ;通用名
	..s goodsname=$P(rtninci,"^",6) ;商品名
	..s form=$P(rtninci,"^",2) ;剂型
	..s manf=$P(rtninci,"^",3) ;厂家
	..s BillUom=$P(rtninci,"^",9) ;计价单位
	..s Spec=$P(rtninci,"^",7) ;规格
	.s OneDur=##class(DHCDoc.Interface.SQSH.List.Drugs).%New()
	.s OneDur.ItemId=ArcimCode //项目HIS中ID
	.s OneDur.ItemType=0 //项目类别，0代表药品，1代表诊疗项目和服务设施
	.s OneDur.Frequency=$G(Freqdesc) //给药频率
	.s OneDur.Condition="" //服药条件
	.s OneDur.Route=$G(InstrDesc) //给药途径
	.s OneDur.SingleDose=DoseQty //单次服药量：值
	.s OneDur.SingleDoseUnit=$G(DoseUom) //单次服药量：单位
	.s OneDur.Quantity=PackQty //开药量：值
	.s OneDur.QuantityUnit=$G(BillUomDesc) //开药量：单位
	.s OneDur.Days=OrderDur // 服药天数（天）
	.s OneDur.DrugGroup=MasterSeqNo //药品分组，说明溶质与溶媒的合用关系
	.s OneDur.SkinTest=Skin //是否过敏试验，1：是，0：否
	.s OneDur.SkinTestResult="" //过敏试验结果
	.s OneDur.DrugOrder="" //药品开药顺序，升序
	.s OneDur.DrugRemark=DrugRemark //药品备注
	.s OneDur.Destinations="" //用药目的
	.s OneDur.ItemComName=genedesc //通用名
	.s OneDur.ItemProName=goodsname //商品名
	.s OneDur.Formulation=form //剂型
	.s OneDur.Manufacture=manf //厂家
	.s OneDur.Packing=BillUom //包装
	.s OneDur.Specs=Spec //规格
	.s OneDur.UnitPrice="" //单价（元）
	.s OneDur.TotalPrice="" //总价（元）
	.s OneDur.InstructDrugDate=$ZD(startdate,3) //用药日期
	.s OneDur.InstructDrugTime=..getDisPising(Freqdr,"I") //给药时间
	.s OneDur.InstructDrugLeftTime="" //给药起始时间
	.s OneDur.InstructDrugRightTime="" //给药结束时间
	.s OneDur.InstructDrugSpeed="" //给药速度
	.s OneDur.InstructDrugSpeedUnit="" //给药速度单位
	.s OneDur.PriorCode=PriorCode //医嘱类型CODE
	.s IsDischargeWithMed=0
	.s:PriorCode="OUT" IsDischargeWithMed=1
	.s OneDur.IsDischargeWithMed=IsDischargeWithMed
	.d FeeItemsObj.Drugs.Insert(OneDur)
	.s FindOrderSave="Y"
	.d OutObj.FeeItems.Insert(FeeItemsObj)
	.;b ;333
	
	q
}

/// lxz
/// desc 获取将要审核的医嘱信息
ClassMethod GetOrderMesageObj(PAADMDr, OrderStr, IP, UserID, CTLocID, OtherMesage, FindOrderSave) As DHCDoc.Interface.SQSH.List.FeeItems
{
	
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
	s MainPriseNO=PatNo_"||"_PAADMDr_"||"_UserID ;处方审核的唯一标志
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	
	s CTLocDesc=$P($G(^CTLOC(CTLocID)),"^",2) //科室描述
	s CTLocCode=$P($G(^CTLOC(CTLocID)),"^",1) //科室Code
	s CTLocCode=CTLocID                       // 普华合成需要rowid
	s CtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14) //医护人员
	s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s CtpcpName=""
	s:CtpcpDr'="" CtpcpName=$p($g(^CTPCP(CtpcpDr,1)),"^",2) //医生姓名
	s:CtpcpName="" CtpcpName=$p($g(^SSU("SSUSR",UserID)),"^",2) 
	
	s AdmReason="" //费别
	s AdmReasonId=$p(^PAADM(PAADMDr,1),"^",7)
	i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	s CtpcpType=$P(^CTPCP(CtpcpDr,1),"^",4)
	s CtpcpTypeDesc=""
	s:CtpcpType'="" CtpcpTypeDesc=$P($G(^CT("CPT",CtpcpType)),"^",2)
	
	s FeeItemsObj=##class(DHCDoc.Interface.SQSH.List.FeeItems).%New()
	s FeeItemsObj.PrescriptionId=MainPriseNO //处方唯一标识（非空）
	s FeeItemsObj.DoctorDepartmentId=CTLocCode //开方科室Id
	s FeeItemsObj.DoctorDepartmentName=CTLocDesc //开方科室名称
	s FeeItemsObj.DoctorLevel=CtpcpTypeDesc //开方医师级别
	s FeeItemsObj.DoctorId=SSUSRInitials //开方医师编号
	s FeeItemsObj.DoctorName=CtpcpName //开方医师姓名
	s FeeItemsObj.PrescriptionDate=$ZD(+$H,3)_" "_$ZT($P($H,",",2),1) //开方时间（格式）
	s FeeItemsObj.DispenseDepartmentId="" //发药科室Id
	s FeeItemsObj.DispenseDepartmentName="" //发药科室名称
	s FeeItemsObj.DispenseDoctorId="" //发药医生ID
	s FeeItemsObj.DispenseDoctorName="" //发药医生名称
	s FeeItemsObj.DispenseDate="" //发药日期(2013-03-29)（格式）
	s FeeItemsObj.Insurance=AdmReason //医保属性
	s FeeItemsObj.Remark="" //处方备注
	
	
	//医嘱信息
	//OrderItem=OrderARCIMRowid+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime
	//+"^"+OrderPackQty+"^"+OrderPrice; 7
	//OrderItem=OrderItem+"^"+OrderRecDepRowid+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes; 11
	//OrderItem=OrderItem+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid
	//+"^"+OrderInstrRowid; 17
	//OrderItem=OrderItem+"^"+PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+OrderSkinTest  21
	//+"^"+OrderPhSpecInstr+"^"+OrderCoverMainIns; 23
	//OrderItem=OrderItem+"^"+OrderActionRowid+"^"+OrderARCOSRowid+"^"+OrderEndDate+"^"+OrderEndTime+"^"+OrderLabSpecRowid+"^"+OrderMultiDate;
	//OrderItem=OrderItem+"^"+OrderNotifyClinician+"^"+OrderDIACatRowId+"^"+OrderInsurCatRowId+"^"+OrderFirstDayTimes+"^"+OrderInsurSignSymptomCode;
	//OrderItem=OrderItem+"^"+OrderStageCode+"^"+OrderSpeedFlowRate+"^"+AnaesthesiaID+"^"+OrderLabEpisodeNo;
	//OrderItem=OrderItem+"^"+OrderCPWStepItemRowId;
	//OrderItem=OrderItem+"^"+OrderAntibApplyRowid+"^"+UserReasonId+"^"+OrderMaterialBarCode;  //KSS
	
	//排序后输出
	k SaveList
	f sub=1:1:$L(OrderStr,$C(1))  d
	.s substr=$P(OrderStr,$C(1),sub)
	.Q:substr=""
	.s MasterSeqNo=$P(substr,"^",19)
	.s SeqNo=$P(substr,"^",20)
	.s OrderOnlyID=$P(substr,"^",..#StrLocation)
	.if MasterSeqNo'=""  d
	..s SaveList(MasterSeqNo,SeqNo)=substr
	.else  d
	..s SaveList(SeqNo)=substr
	
	//输出
	s FindOrderSave="N"
	s sub0=0
	f  s sub0=$O(SaveList(sub0)) Q:sub0=""  d
	.s substr=$G(SaveList(sub0))
	.s MainOrderOnlyID=$P(substr,"^",..#StrLocation)
	.d setoneDur(substr,MainOrderOnlyID)
	.s sub1=0
	.f  s sub1=$O(SaveList(sub0,sub1)) Q:sub1=""  d
	..s substr=$G(SaveList(sub0,sub1))
	..s OrderOnlyID=$P(substr,"^",..#StrLocation)
	..d setoneDur(substr,MainOrderOnlyID)
	q FeeItemsObj
setoneDur(substr,mainonlyid)
	if substr'=""  d
	.;--------------
	.s ARCIMRowid=$P(substr,"^",1)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.Q:OrdType'="R"
	.s priorRowid=$p(substr,"^",3)
	.s PriorCode=$p($g(^OECPR(priorRowid)),"^",1)
	.s Freqdr=$P(substr,"^",15) //频次
	.s:Freqdr'="" Freqdesc=$P($G(^PHCFR(Freqdr)),"^",3)
	.s Instrdr=$P(substr,"^",17) //用法
	.s:Instrdr'="" InstrDesc=$P($G(^PHCIN(Instrdr)),"^",2) 
	.s DoseQty=$P(substr,"^",12) //单次剂量
	.s DoseUomdr=$P(substr,"^",13) //单次剂量单位
	.s:DoseUomdr'="" DoseUom=$P(^CT("UOM",DoseUomdr),"^",2)
	.s OrderDurRowid=$P(substr,"^",16) //疗程
	.s:OrderDurRowid'="" OrderDur=$P($G(^PHCDU(OrderDurRowid)),"^",3)
	.s OrderSkinTest=$P(substr,"^",21) //皮试
	.s Skin=$case(OrderSkinTest,"Y":1,:0)
	.s DrugRemark=$P(substr,"^",11) //备注
	.s PackQty=$P(substr,"^",6) //整包装单位
	.s BillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	.s:BillUOMRowid'="" BillUomDesc=$P($G(^CT("UOM",BillUOMRowid)),"^",2) //计价单位
	.s MasterSeqNo=$P(substr,"^",19)
	.s:MasterSeqNo="" MasterSeqNo=$P(substr,"^",20)
	.s:mainonlyid'="" MasterSeqNo=mainonlyid  ;按照主医嘱的唯一ID设置
	.s (rtninci,genedesc,goodsname,form,manf,BillUom,Spec)=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid) //获取库存项ID
	.if INCIRowid'=""  d
	..s rtninci=..getInciInfo(INCIRowid)
	..s genedesc=$P(rtninci,"^",1) ;通用名
	..s goodsname=$P(rtninci,"^",6) ;商品名
	..s form=$P(rtninci,"^",2) ;剂型
	..s manf=$P(rtninci,"^",3) ;厂家
	..s BillUom=$P(rtninci,"^",9) ;计价单位
	..s Spec=$P(rtninci,"^",7) ;规格
	.s OneDur=##class(DHCDoc.Interface.SQSH.List.Drugs).%New()
	.s OneDur.ItemId=ArcimCode //项目HIS中ID
	.s OneDur.ItemType=0 //项目类别，0代表药品，1代表诊疗项目和服务设施
	.s OneDur.Frequency=$G(Freqdesc) //给药频率
	.s OneDur.Condition="" //服药条件
	.s OneDur.Route=$G(InstrDesc) //给药途径
	.s OneDur.SingleDose=DoseQty //单次服药量：值
	.s OneDur.SingleDoseUnit=$G(DoseUom) //单次服药量：单位
	.s OneDur.Quantity=PackQty //开药量：值
	.s OneDur.QuantityUnit=$G(BillUomDesc) //开药量：单位
	.s OneDur.Days=OrderDur // 服药天数（天）
	.s OneDur.DrugGroup=MasterSeqNo //药品分组，说明溶质与溶媒的合用关系
	.s OneDur.SkinTest=Skin //是否过敏试验，1：是，0：否
	.s OneDur.SkinTestResult="" //过敏试验结果
	.s OneDur.DrugOrder="" //药品开药顺序，升序
	.s OneDur.DrugRemark=DrugRemark //药品备注
	.s OneDur.Destinations="" //用药目的
	.s OneDur.ItemComName=genedesc //通用名
	.s OneDur.ItemProName=goodsname //商品名
	.s OneDur.Formulation=form //剂型
	.s OneDur.Manufacture=manf //厂家
	.s OneDur.Packing=BillUom //包装
	.s OneDur.Specs=Spec //规格
	.s OneDur.UnitPrice="" //单价（元）
	.s OneDur.TotalPrice="" //总价（元）
	.s OneDur.InstructDrugTime=..getDisPising(Freqdr,"O") //给药时间
	.s OneDur.InstructDrugLeftTime="" //给药起始时间
	.s OneDur.InstructDrugRightTime="" //给药结束时间
	.s OneDur.InstructDrugSpeed="" //给药速度
	.s OneDur.InstructDrugSpeedUnit="" //给药速度单位
	.s OneDur.PriorCode=PriorCode //医嘱类型CODE
	.s IsDischargeWithMed=0
	.s:PriorCode="OUT" IsDischargeWithMed=1
	.s OneDur.IsDischargeWithMed=IsDischargeWithMed
	.d FeeItemsObj.Drugs.Insert(OneDur)
	.s FindOrderSave="Y"
	
	q
}

/// 获取已经审核的医嘱项目
/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetSavedOrder(7911343,"")
ClassMethod GetSavedOrder(PAADMDr, OutObj As %ObjectHandle) As %String
{
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	if (PAADMType'="I"){
		//门急诊不上传历史  方案没有确定
		q:..#OPNewversion=0
		
		//提取门诊处方信息
		d ..GetOPSavedOrder(PAADMDr,.OutObj)
		
		//提取对应的--相同就诊日期的其他就诊信息的医嘱信息
		s AdmDate=$P($G(^PAADM(PAADMDr)),"^",6)
		s PersonDr=$P($G(^PAADM(PAADMDr)),"^",1)
		if PersonDr'=""  d
		.s AdmType=0
		.f  s AdmType=$O(^PAPERdr(PersonDr,"ADM",AdmType)) Q:AdmType=""  d
		..Q:AdmType="I"
		..s AdmRowID=0
		..f  s AdmRowID=$O(^PAPERdr(PersonDr,"ADM",AdmType,AdmRowID)) Q:AdmRowID=""  d
		...Q:AdmRowID=PAADMDr
		...s VisitStatus=$P($G(^PAADM(AdmRowID)),"^",20)
		...Q:VisitStatus'="A"
		...s AdmDateN=$P($G(^PAADM(AdmRowID)),"^",6)
		...Q:AdmDateN'=AdmDate ;同一天就诊信息的才去上传
		...d ..GetOPSavedOrder(AdmRowID,.OutObj)

	}else{
		//提取住院处方信息
		d ..GetIPSavedOrder(PAADMDr,.OutObj)
	}
}

/// 按照住院就诊记录获取处方信息
ClassMethod GetIPSavedOrder(PAADMDr, OutObj As %ObjectHandle) As %String
{
	//住院不按照处方走一个药品一个处方
	s PAADMType=$P(^PAADM(PAADMDr),"^",2)
	s orderdr=+$O(^OEORD(0,"Adm",PAADMDr,0))
	Q:orderdr=0

	s AdmReason="" ;费别
	s AdmReasonId=$p(^PAADM(PAADMDr,1),"^",7)
	i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	
	//按照不同HIS版本进行数据提取
	if (..#version=1){
		d OEOrderVersion()
	}elseif (..#version=2){
		d OEExecVersion()
	}
	q 
OEOrderVersion()
	;滚医嘱版本
	k ^TempOrdFindSave($J,orderdr)
	s ordersubdr=0
	f  s ordersubdr=$O(^OEORDi(0,"ItemDate",+$H,orderdr,ordersubdr)) Q:ordersubdr=""  d
	.s stdate=$p($g(^OEORD(orderdr,"I",ordersubdr,1)),"^",9) ;开始日期不是当日的
	.Q:stdate>+$H
	.s statcode="V"
	.s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	.i statdr'="" d
	..s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	.Q:statcode'="V"
	.s ARCIMRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",2)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.s OECOrdDr=$P(^ARC("IC",ItemCatDR),"^",8)
	.Q:OrdType'="R"
	.q:OECOrdDr="3"
	.Q:$D(^TempOrdFindSave($J,orderdr,ordersubdr))
	.s ^TempOrdFindSave($J,orderdr,ordersubdr)=""
	.d SetOneList()
	
	;按照开始日期补漏掉的医嘱项目 可能修改了界面上的医嘱日期
	s ordersubdr=0
	f  s ordersubdr=$O(^OEORDi(0,"StDt",+$H,orderdr,ordersubdr)) Q:ordersubdr=""  d
	.Q:$D(^TempOrdFindSave($J,orderdr,ordersubdr))
	.s statcode="V"
	.s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	.i statdr'="" d
	..s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	.Q:statcode'="V"
	.s ARCIMRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",2)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.s OECOrdDr=$P(^ARC("IC",ItemCatDR),"^",8)
	.Q:OrdType'="R"
	.q:OECOrdDr="3"
	.d SetOneList()
	.s ^TempOrdFindSave($J,orderdr,ordersubdr)=""
	k ^TempOrdFindSave($J)
	q
OEExecVersion()	
	;滚执行记录版本
	k ^TempOrdFindSave($J,orderdr)
	s extime=0
	f  s extime=$O(^OEORDi(0,"Date",orderdr,+$H,extime)) Q:extime=""  d
	.s ordersubdr=0
	.f  s ordersubdr=$O(^OEORDi(0,"Date",orderdr,+$H,extime,ordersubdr)) Q:ordersubdr=""  d
	..s statcode="V"
	..s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	..i statdr'="" d
	...s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	..Q:statcode'="V"
	..s ARCIMRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",2)
	..s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	..s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	..s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	..s OECOrdDr=$P(^ARC("IC",ItemCatDR),"^",8)
	..Q:OrdType'="R"
	..q:OECOrdDr="3"
	..
	..s FindExeOrd="N"
	..s oeordexcdr=0
	..f oeordexcdr=$O(^OEORDi(0,"Date",orderdr,+$H,extime,ordersubdr,oeordexcdr)) Q:oeordexcdr=""  d
	...s statucode=""
	...s execstatudr=$P(^OEORD(+orderdr,"I",ordersubdr,"X",oeordexcdr),"^",16)
	...if execstatudr'="" s statucode=$p($g(^OEC("STAT",execstatudr)),"^",1)
	...Q:((statucode="D")||(statucode="C")||(statucode="R"))
	...s FindExeOrd="Y"
	..Q:$D(^TempOrdFindSave($J,orderdr,ordersubdr))
	..s ^TempOrdFindSave($J,orderdr,ordersubdr)=""
	..Q:FindExeOrd'="Y"
	..d SetOneList()
	k ^TempOrdFindSave($J)
	q
SetOneList()
	if (+orderdr'=0)&&(+ordersubdr'=0)  d
	.s UserID=$p($g(^OEORD(orderdr,"I",ordersubdr,7)),"^",1) //医嘱录入人
	.s PresLoc=$p($g(^OEORD(orderdr,"I",ordersubdr,7)),"^",2) //下医嘱科室
	.s PresCtpcpdr=$p($g(^SSU("SSUSR",UserID)),"^",14)
	.s CTLocDesc=$P($G(^CTLOC(PresLoc)),"^",2) //科室描述
	.s CTLocCode=$P($G(^CTLOC(PresLoc)),"^",1) //科室Code
	.s CtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14) //医护人员
	.s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
	.s CtpcpName=""
	.s:PresCtpcpdr'="" CtpcpName=$p($g(^CTPCP(PresCtpcpdr,1)),"^",2) //医生姓名
	.s:CtpcpName="" CtpcpName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s CtpcpTypeDesc=""
	.if PresCtpcpdr'=""  d
	..s CtpcpType=$P(^CTPCP(PresCtpcpdr,1),"^",4)
	..s CtpcpTypeDesc=""
	..s:CtpcpType'="" CtpcpTypeDesc=$P($G(^CT("CPT",CtpcpType)),"^",2)
	.
	.s OrderStarDate=$p($g(^OEORD(orderdr,"I",ordersubdr,1)),"^",9) ;医嘱开始日期
	.s OrderStarTime=$p($g(^OEORD(orderdr,"I",ordersubdr,1)),"^",10) ;医嘱开始时间
	.
	.;没有开始日期按照下医嘱日期进行输出
	.if OrderStarDate=""  d
	..s OrderStarDate=$p($g(^OEORD(orderdr,"I",ordersubdr,3)),"^",7)	;下医嘱日期
	..s OrderStarTime=$p($g(^OEORD(orderdr,"I",ordersubdr,1)),"^",17)	;下医嘱时间
	.s OrderOnlyID=$P($G(^OEORD(orderdr,"I",ordersubdr,"LOCAL")),"^",..#DataLocation)
	.s:OrderOnlyID="" OrderOnlyID=orderdr_"||"_ordersubdr
	.
	.;---滚医嘱的版本处理数据
	.if ..#version=1  d
	..s findstr=..getFillerNoOnlyID(orderdr_"||"_ordersubdr)
	..s OrderOnlyID=$P(findstr,"^",2)
	..s orditemdif=$P(findstr,"^",1)
	..;按照主医嘱来算
	..s OrderStarDate=$p($g(^OEORD(+orditemdif,"I",$P(orditemdif,"||",2),1)),"^",9)
	..s OrderStarTime=$p($g(^OEORD(+orditemdif,"I",$P(orditemdif,"||",2),1)),"^",10)
	..if OrderStarDate=""  d
	...s OrderStarDate=$p($g(^OEORD(+orditemdif,"I",$P(orditemdif,"||",2),3)),"^",7)
	...s OrderStarTime=$p($g(^OEORD(+orditemdif,"I",$P(orditemdif,"||",2),1)),"^",17)
	.
	.s FeeItemsObj=##class(DHCDoc.Interface.SQSH.List.FeeItems).%New()
	.s FeeItemsObj.PrescriptionId=OrderOnlyID //处方唯一标识
	.s FeeItemsObj.DoctorDepartmentId=CTLocCode //开方科室Id
	.s FeeItemsObj.DoctorDepartmentName=CTLocDesc //开方科室名称
	.s FeeItemsObj.DoctorLevel=CtpcpTypeDesc //开方医师级别
	.s FeeItemsObj.DoctorId=SSUSRInitials //开方医师编号
	.s FeeItemsObj.DoctorName=CtpcpName //开方医师姓名
	.s FeeItemsObj.PrescriptionDate=$ZD(OrderStarDate,3)_" "_$ZT(OrderStarTime,1) //开方时间（格式）
	.s FeeItemsObj.DispenseDepartmentId="" //发药科室Id
	.s FeeItemsObj.DispenseDepartmentName="" //发药科室名称
	.s FeeItemsObj.DispenseDoctorId="" //发药医生ID
	.s FeeItemsObj.DispenseDoctorName="" //发药医生名称
	.s FeeItemsObj.DispenseDate="" //发药日期(2013-03-29)（格式）
	.s FeeItemsObj.Insurance=AdmReason //医保属性
	.s FeeItemsObj.Remark="" //处方备注
	.s PriorCode=""
	.s OrderPriorRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",8) ; OEORI_Priority_dr
	.s:OrderPriorRowid'="" PriorCode=$P($G(^OECPR(OrderPriorRowid)),"^",2)

	.;s FeeItemsObj.DoctorAdviceType=PriorCode
	.s oneOneDugs=..getOneDugs(orderdr_"||"_ordersubdr,PAADMType)
	.d FeeItemsObj.Drugs.Insert(oneOneDugs)
	.d OutObj.FindOrders.Insert(FeeItemsObj) //将一个处方信息插入到对应的已保存医嘱信息中
	q
}

/// 按照门诊就诊记录获取处方信息
ClassMethod GetOPSavedOrder(PAADMDr, OutObj As %ObjectHandle) As %String
{
	
	s orderdr=$o(^OEORD(0,"Adm",PAADMDr,0))
	q:+orderdr=0
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;患者类型
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号	
	s AdmReason="" ;费别
	s AdmReasonId=$p(^PAADM(PAADMDr,1),"^",7)
	i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	
	//按照处方表查询信息
	S querowid=0
	f  s querowid=$O(^PAQUE1(0,"QUE1_PAADM_DR",PAADMDr,querowid)) Q:querowid=""  d
	.s presno=$P($G(^PAQUE1(querowid)),"^",14) //处方号
	.Q:presno=""
	.s PresLoc=$P($G(^PAQUE1(querowid)),"^",4) //开单科室
	.s PresCtpcpdr=$P($G(^PAQUE1(querowid)),"^",5) //开单医生
	.s transDate=$P($G(^PAQUE1(querowid)),"^",7) //开单日期
	.s transTime=$P($G(^PAQUE1(querowid)),"^",8) //开单时间
	.s UserID=$O(^SSU("SSUSR",0,"CTPCP",PresCtpcpdr,0)) //开单人对应的用户
	.
	.s FeeItemsObj=##class(DHCDoc.Interface.SQSH.List.FeeItems).%New()
	.
	.;-------------------查询对应的处方药品
	.s FindAcitveOrd=""
	.s ordersubdr=0
	.f  s ordersubdr=$O(^OEORD(0,"PrescNo",presno,orderdr,ordersubdr)) Q:ordersubdr=""  d
	..s statcode="V"
	..s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	..i statdr'="" d
	...s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	..Q:statcode'="V"
	..s oneOneDugs=..getOneDugs(orderdr_"||"_ordersubdr,PAADMType)
	..d FeeItemsObj.Drugs.Insert(oneOneDugs)
	..s UserAdd=$p($g(^OEORD(orderdr,"I",ordersubdr,7)),"^",1) //医嘱录入人
	..s:((UserID="")||(UserAdd'="")) UserID=UserAdd
	..s UserDepartId=$p($g(^OEORD(orderdr,"I",ordersubdr,7)),"^",2) //下医嘱科室
	..s:((PresLoc="")&&(UserDepartId'="")) PresLoc=UserDepartId
	..s FindAcitveOrd="Y"
	.Q:FindAcitveOrd'="Y"
	.;------------------补全头信息
	.
	.Q:UserID="" //没有医嘱录入人的项目不上传
	.Q:PresLoc="" //没有录入科室不上传
	.s OrdCtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14)
	.if ((OrdCtpcpDr'="")&&(OrdCtpcpDr'=PresCtpcpdr))  d
	..s PresCtpcpdr=OrdCtpcpDr
	.s CTLocDesc=$P($G(^CTLOC(PresLoc)),"^",2) //科室描述
	.s CTLocCode=$P($G(^CTLOC(PresLoc)),"^",1) //科室Code
	.s CtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14) //医护人员
	.s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
	.s CtpcpName=""
	.s:PresCtpcpdr'="" CtpcpName=$p($g(^CTPCP(PresCtpcpdr,1)),"^",2) //医生姓名
	.s:CtpcpName="" CtpcpName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s CtpcpTypeDesc=""
	.if PresCtpcpdr'=""  d
	..s CtpcpType=$P(^CTPCP(PresCtpcpdr,1),"^",4)
	..s CtpcpTypeDesc=""
	..s:CtpcpType'="" CtpcpTypeDesc=$P($G(^CT("CPT",CtpcpType)),"^",2)
	.
	.
	.s FeeItemsObj.PrescriptionId=presno //处方唯一标识（非空）
	.s FeeItemsObj.DoctorDepartmentId=CTLocCode //开方科室Id
	.s FeeItemsObj.DoctorDepartmentName=CTLocDesc //开方科室名称
	.s FeeItemsObj.DoctorLevel=CtpcpTypeDesc //开方医师级别
	.s FeeItemsObj.DoctorId=SSUSRInitials //开方医师编号
	.s FeeItemsObj.DoctorName=CtpcpName //开方医师姓名
	.s FeeItemsObj.PrescriptionDate=$ZD(transDate,3)_" "_$ZT(transTime,1) //开方时间（格式）
	.s FeeItemsObj.DispenseDepartmentId="" //发药科室Id
	.s FeeItemsObj.DispenseDepartmentName="" //发药科室名称
	.s FeeItemsObj.DispenseDoctorId="" //发药医生ID
	.s FeeItemsObj.DispenseDoctorName="" //发药医生名称
	.s FeeItemsObj.DispenseDate="" //发药日期(2013-03-29)（格式）
	.s FeeItemsObj.Insurance=AdmReason //医保属性
	.s FeeItemsObj.Remark="" //处方备注
	.
	.d OutObj.FindOrders.Insert(FeeItemsObj) //将一个处方信息插入到对应的已保存医嘱信息中
	
	q
}

/// 返回一个处方药品的信息
ClassMethod getOneDugs(OrderItemRowID, AdmType) As %ObjectHandle
{
	s orderdr=+OrderItemRowID
	s ordersubdr=+$P(OrderItemRowID,"||",2)
	s OneDur=##class(DHCDoc.Interface.SQSH.List.Drugs).%New()

	if ((orderdr>0)&&(ordersubdr>0))  d
	.s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	.i statdr'="" d
	..s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	.s ARCIMRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",2)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.s Freqdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",4) //频次
	.s:Freqdr'="" Freqdesc=$P($G(^PHCFR(Freqdr)),"^",3)
	.s Instrdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",7) //用法
	.s:Instrdr'="" InstrDesc=$P($G(^PHCIN(Instrdr)),"^",2) 
	.s DoseQty=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",1) //单次剂量
	.s DoseUomdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",3) //单次剂量单位
	.s:DoseUomdr'="" DoseUom=$P(^CT("UOM",DoseUomdr),"^",2)
	.s OrderDurRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",6)  //疗程
	.s:OrderDurRowid'="" OrderDur=$P($G(^PHCDU(OrderDurRowid)),"^",3)
	.s OrderSkinTest=$p($g(^OEORD(orderdr,"I",ordersubdr,5)),"^",2) //皮试
	.s Skin=$case(OrderSkinTest,"Y":1,:0)
	.s DrugRemark=$g(^OEORD(orderdr,"I",ordersubdr,"DEP",1)) //备注
	.s PackQty=$P($G(^OEORD(orderdr,"I",ordersubdr,9)),"^",4) //整包数量
	.s BillUOMRowid=$p($g(^OEORD(orderdr,"I",ordersubdr,"DHC")),"^",13) //协议包装单位
	.s:BillUOMRowid="" BillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	.s:BillUOMRowid'="" BillUomDesc=$P($G(^CT("UOM",BillUOMRowid)),"^",2) //计价单位
	.s OEORIOEORIDR=$P($G(^OEORD(orderdr,"I",ordersubdr,11)),"^",39) ;关联医嘱ID
	.;s:OEORIOEORIDR'="" OEORIOEORIDR=$P(OEORIOEORIDR,"||",1)_""_$P(OEORIOEORIDR,"||",2)
	.;s MasterSeqNo=OEORIOEORIDR
	.;s:MasterSeqNo="" MasterSeqNo=orderdr_""_ordersubdr
	.
	.
	.s PriorCode=""
	.s OrderPriorRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",8) ; OEORI_Priority_dr
	.s:OrderPriorRowid'="" PriorCode=$P($G(^OECPR(OrderPriorRowid)),"^",1)
	.s IsDischargeWithMed=0
	.s:PriorCode="OUT" IsDischargeWithMed=1
	.
	.;先按照唯一ID获取
	.s OrderOnlyID=$P($G(^OEORD(orderdr,"I",ordersubdr,"LOCAL")),"^",..#DataLocation)
	.s MasterSeqNo=OrderOnlyID
	.s:OEORIOEORIDR'="" MasterSeqNo=$P($G(^OEORD(+OEORIOEORIDR,"I",$P(OEORIOEORIDR,"||",2),"LOCAL")),"^",..#DataLocation)
	.
	.;没有唯一ID的记录按照医嘱记录获取关联关系
	.if MasterSeqNo=""  d
	..s MasterSeqNo=OEORIOEORIDR
	..s:MasterSeqNo="" MasterSeqNo=orderdr_""_ordersubdr
	.
	.
	.;---滚医嘱的版本处理数据
	.if ..#version=1  d
	..s findstr=..getFillerNoOnlyID(orderdr_"||"_ordersubdr)
	..s orditemdif=$P(findstr,"^",1)
	..;滚出来的项目按照原始的主医嘱项目查找
	..if (orditemdif'=OrderItemRowID)  d
	...s OrderOnlyID=$P(findstr,"^",2)
	...s OEORIOEORIDR=$P($G(^OEORD(+orditemdif,"I",$P(orditemdif,"||",2),11)),"^",39) ;关联医嘱ID
	...s MasterSeqNo=OrderOnlyID
	...s:OEORIOEORIDR'="" MasterSeqNo=$P($G(^OEORD(+OEORIOEORIDR,"I",$P(OEORIOEORIDR,"||",2),"LOCAL")),"^",..#DataLocation)
	...if MasterSeqNo="" d
	....s MasterSeqNo=OEORIOEORIDR
	....s:MasterSeqNo="" MasterSeqNo=orditemdif
	.
	.
	.s (rtninci,genedesc,goodsname,form,manf,BillUom,Spec)=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid) //获取库存项ID
	.if INCIRowid'=""  d
	..s rtninci=..getInciInfo(INCIRowid)
	..s genedesc=$P(rtninci,"^",1) ;通用名
	..s goodsname=$P(rtninci,"^",6) ;商品名
	..s form=$P(rtninci,"^",2) ;剂型
	..s manf=$P(rtninci,"^",3) ;厂家
	..s BillUom=$P(rtninci,"^",9) ;计价单位
	..s Spec=$P(rtninci,"^",7) ;规格
	.
	.s OneDur.ItemId=ArcimCode //项目HIS中ID
	.s OneDur.ItemType=0 //项目类别，0代表药品，1代表诊疗项目和服务设施
	.s OneDur.Frequency=$G(Freqdesc) //给药频率
	.s OneDur.Condition="" //服药条件
	.s OneDur.Route=$G(InstrDesc) //给药途径
	.s OneDur.SingleDose=DoseQty //单次服药量：值
	.s OneDur.SingleDoseUnit=$G(DoseUom) //单次服药量：单位
	.s OneDur.Quantity=PackQty //开药量：值
	.s OneDur.QuantityUnit=$G(BillUomDesc) //开药量：单位
	.s OneDur.Days=OrderDur // 服药天数（天）
	.s OneDur.DrugGroup=MasterSeqNo //药品分组，说明溶质与溶媒的合用关系
	.s OneDur.SkinTest=Skin //是否过敏试验，1：是，0：否
	.s OneDur.SkinTestResult="" //过敏试验结果
	.s OneDur.DrugOrder="" //药品开药顺序，升序
	.s OneDur.DrugRemark=DrugRemark //药品备注
	.s OneDur.Destinations="" //用药目的
	.s OneDur.ItemComName=genedesc //通用名
	.s OneDur.ItemProName=goodsname //商品名
	.s OneDur.Formulation=form //剂型
	.s OneDur.Manufacture=manf //厂家
	.s OneDur.Packing=BillUom //包装
	.s OneDur.Specs=Spec //规格
	.s OneDur.UnitPrice="" //单价（元）
	.s OneDur.TotalPrice="" //总价（元）
	.s OneDur.InstructDrugDate=..GetExecDate(OrderItemRowID) //给药日期
	.s OneDur.InstructDrugTime=..getDisPising(Freqdr,AdmType) //给药时间
	.s OneDur.InstructDrugLeftTime="" //给药起始时间
	.s OneDur.InstructDrugRightTime="" //给药结束时间
	.s OneDur.InstructDrugSpeed="" //给药速度
	.s OneDur.InstructDrugSpeedUnit="" //给药速度单位
	.s OneDur.PriorCode=PriorCode //医嘱类型CODE
	.s OneDur.IsDischargeWithMed=IsDischargeWithMed //出院带药
	.s OneDur.OrderOnlyID=OrderOnlyID //唯一ID审核前
	.s OneDur.OrderItemRowID=orderdr_"||"_ordersubdr //医嘱ID
	
	q OneDur
}

/// 获取已经审核过的医嘱项目
ClassMethod GetSavedOrderBack(PAADMDr, FeeItemsObj As %ObjectHandle) As %String
{
	
	s EpisodeType=$P(^PAADM(PAADMDr),"^",2)
	Q:EpisodeType="I"
	s orderdr=+$O(^OEORD(0,"Adm",PAADMDr,0))
	Q:orderdr=0
	s ordersubdr=0
	f  s ordersubdr=$O(^OEORD(orderdr,"I",ordersubdr)) Q:ordersubdr=""  d
	.s statcode="V"
	.s statdr=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",13)
	.i statdr'="" d
	..s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
	.Q:statcode'="V"
	.s ARCIMRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,1)),"^",2)
	.s ArcimCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	.Q:OrdType'="R"
	.s Freqdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",4) //频次
	.s:Freqdr'="" Freqdesc=$P($G(^PHCFR(Freqdr)),"^",3)
	.s Instrdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",7) //用法
	.s:Instrdr'="" InstrDesc=$P($G(^PHCIN(Instrdr)),"^",2) 
	.s DoseQty=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",1) //单次剂量
	.s DoseUomdr=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",3) //单次剂量单位
	.s:DoseUomdr'="" DoseUom=$P(^CT("UOM",DoseUomdr),"^",2)
	.s OrderDurRowid=$P($G(^OEORD(orderdr,"I",ordersubdr,2)),"^",6)  //疗程
	.s:OrderDurRowid'="" OrderDur=$P($G(^PHCDU(OrderDurRowid)),"^",3)
	.s OrderSkinTest=$p($g(^OEORD(orderdr,"I",ordersubdr,5)),"^",2) //皮试
	.s Skin=$case(OrderSkinTest,"Y":1,:0)
	.s DrugRemark=$g(^OEORD(orderdr,"I",ordersubdr,"DEP",1)) //备注
	.s PackQty=$P($G(^OEORD(orderdr,"I",ordersubdr,9)),"^",4) //整包数量
	.s BillUOMRowid=$p($g(^OEORD(orderdr,"I",ordersubdr,"DHC")),"^",13) //协议包装单位
	.s:BillUOMRowid="" BillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	.s:BillUOMRowid'="" BillUomDesc=$P($G(^CT("UOM",BillUOMRowid)),"^",2) //计价单位
	.s OEORIOEORIDR=$P($G(^OEORD(orderdr,"I",ordersubdr,11)),"^",39) ;关联医嘱ID
	.s:OEORIOEORIDR'="" OEORIOEORIDR=$P(OEORIOEORIDR,"||",1)_""_$P(OEORIOEORIDR,"||",2)
	.s MasterSeqNo=OEORIOEORIDR
	.s:MasterSeqNo="" MasterSeqNo=orderdr_""_ordersubdr
	.s (rtninci,genedesc,goodsname,form,manf,BillUom,Spec)=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid) //获取库存项ID
	.if INCIRowid'=""  d
	..s rtninci=..getInciInfo(INCIRowid)
	..s genedesc=$P(rtninci,"^",1) ;通用名
	..s goodsname=$P(rtninci,"^",6) ;商品名
	..s form=$P(rtninci,"^",2) ;剂型
	..s manf=$P(rtninci,"^",3) ;厂家
	..s BillUom=$P(rtninci,"^",9) ;计价单位
	..s Spec=$P(rtninci,"^",7) ;规格
	.
	.s OneDur=##class(DHCDoc.Interface.SQSH.List.Drugs).%New()
	.s OneDur.ItemId=ArcimCode //项目HIS中ID
	.s OneDur.ItemType=0 //项目类别，0代表药品，1代表诊疗项目和服务设施
	.s OneDur.Frequency=$G(Freqdesc) //给药频率
	.s OneDur.Condition="" //服药条件
	.s OneDur.Route=$G(InstrDesc) //给药途径
	.s OneDur.SingleDose=DoseQty //单次服药量：值
	.s OneDur.SingleDoseUnit=$G(DoseUom) //单次服药量：单位
	.s OneDur.Quantity=PackQty //开药量：值
	.s OneDur.QuantityUnit=$G(BillUomDesc) //开药量：单位
	.s OneDur.Days=OrderDur // 服药天数（天）
	.s OneDur.DrugGroup=MasterSeqNo //药品分组，说明溶质与溶媒的合用关系
	.s OneDur.SkinTest=Skin //是否过敏试验，1：是，0：否
	.s OneDur.SkinTestResult="" //过敏试验结果
	.s OneDur.DrugOrder="" //药品开药顺序，升序
	.s OneDur.DrugRemark=DrugRemark //药品备注
	.s OneDur.Destinations="" //用药目的
	.s OneDur.ItemComName=genedesc //通用名
	.s OneDur.ItemProName=goodsname //商品名
	.s OneDur.Formulation=form //剂型
	.s OneDur.Manufacture=manf //厂家
	.s OneDur.Packing=BillUom //包装
	.s OneDur.Specs=Spec //规格
	.s OneDur.UnitPrice="" //单价（元）
	.s OneDur.TotalPrice="" //总价（元）
	.s OneDur.InstructDrugTime="" //给药时间
	.s OneDur.InstructDrugLeftTime="" //给药起始时间
	.s OneDur.InstructDrugRightTime="" //给药结束时间
	.s OneDur.InstructDrugSpeed="" //给药速度
	.s OneDur.InstructDrugSpeedUnit="" //给药速度单位
	.d FeeItemsObj.Drugs.Insert(OneDur)
	q
}

/// CreatDate:药房组提供接口
/// Description:取库存项相关信息
/// Input:库存项rowid
/// Table:
/// OutPut:
/// Return:通用名^剂型^生产厂家^给药途径（用法^原料通用名^商品名^规格^药品名称^计价单位描述
///       $g(genedesc)_"^"_$g(form)_"^"_$g(manf)_"^"_$g(instruc)_"^"_geneyl_"^"_goodsname_"^"_Spec_"^"_InciDesc_"^"_BillUom
ClassMethod getInciInfo(inci) As %String
{
  q:inci="" ""
  s arcim=$p($g(^INCI(inci,1)),"^",3)
  q:arcim="" ""
  s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
  s BillUom=""
  s BillUomDr=$p($g(^ARCIM(sub,ver,8)),"^",14)
  i BillUomDr'="" s BillUom=$p(^CT("UOM",BillUomDr),"^",2)
  s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12) 
  q:phcdf="" ""
  s phcd=+phcdf
  s chl=$p(phcdf,"||",2)
  s gene=$p($g(^PHCD(phcd,4)),"^",1) 
  s:gene'="" genedesc=$p($g(^PHCGE("GE",gene)),"^",2)
  S manf=""
  s manfdr=$p($g(^PHCD(phcd,2)),"^",4)
  s:manfdr'="" manf=$p(^PHMNF(manfdr),"^",2)
  I $P(manf,"-",2)'="" S manf=$P(manf,"-",2)
  s formdr=$p(^PHCD(phcd,"DF",chl,1),"^",1)
  s:formdr'="" form=$p(^PHCF(formdr),"^",2)
  s instrucdr=$p(^PHCD(phcd,"DF",chl,1),"^",5)
  s:instrucdr'="" instruc=$p(^PHCIN(instrucdr),"^",2)
  S Fregen=$p(^PHCD(phcd,"DF",chl,3),"^",4)
  S geneyl=$P(Fregen,"||",2)	//原料通用名
  S goodsname=$p($g(^PHCD(phcd,2)),"^",8)	//商品名
  S goodsname=$p(goodsname,"||",1)
  S Spec=$$GetPhSpec(arcim)					//规格
  S InciDesc=$p($g(^INCI(inci,1)),"^",2)	//库存项名称
  q $g(genedesc)_"^"_$g(form)_"^"_$g(manf)_"^"_$g(instruc)_"^"_geneyl_"^"_goodsname_"^"_Spec_"^"_InciDesc_"^"_BillUom
GetPhSpec(Arcim)
 S Subs=$P(Arcim,"||",1)
 S Vers=$P(Arcim,"||",2)
 Q:Subs="" ""
 Q:Vers="" ""
 Q:'$D(^ARCIM(Subs,Vers)) ""
 S PhcdfID=$P(^ARCIM(Subs,Vers,1),"^",12)
 S PhcdID=$P(PhcdfID,"||",1)
 S PhcdfSub=$P(PhcdfID,"||",2)
 Q:PhcdID="" ""
 Q:PhcdfSub="" ""
 Q:'$D(^PHCD(PhcdID,"DF",PhcdfSub)) ""
 S BUomID=$P(^PHCD(PhcdID,"DF",PhcdfSub,2),"^",4)
 Q:BUomID="" ""
 S BQty=+$P(^PHCD(PhcdID,"DF",PhcdfSub,2),"^",5)
 Q:BQty=0 ""
 S EQSub=$O(^PHCD(PhcdID,"DF",PhcdfSub,"EQ",0))
 Q:EQSub="" ""
 Q:'$D(^PHCD(PhcdID,"DF",PhcdfSub,"EQ",EQSub)) ""
 S EQUomID=$P(^PHCD(PhcdID,"DF",PhcdfSub,"EQ",EQSub),"^",1)
 Q:EQUomID="" ""
 S EQUomDesc=$P($G(^CT("UOM",EQUomID)),"^",2)
 S EQQty=+$P(^PHCD(PhcdID,"DF",PhcdfSub,"EQ",EQSub),"^",2)
 S EQFac=EQQty/BQty
 S Spec=EQFac_EQUomDesc
 Q Spec
}

/// creater lxz 
/// desc 获取患者的诊断信息
/// input 就诊ID
/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetDiagnoseMesage(7817144)
ClassMethod GetDiagnoseMesage(PAADMDr) As DHCDoc.Interface.SQSH.List.Diagnosises
{
	
	s ObjMain=##class(DHCDoc.Interface.SQSH.List.Diagnosises).%New()
	s PAPMI=$P($G(^PAADM(PAADMDr)),"^",1)
	//增加患者诊断信息
	s mradm=$P(^PAADM(PAADMDr),"^",61)
	if mradm'=""  d
	.s subrowid=0 
	.f  s subrowid=$o(^MR(mradm,"DIA",subrowid)) q:subrowid=""  d 
	..s OneDia=##class(DHCDoc.Interface.SQSH.List.Diagnosise).%New()
	..s diagid=$p($g(^MR(mradm,"DIA",subrowid)),"^",1)
	..s diadate=$p($g(^MR(mradm,"DIA",subrowid)),"^",7)
	..s diatime=$p($g(^MR(mradm,"DIA",subrowid)),"^",8)
	..if (diagid'="") d
	...s mediadesc=$p(^MRC("ID",diagid),"^",2)
	...s mediacode=$p(^MRC("ID",diagid),"^",2)
	...s medianote=$p($g(^MR(mradm,"DIA",subrowid,"DES",1)),"^",1)
	..e  d
 	...s mediadesc=$p($g(^MR(mradm,"DIA",subrowid,"DES",1)),"^",1)
 	...s mediacode=mediadesc
 	...s medianote=""
 	..Q:mediadesc=""
 	..s OneDia.DiaCode=mediacode ;
 	..s OneDia.DiaName=mediadesc ;
 	..s OneDia.DiaNote=medianote
 	..s OneDia.DiaTime=$ZD(diadate,3)_" "_$ZT(diatime,1)
 	..do ObjMain.DiaList.Insert(OneDia)
 	
 	//增加患者过敏信息
 	Set rset=##Class(%ResultSet).%New("web.PAAllergy:Allergies")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(PAPMI)
		If 'Status Quit
		While (rset.Next()) {
			s ObjAller=##class(DHCDoc.Interface.SQSH.List.Allergichistory).%New()
			set Desc=rset.GetData(3)
			set OnsetDate=rset.GetData(7)
		   	set Active=rset.GetData(17)
		   	Continue:((Active'="Y")||(Desc=""))
		   	s ObjAller.AllergicDesc=Desc
		   	s ObjAller.AllLeftTime=$ZD(OnsetDate,3)_" "_"00:00:00"
		   	s ObjAller.AllRightTime=$ZD(+$H,3)_" "_"00:00:00"
		   	do ObjMain.Allergichistory.Insert(ObjAller)
		}
		d rset.Close()
	}
	Q ObjMain
}

/// creater lxz 
/// desc 获取患者基本信息
/// input 就诊ID
ClassMethod GetPatientInfoObj(PAADMDr) As DHCDoc.Interface.SQSH.List.PatientInfo
{
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	
	s Name=$p(^PAPER(PAPMIID,"ALL"),"^",1) ;姓名
	s PatYBCode=$p($g(^PAPER(PAPMIID,"ALL")),"^",19) ;医保Code
	s DOB=+$p(^PAPER(PAPMIID,"ALL"),"^",6) ;出生日期
	s Sex=+$p(^PAPER(PAPMIID,"ALL"),"^",7) ;性别
	s Sex=$P($G(^CT("SEX",Sex)),"^",1)
	s:DOB'="" DOB=$ZD(DOB,3)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
	s PatYBCode=$p($g(^PAPER(PAPMIID,"ALL")),"^",19) ;医保号
	s Telphone=$p(^PAPER(PAPMIID,"PER",1),"^",11) ;电话
	s CredNo=$p($g(^PAPER(PAPMIID,"PAT",3)),"^",6) ;证件号
	s CredTypeCode=$p(^PAPER(PAPMIID,"PAT",3),"^",7) ;证件类型
	s Email=$p(^PAPER(PAPMIID,"PER",4),"^",19) ;邮件
	
	//患者基本信息
	s PatientInfoObj=##class(DHCDoc.Interface.SQSH.List.PatientInfo).%New()
	s PatientInfoObj.PatientName=Name ;患者姓名
	s PatientInfoObj.PatientId=PatNo ;患者编号（非空）
	s PatientInfoObj.PatientCode=PatYBCode ;患者医保编号
	s PatientInfoObj.PatientNumber=CredNo ;患者证件号
	s PatientInfoObj.PatientPhone=Telphone ;患者手机
	s PatientInfoObj.PatientMail=Email ;患者邮箱
	s PatientInfoObj.PatientSex=Sex ;患者性别
	s PatientInfoObj.PatientBirthday=DOB ;患者出生年月(如：1981-05-06)
	s PatientInfoObj.SpecialCrowd="" ;患者所属特殊人群
	s PatientInfoObj.Weight="" ;患者体重(KG)（如：75.5)
	s PatientInfoObj.Height="" ;身高(cm)（如：168.5）
	s PatientInfoObj.BodyArea="" ;患者体表面积(平方米)（如：15.7）
	q PatientInfoObj
}

/// 获取频次的分发时间
ClassMethod getDisPising(freq, AdmType) As %String
{
	s timeStr=""
	if freq'=""  d
	.k timeStrList
	.s sub=0
	.f  s sub=$O(^PHCFR(freq,"DT",sub)) Q:sub=""  d
	..s distime=$G(^PHCFR(freq,"DT",sub))
	..Q:distime=""
	..s timeStrList(distime)=""
	.s sub=""
	.f  s sub=$O(timeStrList(sub)) Q:sub=""  d
	..s time1=sub
	..if timeStr="" s timeStr=$ZT(time1,2)
	..else  s timeStr=timeStr_"-"_$ZT(time1,2)
	q timeStr
}

/// 获取医嘱对应的唯一ID和主医嘱ID
ClassMethod getFillerNoOnlyID(OEOrdItemDr) As %String
{
	;如果是滚出来的医嘱按照滚出来的查找
	s mainforditemdr=""
	s OrderOnlyID=""
	s mainforditemdrstr=$p($g(^OEORD(+OEOrdItemDr,"I",$P(OEOrdItemDr,"||",2),9)),"^",12)
	if mainforditemdrstr'=""  d
	.s mainforditemdr=$P(mainforditemdrstr,"!!",1)
	.Q:mainforditemdr=""
	.s OrderOnlyID=$P($G(^OEORD(+mainforditemdr,"I",$P(mainforditemdr,"||",2),"LOCAL")),"^",..#DataLocation)
	
	if (mainforditemdr'=""){
		s:OrderOnlyID="" OrderOnlyID=mainforditemdr
		q mainforditemdr_"^"_OrderOnlyID	
	}else{
		s OrderOnlyID=$P($G(^OEORD(+OEOrdItemDr,"I",$P(OEOrdItemDr,"||",2),"LOCAL")),"^",..#DataLocation)
		s:OrderOnlyID="" OrderOnlyID=OEOrdItemDr
		q OEOrdItemDr_"^"_OrderOnlyID
	}
}

/// 获取唯一的ID 用于医嘱录入
/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetIDNum()
ClassMethod GetIDNum(PAADMDr) As %String
{
	s ID=$I(^DHCDocGetOnlyID("SQSH",PAADMDr))
	Q PAADMDr_ID
}

/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetExecDate("8034271||13")
ClassMethod GetExecDate(OrdRowId As %String)
{
	s ExecDate=""
	s child=$p(OrdRowId,"||",2)
	s ExecTime=0
	f  s ExecTime=$o(^OEORDi(0,"Date",+OrdRowId,+$h,ExecTime)) q:(ExecTime="")||(ExecDate'="")  d
	.i $d(^OEORDi(0,"Date",+OrdRowId,+$h,ExecTime,child))  d
	..s ExecDate=$zd(+$h,3)
	
	i ExecDate="" d
	.s child=$o(^OEORD(+OrdRowId,"I",$p(OrdRowId,"||",2),"X",0))
	.q:child=""
	.s ExecDate=$p(^OEORD(+OrdRowId,"I",$p(OrdRowId,"||",2),"X",child),"^",1)
	.b ;whq2
	.s:ExecDate'="" ExecDate=$zd(ExecDate,3)
	
	q ExecDate
}

Storage Default
{
<Data name="PublicMethDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Interfac5B93.PublicMethD</DataLocation>
<DefaultData>PublicMethDefaultData</DefaultData>
<IdLocation>^DHCDoc.Interfac5B93.PublicMethD</IdLocation>
<IndexLocation>^DHCDoc.Interfac5B93.PublicMethI</IndexLocation>
<StreamLocation>^DHCDoc.Interfac5B93.PublicMethS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
