<%--
  PAGE    : trainer/trainerList.jsp
  PURPOSE : Admin view of all trainers. Shows getSessionRate() per trainer type.
            POLYMORPHISM: PersonalTrainer.getSessionRate()=3000, GroupTrainer=1000.
  RECEIVES: trainers (List<Trainer>) from TrainerServlet
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Trainer, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trainers — GymPro</title>
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
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/trainers?action=list">Trainers</a></li>
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
            <h4 class="fw-bold">💪 Trainer Management</h4>
            <div>
                <a href="<%= request.getContextPath() %>/trainers?action=view" class="btn btn-outline-info me-2">Public View</a>
                <a href="<%= request.getContextPath() %>/trainer/addTrainer.jsp" class="btn btn-primary">+ Add Trainer</a>
            </div>
        </div>

        <% String successMsg = (String) session.getAttribute("successMessage");
           if (successMsg != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= successMsg %><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th><th>Name</th><th>Type</th><th>Specialisation</th>
                            <th>Experience</th><th>Session Rate</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Trainer> trainers = (List<Trainer>) request.getAttribute("trainers");
                           if (trainers != null) { for (Trainer t : trainers) { %>
                        <tr>
                            <td><%= t.getTrainerId() %></td>
                            <td class="fw-semibold"><%= t.getName() %></td>
                            <td>
                                <%-- Trainer type badge: PERSONAL=purple, GROUP=teal --%>
                                <% if ("PERSONAL".equals(t.getTrainerType())) { %>
                                    <span class="badge" style="background:#6f42c1">PERSONAL</span>
                                <% } else { %>
                                    <span class="badge bg-success">GROUP</span>
                                <% } %>
                            </td>
                            <td><%= t.getSpecialisation() %></td>
                            <td><%= t.getExperienceYears() %> yrs</td>
                            <%-- getSessionRate() — POLYMORPHISM: Personal=3000, Group=1000 --%>
                            <td class="fw-bold text-success">LKR <%= String.format("%.0f", t.getSessionRate()) %></td>
                            <td><span class="badge <%= "ACTIVE".equals(t.getStatus()) ? "bg-success" : "bg-danger" %>"><%= t.getStatus() %></span></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/trainers?action=edit&id=<%= t.getTrainerId() %>" class="btn btn-sm btn-outline-primary">Edit</a>
                                <a href="<%= request.getContextPath() %>/trainers?action=delete&id=<%= t.getTrainerId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Deactivate this trainer?')">Delete</a>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="alert alert-info mt-3">
            <strong>OOP Note:</strong> <code>trainer.getSessionRate()</code> calls the polymorphic method.
            PersonalTrainer returns LKR 3,000; GroupTrainer returns LKR 1,000. Same method, different result = <strong>POLYMORPHISM</strong>.
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
