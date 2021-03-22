Class DHCDoc.GanSuProvincialPlatform.CardInfoMethod Extends %RegisteredObject
{

/// 根据患者姓名，身份证号查询医院内该患者有效门诊就诊卡号
/// w ##class(DHCDoc.GanSuProvincialPlatform.CardInfoMethod).ODPatientCard("<Request><PatientName>秦海贤</PatientName><IDCard>360822198609284091</IDCard><ParentName></ParentName><ParentIDCard></ParentIDCard><IsChild>0</IsChild><ChildSeq>0</ChildSeq></Request>")
ClassMethod ODPatientCard(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ODPatientCardErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	
	s PatientName=InputObj.PatientName	;患者姓名
	s IDCardNo=InputObj.IDCard	;身份证号(非儿童时填写)
	s ParentName=InputObj.ParentName	;监护人姓名(是儿童时填写)
	s ParentIDCard=InputObj.ParentIDCard	;监护人身份证(是儿童时填写)
	s IsChild=InputObj.IsChild	;是否儿童 0:否 1:是
	s IDType="01" ;默认身份证
	if (UserID=""){
		q $$ODPatientCardErrMag("用户ID为空或His未对照")	
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	//s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType)
	s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule")
	b 
	if (IsChild="0"){
		if ((IDCardNo="")||(PatientName="")){
			q $$ODPatientCardErrMag("查询所需病人信息不全.")
		}
	}else{
		if ((ParentName="")||(PatientName="")||(ParentIDCard="")){
			q $$ODPatientCardErrMag("查询所需病人信息不全.")
		}
	}
	s PatientIDStr=""
	if (IsChild="0"){
		s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,IDCardNo,PatientName,GetPatientIDRule)
		if PatientIDStr="" q $$ODPatientCardErrMag("该身份证号信息在系统中未找到")
	}else{
		Set PatientName=$$ALPHAUP^SSUTIL4(PatientName)
		Quit:'$d(^PAPERi("PAPER_PatName",PatientName)) ""
		Set papmi=""
		For {
			Set papmi=$o(^PAPERi("PAPER_PatName",PatientName,papmi))
			Quit:papmi=""
			s ActiveFlag=$P(^PAPER(papmi,"PAT",1),"^",6)
			continue:ActiveFlag="N"
			//联系人姓名
			s ForeignName=$p($g(^PAPER(papmi,"PER",2)),"^",13)
			continue:PatientName'=ForeignName
			s ForeignCountry=$p($g(^PAPER(papmi,"PER",2)),"^",4)
			continue:ParentIDCard'=ForeignCountry
			if (PatientIDStr=""){
				s PatientIDStr=papmi
			}else{
				s PatientIDStr=PatientIDStr_"^"_papmi
			}
		}
	}
	i '$d(^PAPER(+PatientIDStr,"ALL")) q $$ODPatientCardErrMag("系统中未找到对应信息")
	
	s CFDate="",CFTime=""
	s OutPutObj={}
	s CardInfo=[]
	set PatientIDStrLen=$l(PatientIDStr,"^")
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		s PatientCardID=""
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:PatientCardID=""
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			//Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
			s CFDate=$p(^DHCCARD("CF",PatientCardID),"^",7)
			s CFTime=$p(^DHCCARD("CF",PatientCardID),"^",8)
		}
		s CreateTime=""
		if CFDate'="",CFTime'="" s CreateTime=$zd(CFDate,3)_"  "_$zt(CFTime,1)
		s PatOutObj={}
		//s PatInfoObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		s PatOutObj.CardNO=PatientCard	//就诊卡号
		s PatOutObj.PatientId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)	;患者院内编号
		s PatOutObj.CreateTime=CreateTime	;就诊卡创建时间
		d CardInfo.%Push(PatOutObj)
	}
	
	s OutPutObj.CardList=CardInfo
	s OutPutObj.ResultCode="0"
	s OutPutObj.Msg="执行成功"
	s NodeList("CardList","ChildNode")="CardInfo"
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response",.NodeList)
ODPatientCardErrMag(ErrText="")
	if (ErrText="") s ErrText="查找失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

