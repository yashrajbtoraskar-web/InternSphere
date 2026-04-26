<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile — InternSphere</title>
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
            <% User currentUser = (User) request.getAttribute("currentUser");
               Student student = (Student) request.getAttribute("student");
               String error = (String) session.getAttribute("error");
               String success = (String) session.getAttribute("success");
               if (error != null) session.removeAttribute("error");
               if (success != null) session.removeAttribute("success"); %>
            <div class="page-header"><h1>Profile</h1><p>View and manage your account information</p></div>
            <% if (error != null) { %><div class="alert alert-error">&#9888; <%= error %></div><% } %>
            <% if (success != null) { %><div class="alert alert-success">&#10003; <%= success %></div><% } %>
            <div class="form-page">
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <div class="form-group"><label>Name</label><input type="text" name="name" class="form-control" value="<%= currentUser.getName() %>" required></div>
                        <div class="form-group"><label>Email</label><input type="email" class="form-control" value="<%= currentUser.getEmail() %>" disabled></div>
                        <div class="form-group"><label>Role</label><input type="text" class="form-control" value="<%= currentUser.getRole() %>" disabled></div>
                        <% if (student != null) { %>
                            <div class="form-row">
                                <div class="form-group"><label>Course</label>
                                    <select name="course" class="form-control">
                                        <option value="Computer Science" <%= "Computer Science".equals(student.getCourse()) ? "selected" : "" %>>Computer Science</option>
                                        <option value="Data Science" <%= "Data Science".equals(student.getCourse()) ? "selected" : "" %>>Data Science</option>
                                        <option value="Information Technology" <%= "Information Technology".equals(student.getCourse()) ? "selected" : "" %>>Information Technology</option>
                                        <option value="UX Design" <%= "UX Design".equals(student.getCourse()) ? "selected" : "" %>>UX Design</option>
                                    </select>
                                </div>
                                <div class="form-group"><label>CGPA</label><input type="number" name="cgpa" class="form-control" step="0.01" value="<%= student.getCgpa() %>" min="0" max="10"></div>
                            </div>
                            <div class="form-group"><label>Phone</label><input type="tel" name="phone" class="form-control" value="<%= student.getPhone() %>" pattern="[0-9]{10}"></div>
                            <div class="form-group"><label>Student ID</label><input type="text" class="form-control" value="<%= student.getStudentId() %>" disabled></div>
                        <% } %>
                        <div class="form-actions"><button type="submit" class="btn btn-primary">Update Profile</button></div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
