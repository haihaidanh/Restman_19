package restman.dao;

import restman.model.Customer;
import restman.model.Reservation;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO extends DAO {

    private static final String BASE_SQL = """
            SELECT r.id AS res_id, r.number_of_guests, r.reservation_time,
                   r.create_at, r.status, r.note,
                   u.id AS cust_id, u.name AS cust_name, u.phone_number
            FROM reservation r
            JOIN customer c ON r.customer_id = c.id
            JOIN user u ON c.id = u.id
            """;

    public ReservationDAO() { super(); }

    public List<Reservation> getAllReservations() {
        String sql = BASE_SQL + """
                WHERE r.status IN ('PENDING','CONFIRMED')
                ORDER BY r.reservation_time DESC
                """;
        List<Reservation> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservation(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        loadDetails(list);
        return list;
    }

    public List<Reservation> getReservations(String customerPhone) {
        String sql = BASE_SQL + """
                WHERE u.phone_number LIKE ?
                  AND r.status IN ('PENDING','CONFIRMED')
                ORDER BY r.reservation_time DESC
                """;
        List<Reservation> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (customerPhone == null ? "" : customerPhone.trim()) + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservation(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        loadDetails(list);
        return list;
    }

    private Reservation mapReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setId(rs.getInt("res_id"));
        res.setNumberOfGuests(rs.getInt("number_of_guests"));
        res.setReservationTime(rs.getTimestamp("reservation_time"));
        res.setCreateAt(rs.getTimestamp("create_at"));
        try { res.setStatus(Reservation.Status.valueOf(rs.getString("status"))); }
        catch (Exception ignored) {}
        res.setNote(rs.getString("note"));

        Customer cust = new Customer();
        cust.setId(rs.getInt("cust_id"));
        cust.setName(rs.getString("cust_name"));
        cust.setPhoneNumber(rs.getString("phone_number"));
        res.setCustomer(cust);
        return res;
    }

    private void loadDetails(List<Reservation> list) {
        ReservationDetailDAO detailDAO = new ReservationDetailDAO();
        for (Reservation res : list) {
            res.getDetails().addAll(detailDAO.getMyReservation(res.getId()));
        }
    }
}