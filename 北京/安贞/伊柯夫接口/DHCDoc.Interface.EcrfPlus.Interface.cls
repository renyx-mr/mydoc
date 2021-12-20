Class DHCDoc.Interface.EcrfPlus.Interface Extends %RegisteredObject
{

ClassMethod PushItemInformation()
{
    ; Result int(1) 结果代码。0，失败；1，成功
    ; Message Varchar(max) 返回信息
    ; ProjectList 项目列表
    ; Project 项目
    ; ProjectID int(16) 项目 ID
    ; ProjectName Varchar(500) 项目名称
    ; ProjectNumber Varchar(50) 项目编号
    ; ProjectTypeName Varchar(50) 试验期别
    ; DeptName Varchar(200) 研究科室名称
    ; PINumber Varchar(50) 主要研究者工号
    ; PIName Varchar(50) 主要研究者姓名
    ; InvestigatorList 研究医生列表
    ; Investigator 研究医生信息
    ; Number Varchar(50) 研究医生工号
    ; Name Varchar(50) 研究医生姓名
}

}