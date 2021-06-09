Class User.DHCOPApptRegister Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_OPApptRegister, StorageStrategy = SQLStorage ]
{

/// 指针指向 PAPatMas PAPMI
Property OPAPPTPAPMIDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = OPAPPT_PAPMI_DR ];

/// 日期
Property OPAPPTDate As %Date [ SqlColumnNumber = 3, SqlFieldName = OPAPPT_Date ];

/// 星期
Property OPAPPTWeek As %String [ SqlColumnNumber = 4, SqlFieldName = OPAPPT_Week ];

/// 姓名
Property OPAPPTPatName As %String [ SqlColumnNumber = 5, SqlFieldName = OPAPPT_PatName ];

/// 性别
Property OPAPPTPatSex As CTSex [ SqlColumnNumber = 6, SqlFieldName = OPAPPT_PatSex ];

/// 联系方式
Property OPAPPTPatPhone As %String [ SqlColumnNumber = 7, SqlFieldName = OPAPPT_PatPhone ];

/// 就诊目的 
Property OPAPPTPatAdmDesc As %String [ SqlColumnNumber = 8, SqlFieldName = OPAPPT_PatAdmDesc ];

/// 科别 
Property OPAPPTPatAdmLoc As %String [ SqlColumnNumber = 9, SqlFieldName = OPAPPT_PatAdmLoc ];

/// 出诊医生
Property OPAPPTPatAdmDoc As %String [ SqlColumnNumber = 10, SqlFieldName = OPAPPT_PatAdmDoc ];

/// 预约时间
Property OPAPPTApptDate As %Date [ SqlColumnNumber = 11, SqlFieldName = OPAPPT_ApptDate ];

/// 流调
Property OPAPPTCurrentReg As %String [ SqlColumnNumber = 12, SqlFieldName = OPAPPT_CurrentReg ];

/// 车号
Property OPAPPTPatCarNo As %String [ SqlColumnNumber = 13, SqlFieldName = OPAPPT_PatCarNo ];

/// 状态
Property OPAPPTRegisterStatus As %Date [ SqlColumnNumber = 14, SqlFieldName = OPAPPT_RegisterStatus ];

/// 备注
Property OPAPPTRegisterDesc As %String [ SqlColumnNumber = 15, SqlFieldName = OPAPPT_RegisterDesc ];

/// 工作单位 Work unit
Property OPAPPTWorkUnit As %String [ SqlColumnNumber = 16, SqlFieldName = OPAPPT_WorkUnit ];

/// 登记人
Property OPAPPTRegisterUserDr As SSUser [ SqlColumnNumber = 17, SqlFieldName = OPAPPT_RegisterUser_Dr ];

/// 创建人
Property OPAPPTCreatUserDr As SSUser [ SqlColumnNumber = 18, SqlFieldName = OPAPPT_CreatUser_Dr ];

/// 创建日期
Property OPAPPTCreatDate As %Date [ SqlColumnNumber = 19, SqlFieldName = OPAPPT_CreatDate ];

/// 创建时间
Property OPAPPTCreatTime As %Time [ SqlColumnNumber = 20, SqlFieldName = OPAPPT_CreatTime ];

/// 修改人
Property OPAPPTCUpdateUserDr As SSUser [ SqlColumnNumber = 21, SqlFieldName = OPAPPT_UpdateUser_Dr ];

/// 修改日期
Property OPAPPTUpdateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = OPAPPT_UpdateDate ];

/// 修改时间
Property OPAPPTUpdateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = OPAPPT_UpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCOPApptRegisterD(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="OPAPPT_ApptDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPAPPT_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OPAPPT_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OPAPPT_CreatUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OPAPPT_CurrentReg">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPAPPT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPAPPT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPAPPT_PatAdmDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPAPPT_PatAdmDoc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPAPPT_PatAdmLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPAPPT_PatCarNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPAPPT_PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPAPPT_PatPhone">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPAPPT_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPAPPT_RegisterDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPAPPT_RegisterStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPAPPT_RegisterUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPAPPT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OPAPPT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OPAPPT_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OPAPPT_Week">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPAPPT_WorkUnit">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCOPApptRegisterD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPAPPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OPAPPT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCOPApptRegisterI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPAPPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPAPPT_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPAPPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCOPApptRegisterI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPAPPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMIDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPAPPT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPAPPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegisterUser">
<Global>^DHCOPApptRegisterI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPAPPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RegisterUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPAPPT_RegisterUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPAPPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OPAPPT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCOPApptRegisterS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
