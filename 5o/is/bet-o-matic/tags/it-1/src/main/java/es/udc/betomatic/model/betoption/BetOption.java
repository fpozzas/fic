package es.udc.betomatic.model.betoption;

import es.udc.betomatic.model.bettype.BetType;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

@Entity
public class BetOption {
	private Long id;
	private String name;
	private BigDecimal quota;
	private boolean winner;
	private BetType betType;
	private long version;
	
	public BetOption(){
	}
	
    public BetOption(String name, BigDecimal quota, boolean winner,
			BetType betType) {
		this.name = name;
		this.quota = quota;
		this.winner = winner;
		this.betType = betType;
	}
	@Column(name="betOptionId")
    @SequenceGenerator(           // It only takes effect for
         name="BetOpIdGenerator", // databases providing identifier
         sequenceName="BetOpSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="BetOpIdGenerator")
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setQuota(BigDecimal quota) {
		this.quota = quota;
	}
	public BigDecimal getQuota() {
		return quota;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName() {
		return name;
	}
	public void setWinner(boolean winner) {
		this.winner = winner;
	}
	public boolean getWinner() {
		return winner;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="bettypeId")
	public BetType getBetType() {
		return betType;
	}
	public void setBetType(BetType betType) {
		this.betType = betType;
	}
    @Version
    public long getVersion() {
        return version;
    }
    public void setVersion(long version) {
        this.version = version;
    }

}
