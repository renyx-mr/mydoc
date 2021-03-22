Class DHCDoc.DHCDocCure.Record Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// /// w ##class(DHCDoc.DHCDocCure.Record).SaveCureRecordBatch("24048||2",5)
ClassMethod SaveCureRecordBatch(DCRRowIdStr As %String, UserDR As %String, LocDeptDr As %String) As %String
{
	s ^tmpnk("DCRRowIdStr")=DCRRowIdStr_"^"_UserDR_"^"_LocDeptDr
	s retstr=""
	s DCRRowIdStrLen=$l(DCRRowIdStr,"^")
	for count=1:1:DCRRowIdStrLen{
		s DCRRowId="",DCRTitle="",DCRContent=""
		s DCAARowId=$p(DCRRowIdStr,"^",count)
		if (DCRRowId'=""){
			set content=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCRRowId)
		}elseif (DCAARowId'=""){
			set content=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA(DCAARowId)
			s DCRTitle=$p(content,"^",3)
			s DCRContent=$p(content,"^",4)
		}
		
		s Para=DCRRowId_"^"_DCAARowId_"^"_DCRTitle_"^"_DCRContent_"^"_UserDR_"^"_LocDeptDr
		s ret=..SaveCureRecord(Para)
		b ;1
		s msg=""
		if ret="0" s msg=""
		else  if ret="101" s msg="一个预约仅限添加一条治疗记录"
		else  if ret="103" s msg="已取消预约的不能够添加治疗记录"
		else  s msg="添加失败:"_ret	
		if msg'=""{	
			s Data=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowId)
			s ASData=$p(Data,$c(1),1)
			s AppData=$p(Data,$c(1),2)
			s DDCRSDate=$p(ASData,"^",5)   //预约日期

			s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCAARowId)
			s ArcimDesc="",PatientNo="",PatientName=""
			if (CureAppStr'=""){
				s CureAppInfo=$p(CureAppStr,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(CureAppStr,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
			}
			s msg="患者姓名:"_PatientName_" 预约日期:"_DDCRSDate_" "_msg
			
			if retstr="" s retstr=msg
			else  s retstr=retstr_","_msg
		}
	}
	q retstr
}

/// 保存治疗记录  
/// w ##class(DHCDoc.DHCDocCure.Record).SaveCureRecord(^TMP("SaveCureRecord"))
ClassMethod SaveCureRecord(Para As %String) As %String
{
	n (Para)
	s ^TMP("SaveCureRecord")=Para
	s Rowid=$p(Para,"^",1)
	s AppArriveDR=$p(Para,"^",2)
	s DCRTitle=$p(Para,"^",3)
	s DCRContent=$p(Para,"^",4)
	s UserDR=$p(Para,"^",5)
	s LogonLocDr=$p(Para,"^",6)
	s err=103
	if Rowid="" 
	{
		if AppArriveDR=""  Q 100
		s DCRRowId=..GetDCRRowID(AppArriveDR)
		;一个预约仅限开添加一条治疗记录
		if (DCRRowId'="") Q 101
		s OEOREDR=$P($g(^DHCDocCure(+AppArriveDR,"Arrive",$p(AppArriveDR,"||",2))),"^",2)
		;if OEOREDR="" Q 102 ;医嘱在治疗记录的过程中不是必须的
		s DCAAStatus=$p($g(^DHCDocCure(+AppArriveDR,"Arrive",$p(AppArriveDR,"||",2))),"^",7)
		if (DCAAStatus="C") Q 103
		TS
		k PLIST
		s PLIST(0)=+AppArriveDR
		s PLIST(3)=AppArriveDR
		s PLIST(4)=OEOREDR
		s PLIST(5)=DCRTitle
		s PLIST(6)=DCRContent
		s PLIST(7)=UserDR
		s PLIST(8)=+$h
		s PLIST(9)=$p($h,",",2)
		s PLIST(13)="Y"
	 	&sql(insert into SQLUser.DHC_DocCureRecode values :PLIST())
	 	s err=SQLCODE
	 	if err'=0
	 	{
		 	TRO
		 	q err
		}
	 	s err=##class(DHCDoc.DHCDocCure.Appointment).AppArrive(AppArriveDR,UserDR,LogonLocDr)
	 	if err'=0
	 	{
		 	TRO
		 	q err
		}
		s Resource="Record"
		d ##class(DHCDoc.DHCDocCure.ExecApply).FinishCureApply(+AppArriveDR,UserDR,1,"E",Resource,"",LogonLocDr)
		TC 
	}else{
		s OldData=..GetCureRecord(Rowid)
		k PLIST
		s PLIST(5)=DCRTitle
		s PLIST(6)=DCRContent
		s PLIST(10)=UserDR
		s PLIST(11)=+$h
		s PLIST(12)=$p($h,",",2)
		&sql(update SQLUser.DHC_DocCureRecode VALUES :PLIST() WHERE  DCR_RowId=:Rowid )
	    s err=SQLCODE
	    if ('err){
			d ..SaveFileLog(OldData,Rowid,UserDR)    
	}
	}
  Q err
}

/// w ##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA("1105||1")
ClassMethod GetCureRecordByDCA(AppArriveDR, SpecFlag As %String = "") As %String
{
	n (AppArriveDR,SpecFlag)
	s CureRecordInfo=""
	Quit:AppArriveDR="" CureRecordInfo
	s DCRRowId=..GetDCRRowID(AppArriveDR)
	if DCRRowId'=""{
		s CureRecordInfo=..GetCureRecord(DCRRowId)
	}else{
		Set CureData=$g(^DHCDocCure(+AppArriveDR))
		Set Adm=$p(CureData,"^",1)
		Q:Adm="" ""
		Set PatientId=$P($G(^PAADM(Adm)),"^",1)
		Set OrderId=$p(CureData,"^",2)
		q:OrderId="" ""
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		q:ArcimId="" ""
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
		s DCRContent="正常执行(默认)"
		if SpecFlag=1 s DCRContent=""
		s CureRecordInfo=AppArriveDR_"^"_""_"^"_ArcimDesc_"^"_DCRContent_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""	
	}
	q CureRecordInfo
}

