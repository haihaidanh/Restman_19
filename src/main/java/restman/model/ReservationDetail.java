package restman.model;


public class ReservationDetail {
    private int id;
    private Table table;

    public ReservationDetail() {}
    public ReservationDetail(int id, Table table) { this.id = id; this.table = table; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Table getTable() { return table; }
    public void setTable(Table table) { this.table = table; }
}