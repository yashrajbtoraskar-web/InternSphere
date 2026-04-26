<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Companies — InternSphere</title>
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
            <div class="page-header"><h1>Company Management</h1><p>Manage enterprise partners and recruitment channels</p></div>

            <% Company editCompany = (Company) request.getAttribute("editCompany"); %>
            <!-- Add/Edit Form -->
            <div class="inline-form">
                <h3><%= editCompany != null ? "Edit Company" : "Add New Company" %></h3>
                <form action="${pageContext.request.contextPath}/admin/companies" method="POST">
                    <input type="hidden" name="action" value="<%= editCompany != null ? "update" : "add" %>">
                    <% if (editCompany != null) { %><input type="hidden" name="companyId" value="<%= editCompany.getCompanyId() %>"><% } %>
                    <div class="form-row">
                        <div class="form-group"><label>Company Name</label><input type="text" name="companyName" class="form-control" value="<%= editCompany != null ? editCompany.getCompanyName() : "" %>" required></div>
                        <div class="form-group"><label>Location</label><input type="text" name="location" class="form-control" value="<%= editCompany != null ? editCompany.getLocation() : "" %>" required></div>
                    </div>
                    <div class="form-group"><label>Min. Eligibility CGPA</label><input type="number" name="eligibilityCgpa" class="form-control" step="0.01" min="0" max="10" value="<%= editCompany != null ? editCompany.getEligibilityCgpa() : "" %>" required></div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><%= editCompany != null ? "Update" : "Add Company" %></button>
                        <% if (editCompany != null) { %><a href="${pageContext.request.contextPath}/admin/companies" class="btn btn-ghost">Cancel</a><% } %>
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="table-container">
                <table>
                    <thead><tr><th>ID</th><th>Company Name</th><th>Location</th><th>Min CGPA</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% List<Company> companies = (List<Company>) request.getAttribute("companies");
                       if (companies != null) for (Company c : companies) { %>
                        <tr>
                            <td><%= c.getCompanyId() %></td>
                            <td><strong><%= c.getCompanyName() %></strong></td>
                            <td><%= c.getLocation() %></td>
                            <td><%= c.getEligibilityCgpa() %></td>
                            <td class="flex gap-sm">
                                <a href="${pageContext.request.contextPath}/admin/companies?action=edit&id=<%= c.getCompanyId() %>" class="btn btn-ghost btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/companies" method="POST" style="display:inline" onsubmit="return confirm('Delete this company?')">
                                    <input type="hidden" name="action" value="delete"><input type="hidden" name="companyId" value="<%= c.getCompanyId() %>">
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
