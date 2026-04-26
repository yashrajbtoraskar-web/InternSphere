package com.internsphere.model;

import java.sql.Timestamp;

public class SessionTracking {
    private String sessionId;
    private int userId;
    private String ipAddress;
    private String userAgent;
    private Timestamp loginTime;
    private Timestamp lastActivity;

    public SessionTracking() {}

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public Timestamp getLoginTime() { return loginTime; }
    public void setLoginTime(Timestamp loginTime) { this.loginTime = loginTime; }
    public Timestamp getLastActivity() { return lastActivity; }
    public void setLastActivity(Timestamp lastActivity) { this.lastActivity = lastActivity; }
}
