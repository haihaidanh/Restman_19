package restman.model;


public class ComboDetail {
    private int id;
    private int quantity;
    private Dish dish;

    public ComboDetail() {
    }

    public ComboDetail(int id, int quantity, Dish dish) {
        this.id = id;
        this.quantity = quantity;
        this.dish = dish;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Dish getDish() {
        return dish;
    }

    public void setDish(Dish dish) {
        this.dish = dish;
    }
}