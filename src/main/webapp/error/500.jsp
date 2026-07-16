<%@ page language="java" isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
    <title>500 - Internal Server Error</title>
</head>
<body>
    <h2>500 - Internal Server Error</h2>
    <p>An unexpected error occurred.</p>
    <pre>
<% 
    if (exception != null) {
        exception.printStackTrace(new PrintWriter(out));
    }
%>
    </pre>
</body>
</html>
