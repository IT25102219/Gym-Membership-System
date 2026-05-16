<%--
  PAGE    : trainer/editTrainer.jsp
  PURPOSE : Edit form for an existing trainer.
  CALLS   : TrainerServlet (/trainers) via POST with action="update"
  RECEIVES: trainer (Trainer) from TrainerServlet
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Trainer" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    Trainer trainer = (Trainer) request.getAttribute("trainer");
    if (trainer == null) { response.sendRedirect(request.getContextPath() + "/trainers?action=list"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Trainer — GymPro</title>
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
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/trainers?action=list">Trainers</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-warning" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="card border-0 shadow">
                    <div class="card-header text-white py-3" style="background:#1a1a2e;">
                        <h5 class="mb-0">✏️ Edit Trainer: <%= trainer.getName() %></h5>
                        <small>Session Rate: LKR <%= String.format("%.0f", trainer.getSessionRate()) %> (POLYMORPHISM)</small>
                    </div>
                    <div class="card-body p-4">
                        <form action="<%= request.getContextPath() %>/trainers" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="trainerId" value="<%= trainer.getTrainerId() %>">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Name</label>
                                    <input type="text" class="form-control" name="name" value="<%= trainer.getName() %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Specialisation</label>
                                    <input type="text" class="form-control" name="specialisation" value="<%= trainer.getSpecialisation() %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Experience (Years)</label>
                                    <input type="number" class="form-control" name="experienceYears" value="<%= trainer.getExperienceYears() %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trainer Type</label>
                                    <select class="form-select" name="trainerType">
                                        <option value="PERSONAL" <%= "PERSONAL".equals(trainer.getTrainerType()) ? "selected" : "" %>>Personal</option>
                                        <option value="GROUP" <%= "GROUP".equals(trainer.getTrainerType()) ? "selected" : "" %>>Group</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <input type="text" class="form-control" name="phone" value="<%= trainer.getPhone() != null ? trainer.getPhone() : "" %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="<%= trainer.getEmail() != null ? trainer.getEmail() : "" %>">
                                </div>
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">Availability</label>
                                    <input type="text" class="form-control" name="availability" value="<%= trainer.getAvailability() != null ? trainer.getAvailability() : "" %>">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status">
                                        <option value="ACTIVE" <%= "ACTIVE".equals(trainer.getStatus()) ? "selected" : "" %>>Active</option>
                                        <option value="INACTIVE" <%= "INACTIVE".equals(trainer.getStatus()) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Update Trainer</button>
                            <a href="<%= request.getContextPath() %>/trainers?action=list" class="btn btn-outline-secondary w-100 mt-2">Cancel</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
