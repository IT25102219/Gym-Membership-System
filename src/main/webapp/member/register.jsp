<%--
  PAGE    : member/register.jsp
  PURPOSE : Member registration form. New members fill in their details here.
  CALLS   : MemberServlet (/members) via POST with action="register"
  RECEIVES: errorMessage (String) — shown if registration fails (e.g., duplicate email)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register — GymPro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg,#1a1a2e,#0f3460); min-height:100vh; padding: 2rem 0; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card border-0 shadow-lg">
                <div class="card-header text-white text-center py-3" style="background:#1a1a2e;">
                    <h4 class="mb-0">🏋️ Join GymPro</h4>
                    <small>Create your membership account</small>
                </div>
                <div class="card-body p-4">

                    <%-- Error message display --%>
                    <% String errMsg = (String) request.getAttribute("errorMessage");
                       if (errMsg != null) { %>
                    <div class="alert alert-danger"><%= errMsg %></div>
                    <% } %>

                    <%--
                        REGISTRATION FORM
                        action="/members" → goes to MemberServlet
                        action="register" → MemberServlet creates RegularMember or PremiumMember
                    --%>
                    <form action="<%= request.getContextPath() %>/members" method="post">
                        <input type="hidden" name="action" value="register">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Full Name *</label>
                                <input type="text" class="form-control" name="name" placeholder="Name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Email Address *</label>
                                <input type="email" class="form-control" name="email" placeholder="email" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="text" class="form-control" name="phone" placeholder="phoneNo">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Date of Birth</label>
                                <input type="date" class="form-control" name="dob">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Gender</label>
                                <select class="form-select" name="gender">
                                    <option value="MALE">Male</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Membership Type *</label>
                                <select class="form-select" name="membershipType">
                                    <!-- POLYMORPHISM NOTE: this choice determines which Java subclass is created -->
                                    <option value="REGULAR">Regular (LKR 2500/month)</option>
                                    <option value="PREMIUM">Premium (LKR 5000/month)</option>
                                </select>
                                <small class="text-muted">Premium gets full access + personal trainer</small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Password *</label>
                            <input type="password" class="form-control" name="password" placeholder="Min 6 characters" required minlength="6">
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">
                            Create My Account
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <p class="text-muted">Already a member?
                            <a href="<%= request.getContextPath() %>/index.jsp">Login here</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
