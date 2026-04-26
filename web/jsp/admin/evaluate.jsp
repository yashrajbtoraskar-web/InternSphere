<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluate — InternSphere</title>
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
            <div class="page-header"><h1>Subjective Evaluation</h1><p>Grade descriptive answers from exam submissions</p></div>
            <div class="form-group" style="max-width:400px">
                <label>Select Exam</label>
                <form action="${pageContext.request.contextPath}/admin/evaluate" method="GET" class="flex gap-sm">
                    <select name="examId" class="form-control" onchange="this.form.submit()">
                        <option value="">Choose an exam</option>
                        <% List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                           String selId = request.getAttribute("selectedExamId") != null ? request.getAttribute("selectedExamId").toString() : "";
                           if (exams != null) for (Exam e : exams) { %>
                            <option value="<%= e.getExamId() %>" <%= String.valueOf(e.getExamId()).equals(selId) ? "selected" : "" %>><%= e.getExamName() %></option>
                        <% } %>
                    </select>
                </form>
            </div>
            <% List<Answer> answers = (List<Answer>) request.getAttribute("answers");
               if (answers != null && !answers.isEmpty()) { %>
                <div class="table-container mt-lg">
                    <table>
                        <thead><tr><th>Question</th><th>Answer</th><th>Current Marks</th><th>Grade</th></tr></thead>
                        <tbody>
                        <% for (Answer a : answers) { %>
                            <tr>
                                <td style="max-width:300px"><%= a.getQuestionText() %></td>
                                <td style="max-width:300px"><%= a.getDescriptiveAnswer() != null ? a.getDescriptiveAnswer() : "<em>No answer</em>" %></td>
                                <td><%= a.getMarksAwarded() %></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/evaluate" method="POST" class="flex gap-sm items-center">
                                        <input type="hidden" name="answerId" value="<%= a.getAnswerId() %>">
                                        <input type="hidden" name="examId" value="<%= selId %>">
                                        <input type="number" name="marks" class="form-control" style="width:80px;padding:4px 8px" step="0.5" min="0" value="<%= a.getMarksAwarded() %>">
                                        <button type="submit" class="btn btn-primary btn-sm">Save</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else if (selId != null && !selId.isEmpty()) { %>
                <div class="card mt-lg" style="text-align:center;padding:48px;color:var(--on-surface-muted)">No subjective answers to evaluate for this exam.</div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
