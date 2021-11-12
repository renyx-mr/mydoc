Class DHCDoc.Interface.TumorReporting.ComInterface Extends %RegisteredObject
{

ClassMethod GetOPRegistInfo(PAADMRowID As %String)
{
	s OutRegistObj={}
	s PAAdmInfoObj=##class(DHCDoc.GetInfo.Method.Business.Register).GetPAAdmInfo(PAADMRowID)
	s PAADMPAPMIDR=$p($g(^PAADM(PAADMRowID)),"^",1)	
	; PatientId,VisitSn,VisitType,VisitCardNo,OutpatientNo,VisitTimes,Name,RegisSn,RegisDatetime,VisitDatetime,FirstVisitMark,RegisMethodCode,
	; patient_id	患者ID	00931222	患者在本院信息系统内的唯一标识	文本	varchar(100)	是	
	s OutRegistObj.PatientId=##Class(web.PAPatMas).GetRegistration(PAADMPAPMIDR)
	; visit_sn	单次就诊唯一标识号(与b02_1强关联且唯一)	00931222|4623477|1|门诊	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|门诊号|就诊次数|就诊类型。	文本	varchar(100)	是	
	s OutRegistObj.VisitSn=PAAdmInfoObj.PAADMRowID
	; visit_type	就诊类型	门诊	就诊类型：门诊、急诊	文本	varchar(50)	是	
	s PAADMType=PAAdmInfoObj.PAADMType
	s OutRegistObj.VisitType=$case(PAADMType,"E":"急诊",:"门诊")
	; visit_card_no	就诊卡号	153898	患者在本医院就诊时使用的就诊卡号	文本	varchar(100)	是
	s VisitCardNo=OutRegistObj.PatientId	
	; outpatient_no	门诊号	4623477	患者门诊就诊时对应的门诊号或者病历号	文本	varchar(100)	是	
	s OutRegistObj.OutpatientNo=PAAdmInfoObj.PAADMRowID
	; visit_times	就诊次数	1	本院门诊次数	数值	int	是	
	s OutRegistObj.VisitTimes=..GetVisitNum("O^E",PAADMPAPMIDR)
	; name	患者姓名	张某		文本	varchar(100)	是
	
	s OutRegistObj.Name=$P($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",1)
	; regis_sn	挂号流水号	13423	挂号业务对应的唯一编号	文本	varchar(100)
	s OutRegistObj.RegisSn=PAAdmInfoObj.PAADMADMNo		
	; regis_datetime	挂号时间	2018-01-03 16:31:42	"本业务数据在医院系统中的实际产生时间。门急诊：挂号时间yyyy-MM-dd HH:mm:ss"	日期	datetime
	s OutRegistObj.RegisDatetime=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMCreateDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMCreateTime)		
	; visit_datetime	就诊时间	43112.46678	符合【yyyy-MM-dd HH:mm:ss】的格式	日期	datetime	是	
	s OutRegistObj.VisitDatetime=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMAdmDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMAdmTime)
	; first_visit_mark	是否初诊	是		文本	varchar(50)	
	s PAADMFirstOrReadmis=PAAdmInfoObj.PAADMFirstOrReadmis
	s PAADMAdmReadm=PAAdmInfoObj.PAADMAdmReadm
	s OutRegistObj.PAADMAdmReadm="是"
	if (PAADMFirstOrReadmis="R")||(PAADMAdmReadm="R") s OutRegistObj.PAADMAdmReadm="否"
	; regis_method_code	挂号渠道代码	3	填写医院原始代码	文本	varchar(50)	
	s OutRegistObj.RegisMethodCode=PAAdmInfoObj.PAADMAdmMethodCode
	; RegisMethod,RegisTypeCode,RegisType,RegisChargePrice,RegisPaidPrice,RegisDeptCode,RegisDeptName,VisitDoctorNo,TechnicalTitle,JobTitle,	
	; regis_method	挂号渠道名称	现场预约	如现场预约、自助机预约、114电话平台等	文本	varchar(100) 
	s OutRegistObj.RegisMethod=PAAdmInfoObj.PAADMAdmMethodDesc		
	; regis_type_code	挂号类型代码	3	填写医院原始代码	文本	varchar(50) 
	s OutRegistObj.RegisTypeCode=""		
	; regis_type	挂号类型	普通号	如普通号 、副主任医师号、正主任医师号等	文本	varchar(100) 
	s OutRegistObj.RegisType=""		
	; regis_charge_price	挂号金额（元）	5.0000	号别本身原始金额	数值	decimal(12,4)
	s OutRegistObj.RegisChargePrice=""		
	; regis_paid_price	实付金额（元）	5.0000	患者实付挂号金额	数值	decimal(12,4)
	s OutRegistObj.RegisPaidPrice=""		
	; regis_dept_code	挂号科室代码	15	填写医院原始代码	文本	varchar(50)	是	
	s OutRegistObj.RegisDeptCode=PAAdmInfoObj.PAADMDepCode	
	; regis_dept_name	挂号科室名称	肿瘤科	填写挂号科室名称	文本	varchar(100) 	是	
	s OutRegistObj.RegisDeptName=PAAdmInfoObj.PAADMDepDesc	
	; visit_doctor_no	就诊医生代码	1346	就诊医生代码或者工号	文本	varchar(50)	是
	s OutRegistObj.VisitDoctorNo=PAAdmInfoObj.PAADMAdmDocCode	
	; technical_title	医师职称名称	主治医师	就诊医生职称名称	文本	varchar(100)
	s OutRegistObj.TechnicalTitle=""		
	; job_title	医师职务名称	科室主任	就诊医生职务名称	文本	varchar(100)
	s OutRegistObj.JobTitle=""
	
	; ExtendData1,ExtendData2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME		
	; extend_data1	扩展字段1		用于填写补充信息	文本	text
	s OutRegistObj.ExtendData1=""	
	; extend_data2	扩展字段2		用于填写补充信息	文本	text
	s OutRegistObj.ExtendData2=""		
	; record_status	记录状态	1	1正常 0作废	数值	int	是
	s PAADMVisitStatus=PAAdmInfoObj.PAADMVisitStatus	
	s OutRegistObj.ExtendData1="1"
	s:PAADMVisitStatus="C" OutRegistObj.ExtendData1="0"
	; YY_ID	数据唯一标识			文本	varchar(100)	是	
	s OutRegistObj.ExtendData1=OutRegistObj.PAADMRowID
	; YY_UPDATE_TIME	数据更新时间(增量采集时间)			日期	datetime	是	
	s OutRegistObj.ExtendData1=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMUpdateDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMUpdateTime)
	; YY_CREATE_TIME	数据创建时间			日期	datetime	是
	s OutRegistObj.ExtendData1=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMCreateDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMCreateTime)
	q OutRegistObj
}

