Class web.DHCDocCommonLocal Extends %RegisteredObject
{

ClassMethod GetPatientOrderList(InputXml As %String)
{
	s $ZTRAP="GetPatientOrderListErr"
	if (InputXml["?>") set InputXml=$p(InputXml,"?>",2)
	set InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"Request")
	// 就诊号或病患 ID 或医保卡卡号或身份证号码或就诊卡卡号
	s PatientNo=InputObj.%Get("patient_no") ;patient_no
    if (PatientNo="") q $$GetPatientOrderListErr("1001","病患信息编号不能为空")
	set StartDate=InputObj.%Get("start_date")
	set StartDate=InputObj.%Get("end_date")
	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    if ((StartDate="")||(EndDate="")) q $$GetPatientOrderListErr("1002","开始时间和结束时间不能为空！")
    set ItemArr=[]
	set AdmTypeStr="O^E^I"
	set Patid=""
    s IndCount=0
	for i=1:1:$l(AdmTypeStr,"^"){
        set AdmType=$p(AdmTypeStr,"^",i)
		set AdmId=0
		for {
			set AdmId=$o(^PAPERdr(Patid,"ADM",AdmType,AdmId))
			quit:AdmId=""
			set OeOri=$o(^OEORD(0,"Adm",AdmId,0))
			continue:AdmId=""
			for OneDate=StartDate:1:EndDate{
				set Childsub=0
				for {
					set ChildSub=$o(^OEORDi(0,"StDt",OneDate,OeOri,Childsub))
					quit:Childsub=""
                    set ARCIMRowid=$p($g(^OEORD(OeOri,"I",Childsub,1)),"^",2)
                    set ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		            set OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
                    continue:OrderType'="L"
                    s OrdItemDr=OeOri_"||"_Childsub
                    do ItemArr.%Push($$GetItemObjByItemDr())
                    set IndCount=IndCount+1
				}
			}
		}
	}
    if (IndCount=0) q $$GetPatientOrderListErr("1003","未找到该患者的检查数据！")
    set OutPutObj=##class(%DynamicObject).%New()
    do OutPutObj.%Set("ResultCode","0")
	do OutPutObj.%Set("ResultContent","成功!")
    set OutPutObj.items=ItemArr
    quit ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
GetItemObjByItemDr()
    set ItemObj=##class(%DynamicObject).%New()
    ; patient_id 病患 ID NOT NULL
    d ItemObj.%Set("patient_id",PatientNo)
    ; name 姓名 病患姓名
    s PatientName=$P($G(^PAPER(Patid,"ALL")),"^",1)
    d ItemObj.%Set("name",PatientName)
    ; sex 性别 病患性别
    s PatientSexDr=$P($G(^PAPER(Patid,"ALL")),"^",7)
    if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    else  s PatientSex=""
    d ItemObj.%Set("sex",PatientSex)
    ; birthday 生日 YYYY-MM-DD
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=##class(websys.Conversions).DateLogicalToHtml(PatientDOB)
    d ItemObj.%Set("birthday",PatientBirthday)
    ; age 年龄 病患年龄
    s Age==##class(web.DHCBillInterface).GetPapmiAge(Patid,"")
    d ItemObj.%Set("age",Age)
    ; mobile 联系方式 病患联系方式
    s Mobile=$P($G(^PAPER(Patid,"PER",1)),"^",11)
    d ItemObj.%Set("mobile",Mobile)
    ; creation_time 医嘱下达时间 YYYY-MM-DD HH:MM:SS
    s OrderDate=$p($g(^OEORD(OeOri,"I",Childsub,3)),"^",7)
    s:OrderDate'="" OrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
    s OrdTime=$p($g(^OEORD(OeOri,"I",Childsub,1)),"^",17)
    s:OrdTime'="" OrdTime=##class(websys.Conversions).TimeLogicalToHtml(OrdTime)
    d ItemObj.%Set("creation_time",OrderDate_" "_OrdTime)
    ; bill_no 就诊号
    d ItemObj.%Set("bill_no",AdmId)
    ; card_no 卡号
    s CardNo=""
    d ItemObj.%Set("card_no",CardNo)
    ; diagnosis 诊断
    s Diagnosis=""
    d ItemObj.%Set("diagnosis",Diagnosis)
    ; source 来源 门诊 0/急诊 1
    s Source=$case(AdmType,"O":"0","E":"1","I":"2")
    d ItemObj.%Set("source",Source)
    ; document_no 医嘱编号
    d ItemObj.%Set("document_no",$replace(OrdItemDr,"||","_"))
    ; requester 申请科室
    d ItemObj.%Set("requester","")
    ; requester_doctor 申请医生
    d ItemObj.%Set("requester_doctor","")
    ; priority 患者优先级 急诊/军人/VIP/孕妇/老人/小孩/普通患者
    s Priority=$case(AdmType,"E":"急诊",:"普通患者")
    d ItemObj.%Set("priority",Priority)
    ; item_barcode 检验号 NOT NULL
    s LabEpisodeNo=$p($g(^OEORD(OeOri,"I",Childsub,3)),"^",20)
    d ItemObj.%Set("item_barcode",LabEpisodeNo)
    ; item_name 医嘱名称
    s ArcItemDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
    d ItemObj.%Set("item_name",ArcItemDesc)
    ; item_class 标本类型名称
    d ItemObj.%Set("item_class","")
    ; executor 接收科室
    d ItemObj.%Set("executor","")
    ; cube_type 采集容器名称
    d ItemObj.%Set("cube_type","")
    ; cube_type_code Lis 采集容器编码
    d ItemObj.%Set("cube_type_code","")
    ; reportAddress 获取检验的地址 病患根据此地址去取报告
    d ItemObj.%Set("reportAddress","")
    ; analysisDuration 检验所需等待时间
    d ItemObj.%Set("analysisDuration","")
    ; extra_param1 扩展参数 1
    d ItemObj.%Set("extra_param1","")
    ; extra_param2 扩展参数 2
    d ItemObj.%Set("extra_param2","")
    ; extra_param3 扩展参数 3
    d ItemObj.%Set("extra_param3","")
    ; extra_param4 扩展参数 4
    d ItemObj.%Set("extra_param4","")
    ; extra_param5 扩展参数 5
    d ItemObj.%Set("extra_param5","")
    quit ##class(DHCDoc.Util.XMLParse).ObjToXML(ItemObj,"item","")
    //quit ItemObj
GetPatientOrderListErr(ErrCode="",ErrText="")
	if (ErrText="") s ErrText="获取有效医嘱失败"
    if (ErrCode="") s ErrCode="-1"
	s OutErr=##class(%DynamicObject).%New()
	d OutErr.%Set("ResultCode",ErrCode)
	d OutErr.%Set("ResultContent",ErrText)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutErr,"Response","")
}

}