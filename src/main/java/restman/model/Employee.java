package restman.model;


import java.util.Date;

public class Employee extends User {
    private Date startDate;
    private String position;

    public Employee() {}

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
