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
		PassFuncs.MKFuncs.MKXHZY();
	}else{
		PassFuncs.MKFuncs.MKXHZYCM();
	}
}

///审查方法
function HYLLUpdateClick_HLYY(){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.McSynCheckMode=="0"){
	    //美康同步审查
	    if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
		}
	    HLYYCheckFlag =1 ;
	}else{
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.MKFuncs.MKXHZYNoView();
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
        HisQueryData:function (){
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
			if (Orders==""){return;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return}
			var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,Orders,DocName);
            var TempArr=ret.split(String.fromCharCode(2));
			var PatInfo=TempArr[0];
			var MedCondInfo=TempArr[1];
			var AllergenInfo=TempArr[2];
			var OrderInfo=TempArr[3];
			var PatArr=PatInfo.split("^");
            /*DHCRecipeDataObj.PatCode = PatArr[0];			// 病人编码
			DHCRecipeDataObj.InHospNo= PatArr[11]
			DHCRecipeDataObj.VisitCode =PatArr[7]            // 住院次数*/
			DHCRecipeDataObj.PatName = PatArr[1];				// 病人姓名
			DHCRecipeDataObj.SexProp = PatArr[2];				// 性别
			DHCRecipeDataObj.AgeProp = PatArr[3];			// 出生年月
			DHCRecipeDataObj.Height = PatArr[5];			// 身高
			DHCRecipeDataObj.Weight = PatArr[6];			// 体重




			DHCRecipeDataObj.DeptCode  = PatArr[8];			// 住院科室
			DHCRecipeDataObj.DeptName  =PatArr[12]
			DHCRecipeDataObj.DoctorCode =PatArr[13] ;		// 医生
			DHCRecipeDataObj.DoctorName =PatArr[9]
			DHCRecipeDataObj.PatStatus =1
			DHCRecipeDataObj.UseTime  = PatArr[4];		   	// 使用时间

            DHCRecipeDataObj.EpisodeID=EpisodeID            // 就诊ID  
9.	    "BillType":"医保",      // 费别 (医保,自费)  
10.	    "BloodPress":"",        // 血压  
11.	    "SpecGrps":["肾功能不全","孕妇"],  //特殊人群  
12.	    "ProfessProp":"运动员",    // 职业  
13.	    "PatType":"门诊",          // 患者类别(门诊,住院,急诊)  
14.	    "PatLoc":"消化内科",       // 就诊科室  
15.	    "MainDoc":"石亚飞",        // 主管医生  
16.	    "Hospital":"东华标准版数字化医院[总院]",       // 医院(登录信息)
17.	    "Profess":"主管药师",       // 职称(登录用户) 
18.	    "Group":"安全用药智能决策",        //  安全组  
19.	    "LgCtLoc":"呼吸内科门诊",        // 登录科室 2020/12/1
20.	    "LgUser":"萧亚轩",        // 登录用户  2020/12/1
21.	    "EpisodeID":"001",        // 就诊ID  

        }
    }
}