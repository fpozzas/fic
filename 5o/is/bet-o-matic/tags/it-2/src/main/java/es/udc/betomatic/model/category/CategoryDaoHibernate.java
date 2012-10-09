package es.udc.betomatic.model.category;

import java.util.List;

import org.hibernate.HibernateException;
import org.springframework.stereotype.Repository;
import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("categoryDao")
public class CategoryDaoHibernate
	extends GenericDaoHibernate<Category, Long>
	implements CategoryDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<Category> allCategories() {
		try {
            return getSession().createQuery(
                    "SELECT o FROM Category o").
                    list();

	    } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }
	}
}
