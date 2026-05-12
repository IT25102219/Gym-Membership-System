package com.gym.model;

public class Member {
    private String id;
    private String name;
    private String email;
    private String role;
    private String accessLevel;
    private double monthlyFee;

    public Member() {}

    public Member(String id, String name, String email, String role, String accessLevel, double monthlyFee) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.accessLevel = accessLevel;
        this.monthlyFee = monthlyFee;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getAccessLevel() { return accessLevel; }
    public void setAccessLevel(String accessLevel) { this.accessLevel = accessLevel; }
    public double getMonthlyFee() { return monthlyFee; }
    public void setMonthlyFee(double monthlyFee) { this.monthlyFee = monthlyFee; }

    public String getDisplayInfo() {
        return "Member ID: " + id + " | Email: " + email;
    }
}
