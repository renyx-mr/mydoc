Class DHCDoc.GanSuProvincialPlatform.IntellectualTrialCommon Extends %RegisteredObject
{

/// 3.3.1门诊接诊3101
ClassMethod OPSeeDoctor(AdmDr As %String)
{
	s AdmIbfo=##class(DHCDoc.GetInfo.Method.Register).GetPAAdmInfo()
	s AdmObj=##class(User.PAAdm).%OpenId(AdmDr)
	s OutPutObj={}
	s RetStr=""
	if $ISOBJECT(AdmIbfo) {
		s OutPutObj.clinicType=..GetAdmType(AdmDr)	;varchar(3)	Y	就诊类型
		s OutPutObj.outpatientNum=AdmDr	;varchar(20)	Y	门诊号
		s OutPutObj.depaCode=AdmObj.PAADMDepCodeDRGetObjectId()	;varchar(16)	Y	科室编码
		s OutPutObj.hosDepaName=AdmObj.PAADMDepCodeDR.CTLOCDesc	;varchar(64)	Y	医院科室名称
		s OutPutObj.hosDoctorCode=AdmObj.PAADMAdmDocCodeDRGetObjectId()	;varchar(16)	Y	医院医生编码
		s OutPutObj.doctorName=AdmObj.PAADMAdmDocCodeDR.CTPCPDesc	;varchar(64)	Y	医生姓名
		s acceptsSign=1
		if AdmObj.PAADMAdmReadm="R" s acceptsSign=2
		s OutPutObj.acceptsSign=acceptsSign	;varchar(1)	Y	接诊标识
		s RetStr=""
	}else{
		s RetStr="未找到改条就诊"
	}
	do AdmObj.%Close()
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

/// 3.3.2 门诊录入诊断3102
ClassMethod OPSaveDiagnos(AdmDr As %String, MRAdmDr As %String)
{
	;Diagnosis			;诊断明细项	循环体，见诊断明细3.3.2.1。
	;mainSuit	;varchar(500)	N	主诉	患者向医师描述本次疾病的主要感受记录
	;symptomDesc	;varchar(500)	N	症状描述	接诊医生对患者症状的简要描述
	;cliFeature	;varchar(500)	N	临床表现	
	;drugAllergyHis	;varchar(500)	N	药物过敏史	
	;previousHistory	;varchar(500)	N	既往史	
	;SignsInfo			;体征信息项	见体征信息3.3.2.2
	
	s OutPutObj={}
	//s AdmObj=##class(User.PAAdm).%OpenId(AdmDr)
	//if $ISOBJECT(AdmObj){
		
	//}
	
	//d AdmObj.%Close()
	s DiagnoInfoList=[]
	s Childsub=0
	f {
		s Childsub=$o(^MR(MRAdmDr,"DIA",Childsub))
		q:Childsub=""
		s DiagnosDr=MRAdmDr_"||"_Childsub
		s DiagnosInfo=..GetDiagnosInfo(DiagnosDr)
		d DiagnoInfoList.%Push(DiagnosInfo)
	}
	s OutPutObj.Diagnosis=DiagnoInfoList
	s OutPutObj.mainSuit=""
	s OutPutObj.symptomDesc=""
	s OutPutObj.cliFeature=""
	s OutPutObj.drugAllergyHis=""
	s OutPutObj.previousHistory=""
	s OutPutObj.SignsInfo=..GetPatAdmInfo(MRAdmDr)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

///  诊断明细
ClassMethod GetDiagnosInfo(MRDIARowId As %String)
{
	;diagNum	;varchar(32)	Y	诊断序号	
	;outpDiagCode	;varchar(20)	Y	门诊诊断编码	西医按ICD-10；中医按国标GB/T 15657-1995；
	;outpDiagDesc	;varchar(200)	N	门诊诊断说明
	s Diagnos={}
	s DiagObj=##class(User.MRDiagnos).%OpenId(MRDIARowId)
	if $ISOBJECT(DiagObj) {
		s ICDDxObj=##class(User.MRCICDDx).%OpenId(DiagObj.MRDIAICDCodeDRGetObjectId())
		if $ISOBJECT(ICDDxObj) {
			s Diagnos.diagNum=$p(MRDIARowId,"||",2)
			s Diagnos.outpDiagCode=ICDDxObj.MRCIDCode
			s Diagnos.outpDiagDesc=ICDDxObj.MRCIDDesc
			do ICDDxObj.%Close()
		}
	}	
	d DiagObj.%Close()
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(DiagObj,"BODY","")
}

/// 体征信息
ClassMethod GetPatAdmInfo(MRAdmDr As %String)
{
	;height	;decimal(6,2)	N	身高	单位为“cm”
	;weight	;decimal(6,2)	N	体重	单位为“kg”
	;personHeat	;decimal(4,2)	N	体温	单位为“摄氏度”
	;heartRate	;decimal(3,0)	N	心率	bpm，单位为“次/分钟”
	;respiratoryRate	;decimal(3,0)	N	呼吸频率	数量单位为“次/分钟”
	;bloodType	;varchar(2)	N	血型	2位字符编码第1位采用卫生部CV5103.02 ABO血型代码，0：O型、1：A型、2：B型、3：AB型、5：不详；第2位，0：未做；1：Rh阴；2：Rh阳 3.不详
	;systolicPressure	;decimal(6,2)	N	收缩压	毫米汞柱 数量单位为“mmHg”
	;diastolicPressure	;decimal(6,2)	N	舒张压	毫米汞柱 数量单位为“mmHg”
	;fastingBloodSugar	;decimal(6,2)	N	空腹血糖值	毫摩尔/升 数量单位为“mmol/L”受检者空腹血液葡萄糖定量检测结果值
	;postprandialBloodSugar	;decimal(6,2)	N	餐后血糖值	毫摩尔/升 数量单位为“mmol/L”受检者餐后两小时血糖测量值
	;isFetation	;varchar(1)	N	是否怀孕	0：否；1：是
	;gestation	;decimal(2,0)	N	孕期	周数
	;isSucklingPeriod	;varchar(1)	N	是否哺乳期	0：否；1：是
	s MRAdmInfo={}
	s MRAdmObj=##class(User.MRAdm).%OpenId(MRAdmDr)
	if $ISOBJECT(MRAdmObj) {
		s MRAdmInfo.height=MRAdmObj.MRADMHeight
		s MRAdmInfo.weight=MRAdmObj.MRADMWeight
		s MRAdmInfo.personHeat=""
		s MRAdmInfo.heartRate=""
		s MRAdmInfo.respiratoryRate=""
		s MRAdmInfo.bloodType=""
		s MRAdmInfo.systolicPressure=$p($g(^MR(MRAdmDr,"DHC")),"^",8)
		s MRAdmInfo.diastolicPressure=$p($g(^MR(MRAdmDr,"DHC")),"^",9)
		s MRAdmInfo.fastingBloodSugar=""
		s MRAdmInfo.postprandialBloodSugar=""
		s MRAdmInfo.isFetation=""
		s MRAdmInfo.gestation=""
		s MRAdmInfo.isSucklingPeriod=""
	}
	d MRAdmObj.%Close()
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(MRAdmInfo,"BODY","")
}

/// 3.3.3 门诊/药店处方信息录入3103
ClassMethod OPCheckOEOrdItemInfo(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String)
{
	s OutPutObj={}
	s OutPutObj.clinicType=..GetAdmType(Adm)	;varchar(3)	Y	就诊类型	见基础数据字典 6.1.1就诊类型
	s OutPutObj.outpatientNum=Adm	;varchar(20)	Y	门诊号	
	s OutPutObj.recipeNum=""	;varchar(20)	N	处方号	
	s OutPutObj.depaCode=$p($g(^CTLOC(Loc)),"^",1)	;varchar(16)	Y	科室编码	参考当地结算系统中的“科室” 编码见数据字典 7.1.7科室
	s OutPutObj.hosDepaName=$p($g(^CTLOC(Loc)),"^",2)	;varchar(64)	Y	医院科室名称	填写医院内部科室名称或见数据字典 7.1.7科室
	s OutPutObj.hosDoctorCode=$p($g(^CTPCP(Doc,1)),"^",1)	;varchar(16)	N	医院医生编码	医保备案的医师编码
	s OutPutObj.doctorName =$p($g(^CTPCP(Doc,1)),"^",2) ;varchar(64)	Y	医生姓名	
	;PRESCRIPTION			收费明细列表
	;PRESCRIPTION.Drug			药品明细项	循环体，见药品明细3.3.3.1
	;PRESCRIPTION.NonDrug			非药品明细项	循环体，见非药品明细3.3.3.2
	s DrugList=[]
	s NonDrugList=[]
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount {
		Set OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		Set ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		Set OrderType=$p(OrdItem,"^",2)
		if (OrderType="R"){
			s DrugInfo=..GetCheckDrugInfo(Adm,OrdItem,"1")
			d DrugList.%Push(DrugInfo)
		}else{
			s NonDrugInfo=..GetCheckNonDrugInfo(Adm,OrdItem,"1")
			d NonDrugList.%Push(NonDrugInfo)
		}
	}
	s NodeList("DrugTr","ChildNode")="Drug"
	s NodeList("NonDrugTr","ChildNode")="NonDrug"
	s OutPutObj.PRESCRIPTION=
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"DrugTr",.NodeList).Read(),"<DrugTr>",2),"</DrugTr>",1)_
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrugTr",.NodeList).Read(),"<NonDrugTr>",2),"</NonDrugTr>",1)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

/// 药品明细项
ClassMethod GetCheckDrugInfo(AdmDr As %String, OrdItem As %String, OperationType As %String)
{
	s DrugObj={}
	;s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID)
	;if $ISOBJECT(OrdObj) {
		s DrugObj.adviceId=$p(OrdItem,"^",1)	;varchar(20)	Y	医嘱ID	医嘱ID是医院内部唯一标识一条医嘱的顺序号
		s DrugObj.adviceIdoperationType=OperationType	;varchar(1)	Y	操作类型	1：保存；2：删除；
		s DrugObj.costStartTime=$tr($zd(+$H,3),"-","")_"/"_$tr($zt($P($H,",",2),1),":","")	;datetime	Y	费用发生时间	日期时间格式A：YYYYMMDD/HHMISS/
		Set startdate=$p(OrdItem,"^",4)
		if startdate="" s SttDate=$P($H,",",1)
		e  Set SttDate=startdate //$$zdhFormat(startdate)
		Set starttime=$p(OrdItem,"^",5)
		if starttime="" s SttTime=$P($H,",",2)
		;e  if ($zth(starttime)<$P($H,",",2)) s SttTime=$P($H,",",2)
		e  Set SttTime=$zth(starttime)
		s DrugObj.startUseTime=$tr($zd(starttime,3),"-","")_"/"_$tr($zt(starttime,1),":","")	;datetime	Y	开始使用时间	日期时间格式A： YYYYMMDD/HHNNSS/该收费明细执行的日期，尽量精确到时分秒；如当场下达的“换药”第二天执行。
		Set ARCIMRowid=$p(OrdItem,"^",1)
		s DrugObj.hosItemCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1) ;OrdObj.OEORIItmMastDR.ARCIMCode	;varchar(20)	Y	医院项目代码	医院内自编的唯一标识该收费的编码
		s DrugObj.itemName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2) ;OrdObj.OEORIItmMastDR.ARCIMDesc	;varchar(200)	Y	项目名称	医院内部收费项目名称
		s DrugObj.heaInsItemCode=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ARCIMRowid,"")	;varchar(20)	Y	医保项目代码	由医保统一要求的收费编码
		s DrugObj.medPathway=""	;varchar(4)	N	用药途径	见基础数据字典 6.1.5用药途径
		s DrugObj.takeRequire=""	;varchar(2)	N	服用要求	见基础数据字典 6.1.6服用要求
		s DrugObj.takeRequireDesc=""	;varchar(200)	N	服用要求说明	在“服用要求”为“99”时，补充具体的文字描述内容
		s DrugObj.oneUseDose=$p(OrdItem,"^",12)	;varchar(10)	Y	单次使用剂量△	数值，中药饮片时为“0”
		s DrugObj.oneUseDoseUnit=""	;varchar(10)	N	单次使用剂量单位△	参考当地结算系统中的“计价单位” 编码，中药饮片时为空见数据字典 7.1.10计价单位
		s DrugObj.medFrequencyCode=..GetFrequencyCode("")	;varchar(3)	Y	用药频次代码	参考当地结算系统中的“用法标准” 编码，填代码见数据字典 7.1.11用法标准
		s DrugObj.medAim=""	;varchar(1)	N	给药目的	1：预防；2：应急；3：治疗；4：诊断；9：其他
		s DurRowid=$p(OrdItem,"^",16)
		s DrugObj.medDays=$P($g(^PHCDU(DurRowid)),"^",2) ;OrdObj.OEORIDuratDR.PHCDUCode	;varchar(5)	Y	用药天数	本条处方发药数量可使用天数，数值
		s PAADMRegConDisDR=$P($G(^PAADM(AdmDr,"DHC")),"^",25)
		s ExpStr="^"_""_"^"_AdmDr_"^"_$p(OrdItem,"^",8)_"^^"
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", ARCIMRowid, SttDate, $p(OrdItem,"^",3), "", "", "",$p(OrdItem,"^",8),PAADMRegConDisDR,"","")
		s OrderPrice=$P(retPrice,"^",1)
		s DrugObj.price=OrderPrice	;varchar(10)	Y	单价	数值
		s InciDr=$o(^INCI(0,"ARCIM_DR",+ARCIMRowid,0))
		s OutUomId=$p($g(^INCI(InciDr,1)),"^",12)
		s:OutUomId'="" DrugObj.valuateUnit=$p($g(^CT("UOM",OutUomId)),"^",2)	;varchar(10)	Y	计价单位△	参考当地结算系统中的“计价单位” 编码见数据字典 7.1.10计价单位
		s DrugObj.num=$p(OrdItem,"^",6)	;varchar(5)	Y	数量△	数值，发药数量（由用法用量和天数计算得出，精确到最小单位，不可修改）
		s bUomId=$p($g(^INCI(InciDr,1)),"^",10)
		s outUomId=$p($g(^INCI(InciDr,1)),"^",12)
		s DrugObj.conversionRatio=##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId,outUomId)	;decimal(10,4)	Y	转换比	最小使用单位与计价单位的比值（如计价单位是盒，最小使用单位是粒，一盒10粒，转换比就是10）
		s DrugObj.heaInsUseSign=""	;varchar(1)	N	医保限制使用标志	0：无要求；1：不符合限用规定；2：符合限用规定
		s DrugObj.compoundSign=""	;varchar(2)	N	联合用药/复方标识	对于中药饮片，同一方子的各味中药饮片归入“复方编号”进行归类；存在多个方子时，编号从“01”开始编列。对于非中药饮片，存在联合用药时，“复方编号”进行归类表示这组药是联合用药；非联合用药或者单方时缺省为“00”
		s DrugObj.nonFried=""	;varchar(1)	N	免煎	中药饮片需要免煎时填写，否则本项可以空缺 0：无要求；1：免煎
		s DrugObj.skinTest=""	;varchar(1)	N	皮试	需要皮试时填写，否则本项可以空缺 0：无要求；1：需要皮试 规定要做皮试的药物，必须在处方上注明
		s sumPaySign="1"
		if $p(OrdItem,"^",23)="Y" s sumPaySign="0"
		s DrugObj.sumPaySign=sumPaySign	;varchar(1)	Y	全额自费标识	0：医保；1：自费
	;}
	;d OrdObj.%Close()
	q DrugObj
}

