/**!
* 日期:   2021-03-29
* 新品组合理用药js【8.4.1】
* 
* V1.0
* renyx
* 封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用
*/

// 通用第三方药品知识库
function HLYYYDTS_Click(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//选中一行
		var ids=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 			
		if(ids==null || ids.length==0 || ids.length > 1) {  
			$.messager.alert("警告","请选择一条医嘱");  
			return;  
		}
		var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("警告","请选择一条医嘱");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0); //医嘱code
	var OrderName=mPiece(ArcimInfo,"^",1); //医嘱描述
	//PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
    var IncId=""
	window.open("dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName);
}

///通用药品相互作用
function XHZYClickHandler_HLYY(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.DHCFuncs.DHCXHZY();
	}else{
		PassFuncs.DHCFuncs.DHCXHZYCM();
	}
}

///审查方法
function HYLLUpdateClick_HLYY(){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.McSynCheckMode=="0"){
	    //美康同步审查
	    if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.DHCFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.DHCFuncs.HisScreenDataCM();
		}
	    HLYYCheckFlag =1 ;
	}else{
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.DHCFuncs.MKXHZYNoView();
		}else{
			PassFuncs.MKFuncs.MKXHZYNoViewCM();
		}
	}
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("合理用药检查有警告，你确认通过吗?", true);
			if (PrescCheck ==false) {
				return "-1"
			}
		}
		return 0;
	}else{
		return 100
	}
}

