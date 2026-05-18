<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.MembershipPlan, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Payment — GymPro</title>
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
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/payments?action=list">Payments</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-warning" href="<%= request.getContextPath() %>/auth?action=logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card border-0 shadow">
                    <div class="card-header text-white py-3" style="background:#1a1a2e;">
                        <h5 class="mb-0">💳 Record New Payment</h5>
                        <small>Choose CASH or ONLINE — different processing logic (POLYMORPHISM)</small>
                    </div>
                    <div class="card-body p-4">
                        <form action="<%= request.getContextPath() %>/payments" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Member ID *</label>
                                <input type="number" class="form-control" name="memberId" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Plan ID *</label>
                                <input type="number" class="form-control" name="planId" required>
                                <small class="text-muted">See <a href="<%= request.getContextPath() %>/plans?action=list">Plans page</a> for plan IDs</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Amount (LKR) *</label>
                                <input type="number" class="form-control" name="amount" step="0.01" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Payment Date *</label>
                                <input type="date" class="form-control" name="paymentDate" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Payment Method *</label>
                                <select class="form-select" name="method">
                                    <%-- Method determines CashPayment vs OnlinePayment — POLYMORPHISM --%>
                                    <option value="CASH">CASH (marks as PAID, no TXN ID)</option>
                                    <option value="ONLINE">ONLINE (generates TXN ID automatically)</option>
                                    <option value="CARD">CARD (treated as Online)</option>
                                </select>
                                <small class="text-muted">
                                    CASH → CashPayment object | ONLINE/CARD → OnlinePayment object (Polymorphism!)
                                </small>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Record Payment</button>
                            <a href="<%= request.getContextPath() %>/payments?action=list" class="btn btn-outline-secondary w-100 mt-2">Cancel</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
