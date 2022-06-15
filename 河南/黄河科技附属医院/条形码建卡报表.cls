Class web.UDHCAccCardManage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod ReadCardExInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardExInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ReadCardExInfoExecute(ByRef qHandle As %Binary , StDate As %String, EndDate As %String, CardTypeDr As %String ="1") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	i StDate'="" s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	for myDate=EndDate:-1:StDate{
        s myCardRowID=0
        for {
            s myCardRowID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID)) 
            q:(myCardRowID="")
            s CFCardTypeDR=$p($g(^DHCCARD("CF",myCardRowID)),"^",16)
            continue:CFCardTypeDR=""
            continue:(CardTypeDr'="")&&(CardTypeDr'=CFCardTypeDR)
            d ResetVariablesFR
            s myPAPMDR=$p(^DHCCARD("CF",myCardRowID),"^",4)
            s PatName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
            s PatPMNo=$p($g(^PAPER(myPAPMDR,"PAT",1)),"^")
            s PatDvaNumber=$p($g(^PAPER(myPAPMDR,"PAT",3)),"^",6)
            s PatTelNo=$p(^PAPER(myPAPMDR,"PER",1),"^",11)
            s:CFCardTypeDR'="" CardType=$p(^DHCCARDTYPEDef(CFCardTypeDR),"^",2)
            s PatCardNo=$p(^DHCCARD("CF",myCardRowID),"^",2)
            s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPAPMDR,0))
            if CardID'=""{
                s CreateDate=$p($g(^PAPER(myPAPMDR,"PER",5)),"^",17)
                i CreateDate'="" s CreateDate=##class(websys.Conversions).DateLogicalToHtml(TCreateDate) //$ZD(TCreateDate,3)
                s CreateUser=$p($g(^PAPER(myPAPMDR,"PER",5)),"^",18)
                i CreateUser'="" s CreateUser=$P(^SSU("SSUSR",TCreateUser),"^",2)
            }
            d OutputFR
        }
    }
	Quit $$$OK
ResetVariablesFR
    ; 姓名，登记号，身份证号，电话，卡类型，卡号，建档时间，操作员
	s (PatName,PatPMNo,PatDvaNumber,PatTelNo,CardType, PatCardNo,CreateDate,CreateUser)=""
	quit
OutputFR
	s Data=$lb(PatName,PatPMNo,PatDvaNumber,PatTelNo,CardType, PatCardNo,CreateDate,CreateUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReadCardExInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardExInfoExecute ]
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

Query ReadCardExInfo(StDate As %String, EndDate As %String, CardTypeDr As %String ="1") As %Query(ROWSPEC = "No:%String, CardNo:%String, PatName:%String, PAPMNo:%String, OperName:%String, CardStatus:%String, OperDate:%String, ComIP:%String, AppName:%String, AppAddress:%String, AppIDType:%String, AppIDNo:%String, AppTelNo:%String, Remark:%String,TPoliticalLevel:%String,TSecretLevel:%String,TCardType:%String")
{
}

}
