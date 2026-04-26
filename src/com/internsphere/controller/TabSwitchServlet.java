package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class TabSwitchServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            User user = (User) request.getSession().getAttribute("user");
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int examId = Integer.parseInt(request.getParameter("examId"));

            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            eaDAO.incrementTabSwitch(attemptId);
            int count = eaDAO.getTabSwitchCount(attemptId);

            AuditLogDAO auditDAO = new AuditLogDAO();
            auditDAO.log(user.getUserId(), "TAB_SWITCH_" + count + "_EXAM_" + examId,
                request.getRemoteAddr(), request.getHeader("User-Agent"));

            out.print("{\"tabSwitchCount\":" + count + ",\"maxReached\":" + (count >= 2) + "}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
