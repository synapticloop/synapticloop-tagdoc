package synapticloop.ant;

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

import java.util.HashMap;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;

import synapticloop.util.AnnotationHelper;
import synapticloop.util.XmlUtil;

public class MarkdownParser {
	
	private static HashMap<String, String> MARKDOWN_LOOKUP;
	static {
		MARKDOWN_LOOKUP  = new HashMap<String, String>();
		MARKDOWN_LOOKUP.put("__", "u");
		MARKDOWN_LOOKUP.put("::", "strong");
		MARKDOWN_LOOKUP.put("==", "strike");
		MARKDOWN_LOOKUP.put("//", "em");
		MARKDOWN_LOOKUP.put("~~", "pre");
	}
	

	public static String parseMarkdown(String paragraph) {
		Iterator<String> markdownLookup = MARKDOWN_LOOKUP.keySet().iterator();
		while (markdownLookup.hasNext()) {
			String markdownDelimiter = (String) markdownLookup.next();
			boolean start = true;
			int index = paragraph.indexOf(markdownDelimiter);
			while(index != -1) {
				if(start) {
					paragraph = paragraph.replaceFirst(markdownDelimiter, "<" + MARKDOWN_LOOKUP.get(markdownDelimiter)+ ">");
				} else {
					paragraph = paragraph.replaceFirst(markdownDelimiter, "</" + MARKDOWN_LOOKUP.get(markdownDelimiter)+ ">");
				}
				start = !start;
				index = paragraph.indexOf(markdownDelimiter);
			}
		}

		return(paragraph);
	}
	
	public static String parseList(String paragraph, String delim, String item) {
		StringTokenizer stringTokenizer = new StringTokenizer(paragraph, "\n", false);
		StringBuffer stringBuffer = new StringBuffer(paragraph.length()*2);
		stringBuffer.append("<" + item +"l>");

		boolean foundFirst = false;
		StringBuffer currentLine = new StringBuffer();
		Vector<String> allLines = new Vector<String>();

		while(stringTokenizer.hasMoreTokens()) {
			String line = stringTokenizer.nextToken().trim();
			if(line.startsWith(delim)) {
				if(foundFirst) {
					allLines.add(currentLine.toString());
					currentLine = new StringBuffer();
				}
				currentLine.append(line.substring(1).trim() + " ");
				foundFirst = true;
			} else {
				currentLine.append(line.trim() + " ");
			}
		}

		allLines.add(currentLine.toString());

		Iterator<String> allLinesIterator = allLines.iterator();
		while (allLinesIterator.hasNext()) {
			String allLine = (String) allLinesIterator.next();
			stringBuffer.append("<li>" + parseMarkdown(XmlUtil.xmlEncode(allLine)) + "</li>");
		}

		stringBuffer.append("</" + item + "l>");
		return(stringBuffer.toString());		
	}

	public static String parseOrderedList(String paragraph) {
		return(parseList(paragraph, "+", "o"));
	}
	
	public static String parseUnorderedList(String paragraph) {
		return(parseList(paragraph, "-", "u"));

	}
	/**
	 * Parse a paragraph.  When invoked it is assumed that the passed in
	 * paragraph is a complete paragraph with no line breaks.  Although
	 * it may still have many paragraphs if there are annotations - which
	 * are another way of creating paragraphs
	 * 
	 * @param paragraph
	 * @return
	 */
	public static String parseParagraph(String paragraph) {
		paragraph = paragraph.trim();
		if(paragraph.length() > 1) {
			switch (paragraph.charAt(0)) {
			case '@':
				int annotationLength = paragraph.indexOf('(');
				int endMarker = paragraph.indexOf(')');
				String annotationName = paragraph.substring(1, annotationLength);
				if(AnnotationHelper.hasAnnotation(annotationName)) {
					return(AnnotationHelper.parseAnnotation(annotationName, paragraph.substring(annotationLength + 1, endMarker), paragraph.substring(endMarker + 1)));
				} else {
					return("<p>" + parseMarkdown(XmlUtil.xmlEncode(paragraph)) + "</p>");
				}
			case '-':
				// parsing an unordered-list
				return(parseUnorderedList(paragraph));
			case '+':
				return(parseOrderedList(paragraph));

			default:
				return("<p>" + parseMarkdown(XmlUtil.xmlEncode(paragraph)) + "</p>");
			}
		} else {
			return("");
		}
	}

	/**
	 * Parse the complete
	 * @param toBeParsed
	 * @return
	 */
	public static String parse(String toBeParsed) {
		// trim the line first 
		toBeParsed = toBeParsed.trim();

		if(toBeParsed.compareTo("") == 0) {
			return("");
		}

		StringTokenizer stringTokenizer;
		StringBuffer parsed = new StringBuffer(toBeParsed.length()*2);

		// we are breaking up the lines on the new line character
		stringTokenizer = new StringTokenizer(toBeParsed, "\n", false);
		String parseLine = stringTokenizer.nextToken().trim() + "\n";

		// we want to break these things into paragraphs
		StringBuffer paragraph = new StringBuffer(toBeParsed.length()*2);

		paragraph.append(parseLine);
		
		while(stringTokenizer.hasMoreTokens()) {
			parseLine = stringTokenizer.nextToken().trim();

			// we might be at the end of the line
			if(parseLine.compareTo("") == 0) {
				parsed.append(parseParagraph(paragraph.toString()));
				paragraph = new StringBuffer(toBeParsed.length());
			} else if(parseLine.charAt(0) == '@') {
				parsed.append(parseParagraph(paragraph.toString()));
				paragraph = new StringBuffer(toBeParsed.length());
			}

			paragraph.append(parseLine.trim() + "\n");
		}
		parsed.append(parseParagraph(paragraph.toString()));

		return(parsed.toString());
	}

}
