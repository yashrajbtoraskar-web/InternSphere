package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class SettingsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/common/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            UserDAO uDAO = new UserDAO();
            User dbUser = uDAO.findById(user.getUserId());
            if (!dbUser.getPassword().equals(currentPassword)) {
                request.getSession().setAttribute("error", "Current password is incorrect.");
                response.sendRedirect(request.getContextPath() + "/settings");
                return;
            }
            uDAO.updatePassword(user.getUserId(), newPassword);
            request.getSession().setAttribute("success", "Password updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Settings update failed.");
        }
        response.sendRedirect(request.getContextPath() + "/settings");
    }
}
