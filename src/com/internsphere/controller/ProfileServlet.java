package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if ("STUDENT".equals(user.getRole())) {
                StudentDAO sDAO = new StudentDAO();
                request.setAttribute("student", sDAO.findByUserId(user.getUserId()));
            }
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/jsp/common/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/landing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if ("STUDENT".equals(user.getRole())) {
                StudentDAO sDAO = new StudentDAO();
                Student student = sDAO.findByUserId(user.getUserId());
                student.setCourse(request.getParameter("course"));
                student.setCgpa(new BigDecimal(request.getParameter("cgpa")));
                student.setPhone(request.getParameter("phone"));
                sDAO.update(student);
            }
            // Update user name
            user.setName(request.getParameter("name"));
            request.getSession().setAttribute("user", user);
            request.getSession().setAttribute("success", "Profile updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Profile update failed.");
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
