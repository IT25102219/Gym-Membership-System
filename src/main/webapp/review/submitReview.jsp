<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Member" %>
<%
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    boolean isPremium = "PREMIUM_MEMBER".equals(loggedMember.getRole());
    request.setAttribute("pageTitle", "Submit Review - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<style>
    /* Custom Modern Star Rating */
    .star-rating { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 8px; }
    .star-rating input { display: none; }
    .star-rating label { font-size: 2.5rem; cursor: pointer; color: #e2e8f0; transition: color 0.2s, transform 0.2s; line-height: 1; }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label { color: #eab308; }
    .star-rating label:hover { transform: scale(1.1); }
</style>

<div class="row justify-content-center py-4">
    <div class="col-md-8 col-lg-6">
        <div class="card border-0 shadow-sm overflow-hidden" style="border-radius: 16px;">
            <div class="card-header border-0 py-4 text-center position-relative" style="background: linear-gradient(135deg, var(--bg-dark) 0%, #1e1b4b 100%); color:white;">
                <div class="icon-wrapper mx-auto mb-3 shadow" style="width:64px;height:64px;background:rgba(255,255,255,0.1);color:#fbbf24;">
                    <i data-lucide="star" class="fill-warning" style="width:32px;height:32px;"></i>
                </div>
                <h4 class="fw-bold mb-2">Submit a Review</h4>
                
                <% if (isPremium) { %>
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill shadow-sm"><i data-lucide="check-circle" class="me-1 d-inline" style="width:14px;height:14px;"></i> Verified Review</span>
                <% } else { %>
                <p class="mb-0 text-white-50 small">Share your experience with us.</p>
                <% } %>
            </div>
            
            <div class="card-body p-4 p-md-5 bg-white">
                <form action="<%= request.getContextPath() %>/reviews" method="post">
                    <input type="hidden" name="action" value="submit">

                    <div class="mb-4 text-center bg-light p-4 rounded-4 border">
                        <label class="form-label fw-bold text-muted text-uppercase mb-3 d-block">How was your experience?</label>
                        <div class="star-rating mx-auto d-inline-flex">
                            <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
                            <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
                            <input type="radio" id="star3" name="rating" value="3" checked><label for="star3">★</label>
                            <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
                            <input type="radio" id="star1" name="rating" value="1"><label for="star1">★</label>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Category <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i data-lucide="tag" class="text-muted w-4 h-4"></i></span>
                            <select class="form-select border-start-0 ps-0 bg-light py-2" name="category">
                                <option value="GENERAL">General Feedback</option>
                                <option value="FACILITY">Gym Facility & Equipment</option>
                                <option value="TRAINER">Trainer & Classes</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Your Review <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-3"><i data-lucide="message-square" class="text-muted w-4 h-4"></i></span>
                            <textarea class="form-control border-start-0 ps-0 bg-light py-2" name="comment" rows="5"
                                      placeholder="Tell us what you loved or what we can improve..." required></textarea>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-warning py-3 fs-5 fw-bold text-dark shadow-sm">
                            <i data-lucide="send" class="me-2 w-4 h-4"></i> <%= isPremium ? "Submit Verified Review" : "Submit Public Review" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/reviews?action=view" class="btn btn-light text-secondary border py-2 fw-medium mt-2">Cancel</a>
                    </div>
                </form>

                <div class="alert bg-primary bg-opacity-10 border border-primary text-primary mt-4 mb-0 d-flex align-items-start">
                    <i data-lucide="info" class="me-2 mt-1 flex-shrink-0" style="width:16px;height:16px;"></i>
                    <small>
                        <strong>OOP Note:</strong> Since you are a <strong><%= loggedMember.getRole().replace("_"," ") %></strong>,
                        ReviewServlet will create a <strong><%= isPremium ? "VerifiedReview" : "PublicReview" %></strong> object.
                        Same submit action, different Java object type — <strong>POLYMORPHISM</strong>!
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
