package com.gym.service;

import com.gym.model.*;
import com.gym.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewService {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (member_id, rating, comment, category, " +
                     "review_date, review_type, status) VALUES (?, ?, ?, ?, NOW(), ?, 'ACTIVE')";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, review.getMemberId());
            stmt.setInt(2, review.getRating());
            stmt.setString(3, review.getComment());
            stmt.setString(4, review.getCategory());
            stmt.setString(5, review.getReviewType()); // "PUBLIC" or "VERIFIED"
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding review: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Review> getAllActiveReviews() {
        String sql = "SELECT r.*, m.name as member_name FROM reviews r " +
                     "JOIN members m ON r.member_id = m.member_id " +
                     "WHERE r.status = 'ACTIVE' ORDER BY r.review_date DESC";
        return executeReviewQuery(sql, null);
    }

    public List<Review> getAllReviews() {
        String sql = "SELECT r.*, m.name as member_name FROM reviews r " +
                     "JOIN members m ON r.member_id = m.member_id " +
                     "ORDER BY r.review_date DESC";
        return executeReviewQuery(sql, null);
    }

    public List<Review> getReviewsByCategory(String category) {
        String sql = "SELECT r.*, m.name as member_name FROM reviews r " +
                     "JOIN members m ON r.member_id = m.member_id " +
                     "WHERE r.status='ACTIVE' AND r.category=? ORDER BY r.review_date DESC";
        return executeReviewQuery(sql, category);
    }

    public List<Review> getReviewsByMember(int memberId) {
        String sql = "SELECT r.*, m.name as member_name FROM reviews r " +
                     "JOIN members m ON r.member_id = m.member_id " +
                     "WHERE r.member_id=? ORDER BY r.review_date DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
            return reviews;

        } catch (SQLException e) {
            System.err.println("Error fetching reviews by member: " + e.getMessage());
            return reviews;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean updateReview(Review review) {
        if (!review.canEdit()) {
            System.out.println("Edit denied: this review type cannot be edited.");
            return false;
        }

        String sql = "UPDATE reviews SET rating=?, comment=?, category=? WHERE review_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setString(3, review.getCategory());
            stmt.setInt(4, review.getReviewId());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating review: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean deleteReview(int id) {
        String sql = "UPDATE reviews SET status='REMOVED' WHERE review_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // METHOD : restoreReview
    // DOES   : Restores a REMOVED review back to ACTIVE status.
    //          Calls the approve() method from IModerable interface.
    // CALLED : ReviewServlet when admin clicks "Restore" on moderateReviews.jsp
    public boolean restoreReview(int id) {
        String sql = "UPDATE reviews SET status='ACTIVE' WHERE review_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error restoring review: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // METHOD : executeReviewQuery
    // DOES   : Helper method to execute review queries with optional parameter.
    //          Used by getAllActiveReviews() and getReviewsByCategory().
    private List<Review> executeReviewQuery(String sql, String param) {
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            if (param != null) {
                stmt.setString(1, param); // for category-filtered queries
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs)); // Polymorphism per row
            }
            return reviews;

        } catch (SQLException e) {
            System.err.println("Error executing review query: " + e.getMessage());
            return reviews;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // METHOD : mapResultSetToReview
    // DOES   : Converts a ResultSet row into the correct Review subclass.
    //          review_type='VERIFIED' → VerifiedReview (locked, gold badge)
    //          review_type='PUBLIC'   → PublicReview   (editable, plain badge)
    //          POLYMORPHISM decision — same data, different object type.
    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        int id           = rs.getInt("review_id");
        int memberId     = rs.getInt("member_id");
        String memberName = rs.getString("member_name");
        int rating       = rs.getInt("rating");
        String comment   = rs.getString("comment");
        String category  = rs.getString("category");
        String date      = rs.getString("review_date");
        String type      = rs.getString("review_type");
        String status    = rs.getString("status");

        // POLYMORPHISM: decide which subclass to create based on review_type
        if ("VERIFIED".equalsIgnoreCase(type)) {
            // VerifiedReview: locked editing, gold badge, verified checkmark
            return new VerifiedReview(id, memberId, memberName, rating,
                                      comment, category, date, type, status);
        } else {
            // PublicReview: editable, plain "Member Review" badge
            return new PublicReview(id, memberId, memberName, rating,
                                    comment, category, date, type, status);
        }
    }
}
