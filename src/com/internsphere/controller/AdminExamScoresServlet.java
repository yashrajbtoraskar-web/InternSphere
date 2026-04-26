package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminExamScoresServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ExamDAO examDAO = new ExamDAO();
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();

            List<Exam> exams = examDAO.findAll();
            request.setAttribute("exams", exams);

            String examIdStr = request.getParameter("examId");
            if (examIdStr != null && !examIdStr.isEmpty()) {
                int examId = Integer.parseInt(examIdStr);
                List<ExamAttempt> attempts = eaDAO.findByExam(examId);
                request.setAttribute("attempts", attempts);
                request.setAttribute("selectedExamId", examIdStr);

                Exam selectedExam = examDAO.findById(examId);
                request.setAttribute("selectedExam", selectedExam);
            }

            // Cheaters
            List<ExamAttempt> cheaters = eaDAO.findCheaters();
            request.setAttribute("cheaters", cheaters);

            request.getRequestDispatcher("/jsp/admin/examscores.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}
