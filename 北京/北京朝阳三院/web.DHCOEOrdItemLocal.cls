Class web.DHCOEOrdItemLocal Extends %RegisteredObject
{

ClassMethod GetAddUserByAdm(AdmId As %String, OrdItemDr As %String)
{
	s RetUserId =""
	q:'$d(^PAADM(AdmId)) RetUserId
	s PracticeDocPreiDr=""
	for{
		s PracticeDocPreiDr=$o(^DHCPracticeDocPrei("AllAdm",AdmId,PracticeDocPreiDr))
		q:(PracticeDocPreiDr="")||(RetUserId'="")
		s PracticeOrdItemDR=$p($g(^DHCPracticeDocPre(PracticeDocPreiDr)),"^",10)
		continue:PracticeOrdItemDR'=OrdItemDr
		s RetUserId=$p($g(^DHCPracticeDocPre(PracticeDocPreiDr)),"^",4)
	}
	q RetUserId
}

/// 根据医嘱项判断为长效针或者免费药
/// w ##class(web.DHCOEOrdItemLocal).CheckPresnoFlag("842||1")
/// output 8 免费服药，9 长效针
ClassMethod CheckPresnoFlag(ArcItemDr As %String)
{
	quit:'$d(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2))) ""
	set SelectTypeStr="8^9"
	set RetPresnoType=""
	for OneSelectTypeInd=1:1:$l(SelectTypeStr,"^"){
		quit:(RetPresnoType'="")
		set SelectTypeCode=$p(SelectTypeStr,"^",OneSelectTypeInd)
		continue:SelectTypeCode=""
		set MUCCRowId=0
		for {
			set MUCCRowId=$o(^DHCMUC(0,"TYPE",SelectTypeCode,MUCCRowId)) 
			quit:((MUCCRowId="")||(RetPresnoType'=""))
			set HISCodeRowId=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",2)
			if (HISCodeRowId=ArcItemDr) set RetPresnoType=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",1)
		}
	}
	quit RetPresnoType
}

}
