package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ApplicationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ApplicationDAO dao = new ApplicationDAO();
            request.setAttribute("applications", dao.findAll());

            // Load exams for assignment dropdown
            ExamDAO examDAO = new ExamDAO();
            request.setAttribute("exams", examDAO.findAll());

            request.getRequestDispatcher("/jsp/admin/applications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading applications");
            request.getRequestDispatcher("/jsp/admin/applications.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String status = request.getParameter("status");
        try {
            ApplicationDAO dao = new ApplicationDAO();
            dao.updateStatus(applicationId, status);
            User user = (User) request.getSession().getAttribute("user");
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditDAO.log(user.getUserId(), "APPLICATION_" + status + "_ID:" + applicationId, request.getRemoteAddr(), request.getHeader("User-Agent"));
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/applications");
    }
}
