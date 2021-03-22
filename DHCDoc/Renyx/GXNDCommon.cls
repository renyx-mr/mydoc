Class DHCDoc.Renyx.GXNDCommon Extends %RegisteredObject
{

Parameter AuthorizationId;

ClassMethod GetPrescNoInfo(OrderStr As %String, Adm As %String, User As %String, Loc As %String)
{
	s OrderLen=$L(OrderStr,"^")
	s OrdPrescNoList=""
	f i=1:1:OrderLen 
	{
		S OneOrderStr=$P(OrderStr,"^",i)
		s OrderIDGet=$P(OneOrderStr,"*",2)
		Continue:OrderIDGet=""
		s ArcimRowId=$p($p(OrderStr,"^",i),"*",1)
		continue:ArcimRowId=""
		//##class(User.PAAllergy).%OpenId(AllergyId)
		//s ItmID=$P($G(^OEORD(OrderRowid,"I",sub,1)),"^",2)
	    s ItemCatDR=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
	    s OrderType=$P($g(^ARC("IC",ItemCatDR)),"^",7)
	    continue:OrderType'="R"
		s OrdPrescNo=$p($g(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),1)),"^",14)
		if ('$d(OrdPrescNoList(OrdPrescNo))){
			s OrdPrescNoList(OrdPrescNo)=ArcimRowId_"^"_OrderIDGet
		}else{
			s OrdPrescNoList(OrdPrescNo)=OrdPrescNoList(OrdPrescNo)_$c(1)_ArcimRowId_"^"_OrderIDGet
		}
	}
	s OneOrdPrescNo=0
	s InputJson={}
	f {
		s OneOrdPrescNo=OrdPrescNoList(OneOrdPrescNo)
		q:OneOrdPrescNo=""
		s InputJson=..GetInfo(OneOrdPrescNo,Adm,User,Loc)
		s OutPatient={}
		; outpatientNumber 门诊号 字符 必填
		s OutPatient.outpatientNumber=Adm
		; prescriptionType 处方类型 字符
		s OutPatient.prescriptionType=""
		; chemist 配药药房 字符
		s OutPatient.chemist=""
		; outpatientTime 门诊时间/就诊时间 字符 必填 2019-10-23 10:20:23
		s OutPatient.outpatientTime=$zd($P(^PAADM(Adm),"^",6),3)_" "_$zt($P(^PAADM(Adm),"^",7),1)
		Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		s MRAdmRowid=$p(^PAADM(Adm),"^",61)
		q:MRAdmRowid="" 
		s outpatientDiagnosis=""
		d obj.Execute(MRAdmRowid)
		while 'obj.Next() {
			Quit:'obj.Next()
			s Desc=obj.Data("MRDIAICDCodeDRDesc")
			s Rowid=obj.Data("ID")
			s CodeRowid=obj.Data("MRDIAICDCodeDR")
			s MRDesc=obj.Data("MRDIADesc")
			if (Desc="") {
				s Desc=MRDesc
			}else{
				i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
			}
			if (outpatientDiagnosis="") s outpatientDiagnosis=Desc
			else  s outpatientDiagnosis=outpatientDiagnosis_";"_Desc
		}
		; outpatientDiagnosis 门诊诊断 字符 必填 体弱;高血压
		s OutPatient.outpatientDiagnosis=outpatientDiagnosis
		; drugAllergy 过敏药物 字符 重要 阿莫西林胶囊
		s OutPatient.drugAllergy=""
		; specialNote 特殊注明 字符 重要 妊娠(100);肝功能障碍
		s OutPatient.specialNote=""
		
		s InputJson.outpatient=OutPatient
		s InputJson.outpatient.prescriptionItemList=[]
		f j=1:1:$l(OrdPrescNoList(OneOrdPrescNo),$c(1)) {
			//s PrescriPtionItemObj=..GetOrdItemInfo()
			d InputJson.outpatient.prescriptionItemList.%Push(..GetOrdItemInfo())
		}
		//s InputJson.outpatient.prescriptionItemList=prescriptionItemList
	}
	q InputJson.%ToJSON
}

