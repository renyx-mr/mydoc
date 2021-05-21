Class DHCDoc.Renyx.DHCOEOrdItemLocal Extends %RegisteredObject
{
ClassMethod GetDischargeOrd(AdmId As %String,HospId As %String)
{
	s RetStr=""
	s Oeori=$o(^OEORD(0,"Adm",AdmId,0))
	q:Oeori="" RetStr
	s DischargeArcimStr=##Class(Nur.Interface.OutSide.Order).GetDischargeNeedArcim("dischargeNeedArcim", HospId)
	s DeathDischargeArcimStr=##Class(Nur.Interface.OutSide.Order).GetDischargeNeedArcim("deathDischargeNeedArcim", HospId)
	s CheckArcItemStr=DischargeArcimStr_"^"_DeathDischargeArcimStr
	
	for i=1:1:$l(CheckArcItemStr,"^"){
		s OneCheckArcItem=$p(CheckArcItemStr,"^",i)
		continue:OneCheckArcItem=""
		s SttDat=0
		for {
			s SttDat=$o(^OEORDi(0,"ARCIM",Oeori,OneCheckArcItem,SttDat))
			q:SttDat=""
			s Childsub=0
			for {
				s Childsub=$o(^OEORDi(0,"ARCIM",Oeori,OneCheckArcItem,SttDat,Childsub))
				q:Childsub=""
				s statcode=$$GetStatCode(Oeori_"||"_Childsub) ;防止停留时间内撤销医嘱
				continue:(statcode="U")||(statcode="D")||(statcode="C")
				//s ARCIMRowid=$p($g(^OEORD(Oeori,"I",Childsub,1)),"^",2)	;药品ID
				s ItemDesc=$p($g(^ARCIM(+OneCheckArcItem,$p(OneCheckArcItem,"||",2),1)),"^",2)
				if (RetStr="") s RetStr=ItemDesc
				else  s RetStr=RetStr_";"_ItemDesc
			}
		}
	}
	q RetStr
GetStatCode(OrderID)
	s statcode=""
	s Stat=$P($G(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1)),"^",13)
	s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
	Q statcode
}
/// input: AdmId 就诊id, oeori 医嘱id，PackQty 实际发药数量
ClassMethod UpdateOEOrdItemQty(AdmId As %String , Oeori As %String , PackQty As %String)
{
	
	s AdmType=$p(^PAADM(AdmId),"^",4)
	q:AdmType'="O" ""  ;不是门诊则退出
	s OrderRowid=+Oeori,ChildSub=$p(OrderRowid,"||",2)
	q:(OrderRowid="")||(ChildSub="")
	s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)	;药品ID
	s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
	q:OrderType'="R" "" ;不是药品则退出
	//s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)	;发药数量
	s $p(^OEORD(OrderRowid,"I",ChildSub,9),"^",4)=PackQty   修改发药数量
	q "0"
}
/// w ##class(web.DHCOEOrdItemLocal).CheckInsertArcItem
/// 判断多系统和单系统的医嘱
/// 设置检查医嘱属于单系统还是多系统，单系统医嘱不能跨“系统开多个部位”，只能选择一个系统内的一个或者多个部位；多系统医嘱不能只选择单一系统内的部位，只选择一个系统时在发送申请单时给予提示  
ClassMethod CheckInsertArcItem(mItmListData As %String, ArcItemId As %String, TraID As %String, HospId As %String)
{
	s ^TempRen("CheckInsertArcItem")=$lb(mItmListData,ArcItemId,TraID,HospId)
	;多系统医嘱  
	s MultiSystemArcim=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","MultiSystemArcim",HospId)
	;单系统医嘱
	s SingleSystemArcim=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","SingleSystemArcim",HospId)
	s InputObj=##class(%DynamicAbstractObject).%FromJSON(mItmListData)
	k PartTypeList
	s PartTypeInt=0
	for ListDataInt=0:1:(InputObj.%Size()-1){
		Set OneDataObj=InputObj.%Get(ListDataInt)
		s ItemID=OneDataObj.ItemID
		;TRA_Part_Dr->AP_Desc,TRA_Part_Dr->AP_PartNum,
		&sql(SELECT TRA_Part_Dr->AP_LastRowid,TRA_Part_Dr->AP_Hosp_Dr
			INTO :LastRowid,:HospDr
			FROM SQLUser.DHC_AppTreeLink 
			WHERE TRA_Arc_Dr=:ArcItemId AND TRA_Add_ParRef=:TraID AND TRA_Part_Dr=:ItemID)
		continue:HospDr'=HospId
		continue:LastRowid=""
		;b //s PartTypeInt=PartTypeInt+1
		if ('$d(PartTypeList(LastRowid))){
			s PartTypeInt=PartTypeInt+1
		}
		s PartTypeList(LastRowid)=LastRowid
	}
	s MyArcItemId="!"_ArcItemId_"!"
	s RetStr=""
	if (SingleSystemArcim[MyArcItemId)&&(PartTypeInt>1){
		s RetStr="1" 
	}
	if (MultiSystemArcim[MyArcItemId)&&(PartTypeInt<=1){
		s RetStr="2"
	}
	q RetStr
}

/// CoverMainIns=$p($g(^OEORD(OrderRowid,"I",SubOrd,3)),"^",3)
ClassMethod UpdateCoverMainIns(OrdItemId As %String, UserId As %String)
{
	s MyCoverMainIns=""
	ts
	try{
		s CoverMainIns=$p($g(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3)),"^",3)
		
		s:CoverMainIns="N" MyCoverMainIns="Y"
		s:CoverMainIns="Y" MyCoverMainIns="N"
		s:CoverMainIns="" MyCoverMainIns="Y"
		s $p(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3),"^",3)=MyCoverMainIns
		s InsertDesc=$P($G(^SSU("SSUSR",UserId)),"^",2)_"在"_$zd(+$h,3)_" "_$zt($p($h,",",2),1)_"将医保标志由"_CoverMainIns_"改为"_MyCoverMainIns
		;添加一般日志的记录
		d ##class(DHCDoc.Log.Common).General("Insert","web.DHCOEOrdItemLocal","UpdateCoverMainIns","修改医嘱医保标志",OrdItemId,InsertDesc)
	
	}catch exp  {
		tro
		s MyCoverMainIns=""
	}
	tc
	q MyCoverMainIns
}
	///获取皮试用法
