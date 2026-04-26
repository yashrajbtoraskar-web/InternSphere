<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.User" %>
<% User headerUser = (User) session.getAttribute("user"); String ctxH = request.getContextPath(); %>
<header class="header">
    <div class="header-left">
        <div class="header-search">
            <span class="search-icon">&#128269;</span>
            <input type="text" placeholder="Search InternSphere..." id="globalSearch">
        </div>
    </div>
    <div class="header-right">
        <div class="header-icon" title="Notifications">&#128276;</div>
        <a href="<%=ctxH%>/profile" class="header-icon" title="Profile">&#128100;</a>
        <a href="<%=ctxH%>/logout" class="header-icon" title="Logout" style="color:var(--error);">&#9211;</a>
    </div>
</header>
