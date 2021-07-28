Class DHCDoc.Interface.JingYiTong.Common Extends %RegisteredObject
{

/// 京医通报到接口
/// w ##class(DHCDoc.Interface.JingYiTong.Common).PatCheckIn("")
ClassMethod PatCheckIn(InputXml As %String)
{
	s $ZTRAP="PatCheckInErr"
	s reg=rttty
    s InputXml="<request><time_stamp>20161007073410</time_stamp><input><reg_no>100099735806</reg_no><his_reg_no>278829</his_reg_no><hos_code>H10000000</hos_code><dept_code1>h_GK_07f80ebb_vir</dept_code1><dept_code2>556</dept_code2><card_no>115486999002</card_no><card_type>3</card_type><patient_name>大宝</patient_name><id_card>110108196705226341</id_card><id_card_type>1</id_card_type><reg_date>20211007</reg_date><reg_half>1</reg_half><reg_hour>9:00-9:30</reg_hour></input></request>"
    //if InputXml["_" s InputXmlInputXml=$replace(InputXml,"_","")
    s InputXml="<input>"_$p($p(InputXml,"<input>",2),"</input>",1)_"</input>"
    s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(InputXml,"input")
    // reg_no	平台的订单编号	20	是	遵循安全、唯一、不重复的标准
    s RegNo=InputObj.%Get("reg_no")
    // his_reg_no	his 系统中的生成的单号	255	是
    s AdmId=InputObj.%Get("his_reg_no")
    // hos_code	医院编码	20	是	
    s HospCode=InputObj.%Get("hos_code")
    // dept_code1	一级科室编码	20	是
    s DeptDr1=InputObj.%Get("dept_code1")	
    // dept_code2	二级科室编码	20	是	
    s DeptCode=InputObj.%Get("dept_code2")
    // card_no	患者卡号	20	是	
    s CardNo=InputObj.%Get("card_no")
    // card_type	患者卡类型	枚举	是	参考附录：卡类型
    s CardTypr=InputObj.%Get("card_type")
    // patient_name	患者姓名	10	是	
    s patName=InputObj.%Get("patient_name")
    // id_card	患者证件号	20	是	
    s PatIDNo=InputObj.%Get("id_card")
    // id_card_type	患者证件类型	枚举	是	参考附录：证件类型
    s IDCardType=InputObj.%Get("id_card_type")
    // reg_date	就诊日期	日期	是	例如:2016-08-20
    s RegDate=InputObj.%Get("reg_date")
    // reg_half	就诊单元	枚举	是	参考附录：就诊单元
    s RegHalf=InputObj.%Get("reg_half")
    // reg_hour	就诊时间	20	否	号源list接口返回的某个时间区间9:00-9:30
	s RegHour=InputObj.%Get("reg_hour")
	s PatDr=$P(^PAADM(AdmId),"^")
	s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	set IDNo=$p($g(^PAPER(PatDr,"PAT",3)),"^",6)
	if (patName'=PatName)!(IDNo'=PatIDNo) q $$PatCheckInErr("就诊信息与患者信息不对应，无法进行报到！")
	s AdmDate=$p($g(^PAADM(AdmId)),"^",6)
	s RegDate=$zdh(RegDate)
	if (AdmDate'=RegDate) q $$PatCheckInErr("就诊日期不对，请核实患者信息!")
	s CurrDate=+$H
	s CurrTime=$P($H,",",2)
	if (RegDate>CurrDate) q $$PatCheckInErr("已过就诊日期，请退号！")
	s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmId,""))
	q:RegfeeRowId="" $$PatCheckInErr("未找到改挂号信息！")
	s FeeDepDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),13)
	s FeeDepCode=""
	s:FeeDepDr'="" FeeDepCode=$p($g(^CTLOC(FeeDepDr)),"^",1)
	q:(DeptCode'=FeeDepCode) $$PatCheckInErr("就诊科室不对应，无法进行报到！")
	s FeeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
	if (FeeRBASDr="") q $$PatCheckInErr("挂号信息异常：未找到对应的排班记录！")
	s QueID=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmId,0))
	if (QueID="") q $$PatCheckInErr("未找到该病人对列信息，请到分诊台处理！")
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	if ((status'="报到")&&(status'="过号")) q $$PatCheckInErr("非【报到】或【过号】状态的记录不能进行报到!")
	// <response><ret_code>0</ret_code><ret_msg>操作成功</ret_msg><output><state>1</state></output></response>
	s RetPatArrive=##class(web.DHCAlloc).PatArrive("","",QueID,"")
	if (RetPatArrive'=0) q $$PatCheckInErr(RetPatArrive)
	/*s StateStr="1"
	
	s ASStartTime=$P($G(^RBAS(FeeRBASDr,$p(FeeRBASDr,"||",2))),"^",4)
	if (RegDate<CurrDate) s StateStr="1"*/
	s OutPutObj=##class(%DynamicObject).%New()
	d OutPutObj.%Set("ret_code","0")
	d OutPutObj.%Set("ret_msg","操作成功")
	d OutPutObj.%Set("output","<state>1</state>")
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"response","")
PatCheckInErr(ErrText="")
	//q $$PatCheckInErr()
	if (ErrText="") s ErrText="报到失败"
	s OutErr=##class(%DynamicObject).%New()
	d OutErr.%Set("ret_code","-1")
	d OutErr.%Set("ret_msg",ErrText)
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutErr,"response","")
}

}
