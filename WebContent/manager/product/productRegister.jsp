<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록 페이지</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap');
#container {width: 550px; margin: 20px auto;}
a{text-decoration:none; color: #1DDB16;}

/* 상단 - 메인, 서브타이틀 */
.m_title{font-family: 'Paytone One', sans-serif; font-size: 3em; text-align:center;}
.s_title{font-family: 'Do Hyeon', sans-serif; font-size: 2em; text-align:center; margin-bottom: 30px;}
a {text-decoration: none; color: #59637f; font-size:0.95em; font-weight: 700;}
.c_logout{text-align:center;  margin-bottom: 10px;}
.c_logout a{color: #99424f;}

/* 중단 - 상품 등록 테이블*/
table{ width: 100%; border: 1px solid black; border-collapse: collapse;
 border-top:3px solid #2f9e77; border-bottom:3px solid #2f9e77; border-left:hidden; border-right:hidden;}
tr{height: 35px;}
td, th{border:1px solid #2f9e77;}
th {background:#d8f4e6;}
td {padding-left: 5px;}
/* 중단 - 테이블 안의 입력상자 */
input[type="number"] {width:100px; text-align:right;}
input[type="number"]::-webkit-outer-spin-button, 
input[type="number"]::-webkit-inner-spin-button {-webkit-appearance: none; margin: 0;}
textarea {margin-top: 5px;}
select {height:24px;}
input::file-selector-button{width:90px; height: 27px; background: #2f9e77; color:white; 
border:none; border-radius:5px; cursor:pointer;}
input::file-selector-button:hover{background:green; font-weight: 700; transition:ease-in-out 150ms;}


/* 하단 - 버튼 */
.btns{display: flex; justify-content:space-around; margin-top:20px;}
.btns input {width:100px; height:37px; border:none; background:#495057; color:#fff; font-weight:700;
 border-radius:10px; cursor:pointer;}
.btns input:hover {background: white; color: black; border: 1px solid black; transition: ease-in-out 150ms;}
.btns input:first-child{background: #2f9e77;}
.btns input:first-child:hover{background: green; color:white; border:none; transition: ease-in-out 150ms;}
</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		let form = document.registerForm;
		
		//상품 등록 유효성 검사
		let btn_register = document.getElementById("btn_register");
		btn_register.addEventListener("click", function(){
			if(!form.product_name.value){
				alert('상품 제목을 입력하세요');
				return;
			}
			if(!form.product_price.value){
				alert('상품 가격을 입력하세요');
				return;
			}
			if(!form.product_count.value){
				alert('상품 수량을 입력하세요');
				return;
			}
			if(!form.author.value){
				alert('저자를 입력하세요');
				return;
			}
			if(!form.publishing_com.value){
				alert('출판사를 입력하세요');
				return;
			}
			if(!form.publishing_date.value){
				alert('출판일를 입력하세요');
				return;
			}
			if(!form.product_content.value){
				alert('제품상세내용을 입력하세요');
				return;
			}
			if(!form.discount_rate.value){
				alert('제품상세내용을 입력하세요');
				return;
			}
			form.submit();
		})
		
		// 상품목록 페이지 이동 보튼
		let btn_list = document.getElementById("btn_list");
		btn_list.addEventListener("click", function() {
			location = 'productList.jsp';
		})
		
		// 관리자 페이지 이동 보튼
		let btn_main = document.getElementById("btn_main")
		btn_main.addEventListener("click", function(){
			location = '../managerMain.jsp';
		})
	})
</script>
</head>
<body>
<%
String managerId = (String)session.getAttribute("managerId");
if(managerId==null){
	out.print("<script>location='../logon/managerLoginForm.jsp';</script>");
}
%>
<div id="container">
	<div class="m_title"><a href="../managerMain.jsp">EZEN MALL</a></div>
	<div class="s_title">상품 등록</div>
	<form action="productRegisterPro.jsp" method="post" name="registerForm" enctype="multipart/form-data">
		<table>
			<tr>
				<th width="20%">상품 분류</th>
				<td width="80%">
					<select name="product_kind">
						<option value="110" selected>소설/시</option>
						<option value="120">에세이</option>
						<option value="210">역사</option>
						<option value="220">예술</option>
						<option value="230">종교</option>
						<option value="240">사회</option>
						<option value="250">과학</option>
						<option value="310">경제/경영</option>
						<option value="320">자기계발</option>
						<option value="410">여행</option>
						<option value="420">만화</option>
						<option value="510">잡지</option>
						<option value="610">어린이</option>
						<option value="620">육아</option>
						<option value="630">가정/살림</option>
						<option value="710">건강/취미</option>
						<option value="720">요리</option>
						<option value="810">IT 모바일</option>
						<option value="910">수험서/자격증</option>
						<option value="920">참고서</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>상품 제목</th>
				<td><input type="text" name="product_name" size="56"></td>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><input type="number" name="product_price" min="1000" max="1000000">원</td>
			</tr>
			<tr>
				<th>상품 수량</th>
				<td><input type="number" name="product_count" min="0" max="1000">권</td>
			</tr>
			<tr>
				<th>저자</th>
				<td><input type="text" name="author" size="56"></td>
			</tr>
			<tr>
				<th>출판사</th>
				<td><input type="text" name="publishing_com" size="56"></td>
			</tr>
			<tr>
				<th>출판일</th>
				<td><input type="date" name="publishing_date"></td>
			</tr>
			<tr>
				<th>상품이미지</th>
				<td><input type="file" name="publishing_image"></td>
			</tr>
			<tr>
				<th>상품내용</th>
				<td><textarea name="product_content" rows="13" cols="58"></textarea></td>
			</tr>
			<tr>
				<th>할인율</th>
				<td><input type="number" name="discount_rate" min="0" max="90">%</td>
			</tr>
		</table>
		<div class="btns">
			<input type="button" value="상품등록" id="btn_register">
			<input type="reset" value="다시입력">
			<input type="button" value="상품목록보기" id="btn_list">
			<input type="button" value="관리자페이지" id="btn_main">
		</div>
	</form>
</div>
</body>
</html>