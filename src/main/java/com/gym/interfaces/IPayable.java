/*
 * FILE          : IPayable.java
 * PACKAGE       : com.gym.interfaces
 * PURPOSE       : Defines the payment processing contract.
 *                 All payment types (cash, online) must be able to process
 *                 themselves and generate a receipt.
 * OOP CONCEPT   : ABSTRACTION — hides HOW payment is processed.
 *                 POLYMORPHISM — CashPayment.processPayment() marks as paid;
 *                               OnlinePayment.processPayment() also generates a TXN ID.
 *                 The PaymentServlet calls payment.processPayment() without
 *                 knowing whether it is Cash or Online. The right logic runs.
 * IMPLEMENTED BY: Payment (abstract), CashPayment, OnlinePayment
 * WHY           : Allows adding new payment types (e.g., CardPayment) in the future
 *                 without changing the servlet code. Just implement IPayable.
 */
package com.gym.interfaces;
public interface IPayable {
    boolean processPayment();
    String generateReceipt();
}
