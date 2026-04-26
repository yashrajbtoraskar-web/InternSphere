package com.internsphere.dao;

import com.internsphere.model.Application;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public void create(int studentId, int internshipId, Connection conn) throws SQLException {
        String sql = "INSERT INTO applications (student_id, internship_id) VALUES (?, ?)";
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps); }
    }

    public void logAction(int applicationId, String action, Connection conn) throws SQLException {
        String sql = "INSERT INTO application_logs (application_id, action) VALUES (?, ?)";
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, applicationId);
            ps.setString(2, action);
            ps.executeUpdate();
        } finally { DBUtil.close(ps); }
    }

    public int applyWithTransaction(int studentId, int internshipId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            // Insert application
            String sql = "INSERT INTO applications (student_id, internship_id) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            int appId = -1;
            if (rs.next()) appId = rs.getInt(1);
            DBUtil.close(rs, ps);
            // Log action
            logAction(appId, "APPLIED", conn);
            conn.commit();
            return appId;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    public boolean isDuplicate(int studentId, int internshipId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND internship_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, internshipId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            return false;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Application> findAll() throws SQLException {
        String sql = "SELECT a.*, u.name AS student_name, u.email AS student_email, i.role AS internship_role, c.company_name, s.user_id " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN internships i ON a.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "ORDER BY a.applied_date DESC";
        List<Application> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Application> findByStudent(int studentId) throws SQLException {
        String sql = "SELECT a.*, u.name AS student_name, u.email AS student_email, i.role AS internship_role, c.company_name " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN internships i ON a.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "WHERE a.student_id = ? ORDER BY a.applied_date DESC";
        List<Application> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void updateStatus(int applicationId, String status) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            String sql = "UPDATE applications SET status = ? WHERE application_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, applicationId);
            ps.executeUpdate();
            DBUtil.close(ps);
            logAction(applicationId, status, conn);
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    public int getPendingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE status = 'APPLIED'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Application> findRecent(int limit) throws SQLException {
        String sql = "SELECT a.*, u.name AS student_name, u.email AS student_email, i.role AS internship_role, c.company_name " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN internships i ON a.internship_id = i.internship_id " +
                     "JOIN companies c ON i.company_id = c.company_id " +
                     "ORDER BY a.applied_date DESC LIMIT ?";
        List<Application> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public int getCountByStudent(int studentId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ?" + (status != null ? " AND status = ?" : "");
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            if (status != null) ps.setString(2, status);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setInternshipId(rs.getInt("internship_id"));
        a.setStatus(rs.getString("status"));
        a.setAppliedDate(rs.getTimestamp("applied_date"));
        a.setStudentName(rs.getString("student_name"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setInternshipRole(rs.getString("internship_role"));
        a.setCompanyName(rs.getString("company_name"));
        try { a.setUserId(rs.getInt("user_id")); } catch (SQLException ignored) {}
        return a;
    }
}
