<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Member" %>
<%
    Member headerLoggedMember = (Member) session.getAttribute("loggedMember");
    Boolean hideNav = (Boolean) request.getAttribute("hideNav");
    if (hideNav == null) hideNav = false;
    
    // Auto-redirect if not logged in and nav is not hidden
    if (!hideNav && headerLoggedMember == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "GymPro" %></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Modern CSS -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="<%= hideNav ? "auth-bg" : "bg-light" %>">

<% if (!hideNav) { %>
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand text-white" href="<%= request.getContextPath() %>/dashboard.jsp">
                <i data-lucide="dumbbell" class="me-2"></i> GymPro
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navMenu">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/dashboard.jsp"><i data-lucide="layout-dashboard" class="me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/members?action=list"><i data-lucide="users" class="me-1"></i> Members</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/plans?action=list"><i data-lucide="clipboard-list" class="me-1"></i> Plans</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/trainers?action=list"><i data-lucide="award" class="me-1"></i> Trainers</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/attendance?action=today"><i data-lucide="calendar-check" class="me-1"></i> Attendance</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/payments?action=list"><i data-lucide="credit-card" class="me-1"></i> Payments</a></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%= request.getContextPath() %>/reviews?action=view"><i data-lucide="star" class="me-1"></i> Reviews</a></li>
                </ul>
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item me-3">
                        <span class="text-light d-flex align-items-center">
                            <i data-lucide="user-circle" class="me-2"></i> <%= headerLoggedMember != null ? headerLoggedMember.getName() : "" %>
                            <% if(headerLoggedMember != null && headerLoggedMember.getRole() != null) { %>
                                <span class="badge bg-primary ms-2"><%= headerLoggedMember.getRole().replace("_", " ") %></span>
                            <% } %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm d-flex align-items-center" href="<%= request.getContextPath() %>/auth?action=logout">
                            <i data-lucide="log-out" class="me-1"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-4 mb-5 flex-grow-1">
<% } else { %>
    <div class="container d-flex flex-column justify-content-center min-vh-100">
<% } %>

<%-- Display Flash Messages globally --%>
<% String globalSuccessMsg = (String) session.getAttribute("successMessage");
   if (globalSuccessMsg != null) { session.removeAttribute("successMessage"); %>
<div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
    <i data-lucide="check-circle" class="text-success"></i>
    <div><%= globalSuccessMsg %></div>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>

<% String globalErrorMsg = (String) request.getAttribute("errorMessage");
   if (globalErrorMsg == null) globalErrorMsg = (String) session.getAttribute("errorMessage");
   if (globalErrorMsg != null) { session.removeAttribute("errorMessage"); %>
<div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
    <i data-lucide="alert-circle" class="text-danger"></i>
    <div><%= globalErrorMsg %></div>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>
