package com.internsphere.dao;

import com.internsphere.util.DBUtil;
import java.sql.*;

public class SessionTrackingDAO {

    public void create(String sessionId, int userId, String ipAddress, String userAgent) throws SQLException {
        // Remove existing session for this user first
        delete(userId);
        String sql = "INSERT INTO session_tracking (session_id, user_id, ip_address, user_agent) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, userId);
            ps.setString(3, ipAddress);
            ps.setString(4, userAgent);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public String findSessionByUser(int userId) throws SQLException {
        String sql = "SELECT session_id FROM session_tracking WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getString("session_id");
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void delete(int userId) throws SQLException {
        String sql = "DELETE FROM session_tracking WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void deleteBySessionId(String sessionId) throws SQLException {
        String sql = "DELETE FROM session_tracking WHERE session_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void updateActivity(String sessionId) throws SQLException {
        String sql = "UPDATE session_tracking SET last_activity = CURRENT_TIMESTAMP WHERE session_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }
}
