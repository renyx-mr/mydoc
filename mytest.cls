Class DHCDoc.mytest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBL.Patient.DHCPatient","SelectByPAPERID","","","","000000000120")
ClassMethod SelectByPAPERIDExecute(ByRef qHandle As %Binary, SPAPERID As %String, SPAPERName As %String, SPAPMINo As %String, CardNo As %String) As %Status
{
	s ^DHCXPTest("PatQuery")=SPAPERID_"^"_SPAPERName_"^"_SPAPMINo_"^"_CardNo
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 Set TID = ""
	Set PAPERID = $ZCONVERT(SPAPERID,"U")
	set PAPERName = $ZCONVERT(SPAPERName,"U")
	Set SPAPERName = PAPERName
	Set PAPMINo = SPAPMINo
	Set sCardNo =CardNo

	Set TPAPERAge=""
	Set TPAPERDob=""
	Set TPAPERID=""
	Set TPAPERName=""
 Set TPAPERNationDR=""
	Set TPAPEROccupationDR=""
	Set TPAPERSexDR=""
	Set TPAPERSocialStatusDR=""
	Set TPAPERCountryDR=""
	Set TPAPERCityCodeDR=""
	Set TPAPERCityAreaDR=""
	Set TPAPERZipDR=""
	Set TPAPERStName=""
	Set TPAPERTelO=""
	Set TPAPERTelH=""
	Set TPAPEREmail=""
	Set TPAPERUpdateDate=""
	Set TPAPERSex=""
	Set TPAPERNation=""
	Set TPAPEROccupation=""
	Set TPAPERSocialStatus=""
	Set TPAPERCountry=""
	Set TPAPERCityCode=""
	Set TPAPERCityArea=""
	Set TPAPERZip=""
	set TPAPMIAllergy=""
	set TTelHome=""
	set TPAPERForeignId=""
	set TPAPERForeign=""
	set TPAPERCTRLTDR=""
	set TPAPERCTRLT=""
	set TPAPMICardTypeDR=""
	set TPAPMICardType=""
	set TPAPERForeignAddress=""
	set TPAPERForeignAddress = ""
	set TPAPERCTProvinceDR=""
	set TPAPERCTProvince=""
	set TPAPMIDVAnumber =""
	set TPAPERCompany=""
	/// 工号  协和
	set TEmployeeNo=""
	/// 婚姻状况
	set TPAPERMarital=""
	/// 联系人电话
	set TForeignPhone=""
	set TPoliticalLevel=""
	set TSecretLevel=""
	
	set cardid=""
	If ((PAPERID = "" ) && (PAPERName = "") && (PAPMINo = "")&&(CardNo = "")) goto end 
	if (ForeignCountryNo'=""){
		&sql(DECLARE PaPersonList CURSOR FOR
			SELECT PAPER_RowId
			INTO :rowId
			FROM SQLUser.PA_Person 
			WHERE PAPER_ForeignCountry=:ForeignCountryNo
		)
		&SQL(OPEN PaPersonList)
 		For {
	 		&SQL(FETCH PaPersonList) 
	 		QUIT:SQLCODE
	 		d GetPersonInfo
 		}
 		&SQL(CLOSE PaPersonList)
		goto end
	}
	Set rowId = ""
	Set validation = 0
	if (PAPERID '= "")
	{
		Set rowId = $o(^PAPERi("DVA",PAPERID,0))
		Set validation = 1
	}
	elseif (PAPERName '= "")
	{
		    Set PAPERName = $o(^PAPERi("PAPER_PatName","")) //模糊查询
			While (PAPERName '[ SPAPERName)
			{
				Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName))
				if ( PAPERName="") quit
			}		
		if (PAPERName ="") {goto end}
		
		Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,0))
		Set validation = 2
	}
	elseif (sCardNo '="")
	{
		 set cardid=$o(^DHCCARDi("CF",0,"CardNo",sCardNo,0))
		 if cardid'=""
		 {
		  set rowId=$p($g(^DHCCARD("CF",cardid)),"^",4)
		 }
		 set validation = 3
	}
	else
	{
		If ($o(^PAPERi("PAPMI_PatNo",PAPMINo,0)) = "")
		{
			//Set PAPMINo = $o(^PAPERi("PAPMI_PatNo",PAPMINo))
		}
		if (PAPMINo'=""){
			Set rowId = $o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
		}
	
		Set validation = 4
	}

	while (+rowId'=0)
	{	
		d GetPersonInfo
	}
GetPersonInfo
	Set TPAPMINo = ""
		Set TID = rowId
		If (+$p($g(^PAPER(rowId,"PAT",1)),"^",1) '=0)
		{
			 Set TPAPMINo = $p($g(^PAPER(rowId,"PAT",1)),"^",1)
		}
		else
		{
			Set TPAPMINo = $p($g(^PAPER(rowId,"PAT",2)),"^",1)
		}	
		Set TPAPERDob = $p($g(^PAPER(rowId,"ALL")),"^",6)
		;Set TPAPERAge = $p(+((($H - TPAPERDob) / 365.5) + 0.5),".",1)
		s TPAPERAge=##class(web.DHCBillInterface).GetPapmiAge(rowId,"")
		Set TPAPERID = $p($g(^PAPER(rowId,"PAT",3)),"^",6)
		Set TPAPERName = $p($g(^PAPER(rowId,"ALL")),"^",1)
		
		Set TPAPERNationDR = $p($g(^PAPER(rowId,"PER",2)),"^",1)
 Set TPAPERNation = $s(+$p($g(^PAPER(rowId,"PER",2)),"^",1)'=0:$p($g(^CT("NAT",$p($g(^PAPER(rowId,"PER",2)),"^",1))),"^",2),1:"")

 Set TPAPEROccupationDR = +$p($g(^PAPER(rowId,"PER",2)),"^",6)
		Set TPAPEROccupation = $s(+$p($g(^PAPER(rowId,"PER",2)),"^",6)'=0:$p($g(^CT("OCC",$p($g(^PAPER(rowId,"PER",2)),"^",6))),"^",2),1:"")
		
		Set TPAPERSexDR = $p($g(^PAPER(rowId,"ALL")),"^",7)
		Set TPAPERSex = $s(+$p($g(^PAPER(rowId,"ALL")),"^",7)'=0:$p($g(^CT("SEX",$p($g(^PAPER(rowId,"ALL")),"^",7))),"^",2),1:"")
		
		Set TPAPERSocialStatusDR = $p($g(^PAPER(rowId,"PER",1)),"^",10)
		Set TPAPERSocialStatus = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",10)'=0:$p($g(^CT("SS",$p($g(^PAPER(rowId,"PER",1)),"^",10))),"^",2),1:"")
		
		Set TPAPERCountryDR = $p($g(^PAPER(rowId,"PER",1)),"^",8)
		Set TPAPERCountry =  $s(+$p($g(^PAPER(rowId,"PER",1)),"^",8)'=0:$p($g(^CT("COU",$p($g(^PAPER(rowId,"PER",1)),"^",8))),"^",2),1:"")
		
		Set TPAPERCityCodeDR = $p($g(^PAPER(rowId,"PER",1)),"^",5)
		Set TPAPERCityCode = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",5)'=0:$p($g(^CT("CIT",$p($g(^PAPER(rowId,"PER",1)),"^",5))),"^",2),1:"")
		
		Set TPAPERCityAreaDR = $p($g(^PAPER(rowId,"PER",4)),"^",9)
		Set TPAPERCityArea = $s(+$p($g(^PAPER(rowId,"PER",4)),"^",9)'=0:$p($g(^CT("CITAREA",$p($g(^PAPER(rowId,"PER",4)),"^",9))),"^",2),1:"")
	
		Set TPAPERZipDR = $p($g(^PAPER(rowId,"PER",1)),"^",7)
		Set TPAPERZip = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",7)'=0:$p($g(^CT("ZIP",$p($g(^PAPER(rowId,"PER",1)),"^",7))),"^",2),1:"")
		Set TPAPERStName = $g(^PAPER(rowId,"PER","ADD"))
		Set TPAPERTelO = $p($g(^PAPER(rowId,"PER",1)),"^",9)
		Set TPAPERTelH = $p($g(^PAPER(rowId,"PER",1)),"^",11)
		Set TPAPEREmail = $p($g(^PAPER(rowId,"PER",4)),"^",19)
		Set TPAPERUpdateDate = ##class(websys.Conversions).DateLogicalToHtml($p($g(^PAPER(rowId,"PER",5)),"^",17)) //$zd($p($g(^PAPER(rowId,"PER",5)),"^",2),3)
		//ALLERGY
	
		//set AllergyListCount =$g(^PAPER(rowId,"ALLERGY",0))
		//过敏史只取第一个
		set TPAPMIAllergy=$g(^PAPER(rowId,"ALLERGY",1))
		/*
		For i=1:1:AllergyListCount
		{
			Set TPAPMIAllergy=TPAPMIAllergy_$g(^PAPER(rowId,"ALLERGY",0))
		}
		*/
		//"PER",1
	    set TTelHome=$p($g(^PAPER(rowId,"PER",1)),"^",11)
	    set TPAPERForeignId=$p($g(^PAPER(rowId,"PER",2)),"^",13)
	    set TPAPERForeign=$p($g(^PAPER(rowId,"PER",2)),"^",13)
	    set TPAPERCTRLTDR=$p($g(^PAPER(rowId,"EMP")),"^",4)
	    set TPAPERCTRLT= $s(+$p($g(^PAPER(rowId,"EMP")),"^",4)'=0:$p($g(^CT("RLT",$p($g(^PAPER(rowId,"EMP")),"^",4))),"^",2),1:"")
	    set TPAPMICardTypeDR=$p($g(^PAPER(rowId,"PAT",3)),"^",7)
	    set TPAPMICardType=$s(+$p($g(^PAPER(rowId,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(rowId,"PAT",3)),"^",7))),"^",2),1:"")
	    set TPAPERForeignAddress = $G(^PAPER(rowId,"PER","ADD",1))
	    
	    set TPAPERCTProvinceDR = $p($g(^PAPER(rowId,"PER",4)),"^",2)
	    set TPAPERCTProvince = $s(+$p($g(^PAPER(rowId,"PER",4)),"^",2)'=0:$p($g(^CT("PROV",$p($g(^PAPER(rowId,"PER",4)),"^",2))),"^",2),1:"")
		set TPAPMIDVAnumber =$p($g(^PAPER(rowId,"PAT",3)),"^",6)
		set TPAPERCompany=$p($g(^PAPER(rowId,"PER",4)),"^",18)
		
		set TForeignPhone=$p($g(^PAPER(rowId,"ALL")),"^",4)
		/// 工号  协和
		set TEmployeeNo=$p($g(^PAPER(rowId,"EMP")),"^",5) 
		/// 婚姻状况
		set TPAPERMarital=$p($g(^PAPER(rowId,"PER",2)),"^",3)
		set TPoliticalLevel=$p($g(^PAPER(rowId,"PER",3)),"^",3)
		set TSecretLevel=$p($g(^PAPER(rowId,"DHC")),"^",30)
		///合同单位
		set PAPERHCPDR=$p($g(^PAPER(rowId,"PER",4)),"^",17)
		s BirthTime=$p($g(^PAPER(rowId,"DHC")),"^",1)
		i BirthTime'="" s BirthTime=$zt(BirthTime,1)
		
		s TPAPERDob=##class(websys.Conversions).DateLogicalToHtml(TPAPERDob)
		Set Data=$ListBuild(TID,TPAPMINo,TPAPERID,TPAPERName,TPAPERDob,TPAPERAge,TPAPERSexDR,
		TPAPERNationDR,TPAPEROccupationDR,TPAPERSocialStatusDR,
		TPAPERCountryDR,TPAPERCityCodeDR,TPAPERCityAreaDR,TPAPERZipDR,
		TPAPERStName,TPAPERTelO,TPAPERTelH,TPAPEREmail,TPAPERUpdateDate,
		TPAPERSex,TPAPERNation,TPAPEROccupation,TPAPERSocialStatus,
		TPAPERCountry,TPAPERCityCode,TPAPERCityArea,TPAPERZip,
		TPAPMIAllergy,TTelHome,TPAPERForeignId,TPAPERForeign,
		TPAPERCTRLTDR,TPAPERCTRLT,TPAPMICardTypeDR,TPAPMICardType,
		TPAPERForeignAddress,TPAPERCTProvinceDR,TPAPERCTProvince,TPAPMIDVAnumber,TPAPERCompany,
		TEmployeeNo,TPAPERMarital,TForeignPhone,TPoliticalLevel,TSecretLevel,PAPERHCPDR,BirthTime
		)
		
		;通过卡号查询只要查询出卡状态为N的病人信息
		if (+validation=3)&&(cardid'=""){
			Set CardStatus=$p($g(^DHCCARD("CF",cardid)),"^",10)	
			if CardStatus="N"{
			    s PAPMIDOB=$p(^PAPER(rowId,"ALL"),"^",6)
				s ind1=100000+ind
				s Tind=PAPMIDOB_ind1
				Set ^CacheTemp(repid,Tind)=Data
	 			Set ind=ind+1		
			}
		}else{
			s PAPMIDOB=$p(^PAPER(rowId,"ALL"),"^",6)
			s ind1=100000+ind
			s Tind=PAPMIDOB_ind1
			Set ^CacheTemp(repid,Tind)=Data
	 		Set ind=ind+1
		}
		
	 	if (+validation = 1) 
	 	{
		 	Set rowId = $o(^PAPERi("DVA",PAPERID,rowId))
		 
			 if rowId =""
			 {
				 quit
			 }
		}
	 	
	 	if (+validation=2)
		{	
			Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,rowId))
			if (rowId = "")
			{
				 Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName)) //模糊查询
				 if (PAPERName ="") quit  ; xp add,2008-05-05,避免可能出现的死循环
				  ; 如果查询的名字关键字包含在Global中的最后一个节点中，则出现死循环
				 While (PAPERName '[ SPAPERName)
				 {
					
					Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName))
					if (PAPERName ="") quit 
				 }

				 if ( PAPERName ="") quit	
				 Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,0))
		    }
			if ( PAPERName ="") quit
			
		}elseif (+validation=3)
		{
						
			set cardid=$o(^DHCCARDi("CF",0,"CardNo",sCardNo,cardid))
			 if cardid'=""
			 {
			 	 set rowId=$p($g(^DHCCARD("CF",cardid)),"^",4)
			 }
			else{
			quit}
		}
		elseif (+validation=4)
		{
			Set PAPMINo = $o(^PAPERi("PAPMI_PatNo",PAPMINo))
			if ($extract(PAPMINo,1,$Length(SPAPMINo))'=SPAPMINo)	 Quit
			Set rowId = $o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
		}
end 
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryRegAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRegAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmReg","QueryRegAdmList","2020-7-28","2020-8-28","244")
ClassMethod QueryRegAdmListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, DepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s:StartDate="" StartDate="2019-5-1"
	s:EndDate="" EndDate="2020-7-28"
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	;s DocDr=""
	&sql(DECLARE PAAdmList CURSOR FOR
		SELECT PAADM_RowID,PAADM_PAPMI_DR,PAADM_DepCode_DR->CTLOC_Desc,PAADM_AdmDocCodeDR->CTPCP_Desc,PAADM_DepCode_DR
		INTO :AdmDr,:PatDr,:Admdep,:Admdoc,:AdmdepDr
		FROM SQLUser.PA_Adm 
		WHERE PAADM_VisitStatus="A" AND PAADM_CreateDate>=:StartDate AND PAADM_CreateDate<=:EndDate
	)
	&SQL(OPEN PAAdmList)
	s intNum=0
 	For {
	 	&SQL(FETCH PAAdmList) 
	 	QUIT:SQLCODE  
	 	s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmDr,0))
	 	continue:RegFeeID=""
	 	S vFlag=$$getPrtFairType(AdmDr)
	 	continue:vFlag="Y"
	 	s AdmDiagnos=##class(web.DHCOPAdmReg).CheckAdmDiagnos(AdmDr)
	 	continue:AdmDiagnos'=""
	 	continue:((DepDr'="")&&(DepDr'=AdmdepDr))
	 	s QueNo=$List(^User.DHCRegistrationFeeD(RegFeeID),8)
	 	s PatRegNo=$p($g(^PAPER(PatDr,"PAT",1)),"^",1)
		s PatName=$p($g(^PAPER(PatDr,"ALL")),"^",1)
		s intNum=intNum+1
		d OutputRow
		;w AdmdocDr
 	}
 	&SQL(CLOSE PAAdmList)
	b 
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(intNum,PatRegNo,PatName,Admdep,Admdoc,QueNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
getPrtFairType(adm)
   s Flag="N"
   s dhcbirowid=""
   f  s dhcbirowid=$o(^DHCBCI(0,"ADM",adm,dhcbirowid)) q:dhcbirowid=""  d
   .s invprtid=$p(^DHCBCI(dhcbirowid),"^",1)
   .s prtfairtype=$P($g(^DHCINVPRT(invprtid)),"^",34)
   .s prtflag=$P($g(^DHCINVPRT(invprtid)),"^",8)
   .i prtfairtype="F"  S Flag="Y"
   q Flag
}

