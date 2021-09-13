1、导入 csp，js，cls文件
2、本地化参数设置增加简易门诊科室id串的配置。

// renyx 添加简易门诊用药限制
	s SimpleClinicLocIdStr=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPDoc","SimpleClinicLocIdStr",LogonHospId)
	if (SimpleClinicLocIdStr[(","_LogonLocId_",")){
		s DHCItmMastBHDr=$o(^DHCItmMastBH("0","ARCIM",ARCIMRowid,0))
		if (DHCItmMastBHDr=""){
			s OutInfo="-1^" _OrderName _"不属于简易门诊科室用药，请重新开立！"
			s $P(OutInfo,"^",4)="OrderName"
			q OutInfo
		}else{
			s ItemBHMaxDay=+$p($g(^DHCItmMastBH(DHCItmMastBHDr)),"^",2)
			if (OrderDurFactor>ItemBHMaxDay)&&(ItemBHMaxDay'=0){
				s OutInfo="-1^" _OrderName _"超过简易门诊最大疗程限制,最大天数"_ItemBHMaxDay_"天"
				s $P(OutInfo,"^",4)="OrderDur"
				q OutInfo
			}
			s ItemBHMaxQty=+$p($g(^DHCItmMastBH(DHCItmMastBHDr)),"^",3)
			s ItemBHMaxQtyUom=$p($g(^DHCItmMastBH(DHCItmMastBHDr)),"^",4)
			s ItemBHconvFac = ##Class(appcom.OEDispensing).convFac(ARCIMRowid,ItemBHMaxQtyUom)
			if ((ItemBHMaxQty > 0) && ((PackQty*ItemBHconvFac) > ItemBHMaxQty)) {
				s OutInfo="-1^" _OrderName _"此药品的简易门诊最大限量为"_ItemBHMaxQty_$p($g(^CT("UOM",ItemBHMaxQtyUom)),"^",2) ;_","_$j((ItemBHMaxQty/ItemBHconvFac),"",2)_OrderPackUOM
				s $P(OutInfo,"^",4)="OrderPackQty"
				q OutInfo
			}
		}
	}else{
		s CheckArcItemDr=$o(^DHCItmMastBH("0","ARCIM",ARCIMRowid,0))
		if (CheckArcItemDr'=""){
			s OutInfo="-1^" _OrderName _"为简易门诊用药，其他科室不能开立"
			s $P(OutInfo,"^",4)="OrderName"
			q OutInfo
		}
	}