/// 获取医嘱提示信息
/// w ##class(DHCDoc.DHCDocCure.Record).GetAlertMesage("5679||1")
ClassMethod GetAlertMesage(AppArriveDR) As %String
{
	Q:AppArriveDR="" ""
	s OEOREDR=$P($g(^DHCDocCure(+AppArriveDR,"Arrive",$p(AppArriveDR,"||",2))),"^",2)
	if OEOREDR'=""  d
	.s ArcimRowId=$p($g(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),1)),"^",2)
	else  d
	.s ArcimRowId=$P($G(^DHCDocCure(+AppArriveDR)),"^",12)
	Q:ArcimRowId="" ""
	s Flag=$P($G(^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),9)),"^",22)
	;Q:Flag'="Y" ""
	s ID=$O(^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),"OEM",0))
	Q:ID="" ""
	s Mesag=$G(^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),"OEM",ID))
	Q:Mesag="" ""
	s ARCIMDesc=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",2)
	q ARCIMDesc_","_Mesag
}

/// 取单条治疗记录
/// w ##class(DHCDoc.DHCDocCure.Record).GetCureRecord("1||1")
ClassMethod GetCureRecord(DCRRowId) As %String
{
	n (DCRRowId)
	Quit:DCRRowId="" ""
	s CureRecordInfo=""
	Set Data=$g(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)))
	Q:Data="" ""
	Set AppArriveDR=$p(Data,"^",1)
	Set OEOREDR=$p(Data,"^",2)
	Set DCRTitle=$p(Data,"^",3)
	Set DCRContent=$p(Data,"^",4)
	Set CreateUserDR=$p(Data,"^",5)
	s:CreateUserDR'="" CreateUser=$p($g(^SSU("SSUSR",CreateUserDR)),"^",2)
	Set CreateDate=$p(Data,"^",6)
	;s:CreateDate'="" CreateDate=$zd(CreateDate,1)
	s CreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
	Set CreateTime=$p(Data,"^",7)
	s:CreateTime'="" CreateTime=$zt(CreateTime,1)
	s CreateDate=CreateDate_" "_CreateTime
	Set UpdateUserDR=$p(Data,"^",8)
	s:UpdateUserDR'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	Set UpdateDate=$p(Data,"^",9)
	;s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1)
	s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	Set UpdateTime=$p(Data,"^",10)
	s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	s UpdateDate=UpdateDate_" "_UpdateTime
	s CureRecordInfo=AppArriveDR_"^"_OEOREDR_"^"_DCRTitle_"^"_DCRContent_"^"_CreateUserDR_"^"_$g(CreateUser)_"^"_CreateDate_"^"_UpdateUserDR_"^"_$g(UpdateUser)_"^"_UpdateDate
	q CureRecordInfo
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询单个申请单的治疗记录
/// Table: 		  DHC_DocCureRecord
/// Input：        EpisodeID:就诊ID
/// 
Query FindCureRecordList(DCARowIdStr As %String, DCAOEOREDR As %String = "", Type As %String = "") As %Query(ROWSPEC = "Rowid:%String,DCRTitle:%String,CreateUser:%String,CreateDate:%String,UpdateUser:%String,UpdateDate:%String,PatientNo:%String,PatientName:%String,ArcimDesc:%String,ID:%String,DDCRSLoc:%String,CTCareProv:%String,DDCRSDate:%String,TimeRangeDesc:%String,ServiceGroupDesc:%String,DCAAStatus:%String,DCAARowId:%String")
{
}

