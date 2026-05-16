
package com.gym.model;

import com.gym.interfaces.ISchedulable;


public abstract class Trainer extends Person implements ISchedulable {

    private int trainerId;
    private String specialisation;
    private int experienceYears;
    private String trainerType;
    private String availability;
    private String status;

    public Trainer(int trainerId, String name, String email, String phone,
                   String specialisation, int experienceYears,
                   String trainerType, String availability, String status) {
        super(trainerId, name, email, phone);

        this.trainerId = trainerId;
        this.specialisation = specialisation;
        this.experienceYears = experienceYears;
        this.trainerType = trainerType;
        this.availability = availability;
        this.status = status;
    }

    public Trainer() {
        super();
    }

    public abstract double getSessionRate();


    @Override
    public String getAvailability() {
        return availability;
    }

    @Override
    public boolean isAvailable(String day) {
        if (availability == null || availability.trim().isEmpty()) {
            return false;
        }
        return availability.toLowerCase().contains(day.toLowerCase());
    }


    @Override
    public String getRole() {
        return "TRAINER";
    }
    // ============================================================

    public int getTrainerId() { return trainerId; }
    public String getSpecialisation() { return specialisation; }
    public int getExperienceYears() { return experienceYears; }
    public String getTrainerType() { return trainerType; }
    public String getStatus() { return status; }


    public void setTrainerId(int trainerId) {
        this.trainerId = trainerId;
        super.setPersonId(trainerId);
    }

    public void setSpecialisation(String specialisation) { this.specialisation = specialisation; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }
    public void setTrainerType(String trainerType) { this.trainerType = trainerType; }
    public void setAvailability(String availability) { this.availability = availability; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Trainer{id=" + trainerId + ", name='" + getName() +
               "', type='" + trainerType + "', spec='" + specialisation + "'}";
    }
}