ClassMethod GetOrdItemInfo(Adm As %String, OrdItemDr As %String, ArcItemDr As %String)
{
	
	s OrdItemInfoObj={}
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s PAADMRegConDisDR=$P($G(^PAADM(Adm,"DHC")),"^",25)
	s PatType=$P(^PAADM(Adm,1),"^",6)  //PAADM_Epissubtype_DR
	s ObjOrdItem=##class(User.PAAllergy).%OpenId(OrdItemDr)
	if $IsObject(ObjOrdItem){
		; medicineName 药品名称 字符 必填 0.9%氯化钠注射液、注射用万古霉素、罗红霉素片
		s OrdItemInfoObj.medicineName=ObjOrdItem.OEORIItmMastDR.ARCIMDesc
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcItemDr)
		; specification 药品规格 字符 必填 10ml
		s OrdItemInfoObj.specification=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",INCIRowid)
		; manufacturers 药品厂家 字符 必填 广州市香雪制药股份有限公司
		s OrdItemInfoObj.manufacturers=##class(web.DHCST.Common.DrugStkCommon).GetLastManf(INCIRowid)
		s ExpStr=PAADMRegConDisDR_"^"_OrdItemDr_"^"_""_"^"_Adm_"^"_ObjOrdItem.OEORIRecDepDRGetObjectId()
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, ObjOrdItem.OEORIBBExtCode, ArcItemDr
			, ObjOrdItem.OEORISttDat, "", "", "", "",ObjOrdItem.OEORIRecDepDRGetObjectId(),PAADMRegConDisDR
			,ObjOrdItem.OEORIItmMastDR.ARCIMBillingUOMDRGetObjectId(),ExpStr)
		; price 单价，包装单位单价浮点 重要 12.60
		s OrdItemInfoObj.price=$fn($P(retPrice,"^",1),"",4)
		; quantityPer 用量单位，每次用量单位即剂量单位字符 必填 ml
		s OrdItemInfoObj.quantityPer=OrdItemInfoObj.OEORIUnitDR.CTUOMDesc
		; everyTimeDos 每次用量 数值 必填 100
		s OrdItemInfoObj.everyTimeDos=ObjOrdItem.OEORIDoseQty
		; dailyNumber 每日次数，根据频次换数值 必填 3算  PHCFRDays
		s:ObjOrdItem.OEORIPHFreqDRGetObjectId()'="" OrdItemInfoObj.dailyNumber=ObjOrdItem.OEORIPHFreqDR.PHCFRDays
		if (OrdItemInfoObj.dailyNumber="") s OrdItemInfoObj.dailyNumber=1
		; dailyDose 每日用量(每次用量*每日次数)数值 必填 300
		s OrdItemInfoObj.dailyDose=OrdItemInfoObj.everyTimeDos*OrdItemInfoObj.dailyNumber
		
		; medicationDays 用药天数 数值 必填 3
		s OrdItemInfoObj.medicationDays=OrdItemInfoObj.OEORIDuratDR.PHCDUDesc1
		; frequency 频次 字符 必填 一日三次
		s OrdItemInfoObj.frequency=ObjOrdItem.OEORIPHFreqDR.PHCFRDesc1
		; instruction 用法 字符 必填 静脉输液、口服、肌肉注射
		s OrdItemInfoObj.instruction=OrdItemInfoObj.OEORIInstrDR.PHCINDesc1
		; count 数量 数值 重要
		s OrdItemInfoObj.count=##class(web.DHCOEOrdItem).GetDspTotleQty(OrdItemDr)
		; groupNumber 成组输液组号相同且不为 0数值 重要 1
		s OrdItemInfoObj.groupNumber=""
		; unit 单位，发药单位字符 必填 袋
		s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
		s OrdItemInfoObj.unit=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
		; adviceType 0:门诊医嘱1:急诊医嘱2:住院医嘱字符 0
		s OrdItemInfoObj.adviceType=$case(PAADMType,"O":"1","E":"1","I":"2")
		; memo 说明 字符
		s OrdItemInfoObj.memo=""
	}
	d ObjOrdItem.%Close()
	q ObjOrdItem
}

