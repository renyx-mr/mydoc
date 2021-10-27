Class web.DHCDocPAPatLocal Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod)
{

/// 获取患者的登记号
/// w ##class(web.DHCDocPAPatLocal).GetPaPatNo("45070219891213832X")
ClassMethod GetPaPatNo(PatCredNo As %String)
{
    s MyPatD=""
    s PatCredNo=$$ALPHAUP^SSUTIL4(PatCredNo)
    s PatDr=0
    for {
        s PatDr=$o(^PAPERi("DVA",PatCredNo,PatDr))
        q:((PatDr="")||(MyPatD'=""))
        s PatActive=$p($g(^PAPER(PatDr,"PAT",1)),"^",6)
        continue:PatActive="N"
        s MyPatD=PatDr
    }
    q:MyPatD="" ""
    s PatNo=$p($g(^PAPER(MyPatD,"PAT",1)),"^",2)
    q PatNo
}

}