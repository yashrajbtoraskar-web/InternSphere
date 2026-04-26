package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class ExamSaveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String selectedOptionStr = request.getParameter("selectedOption");
            String descriptiveAnswer = request.getParameter("descriptiveAnswer");

            Integer selectedOption = (selectedOptionStr != null && !selectedOptionStr.isEmpty()) ? Integer.parseInt(selectedOptionStr) : null;

            AnswerDAO dao = new AnswerDAO();
            dao.upsert(attemptId, questionId, selectedOption, descriptiveAnswer);
            out.print("{\"status\":\"saved\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
