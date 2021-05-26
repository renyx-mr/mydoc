Class web.DHCDocDiagnosEntryV8 Extends %RegisteredObject
{
/// 获取第一条诊断的发病日期以及时间 
ClassMethod GetFristDiagOnsetDateStr(AdmDr As %String)
{
    s MradmRowid=$P($g(^PAADM(AdmDr)),"^",61)
    set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MradmRowid)
    s RetStr=""
    s Ind=0
	For{
		Quit:('obj.Next())
        q:Ind>=1
        s Rowid=obj.Data("ID")
        s Ind=Ind+1
        s OnsetDate=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",35)
        s:OnsetDate'="" OnsetDate=$zd(OnsetDate,3)
        s OnsetTime=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",36)
        s:OnsetTime'="" OnsetTime=$zd(OnsetTime,1)
        s:OnsetDate'="" RetStr=OnsetDate
        s:OnsetTime'="" RetStr=RetStr_" "_OnsetTime
    }
    q RetStr
}

}