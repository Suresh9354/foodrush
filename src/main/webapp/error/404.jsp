<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>404 - Not Found</title>
</head>
<body>
    <h2>404 - Page Not Found</h2>
    <p>Sorry, the page you are looking for does not exist on this server.</p>
    <p>If you are getting this on /login, it means your servlets are not registered. Please switch Render environment to Docker!</p>
    <a href="${pageContext.request.contextPath}/">Return to Home</a>
</body>
</html>
