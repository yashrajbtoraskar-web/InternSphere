package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ResultServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            int examId = Integer.parseInt(request.getParameter("examId"));
            ExamDAO eDAO = new ExamDAO();
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            AnswerDAO aDAO = new AnswerDAO();
            Exam exam = eDAO.findById(examId);
            ExamAttempt attempt = eaDAO.findByUserAndExam(user.getUserId(), examId);
            if (attempt != null) {
                request.setAttribute("answers", aDAO.findByAttempt(attempt.getAttemptId()));
                request.setAttribute("totalMarks", aDAO.getTotalMarks(attempt.getAttemptId()));
            }
            request.setAttribute("exam", exam);
            request.setAttribute("attempt", attempt);
            request.getRequestDispatcher("/jsp/student/results.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
