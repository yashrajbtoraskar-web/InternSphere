package com.internsphere.model;

import java.sql.Timestamp;

public class AuditLog {
    private int logId;
    private Integer userId;
    private String action;
    private String ipAddress;
    private String userAgent;
    private Timestamp logTime;
    private String userName; // transient

    public AuditLog() {}

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public Timestamp getLogTime() { return logTime; }
    public void setLogTime(Timestamp logTime) { this.logTime = logTime; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
