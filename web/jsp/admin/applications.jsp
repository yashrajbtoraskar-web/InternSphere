<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>Application Processing</h1><p>Review, process and assign exams to internship applicants</p></div>

            <% String msg = request.getParameter("msg"); %>
            <% if (msg != null) { %>
                <div class="card" style="margin-bottom:16px;padding:12px 20px;border:1px solid rgba(34,197,94,0.3);background:rgba(34,197,94,0.05);color:#22c55e;font-size:14px">
                    &#10003; <%= msg %>
                </div>
            <% } %>

            <div class="table-container">
                <table>
                    <thead><tr><th>Candidate</th><th>Role</th><th>Company</th><th>Applied</th><th>Status</th><th>Action</th><th>Assign Exam</th></tr></thead>
                    <tbody>
                    <% List<Application> apps = (List<Application>) request.getAttribute("applications");
                       List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                       if (apps != null) for (Application a : apps) { %>
                        <tr>
                            <td><strong><%= a.getStudentName() %></strong><br><span class="text-xs text-muted"><%= a.getStudentEmail() %></span></td>
                            <td><%= a.getInternshipRole() %></td>
                            <td><%= a.getCompanyName() %></td>
                            <td class="text-sm"><%= a.getAppliedDate() %></td>
                            <td><span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/applications" method="POST" class="flex gap-sm">
                                    <input type="hidden" name="applicationId" value="<%= a.getApplicationId() %>">
                                    <select name="status" class="form-control" style="width:auto;padding:4px 8px;font-size:12px">
                                        <option value="APPLIED" <%= "APPLIED".equals(a.getStatus()) ? "selected" : "" %>>Applied</option>
                                        <option value="SHORTLISTED" <%= "SHORTLISTED".equals(a.getStatus()) ? "selected" : "" %>>Shortlisted</option>
                                        <option value="SELECTED" <%= "SELECTED".equals(a.getStatus()) ? "selected" : "" %>>Selected</option>
                                        <option value="REJECTED" <%= "REJECTED".equals(a.getStatus()) ? "selected" : "" %>>Rejected</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-sm">Update</button>
                                </form>
                            </td>
                            <td>
                                <% if ("APPLIED".equals(a.getStatus()) || "SHORTLISTED".equals(a.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/assign-exam" method="POST" class="flex gap-sm" style="align-items:center">
                                    <input type="hidden" name="action" value="assign_internship_exam">
                                    <input type="hidden" name="applicationId" value="<%= a.getApplicationId() %>">
                                    <input type="hidden" name="userId" value="<%= a.getUserId() %>">
                                    <select name="examId" class="form-control" style="width:auto;padding:4px 8px;font-size:11px;max-width:180px" required>
                                        <option value="">Select Exam</option>
                                        <% if (exams != null) for (Exam ex : exams) { %>
                                            <option value="<%= ex.getExamId() %>"><%= ex.getExamName() %> (<%= ex.getExamType() %>)</option>
                                        <% } %>
                                    </select>
                                    <button type="submit" class="btn btn-sm" style="background:rgba(34,197,94,0.15);color:#22c55e;border:1px solid rgba(34,197,94,0.3);font-size:11px;padding:4px 12px">ASSIGN</button>
                                </form>
                                <% } else if ("SELECTED".equals(a.getStatus())) { %>
                                    <span style="color:#22c55e;font-size:12px">&#10003; Placed</span>
                                <% } else if ("REJECTED".equals(a.getStatus())) { %>
                                    <span style="color:#ef4444;font-size:12px">&#10007; Rejected</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
