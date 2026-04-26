<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Logs — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>Audit & Security Logs</h1><p>Monitor system activity and detect suspicious behavior</p></div>

            <% List<AuditLog> suspicious = (List<AuditLog>) request.getAttribute("suspiciousLogs");
               if (suspicious != null && !suspicious.isEmpty()) { %>
                <div class="alert alert-error mb-lg">&#9888; <%= suspicious.size() %> suspicious activities detected!</div>
            <% } %>

            <div class="table-container">
                <table>
                    <thead><tr><th>ID</th><th>User</th><th>Action</th><th>IP Address</th><th>User Agent</th><th>Time</th></tr></thead>
                    <tbody>
                    <% List<AuditLog> logs = (List<AuditLog>) request.getAttribute("logs");
                       if (logs != null) for (AuditLog l : logs) {
                           boolean isSuspicious = l.getAction() != null && (l.getAction().contains("TAB_SWITCH") || l.getAction().contains("SUSPICIOUS")); %>
                        <tr style="<%= isSuspicious ? "background:rgba(147,0,10,0.1)" : "" %>">
                            <td><%= l.getLogId() %></td>
                            <td><%= l.getUserName() != null ? l.getUserName() : "System" %></td>
                            <td><%= isSuspicious ? "<span class='badge badge-rejected'>" + l.getAction() + "</span>" : l.getAction() %></td>
                            <td class="text-sm"><%= l.getIpAddress() %></td>
                            <td class="text-xs text-muted" style="max-width:200px;overflow:hidden;text-overflow:ellipsis"><%= l.getUserAgent() %></td>
                            <td class="text-sm"><%= l.getLogTime() %></td>
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
