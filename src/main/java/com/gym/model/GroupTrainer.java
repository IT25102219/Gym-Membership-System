
package com.gym.model;

public class GroupTrainer extends Trainer {

    private final double sessionRate = 1000.0;

    private final int maxClients = 30;

    public GroupTrainer(int trainerId, String name, String email, String phone, String specialisation, int experienceYears, String trainerType, String availability, String status) {
        super(trainerId, name, email, phone, specialisation, experienceYears, trainerType, availability, status);
    }

    public GroupTrainer() {
        super();
    }

    @Override
    public double getSessionRate() {
        return sessionRate;
    }

    @Override
    public String getDisplayInfo() {
        return "Group Trainer: " + getName() +
               " | Specialisation: " + getSpecialisation() +
               " | LKR 1000/person/session" +
               " | " + getExperienceYears() + " years exp." +
               " | Class size: up to " + maxClients;
    }


    @Override
    public String getRole() {

        return "GROUP_TRAINER";
    }


    public int getMaxClients() {

        return maxClients;
    }
}
