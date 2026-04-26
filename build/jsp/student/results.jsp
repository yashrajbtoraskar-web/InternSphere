<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List, java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Results — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .result-header { text-align:center; padding:32px 0; margin-bottom:32px; border-radius:16px; position:relative; overflow:hidden; }
        .result-header.passed { background:linear-gradient(135deg,rgba(34,197,94,0.1),rgba(59,130,246,0.05)); border:1px solid rgba(34,197,94,0.25); }
        .result-header.failed { background:linear-gradient(135deg,rgba(239,68,68,0.1),rgba(100,100,100,0.03)); border:1px solid rgba(239,68,68,0.2); }
        .result-emoji { font-size:52px; margin-bottom:12px; }
        .result-title { font-size:24px; font-weight:700; margin-bottom:8px; }
        .result-subtitle { font-size:14px; opacity:0.7; }
        .result-score { font-size:48px; font-weight:700; margin:16px 0 4px; }
        .result-pct { font-size:14px; opacity:0.6; }
        .section-divider { background:rgba(185,28,28,0.08); border:1px solid rgba(185,28,28,0.15); border-radius:12px; padding:12px 20px; margin:24px 0 16px; font-size:13px; font-weight:600; color:var(--primary); letter-spacing:1px; display:flex; justify-content:space-between; align-items:center; }
        .q-review { background:rgba(255,255,255,0.025); border:1px solid rgba(255,255,255,0.06); border-radius:14px; padding:24px; margin-bottom:16px; }
        .q-review .q-num { font-size:11px; letter-spacing:1.5px; text-transform:uppercase; color:var(--primary); margin-bottom:8px; }
        .q-review .q-text { font-size:15px; line-height:1.6; color:#e0e0e0; margin-bottom:16px; }
        .q-review .answer-row { display:flex; gap:12px; margin-bottom:8px; font-size:13px; align-items:flex-start; }
        .q-review .answer-label { min-width:100px; font-weight:600; font-size:11px; letter-spacing:0.5px; padding:3px 0; }
        .q-review .correct { color:#22c55e; }
        .q-review .wrong { color:#ef4444; }
        .q-review .explanation-box { margin-top:16px; background:rgba(59,130,246,0.06); border:1px solid rgba(59,130,246,0.15); border-radius:10px; padding:14px 18px; }
        .q-review .explanation-box .expl-title { font-size:11px; font-weight:700; color:#3b82f6; letter-spacing:1px; margin-bottom:6px; }
        .q-review .explanation-box .expl-text { font-size:13px; line-height:1.6; color:#a5b4fc; }
        .marks-badge { padding:3px 10px; border-radius:16px; font-size:12px; font-weight:600; display:inline-block; }
        .marks-badge.full { background:rgba(34,197,94,0.12); color:#22c55e; border:1px solid rgba(34,197,94,0.25); }
        .marks-badge.zero { background:rgba(239,68,68,0.1); color:#ef4444; border:1px solid rgba(239,68,68,0.2); }
        .marks-badge.partial { background:rgba(251,191,36,0.1); color:#fbbf24; border:1px solid rgba(251,191,36,0.2); }
    </style>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <% Exam exam = (Exam) request.getAttribute("exam");
               ExamAttempt attempt = (ExamAttempt) request.getAttribute("attempt");
               Double total = (Double) request.getAttribute("totalMarks");
               List<Answer> answers = (List<Answer>) request.getAttribute("answers");
               double pct = (exam != null && total != null && exam.getTotalMarks() > 0) ? (total / exam.getTotalMarks()) * 100 : 0;
               boolean passed = pct >= (exam != null ? exam.getPassingPercentage() : 60);
               boolean disqualified = attempt != null && "DISQUALIFIED".equals(attempt.getStatus()); %>

            <div class="page-header"><h1>Exam Results</h1><p><%= exam != null ? exam.getExamName() : "" %></p></div>

            <% if (attempt != null) { %>
                <!-- Result Header -->
                <div class="result-header <%= disqualified ? "failed" : (passed ? "passed" : "failed") %>">
                    <% if (disqualified) { %>
                        <div class="result-emoji">&#9940;</div>
                        <div class="result-title" style="color:#ef4444">DISQUALIFIED</div>
                        <div class="result-subtitle" style="color:#ef4444">Exam terminated due to integrity violations</div>
                        <div class="result-score" style="color:#ef4444">0</div>
                    <% } else if (passed) { %>
                        <div class="result-emoji">&#127881;&#127942;</div>
                        <div class="result-title" style="color:#22c55e">PASSED!</div>
                        <div class="result-subtitle" style="color:#a5f3fc">
                            <% if ("COMPANY".equals(exam.getExamType())) { %>
                                Congratulations! You have been selected!
                            <% } else { %>
                                Congratulations! You are shortlisted!
                            <% } %>
                        </div>
                        <div class="result-score" style="color:#22c55e"><%= total != null ? String.format("%.0f", total) : "0" %> / <%= exam.getTotalMarks() %></div>
                        <div class="result-pct" style="color:#22c55e"><%= String.format("%.1f", pct) %>%</div>
                    <% } else { %>
                        <div class="result-emoji">&#128532;</div>
                        <div class="result-title" style="color:#ef4444">NOT SHORTLISTED</div>
                        <div class="result-subtitle" style="color:#999">Sorry, you did not meet the passing criteria. Keep trying!</div>
                        <div class="result-score" style="color:#ef4444"><%= total != null ? String.format("%.0f", total) : "0" %> / <%= exam.getTotalMarks() %></div>
                        <div class="result-pct" style="color:#ef4444"><%= String.format("%.1f", pct) %>% (Required: <%= exam.getPassingPercentage() %>%)</div>
                    <% } %>
                </div>

                <!-- Stats -->
                <div class="stats-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:32px">
                    <div class="stat-card"><div class="stat-label">Status</div><div class="stat-value"><span class="badge badge-<%= attempt.getStatus().toLowerCase().replace("_","-") %>"><%= attempt.getStatus() %></span></div></div>
                    <div class="stat-card"><div class="stat-label">Your Score</div><div class="stat-value" style="color:var(--primary)"><%= total != null ? String.format("%.1f", total) : "0" %> / <%= exam.getTotalMarks() %></div></div>
                    <div class="stat-card"><div class="stat-label">Percentage</div><div class="stat-value" style="color:<%= passed ? "#22c55e" : "#ef4444" %>"><%= String.format("%.1f", pct) %>%</div></div>
                    <div class="stat-card"><div class="stat-label">Submitted</div><div class="stat-value text-sm"><%= attempt.getEndTime() != null ? attempt.getEndTime() : "Pending" %></div></div>
                </div>

                <!-- Detailed Answer Review with Explanations -->
                <h3 style="font-size:18px;margin-bottom:20px;color:#e0e0e0">&#128218; Answer Review & Explanations</h3>

                <% String currentSection = "";
                   int n = 1;
                   if (answers != null) for (Answer a : answers) {
                       String sec = a.getSection() != null ? a.getSection() : "General";
                       if (!sec.equals(currentSection)) {
                           currentSection = sec; %>
                    <div class="section-divider">
                        <span>&#128196; <%= currentSection %></span>
                    </div>
                <% } %>
                    <div class="q-review">
                        <div class="q-num">Question <%= n++ %> &bull; <%= a.getQuestionMarks() %> marks</div>
                        <div class="q-text"><%= a.getQuestionText() %></div>

                        <% BigDecimal marks = a.getMarksAwarded();
                           boolean gotFull = marks != null && marks.intValue() == a.getQuestionMarks();
                           boolean gotZero = marks == null || marks.intValue() == 0; %>

                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
                            <span class="marks-badge <%= gotFull ? "full" : (gotZero ? "zero" : "partial") %>">
                                <%= marks != null ? marks : "0" %> / <%= a.getQuestionMarks() %> marks
                            </span>
                            <span style="font-size:12px;color:<%= gotFull ? "#22c55e" : "#ef4444" %>"><%= gotFull ? "&#10003; Correct" : "&#10007; Incorrect" %></span>
                        </div>

                        <% if ("MCQ".equals(a.getQuestionType())) { %>
                            <div class="answer-row">
                                <span class="answer-label" style="color:#888">YOUR ANSWER:</span>
                                <span style="color:<%= gotFull ? "#22c55e" : "#ef4444" %>"><%= a.getSelectedOptionText() != null ? a.getSelectedOptionText() : "Not answered" %></span>
                            </div>
                            <% if (!gotFull) { %>
                            <div class="answer-row">
                                <span class="answer-label correct">CORRECT:</span>
                                <span class="correct"><%= a.getCorrectOptionText() != null ? a.getCorrectOptionText() : "-" %></span>
                            </div>
                            <% } %>
                        <% } else { %>
                            <div class="answer-row">
                                <span class="answer-label" style="color:#888">YOUR ANSWER:</span>
                                <span style="color:#ccc"><%= a.getDescriptiveAnswer() != null ? a.getDescriptiveAnswer() : "Not answered" %></span>
                            </div>
                        <% } %>

                        <% if (a.getExplanation() != null && !a.getExplanation().isEmpty()) { %>
                        <div class="explanation-box">
                            <div class="expl-title">&#128161; EXPLANATION</div>
                            <div class="expl-text"><%= a.getExplanation() %></div>
                        </div>
                        <% } %>
                    </div>
                <% } %>

                <div style="text-align:center;margin-top:32px">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary" style="padding:14px 32px">&#8592; BACK TO DASHBOARD</a>
                    <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-ghost" style="padding:14px 32px;margin-left:12px">VIEW ALL EXAMS</a>
                </div>
            <% } else { %>
                <div class="card" style="text-align:center;padding:48px;color:var(--on-surface-muted)">No exam attempt found.</div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
