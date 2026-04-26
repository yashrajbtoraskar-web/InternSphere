package com.internsphere.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Company {
    private int companyId;
    private String companyName;
    private String location;
    private BigDecimal eligibilityCgpa;
    private Timestamp createdAt;

    public Company() {}

    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public BigDecimal getEligibilityCgpa() { return eligibilityCgpa; }
    public void setEligibilityCgpa(BigDecimal eligibilityCgpa) { this.eligibilityCgpa = eligibilityCgpa; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
