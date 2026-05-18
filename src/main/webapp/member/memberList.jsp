<%--
  PAGE    : member/memberList.jsp
  PURPOSE : Admin view of all gym members in a table with search and actions.
  CALLS   : MemberServlet for search, edit, delete actions
  RECEIVES: members (List<Member>) — set by MemberServlet
            searchQuery (String) — the current search term if any
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Member, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // SESSION CHECK — redirect to login if not authenticated
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    com.gym.model.Member loggedMember = (com.gym.model.Member) session.getAttribute("loggedMember");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Members — GymPro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar { background: linear-gradient(90deg,#1a1a2e,#0f3460) !important; }
    </style>
</head>
<body class="bg-light">

    <%-- Navbar --%>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/dashboard.jsp">🏋️ GymPro</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/members?action=list">Members</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/plans?action=list">Plans</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/trainers?action=list">Trainers</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/attendance?action=today">Attendance</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/payments?action=list">Payments</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/reviews?action=view">Reviews</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-warning" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold">👥 Member Management</h4>
            <a href="<%= request.getContextPath() %>/member/register.jsp" class="btn btn-primary">+ Add Member</a>
        </div>

        <%-- Flash messages --%>
        <% String successMsg = (String) session.getAttribute("successMessage");
           if (successMsg != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= successMsg %><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <%-- Search bar --%>
        <div class="card mb-3 border-0 shadow-sm">
            <div class="card-body py-2">
                <form action="<%= request.getContextPath() %>/members" method="get" class="d-flex gap-2">
                    <input type="hidden" name="action" value="search">
                    <input type="text" class="form-control" name="query"
                           value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>"
                           placeholder="Search by name or email...">
                    <button type="submit" class="btn btn-outline-primary">Search</button>
                    <a href="<%= request.getContextPath() %>/members?action=list" class="btn btn-outline-secondary">Reset</a>
                </form>
            </div>
        </div>

        <%-- Members Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Type</th>
                            <th>Join Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Member> members = (List<Member>) request.getAttribute("members");
                           if (members != null && !members.isEmpty()) {
                               for (Member m : members) { %>
                        <tr>
                            <td><%= m.getMemberId() %></td>
                            <td class="fw-semibold"><%= m.getName() %></td>
                            <td><%= m.getEmail() %></td>
                            <td><%= m.getPhone() != null ? m.getPhone() : "N/A" %></td>
                            <td>
                                <%-- Membership type badge: PREMIUM=gold, REGULAR=blue --%>
                                <% if ("PREMIUM".equals(m.getMembershipType())) { %>
                                    <span class="badge bg-warning text-dark">PREMIUM</span>
                                <% } else { %>
                                    <span class="badge bg-primary">REGULAR</span>
                                <% } %>
                            </td>
                            <td><%= m.getJoinDate() %></td>
                            <td>
                                <%-- Status badge: ACTIVE=green, INACTIVE=red --%>
                                <% if ("ACTIVE".equals(m.getStatus())) { %>
                                    <span class="badge bg-success">ACTIVE</span>
                                <% } else { %>
                                    <span class="badge bg-danger">INACTIVE</span>
                                <% } %>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/members?action=view&id=<%= m.getMemberId() %>"
                                   class="btn btn-sm btn-outline-info">View</a>
                                <a href="<%= request.getContextPath() %>/members?action=edit&id=<%= m.getMemberId() %>"
                                   class="btn btn-sm btn-outline-primary">Edit</a>
                                <a href="<%= request.getContextPath() %>/members?action=delete&id=<%= m.getMemberId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Deactivate this member?')">Delete</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="8" class="text-center text-muted py-4">No members found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- OOP Note for viva --%>
        <div class="alert alert-info mt-3">
            <strong>OOP Note:</strong> Each row above is either a <code>RegularMember</code> or <code>PremiumMember</code> object.
            MemberService creates the correct subclass based on the <code>membership_type</code> column — this is <strong>POLYMORPHISM</strong>.
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
