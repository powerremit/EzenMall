<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그아웃처리</title>
</head>
<body>
<%
// 세션 삭제. 모든 세션을 삭제하면안되니깐 해당세션만 종료
session.removeAttribute("managerId");
%>
<script>
alert('관리자 로그아웃 되었습니다.');
location='managerLoginForm.jsp';
</script>
</body>
</html>