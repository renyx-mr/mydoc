Class web.DHCDocDiagnosEntryLocal Extends %RegisteredObject
{

ClassMethod CheckDiagnosDescByAdmDr(EpisodeID As %String)
{
    s RetStr=0
    q:EpisodeID="" RetStr
    s MrAdmDr=$p($g(^PAADM(EpisodeID)),"^",61)
    q:MrAdmDr="" RetStr
    s DiagnosCount=0
    &SQL(SELECT count(*) INTO :DiagnosCount  FROM SQLUser.MR_Diagnos WHERE MRDIA_Desc LIKE "%单病种%" AND MRDIA_MRADM_ParRef=:MrAdmDr)
    if DiagnosCount>0 s RetStr=1
    q:RetStr
}

}