Class web.QueryAdmInfoCommon Extends %RegisteredObject
{

/// call web_DHCENS_BLL_QCInterface.Dataexchangeorg_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryAdmRegInfo_TM_OUT_REG("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryAdmRegInfo","2019-01-02","2020-01-01")
Query QueryAdmRegInfo(SatarRegDate As %String, EndRegDate As %String) As %Query(ROWSPEC = "ID,PERSON_ID,OUT_NO,OUT_SNO,NAME,REG_DATE,REG_EMP_CODE,REG_EMP_NAME,REG_NO,DEPT_CODE,DEPT_NAME,DOCTOR_CODE,DOCTOR_NAME,PAYMENT_WAY_CD,PAYMENT_WAY_CS,PAYMENT_WAY_CSN,PAYMENT_WAY_CSV,PAYMENT_WAY_DN,CLIN_COST_PAY_CD,CLIN_COST_PAY_CS,CLIN_COST_PAY_CSN,CLIN_COST_PAY_CSV,CLIN_COST_PAY_DN,EMERGENCY_MARK,EMERGENCY_MARK_CS,EMERGENCY_MARK_CSN,EMERGENCY_MARK_CSV,EMERGENCY_VALUE,IS_APPOINT_REGISTER,MONEY_REG,REG_ITEM_CODE,MONEY_INDAGATION,INDAGATION_ITEM_CODE,ANAMN_MANU_FEE,ANAMN_MANU_ITEM_CODE,IS_AMBULANCE,CANCEL_FLAG,ORG_NAME,RESERVE1,RESERVE2,RELATION_PK,UPLOAD_ORG_CODE,SEND_TIME,SEND_SYSTEM,PROVIDER_NAME,PROVIDER_ORG_CODE,CREATETIME,LASTUPTIME,SEND_ORG_CODE,STATE") [ SqlProc, SqlViewName = TM_OUT_REG ]
{
}

ClassMethod QueryAdmRegInfoExecute(ByRef qHandle As %Binary, SatarRegDate As %String, EndRegDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s:SatarRegDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(SatarRegDate)
    s:EndRegDate'="" EndRegDate=##class(websys.Conversions).DateHtmlToLogical(EndRegDate)
    s:SatarRegDate="" SatarRegDate=+$h
    s:EndRegDate="" EndRegDate=+$h
    for OneDate=SatarRegDate:1:EndRegDate{
        s AdmId=0
        for {
            s AdmId=$o(^PAADMi("PAADM_AdmDate",OneDate,AdmId))
            q:AdmId=""
            s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmId,0))
            continue:RegfeeRowId=""
            ;1	ID	标识	varchar(40)	否	复合主键：业务ID;一般要保证该字段的值不能重复
            s ID=AdmId
            ;2	PERSON_ID	人员ID	varchar(40)	否	人员ID
            s PERSONID=$p($g(^PAADM(AdmId)),"^",1)
            ;3	OUT_NO	门诊号	varchar(40)	否	门急诊诊疗对象的门诊号:不存在，填写N/A+医疗服务编号
            s OUTNO=AdmId
            ;4	OUT_SNO	门诊流水号	varchar(40)	否	唯一标识一次门诊
            s OUTSNO=AdmId
            ;5	NAME	患者姓名	varchar(40)	否	患者姓名
            s NAME=$p(^PAPER(PERSONID,"ALL"),"^",1)
            ;6	REG_DATE	挂号时间	datetime	否	挂号时间
            s REGDATE=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",6))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^PAADM(AdmId)),"^",7))
            ;7	REG_EMP_CODE	挂号操作员代码	varchar(40)		挂号操作员代码
            s CreateUserDr=$p($g(^PAADM(AdmId)),"^",43)
            s REGEMPCODE=$p($g(^SSU("SSUSR",CreateUserDr)),"^")
            ;8	REG_EMP_NAME	挂号操作员姓名	varchar(40)		挂号操作员姓名
            s REGEMPNAME=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
            ;9	REG_NO	挂号收据号	varchar(40)		挂号收据号，填挂号单上的收据号（发票号）
            s REGNO=""
            s:RegfeeRowId'="" REGNO=$List(^User.DHCRegistrationFeeD(RegfeeRowId),11)
            ;10	DEPT_CODE	挂号科室-编码	varchar(40)		挂号科室代码
            s DeptCodeDR=$p($g(^PAADM(AdmId)),"^",4)
            s DEPTCODE=$p($g(^CTLOC(DeptCodeDR)),"^",1)
            ;11	DEPT_NAME	挂号科室-名称	varchar(40)		挂号科室名称
            s DEPTNAME=$p($g(^CTLOC(DeptCodeDR)),"^",2)
            ;12	DOCTOR_CODE	挂号医生-编码	varchar(40)		挂号医生代码
            s AdmDocCodeDR=$p($g(^PAADM(AdmId)),"^",9)
            s DOCTORCODE=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",1)
            ;13	DOCTOR_NAME	挂号医生-姓名	varchar(40)		挂号医生姓名
            s DOCTORNAME=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
            ;14	PAYMENT_WAY_CD	挂号付款方式代码	varchar(4)		挂号付款方式代码；取值：医疗费用来源类别代码表CV0710003中的值
            s PAYMENTWAYCD=""
            ;15	PAYMENT_WAY_CS	门诊付费方式代码的字典代码	varchar(20)		门诊付费方式代码的字典代码；默认为CV0710003
            s PAYMENTWAYCS=""
            ;16	PAYMENT_WAY_CSN	门诊付费方式代码的字典名称	varchar(100)		医疗费用来源类别代码表:门诊付费方式代码的字典名称；默认为医疗费用来源类别代码表
            s PAYMENTWAYCSN=""
            ;17	PAYMENT_WAY_CSV	门诊付费方式代码的字典版本	varchar(20)		门诊付费方式代码的字典版本；默认为第一版为V1，如更新字典表则填写V2
            s PAYMENTWAYCSV=""
            ;18	PAYMENT_WAY_DN	门诊付费方式代码的值	varchar(100)		门诊付费方式代码的值；取值：医疗费用来源类别代码表中对应的值
            s PAYMENTWAYDN=""
            ;19	CLIN_COST_PAY_CD	医疗保险类别代码	varchar(4)		取值：医疗保险类别代码表CV0201204中的值
            s CLINCOSTPAYCD=""
            ;20	CLIN_COST_PAY_CS	医疗保险类别代码的字典代码	varchar(20)		CV0201204:默认为CV0201204'
            s CLINCOSTPAYCS=""
            ;21	CLIN_COST_PAY_CSN	医疗保险类别代码的字典名称	varchar(100)		医疗保险类别代码表:默认为医疗保险类别代码表
            s CLINCOSTPAYCSN=""
            ;22	CLIN_COST_PAY_CSV	医疗保险类别代码的字典版本	varchar(20)		V1:默认为第一版为V1。如更新字典表则填写V2
            s CLINCOSTPAYCSV=""
            ;23	CLIN_COST_PAY_DN	医疗保险类别代码的值	varchar(100)		取值：医疗保险类别代码表中对应的值
            s CLINCOSTPAYDN=""
            ;24	EMERGENCY_MARK	门急诊标志	varchar(2)		门急诊标志:0 为门诊，1为急诊	（暂无字典）
            s EMERGENCYMARK=""
            ;25	EMERGENCY_MARK_CS	门急诊标志的字典代码	varchar(20)		门急诊标志的字典代码
            s EMERGENCYMARKCS=""
            ;26	EMERGENCY_MARK_CSN	门急诊标志的字典名称	varchar(100)		门急诊标志的字典名称
            s EMERGENCYMARKCSN=""
            ;27	EMERGENCYMARKCSV	门急诊标志的字典版本	varchar(20)		V1:门急诊标志的字典版本
            s EMERGENCYMARKCSV=""
            ;28	EMERGENCY_VALUE	门急诊标志的值	varchar(20)		门急诊标志的值
            s EMERGENCYVALUE=""
            ;29	IS_APPOINT_REGISTER	是否预约挂号	varchar(40)		0:否（默认），1:是
            s ISAPPOINTREGISTER=""
            ;30	MONEY_REG	挂号费	decimal(8,2)	否	单位：元
            s RegFeeStr=..GetRegFeeInfo($List(^User.DHCRegistrationFeeD(RegfeeRowId),11))
            s MONEYREG=$p(RegFeeStr,"^")
            ;31	REG_ITEM_CODE	挂号费项目编码	varchar(40)		
            s REGITEMCODE=""
            ;32	MONEY_INDAGATION	诊金费	decimal(8,2)	否	单位：元
            s MONEYINDAGATION=$p(RegFeeStr,"^",3)
            ;33	INDAGATION_ITEM_CODE	诊金费项目编码	varchar(40)		
            s INDAGATIONITEMCODE=""
            ;34	ANAMN_MANU_FEE	病历手册费	decimal(8,2)		单位：元
            s ANAMNMANUFEE=""
            ;35	ANAMN_MANU_ITEM_CODE	病历手册费项目编码	varchar(40)		
            s ANAMNMANUITEMCODE=""
            ;36	IS_AMBULANCE	是否救护车送入	varchar(2)	否	0:否（默认），1:是
            s ISAMBULANCE="0"
            ;37	CANCELFLAG		varchar(2)	否	该表只接受新增，默认“0”
            s CANCELFLAG="0"
            ;38	ORG_NAME	医疗机构名称	varchar(100)		
            s ORGNAME=""
            ;39	RESERVE1	预留一	varchar(100)		系统预留，暂不报送；
            s RESERVE1=""
            ;40	RESERVE2	预留二	varchar(100)		系统预留，暂不报送；
            s RESERVE2=""
            ;41	RELATION_PK	关联主键	varchar(40)		
            s RELATIONPK=""
            ;42	UPLOAD_ORG_CODE	上传机构代码	varchar(70)	否	复合主键：上传机构代码
            s UPLOADORGCODE=""
            ;43	SEND_TIME	上报日期	datetime	否	上报日期
            s SENDTIME=##class(websys.Conversions).DateLogicalToHtml(+$h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
            ;44	SEND_SYSTEM	上报系统	varchar(70)	否	复合主键：上报系统，默认值为sys1
            s SENDSYSTEM="sys1"
            ;45	PROVIDER_NAME	开发商机构名称	varchar(40)		《中华人民共和国组织机构代码证》上的机构名称
            s PROVIDERNAME=""
            ;46	PROVIDER_ORG_CODE	开发商机构代码	varchar(70)		《中华人民共和国组织机构代码证》上的代码
            s PROVIDERORGCODE=""
            ;47	CREATETIME	创建时间	datetime		默认值：当前时间
            s CREATETIME=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",41))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^PAADM(AdmId)),"^",42))
            ;48	LASTUPTIME	最后修改时间	datetime		默认值：当前时间
            s LASTUPTIME=##class(websys.Conversions).DateLogicalToHtml(+$h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
            ;49	SEND_ORG_CODE	上报机构	varchar(70)	否	上报机构
            s SENDORGCODE=""
            ;50	STATE	数据状态	varchar(2)	否	默认值：0表示新增
            s STATE="0"
            d QueryAdmRegInfoOutputRow 
        }
    }



	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryAdmRegInfoOutputRow
	set Data=$lb(ID,PERSONID,OUTNO,OUTSNO,NAME,REGDATE,REGEMPCODE,REGEMPNAME,REGNO,DEPTCODE,DEPTNAME,DOCTORCODE,DOCTORNAME,PAYMENTWAYCD,PAYMENTWAYCS,PAYMENTWAYCSN,PAYMENTWAYCSV,PAYMENTWAYDN,CLINCOSTPAYCD,CLINCOSTPAYCS,CLINCOSTPAYCSN,CLINCOSTPAYCSV,CLINCOSTPAYDN,EMERGENCYMARK,EMERGENCYMARKCS,EMERGENCYMARKCSN,EMERGENCYMARKCSV,EMERGENCYVALUE,ISAPPOINTREGISTER,MONEYREG,REGITEMCODE,MONEYINDAGATION,INDAGATIONITEMCODE,ANAMNMANUFEE,ANAMNMANUITEMCODE,ISAMBULANCE,CANCELFLAG,ORGNAME,RESERVE1,RESERVE2,RELATIONPK,UPLOADORGCODE,SENDTIME,SENDSYSTEM,PROVIDERNAME,PROVIDERORGCODE,CREATETIME,LASTUPTIME,SENDORGCODE,STATE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAdmRegInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmRegInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAdmRegInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmRegInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	;b
	Quit $$$OK
}

