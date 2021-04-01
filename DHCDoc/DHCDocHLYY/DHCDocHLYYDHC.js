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
function DHCUpdateClick_HLYY(CallBackFunc,OrderItemStr,Mode){
	if (Mode=="Check") {	//干预
		var rtn=DHCUpdateClick_Check(CallBackFunc,OrderItemStr);
	}
	if (Mode=="Save") {		//保存
		var rtn=DHCUpdateClick_Save(CallBackFunc,OrderItemStr);
	}
	return;
}
function DHCUpdateClick_Check(CallBackFunc,OrderItemStr) {
	var HLYYInfo=PassFuncs.DHCFuncs.DHCXHZY();
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","CheckHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,GlobalObj.HLYYLayOut,HZYYLogicObj.ExpStr);
	//dhcsys_alert("Check=="+HLYYInfo,"500")
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//不需要调用合理用药或者程序异常
		//return true;
		CallBackFunc(true);
		return;
	}
	//var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr.passFlag=="0"){
		//错误等级<8
		if (HLYYArr[1]!="") {
			//存在问题提示是否修改
			/*HLYYArr[1]=HLYYArr[1].replace(/\<br>/g, "\n")
			var rtn=dhcsys_confirm("合理用药提示:"+"\n"+HLYYArr[1]+"\n"+"是否继续审核?","","","","500");
			if (rtn) {return true;}else{return false;}*/
			$.messager.confirm('确认对话框',"合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"是否继续审核?", function(r){
				if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
			});
		}else{
			//不存在问题
			//return true;
			CallBackFunc(true);
		}
	}else if (HLYYArr.passFlag=="1"){
		//错误等级>=8
		//dhcsys_alert("合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改","500");
		//return false;
		$.messager.alert("提示", "合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改", "info",function(){
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
var DHCRecipeDataObj={};
var PassFuncs={
	DHCFuncs:{
        DHCYDTS:function(OrderARCIMCode,OrderName){
			var IncId=""
			linkUrl="dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName
			websys_showModal({
				url:linkUrl,
				title:'药品说明书',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
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
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			var DHCPdss = new PDSS({});
			DHCPdss.refresh(PdssObj, null, 1);  /// 调用审查接口 
			return DHCPdss;
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
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			var DHCPdss = new PDSS({});
			DHCPdss.refresh(PdssObj, null, 1);  /// 调用审查接口
			return DHCPdss;
		},
		HisOperationsData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//获取患者过敏信息 
			var OperationsInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetOperationsInfo",EpisodeID);
			if (OperationsInfo="") {
				return false;
			}
			var ArrayOperations = new Array();
			var OperationsInfoArr=OperationsInfo.split(String.fromCharCode(1));
			for(var i=0; i<OperationsInfoArr.length ;i++){			
				var OperationsArr=OperationsInfoArr[i].split("^");
		      	var Operations;       
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
			var AllergiesInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetAllergiesInfo",EpisodeID);
			if (AllergiesInfo="") {
				return false;
			}
			var ArrayAllergies = new Array();
			var AllergiesInfoArr=AllergiesInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergiesInfoArr.length ;i++){			
				var Allergiesrr=AllergiesInfoArr[i].split("^");
		      	var Allergies;       
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
		HisQueryOrdDataCM:function(OrderItemStr){
			if (OrderItemStr==""){return false;}
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return false;}
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr);
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
        HisQueryOrdData:function (OrderItemStr){
			if ((OrderItemStr=="")||(OrderItemStr="undefined")){return false;}
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if ((EpisodeID=="")||(EpisodeID="undefined")){return false;}
			//获取医嘱信息  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYMKDHCDoc.Interface.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr);
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