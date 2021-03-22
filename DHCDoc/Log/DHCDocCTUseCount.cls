/// creator:郭荣勇
/// date:2016-06-08
/// desc:对基础代码表数据使用次数记录表 DHC_DocCTUseCount的操作业务类
Class DHCDoc.Log.DHCDocCTUseCount Extends %RegisteredObject
{

/// Creator:      李宇峰
/// CreatDate:    2016.07.20
/// Description:  保存代码表数据使用次数记录数据,包括插入和更新
/// Table:        DHC_DocCTUseCount
/// Input:        TableName:表名   UserId:用户id   TableValueId:表记录id
/// Return:       0:数据保存成功    非0:数据保存失败
/// Others: 
/// 保存数据,包括插入和更新
ClassMethod Save(TableName As %String, TableValueId As %String, UserId As %String, AuthType As %String, AuthID As %String, UseIP As %String) As %String
{
	///w ##class(DHCDoc.Log.DHCDocCTUseCount).Save("User.ARCItmMast","8865||1",1,"U",1)
	Set UCRowid=$o(^DHCDOCCTUCi("UserCT",UserId,TableName,TableValueId,0))
	Set date=+$h
	Set time=$p($h,",",2)
	TS
	if UCRowid=""{
		Set UCObj=##class(User.DHCDocCTUseCount).%New()
	}else{
		Set UCObj=##class(User.DHCDocCTUseCount).%OpenId(UCRowid)
	} 
	Set UCObj.UCCodeTableClsName=TableName
	Set UCObj.UCCodeTableID=TableValueId
	Do UCObj.UCUserDRSetObjectId(UserId)
	Set UCObj.UCCreateDate=date
	Set UCObj.UCCreateTime=time
	Set sc=UCObj.%Save()
	If $$$ISERR(sc) {
		d UCObj.%Close()
		tro
		Quit -1
	}else{
		//Quit 0
	}
	d UCObj.%Close()
	Set UCRowid=UCObj.%Id()
	Set Sub=$o(^DHCDOCCTUCi("Auth",AuthType,AuthID,UCRowid,0))
	if Sub=""{
		Set UCSubObj=##class(User.DHCDocCTUseCountDetail).%New(UCRowid)	
		Do UCSubObj.DHCDocCTUseCountParRefSetObjectId(UCRowid)
	}else{
		Set UCSubObj=##class(User.DHCDocCTUseCountDetail).%OpenId(UCRowid_"||"_Sub)		
	}
	
	Set UCSubObj.UCDAuthType=AuthType
	Set UCSubObj.UCDAuthID=AuthID
	Set UCSubObj.UCDCount=+UCSubObj.UCDCount+1
	Set UCSubObj.UCDLastUseDate=date
	Set UCSubObj.UCDLastUseTime=time
	if $d(%session){
		Set UCSubObj.UCDLastUseIP=%session.Data("REMOTE_ADDR")
	}
	Set sc=UCSubObj.%Save()
	If $$$ISERR(sc) {
		d UCSubObj.%Close()
		b ;545
		tro
		Quit -1
	}else{
		TC
		d UCSubObj.%Close()
		Quit 0
	}
}

/// 得到使用次数
/// w ##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.ARCItmMast","8865||1",1,"U")
ClassMethod GetCount(CodeTableClsName As %String, CodeTableID As %String, UserID As %String, AuthType As %String, DeptID As %String = "", GroupID As %String = "") As %String
{
	if UserID="" Quit 0
	//if CodeTableClsName="User.ARCItmMast" Set CodeTableID=CodeTableID_"||1"
	//s ^tempGetCount(CodeTableID)=CodeTableClsName_","_CodeTableID_","_UserID_","_AuthType
	s Count=0
	
	Set UCRowid=$o(^DHCDOCCTUCi("UserCT",UserID,CodeTableClsName,CodeTableID,0))
	b ;56
	Quit:UCRowid="" 0
	Set AuthID=$s(AuthType="G":GroupID,AuthType="D":DeptID,AuthType="U":UserID,1:"")
	b ;44
	if AuthID="" Quit 0
	Set Sub=$o(^DHCDOCCTUCi("Auth",AuthType,AuthID,UCRowid,0))
	if Sub="" Quit 0
	Set Count=$p(^DHCDOCCTUC(UCRowid,Sub),"^",1)
	Q Count
}

}
