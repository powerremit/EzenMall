<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manager.product.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쇼핑몰 전체</title> <%-- 쇼핑몰 전체: 상단+메인+하단 --%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<style>
#container {width: 1200px; margin: 0 auto;}
/* 상단 슬라이더 영역 */
.new_items {text-align: center;}
.new_item .slider {width: 100%;}
.rcmd_items {text-align: center;}
.rcmd_items .slider {width: 100%;}
</style>
<script>
// 슬라이더(slider), 카로셀(carousel-회전목마)
$(document).ready(function(){
  $('.slider').bxSlider({
    autoControls: false, 		// 재생 일시정지 컨트롤버튼 기본값은 ,false
    stopAutoOnClick: true,    // 기본값 false, 불릿을 눌렀을때 화면전환 자동으로 될건지 여부.
    auto:true,
    autoHover: true, 			// 마우스올리면 자동전환 멈춤
    infiniteLoop: true, 		// 무한루프 설정
    pause:3000, 				// 자동 전환, 전환지연시간.
    speed: 2000, 				// 전환 속도
    pager: false,
    slideWidth: 220,
    maxSlides: 5, 			// 이미지 최대 노출
    minSlides: 2, 			// 이미지 최소 노출개수
    moveSlides: 2, 			// 슬라이드 이동 개수 
    slideMargin: 20, 			// 슬라이드 사이 마진 
    touchEnabled: false,		// 웹화면의 touch 이벤트 제거 -> 이미지 클릭 했을 때 해당 페이지로 이동 가능
  });
});


</script>
</head>
<body>
<%
ProductDAO productDAO = ProductDAO.getInstance();
// 메인1: 100번대와 200번대에서 신상품 3개씩을 리스트에 담아서 리턴
String[] nProducts = {"110", "120", "220", "230", "240", "250"};
List<ProductDTO> newProductList = productDAO.getProductList(nProducts);

// 메인2: 추천상품(모든상품에서 최신상품 1개씩 리스트에 담아 리턴) -->
String[] rProducts = {"110","120","210","230","240","250","310","320","410","420","510","610","620","630","710","720","810","910","920"};
List<ProductDTO> rcmdProductList = productDAO.getRcmdProductList(rProducts);

//for(ProductDTO product: newProductList){
//	System.out.println(product.getProduct_id() +","+product.getProduct_image());
//}
//for(ProductDTO product: rcmdProductList){
//	System.out.println(product.getProduct_id() +","+product.getProduct_image());
//}
%>
<div id="container">
	<!-- 상단 -->
	<div>
		<header><jsp:include page="../common/shopTop.jsp"/></header>
	</div>
	
	<!-- 메인(본문) -->
	<div>
		<main>
			<%-- 메인1: 100번 200번대 신상품 3개씩 가져와서 bxSlider로 노출  --%>
			<article class="new_items">
				<h3>신상품</h3>
				<div class="slider">
				<%for(ProductDTO product: newProductList) {%>
					<a href="shopContent.jsp?product_id=<%=product.getProduct_id() %>"><img src="/images_ezenmall/<%=product.getProduct_image()%>"></a>
				<%} %>
				</div>
			</article>
			
			<%-- 메인2: 추천상품: 모든 상품에서  신상품 1개씩을 가져와서 bxSlider으로 노출 --%>
			<article class="rcmd_items">
				<h3>추천 도서</h3>
				<div class="slider">
				<%for(ProductDTO product: rcmdProductList) { %>
					<a href="shopContent.jsp?product_id=<%=product.getProduct_id()%>"><img src="/images_ezenmall/<%=product.getProduct_image()%>"></a>
				<%} %>
				</div>
			</article>
			
			<%-- 메인3: 베스트셀러: 주문수량이 가장 많은 상품 20개를 가져와서 노출 --%>
			<article class="best_items">
				<h3>베스트셀러</h3>	
			</article>
			
			<%-- 메인4: 상품 종류별로 나열되도록 설정한 영역 --%>
			<article class="kind_items">
				<jsp:include page="shopMain.jsp"/>
			</article>
		</main>
	</div>
	
	<!-- 하단 -->
	<div>
		<footer><jsp:include page="../common/shopBottom.jsp"/></footer>
	</div>
</div>
</body>
</html>