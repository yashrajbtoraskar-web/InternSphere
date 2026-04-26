package com.internsphere.dao;

import com.internsphere.model.Answer;
import com.internsphere.util.DBUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {

    public void upsert(int attemptId, int questionId, Integer selectedOption, String descriptiveAnswer) throws SQLException {
        String sql = "INSERT INTO answers (attempt_id, question_id, selected_option, descriptive_answer) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE selected_option = VALUES(selected_option), descriptive_answer = VALUES(descriptive_answer)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            if (selectedOption != null) ps.setInt(3, selectedOption); else ps.setNull(3, Types.INTEGER);
            if (descriptiveAnswer != null) ps.setString(4, descriptiveAnswer); else ps.setNull(4, Types.VARCHAR);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void zeroAllMarks(int attemptId) throws SQLException {
        String sql = "UPDATE answers SET marks_awarded = 0 WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void submitAndEvaluate(int attemptId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            // Auto-evaluate MCQ answers
            String evalSql = "UPDATE answers a " +
                "JOIN questions q ON a.question_id = q.question_id " +
                "JOIN options o ON a.selected_option = o.option_id " +
                "SET a.marks_awarded = CASE WHEN o.is_correct = TRUE THEN q.marks ELSE 0 END " +
                "WHERE a.attempt_id = ? AND q.type = 'MCQ'";
            PreparedStatement ps = conn.prepareStatement(evalSql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
            DBUtil.close(ps);
            // Update attempt status
            String statusSql = "UPDATE exam_attempts SET status = 'SUBMITTED', end_time = CURRENT_TIMESTAMP WHERE attempt_id = ?";
            ps = conn.prepareStatement(statusSql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
            DBUtil.close(ps);
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    public void autoSubmit(int attemptId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            String evalSql = "UPDATE answers a " +
                "JOIN questions q ON a.question_id = q.question_id " +
                "JOIN options o ON a.selected_option = o.option_id " +
                "SET a.marks_awarded = CASE WHEN o.is_correct = TRUE THEN q.marks ELSE 0 END " +
                "WHERE a.attempt_id = ? AND q.type = 'MCQ'";
            PreparedStatement ps = conn.prepareStatement(evalSql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
            DBUtil.close(ps);
            String statusSql = "UPDATE exam_attempts SET status = 'AUTO_SUBMITTED', end_time = CURRENT_TIMESTAMP WHERE attempt_id = ?";
            ps = conn.prepareStatement(statusSql);
            ps.setInt(1, attemptId);
            ps.executeUpdate();
            DBUtil.close(ps);
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    public List<Answer> findByAttempt(int attemptId) throws SQLException {
        String sql = "SELECT a.*, q.question_text, q.type AS question_type, q.section, q.explanation, q.marks AS question_marks, " +
                     "(SELECT o.option_text FROM options o WHERE o.option_id = a.selected_option) AS selected_option_text, " +
                     "(SELECT o.option_text FROM options o WHERE o.question_id = q.question_id AND o.is_correct = TRUE LIMIT 1) AS correct_option_text " +
                     "FROM answers a JOIN questions q ON a.question_id = q.question_id WHERE a.attempt_id = ? ORDER BY a.question_id";
        List<Answer> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void gradeSubjective(int answerId, BigDecimal marks) throws SQLException {
        String sql = "UPDATE answers SET marks_awarded = ? WHERE answer_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, marks);
            ps.setInt(2, answerId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public double getTotalMarks(int attemptId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(marks_awarded), 0) FROM answers WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Answer> findSubjectiveByExam(int examId) throws SQLException {
        String sql = "SELECT a.*, q.question_text, q.type AS question_type FROM answers a " +
                     "JOIN questions q ON a.question_id = q.question_id " +
                     "JOIN exam_attempts ea ON a.attempt_id = ea.attempt_id " +
                     "WHERE ea.exam_id = ? AND q.type = 'SUBJECTIVE' ORDER BY a.attempt_id, a.question_id";
        List<Answer> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private Answer mapRow(ResultSet rs) throws SQLException {
        Answer a = new Answer();
        a.setAnswerId(rs.getInt("answer_id"));
        a.setAttemptId(rs.getInt("attempt_id"));
        a.setQuestionId(rs.getInt("question_id"));
        int sel = rs.getInt("selected_option");
        a.setSelectedOption(rs.wasNull() ? null : sel);
        a.setDescriptiveAnswer(rs.getString("descriptive_answer"));
        a.setMarksAwarded(rs.getBigDecimal("marks_awarded"));
        a.setQuestionText(rs.getString("question_text"));
        a.setQuestionType(rs.getString("question_type"));
        try { a.setSection(rs.getString("section")); } catch (SQLException ignored) {}
        try { a.setExplanation(rs.getString("explanation")); } catch (SQLException ignored) {}
        try { a.setSelectedOptionText(rs.getString("selected_option_text")); } catch (SQLException ignored) {}
        try { a.setCorrectOptionText(rs.getString("correct_option_text")); } catch (SQLException ignored) {}
        try { a.setQuestionMarks(rs.getInt("question_marks")); } catch (SQLException ignored) {}
        return a;
    }
}
