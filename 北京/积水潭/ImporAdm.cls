Class ImporAdm Extends (%RegisteredObject, %XML.Adaptor)
{
/// 导入住院的患者
/// w ..ExportInPat("Y","Y",1) 
/// 传入Y检索数据库中最新患者信息 传入N使用检索的历史信息 
/// CheckData="Y" 只是检测患者信息不导入
/// Meth=1 使用有效在院患者进行导入 其他使用已经办理出院患者信息导入
/// ^lxz("ExportInPat",登记号)="信息"
/// ^lxz("ExportInPat",母亲登记号,婴儿登记号)="信息"
/// ^lxz("ExportInPat",0,"ErrDate",登记号)=错误信息
/// ^lxz("ExportInPat",0,"ErrDate",0,"LOCNULL") 住院科室不存在
/// ^lxz("ExportInPat",0,"ErrDate",0,"LOC")住院科室未对照
/// ^lxz("ExportInPat",0,"ErrDate",0,"WARNULL") 住院病区不存在
/// ^lxz("ExportInPat",0,"ErrDate",0,"WAR") 住院病区未对照
ClassMethod ExportInPat(GetNewDataFlag As %String = "", CheckData As %String = "", Meth As %String = "") As %String
{
	s Num=0
	
	if (GetNewDataFlag="Y"){
		;k ^lxz("ExportInPat")
		if (Meth=1){
			;按照在院患者信息导入数据
			zn ..#DataNameSpace	
			s amddr=0
			f  s amddr=$O(^PAADMi("AdmTypeCurr","I",amddr)) Q:amddr=""  d
			.Q:amddr=""
			.s statu=$P($G(^PAADM(amddr)),"^",20)
			.Q:statu'="A"
			.;基本信息
			.s SocialStatusDesc=""
			.s papmidr=$P(^PAADM(amddr),"^",1)
			.s papmino=$P(^PAPER(papmidr,"PAT",1),"^",1)
			.s Name=$P(^PAPER(papmidr,"ALL"),"^",1)
			.s SocialStatus=$P($G(^PAPER(papmidr,"PER",1)),"^",10)
			.s:SocialStatus'="" SocialStatusDesc=$P($G(^CT("SS",SocialStatus)),"^",2)
			.;获取住院信息
			.s dischargeDate=$P($G(^PAADM(amddr)),"^",17)
			.s AdmLoc=$P(^PAADM(amddr),"^",4) ;住院科室
			.s AdmDate=$P(^PAADM(amddr),"^",6) ;就诊日期
			.s AdmTime=$P(^PAADM(amddr),"^",7) ;就诊时间
			.s CreatUser=$P(^PAADM(amddr),"^",43) ;创建人
			.s AdmWard=$P(^PAADM(amddr),"^",70) ;病区
			.s AdmReason=$P(^PAADM(amddr,1),"^",7) ;费别
			.;;母亲就诊
			.s PAADMMotherAdmDR=$P(^PAADM(amddr),"^",75) 
			.s Motherpapmino="",Motherpapmidr=""
			.s:PAADMMotherAdmDR'="" Motherpapmidr=$P($G(^PAADM(PAADMMotherAdmDR)),"^",1)
			.s:Motherpapmidr'="" Motherpapmino=$P(^PAPER(Motherpapmidr,"PAT",1),"^",1)
			.
			.
			.s (AdmLocCode,AdmLocDesc,AdmWardDesc,AdmWardCode,AdmReaDesc,CreatUserName,GH)=""
			.s:AdmLoc'="" AdmLocCode=$P($G(^CTLOC(AdmLoc)),"^",1),AdmLocDesc=$P($G(^CTLOC(AdmLoc)),"^",2)
			.s:AdmWard'="" AdmWardCode=$P($G(^PAWARD(AdmWard)),"^",1),AdmWardDesc=$P($G(^PAWARD(AdmWard)),"^",2)
			.s:AdmReason'="" AdmReaDesc=$P($G(^PAC("ADMREA",AdmReason)),"^",2)
			.s:CreatUser'="" CreatUserName=$p($g(^SSU("SSUSR",CreatUser)),"^",2)
			.s:CreatUser'="" GH=$p($g(^SSU("SSUSR",CreatUser)),"^",1)
			.d setDataGloble
			.s Num=Num+1
			.i (Num#1000)=0 w Num,!
			zn "dhc-app"
		}else{
			;按照出院患者数据进行导入
			s Num=0
			s BeginTime=$ZTH("15:00")
			zn ..#DataNameSpace	
			s amddr=0
			f  s amddr=$O(^PAADMi("DischDate",+$H,amddr)) Q:amddr=""  d
			.s DisChargeTime=$P(^PAADM(amddr),"^",18) 
			.Q:DisChargeTime<BeginTime
			.;基本信息
			.s SocialStatusDesc=""
			.s papmidr=$P(^PAADM(amddr),"^",1)
			.s papmino=$P(^PAPER(papmidr,"PAT",1),"^",1)
			.s Name=$P(^PAPER(papmidr,"ALL"),"^",1)
			.s SocialStatus=$P($G(^PAPER(papmidr,"PER",1)),"^",10)
			.s:SocialStatus'="" SocialStatusDesc=$P($G(^CT("SS",SocialStatus)),"^",2)
			.;获取住院信息
			.s dischargeDate=$P($G(^PAADM(amddr)),"^",17)
			.s AdmLoc=$P(^PAADM(amddr),"^",4) ;住院科室
			.s AdmDate=$P(^PAADM(amddr),"^",6) ;就诊日期
			.s AdmTime=$P(^PAADM(amddr),"^",7) ;就诊时间
			.s CreatUser=$P(^PAADM(amddr),"^",43) ;创建人
			.s AdmWard=$P(^PAADM(amddr),"^",70) ;病区
			.s AdmReason=$P(^PAADM(amddr,1),"^",7) ;费别
			.;;母亲就诊
			.s PAADMMotherAdmDR=$P(^PAADM(amddr),"^",75) 
			.s Motherpapmino="",Motherpapmidr=""
			.s:PAADMMotherAdmDR'="" Motherpapmidr=$P($G(^PAADM(PAADMMotherAdmDR)),"^",1)
			.s:Motherpapmidr'="" Motherpapmino=$P(^PAPER(Motherpapmidr,"PAT",1),"^",1)
			.
			.
			.s (AdmLocCode,AdmLocDesc,AdmWardDesc,AdmWardCode,AdmReaDesc,CreatUserName,GH)=""
			.s:AdmLoc'="" AdmLocCode=$P($G(^CTLOC(AdmLoc)),"^",1),AdmLocDesc=$P($G(^CTLOC(AdmLoc)),"^",2)
			.s:AdmWard'="" AdmWardCode=$P($G(^PAWARD(AdmWard)),"^",1),AdmWardDesc=$P($G(^PAWARD(AdmWard)),"^",2)
			.s:AdmReason'="" AdmReaDesc=$P($G(^PAC("ADMREA",AdmReason)),"^",2)
			.s:CreatUser'="" CreatUserName=$p($g(^SSU("SSUSR",CreatUser)),"^",2)
			.s:CreatUser'="" GH=$p($g(^SSU("SSUSR",CreatUser)),"^",1)
			.d setDataGloble
			.s Num=Num+1
			.i (Num#1000)=0 w Num,!
			
			zn "dhc-app"
		}
		
	
	}
	
	;进行数据导入校验
	k ^lxz("ExportInPat",0,"ErrDate")
	s sub1=0
	f  s sub1=$O(^lxz("ExportInPat",sub1)) Q:sub1=""  d
	.s Str=$G(^lxz("ExportInPat",sub1))
	.if Str'=""  d
	..d inertOneAdm(Str)
	.
	.;插入孩子的就诊
	.s sub2=0
	.f  s sub2=$O(^lxz("ExportInPat",sub1,sub2)) Q:sub2=""  d
	..s Str=$G(^lxz("ExportInPat",sub1,sub2))
	..if Str'=""  d
	...d inertOneAdm(Str)
	..
	q Num
inertOneAdm(Str)
	s Name=$P(Str,"^",1)
	s papmino=$P(Str,"^",2)
	s AdmDate=$P(Str,"^",3)
	s AdmTime=$P(Str,"^",4)
	s GH=$P(Str,"^",5)
	s CreatUserName=$P(Str,"^",6)
	s AdmLocCode=$P(Str,"^",7)
	s AdmLocDesc=$P(Str,"^",8)
	s AdmWardCode=$P(Str,"^",9)
	s AdmWardDesc=$P(Str,"^",10)
	s AdmReason=$P(Str,"^",11)
	s AdmReaDesc=$P(Str,"^",12)
	s SocialStatus=$P(Str,"^",13)
	s SocialStatusDesc=$P(Str,"^",14)
	s oldpapmidr=$P(Str,"^",15)
	s Motherpapmino=$P(Str,"^",16)
	
	
	
	;查找患者信息是否在数据库中存在不存在直接创建新的患者信息--新生儿
	s CnaDoDesc=""
	s papmino=$E("000000000000",1,10-$L(papmino))_papmino
	s:Motherpapmino'="" Motherpapmino=$E("000000000000",1,10-$L(Motherpapmino))_Motherpapmino
	
	
	Q:$D(^lxz("ExportInPat",0,"OK",papmino))
	
	s papmi=$O(^PAPERi("PAPMI_PatNo",papmino,""),-1)
	if papmi=""  d
	.;未找到患者信息的直接新建患者信息---
	.s:CheckData'="Y" rtn=##Class(DHCDoc.DHCDocCure.ImportPatInfo).InsertOnePatInfo(oldpapmidr)
	.s papmino=$E("000000000000",1,10-$L(papmino))_papmino
	.s papmi=$O(^PAPERi("PAPMI_PatNo",papmino,""),-1)
	.if papmi=""  d
	..s CnaDoDesc=CnaDoDesc_","_papmino_"不存在有效的患者信息"_AdmDate_"^"_oldpapmidr
	
	
	;新生儿需要找到母亲的就诊
	s MotherAdmDr=""
	if Motherpapmino'=""  d
	.s MotherAdmDr=$O(^lxz("ExportInPat",0,"OK",Motherpapmino,""),-1)
	.i MotherAdmDr=""  d
	..s CnaDoDesc=CnaDoDesc_","_papmino_"为找到有效的母亲的就诊"_Name_",母亲"_Motherpapmino
	
	;验证患者心在是否已经存在有效的住院记录
	if papmi'=""  d
	.s admid=0
	.f  s admid=$O(^PAPERdr(papmi,"ADM","I",admid)) Q:admid=""  d
	..s statu=$P($G(^PAADM(admid)),"^",20)
	..if statu="A" s CnaDoDesc=CnaDoDesc_","_papmino_"已经存在有效的住院就诊:"_admid
	
	;验证患者的住院科室是否进行了对照
	s AdmLocID=""
	s:AdmLocCode'="" AdmLocID=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(AdmLocCode),0))
	s:((AdmLocCode'="")&(AdmLocID="")) AdmLocID=$G(^DHCDocBJYGJ("OLDDATALOC",AdmLocCode))
	i AdmLocID=""  d
	.s CnaDoDesc=CnaDoDesc_","_papmino_"未找到有效的对应住院科室ID:"_AdmLocCode
	.if AdmLocCode=""  d
	..s ^lxz("ExportInPat",0,"ErrDate",0,"LOCNULL",papmino)=Name
	.else  d
	..s ^lxz("ExportInPat",0,"ErrDate",0,"LOC",AdmLocCode)=AdmLocDesc
	
	;验证患者的住院病区是否进行了对照
	s AdmWardID=""
	s:AdmWardCode'="" AdmWardID=$O(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(AdmWardCode),AdmWardID)) 
	s:((AdmWardCode'="")&(AdmWardID="")) AdmWardID=$G(^DHCDocBJYGJ("OLDDATAWARD",AdmWardCode))
	i AdmWardID=""  d
	.s CnaDoDesc=CnaDoDesc_","_papmino_"未找到有效的病区ID:"_AdmWardCode
	.if AdmWardCode=""  d
	..s ^lxz("ExportInPat",0,"ErrDate",0,"WARNULL",papmino)=Name
	.else  d
	..s ^lxz("ExportInPat",0,"ErrDate",0,"WAR",AdmWardCode)=AdmWardDesc_"^"_AdmLocDesc
	
	
	;患者类型对应就诊费被
	;I AdmReason="" S CnaDoDesc=CnaDoDesc_","_papmino_"未找就诊费别:"_AdmReason
	;i SocialStatusDesc="" s CnaDoDesc=CnaDoDesc_","_papmino_"未找到社会地位:"_SocialStatus
	s AdmReason=""
	s:SocialStatus'="" AdmReason=$G(^DHCDocBJYGJ("OLDDATAADMREASON",SocialStatus))
	I (AdmReason="")&(SocialStatus'="") S CnaDoDesc=CnaDoDesc_","_papmino_"未找就诊费别:"_SocialStatus
	s:AdmReason="" AdmReason=1
	
	;就诊信息
	i CnaDoDesc'=""  d 
	.s ^lxz("ExportInPat",0,"ErrDate",papmino)=CnaDoDesc
	else  d
	.k ^lxz("ExportInPat",0,"ErrDate",papmino)
	.;进行就诊插入
	.;AdmCate 2 非绿色通道 1 绿色通道 Epissubtype 特殊和普通 AdmSrcDr 来源途径 AdmDiagnosCatRowId特病 ReferralPriorityId 病情
	.s AdmDoc="",CreateUser=1,AdmRoom="",AdmBed="",Epissubtype="",AdmCate=2,AdmRefDocListDR="",AdmDiagnosCatRowId="",AdmInPatNo=""
	.s AdmSrcDr="",FirstOrReadmis="",InsuCoRowid="",RegConDisId="",ReferralPriorityId=""
	.;----组织插入就诊信息串
	.s NowDate=$ZDH(AdmDate,3) ,NowTime=$ZTH(AdmTime)
	.s Para=papmi_"^"_"I"_"^"_$ZDH(AdmDate,3)_"^"_$ZTH(AdmTime)_"^"_AdmLocID_"^"_AdmDoc_"^"_AdmReason_"^"_CreateUser_"^"_AdmWardID_"^"_AdmRoom
	.s Para=Para_"^"_AdmBed_"^"_Epissubtype_"^"_AdmCate_"^"_AdmRefDocListDR_"^"_AdmDiagnosCatRowId_"^"_AdmInPatNo_"^"_AdmSrcDr
	.s Para=Para_"^"_FirstOrReadmis_"^"_InsuCoRowid_"^"_RegConDisId_"^"_ReferralPriorityId
	.Q:CheckData="Y"
	.s Re="" ;##class(web.DHCPAADM).ADMInsert(Para)
	.if Re="" d
	..s ^lxz("ExportInPat",0,"ErrDate",papmino)="插入就诊记录失败:"_Para
	.else  d
	..s ^lxz("ExportInPat",0,"OK",papmino,Re)=""
	..;平台发送就诊数据
	..s rtnEns=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMINFO",Re)
	..//插入转科表
	..s WaitRoom=##class(Nur.CommonInterface.Ward).getWaitRoomID(AdmWardID)
	..s rtntrans=##class(Nur.CommonInterface.Bed).transToWaitRoom(Re,AdmWardID,1,WaitRoom) 
	..;插入入院信息表
	..&sql(update SQLUSER.PA_AdmExt set PAADM_AdminDate=:NowDate,PAADM_AdminTime=:NowTime,PAADM_AdminLoc=:AdmLocID,PAADM_AdminWard=:AdmWardID where PAADM_RowId=:Re)
	..if MotherAdmDr'=""  d
	...;婴儿插入数据
	...&SQL(Update SQLUSER.PA_Adm set PAADM_MotherAdm_DR=:MotherAdmDr where PAADM_RowID=:Re)
	
	q 
setDataGloble
	zn "dhc-app"
	s setstr=Name_"^"_papmino_"^"_$ZD(AdmDate,3)_"^"_$ZT(AdmTime,1)_"^"_GH_"^"_CreatUserName_"^"_AdmLocCode_"^"_AdmLocDesc_"^"_AdmWardCode_"^"_AdmWardDesc_"^"_AdmReason_"^"_AdmReaDesc_"^"_SocialStatus_"^"_SocialStatusDesc_"^"_papmidr_"^"_Motherpapmino
	if Motherpapmino=""  d
	.s ^lxz("ExportInPat",papmino)=setstr
	else  d
	.;新生儿就诊信息记录在母亲的节点上
	.s ^lxz("ExportInPat",Motherpapmino,papmino)=setstr
	zn ..#DataNameSpace
	q
}
}