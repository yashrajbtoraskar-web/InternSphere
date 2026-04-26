package com.internsphere.dao;

import com.internsphere.model.ExamAssignment;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamAssignmentDAO {

    /** Assign an exam to a student's application */
    public void assign(int applicationId, int examId, int userId, int assignedBy) throws SQLException {
        String sql = "INSERT INTO exam_assignments (application_id, exam_id, user_id, assigned_by) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE assigned_date = CURRENT_TIMESTAMP, result = 'PENDING'";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, applicationId);
            ps.setInt(2, examId);
            ps.setInt(3, userId);
            ps.setInt(4, assignedBy);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    /** Update assignment result after exam completion */
    public void updateResult(int userId, int examId, String result, double score) throws SQLException {
        String sql = "UPDATE exam_assignments SET result = ?, score = ? WHERE user_id = ? AND exam_id = ? AND result = 'PENDING'";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, result);
            ps.setDouble(2, score);
            ps.setInt(3, userId);
            ps.setInt(4, examId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    /** Get all assignments for a specific student */
    public List<ExamAssignment> findByUser(int userId) throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.exam_type, e.total_marks AS exam_total_marks, " +
                     "c.company_name, i.role AS internship_role " +
                     "FROM exam_assignments ea " +
                     "JOIN exams e ON ea.exam_id = e.exam_id " +
                     "JOIN applications app ON ea.application_id = app.application_id " +
                     "JOIN internships i ON app.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "WHERE ea.user_id = ? ORDER BY ea.assigned_date DESC";
        return executeQuery(sql, userId);
    }

    /** Get pending assignments for a student (exams they need to take) */
    public List<ExamAssignment> findPendingByUser(int userId) throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.exam_type, e.total_marks AS exam_total_marks, " +
                     "c.company_name, i.role AS internship_role " +
                     "FROM exam_assignments ea " +
                     "JOIN exams e ON ea.exam_id = e.exam_id " +
                     "JOIN applications app ON ea.application_id = app.application_id " +
                     "JOIN internships i ON app.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "WHERE ea.user_id = ? AND ea.result = 'PENDING' ORDER BY ea.assigned_date DESC";
        return executeQuery(sql, userId);
    }

    /** Get all shortlisted students (passed internship exam) for admin view */
    public List<ExamAssignment> findShortlisted() throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.exam_type, e.total_marks AS exam_total_marks, " +
                     "u.name AS student_name, u.email AS student_email, " +
                     "c.company_name, i.role AS internship_role " +
                     "FROM exam_assignments ea " +
                     "JOIN exams e ON ea.exam_id = e.exam_id " +
                     "JOIN users u ON ea.user_id = u.user_id " +
                     "JOIN applications app ON ea.application_id = app.application_id " +
                     "JOIN internships i ON app.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "WHERE ea.result = 'PASSED' AND e.exam_type = 'INTERNSHIP' " +
                     "ORDER BY ea.score DESC";
        return executeQueryFull(sql);
    }

    /** Get all assignments for admin overview */
    public List<ExamAssignment> findAll() throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.exam_type, e.total_marks AS exam_total_marks, " +
                     "u.name AS student_name, u.email AS student_email, " +
                     "c.company_name, i.role AS internship_role " +
                     "FROM exam_assignments ea " +
                     "JOIN exams e ON ea.exam_id = e.exam_id " +
                     "JOIN users u ON ea.user_id = u.user_id " +
                     "JOIN applications app ON ea.application_id = app.application_id " +
                     "JOIN internships i ON app.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "ORDER BY ea.assigned_date DESC";
        return executeQueryFull(sql);
    }

    /** Check if PPO test is already assigned to a user */
    public boolean hasPPOAssignment(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM exam_assignments ea JOIN exams e ON ea.exam_id = e.exam_id " +
                     "WHERE ea.user_id = ? AND e.exam_type = 'COMPANY'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            return false;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    /** Get the latest completed assignment result for dashboard display */
    public ExamAssignment findLatestResult(int userId) throws SQLException {
        String sql = "SELECT ea.*, e.exam_name, e.exam_type, e.total_marks AS exam_total_marks, " +
                     "c.company_name, i.role AS internship_role " +
                     "FROM exam_assignments ea " +
                     "JOIN exams e ON ea.exam_id = e.exam_id " +
                     "JOIN applications app ON ea.application_id = app.application_id " +
                     "JOIN internships i ON app.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "WHERE ea.user_id = ? AND ea.result != 'PENDING' ORDER BY ea.assigned_date DESC LIMIT 1";
        List<ExamAssignment> list = executeQuery(sql, userId);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Get user's application ID for a given exam assignment */
    public int getApplicationIdForUser(int userId, int examId) throws SQLException {
        String sql = "SELECT application_id FROM exam_assignments WHERE user_id = ? AND exam_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return -1;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private List<ExamAssignment> executeQuery(String sql, int userId) throws SQLException {
        List<ExamAssignment> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private List<ExamAssignment> executeQueryFull(String sql) throws SQLException {
        List<ExamAssignment> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                ExamAssignment ea = mapRow(rs);
                try { ea.setStudentName(rs.getString("student_name")); } catch (SQLException ignored) {}
                try { ea.setStudentEmail(rs.getString("student_email")); } catch (SQLException ignored) {}
                list.add(ea);
            }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private ExamAssignment mapRow(ResultSet rs) throws SQLException {
        ExamAssignment ea = new ExamAssignment();
        ea.setAssignmentId(rs.getInt("assignment_id"));
        ea.setApplicationId(rs.getInt("application_id"));
        ea.setExamId(rs.getInt("exam_id"));
        ea.setUserId(rs.getInt("user_id"));
        ea.setAssignedBy(rs.getInt("assigned_by"));
        ea.setAssignedDate(rs.getTimestamp("assigned_date"));
        ea.setResult(rs.getString("result"));
        ea.setScore(rs.getDouble("score"));
        try { ea.setExamName(rs.getString("exam_name")); } catch (SQLException ignored) {}
        try { ea.setExamType(rs.getString("exam_type")); } catch (SQLException ignored) {}
        try { ea.setExamTotalMarks(rs.getDouble("exam_total_marks")); } catch (SQLException ignored) {}
        try { ea.setCompanyName(rs.getString("company_name")); } catch (SQLException ignored) {}
        try { ea.setInternshipRole(rs.getString("internship_role")); } catch (SQLException ignored) {}
        return ea;
    }
}
