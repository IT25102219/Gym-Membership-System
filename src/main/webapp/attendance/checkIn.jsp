<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance — GymPro</title>
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
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/members?action=list">Members</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/plans?action=list">Plans</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/trainers?action=list">Trainers</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/attendance?action=today">Attendance</a></li>
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
        <h4 class="fw-bold mb-3">📅 Attendance — Today</h4>

        <% String successMsg = (String) session.getAttribute("successMessage");
           if (successMsg != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= successMsg %><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="row g-3 mb-4">
            <!-- Check-in form -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header fw-bold" style="background:#1a1a2e; color:white;">✅ Check In</div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/attendance" method="post">
                            <input type="hidden" name="action" value="checkin">
                            <div class="mb-3">
                                <label class="form-label">Member ID</label>
                                <input type="number" class="form-control" name="memberId"
                                       value="<%= loggedMember.getMemberId() %>" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Record Check-In</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Check-out form -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header fw-bold" style="background:#0f3460; color:white;">🚪 Check Out</div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/attendance" method="post">
                            <input type="hidden" name="action" value="checkout">
                            <div class="mb-3">
                                <label class="form-label">Attendance Record ID</label>
                                <input type="number" class="form-control" name="recordId" placeholder="From table below" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Record Check-Out</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Quick links -->
            <div class="col-md-2">
                <div class="card border-0 shadow-sm h-100 d-flex align-items-center justify-content-center">
                    <div class="card-body text-center">
                        <a href="<%= request.getContextPath() %>/attendance?action=history&memberId=<%= loggedMember.getMemberId() %>"
                           class="btn btn-outline-info w-100 mb-2">My History</a>
                        <a href="<%= request.getContextPath() %>/attendance?action=report"
                           class="btn btn-outline-secondary w-100">Report</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Today's attendance table -->
        <div class="card border-0 shadow-sm">
            <div class="card-header fw-bold">Today's Attendance</div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-secondary">
                        <tr><th>Record ID</th><th>Member</th><th>Check-In</th><th>Check-Out</th><th>Duration</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% List<AttendanceRecord> records = (List<AttendanceRecord>) request.getAttribute("records");
                           if (records != null) { for (AttendanceRecord r : records) { %>
                        <tr>
                            <td><%= r.getRecordId() %></td>
                            <td class="fw-semibold"><%= r.getMemberName() %></td>
                            <td><%= r.getCheckIn() %></td>
                            <td><%= r.getCheckOut() != null ? r.getCheckOut() : "—" %></td>
                            <%-- calculateDuration() from AttendanceRecord --%>
                            <td><%= r.getCheckOut() != null ? r.calculateDuration() + " hrs" : "—" %></td>
                            <td>
                                <span class="badge <%= r.getCheckOut() == null ? "bg-success" : "bg-secondary" %>">
                                    <%= r.getCheckOut() == null ? "INSIDE" : "LEFT" %>
                                </span>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-center text-muted py-3">No visits today.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
