package restman.dao;

import restman.model.Account;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO extends DAO {

    public AccountDAO() { super(); }

    public Account login(String username, String password) {
        String sql = "SELECT id, username, password, type FROM account WHERE username = ? AND password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setId(rs.getInt("id"));
                acc.setUsername(rs.getString("username"));
                acc.setPassword(rs.getString("password"));
                try {
                    acc.setType(Account.Type.valueOf(rs.getString("type")));
                } catch (Exception ignored) {}
                return acc;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

