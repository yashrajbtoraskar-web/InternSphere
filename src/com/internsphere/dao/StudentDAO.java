package com.internsphere.dao;

import com.internsphere.model.Student;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public void create(Student student) throws SQLException {
        String sql = "INSERT INTO students (student_id, user_id, course, cgpa, phone) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, student.getStudentId());
            ps.setInt(2, student.getUserId());
            ps.setString(3, student.getCourse());
            ps.setBigDecimal(4, student.getCgpa());
            ps.setString(5, student.getPhone());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public Student findByUserId(int userId) throws SQLException {
        String sql = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.user_id WHERE s.user_id = ?";
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

    public Student findByStudentId(int studentId) throws SQLException {
        String sql = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.user_id WHERE s.student_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void update(Student student) throws SQLException {
        String sql = "UPDATE students SET course = ?, cgpa = ?, phone = ? WHERE student_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, student.getCourse());
            ps.setBigDecimal(2, student.getCgpa());
            ps.setString(3, student.getPhone());
            ps.setInt(4, student.getStudentId());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public List<Student> findAll() throws SQLException {
        String sql = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.user_id ORDER BY s.student_id";
        List<Student> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public int getNextStudentId() throws SQLException {
        String sql = "SELECT COALESCE(MAX(student_id), 1000) + 1 FROM students";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 1001;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setCourse(rs.getString("course"));
        s.setCgpa(rs.getBigDecimal("cgpa"));
        s.setPhone(rs.getString("phone"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        return s;
    }
}
