Class web.DHCDocMedAudit Extends %RegisteredObject
{

ClassMethod FindDocIPBookingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocIPBookingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMedAudit","FindDocIPBooking")
ClassMethod FindDocIPBookingExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s BookCreateDate=+$h-1
    for{
        s BookCreateDate=$o(^DHCDocIPBK(0,"BookingDate",BookCreateDate))
        q:BookCreateDate=""
        s BookDr=0
        for{
            s BookDr=$o(^DHCDocIPBK(0,"BookingDate",BookCreateDate,BookDr))
            q:BookDr=""
            
            s DocIPBookingObj=##class(User.DHCDocIPBooking).%OpenId(BookDr)
            s AdminDate="",IPBookNo="",AdminWardDesc="",PhoneNo="",InfoStrFlag="",Status="",AuditUserDesc=""
            if $IsObject(DocIPBookingObj){
	            s IPAdmDr=DocIPBookingObj.EpisodeIDToGetObjectId()
	            if (IPAdmDr'=""){
	            	s AdminDate=$p($g(^PAADM(IPAdmDr,"DHC")),"^",31)
	            	s:AdminDate'="" AdminDate=$zd(AdminDate,3)
	            }
	            s IPBookNo=DocIPBookingObj.IPBookNo
	            s AdminWardDr=$p($g(^PAADM(IPAdmDr,"DHC")),"^",34)
	            s:AdminWardDr'="" AdminWardDesc=$p($g(^PAC("PACWD",AdminWardDr)),"^",2)
	            s PhoneNo=DocIPBookingObj.ReceiveSMSPhone
	            s PAPMIDR=$p($g(^PAADM(IPAdmDr)),"^",1)
	            s InfoStrFlag=""
	            s ExistID=$O(^User.DHCDocMedAuditD("PAPMIDR",PAPMIDR,0))
	            s ExistObj=##class(User.DHCDocMedAudit).%OpenId(ExistID)
	            if $IsObject(ExistObj){
		            s StatusCode=ExistObj.Status
		            s Status=$case(StatusCode,"P":"通过","U":"拒绝","O":"其他",:"")
		            s AuditUserDR=ExistObj.AuditUserDRGetObjectId()
		            s:AuditUserDR'="" AuditUserDesc=$p($g(^SSU("SSUSR",AuditUserDR)),"^",2)
	            }
				d ExistObj.%Close()
            }
            
            d DocIPBookingObj.%Close()
            //s IPAdmDr=$p($g(^DHCDocIPBK(BookDr)),"^",3)
			d IPBookingOutputRow
        }
    }
		//do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IPBookingOutputRow      
	set Data=$lb(AdminDate,IPBookNo,AdminWardDesc,PhoneNo,InfoStrFlag,Status,AuditUserDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindDocIPBookingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocIPBookingExecute ]
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

Query FindDocIPBooking() As %Query(ROWSPEC = "AdminDate:%String,IPBookNo:%String,AdminWardDesc:%String,PhoneNo:%String,InfoStrFlag:%String,Status:%String,AuditUserDesc:%String")
{
}

ClassMethod FindDocMedAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocMedAuditExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMedAudit","FindDocMedAudit")
ClassMethod FindDocMedAuditExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//序号	新生成日期	病历号	门诊或住院新建
	s StarDate=+$h-30
	s IntCount=0
	for{
		s StarDate=$O(^User.DHCDocMedAuditD("CreateDS",StarDate))
		q:StarDate=""
		s ExistID=0
		for {
			s ExistID=$O(^User.DHCDocMedAuditD("CreateDS",StarDate,"U",ExistID))
			q:ExistID=""
			s IntCount=IntCount+1
			// 序号	新生成日期	病历号	门诊或住院新建
			s SeqNo=IntCount,CreatDate=$zd(StarDate,3),MedicareNo="",AdmType=""
			s ExistObj=##class(User.DHCDocMedAudit).%OpenId(ExistID)
	        if $IsObject(ExistObj){
				s PatientID=ExistObj.PAPMIDRGetObjectId()
				if PatientID'=""{
					s MedicareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
					if (MedicareNo'=""){
						s:$e(MedicareNo,1)="3" AdmType="住院"
						s:$e(MedicareNo,1)="5" AdmType="门诊"
					}
				}
				
			}
			d MedAuditOutputRow
		}
	}
		//do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
MedAuditOutputRow      
	set Data=$lb(SeqNo,CreatDate,MedicareNo,AdmType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindDocMedAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocMedAuditExecute ]
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

Query FindDocMedAudit() As %Query(ROWSPEC = "SeqNo:%String,CreatDate:%String,MedicareNo:%String,AdmType:%String")
{
}

ClassMethod StatisticsUserWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatisticsUserWorkloadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMedAudit","StatisticsUserWorkload")
ClassMethod StatisticsUserWorkloadExecute(ByRef qHandle As %Binary,SatarDate As %String,EndDate As %String,AuditStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//序号	新生成日期	病历号	门诊或住院新建
	s:SatarDate="" SatarDate=+$h
	s:EndDate="" EndDate=+$h
	s SatarDate=SatarDate-1
	if AuditStatus="" s AuditStatus="P^O"
	for StarDate=SatarDate:1:EndDate{
		s StarDate=$O(^User.DHCDocMedAuditD("CreateDS",StarDate))
		q:StarDate=""
		for AuditStatusInt=1:1:$l(AuditStatus,"^"){
			s OneAuditStatus=$p(AuditStatus,"^",AuditStatusInt)
			s ExistID=0
			for {
				s ExistID=$O(^User.DHCDocMedAuditD("CreateDS",StarDate,OneAuditStatus,ExistID))
				q:ExistID=""
				s ExistObj=##class(User.DHCDocMedAudit).%OpenId(ExistID)
				// 患者ID 、 患者姓名 、 病案号 、 审核日期 、 审核时间 、 审核人 、 审核状态
				s PatientID="",PatientName="",MedicareNo="",AuditDate="",AuditTime="",AuditUserDesc="",Status=""
				if $IsObject(ExistObj){
					s PatientID=ExistObj.PAPMIDRGetObjectId()
					if PatientID'=""{
						s MedicareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
					}
					s AuditDate=ExistObj.AuditDate
					s:AuditDate'="" AuditDate=$zd(AuditDate,1)
					s AuditTime=ExistObj.AuditTime
					s:AuditTime'="" AuditTime=$zt(AuditTime,1)
		            s AuditUserDR=ExistObj.AuditUserDRGetObjectId()
		            s:AuditUserDR'="" AuditUserDesc=$p($g(^SSU("SSUSR",AuditUserDR)),"^",2)
					s StatusCode=ExistObj.Status
		            s Status=$case(StatusCode,"P":"通过","U":"拒绝","O":"其他",:"")
				}
			}
		}
	}
	//do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
UserWorkloadOutputRow      
	set Data=$lb(PatientID,PatientName,MedicareNo,AuditDate,AuditTime,AuditUserDesc,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod StatisticsUserWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatisticsUserWorkloadExecute ]
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

Query StatisticsUserWorkload(SatarDate As %String,EndDate As %String,AuditStatus As %String) As %Query(ROWSPEC = "PatientID:%String,PatientName:%String,MedicareNo:%String,AuditDate:%String,AuditTime:%String,AuditUserDesc:%String,Status:%String")
{
}

}
