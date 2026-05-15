<%--
  PAGE    : payment/paymentHistory.jsp
  PURPOSE : Shows a member's payment history with receipts.
            Demonstrates generateReceipt() POLYMORPHISM: Cash vs Online receipt format.
  RECEIVES: payments (List<Payment>) from PaymentServlet
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
    <title>Payment History — GymPro</title>
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
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold">💳 Payment History</h4>
            <a href="<%= request.getContextPath() %>/payments?action=list" class="btn btn-outline-secondary">Admin View</a>
        </div>

        <% List<Payment> payments = (List<Payment>) request.getAttribute("payments"); %>

        <!-- Total paid summary -->
        <% double totalPaid = 0;
           if (payments != null) {
               for (Payment p : payments) {
                   if ("PAID".equals(p.getStatus())) totalPaid += p.getAmount();
               }
           } %>
        <div class="alert alert-success">
            Total Amount Paid: <strong>LKR <%= String.format("%.2f", totalPaid) %></strong>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Date</th><th>Amount</th><th>Method</th><th>Status</th><th>Receipt</th></tr>
                    </thead>
                    <tbody>
                        <% if (payments != null) { for (Payment p : payments) { %>
                        <tr>
                            <td><%= p.getPaymentId() %></td>
                            <td><%= p.getPaymentDate() %></td>
                            <td class="fw-bold">LKR <%= String.format("%.2f", p.getAmount()) %></td>
                            <td><span class="badge <%= "CASH".equals(p.getMethod()) ? "bg-secondary" : "bg-info" %>"><%= p.getMethod() %></span></td>
                            <td>
                                <span class="badge <%="PAID".equals(p.getStatus()) ? "bg-success" : "PENDING".equals(p.getStatus()) ? "bg-warning text-dark" : "bg-danger" %>">
                                    <%= p.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <!-- View Receipt button — triggers modal showing generateReceipt() output -->
                                <button class="btn btn-sm btn-outline-info"
                                        onclick="showReceipt('<%= p.generateReceipt().replace("\n","\\n").replace("'","\\'") %>')">
                                    View Receipt
                                </button>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Receipt Modal -->
        <div class="modal fade" id="receiptModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header" style="background:#1a1a2e; color:white;">
                        <h5 class="modal-title">Payment Receipt</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <pre id="receiptContent" style="font-family: monospace; white-space: pre-wrap;"></pre>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="alert alert-info mt-3">
            <strong>OOP Note:</strong> "View Receipt" calls <code>payment.generateReceipt()</code>.
            CashPayment returns a plain receipt; OnlinePayment includes a TXN ID. Same method, different output = <strong>POLYMORPHISM</strong>.
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showReceipt(text) {
            document.getElementById('receiptContent').textContent = text.replace(/\\n/g, '\n');
            new bootstrap.Modal(document.getElementById('receiptModal')).show();
        }
    </script>
</body>
</html>
