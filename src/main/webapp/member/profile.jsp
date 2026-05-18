<%--
  PAGE    : member/profile.jsp
  PURPOSE : Displays full member details and allows editing.
            Demonstrates getDisplayInfo(), getRole(), getAccessLevel() — POLYMORPHISM.
  CALLS   : MemberServlet (/members) via POST with action="update"
  RECEIVES: member (Member) — set by MemberServlet (either RegularMember or PremiumMember)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Member" %>
<%
    // SESSION CHECK
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    Member member = (Member) request.getAttribute("member");
    if (member == null) member = loggedMember; // fallback to logged-in member
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile — GymPro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>.navbar { background: linear-gradient(90deg,#1a1a2e,#0f3460) !important; }</style>
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
        <div class="row">
            <div class="col-md-8 mx-auto">

                <%-- Flash messages --%>
                <% String successMsg = (String) session.getAttribute("successMessage");
                   if (successMsg != null) { session.removeAttribute("successMessage"); %>
                <div class="alert alert-success"><%= successMsg %></div>
                <% } %>

                <%-- Member Profile Card --%>
                <div class="card border-0 shadow">
                    <div class="card-header text-white py-3" style="background:#1a1a2e;">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">👤 Member Profile</h5>
                            <div>
                                <%-- Show role badge — demonstrates POLYMORPHISM: getRole() returns different values --%>
                                <span class="badge bg-<%= "PREMIUM_MEMBER".equals(member.getRole()) ? "warning text-dark" : "secondary" %>">
                                    <%= member.getRole().replace("_"," ") %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-4">

                        <%-- getDisplayInfo() — POLYMORPHISM demonstration --%>
                        <div class="alert alert-info">
                            <strong>getDisplayInfo() → POLYMORPHISM:</strong><br>
                            <em><%= member.getDisplayInfo() %></em>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Member ID</label>
                                <p class="fw-bold">#<%= member.getMemberId() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Access Level</label>
                                <p class="fw-bold">
                                    Level <%= member.getAccessLevel() %>
                                    (<%= member.getAccessLevel() == 2 ? "Full Access" : "Basic Access" %>)
                                </p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Full Name</label>
                                <p class="fw-bold"><%= member.getName() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Email</label>
                                <p><%= member.getEmail() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Phone</label>
                                <p><%= member.getPhone() != null ? member.getPhone() : "Not provided" %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Date of Birth</label>
                                <p><%= member.getDob() != null ? member.getDob() : "Not provided" %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Gender</label>
                                <p><%= member.getGender() != null ? member.getGender() : "Not specified" %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Join Date</label>
                                <p><%= member.getJoinDate() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Monthly Fee</label>
                                <%-- getMonthlyFee() — POLYMORPHISM: Regular=2500, Premium=5000 --%>
                                <p class="fw-bold text-success">LKR <%= String.format("%.0f", member.getMonthlyFee()) %>/month</p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Status</label>
                                <p>
                                    <span class="badge bg-<%= "ACTIVE".equals(member.getStatus()) ? "success" : "danger" %>">
                                        <%= member.getStatus() %>
                                    </span>
                                </p>
                            </div>
                        </div>

                        <%-- Edit form --%>
                        <hr>
                        <h6 class="fw-bold">Edit Profile</h6>
                        <form action="<%= request.getContextPath() %>/members" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="memberId" value="<%= member.getMemberId() %>">

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Name</label>
                                    <input type="text" class="form-control" name="name" value="<%= member.getName() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone</label>
                                    <input type="text" class="form-control" name="phone" value="<%= member.getPhone() != null ? member.getPhone() : "" %>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Membership Type</label>
                                    <select class="form-select" name="membershipType">
                                        <option value="REGULAR" <%= "REGULAR".equals(member.getMembershipType()) ? "selected" : "" %>>Regular</option>
                                        <option value="PREMIUM" <%= "PREMIUM".equals(member.getMembershipType()) ? "selected" : "" %>>Premium</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status">
                                        <option value="ACTIVE" <%= "ACTIVE".equals(member.getStatus()) ? "selected" : "" %>>Active</option>
                                        <option value="INACTIVE" <%= "INACTIVE".equals(member.getStatus()) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                    <a href="<%= request.getContextPath() %>/members?action=list" class="btn btn-outline-secondary">Back to List</a>
                                    <a href="<%= request.getContextPath() %>/members?action=delete&id=<%= member.getMemberId() %>"
                                       class="btn btn-outline-danger float-end"
                                       onclick="return confirm('Deactivate this member?')">Deactivate</a>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
