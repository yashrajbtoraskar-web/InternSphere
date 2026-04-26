<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examinations — InternSphere</title>
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
            <div class="page-header"><h1>Examination Management</h1><p>Create and manage certification exams</p></div>
            <% Exam editE = (Exam) request.getAttribute("editExam"); %>
            <div class="inline-form">
                <h3><%= editE != null ? "Edit Exam" : "Create New Exam" %></h3>
                <form action="${pageContext.request.contextPath}/admin/exams" method="POST">
                    <input type="hidden" name="action" value="<%= editE != null ? "update" : "add" %>">
                    <% if (editE != null) { %><input type="hidden" name="examId" value="<%= editE.getExamId() %>"><% } %>
                    <div class="form-row">
                        <div class="form-group"><label>Exam Name</label><input type="text" name="examName" class="form-control" value="<%= editE != null ? editE.getExamName() : "" %>" required></div>
                        <div class="form-group"><label>Duration (minutes)</label><input type="number" name="duration" class="form-control" value="<%= editE != null ? editE.getDuration() : "" %>" required min="1"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Start Time</label><input type="datetime-local" name="startTime" class="form-control" required></div>
                        <div class="form-group"><label>End Time</label><input type="datetime-local" name="endTime" class="form-control" required></div>
                    </div>
                    <div class="form-group"><label>Total Marks</label><input type="number" name="totalMarks" class="form-control" value="<%= editE != null ? editE.getTotalMarks() : "" %>" required min="1"></div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><%= editE != null ? "Update" : "Create Exam" %></button>
                    </div>
                </form>
            </div>
            <div class="table-container">
                <table>
                    <thead><tr><th>Exam</th><th>Duration</th><th>Total Marks</th><th>Questions</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                       if (exams != null) for (Exam e : exams) { %>
                        <tr>
                            <td><strong><%= e.getExamName() %></strong><br><span class="text-xs text-muted"><%= e.getStartTime() %></span></td>
                            <td><%= e.getDuration() %> min</td>
                            <td><%= e.getTotalMarks() %></td>
                            <td><%= e.getQuestionCount() %></td>
                            <td class="flex gap-sm">
                                <a href="${pageContext.request.contextPath}/admin/questions?examId=<%= e.getExamId() %>" class="btn btn-primary btn-sm">Questions</a>
                                <a href="${pageContext.request.contextPath}/admin/exams?action=edit&id=<%= e.getExamId() %>" class="btn btn-ghost btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/exams" method="POST" style="display:inline" onsubmit="return confirm('Delete?')">
                                    <input type="hidden" name="action" value="delete"><input type="hidden" name="examId" value="<%= e.getExamId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
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
