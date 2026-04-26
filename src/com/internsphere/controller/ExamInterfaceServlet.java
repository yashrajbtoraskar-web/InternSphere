package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ExamInterfaceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            int examId = Integer.parseInt(request.getParameter("examId"));
            ExamDAO eDAO = new ExamDAO();
            Exam exam = eDAO.findById(examId);
            if (exam == null) { response.sendRedirect(request.getContextPath() + "/student/dashboard"); return; }

            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            ExamAttempt attempt = eaDAO.findByUserAndExam(user.getUserId(), examId);

            // Check if already submitted
            if (attempt != null && ("SUBMITTED".equals(attempt.getStatus()) || "AUTO_SUBMITTED".equals(attempt.getStatus()))) {
                request.getSession().setAttribute("error", "You have already submitted this exam.");
                response.sendRedirect(request.getContextPath() + "/student/results?examId=" + examId);
                return;
            }

            // Create attempt if new
            if (attempt == null) {
                int attemptId = eaDAO.create(user.getUserId(), examId);
                attempt = eaDAO.findById(attemptId);
                AuditLogDAO auditDAO = new AuditLogDAO();
                auditDAO.log(user.getUserId(), "EXAM_STARTED_" + examId, request.getRemoteAddr(), request.getHeader("User-Agent"));
            }

            QuestionDAO qDAO = new QuestionDAO();
            List<Question> questions = qDAO.findByExam(examId);

            // Load existing answers
            AnswerDAO aDAO = new AnswerDAO();
            List<Answer> answers = aDAO.findByAttempt(attempt.getAttemptId());

            request.setAttribute("exam", exam);
            request.setAttribute("attempt", attempt);
            request.setAttribute("questions", questions);
            request.setAttribute("savedAnswers", answers);
            request.getRequestDispatcher("/jsp/student/exam.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
