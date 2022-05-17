<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%@page import="manager.product.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록 처리 페이지</title>
</head>
<body>
<%request.setCharacterEncoding("utf-8");%>
<%-- <jsp:useBean id="product" class="manager.product.ProductDTO"/>
<jsp:setProperty property="*" name="product"/> <!-- request로 받는것보다 자바빈을 이용 하면 간편하게 데이터를 받을 수 있음. --> --%>

<%
// 입력폼의 입력 정보 획득 = 파일업로드 폼이기 때문에 request로 작업 못함 => cos.jar 라이브러리 멀티파트리퀘스트클래스를 사용
// request, 업로드 폴더, 파일최대크기, encType, 파일명중복정책 5개를 받아와야된다.
// 파일 업로드 폴더: C:/images_ezenmall
String realFolder = "C:/images_ezenmall";
int maxSize = 1024 * 1024 * 5; // 5메가
String encType = "utf-8";
String fileName = "";
MultipartRequest multi = null;

try{
	// 이미지 이름은 null값으로 받아와서 아래 작업을 해줘야한다.
	multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
	
	Enumeration<?> files = multi.getFileNames();
	while(files.hasMoreElements()){
		String name = (String)files.nextElement(); // name을 통해서 file이름을 알아낼 수 있다.
		fileName = multi.getFilesystemName(name);
	}
	
} catch(Exception e) {
	e.printStackTrace();
	System.out.println("productRegisterPro.jsp 파일: " + e.getMessage());
}

// 1작업 - 폼에서 넘어오는 10개의 필드값을 획득(멀티파트리퀘스트로) - 제외: product_id값(오토인크리먼트), reg_date(자동)
String product_kind = multi.getParameter("product_kind"); // request로 못받으니깐 multi로
String product_name = multi.getParameter("product_name");
int product_price = Integer.parseInt(multi.getParameter("product_price"));
int product_count = Integer.parseInt(multi.getParameter("product_count"));
String author = multi.getParameter("author");
String publishing_com = multi.getParameter("publishing_com");
String publishing_date = multi.getParameter("publishing_date");
//String product_image = multi.getParameter("product_image"); 이걸로는 이름을 얻을 수 없음.
String product_content = multi.getParameter("product_content");
int discount_rate = Integer.parseInt(multi.getParameter("discount_rate"));

// 2작업 - ProductDTO 객체 생성하여 setter메소드를 사용
ProductDTO product = new ProductDTO();
product.setProduct_kind(product_kind);
product.setProduct_name(product_name);
product.setProduct_price(product_price);
product.setProduct_count(product_count);
product.setAuthor(author);
product.setPublishing_com(publishing_com);
product.setPublishing_date(publishing_date);
product.setProduct_image(fileName); // fileName으로 파일명을 받았기 때문에(업로드한 파일의 실제 이름)
product.setProduct_content(product_content);
product.setDiscount_rate(discount_rate);

System.out.println("product 객체: " + product.toString()); 
/* 디버깅: productDTO에서 toString을 만든이유: 데이터가 잘 넘어오는지 콘솔에서 확인이 가능 */
//데이터가 null 값으로 넘어오는데, form에다가 enctype을 넣어서.. 파일 업로드를 하는 폼이기 때문에 -> 해결법:cos.jar클래스 멀티파트리퀘스트를 이용해야됨.
//그래서 액션태그를 사용할 수 없다. 자바빈 사용 불가능.


// 3작업 - DB처리(DB 연결, product테이블 상품 추가 처리) -->
ProductDAO productDAO = ProductDAO.getInstance(); // 여기까지하고 ProducDAO에서 메소드 생성
productDAO.insertProduct(product);
response.sendRedirect("productList.jsp");


%>
</body>
</html>