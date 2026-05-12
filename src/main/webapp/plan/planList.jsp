<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Plan List - GymPro"); %>
<jsp:include page="/includes/header.jsp" />
<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
    <div class="card-header bg-white p-4 border-bottom-0 d-flex justify-content-between align-items-center">
        <div>
            <h4 class="fw-bold mb-0">System Plans Registry</h4>
            <p class="text-muted small mb-0">Detailed view of all membership tiers</p>
        </div>
        <a href="plans?action=add" class="btn btn-primary btn-sm">Add New</a>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light">
                <tr>
                    <th class="ps-4 border-0 text-muted small text-uppercase">Plan ID</th>
                    <th class="border-0 text-muted small text-uppercase">Name</th>
                    <th class="border-0 text-muted small text-uppercase">Type</th>
                    <th class="border-0 text-muted small text-uppercase">Duration</th>
                    <th class="border-0 text-muted small text-uppercase">Base Price</th>
                    <th class="border-0 text-muted small text-uppercase">Final Price</th>
                    <th class="border-0 text-muted small text-uppercase text-end pe-4">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="plan" items="${plans}">
                    <tr>
                        <td class="ps-4">#${plan.planId}</td>
                        <td>
                            <div class="fw-bold">${plan.planName}</div>
                            <small class="text-muted">${plan.features}</small>
                        </td>
                        <td>
                            <span class="badge rounded-pill ${plan.planType == 'LONG_TERM' ? 'bg-success-subtle text-success' : 'bg-info-subtle text-info'}">
                                ${plan.planType}
                            </span>
                        </td>
                        <td>${plan.durationMonths} Mo</td>
                        <td>LKR ${plan.price}</td>
                        <td class="fw-bold text-primary">LKR ${plan.calculateDiscountedPrice()}</td>
                        <td class="text-end pe-4">
                            <div class="btn-group">
                                <a href="plans?action=edit&id=${plan.planId}" class="btn btn-sm btn-light border"><i data-lucide="edit-2" style="width:14px;height:14px;"></i></a>
                                <a href="plans?action=delete&id=${plan.planId}" class="btn btn-sm btn-light border text-danger" onclick="return confirm('Delete?')"><i data-lucide="trash" style="width:14px;height:14px;"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />
