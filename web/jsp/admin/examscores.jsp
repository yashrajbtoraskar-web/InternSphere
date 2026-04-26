<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Scores & Cheating Report — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>Exam Scores & Integrity Report</h1><p>View all student scores and cheating violations</p></div>

            <!-- Cheaters Section -->
            <% List<ExamAttempt> cheaters = (List<ExamAttempt>) request.getAttribute("cheaters"); %>
            <% if (cheaters != null && !cheaters.isEmpty()) { %>
            <div class="card" style="margin-bottom:24px;border:1px solid rgba(239,68,68,0.3);background:rgba(239,68,68,0.05)">
                <div style="padding:20px 24px;border-bottom:1px solid rgba(239,68,68,0.15)">
                    <h3 style="color:#ef4444;font-size:16px">&#9888; Cheating Violations (<%= cheaters.size() %> detected)</h3>
                </div>
                <div style="overflow-x:auto">
                    <table class="data-table">
                        <thead><tr>
                            <th>Student</th><th>Email</th><th>Exam</th><th>Tab Switches</th><th>Status</th><th>Score</th>
                        </tr></thead>
                        <tbody>
                        <% for (ExamAttempt ch : cheaters) { %>
                            <tr>
                                <td><strong><%= ch.getStudentName() %></strong></td>
                                <td><%= ch.getStudentEmail() %></td>
                                <td><%= ch.getExamName() %></td>
                                <td><span style="color:#ef4444;font-weight:700"><%= ch.getTabSwitchCount() %></span></td>
                                <td>
                                    <% if ("DISQUALIFIED".equals(ch.getStatus())) { %>
                                        <span class="status-badge" style="background:rgba(239,68,68,0.15);color:#ef4444;border:1px solid rgba(239,68,68,0.3)">DISQUALIFIED</span>
                                    <% } else { %>
                                        <span class="status-badge" style="background:rgba(251,191,36,0.15);color:#fbbf24;border:1px solid rgba(251,191,36,0.3)">SUSPICIOUS</span>
                                    <% } %>
                                </td>
                                <td style="color:#ef4444;font-weight:700"><%= String.format("%.0f", ch.getTotalMarks()) %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <div class="card" style="margin-bottom:24px;padding:20px 24px;color:#22c55e;border:1px solid rgba(34,197,94,0.2);background:rgba(34,197,94,0.03)">
                &#10003; No cheating violations detected — all exams are clean.
            </div>
            <% } %>

            <!-- Exam Score Viewer -->
            <div class="card">
                <div style="padding:20px 24px;border-bottom:1px solid rgba(255,255,255,0.06)">
                    <h3 style="font-size:16px;margin-bottom:12px">View Scores by Exam</h3>
                    <form method="GET" action="${pageContext.request.contextPath}/admin/examscores" style="display:flex;gap:12px;align-items:center">
                        <select name="examId" class="form-input" style="max-width:400px" required>
                            <option value="">Select an Exam</option>
                            <% List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                               String selId = (String) request.getAttribute("selectedExamId");
                               if (exams != null) for (Exam e : exams) { %>
                                <option value="<%= e.getExamId() %>" <%= String.valueOf(e.getExamId()).equals(selId) ? "selected" : "" %>><%= e.getExamName() %> (<%= e.getTotalMarks() %> marks)</option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn btn-primary">VIEW SCORES</button>
                    </form>
                </div>

                <% List<ExamAttempt> attempts = (List<ExamAttempt>) request.getAttribute("attempts");
                   Exam selectedExam = (Exam) request.getAttribute("selectedExam");
                   if (attempts != null) { %>
                <div style="padding:16px 24px;background:rgba(185,28,28,0.05);border-bottom:1px solid rgba(255,255,255,0.06)">
                    <strong><%= selectedExam != null ? selectedExam.getExamName() : "Exam" %></strong> &bull; 
                    <%= attempts.size() %> students attempted &bull; 
                    Total marks: <%= selectedExam != null ? selectedExam.getTotalMarks() : "-" %>
                </div>
                <div style="overflow-x:auto">
                    <table class="data-table">
                        <thead><tr>
                            <th>Rank</th><th>Student</th><th>Email</th><th>Score</th><th>Percentage</th><th>Tab Switches</th><th>Status</th><th>Submitted</th>
                        </tr></thead>
                        <tbody>
                        <% int rank = 1;
                           for (ExamAttempt a : attempts) {
                               double pct = selectedExam != null && selectedExam.getTotalMarks() > 0 ?
                                   (a.getTotalMarks() / selectedExam.getTotalMarks()) * 100 : 0;
                        %>
                            <tr style="<%= "DISQUALIFIED".equals(a.getStatus()) ? "background:rgba(239,68,68,0.05)" : "" %>">
                                <td><strong>#<%= rank++ %></strong></td>
                                <td><strong><%= a.getStudentName() %></strong></td>
                                <td style="color:var(--on-surface-muted)"><%= a.getStudentEmail() %></td>
                                <td style="font-weight:700;color:<%= "DISQUALIFIED".equals(a.getStatus()) ? "#ef4444" : pct >= 60 ? "#22c55e" : pct >= 40 ? "#fbbf24" : "#ef4444" %>">
                                    <%= String.format("%.0f", a.getTotalMarks()) %>/<%= selectedExam != null ? selectedExam.getTotalMarks() : "-" %>
                                </td>
                                <td><%= String.format("%.1f", pct) %>%</td>
                                <td style="color:<%= a.getTabSwitchCount() > 0 ? "#ef4444" : "#22c55e" %>"><%= a.getTabSwitchCount() %></td>
                                <td>
                                    <% if ("DISQUALIFIED".equals(a.getStatus())) { %>
                                        <span class="status-badge" style="background:rgba(239,68,68,0.15);color:#ef4444">DISQUALIFIED</span>
                                    <% } else if ("SUBMITTED".equals(a.getStatus())) { %>
                                        <span class="status-badge" style="background:rgba(34,197,94,0.15);color:#22c55e">SUBMITTED</span>
                                    <% } else if ("AUTO_SUBMITTED".equals(a.getStatus())) { %>
                                        <span class="status-badge" style="background:rgba(251,191,36,0.15);color:#fbbf24">AUTO-SUBMIT</span>
                                    <% } else { %>
                                        <span class="status-badge"><%= a.getStatus() %></span>
                                    <% } %>
                                </td>
                                <td style="color:var(--on-surface-muted);font-size:12px"><%= a.getEndTime() != null ? a.getEndTime() : "In Progress" %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
