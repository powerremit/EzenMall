<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인 폼</title>
<style>
	@import url('https://fonts.googleapis.com/css2?family=Paytone+One&display=swap');
	@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap');
	#container {width: 300px; margin: 0 auto;}
	a{text-decoration:none; color: #1DDB16;}
	
	/* 상단 - 메인, 서브타이틀 */
	.m_title{font-family: 'Paytone One', sans-serif; font-size: 3em; text-align:center;}
	.s_title{font-family: 'Do Hyeon', sans-serif; font-size: 2em; text-align:center; margin-bottom: 30px;}
	
	/* 중단 - 로그인 박스 */
	.b_box {border: 1px solid #ccc; border-radius:15px; padding:5px; margin:10px;}
	.b_box input{height: 30px; border:none;}
	.b_box input[type="text"] {background: url('../../icons/login_id_color.png') no-repeat; padding-left:40px;
	 background-position: left center;}
	.b_box input[type="password"] {background: url('../../icons/login_pwd_color.png') no-repeat; padding-left:40px;
	 background-size:30px; background-position: left center;}
	 .b_box input:focus{outline:none;}

	/* 하단 - 로그인 버튼 */
	.btns {text-align: center; margin-top:30px;}
	.btns input {width: 280px; height:45px; border:none; border-radius:15px; cursor: pointer; background-color:#5e869c; color:white;
	 font-size:1.03em;}
	.btns input:hover {background-color:#5a6877; transition: ease-in-out 150ms; font-weight:700;}
	
</style>
<script>
document.addEventListener("DOMContentLoaded", function(){
	let form = document.managerLoginForm;
	
	let btn_login = document.getElementById("btn_login");
	btn_login.addEventListener("click", function(){
		if(!form.managerId.value){
			alert('아이디를 입력하세요');
			return;
		}
		if(!form.managerPwd.value){
			alert('비밀번호를 입력하세요');
			return;
		}
	form.submit();
	})
})
</script>
</head>
<body>

<div id="container">
	<div class="m_title"><a href="#">EZEN MALL</a></div>
	<div class="s_title">관리자 로그인 페이지</div>
	
	<form action="managerLoginPro.jsp" method="post" name="managerLoginForm">
		<div class="a_box">
			<div class="b_box">
				<input type="text" name="managerId" id="managerId" placeholder="아이디를 입력하세요" size="28">
			</div>
			<div class="b_box">
				<input type="password" name="managerPwd" id="managerPwd" placeholder="비밀번호를 입력하세요" size="28">
			</div>
			<div class="btns">
				<input type="button" id="btn_login" value="관리자 로그인">
			</div>
		</div>
	</form>
</div>

</body>
</html>