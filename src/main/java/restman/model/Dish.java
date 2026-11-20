package restman.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Dish extends Food {
    private List<Image> images = new ArrayList<>();

    public Dish() {}
    public Dish(int id, String name, float price, String description, String thumbnail, Date create_at, Date update_at) {
        super(id, name, price, description, thumbnail, create_at, update_at);
    }

    public Dish(int id, String name, float price, String description, String thumbnail, Date update_at) {
        super(id, name, price, description, thumbnail,update_at);
    }

    @Override public String getType() { return "Món ăn"; }

    public List<Image> getImages() { return images; }
    public void setImages(List<Image> images) { this.images = images; }
}