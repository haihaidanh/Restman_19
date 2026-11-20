package restman.dao;

import restman.model.ReservationDetail;
import restman.model.Table;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservationDetailDAO extends DAO {

    public ReservationDetailDAO() { super(); }

    public List<ReservationDetail> getMyReservation(int reservationId) {
        List<ReservationDetail> list = new ArrayList<>();
        String sql = "SELECT id, table_id FROM reservation_detail WHERE reservation_id = ?";
        TableDAO tableDAO = new TableDAO();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Table tbl = tableDAO.getTable(rs.getInt("table_id"));
                list.add(new ReservationDetail(rs.getInt("id"), tbl));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}