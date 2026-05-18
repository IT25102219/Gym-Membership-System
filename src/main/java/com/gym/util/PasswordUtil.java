package com.gym.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    private static final String ALGORITHM = "MD5";

    public static String hashPassword(String plainPassword) {

        if (plainPassword == null) {
            return null;
        }

        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);

            byte[] hashedBytes = md.digest(plainPassword.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {

                String hex = Integer.toHexString(0xFF & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(
                "MD5 algorithm not available. This should never happen with standard JDK. "
                + e.getMessage(), e
            );
        }
    }

    public static boolean verifyPassword(String plainPassword, String storedHash) {
        String hashedInput = hashPassword(plainPassword);

        return storedHash != null && storedHash.equalsIgnoreCase(hashedInput);
    }
}
