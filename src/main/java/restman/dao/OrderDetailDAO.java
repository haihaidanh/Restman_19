package restman.dao;

import restman.model.OrderDetail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class OrderDetailDAO extends DAO {

    public OrderDetailDAO() {
        super();
    }

    public OrderDetailDAO(Connection con) {
        this.con = con;
    }

    public boolean insertDetail(OrderDetail detail, int orderId)
            throws SQLException {

        String sql = """
                INSERT INTO order_detail
                (order_id, food_id, quantity, price, note)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, detail.getFood().getId());
            ps.setInt(3, detail.getQuantity());
            ps.setFloat(4, detail.getPrice());
            ps.setString(5, detail.getNote());

            return ps.executeUpdate() > 0;
        }
    }
}
