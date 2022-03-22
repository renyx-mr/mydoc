Class DHCDoc.Interface.HealthCard.Interface Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetPatientInfoByBookDr(BookDr As %String,HospID As %String)
{
    s PatientID=$p(^DHCDocIPBK(BookID),"^",1)
    s OutputObj={}
    s PatMasObj=##class(User.PAPatMas).%OpenId(PatientID)
    s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
    s DHCPersonObj=##class(User.DHCPerson).%OpenId(PatientID)
    ; PatMasObj PersonObj DHCPersonObj
	if $ISOBJECT(PatMasObj) {
        ; 姓名
        s OutputObj.PAPMIName=PatMasObj.PAPMIName
        ; 性别
        if $ISOBJECT(PatMasObj.PAPMISexDR) {
            s OutputObj.PAPMISexDesc=PatMasObj.PAPMISexDR.CTSEXDesc
        }
        ; 国籍
        s OutputObj.PAPERCountryDesc=PersonObj.PAPERCountryDR.CTCOUDesc
        ; 民族
        s OutputObj.PAPERNationDesc=PersonObj.PAPERNationDR.CTNATDesc
        ; 出生地 省
        s OutputObj.PAPERProvinceBirthDesc=PersonObj.PAPERProvinceBirthDR.PROVDesc
        ; 籍贯 市
        s OutputObj.PAPERCityBirthDesc=PersonObj.PAPERCityBirthDR.CTCITDesc
        ; 职业
        s OutputObj.PAPEROccupationDesc=PersonObj.PAPEROccupationDR.CTOCCDesc
        ; 婚姻状况
        s OutputObj.PAPERMaritalDesc=PersonObj.PAPERMaritalDR.CTMARDesc
        ; 电话
        s OutputObj.PAPERTelH=PersonObj.PAPERTelH
        ; 出生日期   年 月 日
        s PatBirth=PatMasObj.PAPMIDOB
        //s:s OutputObj.PAPMIDOB'="" s OutputObj.PAPMIDOB=$zd()
        s:PatBirth'="" PatBirth=##class(websys.Conversions).DateLogicalToHtml(PatBirth) 
        s OutputObj.PatBirthYear=$p(PatBirth,"-")
        s OutputObj.PatBirthMonth=$p(PatBirth,"-",2)
        s OutputObj.PatBirthDay=$p(PatBirth,"-",3)
        ; 年龄
        s OutputObj.PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID)
        ; 证件类型
        s OutputObj.PAPMICardTypeDesc=PatMasObj.PAPMICardTypeDR.CARDDesc
        ; 证件号码
        s OutputObj.PAPMIDVAnumber=PatMasObj.PAPMIDVAnumber
        ; 现住址 省 市 区
        s OutputObj.PAPERCTProvinceDesc=PersonObj.PAPERCTProvinceDR.PROVDesc
        s OutputObj.PAPERCityCodeDesc=PersonObj.PAPERCityCodeDR.CTCITDesc
        s OutputObj.PAPERCityAreaDesc=PersonObj.PAPERCityAreaDR.CITAREADesc
        ; 户口  省 市 区
        s OutputObj.HouseProvince=DHCPersonObj.PAPERHouseProvinceDR //.PROVDesc
        s CTProvinceObj=##class(User.CTProvince).%OpenId(OutputObj.HouseProvince)
        if $ISOBJECT(CTProvinceObj) {
            s OutputObj.HouseProvince=CTProvinceObj.PROVDesc
            do CTProvinceObj.%Close()
        }
        s OutputObj.HouseCity=DHCPersonObj.PAPERHouseCityDR //.CTCITDesc
        s CTCityObj=##class(User.CTCity).%OpenId(OutputObj.HouseCity)
        if $ISOBJECT(CTCityObj) {
            s OutputObj.HouseCity=CTCityObj.CTCITDesc
            do CTCityObj.%Close()
        }
        s OutputObj.HouseArea=DHCPersonObj.PAPERHouseAreaDR.CITAREADesc
        s CTCityAreaObj=##class(User.CTCityArea).%OpenId(OutputObj.HouseArea)
        if $ISOBJECT(CTCityAreaObj) {
            s OutputObj.HouseArea=CTCityAreaObj.CITAREADesc
            do CTCityAreaObj.%Close()
        }
        ; 工作单位
        s OutputObj.PAPERSecondPhone=PersonObj.PAPERSecondPhone
        ; 单位地址
        s OutputObj.CompanyAddress=""
        ; 单位电话
        s OutputObj.PAPERTelO=PersonObj.PAPERTelO
        ; 单位邮编
        s OutputObj.PAPERComment1=PersonObj.PAPERName6 ;DHCPersonObj.PAPERComment1
        ; 联系人姓名
        s OutputObj.PAPERForeignId=PersonObj.PAPERForeignId
        ; 联系人关系
        s OutputObj.PAPERCTRLTDesc=PersonObj.PAPERCTRLTDR.CTRLTDesc
        ; 联系人电话
        s OutputObj.PAPMIForeignPhoneNo=PatMasObj.PAPMIForeignPhoneNo
        ; 联系人地址 省 市 区
        s OutputObj.PAPERForeignAddress=PersonObj.PAPERForeignAddress
    }
    d PatMasObj.%Close()
    d PersonObj.%Close()
    d DHCPersonObj.%Close()
    q OutputObj.%ToJSON()
}

}