<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.logon.ManagerDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인처리</title>
</head>
<body>
<%
String managerId = request.getParameter("managerId");
String managerPwd = request.getParameter("managerPwd");

ManagerDAO managerDAO = ManagerDAO.getInstance();
int cnt = managerDAO.checkManager(managerId, managerPwd);

out.print("<script>");
if(cnt > 0) { 
	// 로그인 성공 --> ★ 세션 생성 
	session.setAttribute("managerId", managerId);
	out.print("alert('로그인에 성공했습니다.');location='../managerMain.jsp';");
} else {
	out.print("alert('로그인에 실패했습니다.');history.back();");
}
out.print("</script>");
%>
</body>
</html>