<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Internships — InternSphere</title>
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
            <div class="page-header"><h1>Internship Management</h1><p>Create and manage internship postings</p></div>
            <% Internship editI = (Internship) request.getAttribute("editInternship");
               List<Company> companies = (List<Company>) request.getAttribute("companies"); %>
            <div class="inline-form">
                <h3><%= editI != null ? "Edit Internship" : "Post New Internship" %></h3>
                <form action="${pageContext.request.contextPath}/admin/internships" method="POST">
                    <input type="hidden" name="action" value="<%= editI != null ? "update" : "add" %>">
                    <% if (editI != null) { %><input type="hidden" name="internshipId" value="<%= editI.getInternshipId() %>"><% } %>
                    <div class="form-row">
                        <div class="form-group"><label>Company</label>
                            <select name="companyId" class="form-control" required>
                                <option value="">Select Company</option>
                                <% if (companies != null) for (Company c : companies) { %>
                                    <option value="<%= c.getCompanyId() %>" <%= (editI != null && editI.getCompanyId() == c.getCompanyId()) ? "selected" : "" %>><%= c.getCompanyName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group"><label>Role</label><input type="text" name="role" class="form-control" value="<%= editI != null ? editI.getRole() : "" %>" required></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Stipend (&#8377;/month)</label><input type="number" name="stipend" class="form-control" step="0.01" value="<%= editI != null ? editI.getStipend() : "" %>" required></div>
                        <div class="form-group"><label>Deadline</label><input type="date" name="deadline" class="form-control" value="<%= editI != null ? editI.getDeadline() : "" %>" required></div>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><%= editI != null ? "Update" : "Post Internship" %></button>
                        <% if (editI != null) { %><a href="${pageContext.request.contextPath}/admin/internships" class="btn btn-ghost">Cancel</a><% } %>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead><tr><th>Company</th><th>Role</th><th>Stipend</th><th>Deadline</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% List<Internship> internships = (List<Internship>) request.getAttribute("internships");
                       if (internships != null) for (Internship i : internships) { %>
                        <tr>
                            <td><strong><%= i.getCompanyName() %></strong><br><span class="text-xs text-muted"><%= i.getCompanyLocation() %></span></td>
                            <td><%= i.getRole() %></td>
                            <td>&#8377;<%= i.getStipend() %></td>
                            <td><%= i.getDeadline() %></td>
                            <td class="flex gap-sm">
                                <a href="${pageContext.request.contextPath}/admin/internships?action=edit&id=<%= i.getInternshipId() %>" class="btn btn-ghost btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/internships" method="POST" style="display:inline" onsubmit="return confirm('Delete?')">
                                    <input type="hidden" name="action" value="delete"><input type="hidden" name="internshipId" value="<%= i.getInternshipId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </td>
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