ClassMethod GetOrderInfo(AdmId As %String, OEORIRowID As %String)
{
	s OutItemObj={}
	; PatientId,VisitSn,MedicalRecordNo,InpatientNo,HospitalizationTimes,OrderSn,RequestNo,OrderGivenTime,OrderConfirmTime,OrderDeptCode,
	; patient_id	患者ID	43655	患者在本院的唯一标识	文本	varchar(100)	是	开医嘱
	s PAADMPAPMIDR=$p($g(^PAADM(AdmId)),"^",1)
	s OutItemObj.PatientId=##Class(web.PAPatMas).GetRegistration(PAADMPAPMIDR)
	; visit_sn	单次就诊唯一标识号(与b02_1强关联)	43655|4623477|2|住院	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|住院	文本	varchar(100)	是	开医嘱
	s OutItemObj.VisitSn=AdmId
	; visit_type	就诊类型	门诊	就诊类型：门诊、急诊	文本	varchar(50)	是	
	s PAADMType=$p($g(^PAADM(AdmId)),"^",2)
	s OutItemObj.VisitType=$case(PAADMType,"E":"急诊",:"门诊")
	; visit_card_no	就诊卡号	153898	患者在本医院就诊时使用的就诊卡号	文本	varchar(100)	是
	//s OutItemObj.VisitCardNo=OutItemObj.PatientId
	; visit_times	就诊次数	1	本院门诊次数	数值	int	是	
	s OutItemObj.VisitTimes=..GetVisitNum("O^E",PAADMPAPMIDR)
	; medical_record_no	病案号	869881	患者在本院就诊时使用的病案号	文本	varchar(100)
	s OutItemObj.MedicalRecordNo=##class(web.DHCDocOrderCommon).GetMrNo("",PAADMPAPMIDR,"O")
	; inpatient_no	住院号	4623477	患者住院号	文本	varchar(100)	是	开医嘱
	s OutItemObj.InpatientNo=AdmId
	; hospitalization_times	住院次数	2		数值	varchar(20)	是	开医嘱
	s OutItemObj.HospitalizationTimes=..GetVisitNum("I",PAADMPAPMIDR)
	s OrdInfoItemObj=##class(DHCDoc.GetInfo.Method.Doc).GetOrdInfoItem(OEORIRowID)
	; order_sn	医嘱流水号	74471930001|12	其值为医嘱表主键，如果存在医嘱子序号，则需要通过"|"进行字段拼接，保证数据唯一性。如果存在长期、临时多表情况，则拼接医嘱类别字段。	
	;文本	varchar(100)	是	开医嘱
	s OutItemObj.OrderSn=OrdInfoItemObj.OEORIRowId
	; request_no	医技申请单号		其值可以关联到医技报告信息	文本	varchar(100)		开医嘱
	s OutItemObj.RequestNo=OrdInfoItemObj.OEORILabEpisodeNo
	; order_given_time	医嘱下达时间	2018-01-03 16:31:42	"本业务数据在医院系统中的实际产生时间
	s OutItemObj.OrderGivenTime=##class(websys.Conversions).DateLogicalToHtml(OrdInfoItemObj.OEORIDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrdInfoItemObj.OEORITime)
	
	; order_confirm_time	医嘱确认时间	43103.69007		日期	datetime		开医嘱
	s OutItemObj.OrderConfirmTime=OutItemObj.OrderGivenTime
	; order_dept_code	医嘱下达科室代码	15	医嘱开立对应的科室	文本	varchar(50)	是	开医嘱
	s OutItemObj.OrderDeptCode=OrdInfoItemObj.OEORIOrdDeptCode
	; OrderDeptName,OrderDoctorNo,TechnicalTitle,JobTitle,VisitDeptCode,VisitDeptName,OrderStartDatetime,OrderEndDatetime,ExecutiveDeptCode,
	; order_dept_name	医嘱下达科室名称	内科		文本	varchar(100)	是	开医嘱
	s OutItemObj.OrderDeptName=OrdInfoItemObj.OEORIOrdDeptDesc
	; order_doctor_no	医嘱开单医生代码	1346	医嘱开单医生代码或工号	文本	varchar(50)		开医嘱
	s OutItemObj.OrderDoctorNo=OrdInfoItemObj.OEORIDoctorCode
	; technical_title	职称名称	主治医师	医嘱开单医生职称名称	文本	varchar(100)		开医嘱
	s OutItemObj.TechnicalTitle=""
	; job_title	职务名称	科室主任	医嘱开单医生职务名称	文本	varchar(100)		开医嘱
	s OutItemObj.JobTitle=""
	; visit_dept_code	住院科室代码	15	填写医院原始代码	文本	varchar(50)		开医嘱
	s OutItemObj.VisitDeptCode=""
	; visit_dept_name	住院科室名称	内科	填写医院住院科室名称	文本	varchar(100)		开医嘱
	s OutItemObj.VisitDeptName=""
	; order_start_datetime	医嘱开始时间	2018-12-13 18:12:21	医嘱实际开始时间	日期	datetime	是	开医嘱
	s OutItemObj.OrderStartDatetime=##class(websys.Conversions).DateLogicalToHtml(OrdInfoItemObj.OEORISttDat)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrdInfoItemObj.OEORISttTim)
	; order_end_datetime	医嘱停止时间	2018-12-16 13:12:21	医嘱实际停止时间	日期	datetime		开医嘱
	s OutItemObj.OrderEndDatetime=##class(websys.Conversions).DateLogicalToHtml(OrdInfoItemObj.OEORIXDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrdInfoItemObj.OEORIXTime)
	; executive_dept_code	医嘱执行科室代码	15	填写医院原始代码	文本	varchar(50)		开医嘱
	s OutItemObj.ExecutiveDeptCode=OrdInfoItemObj.OEORIRecDepCode
	; ExecutiveDeptOame,OrderType,OrderClassCode,OrderClassName,OrderItemCode,OrderItemName,OrderGroupNo,Dose,DoseUnit,Form,Spec,FrequencyCode,
	; executive_dept_name	医嘱执行科室名称	内科	填写医院执行科室名称	文本	varchar(100)		开医嘱
	s OutItemObj.ExecutiveDeptName=OrdInfoItemObj.OEORIRecDepDesc
	; order_type	医嘱类别	长期医嘱	医嘱类别：长期医嘱、临时医嘱、出院带药	文本	varchar(50)	是	开医嘱
	s OutItemObj.OrderType=OrdInfoItemObj.OEORIPriorityDesc
	; order_class_code	医嘱分类代码	04	填写医院原始代码	文本	varchar(50)	是	开医嘱
	s OutItemObj.OrderClassCode=OrdInfoItemObj.OEORICategCode
	; order_class_name	医嘱分类名称	药品类医嘱	填写医嘱名称分类中文名称，如药品类医嘱、检查类医嘱等。	文本	varchar(100)	是	开医嘱
	s OutItemObj.OrderClassName=OrdInfoItemObj.OEORICategDesc
	; order_item_code	医嘱项目代码	7438731	填写医院原始代码	文本	varchar(100)	是	开医嘱
	s OutItemObj.OrderItemCode=OrdInfoItemObj.ARCIMCode
	; order_item_name	医嘱项目名称	消癌平片	院内医嘱明细名称	文本	varchar(200)	是	开医嘱
	s OutItemObj.OrderItemName=OrdInfoItemObj.ARCIMDesc
	; order_group_no	医嘱组号	8756	每组医嘱对应的编码	文本	varchar(100)		开医嘱
	s OutItemObj.OrderGroupNo=""
	; dose	单次剂量	0.3	药品使用单次剂量	文本	varchar(100)	是	开医嘱
	s OutItemObj.Dose=OrdInfoItemObj.OEORIDoseQty
	; dose_unit	单次剂量单位	g(克)	药品使用剂量单位	文本	varchar(100)	是	开医嘱
	s OutItemObj.DoseUnit=OrdInfoItemObj.OEORIUnitDesc
	; form	药品剂型	片剂	填写药品剂型，如：片剂、注射剂、乳剂、滴眼剂等。	文本	varchar(128)	是	开医嘱
	s OutItemObj.Form=##class(web.DHCDocOrderEntry).GetINCI(+OrdInfoItemObj.ARCIMRowId)
	; spec	规格	250mg 	系指每一支、片或其他每一个单位制剂中含有主药的重量（或效价）或含量（%）或装量	文本	varchar(100)	是	开医嘱
	s Incitmid=$o(^INCI(0,"ARCIM_DR",+OrdInfoItemObj.ARCIMRowId,0))
	s:Incitmid'="" OutItemObj.Spec=##class(web.DHCSTKUTIL).GetSpec(Incitmid)
	; frequency_code	使用频率代码	bid	填写使用频率代码，如bid、biw等。	文本	varchar(50)	是	开医嘱
	s OutItemObj.FrequencyCode=OrdInfoItemObj.OEORIPHFreqCode
	; FrequencyName,AdministrationRoute,LiquidConfiguration,InjectionType,DrugOrder,DrugCompatibility,InfusionDuration,NumOfOrder,NumOfOrderUnit,
	; frequency_name	使用频率	一日两次	填写使用频率名称，如一日两次等。	文本	varchar(100)	是	开医嘱
	s OutItemObj.FrequencyName=OrdInfoItemObj.OEORIPHFreqDesc
	; administration_route	给药途径	口服	填写给药途径中文名称，如口服、吸入用药等。	文本	varchar(100)		开医嘱
	s OutItemObj.AdministrationRoute=OrdInfoItemObj.OEORIInstrDesc
	; liquid_configuration 	液体配置	25ug配500ml糖	填写使用时液体配置信息，如25ug配500ml糖。	文本	varchar(100)
	s OutItemObj.LiquidConfiguration=""		
	; injection_type	注射方式	静脉滴注	填写注射方式，如皮内注射、皮下注射、肌肉注射、静脉注射、静脉滴注等。	文本	varchar(100)
	s OutItemObj.InjectionType=""		
	; drug_order	用药顺序	第2顺序用药	需要按照顺序使用药物	文本	varchar(100)
	s OutItemObj.DrugOrder=""
	; drug_compatibility	用药配伍	口服亚铁盐时加用维生素C	描述用药配伍方式	文本	varchar(100)	
	s OutItemObj.DrugCompatibility=""	
	; infusion_duration	输液时长	30分钟	药品输液花费时间	文本	varchar(50)
	s OutItemObj.InfusionDuration=""		
	; num_of_order	医嘱项目数量	10	医嘱项目对应数量	数值	varchar(50)		开医嘱
	s OutItemObj.NumOfOrder=""
	; num_of_order_unit	医嘱项目数量单位	片	医嘱项目数量对应单位	文本	varchar(50)		开医嘱
	s OutItemObj.NumOfOrderUnit=""
	; HerbalNote,OrderNote,DrugFlag,anufac,TradeName,ExtendData1,RxtendRata2,RecordStatus,YYID,YYUPDATETIME,YYCREATETIME
	; herbal_note	草药备注			文本	varchar(200)
	s OutItemObj.HerbalNote=OrdInfoItemObj.OEORIDepProcNotes		
	; order_note	医嘱备注	自备	填写医嘱备注信息	文本	varchar(200)	是	开医嘱
	s OutItemObj.OrderNote=OrdInfoItemObj.OEORIDepProcNotes
	; drug_flag	是否药品	是	根据该条医嘱分类名称是否属于药品类进行填写，药品类医嘱填写“是”，非药品类填写“否”	文本	varchar(50)		开医嘱
	s OutItemObj.DrugFlag=""
	; manufac	生产厂家			文本	varchar(128)		开医嘱
	s OutItemObj.Manufac=""
	s:Incitmid'="" OutItemObj.Manufac=##class(web.DHCSTITMDESC).GetManfNameByInci(Incitmid)
	; trade_name	药品商品名			文本	varchar(128)		开医嘱
	s OutItemObj.TradeName=""
	; extend_data1	扩展字段1		用于填写补充信息	文本	text		开医嘱
	s OutItemObj.RxtendRata1=""
	; extend_data2	扩展字段2		用于填写补充信息	文本	text		开医嘱
	s OutItemObj.RxtendRata2=""
	; record_status	记录状态	1	1正常 0作废	数值	int	是	开医嘱
	s OEORIItemStatCode=OrdInfoItemObj.OEORIItemStatCode
	s OutItemObj.RecordStatus="1"
	if (" D U C "[OEORIItemStatCode) s OutItemObj.RecordStatus="0"
	; YY_ID	数据唯一标识			文本	varchar(100)	是	开医嘱
	s OutItemObj.YYID=OrdInfoItemObj.OEORIRowId
	; YY_UPDATE_TIME	数据更新时间(增量采集时间)			日期	datetime	是	开医嘱
	s OutItemObj.YYUPDATETIME=##class(websys.Conversions).DateLogicalToHtml(OrdInfoItemObj.OEORIUpdateTime)_" "_##class(websys.Conversions).TimeLogicalToHtml(OrdInfoItemObj.OEORIUpdateTime)
	; YY_CREATE_TIME	数据创建时间			日期	datetime	是	开医嘱
	s OutItemObj.YYCREATETIME=OutItemObj.OrderGivenTime
	q OutItemObj
}

/// 获取单个就诊信息
ClassMethod GetPatientInfoObj(AdmId As %String)
{
	s AdmObj={}
	// patient_id	患者ID(患者唯一)	436653	患者在本院信息系统内的唯一标识	文本	varchar(100)	是
	s PAAdmInfoObj=##class(DHCDoc.GetInfo.Method.Business.Register).GetPAAdmInfo(AdmId)
	s AdmObj.PatientId=##class(web.PAPatMas).GetRegistration(PAAdmInfoObj.PAADMPAPMIDR)
	// visit_sn	单次就诊唯一标识号(唯一)	436653|4623477|1|门诊	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|就诊类型、患者ID|门诊号|就诊次数|就诊类型。	文本	varchar(100)	是
	s AdmObj.VisitSn=PAAdmInfoObj.PAADMADMNo
	// visit_type	就诊类型	门诊	就诊类型：住院、门诊	文本	varchar(50)	是
	s AdmObj.VisitType=$case(PAAdmInfoObj.PAADMType,"I":"住院","E":"急诊",:"门诊")
	// visit_card_no	就诊卡号	153898	患者在本医院就诊时使用的就诊卡号	文本	varchar(100)	是
	s AdmObj.VisitCardNo=AdmObj.PatientId
	// outpatient_no	门诊号	4623477	患者门诊就诊时对应的门诊号或者病历号	文本	varchar(100)	是（就诊类型为门诊）
	s AdmObj.OutpatientNo=AdmId
	// visit_times	就诊次数	1	本院门诊次数	数值	int	是（就诊类型为门诊）
	s AdmObj.VisitTimes=..GetVisitNum(PAAdmInfoObj.PAADMType,PAAdmInfoObj.PAADMPAPMIDR)
	// visit_datetime	就诊时间	2020-04-21 09:45:34		日期	datetime
	s AdmObj.VisitDatetime=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMAdmDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMAdmTime)
	// medical_record_no	病案号	869882	患者在本院就诊时使用的病案号	文本	varchar(100)	是（就诊类型为住院，出院时必填）
	s AdmObj.MedicalRecordNo=##class(web.DHCDocOrderCommon).GetMrNo("",PAAdmInfoObj.PAADMPAPMIDR,"O")
	// inpatient_no	住院号	4623477		文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.InpatientNo=AdmId
	// hospitalization_times	住院次数	1		数值	varchar(20)	是（就诊类型为住院）
	s AdmObj.HospitalizationTimes=..GetVisitNum("I",PAAdmInfoObj.PAADMPAPMIDR)
	// admission_datetime	入院时间	2018-01-03 16:31:42		日期	datetime	是（就诊类型为住院）
	s AdmObj.AdmissionDatetime=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMAdminDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMAdminTime)
	// discharge_datetime	出院时间	2020-04-21 09:45:34		日期	datetime	是（就诊类型为住院，出院时必填）
	s AdmObj.DischargeDatetime=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMDischargeDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMDischargeTime)
	// visit_doctor_no	就诊医生代码	1346	住院：主治医生工号、门诊：就诊医生工号      	文本	varchar(50)	是
	s AdmObj.VisitDoctorNo=PAAdmInfoObj.PAADMAdmDocCode
	// name	姓名	张某		文本	varchar(50)	是
	s AdmObj.Name=$P($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"ALL")),"^",1)
	// gender	性别	女	性别：男、女、未知	文本	varchar(100)	是
	s AdmObj.Gender=""
	s SexDr=$P(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"ALL"),"^",7)
	s:SexDr'="" AdmObj.Gender=$p(^CT("SEX",SexDr),"^",2)
	// patient_gender	性别编码	0：女，1：男,2：其他		文本	varchar(100)	是
	s AdmObj.PatientGender=$case(AdmObj.Gender,"女":"0","男":"1",:"2")
	// date_of_birth	出生日期	1952-05-25	出生日期：yyyy-MM-dd	日期	date	是
	s DobDate=$P($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"ALL")),"^",6)
	s AdmObj.DateOfBirth=##class(websys.Conversions).DateLogicalToHtml(DobDate)
	// occupation_code	职业类别代码	123	填写医院原始代码	文本	varchar(50)	是
	s OccupationDr=$P($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"PER",2)),"^",6)
	s:OccupationDr'="" AdmObj.OccupationCode=$P($g(^CT("OCC",OccupationDr)),"^",1)
	// occupation_name	职业类别名称	其他	填写职业类别对应的中文名称，如工人、农民等。	文本	varchar(100)	是
	s:OccupationDr'="" AdmObj.OccupationName=$P($g(^CT("OCC",OccupationDr)),"^",2)
	// nationality	国籍	中国	患者国籍	文本	varchar(100)	
	s AdmObj.Nationality=PAAdmInfoObj.PAADMRegionDesc
	// ethnicity	民族	汉族	患者民族	文本	varchar(100)
	s AdmObj.Ethnicity=""
	s NationDr=$P($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"PER",2)),"^",1)	
	s:NationDr'="" AdmObj.Ethnicity=$P(^CT("NAT",NationDr),"^",2)
	// education	文化程度	普通高级中学教育	患者文化程度	文本	varchar(100)	
	s AdmObj.Education=""
	// marital_status	婚姻状况类别	已婚	婚姻状态：未婚、已婚、丧偶、离婚	文本	varchar(100)
	s AdmObj.AdmissionDiseaseName=PAAdmInfoObj.PAADMMaritalStatusDesc	
	// newbron_mark	是否新生儿	否	患者是否新生儿	文本	varchar(50)	是
	s AdmObj.NewbronMark="否"
	// certificate_type	证件类型	居民身份证	填写注册证件类型对应的中文名称，如居民身份证、护照等。	文本	varchar(50)	
	s AdmObj.AdmissionDiseaseName=""
	s CardType=$p($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"PAT",3)),"^",7)
	s:CardType'="" AdmObj.AdmissionDiseaseName=$p($g(^PAC("CARD",CardType)),"^",2)
	// certificate_no	证件号码	110322195205251233	患者证件号码	文本	varchar(100)
	s AdmObj.CertificateNo=$p($g(^PAPER(PAAdmInfoObj.PAADMPAPMIDR,"PAT",3)),"^",6)	
	// health_card_type	健康卡类型	医保卡	各省市电子健康卡名称或类型	文本	varchar(50)	
	s AdmObj.HealthCardType=""
	// health_card_no	健康卡号	1005643	各省市电子健康卡号，如属地无此卡，可不填。	文本	varchar(100)
	s AdmObj.HealthCardNo=""	
	// insurance_type	医保类型	城镇职工基本医疗保险	患者医保类型	文本	varchar(50)	是
	s AdmObj.InsuranceType=""
	s AdmReason=$P($g(^PAADM(AdmId,1)),"^",7)
	s:AdmReason'="" AdmObj.InsuranceType=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	// insurance_no	医保卡号	46785	患者医保卡号	文本	varchar(100)	
	s AdmObj.InsuranceNo=""
	// residence_province	户籍地址-省名称	北京市	患者户籍地址-省名称	文本	varchar(100)	
	s AdmObj.ResidenceProvince=""
	// residence_city	户籍地址-市名称	市辖区	患者户籍地址-市名称	文本	varchar(100)
	s AdmObj.ResidenceCity=""	
	// residence_county	户籍地址-县名称	西城区	患者户籍地址-县名称	文本	varchar(100)
	s AdmObj.ResidenceCounty=""	
	// current_address	现住址	牛街1005号	患者现在常用住址	文本	varchar(100)
	s AdmObj.CurrentAddress=""	
	// phone_no	联系电话	18877887778	患者联系电话或联系人的联系电话	文本	varchar(50)	
	s AdmObj.PhoneNo=""
	// phone_no2	联系电话2	13903456128	患者联系电话或联系人的联系电话	文本	varchar(50)	
	s AdmObj.PhoneNo2=""
	// email	邮箱	test123@126.com		文本	varchar(50)	
	s AdmObj.Email=""
	// weixin	微信	xsq12345		文本	varchar(50)	
	s AdmObj.weixin=""
	// contact_person1	紧急联系人1	张三		文本	varchar(50)	
	s AdmObj.ContactPerson1=""
	// contact_phone_no1	紧急联系人电话1	15812309876		文本	varchar(50)
	s AdmObj.ContactPhoneNo1=""	
	// contact_person2	紧急联系人2	李四		文本	varchar(50)	
	s AdmObj.ContactPerson2=""
	// contact_phone_no2	紧急联系人电话2	13819880102		文本	varchar(50)
	s AdmObj.ContactPhoneNo2=""	
	// abo_blood_type	ABO血型	A型	患者ABO血型	文本	varchar(50)	
	s AdmObj.AboBloodType=""
	// rh_blood_type	Rh血型	阴性	患者Rh血型	文本	varchar(50)
	s AdmObj.RhBloodType=""	
	// hospital_id	医院编号	123456	医院编码	文本	varchar(100)
	s AdmObj.HospitalId=""	
	// hospital_name	医院名称	中国医科院肿瘤医院	医院名称	文本	varchar(100)	是
	s AdmObj.HospitalName=""
	// hospital_level	医院级别	1，2，3	医院级别	文本	varchar(100)
	s AdmObj.HospitalLevel=""	
	// is_discharge	出入院状态（0：在院 1：出院）	0：在院 1：出院	患者出入院状态	文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.IsDischarge=""
	if (PAAdmInfoObj.PAADMType="I"){
		if PAAdmInfoObj.PAADMDischgDate=""  s AdmObj.IsDischarge="0"
		else  s AdmObj.IsDischarge="1"
	}
	// patien_identity	患者身份（医保身份名称：0自费，1医保）	0自费，1医保	患者医保类型	文本	varchar(100)	是
	s AdmObj.PatienIdentity=##class(web.DHCDocOrderCommon).GetInsurFlag(AdmReason)
	// blood_type_s	血型(首位代码)		血型(首位代码)	文本	varchar(100)
	s AdmObj.BloodTypeS=""	
	// blood_type_e	血型(末位代码)		血型(末位代码)	文本	varchar(100)
	s AdmObj.BloodTypeE=""	
	// height	身高（CM）	178	身高（CM）	数值	varchar(100)	
	s AdmObj.Height=""
	// weight	体重（KG）	65	体重（KG）	数值	varchar(100)	
	s AdmObj.Weight=""
	// newborn_date	新生儿出生日期	44433	新生儿出生日期	日期	varchar(100)
	s AdmObj.newbornDate=""	
	// newborn_weight	新生儿出生体重（G）	3500	新生儿出生体重（G）	数值	varchar(100)
	s AdmObj.NewbornWeight=""	
	// newborn_current_weight	新生儿当前体重（G）	5500	新生儿当前体重（G）	数值	varchar(100)	
	s AdmObj.NewbornCurrentWeight=""
	// is_drug_allergy	是否药物过敏	是	是否药物过敏	文本	varchar(100)
	s AdmObj.IsDrugAllergy=""	
	// allergy_drug_code	过敏药物编码	1	"1	青霉素制剂 文本	varchar(100)
	s AdmObj.AllergyDrugCode=""	
	// allergy_drug_name	过敏药物名称	青霉素制剂	"青霉素制剂 	文本	varchar(100)
	s AdmObj.AllergyDrugName=""	
	// patient_pregnant	是否怀孕	是	是否怀孕	文本	varchar(100)
	s AdmObj.PatientPregnant=""	
	// patient_lactating	是否哺乳期	是	是否哺乳期	文本	varchar(100)
	s AdmObj.PatientLactating=""	
	// in_bed_no	入院床位号	607	入院床位号	文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.InBedNo=##class(web.DHCDoc.OP.AjaxInterface).GetPatBedNo(AdmId)
	// out_bed_no	出院床位号	607	出院床位号	文本	varchar(100)	是（就诊类型为住院，出院时必填）
	s AdmObj.InBedNo=##class(web.DHCDoc.OP.AjaxInterface).GetPatBedNo(AdmId)
	// imdept_code	入院科室编码   	123	入院科室编码   	文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.ImdeptCode=PAAdmInfoObj.PAADMAdminLocCode
	// imdept_name	入院科室名称     	肿瘤外科	入院科室名称     	文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.ImdeptName=PAAdmInfoObj.PAADMAdminLocDesc
	// transferDept_code	转科科室编码      	123	转科科室编码      	文本	varchar(100)	
	s AdmObj.TransferDeptCode=""
	// transferDept_name	转科科室名称       	肿瘤内科	转科科室名称       	文本	varchar(100)
	s AdmObj.TransferDeptName=""	
	// dept_code	出院科室编码	123	出院科室编码	文本	varchar(100)	是（就诊类型为住院，出院时必填）
	s AdmObj.DeptCode=PAAdmInfoObj.PAADMDepCode
	// dept_name	出院科室名称	肿瘤内科	出院科室名称	文本	varchar(100)	是（就诊类型为住院，出院时必填）
	s AdmObj.DeptName=PAAdmInfoObj.PAADMDepDesc
	// doctor_group_code	主诊组编码	3	主诊组编码	文本	varchar(100)
	s AdmObj.DoctorGroupCode=""	
	// doctor_group_name	主诊组名称	第三主诊组	主诊组名称	文本	varchar(100)
	s AdmObj.DoctorGroupName=""	
	// doctor_code	责任医生编码（经治医生）	123	责任医生编码（经治医生）	文本	varchar(100)	是
	s AdmObj.DoctorCode=PAAdmInfoObj.PAADMAdmDocCode
	// doctor_name	责任医生名称	张三	责任医生名称	文本	varchar(100)	是
	s AdmObj.DoctorName=PAAdmInfoObj.PAADMAdmDocDesc
	// hospital_time	住院时长	7	单位天，必须数字，最小1	文本	varchar(100)	是（就诊类型为住院，出院时必填）
	s AdmInOutDate=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(AdmId)
	//##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(PAADMRowID)
	s ResidentDays=$P(AdmInOutDate,"^",3)
	s AdmObj.HospitalTime=ResidentDays
	// leave_hospital_type	离院方式	1	"1	医嘱离院							指参保人本次治疗结束，按医嘱要求出院，进一步康复等情况指除上述5种出院去向之外的其他情况"	文本	varchar(100)	
	;是（就诊类型为住院，出院时必填）
	s AdmObj.LeaveHospitalType="1"
	// is_upload_date	已上传时间	2021-08-25 20:30	已上传时间	日期	varchar(100)
	s AdmObj.IsUploadDate=""	
	// admission_disease_id	入院诊断编码	C34.904	入院诊断编码，必须是IDC10规范	文本	varchar(100)	是（就诊类型为住院）
	s AdmObj.AdmissionDiseaseId=""
	s InDiagns=..GetPatDiagnsInfo(AdmId,"入院诊断","Y","1","","","")
	s:InDiagns'="" AdmObj.AdmissionDiseaseId=$p($g(^MRC("ID",+InDiagns)),"^",9)
	// admission_disease_name	入院诊断名称	右支气管肺癌	入院诊断名称，必须是IDC10规范	文本	varchar(100)
	s AdmObj.AdmissionDiseaseName=""
	s:InDiagns'="" AdmObj.AdmissionDiseaseName=$p($g(^MRC("ID",+InDiagns)),"^",2)
	;是（就诊类型为住院）
	// discharge_disease_id	出院诊断编码（在院为主要诊断）	C34.904	出院诊断编码（在院为主要诊断），必须是IDC10规范	文本	varchar(100)	
	;是（就诊类型为住院，出院时必填）
	s AdmObj.AdmissionDiseaseId=""
	s OutDiagns=..GetPatDiagnsInfo(AdmId,"出院诊断","Y","1","","","")
	s:OutDiagns'="" AdmObj.AdmissionDiseaseId=$p($g(^MRC("ID",+OutDiagns)),"^",9)
	// discharge_disease_name	出院诊断名称（在院为主要诊断）	右支气管肺癌	出院诊断名称（在院为主要诊断），必须是IDC10规范	文本	varchar(100)	
	;是（就诊类型为住院，出院时必填）
	s AdmObj.AdmissionDiseaseName=""
	s:OutDiagns'="" AdmObj.AdmissionDiseaseName=$p($g(^MRC("ID",+OutDiagns)),"^",2)
	// discharge_reason	出院原因	痊愈	出院原因	文本	varchar(100)	是（就诊类型为住院，出院时必填）\
	s AdmObj.DischargeReason=PAAdmInfoObj.PAADMDischCondDesc
	// tsblbs	特殊病例标识（具体值）	0	"0	普通 	文本	varchar(100)	
	s AdmObj.Tsblbs=""
	// diagnose_position1	入院诊断方位（具体值）	1	"1	左侧 	文本	varchar(100)
	s AdmObj.DiagnosePosition1=""	
	// diagnose_position2	出院诊断方位（具体值）	1	"1	左侧 文本	varchar(100)
	s AdmObj.DiagnosePosition2=""	
	// is_pathological_examination	是否有病理检查	是	是否有病理检查	文本	varchar(100)
	s AdmObj.IsPathologicalExamination=""	
	// pathology_code	病理号	123456	病理号	文本	varchar(100)	
	s AdmObj.PathologyCode=""
	// is_hospital_infected	是否院内感染（0否，1是）	0	0否，1是	文本	varchar(100)
	s AdmObj.IsHospitalInfected=""	
	// hospital_infected_code	院内感染诊断编码	J98.414	院内感染诊断编码	文本	varchar(100)
	s AdmObj.HospitalInfectedCode=""	
	// disease_type	是否特病慢病单据标志	是	是否特病慢病单据标志	文本	varchar(100)
	s AdmObj.DiseaseType=""	
	// special_disease_code	慢病特病代码	I10.x02	慢病特病代码	文本	varchar(100)	
	s AdmObj.SpecialDiseaseCode=""
	// discharge_outcome	出院转归（1-治愈/2-好转/3-未治愈/4-死亡/5-其它）在院病例为“5”	5	（1-治愈/2-好转/3-未治愈/4-死亡/5-其它）在院病例为“5”	文本	varchar(100)	
	;是（就诊类型为住院，出院时必填）
	s AdmObj.DischargeOutcome="5"	
	// extend_data1	扩展字段1		用于填写补充信息	文本	varchar(100)
	s AdmObj.ExtendData1=""	
	// extend_data2	扩展字段2		用于填写补充信息	文本	varchar(100)
	s AdmObj.ExtendData2=""
	// record_status	记录状态	1	1正常 0作废	数值	varchar(100)	是
	s AdmObj.RecordStatus=$case(PAAdmInfoObj.PAADMVisitStatus,"A":"正常",:"作废")
	// YY_ID	数据唯一标识			文本	varchar(100)	是
	s AdmObj.YYID=AdmId
	// YY_UPDATE_TIME	数据更新时间(增量采集时间)			日期	datetime	是
	s AdmObj.YYUPDATETIME=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMUpdateDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMUpdateTime)
	// YY_CREATE_TIME	数据创建时间			日期	datetime	是
	s AdmObj.YYCREATETIME=##class(websys.Conversions).DateLogicalToHtml(PAAdmInfoObj.PAADMCreateDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(PAAdmInfoObj.PAADMCreateTime)
	q AdmObj
}

