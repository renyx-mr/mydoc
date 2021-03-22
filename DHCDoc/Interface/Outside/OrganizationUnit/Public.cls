/// Hosptal:四川攀钢集团医院_通用环球医疗集团有限公司
/// Description: 提供给平台的统一方法
/// CreateDate:20200511
/// Creator:nikang
Class DHCDoc.Interface.Outside.OrganizationUnit.Public Extends %RegisteredObject
{

Parameter ExtUserID = "WX";

Parameter PayModeCode = "JTHLWWXZF";

Parameter BaseDataMethod = "DHCDoc.Interface.Outside.OrganizationUnit.BaseData";

Parameter SelfRegMethod = "DHCDoc.Interface.Outside.OrganizationUnit.SelfReg";

/// 预约接口调用顺序 4(锁号reglock) -9(查询账单信息getRegBill) -【第三方扣款】-10(更新账单信息regBill) -8(更新预约信息updateReg)
/// 退号接口调用顺序 7-9(查询账单信息getRegBill)-8(更新预约信息updateReg)-11（可选）-【第三方退款】-10(更新账单信息regBill)
/// 提供给平台的统一方法
/// Code:
/// 	基础信息接口文档v2.1
///      1.获取医院科室信息				dept
///      2.获取医院医生信息				provider
///     预约功能接口文档v2.2
///      1.获取医院科室信息				dept
///      2.获取医院医生信息				provider
///      3.获取某天排班信息				schedule
///      4.预约登记						reglock
///      5.根据排班Id列表查询预约列表 	getLockListBySche
///      6.根据患者Id查询预约列表 		getLockListByPat
///      7.根据预约记录Id查询预约列表 	getLockListById
///      8.根据预约记录Id更新预约记录 	updateReg
///      9.根据预约记录Id获取账单信息 	getRegBill
///      10.根据预约记录Id更新账单信息  regBill
///      11.根据预约记录Id获取退款信息  refundBillNo
///      16.根据排班ID查询排班信息		querySchedule
///      17.根据排班ID串查询排班信息	queryScheduleStr
/// 	患者信息接口文档v2.2
///      1.获取患者信息					getPatient
///      2.新建患者信息（建档）			savePatient
/// Input: Code(对应业务代码) Param1,Param2,Param3,Param4,Param5,Param6
/// 	   Param参数有几个传几个
/// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common(Code,Param1,Param2,Param3,Param4)
/// /// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("provider")
/// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("getPatient","3","530111198807203840","","","","")
/// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("schedule","{""date"" : ""2020-05-21""}")
/// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("schedule","2020-05-21")
/// Debug:w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("reglock","{""scheduleId"" : ""1533||330"",""scheduleDate"" : ""2020-05-21"",""scheduleStartTime"" : ""08:00:00"",""scheduleEndTime"" : ""10:00:00"",""departmentId"" : ""101"",""providerId"" : ""1001"",""createSourceKey"" : ""UM"",""createSourceTypeId"" : 3,""patientFamilyName"" : ""张"",""patientGivenName"" : ""三"",""patientFullName"" : ""张三"",""patientMobileNumber"" : ""18811112222"",""patientIdTypeId"" : 7,""patientId"" : ""0000000006"",""appointmentId"" : """",""appointmentSerialNumber"" : """",""appointmentTypeId"" : ""4"",""appointmentStatusId"" : ""4"",""isCancellable"" : ""true"",""updateDate"" : """",""updateTime"" : """"}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("getLockListBySche","{""scheduleIdList"":[""1443||937"", ""1||1038"", ""10003""]}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("getLockListById","DHC200522154520000005")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("getRegBill","DHC200522154520000005")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("regBill","DHC200522160517000006","{""appointmentId"":""DHC200522160517000006"",""billStatusId"" : ""5"",""paymentMethodId"" : ""3"",""billNumber"" : ""20200522160517DHCC0002"",""billAmount"" : ""9"",""transactionNumber"" : ""UM666667""}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("updateReg","{""appointmentId"":""DHC200521104639000005""}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("refundBillNo","{""appointmentId"":""DHC200521104639000005""}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("regBill","DHC200522154520000005","{""appointmentId"":""DHC200521104639000005"",""billStatusId"" : ""10"",""paymentMethodId"" : ""3"",""billNumber"" : ""20200522154520DHCC0001"",""billAmount"" : ""9"",""transactionNumber"" : ""UM666666""}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("getPatient","{""patientIdTypeId"":""3"",""patientId"" : ""140423199207230355""}")
/// Debug:w ##Class(DHCDoc.Interface.Outside.OrganizationUnit.Public).Common("savePatient","{""patientIdTypeId"" : 3,""patientId"" : ""110111188605069875"",""patientFamilyName"" : ""张"",""patientGivenName"" : ""富贵"",""patientFullName"" : ""张富贵"",""patientGenderTypeId"" : ""4"",""patientMobileNumber"" : ""18811112222"",""patientResidenceAddress"" : ""北京市西城区复兴门外大街 99 号院 11 号楼 3 单元 502室"",""healthCardId"" : ""A4E0374BCBEAB40E4D66AB5078B44XXX""}")
ClassMethod Common(Code As %String, Param1 As %String = "", Param2 As %String = "", Param3 As %String = "", Param4 As %String = "", Param5 As %String = "", Param6 As %String = "")
{
	s ^Hhr("Common",Code)=$LB(Code,Param1,Param2,Param3,Param4,Param5,Param6)
	s BaseDataClsObj=$ZOBJCLASSMETHOD(..#BaseDataMethod,"%New")
	s SelfRegClsObj=$ZOBJCLASSMETHOD(..#SelfRegMethod,"%New")
	if Code="dept"{
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.BaseData).GetDepartment(..#ExtUserID)	
	}elseif Code="provider"{
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.BaseData).GetDoctor()	
	}elseif Code="schedule"{
		s JsonData={}
		do JsonData.%Set("date",Param1)
		s InputJson=JsonData.%ToJSON()
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetSchedule(InputJson,..#ExtUserID)	
	}elseif Code="reglock"{
		s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).RegLock(InputJson,..#ExtUserID,..#PayModeCode)	
	}elseif Code="getLockListBySche"{
		s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegLockBySchedule(InputJson,..#ExtUserID)	
	}elseif Code="getLockListByPat"{
		s JsonData={}
		do JsonData.%Set("patientIdTypeId",Param1)
		do JsonData.%Set("patientId",Param2)
		do JsonData.%Set("startDate",Param3)
		do JsonData.%Set("endDate",Param4)
		s InputJson=JsonData.%ToJSON()
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegLockByPatient(InputJson,..#ExtUserID)	
	}elseif Code="getLockListById"{
		s JsonData={}
		do JsonData.%Set("appointmentId",Param1)
		s InputJson=JsonData.%ToJSON()
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegLockById(InputJson,..#ExtUserID)	
	}elseif Code="getRegBill"{
		s JsonData={}
		do JsonData.%Set("appointmentId",Param1)
		s InputJson=JsonData.%ToJSON()
		;s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRegBillInfo(InputJson,..#ExtUserID)	
	}elseif Code="regBill"{
		s appointmentId=Param1
		s InputJson=Param2
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
		s OutputObj.responseCode="-100"
		s OutputObj.respongseText="测试"
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).RegBill(appointmentId,InputJson,..#ExtUserID,..#PayModeCode)	
	}elseif Code="updateReg"{
		s appointmentId=Param1
		s InputJson=Param2
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).UpdateBookReg(appointmentId,InputJson,..#ExtUserID)	
	}elseif Code="refundBillNo"{
		s JsonData={}
		do JsonData.%Set("appointmentId",Param1)
		s InputJson=JsonData.%ToJSON()
		;s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).GetRefundBillNo(InputJson,..#ExtUserID)
	}elseif Code="getPatient"{
		s JsonData={}
		do JsonData.%Set("patientIdTypeId",Param1)
		do JsonData.%Set("patientId",Param2)
		s InputJson=JsonData.%ToJSON()
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Patient).GetPatient(InputJson,..#ExtUserID)
	}elseif Code="savePatient"{
		s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Patient).SavePatient(InputJson,..#ExtUserID)
	}elseif Code="querySchedule"{
		s JsonData={}
		do JsonData.%Set("scheduleId",Param1)
		s InputJson=JsonData.%ToJSON()
		s ^tmpquerySchedule("querySchedule")=InputJson
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).QueryAdmSchedule(InputJson,..#ExtUserID)
	}elseif Code="queryScheduleStr"{
		s InputJson=Param1
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfReg).QueryAdmScheduleNew(InputJson,..#ExtUserID)
		b ;hhr h6
	}else{
		s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
		s OutputObj.responseCode="-100"
		s OutputObj.respongseText="无效的代码"
	}
	
	if ((Code="provider")||(Code="querySchedule")){
		DO OutputObj.XMLExportToStream(.myXML,"Response")
		s JsonStream=##class(DHCDoc.Util.XMLParse).XMLToJSON(myXML)
	} else {
		set JsonStream=##class(%GlobalCharacterStream).%New()
		do ##class(ext.util.JsonObject).ObjectToJSONStream(OutputObj,.JsonStream)
	}
	b ;hhr JsonStream
	q JsonStream
}

/// 医院挂号采用分时段就诊，线上挂号，已到就诊时间，只能在窗口进行退号
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.Public).CheckCancelReg()
ClassMethod CheckCancelReg(UserID, EpisodeId)
{
	s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	s ret=1
	s WXFlag=0
	s WXUser=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","ExternalUserID")
	if (","_WXUser_",")[(","_UserCode_","){
		s WXFlag=1	
	}
	Q:WXFlag=0 ret ;非线上用户，即窗口可退
	s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_EpisodeId,""))
	if RegfeeRowId'=""{
		s obj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
		if $IsObject(obj){
			s UserDr=obj.RegfeeUserDr
			s SeqNo=obj.RegfeeNo
			s RoomDr=obj.RegfeeRoomDr
			s InvoiceId=obj.Regfeetemp1
			s RBASDr=obj.RegfeeRBASDr
			s TimeRange= ##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(RBASDr,SeqNo)
			s AsDate=$P($G(^RBAS(+RBASDr,$P(RBASDr,"||",2))),"^",1)
			s ASStartTime=$P($G(^RBAS(+RBASDr,$P(RBASDr,"||",2))),"^",4) 
			if TimeRange'=""{
				s TimeRange=$p(TimeRange," ",2)
				s StartTime=$p(TimeRange,"-",1)
				s ASStartTime=$zth(StartTime,1)
				
			}
			if ((AsDate=+$h)&&(ASStartTime<$p(+$h,",",2)))!(AsDate<+$h){
				s ret=0	
			}
		}
	}
	q ret
}

}
