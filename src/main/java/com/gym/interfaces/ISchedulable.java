package com.gym.interfaces;

public interface ISchedulable {
    String getAvailability();
    boolean isAvailable(String day);
}
