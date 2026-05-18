<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.model.Review, java.util.List" %>
<%
    // SESSION CHECK
    if (session.getAttribute("loggedMember") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    request.setAttribute("pageTitle", "Moderate Reviews - GymPro");
%>
<jsp:include page="/includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0 d-flex align-items-center"><i data-lucide="shield-check" class="me-2 text-primary"></i> Moderate Reviews <span class="badge bg-light text-muted border ms-2 fs-6 fw-normal">Admin</span></h4>
    <a href="<%= request.getContextPath() %>/reviews?action=view" class="btn btn-outline-info shadow-sm"><i data-lucide="eye" class="me-1 w-4 h-4"></i> Public View</a>
</div>

<div class="alert bg-primary bg-opacity-10 border border-primary text-primary mb-4 d-flex align-items-center">
    <i data-lucide="code" class="me-3 flex-shrink-0" style="width:24px;height:24px;"></i>
    <div>
        <strong>OOP Note:</strong> Remove button calls <code>review.remove()</code> from <code>IModerable</code> interface (sets status=REMOVED).
        Restore button calls <code>review.approve()</code> (sets status=ACTIVE).
        <code>getModerationStatus()</code> returns the current status. This is <strong>ABSTRACTION</strong>.
    </div>
</div>

<div class="card border-0 shadow-sm overflow-hidden mb-4">
    <div class="card-body p-0 table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Member</th>
                    <th>Rating</th>
                    <th>Category</th>
                    <th>Type</th>
                    <th>Comment</th>
                    <th>Status</th>
                    <th class="text-end pe-4">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% List<Review> reviews = (List<Review>) request.getAttribute("reviews");
                   if (reviews != null && !reviews.isEmpty()) { for (Review r : reviews) { 
                       boolean isRemoved = "REMOVED".equals(r.getStatus());
                       boolean isVerified = "VERIFIED".equals(r.getReviewType());
                %>
                <tr class="<%= isRemoved ? "bg-light text-muted" : "" %>">
                    <td><span class="badge bg-light text-dark border">#<%= r.getReviewId() %></span></td>
                    <td class="fw-semibold <%= isRemoved ? "text-muted" : "text-dark" %>"><i data-lucide="user" style="width:14px;height:14px;" class="me-1 text-muted"></i><%= r.getMemberName() %></td>
                    <td class="<%= isRemoved ? "text-muted" : "text-warning" %>">
                        <%-- Custom rendering to combine lucide icons and original star rating --%>
                        <div class="d-flex align-items-center">
                            <span style="letter-spacing:2px; font-size:16px;"><%= r.getRatingStars() %></span>
                        </div>
                    </td>
                    <td><span class="badge bg-light text-dark border"><%= r.getCategory() %></span></td>
                    <td>
                        <span class="badge <%= isVerified ? "bg-warning bg-opacity-10 text-warning border border-warning" : "bg-secondary bg-opacity-10 text-secondary border border-secondary" %>">
                            <i data-lucide="<%= isVerified ? "check-circle" : "message-square" %>" style="width:12px;height:12px;" class="me-1"></i><%= r.getDisplayBadge() %>
                        </span>
                    </td>
                    <td style="max-width:250px;">
                        <span class="d-inline-block text-truncate w-100 <%= isRemoved ? "text-decoration-line-through text-muted" : "" %>" title="<%= r.getComment() %>">
                            <%= r.getComment() %>
                        </span>
                    </td>
                    <td>
                        <span class="badge <%= "ACTIVE".equals(r.getModerationStatus()) ? "bg-success bg-opacity-10 text-success border border-success" : "bg-danger bg-opacity-10 text-danger border border-danger" %>">
                            <i data-lucide="<%= "ACTIVE".equals(r.getModerationStatus()) ? "check" : "x" %>" style="width:12px;height:12px;" class="me-1"></i><%= r.getModerationStatus() %>
                        </span>
                    </td>
                    <td class="text-end pe-4">
                        <% if ("ACTIVE".equals(r.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/reviews?action=delete&id=<%= r.getReviewId() %>"
                           class="btn btn-sm btn-outline-danger" title="Remove"
                           onclick="return confirm('Remove this review from public view?')"><i data-lucide="trash-2" style="width:16px;height:16px;"></i></a>
                        <% } else { %>
                        <a href="<%= request.getContextPath() %>/reviews?action=restore&id=<%= r.getReviewId() %>"
                           class="btn btn-sm btn-outline-success" title="Restore"><i data-lucide="refresh-cw" style="width:16px;height:16px;"></i></a>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="8" class="text-center text-muted py-5"><i data-lucide="shield-off" style="width:32px;height:32px;opacity:0.5" class="d-block mx-auto mb-2"></i>No reviews found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
