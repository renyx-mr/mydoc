Class DHCDoc.DHCDocConfig.SubCatContral Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindCatList(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.i value'="" d
 	..s FrequencedItemCatListStr=$g(^DHCDocConfig(value))
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindFreqList(value As %String, Type As %String = "") As %Query(ROWSPEC = "FreqRowId:%String,FreqCode:%String,selected:%Boolean")
{
}

ClassMethod FindFreqListExecute(ByRef qHandle As %Binary, value As %String, Type As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindFreqList","FrequencedItemFreq")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s FreqRowId=0
 	f  s FreqRowId=$o(^PHCFR(FreqRowId)) q:FreqRowId=""  d
 	.s str=$g(^PHCFR(FreqRowId))
 	.s FreqCode=$p(str,"^",3)
 	.s PHCFRDesc2=$p(str,"^",4)
 	.Q:(PHCFRDesc2'="饮片")&&(Type="CM")
	.s selected=0
	.i value'="" d
	..i FreqRowId=$g(^DHCDocConfig(value)) s selected=1
	.Do OutputRowFindFreqList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindFreqList
	set Data=$lb($g(FreqRowId),$g(FreqCode),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFreqListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindDurList(value As %String) As %Query(ROWSPEC = "DurRowId:%String,DurCode:%String,selected:%Boolean")
{
}

ClassMethod FindDurListExecute(ByRef qHandle As %Binary, value As %String, Type As %String = "CM") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindDurList","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DurRowId=0
 	f  s DurRowId=$o(^PHCDU(DurRowId)) q:DurRowId=""  d
 	.s str=$g(^PHCDU(DurRowId))
 	.s DurCode=$p(str,"^",1)
 	.s DurDesc2=$p(str,"^",4)
 	.q:(DurDesc2'="饮片")&&(Type="CM")
	.s selected=0
	.i value'="" d
	..i DurRowId=$g(^DHCDocConfig(value)) s selected=1
	.Do OutputRowFindDurList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDurList
	set Data=$lb($g(DurRowId),$g(DurCode),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDurListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDurListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ReOrdSubCatList() As %Library.Query(CONTAINID = 0, ROWSPEC = "Rowid:%String,Desc:%String,Code:%String") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReSetOrdSubCat","ReOrdSubCatList")

ClassMethod ReOrdSubCatListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ModuleId=0,FindRowID=""
	f  s ModuleId=$o(^DHCDocCT("Module",ModuleId)) q:(ModuleId="")||(FindRowID'="")  d
	.s ModuleDesc=$g(^DHCDocCT("Module",ModuleId))
	.i ModuleDesc="医嘱重分类" s FindRowID=ModuleId
	if (FindRowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s CTDefine=0
	f  s CTDefine=$o(^DHCDocCTi(0,"Define","ModuleDR",FindRowID,CTDefine)) q:CTDefine=""  d
	.//^DHCDocCT("Define",24) = "ORDSUBCAT^医嘱重分类^2" 
	.s DefineDataID=0
	.f  s DefineDataID=$o(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID)) q:DefineDataID=""  d
	..//^DHCDocCT("DefineData",24,"D",1) = "01^药物^63911^" 
	..s DefineDataCode=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",1)
	..s DefineDataDesc=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",2)
	..s DefineDataFrom=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",3)
	..q:(DefineDataFrom'="")&&(DefineDataFrom>+$h)
	..s DefineDataTo=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",4)
	..q:(DefineDataTo'="")&&(DefineDataTo<=+$h)
	..d OutputRow4	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(CTDefine_"||"_DefineDataID,DefineDataDesc,DefineDataCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ReOrdSubCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReOrdSubCatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReOrdSubCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReOrdSubCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindCatListNew(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListNewExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReSetOrdSubCat","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    k SubCateArr
    s OrdSubCatID=""
    for {
		s OrdSubCatID=$O(^DHCDocConfig("DHCDocReSetOrdSubCat",OrdSubCatID))
		q:(OrdSubCatID="")
		s OrdSubCatDesc=$P(^DHCDocCT("DefineData",+OrdSubCatID,"D",$P(OrdSubCatID,"||",2)),"^",2)
		s SubCateList=$G(^DHCDocConfig("DHCDocReSetOrdSubCat",OrdSubCatID))
		for i=1:1:$Length(SubCateList,"^") {
			s ARCICRowId=$P(SubCateList,"^",i)
			continue:(ARCICRowId="")
			s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
			if ($D(SubCateArr(ARCICRowId))){
				s SubCateArr(ARCICRowId)=SubCateArr(ARCICRowId)_"|"_OrdSubCatDesc
			}else{
				s SubCateArr(ARCICRowId)=OrdSubCatDesc
			}
			
		}
	}
    
    
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.i $D(SubCateArr(ARCICRowId)) d
 	..s ARCICDesc=ARCICDesc_"|"_SubCateArr(ARCICRowId)
 	.s selected=0
 	.i value'="" d
 	..s CatListStr=$g(^DHCDocConfig("DHCDocReSetOrdSubCat",value))
 	..s:("^"_CatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatListNew
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListNew
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 得到分类串

// w ##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdCateGoryStr()

ClassMethod GetOrdCateGoryStr() As %String
{
	set ret=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:ReOrdSubCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
		   i ret="" s ret=rset.GetData(1)_":"_rset.GetData(2)
	       e  s ret=ret_";"_rset.GetData(1)_":"_rset.GetData(2)
		}
		d rset.Close()
 	}
 	q ret
}

// 根据分类查询分类下的医嘱子类串

// w ##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr()

ClassMethod GetOrdSubCateGoryStr(value As %String) As %String
{
	set ret=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:FindCatListNew")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(value)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
		   i rset.GetData(3)'="1" continue
		   i ret="" s ret=rset.GetData(1)
	       e  s ret=ret_"^"_rset.GetData(1)
		}
		d rset.Close()
 	}
 	q ret
}

ClassMethod GetPropmtInfo() As %String
{
	//医嘱重分类设置缺陷提醒
	s PropmtInfo="",repeatInfo=""
	s CatListStr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:ReOrdSubCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ID=rset.GetData(1)
			s Value=$g(^DHCDocConfig("DHCDocReSetOrdSubCat",ID))
			if (Value=""){
				continue   
			}
			if (CatListStr=""){
				s CatListStr=Value
			}else{
				s CatListStr=CatListStr_"^"_Value
			}
			
		}
		d rset.Close()
	}
	
	s ARCICRowId=""
	f  {
		s ARCICRowId=$o(^ARC("IC",ARCICRowId))
		q:ARCICRowId=""
		s count=0
		for i=1:1:$L(CatListStr,"^"){
			if ($P(CatListStr,"^",i)=ARCICRowId){
				s count=count+1
			}
		}
		if (count=1){
			continue
		}
 		s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 		if (count>1){
	 		if (repeatInfo=""){
		 		s repeatInfo="医嘱重分类维护重复子类: "_ARCICDesc
		 	}else{
			 	s repeatInfo=repeatInfo_","_ARCICDesc
			}
	 	}else{
	 		if (PropmtInfo=""){
		 		s PropmtInfo="未进行医嘱重分类维护的子类: "_ARCICDesc
		 	}else{
			 	s PropmtInfo=PropmtInfo_","_ARCICDesc
			}
		}
	}
	q PropmtInfo_"<br/>"_repeatInfo
}

}
