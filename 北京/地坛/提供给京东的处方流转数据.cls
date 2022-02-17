Class DHCDoc.Interface.SQSH.PublicMeth Extends %RegisteredObject
{
/// 患者+就诊编码+医生唯一编码
ClassMethod GetOrderMesageJD(PAADMDr, IP, UserID, CTLocID) As DHCDoc.Interface.SQSH.DataPackage
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
	
	d ..GetSavedOrderJD(PAADMDr,.OutObj)
	s needSend="Y"
	q OutObj
}
/// 获取已经审核的医嘱项目
/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetSavedOrder(7911343,"")
ClassMethod GetSavedOrderJD(PAADMDr, OutObj As %ObjectHandle) As %String
{
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	if (PAADMType'="I"){
		//门急诊不上传历史  方案没有确定
		q:..#OPNewversion=0
		
		//提取门诊处方信息
		d ..GetOPSavedOrderJD(PAADMDr,.OutObj)
		
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
		...d ..GetOPSavedOrderJD(AdmRowID,.OutObj)

	}else{
		//提取住院处方信息
		d ..GetIPSavedOrderJD(PAADMDr,.OutObj)
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
		d OEOrderVersionJD()
	}elseif (..#version=2){
		d OEExecVersionjD()
	}
	q 
OEOrderVersionJD()
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
	.d SetOneListJD()
	
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
	.d SetOneListJD()
	.s ^TempOrdFindSave($J,orderdr,ordersubdr)=""
	k ^TempOrdFindSave($J)
	q
OEExecVersionJD()	
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
	..d SetOneListJD()
	k ^TempOrdFindSave($J)
	q
SetOneListJD()
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
	.s oneOneDugs=..getOneDugsJD(orderdr_"||"_ordersubdr,PAADMType)
	.d FeeItemsObj.Drugs.Insert(oneOneDugs)
	.d OutObj.FindOrders.Insert(FeeItemsObj) //将一个处方信息插入到对应的已保存医嘱信息中
	q
}

/// 按照门诊就诊记录获取处方信息
ClassMethod GetOPSavedOrderJD(PAADMDr, OutObj As %ObjectHandle) As %String
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
	..s oneOneDugs=..getOneDugsJD(orderdr_"||"_ordersubdr,PAADMType)
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
ClassMethod getOneDugsJD(OrderItemRowID, AdmType) As %ObjectHandle
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
	.s OneDur.DrugOrder=orderdr_"||"_ordersubdr //药品开药顺序，升序
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
}