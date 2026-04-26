package com.internsphere.dao;

import com.internsphere.model.User;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User authenticate(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public int create(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
            return -1;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void updateLoginStatus(int userId, boolean status) throws SQLException {
        String sql = "UPDATE users SET is_logged_in = ?, last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public int getTotalStudents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'STUDENT'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setLoggedIn(rs.getBoolean("is_logged_in"));
        u.setLastLogin(rs.getTimestamp("last_login"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
