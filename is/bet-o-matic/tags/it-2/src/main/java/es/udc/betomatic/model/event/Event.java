package es.udc.betomatic.model.event;

import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.category.Category;

@Entity
@org.hibernate.annotations.BatchSize(size = 10)
public class Event {
	private Long id;
	private String name;
	private Calendar date;
	private Set<BetType> betTypes = new HashSet<BetType>();
	private Category category;
	private long version;
	
	public Event(){
	}
	
	public Event(String name, Calendar date, Category category) {
		this.name = name;
		this.date = date;
		this.category = category;
	}
	
	public Event(String name, Calendar date){
		this.name = name;
		this.date = date;
	}
	@Column(name="eventId")
    @SequenceGenerator(           // It only takes effect for
         name="EventIdGenerator", // databases providing identifier
         sequenceName="EventSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="EventIdGenerator")
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
    @Temporal(TemporalType.TIMESTAMP)
   	public Calendar getDate() {
		return date;
	}
	public void setDate(Calendar _date) {
		this.date = _date;
	}
	@OneToMany(mappedBy = "event")
	public Set<BetType> getBetTypes() {
		return betTypes;
	}
	public void setBetTypes(Set<BetType> betTypes) {
		this.betTypes = betTypes;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="catId")
	public Category getCategory() {
		return category;
	}
	public void setCategory(Category category) {
		this.category = category;
	}
    @Version
    public long getVersion() {
        return version;
    }
    public void setVersion(long version) {
        this.version = version;
    }
    
    public void addBetType(BetType betType){
    	betTypes.add(betType);
    	betType.setEvent(this);
    }
}
