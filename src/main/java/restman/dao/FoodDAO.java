package restman.dao;

import restman.model.Combo;
import restman.model.ComboDetail;
import restman.model.Dish;
import restman.model.Food;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class FoodDAO extends DAO {

    public FoodDAO() {
        super();
    }

    public List<Food> getFood(String keyword) {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.id, f.name, f.price, f.description, f.thumbnail, f.created_at, f.updated_at, " +
                "c.start_date, c.end_date " +
                "FROM food f LEFT JOIN combo c ON f.id = c.food_id WHERE 1=1";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND f.name LIKE ?";
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Date startDate = rs.getDate("start_date");
                if (startDate != null) {
                    Combo c = new Combo(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getFloat("price"),
                            rs.getString("description"),
                            rs.getString("thumbnail"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at"),
                            startDate,
                            rs.getDate("end_date")
                    );
                    list.add(c);
                } else {
                    Dish d = new Dish(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getFloat("price"),
                            rs.getString("description"),
                            rs.getString("thumbnail"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Food getFood(int id) {
        String sql = "SELECT f.id, f.name, f.price, f.description, f.thumbnail, f.created_at, f.updated_at, " +
                "c.start_date, c.end_date " +
                "FROM food f LEFT JOIN combo c ON f.id = c.food_id " +
                "WHERE f.id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Date startDate = rs.getDate("start_date");

                if (startDate != null) {
                    Combo c = new Combo(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getFloat("price"),
                            rs.getString("description"),
                            rs.getString("thumbnail"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at"),
                            startDate,
                            rs.getDate("end_date")
                    );
                    c.setDishes(getComboDetails(id));
                    return c;
                } else {
                    Dish d = new Dish(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getFloat("price"),
                            rs.getString("description"),
                            rs.getString("thumbnail"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    d.setImages(new ImageDAO().getImagesByDishId(id));
                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateFood(Food food) {
        String sql = "UPDATE food SET name = ?, price = ?, description = ?, thumbnail = ?, updated_at = NOW() WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, food.getName());
            ps.setFloat(2, food.getPrice());
            ps.setString(3, food.getDescription());
            ps.setString(4, food.getThumbnail());
            ps.setInt(5, food.getId());
            boolean ok = ps.executeUpdate() > 0;
            if (ok && food instanceof Combo) {
                Combo c = (Combo) food;
                String comboSql = "UPDATE combo SET end_date = ? WHERE food_id = ?";
                try (PreparedStatement psCombo = con.prepareStatement(comboSql)) {
                    if (c.getEndDate() != null) {
                        psCombo.setDate(1, new java.sql.Date(c.getEndDate().getTime()));
                    } else {
                        psCombo.setNull(1, java.sql.Types.DATE);
                    }
                    psCombo.setInt(2, c.getId());
                    psCombo.executeUpdate();
                }
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ComboDetail> getComboDetails(int comboId) {
        List<ComboDetail> list = new ArrayList<>();
        String sql = "SELECT cd.id, cd.combo_id, cd.dish_id, cd.quantity, " +
                "f.name, f.price, f.description, f.thumbnail " +
                "FROM combo_detail cd " +
                "JOIN food f ON cd.dish_id = f.id " +
                "WHERE cd.combo_id = ? ORDER BY cd.id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Dish d = new Dish();
                d.setId(rs.getInt("dish_id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getFloat("price"));
                d.setDescription(rs.getString("description"));
                d.setThumbnail(rs.getString("thumbnail"));

                ComboDetail cd = new ComboDetail(rs.getInt("id"), rs.getInt("quantity"), d);
                list.add(cd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Dish> getAllDishes() {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT f.id, f.name, f.price, f.description, f.thumbnail " +
                "FROM food f " +
                "LEFT JOIN combo c ON f.id = c.food_id " +
                "WHERE c.food_id IS NULL ORDER BY f.name ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Dish d = new Dish();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getFloat("price"));
                d.setDescription(rs.getString("description"));
                d.setThumbnail(rs.getString("thumbnail"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateComboDetails(int comboId, List<ComboDetail> details) {
        String deleteSql = "DELETE FROM combo_detail WHERE combo_id = ?";
        String insertSql = "INSERT INTO combo_detail(combo_id, dish_id, quantity) VALUES (?, ?, ?)";
        try {
            con.setAutoCommit(false);
            try (PreparedStatement psDel = con.prepareStatement(deleteSql)) {
                psDel.setInt(1, comboId);
                psDel.executeUpdate();
            }
            if (details != null && !details.isEmpty()) {
                try (PreparedStatement psIns = con.prepareStatement(insertSql)) {
                    for (ComboDetail cd : details) {
                        if (cd.getDish() != null && cd.getDish().getId() > 0 && cd.getQuantity() > 0) {
                            psIns.setInt(1, comboId);
                            psIns.setInt(2, cd.getDish().getId());
                            psIns.setInt(3, cd.getQuantity());
                            psIns.addBatch();
                        }
                    }
                    psIns.executeBatch();
                }
            }
            con.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}