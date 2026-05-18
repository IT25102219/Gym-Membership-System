<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.MembershipPlan, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    com.gym.model.Member loggedMember = (com.gym.model.Member) session.getAttribute("loggedMember");
    request.setAttribute("pageTitle", "Plan Admin - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="clipboard-list" class="me-2 text-primary"></i> Membership Plans <span class="badge bg-light text-muted border ms-2 fs-6 fw-normal">Admin View</span></h4>
    <div>
        <a href="<%= request.getContextPath() %>/plans?action=active" class="btn btn-outline-info me-2 shadow-sm"><i data-lucide="eye" class="me-1 w-4 h-4"></i> Public View</a>
        <a href="<%= request.getContextPath() %>/plan/addPlan.jsp" class="btn btn-primary shadow-sm"><i data-lucide="plus" class="me-1 w-4 h-4 text-white"></i> Add Plan</a>
    </div>
</div>

<div class="card border-0 shadow-sm overflow-hidden mb-4">
    <div class="card-body p-0 table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Plan Name</th>
                    <th>Type</th>
                    <th>Duration</th>
                    <th>Base Price</th>
                    <th>Discounted Price</th>
                    <th>Status</th>
                    <th class="text-end pe-4">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% List<MembershipPlan> plans = (List<MembershipPlan>) request.getAttribute("plans");
                   if (plans != null && !plans.isEmpty()) { for (MembershipPlan p : plans) { %>
                <tr>
                    <td><span class="badge bg-light text-dark border">#<%= p.getPlanId() %></span></td>
                    <td class="fw-semibold text-dark"><i data-lucide="tag" style="width:14px;height:14px;" class="me-1 text-muted"></i><%= p.getPlanName() %></td>
                    <td>
                        <span class="badge <%= "LONG_TERM".equals(p.getPlanType()) ? "bg-warning bg-opacity-10 text-warning border border-warning" : "bg-info bg-opacity-10 text-info border border-info" %>">
                            <i data-lucide="<%= "LONG_TERM".equals(p.getPlanType()) ? "star" : "zap" %>" style="width:12px;height:12px;" class="me-1"></i><%= p.getPlanType() %>
                        </span>
                    </td>
                    <td><i data-lucide="calendar" style="width:14px;height:14px;" class="me-1 text-muted"></i><%= p.getDurationMonths() %> mo</td>
                    <td><span class="text-muted">LKR <%= String.format("%.2f", p.calculatePrice()) %></span></td>
                    <td class="text-success fw-bold">LKR <%= String.format("%.2f", p.calculateDiscountedPrice()) %>
                        <% if ("LONG_TERM".equals(p.getPlanType())) { %><span class="badge bg-danger bg-opacity-10 text-danger border border-danger ms-1" style="font-size:10px;">10% OFF</span><% } %>
                    </td>
                    <td>
                        <span class="badge <%= p.isActive() ? "bg-success bg-opacity-10 text-success border border-success" : "bg-secondary bg-opacity-10 text-secondary border border-secondary" %>">
                            <i data-lucide="<%= p.isActive() ? "check-circle" : "minus-circle" %>" style="width:12px;height:12px;" class="me-1"></i><%= p.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </td>
                    <td class="text-end pe-4">
                        <div class="btn-group">
                            <a href="<%= request.getContextPath() %>/plans?action=edit&id=<%= p.getPlanId() %>" class="btn btn-sm btn-outline-primary" title="Edit"><i data-lucide="edit-2" style="width:16px;height:16px;"></i></a>
                            <a href="<%= request.getContextPath() %>/plans?action=delete&id=<%= p.getPlanId() %>"
                               class="btn btn-sm btn-outline-danger" title="Deactivate"
                               onclick="return confirm('Deactivate this plan?')"><i data-lucide="power" style="width:16px;height:16px;"></i></a>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="8" class="text-center text-muted py-5"><i data-lucide="layers" style="width:32px;height:32px;opacity:0.5" class="d-block mx-auto mb-2"></i>No plans found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="alert bg-primary bg-opacity-10 border border-primary text-primary mt-3 d-flex align-items-center">
    <i data-lucide="info" class="me-2 flex-shrink-0"></i>
    <div>
        <strong>OOP Note:</strong> "Discounted Price" calls <code>plan.calculateDiscountedPrice()</code>.
        ShortTermPlan returns full price; LongTermPlan returns price * 0.90. Same method, different result = <strong>POLYMORPHISM</strong>.
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
