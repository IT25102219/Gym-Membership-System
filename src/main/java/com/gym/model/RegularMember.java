package com.gym.model;


    public class RegularMember extends Member {


        private final double monthlyFee = 2500.0;


        public RegularMember(int memberId, String name, String email, String phone,
                             String dob, String gender, String membershipType,
                             String joinDate, String status, String passwordHash) {

            super(memberId, name, email, phone, dob, gender, membershipType,
                    joinDate, status, passwordHash);
        }


        public RegularMember() {
            super();
        }

        @Override
        public double getMonthlyFee() {

            return monthlyFee; // returns 2500.0
        }


        @Override
        public int getAccessLevel() {

            return 1;
        }


        @Override
        public String getRole() {

            return "REGULAR_MEMBER";
        }


        @Override
        public String getDisplayInfo() {
            // Build a readable summary string showing the key facts about this member
            return "Regular Member: " + getName() +
                    " | Email: " + getEmail() +
                    " | Fee: LKR 2500/month" +
                    " | Access Level: Basic (Level 1)" +
                    " | Status: " + getStatus();
        }
    }




