Class DHCDoc.Interface.ShangHaiFanWei.CrmInterface Extends %RegisteredObject
{

/// "{""customer_his_id"":""0000000006"",""page"":""1"",""limit"":""0"",""start_time"":"""",""end_time"":""""}"
/// w ##class(DHCDoc.Interface.ShangHaiFanWei.CrmInterface).FindPatInfo("{""customer_his_id"":""0000000006"",""page"":""1"",""limit"":""0"",""start_time"":"""",""end_time"":""""}")
ClassMethod FindPatInfo(InputStr As %String)
{
	s $ztrap="FindPatInfoErr"
	s:InputStr="" InputStr="{}"
	s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	s PatientNo=InputObj.%Get("customer_his_id")
	s Page=InputObj.%Get("page")
	s Limit=InputObj.%Get("limit")
	s StartDateStr=InputObj.%Get("start_time")
	s EndDateStr=InputObj.%Get("end_time")
	s StartDate="",StartTime=""
	s:StartDateStr'="" StartDate=$e(StartDateStr,1,10)
	s:StartDateStr'="" StartTime=$e(StartDateStr,11,*)
	s EndDate="",EndTime=""
	s:EndDateStr'="" EndDate=$e(StartDateStr,1,10)
	s:EndDateStr'="" EndTime=$e(StartDateStr,11,*)
	s OutPutObj={},DataObj={},DataList=[]
	if (StartDate'=""){
		s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s:EndDate="" EndDate=+$h
		s MyatientId=""
		s:PatientNo'="" MyatientId=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		for OneData=StartDate:1:EndDate{
			s PatientId=0
			for {
				s PatientId=$o(^PAPERi("AddDate",OneData,PatientId))
				q:PatientId=""
				continue:(MyatientId'="")&&(MyatientId'=PatientId)
				s PatActive=$p($g(^PAPER(PatientId,"PAT",1)),"^",6)
				continue:PatActive'="Y"
				s OneDataObj={}
				d GetPatDataObj
				d DataList.%Push(OneDataObj)
			}
		}
	}elseif (PatientNo'=""){
		s PatientId=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		q:PatientId="" $$FindPatInfoErr("客户标识未在his对应数据！")
		s PatActive=$p($g(^PAPER(PatientId,"PAT",1)),"^",6)
		q:PatActive'="Y" $$FindPatInfoErr("客户标识在his对应的数据异常！")
		s OneDataObj={}
		d GetPatDataObj
		d DataList.%Push(OneDataObj)
	}else{
		s PatientId=0
		for {
			s PatientId=$o(^PAPER(PatientId))
			q:PatientId=""
			s PatActive=$p($g(^PAPER(PatientId,"PAT",1)),"^",6)
			continue:PatActive'="Y"
			s OneDataObj={}
			d GetPatDataObj
			d DataList.%Push(OneDataObj)
		}
	}
	if (DataList.%Size()=0){
		q $$FindPatInfoErr("没有获取到客户列表数据！")
	}
	d DataObj.%Set("total",DataList.%Size())
	d DataObj.%Set("list",DataList)
	d OutPutObj.%Set("code","0")
	d OutPutObj.%Set("msg","获取客户列表数据成功")
	d OutPutObj.%Set("data",DataObj)
	q OutPutObj.%ToJSON()
GetPatDataObj
	; full_name	姓名	String		否	
	d OneDataObj.%Set("full_name",$p($g(^PAPER(PatientId,"ALL")),"^",1))
	; sex	性别	String		否	性别(0:保密1:男2女)
	s Sex=$p($g(^PAPER(PatientId,"ALL")),"^",7)
    s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
    s Sex=$case(Sex,"男":"1","女":"2",:"0")
	d OneDataObj.%Set("sex",Sex)
	; birthday	生日	String		是	
	s Dob=$p($g(^PAPER(PatientId,"ALL")),"^",6)
    s:Dob'="" Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	d OneDataObj.%Set("birthday",Dob)
	; phone	手机	String		否	
	s Mobile=$p($g(^PAPER(PatientId,"PER",4)),"^",21)
	d OneDataObj.%Set("phone",Mobile)
	; cred_sn	身份证	String		否	
	s DVAnumber=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
	d OneDataObj.%Set("cred_sn",DVAnumber)
	; province	省份	String		是	
	d OneDataObj.%Set("province","")
	; city	城市	String		是	
	d OneDataObj.%Set("city","")
	; district	区县	String		是	
	d OneDataObj.%Set("district","0")
	; address	地址	String		是	
	s Address=$p($g(^PAPER(PatientId,"PER","ADD",1)),"^",1)
	d OneDataObj.%Set("address",Address)
	; source	来源	String		否	
	d OneDataObj.%Set("source","HIS")
	; card_sn	就诊卡号	String		否	卡号
	s PatientNo=$p($g(^PAPER(PatientId,"PAT",1)),"^",1)
	d OneDataObj.%Set("card_sn",PatientNo)
	q
FindPatInfoErr(ErrText = "")
	s $ztrap=""
	s OutPutObj={}
	if (ErrText="") s ErrText="获取客户列表数据失败"
	d OutPutObj.%Set("code","-1")
	d OutPutObj.%Set("msg",ErrText)
	q OutPutObj.%ToJSON()
}

