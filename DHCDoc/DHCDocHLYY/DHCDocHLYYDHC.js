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
	PassFuncs.DHCFuncs.DHCYDTS(OrderARCIMCode,OrderName);
   
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
function HYLLUpdateClick_HLYY(CallBackFunc,OrderItemStr,Mode){
	if (Mode=="Check") {	//干预
		var rtn=DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode);
	}
	if (Mode=="CheckCM") {	//干预
		var rtn=DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode);
	}
	/*if (Mode=="Save") {		//保存
		var rtn=DHCUpdateClick_Save(CallBackFunc,OrderItemStr);
	}*/
	return;
}
function DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode) {
	
	var HLYYInfo=""
	if (Mode=="Check"){
		HLYYInfo=PassFuncs.DHCFuncs.DHCXHZY(OrderItemStr);
	}else{
		HLYYInfo=PassFuncs.DHCFuncs.DHCXHZYCM(OrderItemStr,Mode);
	}
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","CheckHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,GlobalObj.HLYYLayOut,HZYYLogicObj.ExpStr);
	//dhcsys_alert("Check=="+HLYYInfo,"500")
	
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//不需要调用合理用药或者程序异常
		//return true;
		CallBackFunc(true);
		return;
	}
	//var HLYYArr=HLYYInfo.split("^");
	if (HLYYInfo.passFlag=="1"){
		//错误等级<8
		/*if (HLYYInfo!="") {
			//存在问题提示是否修改
			/*HLYYArr[1]=HLYYArr[1].replace(/\<br>/g, "\n")
			var rtn=dhcsys_confirm("合理用药提示:"+"\n"+HLYYArr[1]+"\n"+"是否继续审核?","","","","500");
			if (rtn) {return true;}else{return false;}
			$.messager.confirm('确认对话框',"合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"是否继续审核?", function(r){
				if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
			});
		}else{*/
			//不存在问题
			//return true;
			CallBackFunc(true);
		//}
	}else if (HLYYInfo.passFlag=="0"){
		//错误等级>=8
		//dhcsys_alert("合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改","500");
		//return false;
		$.messager.alert("提示", "合理用药未审核通过请返回修改", "info",function(){
			CallBackFunc(false);
		});
	}else{
		//var rtn=dhcsys_confirm("合理用药干预系统异常:"+"\n"+HLYYArr[1]+"\n"+"请联系信息科!若确认审核医嘱请点击【确定】","","","","500");
		//if (rtn) {return true;}else{return false;}
		$.messager.confirm('确认对话框',"合理用药干预系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!若确认审核医嘱请点击【确定】", function(r){
			if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
		});
	}
	return;
}

function DHCUpdateClick_Save(CallBackFunc,OrderItemStr) {
	return "";
	var HLYYInfo=$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"SaveHLYYInfo",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderStr:OrderItemStr,
		ExpStr:HZYYLogicObj.ExpStr
	},false);
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","SaveHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,HZYYLogicObj.ExpStr);
	//dhcsys_alert("Save=="+HLYYInfo,"500")
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//不需要调用合理用药或者程序异常
		//return true;
		CallBackFunc(true);
		return;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]!=0){
		//dhcsys_alert("合理用药保存系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!","500");
		$.messager.alert("提示","合理用药保存系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!", "info",function(){
			CallBackFunc(true);
		});
	}
	return;
}