ClassMethod QueryRegAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRegAdmListExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryRegAdmList(StartDate As %String, EndDate As %String, DepDr As %String = "") As %Query(ROWSPEC = "intNum:%String:序号,PatRegNo:%String:登记号,PatName:%String:姓名,Admdep:%String:就诊科室,Admdoc:%String:就诊医生,QueNo:%String:就诊序号")
{
}

/// w ##class(DHCDoc.Test).TestErr()
ClassMethod TestErr() As %String
{
	s $ZTRAP="TestMagErr"
	s Respont="1234123"
	s Respont=##class(web.DHCOPAdm).QASDFADS()
	q Respont
TestMagErr
	s retStr="失败"_$ze
	;b ;001
	;s sc=Respont.Write("调用报错")
	;b 
	q retStr
}

/// d ##class(DHCDoc.Test).TestWrite()
ClassMethod TestWrite()
{
	s test=0
	b  s test=1
	w test,!
}

/// w ##class(DHCDoc.Test).GetPatNolistByMotherParDr(195)
ClassMethod GetPatNolistByMotherParDr(PatDr As %String)
{
	q:'$d(^PAPER(PatDr)) ""
	&sql(DECLARE PatNolistByMother CURSOR FOR
		SELECT PAPMI_No
		INTO :PatNo
		FROM SQLUser.PA_PatMas
		WHERE PAPMI_Mother1_DR=:PatDr
	)
	&SQL(OPEN PatNolistByMother)
	s RetStr=""
 	For {
	 	&SQL(FETCH PatNolistByMother) 
	 	QUIT:SQLCODE  
	 	if (RetStr=""){
		 	s RetStr=PatNo
	 	}else {
		 	s RetStr=RetStr_","_PatNo
	 	}
 	}
 	&SQL(CLOSE PatNolistByMother)
 	q RetStr
}

