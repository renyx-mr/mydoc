Class web.DHCBL.CARDIF.ICardRefInfo Extends %RegisteredObject [ClassType = "", Inheritance = right ,Not ProcedureBlock ]
{
/// 插入就诊和医嘱
ClassMethod InsertAdmAndArcItem(PatNo As %String,ArcItem As %String)
{
    //(PatientNo,DiagnoCode="",ArcimCode="",resCode="",docUserID="",regUserID="")
    s ret=$$Covid2019Test^DHCDocOrdCovidBatch(PatNo,"",ArcItem)
    q ret
	s retCode=$p(ret,"^",1)
	s retDesc=$p(ret,"^",2)
}
/// 获取患者的登记号
ClassMethod GetPatNoByCredNo(IDNo As %String , PatientName As %String) As %Status
{
    if IDNo=""{
		q "-1^证件号码不能为空"
	}
	if PatientName=""{
		q "-1^姓名不能为空"
	}
    if ($length(IDNo)=18){
        set myIDCardNo18=IDNo
        set myIDCardNo15=..ID18to15(IDNo)
    }else{
        set myIDCardNo15=InfoObj.IDNo
        set myIDCardNo18=..ID15to18(IDNo)
    }
    
    set myHadFlag=..GetAllPatIDByIDCardAndName(myIDCardNo18,PatientName)
    if (myHadFlag="") set myHadFlag=..GetAllPatIDByIDCardAndName(myIDCardNo15,PatientName)
    if (myHadFlag="") q "-1^没有在his里面找到该患者"
    if $l(myHadFlag,"^")>1 q "-1^该身份号对应多条信息"
    q myHadFlag
}

/// 根据证件号和姓名得到所有病人id
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatIDByIDCardAndName("370285199106144416","nk")
ClassMethod GetAllPatIDByIDCardAndName(IDCardNo As %String = "", Name As %String = "") As %String
{
	set PatientIDStr=""
	quit:IDCardNo="" PatientIDStr
	set PatientID=""
	
	Set IDCardNo=$ZCVT(IDCardNo,"U")
	Set RecordCount=0
	Set PatientId=0
	for  Set PatientId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PatientId)) Quit:PatientId=""  do
	.s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )  ;身份证 证件类型
	.if PAPMIDVAnumber=""  d
	..s myCredTypeDesc=""
	..s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
	..s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	..if myCredTypeDesc["身份证"  d
	..s PAPMIDVAnumber=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
	.Q:PAPMIDVAnumber'=IDCardNo
    .s PatientNo=$p($g(^PAPER(_PatientId_,"PAT",1)),"^",1)
	.if PatientIDStr=""  s PatientIDStr=PatientNo
	.else  s PatientIDStr=PatientIDStr_"^"PatientNo
 		
	//证件信息位数不足,可以用以下作为补充查询
	Set PatientId=0
	f  s PatientId=$O(^PAPERi("DVA",IDCardNo,PatientId)) q:PatientId=""  do
    .s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
    .Q:ActiveFlag="N"
    .set CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
    .Q:(PatientName'="")&&(CurName'=PatientName)
    .Q:("^"_PatientIDStr_"^")[("^"_PatientId_"^")
    .s PatientNo=$p($g(^PAPER(_PatientId_,"PAT",1)),"^",1)
    .if PatientIDStr=""  s PatientIDStr=PatientNo
	.else  s PatientIDStr=PatientIDStr_"^"PatientNo
 		
	quit PatientIDStr
}
ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// 身份证号18位转15位
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}
}