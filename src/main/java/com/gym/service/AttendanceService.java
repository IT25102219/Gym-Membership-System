package com.gym.service;

import com.gym.model.AttendanceRecord;
import com.gym.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class AttendanceService {

    public boolean checkIn(int memberId) {
        String sql = "INSERT INTO attendance (member_id, check_in, attend_date) VALUES (?, NOW(), CURDATE())";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId); // which member is checking in
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error during check-in: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean checkOut(int recordId) {
        String sql = "UPDATE attendance SET check_out = NOW() WHERE record_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, recordId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error during check-out: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<AttendanceRecord> getAttendanceByMember(int memberId) {
        String sql = "SELECT a.*, m.name as member_name FROM attendance a " +
                     "JOIN members m ON a.member_id = m.member_id " +
                     "WHERE a.member_id = ? ORDER BY a.check_in DESC";
        List<AttendanceRecord> records = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                records.add(mapResultSetToRecord(rs));
            }
            return records;

        } catch (SQLException e) {
            System.err.println("Error fetching attendance by member: " + e.getMessage());
            return records;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<AttendanceRecord> getAttendanceByDate(String date) {
        String sql = "SELECT a.*, m.name as member_name FROM attendance a " +
                     "JOIN members m ON a.member_id = m.member_id " +
                     "WHERE a.attend_date = ? ORDER BY a.check_in ASC";
        List<AttendanceRecord> records = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, date); // date format: "YYYY-MM-DD"
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                records.add(mapResultSetToRecord(rs));
            }
            return records;

        } catch (SQLException e) {
            System.err.println("Error fetching attendance by date: " + e.getMessage());
            return records;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<AttendanceRecord> getTodayAttendance() {
        String sql = "SELECT a.*, m.name as member_name FROM attendance a " +
                     "JOIN members m ON a.member_id = m.member_id " +
                     "WHERE a.attend_date = CURDATE() ORDER BY a.check_in DESC";
        List<AttendanceRecord> records = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                records.add(mapResultSetToRecord(rs));
            }
            return records;

        } catch (SQLException e) {
            System.err.println("Error fetching today's attendance: " + e.getMessage());
            return records;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean deleteRecord(int recordId) {
        String sql = "DELETE FROM attendance WHERE record_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, recordId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting attendance record: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public AttendanceRecord getActiveCheckIn(int memberId) {
        String sql = "SELECT a.*, m.name as member_name FROM attendance a " +
                     "JOIN members m ON a.member_id = m.member_id " +
                     "WHERE a.member_id = ? AND a.check_out IS NULL AND a.attend_date = CURDATE()";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRecord(rs); // found an open check-in
            }
            return null; // no open check-in found

        } catch (SQLException e) {
            System.err.println("Error finding active check-in: " + e.getMessage());
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    private AttendanceRecord mapResultSetToRecord(ResultSet rs) throws SQLException {
        AttendanceRecord record = new AttendanceRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setMemberId(rs.getInt("member_id"));
        record.setMemberName(rs.getString("member_name"));
        record.setCheckIn(rs.getString("check_in"));
        record.setCheckOut(rs.getString("check_out")); // may be null
        record.setAttendDate(rs.getString("attend_date"));
        return record;
    }
}
