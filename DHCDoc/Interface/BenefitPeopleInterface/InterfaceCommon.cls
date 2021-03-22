Class DHCDoc.Interface.BenefitPeopleInterface.InterfaceCommon Extends %RegisteredObject
{

Parameter AuthorizationId = 1323833980420718594;

/// 草药接口
/// w ##class(DHCDoc.Interface.BenefitPeopleInterface.InterfaceCommon).GetPrescNoCMInfo("3^43^38^37^Y^100ml^245^1^^N^^^^16^^CNMedItemCat"_$c(2)_"4617||1^1^66^^^^4198!1"_$c(1)_"3877||1^1^66^^^^3925!1"_$c(1)_"11449||1^1^^^1^",699,10362,4)
ClassMethod GetPrescNoCMInfo(OrdItemStr As %String, Adm As %String, User As %String, Loc As %String)
{
	s ^tempRen("GetPrescNoCMInfo")=OrdItemStr_","_ Adm_","_ User_","_Loc
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s PrescStr=$p(OrdItemStr,$C(2),1)
	s OrdItemStr=$p(OrdItemStr,$C(2),2)
	s PrescPriorRowid=$P(PrescStr,"^",1)
	s PrescDurRowid=$P(PrescStr,"^",2)
	s PrescInstrRowid=$P(PrescStr,"^",3)
	s PrescFreqRowid=$P(PrescStr,"^",4)
    //优先获取医嘱lis
	s OutPutOrdStr=""
	s PrescriptionItemList=##class(%ListOfObjects).%New()
	
    Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount{
		Set OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		continue:$p(OrdItem,"^",8)'=""   //接收科室id
		Set ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		Set ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		continue:ItemCatDR=""
		Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		continue:OrderType'="R"
		Set PrescDurFactor=1
		If PrescDurRowid'="" Set PrescDurFactor=$P(^PHCDU(PrescDurRowid),"^",2)
		Set ARCIMRowid=$p(OrdItem,"^",1)
		Set DoseQty=$p(OrdItem,"^",2)	
		Set DoseUOMRowid=$p(OrdItem,"^",3)
		if DoseUOMRowid="" s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
		s $p(OneOrdItemStr,"^",6)=DoseQty*PrescDurFactor
		s $p(OneOrdItemStr,"^",12)=DoseQty
		s $p(OneOrdItemStr,"^",13)=DoseUOMRowid
		s $p(OneOrdItemStr,"^",15)=PrescFreqRowid
		s $p(OneOrdItemStr,"^",16)=PrescDurRowid
		s $p(OneOrdItemStr,"^",17)=PrescInstrRowid
		d PrescriptionItemList.Insert(..GetOrdItemInfo(Adm,OneOrdItemStr,ARCIMRowid))
	}
	b //没有数据则退出
	
	if (PrescriptionItemList.Count()<=0) q "-1"_$c(3)_"处方外延到药店失败:"_"没有新的药品处方"
	s OneOrdPrescNum=$i(^PrescNoPAAdmLocal(Adm))
	s OneOrdPrescNo=Adm_OneOrdPrescNum
	s InputJson=##class(ext.util.JsonObject).%New()
	s InputJson=..GetInfo(OneOrdPrescNo,Adm,User,Loc)
	s OutPatient=##class(ext.util.JsonObject).%New() //##class(%RegisteredObject).%New()
	; outpatientNumber 门诊号 字符 必填
	;s OutPatient.outpatientNumber=Adm
	d OutPatient.Put("outpatientNumber",Adm)
	; prescriptionType 处方类型 字符
	;s OutPatient.prescriptionType=""
	d OutPatient.Put("prescriptionType","")
	; chemist 配药药房 字符
	;s OutPatient.chemist=""
	d OutPatient.Put("chemist","")
	; outpatientTime 门诊时间/就诊时间 字符 必填 2019-10-23 10:20:23
	//s OutPatient.
	s OutpatientTime=$zd($P(^PAADM(Adm),"^",6),3)_" "_$zt($P(^PAADM(Adm),"^",7),1)
	d OutPatient.Put("outpatientTime",OutpatientTime)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	s MRAdmRowid=$p(^PAADM(Adm),"^",61)
	//continue:MRAdmRowid="" 
	s outpatientDiagnosis=""
	s sc=obj.Execute(MRAdmRowid)
	
	while obj.Next(.sc) {
		//Quit:'obj.Next()
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
	;s OutPatient.outpatientDiagnosis=outpatientDiagnosis
	d OutPatient.Put("outpatientDiagnosis",outpatientDiagnosis)
	; drugAllergy 过敏药物 字符 重要 阿莫西林胶囊
	;s OutPatient.drugAllergy=""
	d OutPatient.Put("drugAllergy","")
	; specialNote 特殊注明 字符 重要 妊娠(100);肝功能障碍
	;s OutPatient.specialNote=""
	d OutPatient.Put("specialNote","")
	s PrescriptionItemList=##class(ext.util.JsonObject).ListToJson(PrescriptionItemList)
	d OutPatient.Put("prescriptionItemList",PrescriptionItemList)
	s OutPatient=OutPatient.Json() ;##class(ext.util.JsonObject).ObjToJson(OutPatient)
	//diagnosticAmount 新增diagnosticAmount  诊查费
	i OneOrdPrescNum=1 d InputJson.Put("diagnosticAmount",..GetCheckOrdFee(Adm))
	d InputJson.Put("outpatient",OutPatient)
	s InputJsonStream=##class(%GlobalCharacterStream).%New()
	b ;;;;222  //w InputJson.Json()
	d InputJsonStream.Write(InputJson.Json())
	s OutJsonStr=##class(web.DHCENS.BLL.DrugHip.Method.SendDrugInfo).SendDrugMessage(InputJsonStream).Read()
	b ;;;
	s OutJsonObj=##class(ext.util.JsonObject).FromJSON(OutJsonStr)
	s Success=OutJsonObj.GetValue("success")
	
	if (Success="false"){
		s Msg=OutJsonObj.GetValue("msg")
		s OutPutOrdStr="-1"_$c(3)_"处方外延到药店失败:"_Msg_",请与信息科联系" 
	}else{
		s Msg=OutJsonObj.GetValue("msg")
		s Code=OutJsonObj.GetValue("code")
		//continue:Code="1"
		s Url=OutJsonObj.GetValue("url")
		//s RetData=OutJsonObj.GetValue("data")
		s RetData=$p($p(OutJsonStr,"""data"":",2),",""recordList""",1)_"}"
		s:Url="" Url=##class(ext.util.JsonObject).FromJSON(RetData).GetValue("url")
		if (Code="1"){
			s OutPutOrdStr="0"_$c(3)_"处方外延到药店成功！"
        } elseif (Code ="0") {
            // 状态0代表：返回修改，关闭弹框
        	s OutPutOrdStr="1"_$c(3)_Url_$c(3)_"处方外延到药店失败:"_Msg
        } else {
			if ((Code = "11")||(Code = "12")) {
				s OutPutOrdStr="0"_$c(3)_"处方外延到药店成功！"
			}else {
				s OutPutOrdStr="-1"_$c(3)_"处方外延到药店失败:"_Msg
			}
		}
	}
	
	q OutPutOrdStr
}

/// 入参获取   zw ^Temp("wanghc","InsertOrderItem"), zw ^ren("OrderStr")
/// w ##class(DHCDoc.Interface.BenefitPeopleInterface.InterfaceCommon).GetPrescNoInfo("3^43^38^37^Y^100ml^245^1^^N^^^^16^^CNMedItemCat"_$c(2)_"4617||1^1^66^^^^4198!1"_$c(1)_"3877||1^1^66^^^^3925!1"_$c(1)_"11449||1^1^^^1^"",699,10362,4)
ClassMethod GetPrescNoInfo(OrdItemStr As %String, Adm As %String, User As %String, Loc As %String)
{
	s ^tempRen("GetPrescNoInfo")=OrdItemStr_","_ Adm_","_ User_","_Loc
	//OrdItemStr
	//优先获取医嘱lis
	s OutPutOrdStr=""
	s PrescriptionItemList=##class(%ListOfObjects).%New()
	
	s OrdItemCount=$L(OrdItemStr,$c(1))
	s CheckOrdFee=0
	for i=1:1:OrdItemCount{
		s OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		continue:$p(OrdItem,"^",8)'=""   //接收科室id
		s ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		s OrderType=$p(OrdItem,"^",2)
		continue:OrderType'="R"
		if (OrderType'="R"){
			s PatType=$P(^PAADM(Adm,1),"^",6) 
			s BillSubRowId=$P($G(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",9)
			s CheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNode("CheckFeeBillSub")
			continue:CheckFeeBillSub'=BillSubRowId
			s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, "", ARCIMRowid, +$h, "", "", "", "","","")	
			s retPrice=$fn($P(retPrice,"^",1),"",4)
			s CheckOrdFee=CheckOrdFee+retPrice
		}
		s OrderRecLoc=$p(OrdItem,"^",8)
		//continue:OrderRecLoc'="121"
		//b ;;;
		d PrescriptionItemList.Insert(..GetOrdItemInfo(Adm,OrdItem,ARCIMRowid))
	}
	b //没有数据则退出
	
	if (PrescriptionItemList.Count()<=0) q "-1"_$c(3)_"处方外延到药店失败:"_"没有新的药品处方"
	s OneOrdPrescNum=$i(^PrescNoPAAdmLocal(Adm))
	s OneOrdPrescNo=Adm_OneOrdPrescNum
	s InputJson=##class(ext.util.JsonObject).%New()
	s InputJson=..GetInfo(OneOrdPrescNo,Adm,User,Loc)
	s OutPatient=##class(ext.util.JsonObject).%New() //##class(%RegisteredObject).%New()
	; outpatientNumber 门诊号 字符 必填
	;s OutPatient.outpatientNumber=Adm
	d OutPatient.Put("outpatientNumber",Adm)
	; prescriptionType 处方类型 字符
	;s OutPatient.prescriptionType=""
	d OutPatient.Put("prescriptionType","")
	; chemist 配药药房 字符
	;s OutPatient.chemist=""
	d OutPatient.Put("chemist","")
	; outpatientTime 门诊时间/就诊时间 字符 必填 2019-10-23 10:20:23
	//s OutPatient.
	s OutpatientTime=$zd($P(^PAADM(Adm),"^",6),3)_" "_$zt($P(^PAADM(Adm),"^",7),1)
	d OutPatient.Put("outpatientTime",OutpatientTime)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	s MRAdmRowid=$p(^PAADM(Adm),"^",61)
	//continue:MRAdmRowid="" 
	s outpatientDiagnosis=""
	s sc=obj.Execute(MRAdmRowid)
	
	while obj.Next(.sc) {
		//Quit:'obj.Next()
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
	;s OutPatient.outpatientDiagnosis=outpatientDiagnosis
	d OutPatient.Put("outpatientDiagnosis",outpatientDiagnosis)
	; drugAllergy 过敏药物 字符 重要 阿莫西林胶囊
	;s OutPatient.drugAllergy=""
	d OutPatient.Put("drugAllergy","")
	; specialNote 特殊注明 字符 重要 妊娠(100);肝功能障碍
	;s OutPatient.specialNote=""
	d OutPatient.Put("specialNote","")
	s PrescriptionItemList=##class(ext.util.JsonObject).ListToJson(PrescriptionItemList)
	d OutPatient.Put("prescriptionItemList",PrescriptionItemList)
	s OutPatient=OutPatient.Json() ;##class(ext.util.JsonObject).ObjToJson(OutPatient)
	//diagnosticAmount 新增diagnosticAmount  诊查费
	i OneOrdPrescNum=1 d InputJson.Put("diagnosticAmount",..GetCheckOrdFee(Adm))
	d InputJson.Put("outpatient",OutPatient)
	s InputJsonStream=##class(%GlobalCharacterStream).%New()
	b ;;;;222  //w InputJson.Json()
	d InputJsonStream.Write(InputJson.Json())
	s OutJsonStr=##class(web.DHCENS.BLL.DrugHip.Method.SendDrugInfo).SendDrugMessage(InputJsonStream).Read()
	b ;;;
	s OutJsonObj=##class(ext.util.JsonObject).FromJSON(OutJsonStr)
	s Success=OutJsonObj.GetValue("success")
	
	if (Success="false"){
		s Msg=OutJsonObj.GetValue("msg")
		s OutPutOrdStr="-1"_$c(3)_"处方外延到药店失败:"_Msg_",请与信息科联系" 
	}else{
		s Msg=OutJsonObj.GetValue("msg")
		s Code=OutJsonObj.GetValue("code")
		//continue:Code="1"
		s Url=OutJsonObj.GetValue("url")
		//s RetData=OutJsonObj.GetValue("data")
		s RetData=$p($p(OutJsonStr,"""data"":",2),",""recordList""",1)_"}"
		s:Url="" Url=##class(ext.util.JsonObject).FromJSON(RetData).GetValue("url")
		if (Code="1"){
			s OutPutOrdStr="0"_$c(3)_"处方外延到药店成功！"
        } elseif (Code ="0") {
            // 状态0代表：返回修改，关闭弹框
        	s OutPutOrdStr="1"_$c(3)_Url_$c(3)_"处方外延到药店失败:"_Msg
        } else {
			if ((Code = "11")||(Code = "12")) {
				s OutPutOrdStr="0"_$c(3)_"处方外延到药店成功！"
			}else {
				s OutPutOrdStr="-1"_$c(3)_"处方外延到药店失败:"_Msg
			}
		}
	}
	
	q OutPutOrdStr
}

ClassMethod GetOrdItemInfo(Adm As %String, OrdItemStr As %String, ArcItemDr As %String)
{
	
	s OrdItemInfoObj=##class(ext.util.JsonObject).%New() //##class(%RegisteredObject).%New()
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s PAADMRegConDisDR=$P($G(^PAADM(Adm,"DHC")),"^",25)
	s PatType=$P(^PAADM(Adm,1),"^",6)  //PAADM_Epissubtype_DR
	; medicineName 药品名称 字符 必填 0.9%氯化钠注射液、注射用万古霉素、罗红霉素片
	s ARCIMDesc=$p($g(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2),1)),"^",2)
	d OrdItemInfoObj.Put("medicineName",ARCIMDesc)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcItemDr)
	; specification 药品规格 字符 必填 10ml
	s Specification=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",INCIRowid)
	d OrdItemInfoObj.Put("specification",Specification)
	; manufacturer 药品厂家 字符 必填 广州市香雪制药股份有限公司
	s manufacturer=##class(web.DHCST.Common.DrugStkCommon).GetLastManf(INCIRowid)
	s manufacturer=$p(manufacturer,"^",2)
	s:manufacturer["-" manufacturer=$p(manufacturer,"-",2)
	d OrdItemInfoObj.Put("manufacturer",manufacturer)
	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, "", ArcItemDr, +$h, "", "", "", "","","")
	; price 单价，包装单位单价浮点 重要 12.60
	d OrdItemInfoObj.Put("price",$fn($P(retPrice,"^",1),"",4))
	; quantityPer 用量单位，每次用量单位即剂量单位字符 必填 ml
	s DoseUOMRowid=$p(OrdItemStr,"^",13)
	s CTUOMDesc=""
	s:DoseUOMRowid'="" CTUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
	d OrdItemInfoObj.Put("quantityPer",CTUOMDesc) ;ObjOrdItem.OEORIUnitDR.CTUOMDesc)
	; everyTimeDos 每次用量 数值 必填 100
	s OEORIDoseQty=$p(OrdItemStr,"^",12)
	d OrdItemInfoObj.Put("everyTimeDos",OEORIDoseQty) ;;ObjOrdItem.OEORIDoseQty)
	; dailyNumber 每日次数，根据频次换数值 必填 3算  PHCFRDays
	s DailyNumber=""
	s FreqRowid=$p(OrdItemStr,"^",15)
	s:FreqRowid'="" DailyNumber=$p($g(^PHCFR(FreqRowid)),"^",5) // OrdItemInfoObj.dailyNumber=ObjOrdItem.OEORIPHFreqDR.PHCFRDays
	if (DailyNumber="") s DailyNumber=1 ;s OrdItemInfoObj.dailyNumber=1
	 d OrdItemInfoObj.Put("dailyNumber",DailyNumber)
	//d OrdItemInfoObj.Put("
	; dailyDose 每日用量(每次用量*每日次数)数值 必填 300
	;s OrdItemInfoObj.dailyDose=OrdItemInfoObj.everyTimeDos*OrdItemInfoObj.dailyNumber
	d OrdItemInfoObj.Put("dailyDose",OEORIDoseQty*DailyNumber)
	
	; medicationDays 用药天数 数值 必填 3
	
	s DurRowid=$p(OrdItemStr,"^",16)
	s PHCDUFactor=$p($g(^PHCDU(DurRowid)),"^",2)
	d OrdItemInfoObj.Put("medicationDays",PHCDUFactor) ;ObjOrdItem.OEORIDuratDR.PHCDUFactor)
	; frequency 频次 字符 必填 一日三次
	s PHCFRDesc2=$p($g(^PHCFR(FreqRowid)),"^",4)
	d OrdItemInfoObj.Put("frequency",PHCFRDesc2) ;ObjOrdItem.OEORIPHFreqDR.PHCFRDesc2)
	; instruction 用法 字符 必填 静脉输液、口服、肌肉注射
	s InstrRowid=$p(OrdItemStr,"^",17)
	s PHCINDesc1=$p($g(^PHCIN(InstrRowid)),"^",2)
	d OrdItemInfoObj.Put("instruction",PHCINDesc1) ;ObjOrdItem.OEORIInstrDR.PHCINDesc1)
	; count 数量 数值 重要
	//s Count=##class(web.DHCOEOrdItem).GetDspTotleQty(OrdItemDr)
	d OrdItemInfoObj.Put("count",$p(OrdItemStr,"^",6))
	; groupNumber 成组输液组号相同且不为 0数值 重要 1
	d OrdItemInfoObj.Put("groupNumber","")
	; unit 单位，发药单位字符 必填 袋
	s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	s PurUomId=$p(^INCI(INCIRowid,3),"^",6) ;入库单位
	s Unit=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	d OrdItemInfoObj.Put("unit",Unit)
	; adviceType 0:门诊医嘱1:急诊医嘱2:住院医嘱字符 0
	s AdviceType=$case(PAADMType,"O":"1","E":"1","I":"2")
	d OrdItemInfoObj.Put("adviceType",AdviceType)
	; memo 说明 字符
	d OrdItemInfoObj.Put("memo","")
	
	
	q OrdItemInfoObj
}

