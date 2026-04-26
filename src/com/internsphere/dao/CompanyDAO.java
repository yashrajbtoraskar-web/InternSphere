package com.internsphere.dao;

import com.internsphere.model.Company;
import com.internsphere.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public void create(Company company) throws SQLException {
        String sql = "INSERT INTO companies (company_name, location, eligibility_cgpa) VALUES (?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getLocation());
            ps.setBigDecimal(3, company.getEligibilityCgpa());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public List<Company> findAll() throws SQLException {
        String sql = "SELECT * FROM companies ORDER BY company_name";
        List<Company> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public Company findById(int companyId) throws SQLException {
        String sql = "SELECT * FROM companies WHERE company_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, companyId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    public void update(Company company) throws SQLException {
        String sql = "UPDATE companies SET company_name = ?, location = ?, eligibility_cgpa = ? WHERE company_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getLocation());
            ps.setBigDecimal(3, company.getEligibilityCgpa());
            ps.setInt(4, company.getCompanyId());
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public void delete(int companyId) throws SQLException {
        String sql = "DELETE FROM companies WHERE company_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, companyId);
            ps.executeUpdate();
        } finally { DBUtil.close(ps, conn); }
    }

    public int getCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM companies";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally { DBUtil.close(rs, ps, conn); }
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setCompanyId(rs.getInt("company_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setLocation(rs.getString("location"));
        c.setEligibilityCgpa(rs.getBigDecimal("eligibility_cgpa"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
