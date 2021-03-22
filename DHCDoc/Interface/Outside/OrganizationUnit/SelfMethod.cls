Class DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod Extends %RegisteredObject
{

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.responseCode=ResultCode
	
	if ($d(^oddCOM(object.%ClassName(1),"a","ResultContent"))){
		s object.ResultContent=ResultContent
	}elseif ($d(^oddCOM(object.%ClassName(1),"a","respongseText"))){
		s object.respongseText=ResultContent
	}
}

/// 获取时间戳
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
ClassMethod getTimestamp()
{
	s startdate=$zdh("1970-01-01",3)
	s starttime=0
	s Timestamp=((+$H-startdate)*24-8)*60*60+$p($h,",",2)
	Q Timestamp
}

ClassMethod DateConvertHis(date)
{
	if $l(date,"-")=3{
		s date=$zdh(date,3)	
	}elseif $l(date,"/")=3{
		s date=$zdh(date,4)	
	}else{
		s date="-1"	
	}
	Q date
}

/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).GetPatCard()
ClassMethod GetPatCard(patientIdTypeId, patientId)
{
	;s patientIdTypeId=obj.patientIdTypeId ;患者 Id 类型（1、2、 4 和 5 预留，暂不使用，3 身份证号,6 电子健康卡,7 HIS系统ID）
	;s patientId=obj.patientId ;患者 Id
	s (CardType,CardNo,PatientID)=""
	if patientIdTypeId=7{
		s PatientID=patientId
	}else{
		s CardType=$g(^DHCRegInterfaceCodeRelate("CardType","UMToHis",patientIdTypeId))
		s CardNo=patientId
		
	}
	
	Q PatientID_"^"_CardType_"^"_CardNo
}

ClassMethod GetOutCardType(CardType)
{
	s CardTypeCode=$p(^DHCCARDTYPEDef(CardType),"^",1)
	s CardType=$g(^DHCRegInterfaceCodeRelate("CardType","HisToUM",CardTypeCode))
	Q CardType
}

ClassMethod GetSexByOut(SexCode)
{
	s SexCode=$g(^DHCRegInterfaceCodeRelate("SEX","UMToHis",SexCode))
	Q SexCode
}

ClassMethod GetDefPatType()
{
	s DefPatType="01"
	Q DefPatType
}

/// d ##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).SetGlobal()
ClassMethod SetGlobal()
{
	;患者性别（1 未知、 2 其它、 3女、 4 男）
	;UM->HIS
	s ^DHCRegInterfaceCodeRelate("SEX","UMToHis",4)=1
	s ^DHCRegInterfaceCodeRelate("SEX","UMToHis",3)=2
	s ^DHCRegInterfaceCodeRelate("SEX","UMToHis",1)=0
	s ^DHCRegInterfaceCodeRelate("SEX","UMToHis",2)=9
	
	;患者 Id 类型（1、2、 4 和 5 预留，暂不使用， 3 身份证号,6 电子健康卡， 7 HIS 系统ID）
	;UM->HIS
	s ^DHCRegInterfaceCodeRelate("CardType","UMToHis",6)="02"
	s ^DHCRegInterfaceCodeRelate("CardType","UMToHis",3)="05"
	;HIS->UM
	s ^DHCRegInterfaceCodeRelate("CardType","HisToUM",16)=6
	s ^DHCRegInterfaceCodeRelate("CardType","HisToUM",26)=3
}

}
