Class DHCDoc.Renyx.CardRefLocal Extends %RegisteredObject
{

ClassMethod GetPatCardNo(PatDr As %String, CardTypeDr As %String)
{
	s CFCardNo=""
	s CFRowId=0
	f{
		//s CFRowId=$o(^DHCCARDi("CF",0,"PAPMICTDR",PatDr,CardTypeDr,CFRowId))
		s CFRowId=$O(^DHCCARDi("CF",0,"PAPMIDR",PatDr,CFRowId)) 
		Q:CFRowId=""
		s CFActive=$p($g(^DHCCARD("CF",CFRowId)),"^",10)
		Continue:CFActive'="N"
		s CFCardTypeDR=$p($g(^DHCCARD("CF",CFRowId)),"^",16)
		Continue:(CardTypeDr'="")&(CardTypeDr'=CFCardTypeDR)
		s CFCardNo=$p($g(^DHCCARD("CF",CFRowId)),"^",2)
	}
	q CFCardNo
}

}
