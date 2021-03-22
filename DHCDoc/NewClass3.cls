Class DHCDoc.NewClass3 Extends %RegisteredObject
{

ClassMethod CheckAllergyInfoJson(OldJsonValue As %String, NewJsonValue As %String)
{
	s RetStr=""
	if (OldJsonValue'="")&&(OldJsonValue'=""){
		s OldJsonObj=##class(%DynamicAbstractObject).%FromJSON(OldJsonValue)
		s NewJsonObj=##class(%DynamicAbstractObject).%FromJSON(NewJsonValue)
		/*s AllergyObj.MRCATDesc=MRCATDesc   						//过敏分类描述
			s AllergyObj.CategoryRowId=CategoryRowId 				//过敏分类Id
			s AllergyObj.TagCode=TagCode 						//过敏类型"I","P"等
			s AllergyObj.MRCATTagDescription=MRCATTagDescription    //过敏类型描述
			s AllergyObj.AllergenRowId=AllergenRowId 				//过敏源ID
			s AllergyObj.ALGDescCT=ALGDescCT 						//过敏源描述
			s AllergyObj.ALGItem=ALGItem 							//过敏项目描述
			s AllergyObj.ALGItemRowId=ALGItemRowId 					//过敏项目ID				
			s AllergyObj.table=table 
			s:ALGDate'="" ALGDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ALGDate)    //时间转换
			s AllergyObj.ALGDate=ALGDate 							//开始时间
			s AllergyObj.Comments=Comments 							//注释（过敏情况补充）
			s AllergyObj.ALGCheckConflict=$g(ALGCheckConflict) 		//冲突开启标志*/
		
		if (OldJsonObj.MRCATDesc'=NewJsonObj.MRCATDesc) s RetStr="过敏分类描述:"_OldJsonObj.MRCATDesc_"->"_NewJsonObj.MRCATDesc_";"
		if (OldJsonObj.CategoryRowId'=NewJsonObj.CategoryRowId) s RetStr=RetStr_"过敏分类Id:"_OldJsonObj.CategoryRowId_"->"_NewJsonObj.CategoryRowId_";"
		if (OldJsonObj.TagCode'=NewJsonObj.TagCode) s RetStr=RetStr_"过敏类型:"_OldJsonObj.TagCode_"->"_NewJsonObj.TagCode_";"
		if (OldJsonObj.MRCATTagDescription'=NewJsonObj.MRCATTagDescription) s RetStr=RetStr_"过敏类型描述:"_OldJsonObj.MRCATTagDescription_"->"_NewJsonObj.MRCATTagDescription_";"
		if (OldJsonObj.AllergenRowId '=NewJsonObj.AllergenRowId ) s RetStr=RetStr_"过敏源ID:"_OldJsonObj.AllergenRowId _"->"_NewJsonObj.AllergenRowId _";"
		if (OldJsonObj.ALGDescCT'=NewJsonObj.ALGDescCT) s RetStr=RetStr_"过敏源描述:"_OldJsonObj.ALGDescCT_"->"_NewJsonObj.ALGDescCT_";"
		if (OldJsonObj.ALGItem'=NewJsonObj.ALGItem) s RetStr=RetStr_"过敏项目描述:"_OldJsonObj.ALGItem_"->"_NewJsonObj.ALGItem_";"
		if (OldJsonObj.ALGItemRowId'=NewJsonObj.ALGItemRowId) s RetStr=RetStr_"过敏项目ID:"_OldJsonObj.ALGItemRowId_"->"_NewJsonObj.ALGItemRowId_";"
		if (OldJsonObj.ALGDate'=NewJsonObj.ALGDate) s RetStr=RetStr_"开始时间:"_OldJsonObj.ALGDate_"->"_NewJsonObj.ALGDate_";"
		if (OldJsonObj.Comments'=NewJsonObj.Comments) s RetStr=RetStr_"注释(过敏情况补充):"_OldJsonObj.Comments_"->"_NewJsonObj.Comments_";"
		if (OldJsonObj.ALGCheckConflict'=NewJsonObj.ALGCheckConflict) s RetStr=RetStr_"冲突开启标志:"_OldJsonObj.TagALGCheckConflictode_"->"_NewJsonObj.ALGCheckConflict_";"
	}
	q RetStr
}

/// 根据过敏记录id获取过敏记录json串
ClassMethod GetAllergyInfoJsonById(AllergyId As %String)
{
	s AllergyObj={}
	s objAllergy=##class(User.PAAllergy).%OpenId(AllergyId)
	if $IsObject(objAllergy){
		///过敏子分类(过敏源)
			s AllergenRowId=objAllergy.ALGTypeDRGetObjectId()
			if +AllergenRowId'="0" {
				s ALGDescCT=objAllergy.ALGTypeDR.ALGDesc             //过敏源
			    s TagCode=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
			}  //else{
			
				s ALGPHCGEDR=objAllergy.ALGPHCGEDRGetObjectId()
				if +ALGPHCGEDR'="0" {
					s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName		//过敏项目
					s ALGItemRowId=ALGPHCGEDR
					s TagCode="G"
					//s table="PHCGeneric"
				}else{
					s ALGPHCDMDR=objAllergy.ALGPHCDMDRGetObjectId()
					if +ALGPHCDMDR'="0" {
						s ALGItem=objAllergy.ALGPHCDMDR.PHCDName   //过敏项目
						s ALGItemRowId=ALGPHCDMDR
						s TagCode="P"
						//s table="PHCDrgMast"
						
					}else{
						s ALGIngredDR=objAllergy.ALGIngredDRGetObjectId()
						if +ALGIngredDR'="0" {
							s ALGItem=objAllergy.ALGIngredDR.INGRDesc   //过敏项目
							s ALGItemRowId=ALGIngredDR
							s TagCode="I"
							//s table="PHCIngredient"
						}
					}
				}
			//}
			if (ALGItem=""){
				;医嘱项ID
				if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") { 
				  s ALGItemRowId=objAllergy.ALGExternalID
				  s ALGItem=$p($g(^ARCIM(+ALGItemRowId,$p(ALGItemRowId,"||",2),1)),"^",2)   //过敏项目
				}else{
					if (objAllergy.ALGExternalID'=""){
						s ALGItemRowId=objAllergy.ALGExternalID
						s ALGItem=objAllergy.ALGExternalID
					}
				}
			}
										   
			s MRCATDesc=objAllergy.ALGMRCAllTypeDR.MRCATDesc                               //过敏分类描述
			S CategoryRowId=objAllergy.ALGMRCAllTypeDRGetObjectId()						   //过敏分类ID
			s:TagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",TagCode) //过敏类型
			s ALGDate=objAllergy.ALGOnsetDate            //开始日期
			s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))   //过敏情况补充
			s ALGCheckConflict=$P($g(^PAPER(+ID,"ALG",$P(ID,"||",2),"DHC")),"^",3)
			s ALGCheckConflict=##Class(websys.Conversions).YesNoLogicalToHtml(ALGCheckConflict)
			s AllergyObj.MRCATDesc=MRCATDesc   						//过敏分类描述
			s AllergyObj.CategoryRowId=CategoryRowId 				//过敏分类Id
			s AllergyObj.TagCode=TagCode 						//过敏类型"I","P"等
			s AllergyObj.MRCATTagDescription=MRCATTagDescription    //过敏类型描述
			s AllergyObj.AllergenRowId=AllergenRowId 				//过敏源ID
			s AllergyObj.ALGDescCT=ALGDescCT 						//过敏源描述
			s AllergyObj.ALGItem=ALGItem 							//过敏项目描述
			s AllergyObj.ALGItemRowId=ALGItemRowId 					//过敏项目ID				
			s AllergyObj.table=table 
			s:ALGDate'="" ALGDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ALGDate)    //时间转换
			s AllergyObj.ALGDate=ALGDate 							//开始时间
			s AllergyObj.Comments=Comments 							//注释（过敏情况补充）
			s AllergyObj.ALGCheckConflict=$g(ALGCheckConflict) 		//冲突开启标志
	}else{
		q ""
	}
	q AllergyObj.%ToJSON
}

/// w ##class(DHCDoc.NewClass3).Test()
ClassMethod Test()
{
	s User={
    "IsSuccess":true,
    "Msg":null,
    "SessionID":null,
    "TList":[
        {
            "ages":null,
            "appointmenttime":"2020/9/14 0:00:00",
            "callcount":0,
            "calldoctorid":null,
            "callroomid":null,
            "checkintime":"2020/9/14 7:10:44",
            "departmentid":"37",
            "departmentname":"急诊发热门诊",
            "doctorid":"432",
            "doctorname":"黄晓丽",
            "earliesttime":null,
            "emergencyLevel":1,
            "entryname":null,
            "isdelete":0,
            "isinterval":null,
            "isordinary":0,
            "isreferral":null,
            "latesttime":null,
            "note":"",
            "passcount":0,
            "passnumbertime":null,
            "patiinfoid":"0000222747",
            "_patiinfoname":"陈绮乐",
            "patisex":"2",
            "printqueueno":"1",
            "queueid":"7DAB04A9-D1DF-43B5-9C59-834BF65A6512",
            "queueno":1,
            "queueorder":5,
            "queueordertype":"A",
            "referraltime":null,
            "regdate":"2020/9/14 0:00:00",
            "roomid":null,
            "roomname":"诊室1",
            "rsrctypeid":"急诊号",
            "serialnumber":"479136",
            "shiftno":"0",
            "sourceid":"040100100",
            "stateid":5,
            "statename":"正在就诊",
            "treatmentbegintime":null,
            "treatmentendtime":null,
            "treatmenttime":0,
            "validdate":"2020/9/14 0:00:00",
            "worksessionid":"3"
        },
        {
            "ages":null,
            "appointmenttime":"2020/9/14 0:00:00",
            "callcount":0,
            "calldoctorid":null,
            "callroomid":null,
            "checkintime":"2020/9/14 7:48:36",
            "departmentid":"37",
            "departmentname":"急诊发热门诊",
            "doctorid":"432",
            "doctorname":"黄晓丽",
            "earliesttime":null,
            "emergencyLevel":1,
            "entryname":null,
            "isdelete":0,
            "isinterval":null,
            "isordinary":0,
            "isreferral":null,
            "latesttime":null,
            "note":"",
            "passcount":0,
            "passnumbertime":null,
            "patiinfoid":"0000095257",
            "_patiinfoname":"张祺东",
            "patisex":"1",
            "printqueueno":"2",
            "queueid":"D8A2B103-439E-4616-A145-5162D4D9335B",
            "queueno":2,
            "queueorder":5,
            "queueordertype":"A",
            "referraltime":null,
            "regdate":"2020/9/14 0:00:00",
            "roomid":null,
            "roomname":"诊室1",
            "rsrctypeid":"急诊号",
            "serialnumber":"479224",
            "shiftno":"0",
            "sourceid":"040100100",
            "stateid":5,
            "statename":"正在就诊",
            "treatmentbegintime":null,
            "treatmentendtime":null,
            "treatmenttime":0,
            "validdate":"2020/9/14 0:00:00",
            "worksessionid":"3"
        }
    ]
	}

	s InputJson=User.%ToJSON()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(InputJson)
	
	q Stream
}

ClassMethod GetRoomIdByIPAddress(IPAddress As %String)
{
	q:IPAddress="" ""
	s RoomId=""
	&SQL(SELECT RoomcRoomDr INTO :Roomid FROM SQLUser.DHCRoomComp WHERE RoomcIp=:IPAddress)
	if (SQLCODE="0") q RoomId
	q ""
}

ClassMethod FindLocDocQueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocQueListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.NewClass3","FindLocDocQueList","1","qwe","","","","","","","","","","","")
ClassMethod FindLocDocQueListExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String = "", MarkID As %String = "", CheckName As %String = "") As %Status
{
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	//If $g(DocId)="" Quit $$$OK
	s Roomid=..GetRoomIdByIPAddress(IPAddress)
	//if (Roomid="") quit $$$OK
	Set repid=$I(^CacheTemp)
	s ind=1
	s Report=""
	s:("^"_CheckName_"^")["^RegQue^" RegQue="on"
	s:("^"_CheckName_"^")["^AllPatient^" AllPatient="on"
	s:("^"_CheckName_"^")["^ArrivedQue^" ArrivedQue="on"
	s:("^"_CheckName_"^")["^Consultation^" Consultation="on"
	s:("^"_CheckName_"^")["^Report^" Report="on"
	
	s InputObj={}
	s InputObj.DoctorId=UserID		;医生id		String	50	是
	s InputObj.DepartmentId=LocID		;	科室id		string	50	是
	s InputObj.RoomId=Roomid		;	诊室		String	50	否
	s InputObj.StateId="0,1,2,5,6"		;	状态值	值为0,1,2,5,6（注意标点是逗号）	String		是
	s InputObj.QueueType="7"		;	队列类型	值为 1：在指定科室坐诊的指定医生的患者队列数据值为2：在指定科室下的指定诊室的患者队列数据值为3：查指定科室下的普通号患者队列数据值为 7：在指定科室坐诊的指定医生指定状态的患者队列数据string		是
	s InputObj.IsAll="true"		;	是否查全部	true:查当天全部有效数据false:根据QueueType值查询，具体说明请看QueueType参数Json格式布尔类型的值为小写，分别为：true,false	Bool		是
	s InputJson=InputObj.%ToJSON()
	s RetStr="0"
	s OutPutJson=..Test()
	;if (OutPutJson["_") s jsonStr=$replace(OutPutJson,"_","")
	;if (OutPutJson["null") s jsonStr=$replace(OutPutJson,"null","""""")
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(OutPutJson)
	if (jsonObject.IsSuccess){
		for ind=0:1:jsonObject.TList.%Size()-1{
			s myvalue=jsonObject.TList.%Get(ind)
			//s EpisodeID=myvalue.SerialNumber		;患者流水号，每条就诊记录的唯一号码	患者每条就诊记录的唯一号码	string
			//s patiinfoid=myvalue.patiinfoid		;	患者唯一号		string
			s PAPMIName=myvalue."_patiinfoname"		;	患者姓名		string
			w ","_","_PAPMIName,!
		}
	}
	/*if (jsonObject.IsSuccess){
		s JsonCount=0
		Set key=""
		s iter=jsonObject.%GetIterator()
		while iter.%GetNext(.key,.value){
			if $IsObject(value){
				s mykey=""
				s myiter=value.%GetIterator()
				while myiter.%GetNext(.mykey,.myvalue){
					if $IsObject(myvalue){
						b ;;;;
						s myiter1=myvalue.%GetIterator()
						while myiter.%GetNext(.mykey1,.myvalue1){
							b ;;1
						}
						//d OutputRow
					}
				}
			}
		}
	}*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ResetVariables
	s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,RegAdmSource)=""
OutputRow  
	d ResetVariables 
	s EpisodeID=myvalue.SerialNumber		;患者流水号，每条就诊记录的唯一号码	患者每条就诊记录的唯一号码	string
	s patiinfoid=myvalue.patiinfoid		;	患者唯一号		string
	s PAPMIName=myvalue.patiinfoname		;	患者姓名		string
	s stateid=myvalue.stateid		;	患者排队状态	0：未报到，1：排队中，2：已过号，5：正在就诊，6：诊结	int
	q:((RegQue="on")&&(stateid'=1)&&(stateid'=2))
	q:((ArrivedQue="on")&&(stateid'=0)&&(stateid'=6))
	q:((Report="on")&&(stateid'=5))
	s LocSeqNo=myvalue.queueno		;	排队号	代表患者的实际位置，需要大于0的整数	string
	s emergencyLevel=myvalue.emergencyLevel		;	队列优先级	一般为0，越小优先级越高	int
	s Loc=myvalue.departmentid		;	患者挂号的科室id		string
	s PAAdmDepCodeDR=myvalue.departmentname		;	患者挂号的科室名称		string
	s roomid=myvalue.roomid		;	诊室id		string
	s ConsultRoom=myvalue.roomname		;	诊室名		string
	s Doctor=myvalue.doctorid		;	医生id		string
	s PAAdmDocCodeDR=myvalue.doctorname		;	医生		string
	s validdate=myvalue.validdate		;		预约患者则为预约时间，现场挂号患者那么则为挂号时间	string
	s shiftno=myvalue.shiftno		;	患者班次	上午或下午或晚上	string
	s appointmenttime=myvalue.appointmenttime		;	患者预约时间		string
	s latesttime=myvalue.latesttime		;	最后呼叫时间		string
	s treatmentendtime=myvalue.treatmentendtime		;	诊结时间		string
	s CheckInTime=myvalue.CheckInTime		;	报到时间		string
	Set PatientID=$P(^PAADM(EpisodeID),"^",1)
	Set mradm=$P(^PAADM(EpisodeID),"^",61)
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	q:(PatientNo'="")&&($$ALPHAUP^SSUTIL4(PAPMINO)'[PatientNo)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	q:(SurName'="")&&($$ALPHAUP^SSUTIL4(PAPMIName)'[SurName)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	.Set PAPMIAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PAPMIDOB,+$h)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=##class(websys.Conversions).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	s PAAdmTimeGet=$P($g(^PAADM(EpisodeID)),"^",7)
	Set PAAdmTime=$ZT(PAAdmTimeGet,3)
	//
	Set PAAdmNo=$P($g(^PAADM(EpisodeID)),"^",81)
	;Set Loc=$P($g(^PAADM(EpisodeID)),"^",4)
	;If Loc'="" d
	;.Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	;.if ($f(PAAdmDepCodeDR,"-")'=0) set PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	;Else  Set PAAdmDepCodeDR=""
	;Set Doctor=$P($g(^PAADM(EpisodeID)),"^",9)
	;If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	;Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set Ward=$P($g(^PAADM(EpisodeID)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(EpisodeID)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	Set AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(EpisodeID)),"^",17)
	If $g(mradm)'="" Set Diagnosis=##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	s ArrivedDate="",ArrivedTime=""
	
	Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set LocSeqNo=QueObj.QueNo
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	.Set Doc=QueObj.QueDocDrGetObjectId()
	.If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.Else  Set PAAdmDocCodeDR=""
	.Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	.Set PriorityCode=QueObj.QueFirstDr.FirstcCode
	.If PriorityCode="" Set PriorityCode="XX"
	.Set RegDocCode=""
	.Set RegDocDr=QueObj.QueMarkDrGetObjectId()
	.If RegDocDr'="" d
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM"," "_EpisodeID,""))
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...if RegRangeTimeDr="" do
	....s RBASRowid=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),18)
	....if RBASRowid'="" s RegRangeTimeDr=$P($G(^RBAS(+RBASRowid,$P(RBASRowid,"||",2),"DHC")),"^",17)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	...set RegDoctor=RegDoctor_"("_$g(RegRangeTime)_")"
	..set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Set Called=QueObj.QueCompDr
	.set SortCalled=Called
	.IF Called="" SET SortCalled="X"
	.Set WalkStatus=QueObj.QueStateDr.PersName
	.Set StatusCode=QueObj.QueStateDr.PersCode
	.If StatusCode="" Set StatusCode="XX"
	.//到达日期，到达时间
	.i WalkStatus="到达" d
	..s ArrivedDate=QueObj.QueStateDate,ArrivedTime=QueObj.QueStateTime
	..i ArrivedDate'="" s ArrivedDate=##class(websys.Conversions).DateLogicalToHtml(ArrivedDate) //$zd(ArrivedDate,3)
	..i ArrivedTime'="" s ArrivedTime=$zt(ArrivedTime,3)
	.;Set ConsultRoom=QueObj.QueRoomDr.CTLOCDesc
	.//set ConsultRoom=QueObj.QueExabDr
	.Set ConsultArea=QueObj.QueExabDr.ExabName
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set SortCalled="X"
	.Set RegDocDr=""  
	set Data=$lb(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,RegAdmSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindLocDocQueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocQueListExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLocDocQueList(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String,TSecretLevel:%String,RegRangeTime:%String,RegAdmSource:%String")
{
}

ClassMethod getqw(LocDr As %String) As %Status
{
	s LocDr=$order(^CTLOC(0))
	s LocStr=$get(^CTLOC(LocDr))
	b 
	q LocStr
}

ClassMethod getUserDr() As %Status
{
	set UserID=$piece($get(^PAADM(12,"DHC")),"^",12)
	set UserID="12"
}

}
