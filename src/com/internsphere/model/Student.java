package com.internsphere.model;

import java.math.BigDecimal;

public class Student {
    private int studentId;
    private int userId;
    private String course;
    private BigDecimal cgpa;
    private String phone;
    private String name;  // transient from users join
    private String email; // transient from users join

    public Student() {}

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }
    public BigDecimal getCgpa() { return cgpa; }
    public void setCgpa(BigDecimal cgpa) { this.cgpa = cgpa; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
