Class DHCDoc.DHCDocCommonLocal Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{
/// Description
ClassMethod test(arg...) As %Status
{
    s ord=arg1
}
/// 如果入院第一天开的医嘱中有入参医嘱
///2482||1^2479||1^2484||1^2483||1
ClassMethod GetSameOrdItemByExec(AdmId As %String,ArcItemStr As %String) 
{
    s RetStr=""
    set InCharDate=$P(^PAADM(AdmId),"^",6)
	s OrderRowid=$o(^OEORD(0,"Adm",+PAADMRowid,""))
    for i=1:1:$l(ArcItemStr,"^"){
        q:(RetStr'="")
        s ArcItem=$p(ArcItemStr,"^",i)
        continue:ArcItem=""
		continue:'$d(^ARCIM(+ArcItem,$p(ArcItem,"||",2)))
		s ArcItemDesc=$p($g(^ARCIM(+ArcItem,$p(ArcItem,"||",2),1)),"^",2)
		s Childsub=0
		for {
			s Childsub=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItem,InCharDate,Childsub))
			q:Childsub=""
			s Sub=0 
			f {
				s Sub=$O(^OEORD(OrderRowid,"I",Childsub,"X",Sub)) 
				q:((Sub="")||(RetStr'=""))
				s ExeDate=$P(^OEORD(OrderRowid,"I",Childsub,"X",Sub),"^",1)
				continue:InCharDate'=ExeDate
				s RetStr=OrderRowid_"||"_Childsub
			}
		}
	}
    q RetStr
}
/// w ##class(web.DHCDocCommon).FindSameItemByExec(1000121,"1129||1")
/// 如果入院第一天开的医嘱中有入参医嘱，则输出1或0（有就是1，无就是0）
ClassMethod FindSameItemByExec(PAADMRowid As %String, ARCIMRowid As %String) As %Boolean
{
	
	;s ^TempFindSameOrderitem(PAADMRowid)=ARCIMRowid
	n (PAADMRowid,ARCIMRowid)
	s OrderRowid=$o(^OEORD(0,"Adm",+PAADMRowid,""))
	s today=$P($h,",",1)
	s findorderitem=0
	q:OrderRowid="" findorderitem
	s Notes=""
	s findorderitemId=""
	set InCharDate=$P(^PAADM(PAADMRowid),"^",6)
	s findCount=0
	s OneOrdDateTime=""
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.s statcode=""
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2) 
	.q:itemrowid="" 
	.q:'$d(^ARCIM($p(itemrowid,"||",1),$p(itemrowid,"||",2)))
	.;Q:(statcode'="V")
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.q:InCharDate'=sttdate
	.q:$g(itemrowid)=""
	.s ItemCatDR=$p(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
	.Q:(itemrowid'=ARCIMRowid)
	.s xdate=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",34)
	.;i xdate="" s xdate=+$h
	.s findCount=findCount+1
	.s Notes=$g(^OEORD(+OrderRowid,"I",itemsub,"DEP",1)) ;备注
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.s sttTIME=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",10)
	.i OneOrdDateTime="" s OneOrdDateTime=$zd(sttdate,3)_" "_$zt(sttTIME)
	.;判断执行记录表
	.s Sub=0  
	.f  s Sub=$O(^OEORD(OrderRowid,"I",itemsub,"X",Sub)) q:Sub=""  d
	..s ExeDate=$P(^OEORD(OrderRowid,"I",itemsub,"X",Sub),"^",1)
	..q:InCharDate'=ExeDate
	..s findorderitem=1
	Q findorderitem
}
}