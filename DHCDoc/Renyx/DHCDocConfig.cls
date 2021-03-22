Class DHCDoc.Renyx.DHCDocConfig Extends %RegisteredObject
{

/// renyx 根据科室id 获取代码模块配置的待录入医嘱
/// w ##Class(web.DHCOPAdmRegLocal).GetArcItemByLocDr("REGINSERTORDITE",1087)
ClassMethod GetArcItemByLocDr(XmlCode As %String, LocDr As %String)
{
	s RetStr=""
	s DefineDr=0
	f{
		s DefineDr=$o(^DHCDocCTi(0,"Define","Code",XmlCode,DefineDr))
		q:DefineDr=""
		s ChildSub=0
 		for {
 			s ChildSub=$O(^DHCDocCT("DefineData",DefineDr,"D",ChildSub)) 
 			q:ChildSub=""
 			s RowData=$g(^DHCDocCT("DefineData",DefineDr,"D",ChildSub))
 			s RecLocDr=$p(RowData,"^",1)
 			continue:(LocDr'=RecLocDr)
 			s StarDate=$p(RowData,"^",3)
 			s EndDate=$p(RowData,"^",4)
 			continue:((StarDate'="")&&(+$h<StarDate))
 			continue:((EndDate'="")&&(+$h>=EndDate))
 			s RetStr=$p(RowData,"^",2)
		}
	}
	q RetStr
}

}
