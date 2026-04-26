<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Questions — InternSphere</title>
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
            <% Exam exam = (Exam) request.getAttribute("exam"); %>
            <div class="page-header">
                <h1>Question Bank</h1>
                <p>Managing questions for: <strong><%= exam != null ? exam.getExamName() : "" %></strong></p>
            </div>

            <div class="inline-form">
                <h3>Add Question</h3>
                <form action="${pageContext.request.contextPath}/admin/questions" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="examId" value="<%= exam != null ? exam.getExamId() : "" %>">
                    <div class="form-row">
                        <div class="form-group"><label>Question Type</label>
                            <select name="type" class="form-control" id="qType" onchange="toggleOptions()">
                                <option value="MCQ">MCQ</option>
                                <option value="SUBJECTIVE">Subjective</option>
                            </select>
                        </div>
                        <div class="form-group"><label>Marks</label><input type="number" name="marks" class="form-control" min="1" required></div>
                    </div>
                    <div class="form-group"><label>Question Text</label><textarea name="questionText" class="form-control" required></textarea></div>
                    <div id="optionsSection" class="options-builder">
                        <label style="font-size:12px;color:var(--on-surface-muted);margin-bottom:8px;display:block">MCQ Options (select correct answer)</label>
                        <div class="option-row"><input type="radio" name="correctOption" value="0" checked><input type="text" name="optionText" class="form-control" placeholder="Option A" required></div>
                        <div class="option-row"><input type="radio" name="correctOption" value="1"><input type="text" name="optionText" class="form-control" placeholder="Option B" required></div>
                        <div class="option-row"><input type="radio" name="correctOption" value="2"><input type="text" name="optionText" class="form-control" placeholder="Option C" required></div>
                        <div class="option-row"><input type="radio" name="correctOption" value="3"><input type="text" name="optionText" class="form-control" placeholder="Option D" required></div>
                    </div>
                    <div class="form-actions"><button type="submit" class="btn btn-primary">Add Question</button></div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead><tr><th>#</th><th>Question</th><th>Type</th><th>Marks</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% List<Question> questions = (List<Question>) request.getAttribute("questions");
                       int qNum = 1;
                       if (questions != null) for (Question q : questions) { %>
                        <tr>
                            <td><%= qNum++ %></td>
                            <td style="max-width:400px"><%= q.getQuestionText() %>
                                <% if ("MCQ".equals(q.getType()) && q.getOptions() != null) { %>
                                    <div style="margin-top:6px">
                                    <% for (Option o : q.getOptions()) { %>
                                        <span class="text-xs" style="display:block;color:var(--on-surface-muted);padding:2px 0"><%= o.isCorrect() ? "&#10003;" : "&#9675;" %> <%= o.getOptionText() %></span>
                                    <% } %>
                                    </div>
                                <% } %>
                            </td>
                            <td><span class="badge badge-<%= q.getType().equals("MCQ") ? "in-progress" : "applied" %>"><%= q.getType() %></span></td>
                            <td><%= q.getMarks() %></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/questions" method="POST" onsubmit="return confirm('Delete?')">
                                    <input type="hidden" name="action" value="delete"><input type="hidden" name="questionId" value="<%= q.getQuestionId() %>"><input type="hidden" name="examId" value="<%= exam.getExamId() %>">
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
<script>
function toggleOptions() {
    document.getElementById('optionsSection').style.display = document.getElementById('qType').value === 'MCQ' ? 'block' : 'none';
}
</script>
</body>
</html>
