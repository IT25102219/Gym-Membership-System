<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.AttendanceRecord, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance History — GymPro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>.navbar { background: linear-gradient(90deg,#1a1a2e,#0f3460) !important; }</style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/dashboard.jsp">🏋️ GymPro</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/attendance?action=today">Attendance</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-warning" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold">📅 Attendance History</h4>
            <a href="<%= request.getContextPath() %>/attendance?action=today" class="btn btn-outline-secondary">← Back</a>
        </div>

        <% List<AttendanceRecord> records = (List<AttendanceRecord>) request.getAttribute("records"); %>

        <!-- Summary stats -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm text-center p-3">
                    <h3 class="fw-bold text-primary"><%= records != null ? records.size() : 0 %></h3>
                    <p class="text-muted mb-0">Total Visits</p>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr><th>Date</th><th>Member</th><th>Check-In</th><th>Check-Out</th><th>Duration</th><th>Display Info</th></tr>
                    </thead>
                    <tbody>
                        <% if (records != null) { for (AttendanceRecord r : records) { %>
                        <tr>
                            <td><%= r.getAttendDate() %></td>
                            <td><%= r.getMemberName() %></td>
                            <td><%= r.getCheckIn() %></td>
                            <td><%= r.getCheckOut() != null ? r.getCheckOut() : "Still inside" %></td>
                            <td><%= r.getCheckOut() != null ? r.calculateDuration() + " hrs" : "—" %></td>
                            <td><small class="text-muted"><%= r.getDisplayInfo() %></small></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
