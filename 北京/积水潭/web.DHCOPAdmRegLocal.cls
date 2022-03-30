Class web.DHCOPAdmRegLocal Extends %RegisteredObject
{
ClassMethod GetMarkDrByAdmDr(AdmDr As %String)
{
    s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmDr,""))
    q:RegfeeRowId="" ""
    s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
    q:RegFeeRBASDr="" ""
    s DocDr= $P($G(^RB("RES",+RegFeeRBASDr)),"^",2)
    s DocDesc=$p($g(^CTPCP(DocDr,1)),"^",2)
    q DocDr_"^"_DocDesc
}
}