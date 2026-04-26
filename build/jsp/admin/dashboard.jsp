<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — InternSphere</title>
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
            <div class="page-header">
                <h1>System Overview</h1>
                <p>Real-time monitoring and management console for InternSphere platform</p>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-students">&#128100;</div>
                    <div class="stat-label">Total Students</div>
                    <div class="stat-value">${totalStudents}</div>
                    <div class="stat-change">&#8593; Active this semester</div>
                    <div class="stat-bar"><span style="height:60%"></span><span style="height:80%"></span><span style="height:45%"></span><span style="height:90%"></span><span style="height:70%"></span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-companies">&#127970;</div>
                    <div class="stat-label">Active Companies</div>
                    <div class="stat-value">${totalCompanies}</div>
                    <div class="stat-change">&#8593; Enterprise Partners</div>
                    <div class="stat-bar"><span style="height:40%"></span><span style="height:70%"></span><span style="height:55%"></span><span style="height:85%"></span><span style="height:60%"></span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-selected">&#10003;</div>
                    <div class="stat-label">Placed / Selected</div>
                    <div class="stat-value">${selectedCount}</div>
                    <div class="stat-change">&#8593; Confirmed placements</div>
                    <div class="stat-bar"><span style="height:50%"></span><span style="height:65%"></span><span style="height:80%"></span><span style="height:95%"></span><span style="height:75%"></span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-pending">&#9203;</div>
                    <div class="stat-label">Pending Reviews</div>
                    <div class="stat-value">${pendingReviews}</div>
                    <div class="stat-change">Awaiting action</div>
                    <div class="stat-bar"><span style="height:70%"></span><span style="height:50%"></span><span style="height:35%"></span><span style="height:55%"></span><span style="height:40%"></span></div>
                </div>
            </div>

            <!-- Cheating Violations Alert -->
            <% List<ExamAttempt> cheaters = (List<ExamAttempt>) request.getAttribute("cheaters"); %>
            <% if (cheaters != null && !cheaters.isEmpty()) { %>
            <div class="card" style="margin-bottom:24px;border:1px solid rgba(239,68,68,0.3);background:rgba(239,68,68,0.05);padding:0">
                <div style="padding:16px 24px;border-bottom:1px solid rgba(239,68,68,0.15);display:flex;justify-content:space-between;align-items:center">
                    <h3 style="color:#ef4444;font-size:15px;margin:0">&#9888; Exam Integrity Violations — <%= cheaters.size() %> detected</h3>
                    <a href="${pageContext.request.contextPath}/admin/examscores" class="btn btn-ghost" style="font-size:12px;padding:6px 16px;border:1px solid rgba(239,68,68,0.3);color:#ef4444">VIEW FULL REPORT &rarr;</a>
                </div>
                <div style="overflow-x:auto">
                    <table class="data-table" style="margin:0">
                        <thead><tr><th>Student</th><th>Exam</th><th>Tab Switches</th><th>Status</th><th>Score</th></tr></thead>
                        <tbody>
                        <% for (ExamAttempt ch : cheaters) { %>
                            <tr style="background:rgba(239,68,68,0.03)">
                                <td><strong><%= ch.getStudentName() %></strong><br><span class="text-xs text-muted"><%= ch.getStudentEmail() %></span></td>
                                <td><%= ch.getExamName() %></td>
                                <td style="color:#ef4444;font-weight:700"><%= ch.getTabSwitchCount() %></td>
                                <td>
                                    <% if ("DISQUALIFIED".equals(ch.getStatus())) { %>
                                        <span class="badge" style="background:rgba(239,68,68,0.15);color:#ef4444;border:1px solid rgba(239,68,68,0.3);padding:4px 10px;border-radius:20px;font-size:11px">DISQUALIFIED</span>
                                    <% } else { %>
                                        <span class="badge" style="background:rgba(251,191,36,0.15);color:#fbbf24;border:1px solid rgba(251,191,36,0.3);padding:4px 10px;border-radius:20px;font-size:11px">SUSPICIOUS</span>
                                    <% } %>
                                </td>
                                <td style="color:#ef4444;font-weight:700"><%= String.format("%.0f", ch.getTotalMarks()) %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

            <!-- Shortlisted Students — PPO Test Assignment -->
            <% List<ExamAssignment> shortlisted = (List<ExamAssignment>) request.getAttribute("shortlisted"); %>
            <% if (shortlisted != null && !shortlisted.isEmpty()) { %>
            <div class="card" style="margin-bottom:24px;border:1px solid rgba(34,197,94,0.3);background:rgba(34,197,94,0.03);padding:0">
                <div style="padding:16px 24px;border-bottom:1px solid rgba(34,197,94,0.15);display:flex;justify-content:space-between;align-items:center">
                    <h3 style="color:#22c55e;font-size:15px;margin:0">&#127942; Shortlisted Students — <%= shortlisted.size() %> passed internship exam</h3>
                </div>
                <div style="overflow-x:auto">
                    <table class="data-table" style="margin:0">
                        <thead><tr><th>Student</th><th>Company</th><th>Role</th><th>Exam Score</th><th>PPO Test</th></tr></thead>
                        <tbody>
                        <% for (ExamAssignment sa : shortlisted) { %>
                            <tr>
                                <td><strong><%= sa.getStudentName() %></strong><br><span class="text-xs text-muted"><%= sa.getStudentEmail() %></span></td>
                                <td><%= sa.getCompanyName() %></td>
                                <td><%= sa.getInternshipRole() %></td>
                                <td style="color:#22c55e;font-weight:700"><%= String.format("%.0f", sa.getScore()) %>/<%= String.format("%.0f", sa.getExamTotalMarks()) %></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/assign-exam" method="POST">
                                        <input type="hidden" name="action" value="assign_ppo_test">
                                        <input type="hidden" name="userId" value="<%= sa.getUserId() %>">
                                        <button type="submit" class="btn btn-sm" style="background:rgba(59,130,246,0.15);color:#3b82f6;border:1px solid rgba(59,130,246,0.3);font-size:11px;padding:6px 16px">
                                            &#128640; ASSIGN PPO TEST
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

            <div class="dashboard-grid">
                <!-- Recent Applications -->
                <div>
                    <div class="section-header">
                        <h3>Recent Applications</h3>
                        <a href="${pageContext.request.contextPath}/admin/applications" class="section-action">View All &rarr;</a>
                    </div>
                    <div class="table-container">
                        <table>
                            <thead><tr><th>Candidate</th><th>Role</th><th>Company</th><th>Status</th></tr></thead>
                            <tbody>
                            <% List<Application> recent = (List<Application>) request.getAttribute("recentApplications");
                               if (recent != null) for (Application app : recent) { %>
                                <tr>
                                    <td><strong><%= app.getStudentName() %></strong><br><span class="text-xs text-muted"><%= app.getStudentEmail() %></span></td>
                                    <td><%= app.getInternshipRole() %></td>
                                    <td><%= app.getCompanyName() %></td>
                                    <td><span class="badge badge-<%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- System Status -->
                <div>
                    <div class="section-header"><h3>System Status</h3></div>
                    <div class="system-status">
                        <div class="status-item">
                            <span class="status-label">API Latency</span>
                            <span class="status-value">42ms</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Database Load</span>
                            <div class="flex items-center gap-sm">
                                <div class="status-bar"><div class="fill" style="width:28%"></div></div>
                                <span class="status-value">28%</span>
                            </div>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Active Sessions</span>
                            <span class="status-value">Online</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Last Updated</span>
                            <span class="text-xs text-muted">Just now</span>
                        </div>
                    </div>
                    <div style="margin-top:16px">
                        <a href="${pageContext.request.contextPath}/admin/internships" class="btn btn-primary btn-block">+ Post New Internship</a>
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
