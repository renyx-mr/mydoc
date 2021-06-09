var PageLogicObj={
    m_TabApptRegisterLimitGrid:undefined,
    m_SexJsonStr:[{"code":"1","desc":"男"},{"code":"2","desc":"女"},{"code":"0","desc":"未知性别"},{"code":"9","desc":"未说明性别"}],
    editRow:undefined
}
$(function(){
	//页面元素初始化
	PageHandle();
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
	
});
function PageHandle(){
	
}
function Init(){
	//初始化 table数据
	PageLogicObj.m_TabApptRegisterLimitGrid=InitTabApptRegisterLimitGrid();
}
function InitEvent(){
    LoadTabApptRegisterLimitDataGrid();
}
function LoadTabApptRegisterLimitDataGrid(){
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCOPApptRegister';
	queryParams.QueryName ='OPApptRegisterList';
	queryParams.StarDate =$("#StartDate").datebox('getValue');
    queryParams.EndDate =$("#EndDate").datebox('getValue');
	//queryParams.ArgCnt =1;
	var opts = PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("options");
	opts.url = $URL;
	PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('clearSelections');
	PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('load', queryParams);
}
function InitTabApptRegisterLimitGrid(){
    var ItemOrderQtyLimitToolBar= [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                PageLogicObj.editRow = undefined;
                PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("rejectChanges");
                PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("unselectAll");
                if (PageLogicObj.editRow != undefined) {
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {
                        	OPAPPTPAPMIDR:"",
                            /*ApptRegisterDr:"1",
                            OPAPPTPAPMIDR:"",
                            OPAPPTDate:"",
                            OPAPPTWeek:"",*/
                        }
                    });
                    //将新插入的那一行开户编辑状态
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    PageLogicObj.editRow = 0;
                }
            
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                DelDateServer();
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                if(PageLogicObj.editRow==undefined){
                    return false;
                }
                SaveDateServer();
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.editRow = undefined;
                PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("rejectChanges");
                PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("unselectAll");
            }
        }];
    // 日期  星期  姓名  性别  联系方式  就诊目的  科别  出诊医生 预约时间 流调 车号 状态 备注 登记人
    ItemOrderQtyLimitColumns=[[    
        { field: 'ApptRegisterDr', title: '表id', width: 1,editor:{type:'text'},hidden:true},
        { field: 'OPAPPTPAPMIDR', title: 'PatId', width: 1,editor:{type:'text'},hidden:true},
        { field: 'OPAPPTDate', title: '日期', width: 140,editor:{type:'datebox'}},
        { field: 'OPAPPTWeek', title: '星期', width: 80,editor:{type:'text'}},
        { field: 'OPAPPTPatName', title: '姓名', width: 100,
            editor:{
                type:'combogrid',
                options:{
                    //required: true,
                    panelWidth:450,
                    panelHeight:350,
                    idField:'TID',
                    textField:'TPAPERName',
                    value:'',//缺省值 
                    mode:'remote',
                    pagination : true,//是否分页   
                    rownumbers:true,//序号   
                    collapsible:false,//是否可折叠的   
                    fit: true,//自动大小   
                    pageSize: 10,//每页显示的记录条数，默认为10   
                    pageList: [10],//可以设置每页记录条数的列表  
                    url:$URL+"?ClassName=web.DHCBL.Patient.DHCPatient&QueryName=SelectByPAPERID",
                    columns:[[
                        {field:'TID',title:'',hidden:'true'},
                        {field:'TPAPERName',title:'姓名',width:100,sortable:true},
                        {field:'TPAPERDob',title:'出生日期',width:100,sortable:true},
                        {field:'TPAPERSex',title:'性别',width:50,sortable:true},
                        {field:'TPAPMIDVAnumber',title:'身份证号',width:170,sortable:true}
                    ]],
                    onSelect : function(rowIndex, rowData) {
                        var rows=PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
                        if(rows){
                            rows.OPAPPTPAPMIDR=rowData.TID
                            rows.OPAPPTPatName=rowData.TPAPERName
                        }
                    },
                    onBeforeLoad:function(param){
                        var PatName=param['q'];
                        param = $.extend(param,{SPAPERID:"", SPAPERName:PatName, SPAPMINo:"", CardNo:"",
                        OutMedicareNo:"",InMedicareNo:"",EmMedicare:""});
                    }
                }
            }
        },
        { field: 'OPAPPTPatSex', title: '性别', width: 100,
            editor:{
                type:'combobox',
                options:{
                    editable:false,
                    valueField:'code',
                    textField:'desc',
                    data:PageLogicObj.m_SexJsonStr,
                    onSelect:function(rec){
                        var rows=PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
                        rows.OPAPPTPatSex=rec.code;
                    },
                    onChange:function(newValue, oldValue){
                        if (newValue==""){
                            var rows=PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
                                rows.OPAPPTPatSex="";
                        }
                    }
                }
            },
            formatter:function(value, record){
                if (value=="1"){
                    return "男";
                }else if(value=="2"){
                    return "女"
                }else if(value=="0"){
                    return "未知性别"
                }else if(value=="9"){
                    return "未告知性别"
                }
                return "";
            }
        },
        { field: 'OPAPPTPatPhone', title: '联系方式', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTPatAdmDesc', title: '就诊目的', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTPatAdmLoc', title: '科别', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTPatAdmDoc', title: '出诊医生', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTApptDate', title: '预约时间', width: 140, align: 'center', sortable: true,
            editor : {type : 'datebox',options : {}}
        },
        { field: 'OPAPPTCurrentReg', title: '流调', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTPatCarNo', title: '车号', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTRegisterStatus', title: '状态', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTRegisterDesc', title: '备注', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTWorkUnit', title: '工作单位', width: 100, align: 'center', sortable: true,
            editor : {type : 'text',options : {}}
        },
        { field: 'OPAPPTRegisterUserDr', title: '登记人', width: 100, align: 'center', sortable: true}
    ]];
    ItemOrderQtyLimitDataGrid=$('#TabApptRegisterLimit').datagrid({  
        fit : true,
        width : 'auto',
        Height : 'auto',
        border : true,
        striped : true,
        singleSelect : true,
        fitColumns : true,
        autoRowHeight : false,
        url:$URL+"?ClassName=web.DHCOPApptRegister&QueryName=OPApptRegisterList",
        loadMsg : '加载中..',  
        pagination : true,  //是否分页
        rownumbers : true,  //
        idField:"ApptRegisterDr",
        pageSize:15,
        pageList : [15,50,100,200],
        columns :ItemOrderQtyLimitColumns,
        toolbar :ItemOrderQtyLimitToolBar,
        onClickRow:function(rowIndex, rowData){
            if (PageLogicObj.editRow != undefined) {
                $.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
                return false;
            }
        },
        onDblClickRow:function(rowIndex, rowData){
            PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("beginEdit", rowIndex);
            PageLogicObj.editRow=rowIndex
        },
        onBeforeLoad:function(param){
	        var StarDate =$("#StartDate").datebox('getValue');
    		var EndDate =$("#EndDate").datebox('getValue');
            
            param = $.extend(param,{StarDate:StarDate,EndDate:EndDate});
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            PageLogicObj.editRow=undefined;
        }
    });
    return ItemOrderQtyLimitDataGrid;
}
function DelDateServer(){
    //删除时先获取选择行
    var rows = PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("getSelections");
    //选择要删除的行
    if (rows.length > 0) {
        $.messager.confirm("提示", "你确定要删除吗?",
        function(r) {
            if (r) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].ApptRegisterDr);
                }
                if (ids.length>1) {
                    $.messager.alert('提示',"请选择一条记录进行删除！");
                    return;
                }
                var ApptRegisterDr=ids.join(',');
                if (ApptRegisterDr==""){
                    PageLogicObj.editRow = undefined;
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("rejectChanges");
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("unselectAll");
                    return;
                }
                var value=$.m({
                     ClassName:"web.DHCOPApptRegister",
                     MethodName:"DeleteApptRegister",
                     ApptRegisterDr:ApptRegisterDr
                },false);
                if(value=="0"){
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('load');
                    PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('unselectAll');
                    $.messager.popover({msg:"删除成功!",type:'success'});
                }else{
                    $.messager.alert('提示',"删除失败:"+value);
                    return;
                }
                PageLogicObj.editRow = undefined;
            }
        });
    } else {
        $.messager.alert("提示", "请选择要删除的行", "error");
    }
}
function SaveDateServer(){
	
    var RowData = PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('getEditors', PageLogicObj.editRow);
    if (RowData.length==0){
		$.messager.alert("提示","没有正在编辑的行!");
		return false;
	}
	var SelRowData=PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
    var ApptRegisterDr=""
    if(RowData[0].target.val()) ApptRegisterDr=RowData[0].target.val();
    var OPAPPTPAPMIDR=""
    if (SelRowData.OPAPPTPAPMIDR!="") OPAPPTPAPMIDR=SelRowData.OPAPPTPAPMIDR;
    var OPAPPTDate=RowData[2].target.datebox('getValue');
    var OPAPPTWeek=RowData[3].target.val();
    var OPAPPTPatName=RowData[4].target.combobox('getText');
    var OPAPPTPatSex=RowData[5].target.combobox('getValue');
    var OPAPPTPatPhone=RowData[6].target.val();
    var OPAPPTPatAdmDesc=RowData[7].target.val();
    var OPAPPTPatAdmLoc=RowData[8].target.val();
    var OPAPPTPatAdmDoc=RowData[9].target.val();
    var OPAPPTApptDate=RowData[10].target.datebox('getValue');
    var OPAPPTCurrentReg=RowData[11].target.val();
    var OPAPPTPatCarNo=RowData[12].target.val();
    var OPAPPTRegisterStatus=RowData[13].target.val();
    var OPAPPTRegisterDesc=RowData[14].target.val();
    var OPAPPTWorkUnit=RowData[15].target.val();
    
    var ValStr=OPAPPTPAPMIDR+"^"+OPAPPTDate+"^"+OPAPPTWeek+"^"+OPAPPTPatName+"^"+OPAPPTPatSex
    ValStr=ValStr+"^"+OPAPPTPatPhone+"^"+OPAPPTPatAdmDesc+"^"+OPAPPTPatAdmLoc+"^"+OPAPPTPatAdmDoc+"^"+OPAPPTApptDate
    ValStr=ValStr+"^"+OPAPPTCurrentReg+"^"+OPAPPTPatCarNo+"^"+OPAPPTRegisterStatus+"^"+OPAPPTRegisterDesc+"^"+OPAPPTWorkUnit
    
    var value=$.m({
            ClassName:"web.DHCOPApptRegister",
            MethodName:"SaveApptRegister",
            datatype:"text",
            ApptRegisterDr:ApptRegisterDr,
            DataStr:ValStr,
            UserId:session['LOGON.USERID']
    },false);
    if(value=="0"){
        PageLogicObj.m_TabApptRegisterLimitGrid.datagrid("endEdit", PageLogicObj.editRow);
        PageLogicObj.editRow = undefined;
        PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('load');
        PageLogicObj.m_TabApptRegisterLimitGrid.datagrid('unselectAll');
        $.messager.popover({msg:"保存成功!",type:'success'});
    }else if(value=="-1"){
        $.messager.alert('提示',"不能增加或更新，该记录已存在");
        return false;
    }else{
        $.messager.alert('提示',"保存失败:"+value);
        return false;
    }
    PageLogicObj.editRow = undefined;
}