var PassFuncs={
	DHCFuncs:{
		DHCPdssCallBack:function(option){
			if (option.passFlag=="1") option.close() 
		},
        DHCYDTS:function(OrderARCIMCode,OrderName){
			var IncId=""
			linkUrl="dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName
			websys_showModal({
				url:linkUrl,
				title:'药品说明书',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		},
		DHCXHZY:function(OrderItemStr){
			//if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) OrderItemStr=this.GetOrderDataOnAdd();
			if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) return "";
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){return "";}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){return "";}
			
			var AdmOrdItem=this.HisQueryOrdData(OrderItemStr);
			if (!AdmOrdItem){return "";}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			var DHCPdss = new PDSS({});
			DHCPdss.refresh(PdssObj, this.DHCPdssCallBack, 3);  /// 调用审查接口
			debugger; 
			return DHCPdss;
		},
		DHCXHZYCM:function(OrderItemStr,Mode){
			//if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) OrderItemStr=this.GetOrderDataOnAddCM();
			if (Mode=="CheckCM") OrderItemStr=this.GetOrderDataOnAddCM();
			if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) return "";
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){return "";}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){return "";}
			
			var AdmOrdItem=this.HisQueryOrdDataCM(OrderItemStr);
			if (!AdmOrdItem){return "";}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			var DHCPdss = new PDSS({});
			DHCPdss.refresh(PdssObj, this.DHCPdssCallBack, 3);  /// 调用审查接口
			return DHCPdss;
		},
		HisOperationsData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//获取患者过敏信息 
			var OperationsInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetOperationsInfo",EpisodeID);
			if (OperationsInfo=="") {
				return false;
			}
			var ArrayOperations = new Array();
			var OperationsInfoArr=OperationsInfo.split(String.fromCharCode(1));
			for(var i=0; i<OperationsInfoArr.length ;i++){			
				var OperationsArr=OperationsInfoArr[i].split("^");
		      	var Operations={};       
				Operations.id = OperationsArr[0];        //诊断编码
		      	Operations.item = OperationsArr[1];     //诊断名称
				ArrayOperations[ArrayOperations.length] = Operations;    
			}
			return ArrayOperations;
		},
		HisAllergiesData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//获取患者过敏信息 
			var AllergiesInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetAllergiesInfo",EpisodeID);
			if (AllergiesInfo=="") {
				return false;
			}
			var ArrayAllergies = new Array();
			var AllergiesInfoArr=AllergiesInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergiesInfoArr.length ;i++){			
				var Allergiesrr=AllergiesInfoArr[i].split("^");
		      	var Allergies={};       
				Allergies.id = Allergiesrr[0];        //诊断编码
		      	Allergies.item = Allergiesrr[1];     //诊断名称
				ArrayAllergies[ArrayAllergies.length] = Allergies;    
			}
			return ArrayAllergies;
		},
		HisQueryAdmInfoData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//获取患者就诊信息 
			var PatInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetPrescInfo",EpisodeID);
			if (PatInfo=="") {
				return false;
			}
			var PatArr=PatInfo.split("^");
			var DHCRecipeDataObj={}
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
			var MedCondInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetMRDiagnos",EpisodeID);
			if (MedCondInfo==""){
				return false;
			}
			var ArrayMedCond = new Array();
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var Medcond={};       
				Medcond.id = MedCondArr[0];        //诊断编码
		      	Medcond.item = MedCondArr[1];     //诊断名称
				ArrayMedCond[ArrayMedCond.length] = Medcond;    
			}
			return ArrayMedCond;
		},
		HisQueryOrdDataCM:function(OrderItemStr){
			if (OrderItemStr==""){return false;}
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return false;}
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr,"CMOEOrd");
			if (RetOrderInfo==""){
				return false;
			}
			var OutPutObj={};
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			if (OrderInfo=="") return false;
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=this.GetOrderData(OrderInfo);
			
			if (ArrayOrder.length>0) OutPutObj.ItemOrder = ArrayOrder;
			if ((!HisOrderInfo)||(HisOrderInfo=="")||(HisOrderInfo=="undefined")) return OutPutObj;
			var ArrayHisOrder=this.GetOrderData(HisOrderInfo);
			
			if (ArrayHisOrder.length>0) OutPutObj.ItemHisOrder = ArrayHisOrder;
			return OutPutObj;
		},
        HisQueryOrdData:function (OrderItemStr){
			if ((OrderItemStr=="")||(OrderItemStr=="undefined")){return false;}
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if ((EpisodeID=="")||(EpisodeID=="undefined")){return false;}
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr);
			if (RetOrderInfo==""){
				return false;
			}
			var OutPutObj={};
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			if (OrderInfo=="") return false;
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=this.GetOrderData(OrderInfo);
			
			if (ArrayOrder.length>0) OutPutObj.ItemOrder = ArrayOrder;
			if ((!HisOrderInfo)||(HisOrderInfo=="")||(HisOrderInfo=="undefined")) return OutPutObj;
			
			//var HisOrderInfo=HisOrderInfo.split(String.fromCharCode(1));
			var ArrayHisOrder=this.GetOrderData(HisOrderInfo);
			if (ArrayHisOrder.length>0) OutPutObj.ItemHisOrder = ArrayHisOrder;
			return OutPutObj;
		},
		GetOrderData:function(OrderInfo){
			var ArrayOrder=new Array();
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<OrderInfoArr.length ;i++){			
				var OrderArr=OrderInfoArr[i].split("^");
		      	var ItemOrder={};       
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
			return ArrayOrder;
		},
		GetOrderDataOnAdd:function(){
			var OrderItemStr = "";
			var OrderItem = "";
			var OneOrderItem = "";
			//快速医嘱套中包含的医嘱数量
			var OrderItemCongeriesNum=0;
			//try {
				var DataArry = GetGirdData();
				for (var i = 0; i < DataArry.length; i++) {
					var OrderItemRowid = DataArry[i]["OrderItemRowid"];
					if (OrderItemRowid!="") continue;
					var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
					if (OrderARCIMRowid == "") continue;
					var OrderType = DataArry[i]["OrderType"];
					if (OrderType!="R") continue;
					var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
					///tanjishan 2015-09    
					//if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
					var StyleConfigStr = DataArry[i]["StyleConfigStr"];
					var StyleConfigObj = {};
					if (StyleConfigStr != "") {
						StyleConfigObj = eval("(" + StyleConfigStr + ")");
					}
					if ((GlobalObj.PAAdmType != "I") && (StyleConfigObj.OrderPackQty != true) && (OrderItemRowid != "")) { continue }
					if ((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) { continue; }
					//原序号  现行ID
					var OrderSeqNo = DataArry[i]["id"];
					var OrderName = DataArry[i]["OrderName"];
					
					var OrderPriorRowid = DataArry[i]["OrderPriorRowid"];
					var OrderRecDepRowid = DataArry[i]["OrderRecDepRowid"];
					//$.messager.alert("警告",OrderRecDepRowid);
					var OrderFreqRowid = DataArry[i]["OrderFreqRowid"];
					var OrderDurRowid = DataArry[i]["OrderDurRowid"];
					var OrderInstrRowid = DataArry[i]["OrderInstrRowid"];
					var OrderDoseQty = DataArry[i]["OrderDoseQty"];
					/*if(OrderDoseQty.indexOf(".")!=-1) {
						if(OrderDoseQty.split(".")[0]==""){
							OrderDoseQty="0."+OrderDoseQty.split(".")[1]
						}
					}*/
					var OrderDoseQty = FormateNumber(OrderDoseQty);
					var OrderDoseUOMRowid = DataArry[i]["OrderDoseUOMRowid"];
					var OrderPackQty = DataArry[i]["OrderPackQty"];
					var OrderPrice = DataArry[i]["OrderPrice"];
					
					var PHPrescType = DataArry[i]["OrderPHPrescType"];
					var BillTypeRowid = DataArry[i]["OrderBillTypeRowid"];
					var OrderSkinTest = DataArry[i]["OrderSkinTest"];
					var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
					var OrderDrugFormRowid = DataArry[i]["OrderDrugFormRowid"];
					var OrderStartDateStr = DataArry[i]["OrderStartDate"];
					var OrderStartDate = "";
					var OrderStartTime = "";
					if (OrderStartDateStr != "") {
						OrderStartDate = OrderStartDateStr.split(" ")[0];
						OrderStartTime = OrderStartDateStr.split(" ")[1];
					}
					//关联
					var OrderMasterSeqNo = DataArry[i]["OrderMasterSeqNo"];
					if (parseFloat(OrderItemCongeriesNum)>0){
						OrderMasterSeqNo=parseFloat(OrderItemCongeriesNum)+OrderMasterSeqNo;
					}
					var OrderDepProcNotes = DataArry[i]["OrderDepProcNote"];
					var OrderPhSpecInstr = ""; //DataArry[i]["OrderPhSpecInstr"];
					var OrderCoverMainIns = DataArry[i]["OrderCoverMainIns"];
					var OrderActionRowid = DataArry[i]["OrderActionRowid"];
					var OrderEndDateStr = DataArry[i]["OrderEndDate"];
					var OrderEndDate = "";
					var OrderEndTime = "";
					if (OrderEndDateStr != "") {
						OrderEndDate = OrderEndDateStr.split(" ")[0];
						OrderEndTime = OrderEndDateStr.split(" ")[1];
					}
					//$.messager.alert("警告",OrderEndDate+"^"+OrderEndTime);
					var OrderLabSpecRowid = DataArry[i]["OrderLabSpecRowid"];
					var OrderMultiDate = ""; //DataArry[i]["OrderMultiDate"];
					var OrderNotifyClinician = ""; //DataArry[i]["OrderNotifyClinician"];
					//if (OrderNotifyClinician==true){OrderNotifyClinician="Y"}else{OrderNotifyClinician="N"}
					var OrderDIACatRowId = DataArry[i]["OrderDIACatRowId"];
					//医保类别
					var OrderInsurCatRowId = DataArry[i]["OrderInsurCatRowId"];
					//医嘱首日次数
					var OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];
					//如果是生成取药医嘱,自备药长嘱只生成执行记录,如果是自备药即刻
					if (((OrderPriorRowid == GlobalObj.LongOrderPriorRowid) || (OrderPriorRowid == GlobalObj.OMSOrderPriorRowid)) && (GlobalObj.PAAdmType == "I")) OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];

					//医保适应症
					var OrderInsurSignSymptomCode = ""; //DataArry[i]["OrderInsurSignSymptomCode"];

					//身体部位
					var OrderBodyPart = DataArry[i]["OrderBodyPart"];
					if (OrderBodyPart != "") {
						if (OrderDepProcNotes != "") {
							OrderDepProcNotes = OrderDepProcNotes + "," + OrderBodyPart;
						} else {
							OrderDepProcNotes = OrderBodyPart;
						}
					}

					//医嘱阶段
					var OrderStageCode = DataArry[i]["OrderStageCode"];
					//输液滴速
					var OrderSpeedFlowRate = DataArry[i]["OrderSpeedFlowRate"];
					OrderSpeedFlowRate = FormateNumber(OrderSpeedFlowRate);
					//GetMenuPara("AnaesthesiaID");
					var AnaesthesiaID = DataArry[i]["AnaesthesiaID"];
					var OrderLabEpisodeNo = DataArry[i]["OrderLabEpisodeNo"];

					var VerifiedOrderMasterRowid = "";
					//营养药标志
					var OrderNutritionDrugFlag = ""; //DataArry[i]["OrderNutritionDrugFlag"];
					//补录关联主医嘱信息 
					var LinkedMasterOrderRowid = DataArry[i]["LinkedMasterOrderRowid"];
					var LinkedMasterOrderSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
					if ((LinkedMasterOrderSeqNo != "") && (OrderMasterSeqNo == "")) {
						OrderMasterSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
					}
					//if ((VerifiedOrderMasterRowid!="")&&(LinkedMasterOrderRowid=="")) LinkedMasterOrderRowid=VerifiedOrderMasterRowid;

					//审批类型
					var OrderInsurApproveType = ""; //DataArry[i]["OrderInsurApproveType"];
					//临床路径步骤
					var OrderCPWStepItemRowId = DataArry[i]["OrderCPWStepItemRowId"];
					//高值材料条码
					var OrderMaterialBarCode = DataArry[i]["OrderMaterialBarcodeHiden"];
					//输液滴速单位
					var OrderFlowRateUnit = DataArry[i]["OrderFlowRateUnit"];
					var OrderFlowRateUnitRowId = DataArry[i]["OrderFlowRateUnitRowId"];
					//开医嘱日期
					var OrderDate = "";
					var OrderTime = "";
					var OrderDateStr = DataArry[i]["OrderDate"];
					if (OrderDateStr != "") {
						OrderDate = OrderDateStr.split(" ")[0];
						OrderTime = OrderDateStr.split(" ")[1];
					}
					//需要配液
					var OrderNeedPIVAFlag = DataArry[i]["OrderNeedPIVAFlag"];
					//****************抗生素10********************************/
					// 管制药品申请
					var OrderAntibApplyRowid = DataArry[i]["OrderAntibApplyRowid"];
					//抗生素使用原因
					var AntUseReason = DataArry[i]["AntUseReason"];
					//使用目的
					var UserReasonId = DataArry[i]["UserReasonId"];
					var ShowTabStr = DataArry[i]["ShowTabStr"];
					//************************************************/
					//输液次数
					var OrderLocalInfusionQty = DataArry[i]["OrderLocalInfusionQty"];
					//个人自备
					var OrderBySelfOMFlag = "";
					if (DataArry[i]["OrderSelfOMFlag"]) OrderBySelfOMFlag = DataArry[i]["OrderSelfOMFlag"];
					var OrderOutsourcingFlag = "";
					if (DataArry[i]["OrderOutsourcingFlag"]) OrderOutsourcingFlag = DataArry[i]["OrderOutsourcingFlag"];
					//超量疗程原因
					var ExceedReasonID = DataArry[i]["ExceedReasonID"];
					//是否加急
					var OrderNotifyClinician = DataArry[i]["Urgent"];
					//整包装单位
					var OrderPackUOMRowid = DataArry[i]["OrderPackUOMRowid"];
					var OrderOperationCode=DataArry[i]["OrderOperationCode"];
					var OrderFreqDispTimeStr = DataArry[i]["OrderFreqDispTimeStr"]; 
					var OrderFreqInfo=DataArry[i]["OrderFreqFactor"]+"^"+DataArry[i]["OrderFreqInterval"]+"^"+OrderFreqDispTimeStr;
					var OrderDurFactor=DataArry[i]["OrderDurFactor"];
					var OrderHiddenPara=DataArry[i]["OrderHiddenPara"];
					var OrderQtyInfo="" //GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,OrderDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderHiddenPara);
					var OrderQtySum="" //mPiece(OrderQtyInfo, "^", 0)
					var OrderPackQty="" //mPiece(OrderQtyInfo, "^",1)
					
					var OrderPriorRemarks = DataArry[i]["OrderPriorRemarksRowId"];
					OrderPriorRowid = "" //ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
					//药理项目
					var OrderPilotProRowid = DataArry[i]["OrderPilotProRowid"];
					if (GlobalObj.PAAdmType == "I") {
						if (GlobalObj.CFIPPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFIPPilotPatAdmReason;
					} else {
						if (GlobalObj.CFPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFPilotPatAdmReason;
					}

					if (OrderDoseQty == "") { OrderDoseUOMRowid = "" }
					//检查申请子表记录Id
					var ApplyArcId="";
					//治疗申请预约ID
					var DCAARowId=GlobalObj.DCAARowId
					//临床知识库检测表id
					var OrderMonitorId=DataArry[i]["OrderMonitorId"];
					var OrderNurseLinkOrderRowid=DataArry[i]["OrderNurseLinkOrderRowid"];;
					var OrderBodyPartLabel=DataArry[i]["OrderBodyPartLabel"];
					if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
					var CelerType="N";	//快速医嘱套标识
					var OrdRowIndex=DataArry[i]["id"];
					var OrderFreqWeekStr="" //CalOrderFreqWeekStr(OrderFreqDispTimeStr);
					OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
					OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
					OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
					OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
					OrderItem = OrderItem + "^" + OrderActionRowid + "^" + OrderARCOSRowid + "^" + OrderEndDate + "^" + OrderEndTime + "^" + OrderLabSpecRowid + "^" + OrderMultiDate;
					OrderItem = OrderItem + "^" + OrderNotifyClinician + "^" + OrderDIACatRowId + "^" + OrderInsurCatRowId + "^" + OrderFirstDayTimes + "^" + OrderInsurSignSymptomCode;
					OrderItem = OrderItem + "^" + OrderStageCode + "^" + OrderSpeedFlowRate + "^" + AnaesthesiaID + "^" + OrderLabEpisodeNo;
					OrderItem = OrderItem + "^" + LinkedMasterOrderRowid + "^" + OrderNutritionDrugFlag;
					OrderItem = OrderItem + "^" + OrderMaterialBarCode + "^^" + OrderCPWStepItemRowId + "^" + OrderInsurApproveType;
					OrderItem = OrderItem + "^" + OrderFlowRateUnitRowId + "^" + OrderDate + "^" + OrderTime + "^" + OrderNeedPIVAFlag + "^" + OrderAntibApplyRowid + "^" + AntUseReason + "^" + UserReasonId;
					OrderItem = OrderItem + "^" + OrderLocalInfusionQty + "^" + OrderBySelfOMFlag + "^" + ExceedReasonID + "^" + OrderPackUOMRowid + "^" + OrderPilotProRowid + "^" + OrderOutsourcingFlag;
					OrderItem = OrderItem + "^" + OrderItemRowid + "^" + ApplyArcId + "^" + DCAARowId + "^" + OrderOperationCode;
					OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr;
					
					if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }

				}
			//} catch (e) { $.messager.alert("警告", e.message) }
			return OrderItemStr;
		},
		GetOrderDataOnAddCM:function(){
			var OrderItemStr=""; 
		   var OrderItem=""; 
		   try{
				var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
				var PrescDurRowid=$('#PrescDuration').combobox("getValue");
				var PrescDurFactor=GetDurFactor();
				var PrescInstrRowid=$('#PrescInstruction').combobox("getValue");
				var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
				var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
				var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
				var PrescCookDecoction="N";
				var cbox=$HUI.checkbox("#PrescCookDecoction");
				if (cbox.getValue()) PrescCookDecoction="Y"; //是否代煎
				var PrescNotes=$('#PrescNotes').val();
				var PrescEmergency=$("#PrescUrgent").checkbox('getValue')?"Y":"N"; //是否加急
				var PrescStartDate="",PrescStartTime="",ARCOSRowId="";
				//开始日期,如果是出院/死亡后费用调整,开始日期必须是出院日期时间
				if (GlobalObj.CurrentDischargeStatus=="B") {
					PrescStartDate=GlobalObj.DischargeDate;
					PrescStartTime=GlobalObj.DischargeTime;
				}else{
					PrescStartDate="";
				}
				var AddLongOrder="";
				if (GlobalObj.PAAdmType=="I"){
					AddLongOrder=$('#AddLongOrderList').combobox('getValue');
					if (!AddLongOrder) AddLongOrder="";
				}
				var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
				var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
				//var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
				var DetailsArr=CMPrescTypeDetails.split("#");
				var CMPrescTypeCode=DetailsArr[0];		
				var IPCookModeFeeNoAutoAdd=DetailsArr[9];
				var CNMedCookModeFeeItemRowid=DetailsArr[10];
				var CNMedAppendItem=DetailsArr[11];
				var CMPrescTypeLinkFeeStr=DetailsArr[17];
				var PrescAppenItemQty=$('#PrescAppenItemQty').val();
				var PrescStr=OrderPriorRowid+"^"+PrescDurRowid+"^"+PrescInstrRowid+"^"+PrescFreqRowid+"^"+PrescCookDecoction+"^"+PrescOrderQty+"^"+OrderRecDepRowid+"^"+GlobalObj.OrderBillTypeRowid+"^"+PrescNotes+"^"+PrescEmergency+"^"+PrescStartDate+"^"+PrescStartTime+"^"+PageLogicObj.m_ARCOSRowId;					
				var PrescWeight=GetPrescWeight();
				var PrescStr=PrescStr+"^"+PrescWeight+"^"+AddLongOrder+"^"+CMPrescTypeCode+"^"+PageLogicObj.PractiacRowStr+"^"+PrescAppenItemQty+"^"+GlobalObj.AntCVID;
				var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
				for(var i=1;i<=rows;i++){
					var Row=i;
					for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
					   if (OrderARCIMRowid!=""){
							var OrderName=GetCellData(i,j,"OrderName");
							var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
							var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text(); //GetCellData(i,j,"OrderPhSpecInstr");
							var OrderPrice=GetCellData(i,j,"OrderPrice");
							var OrderItemSum=GetCellData(i,j,"OrderSum");
							OrderQtySum=parseFloat(OrderDoseQty)*parseFloat(PrescDurFactor);
							OrderQtySum=OrderQtySum.toFixed(4);
							var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
							var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
							var PHCDoseUOMRowid=OrderHiddenPara.split(String.fromCharCode(3))[10];
							var OrderDoseUOMRowid=PHCDoseUOMRowid;
							if (OrderDoseQty==""){OrderDoseUOMRowid=""}
							var INCIPackCombStr =CheckINCIPackSum(j, Row,"0");
							if (INCIPackCombStr=="") return "";
							var cellPosi=i+";"+j; //单元格位置
							OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderPhSpecInstr +"^"+""+"^"+ARCIMARCOSRowid+"^"+INCIPackCombStr+"^"+cellPosi+"^"+OrderHiddenPara;
							if (OrderItemStr==""){OrderItemStr=OrderItem}else{OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem}
					   }
					}
				}
				if (OrderItem=="") return "";
				
				if (OrderItemStr!=""){OrderItemStr=PrescStr+String.fromCharCode(2)+OrderItemStr};
				return OrderItemStr;
			}catch(e){$.messager.alert("提示",e.message);return false;}
		}
    }
}