/// 非药品明细项
ClassMethod GetCheckNonDrugInfo(AdmDr As %String, OrdItem As %String, OperationType As %String)
{
	s DrugObj={}
	;s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID)
	;if $ISOBJECT(OrdObj) {
		
		s DrugObj.adviceId=$p(OrdItem,"^",1)	;varchar(20)	Y	医嘱ID	医嘱ID是医院内部唯一标识一条医嘱的顺序号
		s DrugObj.operationType=OperationType	;varchar(1)	Y	操作类型	1：保存；2：删除；
		s DrugObj.costStartTime=$tr($zd(+$H,3),"-","")_"/"_$tr($zt($P($H,",",2),1),":","")	;datetime	Y	费用发生时间	日期时间格式A： YYYYMMDD/HHNNSS/
		Set startdate=$p(OrdItem,"^",4)
		if startdate="" s SttDate=$P($H,",",1)
		e  Set SttDate=startdate //$$zdhFormat(startdate)
		Set starttime=$p(OrdItem,"^",5)
		if starttime="" s SttTime=$P($H,",",2)
		;e  if ($zth(starttime)<$P($H,",",2)) s SttTime=$P($H,",",2)
		e  Set SttTime=$zth(starttime)
		s DrugObj.startUseTime=$tr($zd(starttime,3),"-","")_"/"_$tr($zt(starttime,1),":","")	;datetime	Y	开始使用时间	日期时间格式A：YYYYMMDD/HHNNSS/该收费明细执行的日期
		Set ARCIMRowid=$p(OrdItem,"^",1)
		s DrugObj.hosItemCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)	;varchar(20)	Y	医院项目代码	医院内自编的唯一标识该收费的编码
		s DrugObj.itemName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)	;varchar(200)	Y	项目名称	医院内部收费项目名称
		s DrugObj.heaInsItemCode=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ARCIMRowid,"")	;varchar(20)	Y	医保项目代码	由医保统一要求的收费编码
		s PAADMRegConDisDR=$P($G(^PAADM(AdmDr,"DHC")),"^",25)
		s ExpStr="^"_""_"^"_AdmDr_"^"_$p(OrdItem,"^",8)_"^^"
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", ARCIMRowid, SttDate, $p(OrdItem,"^",3), "", "", "",$p(OrdItem,"^",8),PAADMRegConDisDR,"","")
		s OrderPrice=$P(retPrice,"^",1)
		s DrugObj.price=OrderPrice	;varchar(10)	Y	单价	数值
		s DrugObj.valuatePrice=""	;varchar(10)	N	计价价格 △	数值，对于分次使用的材料，则：计价价格 ＝ 单价 / 分次次数；且单笔明细的数量只能计为1
		s InciDr=$o(^INCI(0,"ARCIM_DR",+ARCIMRowid,0))
		s OutUomId=$p($g(^INCI(InciDr,1)),"^",12)
		s:OutUomId'="" DrugObj.valuateUnit=$p($g(^CT("UOM",OutUomId)),"^",2)	;varchar(10)	Y	计价单位	参考当地结算系统中的“计价单位” 编码见数据字典 7.1.10计价单位
		s DrugObj.num=$p(OrdItem,"^",6)	;varchar(5)	Y	数量 △	数值
		s DrugObj.imageExamCode=""	;varchar(1)	N	影像检查部位编码	对于影像检查医嘱，说明被检查的部位大类见数据字典 7.1.26检查部位
		s DrugObj.heaInsUseSign=""	;varchar(1)	N	医保限制使用标志	0：无要求；1：不符合限用规定；2：符合限用规定
		s DrugObj.useDesc=""	;varchar(200)	N	使用说明	使用该非药品项目的简要说明
		s DrugObj.setNumCode=""	;varchar(20)	N	套件/组号编号	材料有散件组合套件，或者医嘱进行编组管理时，需要上传以示区分
		s sumPaySign="1"
		if $p(OrdItem,"^",23)="Y" s sumPaySign="0"
		s DrugObj.sumPaySign=sumPaySign	;varchar(1)	Y	全额自费标识	0：医保；1：自费
	;}
	;d OrdObj.%Close()
	q DrugObj
}

