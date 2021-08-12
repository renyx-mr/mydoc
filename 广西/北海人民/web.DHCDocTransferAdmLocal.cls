Class web.DHCDocTransferAdmLocal Extends %RegisteredObject
{

/// 获取医院等级json
ClassMethod GetHospitalGradeJson(ModuleId As %String)
{
    s RetStr=""
    q:ModuleId="" "["_RetStr_"]"
    s RowId=0
 	for {
	 	s RowId=$O(^DHCDocCTi(0,"Define","ModuleDR",ModuleId,RowId)) Q:RowId=""
 		s RowData=$g(^DHCDocCT("Define",RowId))
 		if (RetStr=""){
            s RetStr = "{"_"'id':'"_$p(RowData,"^",1)_"',"_"'text':'"_$p(RowData,"^",2)_"'}"
        }else{
            s RetStr = RetStr_",{"_"'id':'"_$p(RowData,"^",1)_"',"_"'text':'"_$p(RowData,"^",2)_"'}"
        }
 	}
     Q "["_RetStr_"]"
}

/// 获取医院json
ClassMethod GetHospitalJson(HospitalGradeCode As %String)
{
    s RetStr=""
    s CTDefineDr=##class(User.DHCDocCTDefine).GetIdByCode(HospitalGradeCode)
	if (CTDefineDr'=""){
		s ChildSub=0
		for{
			s ChildSub=$o(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub))
			q:ChildSub=""
			; "ALL^2123^^"
			s StartDate=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",4)
			continue:((StartDate'="")&&(StartDate>+$h))
			s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",5)
			continue:((EndDate'="")&&(EndDate<=+$h))
			s ConfigArcItemStr=$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",1)
			if (RetStr=""){
                s RetStr = "{"_"'id':'"_$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",1)_"',"_"'text':'"_$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",2)_"'}"
            }else{
                s RetStr = RetStr_",{"_"'id':'"_$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",1)_"',"_"'text':'"_$p($g(^DHCDocCT("DefineData",CTDefineDr,"D",ChildSub)),"^",2)_"'}"
            }
		}
	}
    Q "["_RetStr_"]"
}

/// w ##class(web.DHCDocDiagnosNew).saveInOtherHosname(1958097,"第一医院")
ClassMethod SaveInOtherHosname(EpisodeID, InOtherHosname, Gradename)
{
	q:((EpisodeID="")||(InOtherHosname="")||(Gradename="")) "-1"
	Set PAAdm2object = ##class(User.PAAdm2).%OpenId(EpisodeID)
	Set PAAdm2object.PAADM2InOtherHosflag="Y"
	Set PAAdm2object.PAADM2InOtherHosname=InOtherHosname
	Set PAAdm2object.PAADM2grade=Gradename
	Set sc=PAAdm2object.%Save()
 	If $$$ISERR(sc) {
 		Trollback
 		Quit -100
 	}
	d PAAdm2object.%Close()
	Quit sc
}

ClassMethod SaveOutOtherHosname(EpisodeID, OutOtherHosname, Gradename)
{
	q:((EpisodeID="")||(OutOtherHosname="")||(Gradename="")) "-1"
	Set PAAdm2object = ##class(User.PAAdm2).%OpenId(EpisodeID)
	Set PAAdm2object.PAADM2OutOtherHosflag="Y"
	Set PAAdm2object.PAADM2OutOtherHosname=OutOtherHosname
	Set PAAdm2object.PAADM2Outgrade=Gradename
	Set sc=PAAdm2object.%Save()
 	If $$$ISERR(sc) {
 		Trollback
 		Quit -100
 	}
	d PAAdm2object.%Close()
	Quit sc
}

/// w ##class(web.DHCDocDiagnosNew).CheckOutOtherHosFlag(1958095)
ClassMethod CheckInOtherHosFlag(EpisodeID)
{
	Set Flag="N"
	Set PAAdm2object = ##class(User.PAAdm2).%OpenId(EpisodeID)
	Set Flag=PAAdm2object.PAADM2InOtherHosflag
	d PAAdm2object.%Close()
	Q Flag
}

ClassMethod CheckOutOtherHosFlag(EpisodeID)
{
	Set Flag="N"
	Set PAAdm2object = ##class(User.PAAdm2).%OpenId(EpisodeID)
	Set Flag=PAAdm2object.PAADM2OutOtherHosflag
	d PAAdm2object.%Close()
	Q Flag
}

}
