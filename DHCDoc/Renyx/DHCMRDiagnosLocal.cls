Class DHCDoc.Renyx.DHCMRDiagnosLocal Extends %RegisteredObject
{
/// 汇总取诊断接口  
/// input : 就诊ID ，诊断类型描述（初步诊断，入院诊断...多个使用^连接），诊断类型（Y:ICD表Rowid,其余描述），获取诊断数量(全部用ALL)，是否按照主诊断获取，诊断状态（确诊，待诊。。。）
/// w ##class(web.Sxddhc).GetPatDiagnsInfo("901","初步诊断","","ALL")
ClassMethod GetPatDiagnsInfo(AdmId As %String, DiagnosTypeDesc As %String = "", DiagnosFlag As %String = "", DiagNum As %String = "", MianFalg As %String = "", DiagStat As %String = "",PDlime As %string = "")
{
	s MradmRowid=$P($g(^PAADM(AdmId)),"^",61)
	q:MradmRowid="" ""
	s RetStr=""
	s:PDlime="" PDlime="^"
	set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MradmRowid)
	For{
		Quit:('obj.Next())
		q:(DiagNum'="ALL")&&((+DiagNum=$l(RetStr,"^"))||(DiagNum=RetStr))
		//b //q:((TypeFlag="0")&&(IcdDrStr'=""))
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		s Desc=obj.Data("MRDIAICDCodeDRDesc")
		continue:CodeRowid=""
		s DiagObj = ##class(User.MRDiagnos).%OpenId(Rowid)
		if ($IsObject(DiagObj)){
			continue:((MianFalg="Y")&&(DiagObj.MRDIAMainDiagFlag'="Y"))
			continue:((DiagStat'="")&&(DiagObj.MRDIADiagStatDR.DSTATDesc'=DiagStat))
			s MRDiagnosTypeDr="",MRDiagnosTypeDesc=""
			s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
			if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
			i MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
			continue:("^"_DiagnosTypeDesc_"^")'[("^"_MRDiagnosTypeDesc_"^") //'=DiagnosTypeDesc
			s OneRet=Desc
			if (DiagnosFlag="Y") s OneRet=CodeRowid
			if RetStr="" s RetStr=OneRet
			else  s RetStr=RetStr_PDlime_OneRet
		}
		d DiagObj.%Close()
	}
	q RetStr
}

ClassMethod GetBookingDiagByIPAdmId(IPAdmId As %String)
{
	s RetStr=""
	s BookId=$O(^DHCDocIPBK(0,"EpisodeIDTo",IPAdmId,0))
	q:BookId="" RetStr
	s ICDList=$p(^DHCDocIPBK(BookId),"^",24) ;ICD诊断-新版不用
	s LICDList=$L(ICDList,"!")
	for i=1:1:LICDList{
		s ICDSub=$P(ICDList,"!",i)
		continue:ICDSub=""
		s SID=$p(ICDSub,$c(2),3)
		s ICDRowId=$p(ICDSub,$c(2),1)
		if (ICDRowId'=""){
			s Desc=$p(^MRC("ID",ICDRowId),"^",2)
		}else{
			s Desc=$p(ICDSub,$c(2),2)
		}
		if (RetStr="") s RetStr=Desc
		else  s RetStr=RetStr_"^"_Desc
	}
	q RetStr
}
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
ClassMethod GetPatDiagnsInfoByAdmId(AdmId As %String,DiagnosTypeDesc As %String = "")
{
	s MradmRowid=$P($g(^PAADM(AdmId)),"^",61)
	q:MradmRowid="" ""
	s IcdDrStr="",Desc=""
	s TypeFlag=0
	if (DiagnosTypeDesc=""){
		s DiagnosTypeDesc="初步诊断"
	}else{
		s TypeFlag=1
	}
	set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MradmRowid)
	For{
		Quit:('obj.Next())||((IcdDrStr'="")&&(TypeFlag=0))
		s Rowid=obj.Data("ID")
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		continue:CodeRowid=""
		s DiagObj = ##class(User.MRDiagnos).%OpenId(Rowid)
		if ($IsObject(DiagObj)){
			continue:(TypeFlag=1)&&(DiagObj.MRDIAMainDiagFlag'="Y")
			continue:(TypeFlag=1)&&(DiagObj.MRDIADiagStatDRGetObjectId()'="3")
			s MRDiagnosTypeDr="",MRDiagnosTypeDesc=""
			s SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
			if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
			i MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
			continue:MRDiagnosTypeDesc'=DiagnosTypeDesc
			if (TypeFlag=1){
				if IcdDrStr="" s IcdDrStr=CodeRowid
				else  s IcdDrStr=IcdDrStr_"^"_CodeRowid
			}else{
			s IcdDrStr=CodeRowid
			}
		}
		d DiagObj.%Close()
		
	}
	q IcdDrStr
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
