Class web.DHCDocPAAdmCommonLocal Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetPatMrAdmWeight(EpisodeID As %String)
{
    s Weight=""
    s MrAdm=$p(^PAADM(EpisodeID),"^",61)
    q:MrAdm="" Weight
    s Weight=$p($g(^MR(MrAdm,"PRO",1)),"^",27)
    q Weight
}

}