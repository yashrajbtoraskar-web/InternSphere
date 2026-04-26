<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>My Applications</h1><p>Track your internship application status</p></div>
            <div class="table-container">
                <table>
                    <thead><tr><th>Company</th><th>Role</th><th>Applied Date</th><th>Status</th></tr></thead>
                    <tbody>
                    <% List<Application> apps = (List<Application>) request.getAttribute("applications");
                       if (apps != null) for (Application a : apps) { %>
                        <tr>
                            <td><strong><%= a.getCompanyName() %></strong></td>
                            <td><%= a.getInternshipRole() %></td>
                            <td class="text-sm"><%= a.getAppliedDate() %></td>
                            <td><span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% if (apps == null || apps.isEmpty()) { %>
                <div class="card mt-lg" style="text-align:center;padding:48px;color:var(--on-surface-muted)">You haven't applied to any internships yet.</div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
