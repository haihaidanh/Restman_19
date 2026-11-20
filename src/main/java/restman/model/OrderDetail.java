package restman.model;


public class OrderDetail {
    private int id;
    private int quantity;
    private float price;
    private String note;
    private Food food;
    private int order_id;

    public OrderDetail() {}
    public OrderDetail(Food food, int quantity, String note) {
        this.food = food;
        this.quantity = quantity;
        this.note = note;
        this.price = food.getPrice();
    }

    public float getTotal() { return price * quantity; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public float getPrice() { return price; }
    public void setPrice(float price) { this.price = price; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Food getFood() { return food; }
    public void setFood(Food food) { this.food = food; }
    public int getOrder_id() { return order_id; }
}