<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .congrats-card { border-radius:16px; padding:24px; margin-bottom:20px; text-align:center; position:relative; overflow:hidden; }
        .congrats-card.passed-internship { background:linear-gradient(135deg,rgba(34,197,94,0.12),rgba(59,130,246,0.08)); border:1px solid rgba(34,197,94,0.3); }
        .congrats-card.passed-company { background:linear-gradient(135deg,rgba(251,191,36,0.12),rgba(34,197,94,0.08)); border:1px solid rgba(251,191,36,0.3); }
        .congrats-card.failed { background:linear-gradient(135deg,rgba(239,68,68,0.08),rgba(100,100,100,0.05)); border:1px solid rgba(239,68,68,0.2); }
        .congrats-card .emoji { font-size:48px; margin-bottom:12px; }
        .congrats-card .title { font-size:20px; font-weight:700; margin-bottom:6px; }
        .congrats-card .subtitle { font-size:13px; opacity:0.7; }
        .congrats-card .company-tag { display:inline-block; margin-top:12px; padding:6px 16px; border-radius:20px; font-size:12px; font-weight:600; letter-spacing:0.5px; }
        .pending-exam-card { background:rgba(59,130,246,0.06); border:1px solid rgba(59,130,246,0.25); border-radius:14px; padding:18px 20px; margin-bottom:12px; display:flex; justify-content:space-between; align-items:center; }
        .pending-exam-card .exam-info h4 { font-size:14px; color:#e0e0e0; margin-bottom:4px; }
        .pending-exam-card .exam-info span { font-size:11px; color:var(--on-surface-muted); }
        .pending-exam-card .btn-take { background:rgba(59,130,246,0.15); color:#3b82f6; border:1px solid rgba(59,130,246,0.3); font-size:11px; padding:6px 16px; border-radius:8px; text-decoration:none; font-weight:600; }
        .pending-exam-card .btn-take:hover { background:rgba(59,130,246,0.25); }
    </style>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <% Student student = (Student) request.getAttribute("student");
               User user = (User) session.getAttribute("user");
               ExamAttempt latestExam = (ExamAttempt) request.getAttribute("latestExam");
               ExamAssignment latestAssignment = (ExamAssignment) request.getAttribute("latestAssignment");
               List<ExamAssignment> pendingExams = (List<ExamAssignment>) request.getAttribute("pendingExams");
               List<ExamAssignment> allAssignments = (List<ExamAssignment>) request.getAttribute("examAssignments"); %>
            <div class="page-header">
                <h1>Student Dashboard</h1>
                <p>Welcome back, <strong><%= user.getName() %></strong>. Your academic portal awaits.</p>
            </div>

            <% String error = (String) session.getAttribute("error");
               String success = (String) session.getAttribute("success");
               if (error != null) { session.removeAttribute("error"); %>
                <div class="alert alert-error">&#9888; <%= error %></div>
            <% } if (success != null) { session.removeAttribute("success"); %>
                <div class="alert alert-success">&#10003; <%= success %></div>
            <% } %>

            <!-- Congratulation / Sorry Messages -->
            <% if (latestAssignment != null) { %>
                <% if ("PASSED".equals(latestAssignment.getResult()) && "COMPANY".equals(latestAssignment.getExamType())) { %>
                    <div class="congrats-card passed-company">
                        <div class="emoji">&#127881;&#127942;&#127881;</div>
                        <div class="title" style="color:#fbbf24">&#127775; CONGRATULATIONS! Welcome to <%= latestAssignment.getCompanyName() %>!</div>
                        <div class="subtitle" style="color:#22c55e">You have successfully cleared the PPO Coding Round and have been SELECTED for the position of <strong><%= latestAssignment.getInternshipRole() %></strong></div>
                        <div class="company-tag" style="background:rgba(251,191,36,0.15);color:#fbbf24;border:1px solid rgba(251,191,36,0.3)">&#128640; PPO CONFIRMED — <%= latestAssignment.getCompanyName().toUpperCase() %></div>
                    </div>
                <% } else if ("PASSED".equals(latestAssignment.getResult()) && "INTERNSHIP".equals(latestAssignment.getExamType())) { %>
                    <div class="congrats-card passed-internship">
                        <div class="emoji">&#127881;&#128079;&#127775;</div>
                        <div class="title" style="color:#22c55e">&#10003; Congratulations! You are SHORTLISTED!</div>
                        <div class="subtitle" style="color:#a5f3fc">You have passed the Internship Screening Test for <strong><%= latestAssignment.getCompanyName() %></strong> — <%= latestAssignment.getInternshipRole() %></div>
                        <div class="company-tag" style="background:rgba(34,197,94,0.15);color:#22c55e;border:1px solid rgba(34,197,94,0.3)">Score: <%= String.format("%.0f", latestAssignment.getScore()) %>/<%= String.format("%.0f", latestAssignment.getExamTotalMarks()) %> — PASSED</div>
                    </div>
                <% } else if ("FAILED".equals(latestAssignment.getResult())) { %>
                    <div class="congrats-card failed">
                        <div class="emoji">&#128532;</div>
                        <div class="title" style="color:#ef4444">Not Shortlisted — Sorry</div>
                        <div class="subtitle" style="color:#999">Unfortunately, you did not meet the passing criteria for <strong><%= latestAssignment.getExamName() %></strong>. Keep practicing and try again!</div>
                        <div class="company-tag" style="background:rgba(239,68,68,0.1);color:#ef4444;border:1px solid rgba(239,68,68,0.2)">Score: <%= String.format("%.0f", latestAssignment.getScore()) %>/<%= String.format("%.0f", latestAssignment.getExamTotalMarks()) %> — FAILED</div>
                    </div>
                <% } else if ("DISQUALIFIED".equals(latestAssignment.getResult())) { %>
                    <div class="congrats-card failed">
                        <div class="emoji">&#9940;</div>
                        <div class="title" style="color:#ef4444">DISQUALIFIED — Exam Terminated</div>
                        <div class="subtitle" style="color:#999">You were disqualified from <strong><%= latestAssignment.getExamName() %></strong> due to exam integrity violations. Score: 0</div>
                    </div>
                <% } %>
            <% } %>

            <!-- Pending Exams (Assigned by Admin) -->
            <% if (pendingExams != null && !pendingExams.isEmpty()) { %>
            <div style="margin-bottom:20px">
                <h3 style="font-size:15px;margin-bottom:12px;color:#3b82f6">&#128221; Assigned Exams — Action Required</h3>
                <% for (ExamAssignment pe : pendingExams) { %>
                    <div class="pending-exam-card">
                        <div class="exam-info">
                            <h4><%= pe.getExamName() %></h4>
                            <span><%= pe.getCompanyName() %> &bull; <%= pe.getInternshipRole() %> &bull; <%= "COMPANY".equals(pe.getExamType()) ? "&#128640; PPO Coding Round" : "&#128218; Internship Screening" %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/exam?examId=<%= pe.getExamId() %>" class="btn-take">START EXAM &rarr;</a>
                    </div>
                <% } %>
            </div>
            <% } %>

            <div class="dashboard-grid">
                <div>
                    <!-- Filter Chips -->
                    <div class="filter-chips">
                        <span class="chip active">All</span>
                        <span class="chip">Engineering</span>
                        <span class="chip">Data Sciences</span>
                        <span class="chip">Design</span>
                    </div>

                    <!-- Matched Opportunities -->
                    <div class="section-header"><h3>Matched Opportunities</h3></div>
                    <% List<Internship> opportunities = (List<Internship>) request.getAttribute("opportunities");
                       if (opportunities != null) for (Internship i : opportunities) { %>
                        <div class="opportunity-card">
                            <div class="opportunity-header">
                                <div>
                                    <div class="opportunity-company"><%= i.getCompanyName() %></div>
                                    <div class="opportunity-role"><%= i.getRole() %></div>
                                    <div class="opportunity-meta"><%= i.getCompanyLocation() %> &bull; &#8377;<%= i.getStipend() %>/month &bull; Deadline: <%= i.getDeadline() %></div>
                                </div>
                            </div>
                            <div class="opportunity-tags">
                                <span class="chip"><%= student.getCourse() %></span>
                                <span class="chip">Min CGPA: <%= i.getEligibilityCgpa() %></span>
                            </div>
                            <div class="opportunity-actions">
                                <form action="${pageContext.request.contextPath}/student/apply" method="POST" style="display:inline">
                                    <input type="hidden" name="internshipId" value="<%= i.getInternshipId() %>">
                                    <button type="submit" class="btn btn-primary btn-sm">APPLY NOW</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                    <% if (opportunities == null || opportunities.isEmpty()) { %>
                        <div class="card" style="text-align:center;padding:48px;color:var(--on-surface-muted);">No eligible internships available at this time.</div>
                    <% } %>
                </div>

                <!-- Right Panel -->
                <div>
                    <!-- Latest Exam Score -->
                    <% if (latestExam != null) { %>
                    <div class="eligibility-panel" style="margin-bottom:16px">
                        <h4 style="margin-bottom:12px;font-size:var(--fs-body-sm)">Latest Exam Result</h4>
                        <div style="text-align:center;padding:12px 0">
                            <div style="font-size:14px;color:var(--on-surface-muted);margin-bottom:6px"><%= latestExam.getExamName() %></div>
                            <% if ("DISQUALIFIED".equals(latestExam.getStatus())) { %>
                                <div style="font-size:36px;font-weight:700;color:#ef4444">DISQUALIFIED</div>
                                <div style="font-size:12px;color:#ef4444;margin-top:4px">Score: 0 (Cheating Detected)</div>
                            <% } else { %>
                                <div style="font-size:36px;font-weight:700;color:var(--primary)"><%= String.format("%.0f", latestExam.getTotalMarks()) %></div>
                                <div style="font-size:12px;color:var(--on-surface-muted);margin-top:4px">Score Obtained</div>
                            <% } %>
                            <div style="margin-top:12px;font-size:11px;color:var(--on-surface-muted)">
                                Status: <span style="color:<%= "SUBMITTED".equals(latestExam.getStatus()) ? "#22c55e" : "#fbbf24" %>"><%= latestExam.getStatus() %></span>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-ghost btn-sm" style="width:100%;margin-top:8px;text-align:center">VIEW ALL EXAMS</a>
                    </div>
                    <% } else { %>
                    <div class="eligibility-panel" style="margin-bottom:16px">
                        <h4 style="margin-bottom:12px;font-size:var(--fs-body-sm)">Examinations</h4>
                        <div style="text-align:center;padding:20px 0;color:var(--on-surface-muted);font-size:13px">No exams attempted yet</div>
                        <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-primary btn-sm" style="width:100%;text-align:center">TAKE AN EXAM &#8594;</a>
                    </div>
                    <% } %>

                    <!-- CGPA Gauge -->
                    <div class="eligibility-panel">
                        <h4 style="margin-bottom:16px">Eligibility Status</h4>
                        <% double cgpaVal = student != null ? student.getCgpa().doubleValue() : 0;
                           int cgpaPct = (int)((cgpaVal / 10.0) * 100); %>
                        <div class="cgpa-gauge" style="--cgpa-pct: <%= cgpaPct %>">
                            <span class="cgpa-value"><%= student != null ? student.getCgpa() : "N/A" %></span>
                        </div>
                        <div style="font-size:var(--fs-label-sm);color:var(--on-surface-muted);margin-bottom:12px">CGPA out of 10.0</div>
                        <div class="eligibility-check"><span class="check-icon">&#10003;</span> Academic standing: Good</div>
                        <div class="eligibility-check"><span class="check-icon">&#10003;</span> No probation flags</div>
                    </div>

                    <!-- Application Tracker -->
                    <div style="margin-top:16px">
                        <h4 style="margin-bottom:12px;font-size:var(--fs-body-sm)">Application Tracker</h4>
                        <div class="app-tracker">
                            <div class="tracker-item">
                                <div class="tracker-value">${appliedCount}</div>
                                <div class="tracker-label">Applied</div>
                            </div>
                            <div class="tracker-item">
                                <div class="tracker-value">${shortlistedCount}</div>
                                <div class="tracker-label">Shortlisted</div>
                            </div>
                            <div class="tracker-item">
                                <div class="tracker-value">${selectedCount}</div>
                                <div class="tracker-label">Selected</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>
