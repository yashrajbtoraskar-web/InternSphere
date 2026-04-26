package com.internsphere.controller;

import com.internsphere.dao.CompanyDAO;
import com.internsphere.model.Company;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class CompanyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            CompanyDAO dao = new CompanyDAO();
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("editCompany", dao.findById(id));
            }
            request.setAttribute("companies", dao.findAll());
            request.getRequestDispatcher("/jsp/admin/companies.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/companies");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            CompanyDAO dao = new CompanyDAO();
            if ("add".equals(action)) {
                Company c = new Company();
                c.setCompanyName(request.getParameter("companyName"));
                c.setLocation(request.getParameter("location"));
                c.setEligibilityCgpa(new BigDecimal(request.getParameter("eligibilityCgpa")));
                dao.create(c);
            } else if ("update".equals(action)) {
                Company c = new Company();
                c.setCompanyId(Integer.parseInt(request.getParameter("companyId")));
                c.setCompanyName(request.getParameter("companyName"));
                c.setLocation(request.getParameter("location"));
                c.setEligibilityCgpa(new BigDecimal(request.getParameter("eligibilityCgpa")));
                dao.update(c);
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(request.getParameter("companyId")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/admin/companies");
    }
}