ClassMethod OPSaveOEOrdItemInfo(AdmDr As %String, OrderStr As %String)
{
	s OutPutObj={}
	s OutPutObj.clinicType=..GetAdmType(AdmDr)	;varchar(3)	Y	就诊类型	见基础数据字典 6.1.1就诊类型
	s OutPutObj.outpatientNum=AdmDr	;varchar(20)	Y	门诊号	
	s OutPutObj.recipeNum=""	;varchar(20)	N	处方号	
	;PRESCRIPTION			收费明细	
	;PRESCRIPTION.Drug			药品明细	循环体，见药品明细3.3.3.1
	;PRESCRIPTION.NonDrug			非药品明细	循环体，见非药品明细3.3.3.2
	s DrugList=[]
	s NonDrugList=[]
	
	For i=1:1:$l(OrderStr,"^") {
		s ArcimRowId=$p($p(OrderStr,"^",i),"*",1)
		s newOrdIdDR=$p($p(OrderStr,"^",i),"*",2)
		i ArcimRowId="" continue
		s statcode="V"
		s TtemStat=$P($G(^OEORD(+newOrdIdDR,"I",+$p(newOrdIdDR,"||",2),1)),"^",13)
		i TtemStat'="" d
		.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
		continue:statcode'="V"
		s ItemCatRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		if (OrderType="R"){
			s DrugInfo=..GetSaveDrugInfo(AdmDr,newOrdIdDR,"1")
			d DrugList.%Push(DrugInfo)
		}else{
			s NonDrugInfo=..GetSaveNonDrugInfo(AdmDr,newOrdIdDR,"1")
			d NonDrugList.%Push(NonDrugInfo)
		}
	}
	s NodeList("DrugTr","ChildNode")="Drug"
	s NodeList("NonDrugTr","ChildNode")="NonDrug"
	s OutPutObj.PRESCRIPTION=
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"DrugTr",.NodeList).Read(),"<DrugTr>",2),"</DrugTr>",1)_
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrugTr",.NodeList).Read(),"<NonDrugTr>",2),"</NonDrugTr>",1)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

