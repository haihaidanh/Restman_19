package restman.dao;

import restman.model.Table;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TableDAO extends DAO {

    public TableDAO() { super(); }

    public Table getTable(int id) {
        String sql = "SELECT id, type, capacity, status, location, description FROM `table` WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Table tbl = new Table();
                tbl.setId(rs.getInt("id"));
                try { tbl.setType(Table.Type.valueOf(rs.getString("type"))); }
                catch (Exception ignored) {}
                tbl.setCapacity(rs.getInt("capacity"));
                try { tbl.setStatus(Table.Status.valueOf(rs.getString("status"))); }
                catch (Exception ignored) {}
                tbl.setLocation(rs.getString("location"));
                tbl.setDescription(rs.getString("description"));
                return tbl;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
