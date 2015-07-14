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

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.DefaultHandler;

import synapticloop.util.XmlUtil;

/**
 * This class is where all of the parsing is done for the TLD files
 */
public class TldSaxParser extends DefaultHandler implements LexicalHandler {
	
	private StringBuffer characterBuffer = new StringBuffer();
	
	private StringBuffer parsedText = new StringBuffer();

	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		parsedText.append("<" + qName + ">");
	}
	

	/*
	 * At the end of the element, finish off the element
	 *  
	 * (non-Javadoc)
	 * @see org.xml.sax.helpers.DefaultHandler#endElement(java.lang.String, java.lang.String, java.lang.String)
	 */
	public void endElement(String uri, String localName, String qName) throws SAXException {
		// the description element holds all of the annotations
		if(qName.compareTo("description") == 0) {
			parsedText.append(MarkdownParser.parse(characterBuffer.toString()) + "</description>");
		} else {
			parsedText.append(XmlUtil.xmlEncode(characterBuffer.toString().trim()) + "</" + qName + ">");
		}
		characterBuffer = new StringBuffer();
	}

	public void characters(char[] ch, int start, int length) throws SAXException {
		characterBuffer.append(new String(ch,start,length));
	}

	/*
	 * The comment sections can also have annotations.
	 * 
	 * (non-Javadoc)
	 * @see org.xml.sax.ext.LexicalHandler#comment(char[], int, int)
	 */
	public void comment(char[] ch, int start, int length) throws SAXException {
//		System.out.println("parsing at comment start");
		parsedText.append("<comment>" + MarkdownParser.parse(new String(ch, start, length)) + "</comment>");
//		System.out.println("parsing at comment end");
		
	}

	public void endCDATA() throws SAXException {
		// do nothing
	}

	public void endDTD() throws SAXException {
		// do nothing
	}

	public void endEntity(String name) throws SAXException {
		// do nothing
	}

	public void startCDATA() throws SAXException {
		// do nothing
	}

	public void startDTD(String name, String publicId, String systemId) throws SAXException {
		// do nothing
	}

	public void startEntity(String name) throws SAXException { 
		// do nothing
	}


	/**
	 * Get the parsed text 
	 * 
	 * @return the parsedText
	 */
	public StringBuffer getParsedText() {
		return parsedText;
	}

	/**
	 * Reset this parsing session.
	 */
	public void reset() {
		this.parsedText = new StringBuffer();
	}
}
