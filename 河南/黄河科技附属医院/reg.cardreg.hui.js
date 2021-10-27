var PageLogicObj={
	m_FindPatListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	m_SessionStr:"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+"^"+session['LOGON.SITECODE']+"^",
	m_SelectCardTypeRowID:"",
	m_OverWriteFlag:"",
	m_CardCost:"",
	m_CCMRowID:"",
	m_SetFocusElement:"",
	m_CardNoLength:"",
	m_SetRCardFocusElement:"",
	m_SetCardRefFocusElement:"",
	m_SetCardReferFlag:"",
	m_CardINVPrtXMLName:"",
	m_PatPageXMLName:"",
	m_CardTypePrefixNo:"",
	m_UsePANoToCardNO:"",
	m_RegCardConfigXmlData:"",
	m_PAPMINOLength:10,
	m_PatMasFlag:"",
	m_CardRefFlag:"",
	m_AccManagerFlag:"",
	m_CardSecrityNo:"",
	m_MedicalFlag:0, //建病历标识
	m_CurSearchValue:"",
	m_tmformat:'HMS',
	m_IDCredTypePlate:"01", //身份证代码字段
	m_CardValidateCode:"",
	m_CardVerify:"",
	m_ModifiedFlag:"",
	m_ReceiptsType:"",
	m_IsNotStructAddress:"",
	m_CredTypeDef:"",
	//已婚
	m_MarriedIDStr:"22^23^24^25^26^27",
	//已婚最低年龄限制(女)
	m_MarriedLimitFemaleFAge:18,
	//已婚最低年龄限制(男)
	m_MarriedLimitMaleAge:18,
	m_PrtXMLName:"UDHCAccDeposit",
	JumpAry :["CardNo","Name", "Sex", "CredNo", "PatType", "TelHome"],
	m_CardRegMustFillInArr:[],
	m_CardRegJumpSeqArr:[]
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
$(window).load(function() {
	if (ServerObj.CardRefgDOMCache==""){
		SaveCahce();
	}
	for (var i=0;i<PageLogicObj.m_CardRegMustFillInArr.length;i++){
		var id=PageLogicObj.m_CardRegMustFillInArr[i]['id'];
		$("label[for="+id+"]").addClass("clsRequired");
	}
});
function Init(){
	PageLogicObj.m_FindPatListTabDataGrid=InitFindPatListTabDataGrid();
}
function InitEvent(){
	$("#PAPMINo").blur(PAPMINoOnblur);
	$("#InMedicare").blur(InMedicareOnBlur);
	$("#Birth").blur(BirthOnBlur);
	$("#BirthTime").blur(BirthTimeOnBlur);
	$("#Name").blur(SearchSamePatient);
	$("#PatYBCode").blur(SearchSamePatient);
	$("#Age").keypress(AgeOnKeypress);
	$("#Age").blur(AgeOnBlur);
	$("#CredNo").change(CredNoOnChange);
	//$("#CredNo").keypress(CredNoOnKeyPress);
	$("#CredNo").blur(SearchSamePatient);
	$("#Clear").click(Clearclick);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#ReadRegInfo").click(ReadRegInfoOnClick);
	$("#NewCard").click(NewCardclick);
	$("#BModifyInfo").click(BModifyInfoclick);
	//$("#PatPaySum").keypress(PatPaySumKeyPress);
	//合并卡
	$("#CardUnite").click(CardUniteClick);
	//打印条码
	$("#prt").click(prtClick);
	$("#CardSearch").click(CardSearchClick);
	$("#BOtherCredType").click(OtherCredTypeInput);
	$("#BAddressInoCollaps").click(BAddressInoCollapsClick);
	$("#BPayInoCollaps").click(BPayInoCollapsClick);
	$("#BBaseInoCollaps").click(BBaseInoCollapsClick);
	
	$HUI.combobox(".hisui-combobox", {
		keyHandler:{
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },
            up: function () {
	            var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
				var valueField=$(this).combobox('options')['valueField'];
                //取得上一行
                for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i][valueField]==CurValue) {
						if (i>0) $(this).combobox("select",Data[i-1][valueField]);
						break;
					}
				}
             },
             down: function () {
              	var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
				if ($(this).combobox('panel').is(":hidden")){
					$(this).combobox('showPanel');
					return false;
				}
				var valueField=$(this).combobox('options')['valueField'];
                //取得下一行
                for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i][valueField]==CurValue) {
							if (i < Data.length-1) $(this).combobox("select",Data[i+1][valueField]);
							break;
						}
					}else{
						$(this).combobox("select",Data[0][valueField]);
						break;
					}
				}
            },
            query: function (q, e) {
                _8c0(this, q);
            },
            enter: function (e) { 
            	$(this).combobox('hidePanel');
            	var id=$(this)[0].id;
            	return DOMFocusJump(id);
            }
		}
	})
	document.onkeydown=Doc_OnKeyDown;
	DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	$("#ComputerIP").val(computername);
}
function PageHandle(){
	//卡类型
	LoadCardType();
	//证件类型、联系人证件类型
	LoadCredType();
	//LoadForeignCredType();
	//病人类型
	LoadPatType();
	//婚姻
	LoadMarital();
	//病人级别
	LoadPoliticalLevel();
	//病人密级
	LoadSecretLevel();
	//合同单位
	LoadHCPDR();
	//民族
	LoadCTNation();
	//关系
	LoadCTRelation();
	//职业
	LoadVocation();
	//性别
	LoadSex();
	//籍贯
	LoadCountry();
	//支付方式
	LoadPayMode();
	//银行
	LoadBank();
	//银行卡类型
	LoadBankCardType();
	//设备类型
	LoadIEType();
	//人群分类 renyx
	LoadPopulationClass();
	
	InitPatRegConfig();
	IntDoc();
	//DisableBtn("NewCard",true);
}
//renyx
function LoadPopulationClass(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"PopulationClass"
	},function(Data){
		$("#PopulationClass").combobox({
		//var cbox = $HUI.combobox("#PopulationClass", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: JSON.parse(Data)
				
		 });
	});*/
	$("#PopulationClass").combobox({
		
		valueField: 'id',
		textField: 'text', 
		editable:false,
		data: JSON.parse(ServerObj.DefaultPopulationClassPara)
				
	});
}
function LoadCardType(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCardTypeDefineListBroker",
		JSFunName:"GetCardTypeToHUIJson",
		ListName:"",
		SessionStr:PageLogicObj.m_SessionStr
	},function(Data){
		var cbox = $HUI.combobox("#CardTypeDefine", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data),
				onSelect:function(rec){
					CardTypeKeydownHandler();
				}
		 });
		 CardTypeKeydownHandler();
	});*/
	$("#CardTypeDefine").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultCardTypePara),
		onSelect:function(rec){
			CardTypeKeydownHandler();
		}
	})
	CardTypeKeydownHandler();
}
function LoadCredType(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#CredType,#ForeignCredType", {
				valueField: 'id',
				textField: 'text',
				blurValidValue:true, 
				editable:false,
				data: JSON.parse(Data)
		 });
		 for (var i=0;i<JSON.parse(Data).length;i++){
			 if (JSON.parse(Data)[i]['selected']==true){
				 PageLogicObj.m_CredTypeDef=JSON.parse(Data)[i]['id'];
				 break;
		     }
		 }
	});*/
	var CredTypeData=JSON.parse(ServerObj.DefaultCredTypePara);
	$("#CredType,#ForeignCredType").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: CredTypeData
	})
	for (var i=0;i<CredTypeData.length;i++){
		 if (CredTypeData[i]['selected']==true){
			 PageLogicObj.m_CredTypeDef=CredTypeData[i]['id'];
			 break;
	     }
	 }
}
/*function LoadForeignCredType(){
	$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#ForeignCredType", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: JSON.parse(Data)
		 });
	});
}*/
function LoadPatType(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadPatType",
		JSFunName:"GetPatTypeToHUIJson",
		ListName:"",
		SessionStr:PageLogicObj.m_SessionStr
	},function(Data){
		var cbox = $HUI.combobox("#PatType", {
				valueField: 'id',
				textField: 'text', 
				//editable:false,
				blurValidValue:true,
				data: JSON.parse(Data),
				filter: function(q, row){
					if (q=="") return true;
					if (row["text"].indexOf(q.toUpperCase())>=0) return true;
					var find=0;
					if ((row["AliasStr"])&&(row["AliasStr"]!="")){
						for (var i=0;i<row["AliasStr"].split("^").length;i++){
							if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
								find=1;
								break;
							}
						}
					}
					if (find==1) return true;
					return false;
				},
				onSelect:function(rec){
					PatTypeOnChange();
				}*//*,
				keyHandler:{
					left: function () {
						return false;
		            },
					right: function () {
						return false;
		            },
		            up: function () {
			            var Data=$(this).combobox("getData");
						var CurValue=$(this).combobox("getValue");
		                //取得上一行
		                for (var i=0;i<Data.length;i++) {
							if (Data[i] && Data[i].provid==CurValue) {
								if (i>0) $(this).combobox("select",Data[i-1].provid);
								break;
							}
						}
		             },
		             down: function () {
		              	var Data=$(this).combobox("getData");
						var CurValue=$(this).combobox("getValue");
		                //取得下一行
		                for (var i=0;i<Data.length;i++) {
							if (CurValue!="") {
								if (Data[i] && Data[i].provid==CurValue) {
									if (i < Data.length-1) $(this).combobox("select",Data[i+1].provid);
									break;
								}
							}else{
								$(this).combobox("select",Data[0].provid);
								break;
							}
						}
		            },
		            enter: function () { 
		                //选中后让下拉表格消失
		                $(this).combogrid('hidePanel');
		                $("#TelHome").focus();
		            }
				}*/
		 /*});
	});*/
	$("#PatType").combobox({
		width:115,
		valueField: 'id',
		textField: 'text', 
		//editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultPatTypePara),
		filter: function(q, row){
			if (q=="") return true;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			var find=0;
			if ((row["AliasStr"])&&(row["AliasStr"]!="")){
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
			}
			if (find==1) return true;
			return false;
		},
		onSelect:function(rec){
			PatTypeOnChange();
		}
	})
}
function LoadMarital(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTMarital",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#PAPERMarital", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#PAPERMarital").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultMaritalPara)
	})
}
function LoadPoliticalLevel(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"PoliticalLevel",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#PoliticalLevel", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#PoliticalLevel").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:true,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultPoliticalLevPara)
	})
}
function LoadSecretLevel(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"SecretLevel",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#SecretLevel", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#SecretLevel").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:true,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultSecretLevelPara)
	})
}
function LoadHCPDR(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"HCPDR",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#HCPDR", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#HCPDR").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:true,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultHCPDRPara)
	})
}
function LoadCTNation(){
	/*var Data=$.cm({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTNATION",
		QueryInfo:"^^^HUIJSON",
		dataType:"text"
	},false);
	var cbox = $HUI.combobox("#NationDescLookUpRowID", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			data: JSON.parse(Data),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			}
	 });*/
	 var cbox = $HUI.combobox("#NationDescLookUpRowID", {
			width:115,
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			data: JSON.parse(ServerObj.DefaultNationPara),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			}
	 });
}
function LoadCTRelation(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTRelation",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#CTRelationDR", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#CTRelationDR").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:true,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultRelationPara)
	 });
}
function LoadVocation(){
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTOCCUPATION",
		QueryInfo:"^^^HUIJSON"
	},function(Data){
		var cbox = $HUI.combobox("#Vocation", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				blurValidValue:true,
				data: JSON.parse(Data),
				filter: function(q, row){
					if (q=="") return true;
					if (row["text"].indexOf(q.toUpperCase())>=0) return true;
					var find=0;
					for (var i=0;i<row["AliasStr"].split("^").length;i++){
						if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
							find=1;
							break;
						}
					}
					if (find==1) return true;
					return false;
				}
		 });
	});*/
	$("#Vocation").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:true,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultOccuptionPara),
		filter: function(q, row){
			if (q=="") return true;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			var find=0;
			for (var i=0;i<row["AliasStr"].split("^").length;i++){
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
					find=1;
					break;
				}
			}
			if (find==1) return true;
			return false;
		}
	});
}
function LoadSex(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadSex",
		JSFunName:"GetSexToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#Sex", {
				valueField: 'id',
				textField: 'text', 
				//editable:false,
				blurValidValue:true,
				data: JSON.parse(Data),
				filter: function(q, row){
					if (q=="") return true;
					var find=0;
					if (row["text"].indexOf(q.toUpperCase())>=0) return true;
					for (var i=0;i<row["AliasStr"].split("^").length;i++){
						if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
							find=1;
							break;
						}
					}
					if (find==1) return true;
					return false;
				},
				onSelect:function(rec){
					SearchSamePatient();
				}
		 });
	});*/
	$HUI.combobox("#Sex", {
		width:115,
		valueField: 'id',
		textField: 'text', 
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultSexPara),
		filter: function(q, row){
			if (q=="") return true;
			var find=0;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			for (var i=0;i<row["AliasStr"].split("^").length;i++){
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
					find=1;
					break;
				}
			}
			if (find==1) return true;
			return false;
		},
		onSelect:function(rec){
			SearchSamePatient();
		}
	})
}
function LoadCountry(){
	/*var Data=$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTCOUNTRY",
		QueryInfo:"^^^HUIJSON"
	},false);*/
	var cbox = $HUI.combobox("#CountryDescLookUpRowID,#CountryHome,#CountryBirth,#CountryHouse", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			//data: JSON.parse(Data),
			data: JSON.parse(ServerObj.DefaultCTCountryPara),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			},
			onSelect:function(rec){
				//$("#AreaBirth,#CityAreaLookUpRowID,#AreaHouse").combobox('select',"");
				var id=$(this).combobox("getValue");
				var Item=$(this)[0].id;
				var tt=Item
				if (tt=="CountryHome"){
					$("#CityHome").combobox('select',"");
				}else if(tt=="CountryBirth"){
					$("#CityBirth").combobox('select',"");
				}else if(tt=="CountryHouse"){
					$("#CityDescLookUpRowID").combobox('select',"");
				}else if(tt=="CountryDescLookUpRowID"){ 
					//$("#CityDescLookUpRowID").combobox('select',"");
				}
				//$("#CityHome,#CityBirth,#CityDescLookUpRowID,#Cityhouse").combobox('select',"");
				//setTimeout(function(){
					LoadProvince(Item,id);
				//})
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					var item=$(this)[0].id;
					if (item=="CountryHome"){
						var provinceId="ProvinceHome";
					}else if(item=="CountryBirth"){
						var provinceId="ProvinceBirth";
					}else if(item=="CountryHouse"){
						var provinceId="ProvinceInfoLookUpRowID"; //省现住
					}else if(item=="CountryDescLookUpRowID"){ 
						var provinceId="ProvinceHouse"
					}
					$("#"+provinceId).combobox('select','');
				}
			}
	 });
}
function LoadPayMode(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadPayMode",
		JSFunName:"GetPayModeToHUIJson",
		ListName:"",
		gGroupID:session['LOGON.GROUPID']
	},function(Data){
		var cbox = $HUI.combobox("#PayMode", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data),
				onSelect:function(rec){
					PayModeOnChange();
				}
		 });
		 setTimeout(function(){
			PayModeOnChange();
		 })
	});*/
	$("#PayMode").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultPaymodePara),
		onSelect:function(rec){
			PayModeOnChange();
		}/*,
		onLoadSuccess:function(){
			var Data=$(this).combobox("getData");
			if (Data.length>0){
				$(this).combobox("select",Data[0]["id"]);
				PayModeOnChange();
			}
		}*/
	});
	setTimeout(function(){
			PayModeOnChange();
		 })
}
function LoadBank(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadBankListBroker",
		JSFunName:"GetBankToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#Bank", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#Bank").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultBankPara)
	});
}
function LoadBankCardType(){
	/*$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadBankCardType",
		JSFunName:"GetBankCardTypeToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#BankCardType", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});*/
	$("#BankCardType").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultBankCardTypePara)
	});
}
function LoadIEType(){
	/*$.cm({
		ClassName:"web.UDHCCardCommLinkRegister",
		QueryName:"ReadHardComList",
		HardGroupType:"IE", 
		ExpStr:""
	},function(GridData){
		var cbox = $HUI.combobox("#IEType", {
				valueField: 'HGRowID',
				textField: 'HGDesc', 
				editable:false,
				blurValidValue:true,
				data: GridData["rows"],
				onLoadSuccess:function(){
					var Data=$(this).combobox("getData");
					if (Data.length>0){
						$(this).combobox("select",Data[0]["HGRowID"]);
					}
				}
				
		 });
	});*/
	$("#IEType").combobox({
		valueField: 'HGRowID',
		textField: 'HGDesc', 
		editable:false,
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultIETypePara),
		onLoadSuccess:function(){
			var Data=$(this).combobox("getData");
			if (Data.length>0){
				$(this).combobox("select",Data[0]["HGRowID"]);
			}
		}
	});
}
function LoadProvince(item,CountryId){
	if (item=="CountryHome"){
		var provinceId="ProvinceHome";
	}else if(item=="CountryBirth"){
		var provinceId="ProvinceBirth";
	}else if(item=="CountryHouse"){
		var provinceId="ProvinceInfoLookUpRowID"; //省现住
	}else if(item=="CountryDescLookUpRowID"){ 
		var provinceId="ProvinceHouse"
	}
	var Data=$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		dataType:"text",
		TabName:"CTProvince",
		QueryInfo:CountryId+"^^^HUIJSON^"+provinceId
	},false);
	var cbox = $HUI.combobox("#"+provinceId, {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			data: JSON.parse(Data),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			},
			onSelect:function(rec){
				//$("#AreaBirth,#CityAreaLookUpRowID,#AreaHouse").combobox('select',"");
				//加载市信息
				var id=$(this).combobox("getValue");
				var item=$(this)[0].id;
				if (item=="ProvinceHome"){
					
				}else if(item=="ProvinceBirth"){
					$("#AreaBirth").combobox('select',"");
					
				}else if(item=="ProvinceInfoLookUpRowID"){
					$("#CityAreaLookUpRowID").combobox('select',"");
					
				}else if(item=="ProvinceHouse"){ //国籍
					$("#AreaHouse").combobox('select',"");
				}
				LoadCity($(this)[0].id,id);
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					var item=$(this)[0].id;
					if (item=="ProvinceHome"){
						var cityId="CityHome";
					}else if(item=="ProvinceBirth"){
						var cityId="CityBirth";
					}else if(item=="ProvinceInfoLookUpRowID"){
						var cityId="CityDescLookUpRowID";
					}else if(item=="ProvinceHouse"){ //国籍
						var cityId="Cityhouse"
					}
					$("#"+cityId).combobox('select','');
				}
			}
	 });
	 var id=$("#"+provinceId).combobox("getValue");
	 if (id!=""){
		LoadCity(provinceId,id);
	 }
}
function LoadCity(item,ProvinceId){
	if (item=="ProvinceHome"){
		var cityId="CityHome";
	}else if(item=="ProvinceBirth"){
		var cityId="CityBirth";
	}else if(item=="ProvinceInfoLookUpRowID"){
		var cityId="CityDescLookUpRowID";
	}else if(item=="ProvinceHouse"){ //国籍
		var cityId="Cityhouse"
	}
	var Data=$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		dataType:"text",
		TabName:"CTCITY",
		QueryInfo:ProvinceId+"^^^HUIJSON"
	},false);
	var cbox = $HUI.combobox("#"+cityId, {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			data: JSON.parse(Data),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			},
			onSelect:function(rec){
				if (rec!=undefined){
					//加载县信息
					var id=$(this).combobox("getValue");
					LoadArea($(this)[0].id,id);
				}
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					var item=$(this)[0].id;
					if (item=="CityHome"){
						var areaId="";
					}else if(item=="CityBirth"){
						var areaId="AreaBirth";
					}else if(item=="CityDescLookUpRowID"){
						var areaId="CityAreaLookUpRowID";
					}else if(item=="Cityhouse"){ 
						var areaId="AreaHouse"
					}
					if (areaId!="") $("#"+areaId).combobox('select','');
				}
			}
	 });
	 var id=$("#"+cityId).combobox("getValue");
	 if (id!=""){
		LoadArea(cityId,id);
	 }
}
function LoadArea(item,cityId){
	if (item=="CityHome"){
		var areaId="";
	}else if(item=="CityBirth"){
		var areaId="AreaBirth";
	}else if(item=="CityDescLookUpRowID"){
		var areaId="CityAreaLookUpRowID";
	}else if(item=="Cityhouse"){ 
		var areaId="AreaHouse"
	}
	var Data=$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		dataType:"text",
		TabName:"CTCITYAREA",
		QueryInfo:cityId+"^^^HUIJSON"
	},false);
	var cbox = $HUI.combobox("#"+areaId, {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			blurValidValue:true,
			data: JSON.parse(Data),
			filter: function(q, row){
				if (q=="") return true;
				if (row["text"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			}
	 });
}
function CardTypeKeydownHandler(){
	var myoptval=$("#CardTypeDefine").combobox("getValue");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){
		return;
	}
	PageLogicObj.m_SelectCardTypeRowID = myCardTypeDR;
	PageLogicObj.m_OverWriteFlag=myary[23];
	$("#CardFareCost,#ReceiptNO,#CardNo").val("");
	var m_RegCardConfigXmlData=$.cm({
		ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
		MethodName:"ReadDefaultCardTypeConfigByDR",
		dataType:"text",
		CardTypeDR:PageLogicObj.m_SelectCardTypeRowID,
		SessionStr:""
	},false);
	PageLogicObj.m_RegCardConfigXmlData=m_RegCardConfigXmlData;
	PageLogicObj.m_CardCost=0;
	if (myary[3]=="C"){
		$("#CardFareCost").val(myary[6]);
		PageLogicObj.m_CardCost=myary[6];
		GetReceiptNo();
	}
	if (myary[16]=="Handle"){
		$("#CardNo").attr("disabled",false);
		DisableBtn("BReadCard",true);
		$("#CardNo").focus();
	}else{
		$("#CardNo").attr("disabled",true);
		DisableBtn("BReadCard",false);
		$("#BReadCard").focus();
	}
	PageLogicObj.m_CCMRowID=myary[14];
	PageLogicObj.m_SetFocusElement = myary[13];
	if (PageLogicObj.m_SetFocusElement!=""){
		$("#"+PageLogicObj.m_SetFocusElement).focus();
	}
	PageLogicObj.m_CardNoLength=myary[17];
	PageLogicObj.m_SetRCardFocusElement=myary[20];
	PageLogicObj.m_SetCardRefFocusElement=myary[22];
	PageLogicObj.m_SetCardReferFlag=myary[21];
	var myobj=document.getElementById("PAPMINo");
	if (PageLogicObj.m_SetCardReferFlag=="Y"){
		myobj.onkeydown = PAPMINoOnKeyDown;
		//myobj.readOnly=false;
		$('#PAPMINo').removeAttr("disabled");
	}else{
		myobj.onclick = function(){return false;}
		//myobj.readOnly=true;
		$('#PAPMINo').val('').attr("disabled",true);
	}
	PageLogicObj.m_CardINVPrtXMLName=myary[25];
	PageLogicObj.m_PatPageXMLName=myary[26];
	PageLogicObj.m_CardTypePrefixNo=myary[29];
	//设置使用登记号作为卡号
	if (myary.length>=37){
		PageLogicObj.m_UsePANoToCardNO=myary[36];
	}
	if (PageLogicObj.m_UsePANoToCardNO=="Y"){
		DisableBtn("BReadCard",true);
		$("#CardNo").attr("disabled",true);
		DisableBtn("NewCard",false);
		PageLogicObj.m_CardNoLength=0;
		$('#Name').focus();
	}
}
function ReadCardClickHandle(){
	if ($("#BReadCard").hasClass('l-btn-disabled')){
		return false;
	}
	var myVersion=ServerObj.ConfigVersion;
	if (myVersion=="12"){
		M1Card_InitPassWord();
    }
	var rtn=DHCACC_ReadMagCard(PageLogicObj.m_CCMRowID,"R", "2");
	var myary=rtn.split("^");
	if (myary[0]=='0'){
		$("#CardNo").val(myary[1]);
		PageLogicObj.m_CardVerify=myary[2];
		PageLogicObj.m_CardValidateCode=myary[2];
		PageLogicObj.m_CardSecrityNo=myary[2];
		GetValidatePatbyCard();
	}
}
function M1Card_InitPassWord()
{
  try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e){
  }
}
function GetReceiptNo(){
	var myPINVFlag="Y";
	var myExpStr=session['LOGON.USERID'] +"^"+myPINVFlag;
	if (cspRunServerMethod(ServerObj.GetreceipNO,'SetReceipNO',session['LOGON.USERID'], PageLogicObj.m_SelectCardTypeRowID, myExpStr)!='0') {
		$.messager.alert("提示",t['InvalidReceiptNo']);
		return false;
	}
}
function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	$('#ReceiptNO').val(ls_ReceipNo);
	//如果张数小于最小提示额change the Txt Color
	if (myary[1]!="0"){	
		$("#ReceiptNO").addClass("newclsInvalid"); 
	}
}
function PAPMINoOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#PAPMINo").unbind("blur");
		SetPAPMINoLenth();
		GetPatDetailByPAPMINo();
		setTimeout(function(){
			$("#PAPMINo").blur(PAPMINoOnblur);
		});
	}
}
function PAPMINoOnblur(){
	SetPAPMINoLenth();
	GetPatDetailByPAPMINo();
}
function InMedicareOnBlur(){
	var myInMedicare = $("#InMedicare").val();
	if (myInMedicare.split('M').length > 1) {
		$("#InMedicare").val(myInMedicare.split('M')[0]);
	}
	SearchSamePatient();
}
function BirthOnBlur(){
	///清屏的时候不在处理
	//var Obj=GetEventElementObj()
	//if (Obj.name=="Clear"){return websys_cancel();}
	var mybirth=$("#Birth").val();
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		$.messager.alert("提示","请输入正确的出生日期!","info",function(){
			$("#Birth").addClass("newclsInvalid"); 
			$("#Birth").focus();
		});
		return false;
	}
	$("#Birth").removeClass("newclsInvalid");
	if ((mybirth.length==8)){
		if (ServerObj.dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (ServerObj.dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
		$("#Birth").val(mybirth);
	}
	if (mybirth!="") {
		if (ServerObj.dtformat=="YMD"){
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (ServerObj.dtformat=="DMY"){
			var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		var ret=mybirth.match(reg);
	    if(ret==null){
		    $.messager.alert("提示","请输入正确的出生日期!","info",function(){
				$("#Birth").addClass("newclsInvalid"); 
				$("#Birth").focus();
			});
			return false;
		}
	  	if (ServerObj.dtformat=="YMD"){
		  	var myrtn=DHCWeb_IsDate(mybirth,"-")
	  	}
	  	if (ServerObj.dtformat=="DMY"){
		  	var myrtn=DHCWeb_IsDate(mybirth,"/")
	  	}
		if (!myrtn){
			$.messager.alert("提示","请输入正确的出生日期!","info",function(){
				$("#Birth").addClass("newclsInvalid"); 
				$("#Birth").focus();
			});
			return false;
		}else{
			var mybirth1=$("#Birth").val();
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				$.messager.alert("提示","出生日期不能大于今天或者小于、等于1840年!","info",function(){
					$("#Birth").addClass("newclsInvalid"); 
					$("#Birth").focus();
				});
				return false;
			}
			var myAge=DHCWeb_GetAgeFromBirthDay("Birth");
			$("#Age").val(myAge);
		}
	}else{
		$("#Birth").removeClass("newclsInvalid");
	}
	SearchSamePatient();
}
function BirthTimeOnBlur(){
	var mybirth=$("#Birth").val();
	if(mybirth=="") return false;
	var mybirthTime=$("#BirthTime").val();
	if(mybirthTime=="") return false;
	var eSrc=document.getElementById('BirthTime')
	if (!IsValidTime(eSrc)) {
		$.messager.alert("提示","请输入正确的出生时间!","info",function(){
			$("#BirthTime").addClass("newclsInvalid"); 
			$("#BirthTime").focus();
		});
		return false;
	}
	var myage = $("#Age").val();
	var mybirthTime=$("#BirthTime").val();
	$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"DispPatAge",
		dataType:"text",
		birthDate:mybirth, admDate:"", birthTime:mybirthTime, admTime:"", controlFlag:"N"
	},function(ageStr){
		var ageStr=ageStr.split("||")[0]
		$("#Age").val(ageStr);
	});
	$("#BirthTime").removeClass("newclsInvalid"); 
}
function AgeOnKeypress(){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	//过滤"." 年龄计算会错误
	if (keycode==46){window.event.keyCode=0;return websys_cancel();}
	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}	
}
function setBirthAndSex(mypId){
	var myary=DHCWeb_GetInfoFromId(mypId);
	if (myary[0]=="1"){
		var myBirth=$("#Birth").val();
		$("#Birth").val(myary[2]);		
		$("#Age").val(myary[4]);		
		var mySexDR="";
		switch(myary[3]){
			case "男":
				mySexDR="1";
				break;
			case "女":
				mySexDR="2";
				break;
			default:
				mySexDR="4";
				break;
		}
		$("#Sex").combobox("select",mySexDR);
	}else{
		$("#CredNo").focus();
		return false;
	}
}
function AgeOnBlur(){
	var myrtn=IsCredTypeID();
	var mypId = $("#CredNo").val();
	if ((myrtn)&&(mypId!="")) {
		var Birth=$("#Birth").val();
		if (Birth==""){
			setBirthAndSex(mypId);
		}
		return;
	};
	var myage = $("#Age").val();
	if (((myage.indexOf("岁")!=-1)||(!isNaN(myage)))&&(myage!="")){
		if (parseInt(myage)>=parseInt(ServerObj.LimitAge)){
			$.messager.alert("提示","年龄不能超过"+LimitAge+"岁","info",function(){
				$("#Birth").focus();
				$("#Birth").val("");
			});
			return false;
		}
	}
	$.cm({
		ClassName:"web.DHCDocCommon",
		MethodName:"GetBirthDateByAge",
		dataType:"text",
		Age:myage, Type:""
	},function(rtn){
		var myBirth=$("#Birth").val()
		if(myBirth==""||myBirth==undefined){
			$("#Birth").val(rtn);
		}
	});
}
function SetPAPMINoLenth(){
	var PAPMINo=$("#PAPMINo").val();
	if (PAPMINo!='') {
		if ((PAPMINo.length<PageLogicObj.m_PAPMINOLength)&&(PageLogicObj.m_PAPMINOLength!=0)) {
			for (var i=(PageLogicObj.m_PAPMINOLength-PAPMINo.length-1); i>=0; i--) {
				PAPMINo="0"+PAPMINo;
			}
		}
		$("#PAPMINo").val(PAPMINo);	
	}
}
function GetPatDetailByPAPMINo(){
	$("#PAPMINo").removeClass("newclsInvalid");
	var myPAPMINo=$('#PAPMINo').val();
	if (myPAPMINo!=""){
		var myPatInfo=$.cm({
			ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName:"GetPatInfoByPANo",
			dataType:"text",
			PAPMINo:myPAPMINo, ExpStr:""
		},false);
		var myary=myPatInfo.split("^");
		if (myary[0]=="0"){
			//先清除页面信息,对应用于清除匹配的XML获取:##class(web.DHCBL.UDHCUIDefConfig).ReadCardPatUDIef
			InitPatRegConfig();
			var myXMLStr=myary[1];
			var PAPMIXMLStr=GetRegMedicalEPMI("",myPAPMINo);
			if (PAPMIXMLStr!="") myXMLStr=PAPMIXMLStr;
			SetPatInfoByXML(myXMLStr);
			if (PageLogicObj.m_SetCardRefFocusElement!=""){
				$("#"+PageLogicObj.m_SetCardRefFocusElement).focus();
			}
			//加入图片base64应用
			var PhotoInfo=$("#PhotoInfo").val();
			if (PhotoInfo!=""){
				var src="data:image/png;base64,"+PhotoInfo;
			}else{
				var src="";
			}
			ShowPicBySrcNew(src,"imgPic");
			var PAPMIDR=$('#PAPMIRowID').val();
			return true;
		}else if (myary[0]=="2001"){
			$.messager.alert("提示","无此登记号的病人!");
		}else if (myary[0]=="-353"){
			$.messager.alert("提示","此登记号不能重复建立账户!");
		}else{
			$.messager.alert("提示","Error Code: " + myary[0]);
		}
		$("#PAPMINo").addClass("newclsInvalid"); 
		return false;
	}
}
function InitPatRegConfig()
{
	/*var myvalue=$.cm({
		ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
		MethodName:"GetCardPatRegConfig",
		dataType:"text",
		SessionStr:""
	},false);*/
	var myvalue=ServerObj.DefaultCardPatRegConfigPara;
	if (myvalue==""){
		return;
	}
	var myRtnAry=myvalue.split(String.fromCharCode(2))
	var myary=myRtnAry[0].split("^");
	var mySetFocusElement=myary[2];
	PageLogicObj.m_IsNotStructAddress=myary[17];
	if (PageLogicObj.m_IsNotStructAddress=="Y"){
		InitAddressCombo();
	}
	PageLogicObj.m_SetFocusElement = mySetFocusElement;
	PageLogicObj.m_PatMasFlag=myary[3];
	PageLogicObj.m_CardRefFlag=myary[4];
	PageLogicObj.m_AccManagerFlag=myary[5];
	SetPatInfoByXML(myRtnAry[1]);
	SetPatInfoByXML(ServerObj.CardPatUIDefStr);
	if (mySetFocusElement!=""){
		$("#"+mySetFocusElement).focus();
	}
	PageLogicObj.m_CardSecrityNo="";
	PageLogicObj.m_CardRegMustFillInArr=JSON.parse(myary[19]);
	PageLogicObj.m_CardRegJumpSeqArr=JSON.parse(myary[20]);
}
function SetPatInfoByXML(XMLStr,CheckFlag,getMessageByIdCard) {
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var AddressObj={
		AdrDesc:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrHouse:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrBirth:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrHome:{
			Country:'',
			Province:'',
			City:''
		}
	};
	var xmlDoc = DHCDOM_CreateXMLDOM();
    oldPersonMessage=[];
	if(typeof getMessageByIdCard!="undefined"){
		oldPersonMessageFromIDCard={};
	}
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if (xmlDoc.parseError.errorCode != 0) {
		alert(xmlDoc.parseError.reason);
		return;
	}
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}
	for (var i = 0; i < nodes.length; i++) {
		var myItemName = nodes(i).nodeName;
		var myItemValue = nodes(i).text;
		if ((myItemName=="OtherCardInfo")&&(myItemValue!="")) {
			myItemValue=myItemValue.replace(/@/g,"^");
		}
		//renyx
		if ((myItemName=="NationDesc")&&(myItemValue!="")) {
			//myItemValue=myItemValue.replace(/@/g,"^");
			$("#NationDescLookUpRowID").combobox("select",myItemValue);
		}
		var _$id=$("#"+myItemName);
		if (_$id.length>0){
			//if (_$id.hasClass("hisui-combobox")){
			if (_$id.next().hasClass('combo')){
				if(typeof getMessageByIdCard!="undefined"){
					if(myItemName=="PatType"){
						oldPersonMessageFromIDCard.PatType=myItemValue
				  	}	
				}else{
				  	//地址信息有加载顺序问题,所以先记录,后处理
					if (myItemName == "CountryHouse") { //国(现住)
						AddressObj.AdrDesc.Country=myItemValue;
					}else if(myItemName == "ProvinceInfoLookUpRowID"){ //省(现住)
						AddressObj.AdrDesc.Province=myItemValue;
					}else if(myItemName=="CityDescLookUpRowID"){ //市(现住)
						AddressObj.AdrDesc.City=myItemValue;
					}else if(myItemName=="CityAreaLookUpRowID"){ //CTArea 县(现住)
						AddressObj.AdrDesc.Area=myItemValue;
					}else if(myItemName=="CountryDescLookUpRowID"){ //国籍
						AddressObj.AdrHouse.Country=myItemValue;
					}else if(myItemName=="ProvinceHouse"){ //省(户口)
						AddressObj.AdrHouse.Province=myItemValue;
					}else if (myItemName == "Cityhouse") { //市(户口)
						AddressObj.AdrHouse.City=myItemValue;
					}else if (myItemName == "AreaHouse") { //县(户口)
						AddressObj.AdrHouse.Area=myItemValue;
					}else if (myItemName == "CountryBirth") { //国(出生)
						AddressObj.AdrBirth.Country=myItemValue;
					}else if (myItemName == "ProvinceBirth") { //省(出生)
						AddressObj.AdrBirth.Province=myItemValue;
					}else if (myItemName == "CityBirth") { //市(出生)
						AddressObj.AdrBirth.City=myItemValue;
					}else if (myItemName == "AreaBirth") { //县(出生)
						AddressObj.AdrBirth.Area=myItemValue;
					}else if (myItemName == "CountryHome") {
						AddressObj.AdrHome.Country=myItemValue;
					}else if (myItemName == "ProvinceHome") {
						AddressObj.AdrHome.Province=myItemValue;
					}else if(myItemName == "CityHome"){
						AddressObj.AdrHome.City=myItemValue;
					}else if(myItemName == "PopulationClass"){
						_$id.combobox("select",myItemValue);
					}else{
						if ((myItemName == "CardTypeDefine")||(myItemName == "PayMode")||(myItemName == "CredType")||(myItemName == "ForeignCredType")){
							if (myItemName=="ForeignCredType"){
								debugger;
							}
							var Data=_$id.combobox("getData");
							for (var m=0;m<Data.length;m++){
								var id=Data[m]["id"];
								if (myItemValue==id.split("^")[0]){
									_$id.combobox("select",id);
									break;
								}
							}
						}else if(myItemName=="IEType"){
							if (myItemValue!=""){
								_$id.combobox("select",myItemValue);
							}
						}else{
							_$id.combobox("select",myItemValue);
						}
					}
				}
			}else{
				if(typeof getMessageByIdCard!="undefined"){
				  if(myItemName=="InMedicare"){
					oldPersonMessageFromIDCard.InMedicare=myItemValue
				  }
				  if(myItemName=="Name"){
					oldPersonMessageFromIDCard.Name=myItemValue
				  }
				  if(myItemName=="CredNo"){
					oldPersonMessageFromIDCard.CredNo=myItemValue
				  }	
				}else{
					if ((PageLogicObj.m_IsNotStructAddress=="Y")&&((myItemName=="Address")||(myItemName=="RegisterPlace"))){
						 _$id.combobox("setText",myItemValue);
			        }else{
				        _$id.val(myItemValue);
				    }
				}
				if ((myItemName=="InMedicare")&&(myItemValue!="")){
				  	$("#InMedicare").attr("disabled",true);
				}else if((myItemName=="InMedicare")&&(myItemValue=="")&&(PageLogicObj.m_MedicalFlag == 1)){
				  	$("#InMedicare").attr("disabled",false);
				}
			}
		}
	}
	delete(xmlDoc);
	//地址字段联动(国家,省份,城市)
	for (var Item in AddressObj) {
		if (Item==="AdrDesc") {
			$("#CountryHouse").combobox("select",AddressObj[Item].Country);
			$("#ProvinceInfoLookUpRowID").combobox("select",AddressObj[Item].Province);
			$("#CityDescLookUpRowID").combobox("select",AddressObj[Item].City);
			$("#CityAreaLookUpRowID").combobox("select",AddressObj[Item].Area);
		}else if (Item==="AdrHouse") {
			$("#CountryDescLookUpRowID").combobox("select",AddressObj[Item].Country);
			$("#ProvinceHouse").combobox("select",AddressObj[Item].Province);
			$("#Cityhouse").combobox("select",AddressObj[Item].City); 
			$("#AreaHouse").combobox("select",AddressObj[Item].Area);
		}else if (Item==="AdrBirth") {
			$("#CountryBirth").combobox("select",AddressObj[Item].Country);
			$("#ProvinceBirth").combobox("select",AddressObj[Item].Province);
			$("#CityBirth").combobox("select",AddressObj[Item].City); 
			$("#AreaBirth").combobox("select",AddressObj[Item].Area);
		}else if (Item==="AdrHome") {
			$("#CountryHome").combobox("select",AddressObj[Item].Country);
			$("#ProvinceHome").combobox("select",AddressObj[Item].Province);
			$("#CityHome").combobox("select",AddressObj[Item].City);
		}
	}
	if(typeof getMessageByIdCard!="undefined"){
		return;
	}
	oldPersonMessage.push($("#Name").val(),$("#CredNo").val(),$("#InMedicare").val(),$("#PatType").combobox("getText"));
	if(typeof CheckFlag!="undefined"){
		//读证件建卡时，姓名、出生日期、证件号、民族、性别信息不能修改，以读出信息为准。
		$("#Name").attr("disabled",true);  
		$("#Birth").attr("disabled",true); 
		$('#NationDescLookUpRowID').combobox('disable');
		$("#CredNo").attr("disabled",true); 
		$('#Sex').combobox('disable');
	}else{
		$("#Name").attr("disabled",false);  
		$("#Birth").attr("disabled",false); 
		$('#NationDescLookUpRowID').combobox('enable');
		$("#CredNo").attr("disabled",false); 
		$('#Sex').combobox('enable');
	}
}
///判断是否要使用APP患者录入的建大病历的暂存信息,如果使用则输出XML，调用SetPatInfoByXML方法完成页面赋值
///支持传入病人Rowid 或 病人登记号，传一个即可
function GetRegMedicalEPMI(PAPMIRowID,PAPMINo) {
	if ((PAPMIRowID=="")&&(PAPMINo=="")) return "";
	var ret=$.cm({
		ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
		MethodName:"IsNeedRegMedicalEPMI",
		dataType:"text",
		PAPMIRowID:PAPMIRowID,
		PAPMINo:PAPMINo
	},false);
	if (ret.split('^')[0]=="1") {
		var PAPMINo=ret.split('^')[1];
		var conFlag=confirm("患者没有病案号且已经在手机APP上注册了大病历信息，是否载入？");
		if (conFlag) {
			var ExpStr="^1"
			var PAPMIXMLStr=$.cm({
				ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
				MethodName:"GetPatInfoByPANo",
				dataType:"text",
				PAPMINo:PAPMINo,
				ExpStr:"^1"
			},false);
			if (PAPMIXMLStr.split('^')[0]=="0") return PAPMIXMLStr.split('^')[1];
		}
	}
	return "";
}
function SearchSamePatient() {
	var name = "",
	sex = "",
	birth = "",
	CredNo = "";
	PatYBCode="";
	var name = $('#Name').val();
	var sex = $("#Sex").combobox("getValue");
	var birth = $('#Birth').val();
	var CredNo = $("#CredNo").val();
	var PatYBCode=$("#PatYBCode").val();
	var InMedicare=$("#InMedicare").val();
	if (name == "" && ((CredNo == "")&&(PatYBCode=="")&&(InMedicare==""))) return false;
	var Age = $("#Age").val();
	var ArgValue=name+"^"+birth+"^"+CredNo+"^"+sex+"^"+Age+"^"+PatYBCode+"^"+InMedicare;
	if (PageLogicObj.m_CurSearchValue==ArgValue) return false;
	PageLogicObj.m_CurSearchValue=ArgValue;
	var myval=$("#CredType").combobox("getValue");
	var myary = myval.split("^");
	var CredTypeID=myary[0];
	if (CredNo=="") CredTypeID="";
	name=DHCC_CharTransAsc(name);
	$.cm({
	    ClassName : "web.DHCPATCardUnite",
	    QueryName : "PatientCardQuery",
	    Name:name,CredNo:CredNo,BirthDay:birth,Sex:sex,UserID:"",TPAGCNTX:"",
	    PatYBCode:PatYBCode,Age:Age,InMedicare:InMedicare,CredTypeID:CredTypeID,
	    Pagerows:PageLogicObj.m_FindPatListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_FindPatListTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitFindPatListTabDataGrid(){
	var Columns=[[ 
		{field:'TPatientID',hidden:true,title:''},
		{field:'Name',title:'姓名',width:100},
		{field:'CardNO',title:'卡号',width:200,
			formatter: function(value,row,index){
				return value.replace("\\u"," ")
			}
		},
		{field:'Sex',title:'性别',width:50},
		{field:'Birthday',title:'出生日期',width:140},
		{field:'CredTypeDesc',title:'证件类型',width:100},
		{field:'CredNo',title:'证件号码',width:165},
		{field:'RegNo',title:'登记号',width:120},
		{field:'PatType',title:'患者类型',width:90},
		{field:'Telphone',title:'电话',width:100},
		{field:'NewInMedicare',title:'病历号',width:90},
		{field:'Company',title:'单位',width:150},
		{field:'Adress',title:'地址(现住)',width:150},
		{field:'ContactPerson',title:'联系人',width:90},
		{field:'PatYBCode',title:'医保卡号',width:90},
		{field:'MobPhone',title:'手机',width:100},
		{field:'myOtherStr',title:'',hidden:true},
		{field:'EmployeeNo',title:'',hidden:true},
		{field:'IDCardNo',title:'',hidden:true},
		{field:'CardID',title:'',hidden:true},
		{field:'TCreateDate',title:'',hidden:true},
		{field:'TCreateUser',title:'',hidden:true},
		{field:'OtherCardNo',title:'',hidden:true}
    ]]
	var FindPatListTabDataGrid=$("#FindPatListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CardID',
		columns :Columns,
		onDblClickRow:function(index, row){
			CardSearchDBClickHander(row);
		}
	}); 
	FindPatListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return FindPatListTabDataGrid;
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行        
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	if (opts.pageNumber==0){opts.pageNumber=1}
	if (opts.pagination){
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		if ((start+1)>data.originalRows.length){
			//取现有行数最近的整页起始值
			start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
			opts.pageNumber=(start/opts.pageSize)+1;
		}
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
	}
	if (data.rows) {
		for (var i = 0; i < data.rows.length; i++) {
			var myOtherStr=data.rows[i].myOtherStr;
			data.rows[i].Sex = myOtherStr.split("^")[4];
			data.rows[i].Birthday = myOtherStr.split("^")[1];
			data.rows[i].RegNo = myOtherStr.split("^")[6];
			data.rows[i].PatType = myOtherStr.split("^")[5];
			data.rows[i].Telphone = myOtherStr.split("^")[0];
			data.rows[i].TPatType = myOtherStr.split("^")[5];
			data.rows[i].NewInMedicare = myOtherStr.split("^")[7];
			data.rows[i].Company = myOtherStr.split("^")[3];
			data.rows[i].Adress = myOtherStr.split("^")[2];
			data.rows[i].ContactPerson = myOtherStr.split("^")[13];
			data.rows[i].PatYBCode = myOtherStr.split("^")[16];
			data.rows[i].MobPhone = myOtherStr.split("^")[17];
		}
	}
	return data;
}
function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	if (ServerObj.dtformat=="YMD"){
		Str=Birth.split("-")
		Year=Str[0];
		Mon=Str[1];
		Day=Str[2];
	}
	if (ServerObj.dtformat=="DMY"){
		Str=Birth.split("/")
		Year=Str[2];
		Mon=Str[1];
		Day=Str[0];
	}
	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	ToYear=Today.getFullYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)||(Year<=1840)){
		return false;
	}else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}else {
		return true;
	}
}
function IsValidTime(fld) {
	 var TIMER=0;
	 var tm=fld.value;
	 var re = /^(\s)+/ ; tm=tm.replace(re,'');
	 var re = /(\s)+$/ ; tm=tm.replace(re,'');
	 var re = /(\s){2,}/g ; tm=tm.replace(re,' ');
	 tm=tm.toUpperCase();
	 var x=tm.indexOf(' AM');
	 if (x==-1) x=tm.indexOf(' PM');
	 if (x!=-1) tm=tm.substring(0,x)+tm.substr(x+1);
	 if (tm=='') {fld.value=''; return 1;}
	 re = /[^0-9A-Za-z]/g ;
	 tm=tm.replace(re,':');
	 if (isNaN(tm.charAt(0))) return ConvNTime(fld);
	 if ((tm.indexOf(':')==-1)&&(tm.length>2)) tm=ConvertNoDelimTime(tm);
	 symIdx=tm.indexOf('PM');
	 if (symIdx==-1) {
		  symIdx=tm.indexOf('AM');
		  if (symIdx!=-1) {
			   if (tm.slice(symIdx)!='AM') return 0;
			   else {
				    tm=tm.slice(0,symIdx);
				    TIMER=1;
			   }
		  }
	 }else {
		  if (tm.slice(symIdx)!='PM') return 0;
		  else {
		   tm=tm.slice(0,symIdx);
		   TIMER=2;
		  }
	 }
	 if (tm=='') return 0;
	 var tmArr=tm.split(':');
	 var len=tmArr.length;
	 if (len>3) return 0;
	 for (i=0; i<len; i++) {
	  	if (tmArr[i]=='') return 0;
	 }
	 var hr=tmArr[0];
	 var mn=tmArr[1];
	 var sc=tmArr[2];
	 if (len==1) {
		  mn=0;
		  sc=0;
	 } else if (len==2) {
		  if (mn.length!=2) return 0;
		  sc=0;
	 } else if (len==3) {
		  if (mn.length!=2) return 0;
		  if (sc.length!=2) return 0;
	 }
	 if ((hr>12)&&(TIMER==1)) return 0;
	 if ((hr==12)&&(TIMER==1)) hr=0;
	 if ( isNaN(hr)||isNaN(mn)||isNaN(sc) ) return 0;
	 hr=parseInt(hr,10);
	 mn=parseInt(mn,10);
	 sc=parseInt(sc,10);
	 if ((hr>23)||(hr<0)||(mn>59)||(mn<0)||(sc>59)||(sc<0)) return 0;
	 if ((hr<12)&&(TIMER==2)) hr+=12;
	 fld.value=ReWriteTime(hr,mn,sc);
	 websys_returnEvent();
	 return 1;
}
function ReWriteTime(h,m,s) {
	 var newtime='';
	 if (h<10) h='0'+h;
	 if (m<10) m='0'+m;
	 if (s<10) s='0'+s;
	 if (PageLogicObj.m_tmformat=='HMS'){newtime=h+':'+m+':'+s ;}
	 if (PageLogicObj.m_tmformat=='HM'){newtime=h+':'+m ;}
	 return newtime;
}
function ConvNTime(fld) {
	 var now=new Date();
	 var tm=fld.value;
	 var re = /(\s)+/g ;
	 tm=tm.replace(re,'');
	 if (tm.charAt(0).toUpperCase()=='N') {
		  xmin = tm.slice(2);
		  if (xmin=='') xmin=0;
		  if (isNaN(xmin)) return 0;
		  xmin_ms = xmin * 60 * 1000;
		  if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
		  else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
		  else if (tm.length>1) return 0;
		  fld.value=ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
		  websys_returnEvent();
		  return 1;
	 }
	 return 0;
}
function PayModeOnChange(){
	var myoptval=$("#PayMode").combobox("getValue");
	var myary=myoptval.split("^");
	if (myary[2]=="Y"){
		SetPayInfoStatus(false);
	}else{
		SetPayInfoStatus(true);
	}
}
function SetPayInfoStatus(SFlag)
{
	$("#PayCompany,#CardChequeNo,#ChequeDate,#PayAccNo").attr("disabled",SFlag);
	if (SFlag){
		$('#Bank,#BankCardType').combobox('disable');
	}else{
		$('#Bank,#BankCardType').combobox('enable');
	}
	//Remark
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CredNoOnChange(){
	var myrtn=IsCredTypeID();
	var CredNo=$("#CredNo").val();
	if (myrtn){
		$("#IDCardNo1").val(CredNo);
	}
	if (!myrtn){
		$("#IDCardNo1").val("");
	}
}
function IsCredTypeID()
{
	var myval=$("#CredType").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==PageLogicObj.m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}
function ForeignIDCardOnKeyPress()
{
	var myval=$("#ForeignCredType").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==PageLogicObj.m_IDCredTypePlate){
		var mypId = $("#ForeignIDCard").val();
		mypId=mypId.toUpperCase();
		$("#ForeignIDCard").val(mypId);
		if (mypId!=""){
			var myary=DHCWeb_GetInfoFromId(mypId);
			if (myary[0]=="1"){
				return true;
			}
			else{
				$("#ForeignIDCard").focus();
				return false;
			}
		}	
	}
	return true
}
function CredNoOnKeyPress()
{
	var winEvent=window.event;
	var mykey=winEvent.keyCode;
	if (mykey==13){
		var myrtn=IsCredTypeID();
		if (myrtn){
			var mypId = $("#CredNo").val();
			mypId=mypId.toUpperCase();
			$("#CredNo").val(mypId);
			var RtnStr=$.cm({
				ClassName:"web.DHCRBAppointment",
				MethodName:"GetAppedCommomInfo",
				dataType:"text",
				CredNo:mypId
			},false);
		    var FindAppFlag=RtnStr.split("^")[0];
		    if (FindAppFlag=="1"){
			    var LastAppedInfo=RtnStr.split("^")[1];
			    var LastAppendName=LastAppedInfo.split("$")[0];
			    var LastAppenTelH=LastAppedInfo.split("$")[1];
			    var DifferenceAppInfo=RtnStr.split("^")[2];
			    if (DifferenceAppInfo!=""){
				    $.messager.confirm('确认对话框',"此身份证号存在以下有效的公共卡预约预留信息:\n姓名:"+LastAppendName+"  电话:"+LastAppenTelH+"(最后一次预留信息)\n"+DifferenceAppInfo+"\n是否取最后一次的预留信息?", function(r){
						if (r){
						    $("#Name").val(LastAppendName);
					    	$("#TelHome").val(LastAppenTelH);
						}
					});
				}else{
					$.messager.confirm('确认对话框',"此身份证号存在有效的公共卡预约预留信息:\n姓名:"+LastAppendName+"  电话:"+LastAppenTelH+"\n是否带入预约预留信息?", function(r){
						if (r){
							$("#Name").val(LastAppendName);
					    	$("#TelHome").val(LastAppenTelH);
						}
					});
				}
			}
			if (mypId!=""){
				setBirthAndSex(mypId);
			}
		}
		CredNoOnChange();
		var myIDNo=$("#IDCardNo1").val();
		var myval=$("#CredType").combobox("getValue");
		var myCredTypeDR = myval.split("^")[0];
		var myCredNo=$("#CredNo").val();
		var myval=$("#CardTypeDefine").combobox("getValue");
		var myCardTypeDR = myval.split("^")[0];
		var myValidateMode=myval.split("^")[30];
		if (myValidateMode=="IDU"){
			if ((myIDNo!="")||(myCredNo!="")){
				var myInfo=$.cm({
					ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
					MethodName:"ReadConfigByIDU",
					dataType:"text",
					IDNo:myIDNo,
					CredTypeDR:myCredTypeDR,
					CredNo:myCredNo,
					CardTypeDR:myCardTypeDR
				},false);
				var myary=myInfo.split(String.fromCharCode(1));
				switch (myary[0]){
					case "0":
						break;
					case "-368":
						PageLogicObj.m_RegCardConfigXmlData=myary[1];
						var myPatInfoXmlData=myary[2];
						var myRepairFlag=myary[3];
						// myRepairFlag 为卡类型配置的"数据类型转换验证",用于控制被赋值的元素是否可再编辑
						if (myRepairFlag=="Y"){
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						}else{
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						}
						GetPatDetailByPAPMINo();
						SetPatRegCardDefaultConfigValue(myary[4]);
						break;
					case "-365":
						$.messager.alert('提示','此证件号码已经存在,请办理其他卡或办理补卡!');
						break;
					default:
						$.messager.alert('提示',"" + " Err Code="+myary[0]);
						break;
				}
				
			}
		}
	}
}
function SetPatInfoModeByXML(XMLStr, Mode)
{
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) { 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		var _$id=$("#"+myItemName);
		if (_$id.length>0){
			//if (_$id.hasClass("hisui-combobox")){
			if (_$id.next().hasClass('combo')){
				if (Mode){
					$('#NationDescLookUpRowID').combobox('disable');
				}else{
					$('#NationDescLookUpRowID').combobox('enable');
				}
				_$id.combobox("select",myItemValue);
			}else{
				_$id.attr("disabled",Mode);
			}
		}
	}
	delete(xmlDoc);
	//关联建卡使用登记号作为卡号，验证卡号的有效性
	CheckForUsePANoToCardNO("New");
}
//验证使用登记号作有没有为卡号时候登记号作为卡号有没有被使用
function CheckForUsePANoToCardNO(Type)
{
	var PAPMINO=$("#PAPMINo").val();
	if (PageLogicObj.m_UsePANoToCardNO=="Y"){
		 if (PAPMINO!=""){
			 $("#CardNo").val(PAPMINO);
			 var myPAPMIStr=$.cm({
				ClassName:"web.DHCBL.CARD.UCardRefInfo",
				MethodName:"GetPAPMIInfoByCardNo",
				dataType:"text",
				CardNo:PAPMINO,
				CardType:PageLogicObj.m_SelectCardTypeRowID
			 },false);
			 if (myPAPMIStr!=""){
					if (Type=="New"){
						$.messager.alert('提示',"该登记号已经作为卡号存在,不能再次使用建卡!","info",function(){
						});
					}
					$("#CardNo").val("");
					DisableBtn("NewCard",true);
			 }else{
					DisableBtn("NewCard",false);
			 }
		 }else{
			 DisableBtn("NewCard",false);
		 }
				
	}
}
function SetPatRegCardDefaultConfigValue(Value){
	var myary=Value.split("^");
	PageLogicObj.m_PatMasFlag= myary[1];
	PageLogicObj.m_CardRefFlag=myary[2];
	PageLogicObj.m_AccManagerFlag=myary[3];
	PageLogicObj.m_SetCardReferFlag=myary[4];
}
function Clearclick(){ 
	SetUIDefaultValue();
	$(".newclsInvalid").removeClass("newclsInvalid");
	$("#PatYBCode,#ChequeDate,#PatPaySum,#OtherCardInfo").val("");
	$("#PAPERMarital,#Bank,#BankCardType").combobox('select','');
	DisableBtn("NewCard",true);
	PageLogicObj.m_FindPatListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });
	PageLogicObj.m_CurSearchValue=""; 
	$("#CredType,#ForeignCredType").combobox('select',PageLogicObj.m_CredTypeDef);
}
function SetUIDefaultValue()
{
	InitPatRegConfig();
	$("#OpMedicare,#InMedicare").attr("disabled",true);
	IDReadControlDisable(false);
	CardTypeKeydownHandler();
	var src="../images/uiimages/patdefault.png";
	ShowPicBySrcNew(src,"imgPic");
}
function IDReadControlDisable(bFlag)
{
	$("#CredNo,#Name,#Birth,#Age").attr("disabled",bFlag);
	if (bFlag){
		$('#Sex,#NationDescLookUpRowID').combobox('disable');
	}else{
		$('#Sex,#NationDescLookUpRowID').combobox('enable');
	}
	//地址 有结构化地址 todo
	//var myobj=document.getElementById("Address");
}
function GetValidatePatbyCard()
{
	var myCardNo=$("#CardNo").val();
	if (myCardNo=="") {
		$.messager.alert('提示',"卡号不能为空!");
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.DHCBL.CARDIF.ICardRefInfo",
		MethodName:"ReadPatValidateInfoByCardNo",
		dataType:"text",
		CardNO:myCardNo,
		SecurityNo:PageLogicObj.m_CardVerify,CardTypeDR:PageLogicObj.m_SelectCardTypeRowID,
		ExpStr:""
	},false);
	var myary=rtn.split("^");
	if (rtn=="") return;
	if (myary[0]=='0'){
		//InitPatRegConfig();
		$("#CardNo").val(myCardNo);
		var myXMLStr=myary[1];
		SetPatInfoByXML(myXMLStr);
		DisableBtn("NewCard",false);
		if (PageLogicObj.m_SetRCardFocusElement!=""){
			$("#"+PageLogicObj.m_SetRCardFocusElement).focus();
		}
	}else{
		switch(myary[0]){
		case "-341": //已经建卡
			//经过讨论如果已经建卡的不带出已有信息
			var CardNo=$("#CardNo").val();
		    //IntListItemNew();
		    //InitTextItem();
		    //IntHelpControlNew();
		    var myPAPMIStr=$.cm({
				ClassName:"web.DHCBL.CARD.UCardRefInfo",
				MethodName:"GetPAPMIInfoByCardNo",
				dataType:"text",
				CardNo:myCardNo,
				CardType:PageLogicObj.m_SelectCardTypeRowID
			},false);
			if (myPAPMIStr!="") {
				$("#PAPMINo").val(myPAPMIStr.split("^")[1]);
				$("#PAPMIRowID").val(myPAPMIStr.split("^")[0]);
				$("#CardNo").val("");
				GetPatDetailByPAPMINo();
				SearchSamePatient();
			}
			CardTypeKeydownHandler();
			if (PageLogicObj.m_MedicalFlag == 1) {
				var flag = ValidateRegInfoByCQU(myary[2]);
				if (flag) {
					DisableBtn("NewCard",false);
					return true;
				}
			}
			$.messager.alert('提示',"此卡号已经存在,不能发卡!");
			break;
		case "-340":
			$.messager.alert('提示',"此卡没有对应的病人信息!");
			break;
		case "-350":
			$.messager.alert('提示',"此卡已经使用,不能重复发卡!");
			break;
		case "-351":
			var CancelInfo=$.cm({
				ClassName:"web.UDHCAccManageCLS7",
				MethodName:"GetCancenlInfo",
				dataType:"text",
				cardno:myCardNo,
				CardTypeDR:PageLogicObj.m_SelectCardTypeRowID
			},false);
			$.messager.alert('提示',"此卡已经被挂失,不能使用,挂失人:"+CancelInfo.split("^")[0]+",挂失原因:"+CancelInfo.split("^")[1]);
			break;
		case "-352":
			$.messager.alert('提示',"此卡已经被作废,不能使用!");
			break;
		case "-356":
			$.messager.alert('提示',"发卡时,配置要求新增卡记录,但是此卡数据被预先生成错误!");
			break;
		case "-357":
			$.messager.alert('提示',"发卡时,配置要求更新卡记录,但是此卡数据没有预先生成!");
			break;
		case "-358":
			$.messager.alert('提示',"发卡时,此卡已经有对应的登记号了,不能再新增!");
			break;
		default:
			$.messager.alert('提示',"Error Code:" +myary[0]);
			break;
		}
		DisableBtn("NewCard",true);
	}
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function ReadRegInfoOnClick(){
	var myHCTypeDR=$("#IEType").combobox("getValue");
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		SetPatInfoByXML(myary[1]);
		var CredNo=$("#CredNo").val();
		//renyx 解决社保卡性别返回值的不同
		var mySex=$("#Sex").combobox("getValue");
		var CardNo=$("#CardNo").val()
		if((mySex==3) && (CardNo.length==9)){
			var num=CredNo.substring(16,17);
			if (num%2==0){
				$("#Sex").combobox("select",2);
			}else{
				$("#Sex").combobox("select",1);
			}
		}
		$("#IDCardNo1").val(CredNo);
		$("#CardNo").val("");
		//SetIDCredType();
		IDReadControlDisable(true);
		BirthOnBlur();
	}
	//使用读取得照片数据文件
	//renyx 去除照片加载
	/*
	var PhotoInfo=$("#PhotoInfo").val();
	if (PhotoInfo!=""){
		var src="data:image/png;base64,"+PhotoInfo;
	}else{
		var src='c://'+$("#CredNo").val()+".bmp"
	}
	ShowPicBySrcNew(src,"imgPic");*/
}
function NewCardclick(){
	if ($("#NewCard").hasClass('l-btn-disabled')){
		return false;
	}
	//$("")
	SaveDataToServer();
	return;
}
function BModifyInfoclick(){
	var PAPMIRowID=$("#PAPMIRowID").val();
	if(PAPMIRowID==""){
		$.messager.alert("提示","请先选择病人记录,再更新!");
		return false;
	}  
	PageLogicObj.m_MedicalFlag=1;
	PageLogicObj.m_ModifiedFlag=1;
	//患者证件类型为身份证时，验证身份证号是否已经存在患者信息，如果存在则不能更新
	var myExpstr="";
	var myIDrtn=IsCredTypeID();
	if (myIDrtn){
		var CredNo=$("#CredNo").val();
		if (CredNo!=""){
			myExpstr=CredNo;
		}
	}
	var myPAPMINo=$('#PAPMINo').val();
	if (myExpstr!=""){
		var myPatInfo=$.cm({
			ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName:"GetPatInfoByPANo",
			dataType:"text",
			PAPMINo:"", ExpStr:myExpstr
		},false);
		var myary=myPatInfo.split("^");
        if (myary[0]=="0"){
			var myXMLStr=myary[1];
			var PAPMIRowID=$("#PAPMIRowID").val();
			var PatientID=myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
			if ((PatientID!="")&&(PatientID!=PAPMIRowID)){
			   $.messager.alert("提示","此身份证已经被使用!","info",function(){
				   $("#CredNo").focus();
			   })
	           return false;
			}
		}
	}
	SaveDataToServer();
	PageLogicObj.m_MedicalFlag=0;
	PageLogicObj.m_ModifiedFlag=0;
}
function checkPatYBCode()
{
	var PatYBCode=$('#PatYBCode').val();
    var myPatType=$("#PatType").combobox("getValue");
    myPatType=CheckComboxSelData("PatType",myPatType);
	if ((myPatType=="")||(myPatType==undefined)) {
		$.messager.alert("提示","请选择病人类型！","info",function(){
			$('#PatType').next('span').find('input').focus();
		});
		return false;
	}
	var PatypeDrArray=myPatType.split("^");
	var PatypeDr=PatypeDrArray[0];
	var rtn=$.cm({
		ClassName:"web.DHCBL.CARD.UCardRefInfo",
		MethodName:"GetInsurFlag",
		dataType:"text",
		PatypeDr:PatypeDr
	},false);
	if ((rtn==0)&&(PatYBCode!="")) {
		$.messager.alert("提示","非医保病人,医保卡号不可填!","info",function(){
			$("#PatYBCode").focus();
		})
		return false;
	}
	if((rtn!=0)&&(PatYBCode=="")) {
		$.messager.alert("提示","医保病人,请填写正确的医保卡号","info",function(){
			$("#PatYBCode").focus();
		})
		return false;
	}
	return true;
}
function SaveDataToServer(){
	//根据配置来验证 界面数据是否完整 ,这个需要单独来写
	//配置需要传递到 Cache端的数据串
	//调用Cache函数
	//分别调用打印程序
	//1.如果卡需要收费, 是否打印发票,或者打印小条(热敏条)
	//2.如果有预交金是否需要打印小条;
	//3.根据卡类型是否打印条形码
	if (!CheckData()){
		return false;
	}
	DisableBtn("NewCard",true);
	///配置需要传递到 Cache端的数据串
	var myPatInfo=GetPatMasInfo();
	var myCardInfo=GetCardRefInfo();
	var myCardInvInfo=GetCardINVInfo();
	var myAccInfo=GetAccManagerInfo();
	var myAccDepInfo=GetPreDepositeInfo();
	var mySecrityNo="";
	var CardNo = $("#CardNo").val();
	if(CardNo.length=="18"||CardNo.length=="9"){
		PageLogicObj.m_OverWriteFlag="N"
	}
	//如果是修改病人基本信息不再设置写卡。
	if (PageLogicObj.m_MedicalFlag!="1"){
		if (PageLogicObj.m_CardRefFlag=="Y"){
			if (PageLogicObj.m_OverWriteFlag=="Y"){
				///设置写卡
				var myrtn=WrtCard();
				var myary=myrtn.split("^");
				if (myary[0]!="0"){
					DisableBtn("NewCard",false);
					return false;
				}
				var mySecrityNo=myary[1];
			}else{
				var mySecrityNo = PageLogicObj.m_CardSecrityNo;
			}
		}
	}
	var Password="000000";
	if (PageLogicObj.m_AccManagerFlag=="Y"){
		var myDefaultPWDFlag=$("#SetDefaultPassword").checkbox('getValue');
		if (myDefaultPWDFlag){	
			var ren=DHCACC_GetValidatePWD(Password);
			var myary=ren.split("^");
			if (myary[0]=='0'){ 
				 Password=myary[1];
			}else{
				$.messager.alert("提示","设置密码失败!");
				DisableBtn("NewCard",false);
				return false;
			}
		}else{
			var ren=DHCACC_SetAccPWD();
			var myary=ren.split("^");
			if (myary[0]=='0'){ 
				 Password=myary[1];
			}else{
				$.messager.alert("提示","设置密码失败!");
				DisableBtn("NewCard",false);
				return false;
			}
		}
	}
	//var SucessPrtStr=""
	//var PayMode=$("PayMode").combobox("getValue");
	/*if((PayMode=="44")||(PayMode=="45")){
				var prtRowIDAry = myPRTStr.split("^");
				var mypayPRTStr = prtRowIDAry.join("!");
				var OPPatobj = parent.frames["udhcOPPatinfo"].document.getElementById("PARowid");
				var ExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + OPPatobj.value + "^" + "" + "^" + mypayPRTStr+"^^C";
				var PayCenterRtn = PayService("OP", PayMode, "", ExpStr);
				if (PayCenterRtn.ResultCode != 0) {
					alert("支付失败");
					return;
				}
				SucessPrtStr = PayCenterRtn.ETPRowID;
			}*/
			//Service end

	var myPopulationClass=$("#PopulationClass").combobox("getValue")+"@"+$("#PopulationClass").combobox("getText")
	var myConfigInfo = PageLogicObj.m_RegCardConfigXmlData;
	var mySpecInfo=mySecrityNo;
	mySpecInfo += "^"+Password;
	var myExpStr="";
	var myExpStr = PageLogicObj.m_MedicalFlag+"^"+PageLogicObj.m_UsePANoToCardNO+"^"+session['LOGON.HOSPID']+"^"+myPopulationClass;
	var rtn=$.cm({
		ClassName:"web.DHCBL.CARDIF.ICardRefInfo",
		MethodName:"SavePCAInfoToServer",
		dataType:"text",
		ConfigInfo:myConfigInfo,
		PaPatInfo:myPatInfo,
		CardInfo:myCardInfo,
		AccInfo:myAccInfo,
		DepositInfo:myAccDepInfo,
		CardINVInfo:myCardInvInfo,
		SepcialInfo:mySpecInfo,
		ExpStr:myExpStr
	},false);
	var myary=rtn.split(String.fromCharCode(1));
	if (myary[0]=='0'){
		var IBPRowId = "",SavePaySumFalg=0; 
		var PayModeid=$("#PayMode").combobox("getValue").split("^")[0];
		//alert(myary[8]+"    "+PayModeid)
		if(((PayModeid=="44")||(PayModeid=="45")||(PayModeid=="69")||(PayModeid=="70"))&&(myary[4]!="")){
			var ExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^"+myary[4]+"^^^^C";
			//alert(parseFloat($("#amt").val()))
			//SavePaySumFalg=1
			var payBillSum=parseFloat($("#amt").val())
			var PayCenterRtn = PayService("PRE", PayModeid, payBillSum, ExpStr);
			if (PayCenterRtn.ResultCode != 0) {
				SavePaySumFalg=1
				$.messager.alert("提示","扫码付支付失败支付失败");
				//return;
			} else {
				IBPRowId = PayCenterRtn.ETPRowID;
				
			}
		}
		if ((myary[4]=="")) SavePaySumFalg=1; 
            //预交金信息
            if (SavePaySumFalg==0){
            var CardSaveAccRtn=$.cm({
                ClassName:"web.DHCBL.CARD.UCardPatRegBuilder",
                MethodName:"CardSaveAccMInfo",
                dataType:"text",
                PAPMIRowID:myary[4],
                CardRefInfo:myary[5],
                CardInfo:myCardInfo,
                CardINVInfo:myCardInvInfo,
                ConfigInfo:myConfigInfo,
                AccInfoDr:myary[8],
                DepositInfo:myAccDepInfo,
                ExpStr:myExpStr
            },false);
            //alert(CardSaveAccRtn+"   "+SavePaySumFalg);
            if (CardSaveAccRtn.split("^")[0]!="0"){
                $.messager.alert("提示","预交金收取失败!");
            }else{
                myary[2]=CardSaveAccRtn.split("^")[1];
            }
            if ((CardSaveAccRtn.split("^")[0]=="0")&&(IBPRowId != "")){
                var linkRtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", IBPRowId, myary[2],"PRE");
                
            }
		}
		
		////根据配置设置打印
		////发卡时收费票据打印的RowID
		if (myary[1]!=""){
		   var myCardCost=$("#CardFareCost").val();
		   var myCardCost=parseFloat(myCardCost)             //转化正数字类型
		   if ((myCardCost>0)&&(myCardCost!="")){
			  PatRegPatInfoPrint(myary[1],PageLogicObj.m_CardINVPrtXMLName,"ReadCardINVEncrypt");
		   }
		}
		////预交金RowID
		var myAmtValue=$("#amt").val();
		if ((myAmtValue>0)&&(myary[2]!="")){
			//Add Version Contral
			var myVersion=ServerObj.ConfigVersion;
			switch(myVersion){
				case "1":
					var mystr=rtn+"^";
					Print_Click(mystr);
					break;
				default:
					PatRegPatInfoPrint(myary[2],PageLogicObj.m_PrtXMLName,"ReadAccDPEncrypt");
				}
		}
		////打印条形码等
		if (myary[3]!=""){}
		///打印首页
		if (myary[4]!=""){
			PatRegPatInfoPrint(myary[4],PageLogicObj.m_PatPageXMLName,"ReadFirstPageEncrypt");
		}
		// 上传身份证照片到服务器 Start
		/*
			ChangeStrToPhotoNew(myary[4],mycredobj.value);
		*/
		// 上传身份证照片到服务器 End
		if (PageLogicObj.m_ModifiedFlag==1){
			$.messager.alert("提示","信息修改成功!");
			PageLogicObj.m_CurSearchValue="";  
			SearchSamePatient()
			return;
		}else if (PageLogicObj.m_MedicalFlag==1){
			$.messager.alert("提示","建病历成功!");
			return;
		}
		$.messager.alert("提示","建卡成功!","info",function(){
			//使用后台返回的卡号和登记号处理界面值，如果是登记号作为卡号的打印登记号
			var CardNo=$("#CardNo").val();
			if (CardNo==""){
				$("#CardNo").val(myary[7]);
			}
			var PAPMINo=$("#PAPMINo").val();
			if (PAPMINo==""){
				$("#PAPMINo").val(myary[6]);
			}
			if (PageLogicObj.m_UsePANoToCardNO=="Y"){
				PatInfoPrint("PAPMINo");
			}
			if ((window.parent)&&(window.parent.SetPassCardNo)){
				if (PageLogicObj.m_UsePANoToCardNO=="Y"){
					window.parent.SetPassCardNo(myary[6]);
				}else{
					window.parent.SetPassCardNo(CardNo);
				}
				window.parent.destroyDialog("CardReg");
				return;
			}
			/*var par_win = parent.window.opener;
			if (par_win){
				var CardNo=$("#CardNo").val();
				try{
					if ((par_win)&&(CardNo!='')){
						par_win.SetPassCardNo(CardNo,PageLogicObj.m_SelectCardTypeRowID);
					}
				}catch(e){}
				window.setTimeout("parent.window.close();",500);
	 		    return;
			}*/
			Clearclick();
			DisableBtn("NewCard",false);
		});
	}else if (myary[0]=='-302'){
		$.messager.alert("提示","此病人已经有正常的卡了,不能发卡!");
	}else if (myary[0]=='-303'){
		$.messager.alert("提示","卡号不能为空,请读卡!");
	}else if (myary[0]=='-304'){
		$.messager.alert("提示","此卡号已经存在,不能发卡!");
	}else if(myary[0]=='-365'){
		$.messager.alert("提示","此证件号码已经存在,请办理其他卡或办理补卡!");
	}else if(myary[0]=='-366'){
		$.messager.alert("提示","请选择卡类型!");
	}else if(myary[0]=='-367'){
		$.messager.alert("提示","证件号码不能为空!");
	}else if(myary[0]=='-369'){
		$.messager.alert("提示","办理卡绑定时,获取患者信息错误!");
	}else if(myary[0]=='-364'){
		$.messager.alert("提示","已经存在此卡类型下的有效卡,不允许再发!");
	}else if(myary[0]=='-341'){
		$.messager.alert("提示","此卡已经建卡,不能重复发卡!");
	}else{
		$.messager.alert("提示","Error Code: "+myary[0]+"  保存数据失败!");
	}
	if (myary[0]!='0'){
		DisableBtn("NewCard",false);
	}
}
function CardNokeydown(e){
	var key=websys_getKey(e);
	if (key==13){
		if(!SetCardNOLength()) return false;
		PageLogicObj.m_CardVerify="";
		GetValidatePatbyCard();
	}
}
function PatPaySumKeyPress(e){
	var key=event.keyCode;
	if (key==13){
		var PatPaySum=$("#PatPaySum").val();
		var CardFareCost=$("#CardFareCost").val()
		$("#amt").val(DHCCalCom(PatPaySum,CardFareCost,"-"));
		var myChange=$("#amt");
		if((isNaN(myChange))||(myChange=="")){
			myChange=0;
		}
		myChange=parseFloat(myChange);
		if (myChange<0){
			$.messager.alert("提示","输入费用金额错误!","info",function(){
				$("#PatPaySum").focus();
			})
		}
	}
}
function DHCCalCom(value1,value2,caloption)
{
	var mynum1=parseFloat(value1);
	if (isNaN(mynum1)) {var mynum1=0;}
	var mynum2=parseFloat(value2);
	if (isNaN(mynum2)) {mynum2=0;}
	switch (caloption)
	{
		case "-":
			var myres=mynum1-mynum2;
			break;
		case "+":
			var myres=mynum1+mynum2;
			break;
		case "*":
			var myres=mynum1*mynum2;
			break;
		case "%":
			var myres=mynum2/mynum1;
			break;
		default:
			var myres=mynum1*mynum2;
			break;
	}
	myres=parseFloat(myres)+0.0000001;
	myres=myres.toFixed(2); //.toString();
	return myres.toFixed(2);
}
function IntDoc(){
	/*$.cm({
		ClassName:"web.DHCACBaseConfig",
		MethodName:"GetAccPara",
		dataType:"text"
	},function(rtn){*/
		var myary=ServerObj.DefaultAccPara.split("^");
		//var myary=rtn.split("^");
		if (isNaN(myary[0])){
			var myVal=0;
		}else{
			var myVal=parseInt(myary[0]);
		}
		if (myVal==1) myVal=true;
		else myVal=false;
		$("#SetDefaultPassword").checkbox('setValue',myVal);
		if (myVal){
			$("#SetDefaultPassword").checkbox('disable')
		}else{
			$("#SetDefaultPassword").checkbox('enable')
		}
		if (isNaN(myary[14])){
			var myVal=0;
		}else{
			var myVal=parseInt(myary[14]);
		}
		$("#DepPrice").val(myVal);
	//});
	GetCurrentRecNo();
}
function GetCurrentRecNo()
{
	/*$.cm({
		ClassName:"web.UDHCAccAddDeposit",
		MethodName:"GetCurrentRecNo",
		dataType:"text",
		userid:session['LOGON.USERID'],
		type:"D"
	},function(ren){
		var myary=ren.split("^");
		if (myary.length>5) PageLogicObj.m_ReceiptsType=myary[5];
		if (myary[0]=='0'){
			$("#ReceiptsNo").val(myary[3]);
		}
	});*/
	var myary=ServerObj.DefaultCurrentRecNoPara.split("^");
	if (myary.length>5) PageLogicObj.m_ReceiptsType=myary[5];
	if (myary[0]=='0'){
		$("#ReceiptsNo").val(myary[3]);
	}
}
function prtClick(){
	if ($("#PAPMINo").val() == "") {
		$.messager.alert("提示","病人ID不能为空!");
		return false;
	}
	PatInfoPrint("PAPMINo");
}
function PatInfoPrint(ElementName) {
	var PatInfoXMLPrint = "PatInfoPrint";
	var Char_2 = "\2";
	var InMedicare = $("#InMedicare").val();
	var Name = $("#Name").val();
	var RegNo = $("#"+ElementName).val();
	//如果登记号存在去后台取患者姓名
	if (RegNo!=""){
		var PatStr=$.cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"GetPatientByNo",
			dataType:"text",
			PapmiNo:RegNo
		    },false)
		if (PatStr!=""){Name=PatStr.split("^")[2]}
	}
	var TxtInfo = "TPatName" + Char_2 + "姓  名:" + "^Name" + Char_2 + Name + "^TRegNo" + Char_2 + "病人ID:" + "^RegNo" + Char_2 + RegNo+"^RegNoTM"+ Char_2 + "*"+RegNo+"*"
	if (InMedicare != "")TxtInfo = TxtInfo + "^TMedicareNo" + Char_2 + "病案号:" + "^MedicareNo" + Char_2 + InMedicare;
	var ListInfo = "";
	DHCP_GetXMLConfig("DepositPrintEncrypt", PatInfoXMLPrint);
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}
function CardSearchCallBack(cardno,Regno,patientid){
	$("#PAPMINo").val(Regno);
	ValidateRegInfoByCQU(patientid);
}
function ValidateRegInfoByCQU(PAPMIDR){
	var myval=$("#CardTypeDefine").combobox('getValue');
	var myCardTypeDR = myval.split("^")[0];
	var myValidateMode=myval.split("^")[30];
	if (myValidateMode=="CQU"){
		var myInfo=$.cm({
			ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
			MethodName:"ReadConfigByCQU",
			dataType:"text",
			PAPMIDR:PAPMIDR, CardTypeDR:myCardTypeDR, SessionStr:""
	    },false)
		var myary=myInfo.split(String.fromCharCode(1));
		switch (myary[0]){
			case "0":
				break;
			case "-368":
				PageLogicObj.m_RegCardConfigXmlData=myary[1];
				var myPatInfoXmlData=myary[2];
				var myRepairFlag=myary[3];
				SetPatInfoByXML(myPatInfoXmlData);
				GetPatDetailByPAPMINo();
				SetPatRegCardDefaultConfigValue(myary[4]);
				break;
			case "-365":
				$.messager.alert("提示","此证件号码已经存在,请办理其他卡或办理补卡!");
				break;
			default:
				$.messager.alert("提示","" + " Err Code="+myary[0]);
				break;
		}
	}else{
		GetPatDetailByPAPMINo();
	}
}
function CardSearchClick()
{
	var src="reg.cardsearchquery.hui.csp";
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("FindPatReg","卡查询", 1260, PageLogicObj.dh,"icon-w-find","",$code,"");
}
function OtherCredTypeInput(){
	var src="doc.othercredtype.hui.csp?OtherCardInfo="+$("#OtherCardInfo").val();;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("OtherCredTypeManager","其他证件管理", "500", "350","icon-w-list","",$code,"");
}
function CardUniteClick(){
	var src="reg.dhcpatcardunite.hui.csp"; //websys.default.csp?WEBSYS.TCOMPONENT=DHCPATCardUnite
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Find","卡合并", PageLogicObj.dw+150, PageLogicObj.dh+100,"icon-w-edit","",$code,"");
}
function CardTypeSave(newData){
	$("#OtherCardInfo").val(newData);
}
function PatTypeOnChange(){
	var myoptval=$("#PatType").combobox("getText");
	if (myoptval=="本院职工"){
		$("#CardFareCost").val("0");
	}else{
		$("#CardFareCost").val(PageLogicObj.m_CardCost);
	}
}
function Doc_OnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		var myComName=SrcObj.id;
		if (myComName=="CardNo"){
			CardNokeydown(e);
		}else if(myComName=="PAPMINo"){
			PAPMINoOnKeyDown(e);
		}if (myComName=="ForeignIDCard"){
			ForeignIDCardOnKeyPress(e);
		}else if(myComName=="CredNo"){
			CredNoOnKeyPress(e);
		}else if (myComName=="PatPaySum"){
			PatPaySumKeyPress(e);
		}else if (myComName=="TelHome"){
			TelHomeKeyPress(e);
		}
		return DOMFocusJump(myComName);
	}
	if (((event.altKey)&&((event.keyCode==82)||(event.keyCode==114)))){
		DisableBtn("BReadCard",false);
		ReadCardClickHandle();
	}
	if ((event.keyCode==119)){
		ReadRegInfoOnClick();
	}
	if (event.keyCode==118){
		Clearclick();
	}else if(event.keyCode==120) {
		CardSearchClick();
	}
	if (((event.altKey)&&((event.keyCode==67)||(event.keyCode==99)))){
		NewCardclick();
	}
}
function InitAddressCombo(){
	var cbox = $HUI.combobox("#Address,#RegisterPlace", {
		valueField: 'provid',
		textField: 'provdesc', 
		editable:true,
		mode:"remote",
		delay:"500",
		keyHandler:{
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },
            up: function () {
	            var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
                //取得上一行
                for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i].provid==CurValue) {
						if (i>0) $(this).combobox("select",Data[i-1].provid);
						break;
					}
				}
             },
             down: function () {
              	var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
                //取得下一行
                for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i].provid==CurValue) {
							if (i < Data.length-1) $(this).combobox("select",Data[i+1].provid);
							break;
						}
					}else{
						$(this).combobox("select",Data[0].provid);
						break;
					}
				}
            },
            enter: function () { 
                //选中后让下拉表格消失
                $(this).combogrid('hidePanel');
                //添加的解决不跳光标问题
                DOMFocusJump($(this).attr("id"));
            },
            query:function(q){
				var GridData=$.cm({
					ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
					QueryName:"admaddressNewlookup",
					desc:q
				},false);
				$(this).combobox("loadData",GridData["rows"]);
				$(this).combobox('setText',q);
	        } 
		}
 	});
 	//$("#Address").combobox("resize","625");
}
function BAddressInoCollapsClick(){
	if ($(".addressinfo").css("display")=="none"){
		$(".addressinfo-div").removeClass("addressinfo-collapse").addClass("addressinfo-expand");
		$(".addressinfo").show();
		$("#BAddressInoCollaps .l-btn-text")[0].innerText="隐藏全部";
	}else{
		$(".addressinfo-div").removeClass("addressinfo-expand").addClass("addressinfo-collapse");
		$(".addressinfo").hide();
		$("#BAddressInoCollaps .l-btn-text")[0].innerText="展开全部";
	}
}
function BPayInoCollapsClick(){
	if ($(".payinfo").css("display")=="none"){
		$(".payinfo-div").removeClass("payinfo-collapse").addClass("payinfo-expand");
		$(".payinfo").show();
		$("#BPayInoCollaps .l-btn-text")[0].innerText="隐藏全部";
	}else{
		$(".payinfo-div").removeClass("payinfo-expand").addClass("payinfo-collapse");
		$(".payinfo").hide();
		$("#BPayInoCollaps .l-btn-text")[0].innerText="展开全部";
	}
}
function BBaseInoCollapsClick(){
	if ($(".baseinfo").css("display")=="none"){
		$(".baseinfo-div").removeClass("baseinfo-collapse").addClass("baseinfo-expand");
		$(".baseinfo").show();
		$("#BBaseInoCollaps .l-btn-text")[0].innerText="隐藏全部";
	}else{
		$(".baseinfo-div").removeClass("baseinfo-expand").addClass("baseinfo-collapse");
		$(".baseinfo").hide();
		$("#BBaseInoCollaps .l-btn-text")[0].innerText="展开全部";
	}
}
function CheckData(){
	
	if (PageLogicObj.m_PatMasFlag=="Y"){
		var IsNullInfo="",FocusName="";
		//必填项目验证
		var myrtn=true;
		for (var i=0;i<PageLogicObj.m_CardRegMustFillInArr.length;i++){
			var id=PageLogicObj.m_CardRegMustFillInArr[i]['id'];
			var text=PageLogicObj.m_CardRegMustFillInArr[i]['text'];
			var val=getValue(id);
			if (val==""){
				if (IsNullInfo=="") IsNullInfo=text,FocusName=id;
				else  IsNullInfo=IsNullInfo+" , "+text;
				
			}
		}
		if (IsNullInfo!=""){
			$.messager.alert("提示","请输入<font color=red>"+IsNullInfo+"</font> !","info",function(){
				setFocus(FocusName)
			});
			return false;
		}
	}
	var myExpstr="";
	//患者证件类型为身份证时，验证身份证号是否已经存在患者信息，如果存在则更新患者信息
	var myIDrtn=IsCredTypeID();
	if (myIDrtn){
		var CredNo=$("#CredNo").val();
		if (CredNo!=""){
			myExpstr=CredNo;
		}
	}
	var myPAPMINo=$('#PAPMINo').val();
	if ((myPAPMINo!="")||(myExpstr!="")){
		var myPatInfo=$.cm({
			ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName:"GetPatInfoByPANo",
			dataType:"text",
			PAPMINo:myPAPMINo, ExpStr:myExpstr
		},false);
		var myary=myPatInfo.split("^");
		if (myary[0]=="2001"){
			$.messager.alert("提示","无此登记号的病人,不能建卡!","info",function(){
				$("#PAPMINo").focus();
			});
			return false;
		}else if (myary[0]=="0"){
			var myXMLStr=myary[1];
			var PatientID=myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
			if (PatientID!=""){
				$("#PAPMIRowID").val(PatientID);
			}else{
				$("#PAPMIRowID").val("");
			}
		}
	}
	var PAPMIRowID=$("#PAPMIRowID").val();
	//验证患者信息(姓名、性别、出生日期、联系电话)是否存在一致的患者
	if (!PatInfoUnique()) {
		return false;
	}
	var InsuNo=$('#PatYBCode').val();
	//医保手册号
	if ((InsuNo!="")&&(InsuNo!="99999999999S")) {
		var Rtn=$.cm({
			ClassName:"web.DHCBL.Patient.DHCPatient",
			MethodName:"PatUniInfoQuery",
			dataType:"text",
			PatientDr:PAPMIRowID, Type:"InsuNo", NoStr:InsuNo
		},false);
		if(Rtn>0){	
			$.messager.alert("提示",InsuNo+"医保号已被使用!","info",function(){
				$("#PatYBCode").focus();
			});
			return false
		}
	}
	if(($("#PopulationClass").combobox("getValue")=="")||($("#PopulationClass").combobox("getValue")=="undefined")||($("#PopulationClass").combobox("getText")=="")||($("#PopulationClass").combobox("getText")=="undefined")){
		$.messager.alert("提示","人员分类不能为空，请选择 !","info",function(){
				//$("#PopulationClass").focus();
				setFocus("PopulationClass")
		});
		return false;
	}
	var OpMedicareObj=document.getElementById('OpMedicare');
	if (PageLogicObj.m_PatMasFlag=="Y"){
		var myBirthTime=$("#BirthTime").val();
		if (myBirthTime!=""){
			 var regTime = /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/;
			 if (!regTime.test(myBirthTime)) {
				 $.messager.alert("提示","请输入正确的出生时间!","info",function(){
					$("#BirthTime").focus();
				 });
				 return false;
			 }
		}
		/*var IsNullInfo="",FocusIndex=""
		var myTelHome=$("#TelHome").val();
		if (myTelHome=="")
		{
			IsNullInfo="联系电话"
			FocusIndex="TelHome"
			//$.messager.alert("提示","请输入联系电话!","info",function(){
			//	$("#TelHome").focus();
			//});
			//return false;
		}
		var myMobPhone=$("#MobPhone").val();
		if (myMobPhone!=""){
			if(myMobPhone.length!="11"){
				$.messager.alert("提示","手机号码长度错误,应为【11】位,请核实!","info",function(){
					$("#MobPhone").focus();
				});
			    return false;
			}
		}
		var myName=$("#Name").val();
		if (myName==""){
			if (IsNullInfo=="")	{
				IsNullInfo="患者姓名"
				FocusIndex="Name"
			}
			else IsNullInfo=IsNullInfo+"、患者姓名"
			//$.messager.alert("提示","请输入患者姓名!","info",function(){
			//	$("#Name").focus();
			//});
			//return false;
		}
		var mySex=$("#Sex").combobox("getValue");
		if ((mySex=="")||(mySex==undefined)){
			if (IsNullInfo=="")	{
				IsNullInfo="性别"
				FocusIndex="Sex"
			}
			else IsNullInfo=IsNullInfo+"、性别"
			//$.messager.alert("提示","请选择性别!","info",function(){
			//	$("#Sex").focus();
			//});
			//return false;
		}
		var myPatType= $("#PatType").combobox("getValue");
		myPatType=CheckComboxSelData("PatType",myPatType);
		if ((myPatType=="")||(myPatType==undefined)){
			if (IsNullInfo=="")	{
				IsNullInfo="患者类型"
				FocusIndex="PatType"
			}
			else IsNullInfo=IsNullInfo+"、患者类型"
			//$.messager.alert("提示","请选择患者类型!","info",function(){
			//	$("#PatType").focus();
			//});
			//return false;
		}
		var myBirth=$("#Birth").val();
		if (myBirth==""){
			if (IsNullInfo=="")	{
				IsNullInfo="出生日期"
				FocusIndex="Birth"
			}
			else IsNullInfo=IsNullInfo+"、出生日期"
			//$.messager.alert("提示","请输入出生日期!","info",function(){
			//	$("#Birth").focus();
			//});
			//return false;
		}
		if (IsNullInfo!=""){
			$.messager.alert("提示",IsNullInfo+"不能为空!","info",function(){
				$("#"+FocusIndex).focus();
			});
			return false;
		}*/
		//非医保类型不能填写医保号
		if (!checkPatYBCode()) return false;
		if (!BirthCheck()) return false;
		if (!ForeignIDCardOnKeyPress()) return false; 
		var myTelHome=$("#TelHome").val();
		if (myTelHome!=""){
			if (!CheckTelOrMobile(myTelHome,"TelHome","")) return false;
		}
		var myBirth=$("#Birth").val();
		if (myBirth!=""){
			if (ServerObj.dtformat=="YMD"){
				var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
			}
			if (ServerObj.dtformat=="DMY"){
				var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
			}
		    var ret=myBirth.match(reg);
	        if(ret==null){
		        $.messager.alert("提示","请输入正确的出生日期!","info",function(){
					$("#Birth").focus();
				});
				return false;
	        }
	        if (ServerObj.dtformat=="YMD"){
		    	var myrtn=DHCWeb_IsDate(myBirth,"-")
		    }
		    if (ServerObj.dtformat=="DMY"){
		    	var myrtn=DHCWeb_IsDate(myBirth,"/")
		    }
		    if (!myrtn){
			    $.messager.alert("提示","请输入正确的出生日期!","info",function(){
					$("#Birth").focus();
				});
				return false;
		    }else{
				var mybirth1=$("#Birth").val();
				var Checkrtn=CheckBirth(mybirth1);
				if(Checkrtn==false){
					$.messager.alert("提示","出生日期不能大于今天或者小于、等于1840年!","info",function(){
						$("#Birth").focus();
					});
					return false;
				}		
		    }
		}
		//仅建病历下列提示信息为必填
	    if ((PageLogicObj.m_MedicalFlag==1)&&(PageLogicObj.m_ModifiedFlag==0)) {
		    if (PageLogicObj.m_IsNotStructAddress=="Y"){
			    var myAddress = $("#Address").combobox("getText");
			    if (myAddress == "") {
				    $.messager.alert("提示","没有地址,请填写地址!","info",function(){
						$('#Address').next('span').find('input').focus();
					});
					return false;
				}
			}else{
				 var myAddress = $("#Address").val();
				 if (myAddress == "") {
				    $.messager.alert("提示","没有地址,请填写地址!","info",function(){
						$("#Address").focus();
					});
					return false;
				 }
			}
			var myCountryDesc = $("#CountryDescLookUpRowID").combobox('getValue');
			myCountryDesc=CheckComboxSelData("CountryDescLookUpRowID",myCountryDesc);
			if (myCountryDesc == "") {
				$.messager.alert("提示","请选择国籍!","info",function(){
					$('#CountryDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myPAPERMarital = $("#PAPERMarital").combobox('getValue');
			if (myPAPERMarital == "") {
				$.messager.alert("提示","请选择婚姻状态!","info",function(){
					$('#PAPERMarital').next('span').find('input').focus();
				});
				return false;
			}
			var myProvinceBirth = $("#ProvinceBirth").combobox('getValue');
			myProvinceBirth=CheckComboxSelData("ProvinceBirth",myProvinceBirth);
			if (myProvinceBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择省(出生)!","info",function(){
					$('#ProvinceBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myNationDesc = $("#NationDescLookUpRowID").combobox('getValue');
			myNationDesc=CheckComboxSelData("NationDescLookUpRowID",myNationDesc);
			if (myNationDesc == "") {
				$.messager.alert("提示","请选择民族!","info",function(){
					$('#NationDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCityBirth = $("#CityBirth").combobox('getValue');
			myCityBirth=CheckComboxSelData("CityBirth",myCityBirth);
			if (myCityBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择市(出生)!","info",function(){
					$('#CityBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myAreaBirth = $("#AreaBirth").combobox('getValue');
			myAreaBirth=CheckComboxSelData("AreaBirth",myAreaBirth);
			if (myAreaBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择县(出生)!","info",function(){
					$('#AreaBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myProvinceInfo = $("#ProvinceInfoLookUpRowID").combobox('getValue');
			myProvinceInfo=CheckComboxSelData("ProvinceInfoLookUpRowID",myProvinceInfo);
			if (myProvinceInfo == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择省(现住)!","info",function(){
					$('#AreaBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myCityDesc = $("#CityDescLookUpRowID").combobox('getValue');
			myCityDesc=CheckComboxSelData("CityDescLookUpRowID",myCityDesc);
			if (myCityDesc == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择市(现住)!","info",function(){
					$('#CityDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCTArea = $("#CityAreaLookUpRowID").combobox('getValue');
			myCTArea=CheckComboxSelData("CityAreaLookUpRowID",myCTArea);
			if (myCTArea == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择县(现住)!","info",function(){
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCompany = $("#EmployeeCompanyLookUpRowID").val();
			if (myCompany == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请输入工作单位!","info",function(){
					$('#EmployeeCompanyLookUpRowID').focus();
				});
				return false;
			}
			var myProvinceHouse = $("#ProvinceHouse").combobox('getValue');
			myProvinceHouse=CheckComboxSelData("ProvinceHouse",myProvinceHouse);
			if (myProvinceHouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择省(户口)!","info",function(){
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCityhouse = $("#Cityhouse").combobox('getValue');
			myCityhouse=CheckComboxSelData("Cityhouse",myCityhouse);
			if (myCityhouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择市(户口)!","info",function(){
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myAreaHouse = $("#AreaHouse").combobox('getValue');
			myAreaHouse=CheckComboxSelData("AreaHouse",myAreaHouse);
			if (myAreaHouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("提示","请选择县(户口)!","info",function(){
					$('#AreaHouse').next('span').find('input').focus();
				});
				return false;
			}
			if (PageLogicObj.m_IsNotStructAddress=="Y"){
			    var myAddress = $("#RegisterPlace").combobox("getText");
			    if (myAddress == "") {
				    if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				    $.messager.alert("提示","请填写地址(户口)!","info",function(){
						$('#RegisterPlace').next('span').find('input').focus();
					});
					return false;
				}
			}else{
				 var myAddress = $("#RegisterPlace").val();
				 if (myAddress == "") {
					if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				    $.messager.alert("提示","请填写地址(户口)!","info",function(){
						$("#RegisterPlace").focus();
					});
					return false;
				 }
			}
			var myCTRelationDR = $("#CTRelationDR").combobox("getText");
			myCTRelationDR=CheckComboxSelData("CTRelationDR",myCTRelationDR);
			if (myCTRelationDR == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","请选择关系!","info",function(){
					$("#CTRelationDR").focus();
				});
				return false;
			}
			var myForeignPhone = $("#ForeignPhone").val();
			if (myForeignPhone == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","请输入联系人电话!","info",function(){
					$("#ForeignPhone").focus();
				});
				return false;
			}else{
				if (!CheckTelOrMobile(myForeignPhone,"ForeignPhone","联系人")) return false;
		    }
		}
	}
	//var OpMedicareObj = document.getElementById('OpMedicare');
	var CredNo=$("#CredNo").val();
	if (PageLogicObj.m_PatMasFlag == "Y") {
		var myForeignName = $("#ForeignName").val();
		if (myForeignName == "") {
		    /*if(PageLogicObj.m_MedicalFlag==1){
			    if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","请输入联系人!","info",function(){
					$("#ForeignName").focus();
				});
				return false;
			}*/
		}
		/*var myTelHome = $("#TelHome").val();
		if (myTelHome == "") {
			$.messager.alert("提示","请输入联系电话!","info",function(){
				$("#TelHome").focus();
			});
			return false;
		}else{
			if (!CheckTelOrMobile(myTelHome,"TelHome","")) return false;
		}
		var myBirth = $("#Birth").val();
		if (myBirth == "") {
			$.messager.alert("提示","请输入出生日期!","info",function(){
				$("#Birth").focus();
			});
			return false;
		}*/
		if(CheckBirthAndBirthTime()){
			$.messager.alert("提示","出生日期是当天的,出生时间不能大于当前时间,请核实!","info",function(){
				$("#BirthTime").focus();
			});
			return false;
		}
		/*var mySex = $("#Sex").combobox("getValue");
		if (mySex == "") {
			$.messager.alert("提示","请选择性别!","info",function(){
				$('#Sex').next('span').find('input').focus();
			});
			return false;
		}*/
		var Age = AgeForYear(myBirth)
		if (Age < ServerObj.ForeignInfoByAge) {
			var ForeignName = $("#ForeignName").val();
			var ForeignPhone = $("#ForeignPhone").val();
			var ForeignIDCard= $("#ForeignIDCard").val();
			if (ForeignName == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","年龄小于"+ServerObj.ForeignInfoByAge+"岁,联系人不能为空!","info",function(){
					$("#ForeignName").focus();
				});
				return false;
			}
			if (ForeignPhone==""){
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","年龄小于"+ServerObj.ForeignInfoByAge+"岁,联系人电话不能为空!","info",function(){
					$("#ForeignPhone").focus();
				});
				return false;
			}
			if (ForeignPhone!=""){
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				if (!CheckTelOrMobile(ForeignPhone,"ForeignPhone","联系人")) return false;
		    }
		    /*
			if (ForeignIDCard==""){
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("提示","年龄小于"+ServerObj.ForeignInfoByAge+"岁,联系人证件信息不能为空","info",function(){
					$("#ForeignIDCard").focus();
				});
				return false;
			}*/
		}else{
			var myForeignPhone = $("#ForeignPhone").val();
			if (myForeignPhone!=""){
				if (!CheckTelOrMobile(myForeignPhone,"ForeignPhone","联系人")) return false;
			}
		}
		/*婚姻状态控制 start*/
		var mySex = $("#Sex").combobox('getText');
		var myPAPERMarital = $("#PAPERMarital").combobox('getValue');
		var AgeToMaritalFlag=0
        if(mySex=="女"){
	        if ((Age < PageLogicObj.m_MarriedLimitFemaleFAge)&&(("^"+PageLogicObj.m_MarriedIDStr+"^").indexOf("^"+myPAPERMarital+"^")!=-1)) {
		        AgeToMaritalFlag=1;
		    }
	    }else if(mySex=="男"){
		    if ((Age < PageLogicObj.m_MarriedLimitMaleAge)&&(("^"+PageLogicObj.m_MarriedIDStr+"^").indexOf("^"+myPAPERMarital+"^")!=-1)) {
			    AgeToMaritalFlag=1;
		    }
		}	
		if(AgeToMaritalFlag==1){
			alert("该患者未到法定年龄!")
		}
		/*婚姻状态控制 end*/
		/*var myPatType = $("#PatType").combobox("getValue");
		myPatType=CheckComboxSelData("PatType",myPatType);
		if ((myPatType == "")||(myPatType==undefined)) {
			$.messager.alert("提示","请选择患者类型","info",function(){
				$('#PatType').next('span').find('input').focus();
			});
			return false;
		}*/
		//对于病人类型为职工的对工号的判断
		var myPatType=$("#PatType").combobox("getText");
		if (myPatType.indexOf('本院')>=0){
			var EmployeeNo=$("#EmployeeNo").val();
			if (EmployeeNo==""){
				$.messager.alert("提示","本院职工,请填写职工工号!","info",function(){
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var curPAPMIRowID=$.cm({
				ClassName:"web.DHCBL.CARDIF.ICardPaPatMasInfo",
				MethodName:"GetPAPMIRowIDByEmployeeNo",
				dataType:"text",
				EmployeeNo:EmployeeNo
			},false);
			var name=curPAPMIRowID.split("^")[1];
			var UserName=curPAPMIRowID.split("^")[2];
			curPAPMIRowID=curPAPMIRowID.split("^")[0];
			if (curPAPMIRowID=="0"){
				$.messager.alert("提示","工号不正确,请核实工号!","info",function(){
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var PAPMIRowID=$("#PAPMIRowID").val();
			if ((PAPMIRowID!=curPAPMIRowID)&&(curPAPMIRowID!="")){
				$.messager.alert("提示","此工号已经被'"+name+"'所用,请核实工号!","info",function(){
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var Name=$("#Name").val();
			if (UserName!=Name){
				$.messager.alert("提示","此工号对应姓名为'"+UserName+"'和所录入姓名不一致!","info",function(){
					$("#Name").focus();
				});
				return false;
			}
		}else{
			var EmployeeNo=$("#EmployeeNo").val();
			if (EmployeeNo!=""){
				$.messager.alert("提示","非本院职工工号不可填写!","info",function(){
					$("#EmployeeNo").focus();
				});
				return false;
			}
		}
		var myIDNo = $("#CredNo").val();
		if (myIDNo!=""){
			var myval=$("#CredType").combobox("getValue");
		    if (myval==""){
			    $.messager.alert("提示","证件号码不为空时,证件类型不能为空!");
				return false;
			}
			var myIDrtn=IsCredTypeID();
			if (myIDrtn){
				var myIsID=DHCWeb_IsIdCardNo(myIDNo);
				if (!myIsID){
					$("#CredNo").focus();
					return false;
				}
				var IDNoInfoStr=DHCWeb_GetInfoFromId(myIDNo)
				var IDBirthday=IDNoInfoStr[2]  
				if (myBirth!=IDBirthday){
					$.messager.alert("提示","出生日期与身份证信息不符!","info",function(){
						$("#Birth").focus();
					});
		   		    return false;
				}
				var IDSex=IDNoInfoStr[3]
				if(mySex!=IDSex){
					$.messager.alert("提示","身份证号:"+myIDNo+"对应的性别是【"+IDSex+"】,请选择正确的性别!","info",function(){
						$('#Sex').next('span').find('input').focus();
					});
					return false;
				}
			}else{
				var myval=$("#CredType").combobox("getValue");
				var myCredTypeDR = myval.split("^")[0];
				var PAPMIRowID=$("#PAPMIRowID").val();
				var mySameFind=$.cm({
				    ClassName : "web.DHCBL.CARD.UCardPaPatMasInfo",
				    MethodName : "CheckCredNoIDU",
				    PatientID:PAPMIRowID, CredNo:myIDNo, CredTypeDR:myCredTypeDR,
				    dataType:"text"
				},false);
				if (mySameFind=="1"){
					$.messager.alert("提示",myIDNo+" 此证件号码已经被使用!","info",function(){
						$("#CredNo").focus();
					})
					return false;
				}
				//如果证件类型不是身份证,清空IDCardNo1值，防止IDCardNo1更新到papmi_id
				$("#IDCardNo1").val("");
			}
		}else{
			var myval=$("#CredType").combobox("getValue");
			var myCredTypeDR = myval.split("^")[0];
			var CredNoRequired=$.cm({
				ClassName:"web.DHCBL.CARD.UCardRefInfo",
				MethodName:"CheckCardNoRequired",
				dataType:"text",
				CredTypeDr:myCredTypeDR
			},false)
			var AgeAllow=$.cm({
				ClassName:"web.DHCDocConfig",
				MethodName:"GetDHCDocCardConfig",
				dataType:"text",
				Node:"AllowAgeNoCreadCard"
			},false);
			var FlagNoCread=$.cm({
				ClassName:"web.DHCDocConfig",
				MethodName:"GetDHCDocCardConfig",
				dataType:"text",
				Node:"NOCREAD"
			},false);
			if (CredNoRequired=="Y"){
				if ((AgeAllow!="")&(parseFloat(Age)<=parseFloat(AgeAllow))){}
				else{
					$.messager.alert("提示","请填写证件号码!","info",function(){
						$('#CredNo').focus();
					});
					return false;
				}
			}
		}
		var myval=$("#CardTypeDefine").combobox("getValue");
		var myary = myval.split("^");
		if (myary[3]=="C"){
			var mypmval=$("#PayMode").combobox("getValue");
			if (mypmval==""){
				$.messager.alert("提示","请选择支付模式!","info",function(){
					$('#PayMode').next('span').find('input').focus();
				});
				return false;
			}
			var mytmpary= mypmval.split("^");
			if (mytmpary[2]=="Y"){
				///Require Pay Info
				var myCheckNO=$("#CardChequeNo").val();
				if (myCheckNO==""){
					if (!PayInfoIsExpand()) BPayInoCollapsClick();
					$.messager.alert("提示","请输入支票/信用卡号!","info",function(){
						$('#CardChequeNo').focus();
					});
					return false;
				}
		   }
		}
		var myOtheRtn=OtherSpecialCheckData();
		if (!myOtheRtn){
			return myOtheRtn;
		}
		if (PageLogicObj.m_ModifiedFlag==1) return true;
	}
	
	//如果是用登记号号作为卡号则不取校验界面卡号
	if ((PageLogicObj.m_CardRefFlag=="Y")&&(PageLogicObj.m_UsePANoToCardNO!="Y"))
	{
		var myCardNo=$("#CardNo").val();
		if (myCardNo==""){
			$.messager.alert("提示","卡号不能为空,请读卡!","info",function(){
				if (PageLogicObj.m_SetFocusElement!=""){
					$("#"+PageLogicObj.m_SetFocusElement).focus();
				}
			});
			return false;
		}
		////Card NO Length ?= Card Type Define Length
		var myCTDefLength=0;
		if (isNaN(PageLogicObj.m_CardNoLength)){
			myCTDefLength=0;
		}else{
			myCTDefLength = PageLogicObj.m_CardNoLength;
		}
		if ((myCTDefLength!=0)&&(myCardNo.length!=myCTDefLength)){
			if (PageLogicObj.m_SetFocusElement!=""){
				$.messager.alert("提示","卡号长度错误 "+myCTDefLength+" ","info",function(){
					$("#CardNo").focus();
				});
			}
			return false;
		}
		////Card No Pre ?= Card Type Define Pre
		if (PageLogicObj.m_CardTypePrefixNo!=""){
			var myPreNoLength=PageLogicObj.m_CardTypePrefixNo.length;
			var myCardNo=$("#CardNo").val();
			var myPreNo=myCardNo.substring(0,myPreNoLength);
			if(myPreNo!=PageLogicObj.m_CardTypePrefixNo){
				$.messager.alert("提示","卡号码前缀错误!","info",function(){
					$("#CardNo").focus();
				});
				return false;
			}
		}
	}
	var myPatPaySum=$("#PatPaySum").val();
	if ((myPatPaySum=="")&&(+PageLogicObj.m_CardCost>0)){
	   	$.messager.alert("提示","请输入收款金额!","info",function(){
			$("#PatPaySum").focus();
		});
   		return false;
	}else{
		var PatPaySum=$("#PatPaySum").val();
		var CardFareCost=$("#CardFareCost").val()
		$("#amt").val(DHCCalCom(PatPaySum,CardFareCost,"-"));
		var myChange=$("#amt").val();
		if((isNaN(myChange))||(myChange=="")){
			myChange=0;
		}
		myChange=parseFloat(myChange);
		if (myChange<0){
			$.messager.alert("提示","输入费用金额错误!","info",function(){
				$("#PatPaySum").focus();
			});
	   		return false;
		}
		var ReceiptsNo=$("#ReceiptsNo").val();
		var myChange=$("#amt").val();
		if ((myChange!="")&&(myChange!="0")&&(ReceiptsNo=="")&&(PageLogicObj.m_ReceiptsType!="")){
			$.messager.alert("提示","您已经没有可用收据,请先领取收据!");
	   		return false;
		}
	}
	if (PageLogicObj.m_AccManagerFlag=="Y"){
		var amt=$("#amt").val();
		if ((!IsNumber(amt))||(amt<0)){
			$.messager.alert("提示","金额输入有误,请重新输入!","info",function(){
				$("#PatPaySum").focus();
			});
	   		return false;
		}
	}
	var OtherCardInfo=$("#OtherCardInfo").val();
	if (OtherCardInfo!=""){
		var CredNo=$("#CredNo").val();
		var myval=$("#CredType").combobox("getValue");
		var myCredTypeDR = myval.split("^")[0];
		for (var i=0;i<OtherCardInfo.split("!").length;i++){
			var oneCredTypeId=OtherCardInfo.split("!")[i].split("^")[0];
			if (oneCredTypeId!=myCredTypeDR) continue;
			var oneCredNo=OtherCardInfo.split("!")[i].split("^")[1];
			if ((oneCredNo!=CredNo)&&(oneCredNo!="")){
				$.messager.alert("提示","证件号码: "+CredNo+" 和其他证件里面相同证件类型维护的号码: "+oneCredNo+" 不一致!请核实!","info",function(){
					$("#CredNo").focus();
				});
	   			return false;
			}
		}
	}
	return myrtn;
}
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"联系电话电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function CheckBirthAndBirthTime()
{
	var Today=new Date();
	var mytime=Today.getHours();
	var CurMinutes= Today.getMinutes();
	if (CurMinutes<=9){
		CurMinutes="0"+CurMinutes;
	}
	mytime=mytime+":"+CurMinutes;
	var CurSeconds= Today.getSeconds();
	if (CurSeconds<=9){
		CurSeconds="0"+CurSeconds;
	}
	mytime=mytime+":"+CurSeconds;
	var Today=getNowFormatDate() ;
	var myBirth=$("#Birth").val();
	if(myBirth==Today){
		var BirthTime=$("#BirthTime").val();
		if(BirthTime!=""){
			if(BirthTime.split(":").length==2){
				BirthTime=BirthTime+":00"
			}
		}
		BirthTime=BirthTime.replace(/:/g,"")
		mytime=mytime.replace(/:/g,"")
		if(parseInt(BirthTime)>parseInt(mytime)){
			return true
		}else{
			return false
		}
	}
	return false;
}
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (ServerObj.dtformat=="YMD"){
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	}
    if (ServerObj.dtformat=="DMY"){
	    var seperator1 = "/";
	    var currentdate = strDate + seperator1 + month + seperator1 + date.getFullYear()
	}
    return currentdate;
}  
//获取年龄--年用来比较
function AgeForYear(strBirthday)
{
	if (ServerObj.dtformat=="YMD"){
		var strBirthdayArr=strBirthday.split("-");
	    var birthYear = strBirthdayArr[0];
	    var birthMonth = strBirthdayArr[1];
	    var birthDay = strBirthdayArr[2];
	}
	if (ServerObj.dtformat=="DMY"){
		var strBirthdayArr=strBirthday.split("/");
	    var birthYear = strBirthdayArr[2];
	    var birthMonth = strBirthdayArr[1];
	    var birthDay = strBirthdayArr[0];
	}
    var d = new Date();
    var nowYear = d.getFullYear();
    var nowMonth = d.getMonth() + 1;
    var nowDay = d.getDate();
	var ageDiff = nowYear - birthYear ; //年之差
	return ageDiff
}
function OtherSpecialCheckData()
{
	var myVer=ServerObj.ConfigVersion;
	switch (myVer){
		case "7":
			var myAge=$("#Age").val();
			if (isNaN(myAge)){myAge=0};
			if (myAge<14){
				var myForeignName=$("#ForeignName").val();
				if (myForeignName==""){
					if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					$.messager.alert("提示","14岁以下,联系人是必填项目!","info",function(){
						$("#ForeignName").focus();
					});
					return false;
				}
				if (PageLogicObj.m_IsNotStructAddress=="Y"){
				    var myAddress = $("#Address").combobox("getText");
				    if (myAddress == "") {
					    if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					    $.messager.alert("提示","14岁以下, 地址是必填项目!","info",function(){
							$('#Address').next('span').find('input').focus();
						});
						return false;
					}
				}else{
					 var myAddress = $("#Address").val();
					 if (myAddress == "") {
						if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					    $.messager.alert("提示","14岁以下, 地址是必填项目!","info",function(){
							$("#Address").focus();
						});
						return false;
					 }
				}
				var myTelHome=$("#TelHome").val();
				if (myTelHome==""){
					if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					$.messager.alert("提示","14岁以下, 联系电话是必填项目!","info",function(){
						$("#TelHome").focus();
					});
					return false;
				}
			}
			break;
		default:
			break;
	}
	return true;
}
function IsNumber(string,sign) 
{
	var number; 
	if (string==null) return false; 
	if ((sign!=null)&&(sign!='-')&&(sign!='+')) {
		return false; 
	}
	number = new Number(string);
	if (isNaN(number)) { 
		return false; 
	} else if ((sign==null)||(sign=='-'&&number<0)||(sign=='+'&&number>0)) { 
		return true; 
	} else 
		return false; 
}
function PatInfoUnique(){
	var myoptval=$("#CardTypeDefine").combobox("getValue");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	var Name=$("#Name").val();
	var Sex = $("#Sex").combobox("getValue");
	var Birth = $('#Birth').val();
	var Tel = $("#TelHome").val();
	var PAPMIRowID=$("#PAPMIRowID").val()
	var rtn=$.cm({
		ClassName:"web.DHCPATCardUnite",
		MethodName:"GetPatByInfo",
		CardType:myCardTypeDR,
		Name:Name,
		Sex:Sex,
		Birth:Birth,
		Tel:Tel,
		PAPMIRowID:PAPMIRowID,
		dataType:"text"
	},false)
	var RtnArr=rtn.split("^")
	if (RtnArr[0]=="0"){
		return true;
	}else if(RtnArr[0]=="S"){
		$.messager.alert('提示','此卡类型、姓名、性别、出生日期、联系电话信息绑定已挂失卡'+RtnArr[1]+',请作废此卡后重新建卡');
		return false;
	}else if(RtnArr[0]=="N"){
		$.messager.alert('提示','此卡类型、姓名、性别、出生日期、联系电话信息绑定卡'+RtnArr[1]+',请办理其他卡或者补卡');
		return false;
	}
	return true;
}
function BirthCheck(){
	var mybirth=$("#Birth").val();
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		$.messager.alert("提示","请输入正确的出生日期!","info",function(){
			$("#Birth").focus();
		});
		return false;
	}else{
		$("#Birth").removeClass("newclsInvalid");
	}
	if ((mybirth.length==8)){
		if (ServerObj.dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (ServerObj.dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
		$("#Birth").val(mybirth);
	}
	if (ServerObj.dtformat=="YMD"){
		var myrtn=DHCWeb_IsDate(mybirth,"-")
	}
	if (ServerObj.dtformat=="DMY"){
		var myrtn=DHCWeb_IsDate(mybirth,"/")
	}
	if (!myrtn){
		$.messager.alert("提示","请输入正确的出生日期!","info",function(){
			$("#Birth").focus();
		});
		return false;
	}else{
		$("#Birth").removeClass("newclsInvalid");
	}
    return true;
}
function GetPatMasInfo()
{
	var myxml="";
	if (PageLogicObj.m_PatMasFlag=="Y"){
		var myparseinfo = $("#InitPatMasEntity").val();
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetCardRefInfo(){
	var myxml="";
	if (PageLogicObj.m_CardRefFlag=="Y"){
		var myparseinfo = $("#InitCardRefEntity").val();
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetCardINVInfo(){
	var myxml="";
	if (PageLogicObj.m_CardRefFlag=="Y"){
		var myparseinfo = $("#InitCardINVPRTEntity").val();
		var myxml=GetEntityClassInfoToXML(myparseinfo)	
	}
	return myxml;
}
function GetAccManagerInfo(){
	var myxml="";
	if (PageLogicObj.m_AccManagerFlag=="Y"){
		var myparseinfo = $("#InitAccManagerEntity").val();
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;	
}
function GetPreDepositeInfo(){
	var myxml="";
	if (PageLogicObj.m_AccManagerFlag=="Y"){
		var myparseinfo = $("#InitAccPreDepositEncrypt").val();
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			var _$id=$("#"+myary[myIdx]);
			if (_$id.length==0){
				var myval="";
			}else{
				//if (_$id.hasClass("hisui-combobox")){
				if (_$id.next().hasClass('combo')){
					if ((myary[myIdx]=="RegisterPlace")||(myary[myIdx]=="Address")){
						var myval=_$id.combobox("getText");
					}else{
						var myval=_$id.combobox("getValue");
						if (myval==undefined) myval="";
						//防止类型卡类型、支付方式id是已串的形式存在
						if (myval!=""){
							myval=myval.split("^")[0];
						}
					}
				}else{
					if (PageLogicObj.m_IsNotStructAddress=="Y"){
						if ((myary[myIdx]=="RegisterPlace")||(myary[myIdx]=="Address")){
							var myval=_$id.combobox("getText");
						}else{
							var myval=_$id.val();
						}
					}else{
						var myval=_$id.val();
					}
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err){
		$.messager.alert("提示","Error: " + Err.description);
	}
	return myxmlstr;
}
function WrtCard(){
	var myPAPMINo=$("#PAPMINo").val();
	var mySecrityNo=$.cm({
		ClassName:"web.UDHCAccCardManage",
		MethodName:"GetCardCheckNo",
		dataType:"text",
		PAPMINo:myPAPMINo
	},false);
	if (mySecrityNo!=""){
		var myCardNo=$("#CardNo").val();
		var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, PageLogicObj.m_CCMRowID);
		if (rtn!="0"){
			return "-1^"
		}
	}else{
		return "-1^";
	}
	return "0^"+mySecrityNo
}
function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName)
{
	if (CurXMLName==""){
		return;
	}
	var INVtmp=RowIDStr.split("^");
	if (INVtmp.length>0){
		DHCP_GetXMLConfig("DepositPrintEncrypt",CurXMLName);
	}
	for (var invi=0;invi<INVtmp.length;invi++){
		if (INVtmp[invi]!=""){
			var encmeth=$("#"+EncryptItemName).val();
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",CurXMLName,INVtmp[invi], Guser, myExpStr);
		}
	}
}
function InvPrintNew(TxtInfo,ListInfo)
{
	var HospName=$("#HospName").val();
	var PDlime=String.fromCharCode(2);
	var TxtInfo=TxtInfo+"^"+"HospName3"+PDlime+HospName;
	//var myPAName=$("#Name").val();
	//TxtInfo=TxtInfo+"^"+"PatName"+PDlime+myPAName;
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","");
	TxtInfo=TxtInfo+ "^CunGen" + String.fromCharCode(2) + "存根"
	DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo,"","");
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
	      var CombValue=Data[i].id ;
	 	  var CombDesc=Data[i].text;
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function SetCardNOLength(){
	var CardNo=$("#CardNo").val();
	if ((PageLogicObj.m_CardNoLength!=0)&&(CardNo.length>PageLogicObj.m_CardNoLength)){
		if (!confirm("卡号位数大于卡类型配置位数,是否截取?")){
			return false;
		}
	}
	if ((CardNo.length<PageLogicObj.m_CardNoLength)&&(PageLogicObj.m_CardNoLength!=0)) {
		for (var i=(PageLogicObj.m_CardNoLength-CardNo.length-1); i>=0; i--) {
			CardNo="0"+CardNo;
		}
	}
	if ((CardNo.length>PageLogicObj.m_CardNoLength)&&(PageLogicObj.m_CardNoLength!=0)){
		PageLogicObj.m_CardSecrityNo=CardNo.substring(PageLogicObj.m_CardNoLength,CardNo.length);
		CardNo=CardNo.substring(0,PageLogicObj.m_CardNoLength);
	}
	$("#CardNo").val(CardNo);
	return true;	
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
//判断基本信息是否全部展开
function BaseInfoIsExpand(){
	if ($(".baseinfo").css("display")=="none"){
		return false;
	}
	return true;
}
//判断地址信息是否全部展开
function AddressInfoIsExpand(){
	if ($(".addressinfo").css("display")=="none"){
		return false;
	}
	return true;
}
//判断缴费信息是否全部展开
function PayInfoIsExpand(){
	if ($(".payinfo").css("display")=="none"){
		return false;
	}
	return true;
}
function CardSearchDBClickHander(row){
	var myPatientID=row['TPatientID'];
	var Regno=row['RegNo'];
	var OtherCardNo=row['OtherCardNo'];
	$("#PAPMINo").val(row['RegNo']);
	GetPatDetailByPAPMINo();
	var CardNO=row['CardNO'];
	if (CardNO.indexOf(",")<0){
		var CardType=$.cm({
			ClassName:"web.DHCPATCardUnite",
			MethodName:"ReadCardTypeByDesc",
			Desc:CardNO,
			dataType:"text"
		},false)
		$("#CardTypeDefine").combobox('select',CardType);
	}else{
		$.messagert.alert("提示","患者拥有不止一种卡,请选择需要修改的对应卡类型!")
	}
	//设置其他证件信息
	CardTypeSave(OtherCardNo);
	//关联建卡使用登记号作为卡号，验证卡号的有效性
	CheckForUsePANoToCardNO("Modify");
}

//cache对象中以键值对的形式存储我们的缓存数据
var cache = {};
//index数组中该存储键，这个键是有顺序，可以方便我们做超出容量的处理
var index = [];
function createCache(){
    return function (key, value) {
        //如果传了值，就说名是设置值
        if(value !== undefined){
            //将数据存入cache对象，做缓存
            cache[key] = value;
            //将键存入index数组中，以和cache中的数据进行对应
            index.push(key);

            //判断缓存中的数据数量是不是超出了限制
            if(index.length >= 150){
                //如果超出了限制
                //删除掉最早存储缓存的数据
                //最早存入缓存的数据的键是在index数组的第一位
                //使用数组的shift方法可以获取并删除掉数组的第一个元素
                var tempKey = index.shift();
                //获取到最早加入缓存的这个数据的键，可以使用它将数据从缓存各种删除
                delete cache[tempKey];
            }
        }
        return cache[key];
    }
}
function SaveCahce(){
   var typeCache = createCache();
   var $txt=$(".textbox");
   for (var i=0;i<$txt.length;i++){
	   var id=$txt[i]['id'];
	   var _$label=$("label[for="+id+"]");
	   if (_$label.length==1){
		   var text=_$label[0].innerHTML;
		   typeCache(id,text);
	   }
   }
   $.cm({
		ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
		MethodName:"SaveCardRegDOMCache",
		dataType:"text",
		obj:JSON.stringify(cache)
   },function(rtn){});
}
///根据元素的classname获取元素值
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
function setFocus(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		$("#"+id).focus();
	}
	if (("^hisui-lookup^hisui-combobox^hisui-datebox").indexOf(("^"+className+"^"))>=0){
		$("#"+id).next('span').find('input').focus();
	}else{
		$("#"+id).focus();
	}
}
function DOMFocusJump(myComName){
	//var myComIdx=PageLogicObj.JumpAry.indexOf(myComName);
	var myComIdx=find(PageLogicObj.m_CardRegJumpSeqArr,myComName)
	//console.log(PageLogicObj.m_CardRegJumpSeqArr);
	if (myComIdx>=0){
		//var id=PageLogicObj.JumpAry[myComIdx+1];
		if (myComIdx==(PageLogicObj.m_CardRegJumpSeqArr.length-1)){
			//$("#NewCard").focus();
		}else{
			var id=PageLogicObj.m_CardRegJumpSeqArr[myComIdx+1]['id'];
			//alert(id);
			if (id!="undefined"){
				var _$id=$("#"+id);
				//if (_$id.hasClass("hisui-combobox")){
				if (_$id.next().hasClass('combo')){
					_$id.next('span').find('input').focus();
				}else{
					//alert(12);
					_$id.focus();
				}
				
			}
		}
		return false;
	}else{
		return true;
	}
	function find(list, elem) {
	  var index=-1;
	  for (var i = 0; i < list.length; i++) {
	    var current = list[i];
	    if (elem == current['id']) {
	        index=i;
	        break;
	    }
	  }
	  return index;
  }
}
var _89b = 0;
    function _89c(_89d, _89e) {
        var _89f = $.data(_89d, "combobox");
        var opts = _89f.options;
        var data = _89f.data;
        for (var i = 0; i < data.length; i++) {
            if (data[i][opts.valueField] == _89e) {
                return i;
            }
        }
        return -1;
    };
    function _8a0(_8a1, _8a2) {
        var opts = $.data(_8a1, "combobox").options;
        var _8a3 = $(_8a1).combo("panel");
        var item = opts.finder.getEl(_8a1, _8a2);
        if (item.length) {
            if (item.position().top <= 0) {
                var h = _8a3.scrollTop() + item.position().top;
                _8a3.scrollTop(h);
            } else {
                if (item.position().top + item.outerHeight() > _8a3.height()) {
                    var h = _8a3.scrollTop() + item.position().top + item.outerHeight() - _8a3.height();
                    _8a3.scrollTop(h);
                }
            }
        }
    };
    function nav(_8a4, dir) {
        var opts = $.data(_8a4, "combobox").options;
        var _8a5 = $(_8a4).combobox("panel");
        var item = _8a5.children("div.combobox-item-hover");
        if (!item.length) {
            item = _8a5.children("div.combobox-item-selected");
        }
        item.removeClass("combobox-item-hover");
        var _8a6 = "div.combobox-item:visible:not(.combobox-item-disabled):first";
        var _8a7 = "div.combobox-item:visible:not(.combobox-item-disabled):last";
        if (!item.length) {
            item = _8a5.children(dir == "next" ? _8a6 : _8a7);
        } else {
            if (dir == "next") {
                item = item.nextAll(_8a6);
                if (!item.length) {
                    item = _8a5.children(_8a6);
                }
            } else {
                item = item.prevAll(_8a6);
                if (!item.length) {
                    item = _8a5.children(_8a7);
                }
            }
        }
        if (item.length) {
            item.addClass("combobox-item-hover");
            var row = opts.finder.getRow(_8a4, item);
            if (row) {
                _8a0(_8a4, row[opts.valueField]);
                if (opts.selectOnNavigation) {
                    _8a8(_8a4, row[opts.valueField]);
                }
            }
        }
    };
    function _8a8(_8a9, _8aa) {
        var opts = $.data(_8a9, "combobox").options;
        var _8ab = $(_8a9).combo("getValues");
        if ($.inArray(_8aa + "", _8ab) == -1) {
            if (opts.multiple) {
                _8ab.push(_8aa);
            } else {
                _8ab = [_8aa];
            }
            _8ac(_8a9, _8ab);
            opts.onSelect.call(_8a9, opts.finder.getRow(_8a9, _8aa));
        }
    };
    function _8ad(_8ae, _8af) {
        var opts = $.data(_8ae, "combobox").options;
        var _8b0 = $(_8ae).combo("getValues");
        var _8b1 = $.inArray(_8af + "", _8b0);
        if (_8b1 >= 0) {
            _8b0.splice(_8b1, 1);
            _8ac(_8ae, _8b0);
            opts.onUnselect.call(_8ae, opts.finder.getRow(_8ae, _8af));
        }
    };
    function _8ac(_8b2, _8b3, _8b4) {
        var opts = $.data(_8b2, "combobox").options;
        var _8b5 = $(_8b2).combo("panel");
        _8b5.find("div.combobox-item-selected").removeClass("combobox-item-selected");
        var vv = [], ss = [];
        for (var i = 0; i < _8b3.length; i++) {
            var v = _8b3[i];
            var s = v;
            opts.finder.getEl(_8b2, v).addClass("combobox-item-selected");
            var row = opts.finder.getRow(_8b2, v);
            if (row) { 
                s = row[opts.textField];
            }else{
                //2019-1-26.neer 娴嬭瘯鍙戠幇 remote鏃?杈撳叆鏌ヨ鏉′欢鏌ヨ涓嶅嚭缁撴灉鏃?getValue()杩斿洖鐨勬槸鏌ヨ鏉′欢鍗充负getText()鐨勫??
                // row涓簎ndefined鏃?娓呯┖鍊?
                //if (opts.forceValidValue) {v = "";}
            }
            vv.push(v);
            ss.push(s);
        }
        $(_8b2).combo("setValues", vv);
        if (!_8b4) {
            $(_8b2).combo("setText", ss.join(opts.separator));
        }
        if(opts.rowStyle && opts.rowStyle=='checkbox'){ 
            //wanghc 2018-10-17 rowStyle=checkbox 閫変腑鏁版嵁琛屾椂,鍒ゆ柇鏄笉鏄簲璇ラ?変腑鍏ㄩ?夊嬀
            var tmpLen = $.data(_8b2, "combobox").data.length;
            if (vv.length==tmpLen){
                _8b5.parent().children("._hisui_combobox-selectall").addClass("checked");
            }else{
                _8b5.parent().children("._hisui_combobox-selectall").removeClass("checked");
            }
        }
    };
    function _8b6(_8b7, data, _8b8) {
        var _8b9 = $.data(_8b7, "combobox");
        var opts = _8b9.options;
        _8b9.data = opts.loadFilter.call(_8b7, data);
        _8b9.groups = [];
        data = _8b9.data;
        var _8ba = $(_8b7).combobox("getValues");
        var dd = [];
        var _8bb = undefined;
        for (var i = 0; i < data.length; i++) {
            var row = data[i];
            var v = row[opts.valueField] + "";
            var s = row[opts.textField];
            var g = row[opts.groupField];
            if (g) {
                if (_8bb != g) {
                    _8bb = g;
                    _8b9.groups.push(g);
                    dd.push("<div id=\"" + (_8b9.groupIdPrefix + "_" + (_8b9.groups.length - 1)) + "\" class=\"combobox-group\">");
                    dd.push(opts.groupFormatter ? opts.groupFormatter.call(_8b7, g) : g);
                    dd.push("</div>");
                }
            } else {
                _8bb = undefined;
            }
            var cls = "combobox-item" + (row.disabled ? " combobox-item-disabled" : "") + (g ? " combobox-gitem" : "");
            dd.push("<div id=\"" + (_8b9.itemIdPrefix + "_" + i) + "\" class=\"" + cls + "\">");
            dd.push(opts.formatter ? opts.formatter.call(_8b7, row) : s);
            dd.push("</div>");
            if (row["selected"] && $.inArray(v, _8ba) == -1) {
                _8ba.push(v);
            }
        }
        $(_8b7).combo("panel").html(dd.join(""));
        if (opts.multiple) {
            _8ac(_8b7, _8ba, _8b8);
            // wanghc 2018-10-17 checkbox all select
            if (opts.rowStyle && opts.rowStyle=='checkbox'){
                
                var myPanelJObj = $(_8b7).combo("panel");
                myPanelJObj.closest('.combo-p').children('._hisui_combobox-selectall').remove();
                var myPanelWidth = myPanelJObj.width() - 5; //5鏄痯adding-left
                var myallselJObj = $('<div style="width:'+myPanelWidth+'px" class="_hisui_combobox-selectall"><span class="combobox-checkbox"></span>鍏ㄩ??鍙栨秷鍏ㄩ??/div>')
                .bind('click',function(e){
                    var _t = $(this);
                    if (_t.hasClass('checked')){
                        _t.removeClass('checked');
                        $(_8b7).combobox("setValues",[]);
                    }else{
                        var tmpArr = [];
                        _t.addClass('checked');
                        $.map(data,function(v){
                            tmpArr.push(v[opts.valueField]);
                        });
                        $(_8b7).combobox("setValues",tmpArr);
                    }
                    if (opts.onAllSelectClick){
                        opts.onAllSelectClick.call(_8b7,e);
                    } 
                });
                if (opts.allSelectButtonPosition=='bottom'){
                    //myallselJObj.appendTo($(_8b7).combo("panel"));
                    myallselJObj.insertAfter(myPanelJObj);
                    myallselJObj.parent().addClass('bbtm');
                }else{
                    //myallselJObj.prependTo($(_8b7).combo("panel"));
                    myallselJObj.insertBefore(myPanelJObj);
                    myallselJObj.parent().addClass('btop');
                }
            }
        } else {
            _8ac(_8b7, _8ba.length ? [_8ba[_8ba.length - 1]] : [], _8b8);
        }
        opts.onLoadSuccess.call(_8b7, data);
    };
    function _8bc(_8bd, url, _8be, _8bf) {
        var opts = $.data(_8bd, "combobox").options;
        if (url) {
            opts.url = url;
        }
        _8be = _8be || {};
        if (opts.onBeforeLoad.call(_8bd, _8be) == false) {
            return;
        }
        opts.loader.call(_8bd, _8be, function (data) {
            _8b6(_8bd, data, _8bf);
        }, function () {
            opts.onLoadError.apply(this, arguments);
        });
    };
    function _8c0(_8c1, q) {
        var _8c2 = $.data(_8c1, "combobox");
        var opts = _8c2.options;
        if (opts.multiple && !q) {
            _8ac(_8c1, [], true);
        } else {
            _8ac(_8c1, [q], true);
        }
        if (opts.mode == "remote") {
            _8bc(_8c1, null, { q: q }, true);
        } else {
            var _8c3 = $(_8c1).combo("panel");
            _8c3.find("div.combobox-item-selected,div.combobox-item-hover").removeClass("combobox-item-selected combobox-item-hover");
            _8c3.find("div.combobox-item,div.combobox-group").hide();
            var data = _8c2.data;
            var vv = [];
            var qq = opts.multiple ? q.split(opts.separator) : [q];
            $.map(qq, function (q) {
                q = $.trim(q);
                var _8c4 = undefined;
                for (var i = 0; i < data.length; i++) {
                    var row = data[i];
                    if (opts.filter.call(_8c1, q, row)) {
                        var v = row[opts.valueField];
                        var s = row[opts.textField];
                        var g = row[opts.groupField];
                        var item = opts.finder.getEl(_8c1, v).show();
                        if (s.toLowerCase() == q.toLowerCase()) {
                            vv.push(v);
                            item.addClass("combobox-item-selected");
                            // wanghc 2018-11-7 杈撳叆楠ㄧ涓嶈兘杩涘叆onSelect浜嬩欢锛岃緭鍏ラ鍚庨?夐绉戝彲浠ヨ繘鍏nSelect闂
                            opts.onSelect.call(_8c1, opts.finder.getRow(_8c1, v));
                        }else{
	                        if ((row["AliasStr"])&&(row["AliasStr"]!="")){
								for (var i=0;i<row["AliasStr"].split("^").length;i++){
									if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
										vv.push(v);
			                            item.addClass("combobox-item-selected");
			                            // wanghc 2018-11-7 杈撳叆楠ㄧ涓嶈兘杩涘叆onSelect浜嬩欢锛岃緭鍏ラ鍚庨?夐绉戝彲浠ヨ繘鍏nSelect闂
			                            opts.onSelect.call(_8c1, opts.finder.getRow(_8c1, v));
									}
								}
							}
	                        }
                        if (opts.groupField && _8c4 != g) {
                            $("#" + _8c2.groupIdPrefix + "_" + $.inArray(g, _8c2.groups)).show();
                            _8c4 = g;
                        }
                    }
                }
            });
            _8ac(_8c1, vv, true);
        }
    };
    function _8c5(_8c6) {
        var t = $(_8c6);
        var opts = t.combobox("options");
        var _8c7 = t.combobox("panel");
        var item = _8c7.children("div.combobox-item-hover");
        if (item.length) {
            var row = opts.finder.getRow(_8c6, item);
            var _8c8 = row[opts.valueField];
            if (opts.multiple) {
                if (item.hasClass("combobox-item-selected")) {
                    t.combobox("unselect", _8c8);
                } else {
                    t.combobox("select", _8c8);
                }
            } else {
                t.combobox("select", _8c8);
            }
        }
        var vv = [];
        $.map(t.combobox("getValues"), function (v) {
            if (_89c(_8c6, v) >= 0) {
                vv.push(v);
            }
        });
        /*褰撻厤鍖瑰?间负绌轰笖enterNullValueClear涓篺lase鏃朵笉娓呯┖杈撳叆妗嗐?俛dd wanghc 2018-5-22*/
        if(vv.length==0 && !opts.enterNullValueClear){
        }else{
            t.combobox("setValues", vv);
        }
        if (!opts.multiple) {
            t.combobox("hidePanel");
        }
    };
    function _8c9(_8ca) {
        var _8cb = $.data(_8ca, "combobox");
        var opts = _8cb.options;
        _89b++;
        _8cb.itemIdPrefix = "_hisui_combobox_i" + _89b;
        _8cb.groupIdPrefix = "_hisui_combobox_g" + _89b;
        $(_8ca).addClass("combobox-f");
        $(_8ca).combo($.extend({}, opts, {
            onShowPanel: function () {
                $(_8ca).combo("panel").find("div.combobox-item,div.combobox-group").show();
                _8a0(_8ca, $(_8ca).combobox("getValue"));
                opts.onShowPanel.call(_8ca);
            }
        }));
        $(_8ca).combo("panel").unbind().bind("mouseover", function (e) {
            $(this).children("div.combobox-item-hover").removeClass("combobox-item-hover");
            var item = $(e.target).closest("div.combobox-item");
            if (!item.hasClass("combobox-item-disabled")) {
                item.addClass("combobox-item-hover");
            }
            e.stopPropagation();
        }).bind("mouseout", function (e) {
            $(e.target).closest("div.combobox-item").removeClass("combobox-item-hover");
            e.stopPropagation();
        }).bind("click", function (e) {
            var item = $(e.target).closest("div.combobox-item");
            if (!item.length || item.hasClass("combobox-item-disabled")) {
                return;
            }
            var row = opts.finder.getRow(_8ca, item);
            if (!row) {
                return;
            }
            var _8cc = row[opts.valueField];
            if (opts.multiple) {
                if (item.hasClass("combobox-item-selected")) {
                    _8ad(_8ca, _8cc);
                } else {
                    _8a8(_8ca, _8cc);
                }
            } else {
                _8a8(_8ca, _8cc);
                $(_8ca).combo("hidePanel");
            }
            e.stopPropagation();
        });
    };
function TelHomeKeyPress(e){
	var winEvent=window.event;
	var mykey=winEvent.keyCode;
	if (mykey==13){
		var TelHome = $("#TelHome").val();
		$.cm({
	    	ClassName : "web.DHCPATCardUnite",
	    	QueryName : "PatientCardQuery",
	    	Name:"",CredNo:"",BirthDay:"",Sex:"",UserID:"",TPAGCNTX:"",
	    	PatYBCode:"",Age:"",InMedicare:"",CredTypeID:"",TelHome:TelHome,
	    	Pagerows:PageLogicObj.m_FindPatListTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_FindPatListTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		});
	}
}
//JSON.parse(string)