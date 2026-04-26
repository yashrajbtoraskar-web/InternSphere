package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentInternshipServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            StudentDAO sDAO = new StudentDAO();
            Student student = sDAO.findByUserId(user.getUserId());
            InternshipDAO iDAO = new InternshipDAO();
            request.setAttribute("student", student);
            request.setAttribute("internships", iDAO.findEligible(student.getCgpa()));
            request.getRequestDispatcher("/jsp/student/internships.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int internshipId = Integer.parseInt(request.getParameter("internshipId"));
        try {
            StudentDAO sDAO = new StudentDAO();
            Student student = sDAO.findByUserId(user.getUserId());
            ApplicationDAO aDAO = new ApplicationDAO();
            InternshipDAO iDAO = new InternshipDAO();
            // Check duplicate
            if (aDAO.isDuplicate(student.getStudentId(), internshipId)) {
                request.getSession().setAttribute("error", "Already applied to this internship.");
                response.sendRedirect(request.getContextPath() + "/student/internships");
                return;
            }
            // Check deadline
            if (iDAO.isDeadlinePassed(internshipId)) {
                request.getSession().setAttribute("error", "Application deadline has passed.");
                response.sendRedirect(request.getContextPath() + "/student/internships");
                return;
            }
            // Apply with transaction
            aDAO.applyWithTransaction(student.getStudentId(), internshipId);
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditDAO.log(user.getUserId(), "APPLIED_INTERNSHIP_" + internshipId, request.getRemoteAddr(), request.getHeader("User-Agent"));
            request.getSession().setAttribute("success", "Application submitted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Application failed: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/student/internships");
    }
}
