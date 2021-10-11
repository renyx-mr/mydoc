Class web.DHCOEOrdItemLocal Extends %RegisteredObject
{

/// 最新获取抗菌药物审核人
/// input 医嘱ID
/// output 用户ID   SS_User指针
/// w ##class(web.DHCOEOrdItemLocal).GetAntibioticUserNew("225||255")
ClassMethod GetAntibioticUserNew(OrdItemId As %String)
{
	q:(OrdItemId="")!(OrdItemId'["||") ""
	//q:'$d(^OEORD(+OrdItemId,$p(OrdItemId,"||",2))) ""
	s AARowid=$o(^DHCDAAi(0,"OEORI",OrdItemId,0))
	//renyx 防止是后续开立的医嘱 从使用目的取
	if (AARowid=""){
		s DAUPRowId=$o(^DAUP("OEORI",OrdItemId,0))
		q:DAUPRowId="" ""
		s DAUPCopy=$p($g(^DAUP("DAUP",DAUPRowId)),"^",26)
		q:DAUPCopy="" ""
		&sql(SELECT AA_Rowid INTO :AARowid FROM SQLUser.DHC_Doc_AntibioticApply WHERE AA_Purpose_DR=:DAUPCopy )
	}
	;b ;sxd
	q:AARowid="" ""
	s AuditUserDR=$p($g(^DHCDAA("ANT",AARowid,1)),"^",10)
	;b ;sxd11
	s DHCConsultDR=$p($g(^DHCDAA("ANT",AARowid,1)),"^",22)
	s:DHCConsultDR'="" AuditUserDR=..GetAntibioticLogUser(AARowid)
	q AuditUserDR
}

/// w ##class(web.DHCOEOrdItemLocal).GetAntibioticLogUser(673)
ClassMethod GetAntibioticLogUser(AARowid)
{
	s ConsultDoc1=$p($g(^DHCDAA("ANT",AARowid,1)),"^",5)
	s ConsultDoc2=$p($g(^DHCDAA("ANT",AARowid,1)),"^",28)
	s ConsultDoc3=$p($g(^DHCDAA("ANT",AARowid,1)),"^",31)
	s:ConsultDoc1'="" ConsultDoc1=$o(^SSU("SSUSR",0,"CTPCP",ConsultDoc1,0))
	s:ConsultDoc2'="" ConsultDoc2=$o(^SSU("SSUSR",0,"CTPCP",ConsultDoc2,0))
	s:ConsultDoc3'="" ConsultDoc3=$o(^SSU("SSUSR",0,"CTPCP",ConsultDoc3,0))
	s ConsultDocStr="^"_ConsultDoc1_"^"_ConsultDoc2_"^"_ConsultDoc3_"^"
	s AuditUserId=""
	s mLogId=""
	for {
		s mLogId=$o(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",AARowid,mLogId),-1)
		q:((mLogId="")!(AuditUserId'=""))
		s mLogStatus=$p(^DHCAntBaseMainLogD(mLogId),"^",11)
		continue:mLogStatus="A"
		s mLogAuditUser=$p(^DHCAntBaseMainLogD(mLogId),"^",6)
		;s mLogAuditUser=""
		;s:mLogAuditDoc'="" mLogAuditUser=$o(^SSU("SSUSR",0,"CTPCP",mLogAuditDoc,0))
		continue:(mLogAuditUser'="")&&(ConsultDocStr[("^"_mLogAuditUser_"^"))
		s AuditUserId=mLogAuditUser
		
	}
	q AuditUserId
}

/// w ##class(web.DHCOEOrdItemLocal).GetTariInfoByARCIMDr("4408||1")
ClassMethod GetTariInfoByARCIMDr(ArcItemDr As %String)
{
	q:(ArcItemDr="")!('$d(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2)))) ""
	s ArcItemCode=$p($g(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2),1)),"^",1)
	q:ArcItemCode="" ""
	q $replace(##class(web.DHCBL.CT.DHCTarItem).GetTariInfoByARCIMCode(ArcItemCode),"&!","<br/>")
}

/// w ##class(web.DHCOEOrdItemLocal).GetInsurFlag(234,2)
ClassMethod GetInsurFlag(AdmId As %String, HospId As %String)
{
	Q:((AdmId="")!(HospId="")) 0
	s BillType=$P(^PAADM(AdmId,1),"^",7)
	q:BillType="" 0
	s InsurFlag=0
	//s HospitalCode=..GetCurrentHospitalCode()
	s AdmSource=$p($g(^PAC("ADMREA",BillType)),"^",9)
	s NationalCode=$p($g(^PAC("ADMREA",BillType)),"^",5)
	if AdmSource>0 s InsurFlag=1
	if (InsurFlag=0){
		s OrderCoverMainIns=##class(DHCDoc.DHCDocConfig.LocalConfig).CheckExitLocalConfigValue("OPDoc","InsertCoverMainInsAdmSource",BillType,"!",HospId)
		s InsurFlag=OrderCoverMainIns
	}
	q InsurFlag
}

/// w ##class(web.DHCOEOrdItemLocal).GetFirsDiagByAdmId(AdmId)
ClassMethod GetFirsDiagByAdmId(AdmId As %String)
{
	s RetStr=""
	s MRAdmId=$p($g(^PAADM(AdmId)),"^",61)
	q:AdmId="" RetStr
	s DiagSub=$o(^MR(MRAdmId,"DIA",0))
	q:DiagSub="" ""
	b 
	s ICDDxDr=$p($g(^MR(MRAdmId,"DIA",DiagSub)),"^",1)
	s DiagDesc=$g(^MR(MRAdmId,"DIA",DiagSub,"DES",1))
	q ICDDxDr_"^"_DiagDesc
}

/// 判断此申请单是否有在用的医嘱
/// output Y/N
/// w ##class(web.DHCOEOrdItemLocal).CheckAntibioticOrdItem(389)
ClassMethod CheckAntibioticOrdItem(AARowid, ArcItemDr As %String = "")
{
	s ^tempRen("CheckAntibioticOrdItem")=AARowid
	s RetStr="N"
	//q:OrdItemDr="" RetStr
	s OrdItemDr=$p($g(^DHCDAA("ANT",+AARowid,1)),"^",6)
	q:OrdItemDr="" RetStr
	s OrdStatusCode=##class(appcom.OEOrdItem).GetStatusCode(OrdItemDr)
	if (ArcItemDr'=""){
		s ArcimRowId=$p($g(^OEORD(+OrdItemDr,"I",$p(OrdItemDr,"||",2),1)),"^",2)
		q:ArcimRowId'=ArcItemDr RetStr
	}
	if (OrdStatusCode'="C")&&(OrdStatusCode'="D")&&(OrdStatusCode'="U") {
		s RetStr="Y"
	}
	q RetStr
}

/// 获取抗菌药物审核人
/// input 医嘱ID
/// output 用户ID   SS_User指针
/// w ##class(web.DHCOEOrdItemLocal).GetAntibioticUser("158||72")
ClassMethod GetAntibioticUser(OrdItemId As %String)
{
	q:(OrdItemId="")!(OrdItemId'["||") ""
	//q:'$d(^OEORD(+OrdItemId,$p(OrdItemId,"||",2))) ""
	s AARowid=$o(^DHCDAAi(0,"OEORI",OrdItemId,0))
	//renyx 防止是后续开立的医嘱 从使用目的取
	if (AARowid=""){
		s DAUPRowId=$o(^DAUP("OEORI",OrdItemId,0))
		q:DAUPRowId="" ""
		s DAUPCopy=$p($g(^DAUP("DAUP",DAUPRowId)),"^",26)
		q:DAUPCopy="" ""
		&sql(SELECT AA_Rowid INTO :AARowid FROM SQLUser.DHC_Doc_AntibioticApply WHERE AA_Purpose_DR=:DAUPCopy)
	}
	;b ;sxd
	q:AARowid="" ""
	s AuditUserDR=$p($g(^DHCDAA("ANT",AARowid,1)),"^",10)
	;b ;sxd11
	q AuditUserDR
}

/// "140104^40^N^数字化摄影（指DR、CR) [腰骶椎正侧位]^13975^^^22^^Y^104-1头痛^^3764||1^^629^^^^^undefined^N^0140104^40^N^数字化摄影
/// （指DR、CR) [右手掌指骨正斜位]^13975^^^22^^Y^104-1头痛^^3764||1^^624^^^^^undefined^N^0140104^40^N^数字化摄影（指DR、CR)
/// [左尺桡骨正侧位]^13975^^^22^^Y^104-1头痛^^3764||1^^619^^^^^undefined^N^0140104^40^N^电视下心脏透视（右前斜位服钡）^13975^^^22^^Y^104-1
/// 头痛^^2403||1^^^^^^^undefined^N^0"
/// w ##class(web.DHCOEOrdItemLocal).CheckInsertArcItem
ClassMethod CheckInsertArcItem(mItmListData As %String, ArcItemId As %String, HospId As %String)
{
	s ^TempRen("CheckInsertArcItem")=$lb(mItmListData,ArcItemId,TraID,HospId)
	;多系统医嘱  
	s MultiSystemArcim=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","MultiSystemArcim",HospId)
	;单系统医嘱
	s SingleSystemArcim=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","SingleSystemArcim",HospId)
	s InputObj=##class(%DynamicAbstractObject).%FromJSON(mItmListData)
	k PartTypeList
	s PartTypeInt=0
	for ListDataInt=0:1:(InputObj.%Size()-1){
		Set OneDataObj=InputObj.%Get(ListDataInt)
		s ItemID=OneDataObj.ItemID
		;TRA_Part_Dr->AP_Desc,TRA_Part_Dr->AP_PartNum,
		&sql(SELECT TRA_Part_Dr->AP_LastRowid,TRA_Part_Dr->AP_Hosp_Dr
			INTO :LastRowid,:HospDr
			FROM SQLUser.DHC_AppTreeLink 
			WHERE TRA_Arc_Dr=:ArcItemId AND TRA_Part_Dr=:ItemID)
		continue:(HospDr'="")&&(HospDr'=HospId)
		continue:LastRowid=""
		;b //s PartTypeInt=PartTypeInt+1
		if ('$d(PartTypeList(LastRowid))){
			s PartTypeInt=PartTypeInt+1
		}
		s PartTypeList(LastRowid)=LastRowid
	}
	s MyArcItemId="!"_ArcItemId_"!"
	s RetStr=""
	if (SingleSystemArcim[MyArcItemId)&&(PartTypeInt>1){
		s RetStr="1" 
	}
	if (MultiSystemArcim[MyArcItemId)&&(PartTypeInt<=1){
		s RetStr="2"
	}
	q RetStr
}

/// CoverMainIns=$p($g(^OEORD(OrderRowid,"I",SubOrd,3)),"^",3)
ClassMethod UpdateCoverMainIns(OrderID As %String, UserID As %String, LocID As %String, Address As %String)
{
	s Adm=$P($G(^OEORD(+OrderID)),"^",1) 
	s VisitStatus=$P($G(^PAADM(Adm)),"^",20)
	;Q:VisitStatus'="A" 0
	s PrescNo=$p($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1)),"^",14)
	s retCoverMainIns=""
	if (##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1"){
		s CoverMainIns=$p($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),3)),"^",3)
		s Childsub=0
		for{
			s Childsub=$o(^OEORD(0,"PrescNo",PrescNo,+OrderID,Childsub))
			q:Childsub=""
			s retCoverMainIns=$$UpdateOEOrdItemCoverMainIns(+OrderID_"||"_Childsub,CoverMainIns)
		}
	}else{
		//s OneOrderID=OrderID
		s CoverMainIns=$p($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),3)),"^",3)
		s retCoverMainIns=$$UpdateOEOrdItemCoverMainIns(OrderID,CoverMainIns)
	}
	q retCoverMainIns
UpdateOEOrdItemCoverMainIns(OneOrderID,CoverMainIns)
	
	if (CoverMainIns="N"){s UpMes="Y"}else{s UpMes="N"}
	s Mesage="Back:"_CoverMainIns_",Up:"_UpMes_",User:"_UserID_",LocID:"_LocID_",IP:"_Address_",UpDateTime:"_$H
	s $p(^OEORD(+OneOrderID,"I",$P(OneOrderID,"||",2),3),"^",3)=UpMes
	d ##class(DHCDoc.Log.Common).General("Insert","web.DHCDocInPatPortalCommon","UpdateMainIns","更新住院医保属性变更",OneOrderID,Mesage)
	q UpMes
	s MyCoverMainIns=""
	ts
	try{
		s CoverMainIns=$p($g(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3)),"^",3)
		
		s:CoverMainIns="N" MyCoverMainIns="Y"
		s:CoverMainIns="Y" MyCoverMainIns="N"
		s:CoverMainIns="" MyCoverMainIns="Y"
		s $p(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3),"^",3)=MyCoverMainIns
		s InsertDesc=$P($G(^SSU("SSUSR",UserId)),"^",2)_"在"_$zd(+$h,3)_" "_$zt($p($h,",",2),1)_"将医保标志由"_CoverMainIns_"改为"_MyCoverMainIns
		;添加一般日志的记录
		d ##class(DHCDoc.Log.Common).General("Insert","web.DHCOEOrdItemLocal","UpdateCoverMainIns","修改医嘱医保标志",OrdItemId,InsertDesc)
	
	}catch exp  {
		tro
		s MyCoverMainIns=""
	}
	tc
	q MyCoverMainIns
	/*s CoverMainIns=$p($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),3)),"^",3)
	if (CoverMainIns="N"){s UpMes="Y"}else{s UpMes="N"}
	s Mesage="Back:"_CoverMainIns_",Up:"_UpMes_",User:"_UserID_",LocID:"_LocID_",IP:"_Address_",UpDateTime:"_$H
	s $p(^OEORD(+OrderID,"I",$P(OrderID,"||",2),3),"^",3)=UpMes
	d ##class(DHCDoc.Log.Common).General("Insert","web.DHCDocInPatPortalCommon","UpdateMainIns","更新住院医保属性变更",OrderID,Mesage)
	q UpMes
	s MyCoverMainIns=""
	ts
	try{
		s CoverMainIns=$p($g(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3)),"^",3)
		
		s:CoverMainIns="N" MyCoverMainIns="Y"
		s:CoverMainIns="Y" MyCoverMainIns="N"
		s:CoverMainIns="" MyCoverMainIns="Y"
		s $p(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),3),"^",3)=MyCoverMainIns
		s InsertDesc=$P($G(^SSU("SSUSR",UserId)),"^",2)_"在"_$zd(+$h,3)_" "_$zt($p($h,",",2),1)_"将医保标志由"_CoverMainIns_"改为"_MyCoverMainIns
		;添加一般日志的记录
		d ##class(DHCDoc.Log.Common).General("Insert","web.DHCOEOrdItemLocal","UpdateCoverMainIns","修改医嘱医保标志",OrdItemId,InsertDesc)
	
	}catch exp  {
		tro
		s MyCoverMainIns=""
	}
	tc
	q MyCoverMainIns*/
}

