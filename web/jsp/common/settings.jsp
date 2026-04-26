<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings — InternSphere</title>
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
            <div class="page-header"><h1>Settings</h1><p>Manage your account security</p></div>
            <% String error = (String) session.getAttribute("error");
               String success = (String) session.getAttribute("success");
               if (error != null) session.removeAttribute("error");
               if (success != null) session.removeAttribute("success"); %>
            <% if (error != null) { %><div class="alert alert-error">&#9888; <%= error %></div><% } %>
            <% if (success != null) { %><div class="alert alert-success">&#10003; <%= success %></div><% } %>
            <div class="form-page">
                <div class="form-card">
                    <h3 style="margin-bottom:24px">Change Password</h3>
                    <form action="${pageContext.request.contextPath}/settings" method="POST">
                        <div class="form-group"><label>Current Password</label><input type="password" name="currentPassword" class="form-control" required></div>
                        <div class="form-group"><label>New Password</label><input type="password" name="newPassword" class="form-control" required minlength="6"></div>
                        <div class="form-group"><label>Confirm New Password</label><input type="password" class="form-control" required minlength="6" id="confirmPw"></div>
                        <div class="form-actions"><button type="submit" class="btn btn-primary">Update Password</button></div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
