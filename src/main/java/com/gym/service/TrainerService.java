
package com.gym.service;

import com.gym.model.*;
import com.gym.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainerService {

    public boolean addTrainer(Trainer trainer) {
        String sql = "INSERT INTO trainers (name, specialisation, experience_years, " +
                     "phone, email, trainer_type, availability, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, trainer.getName());
            stmt.setString(2, trainer.getSpecialisation());
            stmt.setInt(3, trainer.getExperienceYears());
            stmt.setString(4, trainer.getPhone());
            stmt.setString(5, trainer.getEmail());
            stmt.setString(6, trainer.getTrainerType());
            stmt.setString(7, trainer.getAvailability());
            stmt.setString(8, "ACTIVE"); // new trainers start as ACTIVE
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding trainer: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public Trainer getTrainerById(int id) {
        String sql = "SELECT * FROM trainers WHERE trainer_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTrainer(rs); // POLYMORPHISM happens here
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Error fetching trainer by ID: " + e.getMessage());
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Trainer> getAllTrainers() {
        String sql = "SELECT * FROM trainers ORDER BY created_at DESC";
        List<Trainer> trainers = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                trainers.add(mapResultSetToTrainer(rs)); // Polymorphism per row
            }
            return trainers;

        } catch (SQLException e) {
            System.err.println("Error fetching all trainers: " + e.getMessage());
            return trainers;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Trainer> getActiveTrainers() {
        String sql = "SELECT * FROM trainers WHERE status='ACTIVE' ORDER BY name";
        List<Trainer> trainers = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                trainers.add(mapResultSetToTrainer(rs));
            }
            return trainers;

        } catch (SQLException e) {
            System.err.println("Error fetching active trainers: " + e.getMessage());
            return trainers;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public List<Trainer> searchTrainers(String query) {
        String sql = "SELECT * FROM trainers WHERE name LIKE ? OR specialisation LIKE ?";
        List<Trainer> trainers = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            String pattern = "%" + query + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                trainers.add(mapResultSetToTrainer(rs));
            }
            return trainers;

        } catch (SQLException e) {
            System.err.println("Error searching trainers: " + e.getMessage());
            return trainers;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean updateTrainer(Trainer trainer) {
        String sql = "UPDATE trainers SET name=?, specialisation=?, experience_years=?, " +
                     "phone=?, email=?, trainer_type=?, availability=?, status=? " +
                     "WHERE trainer_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, trainer.getName());
            stmt.setString(2, trainer.getSpecialisation());
            stmt.setInt(3, trainer.getExperienceYears());
            stmt.setString(4, trainer.getPhone());
            stmt.setString(5, trainer.getEmail());
            stmt.setString(6, trainer.getTrainerType());
            stmt.setString(7, trainer.getAvailability());
            stmt.setString(8, trainer.getStatus());
            stmt.setInt(9, trainer.getTrainerId());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating trainer: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean deleteTrainer(int id) {
        String sql = "UPDATE trainers SET status='INACTIVE' WHERE trainer_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting trainer: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    private Trainer mapResultSetToTrainer(ResultSet rs) throws SQLException {
        int id               = rs.getInt("trainer_id");
        String name          = rs.getString("name");
        String email         = rs.getString("email");
        String phone         = rs.getString("phone");
        String specialisation = rs.getString("specialisation");
        int experience       = rs.getInt("experience_years");
        String trainerType   = rs.getString("trainer_type");
        String availability  = rs.getString("availability");
        String status        = rs.getString("status");

        if ("PERSONAL".equalsIgnoreCase(trainerType)) {
            return new PersonalTrainer(id, name, email, phone, specialisation,
                                       experience, trainerType, availability, status);
        } else {
            return new GroupTrainer(id, name, email, phone, specialisation,
                                    experience, trainerType, availability, status);
        }
    }
}
