Class DHCDoc.DHCDocConfig.OrdSets Extends %RegisteredObject
{

ClassMethod WritePriorJson()
{
	s DoctorType=##class(web.SSUser).GetDefaultCareProviderType(%session.Get("LOGON.USERID"))
	s i=0
	w "["
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s code=$p($g(^OECPR(rowid)),"^",1)
	.q:(DoctorType="NURSE")&(code="OUT")
	.s priority=$p($g(^OECPR(rowid)),"^",3)
	.Q:priority=0
	.s desc=$p($g(^OECPR(rowid)),"^",2)
	.s oneStr="{id:'"_rowid_"',text:'"_desc_"'}"
	.i $I(i)>1 w ","
	.w oneStr
	w "]",!
	Q
}

ClassMethod WriteRemarksJson()
{
	w "["
	s PriorRemarksStr=##Class(web.DHCDocOrderCommon).GetOrderPriorRemarks("I")
	s Len=$L(PriorRemarksStr,"^")
	w "{id:'',text:'　'}"
	for i=1:1:Len{
		s oneRemarkStr=$P(PriorRemarksStr,"^",i)
		s id=$P(oneRemarkStr,$C(1),1)
		s text=$P(oneRemarkStr,$C(1),3)
		s oneStr=",{id:'"_id_"',text:'"_text_"'}"
		w oneStr
	}
	w "]",!
	Q
}

/// d ##class(DHCDoc.DHCDocConfig.OrdSets).WriteQueryJson("web.DHCDocOrderCommon","LookUpDuration","HIDDEN")
ClassMethod WriteQueryJson(className, queryName, IdCol, TextCol, CodeCol = "")
{
	w "["
	s rs=##class(%ResultSet).%New(className_":"_queryName)
	d rs.Execute("")
	s row=0
	if rs&&rs.QueryIsValid(){
		while rs.Next(){
			s id=rs.GetData(IdCol)
			s text=rs.GetData(TextCol)
			i CodeCol>0{
				//s code=rs.GetData(CodeCol)
				//i code'=text s text=text_"-"_code
			}
			s row=$I(row)
			i row>1 w ","
			w "{""id"":"""_id_""",""text"":"""_text_""""
			w "}"
		}
	}
	q "]"
	//w "]",!
}

ClassMethod WriteCNPrescType()
{
	w "["
	s CMPrescTypeStrStr=##Class(web.DHCDocOrderCommon).GetCMPrescTypeStr("",%session.Get("LOGON.HOSPID"))
	s Len=$L(CMPrescTypeStrStr,$C(2))
	for i=1:1:Len{
		s oneStr=$P(CMPrescTypeStrStr,$C(2),i)
		s id=$P(oneStr,$C(1),1)
		s text=$P(oneStr,$C(1),2)
		i i>1 w ","
		w "{""id"":"""_id_""",""text"":"""_text_""""
		;i i=1 w ",selected:true"
		w "}"
	}
	q "]"
	//w "]"
}

ClassMethod SaveOSCNInfo(OSRowid, PrescTypeCode, DoseQtyId, DuratId, FreqId, InstrId, Notes)
{
	&SQL(UPDATE SQLUser.ARC_OrdSets SET ARCOS_PrescTypeCode=:PrescTypeCode,ARCOS_DurationDR=:DuratId, 
		ARCOS_FrequencyDR=:FreqId, ARCOS_Instr_DR=:InstrId, ARCOS_InstrLinkDosage_DR=:DoseQtyId,ARCOS_Notes=:Notes
	WHERE ARCOS_RowId1=:OSRowid)
	Q SQLCODE
}

}
