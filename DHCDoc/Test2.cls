Class DHCDoc.Test2 Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock ]
{

/// w ##class(DHCDoc.Test2).Test21()
ClassMethod Test21()
{
	s Queno=0
	if (Queno="0")
	{
		s Queno=12
	}
	q Queno
}

/// renyx 根据医嘱项 用法，皮试用法，以及标本判断绑定医嘱是否已经审核
/// output: 0 所有医嘱已经确认，否则有未审核的医
/// w ##class(web.DHCDocOrderCommon).CheckBinDingItemMastByOrder
ClassMethod CheckBinDingItemMastByOrder(AdmId As %String, ARCItmRowid As %String, LocId As %String, PriorRowid As %String = "", InstrRowId As %String = "", ActionRowid As %String = "", SpecCode As %String = "") [ ProcedureBlock = 1 ]
{
	s ^TempRen("CheckBinDingItemMastByOrder")=$lb(AdmId , ARCItmRowid , LocId , PriorRowid , InstrRowId , ActionRowid , SpecCode)
	/*Set InstrRowId=$p(OrdItem,"^",17)
	Set ActionRowid=$p(OrdItem,"^",24)
	Set PriorRowid=$p(OrdItem,"^",3)
	s SpecCode=$p(OrdItem,"^",28)
	//s SpecCodeDr=$p(OrdItem,"^",28)
	//s SpecCode=$lg($g(^dbo.BTSpecimenD(SpecCodeDr)),2)
	<Data name="ARCIM_AuditFlag"><Delimiter>"^"</Delimiter><Node>9</Node><Piece>41</Piece></Data>*/
	q:(AdmId="")||(ARCItmRowid="") 0
	Set ItemCatDR=$p($g(^ARCIM(+ARCItmRowid,$p(ARCItmRowid,"||",2),1)),"^",10)
	q:ItemCatDR="" 0
	s ItemAuditFlag=$p($g(^ARCIM(+ARCItmRowid,$p(ARCItmRowid,"||",2),9)),"^",41)
	Set OrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
	if (OrderType'="R")&&(ItemAuditFlag'="Y"){
		q ""_$p($g(^ARCIM(+ARCItmRowid,$p(ARCItmRowid,"||",2),1)),"^",2)
	}
	s AdmType=$P($g(^PAADM(AdmId)),"^",2)
	Set HospitalRowid=$p($g(^CTLOC(LocId)),"^",22)
	s AddOrdItemStr=""
	;皮试绑定
	d GetOtherItem 
	;用法绑定
	d GetAppendOrdItem
	;子类绑定
	d GetCatItmAddItem
	;医嘱项绑定
	d GetItmAddItem
	;标本绑定
	d GetLabOrdUsedPlanItem
	s RetStr=0
	for k=1:1:$L(AddOrdItemStr,"^") {
 		Set myARCIMRowid=$p(AddOrdItemStr,"^",k)
 		continue:myARCIMRowid=""
		Set myItemCatDR=$p($g(^ARCIM(+myARCIMRowid,$p(myARCIMRowid,"||",2),1)),"^",10)
		continue:myItemCatDR=""
		s myItemAuditFlag=$p($g(^ARCIM(+myARCIMRowid,$p(myARCIMRowid,"||",2),9)),"^",41)
		Set myOrderType=$P($g(^ARC("IC",myItemCatDR)),"^",7)
		if (myOrderType'="R")&&(myItemAuditFlag'="Y"){
			if (RetStr="0"){
				s RetStr=""_$p($g(^ARCIM(+myARCIMRowid,$p(myARCIMRowid,"||",2),1)),"^",2)  ;_"的绑定医嘱"
			}else{
				
				s RetStr=RetStr_"; "_$p($g(^ARCIM(+myARCIMRowid,$p(myARCIMRowid,"||",2),1)),"^",2)
			}
			q
		}
	}
	q RetStr
GetOtherItem
	if (ActionRowid'="")&&(ActionRowid'="undefined"){
		Set ACTIRowid=0
		For {
			s ACTIRowid=$O(^OEC("ACT",ActionRowid,"Item",ACTIRowid)) q:ACTIRowid=""
			s ACTIARCIMDR=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",1)
			;s ACTIQty=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",2)
			s ACTInstrDr=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",3)
			if (InstrRowId'=ACTInstrDr)&&(ACTInstrDr'="") continue
			i AddOrdItemStr="" {
				s AddOrdItemStr=ACTIARCIMDR
			}else{
				s AddOrdItemStr=AddOrdItemStr_"^"_ACTIARCIMDR
			}
		}
	}
	q 
GetAppendOrdItem
	Set ExcluedePriorStr=$g(^DHCDocConfig("IInstrAutoLinkOrdExcludePrior")) //不进行绑定的医嘱类型
	Set CFUseHospSepInstrArcim=$$getconfignode^DHCDocConfig("UseHospSepInstrArcim")
	if CFUseHospSepInstrArcim=1 Set CFInstrRowId=InstrRowId_"||"_HospitalRowid
	e  s CFInstrRowId=InstrRowId
	s AppendItemStr=""
	if $g(InstrRowId)'="" {
	    if ("^"_ExcluedePriorStr_"^")'[("^"_PriorRowid_"^"){
			if AdmType="I" {
				Set AppendItemStr=$$getconfignode1^DHCDocConfig("InstrIPArcim",CFInstrRowId)
			}else{
				Set AppendItemStr=$$getconfignode1^DHCDocConfig("InstrArcim",CFInstrRowId)
			}
		}
	}
	for j=1:1:$L(AppendItemStr,"^") {
		;s SubSeqNo=SubSeqNo+1
 		Set AppendItemNod=$p(AppendItemStr,"^",j)
		Set ARCIMRowid=$P(AppendItemNod,"!",1)
		;continue:("^"_PageLinkOrdStr_"^")[("^"_ARCIMRowid_"^")&&(PageLinkOrdStr'="")
		i AppendItemStr="" {
			s AppendItemStr=ARCIMRowid
		}else{
			s AppendItemStr=AppendItemStr_"^"_ARCIMRowid
		}
	}
	s ArcimWardInfo=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(AdmId,ARCItmRowid,InstrRowId,"1")
	for j=1:1:$L(ArcimWardInfo,$C(2)) {
		s OneArcimWardInfo=$P(ArcimWardInfo,$C(2),j)
		s AddArcimItem=$P(OneArcimWardInfo,"^",1)
		//1:按天,2:按次
		s ExecType=$P(OneArcimWardInfo,"^",2)
		continue:AddArcimItem=""
		s SingleNotFee=$P(OneArcimWardInfo,"^",6)
		s NotLinkPriorStr=$P(OneArcimWardInfo,"^",9)
		if (("_"_NotLinkPriorStr_"_")[("_"_PriorRowid_"_")) {
			continue
		}
		i AppendItemStr="" {
			s AppendItemStr=AddArcimItem
		}else{
			s AppendItemStr=AppendItemStr_"^"_AddArcimItem
		}
	}
	if AddOrdItemStr=""{
		s AddOrdItemStr=AppendItemStr
	}else{
		s AddOrdItemStr=AddOrdItemStr_"^"_AppendItemStr
	}
	q
GetCatItmAddItem
	s AppendItemStr=##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem(ItemCatDR,LocId)
	for j=1:1:$L(AppendItemStr,"^") {
		//Set SubSeqNo=SubSeqNo+1
		Set AddItem=$P(AppendItemStr,"^",j)
		if AddOrdItemStr=""{
			s AddOrdItemStr=AddItem
		}else{
			s AddOrdItemStr=AddOrdItemStr_"^"_AddItem
		}
	}
	q
GetItmAddItem
	s AppendItemStr=##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem(ARCItmRowid,LocId)
	for j=1:1:$L(AppendItemStr,"^") {
		;Set SubSeqNo=SubSeqNo+1
		Set AddItem=$P(AppendItemStr,"^",j)
		if AddOrdItemStr=""{
			s AddOrdItemStr=AddItem
		}else{
			s AddOrdItemStr=AddOrdItemStr_"^"_AddItem
		}
	}
	q
GetLabOrdUsedPlanItem
	k CheckLabOrdUsedPlanStock
	//d ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).GetLabOrdUsedPlanArr(AdmId,.CheckLabOrdUsedPlanStock)
	Q:'$d(CheckLabOrdUsedPlanStock)
	q:(SpecCode="")||(SpecCode="undefined")
	s CFBaseContainer=$$getconfignode^DHCDocConfig("BaseContainer")
	s speccode=SpecCode
	s container=$$GetContainer^DHCDocOrderCommonNew(ARCItmRowid,"LABDATA",speccode)
	;开单科室
	s OEORIUserDepartmentDR=LocId ;$p(^OEORD(OrderRowId,"I",OrderChild,7),"^",2)
	s OrdUsedPlanId=""
	s planlab=0 for {
		s planlab=$O(CheckLabOrdUsedPlanStock(planlab)) 
		Q:planlab=""
		s planData=$g(CheckLabOrdUsedPlanStock(planlab))
		s planLimitLocStr=$p(planData,$C(1),1)
		s planLimitOrdStr=$p(planData,$C(1),2)
		continue:("^"_planLimitLocStr_"^")'[("^"_LocId_"^")
		continue:(planLimitOrdStr'="")&&(("^"_planLimitOrdStr_"^")'[("^"_ARCItmRowid_"^"))
		if (("^"_planLimitOrdStr_"^")[("^"_ARCItmRowid_"^")) {
			s OrdUsedPlanId=planlab
			Q
		}
		s OrdUsedPlanId=planlab
	}
	q:OrdUsedPlanId=""
	s BloodTypeCode=""
	if (CFBaseContainer=1) {
		s BloodTypeCode=container
	}else{
		s BloodTypeCode=speccode
	}
	s BloodFlag="" //取血类型
	s ConBloodTypeId=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_OrdUsedPlanId," "_BloodTypeCode,""))
	if (ConBloodTypeId'="") {
		s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(ConBloodTypeId),3)
		if (BloodFlag'="") {
			s BloodFlagActive=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),4)
			i BloodFlagActive'="Y" s BloodFlag=""
		}				
	}
	s OutInfo=""
	if (BloodFlag="") {
		// 按该方案容器/标本绑定的医嘱进行绑定
		s BindOrdFeeId=0 
		for {
			s BindOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," "_BloodTypeCode,BindOrdFeeId))
			Q:BindOrdFeeId=""
			s ARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindOrdFeeId),2)
			if AddOrdItemStr=""{
				s AddOrdItemStr=ARCIMRowid
			}else{
				s AddOrdItemStr=AddOrdItemStr_"^"_ARCIMRowid
			}
		}
	}else{
		Set PriorRowid=$O(^OECPR(0,"Code","NORM",0))
		s CFAlertAddBoodFeeItem=$$getconfignode^DHCDocConfig("AlertAddBoodFeeItem")
		q:CFAlertAddBoodFeeItem=1
		// 方案取血类型维护的费用
		s BindBloodOrdFeeId=0 
		for {
			s BindBloodOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," BLOODTYPE_"_BloodFlag,BindBloodOrdFeeId))
			Q:BindBloodOrdFeeId=""
			s ARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),2)
			if AddOrdItemStr=""{
				s AddOrdItemStr=ARCIMRowid
			}else{
				s AddOrdItemStr=AddOrdItemStr_"^"_ARCIMRowid
			}
		}
	}
	q
}

