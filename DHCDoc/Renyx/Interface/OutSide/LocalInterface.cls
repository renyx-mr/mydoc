Class DHCDoc.Renyx.Interface.OutSide.LocalInterface Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindPatQueInfo","2020-11-01","2020-11-15")
Query FindPatQueInfo(StDate As %String, EndDate As %String = "") As %Query(ROWSPEC = "queue_id:%String,Patient_info_id:%String,patient_name:%String,patient_sex:%String,queue_type_id:%String,register_id:%String,queue_num:%Double,sub_queue_order:%TinyInt,sub_queue_type:%String,time_interval:%BigInt,doctor_login_id:%String,is_deleted:%String,reserve_time:%DateTime,reserve_end_time:%DateTime,content:%String") [ SqlProc ]
{
}

ClassMethod FindPatQueInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.OutSide.LocalInterface","FindPatQueInfo","","")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	
 	s:StDate'="" StDate=$zdh(StDate,3)
 	s:EndDate'="" EndDate=$zdh(EndDate,3)
 	
 	i StDate="" s StDate=+$h
 	i EndDate="" s EndDate=+$h
 	
 	s LocStr="316^317^318^319"
 	
 	f Date=StDate:1:EndDate d
 	.s AdmId=0  f  s AdmId=$o(^PAADMi("PAADM_AdmDate",Date,AdmId)) q:AdmId=""  d
 	..s PatientId=$p(^PAADM(AdmId),"^",1)
 	..s AdmType=$p(^PAADM(AdmId),"^",2)
 	..q:AdmType="H"
 	..s PatientName=$p(^PAPER(PatientId,"ALL"),"^",1)
 	..s PatSexDr=$p(^PAPER(PatientId,"ALL"),"^",7)
 	..s SexDesc=$p(^CT("SEX",PatSexDr),"^",2)
 	..s RegId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmId,""))
 	..q:RegId=""
 	..;s QueNo=$List(^User.DHCRegistrationFeeD(RegId),8)
 	..s queueorder="0"
 	..s queuetype=""
 	..s interval="34359738367"
 	..s OrdId=$O(^OEORD(0,"Adm",AdmId,0))
 	..q:OrdId=""
 	..s Child=0  f  s Child=$o(^OEORD(OrdId,"I",Child)) q:Child=""  d
 	...s OrdRecDr=$p(^OEORD(OrdId,"I",Child,3),"^",6)
 	...;i ("^"_LocStr_"^")[("^"_OrdRecDr_"^") b ;1
 	...q:("^"_LocStr_"^")'[("^"_OrdRecDr_"^")
 	...s OrdStatus=$p(^OEORD(OrdId,"I",Child,1),"^",13)
 	...q:(OrdStatus'="1")&&(OrdStatus'="6")
 	...;renyx 更新队列类型  
 	...if OrdRecDr="316" d
 	....if (PatSexDr=1) s queuetype=OrdRecDr
 	....e  s queuetype=320
 	...e  s queuetype=OrdRecDr
 	...s OrdDepDesc=$p(^CTLOC(OrdRecDr),"^",2)
 	...s UserId=$p(^OEORD(OrdId,"I",Child,7),"^",1)
 	...s QueNo=Child
 	...s isdeleted="0"
 	...s OrdDate=$p(^OEORD(OrdId,"I",Child,3),"^",7)
 	...s OrdTime=$p(^OEORD(OrdId,"I",Child,1),"^",17)
 	...s:OrdDate'="" OrdDate=$zd(OrdDate,3)
 	...s:OrdTime'="" OrdTime=$zt(OrdTime)
 	...s OrdDateTime=OrdDate_" "_OrdTime
 	...s EndDate=""
 	...s Content=""
 	 	
	...Do OutputRow20
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow20
	set Data=$lb(RegId,PatientId,PatientName,SexDesc,OrdDepDesc,QueNo,QueNo,queueorder,queuetype,interval,UserId,isdeleted,OrdDateTime,EndDate,Content)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPatQueInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatQueInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatQueInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatQueInfoExecute ]
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

