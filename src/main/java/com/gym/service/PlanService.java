package com.gym.service;

import com.gym.model.LongTermPlan;
import com.gym.model.MembershipPlan;
import com.gym.model.ShortTermPlan;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlanService {

    public List<MembershipPlan> getAllPlans() {
        List<MembershipPlan> plans = new ArrayList<>();
        String sql = "SELECT * FROM membership_plans";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                plans.add(mapResultSetToPlan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }

    public MembershipPlan getPlanById(int id) {
        String sql = "SELECT * FROM membership_plans WHERE plan_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPlan(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addPlan(MembershipPlan plan) {
        String sql = "INSERT INTO membership_plans (plan_name, duration_months, price, features, plan_type, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, plan.getPlanName());
            pstmt.setInt(2, plan.getDurationMonths());
            pstmt.setDouble(3, plan.getPrice());
            pstmt.setString(4, plan.getFeatures());
            pstmt.setString(5, plan.getPlanType());
            pstmt.setBoolean(6, plan.isActive());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePlan(MembershipPlan plan) {
        String sql = "UPDATE membership_plans SET plan_name=?, duration_months=?, price=?, features=?, plan_type=?, is_active=? WHERE plan_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, plan.getPlanName());
            pstmt.setInt(2, plan.getDurationMonths());
            pstmt.setDouble(3, plan.getPrice());
            pstmt.setString(4, plan.getFeatures());
            pstmt.setString(5, plan.getPlanType());
            pstmt.setBoolean(6, plan.isActive());
            pstmt.setInt(7, plan.getPlanId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePlan(int id) {
        String sql = "DELETE FROM membership_plans WHERE plan_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private MembershipPlan mapResultSetToPlan(ResultSet rs) throws SQLException {
        int id = rs.getInt("plan_id");
        String name = rs.getString("plan_name");
        int duration = rs.getInt("duration_months");
        double price = rs.getDouble("price");
        String features = rs.getString("features");
        String planType = rs.getString("plan_type");
        boolean active = rs.getBoolean("is_active");

        if ("LONG_TERM".equalsIgnoreCase(planType)) {
            return new LongTermPlan(id, name, duration, price, features, planType, active);
        } else {
            return new ShortTermPlan(id, name, duration, price, features, planType, active);
        }
    }
}
