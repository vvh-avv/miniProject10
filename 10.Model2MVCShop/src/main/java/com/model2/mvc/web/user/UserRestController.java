package com.model2.mvc.web.user;

import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;

@RestController
@RequestMapping("/user/*")
public class UserRestController {

	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	public UserRestController() {
		System.out.println(this.getClass());
	}
	
	@RequestMapping(value="json/login", method=RequestMethod.POST)
	public User login( @RequestBody User user, HttpSession session ) throws Exception{
		System.out.println("/user/json/login : POST");
		
		User returnUser = userService.getUser(user.getUserId());
		
		if(returnUser==null) {
			returnUser = new User();
			returnUser.setUserId("none");
		}
		
		if( user.getPassword().equals(returnUser.getPassword()) ){
			session.setAttribute("user", returnUser);
		}
		
		return returnUser;
	}
	
	@RequestMapping(value="json/getUser/{userId}", method=RequestMethod.GET)
	public User getUser( @PathVariable String userId ) throws Exception{
		System.out.println("/user/json/getUser : GET");
		
		return userService.getUser(userId);
	}
	
	@RequestMapping(value="json/addUser", method=RequestMethod.POST)
	public User addUser( @RequestBody User user ) throws Exception{
		System.out.println("/user/json/addUser : POST");

		userService.addUser(user);
		
		return userService.getUser(user.getUserId());
	}
	
	@RequestMapping(value="json/updateUser", method=RequestMethod.POST)
	public User updateUser( @RequestBody User user ) throws Exception{
		System.out.println("/user/json/updateUser : POST");
		
		userService.updateUser(user);

		return userService.getUser(user.getUserId());
	}
	
	@RequestMapping(value="json/checkDuplication/{userId}", method=RequestMethod.GET)
	public boolean checkDuplication( @PathVariable String userId ) throws Exception{
		System.out.println("/user/json/checkDuplication : GET");
		
		boolean result = userService.checkDuplication(userId);
		System.out.println("boolean 값 : "+result);
		
		return result;
	}
	
	@RequestMapping(value="json/listUser/{sort}", method=RequestMethod.POST)
	public Map<String, Object> listUser( @RequestBody Search search, @PathVariable String sort ) throws Exception{
		System.out.println("/user/json/listUser : GET / POST");
		
		Map<String, Object> map = userService.getUserList(search, sort);
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), 5, search.getPageSize());
		
		map.put("list", map.get("list"));
		map.put("resultPage", resultPage);
		map.put("search", search);
		map.put("sort", sort);
		
		return map; 
	}
	
	@RequestMapping(value="json/quitUser/{userId}/{reason}", method=RequestMethod.POST)
	public void quitUser( @PathVariable String userId, @PathVariable String reason ) throws Exception{
		System.out.println("/user/json/quitUser : POST");
		
		if(reason.contains(",")) {
			reason = reason.split(",")[0];
		}

		userService.quitUser(userId, reason); //탈퇴DB에 insert
		//userService.deleteUser(userId); //회원DB에 delete
		
		System.out.println(userId+"회원 "+reason+"이유로 탈퇴하셨습니다.");
	}
	
	@RequestMapping(value="json/statsUser", method=RequestMethod.GET)
	public void statsUser() throws Exception{
		System.out.println("/user/json/statsUser : GET");
		
		Map<String, Object> map = userService.getQuitUserList();
		Map<String, Integer> reason = (Map<String, Integer>) map.get("reason");
		
		//데이터 가공 후 전달
		String result = "";
		Set<String> reasonKeys = reason.keySet();

		for(String key : reasonKeys) {
			if(result!="") {
				result += ",";
			}
			result += "['"+key+"', "+reason.get(key)+"]";
		}
		
		System.out.println(result);
	}
	
}
