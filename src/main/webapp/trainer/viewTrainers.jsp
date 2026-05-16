<%--
  PAGE    : trainer/viewTrainers.jsp
  PURPOSE : Public member-facing view of active trainers with availability checking.
            Demonstrates isAvailable(String day) method from ISchedulable interface.
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
    <title>Our Trainers — GymPro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar { background: linear-gradient(90deg,#1a1a2e,#0f3460) !important; }
        .trainer-card { border-radius: 12px; transition: transform 0.2s; }
        .trainer-card:hover { transform: translateY(-4px); }
    </style>
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
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/trainers?action=view">Trainers</a></li>
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
        <h4 class="fw-bold mb-3">💪 Our Trainers</h4>
        <div class="alert alert-info">
            <strong>OOP Demo:</strong> <code>trainer.isAvailable("Monday")</code> calls the <code>ISchedulable</code> interface method.
            <code>trainer.getSessionRate()</code> demonstrates POLYMORPHISM (Personal=LKR 3000, Group=LKR 1000).
        </div>
        <div class="row g-4">
            <% List<Trainer> trainers = (List<Trainer>) request.getAttribute("trainers");
               if (trainers != null) { for (Trainer t : trainers) { %>
            <div class="col-md-4">
                <div class="card trainer-card border-0 shadow-sm h-100">
                    <div class="card-header text-white py-3"
                         style="background:<%= "PERSONAL".equals(t.getTrainerType()) ? "#6f42c1" : "#20c997" %>; border-radius:12px 12px 0 0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold"><%= t.getName() %></h6>
                            <span class="badge bg-light text-dark"><%= t.getTrainerType() %></span>
                        </div>
                    </div>
                    <div class="card-body">
                        <p class="mb-1"><strong>Specialisation:</strong> <%= t.getSpecialisation() %></p>
                        <p class="mb-1"><strong>Experience:</strong> <%= t.getExperienceYears() %> years</p>
                        <p class="mb-1"><strong>Session Rate:</strong>
                            <span class="text-success fw-bold">LKR <%= String.format("%.0f", t.getSessionRate()) %></span>
                            <%= "PERSONAL".equals(t.getTrainerType()) ? "/session" : "/person/session" %>
                        </p>
                        <p class="mb-1"><small><strong>Availability:</strong> <%= t.getAvailability() != null ? t.getAvailability() : "Contact us" %></small></p>

                        <!-- isAvailable() from ISchedulable — checks specific days -->
                        <div class="mt-2">
                            <small class="text-muted">Available Mon-Fri:</small><br>
                            <% String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday"};
                               for (String day : days) { %>
                            <span class="badge <%= t.isAvailable(day) ? "bg-success" : "bg-secondary" %> me-1" style="font-size:0.65rem;">
                                <%= day.substring(0,3) %>
                            </span>
                            <% } %>
                        </div>

                        <p class="mt-2 small text-muted"><em><%= t.getDisplayInfo() %></em></p>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
        <div class="mt-3">
            <a href="<%= request.getContextPath() %>/trainers?action=list" class="btn btn-outline-primary">Admin View →</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
