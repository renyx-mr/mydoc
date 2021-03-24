Class DHCDoc.Renyx.DHCOEOrdItemLocal Extends %RegisteredObject
{
	///获取皮试用法
///s SkinTestInstrStr=##class(web.DHCDocConfig).GetConfigNodeNew("SkinTestInstr",CurHospId)

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
