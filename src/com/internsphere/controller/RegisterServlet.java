package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String course = request.getParameter("course");
        String cgpaStr = request.getParameter("cgpa");
        String phone = request.getParameter("phone");
        try {
            UserDAO userDAO = new UserDAO();
            if (userDAO.findByEmail(email) != null) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                return;
            }
            User user = new User(name, email, password, "STUDENT");
            int userId = userDAO.create(user);
            StudentDAO studentDAO = new StudentDAO();
            Student student = new Student();
            student.setStudentId(studentDAO.getNextStudentId());
            student.setUserId(userId);
            student.setCourse(course);
            student.setCgpa(new BigDecimal(cgpaStr));
            student.setPhone(phone);
            studentDAO.create(student);
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditDAO.log(userId, "STUDENT_REGISTERED", request.getRemoteAddr(), request.getHeader("User-Agent"));
            request.setAttribute("success", "Registration successful. Initialize your session.");
            request.getRequestDispatcher("/jsp/landing.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
}