ClassMethod GetRegFeeInfo(InvoiceId)
{
	s BillSum=0,ConRowId="",PBRowId=""
    s AppFee=0,RegFee=0,CheckFee=0,OtherFee=0,Total=0
    if (InvoiceId'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceId,0))
    ;打印挂号费和诊疗费(包括附属的其他费用)
    s TotalRMBDX=""
    i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
    if PBRowId'="" {
        s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
        .s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
        .Q:ArcimId=""
        .s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
        .s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
        .i type="App" s AppFee=AppFee+BillSum
        .e  d
        ..;i (type="Reg")!(type="Check") s RegFee=RegFee+BillSum
        ..i (type="Check") s CheckFee=CheckFee+BillSum
        ..i (type="Reg") s RegFee=RegFee+BillSum
        ..e  s OtherFee=OtherFee+BillSum
        s Total=AppFee+RegFee+OtherFee+CheckFee
        //s TotalRMBDX=##class(web.DHCOPAdmReg).RMBDXXZH("","",Total)
    }
    q Total_"^"_RegFee_"^"_CheckFee
}

/// call web_DHCENS_BLL_QCInterface.QueryDocRegInfo_Dataexchangeorg("8")
/// call web_QueryAdmInfoCommon.QueryDocRegInfo_TM_OUT_ADMISSIONS("2019-01-02","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.QueryAdmInfoCommon","QueryDocRegInfo","2019-01-02","2020-01-01")
Query QueryDocRegInfo(SatarRegDate As %String, EndRegDate As %String) As %Query(ROWSPEC = "ID,PERSON_ID,OUT_NO,OUT_SNO,NAME,DEPT_CODE,DEPT_NAME,ADMISSIONS_TIME,DOCT_CODE,DOCT_NAME,NEWLY_MARK,NEWLY_MARK_CS,NEWLY_MARK_CSN,NEWLY_MARK_CSV,NEWLY_VALUE,ID_NO_CD,ID_NO_CS,ID_NO_CSN,ID_NO_CSV,ID_NO_DN,AGENT_NAME,AGENT_NO_DN,AGENT_NO_CD,AGENT_NO_CS,AGENT_NO_CSN,AGENT_NO_CSV,SECRET_LEVEL,CANCEL_FLAG,RESERVE1,RESERVE2,ORG_NAME,RELATION_PK,UPLOAD_ORG_CODE,SEND_TIME,SEND_SYSTEM,PROVIDER_NAME,PROVIDER_ORG_CODE,CREATETIME,LASTUPTIME,SEND_ORG_CODE,STATE") [ SqlProc, SqlViewName = TM_OUT_ADMISSIONS ]
{
}

