package synapticloop.ant;

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

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import static org.mockito.Mockito.*;

public class TldSaxParserTest {
	TldSaxParser tldSaxParser;
	Attributes attributes;

	@Before
	public void setup() {
		tldSaxParser = new TldSaxParser();
		attributes = mock(Attributes.class);
	}

	@Test
	public void testStartElement() throws SAXException {
		tldSaxParser.startElement("uri", "localName", "qName", attributes);
		assertTrue(tldSaxParser.getParsedText().toString().contains("<qName>"));
	}
	
	@Test
	public void testEndElement() throws SAXException {
		tldSaxParser.endElement("uri", "localName", "qName");
		assertTrue(tldSaxParser.getParsedText().toString().contains("</qName>"));

		tldSaxParser.endElement("uri", "localName", "description");
		assertTrue(tldSaxParser.getParsedText().toString().contains("</description>"));
	}
	
	@Test
	public void testEmptyParsing() throws SAXException {
		// test to ensure that nothing is parsed for these methods
		tldSaxParser.endCDATA();
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
		tldSaxParser.endDTD();
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
		tldSaxParser.endEntity("name");
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
		tldSaxParser.startCDATA();
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
		tldSaxParser.startDTD("name", "publicId", "systemId");
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
		tldSaxParser.startEntity("name");
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
	}
	
	@Test
	public void testReset() throws SAXException {
		tldSaxParser.endElement("uri", "localName", "qName");
		tldSaxParser.reset();
		assertTrue(tldSaxParser.getParsedText().toString().length() == 0);
	}
	
	@Test
	public void testCharacters() throws SAXException {
		tldSaxParser.startElement("uri", "localName", "qName", attributes);
		tldSaxParser.characters(new char[] {'h', 'e', 'l', 'l', 'o'}, 0, 5);
		tldSaxParser.endElement("uri", "localName", "qName");
		assertEquals(tldSaxParser.getParsedText().toString(), "<qName>hello</qName>");
		
	}

	@Test
	public void testComment() throws SAXException {
		tldSaxParser.comment(new char[] {'h', 'e', 'l', 'l', 'o'}, 0, 5);
		assertEquals("<comment><p>hello</p></comment>", tldSaxParser.getParsedText().toString());
		
	}
}
