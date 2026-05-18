<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.AttendanceRecord, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "Attendance History - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="history" class="me-2 text-primary"></i> Attendance History</h4>
    <a href="<%= request.getContextPath() %>/attendance?action=today" class="btn btn-outline-secondary">
        <i data-lucide="arrow-left" class="me-1"></i> Back
    </a>
</div>

<% List<AttendanceRecord> records = (List<AttendanceRecord>) request.getAttribute("records"); %>

<!-- Summary stats -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm text-center p-4 h-100 d-flex flex-column justify-content-center align-items-center">
            <div class="icon-wrapper mb-2" style="background: #e0e7ff; color: #4f46e5;">
                <i data-lucide="calendar-days"></i>
            </div>
            <h2 class="fw-bold text-primary mb-1"><%= records != null ? records.size() : 0 %></h2>
            <p class="text-muted mb-0 fw-medium">Total Visits</p>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm overflow-hidden">
    <div class="card-body p-0 table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Member</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Duration</th>
                    <th>Display Info</th>
                </tr>
            </thead>
            <tbody>
                <% if (records != null && !records.isEmpty()) { for (AttendanceRecord r : records) { %>
                <tr>
                    <td class="fw-medium"><i data-lucide="calendar" style="width:14px;height:14px;" class="me-1 text-muted"></i> <%= r.getAttendDate() %></td>
                    <td class="fw-semibold"><%= r.getMemberName() %></td>
                    <td><span class="badge bg-light text-dark border"><i data-lucide="log-in" style="width:12px;height:12px;" class="me-1 text-success"></i><%= r.getCheckIn() %></span></td>
                    <td>
                        <% if (r.getCheckOut() != null) { %>
                            <span class="badge bg-light text-dark border"><i data-lucide="log-out" style="width:12px;height:12px;" class="me-1 text-danger"></i><%= r.getCheckOut() %></span>
                        <% } else { %>
                            <span class="badge bg-warning text-dark"><i data-lucide="clock" style="width:12px;height:12px;" class="me-1"></i>Still inside</span>
                        <% } %>
                    </td>
                    <td><span class="fw-medium"><%= r.getCheckOut() != null ? r.calculateDuration() + " hrs" : "—" %></span></td>
                    <td><small class="text-muted"><%= r.getDisplayInfo() %></small></td>
                </tr>
                <% } } else { %>
                <tr><td colspan="6" class="text-center text-muted py-5"><i data-lucide="inbox" style="width:32px;height:32px;opacity:0.5" class="d-block mx-auto mb-2"></i>No attendance records found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
