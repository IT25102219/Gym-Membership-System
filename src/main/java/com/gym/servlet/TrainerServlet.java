
package com.gym.servlet;

import com.gym.model.*;
import com.gym.service.TrainerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


@WebServlet("/trainers")
public class TrainerServlet extends HttpServlet {

    private TrainerService trainerService = new TrainerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                // Admin view: all trainers
                List<Trainer> all = trainerService.getAllTrainers();
                request.setAttribute("trainers", all);
                request.getRequestDispatcher("/trainer/trainerList.jsp").forward(request, response);
                break;

            case "view":
                // Public view: active trainers only
                List<Trainer> active = trainerService.getActiveTrainers();
                request.setAttribute("trainers", active);
                request.getRequestDispatcher("/trainer/viewTrainers.jsp").forward(request, response);
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Trainer toEdit = trainerService.getTrainerById(editId);
                request.setAttribute("trainer", toEdit);
                request.getRequestDispatcher("/trainer/editTrainer.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                trainerService.deleteTrainer(deleteId);
                request.getSession().setAttribute("successMessage", "Trainer deactivated.");
                response.sendRedirect(request.getContextPath() + "/trainers?action=list");
                break;

            case "search":
                String q = request.getParameter("query");
                List<Trainer> found = trainerService.searchTrainers(q != null ? q : "");
                request.setAttribute("trainers", found);
                request.setAttribute("searchQuery", q);
                request.getRequestDispatcher("/trainer/trainerList.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/trainers?action=list");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name           = request.getParameter("name");
            String specialisation = request.getParameter("specialisation");
            int experience        = Integer.parseInt(request.getParameter("experienceYears"));
            String phone          = request.getParameter("phone");
            String email          = request.getParameter("email");
            String trainerType    = request.getParameter("trainerType"); // "PERSONAL" or "GROUP"
            String availability   = request.getParameter("availability");

            Trainer newTrainer;
            if ("PERSONAL".equalsIgnoreCase(trainerType)) {
                newTrainer = new PersonalTrainer(0, name, email, phone, specialisation,
                                                  experience, trainerType, availability, "ACTIVE");
            } else {
                newTrainer = new GroupTrainer(0, name, email, phone, specialisation,
                                               experience, trainerType, availability, "ACTIVE");
            }

            boolean added = trainerService.addTrainer(newTrainer);
            request.getSession().setAttribute(added ? "successMessage" : "errorMessage",
                added ? "Trainer added successfully." : "Failed to add trainer.");
            response.sendRedirect(request.getContextPath() + "/trainers?action=list");

        } else if ("update".equals(action)) {
            int trainerId         = Integer.parseInt(request.getParameter("trainerId"));
            String name           = request.getParameter("name");
            String specialisation = request.getParameter("specialisation");
            int experience        = Integer.parseInt(request.getParameter("experienceYears"));
            String phone          = request.getParameter("phone");
            String email          = request.getParameter("email");
            String trainerType    = request.getParameter("trainerType");
            String availability   = request.getParameter("availability");
            String status         = request.getParameter("status");

            Trainer updated;
            if ("PERSONAL".equalsIgnoreCase(trainerType)) {
                updated = new PersonalTrainer(trainerId, name, email, phone, specialisation,
                                               experience, trainerType, availability, status);
            } else {
                updated = new GroupTrainer(trainerId, name, email, phone, specialisation,
                                            experience, trainerType, availability, status);
            }

            trainerService.updateTrainer(updated);
            request.getSession().setAttribute("successMessage", "Trainer updated.");
            response.sendRedirect(request.getContextPath() + "/trainers?action=list");
        }
    }
}
