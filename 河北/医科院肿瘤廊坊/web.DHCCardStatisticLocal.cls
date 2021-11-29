Class web.DHCCardStatisticLocal Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

ClassMethod CardStatisticCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardStatisticCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardStatisticCountExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	i $g(ind)="" s ind=1
	s ^DHCXPTest("CardStatisticCountExecute")=StartDate_"^"_EndDate
	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s Job=$J
	k CardStatistic(Job)
	; ChangeCard 0：建卡，1：换卡，2：补卡，3：补卡
	for CreateDate=StartDate:1:EndDate{
		// 建/换/补卡
		s CFRowid=""
		for {
			s CFRowid=$o(^DHCCARDi("CF",0,"Date",CreateDate,CFRowid))
			q:CFRowid=""
			s CFUserDr=$p(^DHCCARD("CF",CFRowid),"^",9)
			s CFChangeID=$o(^DHCCARD("CF",CFRowid,"CSC","0"))
			s CFFormerCardInform=$$GetFormerCardInform(CFRowid,PapmiDr)
			s FormerCardActiveFlag=$p(CFFormerCardInform,"^",1)
			s NewCardChangeActiveFlag="N"
			s:CFChangeID'="" NewCardChangeActiveFlag=$P(^DHCCARD("CF",CFRowid,"CSC",CFChangeID),"^",3)
			s ChangeCard=0
			s:(FormerCardActiveFlag="D")&&(NewCardChangeActiveFlag="E") ChangeCard=1
			s:(FormerCardActiveFlag="D")&&(NewCardChangeActiveFlag="RN") ChangeCard=2
			s CFUserDesc=$p(^SSU("SSUSR",CFUserDr),"^",2)
			s:'$d(CardStatistic(Job,CFUserDr)) CardStatistic(Job,CFUserDr)=$lb("","","","")
			s $list(CardStatistic(Job,CFUserDr),1)=CFUserDesc
			s CardStatisticStr=$case(ChangeCard,"0":"s $list(CardStatistic(Job,CFUserDr),2)=$list(CardStatistic(Job,CFUserDr),2)+1",:"s $list(CardStatistic(Job,CFUserDr),3)=$list(CardStatistic(Job,CFUserDr),3)+1")
			x CardStatisticStr
			s ^CacheTemp(repid,ind)=CardStatistic(Job,CFUserDr)
			s ind=ind+1
		}
		// 卡合并
		s OldID=" "
		for{
			s OldID=$O(^User.DHCPATCardUniteLogI("UnitDate",CreateDate,OldID))
			q:(OldID="")
			s NewID=" "
			for{
				s NewID=$O(^User.DHCPATCardUniteLogI("UnitDate",CreateDate,OldID,NewID))
				q:(NewID="")
				s ID=0
				for{
					s ID=$O(^User.DHCPATCardUniteLogI("UnitDate",CreateDate,OldID,NewID,ID))
					q:(ID="")
					s InsertUserID=$List(^User.DHCPATCardUniteLogD(ID),14)
					s InsertUserDesc=$p(^SSU("SSUSR",InsertUserID),"^",2)
					s:'$d(CardStatistic(Job,CFUserDr)) CardStatistic(Job,CFUserDr)=$lb("","","","")
					s $list(CardStatistic(Job,CFUserDr),1)=CFUserDesc
					s $list(CardStatistic(Job,CFUserDr),4)=$list(CardStatistic(Job,CFUserDr),4)+1
					s ^CacheTemp(repid,ind)=CardStatistic(Job,CFUserDr)
					s ind=ind+1
				}
			}
		}
	}
	i ind=1  {s qHandle=$lb(0,repid,0) q $$$OK}
	;合计
	s ^CacheTemp(repid,ind)=$LB("合计^"_(ind-1),"m_999","合计",ind-1,"","","","","","","","","","","")
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetFormerCardInform(CFRowid,PapmiDr)
	s CFFormerCardInform=""
	s CFFormerCardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDr,CFRowid),-1)
	i CFFormerCardDr'=""  d 
	.s CFFormerCardNo=$p(^DHCCARD("CF",CFFormerCardDr),"^",2)			;卡号
	.s FormerCardActiveFlag=$p(^DHCCARD("CF",CFFormerCardDr),"^",10)			;卡状态
	.s CFFormerCardInform=FormerCardActiveFlag_"^"_CFFormerCardNo 
	q CFFormerCardInform
}

ClassMethod CardStatisticCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardStatisticCountExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CardStatisticCount(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "UserDesc:%String,CreateCardNum:%String,UpdateCardNum:%String,UniteCardNum:%String")
{
}

}