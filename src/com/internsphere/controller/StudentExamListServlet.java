package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentExamListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            ExamAssignmentDAO assignDAO = new ExamAssignmentDAO();
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            ExamDAO examDAO = new ExamDAO();

            // Get assigned exams for this student
            List<ExamAssignment> assignments = assignDAO.findByUser(user.getUserId());
            request.setAttribute("assignments", assignments);

            // Also provide all exams with attempt status for general exam list
            List<Exam> exams = examDAO.findAll();
            for (Exam e : exams) {
                ExamAttempt attempt = eaDAO.findByUserAndExam(user.getUserId(), e.getExamId());
                if (attempt != null) {
                    e.setAttemptStatus(attempt.getStatus());
                    e.setAttemptScore(attempt.getTotalMarks());
                }
            }
            request.setAttribute("exams", exams);

            request.getRequestDispatcher("/jsp/student/examlist.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
