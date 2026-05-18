<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Review, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "Member Reviews - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="message-square" class="me-2 text-primary"></i> Member Reviews</h4>
    <div>
        <a href="<%= request.getContextPath() %>/reviews?action=mine" class="btn btn-outline-secondary me-2 shadow-sm"><i data-lucide="user" class="me-1 w-4 h-4"></i> My Reviews</a>
        <a href="<%= request.getContextPath() %>/review/submitReview.jsp" class="btn btn-warning shadow-sm fw-bold"><i data-lucide="star" class="me-1 w-4 h-4"></i> Write Review</a>
    </div>
</div>

<!-- Category filter -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body p-3">
        <div class="d-flex align-items-center">
            <span class="text-muted fw-semibold me-3"><i data-lucide="filter" style="width:16px;height:16px;" class="me-1"></i> Filter:</span>
            <div class="btn-group shadow-sm">
                <a href="<%= request.getContextPath() %>/reviews?action=view" class="btn btn-outline-secondary"><i data-lucide="list" style="width:14px;height:14px;" class="me-1"></i>All</a>
                <a href="<%= request.getContextPath() %>/reviews?action=view&category=GENERAL" class="btn btn-outline-info"><i data-lucide="message-circle" style="width:14px;height:14px;" class="me-1"></i>General</a>
                <a href="<%= request.getContextPath() %>/reviews?action=view&category=FACILITY" class="btn btn-outline-primary"><i data-lucide="dumbbell" style="width:14px;height:14px;" class="me-1"></i>Facility</a>
                <a href="<%= request.getContextPath() %>/reviews?action=view&category=TRAINER" class="btn btn-outline-success"><i data-lucide="users" style="width:14px;height:14px;" class="me-1"></i>Trainer</a>
            </div>
        </div>
    </div>
</div>

<div class="alert bg-primary bg-opacity-10 border border-primary text-primary mb-5 d-flex align-items-center">
    <i data-lucide="code" class="me-3 flex-shrink-0" style="width:24px;height:24px;"></i>
    <div>
        <strong>OOP Note:</strong>
        <code>review.getDisplayBadge()</code> returns "Member Review" or "Verified Member ✓" depending on type.
        <code>review.getRatingStars()</code> converts int to ★★★☆☆ format.
        Cards with gold borders are <code>VerifiedReview</code> objects.
    </div>
</div>

<div class="row g-4 mb-5">
    <% List<Review> reviews = (List<Review>) request.getAttribute("reviews");
       if (reviews != null && !reviews.isEmpty()) {
           for (Review r : reviews) {
               boolean isVerified = "VERIFIED".equals(r.getReviewType()); 
    %>
    <div class="col-md-6 col-lg-4">
        <div class="card h-100 border-0 shadow-sm transition-all hover-transform <%= isVerified ? "border border-warning border-2" : "" %>" style="border-radius: 12px;">
            <div class="card-header border-0 pt-3 pb-2 bg-transparent">
                <div class="d-flex justify-content-between align-items-start">
                    <%-- getDisplayBadge() — POLYMORPHISM --%>
                    <span class="badge <%= isVerified ? "bg-warning text-dark" : "bg-light text-muted border" %> rounded-pill px-2 py-1">
                        <i data-lucide="<%= isVerified ? "check-circle" : "message-square" %>" class="me-1 d-inline" style="width:10px;height:10px;"></i>
                        <%= r.getDisplayBadge() %>
                    </span>
                    <span class="badge bg-light text-primary border"><%= r.getCategory() %></span>
                </div>
            </div>
            
            <div class="card-body pt-2 pb-3">
                <%-- getRatingStars() --%>
                <div class="mb-3 d-flex align-items-center">
                    <span class="text-warning fs-5" style="letter-spacing: 2px;"><%= r.getRatingStars() %></span>
                </div>
                <p class="text-dark mb-0 fst-italic" style="line-height: 1.6;">"<%= r.getComment() %>"</p>
            </div>
            
            <div class="card-footer bg-light border-0 py-3 rounded-bottom d-flex align-items-center" style="border-radius: 0 0 12px 12px;">
                <div class="rounded-circle bg-primary bg-opacity-10 text-primary d-flex justify-content-center align-items-center me-2" style="width: 32px; height: 32px; font-size: 14px; font-weight:bold;">
                    <%= r.getMemberName().substring(0, 1).toUpperCase() %>
                </div>
                <div>
                    <p class="mb-0 small fw-bold text-dark"><%= r.getMemberName() %></p>
                    <p class="mb-0" style="font-size:0.7rem; color:var(--text-muted);"><i data-lucide="clock" class="d-inline" style="width:10px;height:10px;"></i> <%= r.getReviewDate() %></p>
                </div>
            </div>
        </div>
    </div>
    <% } } else { %>
    <div class="col-12 text-center py-5">
        <i data-lucide="message-square-dashed" style="width:64px;height:64px;opacity:0.2" class="d-block mx-auto mb-3"></i>
        <h5 class="text-muted">No reviews found. Be the first to leave a review!</h5>
        <a href="<%= request.getContextPath() %>/review/submitReview.jsp" class="btn btn-warning mt-3">Write a Review</a>
    </div>
    <% } %>
</div>

<style>
.hover-transform { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.hover-transform:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important; }
</style>

<jsp:include page="/includes/footer.jsp" />
