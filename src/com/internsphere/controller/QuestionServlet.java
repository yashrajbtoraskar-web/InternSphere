package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class QuestionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int examId = Integer.parseInt(request.getParameter("examId"));
            QuestionDAO qDAO = new QuestionDAO();
            ExamDAO eDAO = new ExamDAO();
            request.setAttribute("exam", eDAO.findById(examId));
            request.setAttribute("questions", qDAO.findByExam(examId));
            request.getRequestDispatcher("/jsp/admin/questions.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/exams");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int examId = Integer.parseInt(request.getParameter("examId"));
        try {
            QuestionDAO dao = new QuestionDAO();
            if ("add".equals(action)) {
                Question q = new Question();
                q.setExamId(examId);
                q.setQuestionText(request.getParameter("questionText"));
                q.setType(request.getParameter("type"));
                q.setMarks(Integer.parseInt(request.getParameter("marks")));
                if ("MCQ".equals(q.getType())) {
                    List<Option> options = new ArrayList<>();
                    String[] optTexts = request.getParameterValues("optionText");
                    String correctIdx = request.getParameter("correctOption");
                    if (optTexts != null) {
                        for (int i = 0; i < optTexts.length; i++) {
                            Option opt = new Option();
                            opt.setOptionText(optTexts[i]);
                            opt.setCorrect(String.valueOf(i).equals(correctIdx));
                            options.add(opt);
                        }
                    }
                    q.setOptions(options);
                }
                dao.create(q);
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(request.getParameter("questionId")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
    }
}
