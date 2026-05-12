<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.MembershipPlan" %>
<% 
    MembershipPlan plan = (MembershipPlan) request.getAttribute("plan");
    request.setAttribute("pageTitle", "Edit Plan - GymPro");
%>
<jsp:include page="/includes/header.jsp" />
<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card auth-card border-0">
            <div class="card-body">
                <div class="mb-4">
                    <h2 class="fw-bold mb-1">Edit Membership Plan</h2>
                    <p class="text-muted small">Update the existing plan details</p>
                </div>
                <form action="<%= request.getContextPath() %>/plans" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="planId" value="<%= plan.getPlanId() %>">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-bold small">Plan Name</label>
                            <input type="text" name="planName" class="form-control bg-light" value="<%= plan.getPlanName() %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">Plan Type</label>
                            <select name="planType" class="form-select bg-light">
                                <option value="SHORT_TERM" <%= "SHORT_TERM".equals(plan.getPlanType()) ? "selected" : "" %>>Short Term (Full Price)</option>
                                <option value="LONG_TERM" <%= "LONG_TERM".equals(plan.getPlanType()) ? "selected" : "" %>>Long Term (10% Discount)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Duration (Months)</label>
                            <input type="number" name="durationMonths" class="form-control bg-light" value="<%= plan.getDurationMonths() %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Base Price (LKR)</label>
                            <input type="number" name="price" class="form-control bg-light" value="<%= plan.getPrice() %>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold small">Features (comma separated)</label>
                            <textarea name="features" class="form-control bg-light" rows="3"><%= plan.getFeatures() %></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox" name="isActive" <%= plan.isActive() ? "checked" : "" %>>
                                <label class="form-check-label small fw-bold">Active</label>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex gap-2 mt-4 pt-3 border-top">
                        <button type="submit" class="btn btn-primary px-4 fw-bold text-white">Update Plan</button>
                        <a href="plans?action=list" class="btn btn-light px-4 border">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />
