package restman.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Combo extends Food {
    private Date startDate;
    private Date endDate;
    private List<ComboDetail> dishes = new ArrayList<>();

    public Combo() {
    }

    public Combo(int id, String name, float price, String description, String thumbnail, Date create_at, Date update_at,
                 Date startDate, Date endDate) {
        super(id, name, price, description, thumbnail, create_at, update_at);
        this.startDate = startDate;
        this.endDate = endDate;
    }

    @Override
    public String getType() {
        return "Combo";
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public List<ComboDetail> getDishes() {
        return dishes;
    }

    public void setDishes(List<ComboDetail> dishes) {
        this.dishes = dishes;
    }
}