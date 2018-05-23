package com.model2.mvc.web.product;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.CookieGenerator;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;

@Controller
@RequestMapping("/product/*")
public class ProductController {

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;

	
	@RequestMapping(value="addProduct", method=RequestMethod.GET)
	public String addProduct() throws Exception {
		System.out.println("/product/addProduct : GET");
		
		return "redirect:/product/addProductView.jsp";
	}

	@RequestMapping(value="addProduct", method=RequestMethod.POST)
	public String addProduct( @ModelAttribute("product") Product product, MultipartHttpServletRequest request, //HttpServletRequest request,
										@RequestParam("file") MultipartFile[] file ) throws Exception {
		System.out.println("/product/addProduct : POST");
		
		//String uploadPath = request.getSession().getServletContext().getRealPath("/");
		String uploadPath = request.getRealPath("/images/uploadFiles");
		
		String fileOriginName = "";
		String fileMultiName = "";
		for(int i=0; i<file.length; i++) {
			fileOriginName = file[i].getOriginalFilename();
			
			//파일이 존재하지 않으면
			if(fileOriginName=="") {
				break;
			}
			
			System.out.println("기존 파일명 : "+fileOriginName);
			SimpleDateFormat formatter = new SimpleDateFormat("YYYYMMDD_HHMMSS_"+i);
			Calendar now = Calendar.getInstance();
			
			//확장자명
			String extension = fileOriginName.split("\\.")[1];
			
			//fileOriginName에 날짜+.+확장자명으로 저장시킴.
			fileOriginName = formatter.format(now.getTime())+"."+extension;
			System.out.println("변경된 파일명 : "+fileOriginName);
			
			//File f = new File("C:\\Users\\Bit\\git\\miniProject08\\08.Model2MVCShop\\WebContent\\images\\uploadFiles\\"+file[i].getOriginalFilename());
			File f = new File(uploadPath+"\\"+fileOriginName); //file[i].getOriginalFilename());
			file[i].transferTo(f);
			if(i==0) { fileMultiName += fileOriginName; }
			else{ fileMultiName += ","+fileOriginName; }
		}
		System.out.println("*"+fileMultiName);
		product.setFileName(fileMultiName);
		
		productService.addProduct(product);
		
		return "forward:/product/getProduct.jsp";
		
	}
	
	@RequestMapping(value="getProduct")
	public String getProduct(@RequestParam("prodNo") int prodNo, Model model,
									HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("/product/getProduct : GET / POST");
		
		Product product = productService.getProduct(prodNo);
		
		model.addAttribute("product", product);
		
		//쿠키 추가
		String history = null;
		Cookie[] c = request.getCookies();
		if(c!=null){ //쿠키가 존재하면
			for(int i=0; i<c.length; i++){
				Cookie cookie = c[i];
				if(cookie.getName().equals("history")){
					history = cookie.getValue();
				}
			}
		}
		history += "," + product.getProdNo();
		//Cookie cookie = new Cookie("history",history);
		//response.addCookie(cookie);
		CookieGenerator cg = new CookieGenerator();
		cg.setCookieName("history");
		cg.addCookie(response, history);
		
		return "forward:/product/detailProduct.jsp";
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.GET)
	public String updateProduct(@ModelAttribute("product") Product product, Model model, HttpSession session,
										@RequestParam(value="status", required=false, defaultValue="") String status) throws Exception{
		System.out.println("/product/updateProduct : GET");
		
		Product productVO = productService.getProduct(product.getProdNo());

		model.addAttribute("product", productVO);
		
		if( ((User)session.getAttribute("user")).getRole().equals("admin") && status.equals("0") ) { //판매중 상품
			return "forward:/product/updateProduct.jsp";
		}else {
			return "forward:/product/detailProduct.jsp";
		}
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.POST)
	public String updateProduct(@ModelAttribute("product") Product product, MultipartHttpServletRequest request,
										@RequestParam("file") MultipartFile[] file) throws Exception{
		System.out.println("/product/updateProduct : POST");
		
		String uploadPath = request.getRealPath("/images/uploadFiles")+"\\";
		
		String fileOriginName = "";
		String fileMultiName = "";
		
/*		//기존 파일 삭제
		if(product.getFileName().contains(",")) {
			for( String fileName : product.getFileName().split(",") ) {
				new File(uploadPath+fileName).delete();
				System.out.println(fileName+" 삭제 완료");
			}
		}else {
			new File(uploadPath+product.getFileName()).delete();
			System.out.println(product.getFileName()+" 삭제 완료");
		}*/
		
		for(int i=0; i<file.length; i++) {
			fileOriginName = file[i].getOriginalFilename();
			
			//파일이 존재하지 않으면
			if(fileOriginName=="") {
				break;
			}			
			
			System.out.println("기존 파일명 : "+fileOriginName);
			SimpleDateFormat formatter = new SimpleDateFormat("YYYYMMDD_HHMMSS_"+i);
			Calendar now = Calendar.getInstance();
			
			//확장자명
			String extension = fileOriginName.split("\\.")[1];
			
			//fileOriginName에 날짜+.+확장자명으로 저장시킴.
			fileOriginName = formatter.format(now.getTime())+"."+extension;
			System.out.println("변경된 파일명 : "+fileOriginName);
			
			File f = new File(uploadPath+fileOriginName); 
			file[i].transferTo(f);
			if(i==0) { fileMultiName += fileOriginName; }
			else{ fileMultiName += ","+fileOriginName; }
		}
		System.out.println("*"+fileMultiName);
		product.setFileName(fileMultiName);
		
		productService.updateProduct(product);
		
		return "forward:/product/getProduct?prodNo="+product.getProdNo()+"&menu=manage";
	}

	@RequestMapping(value="listProduct")
	public String listProduct(@ModelAttribute("search") Search search, @RequestParam(value="sort", required=false, defaultValue="prod_no asc") String sort,
									Model model) throws Exception{
		System.out.println("/product/listProduct : GET / POST");
		
		if(search.getCurrentPage()==0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		if(sort.indexOf("+")!=-1) {
			sort = sort.replace("+", " ");
		}
		
		Map<String,Object> map = productService.getProductList(search, sort);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize );
		
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		model.addAttribute("sort",sort);
		
		return "forward:/product/listProduct.jsp";
	}
}
