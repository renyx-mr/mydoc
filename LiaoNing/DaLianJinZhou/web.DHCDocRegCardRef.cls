Class web.DHCDocRegCardRef Extends %RegisteredObject
{

///  renyx   2021.5.11
/// 合并临时卡接口
/// input: 临时卡登记号，要合并的身份证号，合并的用户id，当前的院区id
///
ClassMethod DocCardUnite(OldPapmiNo As %String,PatDVAnumber As %String ,UserId As %String, HospitalId As %String)
{
    s OldPapmiId=$o(^PAPERi("PAPMI_PatNo",PatientNO,0))
    q:OldPapmiId="" "该登记号未使用，无法进行卡合并！"
    s CFRowID=0
    s OrdCardInd=0
    for {
        s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID))
        q:CFRowID=""
        s ActiveFlag=$p($g(^DHCCARD("CF",CFRowID)),"^",10)
        continue:ActiveFlag'="N"
        s IsTemporaryCard=$p($g(^DHCCARD("CF",CFRowID)),"^",29)
        continue:IsTemporaryCard="Y"
        s OrdCardInd=OrdCardInd+1
    }
    q:OldPapmiId="" "该病人存在除临时卡之外的有效卡，请前往卡合并界面进行合并！"
    s PAPMIRowIdStr=""
    s PAPMIRowId=0
	for {
		s PAPMIRowId=$O(^PAPERi("DVA",PatCredNo,PAPMIRowId)) q:PAPMIRowId=""
        s Active=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",6)
		continue:Active="N"
        if PAPMIRowIdStr="" s PAPMIRowIdStr=PAPMIRowId
        else  s PAPMIRowIdStr=PAPMIRowIdStr_"^"_PAPMIRowId
	}
    q:$l(PAPMIRowIdStr,"^")>1 "该身份证存在多条有效信息，请前往卡合并界面进行合并！"
    s SelectCard=""
    s CardRef=0
    for {
        s CardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowIdStr,CardRef)) 
        q:(CardRef="")
        s type=$P(^DHCCARD("CF",CardRef),"^",10)
		continue:type'="N"
        if (SelectCard="") s SelectCard=CardRef
        else  s SelectCard=SelectCard_"^"_CardRef
    }
    q:$l(SelectCard,"^")<=0 "该身份证未存在有效的卡记录不能进行合并！"
    q ##class(web.DHCPATCardUnite).CardUniteNew(OldPapmiId,PAPMIRowIdStr,SelectCard,"",HospitalId,"",UserId)
}

}