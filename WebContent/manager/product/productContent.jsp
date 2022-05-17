<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manager.product.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세 보기</title>
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
 border-top:3px solid #705e7b; border-bottom:3px solid #705e7b; border-left:hidden; border-right:hidden;}
tr{height: 35px;}
td, th{border:1px solid #705e7b;}
th {background:#e6c9e1;}
td {padding-left: 5px;}
/* 중단 - 테이블 안의 입력상자 */
.c_p_id, .c_p_reg_date{border:none;}
.s_p_id, .s_p_reg_date{font-size:0.7em; color:red;}
.s_p_image {font-size:0.8em; color:blue;}

input[type="number"] {width:100px; text-align:right;}
input[type="number"]::-webkit-outer-spin-button, 
input[type="number"]::-webkit-inner-spin-button {-webkit-appearance: none; margin: 0;}
textarea {margin-top: 5px;}
select {height:24px;}
input::file-selector-button{width:90px; height: 27px; background: #705e7b; color:white; 
border:none; border-radius:5px; cursor:pointer;}
input::file-selector-button:hover{background:green; font-weight: 700; transition:ease-in-out 150ms;}


/* 하단 - 버튼 */
.btns{display: flex; justify-content:space-around; margin-top:20px;}
.btns input {width:100px; height:37px; border:none; background:#495057; color:#fff; font-weight:700;
 border-radius:10px; cursor:pointer;}
.btns input:hover {background: white; color: black; border: 1px solid black; transition: ease-in-out 150ms;}
.btns input:first-child{background: #705e7b;}
.btns input:nth-child(2){background: hotpink}
.btns input:first-child:hover{background: green; color:white; border:none; transition: ease-in-out 150ms;}
.btns input:nth-child(2):hover{background: red; color:white; border:none; transition: ease-in-out 150ms;}
</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		let form = document.updateForm;
		
		// 상품 분류가 선택되도록 설정 
		let product_kind = form.product_kind; // select
		let p_kind = form.p_kind; // ex) 자기계발 310이 있는 option
		for(i=0; i<product_kind.length; i++){
			if(p_kind.value == product_kind[i].value){ // 히든으로 받은 값과 선택된 옵션값이 같을때 선택되도록
				product_kind[i].selected = true;
				break;
			}
		}
		
		//상품 수정 유효성 검사 후 수정처리 페이지로 이동
		let btn_update = document.getElementById("btn_update");
		btn_update.addEventListener("click", function(){
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
		
		// 상품 삭제 처리 페이지로 이동
		let product_id = form.product_id.value;
		let pageNum = form.pageNum.value // 페이징 처리 = 삭제됐을떄  그전 페이지 유지
		let btn_delete = document.getElementById("btn_delete");
		btn_delete.addEventListener("click", function() {
			location = 'productDeletePro.jsp?product_id=' + product_id + "&pageNum=" + pageNum; // 페이징처리 - 삭제됐을때 그전 페이지 유지
		})
		
		
		// 상품목록 페이지 이동 버튼
		let btn_list = document.getElementById("btn_list");
		btn_list.addEventListener("click", function() {
			location = 'productList.jsp?pageNum=' + pageNum;
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

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

String pageNum = request.getParameter("pageNum");
int product_id = Integer.parseInt(request.getParameter("product_id"));

// DB연결 
ProductDAO productDAO = ProductDAO.getInstance();
ProductDTO product = productDAO.getProduct(product_id);

%>
<div id="container">
	<div class="m_title"><a href="../managerMain.jsp">EZEN MALL</a></div>
	<div class="s_title">상품 정보 확인</div>
	<form action="productUpdatePro.jsp" method="post" name="updateForm" enctype="multipart/form-data">
		<input type="hidden" name="pageNum" value="<%=pageNum%>">
		<table>
			<tr>
				<th>상품번호</th>
				<td>
					<input type="text" name="product_id" class="c_p_id" value=<%=product.getProduct_id() %> size="10" readonly>
					<span class="s_p_id">상품번호는 변경 불가</span>
				</td>
			</tr>
			<tr>
				<th width="20%">상품 분류</th>
				<td width="80%">
					<input type="hidden" name="p_kind" value="<%=product.getProduct_kind()%>">
					<select name="product_kind">
						<option value="110">소설/시</option>
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
				<td><input type="text" name="product_name" size="56" value="<%=product.getProduct_name()%>"></td>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><input type="number" name="product_price" min="1000" max="1000000" value="<%=product.getProduct_price()%>">원</td>
			</tr>
			<tr>
				<th>상품 수량</th>
				<td><input type="number" name="product_count" min="0" max="1000" value="<%=product.getProduct_count()%>">권</td>
			</tr>
			<tr>
				<th>저자</th>
				<td><input type="text" name="author" size="56" value="<%=product.getAuthor()%>"></td>
			</tr>
			<tr>
				<th>출판사</th>
				<td><input type="text" name="publishing_com" size="56" value="<%=product.getPublishing_com()%>"></td>
			</tr>
			<tr>
				<th>출판일</th>
				<td><input type="date" name="publishing_date" value="<%=product.getPublishing_date()%>"></td>
			</tr>
			<tr>
				<th>상품이미지</th>
				<td>
					<input type="file" name="publishing_image"><br>
					<span class="s_p_image">상품 이미지를 다시 업로드 하세요.</span>
				</td>
			</tr>
			<tr>
				<th>상품내용</th>
				<td><textarea name="product_content" rows="13" cols="58"><%=product.getProduct_content()%></textarea></td>
			</tr>
			<tr>
				<th>할인율</th>
				<td><input type="number" name="discount_rate" min="0" max="90" value="<%=product.getDiscount_rate()%>">%</td>
			</tr>
			<tr>
				<th>상품등록일</th>
				<td>
					<input type="text" name="reg_date" value="<%=sdf.format(product.getReg_date()) %>" class="c_p_reg_date" size="10" readonly>
					<span class="s_p_reg_date">등록일은 변경 불가</span>
				</td>
				
			</tr>
		</table>
		<div class="btns">
			<input type="button" value="상품정보수정" id="btn_update">
			<input type="button" value="상품정보삭제" id="btn_delete">
			<input type="button" value="상품목록보기" id="btn_list">
			<input type="button" value="관리자페이지" id="btn_main">
		</div>
	</form>
</div>
</body>
</html>