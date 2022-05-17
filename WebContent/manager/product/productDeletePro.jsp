<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manager.product.*"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 삭제 처리</title>
</head>
<body>
<%
String pageNum = request.getParameter("pageNum");
int product_id = Integer.parseInt(request.getParameter("product_id")); // id값만 받아서 삭제 처리
ProductDAO productDAO = ProductDAO.getInstance();
productDAO.deleteProduct(product_id);
response.sendRedirect("productList.jsp?pageNum=" + pageNum);
%>
</body>
</html>