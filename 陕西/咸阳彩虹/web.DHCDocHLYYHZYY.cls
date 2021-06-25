/// 接口对接模式:  不固定ID+不打通
Class web.DHCDocHLYYHZYY Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetPrescOrdId(PrescNo As %String)
{
	s OrdStr=""
	s OrdId=0
	f  s OrdId=$o(^OEORD(0,"PrescNo",PrescNo,OrdId)) q:OrdId=""  d
	.s child=0
	.f  s child=$o(^OEORD(0,"PrescNo",PrescNo,OrdId,child)) q:child=""  d
	..s ordRowId=OrdId_"||"_child
	..i OrdStr="" s OrdStr=ordRowId
	..e  s OrdStr=OrdStr_"^"_ordRowId
	
	q OrdStr
}

/// w ##class(web.DHCDocHLYYHZYY).GetHZYYErrorAndAdviceNew("57886||4")
ClassMethod GetHZYYErrorAndAdviceNew(OrdItemDr As %String)
{
	s ^tempRen("GetHZYYErrorAndAdviceNew")=OrdItemDr
	s RetStr=""
	q:OrdItemDr="" RetStr
	s Ind=0
	s HZYYERRowid=0 
	for {
		
		s HZYYERRowid=$o(^DHCDocHZYYER(0,"Oeori",OrdItemDr,HZYYERRowid))
		q:HZYYERRowid=""
		s ARCIMRowid=$p($g(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2),1)),"^",2)
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		/// 成功标识 0:审核不通过,1:审核通过,2:超时通过,3:自动通过,5:失效药嘱通过,6:进行待审
		s HZYYERIsSuccess=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",6)
		/// 状态 1:可双签名或修改,0:必须修改,2:审核通过不做处理
		s HZYYERStatus=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",7)
		s ErrorInfo=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",11)
		s Advice=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",12)
		s Ind=Ind+1
		//s RetStr=HZYYERStatus_"^"_ErrorInfo_";"_Advice
		if RetStr="" s RetStr=HZYYERStatus_"^"_ARCIMDesc_": ["_Ind_"]"_ErrorInfo_" "_Advice
		else  s RetStr=RetStr_"["_Ind_"]"_ErrorInfo_" "_Advice
 
	}
	//s:RetStr="" RetStr="2^"
	q RetStr
}

ClassMethod CheckResultInfo(OrdItemStr As %String)
{
	q:OrdItemStr="" ""
	s Flag=0
	f k=1:1:$L(OrdItemStr,"^") {
		s ArcimRowId=$p($p(OrdItemStr,"^",k),"*",1)
		s NewOrdIdDR=$p($p(OrdItemStr,"^",k),"*",2)
		continue:NewOrdIdDR=""
		s HZYYERRowid=0 
		for {
			s HZYYERRowid=$o(^DHCDocHZYYER(0,"Oeori",NewOrdIdDR,HZYYERRowid))
			Q:HZYYERRowid=""
			s Flag=0
			s HZYYERIsSuccess=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",6)
			continue:(HZYYERIsSuccess'="0")&&(HZYYERIsSuccess'="1")&&(HZYYERIsSuccess'="2")
			s Flag=1
		}
	}
	q Flag
}

ClassMethod GetPrescNoByItemIDs(OrdItemStr As %String)
{
	q:OrdItemStr="" ""
	s PrescNoStr=""
	f k=1:1:$L(OrdItemStr,"^") {
		s ArcimRowId=$p($p(OrdItemStr,"^",k),"*",1)
		s newOrdIdDR=$p($p(OrdItemStr,"^",k),"*",2)
		i ArcimRowId="" continue
		s PrescNo=$p($g(^OEORD(+newOrdIdDR,"I",$P(newOrdIdDR,"||",2),1)),"^",14)
		continue:PrescNo=""
		if PrescNoStr="" s PrescNoStr=PrescNo
		else  s PrescNoStr=PrescNoStr_"^"_PrescNo
	}
	
	q PrescNoStr
}

/// Creator:      lvjun
/// CreatDate:    2020-12-12
/// Description:  审核医嘱前,调用杭州逸曜干预接口
/// Input:        EpisodeID:就诊表RowId  OrderItemStr:待审核医嘱串  HLYYLayOut:OEOrd(医嘱录入)/CMOEOrd(中草药录入) ExpStr:扩展串,用户id^科室id
/// Return:       标志(0通过,-1不通过,-2调用失败)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).CheckHLYYInfo("518",$p(^lj("CheckHLYYInfo"),",",2),"OEOrd","12175^55")
ClassMethod CheckHLYYInfo(EpisodeID As %String, OrderItemStr As %String, HLYYLayOut As %String, ExpStr As %String) As %String
{
	s ^lj("CheckHLYYInfo")=EpisodeID_","_OrderItemStr_","_HLYYLayOut_","_ExpStr
	if (HLYYLayOut="CMOEOrd") {
		s OrderItemStr=##class(web.DHCDocHLYYHZYY).ConvertCMOEOrdToOEOrd(EpisodeID,OrderItemStr)
	}
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckHLYYInfo(EpisodeID,OrderItemStr,"",ExpStr,"Check")
	Q HLYYInfo
}

/// Creator:      lvjun
/// CreatDate:    2020-12-12
/// Description:  审核医嘱后,调用杭州逸曜保存接口
/// Input:        EpisodeID:就诊表RowId  OrderStr:审核返回医嘱串  ExpStr:扩展串,用户id^科室id
/// Return:       标志(0通过,-1不通过,-2调用失败)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).SaveHLYYInfo("518","5266||1*496||9*V*^","12175^55")
ClassMethod SaveHLYYInfo(EpisodeID As %String, OrderStr As %String, ExpStr As %String) As %String
{
	s ^lj("SaveHLYYInfo")=$lb(EpisodeID,OrderStr,ExpStr)
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckHLYYInfo(EpisodeID,"",OrderStr,ExpStr,"Save")
	Q HLYYInfo
}

/// Creator:      lvjun
/// CreatDate:    2020-12-20
/// Description:  停医嘱调用杭州逸曜合理用药
/// Input:        OrderRowid:医嘱rowid  OperType:操作类型,1：停止，2：撤销，3：作废
/// Return:       标志(0通过,-1不通过,-2调用失败)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).StopHLYYInfo("496||8",1)
ClassMethod StopHLYYInfo(OEORIRowId As %String, OperType As %String) As %String
{
	s ^lj("StopHLYYInfo")=$lb(OEORIRowId,OperType)
	;判断是否是药品医嘱
	s ARCIMRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
	s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
	Q:DrugFlag'="Y" 0
	;判断是否开启杭州逸曜合理用药
	s AddDepRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),7)),"^",2)
	s AddHospRowid=$p($g(^CTLOC(AddDepRowid)),"^",22)
	s HZYYFlag=##class(web.DHCDocHLYYHZYY).CheckIsOpenHZYY(AddDepRowid,AddHospRowid)
	Q:HZYYFlag'="Y" 0
	;拼接医嘱串
	s AdmRowid=$p($g(^OEORD(+OEORIRowId)),"^",1)
	s AdmType=$p($g(^PAADM(AdmRowid)),"^",2)
	if (AdmType="I"){
		;住院作废医嘱调用删除接口
		if ((OperType="3")||(OperType="2")) {
			s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DeleteHLYYInfo(AdmRowid,OEORIRowId)
			Q HLYYInfo
		}else{
			s OrderStr=ARCIMRowid_"*"_OEORIRowId
		}
	}else{
		;门诊处方全部作废后调用删除接口
		s PrescNo=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",14)
		;renyx 修改门诊走删除接口  
		/*s ExistFlag=##class(web.DHCDocHLYYHZYY).CheckPrescExistOrder(PrescNo)
		if (+ExistFlag="0"){*/
			s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DeleteHLYYInfo(AdmRowid,OEORIRowId)
			Q HLYYInfo
		/*}else{
			s OrderStr=ARCIMRowid_"*"_OEORIRowId
		}*/
	}
	Q:OrderStr="" 0
	s AddUsereID=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),7)),"^",1)
	s ExpStr=AddUsereID_"^"_AddDepRowid
	s OrderModeType="Stop"
	//s OrderModeType=$case(OperType,"2":"Delete","3":"Delete",:"Stop")
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckHLYYInfo(AdmRowid,"",OrderStr,ExpStr,OrderModeType)
	Q HLYYInfo
}

