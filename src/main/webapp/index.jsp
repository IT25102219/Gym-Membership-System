<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    request.setAttribute("hideNav", true); 
    request.setAttribute("pageTitle", "Login - GymPro");
%>
<jsp:include page="/includes/header.jsp" />
<div class="row justify-content-center w-100">
    <div class="col-md-6 col-lg-5 col-xl-4">
        <div class="card auth-card border-0 mx-auto">
            <div class="card-body p-0">
                <div class="text-center mb-4">
                    <div class="icon-wrapper">
                        <i data-lucide="dumbbell" style="width: 32px; height: 32px;"></i>
                    </div>
                    <h2 class="fw-bold mt-2">GymPro</h2>
                    <p class="text-muted mb-2">Membership Management System</p>
                    <span class="badge bg-light text-dark border"><i data-lucide="book-open" class="me-1 d-inline-block" style="width:12px;height:12px;vertical-align:text-bottom;"></i> SE1020 — OOP Assignment</span>
                </div>
                <form action="<%= request.getContextPath() %>/auth" method="post">
                    <input type="hidden" name="action" value="login">
                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="mail" class="text-muted" style="width:18px;height:18px;"></i></span>
                            <input type="email" class="form-control border-start-0 ps-0 bg-light" id="email" name="email"
                                   placeholder="kasun@gmail.com" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="lock" class="text-muted" style="width:18px;height:18px;"></i></span>
                            <input type="password" class="form-control border-start-0 ps-0 bg-light" id="password" name="password"
                                   placeholder="Enter your password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold text-white mb-3">
                        <i data-lucide="log-in" class="me-2" style="width:18px;height:18px;"></i> Login to Dashboard
                    </button>
                </form>
                <div class="text-center mt-3 pt-3 border-top">
                    <p class="text-muted mb-0">New member?
                        <a href="<%= request.getContextPath() %>/member/register.jsp" class="text-decoration-none fw-semibold text-primary d-inline-flex align-items-center">
                            Create an account <i data-lucide="chevron-right" style="width:16px;height:16px;"></i>
                        </a>
                    </p>
                </div>
                <div class="mt-4 p-3 bg-light rounded text-center border">
                    <small class="text-muted d-block mb-1 d-flex justify-content-center align-items-center"><i data-lucide="info" style="width:14px;height:14px;" class="me-1"></i><strong>Demo Login</strong></small>
                    <small class="text-muted d-block">Email: <code>kasun@gmail.com</code> | <code>admin@gmail.com</code></small>
                    <small class="text-muted d-block">Password: <code>password123</code></small>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />
