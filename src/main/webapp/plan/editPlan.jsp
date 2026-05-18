<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.MembershipPlan" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    MembershipPlan plan = (MembershipPlan) request.getAttribute("plan");
    if (plan == null) { response.sendRedirect(request.getContextPath() + "/plans?action=list"); return; }
    request.setAttribute("pageTitle", "Edit Plan - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="row justify-content-center py-4">
    <div class="col-md-8 col-lg-6">
        <div class="card border-0 shadow-sm overflow-hidden">
            <div class="card-header border-0 py-4" style="background: linear-gradient(135deg, var(--bg-dark) 0%, #1e1b4b 100%); color:white;">
                <div class="d-flex align-items-center">
                    <div class="icon-wrapper me-3 mb-0" style="width:48px;height:48px;background:rgba(255,255,255,0.1);color:white;">
                        <i data-lucide="edit-3" style="width:24px;height:24px;"></i>
                    </div>
                    <div>
                        <h4 class="fw-bold mb-0">Edit Plan: <%= plan.getPlanName() %></h4>
                        <p class="mb-0 text-white-50 small">Update plan details and pricing</p>
                    </div>
                </div>
            </div>
            
            <div class="card-body p-4 p-md-5 bg-white">
                <form action="<%= request.getContextPath() %>/plans" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="planId" value="<%= plan.getPlanId() %>">

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Plan Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="tag" class="text-muted w-4 h-4"></i></span>
                            <input type="text" class="form-control border-start-0 ps-0 bg-light" name="planName" value="<%= plan.getPlanName() %>" required>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Duration (Months)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="calendar-clock" class="text-muted w-4 h-4"></i></span>
                                <input type="number" class="form-control border-start-0 ps-0 bg-light" name="durationMonths" value="<%= plan.getDurationMonths() %>" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Price (LKR)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="banknote" class="text-muted w-4 h-4"></i></span>
                                <input type="number" class="form-control border-start-0 ps-0 bg-light" name="price" value="<%= plan.getPrice() %>" step="0.01" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Plan Type</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="layers" class="text-muted w-4 h-4"></i></span>
                                <select class="form-select border-start-0 ps-0 bg-light" name="planType">
                                    <option value="SHORT_TERM" <%= "SHORT_TERM".equals(plan.getPlanType()) ? "selected" : "" %>>Short Term</option>
                                    <option value="LONG_TERM" <%= "LONG_TERM".equals(plan.getPlanType()) ? "selected" : "" %>>Long Term (10% off)</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Status</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="activity" class="text-muted w-4 h-4"></i></span>
                                <select class="form-select border-start-0 ps-0 bg-light" name="isActive">
                                    <option value="true" <%= plan.isActive() ? "selected" : "" %>>Active</option>
                                    <option value="false" <%= !plan.isActive() ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-5">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Features</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-2"><i data-lucide="list" class="text-muted w-4 h-4"></i></span>
                            <textarea class="form-control border-start-0 ps-0 bg-light" name="features" rows="3"><%= plan.getFeatures() %></textarea>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary py-2 fs-6 fw-bold"><i data-lucide="save" class="me-2 w-4 h-4 text-white"></i> Update Plan</button>
                        <a href="<%= request.getContextPath() %>/plans?action=list" class="btn btn-light text-secondary border py-2 fw-medium"><i data-lucide="x" class="me-1 w-4 h-4"></i> Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
