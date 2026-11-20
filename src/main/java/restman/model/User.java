package restman.model;

import java.util.ArrayList;
import java.util.List;

public class User {
    private int id;
    private String name;
    private String phoneNumber;
    private String email;
    private int age;
    private List<Address> address = new ArrayList<>();
    private List<Account> account = new ArrayList<>();

    public User() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public List<Address> getAddress() { return address; }
    public void setAddress(List<Address> address) { this.address = address; }
    public List<Account> getAccount() { return account; }
    public void setAccount(List<Account> account) { this.account = account; }
}