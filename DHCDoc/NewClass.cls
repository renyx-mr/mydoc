Class DHCDoc.NewClass Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDoc_NewClass, StorageStrategy = SQLStorage ]
{

Property PatName As %String [ SqlColumnNumber = 2, SqlFieldName = Pat_Name ];

Property PatSex As %String [ SqlColumnNumber = 3, SqlFieldName = Pat_Sex ];

Storage SQLStorage
{
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^DOCNewClass(0))</SqlIdExpression>
<SQLMap name="DAtaMap">
<Data name="Pat_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Pat_Sex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DOCNewClass</Global>
<RowIdSpec name="1">
<Expression>L1</Expression>
<Field>{Pat_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Pat_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Pat_RowId</SqlRowIdName>
<StreamLocation>^DHCDoc.NewClasss</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