/// 药品明细项
ClassMethod GetSaveDrugInfo(AdmDr As %String, OEORIRowID As %String, OperationType As %String)
{
	s DrugObj={}
	s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID)
	if $ISOBJECT(OrdObj) {
		s DrugObj.adviceId=OEORIRowID	;varchar(20)	Y	医嘱ID	医嘱ID是医院内部唯一标识一条医嘱的顺序号
		s DrugObj.adviceIdoperationType=OperationType	;varchar(1)	Y	操作类型	1：保存；2：删除；
		s DrugObj.costStartTime=$tr($zd(OrdObj.OEORIDate,3),"-","")_"/"_$tr($zt(OrdObj.OEORITime,1),":","")	;datetime	Y	费用发生时间	日期时间格式A：YYYYMMDD/HHMISS/
		s DrugObj.startUseTime=$tr($zd(OrdObj.OEORISttDat,3),"-","")_"/"_$tr($zt(OrdObj.OEORISttTim,1),":","")	;datetime	Y	开始使用时间	日期时间格式A： YYYYMMDD/HHNNSS/该收费明细执行的日期，尽量精确到时分秒；如当场下达的“换药”第二天执行。
		s DrugObj.hosItemCode=OrdObj.OEORIItmMastDR.ARCIMCode	;varchar(20)	Y	医院项目代码	医院内自编的唯一标识该收费的编码
		s DrugObj.itemName=OrdObj.OEORIItmMastDR.ARCIMDesc	;varchar(200)	Y	项目名称	医院内部收费项目名称
		s DrugObj.heaInsItemCode=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(OrdObj.OEORIItmMastDRGetObjectId(),"")	;varchar(20)	Y	医保项目代码	由医保统一要求的收费编码
		s DrugObj.medPathway=""	;varchar(4)	N	用药途径	见基础数据字典 6.1.5用药途径
		s DrugObj.takeRequire=""	;varchar(2)	N	服用要求	见基础数据字典 6.1.6服用要求
		s DrugObj.takeRequireDesc=""	;varchar(200)	N	服用要求说明	在“服用要求”为“99”时，补充具体的文字描述内容
		s DrugObj.oneUseDose=OrdObj.OEORIDoseQty	;varchar(10)	Y	单次使用剂量△	数值，中药饮片时为“0”
		s DrugObj.oneUseDoseUnit=""	;varchar(10)	N	单次使用剂量单位△	参考当地结算系统中的“计价单位” 编码，中药饮片时为空见数据字典 7.1.10计价单位
		s DrugObj.medFrequencyCode=..GetFrequencyCode("")	;varchar(3)	Y	用药频次代码	参考当地结算系统中的“用法标准” 编码，填代码见数据字典 7.1.11用法标准
		s DrugObj.medAim=""	;varchar(1)	N	给药目的	1：预防；2：应急；3：治疗；4：诊断；9：其他
		s DrugObj.medDays=OrdObj.OEORIDuratDR.PHCDUDesc	;varchar(5)	Y	用药天数	本条处方发药数量可使用天数，数值
		s PAADMRegConDisDR=$P($G(^PAADM(AdmDr,"DHC")),"^",25)
		s ExpStr=OEORIRowID_"^"_""_"^"_AdmDr_"^"_OrdObj.OEORIRecDepDRGetObjectId()_"^^"
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", OrdObj.OEORIItmMastDRGetObjectId(), OrdObj.OEORISttDat, OrdObj.OEORIPriorityDRGetObjectId(), "", "", "",OrdObj.OEORIRecDepDRGetObjectId(),PAADMRegConDisDR,OrdObj.OEORIQtyPackUOM,ExpStr)
		s OrderPrice=$P(retPrice,"^",1)
		s DrugObj.price=OrderPrice	;varchar(10)	Y	单价	数值
		s InciDr=$o(^INCI(0,"ARCIM_DR",+OrdObj.OEORIItmMastDRGetObjectId(),0))
		s OutUomId=$p($g(^INCI(InciDr,1)),"^",12)
		s:OutUomId'="" DrugObj.valuateUnit=$p($g(^CT("UOM",OutUomId)),"^",2)	;varchar(10)	Y	计价单位△	参考当地结算系统中的“计价单位” 编码见数据字典 7.1.10计价单位
		s DrugObj.num=OrdObj.OEORIQty	;varchar(5)	Y	数量△	数值，发药数量（由用法用量和天数计算得出，精确到最小单位，不可修改）
		s bUomId=$p($g(^INCI(InciDr,1)),"^",10)
		s outUomId=$p($g(^INCI(InciDr,1)),"^",12)
		//s DrugObj.conversionRatio=##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId,outUomId)
		s DrugObj.conversionRatio=##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId,outUomId)	;decimal(10,4)	Y	转换比	最小使用单位与计价单位的比值（如计价单位是盒，最小使用单位是粒，一盒10粒，转换比就是10）
		s DrugObj.heaInsUseSign=""	;varchar(1)	N	医保限制使用标志	0：无要求；1：不符合限用规定；2：符合限用规定
		s DrugObj.compoundSign=""	;varchar(2)	N	联合用药/复方标识	对于中药饮片，同一方子的各味中药饮片归入“复方编号”进行归类；存在多个方子时，编号从“01”开始编列。对于非中药饮片，存在联合用药时，“复方编号”进行归类表示这组药是联合用药；非联合用药或者单方时缺省为“00”
		s DrugObj.nonFried=""	;varchar(1)	N	免煎	中药饮片需要免煎时填写，否则本项可以空缺 0：无要求；1：免煎
		s DrugObj.skinTest=""	;varchar(1)	N	皮试	需要皮试时填写，否则本项可以空缺 0：无要求；1：需要皮试 规定要做皮试的药物，必须在处方上注明
		s sumPaySign="1"
		if OrdObj.OEORICoverMainIns="Y" s sumPaySign="0"
		s DrugObj.sumPaySign=sumPaySign	;varchar(1)	Y	全额自费标识	0：医保；1：自费
	}
	d OrdObj.%Close()
	q DrugObj
}

