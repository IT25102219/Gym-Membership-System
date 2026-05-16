/*
 * SERVLET  : AttendanceServlet
 * PACKAGE  : com.gym.servlet
 * PURPOSE  : Handles all attendance check-in, check-out, history, and report requests.
 * LAYER    : Web/Controller Layer
 * HANDLES  : GET (history/report/today) and POST (checkin/checkout/delete)
 * CALLS    : AttendanceService for all database operations
 * FORWARDS : Results to JSP pages under /attendance/
 * URL      : @WebServlet("/attendance")
 */
package com.gym.servlet;

import com.gym.model.AttendanceRecord;
import com.gym.model.Member;
import com.gym.service.AttendanceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// WHAT : Servlet controlling all gym attendance tracking operations
// WHY  : Routes check-in/check-out HTTP requests to service and JSP
// OOP  : ENCAPSULATION of attendance web logic
@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    // FIELD: attendanceService — handles all attendance DB operations
    private AttendanceService attendanceService = new AttendanceService();

    // METHOD : doGet
    // DOES   : Handles viewing attendance history, daily reports, and today's check-ins
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "today";

        HttpSession session = request.getSession(false);
        Member loggedMember = (session != null) ? (Member) session.getAttribute("loggedMember") : null;

        switch (action) {
            case "history":
                // Show attendance history for a specific member
                int memberId = 0;
                if (request.getParameter("memberId") != null) {
                    memberId = Integer.parseInt(request.getParameter("memberId"));
                } else if (loggedMember != null) {
                    memberId = loggedMember.getMemberId(); // default: logged-in member's history
                }
                List<AttendanceRecord> history = attendanceService.getAttendanceByMember(memberId);
                request.setAttribute("records", history);
                request.setAttribute("memberId", memberId);
                request.getRequestDispatcher("/attendance/attendanceHistory.jsp").forward(request, response);
                break;

            case "report":
                // Show attendance report for a specific date
                String date = request.getParameter("date");
                if (date == null || date.isEmpty()) {
                    date = java.time.LocalDate.now().toString(); // default to today
                }
                List<AttendanceRecord> dateRecords = attendanceService.getAttendanceByDate(date);
                request.setAttribute("records", dateRecords);
                request.setAttribute("reportDate", date);
                request.getRequestDispatcher("/attendance/attendanceReport.jsp").forward(request, response);
                break;

            case "today":
                // Show today's attendance — used by dashboard and checkIn page
                List<AttendanceRecord> todayRecords = attendanceService.getTodayAttendance();
                request.setAttribute("records", todayRecords);
                request.getRequestDispatcher("/attendance/checkIn.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/attendance?action=today");
        }
    }

    // METHOD : doPost
    // DOES   : Handles check-in, check-out, and record deletion
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("checkin".equals(action)) {
            // Record a new check-in for the specified member
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            boolean success = attendanceService.checkIn(memberId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Check-in recorded successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Check-in failed.");
            }
            response.sendRedirect(request.getContextPath() + "/attendance?action=today");

        } else if ("checkout".equals(action)) {
            // Record check-out time for an existing attendance record
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            boolean success = attendanceService.checkOut(recordId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Check-out recorded successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Check-out failed.");
            }
            response.sendRedirect(request.getContextPath() + "/attendance?action=today");

        } else if ("delete".equals(action)) {
            // Admin only: permanently delete an attendance record
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            attendanceService.deleteRecord(recordId);
            request.getSession().setAttribute("successMessage", "Attendance record deleted.");
            response.sendRedirect(request.getContextPath() + "/attendance?action=today");
        }
    }
}
