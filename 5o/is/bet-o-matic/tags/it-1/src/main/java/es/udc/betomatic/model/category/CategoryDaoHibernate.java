package es.udc.betomatic.model.category;

import org.springframework.stereotype.Repository;
import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("categoryDao")
public class CategoryDaoHibernate
	extends GenericDaoHibernate<Category, Long>
	implements CategoryDao {
}
