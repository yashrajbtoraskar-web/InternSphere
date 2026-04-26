<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reports.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/jsp/common/sidebar.jsp"/>
    <div class="main-content">
        <jsp:include page="/jsp/common/header.jsp"/>
        <div class="page-content">
            <div class="page-header"><h1>Reports Console</h1><p>Analytical reports and performance metrics</p></div>

            <% String selectedType = (String) request.getAttribute("selectedType"); %>
            <div class="report-selector">
                <a href="${pageContext.request.contextPath}/admin/reports?type=1" class="report-btn <%= "1".equals(selectedType) ? "active" : "" %>">Students per Company</a>
                <a href="${pageContext.request.contextPath}/admin/reports?type=2" class="report-btn <%= "2".equals(selectedType) ? "active" : "" %>">Application Count</a>
                <a href="${pageContext.request.contextPath}/admin/reports?type=5" class="report-btn <%= "5".equals(selectedType) ? "active" : "" %>">Suspicious Activity</a>
            </div>

            <!-- Exam-specific reports -->
            <% List<Exam> exams = (List<Exam>) request.getAttribute("exams");
               if (exams != null && !exams.isEmpty()) { %>
                <div class="flex gap-sm mb-lg" style="flex-wrap:wrap">
                    <% for (Exam e : exams) { %>
                        <a href="${pageContext.request.contextPath}/admin/reports?type=3&examId=<%= e.getExamId() %>" class="report-btn">Rank: <%= e.getExamName() %></a>
                        <a href="${pageContext.request.contextPath}/admin/reports?type=4&examId=<%= e.getExamId() %>" class="report-btn">Analysis: <%= e.getExamName() %></a>
                    <% } %>
                </div>
            <% } %>

            <% List<Map<String, Object>> data = (List<Map<String, Object>>) request.getAttribute("reportData");
               String title = (String) request.getAttribute("reportTitle");
               if (data != null && !data.isEmpty()) { %>
                <div class="report-content">
                    <h3><%= title %></h3>
                    <div class="table-container">
                        <table>
                            <thead><tr>
                            <% Map<String, Object> first = data.get(0);
                               for (String key : first.keySet()) { %>
                                <th><%= key.replace("_", " ").toUpperCase() %></th>
                            <% } %>
                            </tr></thead>
                            <tbody>
                            <% for (Map<String, Object> row : data) { %>
                                <tr>
                                <% for (Object val : row.values()) { %>
                                    <td><%= val != null ? val.toString() : "-" %></td>
                                <% } %>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } else if (selectedType != null) { %>
                <div class="report-content"><div class="report-empty"><div class="empty-icon">&#128202;</div><p>No data available for this report.</p></div></div>
            <% } else { %>
                <div class="report-content"><div class="report-empty"><div class="empty-icon">&#128202;</div><p>Select a report type above to generate data.</p></div></div>
            <% } %>
        </div>
        <jsp:include page="/jsp/common/footer.jsp"/>
    </div>
</div>
</body>
</html>