ClassMethod FindCureRecordListExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, DCAOEOREDR As %String = "", Type As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Record","FindCureRecordList","34||1","","APP")
	s ^tmpnk("FindCureRecordList")=DCARowIdStr_","_DCAOEOREDR_","_Type
	Set repid=$I(^CacheTemp)
	Set ind=1
	if DCARowIdStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DCARowIdLen=$l(DCARowIdStr,"!")
	for mycount=1:1:DCARowIdLen{
		s DCARowId=$P(DCARowIdStr,"!",mycount)
		if Type="APP" {
			s DCRChildSub=0
			for {
				s DCRChildSub=$o(^DHCDocCure(0,"AppArriveDR",DCARowId,+DCARowId,DCRChildSub))
			q:DCRChildSub=""
			s DCRRowId=+DCARowId_"||"_DCRChildSub
				s DCRActive=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",11)
				continue:DCRActive'="Y"
			d OutputRowApply
			}
		}else{
			s DCRChildSub=0 for  s DCRChildSub=$o(^DHCDocCure(DCARowId,"Recode",DCRChildSub)) q:DCRChildSub=""  d
			.s DCRRowId=DCARowId_"||"_DCRChildSub
			.s DCRActive=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",11)
			.Q:DCRActive'="Y"
			.d OutputRowApply
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApply 
	s CureRecordInfo=..GetCureRecord(DCRRowId)
	s DCROEOREDR=$p(CureRecordInfo,"^",2)
	Q:(DCAOEOREDR'="")&&(DCAOEOREDR'=DCROEOREDR)
	s DCAARowId=$p(CureRecordInfo,"^",1)
	s (DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus)=""
	if DCAARowId'=""  d
	.s Data=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowId)
	.s ASData=$p(Data,$c(1),1)
	.s AppData=$p(Data,$c(1),2)
	.;------排班信息-------
	.s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	.s CTCareProv=$p(ASData,"^",4)  //预约资源
	.s DDCRSDate=$p(ASData,"^",5)   //预约日期
	.s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	.s StartTime=$p(ASData,"^",8)
	.s EndTime=$p(ASData,"^",9)
	.s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	.s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	.s DCAAStatus=$p(AppData,"^",8) //预约状态
	.
	s DCRTitle=$p(CureRecordInfo,"^",3)
	s CreateUser=$p(CureRecordInfo,"^",6)
	s CreateDate=$p(CureRecordInfo,"^",7)
	s UpdateUser=$p(CureRecordInfo,"^",9)
	s UpdateDate=$p(CureRecordInfo,"^",10)
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCARowId)
	s ArcimDesc="",PatientNo="",PatientName=""
	if (CureAppStr'="") d
	.s CureAppInfo=$p(CureAppStr,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s PatientInfo=$p(CureAppStr,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	set Data=$lb(DCRRowId,DCRTitle,CreateUser,CreateDate,UpdateUser,UpdateDate,PatientNo,PatientName,ArcimDesc,DCRRowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus,DCAARowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureRecordListExecute ]
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
	Quit $$$OK
}

/// Creator：     宋春莉
/// CreatDate：   2016-06-15
/// Description:：根据医嘱ID查找是否存在治疗结果记录
/// Table: 		  DHC_DocCureRecord
/// Input：       OEORIRowId:医嘱ID
/// OutPut:       1 存在 0 不存在
/// w ##class(DHCDoc.DHCDocCure.Record).FindCureRecordByOEORI("1584||28")
ClassMethod FindCureRecordByOEORI(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	s FindCureRecord=0
	s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowId,""))
	Q:DCARowId="" FindCureRecord
	s DCRChildSub=$o(^DHCDocCure(DCARowId,"Recode",""))
	i DCRChildSub'="" s FindCureRecord=1
	Q FindCureRecord
}

