<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Review, java.util.List" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "My Reviews - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="star" class="me-2 text-warning fill-warning"></i> My Reviews</h4>
    <a href="<%= request.getContextPath() %>/review/submitReview.jsp" class="btn btn-warning shadow-sm fw-bold"><i data-lucide="plus" class="me-1 w-4 h-4"></i> New Review</a>
</div>

<div class="alert bg-primary bg-opacity-10 border border-primary text-primary mb-4 d-flex align-items-center">
    <i data-lucide="code" class="me-3 flex-shrink-0" style="width:24px;height:24px;"></i>
    <div>
        <strong>OOP Note:</strong> <code>review.canEdit()</code> returns <code>true</code> for PublicReview (Edit button shown)
        and <code>false</code> for VerifiedReview (Edit button hidden — locked for integrity).
        This is <strong>POLYMORPHISM</strong>: same method, different result per subclass.
    </div>
</div>

<div class="row g-4 mb-5">
    <% List<Review> reviews = (List<Review>) request.getAttribute("reviews");
       if (reviews != null && !reviews.isEmpty()) {
           for (Review r : reviews) {
               boolean isVerified = "VERIFIED".equals(r.getReviewType()); 
               boolean isRemoved = "REMOVED".equals(r.getStatus());
    %>
    <div class="col-md-6 col-lg-4">
        <div class="card h-100 border-0 shadow-sm transition-all hover-transform <%= isVerified ? "border border-warning border-2" : "" %>" style="border-radius: 12px; <%= isRemoved ? "opacity:0.7;" : "" %>">
            <div class="card-header border-0 pt-3 pb-2 bg-transparent">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="badge <%= isVerified ? "bg-warning text-dark" : "bg-light text-muted border" %> rounded-pill">
                        <i data-lucide="<%= isVerified ? "check-circle" : "message-square" %>" class="me-1 d-inline" style="width:12px;height:12px;"></i>
                        <%= r.getDisplayBadge() %>
                    </span>
                    <span class="badge bg-light text-primary border"><%= r.getCategory() %></span>
                </div>
            </div>
            
            <div class="card-body pt-2 pb-3">
                <div class="mb-3 d-flex align-items-center gap-2">
                    <span class="text-warning fs-5" style="letter-spacing: 2px;"><%= r.getRatingStars() %></span>
                    <span class="text-muted small">(<%= r.getRating() %>/5)</span>
                </div>
                <p class="text-dark mb-0 <%= isRemoved ? "text-decoration-line-through text-muted" : "" %>"><%= r.getComment() %></p>
            </div>
            
            <div class="card-footer bg-light border-0 py-3 rounded-bottom" style="border-radius: 0 0 12px 12px;">
                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted d-flex align-items-center"><i data-lucide="clock" class="me-1 w-4 h-4"></i> <%= r.getReviewDate() %></small>
                    
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge <%= isRemoved ? "bg-danger bg-opacity-10 text-danger border border-danger" : "bg-success bg-opacity-10 text-success border border-success" %>" style="font-size:10px;">
                            <%= r.getStatus() %>
                        </span>
                        
                        <% if (r.canEdit() && !isRemoved) { %>
                        <button class="btn btn-sm btn-outline-primary py-0 px-2" data-bs-toggle="modal"
                                data-bs-target="#editModal<%= r.getReviewId() %>" title="Edit">
                            <i data-lucide="edit-2" style="width:14px;height:14px;"></i>
                        </button>
                        <% } else if (!r.canEdit()) { %>
                        <span class="text-muted" title="Verified reviews locked"><i data-lucide="lock" style="width:14px;height:14px;"></i></span>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <% if (r.canEdit() && !isRemoved) { %>
        <div class="modal fade" id="editModal<%= r.getReviewId() %>" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
                    <div class="modal-header border-0 py-3" style="background: var(--bg-dark); color:white; border-radius: 16px 16px 0 0;">
                        <h5 class="modal-title fw-bold d-flex align-items-center"><i data-lucide="edit" class="me-2"></i> Edit Review</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="<%= request.getContextPath() %>/reviews" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="reviewId" value="<%= r.getReviewId() %>">
                        <div class="modal-body p-4 bg-light">
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted small text-uppercase">Rating</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0"><i data-lucide="star" class="text-warning fill-warning w-4 h-4"></i></span>
                                    <select class="form-select border-start-0 ps-0 bg-white" name="rating">
                                        <% for (int i=5;i>=1;i--) { %><option value="<%= i %>" <%= r.getRating()==i ? "selected" : "" %>><%= i %> Stars</option><% } %>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted small text-uppercase">Category</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0"><i data-lucide="tag" class="text-muted w-4 h-4"></i></span>
                                    <select class="form-select border-start-0 ps-0 bg-white" name="category">
                                        <option value="GENERAL" <%= "GENERAL".equals(r.getCategory()) ? "selected" : "" %>>General</option>
                                        <option value="FACILITY" <%= "FACILITY".equals(r.getCategory()) ? "selected" : "" %>>Facility</option>
                                        <option value="TRAINER" <%= "TRAINER".equals(r.getCategory()) ? "selected" : "" %>>Trainer</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-semibold text-muted small text-uppercase">Comment</label>
                                <textarea class="form-control" name="comment" rows="4"><%= r.getComment() %></textarea>
                            </div>
                        </div>
                        <div class="modal-footer border-0 bg-light pb-4 pe-4">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } } else { %>
    <div class="col-12 text-center py-5">
        <i data-lucide="message-square-dashed" style="width:64px;height:64px;opacity:0.2" class="d-block mx-auto mb-3"></i>
        <h5 class="text-muted">You haven't submitted any reviews yet.</h5>
        <a href="<%= request.getContextPath() %>/review/submitReview.jsp" class="btn btn-warning mt-3">Write a Review</a>
    </div>
    <% } %>
</div>

<style>
.hover-transform { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.hover-transform:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important; }
</style>

<jsp:include page="/includes/footer.jsp" />
