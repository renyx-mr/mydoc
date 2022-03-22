/// 是否包含自费收费项
ClassMethod CheckArcItemTarFeibie(ArcItemDr As %String,HospitalDr As %String)
{
    s RetStr=""
    Set rset=##Class(%ResultSet).%New("web.UDHCJFOrdPriceSearch1:QueryArcimLinkTar")
    If rset.QueryIsValid() { 
        Set Status=rset.Execute(ArcItemDr,HospitalDr)
        If 'Status Quit
        Set columns = rset.GetColumnCount()
        While (rset.Next()) {
            s Tarcode=rset.Data("tarcode")
            s Tardesc=rset.Data("tardesc")
            s ExpenseType=rset.Data("xmlb")
            if (ExpenseType["自费"){
                if (RetStr=""){
                    s RetStr=Tardesc
                }else{
                    s RetStr=RetStr_";"_Tardesc
                }
            }
        }
    }
    q RetStr
}