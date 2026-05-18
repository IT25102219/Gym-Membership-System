<%--
  PAGE    : trainer/addTrainer.jsp
  PURPOSE : Form to add a new trainer (Personal or Group).
  CALLS   : TrainerServlet (/trainers) via POST with action="add"
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Trainer — GymPro</title>
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
                        <h5 class="mb-0">➕ Add New Trainer</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="<%= request.getContextPath() %>/trainers" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Full Name *</label>
                                    <input type="text" class="form-control" name="name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Specialisation</label>
                                    <input type="text" class="form-control" name="specialisation" placeholder="e.g. Yoga, CrossFit">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Experience (Years)</label>
                                    <input type="number" class="form-control" name="experienceYears" min="0" value="0">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Trainer Type *</label>
                                    <select class="form-select" name="trainerType">
                                        <%-- Type determines which subclass is created — POLYMORPHISM --%>
                                        <option value="PERSONAL">Personal (LKR 3000/session)</option>
                                        <option value="GROUP">Group (LKR 1000/person)</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Phone</label>
                                    <input type="text" class="form-control" name="phone">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Email</label>
                                    <input type="email" class="form-control" name="email">
                                </div>
                                <div class="col-12 mb-4">
                                    <label class="form-label fw-semibold">Availability</label>
                                    <input type="text" class="form-control" name="availability"
                                           placeholder="e.g. Monday Tuesday Wednesday Thursday Friday">
                                    <small class="text-muted">Enter days separated by spaces (used by isAvailable() method)</small>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Add Trainer</button>
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
