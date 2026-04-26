package com.internsphere.controller;

import com.internsphere.dao.AuditLogDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            AuditLogDAO dao = new AuditLogDAO();
            request.setAttribute("logs", dao.findAll());
            request.setAttribute("suspiciousLogs", dao.findSuspicious());
            request.getRequestDispatcher("/jsp/admin/audit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("/jsp/admin/audit.jsp").forward(request, response);
        }
    }
}