/// 非药品明细项
ClassMethod GetSaveNonDrugInfo(AdmDr As %String, OEORIRowID As %String, OperationType As %String)
{
	s DrugObj={}
	s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID)
	if $ISOBJECT(OrdObj) {
		s DrugObj.adviceId=OEORIRowID	;varchar(20)	Y	医嘱ID	医嘱ID是医院内部唯一标识一条医嘱的顺序号
		s DrugObj.operationType=OperationType	;varchar(1)	Y	操作类型	1：保存；2：删除；
		s DrugObj.costStartTime=$tr($zd(OrdObj.OEORIDate,3),"-","")_"/"_$tr($zt(OrdObj.OEORITime,1),":","")	;datetime	Y	费用发生时间	日期时间格式A： YYYYMMDD/HHNNSS/
		s DrugObj.startUseTime=$tr($zd(OrdObj.OEORISttDat,3),"-","")_"/"_$tr($zt(OrdObj.OEORISttTim,1),":","")	;datetime	Y	开始使用时间	日期时间格式A：YYYYMMDD/HHNNSS/该收费明细执行的日期
		s DrugObj.hosItemCode=OrdObj.OEORIItmMastDR.ARCIMCode	;varchar(20)	Y	医院项目代码	医院内自编的唯一标识该收费的编码
		s DrugObj.itemName=OrdObj.OEORIItmMastDR.ARCIMDesc	;varchar(200)	Y	项目名称	医院内部收费项目名称
		s DrugObj.heaInsItemCode=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(OrdObj.OEORIItmMastDRGetObjectId(),"")	;varchar(20)	Y	医保项目代码	由医保统一要求的收费编码
		s PAADMRegConDisDR=$P($G(^PAADM(AdmDr,"DHC")),"^",25)
		s ExpStr=OEORIRowID_"^"_""_"^"_AdmDr_"^"_OrdObj.OEORIRecDepDRGetObjectId()_"^^"
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", OrdObj.OEORIItmMastDRGetObjectId(), OrdObj.OEORISttDat, OrdObj.OEORIPriorityDRGetObjectId(), "", "", "",OrdObj.OEORIRecDepDRGetObjectId(),PAADMRegConDisDR,OrdObj.OEORIQtyPackUOM,ExpStr)
		s OrderPrice=$P(retPrice,"^",1)
		s DrugObj.price=OrderPrice	;varchar(10)	Y	单价	数值
		s DrugObj.valuatePrice=""	;varchar(10)	N	计价价格 △	数值，对于分次使用的材料，则：计价价格 ＝ 单价 / 分次次数；且单笔明细的数量只能计为1
		s InciDr=$o(^INCI(0,"ARCIM_DR",+OrdObj.OEORIItmMastDRGetObjectId(),0))
		s OutUomId=$p($g(^INCI(InciDr,1)),"^",12)
		s:OutUomId'="" DrugObj.valuateUnit=$p($g(^CT("UOM",OutUomId)),"^",2)	;varchar(10)	Y	计价单位	参考当地结算系统中的“计价单位” 编码见数据字典 7.1.10计价单位
		s DrugObj.num=OrdObj.OEORIQty	;varchar(5)	Y	数量 △	数值
		s DrugObj.imageExamCode=""	;varchar(1)	N	影像检查部位编码	对于影像检查医嘱，说明被检查的部位大类见数据字典 7.1.26检查部位
		s DrugObj.heaInsUseSign=""	;varchar(1)	N	医保限制使用标志	0：无要求；1：不符合限用规定；2：符合限用规定
		s DrugObj.useDesc=""	;varchar(200)	N	使用说明	使用该非药品项目的简要说明
		s DrugObj.setNumCode=""	;varchar(20)	N	套件/组号编号	材料有散件组合套件，或者医嘱进行编组管理时，需要上传以示区分
		s sumPaySign="1"
		if OrdObj.OEORICoverMainIns="Y" s sumPaySign="0"
		s DrugObj.sumPaySign=sumPaySign	;varchar(1)	Y	全额自费标识	0：医保；1：自费
	}
	d OrdObj.%Close()
	q DrugObj
}

