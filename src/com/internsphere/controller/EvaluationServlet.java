package com.internsphere.controller;

import com.internsphere.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class EvaluationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ExamDAO eDAO = new ExamDAO();
            request.setAttribute("exams", eDAO.findAll());
            String examIdStr = request.getParameter("examId");
            if (examIdStr != null) {
                int examId = Integer.parseInt(examIdStr);
                AnswerDAO aDAO = new AnswerDAO();
                request.setAttribute("answers", aDAO.findSubjectiveByExam(examId));
                request.setAttribute("selectedExamId", examId);
            }
            request.getRequestDispatcher("/jsp/admin/evaluate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/evaluate");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int answerId = Integer.parseInt(request.getParameter("answerId"));
        BigDecimal marks = new BigDecimal(request.getParameter("marks"));
        String examId = request.getParameter("examId");
        try {
            AnswerDAO dao = new AnswerDAO();
            dao.gradeSubjective(answerId, marks);
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/evaluate?examId=" + examId);
    }
}
