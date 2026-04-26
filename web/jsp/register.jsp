<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body>
<div class="landing-page">
    <header class="landing-header">
        <a href="${pageContext.request.contextPath}/landing" class="landing-brand">INTERNSPHERE</a>
    </header>
    <main class="landing-main" style="grid-template-columns:1fr 480px">
        <div class="landing-hero">
            <div class="hero-badge">&#128274; New Entity Registration</div>
            <h1 class="hero-title">Request<br><span>Access</span></h1>
            <p class="hero-desc">Register as a new student to gain access to internship opportunities, certification exams, and career advancement tools.</p>
        </div>
        <div class="landing-login">
            <div class="login-card">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">&#9888; ${error}</div>
                <% } %>
                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="form-group"><label>Full Name</label><input type="text" name="name" class="form-control" placeholder="Enter your full name" required></div>
                    <div class="form-group"><label>Email Address</label><input type="email" name="email" class="form-control" placeholder="your.email@university.edu" required></div>
                    <div class="form-group"><label>Password</label><input type="password" name="password" class="form-control" placeholder="Create a secure passphrase" required minlength="6"></div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
                        <div class="form-group"><label>Course</label>
                            <select name="course" class="form-control" required>
                                <option value="">Select</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Data Science">Data Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="UX Design">UX Design</option>
                                <option value="Electronics">Electronics</option>
                            </select>
                        </div>
                        <div class="form-group"><label>CGPA</label><input type="number" name="cgpa" class="form-control" step="0.01" min="0" max="10" placeholder="0.00" required></div>
                    </div>
                    <div class="form-group"><label>Phone</label><input type="tel" name="phone" class="form-control" placeholder="10-digit phone number" required pattern="[0-9]{10}"></div>
                    <button type="submit" class="btn btn-primary btn-block btn-lg">CREATE ACCOUNT &#8594;</button>
                </form>
                <div class="login-footer">Already registered? <a href="${pageContext.request.contextPath}/landing">Initialize Session</a></div>
            </div>
        </div>
    </main>
    <footer class="landing-footer">
        <div>&copy; 2026 InternSphere</div>
        <div class="footer-links"><a href="#">Privacy Policy</a><a href="#">Terms</a></div>
    </footer>
</div>
</body>
</html>