/// 获取就诊次数
ClassMethod GetVisitNum(AdmTypeStr As %String, PatId As %String)
{
	s VisitNum=0
	for OneInd=1:1:$l(AdmTypeStr,"^"){
		s MyAdmType=$p(AdmTypeStr,"^",OneInd)
		s PAADMRowID=0
		F {
			S PAADMRowID=$o(^PAPERdr(PatId,"ADM",MyAdmType,PAADMRowID)) 
			Q:PAADMRowID=""
			s VisitNum=VisitNum+1
		}
	}
	q VisitNum
}

/// 汇总取诊断接口  
/// input : 就诊ID ，诊断类型描述（初步诊断，入院诊断...多个使用^连接），诊断类型（Y:ICD表Rowid,其余描述），获取诊断数量(全部用ALL)，是否按照主诊断获取，诊断状态（确诊，待诊。。。）
/// w ##class(web.Sxddhc).GetPatDiagnsInfo("901","初步诊断","","ALL")
ClassMethod GetPatDiagnsInfo(AdmId As %String, DiagnosTypeDesc As %String = "", DiagnosFlag As %String = "", DiagNum As %String = "", MianFalg As %String = "", DiagStat As %String = "", PDlime As %String = ";")
{
	s MradmRowid=$P($g(^PAADM(AdmId)),"^",61)
	q:MradmRowid="" ""
	s RetStr=""
	s:PDlime="" PDlime="^"
	set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MradmRowid)
	For{
		Quit:('obj.Next())
		q:(DiagNum'="ALL")&&((+DiagNum=$l(RetStr,"^"))||(DiagNum=RetStr))
		//b //q:((TypeFlag="0")&&(IcdDrStr'=""))
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		s Desc=obj.Data("MRDIAICDCodeDRDesc")
		continue:CodeRowid=""
		s DiagObj = ##class(User.MRDiagnos).%OpenId(Rowid)
		if ($IsObject(DiagObj)){
			continue:((MianFalg="Y")&&(DiagObj.MRDIAMainDiagFlag'="Y"))
			continue:((DiagStat'="")&&(DiagObj.MRDIADiagStatDR.DSTATDesc'=DiagStat))
			s MRDiagnosTypeDr="",MRDiagnosTypeDesc=""
			s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
			if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
			i MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
			continue:("^"_DiagnosTypeDesc_"^")'[("^"_MRDiagnosTypeDesc_"^") //'=DiagnosTypeDesc
			s OneRet=Desc
			if (DiagnosFlag="Y") s OneRet=CodeRowid
			if RetStr="" s RetStr=OneRet
			else  s RetStr=RetStr_PDlime_OneRet
		}
		d DiagObj.%Close()
	}
	q RetStr
}

}
