Class web.DHCDocCovidEmployee Extends %RegisteredObject
{

/// w ##class(web.DHCDocCovidEmployee).ImportHrpByXls()
ClassMethod ImportHrpByXls()
{
	try{
		//s Stream=##class(%Stream.FileCharacter).%New()
		//s Sc=Stream.LinkToFile("/tmp/核酸字段.xlsx")
		s Stream =##class(%FileCharacterStream).%New()
		s Stream.Filename = "/tmp/coviddata.txt"
		s FlieLineInd=0
		//w Stream.AtEnd,!
		while 'Stream.AtEnd{
			s line=Stream.ReadLine()
			s FlieLineInd=FlieLineInd+1
			continue:FlieLineInd=1
			//w line,!
			//b ;;;23
			s ZhrRfcS11Obj=##class(Nur.Test.XH.tns.ZhrRfcS11).%New()
			//雇佣状态
			s ZhrRfcS11Obj.Stat2=$p(line,"^",1)
			//员工组
			s ZhrRfcS11Obj.Pgtxt=$p(line,"^",2)
			//员工子组
			s ZhrRfcS11Obj.Pktxt=$p(line,"^",3)
			//一级科室
			s ZhrRfcS11Obj.EK1t=$p(line,"^",4)
			//组织单位	
			//s ZhrRfcS11Obj.Ename=$p(line,"^",5)
			//主管部门
			//s ZhrRfcS11Obj.Ename=$p(line,"^",6)
			//工号/学号
			s ZhrRfcS11Obj.Rufnm=$p(line,"^",7)
			//姓名	
			s ZhrRfcS11Obj.Ename=$p(line,"^",8)
			//标识类型 (IC 类型)
			s ZhrRfcS11Obj.EIdtyp=$p(line,"^",9)
			//标识编号	
			s ZhrRfcS11Obj.EIdnum=$p(line,"^",10)
			//所属劳务外包公司	
			//s ZhrRfcS11Obj.Ename=$p(line,"^",11)
			//人员编号	
			//s ZhrRfcS11Obj.Ename=$p(line,"^",12)
			//岗位分类	
			s ZhrRfcS11Obj.ZzZyflT=$p(line,"^",13)
			//工作岗位/工种
			s ZhrRfcS11Obj.ZzGwflT=$p(line,"^",14)
			d ..ImportEmployeeData(ZhrRfcS11Obj)
		}
	}catch sc{
		b 
	}
	q "1"
}