///s SkinTestInstrStr=##class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",CurHospId)
/// 判断是否有皮试医嘱
/// w ##class(web.DHCOEOrdItemLocal).CheckSkinTestByAdm
ClassMethod CheckSkinTestByAdm(AdmId As %String, ArcItemId As %String, HospId As %String)
{
	//s ^tempRen("CheckSkinTestByAdm")=$lb(AdmId , ArcItemId , HospId)
	s RetStr="0"
	s OrderId=$o(^OEORD(0,"Adm",AdmId,0))
	
	q:OrderId="" RetStr
	s OrdDate=0
	s SkinTestInstrStr=##class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",HospId)
	for{
		s OrdDate=$o(^OEORDi(0,"ARCIM",OrderId,ArcItemId,OrdDate))
		q:(OrdDate="")||(RetStr="1")
		s OrdSub=0
		for {
			s OrdSub=$o(^OEORDi(0,"ARCIM",OrderId,ArcItemId,OrdDate,OrdSub))
			q:(OrdSub="")||(RetStr="1")
			s ItemStatId=$p($g(^OEORD(OrderId,"I",OrdSub,1)),"^",13)
			if (ItemStatId'=""){
				s StatCode=$p($g(^OEC("OSTAT",ItemStatId)),"^",1)
				//过滤已经作废  停止   撤销的
				continue:(StatCode="U")||(StatCode="D")||(StatCode="C")
			}
			s InstrId=$p($g(^OEORD(OrderId,"I",OrdSub,2)),"^",7)
			s SkinTest=$p($g(^OEORD(OrderId,"I",OrdSub,5)),"^",2)
			continue:("^"_SkinTestInstrStr_"^")'[("^"_InstrId_"^") //&&(SkinTest="N")
			s RetStr="1"
		}
	}
	q RetStr
	;^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
}
/// w ##class(web.DHCOEOrdItemLocal).GetArcItemManufacturer("404||1")
/// 获取医嘱项的厂商  
ClassMethod GetArcItemManufacturer(ArcItemId As %String)
{
	s INFORowId=$o(^INCI(0,"ARCIM_DR",+ArcItemId,0))
	q:INFORowId="" ""
	s ManufacturerDr=$p($g(^DHCITMINFO(INFORowId)),"^",48)
	q:ManufacturerDr="" ""
	s Manufacturer=$p($g(^PHMNF(ManufacturerDr)),"^",2)
	q Manufacturer
	s DrgMastId=$p($g(^ARCIM(+ArcItemId,$p(ArcItemId,"||",2),1)),"^",12)
	
	//s ManufacturerDr=$p($g(^PHCD(+DrgMastId,"DF",$p(DrgMastId,"||",2),2)),"^",4)
	
	s ManufacturerDr=$p($g(^PHCD(+DrgMastId,2)),"^",4)
	
	s Manufacturer=$p($g(^PHMNF(ManufacturerDr)),"^",2)
	q Manufacturer
}