ClassMethod GetInfo(OneOrdPrescNo As %String, Adm As %String, User As %String, Loc As %String)
{
	s HsopAdmInfo=##class(ext.util.JsonObject).%New() //##class(%RegisteredObject).%New()
	s PatientID=$p($g(^PAADM(Adm)),"^",1)
	;authorizationId 授权 ID，调用接口的厂家授权 ID 字符 必填 1323833980420718594
	//##class(ext.util.JsonObject).%New()
	d HsopAdmInfo.Put("authorizationId","1323833980420718594")  //.authorizationId=..#AuthorizationId
	 ; institutionName 机构名称 字符 必填 河池市第一测试医院
	s HospitalDr=$P($g(^CTLOC(Loc)),"^",22)
	if ((HospitalDr="")&&($d(%session))) Set HospitalDr=%session.Get("LOGON.HOSPID")
	//s HsopAdmInfo.institutionName=$P($g(^CT("HOSP",HospitalDr)),"^",2)
	//d HsopAdmInfo.Put("institutionName",$P($g(^CT("HOSP",HospitalDr)),"^",2))
	d HsopAdmInfo.Put("institutionName","河池市第一测试医院")
	; prescriptionNumber 处方号，住院按每日药单生成处方字符 必填 HC20201104002
	;s HsopAdmInfo.prescriptionNumber=OneOrdPrescNo
	d HsopAdmInfo.Put("prescriptionNumber",OneOrdPrescNo)
	;  patientName 病人姓名， 字符 必填 王大病人 ID 可以加在括号里
	//s HsopAdmInfo.patientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	d HsopAdmInfo.Put("patientName",$p($g(^PAPER(PatientID,"ALL")),"^",1))
	; clinicCode 就诊卡号（患者 id）字符 必填 2874515719
	//s HsopAdmInfo.clinicCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	d HsopAdmInfo.Put("clinicCode",$p($g(^PAPER(PatientID,"ALL")),"^",9))
	; tel 手机号 字符 必填 11121123617
	//s HsopAdmInfo.tel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	d HsopAdmInfo.Put("tel",$p($g(^PAPER(PatientID,"PER",1)),"^",11))
	; idCard 身份证号 字符
	//s HsopAdmInfo.idCard=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	d HsopAdmInfo.Put("idCard",$p($g(^PAPER(PatientID,"PAT",3)),"^",6))
	; sex 性别 字符 必填 女、男、未知s HsopAdmInfo.authorizationId=""
	//s HsopAdmInfo.sex=
	s Sex=##class(web.PAPerson).GetSex(PatientID)
	d HsopAdmInfo.Put("sex",Sex)
	; age 年龄，不满1 岁带月字符 必填 7 岁/3 月
	//s HsopAdmInfo.age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
	d HsopAdmInfo.Put("age",Age)
	; birth 患者出生日期字符 1997-04-23
	//s HsopAdmInfo.birth=$zd($P($G(^PAPER(PatientID,"ALL")),"^",6),3)
	d HsopAdmInfo.Put("birth",$zd($P($G(^PAPER(PatientID,"ALL")),"^",6),3))
	; height 患者身高(单位 cm) 浮点 175.5
	//s HsopAdmInfo.height=""
	d HsopAdmInfo.Put("height","")
	; weight 患者体重(单位 kg) 浮点 65.3
	d HsopAdmInfo.Put("weight","")
	//s HsopAdmInfo.authorizationId=""
	d HsopAdmInfo.Put("authorizationId","1323833980420718594")
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	; category 类别 字符 必填 只限 住院/门诊/急诊
	//s HsopAdmInfo.
	s Category=$case(PAADMType,"O":"门诊","E":"急诊","I":"住院")
	d HsopAdmInfo.Put("category",Category)
	; doctor 医生 字符 必填 赵医生
	s CareProvDR = $p($g(^SSU("SSUSR",User)),"^",14)
	s CarPrvTpRowid=$p($g(^CTPCP(CareProvDR,1)),"^",4)
	s CareProvType=$p($g(^CT("CPT",CarPrvTpRowid)),"^",2)
	//s HsopAdmInfo.doctor=$p($g(^SSU("SSUSR",User)),"^",2)
	d HsopAdmInfo.Put("doctor",$p($g(^SSU("SSUSR",User)),"^",2))
	; doctorId HIS 医生编码/工号 字符 必填 253
	//s HsopAdmInfo.doctorId=$p($g(^SSU("SSUSR",User)),"^",1)
	d HsopAdmInfo.Put("doctorId",$p($g(^SSU("SSUSR",User)),"^",1))
	; department 科室 字符 必填 口腔科
	//s HsopAdmInfo.department=$P($g(^CTLOC(Loc,"DHC")),"^",2)
	d HsopAdmInfo.Put("department",$P($g(^CTLOC(Loc)),"^",2))
	; departmentId HIS 科室编码字符 必填 028
	//s HsopAdmInfo.departmentId=$P($g(^CTLOC(Loc,"DHC")),"^",1)
	d HsopAdmInfo.Put("departmentId",$P($g(^CTLOC(Loc)),"^",1))
	; expense 费别 字符 自费/医保
	//s HsopAdmInfo.expense=""
	d HsopAdmInfo.Put("expense","")
	; innai 类型 数值 必填 inside_web:院内outside_web 院外 csoutside_web_b 院外 bs
	//s HsopAdmInfo.innai="inside_web"
	d HsopAdmInfo.Put("innai","outside_web_b")
	; outsideInnaiName 互联网医院名称 字符重要，当innai 为院外时必传,可与institutionName相同河池市第一测试医院
	//s HsopAdmInfo.outsideInnaiName=$P($g(^CT("HOSP",HospitalDr)),"^",2)
	//d HsopAdmInfo.Put("outsideInnaiName",$P($g(^CT("HOSP",HospitalDr)),"^",2))
	d HsopAdmInfo.Put("outsideInnaiName","河池市第一测试医院")
	// docTitle 开方医生职称
	d HsopAdmInfo.Put("docTitle",CareProvType) 
	q HsopAdmInfo
}

