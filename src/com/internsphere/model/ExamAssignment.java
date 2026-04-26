package com.internsphere.model;

import java.sql.Timestamp;

public class ExamAssignment {
    private int assignmentId;
    private int applicationId;
    private int examId;
    private int userId;
    private int assignedBy;
    private Timestamp assignedDate;
    private String result; // PENDING, PASSED, FAILED, DISQUALIFIED
    private double score;

    // Transient display fields
    private String studentName;
    private String studentEmail;
    private String examName;
    private String examType;
    private String companyName;
    private String internshipRole;
    private double examTotalMarks;

    public ExamAssignment() {}

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getAssignedBy() { return assignedBy; }
    public void setAssignedBy(int assignedBy) { this.assignedBy = assignedBy; }
    public Timestamp getAssignedDate() { return assignedDate; }
    public void setAssignedDate(Timestamp assignedDate) { this.assignedDate = assignedDate; }
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public String getExamType() { return examType; }
    public void setExamType(String examType) { this.examType = examType; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getInternshipRole() { return internshipRole; }
    public void setInternshipRole(String internshipRole) { this.internshipRole = internshipRole; }
    public double getExamTotalMarks() { return examTotalMarks; }
    public void setExamTotalMarks(double examTotalMarks) { this.examTotalMarks = examTotalMarks; }
}