/// 3.3.5 住院信息变动3105
ClassMethod IPSaveDiagnos(AdmDr As %String, MRAdmDr As %String, UserDr As %String, LocDr As %String)
{
	;clinicType	varchar(3)	Y	就诊类型	见基础数据字典 6.1.1就诊类型
	;inpMedRecordNum	varchar(20)	Y	住院病案号	
	;depaCode	varchar(16)	N	科室编码	参考当地结算系统中的“科室” 编码见数据字典 7.1.7科室
	;hosDepaName	varchar(64)	N	医院科室名称	填写医院内部科室名称或见数据字典 7.1.7科室
	;hosDoctorCode	varchar(16)	Y	医生编码	
	;doctorName	varchar(64)	Y	医生姓名	
	;Diagnosis			诊断明细项	诊断信息循环体，见诊断明细3.3.2.1。
	;SignsInfo			体征信息项	参见体征信息3.3.2.2
	s OutPutObj={}
	s DiagnoInfoList=[]
	s Childsub=0
	f {
		s Childsub=$o(^MR(MRAdmDr,"DIA",Childsub))
		q:Childsub=""
		s DiagnosDr=MRAdmDr_"||"_Childsub
		s DiagnosInfo=..GetDiagnosInfo(DiagnosDr)
		d DiagnoInfoList.%Push(DiagnosInfo)
	}
	
	s OutPutObj.clinicType=..GetAdmType(AdmDr)
	s PAPMIDR=$p($g(^PAADM(AdmDr)),"^",1)
	s OutPutObj.inpMedRecordNum=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",22) ;##class(Nur.CommonInterface.Patient).getMedicareNo(AdmDr)
	;s $p($g(^CTLOC(LocDr)),"^",1)
	s OutPutObj.depaCode=$p($g(^CTLOC(LocDr)),"^",1)
	s OutPutObj.hosDepaName=$p($g(^CTLOC(LocDr)),"^",2)
	s CareProvDr=$p($g(^SSU("SSUSR",UserDr)),"^",9)
	s OutPutObj.hosDoctorCode=$p($g(^CTPCP(CareProvDr,1)),"^",1)
	s OutPutObj.doctorName=$p($g(^CTPCP(CareProvDr,1)),"^",2)
	s OutPutObj.Diagnosis=DiagnoInfoList
	s OutPutObj.SignsInfo=..GetPatAdmInfo(MRAdmDr)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
	///
}

