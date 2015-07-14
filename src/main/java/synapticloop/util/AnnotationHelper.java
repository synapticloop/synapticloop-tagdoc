package synapticloop.util;

/*
 * Copyright (c) 2010 synapticloop.
 * All rights reserved.
 *
 * This source code and any derived binaries are covered by the terms and
 * conditions of the Licence agreement ("the Licence").  You may not use this
 * source code or any derived binaries except in compliance with the Licence.
 * A copy of the Licence is available in the file named LICENCE shipped with
 * this source code or binaries.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * Licence for the specific language governing permissions and limitations
 * under the Licence.
 */

import java.util.HashMap;

import synapticloop.ant.Annotation;
import synapticloop.ant.annotation.AllowableValueAnnotator;
import synapticloop.ant.annotation.Annotator;
import synapticloop.ant.annotation.ClassAnnotator;
import synapticloop.ant.annotation.DefaultAnnotator;
import synapticloop.ant.annotation.ExampleAnnotator;
import synapticloop.ant.annotation.HeadingAnnotator;
import synapticloop.ant.annotation.IgnoreAnnotator;
import synapticloop.ant.annotation.OverviewAnnotator;
import synapticloop.ant.annotation.RequiredParentAnnotator;
import synapticloop.ant.annotation.SectionAnnotator;
import synapticloop.ant.annotation.UnknownAnnotator;
import synapticloop.ant.exception.ParseException;

public class AnnotationHelper {
	// the lookup of annotations
	private static HashMap<String, Annotator> annotations = new HashMap<String, Annotator>();
	static {
		annotations.put(AllowableValueAnnotator.NAME, new AllowableValueAnnotator());
		annotations.put(ClassAnnotator.NAME, new ClassAnnotator());
		annotations.put(DefaultAnnotator.NAME, new DefaultAnnotator());
		annotations.put(RequiredParentAnnotator.NAME, new RequiredParentAnnotator());
		annotations.put(SectionAnnotator.NAME, new SectionAnnotator());
		annotations.put(ExampleAnnotator.NAME, new ExampleAnnotator());
		annotations.put(HeadingAnnotator.NAME, new HeadingAnnotator());
		annotations.put(IgnoreAnnotator.NAME, new IgnoreAnnotator());
		annotations.put(OverviewAnnotator.NAME, new OverviewAnnotator());
	}

	/**
	 * Check whether there is 
	 * 
	 * @param annotationName the name of the annotation 
	 * @return whether there is an annotation available for the name
	 */
	public static boolean hasAnnotation(String annotationName) {
		return(annotations.containsKey(annotationName));
	}
	
	/**
	 * Return the annotator named 'annotationName' or null if it doesn't exist
	 * 
	 * @param annotationName The annotation name to look up
	 * @return the annotator responsible for this annotation
	 */
	public static Annotator getAnnotator(String annotationName) {
		return(annotations.get(annotationName));
	}

	/**
	 * parse an annotation
	 * 
	 * @param annotationName The annotation name to parse
	 * @param marker the marker
	 * @param firstLine the first line
	 * @param stringTokenizer the string tokenizer
	 * @return the parsed annotation
	 */
	public static String parseAnnotation(String annotationName, String marker, String lines) {
		try {
			return(annotations.get(annotationName).parse(marker, lines));
		} catch (ParseException saepex) {
			return("");
		}
	}
	
	/**
	 * Add the pre-configured annotation to the list of known annotations.  The
	 * passed in annotation will be instantiated and already have the property 
	 * setters called by the ant sub-system.
	 * 
	 * @param annotation The instantiated annotation  
	 */
	public static void addConfiguredAnnotation(Annotation annotation) {
		// try and find
		String name = annotation.getName();
		String className = annotation.getClassName();
		
		if(null == name) {
			TaskHelper.warn("The annotation must include at least a name attribute.  The annotation will be ignored.");
		} else {
			if(null == className) {
				TaskHelper.info("The annotation @" + name + " will be mapped to the unknown annotator.");
				annotations.put(name, new UnknownAnnotator(name));
			} else {
				// try and load up the class
				// try and find the
				Annotator annotator;
				boolean isLoaded = false;
				String message = null;
				try {
					annotator = (Annotator)AnnotationHelper.class.getClassLoader().loadClass(className).newInstance();
					annotations.put(annotation.getName(), annotator);
					isLoaded = true;
				} catch (InstantiationException jliex) {
					message = jliex.getMessage();
				} catch (IllegalAccessException jliaex) {
					message = jliaex.getMessage();
				} catch (ClassNotFoundException jlcnfex) {
					message = jlcnfex.getMessage();
				}
				
				if(!isLoaded) {
					TaskHelper.warn("Could not instantiate the annotation @" + name + " with class " + className + " and will be ignored.");
					TaskHelper.warn("Message was: " + message);
				} else {
					TaskHelper.info("Successfully mapped the annotation @" + name + " to class " + className);
				}
			}
		}
	}
}
