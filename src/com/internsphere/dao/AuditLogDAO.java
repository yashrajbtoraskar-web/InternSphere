package com.internsphere.dao;

import com.internsphere.model.AuditLog;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public void log(Integer userId, String action, String ipAddress, String userAgent) throws SQLException {
        String sql = "INSERT INTO audit_logs (user_id, action, ip_address, user_agent) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            if (userId != null) ps.setInt(1, userId); else ps.setNull(1, Types.INTEGER);
            ps.setString(2, action);
            ps.setString(3, ipAddress);
            ps.setString(4, userAgent);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public List<AuditLog> findAll() throws SQLException {
        String sql = "SELECT al.*, u.name AS user_name FROM audit_logs al LEFT JOIN users u ON al.user_id = u.user_id ORDER BY al.log_time DESC";
        List<AuditLog> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<AuditLog> findSuspicious() throws SQLException {
        String sql = "SELECT al.*, u.name AS user_name FROM audit_logs al LEFT JOIN users u ON al.user_id = u.user_id " +
                     "WHERE al.action LIKE '%TAB_SWITCH%' OR al.action LIKE '%SUSPICIOUS%' OR al.action LIKE '%MULTIPLE_LOGIN%' " +
                     "ORDER BY al.log_time DESC";
        List<AuditLog> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<AuditLog> findRecent(int limit) throws SQLException {
        String sql = "SELECT al.*, u.name AS user_name FROM audit_logs al LEFT JOIN users u ON al.user_id = u.user_id ORDER BY al.log_time DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
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

    private AuditLog mapRow(ResultSet rs) throws SQLException {
        AuditLog al = new AuditLog();
        al.setLogId(rs.getInt("log_id"));
        int uid = rs.getInt("user_id");
        al.setUserId(rs.wasNull() ? null : uid);
        al.setAction(rs.getString("action"));
        al.setIpAddress(rs.getString("ip_address"));
        al.setUserAgent(rs.getString("user_agent"));
        al.setLogTime(rs.getTimestamp("log_time"));
        al.setUserName(rs.getString("user_name"));
        return al;
    }
}