/// created: renyx
/// desc:检验医嘱加收材料的判断
/// output: 0成功 否则失败
/// w ##Class(web.DHCAPPExaReport).CheckLabOrdUsedPlanStock("80","4325||1","16","99")
ClassMethod CheckLabOrdUsedPlanStock(AdmId As %String, ARCItmRowid As %String, LocDr As %String, RecLocDr As %String, SpecCode As %String)
{
	k CheckLabOrdUsedPlanStock
	d ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).GetLabOrdUsedPlanArr(AdmId,.CheckLabOrdUsedPlanStock)
	Q:'$d(CheckLabOrdUsedPlanStock) 0
	s CFBaseContainer=$$getconfignode^DHCDocConfig("BaseContainer")
	s speccode=SpecCode
	s container=$$GetContainer^DHCDocOrderCommonNew(ARCItmRowid,"LABDATA",speccode)
	;开单科室
	s OEORIUserDepartmentDR=LocDr ;$p(^OEORD(OrderRowId,"I",OrderChild,7),"^",2)
	s OrdUsedPlanId=""
	s planlab=0 for {
		s planlab=$O(CheckLabOrdUsedPlanStock(planlab)) 
		Q:planlab=""
		s planData=$g(CheckLabOrdUsedPlanStock(planlab))
		s planLimitLocStr=$p(planData,$C(1),1)
		s planLimitOrdStr=$p(planData,$C(1),2)
		continue:("^"_planLimitLocStr_"^")'[("^"_LocDr_"^")
		continue:(planLimitOrdStr'="")&&(("^"_planLimitOrdStr_"^")'[("^"_ARCItmRowid_"^"))
		if (("^"_planLimitOrdStr_"^")[("^"_ARCItmRowid_"^")) {
			s OrdUsedPlanId=planlab
			Q
		}
		s OrdUsedPlanId=planlab
	}
	q:OrdUsedPlanId="" 0
	s BloodTypeCode=""
	if (CFBaseContainer=1) {
		s BloodTypeCode=container
	}else{
		s BloodTypeCode=speccode
	}
	s BloodFlag="" //取血类型
	s ConBloodTypeId=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_OrdUsedPlanId," "_BloodTypeCode,""))
	if (ConBloodTypeId'="") {
		s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(ConBloodTypeId),3)
		if (BloodFlag'="") {
			s BloodFlagActive=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),4)
			i BloodFlagActive'="Y" s BloodFlag=""
		}				
	}
	s OutInfo=""
	if (BloodFlag="") {
		// 按该方案容器/标本绑定的医嘱进行绑定
		s BindOrdFeeId=0 for {
			s BindOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," "_BloodTypeCode,BindOrdFeeId))
			Q:BindOrdFeeId=""
			s ARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindOrdFeeId),2)
			;Set ReplaceArcimRowId=##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).GetReplaceItm(AdmId,ARCIMRowid)
			;if (ReplaceArcimRowId'="") s ARCIMRowid=ReplaceArcimRowId
			s CheckStockQtyFlag=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8),"^",11)
			continue:CheckStockQtyFlag="Y" ;renyx 无库存医嘱则不进行库存验证
			s PackQty=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindOrdFeeId),3)
			;d InsertLabLinkOrder("SP")
			s OrderAlertStockQty=##Class(web.DHCDocOrderCommon).GetARCIMAlertStockQty(ARCIMRowid)
			s StockQtyStr = ##Class(web.DHCDocOrderCommon).GetStockQty( RecLocDr, ARCIMRowid)
			s StockQty = $P(StockQtyStr, "^", 1)
            ;s PackedQty = $P(StockQtyStr, "^", 2)
            s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
            s LogicQty = StockQty - PackQty
            if (OrderAlertStockQty > LogicQty)&&(INCIRowid'="") {
	            s OrderName=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
	            if (OutInfo=""){
                s OutInfo="-1^" _OrderName _"医嘱库存不足,库存量为:"_StockQty
	            }else{
		            s OutInfo=OutInfo_"    "_OrderName _"医嘱库存不足,库存量为:"_StockQty
	            }
                //q
            }
		}
	}else{
		;临时医嘱
		Set PriorRowid=$O(^OECPR(0,"Code","NORM",0))
		s CFAlertAddBoodFeeItem=$$getconfignode^DHCDocConfig("AlertAddBoodFeeItem")
		q:CFAlertAddBoodFeeItem=1 0
		// 方案取血类型维护的费用
		s BindBloodOrdFeeId=0 for {
			s BindBloodOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," BLOODTYPE_"_BloodFlag,BindBloodOrdFeeId))
			Q:BindBloodOrdFeeId=""
			s ARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),2)
			;Set ReplaceArcimRowId=##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).GetReplaceItm(AdmId,ARCIMRowid)
			;if (ReplaceArcimRowId'="") s ARCIMRowid=ReplaceArcimRowId
			s CheckStockQtyFlag=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8),"^",11)
			continue:CheckStockQtyFlag="Y" ;renyx 无库存医嘱则不进行库存验证
			
			s PackQty=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),3)
			s OrderAlertStockQty=##Class(web.DHCDocOrderCommon).GetARCIMAlertStockQty(ARCIMRowid)
			s StockQtyStr = ##Class(web.DHCDocOrderCommon).GetStockQty( RecLocDr, ARCIMRowid)
			s StockQty = $P(StockQtyStr, "^", 1)
            ;s PackedQty = $P(StockQtyStr, "^", 2)
            s LogicQty = StockQty - PackQty
            s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
            if (OrderAlertStockQty > LogicQty)&&(INCIRowid'="") {
	            s OrderName=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
                //s OutInfo="-1^" _OrderName _"或邦定的医嘱库存不足,库存量为:"_LogicQty
                if (OutInfo=""){
                	s OutInfo="-1^" _OrderName _"医嘱库存不足,库存量为:"_StockQty
	            }else{
		            s OutInfo=OutInfo_"    "_OrderName _"医嘱库存不足,库存量为:"_StockQty
	            }
                //q
            }
			;是否重复加收
			;s IsRepeatAdd=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),5)
		}
	}
	
	k CheckLabOrdUsedPlanStock
	q OutInfo
}

