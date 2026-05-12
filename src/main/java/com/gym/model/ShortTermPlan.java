package com.gym.model;

public class ShortTermPlan extends MembershipPlan {

    public ShortTermPlan(int planId, String planName, int durationMonths,
                         double price, String features, String planType, boolean isActive) {
        super(planId, planName, durationMonths, price, features, planType, isActive);
    }

    public ShortTermPlan() { super(); }

    @Override
    public double calculateDiscountedPrice() {
        return getPrice();
    }

    @Override
    public String getDisplayInfo() {
        return "Short Term: " + getPlanName() +
               " | " + getDurationMonths() + " month(s)" +
               " | LKR " + String.format("%.2f", getPrice());
    }

    @Override
    public String getRole() {
        return "SHORT_TERM_PLAN";
    }
}
