package restman.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Order {
    public enum Status {PENDING, CONFIRMED, PAID, CANCELLED}

    private int id;
    private Date createdAt;
    private String note;
    private Status status = Status.PENDING;
    private List<OrderDetail> orderDetail = new ArrayList<>();
    private SaleStaff saleStaff;

    public Order() {
        this.createdAt = new Date();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public List<OrderDetail> getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(List<OrderDetail> orderDetail) {
        this.orderDetail = orderDetail;
    }

    public SaleStaff getSaleStaff() {
        return saleStaff;
    }

    public void setSaleStaff(SaleStaff saleStaff) {
        this.saleStaff = saleStaff;
    }
}