ClassMethod QueryDocRegInfoExecute(ByRef qHandle As %Binary, SatarRegDate As %String, EndRegDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s:SatarRegDate'="" SatarRegDate=##class(websys.Conversions).DateHtmlToLogical(SatarRegDate)
    s:EndRegDate'="" EndRegDate=##class(websys.Conversions).DateHtmlToLogical(EndRegDate)
    s:SatarRegDate="" SatarRegDate=+$h
    s:EndRegDate="" EndRegDate=+$h
    for OneDate=SatarRegDate:1:EndRegDate{
        s AdmId=0
        for {
            s AdmId=$o(^PAADMi("PAADM_AdmDate",OneDate,AdmId))
            q:AdmId=""
            //s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmId,0))
            //continue:RegfeeRowId=""
            ;1	ID	标识	varchar(40)	否	复合主键：业务ID;一般要保证该字段的值不能重复
            s ID=AdmId
            ;2	PERSON_ID	人员ID	varchar(40)	否	人员ID
            s PERSONID=$p($g(^PAADM(AdmId)),"^",1)
            ;3	OUT_NO	门诊号	varchar(40)	否	门急诊诊疗对象的门诊号:不存在，填写N/A+医疗服务编号
            s OUTNO=AdmId
            ;4	OUT_SNO	门诊流水号	varchar(40)	否	唯一标识一次门诊
            s OUTSNO=AdmId
            ;5	NAME	患者姓名	varchar(40)	否	患者姓名
            s NAME=$p(^PAPER(PERSONID,"ALL"),"^",1)
            ;6	DEPT_CODE	接诊科室代码	varchar(40)	否	接诊科室代码
            s DeptCodeDR=$p($g(^PAADM(AdmId)),"^",4)
            s DEPTCODE=$p($g(^CTLOC(DeptCodeDR)),"^",1)
            ;7	DEPT_NAME	就诊科室名称	varchar(40)		就诊科室名称
            s DEPTNAME=$p($g(^CTLOC(DeptCodeDR)),"^",2)
            ;8	ADMISSIONS_TIME	接诊时间	datetime		
            s ADMISSIONSTIME=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",6))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^PAADM(AdmId)),"^",7))
            ;9	DOCT_CODE	接诊医生代码	varchar(40)		接诊医生代码
             s AdmDocCodeDR=$p($g(^PAADM(AdmId)),"^",9)
            s DOCTCODE=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",1)
            ;10	DOCT_NAME	接诊医生姓名	varchar(40)		接诊医生姓名
            s DOCTNAME=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
            ;11	NEWLY_MARK	初诊复诊标志	varchar(2)	否	初诊复诊标志；取值：标志是否代码表CV9900014中的值字典码1：码值是，代表初诊；字典码 0 ：码值否，代表复诊
            s FirstOrReadmis=$p($g(^PAADM(AdmId)),"^",72)  ; F:初诊   R: 出院复诊
            s NEWLYMARK=$case(FirstOrReadmis,"R":"0",:"1")
            ;12	NEWLY_MARK_CS	初诊复诊标志的字典代码	varchar(20)	否	CV9900014:初诊复诊标志的字典代码;取值：默认为CV9900014     字典码1：码值是，代表初诊；字典码 0 ：码值否，代表复诊
            s NEWLYMARKCS=$case(FirstOrReadmis,"R":"0",:"1")
            ;13	NEWLY_MARK_CSN	初诊复诊标志的字典名称	varchar(100)	否	标志是否代码表:初诊复诊标志的字典名称；取值：默认为标志是否代码表字典码1：码值是，代表初诊；字典码 0 ：码值否，代表复诊
            s NEWLYMARKCSN=$case(FirstOrReadmis,"R":"0",:"1")
            ;14	NEWLY_MARK_CSV	初诊复诊标志的字典版本	varchar(20)		V1:初诊复诊标志的字典版本；取值；默认为第一版为V1，如更新字典表则填写V2
            s NEWLYMARKCSV=""
            ;15	NEWLY_VALUE	初诊复诊标志的值	varchar(20)		初诊复诊标志的值
            s NEWLYVALUE=$case(FirstOrReadmis,"R":"0",:"1")
            ;16	ID_NO_CD	身份证件类别代码	varchar(4)		身份证件类别代码；取值：身份证件类别代码表 CV0201101中的值
            s IDNOCD=""
            ;17	ID_NO_CS	身份证件类别代码的字典代码	varchar(20)		CV0201101:取值：默认为CV0201101
            s IDNOCS=""
            ;18	ID_NO_CSN	身份证件类别代码的字典名称	varchar(100)		身份证件类别代码表:取值：默认为身份证件类别代码表
            s IDNOCSN=""
            ;19	ID_NO_CSV	身份证件类别代码的字典版本	varchar(20)	否	V1:字典表的版本控制；取值：默认为第一版为V1，如更新字典表则填写V2
            s IDNOCSV=""
            ;20	ID_NO_DN	身份证件类别代码的值	varchar(100)		取值：身份证类别代码表中对应的值
            s IDNODN=""
            ;21	AGENT_NAME	代办人姓名	varchar(20)		代办人姓名；说明：特定环境下代办人身份标识（证明文件）如：门诊门诊精麻处方
            s AGENTNAME=""
            ;22	AGENT_NO_DN	代办人身份证类别代码表中对应的值	varchar(100)		取值：身份证类别代码表中对应的值
            s AGENTNODN=""
            ;23	AGENT_NO_CD	代办人身份证件类别代码	varchar(4)		身份证件类别代码；取值：身份证件类别代码表 CV0201101中的值
            s AGENTNOCD=""
            ;24	AGENT_NO_CS	代办人身份证件类别代码的字典代码	varchar(20)		'CV0201101:取值：默认为CV0201101'
            s AGENTNOCS=""
            ;25	AGENT_NO_CSN	代办人身份证件类别代码的字典名称	varchar(100)		身份证件类别代码表:取值：默认为身份证件类别代码表
            s AGENTNOCSN=""
            ;26	AGENT_NO_CSV	代办人身份证件类别代码的字典版本	varchar(20)		V1:字典表的版本控制；取值：默认为第一版为V1，如更新字典表则填写V2
            s AGENTNOCSV=""
            ;27	SECRET_LEVEL	密级的填报说明	varchar(20)		密级的填报说明：第一位用于填写对于病种的权限控制参数。其中0：无须病种控制；1：恶性肿瘤；2：性病艾滋病；3：其它不治之症；4
            s SECRETLEVEL=""
            ;28	CANCEL_FLAG	varchar(2)	varchar(2)		该表只接受新增，默认“0”
            s CANCELFLAG=""
            ;29	RESERVE1	预留一	varchar(100)		系统预留，暂不报送
            s RESERVE1=""
            ;30	RESERVE2	预留二	varchar(100)		系统预留，暂不报送
            s RESERVE2=""
            ;31	ORG_NAME	医疗机构名称	varchar(100)		医疗机构名称
            s ORGNAME=""
            ;32	RELATION_PK	关联主键	varchar(40)		关联主键用于当此表更新时，记录原始数据的主键
            s RELATIONPK=""
            ;33	UPLOAD_ORG_CODE	上传机构代码	varchar(70)		复合主键：上传机构代码
            s UPLOADORGCODE=""
            ;34	SEND_TIME	上报日期	datetime		上报日期
            s SENDTIME=##class(websys.Conversions).DateLogicalToHtml(+$h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
            ;35	SEND_SYSTEM	上报系统	varchar(70)		复合主键：上报系统，默认值为sys1
            s SENDSYSTEM=""
            ;36	PROVIDER_NAME	开发商机构名称	varchar(40)		《中华人民共和国组织机构代码证》上的机构名称
            s PROVIDERNAME=""
            ;37	PROVIDER_ORG_CODE	开发商机构代码	varchar(70)		《中华人民共和国组织机构代码证》上的代码
            s PROVIDERORGCODE=""
            ;38	CREATETIME	创建时间	datetime		默认值：当前时间
            s CREATETIME=##class(websys.Conversions).DateLogicalToHtml($p($g(^PAADM(AdmId)),"^",41))_" "_##class(websys.Conversions).TimeLogicalToHtml($p($g(^PAADM(AdmId)),"^",42))
            ;39	LASTUPTIME	最后修改时间	datetime		默认值：当前时间
            s LASTUPTIME=##class(websys.Conversions).DateLogicalToHtml(+$h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
            ;40	SEND_ORG_CODE	上报机构	varchar(70)		上报机构
            s SENDORGCODE=""
            ;41	STATE	数据状态	varchar(2)		默认值：0表示新增
            s STATE="0"
            d QueryDocRegInfoOutputRow 
        }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryDocRegInfoOutputRow
	set Data=$lb(ID,PERSONID,OUTNO,OUTSNO,NAME,DEPTCODE,DEPTNAME,ADMISSIONSTIME,DOCTCODE,DOCTNAME,NEWLYMARK,NEWLYMARKCS,NEWLYMARKCSN,NEWLYMARKCSV,NEWLYVALUE,IDNOCD,IDNOCS,IDNOCSN,IDNOCSV,IDNODN,AGENTNAME,AGENTNODN,AGENTNOCD,AGENTNOCS,AGENTNOCSN,AGENTNOCSV,SECRETLEVEL,CANCELFLAG,RESERVE1,RESERVE2,ORGNAME,RELATIONPK,UPLOADORGCODE,SENDTIME,SENDSYSTEM,PROVIDERNAME,PROVIDERORGCODE,CREATETIME,LASTUPTIME,SENDORGCODE,STATE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDocRegInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocRegInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDocRegInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocRegInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	;b
	Quit $$$OK
}

}
