Class web.DHCDocPrefTabsLocal Extends %RegisteredObject
{
/// w ##class(web.DHCDocPrefTabs).CheckOETabsNew()
ClassMethod CheckOETabsNew(id As %Library.String = "", SelTabIndex As %String) As %String
{
	Q:id="" 0
	s ^tempRen("CheckOETabsNew")=$lb(id,SelTabIndex)
	s RetFalg=0
	s obj=##Class(websys.Preferences).%OpenId(id)
	s OldData=obj.Data
	
	s listTable=$list(OldData,3)
	s OnelistTable=$list(listTable,SelTabIndex)
	for i=1:1:$length(OnelistTable,$c(1)) {
		q:RetFalg=1
		continue:$p(OnelistTable,$c(1),i)'[$c(28)
		
		for j=1:1:$l($p(OnelistTable,$c(1),i),$c(28)){
			q:RetFalg=1
			s OneStr=$p($p(OnelistTable,$c(1),i),$c(28),j)
			continue:((OneStr="")||(OneStr'[$c(4))||($p(OneStr,$c(4),2)=""))
			s RetFalg=1
		}
		//w $p(OnelistTable,$c(1),i),!
	}
	//s Data=$LB(ChartID,eprChartFrameSize,TABLIST,NoShowAlias,NoShowAliasSameCode)
	//s ^tempscl("ff")=Data
	b //12
	//s obj.Data=Data
	//s save=obj.%Save()
	
	d obj.%Close()
	q RetFalg
}

}