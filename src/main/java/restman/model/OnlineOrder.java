package restman.model;

import java.util.Date;

public class OnlineOrder extends Order {
    private Date arrivalTime;
    private Reservation reservation;

    public OnlineOrder() { super(); }
    public OnlineOrder(Reservation reservation) {
        super();
        this.reservation = reservation;
    }

    public Date getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Date arrivalTime) { this.arrivalTime = arrivalTime; }
    public Reservation getReservation() { return reservation; }
    public void setReservation(Reservation reservation) { this.reservation = reservation; }
}
