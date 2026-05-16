
package com.gym.model;

public class PersonalTrainer extends Trainer {

    private final double sessionRate = 3000.0;
    private final int maxClients = 5;


    public PersonalTrainer(int trainerId, String name, String email, String phone,
                           String specialisation, int experienceYears,
                           String trainerType, String availability, String status) {

        super(trainerId, name, email, phone, specialisation, experienceYears,
              trainerType, availability, status);
    }

    public PersonalTrainer() {
        super();
    }

    @Override
    public double getSessionRate() {
        return sessionRate;
    }

    @Override
    public String getDisplayInfo() {
        return "Personal Trainer: " + getName() +
               " | Specialisation: " + getSpecialisation() +
               " | LKR 3000/session" +
               " | " + getExperienceYears() + " years exp." +
               " | Max clients: " + maxClients;
    }

    @Override
    public String getRole() {

        return "PERSONAL_TRAINER";
    }


    public int getMaxClients() {

        return maxClients;
    }
}
