<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Internships — InternSphere</title>
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
            <div class="page-header"><h1>Browse Internships</h1><p>Explore opportunities matched to your eligibility</p></div>
            <% String error = (String) session.getAttribute("error");
               String success = (String) session.getAttribute("success");
               if (error != null) { session.removeAttribute("error"); %>
                <div class="alert alert-error">&#9888; <%= error %></div>
            <% } if (success != null) { session.removeAttribute("success"); %>
                <div class="alert alert-success">&#10003; <%= success %></div>
            <% } %>
            <% Student student = (Student) request.getAttribute("student");
               List<Internship> internships = (List<Internship>) request.getAttribute("internships");
               if (internships != null) for (Internship i : internships) { %>
                <div class="opportunity-card">
                    <div class="opportunity-header">
                        <div>
                            <div class="opportunity-company"><%= i.getCompanyName() %></div>
                            <div class="opportunity-role"><%= i.getRole() %></div>
                            <div class="opportunity-meta"><%= i.getCompanyLocation() %> &bull; &#8377;<%= i.getStipend() %>/month</div>
                        </div>
                        <span class="badge badge-applied">Deadline: <%= i.getDeadline() %></span>
                    </div>
                    <div class="opportunity-tags">
                        <span class="chip">Min CGPA: <%= i.getEligibilityCgpa() %></span>
                        <span class="chip">Your CGPA: <%= student.getCgpa() %></span>
                    </div>
                    <div class="opportunity-actions">
                        <form action="${pageContext.request.contextPath}/student/apply" method="POST">
                            <input type="hidden" name="internshipId" value="<%= i.getInternshipId() %>">
                            <button type="submit" class="btn btn-primary btn-sm">APPLY NOW</button>
                        </form>
                    </div>
                </div>
            <% } %>
            <% if (internships == null || internships.isEmpty()) { %>
                <div class="card" style="text-align:center;padding:48px;color:var(--on-surface-muted)">No eligible internships found. Check back soon!</div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
