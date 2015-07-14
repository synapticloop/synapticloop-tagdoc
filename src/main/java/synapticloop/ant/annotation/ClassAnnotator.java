package synapticloop.ant.annotation;

/*
 * Copyright (c) 2008-2010 synapticloop.
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

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.HashSet;

import synapticloop.ant.exception.ParseException;

public class ClassAnnotator extends AnnotatorBase {
	public static final String NAME = "Class";
	
	private static HashSet<String> upperCase = new HashSet<String>();
	private static String[] upperCharacters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
	static {
		for (int i = 0; i < upperCharacters.length; i++) {
			upperCase.add(upperCharacters[i]);
		}
	}

	@SuppressWarnings("unchecked")
	public String parse(String marker, String lines) throws ParseException {
		StringBuffer stringBuffer = new StringBuffer(super.parse(marker, lines));

		// see if we can grab the class

		String className = markerParser(marker);

		try {
			Class clazz = this.getClass().getClassLoader().loadClass(className);
			Field[] fields = clazz.getFields();
			stringBuffer.append("<fields class=\"");
			stringBuffer.append(className);
			stringBuffer.append("\">");
			for (int i = 0; i < fields.length; i++) {
				Field field = fields[i];
				stringBuffer.append("<field><type>" + field.getType().getSimpleName() + "</type><name>" + field.getName() + "</name></field>");
			}
			stringBuffer.append("</fields>");

			Method[] methods = clazz.getMethods();
			stringBuffer.append("<methods class=\"");
			stringBuffer.append(className);
			stringBuffer.append("\">");
			for (int i = 0; i < methods.length; i++) {
				Method method = methods[i];
				if(method.getParameterTypes().length == 0) {
					String returnType = method.getReturnType().getSimpleName();
					if(returnType.compareTo("void") != 0) {
						// we can probably use this
						if(Modifier.isPublic(method.getModifiers())) {
							String methodName = method.getName();
							if(methodName.startsWith("get") || methodName.startsWith("has")) {
								if(upperCase.contains(methodName.charAt(3) + "")) {
									methodName = methodName.substring(3, 4).toLowerCase() + methodName.substring(4);
								}
							} else if(methodName.startsWith("is")) {
								methodName = methodName.substring(2, 3).toLowerCase() + methodName.substring(3);
							}
							stringBuffer.append("<method><return-type>" + method.getReturnType().getSimpleName() + "</return-type><name>" + methodName + "</name></method>");
						}
					}
				}
			}
			stringBuffer.append("</methods>");
		} catch (ClassNotFoundException jlcnfex) {
			// do nothing - class not in classpath
		}

		return(stringBuffer.toString());
	}
}
