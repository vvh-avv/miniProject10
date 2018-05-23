<%@ page contentType="text/html; charset=euc-kr"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title>회원탈퇴</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	$(function(){
		//$("input:nth-of-type(3)") //$("input:radio:last)")
		$("[name=reason][value='기타']").on("click",function(){
			$("input:text[name=reasonText]").focus();
		});
		
		$("#close").on("click", function(){
			window.close();
		});
		
		$("#submit").on("click", function(){
			var chkValue = $("input:checked").val();
			
			if( chkValue==null || (chkValue=="기타" && $("input:text[name=reasonText]").val()=="") ){
				alert("사유는 반드시 입력해주시길 바랍니다.");
			}else{
				if(chkValue=="기타"){ chkValue = $("input:text[name=reasonText]").val(); }

				$("form").attr("method", "POST").attr("action", "/user/quitUser?userId=${user.userId}&reason="+chkValue).submit();
				top.opener.location="/user/logout";
				//top.opener.location="/user/loginView.jsp";
				window.close();
			}
		});
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<form name="detailForm" method="post">
		<h4>정말 탈퇴하시겠습니까?</h4>
			탈퇴사유 : <br>
			<input type="radio" name="reason" value="개인정보 때문에"><font size="2">개인정보 때문에</font><br>
			<input type="radio" name="reason" value="마음에 드는 상품이 없어서"><font size="2">마음에 드는 상품이 없어서</font><br>
			<input type="radio" name="reason" value="기타"><font size="2">기타</font>&nbsp;<input type="text" name="reasonText"><br>
			<br>
			<button id="submit" value="확인">확인</button> <!-- onclick="javascript:fncQuitCheck();" -->
			<button id="close" value="취소">취소</button> <!-- onclick="javascript:window.close();" -->
	</form>

</body>
</html>