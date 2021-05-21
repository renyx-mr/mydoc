Class DHCDoc.Interface.Jingyitong.Common Extends %RegisteredObject
{
/// 京医通报到接口
ClassMethod PatCheckIn(InputXml As %String) 
{
    s InputXml="<request><time_stamp>20161007073410</time_stamp><input><reg_no>100099735806</reg_no><his_reg_no>278829</his_reg_no><hos_code>H10000000</hos_code><dept_code1>h_GK_07f80ebb_vir</dept_code1><dept_code2>556</dept_code2><card_no>115486999002</card_no><card_type>3</card_type><patient_name>大宝</patient_name><id_card>110108196705226341</id_card><id_card_type>1</id_card_type><reg_date>20211007</reg_date><reg_half>1</reg_half><reg_hour>9:00-9:30</reg_hour></input></request>"
    s InputObj=##c
}
}