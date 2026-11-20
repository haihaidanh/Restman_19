package restman.model;

public class Customer extends User {
    private MemberCard memberCard;

    public Customer() { super(); }

    public MemberCard getMemberCard() { return memberCard; }
    public void setMemberCard(MemberCard memberCard) { this.memberCard = memberCard; }
}
