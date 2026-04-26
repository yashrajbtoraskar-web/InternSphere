package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.Internship;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

public class InternshipServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            InternshipDAO iDAO = new InternshipDAO();
            CompanyDAO cDAO = new CompanyDAO();
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("editInternship", iDAO.findById(id));
            }
            request.setAttribute("internships", iDAO.findAll());
            request.setAttribute("companies", cDAO.findAll());
            request.getRequestDispatcher("/jsp/admin/internships.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/internships");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            InternshipDAO dao = new InternshipDAO();
            if ("add".equals(action)) {
                Internship i = new Internship();
                i.setCompanyId(Integer.parseInt(request.getParameter("companyId")));
                i.setRole(request.getParameter("role"));
                i.setStipend(new BigDecimal(request.getParameter("stipend")));
                i.setDeadline(Date.valueOf(request.getParameter("deadline")));
                dao.create(i);
            } else if ("update".equals(action)) {
                Internship i = new Internship();
                i.setInternshipId(Integer.parseInt(request.getParameter("internshipId")));
                i.setCompanyId(Integer.parseInt(request.getParameter("companyId")));
                i.setRole(request.getParameter("role"));
                i.setStipend(new BigDecimal(request.getParameter("stipend")));
                i.setDeadline(Date.valueOf(request.getParameter("deadline")));
                dao.update(i);
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(request.getParameter("internshipId")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/internships");
    }
}
