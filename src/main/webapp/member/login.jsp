<%--
  PAGE    : member/login.jsp
  PURPOSE : Redirect alias — sends user to the main login page (index.jsp)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% response.sendRedirect(request.getContextPath() + "/index.jsp"); %>
