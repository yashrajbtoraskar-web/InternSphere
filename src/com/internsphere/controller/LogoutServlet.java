package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                try {
                    SessionTrackingDAO stDAO = new SessionTrackingDAO();
                    stDAO.deleteBySessionId(session.getId());
                    UserDAO userDAO = new UserDAO();
                    userDAO.updateLoginStatus(user.getUserId(), false);
                    AuditLogDAO auditDAO = new AuditLogDAO();
                    auditDAO.log(user.getUserId(), "LOGOUT", request.getRemoteAddr(), request.getHeader("User-Agent"));
                } catch (Exception e) { e.printStackTrace(); }
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/landing");
    }
}