/// w ##class(DHCDoc.Interface.BenefitPeopleInterface.InterfaceCommon).StopOrder("1612788||59^1612788||60^1612788||61","653")
ClassMethod StopOrder(DelOrdStr As %String, UserDr As %String)
{
	s ^tempRen("stopOrder")=DelOrdStr_","_UserDr
	s Len=$l(DelOrdStr,"^")
	s OrdListStr=""
	s retstr=""
	for i=1:1:Len
	{
		s OrderItemStr=$p(DelOrdStr,"^",i)
		s OrItemID=$p(OrderItemStr,"&",1)    //不能改医嘱ID为第一位的位置
		continue:OrItemID=""
		
		//d ##Class(web.DHCOEOrdItem).Stop(OrItemID,UserDr)
		s StartDate=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1)),"^",9)
		s StartTime=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1)),"^",10)
		s retstr= ##class(appcom.OEOrdItem).Stop(OrItemID,UserDr,StartDate,StartTime) 
		w retstr
		if OrdListStr="" s OrdListStr=OrderItemStr_"&"_StartDate_"&"_StartTime
		else  s OrdListStr=OrdListStr_"^"_OrderItemStr_"&"_StartDate_"&"_StartTime
	}
	//if (OrdListStr'="") s retstr=##class(web.UDHCStopOrderLook).StopOrder("","",OrdListStr,UserDr,"","")
	q retstr
}

