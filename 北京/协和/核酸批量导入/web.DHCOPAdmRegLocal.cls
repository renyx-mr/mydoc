Class web.DHCOPAdmRegLocal Extends %RegisteredObject
{

Parameter CheckCovidData = "2022-01-03";

Parameter CheckArcItemStr = "52593||1^52662||1^52845||1^53545||1";

Parameter CheckCovidCountNum = 10;

ClassMethod InsertCaregiverCovid19(RegNo As %String, EpisodeID As %String, DiagICDDr As %String, ArcItemRowDr As %String)
{
	s $ZTRAP="InsertCaregiverCovid19Err"
	s ret=$$Covid2019Test^DHCDocOrdCovidBatch(RegNo,"",ArcItemRowDr)
	s CaregiverName=""
	s CaregiverCredNo=""
	s CaregiverPatNo=##class(web.DHCOPAdmRegLocal).GetPatNoByCredNo(CaregiverCredNo,CaregiverName)
	if (CaregiverPatNo'["^"){
		s ret=$$Covid2019Test^DHCDocOrdCovidBatch(CaregiverPatNo,"",ArcItemRowDr)
	}
InsertCaregiverCovid19Err
	s $ZTRAP=""
	q ""
}

/// 插入陪诊人数据，并校验该陪诊人在系统中的情况
ClassMethod SaveCaregiver(EpisodeID As %String, CaregiverName As %String, CaregiverCredNo As %String)
{
	q:'$d(^PAADM(EpisodeID)) "-1^未找到该病人就诊信息"
	//s $p(^PAADM(EpisodeID),"Local",111)=CaregiverName
	//s $p(^PAADM(EpisodeID),"Local",112)=CaregiverCredNo
	s PatNo=##class(web.DHCOPAdmRegLocal).GetPatNoByCredNo(CaregiverCredNo,CaregiverName)
	q:(PatNo["^") "1^"_$p(PatNo,"^",2)
	q "1"
}

ClassMethod GetSamplingDate(PatientNo As %String, StartDate As %String, EndDate As %String)
{
	s SamplingDate=""
	s SamplingTime=""
	s PatientId =$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
	//  查询数量  先按照医嘱查询不行再使用就诊数据查
	s PAAdmDr=""
	for {
		s PAAdmDr=$o(^PAPERdr(PatientId,"ADM","O",PAAdmDr),-1)
		q:(PAAdmDr="")||(SamplingDate'="")
		s AdmDate=$p($g(PAAdmDr),"^",6)
		continue:((StartDate'="")&&(AdmDate<StartDate))
		continue:((EndDate'="")&&(AdmDate>EndDate))
		s Oeori=$o(^OEORD(0,"Adm",PAAdmDr,0))
		continue:Oeori=""
		//^OEORDi(0,"ItemDate",{OEORI_Date},{OE_Order.OEORD_RowId},{OEORI_Childsub})
		for OrdDate=StartDate:1:EndDate{
			s OrdChildsub=0
			for {
				s OrdChildsub=$o(^OEORDi(0,"ItemDate",OrdDate,Oeori,OrdChildsub))
				q:OrdChildsub=""
				s OtherFlags=$p($g(^OEORD(Oeori,"I",OrdChildsub,"DHC")),"^",23)
				continue:(OtherFlags'="ImportCovidOrd")
				s itemstat=$p($g(^OEORD(Oeori,"I",OrdChildsub,1)),"^",13)
				continue:itemstat=""
				s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
				continue:(statcode'="V")&&(statcode'="E")
				s SpecCollInfo=##class(DHCNurCom).GetSpecCollInfo(Oeori_"||"_OrdChildsub)
				s:$p(SpecCollInfo,"^",3)'="" SamplingDate=$p(SpecCollInfo,"^",3)
				s:$p(SpecCollInfo,"^",4)'="" SamplingTime=$p(SpecCollInfo,"^",4)
			}
		}
	}
	q SamplingDate_"^"_SamplingTime
}

/// 获取最后一次的采样时间 入参登记号
ClassMethod GetLastSamplingDate(PatientNo As %String)
{
	s SamplingDate=""
	s SamplingTime=""
	s PatientId =$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
	//  查询数量  先按照医嘱查询不行再使用就诊数据查
	s PAAdmDr=""
	for {
		s PAAdmDr=$o(^PAPERdr(PatientId,"ADM","O",PAAdmDr),-1)
		q:(PAAdmDr="")||(SamplingDate'="")
		s Oeori=$o(^OEORD(0,"Adm",PAAdmDr,0))
		continue:Oeori=""
		s OrdChildsub=""
		for{
			s OrdChildsub=$o(^OEORD(Oeori,"I",OrdChildsub),-1)
			q:(OrdChildsub="")||(SamplingDate'="")
			s OtherFlags=$p($g(^OEORD(Oeori,"I",OrdChildsub,"DHC")),"^",23)
			continue:(OtherFlags'="ImportCovidOrd")
			s itemstat=$p($g(^OEORD(Oeori,"I",OrdChildsub,1)),"^",13)
			continue:itemstat=""
			s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
			continue:(statcode'="V")&&(statcode'="E")
			s SpecCollInfo=##class(DHCNurCom).GetSpecCollInfo(Oeori_"||"_OrdChildsub)
			s SamplingDate=$p(SpecCollInfo,"^",3)
			s SamplingTime=$p(SpecCollInfo,"^",4)
		}
	}
	q SamplingDate_"^"_SamplingTime
}

/// 获取单采混采次数 入参登记号
/// w ##class(web.DHCOPAdmRegLocal).GetCovidNumInfo("46670579")
ClassMethod GetCovidNumInfoNew(PatientNo As %String, ArcItemId As %String, resCode As %String = "")
{
    s StartCovidData=$zdh(..#CheckCovidData,3)
	s CovidSingleNum=""
	s CovidMixleNum=""
	s PatientId =$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
    s ArcItemDrStr=ArcItemId
	s:ArcItemDrStr="" ArcItemDrStr=..#CheckArcItemStr
    s:resCode="" resCode=44434
    s AdmLoc=$p(^RB("RES",resCode),"^",1)
    // ^PAADMi("NNLoc",{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_RowID})
    s AdmDoc=$p(^RB("RES",resCode),"^",2)
    // ^PAADMi("NNDoc",{PAADM_AdmDocCodeDR},{PAADM_AdmDate},{PAADM_RowID})
    s AdmDate=StartCovidData-1
    
    for {
        s AdmDate=$o(^PAADMi("NNDoc",AdmDoc,AdmDate))
        q:AdmDate=""
        s PAAdmDr=0
        for {
            s PAAdmDr=$o(^PAADMi("NNDoc",AdmDoc,AdmDate,PAAdmDr))
            q:PAAdmDr=""
            s Oeori=$o(^OEORD(0,"Adm",PAAdmDr,0))
		    continue:Oeori=""
            s OrdChildsub=0
            for {
                s OrdChildsub=$o(^OEORD(Oeori,"I",OrdChildsub))
                q:OrdChildsub=""
                s ItmMastDr=$p($g(^OEORD(Oeori,"I",OrdChildsub,1)),"^",2)
                continue:("^"_ArcItemDrStr_"^")'[("^"_ItmMastDr_"^")
                s ArcimDesc=$P(^ARCIM(+ItmMastDr,$P(ItmMastDr,"||",2),1),"^",2)
                s OtherFlags=$p($g(^OEORD(Oeori,"I",OrdChildsub,"DHC")),"^",23)
                continue:(OtherFlags'="ImportCovidOrd")
                s itemstat=$p($g(^OEORD(Oeori,"I",OrdChildsub,1)),"^",13)
                continue:itemstat=""
                s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
                continue:(statcode'="V")
                if (ArcimDesc["混采") s CovidMixleNum=CovidMixleNum+1
                else  s CovidSingleNum=CovidSingleNum+1
            }
        }
    }
    q CovidSingleNum_"^"_CovidMixleNum
}

/// 获取单采混采次数 入参登记号
/// w ##class(web.DHCOPAdmRegLocal).GetCovidNumInfo("46670579")
ClassMethod GetCovidNumInfo(PatientNo As %String, ArcItemId As %String)
{
	s StartCovidData=$zdh(..#CheckCovidData,3)
	s CovidSingleNum=""
	s CovidMixleNum=""
	s PatientId =$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
	//  查询数量  先按照医嘱查询不行再使用就诊数据查
	s ArcItemDrStr=ArcItemId
	s:ArcItemDrStr="" ArcItemDrStr=..#CheckArcItemStr
	s PAAdmDr=0
	for {
		s PAAdmDr=$o(^PAPERdr(PatientId,"ADM","O",PAAdmDr))
		q:PAAdmDr=""
		s Oeori=$o(^OEORD(0,"Adm",PAAdmDr,0))
		continue:Oeori=""
		;;23
		for CovidArcItemInd=1:1:$l(ArcItemDrStr,"^"){
			s ArcItemDr=$p(ArcItemDrStr,"^",CovidArcItemInd)
			continue:ArcItemDr=""
			s ArcimDesc=$P(^ARCIM(+ArcItemDr,$P(ArcItemDr,"||",2),1),"^",2)
			s OrdSStDat=StartCovidData-1
			for {
				s OrdSStDat=$o(^OEORDi(0,"ARCIM",Oeori,ArcItemDr,OrdSStDat))
				q:OrdSStDat=""
				s OrdChildsub=0
				for {
					s OrdChildsub=$o(^OEORDi(0,"ARCIM",Oeori,ArcItemDr,OrdSStDat,OrdChildsub))
					q:OrdChildsub=""
					;;2
					s OtherFlags=$p($g(^OEORD(Oeori,"I",OrdChildsub,"DHC")),"^",23)
					continue:(OtherFlags'="ImportCovidOrd")
					s itemstat=$p($g(^OEORD(Oeori,"I",OrdChildsub,1)),"^",13)
					continue:itemstat=""
					s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
					continue:(statcode'="V")
					if (ArcimDesc["混采") s CovidMixleNum=CovidMixleNum+1
					else  s CovidSingleNum=CovidSingleNum+1
				}
			}
		}
	}
	q CovidSingleNum_"^"_CovidMixleNum
}

/// w ##class(web.DHCOPAdmRegLocal).CheckPatAge($g(EpisodeID))
ClassMethod CheckPatAge(EpisodeID As %String)
{
	s RetFlag=0
	q:'$d(^PAADM(EpisodeID)) RetFlag
	s PatientId=$p($g(^PAADM(EpisodeID)),"^")
	q:PatientId="" RetFlag
	s PatDob=$p($g(^PAPER(PatientId,"ALL")),"^",6)
	q:PatDob="" RetFlag
	s PatDobYear=$p($zd(PatDob,3),"-")
	s HourYear=$p($zd(+$h,3),"-")
	s:(PatDobYear-HourYear)<=5 RetFlag=1
	q RetFlag
}

/// w ##Class(web.DHCOPAdmRegLocal).KillTmpGlobal("")
ClassMethod KillTmpGlobal(Pid As %String)
{
	if (Pid'=""){
		k ^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid)
	}
	q $j
}

ClassMethod InsertTmpGlobal(Pid As %String, IDNo As %String, PatientName As %String)
{
	// 获取患者的信息
	s PatNoRet=..GetAllPatIDByIDCardAndName(IDNo,PatientName)
	s RetMsg="校验数据成功",RetFlag="0"
	if (PatNoRet["^") {
		s RetMsg="校验数据失败："_$p(PatNoRet,"^",2)
		s RetFlag="1"
		
	}
	s ^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,$i(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid)))=IDNo_"^"_PatientName_"^"_PatNoRet_"^"_RetFlag_"^"_RetMsg
	q 0
}

/// 插入就诊和医嘱
/// w ##Class(web.DHCOPAdmRegLocal).InsertAdmAndArcItem("")
ClassMethod InsertAdmAndArcItem(ArcItem As %String, Pid As %String)
{
	s ^tempren("InsertAdmAndArcItem")=$lb(ArcItem,Pid)
    //(PatientNo,DiagnoCode="",ArcimCode="",resCode="",docUserID="",regUserID="")
    s CovidInd=0
    s SuccessCount=0,ErrCount=0
    for{
		s CovidInd=$o(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd))
		q:CovidInd=""
		s OneCovidData=$g(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd))
		s CheckFlag=$p(OneCovidData,"^",4)
		if CheckFlag="1"{
			s ErrCount=ErrCount+1
			continue
		}
		s OnePatNo=$p(OneCovidData,"^",3)
		if OnePatNo=""{
			s ErrCount=ErrCount+1
			continue
		}
		s ret=$$Covid2019Test^DHCDocOrdCovidBatch(OnePatNo,"",ArcItem)
		s EpisodeID=""
		s:(ret'="err")||(+ret>=0) EpisodeID=$p(ret,"^",3)
		d:EpisodeID'="" ..SaveOrdItemImportFlag(EpisodeID)
		if (ret="err")||(+ret<0) s RetMsg="导入医嘱数据失败："_$p(ret,"^",2),RetFlag="1",ErrCount=ErrCount+1
		else  s RetMsg="导入医嘱数据成功",RetFlag="0",SuccessCount=SuccessCount+1
		s $p(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd),"^",4)=RetFlag
		s $p(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd),"^",5)=RetMsg
    }
    //s ret=$$Covid2019Test^DHCDocOrdCovidBatch(PatNo,"",ArcItem)
    q SuccessCount_"^"_ErrCount
}

/// 获取患者的登记号
/// w ##class(web.DHCOPAdmRegLocal).GetPatNoByCredNo("110109201502025236","张晓峰")
ClassMethod GetPatNoByCredNo(IDNo As %String, PatientName As %String) As %Status
{

   
    set myHadFlag=..GetAllPatIDByIDCardAndName(IDNo,PatientName)
   	// if (myHadFlag="") set myHadFlag=..GetAllPatIDByIDCardAndName(myIDCardNo15,PatientName)
    if (myHadFlag="") q "-1^没有在his里面找到该患者信息"
    if $l(myHadFlag,"^")>1 q "-1^该身份号对应多条信息"
    q myHadFlag
}

/// 根据证件号和姓名得到所有病人id
/// w ##class(web.DHCOPAdmRegLocal).GetPatIDByIDCardAndName("370285199106144416","nk")
ClassMethod GetAllPatIDByIDCardAndName(CardNumber As %String, PatientName As %String) As %String
{
	i CardNumber=$C(0) s CardNumber=""
	q:CardNumber="" ""
	i '$d(^PAPERi("DVA",$$ALPHAUP^SSUTIL4(CardNumber))){
		s:$Length(CardNumber)=15 CardNumber=##class(CardInterface.CardManager).ID15to18(CardNumber)
		s:$Length(CardNumber)=18 CardNumber=##class(CardInterface.CardManager).ID18to15(CardNumber)
	}
	q:'$d(^PAPERi("DVA",$$ALPHAUP^SSUTIL4(CardNumber))) ""
	s myrtn=0
	s PAPMIRowID=0
	s rtn=""
	f  s PAPMIRowID=$o(^PAPERi("DVA",CardNumber,PAPMIRowID))  q:(PAPMIRowID="")  d
	.s Active=$p(^PAPER(PAPMIRowID,"PAT",1),"^",6)
	.q:Active'="Y"
	.set CurName=$P(^PAPER(PAPMIRowID,"ALL"),"^",1)
    .Q:(PatientName'="")&&(CurName'=PatientName)
	.s CardType=$p(^PAPER(PAPMIRowID,"PAT",3),"^",7)
	.q:CardType=""
	.s CardTypeDesc=$p(^PAC("CARD",CardType),"^",2)
	.;q:CardType'="身份证"
	.s PatientNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",1)
	.if rtn="" d
	..s rtn=PatientNo
	.else  d
	..s rtn=rtn_"^"_PatientNo
	q rtn
}

ClassMethod GetCovid19ListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCovid19ListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegLocal","GetCovid19List",1114920)
ClassMethod GetCovid19ListExecute(ByRef qHandle As %Binary, Pid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^tempRen("GetCovid19ListExecute")=Pid
	s CovidInd=0
    for{
		s CovidInd=$o(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd))
		q:CovidInd=""
		s OneData=$g(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,CovidInd))
		// IDNo_"^"_PatientName_"^"_PatNoRet_"^"_RetFlag_"^"_RetMsg
		d ResetVariables
		s IDNo=$p(OneData,"^",1)
		s PatName=$p(OneData,"^",2)
		s PatId=$p(OneData,"^",3)
		s RetFlag=$p(OneData,"^",4)
		s CheckMsg=RetFlag
		s:RetFlag="0" CheckMsg="成功"
		s:RetFlag="1" CheckMsg="失败"
		s ErrLog=$p(OneData,"^",5)
		s Initials=$p(OneData,"^",6)
		b ;;;//s PatientId =$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatId),""))
		s DCERowId=""
		s:PatId'="" DCERowId=$o(^User.DHCDocCovidEmployeeI("PAPatNo"," "_PatId,0))
		;采样时间
		s SamplingDateInfo=""
		s:PatId'="" SamplingDateInfo=..GetLastSamplingDate(PatId)
		s SpecDate=$p(SamplingDateInfo,"^",1),SpecTime=$p(SamplingDateInfo,"^",2)
		s:SpecDate'="" SpecDate=$zd(SpecDate,3)
		s:SpecTime'="" SpecTime=$zt(SpecTime,1)
		s SamplingDate=SpecDate_" "_SpecTime
		;报告时间
		s ReportDate=""
		s:(DCERowId="")&&(Initials'="") DCERowId=$o(^User.DHCDocCovidEmployeeI("Initials"," "_Initials,0))
		if (DCERowId'=""){
			s CovidEmployeeObj=##class(User.DHCDocCovidEmployee).%OpenId(DCERowId)
			if $IsObject(CovidEmployeeObj) {
				s EmploymentStatus=CovidEmployeeObj.DCEEmploymentStatus
				s DormitoryGroup=CovidEmployeeObj.DCEDormitoryGroup
				s GroupDept=CovidEmployeeObj.DCEGroupDept
				s CompetentDept=CovidEmployeeObj.DCECompetentDept
				s JobNumber=CovidEmployeeObj.DCEInitials
				s PatName=CovidEmployeeObj.DCEPatName
				s IDType=CovidEmployeeObj.DCEIDType
				s IDNumberm=CovidEmployeeObj.DCEIDNumber
				s LastUpDate=CovidEmployeeObj.DCELastUpDate
				s LastUpTime=CovidEmployeeObj.DCELastUpTime
				s UpdateDate=$zd(LastUpDate,3)_" "_$zt(LastUpTime,1)
				s ActiveStatus="有效"
				s FocusGroups="否"
				s CovidNumInfo=""
				s:PatId'="" CovidNumInfo="" ;..GetCovidNumInfo(PatId,"")
				s CovidSingleNum=$p(CovidNumInfo,"^",1)
				s CovidMixleNum=$p(CovidNumInfo,"^",2)
				do OutputRow
			}
			d CovidEmployeeObj.%Close()
		}else{
			do OutputRow
		}
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(EmploymentStatus,DormitoryGroup,GroupDept,CompetentDept,JobNumber,PatName,IDType,IDNumberm,PatId,ActiveStatus,FocusGroups,CovidSingleNum,CovidMixleNum,SamplingDate,ReportDate,UpdateDate,CheckMsg,ErrLog)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
ResetVariables
	s (EmploymentStatus,DormitoryGroup,GroupDept,CompetentDept,JobNumber,PatName,IDType,IDNumberm,PatId,ActiveStatus,FocusGroups,CovidSingleNum,CovidMixleNum,SamplingDate,ReportDate,UpdateDate,CheckMsg,ErrLog)=""
 	quit
}

ClassMethod GetCovid19ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCovid19ListExecute ]
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

Query GetCovid19List(Pid As %String) As %Query(ROWSPEC = "EmploymentStatus:%String,DormitoryGroup:%String,GroupDept:%String,CompetentDept:%String,JobNumber:%String,PatName:%String,IDType:%String,IDNumberm:%String,PatId:%String,ActiveStatus:%String,FocusGroups:%String,CovidSingleNum:%String,CovidMixleNum:%String,SamplingDate:%String,ReportDate:%String,UpdateDate:%String,CheckMsg:%String,ErrLog:%String")
{
}

ClassMethod FindCovid19InfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCovid19InfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegLocal","FindCovid19InfoList","4194358","","","","","","","","")
ClassMethod FindCovid19InfoListExecute(ByRef qHandle As %Binary, Pid As %String, StartDate As %String, EndDate As %String, GroupDept As %String, CompetentDept As %String, ResidueDegree As %String, UpdateDate As %String, ActiveFlag As %String, FocusGroups As %String, EmployStatus As %String, ArcItemId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^tempRen("FindCovid19InfoListExecute")=$lb(Pid , StartDate , EndDate , GroupDept , CompetentDept , ResidueDegree , UpdateDate , ActiveFlag, FocusGroups,EmployStatus,ArcItemId)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	s:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	s DCERowId=0
	for{
		s DCERowId=$o(^User.DHCDocCovidEmployeeD(DCERowId))
		q:DCERowId=""
		s CovidEmployeeObj=##class(User.DHCDocCovidEmployee).%OpenId(DCERowId)
		if $IsObject(CovidEmployeeObj) {
			
			s EmploymentStatus=CovidEmployeeObj.DCEEmploymentStatus
			s DormitoryGroup=CovidEmployeeObj.DCEDormitoryGroup
			s GroupDept=CovidEmployeeObj.DCEGroupDept
			s CompetentDept=CovidEmployeeObj.DCECompetentDept
			s JobNumber=CovidEmployeeObj.DCEInitials
			s PatName=CovidEmployeeObj.DCEPatName
			s IDType=CovidEmployeeObj.DCEIDType
			s IDNumberm=CovidEmployeeObj.DCEIDNumber
			s PatId=CovidEmployeeObj.DCEPatientNo
			s LastUpDate=CovidEmployeeObj.DCELastUpDate
			s LastUpTime=CovidEmployeeObj.DCELastUpTime
			d CovidEmployeeObj.%Close()
			;;we
			continue:(EmployStatus'="")&&(EmployStatus'=EmploymentStatus)
			continue:(ActiveFlag="Y")&&(PatId="")
			continue:(UpdateDate'="")&&(UpdateDate'=LastUpDate)
			//s UpdateDate=$zd(LastUpDate,3)_" "_$zt(LastUpTime,1)
			s ActiveStatus="无效"
			s:PatId'="" ActiveStatus="有效"
			s CovidNumInfo=""
			//w:"47023760"=PatId $h
			s:PatId'="" CovidNumInfo="" //..GetCovidNumInfo(PatId,ArcItemId)
			//w:"47023760"=PatId $h
			s CovidSingleNum=$p(CovidNumInfo,"^",1)
			s CovidMixleNum=$p(CovidNumInfo,"^",2)
			continue:(ArcItemId'="")&&((CovidSingleNum="")||(CovidMixleNum=""))
			s Surplus=..#CheckCovidCountNum-(CovidSingleNum+CovidMixleNum)
			continue:(ResidueDegree'="")&&((PatId="")||(Surplus'=+ResidueDegree))
			s SamplingDateInfo=""
			s:PatId'="" SamplingDateInfo="" //..GetSamplingDate(PatId,StartDate,EndDate)
			s SpecDate=$p(SamplingDateInfo,"^",1),SpecTime=$p(SamplingDateInfo,"^",2)
			//continue:(StartDate'="")&&((SpecDate="")||(StartDate>SpecDate))
			//continue:(EndDate'="")&&((SpecDate="")||(EndDate<SpecDate))
			s:SpecDate'="" SpecDate=$zd(SpecDate,3)
			s:SpecTime'="" SpecTime=$zt(SpecTime,1)
			s SamplingDate=SpecDate_" "_SpecTime
			s ReportDate=""
			s CheckMsg=CovidEmployeeObj.DCECheckLog
			s ErrLog=""
			s ^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,$i(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid)))=IDNumberm_"^"_PatName_"^"_PatId_"^"_CheckMsg_"^"_""_"^"_JobNumber
			
			d Covid19InfoOutputRow
		}
		
	}
    // s ^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid,$i(^TEMP("Covid19","web.DHCOPAdmRegLocal",Pid)))=IDNo_"^"_PatientName_"^"_PatNoRet_"^"_RetFlag_"^"_RetMsg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Covid19InfoOutputRow      
	set Data=$lb(EmploymentStatus,DormitoryGroup,GroupDept,CompetentDept,JobNumber,PatName,IDType,IDNumberm,PatId,ActiveStatus,FocusGroups,CovidSingleNum,CovidMixleNum,SamplingDate,ReportDate,$zd(LastUpDate,3)_" "_$zt(LastUpTime,1),CheckMsg,ErrLog)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCovid19InfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCovid19InfoListExecute ]
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

Query FindCovid19InfoList(Pid As %String, StartDate As %String, EndDate As %String, GroupDept As %String, CompetentDept As %String, ResidueDegree As %String, UpdateDate As %String, ActiveFlag As %String, FocusGroups As %String, EmployStatus As %String, ArcItemId As %String = "") As %Query(ROWSPEC = "EmploymentStatus:%String,DormitoryGroup:%String,GroupDept:%String,CompetentDept:%String,JobNumber:%String,PatName:%String,IDType:%String,IDNumberm:%String,PatId:%String,ActiveStatus:%String,FocusGroups:%String,CovidSingleNum:%String,CovidMixleNum:%String,SamplingDate:%String,ReportDate:%String,UpdateDate:%String,CheckMsg:%String,ErrLog:%String")
{
}

ClassMethod SaveOrdItemImportFlag(AdmId As %String)
{
	s Oeori=$o(^OEORD(0,"Adm",AdmId,0))
	q:Oeori="" ""
	s OrdItemDr=0
	for{
		s OrdItemDr=$o(^OEORD(Oeori,"I",OrdItemDr))
		q:OrdItemDr=""
		s $p(^OEORD(Oeori,"I",OrdItemDr,"DHC"),"^",23)="ImportCovidOrd"
	}
	q "1"
}

ClassMethod LoadListDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadListDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegLocal","LoadListData","ArcItem")
ClassMethod LoadListDataExecute(ByRef qHandle As %Binary, ListType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	if (ListType="ArcItem"){
		s ArcItemDrStr=..#CheckArcItemStr
		for dArcItemInd=1:1:$l(ArcItemDrStr,"^"){
			s DataId=$p(ArcItemDrStr,"^",dArcItemInd)
			continue:DataId=""
			s DataDesc=$P(^ARCIM(+DataId,$P(DataId,"||",2),1),"^",2)
			do ListDataOutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ListDataOutputRow      
	set Data=$lb(DataId,DataDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod LoadListDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadListDataExecute ]
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

Query LoadListData(ListType As %String) As %Query(ROWSPEC = "DataId:%String,DataDesc:%String")
{
}

/// w ##class(web.DHCOPAdmRegLocal).GetLoadListJsonData("ArcItem")
ClassMethod GetLoadListJsonData(ListType As %String)
{
	s myrtn="["
	s index=1
	if (ListType="ArcItem"){
		s ArcItemDrStr=..#CheckArcItemStr
		for ArcItemInd=1:1:$l(ArcItemDrStr,"^"){
			s ArcItemDr=$p(ArcItemDrStr,"^",ArcItemInd)
			continue:ArcItemDr=""
			s ArcimDesc=$P(^ARCIM(+ArcItemDr,$P(ArcItemDr,"||",2),1),"^",2)
			s OneJsonData="{""text"":"""_$g(ArcimDesc)_""",""id"":"""_$g(ArcItemDr)_"""}"
			i index=1 {
				s myrtn=myrtn_OneJsonData
			}else{
				s myrtn=myrtn_","_OneJsonData
			}
			s index=index+1
		}
	}else{
		s CTDefineDr=$o(^DHCDocCTi(0,"Define","Code",$$ALPHAUP^SSUTIL4(ListType),0))
		s SubRowId=0
		for {
			s SubRowId=$O(^DHCDocCT("DefineData",CTDefineDr,"D",SubRowId))
			q:SubRowId="" 
			s StartDate=$P(^DHCDocCT("DefineData",CTDefineDr,"D",SubRowId),"^",3)
			s Enddate=$P(^DHCDocCT("DefineData",CTDefineDr,"D",SubRowId),"^",4)
			continue:((StartDate'="")&&(StartDate>+$H))
			continue:((Enddate'="")&&(Enddate<+$H))
			s DefineCode=$P(^DHCDocCT("DefineData",CTDefineDr,"D",SubRowId),"^",1)
			s DefineDesc=$P(^DHCDocCT("DefineData",CTDefineDr,"D",SubRowId),"^",2)
			s OneJsonData="{""text"":"""_$g(DefineDesc)_""",""id"":"""_$g(DefineCode)_"""}"
			i index=1 {
				s myrtn=myrtn_OneJsonData
			}else{
				s myrtn=myrtn_","_OneJsonData
			}
			s index=index+1
		}
	}
	s myrtn=myrtn_"]"
	q myrtn
}

}
