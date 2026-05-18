<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "Add Plan - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="row justify-content-center py-4">
    <div class="col-md-8 col-lg-6">
        <div class="card border-0 shadow-sm overflow-hidden">
            <div class="card-header border-0 py-4 text-center" style="background: linear-gradient(135deg, var(--bg-dark) 0%, #1e1b4b 100%); color:white;">
                <div class="icon-wrapper mx-auto mb-3" style="width:56px;height:56px;background:rgba(255,255,255,0.1);color:white;">
                    <i data-lucide="plus-circle" style="width:28px;height:28px;"></i>
                </div>
                <h4 class="fw-bold mb-1">Add New Membership Plan</h4>
                <p class="mb-0 text-white-50 small"><i data-lucide="info" class="me-1 d-inline" style="width:14px;height:14px;"></i> Create a new pricing tier</p>
            </div>
            
            <div class="card-body p-4 p-md-5 bg-white">
                <form action="<%= request.getContextPath() %>/plans" method="post">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Plan Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="tag" class="text-muted w-4 h-4"></i></span>
                            <input type="text" class="form-control border-start-0 ps-0 bg-light" name="planName" placeholder="e.g. Monthly Basic" required>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Duration (Months) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="calendar-clock" class="text-muted w-4 h-4"></i></span>
                                <input type="number" class="form-control border-start-0 ps-0 bg-light" name="durationMonths" min="1" max="24" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Base Price (LKR) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i data-lucide="banknote" class="text-muted w-4 h-4"></i></span>
                                <input type="number" class="form-control border-start-0 ps-0 bg-light" name="price" min="0" step="0.01" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Plan Type <span class="text-danger">*</span></label>
                        <div class="input-group mb-2">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="layers" class="text-muted w-4 h-4"></i></span>
                            <select class="form-select border-start-0 ps-0 bg-light" name="planType">
                                <option value="SHORT_TERM">Short Term (no discount)</option>
                                <option value="LONG_TERM">Long Term (10% discount)</option>
                            </select>
                        </div>
                        <small class="text-muted"><i data-lucide="zap" class="text-warning d-inline me-1" style="width:14px;height:14px;"></i> Long Term plans automatically get a 10% discount</small>
                    </div>
                    
                    <div class="mb-5">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Features / Description</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-2"><i data-lucide="list" class="text-muted w-4 h-4"></i></span>
                            <textarea class="form-control border-start-0 ps-0 bg-light" name="features" rows="3" placeholder="e.g. Gym access, locker room, group classes"></textarea>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary py-2 fs-6 fw-bold"><i data-lucide="plus" class="me-2 w-4 h-4 text-white"></i> Add Plan</button>
                        <a href="<%= request.getContextPath() %>/plans?action=list" class="btn btn-light text-secondary border py-2 fw-medium"><i data-lucide="x" class="me-1 w-4 h-4"></i> Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
