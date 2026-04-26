package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Handles admin assigning exams to students who applied for internships.
 * Also handles assigning PPO (company) tests to shortlisted students.
 */
public class AdminAssignExamServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User admin = (User) request.getSession().getAttribute("user");
            String action = request.getParameter("action");
            ExamAssignmentDAO eaDAO = new ExamAssignmentDAO();
            ApplicationDAO appDAO = new ApplicationDAO();
            AuditLogDAO auditDAO = new AuditLogDAO();

            if ("assign_internship_exam".equals(action)) {
                int applicationId = Integer.parseInt(request.getParameter("applicationId"));
                int examId = Integer.parseInt(request.getParameter("examId"));
                int userId = Integer.parseInt(request.getParameter("userId"));

                eaDAO.assign(applicationId, examId, userId, admin.getUserId());
                // Update application status to SHORTLISTED
                appDAO.updateStatus(applicationId, "SHORTLISTED");

                auditDAO.log(admin.getUserId(), "ASSIGN_INTERNSHIP_EXAM_" + examId + "_TO_USER_" + userId,
                    request.getRemoteAddr(), request.getHeader("User-Agent"));
                response.sendRedirect(request.getContextPath() + "/admin/applications");

            } else if ("assign_ppo_test".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                // Find PPO (company) exam
                ExamDAO examDAO = new ExamDAO();
                List<Exam> companyExams = examDAO.findByType("COMPANY");
                if (!companyExams.isEmpty()) {
                    int examId = companyExams.get(0).getExamId();
                    // Find the user's application that passed internship
                    List<ExamAssignment> assignments = eaDAO.findByUser(userId);
                    int appId = -1;
                    for (ExamAssignment a : assignments) {
                        if ("PASSED".equals(a.getResult()) && "INTERNSHIP".equals(a.getExamType())) {
                            appId = a.getApplicationId();
                            break;
                        }
                    }
                    if (appId > 0) {
                        eaDAO.assign(appId, examId, userId, admin.getUserId());
                        auditDAO.log(admin.getUserId(), "ASSIGN_PPO_TEST_" + examId + "_TO_USER_" + userId,
                            request.getRemoteAddr(), request.getHeader("User-Agent"));
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}
