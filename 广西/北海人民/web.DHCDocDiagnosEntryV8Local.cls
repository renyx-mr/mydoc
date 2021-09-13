Class web.DHCDocDiagnosEntryV8Local Extends %RegisteredObject
{

ClassMethod CheckMRCICDDx(ICDRowId As %String, HospId As %String = "")
{
	s RetStr="0"
	q:'$d(^MRC("ID",+ICDRowId)) RetStr
	s ICD9CMCode=$p($g(^MRC("ID",+ICDRowId)),"^",4)
	q:ICD9CMCode="" RetStr
	s ICD9CMCode=","_ICD9CMCode_","
	s ICD9CMCodeStr=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","ICD9CMCodeStr",HospId)
	if (ICD9CMCodeStr[ICD9CMCode) s RetStr="1"
	q RetStr
}

/// 判断该患者的 初复诊 ，通过就诊id判断 
/// ##class(web.DHCDocDiagnosEntryV8Local).CheckInitialReplyAdm()
ClassMethod CheckInitialReplyAdm(EpisodeID As %String)
{
	s RetStr=""
	; ReAdmis R 复诊
	s ReAdmis=$p($g(^PAADM(EpisodeID)),"^",56)
	q:ReAdmis="R" "F"
	; FirstAdm F:初诊   R: 出院复诊
	s FirstAdm=$p($g(^PAADM(EpisodeID)),"^",72)
	q:FirstAdm="R" "F"
	q:FirstAdm="F" "C"
	q RetStr
}

}
