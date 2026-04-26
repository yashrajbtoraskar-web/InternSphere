package com.internsphere.controller;

import com.internsphere.dao.*;
import com.internsphere.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            StudentDAO sDAO = new StudentDAO();
            Student student = sDAO.findByUserId(user.getUserId());
            request.setAttribute("student", student);

            InternshipDAO iDAO = new InternshipDAO();
            request.setAttribute("opportunities", iDAO.findEligible(student.getCgpa()));

            ApplicationDAO aDAO = new ApplicationDAO();
            request.setAttribute("appliedCount", aDAO.getCountByStudent(student.getStudentId(), null));
            request.setAttribute("selectedCount", aDAO.getCountByStudent(student.getStudentId(), "SELECTED"));
            request.setAttribute("shortlistedCount", aDAO.getCountByStudent(student.getStudentId(), "SHORTLISTED"));

            // Latest exam result for dashboard
            ExamAttemptDAO eaDAO = new ExamAttemptDAO();
            ExamAttempt latestExam = eaDAO.findLatestCompleted(user.getUserId());
            request.setAttribute("latestExam", latestExam);

            // Exam assignments — pending exams and results
            ExamAssignmentDAO assignDAO = new ExamAssignmentDAO();
            List<ExamAssignment> allAssignments = assignDAO.findByUser(user.getUserId());
            List<ExamAssignment> pendingAssignments = assignDAO.findPendingByUser(user.getUserId());
            request.setAttribute("examAssignments", allAssignments);
            request.setAttribute("pendingExams", pendingAssignments);

            // Find latest result for congratulation/sorry messages
            ExamAssignment latestResult = assignDAO.findLatestResult(user.getUserId());
            request.setAttribute("latestAssignment", latestResult);

            // Available exams count
            ExamDAO examDAO = new ExamDAO();
            List<Exam> exams = examDAO.findAll();
            request.setAttribute("totalExams", exams != null ? exams.size() : 0);

            request.getRequestDispatcher("/jsp/student/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("/jsp/student/dashboard.jsp").forward(request, response);
        }
    }
}
