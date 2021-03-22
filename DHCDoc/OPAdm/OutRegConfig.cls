Class DHCDoc.OPAdm.OutRegConfig Extends %RegisteredObject
{

/// Creator:    nikang
/// Desc:       为对外预约挂号接口所做配置
/// CreateTime：2017-08-08
ClassMethod PutConfigNode(Nodeinfo As %String, Node1 As %String) As %String
{
	s Node=$p(Nodeinfo,$C(1),1)
	s Info=$p(Nodeinfo,$C(1),2)
	if (Node="LockNotAllowAdd")!(Node="BarCardType")!(Node="LockActiveTime")!(Node="SelfAdmReason"){
		s ^DHCOPRegConfig("ExternalService",Node)=+Info
	}else{
		s ^DHCOPRegConfig("ExternalService",Node1,Node)=Info
	}
}

ClassMethod SaveConfig(Coninfo As %String, Node1 As %String) As %String
{
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d ..PutConfigNode(evNoteinfo,Node1)
	q 0
}

ClassMethod GetConfigNode(NodeValue As %String, NodeName As %String) As %String
{
	Q:NodeName="" ""
	if (NodeName="LockNotAllowAdd")!(NodeName="BarCardType")!(NodeName="LockActiveTime")!(NodeName="SelfAdmReason"){
		Q:'$d(^DHCOPRegConfig("ExternalService",NodeName)) ""
		Q $g(^DHCOPRegConfig("ExternalService",NodeName))
	}else{
		Q:NodeValue="" ""
		Q:'$d(^DHCOPRegConfig("ExternalService",NodeValue,NodeName)) ""
		Q $g(^DHCOPRegConfig("ExternalService",NodeValue,NodeName))
	}
}

ClassMethod getDefaultData(value As %String, value2 As %String) As %String
{
	s rtn=""
	if (value2="LockNotAllowAdd")!(value2="LockActiveTime"){
		s rtn=$g(^DHCOPRegConfig("ExternalService",value2))
	}else{
		s rtn=$g(^DHCOPRegConfig("ExternalService",value,value2))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

Query FindList(value As %String, GroupRowId As %String) As %Query(ROWSPEC = "RowId:%String,Code:%String,selected:%Boolean")
{
}

ClassMethod FindListExecute(ByRef qHandle As %Binary, value As %String, GroupRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.OutRegConfig","FindList","CardType","")
	Set repid=$I(^CacheTemp)
    Set ind=1
	if value="AppRegMethod"{
	    s APTMRowId=0
	 	f  s APTMRowId=$o(^RBC("APTM",APTMRowId)) q:APTMRowId=""  d
	 	.s str=$g(^RBC("APTM",APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
		.s selected=0
		.i value'="" d
		..i APTMRowId=$g(^DHCOPRegConfig("ExternalService",GroupRowId,value)) s selected=1
		.Do OutputRowFindList
	}elseif value="SelfAdmReason"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("ADMREA",APTMRowId)) q:APTMRowId=""  d
	    .s APTMCode=$p(^PAC("ADMREA",APTMRowId),"^",2)
	    .s BillTypeDuration=""
	    .s BillTypeDurationDr=$g(^DHCDocConfig("BillTypeDuration",APTMRowId))
	    .s:BillTypeDurationDr'="" BillTypeDuration=$p(^PHCDU(BillTypeDurationDr),"^",1)
	    .s DiagnosCatArcimAllow=$g(^DHCDocConfig("DiagnosCatArcimAllow",APTMRowId))
	    .s DiagnosCatArcimAllow=$s(DiagnosCatArcimAllow=1:"Y",DiagnosCatArcimAllow=0:"N",1:"N")
	    .s NotAllowItemInDuration=$g(^DHCDocConfig("NotAllowItemInDuration",APTMRowId))
	    .s NotAllowItemInDuration=$s(NotAllowItemInDuration=1:"Y",NotAllowItemInDuration=0:"N",1:"N")
	    .s selected=0
	    .i value'="" d
	    ..i ("^"_$g(^DHCOPRegConfig("ExternalService",value))_"^")[("^"_APTMRowId_"^")  s selected=1
		.Do OutputRowFindList	
	}elseif value="GetPatientIDRule"{
		s TempStr="1"_$c(1)_"GETNEWINSU"_$c(1)_"获取最新含医保号主索引"_"^"_"2"_$c(1)_"GETNEW"_$c(1)_"获取最新主索引"_"^"_"3"_$c(1)_"GETALL"_$c(1)_"获取全部主索引"
		s TempLen=$l(TempStr,"^")
		for TempCount=1:1:TempLen d
		.s aTempStr=$p(TempStr,"^",TempCount)
		.s APTMRowId=$p(aTempStr,$c(1),"2")
		.s APTMCode=$p(aTempStr,$c(1),"3")
		.s selected=0
		.i value'="" d
	    ..i ("^"_$g(^DHCOPRegConfig("ExternalService",GroupRowId,value))_"^")[("^"_APTMRowId_"^")  s selected=1
		.Do OutputRowFindList	
	}
	elseif value="BarCardType"{
		s APTMRowId=0
	 	f  s APTMRowId=$o(^DHCCARDTYPEDef(APTMRowId)) q:APTMRowId=""  d
	 	.s str=$g(^DHCCARDTYPEDef(APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
		.s selected=0
		.i value'="" d
		..i APTMRowId=$g(^DHCOPRegConfig("ExternalService",value)) s selected=1
		.Do OutputRowFindList	
	}elseif value="AdmReason"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("ADMREA",APTMRowId)) q:APTMRowId=""  d
	    .s APTMCode=$p(^PAC("ADMREA",APTMRowId),"^",2)
	    .s BillTypeDuration=""
	    .s BillTypeDurationDr=$g(^DHCDocConfig("BillTypeDuration",APTMRowId))
	    .s:BillTypeDurationDr'="" BillTypeDuration=$p(^PHCDU(BillTypeDurationDr),"^",1)
	    .s DiagnosCatArcimAllow=$g(^DHCDocConfig("DiagnosCatArcimAllow",APTMRowId))
	    .s DiagnosCatArcimAllow=$s(DiagnosCatArcimAllow=1:"Y",DiagnosCatArcimAllow=0:"N",1:"N")
	    .s NotAllowItemInDuration=$g(^DHCDocConfig("NotAllowItemInDuration",APTMRowId))
	    .s NotAllowItemInDuration=$s(NotAllowItemInDuration=1:"Y",NotAllowItemInDuration=0:"N",1:"N")
	    .s selected=0
	    .i value'="" d
	    ..i APTMRowId=$g(^DHCRegInterfaceCodeRelate("Default",value)) s selected=1
		.Do OutputRowFindList	
	}elseif value="CardType"{
		s APTMRowId=0
	 	f  s APTMRowId=$o(^DHCCARDTYPEDef(APTMRowId)) q:APTMRowId=""  d
	 	.s str=$g(^DHCCARDTYPEDef(APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
	 	.s APTMCode1=$p(str,"^",1)
		.s selected=0
		.i value'="" d
		..i APTMCode1=$g(^DHCRegInterfaceCodeRelate("Default",value)) s selected=1
		.Do OutputRowFindList1	
	}elseif value="IDCardType"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("CARD",APTMRowId)) q:APTMRowId=""  d
	    .s APTMCode=$p(^PAC("CARD",APTMRowId),"^",2)
	    .s APTMCode1=$p(^PAC("CARD",APTMRowId),"^",1)
	    .s selected=0
	    .i value'="" d
	    ..i APTMCode1=$g(^DHCRegInterfaceCodeRelate("Default",value)) s selected=1
		.Do OutputRowFindList1	
	}elseif value="ExtUserID"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^SSU("SSUSR",APTMRowId)) q:APTMRowId=""  d
	    .s APTMCode=$p(^SSU("SSUSR",APTMRowId),"^",2)
	    .s APTMCode1=$p(^SSU("SSUSR",APTMRowId),"^",1)
	    .s selected=0
	    .i value'="" d
	    ..i APTMCode1=$g(^DHCRegInterfaceCodeRelate("Default",value)) s selected=1
		.Do OutputRowFindList1	
	}elseif value="SSGroup"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^SSU("SSGRP",APTMRowId)) q:APTMRowId=""  d
	    .s APTMCode=$p(^SSU("SSGRP",APTMRowId),"^",1)
	    .s selected=0
		.Do OutputRowFindList	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindList
	set Data=$lb($g(APTMRowId),$g(APTMCode),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
OutputRowFindList1
	set Data=$lb($g(APTMCode1),$g(APTMCode),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
