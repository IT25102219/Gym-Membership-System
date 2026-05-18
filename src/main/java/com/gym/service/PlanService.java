
package com.gym.service;

import com.gym.model.*;
import com.gym.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class PlanService {

  
    public boolean addPlan(MembershipPlan plan) {
        String sql = "INSERT INTO membership_plans (plan_name, duration_months, price, " +
                     "features, plan_type, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, plan.getPlanName());
            stmt.setInt(2, plan.getDurationMonths());
            stmt.setDouble(3, plan.getPrice());
            stmt.setString(4, plan.getFeatures());
            stmt.setString(5, plan.getPlanType());
            stmt.setBoolean(6, plan.isActive());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding plan: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

   
    public MembershipPlan getPlanById(int id) {
        String sql = "SELECT * FROM membership_plans WHERE plan_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
               
                return mapResultSetToPlan(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Error fetching plan by ID: " + e.getMessage());
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    
    public List<MembershipPlan> getAllPlans() {
        String sql = "SELECT * FROM membership_plans ORDER BY created_at DESC";
        List<MembershipPlan> plans = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                
                plans.add(mapResultSetToPlan(rs));
            }
            return plans;

        } catch (SQLException e) {
            System.err.println("Error fetching all plans: " + e.getMessage());
            return plans;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // METHOD
    public List<MembershipPlan> getActivePlans() {

        String sql = "SELECT * FROM membership_plans WHERE is_active = TRUE ORDER BY price ASC";
        List<MembershipPlan> plans = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                plans.add(mapResultSetToPlan(rs));
            }
            return plans;

        } catch (SQLException e) {
            System.err.println("Error fetching active plans: " + e.getMessage());
            return plans;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    
    public boolean updatePlan(MembershipPlan plan) {
        String sql = "UPDATE membership_plans SET plan_name=?, duration_months=?, " +
                     "price=?, features=?, plan_type=?, is_active=? WHERE plan_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, plan.getPlanName());
            stmt.setInt(2, plan.getDurationMonths());
            stmt.setDouble(3, plan.getPrice());
            stmt.setString(4, plan.getFeatures());
            stmt.setString(5, plan.getPlanType());
            stmt.setBoolean(6, plan.isActive());
            stmt.setInt(7, plan.getPlanId());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating plan: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

   
    public boolean deletePlan(int id) {
     
        String sql = "UPDATE membership_plans SET is_active = FALSE WHERE plan_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting plan: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

   
    private MembershipPlan mapResultSetToPlan(ResultSet rs) throws SQLException {
        int id            = rs.getInt("plan_id");
        String name       = rs.getString("plan_name");
        int duration      = rs.getInt("duration_months");
        double price      = rs.getDouble("price");
        String features   = rs.getString("features");
        String planType   = rs.getString("plan_type");
        boolean isActive  = rs.getBoolean("is_active");

       
        if ("LONG_TERM".equalsIgnoreCase(planType)) {
          
            return new LongTermPlan(id, name, duration, price, features, planType, isActive);
        } else {
          
            return new ShortTermPlan(id, name, duration, price, features, planType, isActive);
        }
    }
}
