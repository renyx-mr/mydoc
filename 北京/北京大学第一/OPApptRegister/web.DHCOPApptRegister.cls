Class web.DHCOPApptRegister Extends %RegisteredObject
{

ClassMethod DeleteApptRegister(ApptRegisterDr As %String)
{
    &sql(delete from SQLUser.DHC_OPApptRegister where OPAPPT_RowID=:ApptRegisterDr)
    Q SQLCODE
}

/// w ##class(web.DHCOPApptRegister).SaveApptRegister("","^2021-06-01^^王五流^2^1677999^^^^2021-06-01^123^124123^12312^123123^123","12177")
ClassMethod SaveApptRegister(ApptRegisterDr As %String, DataStr As %String, UserId As %String)
{
	s ^tempRen("SaveApptRegister")=$lb(ApptRegisterDr,DataStr,UserId)
	ts
	if (ApptRegisterDr'=""){
		s ApptRegisterObj=##class(User.DHCOPApptRegister).%OpenId(ApptRegisterDr)
	}else{
		s ApptRegisterObj=##class(User.DHCOPApptRegister).%New()
	}
	if $IsObject(ApptRegisterObj){
        d:$p(DataStr,"^",1)'="" ApptRegisterObj.OPAPPTPAPMIDRSetObjectId($p(DataStr,"^",1))
		s:$p(DataStr,"^",2)'="" ApptRegisterObj.OPAPPTDate=##class(websys.Conversions).DateHtmlToLogical($p(DataStr,"^",2)) //$p(DataStr,"^",2)
        s ApptRegisterObj.OPAPPTWeek=$p(DataStr,"^",3)
        s ApptRegisterObj.OPAPPTPatName=$p(DataStr,"^",4)
        d:$p(DataStr,"^",5)'="" ApptRegisterObj.OPAPPTPatSexSetObjectId($p(DataStr,"^",5))
        s ApptRegisterObj.OPAPPTPatPhone=$p(DataStr,"^",6)
        s ApptRegisterObj.OPAPPTPatAdmDesc=$p(DataStr,"^",7)
        s ApptRegisterObj.OPAPPTPatAdmLoc=$p(DataStr,"^",8)
        s ApptRegisterObj.OPAPPTPatAdmDoc=$p(DataStr,"^",9)
        s:$p(DataStr,"^",10)'="" ApptRegisterObj.OPAPPTApptDate=##class(websys.Conversions).DateHtmlToLogical($p(DataStr,"^",10)) //$p(DataStr,"^",10)
        s ApptRegisterObj.OPAPPTCurrentReg=$p(DataStr,"^",11)
        s ApptRegisterObj.OPAPPTPatCarNo=$p(DataStr,"^",12)
        s ApptRegisterObj.OPAPPTRegisterStatus=$p(DataStr,"^",13)
        s ApptRegisterObj.OPAPPTRegisterDesc=$p(DataStr,"^",14)
        s ApptRegisterObj.OPAPPTWorkUnit=$p(DataStr,"^",15)
        if (ApptRegisterDr=""){
            //登记人
            d ApptRegisterObj.OPAPPTRegisterUserDrSetObjectId(UserId)
            d ApptRegisterObj.OPAPPTCreatUserDrSetObjectId(UserId)
            s ApptRegisterObj.OPAPPTCreatDate=+$h
            s ApptRegisterObj.OPAPPTCreatTime=$p($h,",",2)
        }else{
            d ApptRegisterObj.OPAPPTCUpdateUserDrSetObjectId(UserId)
            s ApptRegisterObj.OPAPPTUpdateDate=+$h
            s ApptRegisterObj.OPAPPTUpdateTime=$p($h,",",2)
        }
	}
	s sc= ApptRegisterObj.%Save()
	If $$$ISERR(sc) {
		b //Do $System.Status.DisplayError()
		tro
		Quit 100
	}
	s ApptRegisterDr=ApptRegisterObj.%Id()
	tc
	q 0
}

ClassMethod OPApptRegisterListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPApptRegisterListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPApptRegister","OPApptRegisterList",1,"")
ClassMethod OPApptRegisterListExecute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s StarDate=##class(websys.Conversions).DateHtmlToLogical(StarDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:StarDate="" StarDate=+$h
    s:EndDate="" EndDate=+$h
	for OneDate=StarDate:1:EndDate{

        s ApptRegDr=0
        for {
            s ApptRegDr=$o(^DHCOPApptRegisterI(0,"CreateDate",OneDate,ApptRegDr))
            q:ApptRegDr=""
            s (ApptRegisterDr,OPAPPTPAPMIDR,OPAPPTDate,OPAPPTWeek,OPAPPTPatName,OPAPPTPatSex,OPAPPTPatPhone,OPAPPTPatAdmDesc,
            OPAPPTPatAdmLoc,OPAPPTPatAdmDoc,OPAPPTApptDate,OPAPPTCurrentReg,OPAPPTPatCarNo,OPAPPTRegisterStatus,OPAPPTRegisterDesc,
            OPAPPTWorkUnit,OPAPPTRegisterUser)=""
            s ApptRegisterDr=ApptRegDr
            s ApptRegObj=##Class(User.DHCOPApptRegister).%OpenId(ApptRegisterDr)
            if $IsObject(ApptRegObj){
                s OPAPPTPAPMIDR=ApptRegObj.OPAPPTPAPMIDRGetObjectId()
                s:ApptRegObj.OPAPPTDate'="" OPAPPTDate=##class(websys.Conversions).DateLogicalToHtml(ApptRegObj.OPAPPTDate)
                s OPAPPTWeek=ApptRegObj.OPAPPTWeek
                s OPAPPTPatName=ApptRegObj.OPAPPTPatName
                s OPAPPTPatSex=ApptRegObj.OPAPPTPatSexGetObjectId()
                s OPAPPTPatPhone=ApptRegObj.OPAPPTPatPhone
                s OPAPPTPatAdmDesc=ApptRegObj.OPAPPTPatAdmDesc
                s OPAPPTPatAdmLoc=ApptRegObj.OPAPPTPatAdmLoc
                s OPAPPTPatAdmDoc=ApptRegObj.OPAPPTPatAdmDoc
                s:ApptRegObj.OPAPPTApptDate'="" OPAPPTApptDate=##class(websys.Conversions).DateLogicalToHtml(ApptRegObj.OPAPPTApptDate)
                s OPAPPTCurrentReg=ApptRegObj.OPAPPTCurrentReg
                s OPAPPTPatCarNo=ApptRegObj.OPAPPTPatCarNo
                s OPAPPTRegisterStatus=ApptRegObj.OPAPPTRegisterStatus
                s OPAPPTRegisterDesc=ApptRegObj.OPAPPTRegisterDesc
                s OPAPPTWorkUnit=ApptRegObj.OPAPPTWorkUnit
                s OPAPPTRegisterUser=ApptRegObj.OPAPPTRegisterUserDr.SSUSRName
            }else{
	            continue
            }
            d ApptRegObj.%Close()
            d OutputRow
        }
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(ApptRegisterDr,OPAPPTPAPMIDR,OPAPPTDate,OPAPPTWeek,OPAPPTPatName,OPAPPTPatSex,OPAPPTPatPhone,OPAPPTPatAdmDesc,OPAPPTPatAdmLoc,OPAPPTPatAdmDoc,OPAPPTApptDate,OPAPPTCurrentReg,OPAPPTPatCarNo,OPAPPTRegisterStatus,OPAPPTRegisterDesc,OPAPPTWorkUnit,OPAPPTRegisterUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod OPApptRegisterListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPApptRegisterListExecute ]
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

Query OPApptRegisterList(StarDate As %String, EndDate As %String) As %Query(ROWSPEC = "ApptRegisterDr:%String,OPAPPTPAPMIDR:%String,OPAPPTDate:%String,OPAPPTWeek:%String,OPAPPTPatName:%String,OPAPPTPatSex:%String,OPAPPTPatPhone:%String,OPAPPTPatAdmDesc:%String,OPAPPTPatAdmLoc:%String,OPAPPTPatAdmDoc:%String,OPAPPTApptDate:%String,OPAPPTCurrentReg:%String,OPAPPTPatCarNo:%String,OPAPPTRegisterStatus:%String,OPAPPTRegisterDesc:%String,OPAPPTWorkUnit:%String,OPAPPTRegisterUser:%String")
{
}

}
