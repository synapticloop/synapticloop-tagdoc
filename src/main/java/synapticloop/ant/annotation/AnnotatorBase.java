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

import synapticloop.ant.MarkdownParser;
import synapticloop.ant.exception.ParseException;
import synapticloop.util.XmlUtil;

public class AnnotatorBase implements Annotator {
	
	/**
	 * @return
	 */
	protected String getTagName() {
		String className = this.getClass().getSimpleName();

		String tagName = className.substring(0, className.indexOf("Annotator")).toLowerCase();
		return tagName;
	}

	public String parse(String marker, String line) throws ParseException {
		StringBuffer parsedBuffer = new StringBuffer();
		String tagName = getTagName();

		parsedBuffer.append("<" + tagName + ">" + markerParser(marker) + "</" + tagName + ">");

		parsedBuffer.append("<sub-" + tagName + ">");
		parsedBuffer.append(MarkdownParser.parseMarkdown(XmlUtil.xmlEncode(line.replaceAll("\n", " ")).trim()));
		parsedBuffer.append("</sub-" + tagName + ">");
		return(parsedBuffer.toString());
	}


	protected String markerParser(String marker) {
		return(marker.replaceAll("\"", ""));
	}
}
