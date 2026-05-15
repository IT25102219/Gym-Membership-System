/*
 * FILE    : Payment.java
 * PACKAGE : com.gym.model
 * PURPOSE : Abstract base class for all payment types in the system.
 *           Defines the common payment data (amount, date, method, status)
 *           and forces subclasses to implement processPayment() and generateReceipt().
 * OOP     : ABSTRACTION — abstract class, cannot instantiate Payment directly.
 *                         processPayment() and generateReceipt() are abstract.
 *           ENCAPSULATION — all payment fields are private with getters/setters.
 *           POLYMORPHISM — PaymentServlet calls payment.processPayment() without
 *                         knowing if it is CashPayment or OnlinePayment.
 * CONNECTS: Extended by CashPayment.java and OnlinePayment.java
 *           PaymentService creates the correct subclass based on method column
 *           PaymentServlet calls processPayment() (polymorphism)
 */
package com.gym.model;

import com.gym.interfaces.Displayable;
import com.gym.interfaces.IPayable;


public abstract class Payment implements IPayable, Displayable {


    private int paymentId;


    private int memberId;


    private int planId;


    private double amount;


    private String paymentDate;


    private String method;


    private String status;


    public Payment(int paymentId, int memberId, int planId, double amount,
                   String paymentDate, String method, String status) {
        this.paymentId = paymentId;
        this.memberId = memberId;
        this.planId = planId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.method = method;
        this.status = status;
    }


    public Payment() {}
    @Override
    public abstract boolean processPayment();
    @Override
    public abstract String generateReceipt();


    public int getPaymentId() { return paymentId; }
    public int getMemberId() { return memberId; }
    public int getPlanId() { return planId; }
    public double getAmount() { return amount; }
    public String getPaymentDate() { return paymentDate; }
    public String getMethod() { return method; }
    public String getStatus() { return status; }



    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setPlanId(int planId) { this.planId = planId; }
    public void setAmount(double amount) { this.amount = amount; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
    public void setMethod(String method) { this.method = method; }


    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Payment{id=" + paymentId + ", memberId=" + memberId +
               ", amount=" + amount + ", status='" + status + "'}";
    }
}