ClassMethod QueryDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Renyx.Interface.OutSide.LocalInterface","QueryDoctor",1,"")
ClassMethod QueryDoctorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	&sql(DECLARE DoctorList CURSOR FOR
		SELECT SSUSR_RowId,SSUSR_Name,SSUSR_DefaultDept_DR->CTLOC_Desc,SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc
		INTO :DocCode,:DocDesc,:DepDesc,:CarPrvTpDesc
		FROM SQLUser.SS_User 
		WHERE SSUSR_DefaultDept_DR IN ("316","317","318","319")
	)
	&SQL(OPEN DoctorList)
	s intNum=0
 	For {
	 	&SQL(FETCH DoctorList) 
	 	QUIT:SQLCODE
	 	do OutputRow
 	}
 	&SQL(CLOSE DoctorList)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(DocCode,DocDesc,DepDesc,CarPrvTpDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorExecute ]
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

Query QueryDoctor() As %Query(ROWSPEC = "login_id:%String,name:%String,department:%String,title:%String") [ SqlProc ]
{
}

ClassMethod QueryQueTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQueTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 	队列类型   
/// d ##class(%ResultSet).RunQuery("web.DHCDocExtData","HisCodeQuery",1,"")
ClassMethod QueryQueTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s LocStr="316^317^318^319"
	for i=1:1:$l(LocStr,"^"){
		if ($p(LocStr,"^",1)=316){
			s LocDr=$p(LocStr,"^",1)
			s LocDesc=$p($g(^CTLOC($p(LocStr,"^",1))),"^",2)_"(男)"
			s LocDescE=LocDesc
			do OutputRow
			s LocDr="320"
			s LocDesc=$p($g(^CTLOC($p(LocStr,"^",1))),"^",2)_"(女)"
			s LocDescE=LocDesc
			do OutputRow
		}else{
			s LocDr=$p(LocStr,"^",1)
			s LocDesc=$p($g(^CTLOC($p(LocStr,"^",1))),"^",2)
			s LocDescE=LocDesc
			do OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(LocDr,LocDesc,LocDescE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryQueTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQueTypeExecute ]
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

Query QueryQueType() As %Query(ROWSPEC = "queue_type_id:%String,name:%String,display_name:%String")
{
}

ClassMethod GetPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocExtData","HisCodeQuery",1,"")
ClassMethod GetPatInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s:StDate'="" StDate=$zdh(StDate,3)
 	s:EndDate'="" EndDate=$zdh(EndDate,3)
 	
 	i StDate="" s StDate=+$h
 	i EndDate="" s EndDate=+$h
 	
 	s LocStr="316^317^318^319"
 	k PatInfoList
 	f Date=StDate:1:EndDate{
	 	s AdmId=0
	 	f{
		 	s AdmId=$o(^PAADMi("PAADM_AdmDate",Date,AdmId)) 
		 	q:AdmId=""
 			s PatientId=$p(^PAADM(AdmId),"^",1)
 			s AdmType=$p(^PAADM(AdmId),"^",2)
 			continue:AdmType="I"
 			continue:AdmType="H"
 			s RegId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmId,""))
 			continue:RegId=""
 			s OrdId=$O(^OEORD(0,"Adm",AdmId,0))
 			continue:OrdId=""
 			s Child=0  
 			f{
	 			s Child=$o(^OEORD(OrdId,"I",Child)) 
	 			q:Child=""
 				s OrdRecDr=$p(^OEORD(OrdId,"I",Child,3),"^",6)
 				continue:("^"_LocStr_"^")'[("^"_OrdRecDr_"^")
 				s OrdStatus=$p(^OEORD(OrdId,"I",Child,1),"^",13)
 				continue:(OrdStatus'="1")&&(OrdStatus'="6")
 				s PatInfoList(PatientId)=""
 			}
	 	}
 	}
 	s PatInd=0
 	for {
	 	s PatInd=$o(PatInfoList(PatInd))
	 	q:PatInd=""
	 	///s PatDr=
	 	s PatNo=PatInd //$p($g(^PAPER(PatInd,"PAT",1)),"^",1)
	 	s PatName=$p(^PAPER(PatInd,"ALL"),"^",1)
	 	s PatId=$p($g(^PAPER(PatInd,"PAT",3)),"^",6)
	 	s PatCardNo=""
	 	s PatInsuNO=""
	 	do OutputRow
 	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(PatNo,PatName,PatId,PatCardNo,PatInsuNO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod GetPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoExecute ]
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

Query GetPatInfo(StDate As %String, EndDate As %String = "") As %Query(ROWSPEC = "patient_info_id:%String,patient_info_name:%String,id_card:%String,hospital_card:%String,social_security_card:%String")
{
}

}
