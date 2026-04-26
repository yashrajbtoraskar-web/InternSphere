package com.internsphere.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Internship {
    private int internshipId;
    private int companyId;
    private String role;
    private BigDecimal stipend;
    private Date deadline;
    private Timestamp createdAt;
    private String companyName;     // transient
    private String companyLocation; // transient
    private BigDecimal eligibilityCgpa; // transient

    public Internship() {}

    public int getInternshipId() { return internshipId; }
    public void setInternshipId(int internshipId) { this.internshipId = internshipId; }
    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public BigDecimal getStipend() { return stipend; }
    public void setStipend(BigDecimal stipend) { this.stipend = stipend; }
    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getCompanyLocation() { return companyLocation; }
    public void setCompanyLocation(String companyLocation) { this.companyLocation = companyLocation; }
    public BigDecimal getEligibilityCgpa() { return eligibilityCgpa; }
    public void setEligibilityCgpa(BigDecimal eligibilityCgpa) { this.eligibilityCgpa = eligibilityCgpa; }
}