/// w ##class(DHCDoc.Test2).TestExcel()
ClassMethod TestExcel()
{
	s file=##class(%File).%New("d:\ceshi.xls")
	d file.Open("WSN")
	d file.WriteLine("姓名"_$c(9)_"年龄"_$c(9)_"性别"_$c(9)_"民族")
	f i=1:1:200{
		s ExeclLin="123"_$c(9)_"1"_$c(9)_"2"_$c(9)_"3"
		d file.WriteLine(ExeclLin)
		
	}
	d file.Close()
	w "ssssss"_file.Size
	s Stream=##class(%Stream.FileCharacter).%New()
	s sc=Stream.LinkToFile("d:\ceshi.xls")
	while 'Stream.AtEnd{
		s line=Stream.ReadLine()
		s name=$p(line,$c(9),1)
		s age=$p(line,$c(9),2)
		s sex=$p(line,$c(9),3)
		s nation=$p(line,$c(9),4)
		w name_"^"_age_"^"_sex_"^"_nation
		
	}
	w "123"
	q "222"
}

/// w ##class(DHCDoc.Test2).GetQueueList("1","2","3")
ClassMethod GetQueueList(DoctorId As %String, DepartmentId As %String, RoomId As %String, ByRef DocQueueList)
{
	s InputObj={}
	s InputObj.DoctorId=DoctorId		;医生id		String	50	是
	s InputObj.DepartmentId=DepartmentId		;	科室id		string	50	是
	s InputObj.RoomId=RoomId		;	诊室		String	50	否
	s InputObj.StateId="0,1,2,5,6"		;	状态值	值为0,1,2,5,6（注意标点是逗号）	String		是
	s InputObj.QueueType="7"		;	队列类型	值为 1：在指定科室坐诊的指定医生的患者队列数据值为2：在指定科室下的指定诊室的患者队列数据值为3：查指定科室下的普通号患者队列数据值为 7：在指定科室坐诊的指定医生指定状态的患者队列数据string		是
	s InputObj.IsAll="true"		;	是否查全部	true:查当天全部有效数据false:根据QueueType值查询，具体说明请看QueueType参数Json格式布尔类型的值为小写，分别为：true,false	Bool		是
	s InputJson=InputObj.%ToJSON()
	s RetStr="0"
	s OutPutJson=""
	if (OutPutJson["_") s jsonStr=$tr(OutPutJson,"_","")
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(OutPutJson)
	if (jsonObject.IsSuccess="true"){
		s JsonCount=0
		Set key=""
		s iter=jsonObject.%GetIterator()
		while iter.%GetNext(.key,.value){
			if $IsObject(value){
				s mykey=""
				s myiter=value.%GetIterator()
				while myiter.%GetNext(.mykey,.myvalue){
					if $IsObject(myvalue){
						s JsonCount=JsonCount+1
						s EpisodeID=myvalue.SerialNumber		;患者流水号，每条就诊记录的唯一号码	患者每条就诊记录的唯一号码	string
						s patiinfoid=myvalue.patiinfoid		;	患者唯一号		string
						s PAPMIName=myvalue.patiinfoname		;	患者姓名		string
						s stateid=myvalue.stateid		;	患者排队状态	0：未报到，1：排队中，2：已过号，5：正在就诊，6：诊结	int
						s queueno=myvalue.queueno		;	排队号	代表患者的实际位置，需要大于0的整数	string
						s emergencyLevel=myvalue.emergencyLevel		;	队列优先级	一般为0，越小优先级越高	int
						s departmentid=myvalue.departmentid		;	患者挂号的科室id		string
						s departmentname=myvalue.departmentname		;	患者挂号的科室名称		string
						s roomid=myvalue.roomid		;	诊室id		string
						s roomname=myvalue.roomname		;	诊室名		string
						s doctorid=myvalue.doctorid		;	医生id		string
						s doctorname=myvalue.doctorname		;	医生		string
						s validdate=myvalue.validdate		;		预约患者则为预约时间，现场挂号患者那么则为挂号时间	string
						s shiftno=myvalue.shiftno		;	患者班次	上午或下午或晚上	string
						s appointmenttime=myvalue.appointmenttime		;	患者预约时间		string
						s latesttime=myvalue.latesttime		;	最后呼叫时间		string
						s treatmentendtime=myvalue.treatmentendtime		;	诊结时间		string
						s CheckInTime=myvalue.CheckInTime		;	报到时间		string
						s DocQueueList($j,JsonCount)=$lb(SerialNumber,patiinfoid,patiinfoname,stateid,queueno,emergencyLevel,
							departmentid,departmentname,roomid,roomname,doctorid,doctorname,validdate,shiftno,appointmenttime,
							latesttime,treatmentendtime,CheckInTime)
						s DocQueueList($j,JsonCount)=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB
						,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital
						,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag
						,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate
						,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode
						,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime
						,RegAdmSource)
					}
				}
			}
		}
	}else{
		s RetStr="1^"_jsonObject.Msg
	}
	q RetStr
}

