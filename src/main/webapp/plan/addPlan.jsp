<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Create Plan - GymPro"); %>
<jsp:include page="/includes/header.jsp" />
<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card auth-card border-0">
            <div class="card-body">
                <div class="mb-4">
                    <h2 class="fw-bold mb-1">Create New Plan</h2>
                    <p class="text-muted small">Fill in the details to add a new membership subscription</p>
                </div>
                <form action="<%= request.getContextPath() %>/plans" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-bold small">Plan Name</label>
                            <input type="text" name="planName" class="form-control bg-light" placeholder="e.g. Platinum Plus" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">Plan Type</label>
                            <select name="planType" class="form-select bg-light">
                                <option value="SHORT_TERM">Short Term (Full Price)</option>
                                <option value="LONG_TERM">Long Term (10% Discount)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Duration (Months)</label>
                            <input type="number" name="durationMonths" class="form-control bg-light" value="1" min="1" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Base Price (LKR)</label>
                            <input type="number" name="price" class="form-control bg-light" value="5000" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold small">Features (comma separated)</label>
                            <textarea name="features" class="form-control bg-light" rows="3" placeholder="Free Wifi, Personal Trainer, Sauna Access"></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox" name="isActive" checked>
                                <label class="form-check-label small fw-bold">Set as Active</label>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex gap-2 mt-4 pt-3 border-top">
                        <button type="submit" class="btn btn-primary px-4 fw-bold text-white">Save Plan</button>
                        <a href="plans?action=list" class="btn btn-light px-4 border">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />
