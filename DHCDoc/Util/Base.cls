/// creator:郭荣勇
/// date:2016-2-3
/// desc:医生站基础工具类(方法与具体业务无关),web.DHCDocCommon中的方法都移植到这里
Class DHCDoc.Util.Base Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2017-7-13
/// desc:身份证号15位转18位
/// input:IDCardNo15 15位身份证号码
/// output:18位身份证号码
ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// creator:郭荣勇
/// date:2017-7-13
/// desc:身份证号18位转15位
/// input:IDCardNo18 18位身份证号码
/// output:15位身份证号码
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}

/// creator:郭荣勇
/// date:2015-11-18
/// desc:通过年龄描述得到出生日期
/// input:Age 年龄描述, Type 类型:默认为空,为空即如果只有"岁"则计算的月和日和当前的月和日相同
/// output:年龄描述(eg:1岁 或 2月 或 3天)
/// other:
/// debug:w ##class(DHCDoc.Util.Base).GetBirthDateByAge("1","")
ClassMethod GetBirthDateByAge(Age As %String, Type As %String = "") As %String
{
	n (Age,Type)
	s BirthDate=""
	q:Age="" ""
	;兼容只填了数字,没有单位的情况
	i +Age=Age s Age=+Age_"岁"
	
	s CurDate=$zd($h,3)
	s CurYear=$P(CurDate,"-",1)
	s CurMonth=$P(CurDate,"-",2)
	s CurDay=$P(CurDate,"-",3)
	s Year="",Month="",Day=""
	i Age["岁" {
		s Year=$p(Age,"岁",1)
		s Year=CurYear-Year
	}
	i Age["月" {
		i Year="" {
			s Month=$p(Age,"月",1)
			s Year=CurYear
		}else{
			s Month=$p($p(Age,"岁",2),"月",1)
		}
		s Month=CurMonth-Month
		i Month<=0{
			s Year=Year-1
			s Month=Month+12
		}
	}
	i Age["天" {
		i Month="" {
			s Day=$p(Age,"天",1) 
			s Month=CurMonth
			i Year="" s Year=CurYear
		}else{
			s Day=$p($p(Age,"月",2),"天",1)
		}
		s Day=CurDay-Day
		i Day<=0{
			s Month=Month-1
			i Month=0{
				s Year=Year-1
				s Month=12
				s Day=Day+31
			}else{
				s Day=Day+($zd($zdh(Year_"-"_(Month+1)_"-01",3),14)-$zd($zdh(Year_"-"_Month_"-01",3),14)-1)
			}
		}
	}
	
	
	i Type="" {
		i Year="" s Year=CurYear
		i Year'="",Month="" s Month=CurMonth
		i Month'="",Day="" s Day=CurDay
		i $l(Month)=1 s Month="0"_Month
		i $l(Day)=1  s Day="0"_Day
		s BirthDate=Year_"-"_Month_"-"_Day
	}
	
	
	Q BirthDate
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:得到年龄描述
/// input:PatientNo 登记号
/// output:年龄描述(eg:1年 或 2月 或 3天)
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).GetAgeDesc("2010-04-01","")
ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	Q ##class(web.DHCDTHealthCommon).GetAgeDesc(DOB,CalDate)
	
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到病人年龄
/// Table;        PA_Person
/// Input:        PatientID 病人Rowid
/// Return:       病人年龄 数字类型
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetPatAge(1)
ClassMethod GetPatAge(PatientID As %String) As %String
{
	n (PatientID)
	s myAge=""
	s:PatientID'="" myAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
	Q myAge
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到登记号对应的所有卡,通过类型控制,是否显示最后一次或者全部(以,分开)
/// Table;        DHC_CardRef
/// Input:        Type:显示类型(最后一次:LAST,全部:ALL),PatientNO:登记号,PatientID:病人rowid,EpisodeID:就诊rowid
/// Return:       卡号||全部卡号及类型||""
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetCardNoByPAPER("LAST","00000629")
ClassMethod GetCardNoByPAPER(Type As %String, PatientNO As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	////n (Type,PatientNO,PatientID,EpisodeID)
	s myCardNo=""
	
	if PatientID'="" {
		s PAPMIRowid=PatientID
	}elseif PatientNO'="" {
		s PAPMIRowid=$O(^PAPERi("PAPMI_PatNo",PatientNO,0))
	}elseif EpisodeID'="" {
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	}
	Q:Type="" myCardNo
	Q:PAPMIRowid="" myCardNo
	s CFRowid=""
	for {
		s CFRowid=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowid,CFRowid),-1)
		Q:CFRowid=""
		s ActiveFlag=$p($g(^DHCCARD("CF",CFRowid)),"^",10)
		if ActiveFlag'="N" continue
		s CardType=""
		s CardTypeDr=$p($g(^DHCCARD("CF",CFRowid)),"^",16)
		i CardTypeDr'="" s CardType=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
		if CFRowid'="" {
			s CardNo=$p($g(^DHCCARD("CF",CFRowid)),"^",2)
			if $ZCVT(Type,"U")="LAST" {
				s myCardNo=CardNo 
				quit
			}elseif ($ZCVT(Type,"U")="ALL")  {
				if myCardNo="" s myCardNo=CardType_":"_CardNo
				else  s myCardNo=myCardNo_","_CardType_":"_CardNo
			}
		}
	}
	
	Q myCardNo
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:格式化登记号
/// input:PatientNo 登记号
/// output:格式化后的登记号
/// other:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// debug:w ##class(web.DHCDTHealthCommon).FormatPatientNo("12")
ClassMethod FormatPatientNo(PatientNo As %String) As %String
{
	n (PatientNo)
	s PatientNoRet=""
	Q:$Number(PatientNo)="" ""
	s PatientNoLen=+..GetPatientNoLen()
	
	if $l(PatientNo)>PatientNoLen {
		s PatientNoRet=$e(PatientNo,1,PatientNoLen)
	}else{
		s PatientNoRet=$e("0000000000000000000",1,PatientNoLen-$l(PatientNo))_PatientNo
	}
	
	Q PatientNoRet
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:得到登记号系统设置长度
/// input:
/// output:登记号系统设置长度
/// other:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// debug:w ##class(web.DHCDTHealthCommon).GetPatientNoLen()
ClassMethod GetPatientNoLen() As %String
{
	s PatientNoLen=+$p(^CF("PATCF",1,3),"^",5)
	
	Q PatientNoLen
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到卡号根据登记号和卡类型
/// Table;        DHC_CardRef
/// Input:        CardTypeRowid:卡类型rowid,PatientNO:登记号,PatientID:病人rowid,EpisodeID:就诊rowid
/// Return:       卡号||""
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetCardNo(1,"0000000001")
ClassMethod GetCardNo(CardTypeRowid As %String, PatientNO As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	n (CardTypeRowid,PatientNO,PatientID,EpisodeID)
	s myCardNo=""
	
	if PatientID'="" {
		s PAPMIRowid=PatientID
	}elseif PatientNO'="" {
		s PAPMIRowid=$O(^PAPERi("PAPMI_PatNo",PatientNO,0))
	}elseif EpisodeID'="" {
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	}
	Q:CardTypeRowid="" myCardNo
	Q:PAPMIRowid="" myCardNo
	s CFRowid=0
	s CFRowid=$O(^DHCCARDi("CF",0,"TypePAPMINO",CardTypeRowid,PAPMIRowid,CFRowid))
	if CFRowid'="" {
		s myCardNo=$p($g(^DHCCARD("CF",CFRowid)),"^",2)
	}
	
	Q myCardNo
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到web配置的模板路径
/// Table;        websys.configuration
/// Input:        SEXRowid:性别rowid
/// Return:       web配置的模板路径
/// Others:
/// Debug:		w ##class(DHCDoc.Util.Base).GetPath()
ClassMethod GetPath()
{
	n (Path)
	Set Path=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
	if $IsObject(Config) {
		Set Path=Config.PathToReports
		d Config.%Close()
	}

	Q Path
}

///  Creator:      郭荣勇
///  CreatDate:    2015.03.12
///  Description:: 根据科室RowId得到科室所归属的医院
///  Table:        
///  Input:        
///  Return:       
///  Others:
///  Debug:  d ##class(DHCDoc.Util.Base).GetHospIdByLocId(2)
ClassMethod GetHospIdByLocId(LocId As %String) As %String
{
	Q:(LocId="") ""
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	Q HospId
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到代码表下设置的医院代码
/// Table;        CT_Hospital
/// Input:        HospRowid 医院Rowid
/// Return:       代码表下设置的医院代码
/// Others:
/// Debug:		w ##class(DHCDoc.Util.Base).GetCTHospitalStr()
ClassMethod GetCTHospitalStr() As %String
{
	s CTHospitalStr=""
	s HospRowid=0
	for {
		s HospRowid=$O(^CT("HOSP",HospRowid)) Q:HospRowid=""
		s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
		s HospitalDesc=$p($g(^CT("HOSP",HospRowid)),"^",2)
		i CTHospitalStr="" s CTHospitalStr=HospRowid_"^"_HospitalCode_"^"_HospitalDesc
		e  s CTHospitalStr=CTHospitalStr_$C(1)_HospRowid_"^"_HospitalCode_"^"_HospitalDesc
	}
	

	Q $g(CTHospitalStr)
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到代码表下设置的医院代码
/// Table;        CT_Hospital
/// Input:        HospRowid 医院Rowid
/// Return:       代码表下设置的医院代码
/// Others:
/// Debug:		w ##class(DHCDoc.Util.Base).GetCTHospitalCode(1)
ClassMethod GetCTHospitalCode(HospRowid As %String = "") As %String
{
	s HospitalCode=""
	if (HospRowid'=""){
		s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
	}else{
		s HospRowid=$O(^CT("HOSP",0))
		i HospRowid'="" s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
	}

	Q $g(HospitalCode)
}

/// Creator:      周志强
/// CreatDate:    2009.03.20
/// Description:: 得到医生站设置里当前医院的代码
/// Table:        
/// Input:        
/// Return:       医生站设置医院的代码
/// Others:
ClassMethod GetDocHospitalCode() As %String
{
	s HospitalCode=""
	s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
	i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
	Q HospitalCode
}

///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 通过就诊得到医嘱主表Rowid
///  Table:        PA_Adm,OE_Order
///  Input:        
///  Return:       医嘱主表Rowid
///  Others:
///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 通过用户Rowid得到对应医生Rowid
///  Table:        SS_User,CT_CareProv
///  Input:        
///  Return:       医生Rowid
///  Others:
///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 设置时间日志
///  Table:        
///  Input:        
///  Return:       
///  Others:
///  Debug:  d ##class(DHCDoc.Util.Base).SetTimeLog("大通保存时间","1")
ClassMethod SetTimeLog(Flag As %String, UniqueID As %String) As %String
{
	Q:(Flag="")||(UniqueID="") 0
	s ^DHCDocTimeLog(Flag,UniqueID)=$zd(+$H,3)_"	"_$zt($p($h,",",2),1)
	s ^DHCDocTimeLog(Flag,0,+$H,UniqueID)=""
	
	Q 0
}

/// Creator:      周志强
/// CreatDate:    2012.12.29
/// Description:: 判断是否为实习医生
/// Table;        CT_CareProv
/// Input:        UserID :用户指针
/// Return:       1:是   0:否
/// Others:
/// Debug:		  w ##class(DHCDoc.Util.Base).IsPracticeDoctor(3907)
ClassMethod IsPracticeDoctor(UserID As %String = "") As %String
{
	s CTPCPRowId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	s CarPrvTypeCode=""
	i CTPCPRowId'="" {
		s CarPrvTypeRowId=$P($g(^CTPCP(CTPCPRowId,1)),"^",4)
		s CarPrvTypeCode=$P($g(^CT("CPT",CarPrvTypeRowId)),"^",1)
	}
	i CarPrvTypeCode="PRACTICE" Quit 1
	Q 0
}

/// 获取科室描述/Code
ClassMethod GetCTLOCDesc(CTLOCID As %String) As %String
{
	s CTLOCCode=""
	s CTLOCDesc=""
	i CTLOCID'=""  d
	.s CTLOCCode=$P(^CTLOC(CTLOCID),"^",1)
	.s CTLOCDesc=$P(^CTLOC(CTLOCID),"^",2)
	Q CTLOCDesc_"^"_CTLOCCode
}

/// creater lxz
/// 获取年龄调用计费组方法
/// s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm)
/// 如果建卡之前获取没有患者索引使用出生日期和日期来计算
/// 入参YYYY-MM-DD
/// w ##class(DHCDoc.Util.Base).GetAgeDescNew("2014-01-04","")
ClassMethod GetAgeDescNew(DOB As %String, CalDate As %String) As %String
{
	s $ZT="ErrorDate"
	s DOBTest=$ZDH(DOB,3)
	s:CalDate'="" CalDateTest=$ZDH(CalDate,3)
	s:CalDate="" CalDate=$ZD(+$H,3)
	s AgeStr=##class(web.UDHCJFCOMMON).DispPatAge(DOB,CalDate,"","")
	s Age=$P(AgeStr,"||",1)
	q Age
ErrorDate
	q ""
}

/// creater scl
/// 根据表名、记录id，查询条件判断条件是否在别名列表里
/// 入参：表名 查询条件
/// 出参 1 在 0不在
/// w ##class(DHCDoc.Util.Base).CheckAliasByTableName("SS_User","1","DM")
ClassMethod CheckAliasByTableName(TableName As %String, paraId As %String, paraDesc As %String) As %String
{
	s AliasExistFlag=0
	Q:(TableName="")||(paraDesc="") 1
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s SubID=0  
	f  s SubID=$O(^User.BDPAliasI("DataRef",TableName,paraId,SubID)) Q:(SubID="")||(AliasExistFlag=1)  d
	.i $D(^User.BDPAliasD(SubID)) d
	..s SubCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	..i SubCode[paraDesc  d
	...s AliasExistFlag=1
	Q AliasExistFlag
}

/// creater scl
/// 根据表名、记录id，查询条件判断条件
/// 入参：表名 查询条件
/// 出参 1 在 0不在
/// w ##class(DHCDoc.Util.Base).CheckUserName("SS_User","1","DM")
ClassMethod CheckUserName(TableName As %String, paraId As %String, paraDesc As %String) As %String
{
	Q:paraDesc="" 1
	s AliasExistFlag=0
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s UserCode=$p(^SSU("SSUSR",paraId),"^",1)
	i ($$ALPHAUP^SSUTIL4(UserCode))[paraDesc  q 1
	s Username=$p(^SSU("SSUSR",paraId),"^",2)
	i ($$ALPHAUP^SSUTIL4(Username))[paraDesc  s AliasExistFlag=1
	Q:AliasExistFlag="1" AliasExistFlag
	s careRowId=$p(^SSU("SSUSR",paraId),"^",14)
	if (careRowId'=""){
		s con=$p($g(^CTPCP(careRowId,3)),"^",28)
		i ($$ALPHAUP^SSUTIL4(con))[paraDesc  q 1
	}
	s AliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName(TableName,paraId,paraDesc)
	Q AliasExistFlag
}

ClassMethod CheckCTCareName(TableName As %String, paraId As %String, paraDesc As %String) As %String
{
	Q:paraDesc="" 1
	s AliasExistFlag=0
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s CTPCPDesc=$p(^CTPCP(paraId,1),"^",2)
	s CTPCPOtherName=$p(^CTPCP(paraId,3),"^",28)
	i ($$ALPHAUP^SSUTIL4(CTPCPDesc))[paraDesc  s AliasExistFlag=1
	i ($$ALPHAUP^SSUTIL4(CTPCPOtherName))[paraDesc  s AliasExistFlag=1
	Q:AliasExistFlag="1" AliasExistFlag
	s AliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName(TableName,paraId,paraDesc)
	Q AliasExistFlag
}

/// creater scl
/// 根据表名、记录id，查询别名列表
/// 入参：表名 查询条件
/// 出参 别名1^别名2
/// w ##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Country","1")
ClassMethod GetAliasByTabName(TableName As %String, paraId As %String) As %String
{
	s AliasStr=""
	Q:(TableName="")||(paraId="") ""
	s SubID=0  
	f  s SubID=$O(^User.BDPAliasI("DataRef",TableName,paraId,SubID)) Q:(SubID="")  d
	.i $D(^User.BDPAliasD(SubID)) d
	..s SubCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	..i AliasStr="" s AliasStr=SubCode
	..e  s AliasStr=AliasStr_"^"_SubCode
	Q AliasStr
}

/// 字符转ASCII码,以冒号(:)拼接返回;对应javascript方法:DHCOPAdm.Common.js中DHCC_CharTransAsc
ClassMethod CharTransAsc(Str As %String) As %String
{
	if (Str="") quit ""
	s rtnStr=""
	s len=$l(Str)
	for i=1:1:len {
		s oneStr=$e(Str,i)
		if (rtnStr="") {
			s rtnStr=$A(oneStr)
		}else{
			s rtnStr=rtnStr_":"_$A(oneStr)
		}
	}
	quit rtnStr
}

/// ASCII码转字符,以冒号(:)拼接传入
ClassMethod AscTransChar(AscStr As %String) As %String
{
	if (AscStr="") quit ""
	s rtnStr=""
	for i=1:1:$l(AscStr,":") {
		if (rtnStr="") {
			s rtnStr=$C($p(AscStr,":",i))
		}else{
			s rtnStr=rtnStr_$C($p(AscStr,":",i))
		}
	}
	quit rtnStr
}

}
