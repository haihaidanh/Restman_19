package restman.model;


public class Restaurant {
    private int id;
    private String name;
    private String address;
    private String open_time;
    private String close_time;
    private String email;
    private String phone_number;

    public Restaurant() {
    }

    public Restaurant(int id, String name, String address, String open_time, String close_time, String email, String phone_number) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.open_time = open_time;
        this.close_time = close_time;
        this.email = email;
        this.phone_number = phone_number;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getOpen_time() {
        return open_time;
    }

    public void setOpen_time(String open_time) {
        this.open_time = open_time;
    }

    public String getClose_time() {
        return close_time;
    }

    public void setClose_time(String close_time) {
        this.close_time = close_time;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }
}