/// w ##class(DHCDoc.Interface.BenefitPeopleInterface.InterfaceCommon).GetDiagFeeInfo("9807||1^N^3^23/12/2020^15:22^^30^121^31^^^^^1^4^63^^4^^4^N^^Y^^^^^^^N^ ^^^^^^^^^N^^^^^^^^N^undefined^^^^N^^"_$c(1)_"10216||1^R^3^23/12/2020^15:23^1^0.4792^47^31^53||1^^1^2^1^4^63^2^1^^5^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^undefined^^^^N^^",1641985,211,"8")
ClassMethod GetCheckOrdFee(Adm As %String)
{
	
	s OrdDr=$o(^OEORD(0,"Adm",Adm,0))
	q:OrdDr=0 ""
	s CheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNode("CheckFeeBillSub")
	s PatType=$P(^PAADM(Adm,1),"^",6)
	s CheckOrdFee=0 
	s OrdItemSub=0
	f{
		s OrdItemSub=$o(^OEORD(OrdDr,"I",OrdItemSub))
		q:OrdItemSub=""
		s ArcItemDr=$p($g(^OEORD(OrdDr,"I",OrdItemSub,"1")),"^",2)
		s BillSubRowId=$P($G(^ARCIM(+ArcItemDr,$P(ArcItemDr,"||",2),1)),"^",9)
		continue:CheckFeeBillSub'=BillSubRowId
		s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, "", ArcItemDr, +$h, "", "", "", "","","")
		s retPrice=$P(retPrice,"^",1)
		s CheckOrdFee=CheckOrdFee+retPrice
	}
	q $fn(CheckOrdFee,"",4)
}

}
