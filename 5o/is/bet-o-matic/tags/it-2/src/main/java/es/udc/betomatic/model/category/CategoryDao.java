package es.udc.betomatic.model.category;

import java.util.List;
import es.udc.pojo.modelutil.dao.GenericDao;

public interface CategoryDao
	extends GenericDao<Category, Long> {
	
	public List<Category> allCategories();

}