/// w ##class(DHCDoc.Interface.ShangHaiFanWei.CrmInterface).FindAdmOrdInfo("")
ClassMethod FindAdmOrdInfo(InputStr As %String)
{
	//s $ztrap="FindAdmOrdInfoErr"
	s:InputStr="" InputStr="{}"
	s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	; customer_his_id	客户标识	String		否
	; page	页号	String		是
	; limit	每页的行数	String		是
	; start_time	开始时间	String		是
	; end_time	结束时间	String		是
	s PatientNo=InputObj.%Get("customer_his_id")
	s Page=InputObj.%Get("page")
	s Limit=InputObj.%Get("limit")
	s StartDateStr=InputObj.%Get("start_time")
	s EndDateStr=InputObj.%Get("end_time")
	s StartDate="",StartTime=""
	s:StartDateStr'="" StartDate=$e(StartDateStr,1,10)
	s:StartDateStr'="" StartTime=$e(StartDateStr,11,*)
	s EndDate="",EndTime=""
	s:EndDateStr'="" EndDate=$e(StartDateStr,1,10)
	s:EndDateStr'="" EndTime=$e(StartDateStr,11,*)
	s OutPutList=[]
	if (StartDate'=""){
		s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		s StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
		s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s:EndTime'="" EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
		s:EndDate="" EndDate=+$h
		s:EndTime="" EndTime=$p($h,",",2)
		// ^PAADMi("PAADM_DateTime",{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
		s PatientId=""
		s:PatientNo'="" PatientId=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		for OneDate=StartDate:1:EndDate{
			s MyStartTime=0
			if (OneDate=StartDate) s MyStartTime=StartTime
			s MyEndTime=86399
			if (OneDate=EndDate) s MyEndTime=EndTime
			for OneTime=MyStartTime:1:MyEndTime{
				s AdmId=0
				for{
					s AdmId=$o(^PAADMi("PAADM_DateTime",OneDate,OneTime,AdmId))
					q:AdmId=""
					s MyPatientId=$p($g(^PAADM(AdmId)),"^",1)
					continue:(PatientId'="")&&(MyPatientId'=PatientId)
					s AdmVisitStatus=$p($g(^PAADM(AdmId)),"^",20)
					continue:AdmVisitStatus'="A"
					s OneAdmInfoObj={}
					d GetAdmInfo
					d OutPutList.%Push(OneAdmInfoObj)
				}
			}
		}
	}elseif (PatientNo'=""){
		s PatientId=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		q:PatientId="" $$FindAdmOrdInfoErr("客户标识未在his对应数据！")
		// ^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s AdmTypeStr="E^O^I"
		for AdmTypeInd=1:1:$l(AdmTypeStr,"^"){
			s AdmType=$p(AdmTypeStr,"^",AdmTypeInd)
			s AdmId=0
			for{
				s AdmId=$o(^PAPERdr(PatientId,"ADM",AdmType,AdmId))
				q:AdmId=""
				s AdmVisitStatus=$p($g(^PAADM(AdmId)),"^",20)
				continue:AdmVisitStatus'="A"
				s OneAdmInfoObj={}
				d GetAdmInfo
				d OutPutList.%Push(OneAdmInfoObj)
			}
		}
	}else{
		s AdmId=0
		for {
			s AdmId=$o(^PAADM(AdmId))
			q:AdmId=""
			s AdmVisitStatus=$p($g(^PAADM(AdmId)),"^",20)
			continue:AdmVisitStatus'="A"
			s OneAdmInfoObj={}
			d GetAdmInfo
			d OutPutList.%Push(OneAdmInfoObj)
		}
	}
	q OutPutList.%ToJSON()
GetAdmInfo
	; diagnosis_sn	就诊号	String		否	
	d OneAdmInfoObj.%Set("diagnosis_sn",AdmId)
	; time	就诊日期时间	String		否	YYYY-MM-DDHH：MM：SS
	s AdmDateTimeStr=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",6))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^PAADM(AdmId)),"^",7))
	d OneAdmInfoObj.%Set("time",AdmDateTimeStr)
	; doctor	就诊科室	String		否	
	s DepCodeDR=$p($g(^PAADM(AdmId)),"^",4)
	s AdmDeptDesc=""
	s:DepCodeDR'="" AdmDeptDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
	d OneAdmInfoObj.%Set("doctor",AdmDeptDesc)
	; item	就诊医嘱列表	String		否	单次就诊所有的医嘱
	s ItemList=[]
	s OrderId=$o(^OEORD(0,"Adm",AdmId,0))
	if (OrderId'=""){
		s ItemSub=0
		for {
			s ItemSub=$o(^OEORD(OrderId,"I",ItemSub))
			q:ItemSub=""
			s OrdIteObj={}
			d GetAdmOrdItemInfo
			d ItemList.%Push(OrdIteObj)
		}
	}
	d OneAdmInfoObj.%Set("item",ItemList)
	q
GetAdmOrdItemInfo
	; Item_id	医嘱标识	String		否	
	s ARCIMRowId=$p($g(^OEORD(OrderId,"I",ItemSub,1)),"^",2)
	q:(ARCIMRowId="")
	q:('$d(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)))
    s ArcItemCode=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",1)
	d OrdIteObj.%Set("Item_id",ArcItemCode)
	; item_name	医嘱名称	String		否
	s ArcItemDesc=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",2)
	d OrdIteObj.%Set("item_name",ArcItemDesc)	
	; goods_id	套餐标识	String		否	
	d OrdIteObj.%Set("goods_id","")
	; goods_name	套餐名称	String		否	
	d OrdIteObj.%Set("goods_name","")
	; order_id	订单标识	String		否	
	d OrdIteObj.%Set("order_id",OrderId_"||"_ItemSub)
	q 
FindAdmOrdInfoErr(ErrText = "")
	s $ztrap=""
	s OutPutObj={}
	if (ErrText="") s ErrText="获取就诊记录数据失败"
	d OutPutObj.%Set("code","-1")
	d OutPutObj.%Set("msg",ErrText)
	q OutPutObj.%ToJSON()
}

}
