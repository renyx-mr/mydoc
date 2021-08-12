function B_DiagInfoOnclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要填写的病人!");
		return false;
	}
	var EpisodeID=row["EpisodeID"];
	$('body').append('<div id="DiagWin" title="诊断相关">'+
	//'<div style="display:inline-block;vertical-align:top">'+
		'<table class="search-table">'+
			'<tr>'+
				'<td class="r-label">'+
					'<label for="">血压</label>'+
				'</td>'+
				'<td>'+
					'<input class="hisui-validatebox" type="text" id="BPSystolic" style="width:70px;margin-right:10px;"/>/'+
					'<input class="hisui-validatebox" type="text" id="BPDiastolic" style="width:70px;margin:0 10px;"/>mmHg'+
				'</td>'+
				'<td class="r-label">'+
					'<label for="">体重</label>'+
				'</td>'+
				'<td>'+
					'<input class="hisui-validatebox" type="text" id="Weight" style="width:70px;margin-right:10px;"/>Kg'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<td class="r-label">'+
					'<label for="">生理周期</label>'+
				'</td>'+
				'<td>'+
					'<select id="PhysiologicalCycle" class="hisui-combobox" name="PhysiologicalCycle" style="width:240px;"></select>'+
				'</td>'+
				'<td class="r-label">'+
					'<label for="">身高</label>'+
				'</td>'+
				'<td>'+
					'<input class="hisui-validatebox" type="text" id="Height" style="width:70px;margin-right:10px;"/>CM'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<td class="r-label">'+
					'<label for="">特殊人群</label>'+
				'</td>'+
				'<td colspan="3">'+
					'<select id="Special" class="hisui-combobox" name="Special" style="width:240px;"></select>'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<td colspan="4" style="float:center">'+
					'<center><a href="#" id="DiagInfoSave" onClick="DiagInfoSaveClick('+EpisodeID+')">保存</a></center>'+
				'</td>'+
			'</tr>'+
		'</table>'+
		//'</div>'+
	'</div>');
	$("#DiagWin").window({
    	width:600,
    	height:400,
    	modal:true,
    	center:true
	});
	var DiagOtherInfo= $.cm({
		ClassName:"web.DHCDocDiagnosEntryV8",
		MethodName:"GetDiagOtherInfo",
		dataType:"text",
		EpisodeID:EpisodeID
	},false);
	var DiagOtherInfoArr=DiagOtherInfo.split(String.fromCharCode(1));
	$("#BPSystolic").val(DiagOtherInfoArr[5]);
	$("#BPDiastolic").val(DiagOtherInfoArr[6]);
	$("#Weight").val(DiagOtherInfoArr[7]);
	$("#Height").val(DiagOtherInfoArr[10]);
	var PhysiologicalCycleJson = $.cm({
		ClassName:"web.DHCDocDiagnosEntryV8",
		MethodName:"GetPhysiologicalCycleJson",
		dataType:"text",
	},false);
	var cbox = $HUI.combobox("#PhysiologicalCycle", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		multiple:false,
		data: eval("("+PhysiologicalCycleJson+")"),
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#PhysiologicalCycle");
			var DiagOtherInfoArr=ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
			for (i=0;i<DiagOtherInfoArr[9].split("^").length;i++){
				sbox.select(DiagOtherInfoArr[9].split("^")[i]);
			}
		}
	});
	var SpecialJson = $.cm({
		ClassName:"web.DHCDocDiagnosEntryV8",
		MethodName:"GetSpecialJson",
		dataType:"text",
	},false);
	var cbox = $HUI.combobox("#Special", {
		valueField: 'id',
		textField: 'text', 
		editable:false,
		multiple:true,
		data: eval("("+SpecialJson+")"),
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#Special");
			var DiagOtherInfoArr=ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
			for (i=0;i<DiagOtherInfoArr[8].split("^").length;i++){
				sbox.select(DiagOtherInfoArr[8].split("^")[i]);
			}
		}
	});
	$HUI.linkbutton("#DiagInfoSave",{
		iconCls: 'icon-save'
	});
	//$("#DiagInfoSave").addClass("hisui-linkbutton");
}
function DiagInfoSaveClick(EpisodeID){
	if ((EpisodeID==="undefined")||(EpisodeID=="")){
		return;
	}
	var BPSystolic=$("#BPSystolic").val();
	var BPDiastolic=$("#BPDiastolic").val();
	var Weight=$("#Weight").val();
	var o=$HUI.combobox("#Special");
	var Specialist=o.getValues().join("!");
	var Subject=""
	var PhysiologicalCycle=$("#PhysiologicalCycle").combobox('getValue');
	if (PhysiologicalCycle==undefined) PhysiologicalCycle="";
	var Height=$("#Height").val();
	var AdmPara=""+"^"+Specialist+"^"+Subject+"^"+Weight+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+BPSystolic+"^"+BPDiastolic+"^"+PhysiologicalCycle+"^"+Height;
	var RetStr = $.cm({
		ClassName:"web.DHCMRDiagnos",
		MethodName:"UpdatePAADM",
		dataType:"text",
		EpisodeID:EpisodeID,
		AdmPara:AdmPara,
		PAPMIAddress:"Hidden",
		PAPMICompany:"Hidden"
	},false);
	if (RetStr!="0"){
		$.messager.alert("提示","保存诊断相关信息失败！");
		return;
	}else{
		$("#DiagWin").window('close');
	}
}