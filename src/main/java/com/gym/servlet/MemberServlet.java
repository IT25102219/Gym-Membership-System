
package com.gym.servlet;

import com.gym.model.*;
import com.gym.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;


@WebServlet("/members")
public class MemberServlet extends HttpServlet {


    private MemberService memberService = new MemberService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":

                List<Member> allMembers = memberService.getAllMembers();
                request.setAttribute("members", allMembers);
                request.getRequestDispatcher("/member/memberList.jsp").forward(request, response);
                break;

            case "view":

                int viewId = Integer.parseInt(request.getParameter("id"));
                Member viewMember = memberService.getMemberById(viewId);
                request.setAttribute("member", viewMember);
                request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
                break;

            case "edit":

                int editId = Integer.parseInt(request.getParameter("id"));
                Member editMember = memberService.getMemberById(editId);
                request.setAttribute("member", editMember);
                request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
                break;

            case "delete":

                int deleteId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = memberService.deleteMember(deleteId);
                if (deleted) {
                    request.getSession().setAttribute("successMessage", "Member deactivated successfully.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Could not deactivate member.");
                }
                response.sendRedirect(request.getContextPath() + "/members?action=list");
                break;

            case "search":

                String query = request.getParameter("query");
                List<Member> found = (query != null && !query.trim().isEmpty())
                        ? memberService.searchMembers(query.trim())
                        : memberService.getAllMembers();
                request.setAttribute("members", found);
                request.setAttribute("searchQuery", query);
                request.getRequestDispatcher("/member/memberList.jsp").forward(request, response);
                break;

            default:

                response.sendRedirect(request.getContextPath() + "/members?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            handleRegistration(request, response);

        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String name           = request.getParameter("name");
        String email          = request.getParameter("email");
        String phone          = request.getParameter("phone");
        String dob            = request.getParameter("dob");
        String gender         = request.getParameter("gender");
        String membershipType = request.getParameter("membershipType");
        String password       = request.getParameter("password");
        String joinDate       = LocalDate.now().toString(); // today's date


        if (name == null || email == null || password == null ||
                name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name, email, and password are required.");
            request.getRequestDispatcher("/member/register.jsp").forward(request, response);
            return; // stop processing
        }


        Member newMember;
        if ("PREMIUM".equalsIgnoreCase(membershipType)) {

            newMember = new PremiumMember(0, name, email, phone, dob,
                    gender, "PREMIUM", joinDate, "ACTIVE", password);
        } else {

            newMember = new RegularMember(0, name, email, phone, dob,
                    gender, "REGULAR", joinDate, "ACTIVE", password);
        }


        boolean success = memberService.registerMember(newMember);

        if (success) {

            request.getSession().setAttribute("successMessage",
                    "Registration successful! Please log in.");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {

            request.setAttribute("errorMessage",
                    "Registration failed. Email may already be registered.");
            request.getRequestDispatcher("/member/register.jsp").forward(request, response);
        }
    }


    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int memberId          = Integer.parseInt(request.getParameter("memberId"));
        String name           = request.getParameter("name");
        String phone          = request.getParameter("phone");
        String membershipType = request.getParameter("membershipType");
        String status         = request.getParameter("status");


        Member existing = memberService.getMemberById(memberId);
        if (existing != null) {
            existing.setName(name);
            existing.setPhone(phone);
            existing.setMembershipType(membershipType);
            existing.setStatus(status);

            boolean updated = memberService.updateMember(existing);
            if (updated) {
                request.getSession().setAttribute("successMessage", "Profile updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Update failed.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/members?action=view&id=" + memberId);
    }
}

