package com.model2.mvc.web.product;

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
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@RestController
@RequestMapping("/product/*")
public class ProductRestController {

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductRestController() {
		System.out.println(this.getClass());
	}
	
	@RequestMapping(value="json/addProduct", method=RequestMethod.POST)
	public void addProduct( @RequestBody Product product ) throws Exception{
		System.out.println("/product/json/addProduct : POST");
		
		productService.addProduct(product);
	}
	
	@RequestMapping(value="json/getProduct/{prodNo}")
	public Product getProduct( @PathVariable int prodNo ) throws Exception{
		System.out.println("/product/json/getProduct : GET / POST");
		
		return productService.getProduct(prodNo);
	}
	
	@RequestMapping(value="json/updateProduct", method=RequestMethod.POST)
	public Product updateProduct( @RequestBody Product product ) throws Exception{
		System.out.println("/product/json/updateProduct : POST");
		
		productService.updateProduct(product);
		
		return productService.getProduct(product.getProdNo());
	}
	
	@RequestMapping(value="json/listProduct")
	public Map<String, Object> listProduct( @RequestBody Search search ) throws Exception{
		System.out.println("/product/json/listProduct : GET / POST");
		
		Map<String, Object> map = productService.getProductList(search, "prod_no asc");
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), 5, search.getPageSize());

		map.put("list", map.get("list"));
		map.put("resultPage", resultPage);
		map.put("search", search);
		map.put("sort", "prod_no asc");
		
		return map; 
	}
}
