/*
 * SERVLET  : PaymentServlet
 * PACKAGE  : com.gym.servlet
 * PURPOSE  : Handles all payment recording, history, filtering, and status updates.
 *            Creates CashPayment or OnlinePayment (POLYMORPHISM) before processing.
 * LAYER    : Web/Controller Layer
 * HANDLES  : GET (history/list/filter) and POST (add/updateStatus/delete)
 * CALLS    : PaymentService for database operations
 * FORWARDS : Results to JSP pages under /payment/
 * URL      : @WebServlet("/payments")
 */
package com.gym.servlet;

import com.gym.model.CashPayment;
import com.gym.model.Member;
import com.gym.model.OnlinePayment;
import com.gym.model.Payment;
import com.gym.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/payments")
public class PaymentServlet extends HttpServlet {
    private PaymentService paymentService = new PaymentService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "history";

        HttpSession session = request.getSession(false);
        Member loggedMember = (session != null) ? (Member) session.getAttribute("loggedMember") : null;

        switch (action) {
            case "history":
                int memberId = 0;
                if (request.getParameter("memberId") != null) {
                    memberId = Integer.parseInt(request.getParameter("memberId"));
                } else if (loggedMember != null) {
                    memberId = loggedMember.getMemberId();
                }
                List<Payment> history = paymentService.getPaymentsByMember(memberId);
                request.setAttribute("payments", history);
                request.getRequestDispatcher("/payment/paymentHistory.jsp").forward(request, response);
                break;

            case "list":
                List<Payment> all = paymentService.getAllPayments();
                request.setAttribute("payments", all);
                request.getRequestDispatcher("/payment/paymentList.jsp").forward(request, response);
                break;

            case "filter":

                String status = request.getParameter("status");
                List<Payment> filtered = paymentService.getPaymentsByStatus(status);
                request.setAttribute("payments", filtered);
                request.setAttribute("filterStatus", status);
                request.getRequestDispatcher("/payment/paymentList.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/payments?action=list");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int memberId    = Integer.parseInt(request.getParameter("memberId"));
            int planId      = Integer.parseInt(request.getParameter("planId"));
            double amount   = Double.parseDouble(request.getParameter("amount"));
            String date     = request.getParameter("paymentDate");
            String method   = request.getParameter("method"); // "CASH", "ONLINE", "CARD"


            Payment newPayment;
            if ("ONLINE".equalsIgnoreCase(method) || "CARD".equalsIgnoreCase(method)) {

                newPayment = new OnlinePayment(0, memberId, planId, amount, date, method, "PENDING");
            } else {

                newPayment = new CashPayment(0, memberId, planId, amount, date, method, "PENDING");
            }


            boolean added = paymentService.recordPayment(newPayment);
            request.getSession().setAttribute(added ? "successMessage" : "errorMessage",
                added ? "Payment recorded successfully." : "Failed to record payment.");
            response.sendRedirect(request.getContextPath() + "/payments?action=list");

        } else if ("updateStatus".equals(action)) {
            int paymentId  = Integer.parseInt(request.getParameter("paymentId"));
            String status  = request.getParameter("status");
            paymentService.updatePaymentStatus(paymentId, status);
            request.getSession().setAttribute("successMessage", "Payment status updated.");
            response.sendRedirect(request.getContextPath() + "/payments?action=list");

        } else if ("delete".equals(action)) {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            paymentService.deletePayment(paymentId);
            request.getSession().setAttribute("successMessage", "Payment deleted.");
            response.sendRedirect(request.getContextPath() + "/payments?action=list");
        }
    }
}
