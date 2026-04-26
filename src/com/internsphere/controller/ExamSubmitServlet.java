package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ExamSubmitServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int examId = Integer.parseInt(request.getParameter("examId"));
            String submitType = request.getParameter("submitType");

            AnswerDAO aDAO = new AnswerDAO();
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            AuditLogDAO auditDAO = new AuditLogDAO();
            ExamDAO examDAO = new ExamDAO();
            ExamAssignmentDAO assignDAO = new ExamAssignmentDAO();

            if ("cheat".equals(submitType)) {
                // Cheating detected — set all marks to 0 and mark as DISQUALIFIED
                aDAO.zeroAllMarks(attemptId);
                eaDAO.updateStatus(attemptId, "DISQUALIFIED");
                eaDAO.updateTabSwitchCount(attemptId, 2);
                auditDAO.log(user.getUserId(), "EXAM_DISQUALIFIED_CHEATING_" + examId,
                    request.getRemoteAddr(), request.getHeader("User-Agent"));

                // Update exam assignment result
                assignDAO.updateResult(user.getUserId(), examId, "DISQUALIFIED", 0);

                response.setContentType("application/json");
                response.getWriter().print("{\"status\":\"disqualified\"}");
            } else if ("auto".equals(submitType)) {
                aDAO.submitAndEvaluate(attemptId);
                eaDAO.updateStatus(attemptId, "AUTO_SUBMITTED");
                auditDAO.log(user.getUserId(), "EXAM_AUTO_SUBMITTED_" + examId,
                    request.getRemoteAddr(), request.getHeader("User-Agent"));

                // Calculate pass/fail
                evaluateResult(user.getUserId(), examId, attemptId, aDAO, examDAO, assignDAO);

                response.setContentType("application/json");
                response.getWriter().print("{\"status\":\"auto_submitted\"}");
            } else {
                aDAO.submitAndEvaluate(attemptId);
                eaDAO.updateStatus(attemptId, "SUBMITTED");
                auditDAO.log(user.getUserId(), "EXAM_SUBMITTED_" + examId,
                    request.getRemoteAddr(), request.getHeader("User-Agent"));

                // Calculate pass/fail
                evaluateResult(user.getUserId(), examId, attemptId, aDAO, examDAO, assignDAO);

                response.sendRedirect(request.getContextPath() + "/student/results?examId=" + examId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }

    /**
     * Evaluate exam result - determine if student passed or failed based on passing percentage
     */
    private void evaluateResult(int userId, int examId, int attemptId,
            AnswerDAO aDAO, ExamDAO examDAO, ExamAssignmentDAO assignDAO) {
        try {
            double totalMarksScored = aDAO.getTotalMarks(attemptId);
            Exam exam = examDAO.findById(examId);
            if (exam != null) {
                double percentage = (totalMarksScored / exam.getTotalMarks()) * 100;
                String result = percentage >= exam.getPassingPercentage() ? "PASSED" : "FAILED";
                assignDAO.updateResult(userId, examId, result, totalMarksScored);

                // If passed internship exam, update application status
                if ("PASSED".equals(result) && "INTERNSHIP".equals(exam.getExamType())) {
                    int appId = assignDAO.getApplicationIdForUser(userId, examId);
                    if (appId > 0) {
                        ApplicationDAO appDAO = new ApplicationDAO();
                        appDAO.updateStatus(appId, "SHORTLISTED");
                    }
                }
                // If passed company exam, update application to SELECTED
                if ("PASSED".equals(result) && "COMPANY".equals(exam.getExamType())) {
                    int appId = assignDAO.getApplicationIdForUser(userId, examId);
                    if (appId > 0) {
                        ApplicationDAO appDAO = new ApplicationDAO();
                        appDAO.updateStatus(appId, "SELECTED");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
