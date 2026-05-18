<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.MembershipPlan, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    com.gym.model.Member loggedMember = (com.gym.model.Member) session.getAttribute("loggedMember");
    request.setAttribute("pageTitle", "Membership Plans - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-1 d-flex align-items-center"><i data-lucide="clipboard-list" class="me-2 text-primary"></i> Membership Plans</h4>
        <p class="text-muted mb-0"><i data-lucide="info" style="width:14px;height:14px;" class="me-1"></i> Choose the plan that's right for you</p>
    </div>
    <a href="<%= request.getContextPath() %>/plans?action=list" class="btn btn-outline-primary shadow-sm"><i data-lucide="shield" class="me-1 w-4 h-4"></i> Admin View</a>
</div>

<div class="alert bg-primary bg-opacity-10 border border-primary text-primary mb-5 d-flex align-items-center">
    <i data-lucide="code" class="me-3 flex-shrink-0" style="width:24px;height:24px;"></i>
    <div>
        <strong>OOP Demonstration:</strong> Each card below calls <code>plan.calculateDiscountedPrice()</code>.
        For <code>ShortTermPlan</code> this returns the full price. For <code>LongTermPlan</code> it applies 10% off.
        Same method name, different result — this is <strong>POLYMORPHISM</strong>!
    </div>
</div>

<div class="row g-4 mb-5">
    <%
    List<MembershipPlan> plans = (List<MembershipPlan>) request.getAttribute("plans");
    if (plans != null && !plans.isEmpty()) {
        for (MembershipPlan plan : plans) {
            boolean isLongTerm = "LONG_TERM".equals(plan.getPlanType());
    %>
    <div class="col-md-4">
        <div class="card h-100 border-0 shadow-sm transition-all hover-transform position-relative overflow-hidden <%= isLongTerm ? "border border-warning border-2" : "" %>" style="border-radius: 16px;">
            <% if (isLongTerm) { %>
            <!-- Premium Badge for Long Term -->
            <div class="position-absolute" style="top: 15px; right: -30px; transform: rotate(45deg); background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; padding: 5px 40px; font-size: 12px; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.2); z-index: 10;">
                BEST VALUE
            </div>
            <% } %>

            <div class="card-header border-0 pt-4 pb-0 bg-white text-center">
                <div class="icon-wrapper mx-auto mb-3" style="<%= isLongTerm ? "background:#fef3c7;color:#d97706;" : "background:#e0e7ff;color:#4f46e5;" %>">
                    <i data-lucide="<%= isLongTerm ? "award" : "zap" %>" style="width:28px;height:28px;"></i>
                </div>
                <h5 class="fw-bold mb-1 text-dark"><%= plan.getPlanName() %></h5>
                <span class="badge <%= isLongTerm ? "bg-warning text-dark" : "bg-light text-muted border" %> rounded-pill px-3 py-2 mb-3">
                    <i data-lucide="<%= isLongTerm ? "star" : "clock" %>" class="me-1 d-inline" style="width:12px;height:12px;"></i>
                    <%= isLongTerm ? "LONG TERM" : "SHORT TERM" %>
                </span>
            </div>
            
            <div class="card-body px-4 text-center">
                <div class="mb-4">
                    <%-- calculateDiscountedPrice() — POLYMORPHISM in action --%>
                    <h2 class="fw-bold text-success mb-0 d-flex justify-content-center align-items-center">
                        <span class="fs-6 text-muted fw-normal me-1 align-self-start mt-2">LKR</span> 
                        <%= String.format("%.0f", plan.calculateDiscountedPrice()) %>
                    </h2>
                    
                    <% if (isLongTerm && plan.calculateDiscountedPrice() < plan.calculatePrice()) { %>
                    <div class="mt-2 d-flex justify-content-center align-items-center gap-2">
                        <p class="text-muted text-decoration-line-through mb-0 small">LKR <%= String.format("%.0f", plan.calculatePrice()) %></p>
                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">10% OFF</span>
                    </div>
                    <% } else { %>
                    <div class="mt-2" style="height:24px;"></div> <!-- Spacer -->
                    <% } %>
                    <p class="text-muted mt-2 mb-0 fw-medium bg-light d-inline-block px-3 py-1 rounded-pill"><i data-lucide="calendar" class="me-1 d-inline text-muted" style="width:14px;height:14px;"></i> <%= plan.getDurationMonths() %> month(s)</p>
                </div>

                <hr class="border-light-subtle mb-4">
                
                <div class="text-start mb-4">
                    <p class="fw-bold small text-uppercase text-muted mb-3"><i data-lucide="check-circle-2" class="me-1 d-inline" style="width:14px;height:14px;"></i> Features included</p>
                    <p class="text-dark small lh-lg mb-0"><%= plan.getFeatures().replace("\n", "<br>") %></p>
                </div>
                
                <div class="mt-auto pt-3 border-top border-light-subtle text-start">
                    <p class="small text-muted mb-0 d-flex align-items-center">
                        <i data-lucide="info" class="me-2 text-primary flex-shrink-0" style="width:16px;height:16px;"></i>
                        <em><%= plan.getDisplayInfo() %></em>
                    </p>
                </div>
            </div>
            
            <div class="card-footer bg-white border-0 p-4 pt-0 text-center">
                <a href="<%= request.getContextPath() %>/payment/addPayment.jsp"
                   class="btn <%= isLongTerm ? "btn-warning fw-bold" : "btn-outline-primary" %> w-100 py-2 rounded-3">
                    <i data-lucide="shopping-cart" class="me-2 w-4 h-4"></i> Join This Plan
                </a>
            </div>
        </div>
    </div>
    <%  } } else { %>
    <div class="col-12 text-center py-5">
        <i data-lucide="package-x" style="width:64px;height:64px;opacity:0.2" class="d-block mx-auto mb-3"></i>
        <h5 class="text-muted">No active plans available right now.</h5>
    </div>
    <% } %>
</div>

<style>
.hover-transform { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.hover-transform:hover { transform: translateY(-8px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04) !important; }
</style>

<jsp:include page="/includes/footer.jsp" />
