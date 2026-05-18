package com.gym.servlet;

import com.gym.model.Member;
import com.gym.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// WHAT : Servlet that handles login and logout for all gym members
// WHY  : Separates authentication logic from the JSP pages
// OOP  : ENCAPSULATION — auth logic hidden inside this servlet class
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    // FIELD: memberService — the service class that talks to the database for member operations
    // Created once when servlet is initialised (not per-request)
    private MemberService memberService = new MemberService();

    // METHOD : doPost
    // DOES   : Handles POST requests — login form submissions and logout actions.
    //          Reads the "action" parameter to decide what to do.
    // CALLED : Browser submits the login form on index.jsp (action="login")
    //          Logout link on navbar (action="logout")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read the "action" hidden input from the form to know what to do
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            // ---- HANDLE LOGIN ----
            handleLogin(request, response);

        } else if ("logout".equals(action)) {
            // ---- HANDLE LOGOUT ----
            handleLogout(request, response);
        }
    }

    // METHOD : doGet
    // DOES   : GET requests to /auth?action=logout (logout via link, not form)
    // CALLED : Navbar logout link
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            // Any other GET to /auth redirects to the login page
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    // METHOD : handleLogin
    // DOES   : Reads email and password from the login form,
    //          calls MemberService.login() to verify credentials,
    //          stores member in session on success, or sets error on failure.
    // CALLED : doPost() when action == "login"
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form fields submitted from index.jsp login form
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation: check that neither field is empty before querying DB
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            // Set error message to display on the login form
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return; // stop processing — do not attempt login
        }

        // Call MemberService.login() — this hashes the password and compares to DB
        // Returns Member object if credentials are valid, null if not
        Member loggedMember = memberService.login(email.trim(), password);

        if (loggedMember != null) {
            // ---- LOGIN SUCCESSFUL ----
            // Get or create the HttpSession for this browser
            HttpSession session = request.getSession(true);

            // Store the logged-in member object in the session
            // This is how we know who is logged in across multiple requests
            session.setAttribute("loggedMember", loggedMember);

            // Store the member's role separately for easy access in JSP
            // Role values: "REGULAR_MEMBER" or "PREMIUM_MEMBER"
            session.setAttribute("role", loggedMember.getRole());

            // Store member ID separately for convenience in JSP and servlets
            session.setAttribute("memberId", loggedMember.getMemberId());

            // Set session timeout: 30 minutes of inactivity → auto logout
            session.setMaxInactiveInterval(30 * 60); // 30 minutes in seconds

            // Redirect to dashboard after successful login
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

        } else {
            // ---- LOGIN FAILED ----
            // Set error attribute so index.jsp can display the error message
            request.setAttribute("errorMessage",
                "Invalid email or password. Please try again.");
            // Forward back to login page WITH the error message attribute set
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    // METHOD : handleLogout
    // DOES   : Destroys the current session, clearing all login state.
    //          After logout, the user must log in again to access any page.
    // CALLED : doPost()/doGet() when action == "logout"
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Get the existing session — false means don't create a new one if none exists
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Invalidate destroys the session and clears ALL attributes
            // (loggedMember, role, memberId — all gone)
            session.invalidate();
        }

        // Redirect to login page after logout
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
