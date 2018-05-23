package com.model2.mvc.web.purchase;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseService;

@RestController
@RequestMapping("/purchase/*")
public class PurchaseRestController {

	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	
	public PurchaseRestController() {
		System.out.println(this.getClass());
	}
	
	@RequestMapping(value="json/addPurchase", method=RequestMethod.POST)
	public void addPurchase( @RequestBody Purchase purchase ) throws Exception{
		System.out.println("/purchase/json/addPurchase : POST");
		
		purchaseService.addPurchase(purchase);
	}
	
	@RequestMapping(value="json/getPurchase/{tranNo}", method=RequestMethod.GET)
	public Purchase getPurchase( @PathVariable int tranNo ) throws Exception{
		System.out.println("/purchase/json/getPurchase : GET");
		
		return purchaseService.getPurchase(tranNo);
	}
	
	@RequestMapping(value="json/listPurchase/{buyerId}")
	public Map<String,Object> listPurchase( @RequestBody Search search, @PathVariable String buyerId ) throws Exception{
		System.out.println("/purchase/json/listPurchase : GET / POST");
		
		Map<String, Object> map = purchaseService.getPurchaseList(search, buyerId, "asc");
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), 5, search.getPageSize());

		map.put("list", map.get("list"));
		map.put("resultPage", resultPage);
		map.put("search", search);
		map.put("sort", "prod_no asc");
		
		return map;
	}
	
	@RequestMapping(value="json/updatePurchase", method=RequestMethod.POST)
	public Purchase updatePurchase( @RequestBody Purchase purchase ) throws Exception{
		System.out.println("/purchase/json/updatePurchase : POST");
		
		purchaseService.updatePurchase(purchase);
		
		return purchaseService.getPurchase(purchase.getTranNo());
	}
	
	@RequestMapping(value="json/updateTranCode/{tranNo}/{tranCode}", method=RequestMethod.POST)
	public Purchase updateTranCode( @PathVariable int tranNo, @PathVariable String tranCode ) throws Exception{
		System.out.println("/purchase/json/updateTranCode : POST");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);
		purchase.setTranCode(tranCode);
		purchaseService.updateTranCode(purchase);
		
		return purchaseService.getPurchase(tranNo);
	}
	
	@RequestMapping(value="json/updateTranCodeByProd/{prodNo}/{tranCode}", method=RequestMethod.POST)
	public Purchase updateTranCodeByProd( @PathVariable String prodNo, @PathVariable String tranCode ) throws Exception{
		System.out.println("/purchase/json/updateTranCodeByProd : POST");
		
		//ÀÏ°ýÃ³¸®
		if(prodNo.contains(",")) {
			String[] prodList = prodNo.split(",");
			for(int i=0; i<prodList.length; i++) {
				Purchase purchase = purchaseService.getPurchase2(Integer.parseInt(prodList[i]));
				purchase.setTranCode(tranCode);
				purchaseService.updateTranCode(purchase);
			}
		}else {
			Purchase purchase = purchaseService.getPurchase2(Integer.parseInt(prodNo));
			purchase.setTranCode(tranCode);
			purchaseService.updateTranCode(purchase);
		}
		
		return purchaseService.getPurchase2(Integer.parseInt(prodNo));
	}
	
}
