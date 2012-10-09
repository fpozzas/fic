package es.udc.betomatic.model.bettype;

import java.util.LinkedList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.event.Event;

@Entity
@org.hibernate.annotations.BatchSize(size = 10)
public class BetType {

	private Long id;
	private String question;
	private boolean multipleWinner;
	private Event event;
	private boolean winner;
	private List<BetOption> options = new LinkedList<BetOption>();
	private long version;
	
	public BetType() {}
	
    public BetType(String question, boolean multipleWinner) {
		this.question = question;
		this.multipleWinner = multipleWinner;
	}
    
	@Column(name="bettypeId")
    @SequenceGenerator(           // It only takes effect for
         name="BetTypeIdGenerator", // databases providing identifier
         sequenceName="BetTypeSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="BetTypeIdGenerator")
	public Long getId() {
		return id;
	}
    public void setId(Long id) {
		this.id = id;
	}
	public void setQuestion(String question) {
		this.question = question;
	}
	public String getQuestion() {
		return question;
	}
	public void setMultipleWinner(boolean multipleWinner) {
		this.multipleWinner = multipleWinner;
	}
	public boolean getMultipleWinner() {
		return multipleWinner;
	}
	@OneToMany(mappedBy = "betType")
	public List<BetOption> getOptions() {
		return options;
	}
	public void setOptions(List<BetOption> options) {
		this.options = options;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="eventId")
	public Event getEvent() {
		return event;
	}
	public void setEvent(Event event) {
		this.event = event;
	}
    @Version
    public long getVersion() {
        return version;
    }
    public void setVersion(long version) {
        this.version = version;
    }
	public boolean getWinner() {
		return winner;
	}
	public void setWinner(boolean winner) {
		this.winner = winner;
	}

	public void addOptions(List<BetOption> betOptions) {
		options = betOptions;
		for (BetOption opt : betOptions){
			opt.setBetType(this);
		}
	}
}
