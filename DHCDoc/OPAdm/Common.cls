/// creator：:郭荣勇
/// date：2017-06-08
/// desc：收集和编写预约挂号产品线的业务公共方法类
Class DHCDoc.OPAdm.Common Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：根据发票id得到就诊id
/// input:INVRowId 发票表Rowid(DHC_INVPRT)
/// output:Adm	就诊记录Rowid(PA_Adm)
ClassMethod GetAdmByINV(INVRowId As %String) As %String
{
	n (INVRowId)
	Q:INVRowId=""
	s ConRowId=$O(^DHCBCI(0,"INV",INVRowId,0))
	Q:ConRowId="" ""
	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
	Q:PBRowId="" ""
	s Adm=$P(^DHCPB(PBRowId),"^",1) 
	Q Adm
}

/// creator：:郭荣勇
/// date：2017-06-09
/// desc：根据当前发票正票id得到最初的正票id(多次红冲会出现多个正票和负票),此方法由计费组提供技术咨询
/// input:发票表Rowid(DHC_INVPRT)
/// output:发票表Rowid(DHC_INVPRT)
/// other: 只传第二个参数,第一个参数和第三个参数传空
/// w ##class(DHCDoc.OPAdm.Common).GetOrgPrtRowID("",2121,"")
ClassMethod GetOrgPrtRowID(AbortPrtRowID, NewPrtRowid, ExpStr)
{
	New (AbortPrtRowID,NewPrtRowid,ExpStr)
	Set myPrtRowID=""
	If (+NewPrtRowid=0) {
		;新发票Rowid为空,一定上全退,负责为部分退费
		Set InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR
		Set myPrtRowID=InitInvDR
	}Else{
		Set OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR
		Set myPrtRowID=OldInvDR	
	}
	if (myPrtRowID'="") {
		Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)
		While (+myOldInvDR'=0) {
			Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR
			If (+myOldInvDR'=0){
				Set myPrtRowID=myOldInvDR
			}
		}
	}
	Quit myPrtRowID
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：判断病人有无收费发票，如果有收费发票，则病人不能退号
/// input:Adm	就诊记录Rowid(PA_Adm)
/// output:Y 存在,N 不存在
ClassMethod GetPrtFairType(Adm)
{
	n (Adm)
	s Flag="N"
	s dhcbirowid=""
	f  s dhcbirowid=$o(^DHCBCI(0,"ADM",Adm,dhcbirowid)) q:dhcbirowid=""  d
	.s invprtid=$p(^DHCBCI(dhcbirowid),"^",1)
	.s prtfairtype=$P($g(^DHCINVPRT(invprtid)),"^",34)
	.s prtflag=$P($g(^DHCINVPRT(invprtid)),"^",8)
	.i prtfairtype="F"  S Flag="Y"
	q Flag
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：通过就诊id得到预约记录id
/// input:Adm	就诊记录Rowid(PA_Adm)
/// output:预约记录id(eg:121||12||1)
ClassMethod GetAppByAdm(Adm)
{
	Q ##class(web.DHCRBAppointment).GetAppByAdm(Adm)
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：得到服务项所对应的挂号费用类型
/// input:SerId	挂号职称ID(RBC_SessionType)
/// output:挂号费用类型代码(eg:"Reg","Check","App","Other"等)
ClassMethod GeRegSerBillSubType(SerId) As %String
{
	n (SerId)
	Q:SerId="" ""
	s ArcimId=$p(^RBC("SER",SerId),"^",1)
	Q ##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：得到发票的支付方式和金额
/// input:InvoiceId	发票表ID(DHC_INVPRT)
/// output:支付方式和金额字符串(eg:"自费:3,医保:2,账户:1")
ClassMethod GetINVPayMode(InvoiceId As %String) As %String
{
	n (InvoiceId)
	Q:InvoiceId="" ""
	Q ##class(web.DHCOPAdmReg).GetINVPayMode(InvoiceId)
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：得到病人类型默认费别
/// input:PatCatDr	病人类型ID
/// output:费别ID
ClassMethod GetDefaultBillType(PatCatDr As %String) As %String
{
	n (PatCatDr)
	Q:PatCatDr="" ""
	Q ##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
}

/// creator：:郭荣勇
/// date：2017-06-08
/// desc：得到排班记录对应的服务串,如果模板上未定义服务则去找医生上所定义的服务
/// input:ASRowId	出诊记录ID
/// output:医嘱项id字符串(eg:1313||1^43434||1)
ClassMethod GetScheduleService(ASRowId As %String) As %String
{
	n (ASRowId)
	Q:ASRowId="" ""
	Q ##class(web.DHCOPAdmReg).GetScheduleService(ASRowId)
}

}