/// 3.3.6 住院处方录入3106
ClassMethod IPCheckOEOrdItemInfo(AdmDr As %String, OrdItemStr As %String, User As %String, Loc As %String, PriorRowid As %String)
{
	s OutPutObj={}
	s OutPutObj.clinicType=..GetAdmType(AdmDr)	;varchar(3)	Y	就诊类型	见基础数据字典 6.1.1就诊类型
	s PAPMIDR=$p($g(^PAADM(AdmDr)),"^",1)
	s OutPutObj.inpMedRecordNum=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",22) ;	varchar(20)	Y	住院病案号	
	s OutPutObj.recipeNum=""	;varchar(20)	N	处方号	
	s CareProvDr=$p($g(^SSU("SSUSR",User)),"^",9)
	s CarPrvTpDR=$p($g(^CTPCP(CareProvDr,1)),"^",4)
	s AdviceSource=""
	if (CarPrvTpDR<=5)&&(CarPrvTpDR>0) s AdviceSource="01"
	e  i (CarPrvTpDR<=15)&&(CarPrvTpDR>=11) s AdviceSource="02"
	e  i (CarPrvTpDR<=16)&&(CarPrvTpDR>=20) s AdviceSource="11"
	s OutPutObj.adviceSource=AdviceSource	;varchar(2)	Y	医嘱来源	见基础数据字典 6.1.7医嘱来源
	s OutPutObj.inpatientWard=""	;	varchar(20)	N	病区	病人所在的病区
	s OutPutObj.lowerDepaCode=$p($g(^CTLOC(Loc)),"^",1)	;varchar(16)	Y	下达科室编码	见数据字典 7.1.7科室
	s OutPutObj.hosDepaName=$p($g(^CTLOC(Loc)),"^",2)	;varchar(64)	Y	医院科室名称	填写医院内部科室名称或见数据字典 7.1.7科室
	
	s OutPutObj.lowerDoctorCode=$p($g(^CTPCP(CareProvDr,1)),"^",1)	;	varchar(16)	N	下达医生编码	
	s OutPutObj.lowerDoctorName=$p($g(^CTPCP(CareProvDr,1)),"^",2)	;varchar(64)	Y	下达医生姓名	
	s OutPutObj.adviceLowerTime=""	;	datetime	N	医嘱下达时间	日期时间格式A： YYYYMMDD/HHNNSS/
	s OutPutObj.executeDepaCode=""	;	varchar(16)	N	执行科室编码	见数据字典 7.1.7科室
	s OutPutObj.adviceExecutorCode=""	;	varchar(16)	N	医嘱执行人编码	
	s OutPutObj.executeDoctorName=""	;	varchar(64)	N	执行医生姓名	
	s OutPutObj.adviceExecuteTime=""	;	datetime	N	医嘱执行时间	日期时间格式A： YYYYMMDD/HHNNSS/
	s OutPutObj.adviceEndTime=""	;	datetime	N	医嘱终止时间	日期时间格式A： YYYYMMDD/HHNNSS/
	s OutPutObj.adviceNum=""	;	varchar(20)	N	医嘱组号
	s PriorCode=""
	if (PriorRowid="") s PriorCode=2
	if (PriorRowid=""){	
		s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
		s PriorCode=$case(PriorCode,"NORM":"2","S":"1","OUT":"3")
		i PriorCode="" s PriorCode=9
	}
	s OutPutObj.adviceType=PriorCode	;varchar(1)	Y	医嘱类别	1：长期（在院）；2：临时（在院）；3：出院带药；9：其他
	;s OutPutObj.PRESCRIPTION			收费明细	
	;Drug			药品明细	循环体，见药品明细3.3.3.1
	;NonDrug			非药品明细	循环体，见非药品明细3.3.3.2
	s DrugList=[]
	s NonDrugList=[]
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount {
		Set OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		Set ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		Set OrderType=$p(OrdItem,"^",2)
		if (OrderType="R"){
			s DrugInfo=..GetCheckDrugInfo(AdmDr,OrdItem,"1")
			d DrugList.%Push(DrugInfo)
		}else{
			s NonDrugInfo=..GetCheckNonDrugInfo(AdmDr,OrdItem,"1")
			d NonDrugList.%Push(NonDrugInfo)
		}
	}
	s NodeList("DrugTr","ChildNode")="Drug"
	s NodeList("NonDrugTr","ChildNode")="NonDrug"
	s OutPutObj.PRESCRIPTION=
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"DrugTr",.NodeList).Read(),"<DrugTr>",2),"</DrugTr>",1)_
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrugTr",.NodeList).Read(),"<NonDrugTr>",2),"</NonDrugTr>",1)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

/// 3.3.7 住院保存医嘱3107
ClassMethod IPSaveOEOrdItemInfo(AdmDr As %String, OrderStr As %String)
{
	s OutPutObj={}
	s OutPutObj.clinicType=..GetAdmType(AdmDr)	;varchar(3)	Y	就诊类型	见基础数据字典 6.1.1就诊类型
	s PAPMIDR=$p($g(^PAADM(AdmDr)),"^",1)
	s OutPutObj.inpMedRecordNum=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)	;varchar(20)	Y	住院病案号
	s OutPutObj.recipeNum=""	;varchar(20)	N	处方号
	;PRESCRIPTION			收费明细	
	;PRESCRIPTION.Drug			药品明细	循环体，见药品明细3.3.3.1
	;PRESCRIPTION.NonDrug			非药品明细	循环体，见非药品明细3.3.3.2
	s DrugList=[]
	s NonDrugList=[]
	
	For i=1:1:$l(OrderStr,"^") {
		s ArcimRowId=$p($p(OrderStr,"^",i),"*",1)
		s newOrdIdDR=$p($p(OrderStr,"^",i),"*",2)
		i ArcimRowId="" continue
		s statcode="V"
		s TtemStat=$P($G(^OEORD(+newOrdIdDR,"I",+$p(newOrdIdDR,"||",2),1)),"^",13)
		i TtemStat'="" d
		.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
		continue:statcode'="V"
		s ItemCatRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		if (OrderType="R"){
			s DrugInfo=..GetSaveDrugInfo(AdmDr,newOrdIdDR,"1")
			d DrugList.%Push(DrugInfo)
		}else{
			s NonDrugInfo=..GetSaveNonDrugInfo(AdmDr,newOrdIdDR,"1")
			d NonDrugList.%Push(NonDrugInfo)
		}
	}
	s NodeList("DrugTr","ChildNode")="Drug"
	s NodeList("NonDrugTr","ChildNode")="NonDrug"
	s OutPutObj.PRESCRIPTION=
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"DrugTr",.NodeList).Read(),"<DrugTr>",2),"</DrugTr>",1)_
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrugTr",.NodeList).Read(),"<NonDrugTr>",2),"</NonDrugTr>",1)
	s RetStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY","")
}

