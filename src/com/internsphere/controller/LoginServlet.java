package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("ADMIN".equals(user.getRole())) response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            else response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }
        request.getRequestDispatcher("/jsp/landing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                request.setAttribute("error", "Invalid credentials. Access denied.");
                request.getRequestDispatcher("/jsp/landing.jsp").forward(request, response);
                return;
            }
            // Single session enforcement
            SessionTrackingDAO stDAO = new SessionTrackingDAO();
            String existingSession = stDAO.findSessionByUser(user.getUserId());
            if (existingSession != null) {
                stDAO.delete(user.getUserId());
            }
            // Create new session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            // Track session
            String ip = request.getRemoteAddr();
            String ua = request.getHeader("User-Agent");
            stDAO.create(session.getId(), user.getUserId(), ip, ua);
            userDAO.updateLoginStatus(user.getUserId(), true);
            // Audit log
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditDAO.log(user.getUserId(), user.getRole() + "_LOGIN", ip, ua);
            // Redirect based on role
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Try again.");
            request.getRequestDispatcher("/jsp/landing.jsp").forward(request, response);
        }
    }
}
