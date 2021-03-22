Class DHCDoc.Interface.Outside.CallWebService Extends %Persistent
{

/// w ##Class(DHCDoc.Interface.Outside.CallWebService).UpdateOrdInfoToPQAMS(+$H-4)
/// tanjishan 2018-03-05
/// 调用医院协同组的接口，将毒麻处方信息上传至医师资质授权管理系统
ClassMethod UpdateOrdInfoToPQAMS(ToDay As %String = "") As %String
{
	i ToDay="" s ToDay=+$H-1
	s InputInfo=""
	s SttTime=""
	for {
		s SttTime=$O(^OEORDi(0,"StDtTm",ToDay,SttTime))
		q:SttTime=""
		s OrderRowid=0
		for {
			s OrderRowid=$O(^OEORDi(0,"StDtTm",ToDay,SttTime,OrderRowid))
			q:(OrderRowid="")
			s ItemSub=0
			for {
				s ItemSub=$O(^OEORDi(0,"StDtTm",ToDay,SttTime,OrderRowid,ItemSub))
				q:(ItemSub="")
				s StatCode=""
				s ItemStat=$p($g(^OEORD(OrderRowid,"I",ItemSub,1)),"^",13)
				i ItemStat'="" s StatCode=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
				continue:(("VDPE")'[StatCode)||(StatCode="")
				s ArcimRowID=$p($g(^OEORD(OrderRowid,"I",ItemSub,1)),"^",2)
				s PHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ArcimRowID)
				continue:(PHPrescType'=8)
				s UserAdd=$p($g(^OEORD(OrderRowid,"I",ItemSub,7)),"^",1)
				continue:(UserAdd="")
				s UserCode=$P(^SSU("SSUSR",UserAdd),"^",1)
				s EpisodeID=$P(^OEORD(OrderRowid),"^",1)
				s PatientID=$P(^PAADM(EpisodeID),"^",1)
				s PatientName=$P(^PAPER(PatientID,"ALL"),"^",1)
				s ArcimName=$P(^ARCIM(+ArcimRowID,$P(ArcimRowID,"||",2),1),"^",2)
				s OrderTime=$Zd(ToDay,3)_" "_$ZT(SttTime,2)
				s sysNum="PNT"
				s Other="NULL"
				s Level="PNT"
				s OneInfo=UserCode_"^"_PatientName_"^"_EpisodeID_"^"_ArcimName_"^"_OrderTime
				s OneInfo=OneInfo_"^"_sysNum_"^"_Other_"^"_Level
				s OneInfo=$TR(OneInfo,"!","")
				i InputInfo="" s InputInfo=OneInfo
				e  s InputInfo=InputInfo_"!"_OneInfo
			}
		}
	}
	s ret=100
	i InputInfo'=""{
		s SOAPObj=##Class(DHCDoc.Interface.Outside.SOAP.CommonServiceHttpPort).%New()
		s ret=SOAPObj.saveRecord(InputInfo)
	}
	
	q ret
}

Storage Default
{
<Data name="CallWebServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.InteEC13.CallWebServiceD</DataLocation>
<DefaultData>CallWebServiceDefaultData</DefaultData>
<IdLocation>^DHCDoc.InteEC13.CallWebServiceD</IdLocation>
<IndexLocation>^DHCDoc.InteEC13.CallWebServiceI</IndexLocation>
<StreamLocation>^DHCDoc.InteEC13.CallWebServiceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
