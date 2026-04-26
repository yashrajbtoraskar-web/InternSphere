package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

public class ExamManageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ExamDAO dao = new ExamDAO();
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("editExam", dao.findById(id));
            }
            request.setAttribute("exams", dao.findAll());
            request.getRequestDispatcher("/jsp/admin/exams.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/exams");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            ExamDAO dao = new ExamDAO();
            if ("add".equals(action)) {
                Exam e = new Exam();
                e.setExamName(request.getParameter("examName"));
                e.setDuration(Integer.parseInt(request.getParameter("duration")));
                e.setStartTime(Timestamp.valueOf(request.getParameter("startTime").replace("T", " ") + ":00"));
                e.setEndTime(Timestamp.valueOf(request.getParameter("endTime").replace("T", " ") + ":00"));
                e.setTotalMarks(Integer.parseInt(request.getParameter("totalMarks")));
                dao.create(e);
            } else if ("update".equals(action)) {
                Exam e = new Exam();
                e.setExamId(Integer.parseInt(request.getParameter("examId")));
                e.setExamName(request.getParameter("examName"));
                e.setDuration(Integer.parseInt(request.getParameter("duration")));
                e.setStartTime(Timestamp.valueOf(request.getParameter("startTime").replace("T", " ") + ":00"));
                e.setEndTime(Timestamp.valueOf(request.getParameter("endTime").replace("T", " ") + ":00"));
                e.setTotalMarks(Integer.parseInt(request.getParameter("totalMarks")));
                dao.update(e);
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(request.getParameter("examId")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/exams");
    }
}
