package com.gym.model;

public class LongTermPlan extends MembershipPlan {

    private final double discountPercent = 10.0;

    public LongTermPlan(int planId, String planName, int durationMonths,
                        double price, String features, String planType, boolean isActive) {
        super(planId, planName, durationMonths, price, features, planType, isActive);
    }

    public LongTermPlan() { super(); }

    @Override
    public double calculateDiscountedPrice() {
        return getPrice() * 0.90;
    }

    @Override
    public String getDisplayInfo() {
        return "Long Term: " + getPlanName() +
               " | " + getDurationMonths() + " month(s)" +
               " | LKR " + String.format("%.2f", calculateDiscountedPrice()) +
               " (10% off from LKR " + String.format("%.2f", getPrice()) + ")";
    }

    @Override
    public String getRole() {
        return "LONG_TERM_PLAN";
    }

    public double getDiscountPercent() {
        return discountPercent;
    }
}
