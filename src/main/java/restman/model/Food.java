package restman.model;


import java.util.Date;

public abstract class Food {
    private int id;
    private String name;
    private float price;
    private String description;
    private String thumbnail;
    private Date created_at;
    private Date updated_at;

    String type;

    public Food() {
    }

    public Food(int id, String name, float price, String description, String thumbnail, Date created_at, Date updated_at) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.thumbnail = thumbnail;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public Food(int id, String name, float price, String description, String thumbnail, Date updated_at) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.thumbnail = thumbnail;
        this.updated_at = updated_at;
    }

    public void setType(String type){
        this.type = type;
    }

    public String getType() {
        return this.type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }
}