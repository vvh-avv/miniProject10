<%@ page contentType="text/html; charset=euc-kr"%>

<html>
<head>
<title>�α��� ȭ��</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"></script>
<script src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	function fncLogin(){
		var id = $("input:text").val();
		var pw = $("input:password").val();
			
		if(id==null || id.length<1){
			alert('���̵� �Է����� �����̽��ϴ�.');
			$("input:text").focus();
			return;
		}
			
		if(pw==null || pw.length<1){
			alert('�н����带 �Է����� �����̽��ϴ�.');
			$("input:password").focus();
			return;
		}
		
		$.ajax({
			url : "/user/json/login",
			method : "POST",
			dataType : "json",
			headers : {
				"Accept" : "application/json",
				"Content-Type" : "application/json"
			},
			data : JSON.stringify({
				userId : id,
				password : pw
			}),
			success : function(JSONData, status){
				
				if(JSONData.userId != "none"){
					
					if( JSONData.password == $("#password").val() ){
						$("form").attr("method","POST").attr("action","/user/login").attr("target","_parent").submit();
						//[���1]
						//$(window.parent.document.location).attr("href","/index.jsp");
						//[���2]
						//window.parent.document.location.reload();
						//[���3]
						//$(window.parent.frames["topFrame"].document.location).attr("href","/layout/top.jsp");
						//$(window.parent.frames["leftFrame"].document.location).attr("href","/layout/left.jsp");
						//$(window.parent.frames["rightFrame"].document.location).attr("href","/user/getUser?userId="+JSONData.userId);
					}else{
						$("#message").text("��й�ȣ�� �ٽ� Ȯ�����ּ���.").css("color", "red");
						$("#password").val("").focus();
					}
					
				}else{
					$("#userId").val("").focus();
					$("#password").val("");
					$("#message").text("���̵�, �н����带 �ٽ� Ȯ�����ּ���.").css("color", "red");
				}
			}
		}); //e.o.ajax
		
	}
	
	$(function(){
		$("#userId").focus();
		
		//�α��� ����Ű ó��
		$("#userId, #password").keypress(function(event){
			if(event.which==13){
				fncLogin();
			}
		});

		$("img[src='/images/btn_login.gif']").on("click", function(){
			fncLogin();
		});

		$("img[src='/images/btn_add.gif']").on("click", function(){
			self.location="/user/addUser";
		});

		
	});

	//īī�� �α���
	$(function(){
		Kakao.init('b3eb26586b770154ea49919a7f59f2d2');
		
		$("#kakao-login-btn").on("click", function(){
			//1. �α��� �õ�
			Kakao.Auth.login({
		        success: function(authObj) {
		          //console.log(JSON.stringify(authObj));
		          //console.log(Kakao.Auth.getAccessToken());
		        
		          //2. �α��� ������, API�� ȣ���մϴ�.
		          Kakao.API.request({
		            url: '/v1/user/me',
		            success: function(res) {
		              //console.log(JSON.stringify(res));
		              res.id += "@k";
		              
		              $.ajax({
		            	  url : "/user/json/checkDuplication/"+res.id,
		            	  headers : {
		  					"Accept" : "application/json",
		  					"Content-Type" : "application/json"
		  				  },
		  				  success : function(idChk){
		  					  
		  					  if(idChk==true){ //DB�� ���̵� ���� ��� => ȸ������
		  						  console.log("ȸ��������...");
		  						  $.ajax({
		  							  url : "/user/json/addUser",
		  							  method : "POST",
		  							  headers : {
		  								"Accept" : "application/json",
		  								"Content-Type" : "application/json"
		  							  },
		  							  data : JSON.stringify({
  		  								userId : res.id,
		  								userName : res.properties.nickname,
  		  								password : "kakao123",
		  							  }),
		  							  success : function(JSONData){
		  								 alert("ȸ�������� ���������� �Ǿ����ϴ�.");
		  								 $("form").attr("method","POST").attr("action","/user/snsLogin/"+res.id).attr("target","_parent").submit();
		  							  }
		  						  })
		  					  }
		  					  if(idChk==false){ //DB�� ���̵� ������ ��� => �α���
		  						  console.log("�α�����...");
		  						  $("form").attr("method","POST").attr("action","/user/snsLogin/"+res.id).attr("target","_parent").submit();
		  					  }
		  				  }
		              })
		            },
		            fail: function(error) {
		              alert(JSON.stringify(error));
		            }
		          });
		          
		        },
		        fail: function(err) {
		          alert(JSON.stringify(err));
		        }
		      });
		})
	})//e.o.kakao
	
	//���̹� �α���
	$(function(){
   			var naverLogin = new naver.LoginWithNaverId({
				clientId: "NqLY8zfxRnZIl3CjoL1a",
				callbackUrl: "http://192.168.0.69:8080/user/naverCallback.jsp",
				isPopup: true,
				loginButton: {color: "green", type: 3, height: 45}
			});
			naverLogin.init();
	})//e.o.naver
		
	
