Class DHCDoc.Interface.NeusoftAlloc Extends %RegisteredObject
{

ClassMethod QueryAdmInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// input:就这类型（"O^E" 或者 "I"）,科室code，医生code，登记号，姓名
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.NeusoftAlloc","QueryAdmInfoList",1,"")
ClassMethod QueryAdmInfoListExecute(ByRef qHandle As %Binary, LocCode As %String, DocCode As %String, PatNo As %String, PatName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s AdmDate=+$h
    s AdmId=0
    for {
        s AdmId=$o(^PAADMi("PAADM_AdmDate",AdmDate,AdmId))
        q:AdmId=""
        s AdmType=$p($g(^PAADM(AdmId)),"^",2)
        s AdmPatId=$p($g(^PAADM(AdmId)),"^",1)
        s AdmPatNo=$p($g(^PAPER(AdmPatId,"PAT",1)),"^",1)
        continue:(PatNo'="")&&(AdmPatNo'=PatNo)
        s AdmPatName=$p($g(^PAPER(AdmPatId,"ALL")),"^",1)
        continue:(PatName'="")&&(PatName'=AdmPatName)
        s AdmLocDr=$p($g(^PAADM(AdmId)),"^",4)
        s AdmLocCode=$p($g(^CTLOC(AdmLocDr)),"^",1)
        continue:(LocCode'="")&&(AdmLocCode'=LocCode)
        s AdmLocDesc=$p($g(^CTLOC(AdmLocDr)),"^",2)
        s AdmDocDR=$p($g(^PAADM(AdmId)),"^",9)
        s AdmDocCode=$p($g(^CTPCP(AdmDocDR,1)),"^",1)
        continue:(DocCode'="")&&(DocCode'=AdmDocCode)
        s AdmDocName=$p($g(^CTPCP(AdmDocDR,1)),"^",2)
        s AdmSexDr=$p($g(^PAPER(AdmPatId,"ALL")),"^",7)
        s AdmSexCode="",AdmSexDesc=""
        s:AdmSexDr'="" AdmSexCode=$p($g(^CT("SEX",AdmSexDr)),"^",1)
        s:AdmSexDr'="" AdmSexDesc=$p($g(^CT("SEX",AdmSexDr)),"^",2)
        s Address=$g(^PAPER(AdmPatId,"PER","ADD",1))
		s AdmNationDr=$p($g(^PAPER(AdmPatId,"PER",2)),"^",1)
		s AdmNationCode="",AdmNationDesc=""
		s:AdmNationDr'="" AdmNationCode=$p($g(^CT("NAT",AdmNationDr)),"^",1)
		s:AdmNationDesc'="" AdmNationDesc=$p($g(^CT("NAT",AdmNationDr)),"^",2)
		s Marital=$p($g(^PAPER(AdmPatId,"PER",2)),"^",3)
		s MaritalCode="",MaritalName=""
		s:Marital'="" MaritalCode=$p($g(^CT("MAR",Marital)),"^",1)
		s:Marital'="" MaritalName=$p($g(^CT("MAR",Marital)),"^",2)
		s BirthDate=$p($g(^PAPER(AdmPatId,"ALL")),"^",6)
		s:BirthDate'="" BirthDate=##class(websys.Conversions).DateLogicalToHtml(BirthDate)
		s PatAge=##class(web.DHCBillInterface).GetPapmiAge(AdmPatId,AdmId)
		s DVAnumber=$p($g(^PAPER(AdmPatId,"PAT",3)),"^",6)
    	s CreadTypeDr=$p($g(^PAPER(AdmPatId,"PAT",3)),"^",7)
    	s CreadTypeCode="",CreadTypeDesc=""
    	s:CreadTypeDr'="" CreadTypeCode=$p($g(^PAC("CARD",CreadTypeDr)),"^",1)
    	s:CreadTypeDr'="" CreadTypeDesc=$p($g(^PAC("CARD",CreadTypeDr)),"^",2)
    	;住院累计数
    	s ExemptionNumber=$p($g(^PAPER(AdmPatId,"PER",4)),"^",8)
    	// 入院时间
    	s AdmDate=$p($g(^PAADM(AdmId)),"^",6)
    	s AdmTime=$p($g(^PAADM(AdmId)),"^",7)
    	s AdmDateStr=$replace(AdmDate,"-","")_$replace(AdmTime,":","")
    	//病区
    	s CurrentWardDR=$p($g(^PAADM(AdmId)),"^",70)
    	s WardCode="",WardName=""
    	s:CurrentWardDR'="" WardCode=$p($g(^PAWARD(CurrentWardDR)),"^",1)
    	s:CurrentWardDR'="" WardName=$p($g(^PAWARD(CurrentWardDR)),"^",2)
    	// BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc
    	s CurrentRoomDR=$p($g(^PAADM(AdmId)),"^",69)
    	s RoomCode=""
    	s:CurrentRoomDR'="" RoomCode=$p($g(^PAROOM(CurrentRoomDR)),"^",1)
    	s CurrentBedDR=$p($g(^PAADM(AdmId)),"^",73)
    	s BedCode=""
    	s:CurrentBedDR'="" BedCode=$p($g(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2))),"^",1)
        do QueryAdmInfoListRow
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryAdmInfoListRow
	;登记号，姓名，科室code，科室name，医生code，医生name，性别code，性别name，民族code，民族name，婚姻code，婚姻name，出生日期，年龄，证件号，证件类型code，证件类型name，住院次数，入院时间，病区code，病区name，病房code，床号code
	set Data=$lb(AdmPatNo,AdmPatName,AdmLocCode,AdmLocDesc,AdmDocCode,AdmDocName,AdmSexCode,AdmSexDesc,AdmNationCode,AdmNationDesc,MaritalCode,MaritalName,BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc,ExemptionNumber,AdmDateStr,WardCode,WardName,RoomCode,BedCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryAdmInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmInfoListExecute ]
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

Query QueryAdmInfoList(LocCode As %String, DocCode As %String, PatNo As %String, PatName As %String) As %Query(ROWSPEC = "AdmPatNo,AdmPatName,AdmLocCode,AdmLocDesc,AdmDocCode,AdmDocName,AdmSexCode,AdmSexDesc,AdmNationCode,AdmNationDesc,MaritalCode,MaritalName,BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc,ExemptionNumber,AdmDateStr,WardCode,WardName,RoomCode,BedCode")
{
}

ClassMethod QueryIPAdmInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPAdmInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// input:就这类型（"O^E" 或者 "I"）,科室code，医生code，登记号，姓名
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.NeusoftAlloc","QueryAdmInfoList",1,"")
ClassMethod QueryIPAdmInfoListExecute(ByRef qHandle As %Binary, LocCode As %String, DocCode As %String, MedicareNo As %String, PatName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s AdmDate=+$h
    s AdmId=0
    for {
        s AdmId=$o(^PAADMi("PAADM_AdmDate",AdmDate,AdmId))
        q:AdmId=""
        s AdmType=$p($g(^PAADM(AdmId)),"^",2)
        s AdmPatId=$p($g(^PAADM(AdmId)),"^",1)
        s AdmMedicareNo=$p($g(^PAPER(AdmPatId,"PAT",1)),"^",22)
        continue:(MedicareNo'="")&&(AdmMedicareNo'=MedicareNo)
        s AdmPatName=$p($g(^PAPER(AdmPatId,"ALL")),"^",1)
        continue:(PatName'="")&&(PatName'=AdmPatName)
        s AdmLocDr=$p($g(^PAADM(AdmId)),"^",4)
        s AdmLocCode=$p($g(^CTLOC(AdmLocDr)),"^",1)
        continue:(LocCode'="")&&(AdmLocCode'=LocCode)
        s AdmLocDesc=$p($g(^CTLOC(AdmLocDr)),"^",2)
        s AdmDocDR=$p($g(^PAADM(AdmId)),"^",9)
        s AdmDocCode=$p($g(^CTPCP(AdmDocDR,1)),"^",1)
        continue:(DocCode'="")&&(DocCode'=AdmDocCode)
        s AdmDocName=$p($g(^CTPCP(AdmDocDR,1)),"^",2)
        s AdmSexDr=$p($g(^PAPER(AdmPatId,"ALL")),"^",7)
        s AdmSexCode="",AdmSexDesc=""
        s:AdmSexDr'="" AdmSexCode=$p($g(^CT("SEX",AdmSexDr)),"^",1)
        s:AdmSexDr'="" AdmSexDesc=$p($g(^CT("SEX",AdmSexDr)),"^",2)
        s Address=$g(^PAPER(AdmPatId,"PER","ADD",1))
		s AdmNationDr=$p($g(^PAPER(AdmPatId,"PER",2)),"^",1)
		s AdmNationCode="",AdmNationDesc=""
		s:AdmNationDr'="" AdmNationCode=$p($g(^CT("NAT",AdmNationDr)),"^",1)
		s:AdmNationDesc'="" AdmNationDesc=$p($g(^CT("NAT",AdmNationDr)),"^",2)
		s Marital=$p($g(^PAPER(AdmPatId,"PER",2)),"^",3)
		s MaritalCode="",MaritalName=""
		s:Marital'="" MaritalCode=$p($g(^CT("MAR",Marital)),"^",1)
		s:Marital'="" MaritalName=$p($g(^CT("MAR",Marital)),"^",2)
		s BirthDate=$p($g(^PAPER(AdmPatId,"ALL")),"^",6)
		s:BirthDate'="" BirthDate=##class(websys.Conversions).DateLogicalToHtml(BirthDate)
		s PatAge=##class(web.DHCBillInterface).GetPapmiAge(AdmPatId,AdmId)
		s DVAnumber=$p($g(^PAPER(AdmPatId,"PAT",3)),"^",6)
    	s CreadTypeDr=$p($g(^PAPER(AdmPatId,"PAT",3)),"^",7)
    	s CreadTypeCode="",CreadTypeDesc=""
    	s:CreadTypeDr'="" CreadTypeCode=$p($g(^PAC("CARD",CreadTypeDr)),"^",1)
    	s:CreadTypeDr'="" CreadTypeDesc=$p($g(^PAC("CARD",CreadTypeDr)),"^",2)
    	;住院累计数
    	s ExemptionNumber=$p($g(^PAPER(AdmPatId,"PER",4)),"^",8)
    	// 入院时间
    	s AdmDate=$p($g(^PAADM(AdmId)),"^",6)
    	s AdmTime=$p($g(^PAADM(AdmId)),"^",7)
    	s AdmDateStr=$replace(AdmDate,"-","")_$replace(AdmTime,":","")
    	//病区
    	s CurrentWardDR=$p($g(^PAADM(AdmId)),"^",70)
    	s WardCode="",WardName=""
    	s:CurrentWardDR'="" WardCode=$p($g(^PAWARD(CurrentWardDR)),"^",1)
    	s:CurrentWardDR'="" WardName=$p($g(^PAWARD(CurrentWardDR)),"^",2)
    	// BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc
    	s CurrentRoomDR=$p($g(^PAADM(AdmId)),"^",69)
    	s RoomCode=""
    	s:CurrentRoomDR'="" RoomCode=$p($g(^PAROOM(CurrentRoomDR)),"^",1)
    	s CurrentBedDR=$p($g(^PAADM(AdmId)),"^",73)
    	s BedCode=""
    	s:CurrentBedDR'="" BedCode=$p($g(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2))),"^",1)
        do QueryIPAdmInfoListRow
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryIPAdmInfoListRow
	;登记号，姓名，科室code，科室name，医生code，医生name，性别code，性别name，民族code，民族name，婚姻code，婚姻name，出生日期，年龄，证件号，证件类型code，证件类型name，住院次数，入院时间，病区code，病区name，病房code，床号code
	set Data=$lb(AdmPatNo,AdmPatName,AdmLocCode,AdmLocDesc,AdmDocCode,AdmDocName,AdmSexCode,AdmSexDesc,AdmNationCode,AdmNationDesc,MaritalCode,MaritalName,BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc,ExemptionNumber,AdmDateStr,WardCode,WardName,RoomCode,BedCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryIPAdmInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPAdmInfoListExecute ]
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

Query QueryIPAdmInfoList(LocCode As %String, DocCode As %String, PatNo As %String, PatName As %String) As %Query(ROWSPEC = "AdmPatNo,AdmPatName,AdmLocCode,AdmLocDesc,AdmDocCode,AdmDocName,AdmSexCode,AdmSexDesc,AdmNationCode,AdmNationDesc,MaritalCode,MaritalName,BirthDate,PatAge,DVAnumber,CreadTypeCode,CreadTypeDesc,ExemptionNumber,AdmDateStr,WardCode,WardName,RoomCode,BedCode")
{
}

}
