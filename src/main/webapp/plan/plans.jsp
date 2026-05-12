<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Membership Plans - GymPro"); %>
<jsp:include page="/includes/header.jsp" />
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold mb-1">Membership Plans</h2>
        <p class="text-muted small mb-0">View and manage all available gym subscription plans</p>
    </div>
    <a href="plans?action=add" class="btn btn-primary d-flex align-items-center">
        <i data-lucide="plus" class="me-2" style="width:18px;height:18px;"></i> Create New Plan
    </a>
</div>
<div class="row g-4">
    <c:forEach var="plan" items="${plans}">
        <div class="col-lg-4 col-md-6">
            <div class="card dash-card h-100 border-0">
                <div class="card-body p-4 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="icon-wrapper ms-0" style="background: ${plan.planType == 'LONG_TERM' ? '#dcfce7' : '#e0f2fe'}; color: ${plan.planType == 'LONG_TERM' ? '#16a34a' : '#0284c7'};">
                            <i data-lucide="${plan.planType == 'LONG_TERM' ? 'award' : 'zap'}" style="width:24px;height:24px;"></i>
                        </div>
                        <span class="badge rounded-pill ${plan.active ? 'bg-success' : 'bg-secondary'} px-3 py-2">
                            ${plan.active ? 'Active' : 'Inactive'}
                        </span>
                    </div>
                    <h4 class="fw-bold mb-1">${plan.planName}</h4>
                    <p class="text-muted small mb-3">${plan.durationMonths} Month(s) Duration</p>
                    <div class="bg-light rounded-3 p-3 mb-4">
                        <h3 class="fw-bold text-primary mb-0">LKR ${String.format("%.0f", plan.calculateDiscountedPrice())}</h3>
                        <c:if test="${plan.planType == 'LONG_TERM'}">
                            <small class="text-muted text-decoration-line-through">LKR ${String.format("%.0f", plan.price)}</small>
                            <span class="badge bg-danger-subtle text-danger ms-1">10% OFF</span>
                        </c:if>
                    </div>
                    <div class="mb-4 flex-grow-1">
                        <h6 class="fw-bold small text-uppercase text-muted mb-2">Features</h6>
                        <ul class="list-unstyled mb-0">
                            <c:forEach var="feature" items="${plan.features.split(',')}">
                                <li class="small mb-2 d-flex align-items-center">
                                    <i data-lucide="check-circle-2" class="text-success me-2" style="width:14px;height:14px;"></i>
                                    ${feature.trim()}
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <div class="d-flex gap-2 mt-auto pt-3 border-top">
                        <a href="plans?action=edit&id=${plan.planId}" class="btn btn-light flex-grow-1 border">
                            <i data-lucide="edit-3" style="width:16px;height:16px;" class="me-1"></i> Edit
                        </a>
                        <a href="plans?action=delete&id=${plan.planId}" class="btn btn-outline-danger" onclick="return confirm('Delete this plan?')">
                            <i data-lucide="trash-2" style="width:16px;height:16px;"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<jsp:include page="/includes/footer.jsp" />