Method Set123()
{
	s sss=1234123
	s PatDr="1234123"
	q sss_","_PatDr
}

Method GetPatNolistByMotherParDrNew(PatDr As %String)
{
	n (PatDr)
	q:'$d(^PAPER(PatDr)) ""
	&sql(DECLARE PatNolistByMother1 CURSOR FOR
		SELECT PAPMI_No
		INTO :PatNo
		FROM SQLUser.PA_PatMas
		WHERE PAPMI_Mother1_DR=:PatDr
	)
	&SQL(OPEN PatNolistByMother1)
	s RetStr=""
 	For {
	 	&SQL(FETCH PatNolistByMother1) 
	 	QUIT:SQLCODE  
	 	if (RetStr=""){
		 	s RetStr=PatNo
	 	}else {
		 	s RetStr=RetStr_","_PatNo
	 	}
 	}
 	&SQL(CLOSE PatNolistByMother1)
 	q RetStr
}

/// w ##class(DHCDoc.Test).Test()
ClassMethod Test(inputstr)
{
	s Obj=##class(DHCDoc.Test).%New()
	s PatDr="195"
	//s RetStr=Obj.GetPatNolistByMotherParDrNew(PatDr)
	//d Obj.%Close()
	//k BlackListCount
	//s RetStr=Obj.CreateAdmBreakRecord("65014",.BlackListCount)
	s RetStr=Obj.UpdateOeItemUserAdd(inputstr)  ;Obj.Test1()
	b ;kkk
	q RetStr
}