/// w ##class(web.DHCOEOrdItemLocal).GetUpdateCoverMainInsLog("50||73")
ClassMethod GetUpdateCoverMainInsLog(OrdItemId As %String)
{
	s LogDesc=""
	&sql(SELECT TOP 1 LogValue INTO :LogDesc FROM SQLUser.DHCDoc_Log.Common 
		WHERE CallClass="web.DHCOEOrdItemLocal" AND CallMethod='UpdateCoverMainIns' AND InsType='I' AND LogKey=:OrdItemId 
		ORDER BY ID DESC)
	q LogDesc
}

ClassMethod CheckOrdItemInsu(OrdItemId As %String, HospId As %String)
{
	s RetStr=""
	s OrdArcimID=$P($G(^OEORD(+OrdItemId,"I",$P(OrdItemId,"||",2),1)),"^",2)
	q:OrdArcimID="" RetStr
	s HospCodeNode="HospDr_"_HospId
	s CookArcRowid=0
	for{
		s CookArcRowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid))
		q:CookArcRowid=""
		s subrowid=0
    	for {
	    	s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid))
	    	q:subrowid=""
	    	s RowID=subrowid
	    	s ArcimID=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid),"^",1)
	    	Continue:ArcimID'=OrdArcimID
	    	s RetStr="1"
    	}
	}
	q RetStr
}

