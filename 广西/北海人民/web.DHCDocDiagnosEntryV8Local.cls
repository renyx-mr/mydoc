Class web.DHCDocDiagnosEntryV8Local Extends %RegisteredObject
{

/// W ##class(web.DHCDocDiagnosEntryV8Local).UpdateTemperature()
ClassMethod UpdateTemperature()
{
	s MRAdmID=0
	for {
		s MRAdmID=$o(^MR(MRAdmID))
		q:MRAdmID=""
		s OBSChildsub=0
		for {
			s OBSChildsub=$o(^MR(MRAdmID,"OBS",OBSChildsub))
			q:OBSChildsub=""
			s Temperature=$p($g(^MR(MRAdmID,"OBS",OBSChildsub)),"^",2)
			if (Temperature="undefined"){
				s $p(^MR(MRAdmID,"OBS",OBSChildsub),"^",2)=""
			}
		}
	}
	q 0
}
/// 获取体温
ClassMethod GetAdmTemperature(MRAdmID As %String)
{
	s RetStr=""
	s OBSChildsub=$o(^MR(MRAdmID,"OBS",0))
	q:OBSChildsub="" RetStr
	s Temperature=$p($g(^MR(MRAdmID,"OBS",OBSChildsub)),"^",2)
	if (Temperature="undefined"){
		s $p(^MR(MRAdmID,"OBS",OBSChildsub),"^",2)=""
	}
	s:Temperature'="" RetStr=Temperature
	q RetStr
}

/// 保存体温
/// w ##class(web.DHCDocDiagnosEntryV8Local).SaveTemperature(13161478,13157863,"36.7",6)
ClassMethod SaveTemperature(EpisodeID As %String, MRAdmID As %String, TemperatureVal As %String, UserID As %String = "")
{
	s ^TempRen("SaveTemperature")=TemperatureVal
	//q:(TemperatureVal="") ""
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	q:UserID="" ""
	s CurrDate=+$h
	s CurrTime=$p($h,",",2)
	s OBSChildsub=$o(^MR(MRAdmID,"OBS",0))
	if (OBSChildsub=""){
		s RetItemValue=##Class(Nur.NIS.Service.VitalSign.Temperature).saveObsItemValue(EpisodeID,"temperature",TemperatureVal,UserID,CurrDate,CurrTime,CurrDate,CurrTime,"")
	}else{
		s RetItemValue=##Class(Nur.NIS.Service.VitalSign.Temperature).saveObsItemValue(EpisodeID,"temperature",TemperatureVal,UserID,$p($g(^MR(MRAdmID,"OBS",OBSChildsub)),"^",3),$p($g(^MR(MRAdmID,"OBS",OBSChildsub)),"^",4),CurrDate,CurrTime,"")
	}
	q 0
}

/// 保存脑卒中信息接口
ClassMethod InsertCerebralApoplexyInfo(EpisodeID As %String, ParaStr As %String)
{
	Set PAAdmExtObj = ##class(User.PAAdmExt).%OpenId(EpisodeID)
	if $IsObject(PAAdmExtObj){
		s PAAdmExtObj.PAADMAdmAge=$p(ParaStr,"^",1)
		s PAAdmExtObj.PAADMBAdmBlood=$p(ParaStr,"^",2)
		s PAAdmExtObj.PAADMSingleLimbFatigue=$p(ParaStr,"^",3)
		s PAAdmExtObj.PAADMLanguageBarrier=$p(ParaStr,"^",4)
		s PAAdmExtObj.PAADMSymptomTime1=$p(ParaStr,"^",5)
		s PAAdmExtObj.PAADMSymptomTime2=$p(ParaStr,"^",6)
		s PAAdmExtObj.PAADMAdmDiabetes=$p(ParaStr,"^",7)
		Set sc=PAAdmExtObj.%Save()
		If $$$ISERR(sc) {
 			Trollback
 			Quit -100
 		}
		d PAAdmExtObj.%Close()
		Quit sc
	}
	d PAAdmExtObj.%Close()
	q ""
}

ClassMethod CerebralApoplexyICD(ICDRowId As %String, HospId As %String = "")
{
	s RetStr="0"
	s CerebralApoplexyStr=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","CerebralApoplexyICDStr",HospId)
	if (CerebralApoplexyStr[(","_ICDRowId_",")) s RetStr="1"
	q RetStr
}

ClassMethod CheckMRCICDDx(ICDRowId As %String, HospId As %String = "")
{
	s RetStr="0"
	q:'$d(^MRC("ID",+ICDRowId)) RetStr
	s ICD9CMCode=$p($g(^MRC("ID",+ICDRowId)),"^",4)
	q:ICD9CMCode="" RetStr
	s ICD9CMCode=","_ICD9CMCode_","
	s ICD9CMCodeStr=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","ICD9CMCodeStr",HospId)
	if (ICD9CMCodeStr[ICD9CMCode) s RetStr="1"
	q RetStr
}

/// 判断该患者的 初复诊 ，通过就诊id判断 
/// ##class(web.DHCDocDiagnosEntryV8Local).CheckInitialReplyAdm()
ClassMethod CheckInitialReplyAdm(EpisodeID As %String)
{
	s RetStr=""
	; ReAdmis R 复诊
	s ReAdmis=$p($g(^PAADM(EpisodeID)),"^",56)
	q:ReAdmis="R" "F"
	; FirstAdm F:初诊   R: 出院复诊
	s FirstAdm=$p($g(^PAADM(EpisodeID)),"^",72)
	q:FirstAdm="R" "F"
	q:FirstAdm="F" "C"
	q RetStr
}

}
