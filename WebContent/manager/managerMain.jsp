<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쇼핑몰 관리자 메인 페이지</title>
<style>
#container {width: 300px; margin: 20px auto;}
@import url('https://fonts.googleapis.com/css2?family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap');
a{text-decoration:none; color: #1DDB16;}

/* 상단 - 메인, 서브타이틀 */
.m_title{font-family: 'Paytone One', sans-serif; font-size: 3em; text-align:center;}
.s_title{font-family: 'Do Hyeon', sans-serif; font-size: 2em; text-align:center; margin-bottom: 30px;}
a {text-decoration: none; color: #59637f; font-size:0.95em; font-weight: 700;}
.c_logout{text-align:center;  margin-bottom: 10px;}
.c_logout a{color: #99424f;}
/*테이블 메뉴*/
table{width: 100%; border: 1px solid black; border-collapse: collapse; 
border-top:3px solid gray; border-bottom:3px solid gray; border-left:hidden; border-right:hidden;}
tr{height: 50px;}
th{border: 1px solid black;}
.title_row{background: #dee2e6; font-size:1.1em;}
.a_row{background: #f5f6fa;}
.a_row:hover{background: #ccc; transition: ease-in-out 150ms;}
.a_row:hover a{color:black; transition: ease-in-out 150ms;}
</style>
<script>
</script>
</head>
<body>
<% // 관리자메인jsp에서 실행하면 바로 실행되는데, 세션이 있어야 작동되게끔 해야되니깐. 세션이 없을때는 로그인 페이지로 열리도록 
String managerId = (String)session.getAttribute("managerId");
if(managerId==null){
	out.print("<script>location='./logon/managerLoginForm.jsp';</script>");
}
%>
<div id="container">
	<div class="m_title"><a href="">EZEN MALL</a></div>
	<div class="s_title">관리자 페이지</div>
	
	<div class="c_logout"><a href="./logon/managerLogout.jsp">로그아웃</a></div> <!-- 경로: ./를 넣던가 ./를 빼던가 해야함. -->
	<table>
		<tr class="title_row"><th>상품 관리</th></tr>
		<tr class="a_row"><th><a href="./product/productRegister.jsp">상품 등록</a></th></tr>
		<tr class="a_row"><th><a href="./product/productList.jsp">상품 목록(수정/삭제)</a></th></tr>
		<tr class="title_row"><th>주문 관리</th></tr>
		<tr class="a_row"><th><a href="">주문 목록(수정/삭제)</a></th></tr>
		<tr class="title_row"><th>회원 관리</th></tr>
		<tr class="a_row"><th><a href="">회원 목록(수정/삭제)</a></th></tr>
	</table>
</div>
</body>
</html>