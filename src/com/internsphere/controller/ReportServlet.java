package com.internsphere.controller;

import com.internsphere.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class ReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        try {
            ReportDAO dao = new ReportDAO();
            ExamDAO examDAO = new ExamDAO();
            request.setAttribute("exams", examDAO.findAll());
            if (type != null) {
                List<Map<String, Object>> data = null;
                switch (type) {
                    case "1": data = dao.studentsPerCompany(); request.setAttribute("reportTitle", "Students Selected Per Company"); break;
                    case "2": data = dao.applicationCountByInternship(); request.setAttribute("reportTitle", "Internship-wise Application Count"); break;
                    case "3":
                        int examId = Integer.parseInt(request.getParameter("examId"));
                        data = dao.examRankList(examId);
                        request.setAttribute("reportTitle", "Exam Rank List");
                        break;
                    case "4":
                        examId = Integer.parseInt(request.getParameter("examId"));
                        data = dao.questionAnalysis(examId);
                        request.setAttribute("reportTitle", "Question-wise Performance Analysis");
                        break;
                    case "5": data = dao.suspiciousLogs(); request.setAttribute("reportTitle", "Suspicious Activity Logs"); break;
                }
                request.setAttribute("reportData", data);
                request.setAttribute("selectedType", type);
            }
            request.getRequestDispatcher("/jsp/admin/reports.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("/jsp/admin/reports.jsp").forward(request, response);
        }
    }
}
