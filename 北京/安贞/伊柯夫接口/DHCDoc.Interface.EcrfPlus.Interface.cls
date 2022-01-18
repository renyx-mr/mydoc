Class DHCDoc.Interface.EcrfPlus.Interface Extends %RegisteredObject
{

ClassMethod PushItemInformation(PPRowId As %String)
{
    s PilotProject=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
    s OutPutObj={} ;##(%DynamicObject).%New()
    s OutPutObj.InvestigatorList=[]
    if $ISObject(PilotProject){
        ; <ProjectID>项目编号</ProjectID>
        s OutPutObj.ProjectID=PilotProject.PPCode
        ;  <StudyID>研究编号</StudyID>
        s OutPutObj.StudyID=PilotProject.ProjectNo
        ; <ORGNumber>机构编号</ORGNumber>
        s OutPutObj.ORGNumber="" ;PilotProject.PPCode
        ;  <ProjectName>项目名称</ProjectName>
        s OutPutObj.ProjectName=PilotProject.PPCode
        ;  <ProjectStatus>项目状态</ProjectStatus>
        //Normal立项,Abort暂停,Strike终止,Verify在研,UnApproved未批准,InApprove审批中,Finish已完成,Hang未进行，Break中止,Excep非大表数据，C发布后在研，didnotpass上会未通过只有财务用到
        s PPState=$case(PilotProject.PPState,"A":"暂停","S":"暂停","V":"在研","U":"未批准","I":"审批中","F":"已完成","H":"未进行","B":"中止","E":"非大表数据","C":"发布后在研","D":"上会未通过只有财务用到")
        s OutPutObj.ProjectStatus=PPState
        ;  <TypeCode>试验期别</TypeCode>
        s OutPutObj.TypeCode=""
        ;  <TypeName>试验期别名称</TypeName>
        s OutPutObj.TypeName=""
        ;  <PICode>主要研究者工号</PICode>
        s OutPutObj.ProjectID=PilotProject.PPStartUserDr.SSUSRInitials
        ; <PIName>主要研究者姓名</PIName>
        s OutPutObj.PIName=PilotProject.PPStartUserDr.SSUSRName
        ; <DeptCode>研究科室编号</DeptCode>
        s OutPutObj.DeptCode=PilotProject.PPCreateDepartmentDr.CTLOCCode
        ; <DeptName>研究科室名称</DeptName>
        s OutPutObj.DeptName=PilotProject.PPCreateDepartmentDr.CTLOCDesc
        ; <DrugName>药物/器械名称</DrugName>
        s OutPutObj.DrugName=""
        ; <BusinessName>申办方名称</BusinessName>
        s OutPutObj.BusinessName=""
        ; <CROName>CRO名称</CROName>
        s OutPutObj.CROName=""
        ; <SMOName>SMO名称</SMOName>
        s OutPutObj.SMOName=""
        ; <IRBResultNo>首次伦理批件号</IRBResultNo>
        s OutPutObj.IRBResultNo=""
        ; <PIAName>研究助理</PIAName>
        s OutPutObj.PIAName=""
        ; <InvestigatorList>
        ; <!---多条数据-->
        s PPCChildSub=0
        for {
            s PPCChildSub=$o(^DHCDocPPC(PPRowId,PPCChildSub))
            q:PPCChildSub=""
            ; <Investigator>
            s Investigator={} ;##(%DynamicObject).%New()
            s PilotProCareRowId=PPRowId_"||"_PPCChildSub
            s PilotProCare=##class(User.DHCDocPilotProCare).%OpenId(PilotProCareRowId)
            if $ISObject(PilotProCare){
                ; <UserID>人员ID</UserID>
                s Investigator.UserID=PilotProCare.PPCDoctorDrGetObjectId()
                ; <UserName>姓名</UserName>
                s Investigator.UserName=PilotProCare.PPCDoctorDr.CTPCPDesc
                ; <JobNumber>工号</JobNumber>
                s Investigator.JobNumber=PilotProCare.PPCDoctorDr.CTPCPCode
                ; <Status>状态</Status>
                s Investigator.Status=$case(PilotProCare.PPCState,"N":"Normal","A":"Abort","S":"Strike",:"")
                d PilotProCare.%Close()
                d OutPutObj.InvestigatorList.%Push(Investigator)
            }
        ; <Investigator>
        
        ; </Investigator>
        }
        ; </InvestigatorList>
    }
    d PilotProject.%Close()
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Request","")
}

ClassMethod GetSubjectScheduledEvents(PPRowId As %String, PatId As %String)
{
    s OutPutObj={} ;##(%DynamicObject).%New()
    s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
    s PatNo=$p($g(^PAPER(PatId,"PAT",1)),"^",1)
    ; <ProjectID>项目编号</ProjectID>
    s OutPutObj.ProjectID=PPCode
    ; <PatientID>病人ID</PatientID>
    s OutPutObj.PatientID=PatNo
    ; <PIJobNumber>主要研究者工号</PIJobNumber>
    s StartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
    s UserCode=$p($g(^SSU("SSUSR",StartUserDr)),"^",1)
    s OutPutObj.PIJobNumber=UserCode
    s RequestStream=##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Request","")
}

ClassMethod PushPilotProjectOrder(PPRowId As %String, AdmId As %String, OrderStr As %String)
{
	s OutPutObj={}
    s OutPutObj.OrderList=[]
	; <ProjectID>项目编号</ProjectID>
	s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
	s OutPutObj.ProjectID=PPCode
	; <ProjectName>项目名称</ProjectName>
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s OutPutObj.ProjectName=PPDesc
	; <EventID>日程安排事件ID</EventID>
    s OutPutObj.EventID=""
	; <CompleteDate>完成时间(CHECKDATE)</CompleteDate>
    s OutPutObj.CompleteDate=""
	; <PatientID>病人ID,HIS中的病人唯一号</PatientID>
    s PatId=$p($g(^PAADM(AdmId)),"^",1)
    s PatNo=$p($g(^PAPER(PatId,"PAT",1)),"^",1)
    s OutPutObj.PatientID=PatNo
	; <DoctorCode>医生工号</DoctorCode>
    s StartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
    s OutPutObj.DoctorCode=$p($g(^SSU("SSUSR",StartUserDr)),"^",1)
	; <DoctorName>医生名称</DoctorName>
    s OutPutObj.DoctorName=$p($g(^SSU("SSUSR",StartUserDr)),"^",2)
	; <PatientType>病人类型</PatientType>
    s AdmType=$p($g(^PAADM(AdmId)),"^",2)
    s OutPutObj.PatientType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:"")
	; <DeptCode>就诊科室编号</DeptCode>
    s AdmLocDr=$p($g(^PAADM(AdmId)),"^",4)
    s OutPutObj.DeptCode=$p($g(^CTLOC(AdmLocDr)),"^",1)
	; <DeptName>就诊科室名称</DeptName>
    s OutPutObj.DeptName=$p($g(^CTLOC(AdmLocDr)),"^",2)
	; <DistrictCode>病区编号</DistrictCode>
    s CurrentWardDR=$p($g(^PAADM(AdmId)),"^",70)
    s OutPutObj.DistrictCode=""
    s:CurrentWardDR'="" OutPutObj.DistrictCode=$p($g(^PAWARD(CurrentWardDR)),"^",1)
	; <DistrictName>病区名称</DistrictName>
    s OutPutObj.DistrictName=""
    s:CurrentWardDR'="" OutPutObj.DistrictName=$p($g(^PAWARD(CurrentWardDR)),"^",2)
	; <WardCode>病房编号</WardCode>
    s CurrentRoomDR=$p($g(^PAADM(AdmId)),"^",69)
    s OutPutObj.WardCode=""
    s:CurrentRoomDR'="" OutPutObj.WardCode=$p($g(^PAROOM(CurrentRoomDR)),"^",1)
	; <WardName>病房名称</WardName>
    s OutPutObj.WardName=""
    s:CurrentRoomDR'="" OutPutObj.WardName=$p($g(^PAROOM(CurrentRoomDR)),"^",2)
	; <BedNo>病床号</BedNo>
    s CurrentBedDR=$p($g(^PAADM(AdmId)),"^",73)
    s OutPutObj.BedNo=""
    s:CurrentBedDR'="" OutPutObj.BedNo=$p($g(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2))),"^",1)
	; <OrderID>医嘱号</OrderID>
    s OutPutObj.OrderID=""
	; <OrderList>
    for OrdInd=1:1:$l(OrderStr,"^"){
        s OrdIteDr=$p(OrderStr,"^",OrdInd)
        continue:OrdIteDr=""
        s ArcItemDr=$p($g(^OEORD(+OrdIteDr,"I",$p(OrdIteDr,"||",2),1)),"^",2)
        continue:ArcItemDr=""
        Set ItemCatDR=$p($g(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2),1)),"^",10)
		Set OrderType=$P($g(^ARC("IC",ItemCatDR)),"^",7)
        ; <OrderInfo>
        s OrderInfo={}
        ; <OrderNo>申请单号</OrderNo>
        s OrderNo=""
        if (OrderType="L"){
            s ExaReqID=$o(^DHCAPREP(0,"OrdItem",OrdIteDr,""))
            s OrderNo=$p(^DHCAPREP(ExaReqID),"^",1)
        }else{
            s OrderNo=$p($g(^OEORD(+OrdIteDr,"I",$p(OrdIteDr,"||",2),3)),"^",2)
        }
        s OrderInfo.OrderNo=OrderNo
        ; <ClinicCode>检验检查项目代码</ClinicCode>
        s OrderInfo.ClinicCode=$p($g(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2),1)),"^",1)
        ; <ClinicName>检验检查项目名称</ClinicName>
        s OrderInfo.ClinicName=$p($g(^ARCIM(+ArcItemDr,$p(ArcItemDr,"||",2),1)),"^",2)
        ; <OrderStatus>状态</OrderStatus>
        s StatusDR=$p($g(^OEORD(+OrdIteDr,"I",$p(OrdIteDr,"||",2),1)),"^",13)
		s OrderInfo.OrderStatus=$p($g(^OEC("OSTAT",StatusDR)),"^",2)
        ; </OrderInfo>
        d OutPutObj.OrderList.%Push(OrderInfo)
    }
	; </OrderList>
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(OutPutObj,"Request","")
}

}