ClassMethod SaveFileLog(OldData As %String, RowId As %String, UserID As %String, Type As %String = "") As %String
{
	n (%session,OldData,RowId,UserID,Type)
	s UPUserIP=$zutil(67,15,$j)   //获取IP地址
    s UPDate=+$h
 	s UPTime=$p($h,",",2)
    s OldTitle=$p(OldData,"^",3)
    s OldContent=$p(OldData,"^",4)
    s UpdStr=""
    if Type'="DEL"{
		s NewData=..GetCureRecord(RowId)
	    s NewTitle=$p(NewData,"^",3)
	    s NewContent=$p(NewData,"^",4)
	    if (OldTitle'=NewTitle)  d
	    .i UpdStr="" s UpdPropertyStr="治疗标题"_"由'"_OldTitle_"'改成了'"_NewTitle_"'"
	    .e  s UpdStr=UpdStr_";"_"治疗标题"_"由'"_OldTitle_"'改成了'"_NewTitle_"'"
		if (OldContent'=NewContent)  d
		.i UpdStr="" s UpdStr="治疗内容"_"由'"_OldContent_"'改成了'"_NewContent_"'"
		.e  s UpdStr=UpdPropertyStr_";"_"治疗内容"_"由'"_OldContent_"'改成了'"_NewContent_"'"
    }else{
		s UpdStr="撤消了治疗标题为"_OldTitle_",治疗内容为"_OldContent_"的治疗记录"
	}
	k PLIST
	s PLIST(0)=RowId
	s PLIST(3)=UPDate
	s PLIST(4)=UPTime
	s PLIST(5)=UserID
	s PLIST(6)=UpdStr
	s PLIST(7)=UPDate
	s PLIST(8)=UPTime
	&sql(insert into SQLUser.DHC_DocCureRecodeChange values :PLIST())
    q SQLCODE
}

/// w ##class(DHCDoc.DHCDocCure.Record).CancelRecord("2||1",1)
ClassMethod CancelRecord(DCRRowId As %String, UserID As %String)
{
	s Active="N"
	s UPDate=+$h
 	s UPTime=$p($h,",",2)
 	s checkret=##class(DHCDoc.DHCDocCure.ExecApply).CheckBeforeUpdateExec(+DCRRowId,UserID)
	Q:checkret'="" "-205^"_checkret
	Ts
	s Data=..GetCureRecord(DCRRowId)
	&sql(update  SQLUser.DHC_DocCureRecode set DCR_Active=:Active,DCR_LastUpdateUser_DR=:UserID,DCR_LastUpdateDate=:UPDate,DCR_LastUpdateTime=:UPTime where DCR_RowId=:DCRRowId)
	if 'SQLCODE{
		s err= ..SaveFileLog(Data,DCRRowId,UserID,"DEL")	
		if err{
			Tro
			Q "-100^"_"保存治疗记录变更记录数据错误,错误代码："_SQLCODE	
		}
		s DCAARowId=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",1)
		if (DCAARowId=""){
			Q "-102^"_"治疗预约记录指向为空"	
		}
		k PLIST
		s PLIST(9)="I"
		s PLIST(10)=UserID
		s PLIST(11)=UPDate
		s PLIST(12)=UPTime
		&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
		if SQLCODE
	    {
		    Trollback
			Quit "-102^"_"更新治疗预约记录错误,错误代码："_SQLCODE	
		}
		s OEOREDR=$P($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",2)
		s rtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"C",UserID,+$H,"","")
		if rtn'=0{
			Trollback
			Quit "-102^"_"更新执行记录错误,错误代码："_rtn
		}
		s AppEexcNum=+$p(^DHCDocCure(+DCRRowId),"^",15)
		s AppEexcNum=AppEexcNum-1
		s CureObj=##class(User.DHCDocCureApp).%OpenId(+DCRRowId)
		if $IsObject(CureObj){
			s CureObj.DCAExecNum=AppEexcNum
			d CureObj.%Save()
		}
	}else{
		tro
		Q "-101^"_"更新治疗记录错误,错误代码："_SQLCODE	
	}
	Tc
	Q 0
}

ClassMethod GetDCRRowID(AppArriveDR As %String)
{
	n (AppArriveDR)
	s DCRRowID=""
	s DCRChildSub=0
	for {
		s DCRChildSub=$o(^DHCDocCure(0,"AppArriveDR",AppArriveDR,+AppArriveDR,DCRChildSub))
		q:DCRChildSub=""
		s DCRActive=$p(^DHCDocCure(+AppArriveDR,"Recode",DCRChildSub),"^",11)
		continue:DCRActive'="Y"	
		s DCRRowID=+AppArriveDR_"||"_DCRChildSub
	}
	Q DCRRowID
}

}
