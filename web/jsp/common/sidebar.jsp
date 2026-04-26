<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.User" %>
<% User sidebarUser = (User) session.getAttribute("user");
   String role = sidebarUser != null ? sidebarUser.getRole() : "";
   String currentPath = request.getServletPath();
   String ctx = request.getContextPath();
%>
<aside class="sidebar">
    <div class="sidebar-logo">
        <h2>InternSphere</h2>
        <div class="logo-sub">Management System</div>
    </div>

    <div class="sidebar-section">
        <div class="sidebar-section-label">Navigation Console</div>
        <ul class="sidebar-nav">
            <% if ("ADMIN".equals(role)) { %>
                <li><a href="<%=ctx%>/admin/dashboard" class="<%= currentPath.contains("dashboard") ? "active" : "" %>"><span class="nav-icon">&#9632;</span> Dashboard</a></li>
                <li><a href="<%=ctx%>/admin/applications" class="<%= currentPath.contains("applications") ? "active" : "" %>"><span class="nav-icon">&#9993;</span> Applications</a></li>
                <li><a href="<%=ctx%>/admin/internships" class="<%= currentPath.contains("internships") ? "active" : "" %>"><span class="nav-icon">&#128188;</span> Internships</a></li>
                <li><a href="<%=ctx%>/admin/companies" class="<%= currentPath.contains("companies") ? "active" : "" %>"><span class="nav-icon">&#127970;</span> Companies</a></li>
                <li><a href="<%=ctx%>/admin/exams" class="<%= currentPath.contains("exam") ? "active" : "" %>"><span class="nav-icon">&#128221;</span> Examinations</a></li>
                <li><a href="<%=ctx%>/admin/evaluate" class="<%= currentPath.contains("evaluate") ? "active" : "" %>"><span class="nav-icon">&#9998;</span> Evaluate</a></li>
                <li><a href="<%=ctx%>/admin/reports" class="<%= currentPath.contains("reports") ? "active" : "" %>"><span class="nav-icon">&#128202;</span> Reports</a></li>
                <li><a href="<%=ctx%>/admin/audit" class="<%= currentPath.contains("audit") ? "active" : "" %>"><span class="nav-icon">&#128274;</span> Audit Logs</a></li>
                <li><a href="<%=ctx%>/admin/examscores" class="<%= currentPath.contains("examscores") ? "active" : "" %>"><span class="nav-icon">&#127942;</span> Exam Scores</a></li>
            <% } else { %>
                <li><a href="<%=ctx%>/student/dashboard" class="<%= currentPath.contains("dashboard") ? "active" : "" %>"><span class="nav-icon">&#9632;</span> Dashboard</a></li>
                <li><a href="<%=ctx%>/student/internships" class="<%= currentPath.contains("internships") ? "active" : "" %>"><span class="nav-icon">&#128188;</span> Internships</a></li>
                <li><a href="<%=ctx%>/student/applications" class="<%= currentPath.contains("applications") ? "active" : "" %>"><span class="nav-icon">&#9993;</span> Applications</a></li>
                <li><a href="<%=ctx%>/student/exams" class="<%= currentPath.contains("exam") ? "active" : "" %>"><span class="nav-icon">&#128221;</span> Examinations</a></li>
            <% } %>
        </ul>
    </div>

    <div class="sidebar-section">
        <div class="sidebar-section-label">System</div>
        <ul class="sidebar-nav">
            <li><a href="<%=ctx%>/profile" class="<%= currentPath.contains("profile") ? "active" : "" %>"><span class="nav-icon">&#128100;</span> Profile</a></li>
            <li><a href="<%=ctx%>/settings" class="<%= currentPath.contains("settings") ? "active" : "" %>"><span class="nav-icon">&#9881;</span> Settings</a></li>
        </ul>
    </div>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar"><%= sidebarUser != null ? sidebarUser.getName().substring(0, 1).toUpperCase() : "?" %></div>
            <div class="user-info">
                <div class="user-name"><%= sidebarUser != null ? sidebarUser.getName() : "Guest" %></div>
                <div class="user-role"><%= role %></div>
            </div>
        </div>
    </div>
</aside>