/// 获取就诊类型
ClassMethod GetAdmType(AdmDr As %String)
{
	s PAADMType=$p($g(^PAADM(AdmDr)),"^",2)
	s PAADMTypeStr=$case(PAADMType,"O":"100","I":"400","E":"200")
	if (PAADMTypeStr="") s PAADMTypeStr="999"
	q PAADMTypeStr
}

/// 获取频次代码
ClassMethod GetFrequencyCode(medFrequencyCode As %String)
{
	if medFrequencyCode="10pm"  s medFrequencyCode="079 "
	if medFrequencyCode="12MN"  s medFrequencyCode="079 "
	if medFrequencyCode="12N"  s medFrequencyCode="079 "
	if medFrequencyCode="2Pm"  s medFrequencyCode="079 "
	if medFrequencyCode="3Am"  s medFrequencyCode="079 "
	if medFrequencyCode="4Pm"  s medFrequencyCode="079 "
	if medFrequencyCode="6Am"  s medFrequencyCode="079 "
	if medFrequencyCode="6Pm"  s medFrequencyCode="079 "
	if medFrequencyCode="Bid"  s medFrequencyCode="026 "
	if medFrequencyCode="Bid(餐前)   "  s medFrequencyCode="027 "
	if medFrequencyCode="Bid(餐中)   "  s medFrequencyCode="079 "
	if medFrequencyCode="Bid(空腹)   "  s medFrequencyCode="079 "
	if medFrequencyCode="WEEK"  s medFrequencyCode="079 "
	if medFrequencyCode="ONCE"  s medFrequencyCode="079 "
	if medFrequencyCode="Prn"  s medFrequencyCode="029 "
	if medFrequencyCode="Q12h"  s medFrequencyCode="030 "
	if medFrequencyCode="Q8h"  s medFrequencyCode="042 "
	if medFrequencyCode="Qd "  s medFrequencyCode="043 "
	if medFrequencyCode="Qd(餐前)"  s medFrequencyCode="044 "
	if medFrequencyCode="Qd(餐中)"  s medFrequencyCode="079 "
	if medFrequencyCode="Qd(空腹)"  s medFrequencyCode="079 "
	if medFrequencyCode="Qh "  s medFrequencyCode="032 "
	if medFrequencyCode="Qid"  s medFrequencyCode="045 "
	if medFrequencyCode="Qn "  s medFrequencyCode="041 "
	if medFrequencyCode="Qod"  s medFrequencyCode="042 "
	if medFrequencyCode="Qd(餐后)"  s medFrequencyCode="079 "
	if medFrequencyCode="St "  s medFrequencyCode="050 "
	if medFrequencyCode="Tid"  s medFrequencyCode="013 "
	if medFrequencyCode="Tid(餐前)   "  s medFrequencyCode="052 "
	if medFrequencyCode="Tid(餐中)   "  s medFrequencyCode="079 "
	if medFrequencyCode="Tid(空腹)   "  s medFrequencyCode="079 "
	if medFrequencyCode="Tid(餐后)   "  s medFrequencyCode="079 "
	if medFrequencyCode="多次"  s medFrequencyCode="079 "
	if medFrequencyCode="临时"  s medFrequencyCode="080 "
	if medFrequencyCode="每日1次"  s medFrequencyCode="079 "
	if medFrequencyCode="每日2次"  s medFrequencyCode="079 "
	if medFrequencyCode="每日3次"  s medFrequencyCode="079 "
	if medFrequencyCode="每日4次"  s medFrequencyCode="079 "
	if medFrequencyCode="频服"  s medFrequencyCode="079 "
	if medFrequencyCode="睡前"  s medFrequencyCode="079 "
	if medFrequencyCode="晚餐后2小时 "  s medFrequencyCode="079 "
	if medFrequencyCode="晚餐前 "  s medFrequencyCode="079"
	if medFrequencyCode="晚餐前30分钟"  s medFrequencyCode="079 "
	if medFrequencyCode="午餐后2小时 "  s medFrequencyCode="079 "
	if medFrequencyCode="午餐前 "  s medFrequencyCode="079 "
	if medFrequencyCode="午餐前30分钟"  s medFrequencyCode="079 "
	if medFrequencyCode="与晚餐同服  "  s medFrequencyCode="079 "
	if medFrequencyCode="与午餐同服  "  s medFrequencyCode="079 "
	if medFrequencyCode="与早餐同服  "  s medFrequencyCode="079 "
	if medFrequencyCode="早餐后2小时 "  s medFrequencyCode="079 "
	if medFrequencyCode="早餐前 "  s medFrequencyCode="079 "
	if medFrequencyCode="早餐前30分钟"  s medFrequencyCode="079 "
	if medFrequencyCode="遵医嘱 "  s medFrequencyCode="079 "
	if medFrequencyCode="Q4h"  s medFrequencyCode="033 "
	if medFrequencyCode="BIW"  s medFrequencyCode="022 "

	q medFrequencyCode
}

}
