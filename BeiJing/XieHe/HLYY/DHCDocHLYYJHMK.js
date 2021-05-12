//界面初始加载  
function HtmlPageLoadInit(AdmId,AdmType,PageType){
    //PassFuncs.
    if (PageType=="Diag") {
        PassFuncs.JHMKDiagPage(AdmId);
    }else{
        if (AdmType=="O") PassFuncs.JHMKOpenPage(AdmId);
        else PassFuncs.JHMKOrderPage(AdmId);
    }
}
//保存医嘱调用
function HLYYUpdateClick_Check(AdmId,AdmType,OrderItemStr){
    PassFuncs.JHMKCheckOrder(AdmId,AdmType,OrderItemStr);
}
function HLYYUpdateDiagClick_Check(AdmId,DiagItemStr){
    PassFuncs.JHMKCheckDiagnos(AdmId,DiagItemStr);
}
var PassFuncs={
    JHMKCheckOrder:function(AdmId,AdmType,OrderItemStr){ //保存医嘱时调用
        var Source="40-5"
        if (AdmType=="I") Source="40-2";
        var InputData=this.JHMKCommonInfo(AdmId,Source);
        if (AdmType=="O") InputData.yizhu=this.JHMKGetOrdItem(AdmType,OrderItemStr);
        else  InputData.menzhenxiyaochufang=this.JHMKGetOrdItem(AdmType,OrderItemStr)
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        alert(RetStr);
        closeCdssFront();
    },
    JHMKOpenPage:function(AdmId){
        var InputData=this.JHMKCommonInfo(AdmId,"40-4");
        InputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        alert(RetStr);
        closeCdssFront();
    },
    JHMKCheckDiagnos:function(AdmId,DiagItemStr){
        var InputData=this.JHMKCommonInfo(AdmId,"50-2");
        InputData.menzhenzhenduan=this.DiagItemStr(AdmId,DiagItemStr);
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        alert(RetStr);
        closeCdssFront();
    },
    JHMKDiagPage:function(AdmId){ //保存医嘱时调用
        var InputData=this.JHMKCommonInfo(AdmId,"50-1");
        //InputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        alert(RetStr);
        closeCdssFront();
    },
    JHMKOrderPage:function(AdmId){
        var InputData=this.JHMKCommonInfo(AdmId,"40-1");
        //InputData.menzhenjiuzhenjilu=this.JHMKGetPatAdmInfo(AdmId)
        var RetStr=cdssSendData(JSON.stringify(InputData),"");
        alert(RetStr);
        closeCdssFront();
    },
    JHMKCommonInfo:function(AdmId,Source){
        var SendData={};
        var GetPrescInfo=tkMakeServerCall("web.DHCDocHLYYJHMK","GetPrescInfo",AdmId,session['LOGON.USERID'],session['LOGON.CTLOCID']);
        if (GetPrescInfo=="") return SendData;
        var PatInfo=GetPrescInfo.split("$")[0];
        var DocInfo=GetPrescInfo.split("$")[1];
        SendData.patient_id=PatInfo.split("^")[0];
        SendData.patient_name=PatInfo.split("^")[1];
        SendData.visit_id=PatInfo.split("^")[2];
        SendData.pageSource=Source;
        SendData.patient_list="否";
        SendData.yonghuxinxi={
            user_id:DocInfo.split("^")[0],
            user_name:DocInfo.split("^")[1],
            user_dept:DocInfo.split("^")[2],
            education_title:DocInfo.split("^")[3]
        }
        return SendData;
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
        PatAdmObj.visit_dept_name=GetPatAdmInfo.split("^")[5];
        PatAdmObj.visit_dept_code=GetPatAdmInfo.split("^")[6];
        PatAdmObj.visit_doctor_name=GetPatAdmInfo.split("^")[7];
        PatAdmObj.visit_doctor_code=GetPatAdmInfo.split("^")[8];
        return PatAdmObj;
    },
    JHMKGetOrdItem:function(AdmType,OrderItemStr){
        var OrdItemInfo=this.JHMKGetOrdItemInfo("GetOrdersInfo",OrderItemStr);
        if ((!OrdItemInfo)||(OrdItemInfo=="")||(OrdItemInfo=="undefined")) return {};
        var ArrayOrder=new Array();
        var OrderInfoArr=OrdItemInfo.split(String.fromCharCode(1));
        for(var i=0; i<OrderInfoArr.length ;i++){
            var OrderArr=OrderInfoArr[i].split("^");
            var OrdItemObj={};
            OrdItemObj.order_item_code=OrderArr[0];
            OrdItemObj.order_class_name=OrderArr[2];
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
            if (AdmType=="I"){
                OrdItemObj.order_item_name=OrderArr[1];
                OrdItemObj.order_begin_time=OrderArr[6];
                OrdItemObj.order_end_time=OrderArr[7];
                OrdItemObj.order_properties_name=OrderArr[10];
                OrdItemObj.order_status_name=OrderArr[18];
            }else{
                OrdItemObj.charge_name="";
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
    JHMKGetAdmDiagnos:function(DiagItemStr){
        var DiagnosInfo=this.JHMKGetOrdItemInfo("GetDiagnosInfo",DiagItemStr);
        if ((!DiagnosInfo)||(DiagnosInfo=="")||(DiagnosInfo=="undefined")) return {};
        var ArrayDiag=new Array();
        var DiagnosInfoArr=DiagnosInfo.split(String.fromCharCode(1));
        for(var i=0; i<DiagnosInfoArr.length ;i++){
            var DiagArr=DiagnosInfoArr[i].split("^");
            var DiagnosObj={};
            DiagObj.diagnosis_name=DiagArr[1];
            DiagnosObj.diagnosis_desc=DiagArr[0];
            DiagnosObj.diagnosis_code=DiagArr[2];
            DiagnosObj.diagnosis_time=DiagArr[4];
            DiagnosObj.diagnosis_num=DiagArr[3];
            DiagnosObj.diagnosis_flag_name=DiagArr[5];
            DiagnosObj.diagnosis_sub_num=DiagArr[6];
            DiagnosObj.diagnosis_type_name=DiagArr[7];
            ArrayDiag[ArrayDiag.length] = DiagnosObj;
        }
        return ArrayDiag;
    }
}