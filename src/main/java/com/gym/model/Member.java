
package com.gym.model;


public abstract class Member extends Person {


    private int memberId;

    private String dob;


    private String gender;


    private String membershipType;


    private String joinDate;


    private String status;


    private String passwordHash;


    public Member(int memberId, String name, String email, String phone,
                  String dob, String gender, String membershipType,
                  String joinDate, String status, String passwordHash) {

        super(memberId, name, email, phone);


        this.memberId = memberId;
        this.dob = dob;
        this.gender = gender;
        this.membershipType = membershipType;
        this.joinDate = joinDate;
        this.status = status;
        this.passwordHash = passwordHash;
    }


    public Member() {
        super();
    }

    public abstract double getMonthlyFee();


    public abstract int getAccessLevel();


    @Override
    public String getRole() {

        return "MEMBER";
    }

    public boolean isActive() {

        return "ACTIVE".equalsIgnoreCase(this.status);
    }



    public int getMemberId() {
        return memberId;
    }


    public String getDob() {
        return dob;
    }

    public String getGender() {
        return gender;
    }


    public String getMembershipType() {
        return membershipType;
    }


    public String getJoinDate() {
        return joinDate;
    }


    public String getStatus() {
        return status;
    }


    public String getPasswordHash() {
        return passwordHash;
    }



    public void setMemberId(int memberId) {
        this.memberId = memberId;

        super.setPersonId(memberId);
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setMembershipType(String membershipType) {
        this.membershipType = membershipType;
    }

    public void setJoinDate(String joinDate) {
        this.joinDate = joinDate;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }


    @Override
    public String toString() {
        return "Member{id=" + memberId + ", name='" + getName() +
                "', type='" + membershipType + "', status='" + status + "'}";
    }
}