/// w ##class(DHCDoc.Test2).Test2()
ClassMethod Test2(jsonStr As %String = "")
{
	set:jsonStr="" jsonStr = "{""DocTitle"":""AAA"",""PatientId"":[{""_aaa"":1,""cd"":""cc""},{""_aaa"":2,""cd"":""dd""}],""msg"":""aaa""}"
	;Set jsonStr="{""Doc_Title"":""AAA"",""Patient_Id"":[5,{""AA"":""CC"",""BB"":56,""CC"":[{""123"":233}]},""77"",8],""Hospital_Id"":{""aaa"":1,""666"":{""12"":12,""13"":13,""14"":[1,""22"",3,4]},""bbb"":2},""Doc_Content"":444,""222"":444}"
	
	//%DynamicAbstractObject
	if (jsonStr["_") s jsonStr=$tr(jsonStr,"_","")
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(jsonStr)
	Set jsonResult=##class(DHCHAI.RMES.AnalysisSrv).ChangeJsonObject(jsonObject)
	b 
	Set key=""
	s iter=jsonObject.%GetIterator()
	while iter.%GetNext(.key,.value){
		
		if $IsObject(value){
			s myiter=value.%GetIterator()
			while myiter.%GetNext(.mykey,.myvalue){
				if $IsObject(myvalue){
					b  ;001
				}else{
				w mykey_" = "_myvalue,!
				}
			}
		} else {
			w key_" = "_value,!
		}
	}
	Quit 1
	set obj = ##class(%DynamicAbstractObject).%FromJSON(src)
	b 
	s StrJson="{""Msg"":""信息不存在,请联系管理员进行维护！"",""TList"":[{""lia"":""1"",""lie:""2""},{""lia"":""1"",""lie:""2""}]}"
	s obj=##class(%DynamicObject).%FromJSON(StrJson)
	
	s iter=obj.%GetIterator()
	while iter.%GetNext(.key,.value){
		b 
		if $IsObject(value){
			w key_"   ,"_value,!
		}else{
			w key_"   ,"_value,!
			;d Stream.Write("<"_key_">"_value_"</"_key_">")
		}
	}
	q 0
}

ClassMethod Test()
{
	try{
		s eee= ##class(web.DHCOPAdm).GetInsuBillParaByAdmID("12")
	}catch(e){
		b 
		w "12"
	}
	q "12"
}

ClassMethod GetSingnDrByOEOrdDr(OEOrdDr As %String)
{
	q:'$d(^DHCDocSignVerify(0,"OEORI",OEOrdDr)) ""
	s SVDr=$o(^DHCDocSignVerify(0,"OEORI",OEOrdDr,0))
	q:SVDr="" ""
	q:'$d(^DHCDocSignVerify(SVDr)) ""
	s SignatureDR=$p($g(^DHCDocSignVerify(SVDr)),"^",11)
	q SignatureDR
}

/// w ##Class(DHCDoc.Test2).Test1()
ClassMethod Test1()
{
	s OutPutObj={}
	s OutPutObj.outpatientNum="111"	;varchar(20)	Y	门诊号	
	s OutPutObj.recipeNum="222"	;varchar(20)	N	处方号
	s RetStr="11,22^11,22^11,22^11,22"
	s RetStr2="33,44^33,44^33,44^33,44"
	s DrugList=[]
	s NonDrugList=[]
	f i=1:1:$l(RetStr,"^"){
		s DrugObj={}
		s DrugObj.Num1=$p($p(RetStr,"^",i),",",1)
		s DrugObj.Num2=$p($p(RetStr,"^",i),",",1)
		d DrugList.%Push(DrugObj)
		s NonDrugObj={}
		s NonDrugObj.Num1=$p($p(RetStr,"^",i),",",1)
		s NonDrugObj.Num2=$p($p(RetStr,"^",i),",",1)
		d NonDrugList.%Push(DrugObj)
	}
	
	;s OutPutObj.PRESCRIPTION.NonDrug=NonDrugList
	s NodeList("DrugTr","ChildNode")="Drug"
	s NodeList("NonDrugTr","ChildNode")="NonDrug"
	;s NodeList("regScheduleInfos","HideNode")=1
	s OutPutObj.PRESCRIPTION=
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"DrugTr",.NodeList).Read(),"<DrugTr>",2),"</DrugTr>",1)_
		$p($p(##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrugTr",.NodeList).Read(),"<NonDrugTr>",2),"</NonDrugTr>",1)
	;w ##class(DHCDoc.Util.XMLParse).ObjToXML(DrugList,"Drug",.NodeList).Read(),!
	;w ##class(DHCDoc.Util.XMLParse).ObjToXML(NonDrugList,"NonDrug","").Read(),!
	q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"BODY",.NodeList).Read()
}

