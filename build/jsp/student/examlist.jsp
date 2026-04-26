<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examinations — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/exam.css">
    <style>
        .exam-type-badge { display:inline-block; padding:3px 10px; border-radius:16px; font-size:10px; font-weight:600; letter-spacing:0.5px; margin-left:8px; }
        .exam-type-badge.internship { background:rgba(59,130,246,0.12); color:#3b82f6; border:1px solid rgba(59,130,246,0.25); }
        .exam-type-badge.company { background:rgba(251,191,36,0.12); color:#fbbf24; border:1px solid rgba(251,191,36,0.25); }
        .assigned-tag { display:inline-block; padding:2px 8px; border-radius:10px; font-size:10px; font-weight:600; background:rgba(34,197,94,0.1); color:#22c55e; border:1px solid rgba(34,197,94,0.2); margin-left:6px; }
        .result-tag { display:inline-block; padding:4px 12px; border-radius:16px; font-size:11px; font-weight:600; }
        .result-tag.passed { background:rgba(34,197,94,0.12); color:#22c55e; border:1px solid rgba(34,197,94,0.25); }
        .result-tag.failed { background:rgba(239,68,68,0.1); color:#ef4444; border:1px solid rgba(239,68,68,0.2); }
        .result-tag.pending { background:rgba(59,130,246,0.1); color:#3b82f6; border:1px solid rgba(59,130,246,0.2); }
    </style>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>Examinations</h1><p>Take certification exams to qualify for internship placements</p></div>

            <% List<ExamAssignment> assignments = (List<ExamAssignment>) request.getAttribute("assignments"); %>

            <!-- Assigned Exams Section -->
            <% if (assignments != null && !assignments.isEmpty()) { %>
            <h3 style="font-size:15px;margin-bottom:16px;color:#3b82f6">&#128221; Your Assigned Exams</h3>
            <% for (ExamAssignment ea : assignments) { %>
                <div class="exam-card">
                    <div class="exam-card-header">
                        <div class="exam-icon">&#128196;</div>
                        <div>
                            <div class="exam-title">
                                <%= ea.getExamName() %>
                                <span class="exam-type-badge <%= "COMPANY".equals(ea.getExamType()) ? "company" : "internship" %>">
                                    <%= "COMPANY".equals(ea.getExamType()) ? "&#128640; PPO CODING" : "&#128218; INTERNSHIP" %>
                                </span>
                            </div>
                            <div class="exam-meta"><%= ea.getCompanyName() %> &bull; <%= ea.getInternshipRole() %></div>
                        </div>
                    </div>
                    <div class="exam-stats">
                        <span>Assigned: <%= ea.getAssignedDate() != null ? ea.getAssignedDate().toString().substring(0,10) : "-" %></span>
                    </div>
                    <% if ("PENDING".equals(ea.getResult())) { %>
                        <a href="${pageContext.request.contextPath}/student/exam?examId=<%= ea.getExamId() %>" class="btn btn-primary btn-sm">START EXAM &rarr;</a>
                    <% } else if ("PASSED".equals(ea.getResult())) { %>
                        <div style="display:flex;align-items:center;gap:12px">
                            <span class="result-tag passed">&#10003; PASSED — <%= String.format("%.0f", ea.getScore()) %>/<%= String.format("%.0f", ea.getExamTotalMarks()) %></span>
                            <a href="${pageContext.request.contextPath}/student/results?examId=<%= ea.getExamId() %>" class="btn btn-ghost btn-sm">View Results</a>
                        </div>
                    <% } else if ("FAILED".equals(ea.getResult())) { %>
                        <div style="display:flex;align-items:center;gap:12px">
                            <span class="result-tag failed">&#10007; FAILED — <%= String.format("%.0f", ea.getScore()) %>/<%= String.format("%.0f", ea.getExamTotalMarks()) %></span>
                            <a href="${pageContext.request.contextPath}/student/results?examId=<%= ea.getExamId() %>" class="btn btn-ghost btn-sm">View Results</a>
                        </div>
                    <% } else if ("DISQUALIFIED".equals(ea.getResult())) { %>
                        <span class="result-tag failed">&#9940; DISQUALIFIED</span>
                    <% } %>
                </div>
            <% } %>
            <hr style="border:none;border-top:1px solid rgba(255,255,255,0.06);margin:32px 0">
            <% } %>

            <!-- All Available Exams -->
            <h3 style="font-size:15px;margin-bottom:16px;color:var(--on-surface-muted)">&#128218; All Available Exams</h3>
            <% List<Exam> exams = (List<Exam>) request.getAttribute("exams");
               if (exams != null) for (Exam e : exams) { %>
                <div class="exam-card">
                    <div class="exam-card-header">
                        <div class="exam-icon">&#128196;</div>
                        <div>
                            <div class="exam-title">
                                <%= e.getExamName() %>
                                <% if (e.getExamType() != null) { %>
                                <span class="exam-type-badge <%= "COMPANY".equals(e.getExamType()) ? "company" : "internship" %>">
                                    <%= "COMPANY".equals(e.getExamType()) ? "&#128640; COMPANY" : "&#128218; INTERNSHIP" %>
                                </span>
                                <% } %>
                            </div>
                            <div class="exam-meta"><%= e.getDuration() %> minutes &bull; <%= e.getTotalMarks() %> marks</div>
                        </div>
                    </div>
                    <div class="exam-stats">
                        <span>&#128196; Questions available</span>
                        <span>&#9200; Duration: <%= e.getDuration() %> min</span>
                    </div>
                    <% if (e.getAttemptStatus() != null) { %>
                        <div style="display:flex;align-items:center;gap:8px">
                            <span class="badge badge-<%= e.getAttemptStatus().toLowerCase().replace("_","-") %>"><%= e.getAttemptStatus() %></span>
                            <a href="${pageContext.request.contextPath}/student/results?examId=<%= e.getExamId() %>" class="btn btn-ghost btn-sm">View Results</a>
                        </div>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/student/exam?examId=<%= e.getExamId() %>" class="btn btn-primary btn-sm">START EXAM &rarr;</a>
                    <% } %>
                </div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
