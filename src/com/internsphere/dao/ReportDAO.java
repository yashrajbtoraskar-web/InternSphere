package com.internsphere.dao;

import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ReportDAO {

    // Report 1: Students selected per company
    public List<Map<String, Object>> studentsPerCompany() throws SQLException {
        String sql = "SELECT c.company_name, COUNT(a.application_id) AS selected_count " +
                     "FROM applications a JOIN internships i ON a.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id WHERE a.status = 'SELECTED' " +
                     "GROUP BY c.company_name ORDER BY selected_count DESC";
        return executeReport(sql);
    }

    // Report 2: Internship-wise application count
    public List<Map<String, Object>> applicationCountByInternship() throws SQLException {
        String sql = "SELECT c.company_name, i.role, COUNT(a.application_id) AS app_count, " +
                     "SUM(CASE WHEN a.status='SELECTED' THEN 1 ELSE 0 END) AS selected, " +
                     "SUM(CASE WHEN a.status='REJECTED' THEN 1 ELSE 0 END) AS rejected " +
                     "FROM internships i JOIN companies c ON i.company_id = c.company_id " +
                     "LEFT JOIN applications a ON a.internship_id = i.internship_id " +
                     "GROUP BY c.company_name, i.role ORDER BY app_count DESC";
        return executeReport(sql);
    }

    // Report 3: Exam rank list
    public List<Map<String, Object>> examRankList(int examId) throws SQLException {
        String sql = "SELECT u.name, u.email, ea.status, COALESCE(SUM(a.marks_awarded), 0) AS total_marks " +
                     "FROM exam_attempts ea JOIN users u ON ea.user_id = u.user_id " +
                     "LEFT JOIN answers a ON ea.attempt_id = a.attempt_id " +
                     "WHERE ea.exam_id = ? GROUP BY u.name, u.email, ea.status ORDER BY total_marks DESC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++)
                    row.put(md.getColumnLabel(i), rs.getObject(i));
                result.add(row);
            }
            return result;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    // Report 4: Question-wise performance analysis
    public List<Map<String, Object>> questionAnalysis(int examId) throws SQLException {
        String sql = "SELECT q.question_id, q.question_text, q.type, q.marks AS max_marks, " +
                     "COUNT(a.answer_id) AS attempts, COALESCE(AVG(a.marks_awarded), 0) AS avg_marks, " +
                     "COALESCE(MAX(a.marks_awarded), 0) AS highest " +
                     "FROM questions q LEFT JOIN answers a ON q.question_id = a.question_id " +
                     "WHERE q.exam_id = ? GROUP BY q.question_id, q.question_text, q.type, q.marks ORDER BY q.question_id";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++)
                    row.put(md.getColumnLabel(i), rs.getObject(i));
                result.add(row);
            }
            return result;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    // Report 5: Suspicious activity logs
    public List<Map<String, Object>> suspiciousLogs() throws SQLException {
        String sql = "SELECT al.log_id, u.name, al.action, al.ip_address, al.log_time " +
                     "FROM audit_logs al LEFT JOIN users u ON al.user_id = u.user_id " +
                     "WHERE al.action LIKE '%TAB_SWITCH%' OR al.action LIKE '%SUSPICIOUS%' OR al.action LIKE '%MULTIPLE_LOGIN%' " +
                     "ORDER BY al.log_time DESC";
        return executeReport(sql);
    }

    private List<Map<String, Object>> executeReport(String sql) throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++)
                    row.put(md.getColumnLabel(i), rs.getObject(i));
                result.add(row);
            }
            return result;
        } finally { DBUtil.close(rs, ps, conn); }
    }
}