ClassMethod GetInfo(OneOrdPrescNo As %String, Adm As %String, User As %String, Loc As %String)
{
	s HsopAdmInfo={}
	s PatientID=$p($g(^PAADM(Adm)),"^",1)
	;authorizationId 授权 ID，调用接口的厂家授权 ID 字符 必填 1323833980420718594
	s HsopAdmInfo.authorizationId=..#AuthorizationId
	; institutionName 机构名称 字符 必填 河池市第一测试医院
	s HospitalDr=$P($g(^CTLOC(Loc)),"^",22)
	if ((HospitalDr="")&&($d(%session))) Set HospitalDr=%session.Get("LOGON.HOSPID")
	s HsopAdmInfo.institutionName=$P($g(^CT("HOSP",HospitalDr)),"^",2)
	; prescriptionNumber 处方号，住院按每日药单生成处方字符 必填 HC20201104002
	s HsopAdmInfo.prescriptionNumber=OneOrdPrescNo
	;  patientName 病人姓名， 字符 必填 王大病人 ID 可以加在括号里
	s HsopAdmInfo.patientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	; clinicCode 就诊卡号（患者 id）字符 必填 2874515719
	s HsopAdmInfo.clinicCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	; tel 手机号 字符 必填 11121123617
	s HsopAdmInfo.tel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	; idCard 身份证号 字符
	s HsopAdmInfo.idCard=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	; sex 性别 字符 必填 女、男、未知s HsopAdmInfo.authorizationId=""
	s HsopAdmInfo.sex=##class(web.PAPerson).GetSex(PatientID)
	; age 年龄，不满1 岁带月字符 必填 7 岁/3 月
	s HsopAdmInfo.age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
	; birth 患者出生日期字符 1997-04-23
	s HsopAdmInfo.birth=$zd($P($G(^PAPER(PatientID,"ALL")),"^",6),3)
	; height 患者身高(单位 cm) 浮点 175.5
	s HsopAdmInfo.height=""
	; weight 患者体重(单位 kg) 浮点 65.3
	s HsopAdmInfo.authorizationId=""
	
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	; category 类别 字符 必填 只限 住院/门诊/急诊
	s HsopAdmInfo.category=$case(PAADMType,"O":"门诊","E":"急诊","I":"住院")
	; doctor 医生 字符 必填 赵医生
	s CareProvDR = $p($g(^SSU("SSUSR",User)),"^",14)
	s HsopAdmInfo.doctor=$p($g(^SSU("SSUSR",User)),"^",2)
	; doctorId HIS 医生编码/工号 字符 必填 253
	s HsopAdmInfo.doctorId=$p($g(^SSU("SSUSR",User)),"^",1)
	; department 科室 字符 必填 口腔科
	s HsopAdmInfo.department=$P($g(^CTLOC(Loc,"DHC")),"^",2)
	; departmentId HIS 科室编码字符 必填 028
	s HsopAdmInfo.departmentId=$P($g(^CTLOC(Loc,"DHC")),"^",1)
	; expense 费别 字符 自费/医保
	s HsopAdmInfo.expense=""
	; innai 类型 数值 必填 inside_web:院内outside_web 院外 csoutside_web_b 院外 bs
	s HsopAdmInfo.innai="inside_web"
	; outsideInnaiName 互联网医院名称 字符重要，当innai 为院外时必传,可与institutionName相同河池市第一测试医院
	s HsopAdmInfo.outsideInnaiName=$P($g(^CT("HOSP",HospitalDr)),"^",2)
	q HsopAdmInfo
}

}
