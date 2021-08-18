//新冠信息填写
function InitCovid19Show(){
    $('body').append('<div id="Covid19Win" title="新冠筛查">'+
        '<table class="search-table">'+
            '<tr>'+
                '<td class="r-label">'+
                    '<label for="">新冠病毒核酸筛查</label>'+
                '</td>'+
                '<td>'+
                    '<select id="FeverScreen" class="hisui-combobox" name="FeverScreen" style="width:240px;"></select>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td class="r-label">'+
                    '<label for="">病人去向</label>'+
                '</td>'+
                '<td>'+
                    '<select id="FeverGoto" class="hisui-combobox" name="FeverGoto" style="width:240px;"></select>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td class="r-label">'+
                    '<label for="">是否医护人员</label>'+
                '</td>'+
                '<td>'+
                    '<select id="FeverCareProv" class="hisui-combobox" name="FeverCareProv" style="width:240px;"></select>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td class="r-label">'+
                    '<label for="">七天内核酸阴性证明</label>'+
                '</td>'+
                '<td>'+
                    '<select id="FeverReport" class="hisui-combobox" name="FeverReport" style="width:240px;"></select>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td colspan="2">'+
                    '<label for="">* 两周内去过新冠疫情高/中风险地区或其他省份（填写否或具体省份）</label>'+
                    '<input class="hisui-validatebox" type="text" id="FeverDangerArea" style="margin-right:10px;"/>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td colspan="2">'+
                    '<label for="">* 是否属两周内入镜人员（填写否或具体国家）</label>'+
                    '<input class="hisui-validatebox" type="text" id="FeverForeign" style="margin-right:10px;"/>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td colspan="2">'+
                    '<label for="">* 近两周接触人员是否有发热或呼吸道症状（填写无或不详或接触人姓名）</label>'+
                    '<input class="hisui-validatebox" type="text" id="GoEpidemicNew" style="margin-right:10px;"/>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
				'<td colspan="2" style="float:center">'+
					'<center><a href="#" id="Covid19InfoSave" onClick="Covid19InfoSaveClick()">保存</a></center>'+
				'</td>'+
			'</tr>'+
        '</table>'+
    '</div>');
    $("#Covid19Win").window({
    	width:600,
    	height:400,
    	modal:true,
    	center:true
	});
    $HUI.linkbutton("#Covid19InfoSave",{
		iconCls: 'icon-save'
	});
    $HUI.combobox("#FeverScreen", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: [{id:"Y",text:"是"},{id:"N",text:"否"}],
    });
    $HUI.combobox("#FeverGoto", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: [{id:"H",text:"回家"},{id:"G",text:"感染科"},{id:"Q",text:"其他"}],
    });
    $HUI.combobox("#FeverCareProv", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: [{id:"Y",text:"是"},{id:"N",text:"否"}],
    });
    $HUI.combobox("#FeverReport", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: [{id:"Y",text:"是"},{id:"N",text:"否"}],
    });
}
function Covid19InfoSaveClick(){
    var FeverScreen=$("#FeverScreen").combobox('getValue');
    var FeverGoto=$("#FeverGoto").combobox('getValue');
    var FeverCareProv=$("#FeverCareProv").combobox('getValue');
    var FeverReport=$("#FeverReport").combobox('getValue');
    var FeverDangerArea=$("#FeverDangerArea").val();
    var FeverForeign=$("#FeverForeign").val();
    var GoEpidemicNew=$("#GoEpidemicNew").val();
    var RetStr = $.cm({
		ClassName:"web.DHCDocFeverPat",
		MethodName:"FeverInsert",
		dataType:"text",
		EpisodeID:ServerObj.EpisodeID,UserID:session['LOGON.USERID'],Status:"",
		GoEpidemic:"",WsStatus:"",GoEpidemicNew:GoEpidemicNew,
		FeverScreen:FeverScreen,FeverGoto:FeverGoto,FeverForeign:FeverForeign,
        DHCDocFeverWhCity:"",FeverCareProv:FeverCareProv,FeverDangerArea:FeverDangerArea,
        FeverReport:FeverReport
	},false);
    if (RetStr!="0"){
		$.messager.alert("提示","保存信息失败！");
		return;
	}else{
		$("#Covid19Win").window('close');
	}
}
//转入医院填写
/*---- 
<csp:method name=OnPreHTTP arguments="" returntype=%Boolean>
i ##Class(websys.SessionEvents).SessionExpired() q 1
quit 1
</csp:method>
<!DOCTYPE html>
<!--转出入诊 imedical/web/csp/dhcdoc.transfer.admlocal.hui.csp--> 
<HTML lang="zh-CN">
<HEAD>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<TITLE><EXTHEALTH:TRANSLATE id=title>##(%session.Get("TITLE"))##</EXTHEALTH:TRANSLATE></TITLE>
<EXTHEALTH:HEAD></EXTHEALTH:HEAD>
<HISUI></HISUI>
<STYLE type='text/css'>
.form-table{
   border-collapse:separate;
   border-spacing:0px 10px;
}

.form-table td{
    white-space: nowrap;	
}

.r-label,.ifhidden{
   text-align:right;
}

.minitext{
   width:80px!important;
}
.midtext{
   width:120px!important;
}
.maxtext{
   width:130px!important;
}
.line{
   padding:0px 5px;
   color:#DCDCDC;	
}
.ach-div{
   width:120px;
   margin:0px auto;
}
textarea{
   width:688px;
   border-color:#40a2de	
}
#patient-label label{
   width:100px;	
}

#tree_panel ul,#patient-label ul,.form-table tr td ul{
   list-style-type: none;
   display: flex; 
   flex-wrap: wrap
   justify-content: flex-start;
   align-items: center;
}
#btnAddItem,#btnUpdateItem {
   display:inline-block;
}
#btnClose,#btnUpdateItem {
   margin-left:20px;
}
</STYLE>
</HEAD>
<Server>
s EpisodeID=$g(%request.Data("EpisodeID",1))
s HospitalGradeJson=##class(web.DHCDocTransferAdmLocal).GetHospitalGradeJson("33")
</Server>

<body>
   <div id="TransferAdmWin">
       <table class="search-table">
           <tr>
               <td class="r-label">
                   <label for="">等级</label>
               </td>
               <td>
                   <select id="TransferHospitalGrade" class="hisui-combobox" name="TransferHospitalGrade" style="width:240px;"></select>
               </td>
               <td class="r-label">
                   <label for="">医院名称</label>
               </td>
               <td>
                   <select id="TransferHospitalName" class="hisui-combobox" name="TransferHospitalName" style="width:240px;"></select>
               </td>
           </tr>
           <tr>
               <td class="r-label">
               </td>
               <td></td>
               <td class="r-label">
                   <label for="">其他医院</label>
               </td>
               <td>
                   <input class="hisui-validatebox" type="text" id="TransferHospitalNameStr" style="margin-right:10px;"/>
               </td>
           </tr>
           <tr>
               <td colspan="4" >医院名称选择其他才需要填写其他医院</td>
           </tr>
           <tr>
               <td colspan="4" >
                   <center><a href="#" class="hisui-linkbutton" id="TransferAdmSave" onClick="TransferAdmSaveClick()" data-options="iconCls: 'icon-save'">保存</a></center>
               </td>
           </tr>
       </table>
   </div>
<SCRIPT language = 'javascript' >
       //全局请求后台服务对象
var ServerObj={
   EpisodeID:"#(EpisodeID)#",
   HospitalGradeJson:"#(HospitalGradeJson)#"
}
/// JQuery 初始化页面
$(function(){ InitPageDefault(); })
function TransferAdmSaveClick(){
   var TransferHospitalGrade=$("#TransferHospitalGrade").combobox("getText");
   var TransferHospitalName=$("#TransferHospitalName").combobox("getText");
   if (TransferHospitalName.indexOf("其他")>=0) {
       TransferHospitalName=$("#TransferHospitalNameStr").val();
   }
   if ((TransferHospitalGrade=="undefined")||(TransferHospitalGrade=="")){
       $.messager.alert("提示","医院等级不能为空！");
       websys_showModal('options').CallBackFunc(false)
       return;
   }
   if ((TransferHospitalName=="undefined")||(TransferHospitalName=="")){
       $.messager.alert("提示","医院名称不能为空！");
       websys_showModal('options').CallBackFunc(false)
   }
   var RetStr = $.cm({
       ClassName:"web.DHCDocTransferAdmLocal",
       MethodName:"SaveInOtherHosname",
       dataType:"text",
       EpisodeID:ServerObj.EpisodeID,
       InOtherHosname:TransferHospitalName,
       Gradename:TransferHospitalGrade
   },false);
   if (RetStr!="1"){
       $.messager.alert("提示","保存信息失败！");
       websys_showModal('options').CallBackFunc(false)
   }else{
       websys_showModal('options').CallBackFunc(true)
   }
}
function InitPageDefault(){
   //$HUI.combobox("#TransferHospitalName")
   $HUI.combobox("#TransferHospitalGrade", {
       valueField: 'id',
       textField: 'text', 
       editable:true,
       multiple:false,
       data: eval("("+ServerObj.HospitalGradeJson+")"),
       onSelect: function (rec) {
           var HospitalJson = $.cm({
               ClassName:"web.DHCDocTransferAdmLocal",
               MethodName:"GetHospitalJson",
               dataType:"text",
               HospitalGradeCode:rec["id"]
           },false);
           $HUI.combobox("#TransferHospitalName", {
               valueField: 'id',
               textField: 'text', 
               editable:true,
               multiple:false,
               data: eval("("+HospitalJson+")"),
               onSelect: function (rec) {
                   if (rec["text"].indexOf("其他")>=0){
                       $("#TransferHospitalNameStr").attr('disabled',false);
                   }else{
                       $("#TransferHospitalNameStr").attr('disabled',true);
                   }
               }
           });
       }
   });
}
</SCRIPT>
</body>
</html>
*/
// renyx 添加转入医院信息
var OutOtherHosFlag = $.cm({
    ClassName:"web.DHCDocTransferAdmLocal",
    MethodName:"CheckOutOtherHosFlag",
    dataType:"text",
    EpisodeID:GlobalObj.EpisodeID
},false);
if (OutOtherHosFlag=="Y") resolve(true);
var TransferAdmConfirm=dhcsys_confirm('病人是否转出?');
    if (!TransferAdmConfirm){
        resolve(true);
    }else{
        InitTransferAdmShow(resolve);
    }
function InitTransferAdmShow(){
    var lnk=encodeURI("dhcdoc.transfer.admlocal.hui.csp?EpisodeID="+GlobalObj.EpisodeID); 
    websys_showModal({
        url:lnk,
        title:'转出医院',
        width:750,height:400,
        closable:false,
        CallBackFunc:function(rtnStr){
            websys_showModal("close");
            if (typeof rtnStr=="undefined"){
                CallBackFun(false);
            }
            CallBackFun(rtnStr);
        }
    });
	return ;
    
}