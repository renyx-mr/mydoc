function ReadLinkRegInfoOnClick()
{
	
	var myHCTypeDR=$("#IEType").combobox("getValue");
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + myary[1]
		var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
		if (!xmlDoc) return;
		var nodes = xmlDoc.documentElement.childNodes;
		if (nodes.length<=0){return;}
		for (var i = 0; i < nodes.length; i++) {
 			var myItemName = getNodeName(nodes,i);
			var myItemValue = getNodeValue(nodes,i);
 			if(myItemName=="Name"){
				$("#ForeignName").val(myItemValue);
			}
			if(myItemName=="CredNo"){
 				$("#ForeignIDCard").val(myItemValue);
			}
			if(myItemName=="Address"){
 				$("#ForeignAddress").val(myItemValue);
			}	
  		}
  	}	
}