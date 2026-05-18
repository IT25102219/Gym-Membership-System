package com.gym.servlet;

import com.gym.model.*;
import com.gym.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {

    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "view";

        HttpSession session = request.getSession(false);
        Member loggedMember = (session != null) ? (Member) session.getAttribute("loggedMember") : null;

        switch (action) {
            case "view":
                String category = request.getParameter("category");
                List<Review> reviews;
                if (category != null && !category.isEmpty() && !category.equals("ALL")) {
                    reviews = reviewService.getReviewsByCategory(category);
                } else {
                    reviews = reviewService.getAllActiveReviews();
                }
                request.setAttribute("reviews", reviews);
                request.setAttribute("selectedCategory", category);
                request.getRequestDispatcher("/review/viewReviews.jsp").forward(request, response);
                break;

            case "mine":
                // Show the logged-in member's own reviews
                if (loggedMember != null) {
                    List<Review> myReviews = reviewService.getReviewsByMember(loggedMember.getMemberId());
                    request.setAttribute("reviews", myReviews);
                }
                request.getRequestDispatcher("/review/myReviews.jsp").forward(request, response);
                break;

            case "moderate":
                // Admin view: ALL reviews including removed ones
                List<Review> allReviews = reviewService.getAllReviews();
                request.setAttribute("reviews", allReviews);
                request.getRequestDispatcher("/review/moderateReviews.jsp").forward(request, response);
                break;

            case "delete":
                // Soft-delete: set status to REMOVED
                int deleteId = Integer.parseInt(request.getParameter("id"));
                reviewService.deleteReview(deleteId);
                request.getSession().setAttribute("successMessage", "Review removed.");
                response.sendRedirect(request.getContextPath() + "/reviews?action=moderate");
                break;

            case "restore":
                // Restore a removed review back to ACTIVE
                int restoreId = Integer.parseInt(request.getParameter("id"));
                reviewService.restoreReview(restoreId);
                request.getSession().setAttribute("successMessage", "Review restored.");
                response.sendRedirect(request.getContextPath() + "/reviews?action=moderate");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/reviews?action=view");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Member loggedMember = (session != null) ? (Member) session.getAttribute("loggedMember") : null;

        if ("submit".equals(action) && loggedMember != null) {
            int rating       = Integer.parseInt(request.getParameter("rating"));
            String comment   = request.getParameter("comment");
            String category  = request.getParameter("category");
            int memberId     = loggedMember.getMemberId();
            String memberName = loggedMember.getName();

            Review newReview;
            String role = loggedMember.getRole();

            if ("PREMIUM_MEMBER".equals(role)) {
                newReview = new VerifiedReview(0, memberId, memberName, rating,
                                               comment, category, null, "VERIFIED", "ACTIVE",
                                               loggedMember.getJoinDate());
            } else {
                newReview = new PublicReview(0, memberId, memberName, rating,
                                             comment, category, null, "PUBLIC", "ACTIVE");
            }

            boolean added = reviewService.addReview(newReview);
            request.getSession().setAttribute(added ? "successMessage" : "errorMessage",
                added ? "Review submitted successfully!" : "Failed to submit review.");
            response.sendRedirect(request.getContextPath() + "/reviews?action=mine");

        } else if ("edit".equals(action)) {
            int reviewId    = Integer.parseInt(request.getParameter("reviewId"));
            int rating      = Integer.parseInt(request.getParameter("rating"));
            String comment  = request.getParameter("comment");
            String category = request.getParameter("category");

            Review toUpdate = new PublicReview(reviewId,
                loggedMember != null ? loggedMember.getMemberId() : 0,
                loggedMember != null ? loggedMember.getName() : "",
                rating, comment, category, null, "PUBLIC", "ACTIVE");

            boolean updated = reviewService.updateReview(toUpdate);
            request.getSession().setAttribute(updated ? "successMessage" : "errorMessage",
                updated ? "Review updated." : "Update failed (Verified reviews cannot be edited).");
            response.sendRedirect(request.getContextPath() + "/reviews?action=mine");
        }
    }
}
