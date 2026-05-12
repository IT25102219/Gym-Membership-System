package com.gym.model;

import com.gym.interfaces.Displayable;
import com.gym.interfaces.IPlanPriceable;

public abstract class MembershipPlan implements IPlanPriceable, Displayable {

    private int planId;
    private String planName;
    private int durationMonths;
    private double price;
    private String features;
    private String planType;
    private boolean isActive;

    public MembershipPlan(int planId, String planName, int durationMonths,
                          double price, String features, String planType, boolean isActive) {
        this.planId = planId;
        this.planName = planName;
        this.durationMonths = durationMonths;
        this.price = price;
        this.features = features;
        this.planType = planType;
        this.isActive = isActive;
    }

    public MembershipPlan() {}

    @Override
    public abstract double calculateDiscountedPrice();

    @Override
    public double calculatePrice() {
        return price;
    }

    public int getPlanId()          { return planId; }
    public String getPlanName()     { return planName; }
    public int getDurationMonths()  { return durationMonths; }
    public double getPrice()        { return price; }
    public String getFeatures()     { return features; }
    public String getPlanType()     { return planType; }
    public boolean isActive()       { return isActive; }

    public void setPlanId(int planId)               { this.planId = planId; }
    public void setPlanName(String planName)         { this.planName = planName; }
    public void setDurationMonths(int d)             { this.durationMonths = d; }
    public void setPrice(double price)               { this.price = price; }
    public void setFeatures(String features)         { this.features = features; }
    public void setPlanType(String planType)         { this.planType = planType; }
    public void setActive(boolean active)            { isActive = active; }
}
