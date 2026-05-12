<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Member" %>
<%
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    if (loggedMember == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    request.setAttribute("pageTitle", "Dashboard - GymPro");
%>
<jsp:include page="/includes/header.jsp" />
<div class="p-4 mb-4 rounded-4 text-white position-relative overflow-hidden" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
    <i data-lucide="activity" class="position-absolute text-white opacity-25" style="width: 200px; height: 200px; top: -50px; right: -20px;"></i>
    <div class="position-relative z-index-1">
        <h3 class="fw-bold mb-3 d-flex align-items-center"><i data-lucide="hand" class="me-2 text-warning"></i> Welcome back, <%= loggedMember.getName() %>!</h3>
        <div class="d-flex flex-wrap gap-3 align-items-center">
            <span class="badge bg-white text-primary border rounded-pill px-3 py-2"><i data-lucide="shield-check" style="width:14px;height:14px;" class="me-1"></i> Role: <%= loggedMember.getRole().replace("_"," ") %></span>
            <span class="badge bg-white text-primary border rounded-pill px-3 py-2"><i data-lucide="key" style="width:14px;height:14px;" class="me-1"></i> Access: <%= loggedMember.getAccessLevel() %></span>
            <span class="badge bg-white text-primary border rounded-pill px-3 py-2"><i data-lucide="banknote" style="width:14px;height:14px;" class="me-1"></i> Fee: LKR <%= String.format("%.0f", loggedMember.getMonthlyFee()) %></span>
        </div>
        <p class="mt-3 mb-0 text-white-50 small d-flex align-items-center"><i data-lucide="info" style="width:14px;height:14px;" class="me-1"></i> <%= loggedMember.getDisplayInfo() %></p>
    </div>
</div>
<div class="row g-4">
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/members?action=list" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #e0e7ff; color: #4f46e5;">
                        <i data-lucide="users" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Members</h5>
                    <p class="card-text text-muted small">View, register, and manage gym members</p>
                    <span class="badge rounded-pill mt-2" style="background:#4f46e5; color:white; padding:0.5rem 1rem;">Manage Members <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/plans?action=list" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #dcfce7; color: #16a34a;">
                        <i data-lucide="clipboard-list" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Membership Plans</h5>
                    <p class="card-text text-muted small">View active plans with discounted pricing</p>
                    <span class="badge rounded-pill mt-2" style="background:#16a34a; color:white; padding:0.5rem 1rem;">Browse Plans <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/trainers?action=list" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #f3e8ff; color: #9333ea;">
                        <i data-lucide="award" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Trainers</h5>
                    <p class="card-text text-muted small">Personal &amp; Group trainers management</p>
                    <span class="badge rounded-pill mt-2" style="background:#9333ea; color:white; padding:0.5rem 1rem;">View Trainers <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/attendance?action=today" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #e0f2fe; color: #0284c7;">
                        <i data-lucide="calendar-check" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Attendance</h5>
                    <p class="card-text text-muted small">Check-in, check-out &amp; daily reports</p>
                    <span class="badge rounded-pill mt-2" style="background:#0284c7; color:white; padding:0.5rem 1rem;">Today's Attendance <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/payments?action=filter&status=PENDING" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #fef9c3; color: #ca8a04;">
                        <i data-lucide="credit-card" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Payments</h5>
                    <p class="card-text text-muted small">Cash &amp; online payment management</p>
                    <span class="badge rounded-pill mt-2" style="background:#ca8a04; color:white; padding:0.5rem 1rem;">Pending Payments <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6">
        <a href="<%= request.getContextPath() %>/reviews?action=view" class="text-decoration-none">
            <div class="card dash-card h-100">
                <div class="card-body text-center p-4">
                    <div class="icon-wrapper mx-auto mb-3" style="background: #fee2e2; color: #dc2626;">
                        <i data-lucide="star" style="width:28px;height:28px;"></i>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Reviews</h5>
                    <p class="card-text text-muted small">Member feedback &amp; verified reviews</p>
                    <span class="badge rounded-pill mt-2" style="background:#dc2626; color:white; padding:0.5rem 1rem;">View Reviews <i data-lucide="arrow-right" style="width:14px;height:14px;" class="ms-1"></i></span>
                </div>
            </div>
        </a>
    </div>
</div>
<div class="card mt-5 border-0 shadow-sm overflow-hidden">
    <div class="card-header border-0 d-flex align-items-center" style="background: var(--bg-dark); color:white;">
        <i data-lucide="code" class="me-2"></i> <strong>OOP Concepts Demonstrated in This System</strong>
    </div>
    <div class="card-body p-4 bg-white">
        <div class="row text-center g-4">
            <div class="col-md-3 col-6">
                <div class="p-3 bg-light rounded-4 h-100 border border-light-subtle shadow-sm transition-all hover-transform">
                    <div class="icon-wrapper mx-auto mb-2" style="width:40px;height:40px; background:#e0e7ff; color:#4f46e5;">
                        <i data-lucide="box" style="width:20px;height:20px;"></i>
                    </div>
                    <h6 class="fw-bold text-primary mb-1">ENCAPSULATION</h6>
                    <p class="small text-muted mb-0">All model fields private with getters/setters</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-light rounded-4 h-100 border border-light-subtle shadow-sm transition-all hover-transform">
                    <div class="icon-wrapper mx-auto mb-2" style="width:40px;height:40px; background:#dcfce7; color:#16a34a;">
                        <i data-lucide="git-merge" style="width:20px;height:20px;"></i>
                    </div>
                    <h6 class="fw-bold text-success mb-1">INHERITANCE</h6>
                    <p class="small text-muted mb-0">RegularMember → Member → Person (3 levels)</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-light rounded-4 h-100 border border-light-subtle shadow-sm transition-all hover-transform">
                    <div class="icon-wrapper mx-auto mb-2" style="width:40px;height:40px; background:#fef9c3; color:#ca8a04;">
                        <i data-lucide="layers" style="width:20px;height:20px;"></i>
                    </div>
                    <h6 class="fw-bold text-warning mb-1">POLYMORPHISM</h6>
                    <p class="small text-muted mb-0">Same method, different result per subclass</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-light rounded-4 h-100 border border-light-subtle shadow-sm transition-all hover-transform">
                    <div class="icon-wrapper mx-auto mb-2" style="width:40px;height:40px; background:#fee2e2; color:#dc2626;">
                        <i data-lucide="file-json" style="width:20px;height:20px;"></i>
                    </div>
                    <h6 class="fw-bold text-danger mb-1">ABSTRACTION</h6>
                    <p class="small text-muted mb-0">6 interfaces + 5 abstract classes</p>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
.hover-transform:hover { transform: translateY(-3px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1) !important; }
</style>
<jsp:include page="/includes/footer.jsp" />
