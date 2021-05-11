Class DHCDoc.Renyx.DHCMRDiagnosLocal Extends %RegisteredObject
{
ClassMethod GetMainDiagFlag(AdmDr As %String,IcdDr As %String)
{
	s RetStr="N"
	s MradmRowid=$P($g(^PAADM(AdmDr)),"^",61)
	q:MradmRowid="" RetStr
	s MainDiagCount=0
	&sql(SELECT count(*) INTO :MainDiagCount
		FROM SQLUser.MR_Diagnos
		WHERE MRDIA_MainDiagFlag="Y" AND MRDIA_MRADM_ParRef=:MradmRowid)
	if (MainDiagCount>0) s RetStr="Y"
	q RetStr
}
ClassMethod GetPatDiagnsInfoByAdmId(AdmId As %String)
{
	s MradmRowid=$P($g(^PAADM(AdmId)),"^",61)
	q:MradmRowid="" ""
	s IcdDr="",Desc=""
	set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MradmRowid)
	For{
		Quit:('obj.Next())||(IcdDr'="")
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		continue:CodeRowid=""
		s DiagObj = ##class(User.MRDiagnos).%OpenId(Rowid)
		if ($IsObject(DiagObj)){
			continue:DiagObj.MRDIAMainDiagFlag'="Y"
			continue:DiagObj.MRDIADiagStatDRGetObjectId()'="3"
			s MRDiagnosTypeDr="",MRDiagnosTypeDesc=""
			s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
			if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
			i MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
			continue:MRDiagnosTypeDesc'="初步诊断"
			s IcdDr=CodeRowid
		}
		d DiagObj.%Close()
		
	}
	q IcdDr
	/*s IcdDr="",Desc=""
	&sql(
		SELECT TOP 1 MRDIA_ICDCode_DR,MRDIA_Desc 
		INTO :IcdDr,:Desc
		FROM SQLUser.MR_Diagnos 
		INNER JOIN SQLUser.MR_DiagType 
			ON SQLUser.MR_DiagType.TYP_ParRef=SQLUser.MR_Diagnos.MRDIA_RowId
		INNER JOIN SQLUser.MRC_DiagnosType 
			ON SQLUser.MR_DiagType.TYP_MRCDiagTyp=SQLUser.MRC_DiagnosType.DTYP_RowId
		WHERE SQLUser.MR_Diagnos.MRDIA_MainDiagFlag="Y" AND SQLUser.MRC_DiagnosType.TYP_MRCDiagTyp->DTYP_Desc="初步诊断"
		AND SQLUser.MR_Diagnos.MRDIA_DiagStat_DR="3" AND SQLUser.MR_Diagnos.MRDIA_MRADM_ParRef=:MradmRowid
	)
	q IcdDr_"^"_Desc*/
}

/// renyx 判断改患者是否开立了中医诊断和证型  
/// input 就诊id
/// output 0有，否则没有
ClassMethod CheckAdmDiagnos(AdmId As %String)
{
	s MrAdm=$p($g(^PAADM(AdmId)),"^",61)
	q:MrAdm="" -1
	s DiagCNICDFlag=0
	s DiagCNICDCCFlag=0
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MrAdm)
	For{
		Quit:'obj.Next()
		s Desc=obj.Data("MRDIAICDCodeDRDesc")
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
		s BillFlag1="" 
		s BillFlag3=""
		s DiagnosCat=""
		i CodeRowid'="" {
			s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
			s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)	
			i BillFlag3'="Y" {
				s DiagnosCat="西医"
			}elseif (BillFlag3="Y")&&(BillFlag1'="Y") {
				s DiagnosCat="中医"
				s DiagCNICDFlag=1
			}else  {
				s DiagnosCat="证型"
				s DiagCNICDCCFlag=1
			}
		}else {
			s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
			i Questionnaire=1 {
				s DiagnosCat="西医"
			}elseif (Questionnaire=2) {
				s DiagnosCat="中医"
				s DiagCNICDFlag=1
			}elseif (Questionnaire=3) {
				s DiagnosCat="证型"
				s DiagCNICDCCFlag=1
			}
		}
	}
	q:((DiagCNICDFlag=1)&&(DiagCNICDCCFlag=1)) 0
	q -1
}

}
