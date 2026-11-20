package restman.dao;

import restman.model.OnlineOrder;
import restman.model.OrderDetail;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class OnlineOrderDAO extends DAO {

    public OnlineOrderDAO() { super(); }

    public boolean insert(OnlineOrder order) {
        String sqlOrder = "INSERT INTO `order` (created_at, note, status) VALUES (NOW(), ?, 'PENDING')";
        String sqlOnline = "INSERT INTO online_order (order_id, reservation_id) VALUES (?, ?)";
        try {
            con.setAutoCommit(false);

            int orderId;
            try (PreparedStatement ps = con.prepareStatement(
                    sqlOrder, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, order.getNote());
                ps.executeUpdate();

                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (!gk.next()) {
                        throw new SQLException("Cannot get order ID");
                    }
                    orderId = gk.getInt(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlOnline)) {
                ps.setInt(1, orderId);
                ps.setInt(2, order.getReservation().getId());
                ps.executeUpdate();
            }

            OrderDetailDAO detailDAO = new OrderDetailDAO(con);

            for (OrderDetail d : order.getOrderDetail()) {
                if (!detailDAO.insertDetail(d, orderId)) {
                    throw new SQLException("Insert order detail failed");
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { con.rollback(); } catch (SQLException ignored) {}
        } finally {
            try { con.setAutoCommit(true); } catch (SQLException ignored) {}
        }
        return false;
    }
}