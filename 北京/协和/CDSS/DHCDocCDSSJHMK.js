//诊断 医嘱录入界面初始化调用 
// input:就诊id，就诊类型，界面类型（Diag：诊断，OEOrd：医嘱）
function HtmlPageLoadInit(AdmId,AdmType,PageType){
    //PassFuncs.
    if (PageType=="Diag") {
        PassFuncs.JHMKDiagPage(AdmId);
    }else{
        if (AdmType=="O") PassFuncs.JHMKOpenPage(AdmId);
        else PassFuncs.JHMKOrderPage(AdmId);
    }
}
//医嘱状态：下达/审核/开始/撤销/停止、废除
//input 就诊id，就诊类型，医嘱id串（使用“^”分割），医嘱状态（根据文档传入），删除类型（是否获取子医嘱串，“LinkSub”：获取子医嘱）
function CDSSUpdateOrdItemClick(AdmId,AdmType,SelOrdItemDrStr,StatusDesc,DelType){
	if (DelType=="LinkSub"){
		SelOrdItemDrStr=tkMakeServerCall("web.DHCDocHLYYJHMK","GetOrdItemLinkSub",SelOrdItemDrStr)
	}
    PassFuncs.JHMKUpdateOrdItemClick(AdmId,AdmType,SelOrdItemDrStr,StatusDesc);
}
//关闭cdss
function CloseJHMKCDSS(){
	PassFuncs.CloseJHMKCDSS();
}
//医嘱的保存调用
//input：就诊id，就诊类型，医嘱id串（使用“^”分割）
function CDSSUpdateClick_Check(AdmId,AdmType,OrderItemStr){
    PassFuncs.JHMKCheckOrder(AdmId,AdmType,OrderItemStr);
}
// 保存诊断时调用
//input：就诊id，诊断id
function HLYYUpdateDiagClick_Check(AdmId,MRDiagnosRowid){
    PassFuncs.JHMKCheckDiagnos(AdmId,MRDiagnosRowid);
}
//删除诊断
//input：就诊id，诊断id
function CDSSDeleteDiagClick(AdmId,MRDiagnosRowid){
    PassFuncs.JHMKDeleteDiagnos(AdmId,MRDiagnosRowid);
}
var PassFuncs={
	CloseJHMKCDSS:function(){
		closeCdssFront();
	},
    JHMKUpdateOrdItemClick:function(AdmId,AdmType,SelOrdItemDrStr,StatusDesc){
        var Source="40-5"
        if (AdmType=="I") Source="40-2";
        var InputData=this.JHMKCommonInfo(AdmId,Source);
        if (AdmType=="O") InputData.menzhenxiyichufang=this.JHMKGetOrdItem(AdmType,"",SelOrdItemDrStr,StatusDesc);
        else  InputData.yizhu=this.JHMKGetOrdItem(AdmType,"",SelOrdItemDrStr,StatusDesc);
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
    },
    JHMKCheckOrder:function(AdmId,AdmType,OrderItemStr){ //获取医嘱并推送
        var Source="40-5"
        if (AdmType=="I") Source="40-2";
        var InputData=this.JHMKCommonInfo(AdmId,Source);
        //if (CDSSLayout=="CMOEOrd") OrderItemStr=this.JHMKGetOrdItemInfo("ConvertCMOEOrdToOEOrd",OrderItemStr);
        if (AdmType=="O") InputData.menzhenxiyichufang=this.JHMKGetOrdItem(AdmType,"",OrderItemStr,",");
        else  InputData.yizhu=this.JHMKGetOrdItem(AdmType,"",OrderItemStr,",");
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKOpenPage:function(AdmId){
        var JHMKInputData=this.JHMKCommonInfo(AdmId,"40-4");
        JHMKInputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        var JHMKInputJson=JSON.stringify(JHMKInputData);
        var RetStr=cdssSendData(JHMKInputJson,"");
        return
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKCheckDiagnos:function(AdmId,MRDiagnosRowid){
        var InputData=this.JHMKCommonInfo(AdmId,"50-2");
        InputData.menzhenzhenduan=this.JHMKGetAdmDiagnos("",MRDiagnosRowid,"");
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKDeleteDiagnos:function(AdmId,MRDiagnosRowid){
        var InputData=this.JHMKCommonInfo(AdmId,"50-2");
        InputData.menzhenzhenduan=this.JHMKGetAdmDiagnos("",MRDiagnosRowid,"1");
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKDiagPage:function(AdmId){ //诊断界面初始化推送信息到嘉和
        var InputData=this.JHMKCommonInfo(AdmId,"50-1");
        //InputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKOrderPage:function(AdmId){
        var InputData=this.JHMKCommonInfo(AdmId,"40-1");
        //InputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        //alert(JSON.stringify(InputData));
        return
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        //alert(RetStr);
        //closeCdssFront();
    },
    JHMKCommonInfo:function(AdmId,Source){
        var JHMKSendData={};
        var GetPrescInfo=tkMakeServerCall("web.DHCDocHLYYJHMK","GetPrescInfo",AdmId,session['LOGON.USERID'],session['LOGON.CTLOCID']);
        if (GetPrescInfo=="") return JHMKSendData;
        var PatInfo=GetPrescInfo.split("$")[0];
        var DocInfo=GetPrescInfo.split("$")[1];
        JHMKSendData.patient_id=PatInfo.split("^")[0];
        JHMKSendData.patient_name=PatInfo.split("^")[1];
        JHMKSendData.visit_id=PatInfo.split("^")[2];
        JHMKSendData.pageSource=Source;
        JHMKSendData.patient_list="否";
        JHMKSendData.yonghuxinxi={
            user_id:DocInfo.split("^")[0],
            user_name:DocInfo.split("^")[1],
            user_dept:DocInfo.split("^")[2],
            education_title:DocInfo.split("^")[3]
        }
        return JHMKSendData;
    },
    JHMKGetPatAdmInfo:function(AdmId){
        var PatAdmObj={};
        var GetPatAdmInfo=this.JHMKGetOrdItemInfo("GetPatAdmInfo",AdmId);
        if (GetPatAdmInfo=="") return PatAdmObj;
        PatAdmObj.inp_no=GetPatAdmInfo.split("^")[0];
        PatAdmObj.name=GetPatAdmInfo.split("^")[1];
        PatAdmObj.sex_name=GetPatAdmInfo.split("^")[2];
        PatAdmObj.date_for_birth=GetPatAdmInfo.split("^")[3];
        PatAdmObj.visit_time=GetPatAdmInfo.split("^")[4];
        PatAdmObj.visit_dept_name=GetPatAdmInfo.split("^")[6];
        PatAdmObj.visit_dept_code=GetPatAdmInfo.split("^")[5];
        PatAdmObj.visit_doctor_name=GetPatAdmInfo.split("^")[8];
        PatAdmObj.visit_doctor_code=GetPatAdmInfo.split("^")[7];
        return PatAdmObj;
    },
    JHMKGetOrdItem:function(AdmType,OrderItemStr,SelOrdItemDrStr,StatusDesc){
        if ((OrderItemStr!="")&&(StatusDesc=="")){
            StatusDesc="审核"
            var OrdItemInfo=this.JHMKGetOrdItemInfo("GetOrdersInfo",OrderItemStr);
        }else{
            var OrdItemInfo=this.JHMKGetOrdItemInfo("GetVerifiedOrdersInfo",SelOrdItemDrStr);
        }
        if ((!OrdItemInfo)||(OrdItemInfo=="")||(OrdItemInfo=="undefined")) return {};
        var ArrayOrder=new Array();
        var OrderInfoArr=OrdItemInfo.split(String.fromCharCode(1));
        for(var i=0; i<OrderInfoArr.length ;i++){
            var OrderArr=OrderInfoArr[i].split("^");
            var OrdItemObj={};
            OrdItemObj.order_item_code=OrderArr[0];
            OrdItemObj.order_class_code=OrderArr[2];
            OrdItemObj.order_class_name=OrderArr[3];
            OrdItemObj.order_no=OrderArr[4];
            OrdItemObj.specification=OrderArr[5];
            OrdItemObj.duration_value=OrderArr[8];
            OrdItemObj.duration_unit=OrderArr[9];
            OrdItemObj.dosage_from=OrderArr[11];
            OrdItemObj.dosage_value=OrderArr[12];
            OrdItemObj.dosage_unit=OrderArr[13];
            OrdItemObj.total_dosage_value=OrderArr[14];
            OrdItemObj.total_dosage_unit=OrderArr[15];
            OrdItemObj.frequency_name=OrderArr[16];
            OrdItemObj.frequency_code=OrderArr[17];
            OrdItemObj.order_time=OrderArr[19];
            OrdItemObj.order_status_name=StatusDesc;
            if (AdmType=="I"){
                OrdItemObj.order_item_name=OrderArr[1];
                OrdItemObj.order_begin_time=OrderArr[6];
                OrdItemObj.order_end_time=OrderArr[7];
                OrdItemObj.order_properties_name=OrderArr[10];
                
            }else{
                OrdItemObj.charge_name=OrderArr[1];
                OrdItemObj.pharmacy_way_name=OrderArr[20];
            }
            ArrayOrder[ArrayOrder.length] = OrdItemObj;
        }
        return ArrayOrder;
    },
    JHMKGetOrdItemInfo:function(ClassMethodName,Arg1){
        //OrderItemStr
        var ReturnInfo=tkMakeServerCall("web.DHCDocHLYYJHMK",ClassMethodName,Arg1);
        return ReturnInfo;
    },
    JHMKGetAdmDiagnos:function(DiagItemStr,MRDiagnosRowid,DeleteFlag){
        var DiagnosInfo=this.JHMKGetOrdItemInfo("DelDiagnosInfo",MRDiagnosRowid)
        /*if (DeleteFlag==""){
        	DiagnosInfo=this.JHMKGetOrdItemInfo("GetDiagnosInfo",DiagItemStr);
        }else{
	        DiagnosInfo=this.JHMKGetOrdItemInfo("DelDiagnosInfo",MRDiagnosRowid);
        }*/
        if ((!DiagnosInfo)||(DiagnosInfo=="")||(DiagnosInfo=="undefined")) return {};
        var ArrayDiag=new Array();
        var DiagnosInfoArr=DiagnosInfo.split(String.fromCharCode(1));
        for(var i=0; i<DiagnosInfoArr.length ;i++){
            var DiagArr=DiagnosInfoArr[i].split("^");
            var DiagnosObj={};
            DiagnosObj.diagnosis_name=DiagArr[2];
            DiagnosObj.diagnosis_desc=DiagArr[0];
            DiagnosObj.diagnosis_code=DiagArr[1];
            DiagnosObj.diagnosis_time=DiagArr[4];
            DiagnosObj.diagnosis_num=DiagArr[3];
            DiagnosObj.diagnosis_flag_name=DiagArr[5];
            DiagnosObj.diagnosis_sub_num=DiagArr[6];
            DiagnosObj.diagnosis_type_name=DiagArr[7];
            DiagnosObj.DELETE_FLAG=DeleteFlag;
            ArrayDiag[ArrayDiag.length] = DiagnosObj;
        }
        return ArrayDiag;
    }
}