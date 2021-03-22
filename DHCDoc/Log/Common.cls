/// creator:郭荣勇
/// date:2017-03-10
/// desc:常规日志记录,一般性的通用日志;在具体业务类中调用此日志类方法
Class DHCDoc.Log.Common Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = Common ]
{

/// 插入类型:根据主键更新或者插入,两个值:Insert或Update
Property InsType As %String(DISPLAYLIST = ",Insert,Update", TRUNCATE = 1, VALUELIST = ",I,U") [ InitialExpression = "I", Required ];

/// 调用日志类
Property CallClass As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 调用日志类
Property CallMethod As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 日志描述
Property LogDesc As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 主键(可以"."拼接)
Property LogKey As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 日志记录值
Property LogValue As %Library.String(MAXLEN = "", TRUNCATE = 1);

/// 系统日期
Property InsertDate As %Date [ InitialExpression = {+$h} ];

/// 系统时间
Property InsertTime As %Time [ InitialExpression = {$p($h,",",2)} ];

/// 最后更新日期
Property LastUpdateDate As %Date;

/// 系统时间
Property LastUpdateTime As %Time;

Index LogKey On (CallClass As Exact, CallMethod As Exact, LogKey As Exact);

Index InsertDate On (InsertDate As Exact, CallClass As Exact, CallMethod As Exact, LogKey As Exact);

/// creator:郭荣勇
/// date:20170310
/// desc:一般性的通用日志
/// table:DHCDoc_Log.Common
/// input:根据主键更新或者插入(Insert/Update),调用日志类,调用日志类方法,日志描述,主键(可以"."拼接),日志记录值
/// output:
/// eg: d ##class(DHCDoc.Log.Common).General("Update","web.DHCOEDispensing","PortForDurg","批次价失败记录","321||23||1","-1^执行记录不能为空")
/// eg: d ##class(DHCDoc.Log.Common).General("Insert","web.DHCOEDispensing","PortForDurg01","批次价失败记录第二个位置","321||23||1","-1^执行记录不能为空")
ClassMethod General(InsType As %String, CallClass As %String, CallMethod As %String, LogDesc As %String, LogKey As %String, LogValue As %String) As %String
{
	n (InsType,CallClass,CallMethod,LogDesc,LogKey,LogValue)
	s SQLCODE=0
	if InsType="Insert" {
		set InsType="I"
        &sql(insert DHCDoc_Log.Common set 
        InsType=:InsType,
        CallClass=:CallClass,
        CallMethod=:CallMethod,
        LogDesc=:LogDesc,
        LogKey=:LogKey,
        LogValue=:LogValue)
	}elseif InsType="Update" {
		s ExistRowId=$O(^DHCDoc.Log.CommonI("LogKey",CallClass,CallMethod,LogKey,""),-1)
		i ExistRowId>0 {
		    set InsType="U"
            &sql(update DHCDoc_Log.Common set 
            InsType=:InsType,
            CallClass=:CallClass,
            CallMethod=:CallMethod,
            LogDesc=:LogDesc,
            LogKey=:LogKey,
            LogValue=:LogValue where ID=:ExistRowId)
		}else{
			s SQLCODE=..General("Insert",CallClass,CallMethod,LogDesc,LogKey,LogValue)
		}
	}else{
	}
	; 日志记录失败记录
	if SQLCODE d code(SQLCODE)
	
	quit SQLCODE
code(SQLCODE) n cnt
	S cnt=$i(^DHCDoc.Log.CommonERR(0))
	S ^DHCDoc.Log.CommonERR(cnt)=SQLCODE_" "_$g(%mdiag(1))_" "_$g(%msg)_" "_$h
	S ^DHCDoc.Log.CommonERR("DATET",+$H,$P($H,",",2),cnt)=""
	Q
}

Storage Default
{
<Data name="CommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Caption1</Value>
</Value>
<Value name="3">
<Value>InsType</Value>
</Value>
<Value name="4">
<Value>CallClass</Value>
</Value>
<Value name="5">
<Value>CallMethod</Value>
</Value>
<Value name="6">
<Value>LogDesc</Value>
</Value>
<Value name="7">
<Value>LogKey</Value>
</Value>
<Value name="8">
<Value>LogValue</Value>
</Value>
<Value name="9">
<Value>InsertDate</Value>
</Value>
<Value name="10">
<Value>InsertTime</Value>
</Value>
<Value name="11">
<Value>LastUpdateDate</Value>
</Value>
<Value name="12">
<Value>LastUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Log.CommonD</DataLocation>
<DefaultData>CommonDefaultData</DefaultData>
<IdLocation>^DHCDoc.Log.CommonD</IdLocation>
<IndexLocation>^DHCDoc.Log.CommonI</IndexLocation>
<StreamLocation>^DHCDoc.Log.CommonS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