Method CreateAdmBreakRecord(StartDate As %String, ByRef BlackListCount)
{
	s AdmDate=StartDate
	
	f {
		s AdmDate=$o(^PAADMi("PAADM_AdmDate",AdmDate))
		q:AdmDate=""
		continue:AdmDate>+$h
		s AdmDr=0
		f {
			s AdmDr=$o(^PAADMi("PAADM_AdmDate",AdmDate,AdmDr))
			q:AdmDr=""
			s AdmPAPMIDR=$p(^PAADM(AdmDr),"^",1)
			continue:AdmPAPMIDR=""
			//黑名单时间
			Set BlackListDate=##class(web.DHCRBAppointment).GetBlackListEndDate(AdmPAPMIDR,"")
			Set SYConfigDate=$p($g(^BlackDateAndCountConfig("Config")),"^",3)     //生成黑名单的时间范围
			;如果没有维护时间范围且之前无黑名单记录,查找全部爽约记录，若此病人有黑名单记录,则从上次生成黑名单日期之后查询
			i (+SYConfigDate=0)  continue:AdmDate<BlackListDate
    		;如果维护了时间范围,则从这个时间范围内查找爽约记录,若此病人有黑名单记录,则从上次生成黑名单日期之后查询   
			i (+SYConfigDate'=0) continue:AdmDate<((+$h)-SYConfigDate)&&(AdmDate<BlackListDate)
			s RegfeeDr=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmDr,0))
			continue:RegfeeDr=""
			s feeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeDr),18)
			continue:feeRBASDr=""
			s VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
			continue:VisitStatus'="A"
			s QueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmDr,0))
			continue:QueDr=""
			s QueStateDr=$List(^User.DHCQueueD(QueDr),14) ;User.DHCPerState
			continue:QueStateDr=""
			s PersName=$List(^User.DHCPerStateD(QueStateDr),4)
			continue:PersName'="报到"
			s feeSessEndTime=$P($g(^RBAS(+feeRBASDr,$p(feeRBASDr,"||",2))),"^",5)
			w AdmDate,",",feeSessEndTime,",",$h,",",AdmPAPMIDR,!
			continue:(AdmDate=+$h)&&(feeSessEndTime>$p($h,",",2))
			s BlackListCount($j,AdmPAPMIDR)=$g(BlackListCount($j,AdmPAPMIDR))+1
		}
	}
	q 0
}

