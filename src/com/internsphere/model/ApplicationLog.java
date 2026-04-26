package com.internsphere.model;

import java.sql.Timestamp;

public class ApplicationLog {
    private int logId;
    private int applicationId;
    private String action;
    private Timestamp logTime;

    public ApplicationLog() {}

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public Timestamp getLogTime() { return logTime; }
    public void setLogTime(Timestamp logTime) { this.logTime = logTime; }
}
