Class web.DHCDocHLYYJHMK Extends %RegisteredObject
{
/// renyx 根据抗菌药物申请单的id获取打印数据
ClassMethod GetAntPrintData(EpisodeID As %String, AntRowId As %String)
{
	q:'$d(^DHCDAA("ANT",AntRowId)) ""
	s PatInfoStr=..GetPatBaseInfo(EpisodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1="",Diagnose2=""
	k TmpPatDiagArr,TmpOnePatDiagArr
    s diagDesc=$p(PatInfoStr,"^",20) //所有诊断
    // 名称 规格 用法 数量  拟用时间
    ;病史及诊疗情况摘要 申请理由
    ;会诊意见  抗菌药物工作组意见
    ;备注 用药监测项目结果
    s ArcimId=$p($g(^DHCDAA("ANT",AntRowId)),"^",2)
    s ArcItemDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
    ;规格
    s Specification="" 
	s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	if (InciRowid'="") s Specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
    ;用法
	s InstrDR=$p($g(^DHCDAA("ANT",AntRowId)),"^",8)
	s InstrDesc=""
	s:InstrDR'="" InstrDesc=$p($g(^PHCIN(InstrDR)),"^",2)
    s AntQty="12"
}
｝