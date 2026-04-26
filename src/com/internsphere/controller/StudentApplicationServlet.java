package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentApplicationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            StudentDAO sDAO = new StudentDAO();
            Student student = sDAO.findByUserId(user.getUserId());
            ApplicationDAO aDAO = new ApplicationDAO();
            request.setAttribute("applications", aDAO.findByStudent(student.getStudentId()));
            request.getRequestDispatcher("/jsp/student/applications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
