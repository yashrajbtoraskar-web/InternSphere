package com.internsphere.model;

import java.sql.Timestamp;

public class Application {
    private int applicationId;
    private int studentId;
    private int internshipId;
    private String status;
    private Timestamp appliedDate;
    private String studentName;      // transient
    private String internshipRole;   // transient
    private String companyName;      // transient
    private String studentEmail;     // transient
    private int userId;              // transient — from users table

    public Application() {}

    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getInternshipId() { return internshipId; }
    public void setInternshipId(int internshipId) { this.internshipId = internshipId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getAppliedDate() { return appliedDate; }
    public void setAppliedDate(Timestamp appliedDate) { this.appliedDate = appliedDate; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getInternshipRole() { return internshipRole; }
    public void setInternshipRole(String internshipRole) { this.internshipRole = internshipRole; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}
