<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.AttendanceRecord, com.gym.model.Member, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "Attendance Report - GymPro");
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    boolean isAdmin = loggedMember != null && "ADMIN".equalsIgnoreCase(loggedMember.getMembershipType());
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
%>
<jsp:include page="/includes/header.jsp" />
<% if (successMsg != null) { %>
    <div class="alert alert-success mt-3 mx-4"><%= successMsg %></div>
<% } %>
<% if (errorMsg != null) { %>
    <div class="alert alert-danger mt-3 mx-4"><%= errorMsg %></div>
<% } %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="bar-chart-2" class="me-2 text-info"></i> Attendance Report</h4>
</div>

<!-- Date filter form -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body p-4">
        <form action="<%= request.getContextPath() %>/attendance" method="get" class="row g-3 align-items-end">
            <input type="hidden" name="action" value="report">
            <div class="col-md-4">
                <label class="form-label fw-semibold text-muted small text-uppercase">Select Date</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i data-lucide="calendar" class="text-muted" style="width:18px;height:18px;"></i></span>
                    <input type="date" class="form-control border-start-0 ps-0 bg-light" name="date"
                           value="<%= request.getAttribute("reportDate") != null ? request.getAttribute("reportDate") : "" %>">
                </div>
            </div>
            <div class="col-md-8">
                <button type="submit" class="btn btn-primary me-2"><i data-lucide="filter" class="me-1"></i> View Report</button>
                <a href="<%= request.getContextPath() %>/attendance?action=today" class="btn btn-outline-secondary"><i data-lucide="calendar-today" class="me-1"></i> Today</a>
            </div>
        </form>
    </div>
</div>

<% List<AttendanceRecord> records = (List<AttendanceRecord>) request.getAttribute("records"); %>

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm text-center p-4">
            <div class="icon-wrapper mx-auto mb-2" style="background: #e0f2fe; color: #0284c7;">
                <i data-lucide="users"></i>
            </div>
            <h2 class="fw-bold text-info mb-1"><%= records != null ? records.size() : 0 %></h2>
            <p class="text-muted mb-0 fw-medium">Total Visitors</p>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm overflow-hidden">
    <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
        <span><i data-lucide="file-text" class="me-2 text-muted" style="width:18px;height:18px;"></i> Report for: <strong><%= request.getAttribute("reportDate") %></strong></span>
        <button onclick="window.print()" class="btn btn-sm btn-outline-secondary"><i data-lucide="printer" class="me-1 w-4 h-4"></i> Print</button>
    </div>
    <div class="card-body p-0 table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Member</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Duration</th>
                    <th>Report</th>
                    <% if (isAdmin) { %><th>Action</th><% } %>
                </tr>
            </thead>
            <tbody>
                <% if (records != null && !records.isEmpty()) {
                      for (AttendanceRecord r : records) { %>
                <tr>
                    <td class="fw-semibold"><i data-lucide="user" style="width:14px;height:14px;" class="me-1 text-muted"></i> <%= r.getMemberName() %></td>
                    <td><span class="badge bg-light text-dark border"><i data-lucide="log-in" style="width:12px;height:12px;" class="me-1 text-success"></i><%= r.getCheckIn() %></span></td>
                    <td>
                        <% if (r.getCheckOut() != null) { %>
                            <span class="badge bg-light text-dark border"><i data-lucide="log-out" style="width:12px;height:12px;" class="me-1 text-danger"></i><%= r.getCheckOut() %></span>
                        <% } else { %>
                            <span class="badge bg-warning text-dark"><i data-lucide="clock" style="width:12px;height:12px;" class="me-1"></i>Inside</span>
                        <% } %>
                    </td>
                    <td><span class="fw-medium"><%= r.getCheckOut() != null ? r.calculateDuration() + " hrs" : "—" %></span></td>
                    <td><small class="text-muted bg-light p-1 rounded border"><%= r.generateReport() %></small></td>
                    <% if (isAdmin) { %>
                    <td>
                        <form action="<%= request.getContextPath() %>/attendance" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this attendance record?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="recordId" value="<%= r.getRecordId() %>">
                            <input type="hidden" name="returnAction" value="report">
                            <input type="hidden" name="reportDate" value="<%= request.getAttribute("reportDate") != null ? request.getAttribute("reportDate") : "" %>">
                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                        </form>
                    </td>
                    <% } %>
                </tr>
                <% } } else { %>
                <tr><td colspan="5" class="text-center text-muted py-5"><i data-lucide="inbox" style="width:32px;height:32px;opacity:0.5" class="d-block mx-auto mb-2"></i>No attendance records for this date.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<style>
@media print {
    .navbar, form, .btn-outline-secondary { display: none !important; }
    .card { box-shadow: none !important; border: 1px solid #dee2e6 !important; }
}
</style>

<jsp:include page="/includes/footer.jsp" />
