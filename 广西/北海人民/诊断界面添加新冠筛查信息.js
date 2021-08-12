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
function InitTransferAdmShow(){
    $('body').append('<div id="TransferAdmWin" title="新冠筛查">'+
        '<table class="search-table">'+
            '<tr>'+
                '<td class="r-label">'+
                    '<label for="">等级</label>'+
                '</td>'+
                '<td>'+
                    '<select id="HospitalGrade" class="hisui-combobox" name="TransferHospitalGrade" style="width:240px;"></select>'+
                '</td>'+
                '<td class="r-label">'+
                    '<label for="">医院名称</label>'+
                '</td>'+
                '<td>'+
                    '<select id="HospitalGrade" class="hisui-combobox" name="TransferHospitalName" style="width:240px;"></select>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
                '<td class="r-label">'+
                    //'<label for="">等级</label>'+
                '</td>'+
                '<td>'+
                    //'<select id="HospitalGrade" class="hisui-combobox" name="TransferHospitalGrade" style="width:240px;"></select>'+
                '</td>'+
                '<td class="r-label">'+
                    '<label for="">其他医院</label>'+
                '</td>'+
                '<td>'+
                    //'<select id="HospitalGrade" class="hisui-combobox" name="TransferHospitalName" style="width:240px;"></select>'+
                    '<input class="hisui-validatebox" type="text" id="TransferHospitalNameStr" style="margin-right:10px;"/>'+
                '</td>'+
            '</tr>'+
            '<tr>'+
				'<td colspan="4" style="float:center">'+
					'<span style="coloe:red">医院名称选择其他才需要填写其他医院</span>'+
				'</td>'+
			'</tr>'+
            '<tr>'+
				'<td colspan="4" style="float:center">'+
					'<center><a href="#" id="TransferAdmSave" onClick="TransferAdmSaveClick()">保存</a></center>'+
				'</td>'+
			'</tr>'+
        '</table>'+
    '</div>');
    $("#TransferAdmWin").window({
        width:600,
        height:400,
        modal:true,
        center:true
    });
    $("#TransferHospitalNameStr").attr('disabled',true);
    $HUI.linkbutton("#TransferAdmSave",{
		iconCls: 'icon-save'
	});
    var HospitalGradeJson = $.cm({
		ClassName:"web.DHCDocTransferAdmLocal",
		MethodName:"GetHospitalGradeJson",
		dataType:"text",
        ModuleId:"33"
	},false);
	$HUI.combobox("#TransferHospitalGrade", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: eval("("+HospitalGradeJson+")"),
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
                    if (rec["text"].indexOf>0){
                        $("#TransferHospitalNameStr").attr('disabled',false);
                    }else{
                        $("#TransferHospitalNameStr").attr('disabled',true);
                    }
                }
            });
        }
	});
}
function TransferAdmSaveClick(){
    var TransferHospitalGrade=$("#TransferHospitalGrade").combobox("getText");
    var TransferHospitalName=$("#TransferHospitalName").combobox("getText");
    if (TransferHospitalName.indexOf("其他")>0) {
        TransferHospitalName=$("#TransferHospitalNameStr").val();
    }
    var RetStr = $.cm({
		ClassName:"web.DHCDocTransferAdmLocal",
		MethodName:"SaveInOtherHosname",
		dataType:"text",
		EpisodeID:ServerObj.EpisodeID,
		InOtherHosname:TransferHospitalName,
		Gradename:TransferHospitalGrade
	},false);
	if (RetStr!="0"){
		$.messager.alert("提示","保存信息失败！");
		return;
	}else{
		$("#TransferAdmWin").window('close');
	}
}