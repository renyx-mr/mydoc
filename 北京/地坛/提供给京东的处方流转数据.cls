Class DHCDoc.Interface.SQSH.PublicMeth Extends %RegisteredObject
{
/// 患者+就诊编码+医生唯一编码
ClassMethod GetOrderMesageJD(PAADMDr, IP, UserID, CTLocID,OEOrdItemIDs As %String) As DHCDoc.Interface.SQSH.DataPackage
{
	s needSend="N"
	Q:PAADMDr="" "-1"
	Q:OrderStr="" "-1"
	s PAPMIID=$P($G(^PAADM(PAADMDr)),"^",1)
	s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
	s MainPriseNO=PatNo_"||"_PAADMDr_"||"_UserID ;处方审核的唯一标志
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;处方类型
	q:PriseType'="O" ""
	s PriseType="门诊"
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
	
	d ..GetSavedOrderJD(PAADMDr,.OutObj,OEOrdItemIDs)
	j ##class(web.DHCENS.BLL.HLWYY.Method.AdvancePrescriptionAudit).SendPrescriptionData(##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Request").Read())
	q OutObj
}
/// 获取已经审核的医嘱项目
/// w ##class(DHCDoc.Interface.SQSH.PublicMeth).GetSavedOrder(7911343,"")
ClassMethod GetSavedOrderJD(PAADMDr, OutObj As %ObjectHandle,OEOrdItemIDs As %String) As %String
{
	q:OEOrdItemIDs=""
	s OrderLen=$L(OEOrdItemIDs,"^")
	s PAADMType=$P($G(^PAADM(PAADMDr)),"^",2) ;患者类型
	k OrdPrescNoList($j)
	f OEOrdItemInd=1:1:OrderLen 
	{
		S OneOrderStr=$P(OEOrdItemIDs,"^",OEOrdItemInd)
		s OrderIDGet=$P(OneOrderStr,"*",2)
		continue:OrderIDGet=""
		s ArcimRowId=$p($p(OrderStr,"^",OEOrdItemInd),"*",1)
		continue:ArcimRowId=""
		s OrdPrescNo=$p($g(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),1)),"^",14)
		continue:OrdPrescNo=""
		s InciDr=##class(web.DHCOutPhCommon).GetInciByOrditm(OrderIDGet)
		continue:InciDr=""
		s INFOSeparateBuyFlag=##class(PHA.COM.Drug).INFOSeparateBuyFlagByInci(InciDr)
		continue:INFOSeparateBuyFlag'="Y"
		s statcode="V"
		s statdr=$P($G(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),1)),"^",13)
		i statdr'="" d
		.s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
		continue:statcode'="V"
		s UserAdd=$p($g(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),7)),"^",1) //医嘱录入人
		continue:UserAdd=""
		s UserDepartId=$p($g(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),7)),"^",2) //下医嘱科室
		continue:UserDepartId=""
		if ($g(OrdPrescNoList($j,OrdPrescNo))=""){
			s OrdPrescNoList($j,OrdPrescNo)=OrderIDGet
		}else{
			s OrdPrescNoList($j,OrdPrescNo)=$g(OrdPrescNoList($j,OrdPrescNo))_"^"_OrderIDGet
		}
	}
	s Presno=0
	for {
		s Presno=$o(OrdPrescNoList($j,Presno))
		q:Presno=""
		s QueRowId=$o(^PAQUE1(0,"PrescNo",Presno,0))
		continue:QueRowId=""
		s PresLoc=$P($G(^PAQUE1(QueRowId)),"^",4) //开单科室
		s PresCtpcpdr=$P($G(^PAQUE1(QueRowId)),"^",5) //开单医生
		s transDate=$P($G(^PAQUE1(QueRowId)),"^",7) //开单日期
		s transTime=$P($G(^PAQUE1(QueRowId)),"^",8) //开单时间
		s UserID=$O(^SSU("SSUSR",0,"CTPCP",PresCtpcpdr,0)) //开单人对应的用户
		s FeeItemsObj=##class(DHCDoc.Interface.SQSH.List.FeeItems).%New()
		s OrdItemDrStr=$g(OrdPrescNoList($j,Presno))
		s FindAcitveOrd="N"
		for OrdItemInd=1:1:$l(OrdItemDrStr,"^"){
			s OneOrdItemDr=$p(OrdItemDrStr,"^",OrdItemInd)
			continue:OneOrdItemDr=""
			s statcode="V"
			s statdr=$P($G(^OEORD(+OneOrdItemDr,"I",$p(OneOrdItemDr,"||",2),1)),"^",13)
			i statdr'="" d
			.s statcode=$p($g(^OEC("OSTAT",statdr)),"^",1)
			Q:statcode'="V"
			s oneOneDugs=..getOneDugsJD(OneOrdItemDr,PAADMType)
			d FeeItemsObj.Drugs.Insert(oneOneDugs)
			s UserAdd=$p($g(^OEORD(+OneOrdItemDr,"I",$p(OneOrdItemDr,"||",2),7)),"^",1) //医嘱录入人
			s:((UserID="")||(UserAdd'="")) UserID=UserAdd
			s UserDepartId=$p($g(^OEORD(+OneOrdItemDr,"I",$p(OneOrdItemDr,"||",2),7)),"^",2) //下医嘱科室
			s:((PresLoc="")&&(UserDepartId'="")) PresLoc=UserDepartId
			s FindAcitveOrd="Y"
			
		}
		continue:FindAcitveOrd'="Y"
		continue:UserID="" //没有医嘱录入人的项目不上传
		continue:PresLoc="" //没有录入科室不上传
		s OrdCtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14)
		if ((OrdCtpcpDr'="")&&(OrdCtpcpDr'=PresCtpcpdr))  d
		.s PresCtpcpdr=OrdCtpcpDr
		s CTLocDesc=$P($G(^CTLOC(PresLoc)),"^",2) //科室描述
		s CTLocCode=$P($G(^CTLOC(PresLoc)),"^",1) //科室Code
		s CtpcpDr=$p($g(^SSU("SSUSR",UserID)),"^",14) //医护人员
		s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
		s CtpcpName=""
		s:PresCtpcpdr'="" CtpcpName=$p($g(^CTPCP(PresCtpcpdr,1)),"^",2) //医生姓名
		s:CtpcpName="" CtpcpName=$p($g(^SSU("SSUSR",UserID)),"^",2)
		s CtpcpTypeDesc=""
		if PresCtpcpdr'=""  d
		.s CtpcpType=$P(^CTPCP(PresCtpcpdr,1),"^",4)
		.s CtpcpTypeDesc=""
		.s:CtpcpType'="" CtpcpTypeDesc=$P($G(^CT("CPT",CtpcpType)),"^",2)
		s FeeItemsObj.PrescriptionId=Presno //处方唯一标识（非空）
		s FeeItemsObj.DoctorDepartmentId=CTLocCode //开方科室Id
		s FeeItemsObj.DoctorDepartmentName=CTLocDesc //开方科室名称
		s FeeItemsObj.DoctorLevel=CtpcpTypeDesc //开方医师级别
		s FeeItemsObj.DoctorId=SSUSRInitials //开方医师编号
		s FeeItemsObj.DoctorName=CtpcpName //开方医师姓名
		s FeeItemsObj.PrescriptionDate=$ZD(transDate,3)_" "_$ZT(transTime,1) //开方时间（格式）
		s FeeItemsObj.DispenseDepartmentId="" //发药科室Id
		s FeeItemsObj.DispenseDepartmentName="" //发药科室名称
		s FeeItemsObj.DispenseDoctorId="" //发药医生ID
		s FeeItemsObj.DispenseDoctorName="" //发药医生名称
		s FeeItemsObj.DispenseDate="" //发药日期(2013-03-29)（格式）
		s FeeItemsObj.Insurance=AdmReason //医保属性
		s FeeItemsObj.Remark="" //处方备注
		d OutObj.FindOrders.Insert(FeeItemsObj)
	}
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

ClassMethod GetPrescriptionBase64(PrescNo As %String)
{
	s PrescriptionObj=##class(%DynamicObject).%New()
	; platformTenantId	京东租户id	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformTenantId","")
	; platformHospitalCode	京东医院编码	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformHospitalCode","")
	; hospitalName	医院名称	String	Y	
	d PrescriptionObj.%Set("hospitalName","")
	; platformProviderCode	京东接入商编码	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformProviderCode","")
	; thirdPrescriptionNo	三方处方号	String	Y	
	d PrescriptionObj.%Set("thirdPrescriptionNo",PrescNo)
	; jdRxid	京东处方id	Long	N	京东处方单号
	d PrescriptionObj.%Set("jdRxid","")
	; qrCodeReturnType	二维码返回类型	Integer	N	1下载链接（默认）2BASE64字节数组
	d PrescriptionObj.%Set("qrCodeReturnType","2")
	s InputXml=#class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Request").Read()
	s OutputStr=##class(web.DHCENS.BLL.HLWYY.Method.PrescriptionMedicationGuidance).SendMedicationGuidance(InputXml)
	s QrCodeData=""
	s:OutputStr["</qrCodeData>" QrCodeData=$p($p(OutputStr,"</qrCodeData>"),"<qrCodeData>",2)
	q QrCodeData
}
ClassMethod SendStopPrescToJD(PrescNo As %String)
{
	s PrescriptionObj=##class(%DynamicObject).%New()
	; platformTenantId	京东租户id	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformTenantId","")
	; platformHospitalCode	京东医院编码	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformHospitalCode","")
	; hospitalName	医院名称	String	Y	
	d PrescriptionObj.%Set("hospitalName","")
	; platformProviderCode	京东接入商编码	String	Y	京东健康提供
	d PrescriptionObj.%Set("platformProviderCode","")
	; thirdPrescriptionNo	三方处方号	String	Y	
	d PrescriptionObj.%Set("thirdPrescriptionNo",PrescNo)
	; jdRxid	京东处方id	Long	N	京东处方单号
	d PrescriptionObj.%Set("jdRxid","")
	; qrCodeReturnType	二维码返回类型	Integer	N	1下载链接（默认）2BASE64字节数组
	d PrescriptionObj.%Set("qrCodeReturnType","2")
	s InputXml=#class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Request").Read()
	d ##class(web.DHCENS.BLL.HLWYY.Method.PrescriptionMedicationGuidance).SendMedicationGuidance(InputXml)
	q 0
}

}