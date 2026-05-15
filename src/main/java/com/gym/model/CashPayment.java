/*
 * FILE    : CashPayment.java
 * PACKAGE : com.gym.model
 * PURPOSE : Represents a payment made with physical cash at the gym counter.
 *           Cash payments are manually processed by staff — no TXN ID needed.
 *           Staff marks it as PAID after receiving the physical cash.
 * OOP     : POLYMORPHISM — processPayment() simply marks as PAID (no TXN ID generation).
 *                         COMPARE: OnlinePayment.processPayment() generates TXN ID first.
 *                         Same method name, different logic = POLYMORPHISM.
 *           INHERITANCE — inherits all fields from Payment.
 * CONNECTS: Created by PaymentServlet when method="CASH" in the form
 *           PaymentService creates CashPayment when method='CASH' in DB
 */
package com.gym.model;


public class CashPayment extends Payment {

    public CashPayment(int paymentId, int memberId, int planId, double amount,
                       String paymentDate, String method, String status) {

        super(paymentId, memberId, planId, amount, paymentDate, method, status);
    }

    public CashPayment() {
        super();
    }


    @Override
    public boolean processPayment() {

        setStatus("PAID");

        System.out.println("Cash payment processed. Amount: LKR " + getAmount() +
                           " received at counter. Payment ID: " + getPaymentId());

        return true;
    }

    @Override
    public String generateReceipt() {
        return "====================================\n" +
               "         CASH PAYMENT RECEIPT       \n" +
               "====================================\n" +
               "Payment ID : " + getPaymentId() + "\n" +
               "Member ID  : " + getMemberId() + "\n" +
               "Amount     : LKR " + String.format("%.2f", getAmount()) + "\n" +
               "Paid on    : " + getPaymentDate() + "\n" +
               "Method     : CASH (Paid at counter)\n" +
               "Status     : " + getStatus() + "\n" +
               "====================================\n" +
               "Thank you for your payment!";
    }

    @Override
    public String getDisplayInfo() {
        return "Cash Payment | ID: " + getPaymentId() +
               " | LKR " + String.format("%.2f", getAmount()) +
               " | Date: " + getPaymentDate() +
               " | Status: " + getStatus();
    }

    @Override
    public String getRole() {
        return "CASH_PAYMENT";
    }
}
