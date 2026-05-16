<%--
  PAGE    : payment/paymentList.jsp
  PURPOSE : Admin view of all payments with filtering and status management.
  RECEIVES: payments (List<Payment>), filterStatus (String)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Payment, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Payments — GymPro</title>
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
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/attendance?action=today">Attendance</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/payments?action=list">Payments</a></li>
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
            <h4 class="fw-bold">💳 All Payments — Admin</h4>
            <a href="<%= request.getContextPath() %>/payment/addPayment.jsp" class="btn btn-success">+ Add Payment</a>
        </div>

        <% String successMsg = (String) session.getAttribute("successMessage");
           if (successMsg != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= successMsg %><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Filter buttons -->
        <div class="btn-group mb-3">
            <a href="<%= request.getContextPath() %>/payments?action=list" class="btn btn-outline-secondary">All</a>
            <a href="<%= request.getContextPath() %>/payments?action=filter&status=PAID" class="btn btn-outline-success">Paid</a>
            <a href="<%= request.getContextPath() %>/payments?action=filter&status=PENDING" class="btn btn-outline-warning">Pending</a>
            <a href="<%= request.getContextPath() %>/payments?action=filter&status=OVERDUE" class="btn btn-outline-danger">Overdue</a>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Member</th><th>Amount</th><th>Date</th><th>Method</th><th>Status</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% List<Payment> payments = (List<Payment>) request.getAttribute("payments");
                           if (payments != null) { for (Payment p : payments) { %>
                        <tr>
                            <td><%= p.getPaymentId() %></td>
                            <td>Member #<%= p.getMemberId() %></td>
                            <td class="fw-bold">LKR <%= String.format("%.2f", p.getAmount()) %></td>
                            <td><%= p.getPaymentDate() %></td>
                            <td><span class="badge <%= "CASH".equals(p.getMethod()) ? "bg-secondary" : "bg-info" %>"><%= p.getMethod() %></span></td>
                            <td>
                                <span class="badge <%= "PAID".equals(p.getStatus()) ? "bg-success" : "PENDING".equals(p.getStatus()) ? "bg-warning text-dark" : "bg-danger" %>">
                                    <%= p.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <!-- Mark as Paid -->
                                <% if (!"PAID".equals(p.getStatus())) { %>
                                <form action="<%= request.getContextPath() %>/payments" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
                                    <input type="hidden" name="status" value="PAID">
                                    <button type="submit" class="btn btn-sm btn-success">Mark Paid</button>
                                </form>
                                <% } %>
                                <!-- Delete -->
                                <form action="<%= request.getContextPath() %>/payments" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                            onclick="return confirm('Delete this payment?')">Delete</button>
                                </form>
                            </td>
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
