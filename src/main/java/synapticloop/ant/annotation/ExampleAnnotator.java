package synapticloop.ant.annotation;

import java.util.StringTokenizer;

import synapticloop.ant.exception.ParseException;
import synapticloop.util.XmlUtil;

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

public class ExampleAnnotator extends AnnotatorBase {
	public static final String NAME = "Example";

	public String parse(String marker, String paragraph) throws ParseException {
		StringBuffer parsedBuffer = new StringBuffer();
		StringTokenizer stringTokenizer = new StringTokenizer(paragraph, "\n", false);

		String tagName = getTagName();

		String parsedMarker = markerParser(marker);

		if(parsedMarker.length() == 0) {
			parsedMarker = "Example";
		}

		parsedBuffer.append("<" + tagName + ">" + parsedMarker + "</" + tagName + "><sub-" + tagName + ">");

		while(stringTokenizer.hasMoreElements()) {
			String line = stringTokenizer.nextToken();
			if(line.compareTo("") == 0) {
				parsedBuffer.append("</sub-" + tagName + ">");
				break;
			} else {
				parsedBuffer.append("<line>" + XmlUtil.xmlEncode(line) + "</line>");
			}
		}
		// if we are at the end of the line
		if(!stringTokenizer.hasMoreElements()) {
			parsedBuffer.append("</sub-" + tagName + ">");
		}
		
		return(parsedBuffer.toString());
	}

}
