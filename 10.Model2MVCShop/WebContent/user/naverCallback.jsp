<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>

<body>
	<script type="text/javascript">
		  var naver_id_login = new naver_id_login("NqLY8zfxRnZIl3CjoL1a", "YOUR_CALLBACK_URL");
		  // 접근 토큰 값 출력
		  //alert(naver_id_login.oauthParams.access_token);
		  
		  // 네이버 사용자 프로필 조회
		  naver_id_login.get_naver_userprofile("naverSignInCallback()");
		  
		  // 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
		  function naverSignInCallback() {
			var id = naver_id_login.getProfileData('id')+"@n";
			var nickname = naver_id_login.getProfileData('name');
		    //var email = naver_id_login.getProfileData('email');
			
			$.ajax({
				 url : "/user/json/checkDuplication/"+id,
           	 	 headers : {
 					"Accept" : "application/json",
 					"Content-Type" : "application/json"
 				 },
 				 success : function(idChk){
 					 
 					if(idChk==true){ //DB에 아이디가 없을 경우 => 회원가입
						  console.log("회원가입중...");
						  $.ajax({
							  url : "/user/json/addUser",
							  method : "POST",
							  headers : {
								"Accept" : "application/json",
								"Content-Type" : "application/json"
							  },
							  data : JSON.stringify({
  								userId : id,
								userName : nickname,
  								password : "naver123",
							  }),
							  success : function(JSONData){
								 alert("회원가입이 정상적으로 되었습니다.");
								 window.close();
								 top.opener.location="/user/snsLogin/"+id;
							  }
						  })
					  }
					  if(idChk==false){ //DB에 아이디가 존재할 경우 => 로그인
						  console.log("로그인 중...");
						  window.close();
						  top.opener.location="/user/snsLogin/"+id;
					  }
 				 }
			})
			
		  }
	</script>
	
	<form name="defaultForm">
	</form>
	
</body>
</html>