var DHCRecipeDataObj={};
var PassFuncs={
	DHCFuncs:{
        DHCYDTS:function(OrderARCIMCode,OrderName){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(11)
		},
		DHCXHZY:function(){
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){return false;}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){return false;}
			var AdmOrdItem=this.HisQueryOrdData();
			if (!AdmOrdItem){return false;}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			pdss.refresh(PdssObj, null, 1);  /// 调用审查接口 
		},
		DHCXHZYCM:function(){
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){return false;}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){return false;}
			var AdmOrdItem=this.HisQueryOrdDataCM();
			if (!AdmOrdItem){return false;}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			pdss.refresh(PdssObj, null, 1);  /// 调用审查接口 
		},
		HisQueryAdmInfoData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//获取患者就诊信息 
			var PatInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetPrescInfo",EpisodeID);
			if (PatInfo="") {
				return false;
			}
			var PatArr=PatInfo.split("^");
			DHCRecipeDataObj.MsgID=""	//日志监测id	必需
			DHCRecipeDataObj.Action=""	//应用场景（CheckRule：用药审查,EduRule 用药指导）必需
			DHCRecipeDataObj.PatName = PatArr[1];				// 病人姓名
			DHCRecipeDataObj.SexProp = PatArr[2];				// 性别
			DHCRecipeDataObj.AgeProp = PatArr[3];			// 出生年月
			DHCRecipeDataObj.Height = PatArr[4];			// 身高
			DHCRecipeDataObj.Weight = PatArr[5];			// 体重
			DHCRecipeDataObj.BillType= PatArr[6];				//费别 (医保,自费)	必需
			DHCRecipeDataObj.BloodPress= PatArr[7];				//血压	必需
			DHCRecipeDataObj.SpecGrps= PatArr[8];				//特殊人群	必需
			DHCRecipeDataObj.ProfessProp= PatArr[9];				//职业	必需
			DHCRecipeDataObj.PatType= PatArr[10];				//就诊类型(门诊,住院,急诊)	必需
			DHCRecipeDataObj.PatLoc= PatArr[11];			//就诊科室	必需
			DHCRecipeDataObj.MainDoc= PatArr[12];				//主管医生	必需
			DHCRecipeDataObj.Group= session['LOGON.GROUPDESC'];	 //安全组-描述(登录信息)	必需(2020/12/1)
			DHCRecipeDataObj.Hospital= session['LOGON.HOSPDESC'];		//医院-描述(登录信息)	必需(2020/12/1)
			DHCRecipeDataObj.LgCtLoc = session['LOGON.CTLOCDESC'];		//登录科室-描述(登录信息)	必需(2020/12/1)
			DHCRecipeDataObj.LgUser = session['LOGON.USERNAME'];	//登录用户-描述(登录信息)	必需(2020/12/1)
			DHCRecipeDataObj.Profess = "";				//职称-描述(登录信息)	必需(2020/12/1)
			DHCRecipeDataObj.EpisodeID = EpisodeID;				//就诊ID	必需
			return DHCRecipeDataObj;
		},
		HisQueryDiagnosData:function(){
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			//获取诊断信息 
			var MedCondInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetMRDiagnos",EpisodeID);
			if (MedCondInfo=""){
				return false;
			}
			var ArrayMedCond = new Array();
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var Medcond;       
				Medcond.id = MedCondArr[0];        //诊断编码
		      	Medcond.item = MedCondArr[1];     //诊断名称
				ArrayMedCond[ArrayMedCond.length] = Medcond;    
			}
			return ArrayMedCond;
		},
		HisQueryOrdDataCM:function(){
			var Orders="";
			var Para1=""
			var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
		    var OrderSeqNo=0;
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						var OrderSeqNo=OrderSeqNo+1;
				   		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+PHCDoseUOMRowid;
					    Para1=Para1+"!"+PrescFrequenceRowid+"!"+PrescDurationRowid+"!"+PrescInstructionID+"!"+OrderDrugFormRowid+"!"+OrderSeqNo+"!"+OrderSeqNo+"!"+MasterSeqNo;
						if ((OrderARCIMRowid!="")){
							if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
						}
				   }
			    }
			}
			if (Orders==""){return false;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return false;}
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,Orders);
			if (RetOrderInfo=""){
				return false;
			}
			var OutPutObj;
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=new Array();
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<OrderInfoArr.length ;i++){			
				var OrderArr=OrderInfoArr[i].split("^");
		      	var ItemOrder;       
				ItemOrder.SeqNo=OrderArr[0]; //	医嘱序号	必需
				ItemOrder.PhDesc=OrderArr[1]; //	药品名称	必需
				ItemOrder.FormProp=OrderArr[2]; //	剂型	必需
				ItemOrder.OnceDose=OrderArr[3]; //	单次剂量	必需
				ItemOrder.Unit=OrderArr[4]; //	单次剂量单位	必需
				ItemOrder.DrugPreMet=OrderArr[5]; //	用法	必需
				ItemOrder.DrugFreq=OrderArr[6]; //	频次	必需
				ItemOrder.Treatment=OrderArr[7]; //	疗程	必需
				ItemOrder.id=OrderArr[8]; //	标识	必需
				ItemOrder.LinkSeqNo=OrderArr[9]; //	关联序号(1, 1.1, 1.2)	必需
				ItemOrder.OrdDate=OrderArr[10]; //	医嘱日期	必需
				ItemOrder.IsFirstUseProp=OrderArr[11]; //	是否首次(首次/非首次)	必需
				ItemOrder.DurgSpeedProp=OrderArr[12]; //	给药速度	必需
				ItemOrder.DrugSpeedPropUnit=OrderArr[13]; //	给药速度单位	必需
				ItemOrder.OrdEndDate=OrderArr[14]; //	医嘱停止日期	必需(2020/12/17增加)
				ArrayOrder[ArrayOrder.length] = ItemOrder;    
			}
			OutPutObj.ItemOrder = ArrayOrder;
			var ArrayHisOrder=new Array();
			var HisOrderInfo=HisOrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<HisOrderInfo.length ;i++){			
				var HisOrderArr=HisOrderInfo[i].split("^");
		      	var ItemHisOrder;       
				ItemHisOrder.SeqNo=HisOrderArr[0]; //	医嘱序号	必需
				ItemHisOrder.PhDesc=HisOrderArr[1]; //	药品名称	必需
				ItemHisOrder.FormProp=HisOrderArr[2]; //	剂型	必需
				ItemHisOrder.OnceDose=HisOrderArr[3]; //	单次剂量	必需
				ItemHisOrder.Unit=HisOrderArr[4]; //	单次剂量单位	必需
				ItemHisOrder.DrugPreMet=HisOrderArr[5]; //	用法	必需
				ItemHisOrder.DrugFreq=HisOrderArr[6]; //	频次	必需
				ItemHisOrder.Treatment=HisOrderArr[7]; //	疗程	必需
				ItemHisOrder.id=HisOrderArr[8]; //	标识	必需
				ItemHisOrder.LinkSeqNo=HisOrderArr[9]; //	关联序号(1, 1.1, 1.2)	必需
				ItemHisOrder.OrdDate=HisOrderArr[10]; //	医嘱日期	必需
				ItemHisOrder.IsFirstUseProp=HisOrderArr[11]; //	是否首次(首次/非首次)	必需
				ItemHisOrder.DurgSpeedProp=HisOrderArr[12]; //	给药速度	必需
				ItemHisOrder.DrugSpeedPropUnit=HisOrderArr[13]; //	给药速度单位	必需
				ItemHisOrder.OrdEndDate=HisOrderArr[14]; //	医嘱停止日期	必需(2020/12/17增加)
				ArrayHisOrder[ArrayHisOrder.length] = ItemHisOrder;    
			}
			OutPutObj.ItemHisOrder = ArrayHisOrder;
		},
        HisQueryOrdData:function (){
            DHCRecipeDataObj={};
            var Orders="";
			var Para1=""
			var rowids=$('#Order_DataGrid').getDataIDs();
			for(var i=0;i<rowids.length;i++){
				var Row=rowids[i];
				var OrderItemRowid=GetCellData(Row,"OrderItemRowid");
				var OrderARCIMRowid=GetCellData(Row,"OrderARCIMRowid");
				var OrderType=GetCellData(Row,"OrderType");
				var OrderDurRowid=GetCellData(Row,"OrderDurRowid");
				var OrderFreqRowid=GetCellData(Row,"OrderFreqRowid");
				var OrderInstrRowid=GetCellData(Row,"OrderInstrRowid");
				var OrderDoseQty=GetCellData(Row,"OrderDoseQty");
				var OrderDoseUOMRowid=GetCellData(Row,"OrderDoseUOMRowid");
		    	var OrderDrugFormRowid=GetCellData(Row,"OrderDrugFormRowid");
				var OrderPHPrescType=GetCellData(Row,"OrderPHPrescType");
				var OrderPriorRowId=GetCellData(Row,"OrderPriorRowid");
				var OrderSeqNo=GetCellData(Row,"id");
				var OrderPackQty = GetCellData(Row,"OrderPackQty");
				var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
				//$(Row+"_OrderMKLight").html(str);
				var OrderMasterSeqNo=GetCellData(Row,"OrderMasterSeqNo");
				//var obj=document.getElementById("McRecipeCheckLight_"+OrderSeqNo,Row);
			    //判断是否处理草药
			    if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;}
			    if (OrderType!="R") {continue;}
			    if (OrderARCIMRowid=="") {continue;}
			    if (OrderItemRowid!="") {continue;}
			    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
			    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+OrderPriorRowId+"!"+OrderSeqNo+"!"+Row+"!"+OrderMasterSeqNo;
				Para1=Para1+"!"+OrderPackQty+"!"+OrderPackUOMRowid;
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
					if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
				}
			}
			if (Orders==""){return false;}
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,Orders);
			if (RetOrderInfo=""){
				return false;
			}
			var OutPutObj;
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=new Array();
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<OrderInfoArr.length ;i++){			
				var OrderArr=OrderInfoArr[i].split("^");
		      	var ItemOrder;       
				ItemOrder.SeqNo=OrderArr[0]; //	医嘱序号	必需
				ItemOrder.PhDesc=OrderArr[1]; //	药品名称	必需
				ItemOrder.FormProp=OrderArr[2]; //	剂型	必需
				ItemOrder.OnceDose=OrderArr[3]; //	单次剂量	必需
				ItemOrder.Unit=OrderArr[4]; //	单次剂量单位	必需
				ItemOrder.DrugPreMet=OrderArr[5]; //	用法	必需
				ItemOrder.DrugFreq=OrderArr[6]; //	频次	必需
				ItemOrder.Treatment=OrderArr[7]; //	疗程	必需
				ItemOrder.id=OrderArr[8]; //	标识	必需
				ItemOrder.LinkSeqNo=OrderArr[9]; //	关联序号(1, 1.1, 1.2)	必需
				ItemOrder.OrdDate=OrderArr[10]; //	医嘱日期	必需
				ItemOrder.IsFirstUseProp=OrderArr[11]; //	是否首次(首次/非首次)	必需
				ItemOrder.DurgSpeedProp=OrderArr[12]; //	给药速度	必需
				ItemOrder.DrugSpeedPropUnit=OrderArr[13]; //	给药速度单位	必需
				ItemOrder.OrdEndDate=OrderArr[14]; //	医嘱停止日期	必需(2020/12/17增加)
				ArrayOrder[ArrayOrder.length] = ItemOrder;    
			}
			OutPutObj.ItemOrder = ArrayOrder;
			var ArrayHisOrder=new Array();
			var HisOrderInfo=HisOrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<HisOrderInfo.length ;i++){			
				var HisOrderArr=HisOrderInfo[i].split("^");
		      	var ItemHisOrder;       
				ItemHisOrder.SeqNo=HisOrderArr[0]; //	医嘱序号	必需
				ItemHisOrder.PhDesc=HisOrderArr[1]; //	药品名称	必需
				ItemHisOrder.FormProp=HisOrderArr[2]; //	剂型	必需
				ItemHisOrder.OnceDose=HisOrderArr[3]; //	单次剂量	必需
				ItemHisOrder.Unit=HisOrderArr[4]; //	单次剂量单位	必需
				ItemHisOrder.DrugPreMet=HisOrderArr[5]; //	用法	必需
				ItemHisOrder.DrugFreq=HisOrderArr[6]; //	频次	必需
				ItemHisOrder.Treatment=HisOrderArr[7]; //	疗程	必需
				ItemHisOrder.id=HisOrderArr[8]; //	标识	必需
				ItemHisOrder.LinkSeqNo=HisOrderArr[9]; //	关联序号(1, 1.1, 1.2)	必需
				ItemHisOrder.OrdDate=HisOrderArr[10]; //	医嘱日期	必需
				ItemHisOrder.IsFirstUseProp=HisOrderArr[11]; //	是否首次(首次/非首次)	必需
				ItemHisOrder.DurgSpeedProp=HisOrderArr[12]; //	给药速度	必需
				ItemHisOrder.DrugSpeedPropUnit=HisOrderArr[13]; //	给药速度单位	必需
				ItemHisOrder.OrdEndDate=HisOrderArr[14]; //	医嘱停止日期	必需(2020/12/17增加)
				ArrayHisOrder[ArrayHisOrder.length] = ItemHisOrder;    
			}
			OutPutObj.ItemHisOrder = ArrayHisOrder;
		}
    }
}