/// w ##class(web.DHCOEOrdItemLocal).CheckSkinTestByArcItem("404||1")
/// 判断该医嘱是不是皮试配置医嘱  
ClassMethod CheckSkinTestByArcItem(ArcItemDr As %String)
{
	s ^tempren("ArcItemDr")=ArcItemDr
	s PHCSkinTestId=$o(^CF.PHA.IN.SkinTesti("ARCIM",ArcItemDr,0))
	q:PHCSkinTestId="" ""
	s StartDate=$p($g(^CF.PHA.IN.SkinTest(PHCSkinTestId)),"^",8)
	s EndDate=$p($g(^CF.PHA.IN.SkinTest(PHCSkinTestId)),"^",9)
	q:(+StartDate>+$h)||((EndDate'="")&&(+EndDate<+$h)) ""
	q "1"
}

ClassMethod test()
{
	//s ParamArr("OrderTreatment")=""
    s OrderTreatment=##class(web.DHCOEOrdItemLocal).CheckSkinTestByArcItem(OrderARCIMRowid)
    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
    if (PAAdmType="O")&&(OrderTreatment="1")&&($g(ParamArr("OrderType"))="R"){
	    s CallBackFunParams=OrderName_"是可皮试医嘱，请确认是否用做治疗！！！"
		//s CallBackFunStr=..GetCallBackFunStr(CallBackFunStr,"OrderTreatment",CallBackFunParams)
    }
	if (OrderDirectEntryAuth="N"){
		q OutInfo
	}
}

/// 判断是否有国家重点监控药品  
/// desc   判断当天是是否有有效的执行记录    
/// 0没有  ，1 有
/// w ##class(web.DHCOEOrdItemLocal).CheckBeforSaveOrdItem(3006495,"13875||1")
ClassMethod CheckBeforSaveOrdItem(AdmDr As %String, ArcItemDr As %String)
{
	//s enddate=$p(^OEORD(ord,"I",itm,9),"^",9)  ;停止日期
	
	//s endtime=$p(^OEORD(ord,"I",itm,9),"^",10) ; 停止时间  
	s CheckArcItemDrStr="^5305||1^6661||1^13661||1^13875||1^13938||1^14241||1^14386||1^14393||1^14492||1^14544||1^14587||1^14646||1^14825||1^16336||1^16589||1^16657||1^14699||1^"
	s ArcItemDr="^"_ArcItemDr_"^"
	q:CheckArcItemDrStr'[ArcItemDr 0
	s OrderDr=$o(^OEORD(0,"Adm",AdmDr,0))
	q:OrderDr="" 0
	s CheckFlag=0
	for i=1:1:$l(CheckArcItemDrStr,"^"){
		s OneArcItemDr=$p(CheckArcItemDrStr,"^",i)
		continue:OneArcItemDr=""
		s OrdStartDate=0
		for {
			s OrdStartDate=$o(^OEORDi(0,"ARCIM",OrderDr,OneArcItemDr,OrdStartDate))
			q:OrdStartDate=""
			s OrdItemSub=0
			for {
				s OrdItemSub=$o(^OEORDi(0,"ARCIM",OrderDr,OneArcItemDr,OrdStartDate,OrdItemSub))
				q:OrdItemSub=""
				s OEORIXDate=$p($g(^OEORD(OrderDr,"I",OrdItemSub,3)),"^",34)
				continue:((OEORIXDate'="")&&(OEORIXDate<+$h))
				s DateTime=$p($h,",",2)
				s OEORIXTime=$p($g(^OEORD(OrderDr,"I",OrdItemSub,2)),"^",15)
				///continue:((OEORIXTime'="")&&(DateTime>OEORIXTime))
				//s maxExDate = $o(^OEORDi(0,"OrdItem",oeori,oeorisub,""),-1)
				s tmpdate=+$h-1
				for {
					s tmpdate=$o(^OEORDi(0,"OrdItem",OrderDr,OrdItemSub,tmpdate))
					q:tmpdate=""
					set xSub=0 
					for  {
						set xSub = $o(^OEORDi(0,"OrdItem",OrderDr,OrdItemSub,tmpdate,xSub)) 
						Quit:xSub=""
						//s ExecId=oeori_"||"_oeorisub_"||"_xSub
						Set str = $g(^OEORD(OrderDr,"I",OrdItemSub,"X",xSub))
						set ExecStateDR = $p(str,"^",16)
						;Continue:ExecStateDR=""
						s ExecStateCode=""
						Set:ExecStateDR'="" ExecStateCode = $p(^OEC("STAT",ExecStateDR),"^",1)
						continue:(ExecStateCode="U")!(ExecStateCode="C")!(ExecStateCode="D")
						//b ;l12
						continue:(tmpdate<+$h)
						set tmptime = $p(str,"^",2)
						//continue:(tmpdate=+$h)&&(tmptime<DateTime) 
						//w $zt(tmptime,1) 
						s CheckFlag=1
					}
				}
				;w OrderDr_"||"_OrdItemSub,!
				//s CheckFlag=1
			}
		}
	}
	q CheckFlag
}

/// input 医嘱id ， 接收科室id
/// return  0成功，否则失败
ClassMethod UpdateOEOrdItemRecLoc(OrdItemDr As %String, UserDr As %String, LocDr As %String)
{
	q:'$d(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2))) "0"
	ts
	s OrdItemObj=##class(User.OEOrdItem).%OpenId(OrdItemDr)
	if $IsObject(OrdItemObj){
		d OrdItemObj.OEORIUserUpdateSetObjectId(UserDr)
		s OrdItemObj.OEORIUpdateDate=+$h
		s OrdItemObj.OEORIUpdateTime=$p($h,",",2)
		d OrdItemObj.OEORIRecDepDRSetObjectId(LocDr)
	}
	s sc=OrdItemObj.%Save()
	if $$$ISERR(sc){
		tro 
		q "-1"
	}
	tc
	q 0
}

/// input 医嘱id
/// return 默认标本代码,$c(3),标本名称,$c(3),容器代码,$c(3),容器名称   (多个以$c(2)分割)
ClassMethod GetLabSpecLocal(OrdItemDr As %String)
{
	//
	s ArcItemDr=$p($g(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2),1)),"^",2)
	q:ArcItemDr="" ""
	q ##class(web.DHCDocOrderCommon).GetLabSpec(ArcItemDr)
}

/// input: 医嘱id ， 标本代码^容器代码 ， 用户id ， 医院id
/// return 0成功，否则失败
ClassMethod UpdateOrdItemLab(OrdItemDr As %String, LabSpecStr As %String, UserId As %String, HospitalId As %String = "")
{
	q:'$d(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2),"SPEC")) "0"
	s SpecChildsub=$o(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2),"SPEC",0))
	q:SpecChildsub="0"
	//s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode("")
	s:HospitalId="" HospitalId=%session.Get("LOGON.HOSPID")
	q:$o(^dbo.BTTestSetI("IndexCode",HospitalId," "_$p(LabSpecStr,"^",1),0))="" "-1"
	q:$o(^dbo.BTContainerI("IndexCode",HospitalId,$p(LabSpecStr,"^",2),0))="" "-1"
	s ARRowID=""
	&sql(SELECT AR_RowID INTO :ARRowID FROM SQlUser.DHC_AppRepArc WHERE AR_OrdItem=:OrdItemDr)
	q:ARRowID="" "0"
	TS 
	s AppRepArcObj=##class(User.DHCAppRepArc).%OpenId(ARRowID)
	if $IsObject(AppRepArcObj) {
		s AppRepArcObj.ARSpecCode=$p(LabSpecStr,"^",1)
	}
	s sc= AppRepArcObj.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -1
	}
	s OrdSpecimenObj=##class(User.OEOrdSpecimen).%OpenId(OrdItemDr_"||"_SpecChildsub)
	if $IsObject(OrdSpecimenObj) {
		s OrdSpecimenObj.SPECCode=$p(LabSpecStr,"^",1)
		s OrdSpecimenObj.SPECContainer=$p(LabSpecStr,"^",2)
	}
	s sc= OrdSpecimenObj.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -1
	}
	
	s OrdItemObj=##class(User.OEOrdItem).%OpenId(OrdItemDr)
	if $IsObject(OrdItemObj) {
		d OrdItemObj.OEORIUserUpdateSetObjectId(UserId)
		s OrdItemObj.OEORIUpdateDate=+$h
		s OrdItemObj.OEORIUpdateTime=$p($h,",",2)
	}
	s sc= OrdItemObj.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -1
	}
	TC 
	q 0
}

}
