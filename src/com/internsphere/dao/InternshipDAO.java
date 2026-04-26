package com.internsphere.dao;

import com.internsphere.model.Internship;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class InternshipDAO {

    public void create(Internship internship) throws SQLException {
        String sql = "INSERT INTO internships (company_id, role, stipend, deadline) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getRole());
            ps.setBigDecimal(3, internship.getStipend());
            ps.setDate(4, internship.getDeadline());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public List<Internship> findAll() throws SQLException {
        String sql = "SELECT i.*, c.company_name, c.location, c.eligibility_cgpa FROM internships i JOIN companies c ON i.company_id = c.company_id ORDER BY i.deadline DESC";
        List<Internship> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public List<Internship> findEligible(BigDecimal cgpa) throws SQLException {
        String sql = "SELECT i.*, c.company_name, c.location, c.eligibility_cgpa FROM internships i JOIN companies c ON i.company_id = c.company_id WHERE c.eligibility_cgpa <= ? AND i.deadline >= CURDATE() ORDER BY i.deadline";
        List<Internship> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, cgpa);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public Internship findById(int internshipId) throws SQLException {
        String sql = "SELECT i.*, c.company_name, c.location, c.eligibility_cgpa FROM internships i JOIN companies c ON i.company_id = c.company_id WHERE i.internship_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, internshipId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void update(Internship internship) throws SQLException {
        String sql = "UPDATE internships SET company_id = ?, role = ?, stipend = ?, deadline = ? WHERE internship_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getRole());
            ps.setBigDecimal(3, internship.getStipend());
            ps.setDate(4, internship.getDeadline());
            ps.setInt(5, internship.getInternshipId());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void delete(int internshipId) throws SQLException {
        String sql = "DELETE FROM internships WHERE internship_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, internshipId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public boolean isDeadlinePassed(int internshipId) throws SQLException {
        String sql = "SELECT deadline < CURDATE() FROM internships WHERE internship_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, internshipId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getBoolean(1);
            return true;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public int getSelectedCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE status = 'SELECTED'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private Internship mapRow(ResultSet rs) throws SQLException {
        Internship i = new Internship();
        i.setInternshipId(rs.getInt("internship_id"));
        i.setCompanyId(rs.getInt("company_id"));
        i.setRole(rs.getString("role"));
        i.setStipend(rs.getBigDecimal("stipend"));
        i.setDeadline(rs.getDate("deadline"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        i.setCompanyName(rs.getString("company_name"));
        i.setCompanyLocation(rs.getString("location"));
        i.setEligibilityCgpa(rs.getBigDecimal("eligibility_cgpa"));
        return i;
    }
}
