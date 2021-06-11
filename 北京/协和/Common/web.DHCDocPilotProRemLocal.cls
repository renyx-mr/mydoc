Class web.DHCDocPilotProRemLocal Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

ClassMethod QueryDHCDocPilotProRemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCDocPilotProRemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}


ClassMethod QueryDHCDocPilotProRemListExecute(ByRef qHandle As %Binary, StartDate As %String,EndDate As %String,UserDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:StartDate="" StartDate=+$h
	s:EndDate="" EndDate=+$h
	; 项目编号、项目名称 、到账状态 、主要研究者 、入账金额 、药物/医疗器械名称 、付款方 、入账账号 、办理日期 、确认时间
	&sql(DECLARE SQLDHCDocPilotProRemList CURSOR FOR
		SELECT PPR_PP_ParRef->PP_Code,PPR_PP_ParRef->PP_Desc,PPR_State,PPR_MasterUserDR->SSUSR_Name,PPR_RemAmount
			,PPR_PP_ParRef->PP_Desc,PPR_Remitter,PPR_Account,PPR_SysDate,PPR_ConfirmDate
		INTO :PPCode,:PPDesc,:PPRState,:SSUSRName,:PPRRemAmount
			,:ArcItemDesc,:PPRRemitter,:PPRAccount,:PPRSysDate,:PPRConfirmDate
		FROM SQLUser.DHC_DocPilotProRem 
		WHERE PPR_ConfirmDate>=:StartDate AND PPR_ConfirmDate<=:EndDate
		IF :UserDr IS Not NULL THEN AND PPR_Receiver=:UserDr
		--ORDER BY NA_RowId ASC
	)
	&SQL(OPEN SQLDHCDocPilotProRemList)
	For {
		&SQL(FETCH SQLDHCDocPilotProRemList) 
		QUIT:SQLCODE
		s PPRState=$case(PPRState,"A":"申请","V":"确认到账")
		s PPRSysDate=##class(websys.Conversions).DateLogicalToHtml(PPRSysDate)
		s PPRConfirmDate=##class(websys.Conversions).DateLogicalToHtml(PPRConfirmDate)
		do OutputRow
	}
	&SQL(CLOSE SQLDHCDocPilotProRemList)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(PPCode,PPDesc,PPRState,SSUSRName,PPRRemAmount,ArcItemDesc,PPRRemitter,PPRAccount,PPRSysDate,PPRConfirmDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryDHCDocPilotProRemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCDocPilotProRemListExecute ]
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

Query QueryDHCDocPilotProRemList(StartDate As %String,EndDate As %String,UserDr As %String) As %Query(ROWSPEC = "PPCode:%String,PPDesc:%String,PPRState:%String,SSUSRName:%String,PPRRemAmount:%String,ArcItemDesc:%String,PPRRemitter:%String,PPRAccount:%String,PPRSysDate:%String,PPRConfirmDate:%String") [ SqlProc ]
{
}

}