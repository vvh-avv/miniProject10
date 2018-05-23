<%@ page contentType="text/html; charset=euc-kr"%>

<html>
<head>
<title>로그인 화면</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	function fncLogin(){
		var id = $("input:text").val();
		var pw = $("input:password").val();
			
		if(id==null || id.length<1){
			alert('ID 를 입력하지 않으셨습니다.');
			$("input:text").focus();
			return;
		}
			
		if(pw==null || pw.length<1){
			alert('패스워드를 입력하지 않으셨습니다.');
			$("input:password").focus();
			return;
		}
			
		$("form").attr("method","POST").attr("action","/user/login").attr("target","_parent").submit();
	}
	
	$(function(){
		$("#userId").focus();
		
		//로그인 엔터키 처리
		$("#userId, #password").keypress(function(event){
			if(event.which==13){
				fncLogin();
			}
		});

		$("img[src='/images/btn_login.gif']").on("click", function(){
			fncLogin();
		});
	});
	
	$(function(){
		$("img[src='/images/btn_add.gif']").on("click", function(){
			self.location="/user/addUser";
			//self.location="addUserView.jsp";
		});
	});
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
															
															<!-- 카카오 로그인 추가 -->
															<a id="kakao-login-btn"></a>
															<a href="http://developers.kakao.com/logout"></a>
															<script type='text/javascript'>
															  //<![CDATA[
															  // 사용할 앱의 JavaScript 키를 설정해 주세요.
															  Kakao.init('b3eb26586b770154ea49919a7f59f2d2');
															  // 카카오 로그인 버튼을 생성합니다.
															  Kakao.Auth.createLoginButton({
															    container: '#kakao-login-btn',
															    success: function(authObj) {
																	//alert(JSON.stringify(authObj));
																	var accessToken = Kakao.Auth.getAccessToken();
																	var refreshToken = Kakao.Auth.getRefreshToken();
																	alert(accessToken);
																	alert(refreshToken);
																	/*
																	if(refreshToken){
																		Kakao.API.request({
																			url : '/v1/user/me',
																			success : function(res){
																				var sData = JSON.stringify(res);
																				alert(sData);
																				sData = JSON.parse(sData);
																				var nickName = sData.properties.ninkname;
																			}
																		});
																	}*/
															    },
															    fail: function(err) {
															       alert(JSON.stringify(err));
															    }
															  });
															 //]]>
															</script>
																														
														</td>
														<td width="20" height="20">&nbsp;</td>
													</tr>
												</table>
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