/// Creator:      lvjun
/// CreatDate:    2020-12-25
/// Description:  审核医嘱后,调用杭州逸曜审方接口
/// Input:        EpisodeID:就诊表RowId  OrderStr:审核返回医嘱串  ExpStr:扩展串,用户id^科室id
/// Return:       标志(0通过,-1不通过,-2调用失败)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).ExamHLYYInfo("31292649","2647||1*31290083||265*V*^","15888^78")
ClassMethod ExamHLYYInfo(EpisodeID As %String, OrderStr As %String, ExpStr As %String) As %String
{
	s ^lj("ExamHLYYInfo")=$lb(EpisodeID,OrderStr,ExpStr)
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckHLYYInfo(EpisodeID,"",OrderStr,ExpStr,"Exam")	
	Q HLYYInfo
}

/// Creator:      lvjun
/// CreatDate:    2020-12-12
/// Description:  将待审核草药数据串拼接成待审核西药数据串
/// Input:        EpisodeID:就诊表RowId  CMOEOrdStr:待审核草药数据串
/// Return:       待审核西药格式数据串
/// Others:       w ##class(web.DHCDocHLYYHZYY).ConvertCMOEOrdToOEOrd("4415774",$p(^lj("ConvertCMOEOrdToOEOrd"),",",2))
ClassMethod ConvertCMOEOrdToOEOrd(EpisodeID As %String, CMOEOrdStr As %String) As %String
{
	s ^lj("ConvertCMOEOrdToOEOrd")=EpisodeID_","_CMOEOrdStr
	s PrescStr=$p(CMOEOrdStr,$C(2),1)
	s CMItemStr=$p(CMOEOrdStr,$c(2),2)
	s PrescPriorRowid=$p(PrescStr,"^",1)
	s PrescDurRowid=$p(PrescStr,"^",2)
	s PrescInstrRowid=$p(PrescStr,"^",3)
	s PrescFreqRowid=$p(PrescStr,"^",4)
	s PrescCookMode=$p(PrescStr,"^",5)
	s PrescOrderQty=$p(PrescStr,"^",6)
	s PrescRecDepRowid=$p(PrescStr,"^",7)
	s PrescAdmReason=$p(PrescStr,"^",8)
	s PrescNotes=$p(PrescStr,"^",9)
	s PrescEmergency=$p(PrescStr,"^",10)
	s PrescStartDate=$p(PrescStr,"^",11)
	if (PrescStartDate="") s PrescStartDate=+$h
    else  s PrescStartDate=##class(websys.Conversions).DateHtmlToLogical(PrescStartDate)
    s PrescStartDate=##class(websys.Conversions).DateLogicalToHtml(PrescStartDate)
    s PrescStartTime=$p(PrescStr,"^",12)
    if (PrescStartTime="") s PrescStartTime=$p($h,",",2)
    else  s PrescStartTime=##class(websys.Conversions).TimeHtmlToLogical(PrescStartTime)
    s PrescStartTime=$zt(PrescStartTime,1)
    ;
    s OEOrdStr=""
	for ItemSeq=1:1:$l(CMItemStr,$c(1)) {
		s CMItemOne=$p(CMItemStr,$c(1),ItemSeq)
		continue:CMItemOne=""
		s ARCIMRowid=$p(CMItemOne,"^",1)
		continue:ARCIMRowid=""
		s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
		continue:OrderType'="R"
		s DoseQty=$p(CMItemOne,"^",2)
		s DurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
		s PackQty=DoseQty*DurFactor
		s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$h,"","","","","","")
		s UnitPrice=$p(OrderPrice,"^",4)
		s DoseUOMRowid=$p(CMItemOne,"^",3)
		if (DoseUOMRowid="") s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
		if (DoseUOMRowid="") {
			s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
			if (Phcdf'="") s DoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
		s PhSpecInstr=$p(CMItemOne,"^",4)
		s OrderSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime_"^"_ItemSeq
		s OrderMasterSeqNo=EpisodeID_"^"_PrescStartDate_"^"_PrescStartTime
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PrescPriorRowid_"^"_PrescStartDate_"^"_PrescStartTime_"^"_PackQty	;1-6
		s OEOrdOne=OEOrdOne_"^"_UnitPrice_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""_"^"_PrescFreqRowid	;7-14
		s OEOrdOne=OEOrdOne_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_""_"^"_OrderMasterSeqNo_"^"_OrderSeqNo	;15-20
		s $p(OEOrdOne,"^",22)=PhSpecInstr
		s $p(OEOrdOne,"^",30)=PrescEmergency
		s $p(OEOrdOne,"^",46)=PrescStartDate
		s $p(OEOrdOne,"^",47)=PrescStartTime
		s $p(OEOrdOne,"^",55)=DoseUOMRowid
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

/// Creator:      lvjun
/// CreatDate:    2020-12-20
/// Description:  判断是否开启杭州逸曜合理用药
/// Input:        DepRowid:科室表RowId  HospitalId:院区id
/// Return:       Y:开启  N:未开启
/// Others:       w ##class(web.DHCDocHLYYHZYY).CheckIsOpenHZYY("3","2")
ClassMethod CheckIsOpenHZYY(DepRowid As %String, HospRowid As %String) As %String
{
	s ^lj("CheckIsOpenHZYY")=$lb(DepRowid,HospRowid)
	s ParameterNum=##class(web.DHCDocHLYYHZYY).GetParameterNum("web.DHCDocConfig","GetConfigNode")
	if (ParameterNum=1) s CurrCompany=##class(web.DHCDocConfig).GetConfigNode("CurrCompany")
	else  s CurrCompany=##class(web.DHCDocConfig).GetConfigNode("CurrCompany",HospRowid)
	s CurrCompanyCode=$p(CurrCompany,"^",2)
	s CurrCompanyCode=$$ALPHAUP^SSUTIL4(CurrCompanyCode)
	Q:CurrCompanyCode'="HZYY" "N"
	if (ParameterNum=1) s HLYYAdmDep=##class(web.DHCDocConfig).GetConfigNode("DTAdmDep")
	else  s HLYYAdmDep=##class(web.DHCDocConfig).GetConfigNode("DTAdmDep",HospRowid)
	Q:HLYYAdmDep="" "N"
	Q:(("^"_HLYYAdmDep_"^")'[("^"_DepRowid_"^")) "N"
	Q "Y"
}

/// Creator:      lvjun
/// CreatDate:    2020-12-20
/// Description:  判断是否是药品医嘱
/// Input:        ARCIMRowid:医嘱项id
/// Return:       Y:是  N:不是
/// Others:		  w ##class(web.DHCDocHLYYHZYY).CheckIsDrugItem("1||1")
ClassMethod CheckIsDrugItem(ARCIMRowid As %String) As %String
{
	s ^lj("CheckIsDrugItem")=ARCIMRowid
	s DrugFlag="N"
	Q:ARCIMRowid="" DrugFlag
	s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	Q:ItemCatDr="" DrugFlag
	s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
	if (OrderType="R") s DrugFlag="Y"
	Q DrugFlag
}

/// Creator:      lvjun
/// CreatDate:    2020-12-20
/// Description:  根据处方号判断是否还存在有效医嘱
/// Input:        PrescNo:处方号
/// Return:       0:不存在,1:存在^医嘱id串
/// Others:		  w ##class(web.DHCDocHLYYHZYY).CheckPrescExistOrder("O201209000007")
ClassMethod CheckPrescExistOrder(PrescNo As %String) As %String
{
	s ExistFlag="0"
	Q:PrescNo="" ExistFlag
	s OrderRowid=$o(^OEORD(0,"PrescNo",PrescNo,0))
	Q:OrderRowid="" ExistFlag
	s ValidOrderStr=""
	s ChildSub=0 for {
		s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub))
		Q:ChildSub=""
		s StatCode=""
		s ItemStatDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
		if (ItemStatDr'="") s StatCode=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
		continue:(StatCode'="V")&&(StatCode'="E")
		s ExistFlag="1"
		if (ValidOrderStr="") s ValidOrderStr=OrderRowid_"||"_ChildSub
		else  s ValidOrderStr=ValidOrderStr_"^"_OrderRowid_"||"_ChildSub
	}
	Q ExistFlag_"!"_ValidOrderStr
}

/// Creator:      lvjun
/// CreatDate:    2020-12-25
/// Description:  判断类方法入参个数
/// Input:        className:类名  methodName:方法名
/// Return:       入参个数
/// Others:       w ##class(web.DHCDocHLYYHZYY).GetParameterNum("web.DHCDocConfig","GetConfigNode")
ClassMethod GetParameterNum(className As %String, methodName As %String) As %String
{
	s methodParameter=$g(^oddCOM(className,"m",methodName,60))
	s parameterNum=$ll(methodParameter)
	q parameterNum
}

/// Creator:      lvjun
/// CreatDate:    2020-12-30
/// Description:  调用杭州逸曜合理用药接口双签
/// Input:        EpisodeID:就诊表id DataStr:住院传入医嘱串,门诊传入处方串 SignNotes:双签内容,UserID:用户id,OperType:操作类型,S双签,U修改
/// Return:       监测信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).SignHLYYInfo("4415774","4321437||231","测试","2788","S")
ClassMethod SignHLYYInfo(EpisodeID As %String, DataStr As %String, SignNotes As %String, UserID As %String, OperType As %String) As %String
{
	s ^lj("SignHLYYInfo")=$lb(EpisodeID,DataStr,SignNotes,UserID,OperType)
	s HLYYInfo=0
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		for i=1:1:$l(DataStr,"^") {
			s OrderOne=$p(DataStr,"^",i)
			continue:OrderOne=""
			;住院按照组进行管理,只需要主医嘱进行调用
			s OEORIOEORIDR=$p($g(^OEORD(+OrderOne,"I",$p(OrderOne,"||",2),11)),"^",39)
			continue:OEORIOEORIDR'=""
			s ret=0
			if (OperType="S") {
				s ret=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SignHLYYInfo(EpisodeID,OrderOne,SignNotes,UserID)
			}
			b	;ret
			if (+ret=0) {
				;更新his记录
				s HZYYERRowid=0 for {
					s HZYYERRowid=$o(^DHCDocHZYYER(0,"GroupNo",OrderOne,HZYYERRowid))
					Q:HZYYERRowid=""
					s CurrDate=+$h,CurrTime=$p($h,",",2)
					&SQL(Update SQLUser.DHC_DocHZYYExamResult Set HZYYER_LastStatus=:OperType,HZYYER_DoubleSign=:SignNotes,
					 	HZYYER_UpdateDate=:CurrDate,HZYYER_UpdateTime=:CurrTime,HZYYER_UpdateUser_DR=:UserID Where HZYYER_RowId=:HZYYERRowid)
					s HLYYInfo=HLYYInfo+SQLCODE
				}
			}
		}
	}else{
		for i=1:1:$l(DataStr,"^") {
			s PrescNo=$p(DataStr,"^",i)
			continue:PrescNo=""
			s ret=0
			if (OperType="S") {
				;s ret=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SignHLYYInfo(EpisodeID,PrescNo,SignNotes,UserID)
			}
			b	;ret
			if (+ret=0) {
				;更新his记录
				s HZYYERRowid=0 for {
					s HZYYERRowid=$o(^DHCDocHZYYER(0,"PrescNo",PrescNo,HZYYERRowid))
					Q:HZYYERRowid=""
					s CurrDate=+$h,CurrTime=$p($h,",",2)
					&SQL(Update SQLUser.DHC_DocHZYYExamResult Set HZYYER_LastStatus=:OperType,HZYYER_DoubleSign=:SignNotes,
					 	HZYYER_UpdateDate=:CurrDate,HZYYER_UpdateTime=:CurrTime,HZYYER_UpdateUser_DR=:UserID Where HZYYER_RowId=:HZYYERRowid)
					s HLYYInfo=HLYYInfo+SQLCODE
				}
			}
		}
	}
	Q HLYYInfo
}

/// Creator:      lvjun
/// CreatDate:    2021-02-01
/// Description:  根据审核后医嘱串获取所有的处方号
/// Input:        OrderStr:审核后医嘱串
/// Return:       处方号1^处方号2^处方号3...
/// Others:		  w ##class(web.DHCDocHLYYHZYY).GetPrescNoStrByOrder("57882||27")
ClassMethod GetPrescNoStrByOrder(OrderStr As %String) As %String
{
	s PrescNoStr=""
	f i=1:1:$l(OrderStr,"^") {
		s OrderOne=$p(OrderStr,"^",i)
		continue:OrderOne=""
		if (OrderOne["*"){
			s ARCIMRowid=$p(OrderOne,"*",1)
			s OEORIRowId=$p(OrderOne,"*",2)
		}else{
			s OEORIRowId=OrderOne
			s ARCIMRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
		}
		s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
		continue:DrugFlag'="Y"
		s PrescNo=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",14)
		continue:PrescNo=""
		continue:("^"_PrescNoStr_"^")[("^"_PrescNo_"^")
		if (PrescNoStr="") s PrescNoStr=PrescNo
		else  s PrescNoStr=PrescNoStr_"^"_PrescNo
	}
	Q PrescNoStr
}

/// Creator:      lvjun
/// CreatDate:    2021-02-02
/// Description:  根据就诊id,处方号串展示审方数据(门急诊使用,代码参考总览打印界面)
/// Input:        EpisodeID:就诊id,PrescNoStr:处方号串
/// Return:       
/// Others:		  d ##class(web.DHCDocHLYYHZYY).GetOEPrescInfo("511","O210203000003")
ClassMethod GetOEPrescInfo(EpisodeID As %String, PrescNoStr As %String)
{
	s ^lj("GetOEPrescInfo")=$lb(EpisodeID,PrescNoStr)
	d ..QueryOEPrescInfo(EpisodeID,PrescNoStr,.colDefine)
	s tIndx="QueryOEPrescInfo_"_$j
	b	;^CacheTemp(tIndx)
	s IsSuccessIndex=colDefine.index("IsSuccess")
	s NowStatusIndex=colDefine.index("NowStatus")
	w "["
	s tableCount=0
	s PrescNo=0 for {
		s PrescNo=$o(^CacheTemp(tIndx,PrescNo))
		Q:PrescNo=""
		s col="SeqNo:序号,ArcimDesc:医嘱名称,DoseQty:单次剂量,PHFreq:频次,Instr:用法,Dura:疗程,OrdStatus:状态,OrderPackQty:数量,OrdDepProcNotes:备注,ErrorAndAdvice:错误信息及药师建议,OEItemID:医嘱ID"	;OrdCreateDate:下医嘱日期,OrdCreateTime:医嘱时间,OrdBilled:计费状态/撤销,AdmReason:费别,IsSuccess:审方结果,NowStatus:审方状态
		w:tableCount>0 ","
		s tableCount=tableCount+1
		w "{"
		w ##class(web.DHCDocHLYYHZYY).FormatDataTableCols(col,.colDefine)
		w ",""id"":"""_PrescNo_"_Table"","
		w """rows"":["
		s rowCount=0,prelist="",MainSeqNo=1
		s IsSuccess="",NowStatus="",RecLoc=""
		s Count=0 for {
			s Count=$o(^CacheTemp(tIndx,PrescNo,Count))
			Q:Count=""
			w:rowCount>0 ","
			s rowCount=rowCount+1
			s list=^CacheTemp(tIndx,PrescNo,Count)
			s IsSuccess=$lg(list,IsSuccessIndex)	;审方结果
			s NowStatus=$lg(list,NowStatusIndex)	;审方状态
			s OEItemID=$lg(list,14)
			s RecLoc=$lg(list,33)
			s SeqNo=$list(list,56)
			s MasterSeqNo=$list(list,53)
		    if (MasterSeqNo'="")&&(prelist'="") {
			    s PreSeqNo=$list(prelist,56)
			    if (PreSeqNo[".") s $list(list,56)=$p(PreSeqNo,".",1)_"."_($p(PreSeqNo,".",2)+1)
			    e  s $list(list,56)=PreSeqNo_".1"
		    }else{
			    s $list(list,56)=MainSeqNo,MainSeqNo=MainSeqNo+1
		    }
		    s prelist=list
			d ##class(DHCDoc.Common.FormatData).JsonList(colDefine,list)
		}
		w "]"
		w ",""title"":"""_"处方号："_PrescNo_"-"_RecLoc
		if (NowStatus'="") {
			w "-审方结果："_IsSuccess_"-审方状态："_NowStatus_""""
		}elseif (IsSuccess'="") {
			w "-审方结果："_IsSuccess_""""
		}else{
			w ""_""""
		}
		w ",""titleClass"":""normal-head"""
		w "}"
	}
	w "]"
	q ""
}

/// base on the query of web.DHCDocQryOEOrder:GetOrdByAdm
ClassMethod QueryOEPrescInfo(EpisodeID As %String, PrescNoStr As %String, ByRef colDefine As DHCDoc.Common.MapIndex)
{
	s colDefine=##class(DHCDoc.Common.MapIndex).%New()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocQryOEOrder"
	set rs.QueryName="GetOrdByAdm"
	set sc=rs.Execute(EpisodeID,"","","")
	s len=rs.GetColumnCount()
	f i=1:1:len {
		d colDefine.add(rs.GetColumnName(i))
		s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
	}
	d colDefine.add("IsSuccess")	;审方结果
	d colDefine.add("NowStatus")	;审方状态
	d colDefine.add("ErrorAndAdvice")	;错误信息及药师建议
	s colDefine.map("ErrorAndAdvice","Type")="String"
	set tIndx="QueryOEPrescInfo_"_$j
	k ^CacheTemp(tIndx)
	set count=1
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s OrderType=rs.Data("OrderType")
		continue:OrderType'="R"
		s PrescNo=rs.Data("PrescNo")
		continue:(PrescNoStr'[PrescNo)&&(PrescNoStr'="")
		s list=$lb()
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		;单次剂量、单位合并一列显示
		s DoseQty=rs.Data("DoseQty")
		s DoseUnit=rs.Data("DoseUnit")
		if (DoseUnit'="") s DoseQty=DoseQty_DoseUnit
		s $list(list,6)=DoseQty
		;数量、数量单位合并一列显示
		s OrderPackQty=rs.Data("OrderPackQty")
		s PackUOMDesc=rs.Data("PackUOMDesc")
		s OEItemID=rs.Data("OEItemID")
		s ARCIMRowId=rs.Data("ARCIMRowId")
		s IsCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowId)
		if (IsCNMedItem="Y") s OrderPackQty=OrderPackQty_DoseUnit
		else  s OrderPackQty=OrderPackQty_PackUOMDesc
		s $list(list,29)=OrderPackQty
		;
		s LastHZYYERRowid=$o(^DHCDocHZYYER(0,"PrescNo",PrescNo,""),-1)
		s ExamResult=##class(web.DHCDocHLYYHZYY).GetHZYYExamResult(LastHZYYERRowid)
		s IsSuccess=$p(ExamResult,"^",3)
		s NowStatus=$p(ExamResult,"^",4)
		;获取错误及建议
		s ErrorAndAdvice=##class(web.DHCDocHLYYHZYY).GetHZYYErrorAndAdvice(OEItemID,"",PrescNo)
		s $list(list,index+1)=IsSuccess
		s $list(list,index+2)=NowStatus
		s $list(list,index+3)=ErrorAndAdvice
		;
		s ^CacheTemp(tIndx,PrescNo,count)=list
		s count=count+1
	}
	d rs.Close()
}

ClassMethod FormatDataTableCols(dataHeadConfig As %String, ByRef colDefine As DHCDoc.Common.MapIndex) As %String
{
	k headMap,headMap2,hiddenMap
	f i=1:1:$L(dataHeadConfig,","){
		s m=$P(dataHeadConfig,",",i)
		s d=$P(m,":",1)
		s h=$P(m,":",2)
		continue:( (h="") || (h="null") || ( '$d(colDefine.map(d)) ) )
		s headMap(d)=h
		s headMap2(i)=d
		s isHidden="N"
		if (h=d){
			s isHidden="Y"
		}
		s hiddenMap(i)=isHidden
	}
	
	s json= """head"":["
	s i="" f  {
		s i=$o(headMap2(i))
		q:i=""
		s:i>1 json=json_","
		s json=json_ """"_headMap(headMap2(i))_""""
	}
	s json=json_ "],""rowCols"":["
	s count=0
	
	s i="" f {
		s i=$o(headMap2(i)) 
		q:i=""
		s:i>1 json=json_","
		s json=json_ "{""data"":"_""""_headMap2(i)_"""}"
	}
	
	s json=json_ "],""HiddenCols"":["
	s i="" f {
		s i=$o(hiddenMap(i)) 
		q:i=""
		s:i>1 json=json_","
		s json=json_ "{"""_headMap2(i)_""":"_""""_hiddenMap(i)_"""}"
	}
	
	s json=json_ "]"
	q json
}

Query QryOrderInfo(EpisodeID As %String, UserID As %String, StartDate As %String, EndDate As %String, OrderDesc As %String, LongOrder As %String, ShortOrder As %String, RefuseOrder As %String) As %Query(ROWSPEC = "OrderRowid:%String,OooriOeoriDR:%String,Priority:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,ReLoc:%String,GroupSign:%String,GroupNo:%String,CheckPharmId:%String,CheckPharmName:%String,IsSuccess:%String,NowStatus:%String,ErrorAndAdvice:%String,DoubleSign:%String")
{
}

/// Creator:      lvjun
/// CreatDate:    2021-02-02
/// Description:  根据就诊id,处方号串展示审方数据(门急诊使用,代码参考总览打印界面)
/// Input:        EpisodeID:就诊id,PrescNoStr:处方号串
/// Return:       
/// Others:	d ##class(%ResultSet).RunQuery("web.DHCDocHLYYHZYY","QryOrderInfo","35","12175","","","","on","on","on")
ClassMethod QryOrderInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String, StartDate As %String, EndDate As %String, OrderDesc As %String, LongOrder As %String, ShortOrder As %String, RefuseOrder As %String) As %Status
{
	s ^lj("QryOrderInfo")=$lb(EpisodeID,UserID,StartDate,EndDate,OrderDesc,LongOrder,ShortOrder,RefuseOrder)
	Set repid=$I(^CacheTemp)
	if $g(ind) = "" set ind=1
	if (StartDate="") s StartDate=+$h-3
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	if (EndDate="") s EndDate=+$h+1
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	k plist
	s space="&nbsp&nbsp",tab=space_space_space_space
	Set rs=##Class(%ResultSet).%New("web.DHCDocQryOEOrder:GetOrdByAdm")
	If rs.QueryIsValid() {
		Set Status=rs.Execute(EpisodeID,UserID,StartDate,EndDate,"","",LongOrder,ShortOrder)
		If 'Status Quit
		While rs.Next() {
			s OrderRowid=rs.Data("OEItemID")
			s ARCIMRowid=$p($g(^OEORD(+OrderRowid,"I",$p(OrderRowid,"||",2),1)),"^",2)
			s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
			continue:DrugFlag'="Y"
			;草药暂时不参与审方
			s CNMedFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
			continue:CNMedFlag=1
			s OooriOeoriDR=$p($g(^OEORD(+OrderRowid,"I",$p(OrderRowid,"||",2),11)),"^",39)
			s Priority=rs.Data("Priority")
			s OrdStartDate=rs.Data("OrdStartDate")
			s CheckStDate=##class(websys.Conversions).DateHtmlToLogical(OrdStartDate)
			continue:(StartDate'="")&&(CheckStDate<StartDate)
			continue:(EndDate'="")&&(CheckStDate>EndDate)
			s OrdStartTime=rs.Data("OrdStartTime")
			s ArcimDesc=rs.Data("ArcimDesc")
			continue:(ArcimDesc'[OrderDesc)&&(OrderDesc'="")
			if (OooriOeoriDR'="") s ArcimDesc=tab_ArcimDesc
			s DoseQty=rs.Data("DoseQty")_rs.Data("DoseUnit")
			s PHFreq=rs.Data("PHFreqDesc")
			s Instr=rs.Data("Instr")
			s Doctor=rs.Data("Doctor")
			s OrdStatus=rs.Data("OrdStatus")
			s ReLoc=rs.Data("ReLoc")
			s GroupSign=""
			;审方信息
			s GroupNo=OooriOeoriDR
			if (GroupNo="") s GroupNo=OrderRowid
			s LastHZYYERRowid=$o(^DHCDocHZYYER(0,"GroupNo",GroupNo,""),-1)
			s ExamResult=##class(web.DHCDocHLYYHZYY).GetHZYYExamResult(LastHZYYERRowid)
			s CheckPharmId=$p(ExamResult,"^",1)
			s CheckPharmName=$p(ExamResult,"^",2)
			s IsSuccess=$p(ExamResult,"^",3)
			continue:(RefuseOrder="on")&&(IsSuccess'="审核不通过")
			s NowStatus=$p(ExamResult,"^",4)
			if (NowStatus="禁") s NowStatus="<font color=red>禁</font>"
			if (NowStatus="签") s NowStatus="<font color=green>签</font>"
			s DoubleSign=$p(ExamResult,"^",7)
			;获取错误及建议
			s ErrorAndAdvice=##class(web.DHCDocHLYYHZYY).GetHZYYErrorAndAdvice(OrderRowid,GroupNo,"")
			;
			s rslist=$lb(OrderRowid,OooriOeoriDR,Priority,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,PHFreq,Instr,Doctor,OrdStatus,ReLoc,GroupSign,GroupNo,CheckPharmId,CheckPharmName,IsSuccess,NowStatus,ErrorAndAdvice,DoubleSign)
			if (+OooriOeoriDR>0){
				set plist(+OooriOeoriDR,$p(OooriOeoriDR,"||",2),"Sub",$p(OrderRowid,"||",2)) = rslist
			}else{
				set plist(+OrderRowid,$p(OrderRowid,"||",2)) = rslist 
			}
		 }
	}
	d ..OutputGroupOrder(repid,ind,.plist)
	;
	Set qHandle = $lb(0,repid,0)
 	quit $$$OK
}

ClassMethod QryOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按成组输出医嘱
ClassMethod OutputGroupOrder(repid, ind, ByRef plist)
{
	s orderParref = $o(plist(""))
	q:+orderParref=0
	s parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
	.s plist(orderParref,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
	.s sub=0 f  s sub = $o(plist(orderParref,parref,"Sub",sub)) q:sub=""  d
	..if $o(plist(orderParref,parref,"Sub",sub))="" d
	...s $list(plist(orderParref,parref,"Sub",sub),13)="<p style=""display:inline;color:red;"">┛</p>"
	..else  d
	...s $list(plist(orderParref,parref,"Sub",sub),13)="<p style=""display:inline;color:red;"">┃</p>" 
	..s plist(orderParref,parref,"ChildNum")=plist(orderParref,parref,"ChildNum")+1
	.i plist(orderParref,parref,"ChildNum")>0 Set $list(plist(orderParref,parref),13)="<p style=""display:inline;color:red;"">┓</p>"
	
	s parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
	.s ind = ind+1	
	.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
	.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
	..s ind = ind+1
	..s ^CacheTemp(repid,ind) = plist(orderParref,parref,"Sub",sub)
	q
}

/// Creator:	  lvjun
/// CreatDate:	  2020-12-30
/// Description:  根据杭州逸耀审方结果id获取审方信息
/// Input:		  HZYYERRowid:杭州逸耀审方结果id
/// Return:		  审方信息
/// Others:		  w ##class(web.DHCDocHLYYHZYY).GetHZYYExamResult("1")
ClassMethod GetHZYYExamResult(HZYYERRowid As %String) As %String
{
	Q:HZYYERRowid="" ""
	;审核药师工号
	s CheckPharmId=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",1)
	;审核药师姓名
	s CheckPharmName=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",2)
	;成功标识
	s IsSuccess=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",6)
	if (IsSuccess="0") s IsSuccess="审核不通过"
	if (IsSuccess="1") s IsSuccess="审核通过"
	if (IsSuccess="2") s IsSuccess="超时通过"
	if (IsSuccess="3") s IsSuccess="自动通过"
	if (IsSuccess="5") s IsSuccess="失效药嘱通过"
	if (IsSuccess="6") s IsSuccess="进入待审"
	;状态
	s NowStatus=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",7)
	if (NowStatus="0") s NowStatus="禁"
	if (NowStatus="1") s NowStatus="签"
	if (NowStatus="2") s NowStatus="审核通过不做处理"
	s LastStatus=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",13)
	if (LastStatus="S") s LastStatus="双签通过"
	if (LastStatus="U") s LastStatus="已经作废"
	if (LastStatus'="") s NowStatus=NowStatus_" "_LastStatus
	;错误信息
	s ErrorInfo=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",11)
	;药师建议
	s Advice=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",12)
	;双签内容
	s DoubleSign=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",14)
	;
	s ExamResult=CheckPharmId_"^"_CheckPharmName_"^"_IsSuccess_"^"_NowStatus_"^"_ErrorInfo_"^"_Advice_"^"_DoubleSign
	Q ExamResult
}

/// Creator:	  lvjun
/// CreatDate:	  2020-12-30
/// Description:  获取审方返回的错误信息及建议
/// Input:		  OEORIRowId:医嘱id  GroupNo:组号  PrescNo:处方号
/// Return:		  错误信息及建议
/// Others:		  w ##class(web.DHCDocHLYYHZYY).GetHZYYErrorAndAdvice("57882||16","","")
ClassMethod GetHZYYErrorAndAdvice(OEORIRowId As %String, GroupNo As %String, PrescNo As %String) As %String
{
	s ErrorAndAdvice=""
	s HZYYERRowid=0 for {
		s HZYYERRowid=$o(^DHCDocHZYYER(0,"Oeori",OEORIRowId,HZYYERRowid))
		Q:HZYYERRowid=""
		d GetErrorAndAdvice
	}
	if (GroupNo'="") {
		s HZYYERRowid=0 for {
			s HZYYERRowid=$o(^DHCDocHZYYER(0,"GroupNo",GroupNo,HZYYERRowid))
			Q:HZYYERRowid=""
			s HZYYEROeoriDr=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",9)
			continue:+HZYYEROeoriDr'=0
			d GetErrorAndAdvice
		}
	}
	if (PrescNo'="") {
		s HZYYERRowid=0 for {
			s HZYYERRowid=$o(^DHCDocHZYYER(0,"PrescNo",PrescNo,HZYYERRowid))
			Q:HZYYERRowid=""
			s HZYYEROeoriDr=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",9)
			continue:+HZYYEROeoriDr'=0
			d GetErrorAndAdvice
		}
	}
	Q ErrorAndAdvice
GetErrorAndAdvice
	s ErrorInfo=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",11)
	s Advice=$p($g(^DHCDocHZYYER(HZYYERRowid)),"^",12)
	Q:(ErrorInfo="")&&(Advice="")
	if (ErrorAndAdvice="") s ErrorAndAdvice=ErrorInfo_" "_Advice
	else  s ErrorAndAdvice=ErrorAndAdvice_"  "_ErrorInfo_" "_Advice
	Q
}

/// Creator:      lvjun
/// CreatDate:    2021-02-05
/// Description:  根据杭州逸曜审方结果判断是否可用
/// Input:        EpisodeID:就诊id,OEORIRowIdStr:医嘱id,PrescNoStr:处方号串
/// Return:       标志(-2等待审方,-11不通过未处理,-12不通过已处理,0通过,11通过需要双签,12通过需要双签,已经作废)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).CheckBeforeUse("514","","O210205000018")
/// Others:       w ##class(web.DHCDocHLYYHZYY).CheckBeforeUse("56533","55577||117","")
ClassMethod CheckBeforeUse(EpisodeID As %String, OEORIRowIdStr As %String, PrescNoStr As %String) As %String
{
	;根据门诊住院分开判断
	s status=""
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		for i=1:1:$l(OEORIRowIdStr,"^") {
			s OEORIRowId=$p(OEORIRowIdStr,"^",i)
			continue:OEORIRowId=""
			s GroupNo=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),11)),"^",39)
			if (GroupNo="") s GroupNo=OEORIRowId
			s LastHZYYERRowid=$o(^DHCDocHZYYER(0,"GroupNo",GroupNo,""),-1)
			if (LastHZYYERRowid="") s status="-2"_"^"_OEORIRowId_"需要等待审方" Quit
			s IsSuccess=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",6)
			if (IsSuccess="")||(IsSuccess="6") s status="-2"_"^"_OEORIRowId_"需要等待审方" Quit
			if (IsSuccess="0") {
				s NowStatus=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",7)
				if (NowStatus="0") {
					s status="-11"_"^"_OEORIRowId_"审方不通过"
					s ItemStat=""
					s ItemStatDr=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",13)
					if (ItemStatDr'="") s ItemStat=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
					if (ItemStat'="V")&&(ItemStat'="E") s status="-12"_"^"_OEORIRowId_"审方不通过"
				}
				if (NowStatus="1") {
					s LastStatus=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",13)
					if (LastStatus="") s status="11"_"^"_OEORIRowId_"审方通过,需要双签"
					if (LastStatus="U") s status="12"_"^"_OEORIRowId_"审方通过,需要双签,已经作废"
				}
			}
			if (status'="") Quit
		}
	}else{
		;先判断是否获取到了所有结果
		for i=1:1:$l(PrescNoStr,"^") {
			s PrescNo=$p(PrescNoStr,"^",i)
			continue:PrescNo=""
			s LastHZYYERRowid=$o(^DHCDocHZYYER(0,"PrescNo",PrescNo,""),-1)
			if (LastHZYYERRowid="") s status="-2"_"^"_PrescNo_"需要等待审方" Quit
			s IsSuccess=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",6)
			s LastStatus=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",13)
			if ((IsSuccess="")||(IsSuccess="6"))&&(LastStatus="") s status="-2"_"^"_PrescNo_"需要等待审方" Quit
		}
		b	;status
		Q:status'="" status
		for i=1:1:$l(PrescNoStr,"^") {
			s PrescNo=$p(PrescNoStr,"^",i)
			continue:PrescNo=""
			s LastHZYYERRowid=$o(^DHCDocHZYYER(0,"PrescNo",PrescNo,""),-1)
			s IsSuccess=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",6)
			if (IsSuccess="0") {
				s NowStatus=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",7)
				if (NowStatus="0") {
					s status="-11"_"^"_PrescNo_"审方不通过"
					s ExistFlag=##class(web.DHCDocHLYYHZYY).CheckPrescExistOrder(PrescNo)
					if (+ExistFlag="0") s status="-12"_"^"_PrescNo_"审方不通过,已经作废"
				}
				if (NowStatus="1") {
					s LastStatus=$p($g(^DHCDocHZYYER(LastHZYYERRowid)),"^",13)
					if (LastStatus="") s status="11"_"^"_PrescNo_"审方通过,需要双签"
					if (LastStatus="U") s status="12"_"^"_PrescNo_"审方通过,需要双签,已经作废"
				}
			}
			if (status'="") Quit
		}
	}
	if (status="") s status="0^审方通过"
	Q status
}

/// Creator:      lvjun
/// CreatDate:    2021-02-22
/// Description:  根据医嘱id判断医嘱是否可用(提供给其他产品组使用)
/// Input:        OEORIRowId:医嘱表id
/// Return:       标志(Y通过,N不通过)^提示信息
/// Others:       w ##class(web.DHCDocHLYYHZYY).CheckBeforeUseService("1||1")
ClassMethod CheckBeforeUseService(OEORIRowId As %String) As %String
{
	s rtn="Y^通过"
	;判断是否是药品医嘱
	s ARCIMRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
	s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
	Q:DrugFlag'="Y" rtn
	;判断是否开启杭州逸曜合理用药
	s AddDepRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),7)),"^",2)
	s AddHospRowid=$p($g(^CTLOC(AddDepRowid)),"^",22)
	s HZYYFlag=##class(web.DHCDocHLYYHZYY).CheckIsOpenHZYY(AddDepRowid,AddHospRowid)
	Q:HZYYFlag'="Y" rtn
	;获取审方结果
	s AdmRowid=$p($g(^OEORD(+OEORIRowId)),"^",1)
	s PrescNo=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",14)
	s ExamResult=##class(web.DHCDocHLYYHZYY).CheckBeforeUse(AdmRowid,OEORIRowId,PrescNo)
	if (+ExamResult'="0") s rtn="N"_"^"_$p(ExamResult,"^",2)
	Q rtn
}

/// Creator:      lvjun
/// CreatDate:    2021-03-01
/// Description:  根据就诊id获取待审核的处方号串
/// Input:        EpisodeID:就诊id
/// Return:       处方号1^处方号2^处方号3...
/// Others:		  w ##class(web.DHCDocHLYYHZYY).GetPrescNoStrByAdm("515")
ClassMethod GetPrescNoStrByAdm(EpisodeID As %String) As %String
{
	s PrescNoStr=""
	Q:EpisodeID="" PrescNoStr
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	Q:OrderRowid="" PrescNoStr
	s ChildSub=0 for {
		s ChildSub=$o(^OEORD(OrderRowid,"I",ChildSub))
		Q:ChildSub=""
		s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
		continue:ARCIMRowid=""
		s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
		continue:DrugFlag'="Y"
		s ItemStat=""
		s ItemStatDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
		if (ItemStatDr'="") s ItemStat=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
		continue:(ItemStat'="V")&&(ItemStat'="E")
		s PrescNo=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",14)
		continue:PrescNo=""
		s PrescStatus=+(##class(web.DHCDocHLYYHZYY).CheckBeforeUse(EpisodeID,"",PrescNo))
		b	;PrescStatus
		continue:(PrescStatus'="-2")&&(PrescStatus'="-11")&&(PrescStatus'="11")
		if (PrescNoStr="") s PrescNoStr=PrescNo
		else  s PrescNoStr=PrescNoStr_"^"_PrescNo
	}
	Q PrescNoStr
}

}