/// w ##class(web.DHCOEOrdItemLocal).CheckAdmInsu(66)
ClassMethod CheckAdmInsu(AdmId As %String)
{
	s PAADMAdmReasonDR=$p(^PAADM(AdmId,1),"^",7)
	Q:PAADMAdmReasonDR="" ""
	s AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s AdmInsuFlag=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",5)
	q:+AdmInsuFlag>=1 "1"
	q ""
}

/// 判断是否有皮试医嘱
/// w ##class(web.DHCOEOrdItemLocal).CheckSkinTestByAdm
ClassMethod CheckSkinTestByAdm(AdmId As %String, ArcItemId As %String, HospId As %String)
{
	//s ^tempRen("CheckSkinTestByAdm")=$lb(AdmId , ArcItemId , HospId)
	s RetStr="0"
	s OrderId=$o(^OEORD(0,"Adm",AdmId,0))
	
	q:OrderId="" RetStr
	s OrdDate=0
	s SkinTestInstrStr=##class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",HospId)
	for{
		s OrdDate=$o(^OEORDi(0,"ARCIM",OrderId,ArcItemId,OrdDate))
		q:(OrdDate="")||(RetStr="1")
		s OrdSub=0
		for {
			s OrdSub=$o(^OEORDi(0,"ARCIM",OrderId,ArcItemId,OrdDate,OrdSub))
			q:(OrdSub="")||(RetStr="1")
			s ItemStatId=$p($g(^OEORD(OrderId,"I",OrdSub,1)),"^",13)
			if (ItemStatId'=""){
				s StatCode=$p($g(^OEC("OSTAT",ItemStatId)),"^",1)
				//过滤已经作废  停止   撤销的
				continue:(StatCode="U")||(StatCode="D")||(StatCode="C")
			}
			s InstrId=$p($g(^OEORD(OrderId,"I",OrdSub,2)),"^",7)
			s SkinTest=$p($g(^OEORD(OrderId,"I",OrdSub,5)),"^",2)
			continue:("^"_SkinTestInstrStr_"^")'[("^"_InstrId_"^") //&&(SkinTest="N")
			s RetStr="1"
		}
	}
	q RetStr
	;^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
}

