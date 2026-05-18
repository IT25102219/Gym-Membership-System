
package com.gym.servlet;

import com.gym.model.*;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "active"; 

        switch (action) {
            case "list":
                
                List<MembershipPlan> allPlans = planService.getAllPlans();
                request.setAttribute("plans", allPlans);
                request.getRequestDispatcher("/plan/planList.jsp").forward(request, response);
                break;

            case "active":
               
                List<MembershipPlan> activePlans = planService.getActivePlans();
                request.setAttribute("plans", activePlans);
                request.getRequestDispatcher("/plan/plans.jsp").forward(request, response);
                break;

            case "edit":
               
                int editId = Integer.parseInt(request.getParameter("id"));
                MembershipPlan planToEdit = planService.getPlanById(editId);
                request.setAttribute("plan", planToEdit);
                request.getRequestDispatcher("/plan/editPlan.jsp").forward(request, response);
                break;

            case "delete":
               
                int deleteId = Integer.parseInt(request.getParameter("id"));
                planService.deletePlan(deleteId);
                request.getSession().setAttribute("successMessage", "Plan deactivated.");
                response.sendRedirect(request.getContextPath() + "/plans?action=list");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/plans?action=active");
        }
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
           
            String planName     = request.getParameter("planName");
            int durationMonths  = Integer.parseInt(request.getParameter("durationMonths"));
            double price        = Double.parseDouble(request.getParameter("price"));
            String features     = request.getParameter("features");
            String planType     = request.getParameter("planType"); // "SHORT_TERM" or "LONG_TERM"

            
            MembershipPlan newPlan;
            if ("LONG_TERM".equalsIgnoreCase(planType)) {
               
                newPlan = new LongTermPlan(0, planName, durationMonths, price, features, planType, true);
            } else {
                
                newPlan = new ShortTermPlan(0, planName, durationMonths, price, features, planType, true);
            }

            boolean added = planService.addPlan(newPlan);
            if (added) {
                request.getSession().setAttribute("successMessage", "Plan added successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add plan.");
            }
            response.sendRedirect(request.getContextPath() + "/plans?action=list");

        } else if ("update".equals(action)) {
            int planId         = Integer.parseInt(request.getParameter("planId"));
            String planName    = request.getParameter("planName");
            int duration       = Integer.parseInt(request.getParameter("durationMonths"));
            double price       = Double.parseDouble(request.getParameter("price"));
            String features    = request.getParameter("features");
            String planType    = request.getParameter("planType");
            boolean isActive   = "true".equals(request.getParameter("isActive"));

            
            MembershipPlan updated;
            if ("LONG_TERM".equalsIgnoreCase(planType)) {
                updated = new LongTermPlan(planId, planName, duration, price, features, planType, isActive);
            } else {
                updated = new ShortTermPlan(planId, planName, duration, price, features, planType, isActive);
            }

            planService.updatePlan(updated);
            request.getSession().setAttribute("successMessage", "Plan updated successfully.");
            response.sendRedirect(request.getContextPath() + "/plans?action=list");
        }
    }
}
