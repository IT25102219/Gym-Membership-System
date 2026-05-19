<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.AttendanceRecord, com.gym.model.Member, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    boolean isAdmin = loggedMember != null && "ADMIN".equalsIgnoreCase(loggedMember.getMembershipType());
    request.setAttribute("pageTitle", "Attendance Today - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<%
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
%>
<% if (successMsg != null) { %>
    <div class="alert alert-success mt-3"><%= successMsg %></div>
<% } %>
<% if (errorMsg != null) { %>
    <div class="alert alert-danger mt-3"><%= errorMsg %></div>
<% } %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="calendar-check" class="me-2 text-primary"></i> Attendance — Today</h4>
</div>

<div class="row g-4 mb-4">
    <!-- Check-in form -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                <h5 class="fw-bold text-success d-flex align-items-center"><i data-lucide="log-in" class="me-2"></i> Check In</h5>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/attendance" method="post">
                    <input type="hidden" name="action" value="checkin">
                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Member ID</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="hash" class="text-muted" style="width:18px;height:18px;"></i></span>
                            <input type="number" class="form-control border-start-0 ps-0 bg-light" name="memberId"
                                   value="<%= loggedMember.getMemberId() %>" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success w-100 py-2"><i data-lucide="check-circle" class="me-1"></i> Record Check-In</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Check-out form -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                <h5 class="fw-bold text-danger d-flex align-items-center"><i data-lucide="log-out" class="me-2"></i> Check Out</h5>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/attendance" method="post">
                    <input type="hidden" name="action" value="checkout">
                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Attendance Record ID</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="fingerprint" class="text-muted" style="width:18px;height:18px;"></i></span>
                            <input type="number" class="form-control border-start-0 ps-0 bg-light" name="recordId" placeholder="From table below" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-danger text-white w-100 py-2" style="background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%); border:none;"><i data-lucide="x-circle" class="me-1 text-white"></i> Record Check-Out</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Quick links -->
    <div class="col-md-2">
        <div class="card border-0 shadow-sm h-100 bg-primary text-white text-center d-flex flex-column justify-content-center p-3" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
            <i data-lucide="zap" class="mx-auto mb-3 opacity-75" style="width:32px;height:32px;"></i>
            <h6 class="fw-bold mb-3">Quick Actions</h6>
            <a href="<%= request.getContextPath() %>/attendance?action=history&memberId=<%= loggedMember.getMemberId() %>"
               class="btn btn-light w-100 mb-2 text-primary fw-bold"><i data-lucide="history" class="me-1 w-4 h-4"></i> My History</a>
            <a href="<%= request.getContextPath() %>/attendance?action=report"
               class="btn btn-outline-light w-100 border-white text-white"><i data-lucide="bar-chart" class="me-1 w-4 h-4"></i> Report</a>
        </div>
    </div>
</div>

<!-- Today's attendance table -->
<div class="card border-0 shadow-sm overflow-hidden">
    <div class="card-header bg-white py-3 d-flex align-items-center border-bottom">
        <i data-lucide="list" class="me-2 text-muted"></i> <span class="fw-bold">Today's Active & Completed Visits</span>
    </div>
    <div class="card-body p-0 table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Record ID</th>
                    <th>Member</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Duration</th>
                    <th>Status</th>
                    <% if (isAdmin) { %><th>Action</th><% } %>
                </tr>
            </thead>
            <tbody>
                <% List<AttendanceRecord> records = (List<AttendanceRecord>) request.getAttribute("records");
                   if (records != null && !records.isEmpty()) { for (AttendanceRecord r : records) { %>
                <tr>
                    <td><span class="badge bg-light text-dark border">#<%= r.getRecordId() %></span></td>
                    <td class="fw-semibold"><i data-lucide="user" style="width:14px;height:14px;" class="me-1 text-muted"></i> <%= r.getMemberName() %></td>
                    <td><span class="badge bg-light text-dark border"><i data-lucide="log-in" style="width:12px;height:12px;" class="me-1 text-success"></i><%= r.getCheckIn() %></span></td>
                    <td>
                        <% if (r.getCheckOut() != null) { %>
                            <span class="badge bg-light text-dark border"><i data-lucide="log-out" style="width:12px;height:12px;" class="me-1 text-danger"></i><%= r.getCheckOut() %></span>
                        <% } else { %>
                            <span class="text-muted">—</span>
                        <% } %>
                    </td>
                    <td><span class="fw-medium"><%= r.getCheckOut() != null ? r.calculateDuration() + " hrs" : "—" %></span></td>
                    <td>
                        <% if (r.getCheckOut() == null) { %>
                            <span class="badge bg-success bg-opacity-10 text-success border border-success"><i data-lucide="activity" style="width:12px;height:12px;" class="me-1"></i>INSIDE</span>
                        <% } else { %>
                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary"><i data-lucide="check" style="width:12px;height:12px;" class="me-1"></i>LEFT</span>
                        <% } %>
                    </td>
                    <% if (isAdmin) { %>
                    <td>
                        <form action="<%= request.getContextPath() %>/attendance" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this attendance record?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="recordId" value="<%= r.getRecordId() %>">
                            <input type="hidden" name="returnAction" value="today">
                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                        </form>
                    </td>
                    <% } %>
                </tr>
                <% } } else { %>
                <tr><td colspan="6" class="text-center text-muted py-5"><i data-lucide="inbox" style="width:32px;height:32px;opacity:0.5" class="d-block mx-auto mb-2"></i>No visits today yet.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
