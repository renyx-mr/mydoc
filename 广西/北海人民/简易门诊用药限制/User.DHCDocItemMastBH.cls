Class User.DHCDocItemMastBH Extends %Persistent [ SqlRowIdName = DARCIM_Rowid, SqlTableName = DHC_Doc_ItemMastBH, StorageStrategy = SQLStorage ]
{

/// 医嘱项id指针
Property DARCIMARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DARCIM_ARCIM_DR ];

/// 使用天数
Property DARCIMMaxDay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DARCIM_MaxDay ];

/// 最大量
Property DARCIMMaxQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DARCIM_MaxQty ];

/// 最大量单位
Property DARCIMMaxQtyUom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DARCIM_MaxQtyUom ];

/// 修改人
Property DARCIMUpdateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DARCIM_UpdateUser_Dr ];

/// 修改日期
Property DARCIMUpdateDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = DARCIM_UpdateDate ];

/// 修改时间
Property DARCIMUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DARCIM_UpdateTime ];

/// 创建人
Property DARCIMCreateUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DARCIM_CreateUser_Dr ];

/// 创建日期
Property DARCIMCreateDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = DARCIM_CreateDate ];

/// 创建时间
Property DARCIMCreateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DARCIM_CreateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCItmMastBH(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="DARCIM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DARCIM_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DARCIM_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DARCIM_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DARCIM_MaxDay">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DARCIM_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DARCIM_MaxQtyUom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DARCIM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DARCIM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DARCIM_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCItmMastBH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{DARCIM_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DARCIM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCItmMastBH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{DARCIM_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DARCIM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DARCIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocItemMastBHS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