/// w ##class(web.DHCOEOrdItemLocal).GetArcItemManufacturer("404||1")
ClassMethod GetArcItemManufacturer(ArcItemId As %String)
{
	s INFORowId=$o(^INCI(0,"ARCIM_DR",+ArcItemId,0))
	q:INFORowId="" ""
	s ManufacturerDr=$p($g(^DHCITMINFO(INFORowId)),"^",48)
	q:ManufacturerDr="" ""
	s Manufacturer=$p($g(^PHMNF(ManufacturerDr)),"^",2)
	q Manufacturer
	s DrgMastId=$p($g(^ARCIM(+ArcItemId,$p(ArcItemId,"||",2),1)),"^",12)
	
	//s ManufacturerDr=$p($g(^PHCD(+DrgMastId,"DF",$p(DrgMastId,"||",2),2)),"^",4)
	
	s ManufacturerDr=$p($g(^PHCD(+DrgMastId,2)),"^",4)
	
	s Manufacturer=$p($g(^PHMNF(ManufacturerDr)),"^",2)
	q Manufacturer
}

/// w ##class(web.DHCOEOrdItemLocal).CheckSkinTestByArcItem("404||1")
ClassMethod CheckSkinTestByArcItem(ArcItemDr As %String)
{
	s ^tempren("ArcItemDr")=ArcItemDr
	s PHCSkinTestId=$o(^CF.PHA.IN.SkinTesti("ARCIM",ArcItemDr,0))
	q:PHCSkinTestId="" ""
	s StartDate=$p($g(^CF.PHA.IN.SkinTest(PHCSkinTestId)),"^",8)
	s EndDate=$p($g(^CF.PHA.IN.SkinTest(PHCSkinTestId)),"^",9)
	q:(+StartDate>+$h)||((EndDate'="")&&(+EndDate<+$h)) ""
	q "1"
}

ClassMethod test()
{
	//s ParamArr("OrderTreatment")=""
    s OrderTreatment=##class(web.DHCOEOrdItemLocal).CheckSkinTestByArcItem(OrderARCIMRowid)
    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
    if (PAAdmType="O")&&(OrderTreatment="1")&&($g(ParamArr("OrderType"))="R"){
	    s CallBackFunParams=OrderName_"是可皮试医嘱，请确认是否用做治疗！！！"
		//s CallBackFunStr=..GetCallBackFunStr(CallBackFunStr,"OrderTreatment",CallBackFunParams)
    }
	if (OrderDirectEntryAuth="N"){
		q OutInfo
	}
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","FindLogIPInsuChange","9650914||48")
Query FindLogIPInsuChange(OEOrdItem As %String) As %Query(ROWSPEC = "ID:%String,desc:%String,User:%String,Loc:%String,IP:%String,datetime:%String")
{
}

ClassMethod FindLogIPInsuChangeExecute(ByRef qHandle As %Binary, OEOrdItem As %String) As %Status
{
		Set repid=$I(^CacheTemp)
 		s ind=1
		s CallClass="web.DHCDocInPatPortalCommon"
		s UpdateMainIns="UpdateMainIns"
		&SQL(DECLARE EmpCursor11 CURSOR FOR
			SELECT ID,LogValue into :ID,:LogValue FROM DHCDoc_Log.Common 
			WHERE CallClass=:CallClass
			AND CallMethod=:UpdateMainIns
			AND LogKey=:OEOrdItem
			ORDER BY ID desc) 
		 &SQL(OPEN EmpCursor11)
		 for  &SQL(FETCH EmpCursor11) QUIT:SQLCODE  do
		 .Q:ID=""
		 .Q:LogValue=""
		 .s JsonObj={}
		 .d JsonObj.%Set("ID",ID)
		 .s $P(LogValue,"UpDateTime:",2)=$tr($P(LogValue,"UpDateTime:",2),",","^")
		 .k Listfind
		 .for is1=1:1:$L(LogValue,",")  d
		 ..s one=$P(LogValue,",",is1)
		 ..Q:one=""
		 ..s key=$P(one,":",1)
		 ..s Val=$P(one,":",2)
		 ..Q:key=""
		 ..s Listfind(key)=Val
		 .
		 .s desc="由"_$case($G(Listfind("Back")),"N":"保外",:"保内")_"改为"_$case($G(Listfind("Up")),"N":"保外",:"保内")
		 .s User=""
		 .if $G(Listfind("User"))'=""  d
		 ..s User=$P($G(^SSU("SSUSR",$G(Listfind("User")))),"^",1)_$P($G(^SSU("SSUSR",$G(Listfind("User")))),"^",2)
		 .s Loc=""
		 .if $G(Listfind("LocID"))'=""  d
		 ..s Loc=$P(^CTLOC($G(Listfind("LocID"))),"^",2)
		 .
		 .s IP=$G(Listfind("IP"))
		 .
		 .s datetime=""
		 .if $G(Listfind("UpDateTime"))'=""  d
		 ..s datetime=$ZD(+$G(Listfind("UpDateTime")),3)_" "_$ZT($P($G(Listfind("UpDateTime")),"^",2),1)
		 .Do OutputRowIPChange
		 &sql(close EmpCursor11)
    	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
OutputRowIPChange
	set Data=$lb(ID,desc,User,Loc,IP,datetime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLogIPInsuChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLogIPInsuChangeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLogIPInsuChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLogIPInsuChangeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
