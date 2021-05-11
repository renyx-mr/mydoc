Class web.DHCDocCardRefLocal Extends %RegisteredObject 
{
///renyx  自动合并卡接口 2021.4.29
///input 临时卡登记号，患者身份证号，姓名
///return 0：成功，其余失败
ClassMethod UpdateCardUnite(OldPatNo As %String,PatIdNo As %String,PatName As %String,UserId As %String)
{
    s CFRowID=0
    //s ^DHCCARDi("CF",0,"IDCardNo",{CF_IDCardNo},{CF_RowID})
    s CardPatIdStr=""
    for{
        s CFRowID=$o(^DHCCARDi("CF",0,"IDCardNo",PatIdNo,CFRowID))
        q:CFRowID=""
        s ActiveFlag=$p($g(^DHCCARD("CF",CFRowID)),"^",10)
        continue:(ActiveFlag'="N")||(ActiveFlag'="")
        s CardPatId=$p($g(^DHCCARD("CF",CFRowID)),"^",4)
        if (CardPatIdStr=""){
            s CardPatIdStr=CardPatId
        }else{
            if ("^"_CardPatIdStr_"^")'[("^"_CardPatId_"^") s CardPatIdStr=CardPatIdStr_"^"_CardPatId
        }
    }
    if ($l(CardPatIdStr,"^")>1) q "-1^存在多条争取的患者信息"

}
}