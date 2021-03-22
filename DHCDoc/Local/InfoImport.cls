/// CreateDate：2019.2.21
/// CreateUser: gry
/// Desc:医生站业务信息导入类，处理比如上线时的患者信息导入、预约信息导入
Class DHCDoc.Local.InfoImport Extends (%RegisteredObject, %XML.Adaptor)
{

/// 导入患者信息模式：老库为Cache数据库(Y)/老库为非Cache数据库(N)
Parameter OldDababaseIs = "N";

/// OldDababaseIs = "Y"的情况下新库中映射的namespace，注意需要同时挂载MEDDATA和MEDCODE，否则无法获取老库的基础配置global
Parameter DataNameSpace = "DHC-DATA-OLD";

/*
--
todo 详细使用注解,导入数据来源格式说明
--
// 导入患者信息
*/
ClassMethod ImportPatInfo(BeginID As %String = "") As %String
{
	if ..#OldDababaseIs="Y" {
		d ##class(DHCDoc.Local.InfoImportMethod).ImportPatInfoCache()
	}else{
		d ##class(DHCDoc.Local.InfoImportMethod).ImportPatInfoNotCache()
	}
}

/*
--
todo 详细使用注解,导入数据来源格式说明
--

对于提前挂号或提前取号的处理：
场景：项目上线且不同意停止就诊日期为上线后日期的提前挂号或取号业务（优先方案应说服医院停止提前挂号和取号业务）
此方案缺陷：仅导入就诊信息及处理资源表占序号，不处理其他就诊相关业务数据；相关退号处理需在老系统中处理
// 导入预约相关信息
*/
ClassMethod ImportAppInfo(BeginID As %String = "") As %String
{
	Q ##class(DHCDoc.Local.InfoImportMethod).ImportAppInfo()
}

}
