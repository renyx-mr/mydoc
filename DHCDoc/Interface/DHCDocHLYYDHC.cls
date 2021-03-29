/// 合理用药的后台数据获取类
Class DHCDoc.Interface.DHCDocHLYYDHC Extends web.DHCDocHLYY
{
/// w ##class(web.DHCHLYY).GetPrescInfo(8697,"265||1!0.5!109!4!63!8!265||1!5!1!1!","测试医生")
///  8697,265||1!0.5!109!4!63!8!265||1!5!1!1!,测试医生
///  ,26||1!0.2!109!5!63!2!26||1!3!3^1490||1!10!139!40!63!2!1490||1!3!4,唐骅		
ClassMethod GetPrescInfo(EpisodeID As %String, OrderStr As %String, DocName As %String)
{
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    else  s PatientSex=""
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=$ZD($G(PatientDOB),3)
    //&SQL(Select PAPMI_No into :PatientNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
    s Height="" ;身高
    s Weight="" ;体重
    s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)    
    s PAAdmReason=""  // 费别 (医保,自费) 
    If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	s BloodPress=""    // 血压  
    s SpecGrps=""    //特殊人群 
    s ProfessProp=""  // 职业
    s PatType=""  // 患者类别(门诊,住院,急诊) 
    s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
    s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
    s PatLoc=EpisodeLocCode  // 就诊科室
    s AdmDocCodeDR=$p($g(^PAADM(EpisodeID)),"^",9)
    s DocDesc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
    s MainDoc=DocDesc  // 主管医生
    s Hospital="" // 医院(登录信息)
    s Profess="" // 职称(登录用户)
    s Group="" //  安全组  
    s LgCtLoc="" // 登录科室 2020/12/1
    s LgUser="" // 登录用户  2020/12/1
    s PatInfo=PatientID_"^"_PatientName_"^"_PatientSex_"^"_PatientBirthday_"^"_Height_"^"_Weight
    s PatInfo=PatInfo_"^"_PAAdmReason_"^"_BloodPress_"^"_SpecGrps_"^"_ProfessProp_"^"_PatType
    s PatInfo=PatInfo_"^"_PatLoc_"^"_DocDesc_"^"_Hospital_"^"_Profess_"^"_Groupe
    s PatInfo=PatInfo_"^"_LgCtLoc_"^"_LgUser
    q PatInfo
}
/// 获取插入的医嘱信息  
ClassMethod () As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
}
}