/// w ##class(web.DHCOPAdmRegLocal).ImportEmployeeData(ImportObj)
ClassMethod ImportEmployeeData(ImportObj As Nur.Test.XH.tns.ZhrRfcS11)
{
	s Err=0
	q:ImportObj.Rufnm="" Err
	q:'$IsObject(ImportObj) Err
	try{
		s DCERowId=$o(^User.DHCDocCovidEmployeeI("Initials"," "_ImportObj.Rufnm,0))
		//b ;;;23
		s CovidEmployeeObj=""
		TS
		if (DCERowId'=""){
			s CovidEmployeeObj=##class(User.DHCDocCovidEmployee).%OpenId(DCERowId)
		}else{
			s CovidEmployeeObj=##class(User.DHCDocCovidEmployee).%New()
		}
		// 离职，2 离退休，3 在职
		s EmploymentStatus=$case(ImportObj.Stat2,"0":"离职","2":"离退休","3":"在职",:ImportObj.Stat2)
		s:(EmploymentStatus'="") CovidEmployeeObj.DCEEmploymentStatus=EmploymentStatus
		s:(ImportObj.Pgtxt'="") CovidEmployeeObj.DCEGroup=ImportObj.Pgtxt
		s:(ImportObj.Pktxt'="") CovidEmployeeObj.DCEDormitoryGroup=ImportObj.Pktxt
		s:(ImportObj.EK1t'="") CovidEmployeeObj.DCEGroupDept=ImportObj.EK1t
		s:(ImportObj.Rufnm'="") CovidEmployeeObj.DCEInitials=ImportObj.Rufnm
		s:(ImportObj.Ename'="") CovidEmployeeObj.DCEPatName=ImportObj.Ename
		//01	身份证号 21	公务普通护照 22	公务护照 23	外交护照 24	因私普通护照 03	台胞证 41	因公港澳通行证 42	因私港澳通行证 51	大陆居民往来台湾通行证
		s IDType=$case(ImportObj.EIdtyp,"01":"身份证号","21":"公务普通护照","22":"公务护照","23":"外交护照","24":"因私普通护照","03":"台胞证","41":"因公港澳通行证","42":"因私港澳通行证","51":"大陆居民往来台湾通行证",:ImportObj.EIdtyp)
		s:(IDType'="") CovidEmployeeObj.DCEIDType=IDType
		s:(ImportObj.EIdnum'="") CovidEmployeeObj.DCEIDNumber=ImportObj.EIdnum
		s:(ImportObj.ZzZyflT'="") CovidEmployeeObj.DCEClassPost=ImportObj.ZzZyflT
		s:(ImportObj.ZzGwflT'="") CovidEmployeeObj.DCECPost=ImportObj.ZzGwflT
		if (DCERowId=""){
			s CovidEmployeeObj.DCECreateDate=+$h
			s CovidEmployeeObj.DCECreateTime=$p($h,",",2)
		}else{
			s CovidEmployeeObj.DCELastUpDate=+$h
			s CovidEmployeeObj.DCELastUpTime=$p($h,",",2)
		}
		s PatientDrStr=##class(web.DHCOPAdmRegLocal).GetAllPatIDByIDCardAndName(ImportObj.EIdnum,ImportObj.Ename)
		if (PatientDrStr'="")&&($l(PatientDrStr,"^")=1){
			s CovidEmployeeObj.DCEPatientNo=PatientDrStr
		}else{
			s:PatientDrStr="" CovidEmployeeObj.DCECheckLog="没有在his里面找到该患者信息"
			s:$l(PatientDrStr,"^")>1 CovidEmployeeObj.DCECheckLog="该身份号对应多条信息"
		}
		s ObjS= CovidEmployeeObj.%Save()
		If $$$ISERR(ObjS) {
			b //Do $System.Status.DisplayError()
			Trollback
			s Err=100
		}else{
			//b ;;;23
			TC
		}
	}catch sc{
		tro
	}
	q Err
}

/// Do ##class(web.DHCDocCovidEmployee).GetZrfc11Info("20211104")
/// 获取第三方hr接口
///       
/// 
ClassMethod GetZrfc11Info(inDate As %String) [ Final ]
{
	#dim zhrs03 As Nur.Test.XH.tns.ZhrRfcS11
	#dim list03 As %ListOfObjects
	#dim list04 As %ListOfObjects
	#dim list05 As %ListOfObjects
		
	Set soap=##class(Nur.Test.XH.zrfc11).%New()
	Set soap.Username="RFC_U6"
	Set soap.Password="pumch123456"
	Set list03=soap.Zrfc11(inDate)
	Write list03.GetAt(1),!
	
	Set nums3 = list03.Count()
	If nums3>0 
	{
		For i=1:1:nums3
		{
			Set zhrs03=list03.GetAt(i)
			d ..ImportEmployeeData(zhrs03)
			/*s RowID=$O(^User.DHCMGPersonsI("SSID"," "_$zcvt(zhrs03.Rufnm,"U"),""))
			i RowID="" continue
			w RowID,!*/
			//Write "date|"_zhrs03.Aedtm_"^name|"_zhrs03.Ename_"^perid|"_zhrs03.Rufnm_"^gw|"_zhrs03.EPlans_"^gwmc|"_zhrs03.EPtext_"^sex|"_zhrs03.Gesch_"^birthday|"_zhrs03.Gbdat_"^idcard|"_zhrs03.Ictxt_"^stat|"_zhrs03.Stat2_"^zwname|"_zhrs03.EZwmct_"^zcname|"_zhrs03.EZyjzt_"^edu|"_zhrs03.EAcaqu_"^workday|"_zhrs03.EDate1_"^todate|"_zhrs03.EDate2,!
		}	
	}
	q 1
}

}
