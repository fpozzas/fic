package es.udc.betomatic.web.services;

import java.io.IOException;

import org.apache.tapestry5.EventConstants;
import org.apache.tapestry5.internal.EmptyEventContext;
import org.apache.tapestry5.services.ApplicationStateManager;
import org.apache.tapestry5.services.ComponentEventRequestFilter;
import org.apache.tapestry5.services.ComponentEventRequestHandler;
import org.apache.tapestry5.services.ComponentEventRequestParameters;
import org.apache.tapestry5.services.ComponentSource;
import org.apache.tapestry5.services.MetaDataLocator;

public class ComponentEventAuthenticationFilter implements ComponentEventRequestFilter {

    private ApplicationStateManager applicationStateManager;
    private ComponentSource componentSource;
    private MetaDataLocator locator;

    public ComponentEventAuthenticationFilter(
            ApplicationStateManager applicationStateManager,
            ComponentSource componentSource, MetaDataLocator locator) {

        this.applicationStateManager = applicationStateManager;
        this.componentSource = componentSource;
        this.locator = locator;

    }

    public void handle(ComponentEventRequestParameters parameters,
            ComponentEventRequestHandler handler) throws IOException {

        ComponentEventRequestParameters handlerParameters = parameters;
        String redirectPage = AuthenticationValidator.checkForPage(parameters
                .getActivePageName(), applicationStateManager, componentSource,
                locator);
        if (redirectPage == null) {
            String componentId = parameters.getNestedComponentId();
            if (componentId != null) {
                String mainComponentId = null;
                String eventId = null;
                if (componentId.indexOf(".") != -1) {
                    mainComponentId = componentId.substring(0, componentId
                            .lastIndexOf("."));
                    eventId = componentId.substring(componentId
                            .lastIndexOf(".") + 1);
                } else {
                    eventId = componentId;
                }

                redirectPage = AuthenticationValidator.checkForComponentEvent(
                        parameters.getActivePageName(), mainComponentId,
                        eventId, parameters.getEventType(),
                        applicationStateManager, componentSource, locator);

                if (redirectPage != null) {
                    handlerParameters = new ComponentEventRequestParameters(
                            redirectPage, redirectPage, "",
                            EventConstants.ACTIVATE, new EmptyEventContext(),
                            new EmptyEventContext());
                }
            }
        }
        handler.handle(handlerParameters);

    }

}
