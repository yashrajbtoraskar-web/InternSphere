package com.internsphere.dao;

import com.internsphere.model.ExamAttempt;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamAttemptDAO {

    public int create(int userId, int examId) throws SQLException {
        String sql = "INSERT INTO exam_attempts (user_id, exam_id) VALUES (?, ?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
            return -1;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public ExamAttempt findByUserAndExam(int userId, int examId) throws SQLException {
        String sql = "SELECT * FROM exam_attempts WHERE user_id = ? AND exam_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void updateStatus(int attemptId, String status) throws SQLException {
        String sql = "UPDATE exam_attempts SET status = ?, end_time = CURRENT_TIMESTAMP WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, attemptId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void updateTabSwitchCount(int attemptId, int count) throws SQLException {
        String sql = "UPDATE exam_attempts SET tab_switch_count = ? WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, count);
            ps.setInt(2, attemptId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void incrementTabSwitch(int attemptId) throws SQLException {
        String sql = "UPDATE exam_attempts SET tab_switch_count = tab_switch_count + 1 WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public int getTabSwitchCount(int attemptId) throws SQLException {
        String sql = "SELECT tab_switch_count FROM exam_attempts WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<ExamAttempt> findByExam(int examId) throws SQLException {
        String sql = "SELECT ea.*, u.name AS student_name, u.email AS student_email, e.exam_name, " +
                     "COALESCE((SELECT SUM(a.marks_awarded) FROM answers a WHERE a.attempt_id = ea.attempt_id), 0) AS total_marks " +
                     "FROM exam_attempts ea JOIN users u ON ea.user_id = u.user_id JOIN exams e ON ea.exam_id = e.exam_id " +
                     "WHERE ea.exam_id = ? ORDER BY total_marks DESC";
        List<ExamAttempt> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ExamAttempt ea = mapRow(rs);
                ea.setStudentName(rs.getString("student_name"));
                ea.setStudentEmail(rs.getString("student_email"));
                ea.setExamName(rs.getString("exam_name"));
                ea.setTotalMarks(rs.getDouble("total_marks"));
                list.add(ea);
            }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    /** Get all cheaters (DISQUALIFIED or tab_switch_count > 0) across all exams */
    public List<ExamAttempt> findCheaters() throws SQLException {
        String sql = "SELECT ea.*, u.name AS student_name, u.email AS student_email, e.exam_name, " +
                     "COALESCE((SELECT SUM(a.marks_awarded) FROM answers a WHERE a.attempt_id = ea.attempt_id), 0) AS total_marks " +
                     "FROM exam_attempts ea JOIN users u ON ea.user_id = u.user_id JOIN exams e ON ea.exam_id = e.exam_id " +
                     "WHERE ea.status = 'DISQUALIFIED' OR ea.tab_switch_count > 0 " +
                     "ORDER BY ea.tab_switch_count DESC, ea.end_time DESC";
        List<ExamAttempt> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                ExamAttempt ea = mapRow(rs);
                ea.setStudentName(rs.getString("student_name"));
                ea.setStudentEmail(rs.getString("student_email"));
                ea.setExamName(rs.getString("exam_name"));
                ea.setTotalMarks(rs.getDouble("total_marks"));
                list.add(ea);
            }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    /** Get latest completed attempt for a user (for dashboard display) */
    public ExamAttempt findLatestCompleted(int userId) throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.total_marks AS exam_total, " +
                     "COALESCE((SELECT SUM(a.marks_awarded) FROM answers a WHERE a.attempt_id = ea.attempt_id), 0) AS total_marks " +
                     "FROM exam_attempts ea JOIN exams e ON ea.exam_id = e.exam_id " +
                     "WHERE ea.user_id = ? AND ea.status IN ('SUBMITTED','AUTO_SUBMITTED','DISQUALIFIED') " +
                     "ORDER BY ea.end_time DESC LIMIT 1";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ExamAttempt ea = mapRow(rs);
                ea.setExamName(rs.getString("exam_name"));
                ea.setTotalMarks(rs.getDouble("total_marks"));
                return ea;
            }
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public ExamAttempt findById(int attemptId) throws SQLException {
        String sql = "SELECT * FROM exam_attempts WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private ExamAttempt mapRow(ResultSet rs) throws SQLException {
        ExamAttempt ea = new ExamAttempt();
        ea.setAttemptId(rs.getInt("attempt_id"));
        ea.setUserId(rs.getInt("user_id"));
        ea.setExamId(rs.getInt("exam_id"));
        ea.setStartTime(rs.getTimestamp("start_time"));
        ea.setEndTime(rs.getTimestamp("end_time"));
        ea.setStatus(rs.getString("status"));
        try { ea.setTabSwitchCount(rs.getInt("tab_switch_count")); } catch (SQLException ignored) {}
        return ea;
    }
}
