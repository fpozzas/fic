package es.udc.betomatic.web.services;

import org.apache.tapestry5.annotations.OnEvent;
import org.apache.tapestry5.model.MutableComponentModel;
import org.apache.tapestry5.services.ClassTransformation;
import org.apache.tapestry5.services.ComponentClassTransformWorker;
import org.apache.tapestry5.services.TransformMethodSignature;

public class AuthenticationPolicyWorker implements
		ComponentClassTransformWorker {

	public void transform(ClassTransformation transformation,
			MutableComponentModel model) {

		processPageAnnotations(transformation, model);

		processEventHandlerAnnotations(transformation, model);

	}

	/**
	 * Read and process restriction on page classes annotated with
	 * {@link AuthenticationPolicy} annotation
	 * 
	 * @param transformation
	 *            Contains class-specific information used when transforming a
	 *            raw component class into an executable component class.
	 * @param model
	 *            Mutable version of
	 *            {@link org.apache.tapestry5.model.ComponentModel} used during
	 *            the transformation phase.
	 */
	private void processPageAnnotations(ClassTransformation transformation,
			MutableComponentModel model) {

		AuthenticationPolicy policy = transformation
				.getAnnotation(AuthenticationPolicy.class);
		if (policy != null) {
			model.setMeta(AuthenticationValidator.PAGE_AUTHENTICATION_TYPE,
					policy.value().toString());
		}

	}

	/**
	 * Inject meta datas about annotated methods
	 * 
	 * @param transformation
	 *            Contains class-specific information used when transforming a
	 *            raw component class into an executable component class.
	 * @param model
	 *            Mutable version of
	 *            {@link org.apache.tapestry5.model.ComponentModel} used during
	 *            the transformation phase.
	 */
	private void processEventHandlerAnnotations(
			ClassTransformation transformation, MutableComponentModel model) {

		for (TransformMethodSignature method : transformation
				.findMethodsWithAnnotation(AuthenticationPolicy.class)) {
			String methodName = method.getMethodName();
			AuthenticationPolicy policy = transformation.getMethodAnnotation(
					method, AuthenticationPolicy.class);
			OnEvent event = transformation.getMethodAnnotation(method,
					OnEvent.class);
			if (methodName.startsWith("on") || event != null) {
				String componentId = extractComponentId(method, event);
				String eventType = extractEventType(method, event);
				String authenticationPolicyMeta = AuthenticationValidator.EVENT_HANDLER_AUTHENTICATION_TYPE
						+ "-" + componentId + "-" + eventType;

				authenticationPolicyMeta = authenticationPolicyMeta
						.toLowerCase();
				model.setMeta(authenticationPolicyMeta, policy.value()
						.toString());
			} else {
				throw new RuntimeException(
						"Cannot put AuthenticationPolicy annotation on a non event handler method");
			}
		}

	}

	/**
	 * This code is taken deliberatly from
	 * http://svn.apache.org/viewvc/tapestry/
	 * tapestry5/trunk/tapestry-core/src/main
	 * /java/org/apache/tapestry5/internal/transform/OnEventWorker.java?view=log
	 */
	public static final String extractComponentId(
			TransformMethodSignature method, OnEvent annotation) {

		if (annotation != null) {
			return annotation.component();
		}
		// Method name started with "on". Extract the component id, if present.
		String name = method.getMethodName();
		int fromx = name.indexOf("From");
		if (fromx < 0) {
			return "";
		}
		return name.substring(fromx + 4);

	}

	/**
	 * This code is taken deliberatly from:
	 * http://svn.apache.org/viewvc/tapestry
	 * /tapestry5/trunk/tapestry-core/src/main
	 * /java/org/apache/tapestry5/internal/transform/OnEventWorker.java?view=log
	 */
	public static final String extractEventType(
			TransformMethodSignature method, OnEvent annotation) {

		if (annotation != null) {
			return annotation.value();
		}
		// Method name started with "on". Extract the event type.
		String name = method.getMethodName();
		int fromx = name.indexOf("From");
		return fromx == -1 ? name.substring(2) : name.substring(2, fromx);

	}

}
