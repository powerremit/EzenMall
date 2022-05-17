<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manager.product.*, java.util.List, java.text.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제품 목록</title>	
<style>
@import url('https://fonts.googleapis.com/css2?family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap');
#container {width: 1200px; margin: 20px auto;}
.m_title a{text-decoration:none; color: #1DDB16;}

/* 상단 - 메인, 서브타이틀 */
.m_title{font-family: 'Paytone One', sans-serif; font-size: 3em; text-align:center;}
.s_title{font-family: 'Do Hyeon', sans-serif; font-size: 2em; text-align:center; margin-bottom: 30px;}
a {text-decoration: none; color: #59637f; font-size:0.95em; font-weight: 700;}
/* 상단 - 전체 상품수, 아이디, 로그아웃, 상품등록*/
.top_info { margin-bottom:10px; text-align:right;}
.c_cnt {float:left;}
.c_cnt, .c_managerId {color: #59637f; font-size:0.95em; font-weight: 700; }
.c_managerId{clear:both;}
.c_logout{color: #99424f;}

/* 상단 - 검색 */
.top_search { margin-bottom: 10px;}
.c_select { width: 153px; height: 25px;}
.c_input { width: 200px; height: 19px;}
.c_submit { width: 82px; height: 27px; border: none; background: #000; color: #fff; 
font-size: 0.8em; font-weight: bold; border-radius: 3px;}

/* 중단 - 테이블 */
table {width: 100%; border: 1px solid black; border-collapse: collapse; font-size: 0.9em; }
tr {height: 30px;}
th, td{border: 1px solid black;}
th {background: #dee2e6;}
tr:nth-child(2n+1) {background: #f8f9fa;}
.center{text-align: center;}
.left{text-align: left; padding-left:3px;}
.right{text-align: right; padding-right:5px;}
.img_update:hover{content: url('../../icons/update2.png');}
.img_delete:hover{content: url('../../icons/delete2.png');}

/* 하단 = 페이지네이션 */
#paging {text-align: center; margin-top: 20px;}
#pBox {display: inline-block; width: 22px; height: 22px; padding:5px; margin: 5px; font-size:0.9em;}
#pBox:hover {background: #adb5bd; color:white; border-radius:10px; font-weight:700; transition: ease-in-out 150ms;}
.pBox_c {background: #495057; color:white; border-radius:10px; font-weight:700;}
.pBox_b {font-weight:700;}

</style>
<script>

</script>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String managerId = (String)session.getAttribute("managerId");
if(managerId==null){
	out.print("<script>location='../logon/managerLoginForm.jsp';</script>");
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
DecimalFormat df = new DecimalFormat("#,###,###");
String product_kindName = "";

//페이징처리(페이지네이션) ##########
//페이징 처리를 위한 변수 선언
int pageSize = 10; // 한페이지에 10개씩 
String pageNum = request.getParameter("pageNum");
if(pageNum==null){
	pageNum = "1"; // pageNum 이 없다면 1페이지로 넘어오겠다.
};
int currentPage = Integer.parseInt(pageNum); // 현재 페이지
int startRow = (currentPage -1) * pageSize + 1; // 현재 페이지의 첫번째 행
int endRow = currentPage * pageSize; // 현재페이지의 마지막 행

//##########################

// 검색 처리 - 검색일때는 search가 1이고, 검색이 아닐때는 search가 0
String search = request.getParameter("search");
String s_search = "";
String i_search = "";
if(search == null) {
	search = "0";
} else { // search가 "1"일때
	s_search = request.getParameter("s_search");
	i_search = request.getParameter("i_search");
}

// DB 연결, 질의 처리
ProductDAO productDAO = ProductDAO.getInstance();
// 전체 상품수 조회
int cnt = 0;
// 전체 상품 조회 - ##페이징 처리가 된 상품 조회 , 검색처리(search 가 1이면 검색, search가 0이면 검색이 아님)
List<ProductDTO> productList = null;
if(search.equals("1")) {
	productList = productDAO.getProductList(startRow, pageSize, s_search, i_search);
	cnt = productDAO.getProductCount(s_search, i_search);
} else if(search.equals("0")) {
	productList = productDAO.getProductList(startRow, pageSize);
	cnt = productDAO.getProductCount();
}

// 매 페이지 마다 전체 상품 수에 대한 역순 번호 --##페이징 처리
int number = cnt - ((currentPage-1) * pageSize); 

%>
<div id="container">
	<div class="m_title"><a href="../managerMain.jsp">EZEN MALL</a></div>
	<div class="s_title"><a href="productList.jsp">제품 목록</a></div>
	<div class="top_info">
		<span class="c_cnt">전체 상품 수: <%=cnt %>개</span>
		<span class="c_managerId"><%=managerId %>님(관리자)</span>&emsp;|&emsp;
		<span><a href="../managerMain.jsp">관리자페이지</a></span>&emsp;|&emsp;
		<span><a href="productRegister.jsp" class="c_register">상품등록</a></span>&emsp;|&emsp;
		<span><a href="../logon/managerLogout.jsp" class="c_logout">로그아웃</a></span>
	</div>
	<div class="top_search">
		<form action="productList.jsp" method="post" name="searchForm">
			<input type="hidden" name="search" value="1">
			<span class="c_s1">
				<select name="s_search" class="c_select">
					<option selected>제목</option>
					<option>저자</option>
					<option>출판사</option>
					<option>내용</option>
				</select>
			</span>
			<span class="c_s2"><input type="text" name="i_search" class="c_input"></span>
			<span class="c_s3"><input type="submit" value="검색" class="c_submit"></span>
		</form>
	</div>
	
	<table>
		<tr>
			<th width="4%">NO</th>
			<th width="9%">제품분류</th>
			<th width="5%">이미지</th>
			<th width="20%">제품명</th>
			<th width="7%">가격</th>
			<th width="5%">재고</th>
			<th width="12%">저자</th>
			<th width="12%">출판사</th>
			<th width="7%">출판일</th>
			<th width="4%">할인율</th>
			<th width="7%">제품등록일</th>
			<th width="8%">수정 | 삭제</th>
		</tr>
		<%if(cnt == 0) {  // 등록된 글이 없을 때
			out.print("<tr><td colspan='13'>등록된 데이터가 없습니다.<td></tr>");
		} else { // 글이 있을 때
			for (ProductDTO product : productList) {	
				// 상품분류 분류코드말고 분류명으로 처리
				switch(product.getProduct_kind()){
				case "110": product_kindName = "소설/시"; break;
				case "120": product_kindName = "에세이"; break;
				case "210": product_kindName = "역사"; break;
				case "220": product_kindName = "예술"; break;
				case "230": product_kindName = "종교"; break;
				case "240": product_kindName = "사회"; break;
				case "250": product_kindName = "과학"; break;
				case "310": product_kindName = "경제/경영"; break;
				case "320": product_kindName = "자기계발"; break;
				case "410": product_kindName = "여행"; break;
				case "420": product_kindName = "만화"; break;
				case "510": product_kindName = "잡지"; break;
				case "610": product_kindName = "어린이"; break;
				case "620": product_kindName = "육아"; break;
				case "630": product_kindName = "가정/살림"; break;
				case "710": product_kindName = "건강/취미"; break;
				case "720": product_kindName = "요리"; break;
				case "810": product_kindName = "IT 모바일"; break;
				case "910": product_kindName = "수험서/자격증"; break;
				case "920": product_kindName = "참고서"; break;
				default: product_kindName = product.getProduct_kind(); break;
				}
		%> 
		<tr>
			<td class="center"><%=number-- %></td>
			<td class="center"><%=product_kindName %></td>
			<td class="center">
				<a href="productContent.jsp?product_id=<%=product.getProduct_id()%>&pageNum=<%=pageNum%>">
					<img src=<%="/images_ezenmall/" + product.getProduct_image()%> width="35px" height="50px">
				</a>
			</td>
			<td class="left">
				<a href="productContent.jsp?product_id=<%=product.getProduct_id()%>&pageNum=<%=pageNum%>"><%=product.getProduct_name() %></a>
			</td>
			<td class="right"><%=df.format(product.getProduct_price()) %>원</td>
			<td class="right"><%=df.format(product.getProduct_count()) %>권</td>
			<td class="center"><%=product.getAuthor() %></td>
			<td class="center"><%=product.getPublishing_com() %></td>
			<td class="center"><%=product.getPublishing_date() %></td>
			<td class="center"><%=product.getDiscount_rate() %>&#37;</td>
			<td class="center"><%=sdf.format(product.getReg_date()) %></td>
			<td class="center">
				<a href="productContent.jsp?product_id=<%=product.getProduct_id()%>&pageNum=<%=pageNum%>"><img alt="" src="../../icons/update1.png" class="img_update" width="25" title="상품수정"></a>&nbsp;
				<a href="productDeletePro.jsp?product_id=<%=product.getProduct_id()%>&pageNum=<%=pageNum%>"><img alt="" src="../../icons/delete1.png" class="img_delete" width="25" title="상품삭제"></a>
			</td>
		</tr>
		<%} }%>
	</table>
	<!-- 페이징처리 -->
	<div id="paging">
		<%
		if(cnt>0) {
			int pageCount = cnt / pageSize + (cnt%pageSize==0 ? 0 : 1);  // 전체 페이지 수
			int startPage = 1; // 시작페이지의 번호
			int pageBlock = 10; // 페이징의 개수
			
			// 시작페이지 설정
			if(currentPage % 10 != 0) {
				startPage = (currentPage/10)*10 + 1;
			} else {
				startPage = (currentPage/10-1)*10 + 1;
			}
			// 끝 페이지 설정
			int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount) endPage = pageCount; // 마지막 페이지 번호
			
			// 맨 처음 페이지 이동처리
			if(startPage > 10) {
				out.print("<a href='productList.jsp?pageNum=1&search="+search+"&s_search="+s_search+"&i_search="+i_search+"'><div id='pBox' class='pBox_b' title='첫페이지'>"+ "〈〈" +"</div></a>");
			}
			// 이전 페이지 이동 처리
			if(startPage > 10){
				out.print("<a href='productList.jsp?pageNum="+(currentPage-10)+"&search="+search+"&s_search="+s_search+"&i_search="+i_search+"'><div id='pBox' class='pBox_b' title='이전페이지'>"+ "〈" +"</div></a>");
			}
			
			// 페이징 블럭 출력 처리 (현재 페이지에 대해서 몇부터 몇까지가 나오나)
			for(int i=startPage; i<=endPage; i++){
				if(currentPage == i){ // 선택된 페이지만 효과 처리
					out.print("<div id='pBox' class='pBox_c'>" + i + "</div>");				
				} else { // 선택 안된 페이지
					out.print("<a href='productList.jsp?pageNum="+i+"&search="+search+"&s_search="+s_search+"&i_search="+i_search+"'><div id='pBox'>" + i + "</div></a>");
				}
			}
			
			// 다음 페이지 이동 처리
			if(endPage < pageCount) {
				int movePage = currentPage + 10;
				if(movePage > pageCount) {
					movePage = pageCount;
				}
				out.print("<a href='productList.jsp?pageNum="+ (movePage) +"&search="+search+"&s_search="+s_search+"&i_search="+i_search+"'><div id='pBox' class='pBox_b' title='다음페이지'>" + "〉" + "</div></a>");				
			}
			
			// 맨 마지막 페이지 이동 처리
			if(endPage < pageCount) {
				out.print("<a href='productList.jsp?pageNum="+ pageCount +"&search="+search+"&s_search="+s_search+"&i_search="+i_search+"'><div id='pBox' class='pBox_b' title='마지막페이지'>" + "〉〉" + "</div></a>");
			}
		}
		%>
	</div>
</div>
</body>
</html>