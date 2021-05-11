Class DHCDoc.Interface.DocInsuYinHai.InsuOrderPublic Extends %RegisteredObject
{

/// w ##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderPublic).Method2006()
ClassMethod Method2006()
{
	s OutStream=##class(%GlobalCharacterStream).%New()
	//^PAADMi("PAADM_Type",{PAADM_Type},{PAADM_RowID})
	s AdmDr=""
	for {
		s AdmDr=$o(^PAADMi("PAADM_Type","I",AdmDr))
		q:AdmDr=""
		s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(AdmDr)
		continue:CurrentDischargeStatus'="B"
		d OutStream.Write("<?Xml version=""1.0"" encoding=""UTF-8""?><INPA>")
		s AdmDepDr=$p(^PAADM(AdmDr),"^",4)
		s DocDr=$p(^PAADM(AdmDr),"^",4)
		s UserId=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
		// ##class(web.DHCDischargeHistory).GetCommonInfo("2006","2")
		d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetCommonInfo("2006","2",AdmDepDr,UserId))
		d OutStream.Write("<DETAIL>")
		s AdmId=""
		//基本信息
		d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetHospitalInfo(AdmDr))
		d OutStream.Write("<DIAGNOSES>")
		//诊断信息
		d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetPatDiagnsInfo(AdmDr))
		d OutStream.Write("</DIAGNOSES>")
		
		d OutStream.Write("<HOSPITALLIST>")
		//医嘱信息
		d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetOrderInfo(AdmDr))
		d OutStream.Write("</HOSPITALLIST>")
		d OutStream.Write("</DETAIL></INPA>")
		b ;;;
	}
	/*d OutStream.Write("<?Xml version=""1.0"" encoding=""UTF-8""?><INPA>")
	d OutStream.Write("<DETAIL>")
	s AdmId=""
	d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetHospitalInfo(AdmId))
	d OutStream.Write("</DETAIL></INPA>")*/
	q "0"
}

ClassMethod Method2001(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String, Type As %String)
{
	if (Type="CMOrdItem") s OrdItemStr=##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).ConvertCMOEOrdToOEOrd(Adm,OrdItemStr)
	s OutStream=##class(%GlobalCharacterStream).%New()
	d OutStream.Write("<?Xml version=""1.0"" encoding=""UTF-8""?><INPA>")
    //s AdmDepDr=$p(^PAADM(Adm),"^",4)
    //s DocDr=$p(^PAADM(AdmId),"^",4)
    //s UserId=$o(^CTPCP(0,"CareProvType",DocDr,0))
    // ##class(web.DHCDischargeHistory).GetCommonInfo("2006","2")
    d OutStream.Write(##class(web.DHCDischargeHistory).GetCommonInfo("2006","2",Loc,User))
    d OutStream.Write("<DETAIL>")
    s AdmId=""
    //基本信息
    d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetHospitalInfo(Adm))
    d OutStream.Write("<DIAGNOSES>")
    //诊断信息
    d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetPatDiagnsInfo(Adm))
    d OutStream.Write("</DIAGNOSES>")
    
    d OutStream.Write("<HOSPITALLIST>")
    //医嘱信息
    d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetInsertOrderInfo(Adm,OrdItemStr,User,Loc))
    d OutStream.Write("</HOSPITALLIST>")
    d OutStream.Write("</DETAIL></INPA>")
}

ClassMethod Method2005(AdmDr As %String, OrdItemDrStr As %String, User As %String, Loc As %String)
{
	q:OrdItemDrStr=""
	s IndCon=0
	s OrdDataList=##class(%ListOfDataTypes).%New()
	for i=1:1:$l(OrdItemDrStr,"^"){
		s OneOrdItemDr=$p(OrdItemDrStr,"^",i)
		continue:(OneOrdItemDr="")||('$d(^OEORD(+OneOrdItemDr,"I",$p(OneOrdItemDr,"||",2))))
		s IndCon=IndCon+1
		
		//s ArrOrdObj=##class(%ArrayOfDataTypes).%New()
		//d ArrOrdObj.SetAt(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetPatDiagnsInfo(OneOrdItemDr),"DETAILLIST")
		d OrdDataList.Insert(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetPatDiagnsInfo(OneOrdItemDr))
	}
	if (IndCon=0) q ""
	s ArrayObj=##class(%ArrayOfDataTypes).%New()
	d ArrayObj.SetAt("","AKB020")
	d ArrayObj.SetAt(AdmDr,"AKC190")
	d ArrayObj.SetAt(OrdDataList,"DETAILLIST")
	s OutStream=##class(%GlobalCharacterStream).%New()
	d OutStream.Write("<?Xml version=""1.0"" encoding=""UTF-8""?><INPA>")
	d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetCommonInfo("2006","2",Loc,User))
	d OutStream.Write("<DETAIL>")
	d OutStream.Write(##class(DHCDoc.Util.FromXML).Arr2XML(ArrayObj).Read())
	d OutStream.Write("</DETAIL></INPA>")
}

ClassMethod Method2007(AdmId As %String, Loc As %String, User As %String)
{
	s OutStream=##class(%GlobalCharacterStream).%New()
	d OutStream.Write("<?Xml version=""1.0"" encoding=""UTF-8""?><INPA>")
	d OutStream.Write(##class(DHCDoc.Interface.DocInsuYinHai.InsuOrderCommon).GetCommonInfo("2006","2",Loc,User))
	d OutStream.Write("<DETAIL>")
	s ArrayObj=##class(%ArrayOfDataTypes).%New()
	d ArrayObj.SetAt("","AKB020")
	d ArrayObj.SetAt(AdmId,"AKC190")
	d OutStream.Write(##class(DHCDoc.Util.FromXML).Arr2XML(ArrayObj).Read())
	d OutStream.Write("</DETAIL></INPA>")
}

}
