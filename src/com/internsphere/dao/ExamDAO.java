package com.internsphere.dao;

import com.internsphere.model.Exam;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public void create(Exam exam) throws SQLException {
        String sql = "INSERT INTO exams (exam_name, duration, start_time, end_time, total_marks) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, exam.getExamName());
            ps.setInt(2, exam.getDuration());
            ps.setTimestamp(3, exam.getStartTime());
            ps.setTimestamp(4, exam.getEndTime());
            ps.setInt(5, exam.getTotalMarks());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public List<Exam> findAll() throws SQLException {
        String sql = "SELECT e.*, (SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.exam_id) AS question_count FROM exams e ORDER BY e.start_time DESC";
        List<Exam> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) { Exam ex = mapRow(rs); ex.setQuestionCount(rs.getInt("question_count")); list.add(ex); }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Exam> findByType(String examType) throws SQLException {
        String sql = "SELECT e.*, (SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.exam_id) AS question_count FROM exams e WHERE e.exam_type = ? ORDER BY e.start_time DESC";
        List<Exam> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, examType);
            rs = ps.executeQuery();
            while (rs.next()) { Exam ex = mapRow(rs); ex.setQuestionCount(rs.getInt("question_count")); list.add(ex); }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public Exam findById(int examId) throws SQLException {
        String sql = "SELECT * FROM exams WHERE exam_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void update(Exam exam) throws SQLException {
        String sql = "UPDATE exams SET exam_name = ?, duration = ?, start_time = ?, end_time = ?, total_marks = ? WHERE exam_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, exam.getExamName());
            ps.setInt(2, exam.getDuration());
            ps.setTimestamp(3, exam.getStartTime());
            ps.setTimestamp(4, exam.getEndTime());
            ps.setInt(5, exam.getTotalMarks());
            ps.setInt(6, exam.getExamId());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void delete(int examId) throws SQLException {
        String sql = "DELETE FROM exams WHERE exam_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    private Exam mapRow(ResultSet rs) throws SQLException {
        Exam e = new Exam();
        e.setExamId(rs.getInt("exam_id"));
        e.setExamName(rs.getString("exam_name"));
        try { e.setExamType(rs.getString("exam_type")); } catch (SQLException ignored) {}
        e.setDuration(rs.getInt("duration"));
        e.setStartTime(rs.getTimestamp("start_time"));
        e.setEndTime(rs.getTimestamp("end_time"));
        e.setTotalMarks(rs.getInt("total_marks"));
        try { e.setPassingPercentage(rs.getInt("passing_percentage")); } catch (SQLException ignored) {}
        return e;
    }
}
