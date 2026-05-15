/*
 * FILE      : PaymentService.java
 * PACKAGE   : com.gym.service
 * PURPOSE   : Handles all database operations for payments.
 *             When reading, creates CashPayment or OnlinePayment based on method column.
 *             Demonstrates POLYMORPHISM in the service layer.
 * LAYER     : Business Logic Layer
 * CALLS     : DBConnection.getConnection()
 * CALLED BY : PaymentServlet.java
 */
package com.gym.service;

import com.gym.model.CashPayment;
import com.gym.model.OnlinePayment;
import com.gym.model.Payment;
import com.gym.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class PaymentService {
    public boolean recordPayment(Payment payment) {

        payment.processPayment();

        String sql = "INSERT INTO payments (member_id, plan_id, amount, payment_date, " +
                     "method, status) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, payment.getMemberId());
            stmt.setInt(2, payment.getPlanId());
            stmt.setDouble(3, payment.getAmount());
            stmt.setString(4, payment.getPaymentDate());
            stmt.setString(5, payment.getMethod());
            stmt.setString(6, payment.getStatus()); // set by processPayment() above
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error recording payment: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Payment> getPaymentsByMember(int memberId) {
        String sql = "SELECT p.*, mp.plan_name FROM payments p " +
                     "JOIN membership_plans mp ON p.plan_id = mp.plan_id " +
                     "WHERE p.member_id = ? ORDER BY p.payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs)); // Polymorphism per row
            }
            return payments;

        } catch (SQLException e) {
            System.err.println("Error fetching payments by member: " + e.getMessage());
            return payments;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Payment> getAllPayments() {
        String sql = "SELECT p.*, m.name as member_name, mp.plan_name " +
                     "FROM payments p " +
                     "JOIN members m ON p.member_id = m.member_id " +
                     "JOIN membership_plans mp ON p.plan_id = mp.plan_id " +
                     "ORDER BY p.payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Payment pay = mapResultSetToPayment(rs);
                payments.add(pay);
            }
            return payments;

        } catch (SQLException e) {
            System.err.println("Error fetching all payments: " + e.getMessage());
            return payments;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Payment> getPaymentsByStatus(String status) {
        String sql = "SELECT p.*, m.name as member_name, mp.plan_name " +
                     "FROM payments p " +
                     "JOIN members m ON p.member_id = m.member_id " +
                     "JOIN membership_plans mp ON p.plan_id = mp.plan_id " +
                     "WHERE p.status = ? ORDER BY p.payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status); // "PAID", "PENDING", or "OVERDUE"
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
            return payments;

        } catch (SQLException e) {
            System.err.println("Error fetching payments by status: " + e.getMessage());
            return payments;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean updatePaymentStatus(int id, String status) {
        String sql = "UPDATE payments SET status = ? WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status); // new status value
            stmt.setInt(2, id);        // which payment to update
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean deletePayment(int id) {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting payment: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        int id           = rs.getInt("payment_id");
        int memberId     = rs.getInt("member_id");
        int planId       = rs.getInt("plan_id");
        double amount    = rs.getDouble("amount");
        String date      = rs.getString("payment_date");
        String method    = rs.getString("method");
        String status    = rs.getString("status");


        if ("ONLINE".equalsIgnoreCase(method) || "CARD".equalsIgnoreCase(method)) {

            return new OnlinePayment(id, memberId, planId, amount, date, method, status);
        } else {

            return new CashPayment(id, memberId, planId, amount, date, method, status);
        }
    }
}
