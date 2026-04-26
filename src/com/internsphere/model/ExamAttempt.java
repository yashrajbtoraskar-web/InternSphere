package com.internsphere.model;

import java.sql.Timestamp;

public class ExamAttempt {
    private int attemptId;
    private int userId;
    private int examId;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status;
    private int tabSwitchCount;
    private String studentName;  // transient
    private String examName;     // transient
    private double totalMarks;   // transient - calculated
    private String studentEmail; // transient

    public ExamAttempt() {}

    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getTabSwitchCount() { return tabSwitchCount; }
    public void setTabSwitchCount(int tabSwitchCount) { this.tabSwitchCount = tabSwitchCount; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public double getTotalMarks() { return totalMarks; }
    public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
}
