package com.internsphere.model;

import java.sql.Timestamp;

public class Exam {
    private int examId;
    private String examName;
    private String examType; // INTERNSHIP or COMPANY
    private int duration;
    private Timestamp startTime;
    private Timestamp endTime;
    private int totalMarks;
    private int passingPercentage;
    private int questionCount; // transient
    private String attemptStatus; // transient - for student view
    private double attemptScore;  // transient - for student view

    public Exam() {}

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public String getExamType() { return examType; }
    public void setExamType(String examType) { this.examType = examType; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }
    public int getPassingPercentage() { return passingPercentage; }
    public void setPassingPercentage(int passingPercentage) { this.passingPercentage = passingPercentage; }
    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }
    public String getAttemptStatus() { return attemptStatus; }
    public void setAttemptStatus(String attemptStatus) { this.attemptStatus = attemptStatus; }
    public double getAttemptScore() { return attemptScore; }
    public void setAttemptScore(double attemptScore) { this.attemptScore = attemptScore; }
}
