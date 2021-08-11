Class DHCDoc.Interface.RongWeiZhongBang.TriageCall Extends (%RegisteredObject, %XML.Adaptor)
{
ClassMethod GetRoomNoByIp(IPAddress As %String)
{
    q:IPAddress="" ""
    s IPAddress=" "_IPAddress
    s DHCRoomCompDr=$o(^User.DHCRoomCompI("RoomcIpIndex",IPAddress,0))
    q:DHCRoomCompDr="" ""
    s RoomcRoomDr=$List(^User.DHCRoomCompD(DHCRoomCompDr),5)
    q:RoomcRoomDr="" ""
    q $p($g(^CTLOC(RoomcRoomDr)),"^",1)
}
ClassMethod Login(IPAddress As %String,UserId As %String,DeptId As %String)
{
    s InputObj=##class(%DynamicObject).%New()
    ; room varchar 50 √ 房间号(必)
    s RoomNo=..GetRoomNoByIp(IPAddress)
    d InputObj.%Set("room",RoomNo)
    ; doctor_code varchar 50 × 医生编号(必)
    s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
    d InputObj.%Set("doctor_code",UserCode)
    ; dept_code varchar 50 × 科室编号(必)
    s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
    d InputObj.%Set("dept_code",DeptCode)
    ; expert varchar 50 × 医生出诊级别(0 普通 1 专家)
    Set CTCPTInternalType="", isNurse=0
	s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
    s CTPCPCarPrvTpDesc=""
    if (DocId'=""){
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(DocId,1)),"^",4)
		s CTPCPCarPrvTpDesc = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
	}
    /*if (CTPCPCarPrvTpDesc'["普"){
        s CTPCPCarPrvTpDesc="1"
    }else{
        s CTPCPCarPrvTpDesc="0"
    }*/
    d InputObj.%Set("expert",CTPCPCarPrvTpDesc)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(InputObj,"root","")
}
ClassMethod Logout(IPAddress As %String,UserId As %String,DeptId As %String)
{
    s InputObj=##class(%DynamicObject).%New()
    ; room varchar 50 √ 房间号(必)
    s RoomNo=..GetRoomNoByIp(IPAddress)
    d InputObj.%Set("room",RoomNo)
    ; doctor_code varchar 50 × 医生编号(必)
    s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
    d InputObj.%Set("doctor_code",UserCode)
    ; dept_code varchar 50 × 科室编号(必)
    s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
    d InputObj.%Set("dept_code",DeptCode)
    ; expert varchar 50 × 医生出诊级别(0 普通 1 专家)
    Set CTCPTInternalType="", isNurse=0
	s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
    s CTPCPCarPrvTpDesc=""
    if (DocId'=""){
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(DocId,1)),"^",4)
		s CTPCPCarPrvTpDesc = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
	}
    /*if (CTPCPCarPrvTpDesc'["普"){
        s CTPCPCarPrvTpDesc="1"
    }else{
        s CTPCPCarPrvTpDesc="0"
    }*/
    d InputObj.%Set("expert",CTPCPCarPrvTpDesc)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(InputObj,"root","")
}
ClassMethod NextCall(IPAddress As %String,AdmId As %String,DocDr As %String,UserId As %String,DeptId As %String)
{
    s QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(AdmId,DocDr)
    q:QueRowId="" ""
    s InputObj=##class(%DynamicObject).%New()
    ; room varchar 50 × 房间号(必)
    s RoomNo=..GetRoomNoByIp(IPAddress)
    d InputObj.%Set("room",RoomNo)
    ; reg_id varchar 50 × 患者唯一 ID
    s PatientID=$p($g(^PAADM(AdmId)),"^",1)
    s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
    d InputObj.%Set("reg_id",PatientNo)
    ; doctor_code varchar 50 × 医生编号(必)
    s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
    d InputObj.%Set("doctor_code",UserCode)
    ; dept_code varchar 50 × 检查项目编号(必)
    s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
    d InputObj.%Set("dept_code",DeptCode)
    ; expert varchar 50 × 医生出诊级别(0 普通 1 专家)
    s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
    s CTPCPCarPrvTpDesc=""
    if (DocId'=""){
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(DocId,1)),"^",4)
		s CTPCPCarPrvTpDesc = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
	}
    /*if (CTPCPCarPrvTpDesc'["普"){
        s CTPCPCarPrvTpDesc="1"
    }else{
        s CTPCPCarPrvTpDesc="0"
    }*/
    d InputObj.%Set("expert",CTPCPCarPrvTpDesc)
    ; pat_now varchar 50 × 当前患者姓名
    s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
    d InputObj.%Set("pat_now",PatName)
    ; now_seq_no varchar 50 × 当前患者序号
    s SeqNo=$List(^User.DHCQueueD(QueRowId),10)
    d InputObj.%Set("now_seq_no",CTPCPCarPrvTpDesc)
    ; pat_wait varchar 50 × 等候患者姓名
    d InputObj.%Set("pat_wait",CTPCPCarPrvTpDesc)
    ; wait_seq_no varchar 50 × 等候患者序号
    d InputObj.%Set("wait_seq_no",CTPCPCarPrvTpDesc)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(InputObj,"root","")
}
ClassMethod CallAgain(IPAddress As %String,AdmId As %String,DocDr As %String,UserId As %String,DeptId As %String)
{
    s QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(AdmId,DocDr)
    q:QueRowId="" ""
    s InputObj=##class(%DynamicObject).%New()
    ; room varchar 50 × 房间号(必)
    s RoomNo=..GetRoomNoByIp(IPAddress)
    d InputObj.%Set("room",RoomNo)
    ; reg_id varchar 50 × 患者唯一 ID
    s PatientID=$p($g(^PAADM(AdmId)),"^",1)
    s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
    d InputObj.%Set("reg_id",PatientNo)
    ; doctor_code varchar 50 × 医生编号(必)
    s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
    d InputObj.%Set("doctor_code",UserCode)
    ; dept_code varchar 50 × 检查项目编号(必)
    s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
    d InputObj.%Set("dept_code",DeptCode)
    ; expert varchar 50 × 医生出诊级别(0 普通 1 专家)
    s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
    s CTPCPCarPrvTpDesc=""
    if (DocId'=""){
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(DocId,1)),"^",4)
		s CTPCPCarPrvTpDesc = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
	}
    /*if (CTPCPCarPrvTpDesc'["普"){
        s CTPCPCarPrvTpDesc="1"
    }else{
        s CTPCPCarPrvTpDesc="0"
    }*/
    d InputObj.%Set("expert",CTPCPCarPrvTpDesc)
    ; pat_now varchar 50 × 呼叫患者姓名
    s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
    d InputObj.%Set("pat_now",PatName)
    ; now_seq_no varchar 50 × 呼叫患者序号
    s SeqNo=$List(^User.DHCQueueD(QueRowId),10)
    d InputObj.%Set("now_seq_no",SeqNo)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(InputObj,"root","")
}
/// 过号调用数据接口
/// 入参：IPAddress 登录电脑ip，DocDr 医护人员id，UserId 用户id，DeptId 科室id
/// 出参：第三方使用xml串
ClassMethod OverNumber(IPAddress As %String,AdmId As %String,DocDr As %String,UserId As %String,DeptId As %String)
{
    s QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(AdmId,DocDr)
    q:QueRowId="" ""
    s InputObj=##class(%DynamicObject).%New()
    ; room varchar 50 × 房间号
    s RoomNo=..GetRoomNoByIp(IPAddress)
    d InputObj.%Set("room",RoomNo)
    ; reg_id varchar 50 × 患者唯一 Id
    s PatientID=$p($g(^PAADM(AdmId)),"^",1)
    s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
    d InputObj.%Set("reg_id",PatientID)
    ; pat_now varchar 50 × 患者姓名
    s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
    d InputObj.%Set("pat_now",PatName)
    ; doctor_code varchar 50 × 医生编号
    s UserCode=$P($g(^SSU("SSUSR",UserId)),"^",1)
    d InputObj.%Set("doctor_code",UserCode)
    ; dept_code varchar 50 × 科室编码
    s DeptCode=$p($g(^CTLOC(DeptId)),"^",1)
    d InputObj.%Set("dept_code",DeptCode)
    ; now_seq_no varchar 50 × 患者序号
    s SeqNo=$List(^User.DHCQueueD(QueRowId),10)
    d InputObj.%Set("now_seq_no",SeqNo)
    q ##class(DHCDoc.Util.XMLParse).ObjToXML(InputObj,"root","")
}
}