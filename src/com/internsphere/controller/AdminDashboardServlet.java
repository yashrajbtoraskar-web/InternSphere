package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO userDAO = new UserDAO();
            CompanyDAO companyDAO = new CompanyDAO();
            InternshipDAO internshipDAO = new InternshipDAO();
            ApplicationDAO applicationDAO = new ApplicationDAO();
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();

            request.setAttribute("totalStudents", userDAO.getTotalStudents());
            request.setAttribute("totalCompanies", companyDAO.getCount());
            request.setAttribute("selectedCount", internshipDAO.getSelectedCount());
            request.setAttribute("pendingReviews", applicationDAO.getPendingCount());
            request.setAttribute("recentApplications", applicationDAO.findRecent(5));

            // Cheater data for admin dashboard
            List<ExamAttempt> cheaters = eaDAO.findCheaters();
            request.setAttribute("cheaters", cheaters);
            request.setAttribute("cheaterCount", cheaters != null ? cheaters.size() : 0);

            // All exam scores
            ExamDAO examDAO = new ExamDAO();
            List<Exam> exams = examDAO.findAll();
            request.setAttribute("exams", exams);

            // Shortlisted students (passed internship exam) — for PPO test assignment
            ExamAssignmentDAO assignDAO = new ExamAssignmentDAO();
            List<ExamAssignment> shortlisted = assignDAO.findShortlisted();
            request.setAttribute("shortlisted", shortlisted);

            // All exam assignment results
            List<ExamAssignment> allResults = assignDAO.findAll();
            request.setAttribute("allExamResults", allResults);

            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard");
            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
        }
    }
}
