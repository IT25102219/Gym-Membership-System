package com.gym.model;





public class PremiumMember extends Member {


    private final double monthlyFee = 5000.0;


    private boolean trainerAssigned;


    public PremiumMember(int memberId, String name, String email, String phone,
                         String dob, String gender, String membershipType,
                         String joinDate, String status, String passwordHash) {

        super(memberId, name, email, phone, dob, gender, membershipType,
                joinDate, status, passwordHash);


        this.trainerAssigned = false;
    }


    public PremiumMember(int memberId, String name, String email, String phone,
                         String dob, String gender, String membershipType,
                         String joinDate, String status, String passwordHash,
                         boolean trainerAssigned) {
        super(memberId, name, email, phone, dob, gender, membershipType,
                joinDate, status, passwordHash);
        this.trainerAssigned = trainerAssigned;
    }


    public PremiumMember() {
        super();
        this.trainerAssigned = false; // default: no trainer assigned
    }


    @Override
    public double getMonthlyFee() {

        return monthlyFee; // returns 5000.0
    }


    @Override
    public int getAccessLevel() {
        // Level 2 = full gym access (all equipment + pool + sauna + trainer sessions)
        return 2;
    }


    @Override
    public String getRole() {
        return "PREMIUM_MEMBER";
    }


    @Override
    public String getDisplayInfo() {

        return "Premium Member: " + getName() +
                " | Email: " + getEmail() +
                " | Fee: LKR 5000/month" +
                " | Access Level: Full (Level 2)" +
                " | Trainer: " + (trainerAssigned ? "Yes" : "No") +
                " | Status: " + getStatus();
    }


    public boolean hasTrainerAssigned() {
        return trainerAssigned;
    }


    public void setTrainerAssigned(boolean trainerAssigned) {
        this.trainerAssigned = trainerAssigned;
    }
}



