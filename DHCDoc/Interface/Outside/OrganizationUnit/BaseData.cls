/// Hosptal:四川攀钢集团医院
/// Description:  通用环球医疗集团有限公司_基础信息对接接口
/// CreateDate:20200510
/// Creator:nikang
Class DHCDoc.Interface.Outside.OrganizationUnit.BaseData Extends (%RegisteredObject, %XML.Adaptor)
{

/// 查询医院科室信息接口
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.BaseData).GetDepartment().Read()
ClassMethod GetDepartment(ExtUserID As %String)
{
	;s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	s UserID=13126  ;集团互联网微信收费员
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	if (UserID=""){
		s OutputObj.responseCode="-1001"
		s OutputObj.respongseText="His未维护可用用户"
		q OutputObj	
	}
	
	s RecordCount=0
	s HospId=""
	for{
		s HospId=$o(^CT("HOSP",HospId))	
		q:HospId=""
		Set DepartmentObj=##Class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.department).%New()
		s HospName=$p(^CT("HOSP",HospId),"^",2)	 
		s HospCode=$p(^CT("HOSP",HospId),"^",1)	 ;修改成取Code
		i HospId=0 s HospCode="PGJTZYY"
		s DepartmentObj.organizationUnitId=HospCode
		s DepartmentObj.organizationUnitName=$p(^CT("HOSP",HospId),"^",2)	
		s DepartmentObj.organizationUnitAddress=$p(^CT("HOSP",HospId),"^",18)	
		s DepartmentObj.isOnlineServiceEnabled="false"
		s DepartmentObj.levelId=5
		s DepartmentObj.parentId="PGJTZYY"
		i HospId=0 s DepartmentObj.levelId=4,DepartmentObj.parentId=0,DepartmentObj.organizationUnitName="攀钢集团总医院",DepartmentObj.organizationUnitAddress="攀枝花市"
		Do OutputObj.DeptData.Insert(DepartmentObj)
		Do DepartmentObj.%Close()
		Set RecordCount=RecordCount+1
	}
		
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=""
	i $D(^SSU("SSGRP",GroupID,"DHC")){
		s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupID,"DHC")),"^",1)
	}

	set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,"O^E^I","")
	set myDeptNum=$length(myOPDeptStr,"^")
	for i=1:1:myDeptNum
	{
		set myOneDeptStr=$piece(myOPDeptStr,"^",i)
		Set DepartmentObj=##Class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.department).%New()
		set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
		continue:DepartmentCode=""
		s ActiveFlag=$P(^CTLOC(DepartmentCode),"^",14)
		if ActiveFlag'="Y"{
			;continue
		}
		set DepartmentName=$piece(myOneDeptStr,$C(1),2)
		if (DepartmentName["-") d
		.set DepartmentName=$piece(DepartmentName,"-",1)
		set LocAddress=""
		set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
		if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
		set flag=0
		set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResRowId)) Q:ResRowId=""  d
		.Q:(GroupResRowIdStr'="")&&(("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!"))
		.s flag=1
		
		;if ((flag=0)&&(GroupResRowIdStr'="")) continue
		s isOnlineServiceEnabled="false"
		if flag=1{
			s isOnlineServiceEnabled="true"	
		}
		;set ExistDepSchedule=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(DepartmentCode,StartDate,EndDate)
		;查科室过滤没有排班的科室
		;continue:(ExistDepSchedule=0)
		set DepartmentHospCode=$p(^CTLOC(DepartmentCode),"^",22)
		set DepartmentHospDesc=""
		if DepartmentHospCode'="" s DepartmentHospDesc=$p(^CT("HOSP",DepartmentHospCode),"^",2),HospitalCode=$p(^CT("HOSP",DepartmentHospCode),"^",1)
		
		s DepartmentObj.organizationUnitId=DepartmentCode
		s DepartmentObj.organizationUnitName=DepartmentName
		s DepartmentObj.organizationUnitAddress=LocAddress
		s DepartmentObj.isOnlineServiceEnabled=isOnlineServiceEnabled
		s DepartmentObj.levelId=6
		s DepartmentObj.parentId=HospitalCode
		Do OutputObj.DeptData.Insert(DepartmentObj)
		Do DepartmentObj.%Close()
		Set RecordCount=RecordCount+1
	}
	
	d OutputObj.XMLExportToString(.Input)
	q OutputObj
}

/// 查询医院医生信息接口
/// w ##class(DHCDoc.Interface.Outside.OrganizationUnit.BaseData).GetDoctor()
ClassMethod GetDoctor(RowId As %String = "")
{
	s OutputObj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.common).%New()
	s OutputObj.responseCode="0"
	s OutputObj.respongseText="查询成功"
	s OutputObj.responseTimestamp=##class(DHCDoc.Interface.Outside.OrganizationUnit.SelfMethod).getTimestamp()
	s count=0
	s InputObj=##class(%ListOfObjects).%New()
	if (RowId=""){
		s RowId=0
		s ResRowID=0
		f  s RowId=$o(^CTPCP(RowId)) q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTPCP",RowId))
		.s ResLocID=""
		.f  s ResLocID=$o(^RB("RES",0,"CTPCP",RowId,ResLocID)) q:ResLocID=""  d
		..s ResRowID=0
		..s ResRowID=$o(^RB("RES",0,"CTPCP",RowId,ResLocID,ResRowID))
		..q:(ResRowID="")
		..s ScheSt=$p(^RB("RES",ResRowID),"^",6)
		..Q:(ScheSt'="Y")
		..s departmentCode=ResLocID
		..s Active=$p($g(^CTPCP(RowId,1)),"^",9)
		..Q:Active'="Y"
		..s TypeDr=$p(^CTPCP(RowId,1),"^",4)
		..s InternalType=$p($g(^CT("CPT",TypeDr)),"^",4)
		..s TypeDees=$p($g(^CT("CPT",TypeDr)),"^",2)
		..q:InternalType'="DOCTOR"
		..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",RowId,0))
		..s ActiveDateFrom=$p($g(^CTPCP(RowId,2)),"^",14)
		..Q:(ActiveDateFrom'="")&&(+$h<ActiveDateFrom)
		..s ActiveDateTo=$p($g(^CTPCP(RowId,2)),"^",15)
		..Q:(ActiveDateTo'="")&&(+$h'<ActiveDateTo)
		..s doctorName=$p($g(^CTPCP(RowId,1)),"^",2)
		..s doctorCode=$p($g(^CTPCP(RowId,1)),"^",1)
		..s docobj=##class(DHCDoc.Interface.Outside.OrganizationUnit.Entity.doctor).%New()
		..s docobj.providerFullName=doctorName
		..s docobj.providerId=RowId
		..s docobj.providerFamilyName=$e(doctorName,1,1)
		..s docobj.providerGivenName=$e(doctorName,2,$l(doctorName))
		..s docobj.providerGenderTypeId="1" ;性别  未知
		..s docobj.providerResidentId="暂无" ;身份证号
		..s docobj.providerEmployeeId=doctorCode
		..s providerLicenseTypeId=$case(TypeDr,"":"3","":"4","":"5","":"6","":"7","":"8","":"9","":"10","":"11",:"2")
		..s docobj.providerLicenseTypeId=providerLicenseTypeId
		..;医生职称（1 预留，暂不使用，2 其它、 
		..;3 主任医师、 4 主任中医师、 5 副主任医师、 6副主任中医师、 
		..;7 主治医师、 8 主治中医师、9 住院医师、 10 医师、 11 助理医师
		..s docobj.providerLicenseTypeName=$case(providerLicenseTypeId,"3":"主任医师","4":"主任中医师","5":"副主任医师","6":"副主任中医师","7":"主治医师","8":"主治中医师","9":"住院医师","10":"医师","11":"助理医师",:"其它")
		..s docobj.providerDescription="暂无"
		..s docobj.primaryDepartmentId=departmentCode
		..s docobj.providerExpertiseName="暂无"
		..Do OutputObj.DoctorData.Insert(docobj)
		..Do docobj.%Close()
		..s count=count+1
	}
	d OutputObj.XMLExportToString(.Input)
	b
	q OutputObj
}

}