ClassMethod GetFrequencyCode(medFrequencyCode As %String)
{
	if medFrequencyCode="10pm"  s medFrequencyCode=79
	if medFrequencyCode="12MN"  s medFrequencyCode=79
	if medFrequencyCode="12N"   s medFrequencyCode=79
	if medFrequencyCode="2Pm"   s medFrequencyCode=79
	if medFrequencyCode="3Am"   s medFrequencyCode=79
	if medFrequencyCode="4Pm"   s medFrequencyCode=79
	if medFrequencyCode="6Am"   s medFrequencyCode=79
	if medFrequencyCode="6Pm"   s medFrequencyCode=79
	if medFrequencyCode="Bid"   s medFrequencyCode=26
	if medFrequencyCode="Bid(餐前)"  s medFrequencyCode=27
	if medFrequencyCode="Bid(餐中)"  s medFrequencyCode=79
	if medFrequencyCode="Bid(空腹)"  s medFrequencyCode=79
	if medFrequencyCode="WEEK"  s medFrequencyCode=79
	if medFrequencyCode="ONCE"  s medFrequencyCode=79
	if medFrequencyCode="Prn"   s medFrequencyCode=29
	if medFrequencyCode="Q12h"  s medFrequencyCode=30
	if medFrequencyCode="Q8h"   s medFrequencyCode=42
	if medFrequencyCode="Qd"    s medFrequencyCode=43
	if medFrequencyCode="Qd(餐前)"   s medFrequencyCode=44
	if medFrequencyCode="Qd(餐中)"   s medFrequencyCode=79
	if medFrequencyCode="Qd(空腹)" s medFrequencyCode=79
	if medFrequencyCode="Qh"    s medFrequencyCode=32
	if medFrequencyCode="Qid "  s medFrequencyCode=45
	if medFrequencyCode="Qn"    s medFrequencyCode=41
	if medFrequencyCode="Qod"   s medFrequencyCode=42
	if medFrequencyCode="Qd(餐后)"   s medFrequencyCode=79
	if medFrequencyCode="St"    s medFrequencyCode=50
	if medFrequencyCode="Tid"   s medFrequencyCode=13
	if medFrequencyCode="Tid(餐前)"  s medFrequencyCode=52
	if medFrequencyCode="Tid(餐中)"  s medFrequencyCode=79
	if medFrequencyCode="Tid(空腹)"  s medFrequencyCode=79
	if medFrequencyCode="Tid(餐后)"  s medFrequencyCode=79
	if medFrequencyCode="多次"  s medFrequencyCode=79
	if medFrequencyCode="临时"  s medFrequencyCode=80
	if medFrequencyCode="每日1次"    s medFrequencyCode=79
	if medFrequencyCode="每日2次"    s medFrequencyCode=79
	if medFrequencyCode="每日3次"    s medFrequencyCode=79
	if medFrequencyCode="每日4次"    s medFrequencyCode=79
	if medFrequencyCode="频服"  s medFrequencyCode=79
	if medFrequencyCode="睡前"  s medFrequencyCode=79
	if medFrequencyCode="晚餐后2小时"  s medFrequencyCode=79
	if medFrequencyCode="晚餐前"     s medFrequencyCode= 79     
	if medFrequencyCode="晚餐前30分钟"  s medFrequencyCode=79
	if medFrequencyCode="午餐后2小时"  s medFrequencyCode=79
	if medFrequencyCode="午餐前"     s medFrequencyCode=79
	if medFrequencyCode="午餐前30分钟"  s medFrequencyCode=79
	if medFrequencyCode="与晚餐同服"   s medFrequencyCode=79
	if medFrequencyCode="与午餐同服"   s medFrequencyCode=79
	if medFrequencyCode="与早餐同服"   s medFrequencyCode=79
	if medFrequencyCode="早餐后2小时"  s medFrequencyCode=79
	if medFrequencyCode="早餐前"     s medFrequencyCode=79
	if medFrequencyCode="早餐前30分钟"  s medFrequencyCode=79
	if medFrequencyCode="遵医嘱"    s medFrequencyCode=79
	if medFrequencyCode="Q4h"   s medFrequencyCode=33
	if medFrequencyCode="BIW"   s medFrequencyCode=22
	q medFrequencyCode
}

}
