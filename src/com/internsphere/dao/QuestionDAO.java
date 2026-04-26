package com.internsphere.dao;

import com.internsphere.model.Question;
import com.internsphere.model.Option;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public void create(Question question) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            String sql = "INSERT INTO questions (exam_id, question_text, type, marks) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, question.getExamId());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getType());
            ps.setInt(4, question.getMarks());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            int qId = -1;
            if (rs.next()) qId = rs.getInt(1);
            DBUtil.close(rs, ps);
            if ("MCQ".equals(question.getType()) && question.getOptions() != null) {
                String optSql = "INSERT INTO options (question_id, option_text, is_correct) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(optSql);
                for (Option opt : question.getOptions()) {
                    ps.setInt(1, qId);
                    ps.setString(2, opt.getOptionText());
                    ps.setBoolean(3, opt.isCorrect());
                    ps.addBatch();
                }
                ps.executeBatch();
                DBUtil.close(ps);
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    public List<Question> findByExam(int examId) throws SQLException {
        String sql = "SELECT * FROM questions WHERE exam_id = ? ORDER BY question_id";
        List<Question> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Question q = mapRow(rs);
                if ("MCQ".equals(q.getType())) {
                    q.setOptions(findOptionsByQuestion(q.getQuestionId(), conn));
                }
                list.add(q);
            }
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public Question findById(int questionId) throws SQLException {
        String sql = "SELECT * FROM questions WHERE question_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Question q = mapRow(rs);
                if ("MCQ".equals(q.getType())) {
                    q.setOptions(findOptionsByQuestion(q.getQuestionId(), conn));
                }
                return q;
            }
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void delete(int questionId) throws SQLException {
        String sql = "DELETE FROM questions WHERE question_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    private List<Option> findOptionsByQuestion(int questionId, Connection conn) throws SQLException {
        String sql = "SELECT * FROM options WHERE question_id = ? ORDER BY option_id";
        List<Option> list = new ArrayList<>();
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Option o = new Option();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(rs.getInt("question_id"));
                o.setOptionText(rs.getString("option_text"));
                o.setCorrect(rs.getBoolean("is_correct"));
                list.add(o);
            }
            return list;
        } finally { DBUtil.close(rs, ps); }
    }

    private Question mapRow(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("question_id"));
        q.setExamId(rs.getInt("exam_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setType(rs.getString("type"));
        try { q.setSection(rs.getString("section")); } catch (SQLException ignored) {}
        q.setMarks(rs.getInt("marks"));
        try { q.setExplanation(rs.getString("explanation")); } catch (SQLException ignored) {}
        return q;
    }
}
