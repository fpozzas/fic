package es.udc.betomatic.model.category;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;

@Entity
public class Category {
	
	private long id;
	private String name;

	public Category(){
	}
	public Category(String name) {
		this.name = name;
	}
	@Column(name="catId")
    @SequenceGenerator(           // It only takes effect for
         name="CategoryIdGenerator", // databases providing identifier
         sequenceName="CategorySeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="CategoryIdGenerator")
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}
