Class DHCDoc.Renyx.DHCMRDiagnosLocal Extends %RegisteredObject
{

/// renyx 判断改患者是否开立了中医诊断和证型  
/// input 就诊id
/// output 0有，否则没有
ClassMethod CheckAdmDiagnos(AdmId As %String)
{
	s MrAdm=$p($g(^PAADM(AdmId)),"^",61)
	q:MrAdm="" -1
	s DiagCNICDFlag=0
	s DiagCNICDCCFlag=0
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MrAdm)
	For{
		Quit:'obj.Next()
		s Desc=obj.Data("MRDIAICDCodeDRDesc")
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
		s BillFlag1="" 
		s BillFlag3=""
		s DiagnosCat=""
		i CodeRowid'="" {
			s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
			s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)	
			i BillFlag3'="Y" {
				s DiagnosCat="西医"
			}elseif (BillFlag3="Y")&&(BillFlag1'="Y") {
				s DiagnosCat="中医"
				s DiagCNICDFlag=1
			}else  {
				s DiagnosCat="证型"
				s DiagCNICDCCFlag=1
			}
		}else {
			s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
			i Questionnaire=1 {
				s DiagnosCat="西医"
			}elseif (Questionnaire=2) {
				s DiagnosCat="中医"
				s DiagCNICDFlag=1
			}elseif (Questionnaire=3) {
				s DiagnosCat="证型"
				s DiagCNICDCCFlag=1
			}
		}
	}
	q:((DiagCNICDFlag=1)&&(DiagCNICDCCFlag=1)) 0
	q -1
}

}
