package es.udc.betomatic.web.services;

import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.ioc.MappedConfiguration;
import org.apache.tapestry5.ioc.OrderedConfiguration;
import org.apache.tapestry5.ioc.ServiceBinder;
import org.apache.tapestry5.services.ComponentClassTransformWorker;
import org.apache.tapestry5.services.ComponentEventRequestFilter;
import org.apache.tapestry5.services.Dispatcher;
import org.apache.tapestry5.services.PageRenderRequestFilter;

/**
 * This module is automatically included as part of the Tapestry IoC Registry,
 * it's a good place to configure and extend Tapestry, or to place your own
 * service definitions.
 */
public class AppModule {

	public static void bind(ServiceBinder binder) {

		/* Bind filters. */
		binder.bind(SessionDispatcher.class);
		binder.bind(PageRenderAuthenticationFilter.class);
		binder.bind(ComponentEventAuthenticationFilter.class);

	}

	public static void contributeApplicationDefaults(
			MappedConfiguration<String, String> configuration) {

		// Contributions to ApplicationDefaults will override any contributions
		// to FactoryDefaults (with the same key). Here we're restricting the
		// supported locales.
		configuration.add(SymbolConstants.SUPPORTED_LOCALES, "en,es,gl");

	}

	/**
	 * Contribute our {@link ComponentClassTransformWorker} to transformation
	 * pipeline to add our code to loaded classes
	 * 
	 * @param configuration
	 *            component class transformer configuration
	 */
	public static void contributeComponentClassTransformWorker(
			OrderedConfiguration<ComponentClassTransformWorker> configuration) {

		configuration.add("AuthenticationPolicy",
				new AuthenticationPolicyWorker());

	}

	public static void contributeMasterDispatcher(
			OrderedConfiguration<Dispatcher> configuration,
			SessionDispatcher sessionDispatcher) {

		/* Add dispatchers to the master Dispatcher service. */
		configuration.add("SessionDispatcher", sessionDispatcher,
				"before:PageRender");

	}

	/**
	 * Contributes "PageRenderAuthenticationFilter" filter which checks for
	 * access rights of requests.
	 */
	public void contributePageRenderRequestHandler(
			OrderedConfiguration<PageRenderRequestFilter> configuration,
			PageRenderRequestFilter pageRenderAuthenticationFilter) {

		/*
		 * Add filters to the filters pipeline of the PageRender command of the
		 * MasterDispatcher service.
		 */
		configuration.add("PageRenderAuthenticationFilter",
				pageRenderAuthenticationFilter, "before:*");

	}

	/**
	 * Contribute "PageRenderAuthenticationFilter" filter to determine if the
	 * event can be processed and the user has enough rights to do so.
	 */
	public void contributeComponentEventRequestHandler(
			OrderedConfiguration<ComponentEventRequestFilter> configuration,
			ComponentEventRequestFilter componentEventAuthenticationFilter) {

		/*
		 * Add filters to the filters pipeline of the ComponentEvent command of
		 * the MasterDispatcher service.
		 */
		configuration.add("ComponentEventAuthenticationFilter",
				componentEventAuthenticationFilter, "before:*");

	}

}
