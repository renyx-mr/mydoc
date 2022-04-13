1、导入文件夹中的三个文件
2、在csp中引用方法 ##class(web.DHDocCDSSInterface).Init(30) 加载第三方js和本地js
3、在 ##class(web.DHDocCDSSInterface).Init(30)  之前确定引用 json2.js和jquery.js供第三方使用
4、业务集中在DHCDocCDSSJHMK.js调用，方法中有入参说明
    --HtmlPageLoadInit 界面初始化的调用
    --CDSSUpdateOrdItemClick 撤销/停止、废除医嘱时调用 
    --CloseJHMKCDSS 关闭cdss
    --CDSSUpdateClick_Check 保存医嘱后调用和方法CDSSUpdateOrdItemClick同性质
    --HLYYUpdateDiagClick_Check 保存诊断时调用
    --CDSSDeleteDiagClick  删除诊断时调用 