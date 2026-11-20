package restman.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Reservation {
    public enum Status { PENDING, CONFIRMED, CHECKED_IN, CANCELLED }

    private int id;
    private int numberOfGuests;
    private Date reservationTime;
    private Date createAt;
    private Status status;
    private String note;
    private Customer customer;
    private List<ReservationDetail> details = new ArrayList<>();

    public Reservation() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getNumberOfGuests() { return numberOfGuests; }
    public void setNumberOfGuests(int numberOfGuests) { this.numberOfGuests = numberOfGuests; }
    public Date getReservationTime() { return reservationTime; }
    public void setReservationTime(Date reservationTime) { this.reservationTime = reservationTime; }
    public Date getCreateAt() { return createAt; }
    public void setCreateAt(Date createAt) { this.createAt = createAt; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    public List<ReservationDetail> getDetails() { return details; }
    public void setDetails(List<ReservationDetail> details) { this.details = details; }
}