/// KM 27-Jun-2001: Called from component  MRDiagnos.ListEMR
/// d ##class(%ResultSet).RunQuery("DHCDoc.Test","Find",$LISTFROMSTRING("1,2,3",","))
Query Find(Str As %List) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName")
{
	
	--w :Str.split(",")
	--s Strlist=$p(Str,",")
	SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_Code, MRDIA_Date, MRDIA_Time, $LISTTOSTRING(MRDIA_Desc,","), MRDIA_UpdateUser_DR->SSUSR_Name
	FROM SQLUser.MR_Diagnos
	WHERE MRDIA_MRADM_ParRef %INLIST :Str
}

Method Test1()
{
	s retbbj={}
	s retbbj.one="11"
	s retbbj.two="22"
	q retbbj
}

/// w ##class(DHCDoc.Test).GetOeItemUserAddByOeOri("1||3")
ClassMethod GetOeItemUserAddByOeOri(OrdItemDr As %String)
{
	s OeOri=+OrdItemDr
	s ChildSub=$p(OrdItemDr,"||",2)
	s OrdUserAdd=""
	q:'$d(^OEORD(OeOri,"I",ChildSub)) OrdUserAdd
	s ArcimId=$p($g(^OEORD(OeOri,"I",ChildSub,1)),"^",2)
	q:ArcimId="" OrdUserAdd
	s BillSubRowId=$P($G(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",9)
	s CheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNode("CheckFeeBillSub")
	if CheckFeeBillSub=BillSubRowId{
		s OrdAdmDR=$p($g(^OEORD(OeOri)),"^",1)
		s AdmDocCodeDR=$p($g(^PAADM(OrdAdmDR)),"^",9)
		s OrdUserAdd=$o(^SSU("SSUSR",0,"CTPCP",AdmDocCodeDR,0))
	}else{
		s OrdUserAdd=$p($g(^OEORD(OeOri,"I",ChildSub,7)),"^",1)
	}
	q OrdUserAdd
}

Method UpdateOeItemUserAdd(AdmDr As %String, UserId As %String)
{
	s CheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNode("CheckFeeBillSub")
	q:CheckFeeBillSub="" 0
	/*&SQL(UPDATE SQLUser.OE_OrdItem
		SET OEORI_UserAdd= (SELECT SSUSR_RowId FROM SQLUser.SS_User WHERE SSUSR_CareProv_DR=
			(SELECT PAADM_AdmDocCodeDR FROM SQLUser.PA_Adm WHERE PAADM_RowID=:AdmDr))
		WHERE OEORI_ItmMast_DR->ARCIM_BillSub_DR=:CheckFeeBillSub AND OEORI_UserAdd IS NULL
		AND OEORI_OEORD_ParRef->OEORD_Adm_DR=:AdmDr
	)*/
	&SQL(UPDATE SQLUser.OE_OrdItem
		SET OEORI_UserAdd= :UserId
		WHERE OEORI_ItmMast_DR->ARCIM_BillSub_DR=:CheckFeeBillSub AND OEORI_UserAdd IS NULL
			AND OEORI_OEORD_ParRef->OEORD_Adm_DR=:AdmDr
	)
	if SQLCODE Q SQLCODE
	q 0
}

}
