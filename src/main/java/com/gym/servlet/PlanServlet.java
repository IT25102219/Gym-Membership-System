package com.gym.servlet;

import com.gym.model.LongTermPlan;
import com.gym.model.MembershipPlan;
import com.gym.model.ShortTermPlan;
import com.gym.service.PlanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/plans")
public class PlanServlet extends HttpServlet {

    private PlanService planService = new PlanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listPlans(request, response);
                break;
            case "delete":
                deletePlan(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "add":
                response.sendRedirect("plan/addPlan.jsp");
                break;
            default:
                listPlans(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            savePlan(request, response, true);
        } else if ("update".equalsIgnoreCase(action)) {
            savePlan(request, response, false);
        }
    }

    private void listPlans(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MembershipPlan> plans = planService.getAllPlans();
        request.setAttribute("plans", plans);
        request.getRequestDispatcher("plan/plans.jsp").forward(request, response);
    }

    private void deletePlan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        planService.deletePlan(id);
        response.sendRedirect("plans?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MembershipPlan plan = planService.getPlanById(id);
        request.setAttribute("plan", plan);
        request.getRequestDispatcher("plan/editPlan.jsp").forward(request, response);
    }

    private void savePlan(HttpServletRequest request, HttpServletResponse response, boolean isNew) throws IOException {
        String name = request.getParameter("planName");
        int duration = Integer.parseInt(request.getParameter("durationMonths"));
        double price = Double.parseDouble(request.getParameter("price"));
        String features = request.getParameter("features");
        String planType = request.getParameter("planType");
        boolean active = request.getParameter("isActive") != null;

        MembershipPlan plan;
        if ("LONG_TERM".equalsIgnoreCase(planType)) {
            plan = new LongTermPlan(0, name, duration, price, features, planType, active);
        } else {
            plan = new ShortTermPlan(0, name, duration, price, features, planType, active);
        }

        if (!isNew) {
            plan.setPlanId(Integer.parseInt(request.getParameter("planId")));
            planService.updatePlan(plan);
        } else {
            planService.addPlan(plan);
        }
        response.sendRedirect("plans?action=list");
    }
}
