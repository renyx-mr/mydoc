Class DHCDoc.GetInfo.Entry.DHCQueue Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 对列表ID
Property ID As %String(TRUNCATE = 1);

/// 最后操作人指针(指向SS_User)
Property Operuserid As %String(TRUNCATE = 1);

/// 最后操作人Code
Property OperuserCode As %String(TRUNCATE = 1);

/// 最后操作人描述
Property OperuserDesc As %String(TRUNCATE = 1);

/// 是否呼叫过标志
Property QueCalled As %String(TRUNCATE = 1);

/// 呼叫电脑
Property QueCompDr As %String(TRUNCATE = 1);

/// 记录插入日期
Property QueDate As %String(TRUNCATE = 1);

/// 就诊科室指针(指向CT_Loc)
Property QueDepDr As %String(TRUNCATE = 1);

/// 就诊科室Code
Property QueDepCode As %String(TRUNCATE = 1);

/// 就诊科室描述
Property QueDepDesc As %String(TRUNCATE = 1);

/// 就诊医生指针(指向CT_CareProv)
Property QueDocDr As %String(TRUNCATE = 1);

/// 就诊医生Code
Property QueDocCode As %String(TRUNCATE = 1);

/// 就诊医生描述
Property QueDocDesc As %String(TRUNCATE = 1);

/// 就诊诊区指针(指向DHCExaBorough)
Property QueExabDr As %String(TRUNCATE = 1);

/// 就诊诊区Code
Property QueExabCode As %String(TRUNCATE = 1);

/// 就诊诊区名称
Property QueExabDesc As %String(TRUNCATE = 1);

/// 就诊优先级指针(指向DHCFirstCode)
Property QueFirstDr As %String(TRUNCATE = 1);

/// 就诊优先级Code
Property QueFirstCode As %String(TRUNCATE = 1);

/// 就诊优先级描述
Property QueFirstDesc As %String(TRUNCATE = 1);

/// 就诊号别指针(指向CT_CareProv)
Property QueMarkDr As %String(TRUNCATE = 1);

/// 就诊号别Code
Property QueMarkCode As %String(TRUNCATE = 1);

/// 就诊号别描述
Property QueMarkDesc As %String(TRUNCATE = 1);

/// 记录插入时患者姓名
Property QueName As %String(TRUNCATE = 1);

/// 就诊序号
Property QueNo As %String(TRUNCATE = 1);

/// 就诊记录指针(指向PA_Adm)
Property QuePaadmDr As %String(TRUNCATE = 1);

/// 病人ID
Property QuePersonId As %String(TRUNCATE = 1);

/// 就诊诊室指针(指向CT_Loc)
Property QueRoomDr As %String(TRUNCATE = 1);

/// 就诊诊室Code
Property QueRoomCode As %String(TRUNCATE = 1);

/// 就诊诊室描述
Property QueRoomDesc As %String(TRUNCATE = 1);

/// 就诊状态指针(指向DHCPerState)
Property QueStateDr As %String(TRUNCATE = 1);

/// 就诊状态Code
Property QueStateCode As %String(TRUNCATE = 1);

/// 就诊状态Desc
Property QueStateDesc As %String(TRUNCATE = 1);

/// 最后状态改变时间
Property QueStateTime As %String(TRUNCATE = 1);

/// 门诊会诊标识
Property QueConsultFlag As %String(TRUNCATE = 1);

/// 最后状态改变日期
Property QueStateDate As %String(TRUNCATE = 1);

/// 创建时间
Property QueTime As %String(TRUNCATE = 1);

/// 二次分诊科室 (取自CT_Loc)
Property ChangeDepDr As %String(TRUNCATE = 1);

/// 二次分诊科室 Code
Property ChangeDepCode As %String(TRUNCATE = 1);

/// 二次分诊科室描述
Property ChangeDepDesc As %String(TRUNCATE = 1);

Property Comm1 As %String(TRUNCATE = 1);

Property Comm2 As %String(TRUNCATE = 1);

/// 状态变化记录
Property StatusChangeList As list Of DHCDoc.GetInfo.Entry.DHCQueueStatus;

}