/// 为门诊无卡患者建立院内患者档案
ClassMethod ODCreatePatient(XMLRequest As %String) As %GlobalCharacterStream
{
	s $ZTRAP="ODCreatePatientErrMag"
	s InputObj=##class(DHCDoc.Util.XMLParse).XMLToObj(XMLRequest)
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	s PatientName=InputObj.Name	;患者姓名
	s Sex=InputObj.Sex	;患者性别1:男 2:女 3:其他
	s Mobile=InputObj.Telphone	;电话号码
	s DOB=InputObj.Birthday	;患者生日
	s IDNo=InputObj.IDCard	;身份证号(非儿童时填写)
	s ParentName=InputObj.ParentName	;监护人姓名(是儿童时填写)
	s ParentIDCard=InputObj.ParentIDCard	;监护人身份证(是儿童时填写)
	s IsChild=InputObj.IsChild	;是否儿童 0:否 1:是
	s QRCode=InputObj.QRCode	;电子健康卡二维码
	s ChildSeq=InputObj.ChildSeq	;第几孩
	s VUId=InputObj.VUId	;电子健康卡号
	s PatientType="01" ;默认自费
	s CardTypeCode="01" ;默认条形码
	s IDType="01" ;默认身份证
	if (UserID="")
	{
		q $$ODCreatePatientErrMag("用户ID不能为空.")
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s UseDataCompare=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UseDataCompare"))
	s BankCode=""
	if UseDataCompare=1{
		s BankCode="HIS"	
	}
	Set CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode,BankCode)
	set IDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType)
	;set PayModeID=##Class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if (PatientName="") q $$ODCreatePatientErrMag("患者姓名不能为空." )
	if (Sex="") q $$ODCreatePatientErrMag("性别不能为空.")
	if (DOB="") q $$ODCreatePatientErrMag("出生日期不能为空.")
	
	if (IsChild="1"){
		if (ParentName="")||(ParentIDCard=""){
			q $$ODCreatePatientErrMag("监护人信息不能为空")
		}
	}else{
		if (IDTypeID="") q $$ODCreatePatientErrMag("证件类型不能为空." )
		if (IDNo="") q $$ODCreatePatientErrMag("证件号不能为空.")
	}		
	s HisCreateCardNoFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"HisCreateCardNo"))
	;自动建一个条形码
	s UsePAPMINoToCardFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UsePAPMINoToCard"))
	s PatientCard=""
	if (UsePAPMINoToCardFlag=0){
		if (CardTypeID="") q $$ODCreatePatientErrMag("卡类型不能为空.")
		//if PatientCard=""{
			if (HisCreateCardNoFlag="1")    /// HIS生成就诊卡卡号
			{
				set PatientCard=##Class(DHCExternalService.CardInterface.GetRelate).CreateCardNo(CardTypeID)
			}
		//}
		if (PatientCard="")  q $$ODCreatePatientErrMag("卡号不能为空")
		s Status=##class(DHCExternalService.CardInterface.CardManager).CardHadCreate(CardTypeID,PatientCard)
		if $piece(Status,"^",1)'=""{
			set PatientID=$piece(Status,"^",2)
			s StatusDesc=##class(DHCExternalService.CardInterface.CardManager).GetCardStatusDesc($piece(Status,"^",1))
			if ($piece(Status,"^",1)="N") q $$ODCreatePatientErrMag("此卡号已建卡.")
		}
	}else{
		;条形码卡类型RowID?
		s CardTypeID=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","BarCardType"))
		if CardTypeID=0{
			q $$ODCreatePatientErrMag("请联系管理员配置条形码卡类型")
		}else{
			s CardTypeCode=$P(^DHCCARDTYPEDef(CardTypeID),"^",1)
		}
	}
	set CardFareType=$P(^DHCCARDTYPEDef(CardTypeID),"^",3)
	Set CardFareCost=+$P(^DHCCARDTYPEDef(CardTypeID),"^",6)
	s CardDepositAmt=""
	if (CardFareType="C")&&(CardDepositAmt'=CardFareCost)
	{
		q $$ODCreatePatientErrMag("卡金额错误")
	}
	s PayModeID=""
	if (CardFareType="C")&&(PayModeID="")
	{
		q $$ODCreatePatientErrMag("支付方式为空")
	}
	//set mySecurityNo=SecurityNo

	set mySecurityFlag=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^", 18)		;CTD_SecurityNoFlag
	if (mySecurityFlag="Y")
	{
		set mySecurityNo=##Class(web.UDHCAccCardManage).GetCardCheckNo("")
	}
	;b ;check
	s OutPutObj={}
	s PatientIDs=##class(DHCExternalService.CardInterface.CardManager).CheckInfoByIDCard(IDTypeID,IDNo,CardTypeID,PatientName)
	s IDTotal=0
	s Flag=$P(PatientIDs,"^",1)
	s IDTotal=$P(PatientIDs,"^",3)
	if (Flag=1)||((Flag=-1)){
		s Status=$P(PatientIDs,"^",2)
		s StatusDesc=##class(DHCExternalService.CardInterface.CardManager).GetCardStatusDesc(Status)
		
		s myPatientID=+$P(PatientIDs,"^",4)
		s PatientCardID=""
		for {
			s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			q:PatientCardID=""
			s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			Continue:(CardTypeID'="")&(CardTypeID'=CFCardTypeDR)
			s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
		}
		s OutPutObj.Msg="已存在同种类型的卡"
		set OutPutObj.ResultCode="-51"
		;set OutputObj.SecurityNo=mySecurityNo
		set OutPutObj.PatientId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
	}else{
		s PatientIDs=$P(PatientIDs,"^",2)
	}
	;是否允许关联卡
	s AllowRelateCardFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AllowRelateCard"))
	if (PatientIDs'="")&&(AllowRelateCardFlag=0){
		q $$ODCreatePatientErrMag("已存在一种类型的正常卡,不允许再关联卡")
	}
	//s PatientIDs=""
	set PatType=##class(DHCExternalService.CardInterface.GetRelate).GetPatType(BankCode,PatientType)
	if (PatType=""){
		q $$ODCreatePatientErrMag("病人类型不能为空")
	}
	if (PatType'=1){
		q $$ODCreatePatientErrMag("非自费患者请前往窗口建卡")
	}

	set InfoObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	set InfoObj.Address="" //InputObj.Address
	set InfoObj.CardTypeCode=CardTypeCode
	set InfoObj.DOB=DOB
	set InfoObj.IDType=IDType
	set InfoObj.IDNo=IDNo 
	set InfoObj.InsureCardFlag="" ;InputObj.InsureCardFlag
	set InfoObj.InsureCardNo="" //InputObj.InsureCardNo
	set InfoObj.Mobile=Mobile
	set InfoObj.PatientCard=PatientCard
	set InfoObj.PatientName=PatientName
	set InfoObj.PatientType=PatType
	set InfoObj.SecurityNo=mySecurityNo
	set InfoObj.Sex=Sex
	set InfoObj.PayMode="" //##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(InputObj.PayModeCode,BankCode)
	set InfoObj.TotalAmount="" //InputObj.CardDepositAmt
	set InfoObj.TelephoneNo=Mobile
	set InfoObj.UserID=UserID
	set InfoObj.ChargeDepositAmt="" //+InputObj.ChargeDepositAmt-InputObj.CardDepositAmt
	set InfoObj.AccountPassword="" //InputObj.AccountPassword
	set InfoObj.TheArea="" //InputObj.TheArea
	
	;b ;TS
	TStart
	s PatientID=""
	if (PatientIDs=""){ ;插入
		
		s rtn=##class(DHCExternalService.CardInterface.CardManager).CardInsert(InfoObj,"")
		b ;rrrs
		i +rtn=0{
			s PatientID=$P(rtn,"^",2)
			if (IsChild="1"){
				s $p(^PAPER(PatientID,"PER",2),"^",13)=ParentName
				s $p(^PAPER(PatientID,"PER",2),"^",4)=ParentIDCard
			}
			s DHCCardRefDr=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardTypeID,PatientCard)
			if DHCCardRefDr'=""{
				s $p(^DHCCARD("CF",DHCCardRefDr),"^",23)=VUId
				s $p(^DHCCARD("CF",DHCCardRefDr),"^",24)=QRCode
			}
			Set OutPutObj.ResultCode="0"
			Set OutPutObj.ResultContent="建卡成功"
			
		}else{
			Set OutPutObj.ResultCode="-1"
			Set OutPutObj.Msg="建卡失败:"_rtn
			;q "-1^"_$P(rtn,"^",2)
		}
	}else{ ;更新
		
		set PatientID=PatientIDs
		set InfoObj.PatientID=PatientID
		s rtn=##class(DHCExternalService.CardInterface.CardManager).CardRelate(InfoObj,IDTotal,"")
		i +rtn=0{
			if (IsChild="1"){
				s $p(^PAPER(PatientID,"PER",2),"^",13)=ParentName
				s $p(^PAPER(PatientID,"PER",2),"^",4)=ParentIDCard
			}
			s DHCCardRefDr=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardTypeID,PatientCard)
			if DHCCardRefDr'=""{
				s $p(^DHCCARD("CF",DHCCardRefDr),"^",23)=VUId
				s $p(^DHCCARD("CF",DHCCardRefDr),"^",24)=QRCode
			}
			Set OutPutObj.ResultCode="0"
			Set OutPutObj.Msg="发卡成功"
			;q "0^成功^"
		}else{
			Set OutPutObj.ResultCode="-1"
			Set OutPutObj.Msg="发卡失败:"_rtn
			;q "-1^"_$P(rtn,"^",2)
		}
	}
	if (OutPutObj.ResultCode="0")
	{
		TCommit
		set OutPutObj.PatientId=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
	}
	else
	{
		TRollback
	}
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Response","")
ODCreatePatientErrMag(ErrText="")
	if (ErrText="") s ErrText="建档失败"
	s OutObj={}
	s OutObj.ResultCode="-1"
	s OutObj.Msg=ErrText
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutObj,"Response","")
}

}