</script>

</head>

<body bgcolor="#ffffff" text="#000000">

	<form name="loginForm">

		<div align="center">

			<TABLE WITH="100%" HEIGHT="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD ALIGN="CENTER" VALIGN="MIDDLE">
						<table width="650" height="390" border="5" cellpadding="0" cellspacing="0" bordercolor="#D6CDB7">
							<tr>
								<td width="10" height="5" align="left" valign="top" bordercolor="#D6CDB7">
									<table width="650" height="390" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="305"><img src="/images/logo-spring.png" width="305" height="390" /></td>
											<td width="345" align="left" valign="top" background="/images/login02.gif">
												<table width="100%" height="220" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td width="30" height="100">&nbsp;</td>
														<td width="100" height="100">&nbsp;</td>
														<td height="100">&nbsp;</td>
														<td width="20" height="100">&nbsp;</td>
													</tr>
													<tr>
														<td width="30" height="50">&nbsp;</td>
														<td width="100" height="50"><img src="/images/text_login.gif" width="91" height="32" /></td>
														<td height="50">&nbsp;</td>
														<td width="20" height="50">&nbsp;</td>
													</tr>
													<tr>
														<td width="200" height="50" colspan="4"></td>
													</tr>
													<tr>
														<td width="30" height="30">&nbsp;</td>
														<td width="100" height="30"><img src="/images/text_id.gif" width="100" height="30" /></td>
														<td height="30"><input type="text" name="userId" id="userId" class="ct_input_g" style="width: 180px; height: 19px" maxLength='50' /></td>
														<td width="20" height="30">&nbsp;</td>
													</tr>
													<tr>
														<td width="30" height="30">&nbsp;</td>
														<td width="100" height="30"><img src="/images/text_pas.gif" width="100" height="30" /></td>
														<td height="30"><input type="password" name="password" id="password" class="ct_input_g" style="width: 180px; height: 19px" maxLength="50" /></td>
														<td width="20" height="30">&nbsp;</td>
													</tr>
													<tr>
														<td width="30" height="20">&nbsp;</td>
														<td width="100" height="20">&nbsp;</td>
														<td height="20" align="center">
															<table width="136" height="20" border="0" cellpadding="0" cellspacing="0">
																<tr>
																	<td width="56">
																		<img src="/images/btn_login.gif" width="56" height="20" border="0" />
																	</td>
																	<td width="10">&nbsp;</td>
																	<td width="70">
																		<img src="/images/btn_add.gif" width="70" height="20" border="0">
																	</td>
																</tr>
															</table>
																												
														</td>
														<td width="20" height="20">&nbsp;</td>
													</tr>
												</table>
												
												<!-- �α��� ���� Ajax ó�� --><br>
												<div id="message" align="center"></div><br>
												
												<!-- īī�� �α��� �߰� -->
												<div id="kakaoLogin" align="center">
													<a id="kakao-login-btn" href="#">
														<img src="//k.kakaocdn.net/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="80%"/>
													</a>
													<a href="http://developers.kakao.com/logout"></a>
												</div>
												
												<!-- ���̹� �α��� �߰� -->
  												<div id="naverIdLogin" align="center">
													<a id="naver-login-btn" href="#" role="button">
														<img src="https://static.nid.naver.com/oauth/big_g.PNG" width="80%" height="45"/> 
													</a>
												</div>

											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</TD>
				</TR>
			</TABLE>

		</div>

	</form>

</body>
</html>