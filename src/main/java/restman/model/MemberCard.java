package restman.model;


import java.util.Date;

public class MemberCard {
    private int id;
    private Date expiryDate;
    private Date createAt;
    private MemberCardType type;

    public MemberCard() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    public Date getCreateAt() { return createAt; }
    public void setCreateAt(Date createAt) { this.createAt = createAt; }
    public MemberCardType getType() { return type; }
    public void setType(MemberCardType type) { this.type = type; }
}
