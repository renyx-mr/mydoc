///renyx 
///2017-11-28
///建档审核列表

$(function(){
	
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});

function PageHandle(){
	LoadRegistrationRegCard();
}
function Init(){
	InitOPFilingAuditDataGrid();
	InitIPFilingAuditDataGrid();
}
function InitEvent(){
	
}
function InitOPFilingAuditDataGrid(){
	// 序号	新生成日期	病历号明细	填写信息是否完整	门诊新建还是住院新建
	var Columns=[[ 
		{field:'PatNo',title:'序号',width:50,},
		{field:'CreateDate',title:'新生成日期',width:100},
		{field:'TabPrice',title:'病历号明细',width:50},
		{field:'TabSeqNo',title:'填写信息是否完整',width:50},
		{field:'TabDeptRowId',title:'门诊新建还是住院新建',width:100}
    ]]
	var selectedMarkListDataGrid=$("#OPFilingAudit").datagrid({
		fit:true,
		//rownumbers:true,
		columns:Columns,
		pageSize:99999,  
		//pageList:[60], 
	    //singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		//showHeader:false,
		rownumbers : false,
		//pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		onDblClickRow:function(index, row){
			//DelSelMarkListRow(row);
		}
	}); 
	return selectedMarkListDataGrid;
}
function InitIPFilingAuditDataGrid(){
	// 住院日期	住院号	收住科室	联系手机号	信息是否完整	审核状态	审核人

	var columns=[[
		{field:'PrtDoctorName',title:'住院日期',width:110},
		{field:'PrtDate1',title:'住院号',width:110},
		{field:'PrtTime2',title:'收住科室',width:110},
		{field:'PrtDoctorName3',title:'联系手机号',width:110},
		{field:'PrtDate4',title:'信息是否完整',width:110},
		{field:'PrtDate5',title:'审核状态',width:110},
		{field:'PrtTime6',title:'审核人',width:110}
	]];

	$HUI.datagrid('#IPFilingAudit',{
		fit:true,
		//rownumbers:true,
		columns:columns,
		pageSize:99999,  
		//pageList:[60], 
	    //singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		//showHeader:false,
		rownumbers : false,
		//pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
	});

	//$HUI.window("#IPFilingAudit").open();
}
function LoadRegistrationRegCard(){
	$('#RegistrationRegCard').empty();
	//src=src+"?PatListType="+PatListType;
	var src="websys.csp?a=a&TMENU=52802&TPAGID=4735695"
	var patientList= '<iframe id="framePatientList" src="'+src+'" width="100%" height="100%"'+
						'marginheight="0" marginwidth="0" scrolling="auto" align="middle" ></iframe>'
	$('#RegistrationRegCard').empty().append(patientList);
}