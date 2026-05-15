/*
 * FILE    : OnlinePayment.java
 * PACKAGE : com.gym.model
 * PURPOSE : Represents a payment made through an online channel (bank transfer, card).
 *           Online payments automatically generate a unique Transaction ID (TXN ID)
 *           for tracking and dispute resolution purposes.
 * OOP     : POLYMORPHISM — processPayment() generates a TXN ID BEFORE marking as PAID.
 *                         COMPARE: CashPayment.processPayment() just marks as PAID.
 *                         DIFFERENT behavior from the SAME method name = POLYMORPHISM.
 *           INHERITANCE — inherits all fields from Payment.
 * CONNECTS: Created by PaymentServlet when method="ONLINE" in the form
 *           PaymentService creates OnlinePayment when method='ONLINE' in DB
 */
package com.gym.model;

import java.util.UUID;


public class OnlinePayment extends Payment {
    private String transactionId;

    public OnlinePayment(int paymentId, int memberId, int planId, double amount,
                         String paymentDate, String method, String status) {
        super(paymentId, memberId, planId, amount, paymentDate, method, status);
        this.transactionId = ""; // not assigned until processPayment() is called
    }


    public OnlinePayment(int paymentId, int memberId, int planId, double amount,
                         String paymentDate, String method, String status,
                         String transactionId) {
        super(paymentId, memberId, planId, amount, paymentDate, method, status);
        this.transactionId = transactionId;
    }


    public OnlinePayment() {
        super();
        this.transactionId = "";
    }

    @Override
    public boolean processPayment() {
        this.transactionId = "TXN" + UUID.randomUUID().toString()
                                        .replace("-", "")
                                        .substring(0, 8)
                                        .toUpperCase();

        setStatus("PAID");

        System.out.println("Online payment processed. TXN ID: " + transactionId +
                           " | Amount: LKR " + getAmount());


        return true;
    }


    @Override
    public String generateReceipt() {
        return "====================================\n" +
               "        ONLINE PAYMENT RECEIPT      \n" +
               "====================================\n" +
               "Payment ID : " + getPaymentId() + "\n" +
               "TXN ID     : " + (transactionId.isEmpty() ? "N/A" : transactionId) + "\n" +
               "Member ID  : " + getMemberId() + "\n" +
               "Amount     : LKR " + String.format("%.2f", getAmount()) + "\n" +
               "Paid on    : " + getPaymentDate() + "\n" +
               "Method     : ONLINE\n" +
               "Status     : " + getStatus() + "\n" +
               "====================================\n" +
               "Thank you for your online payment!";
    }

    @Override
    public String getDisplayInfo() {
        return "Online Payment | TXN: " + (transactionId.isEmpty() ? "N/A" : transactionId) +
               " | LKR " + String.format("%.2f", getAmount()) +
               " | Date: " + getPaymentDate() +
               " | Status: " + getStatus();
    }
    @Override
    public String getRole() {
        return "ONLINE_PAYMENT";
    }
    public String getTransactionId() {
        return transactionId;
    }
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
}
