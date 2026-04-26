<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="InternSphere — Integrated Internship & Online Examination Management System">
    <title>InternSphere — Initialize Session</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body>
<div class="landing-page">
    <!-- HEADER -->
    <header class="landing-header">
        <div class="landing-brand">INTERNSPHERE</div>
        <div class="landing-header-actions">
            <div class="header-icon" title="Search">&#128269;</div>
            <div class="header-icon" title="Notifications">&#128276;</div>
        </div>
    </header>

    <!-- MAIN -->
    <main class="landing-main">
        <!-- HERO -->
        <div class="landing-hero">
            <div class="hero-badge">&#9889; Enterprise Platform v2.0</div>
            <h1 class="hero-title">
                Infinite<br>
                <span>Opportunities</span>
            </h1>
            <p class="hero-desc">
                A unified enterprise platform connecting students with industry-leading internship programs.
                Streamline applications, certifications, and placements through an intelligent management system.
            </p>
            <div class="hero-stats">
                <div class="hero-stat">
                    <div class="hero-stat-value">1000+</div>
                    <div class="hero-stat-label">Active Students</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-value">50+</div>
                    <div class="hero-stat-label">Enterprise Partners</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-value">99.9%</div>
                    <div class="hero-stat-label">Platform Uptime</div>
                </div>
            </div>
        </div>

        <!-- LOGIN PANEL -->
        <div class="landing-login">
            <div class="login-card">
                <div class="login-tabs" id="loginTabs">
                    <button class="login-tab active" onclick="switchTab('student')">Student Portal</button>
                    <button class="login-tab" onclick="switchTab('admin')">Admin Access</button>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">&#9888; ${error}</div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">&#10003; ${success}</div>
                <% } %>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="form-group">
                        <label>Institutional Email</label>
                        <input type="email" name="email" class="form-control" placeholder="identifier@domain.edu" required id="emailInput">
                    </div>
                    <div class="form-group">
                        <label>Access Mode</label>
                        <input type="password" name="password" class="form-control" placeholder="Enter secure passphrase" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block btn-lg" id="loginBtn">
                        INITIALIZE SESSION &#8594;
                    </button>
                </form>

                <div class="login-footer">
                    Unregistered entity? <a href="${pageContext.request.contextPath}/register">Request Access</a>
                </div>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer class="landing-footer">
        <div>&copy; 2026 InternSphere. All rights reserved.</div>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">API Docs</a>
            <a href="#">Support</a>
        </div>
    </footer>
</div>

<script>
function switchTab(role) {
    const tabs = document.querySelectorAll('.login-tab');
    tabs.forEach(t => t.classList.remove('active'));
    if (role === 'admin') {
        tabs[1].classList.add('active');
        document.getElementById('emailInput').placeholder = 'admin@internsphere.io';
    } else {
        tabs[0].classList.add('active');
        document.getElementById('emailInput').placeholder = 'identifier@domain.edu';
    }
}
</script>
</body>
</html>
