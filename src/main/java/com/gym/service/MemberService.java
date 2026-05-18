package com.gym.service;




import com.gym.model.*;
import com.gym.util.DBConnection;
import com.gym.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class MemberService {


    public boolean registerMember(Member member) {

        if (emailExists(member.getEmail())) {
            return false; // email taken — registration fails
        }


        String sql = "INSERT INTO members (name, email, phone, dob, gender, " +
                "membership_type, join_date, status, password_hash) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";


        Connection conn = null;
        try {
            conn = DBConnection.getConnection(); // get a live DB connection
            // prepareStatement compiles the SQL on the DB server — faster and safer
            PreparedStatement stmt = conn.prepareStatement(sql);

            // Set each ? placeholder with the actual data from the Member object
            stmt.setString(1, member.getName());
            stmt.setString(2, member.getEmail());
            stmt.setString(3, member.getPhone());
            stmt.setString(4, member.getDob());
            stmt.setString(5, member.getGender());
            stmt.setString(6, member.getMembershipType());
            stmt.setString(7, member.getJoinDate());
            stmt.setString(8, "ACTIVE"); // new members always start as ACTIVE


            stmt.setString(9, PasswordUtil.hashPassword(member.getPasswordHash()));


            int rowsAffected = stmt.executeUpdate();


            return rowsAffected > 0;

        } catch (SQLException e) {
            // Print the error details for debugging
            System.err.println("Error registering member: " + e.getMessage());
            return false; // registration failed

        } finally {

            DBConnection.closeConnection(conn);
        }
    }


    public Member getMemberById(int id) {
        String sql = "SELECT * FROM members WHERE member_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id); // set the member_id to search for


            ResultSet rs = stmt.executeQuery();

            // moveToFirst row (or check if any row exists)
            if (rs.next()) {

                return mapResultSetToMember(rs);
            }
            // No row found — member doesn't exist
            return null;

        } catch (SQLException e) {
            System.err.println("Error fetching member by ID: " + e.getMessage());
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Member> getAllMembers() {
        String sql = "SELECT * FROM members ORDER BY created_at DESC";
        List<Member> members = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();


            while (rs.next()) {

                members.add(mapResultSetToMember(rs));
            }
            return members;

        } catch (SQLException e) {
            System.err.println("Error fetching all members: " + e.getMessage());
            return members;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Member> searchMembers(String query) {

        String sql = "SELECT * FROM members WHERE name LIKE ? OR email LIKE ?";
        List<Member> members = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);

            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern); // for name search
            stmt.setString(2, searchPattern); // for email search
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                members.add(mapResultSetToMember(rs));
            }
            return members;

        } catch (SQLException e) {
            System.err.println("Error searching members: " + e.getMessage());
            return members;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean updateMember(Member member) {
        String sql = "UPDATE members SET name=?, phone=?, membership_type=?, " +
                "status=? WHERE member_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, member.getName());
            stmt.setString(2, member.getPhone());
            stmt.setString(3, member.getMembershipType());
            stmt.setString(4, member.getStatus());
            stmt.setInt(5, member.getMemberId());

            return stmt.executeUpdate() > 0; // true if at least one row was updated

        } catch (SQLException e) {
            System.err.println("Error updating member: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean deleteMember(int id) {
        // Soft delete: mark as INACTIVE rather than removing the row
        String sql = "UPDATE members SET status='INACTIVE' WHERE member_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting member: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public Member login(String email, String password) {
        String sql = "SELECT * FROM members WHERE email=? AND status='ACTIVE'";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email); // match exact email

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                String storedHash = rs.getString("password_hash");


                if (PasswordUtil.verifyPassword(password, storedHash)) {

                    return mapResultSetToMember(rs);
                }

            }

            return null;

        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM members WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                return rs.getInt(1) > 0;
            }
            return false; // no result = email not found = available

        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    private Member mapResultSetToMember(ResultSet rs) throws SQLException {

        String membershipType = rs.getString("membership_type");


        int id             = rs.getInt("member_id");
        String name        = rs.getString("name");
        String email       = rs.getString("email");
        String phone       = rs.getString("phone");
        String dob         = rs.getString("dob") != null ? rs.getString("dob") : "";
        String gender      = rs.getString("gender") != null ? rs.getString("gender") : "";
        String joinDate    = rs.getString("join_date") != null ? rs.getString("join_date") : "";
        String status      = rs.getString("status");
        String passHash    = rs.getString("password_hash");


        if ("PREMIUM".equalsIgnoreCase(membershipType)) {

            return new PremiumMember(id, name, email, phone, dob, gender,
                    membershipType, joinDate, status, passHash);
        } else {

            return new RegularMember(id, name, email, phone, dob, gender,
                    membershipType, joinDate, status, passHash);
        }
    }
}

