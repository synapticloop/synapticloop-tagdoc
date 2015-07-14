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

import static org.mockito.Mockito.*;

public class MarkdownParserTest {
	MarkdownParser markdownParser;

	@Before
	public void setup() {
		markdownParser = new MarkdownParser();
	}

	@Test
	public void testParseMarkdown() {
		String parsed = MarkdownParser.parseMarkdown("__==:://~~~~//::==__");
		assertEquals("<u><strike><strong><em><pre></pre></em></strong></strike></u>", parsed);
	}
	
	@Test
	public void testParseUnorderedList() {
		String parsed = MarkdownParser.parseUnorderedList("- one\n-two");
		assertEquals("<ul><li>one </li><li>two </li></ul>", parsed);
	}

	@Test
	public void testParseOrderedList() {
		String parsed = MarkdownParser.parseOrderedList("+ one\n+two");
		assertEquals("<ol><li>one </li><li>two </li></ol>", parsed);
	}
	
	@Test
	public void testParse() {
		String parsed = MarkdownParser.parse("@Heading(\"hello\") something\n" +
				" \n" +
				"Another Paragraph\n" +
				"@Annotation(\"annotation\") an annotation\n" +
				" \n" +
				"- unordered\n" +
				" \n" +
				"+ ordered");
		assertEquals("<heading>hello</heading><sub-heading>something</sub-heading><p>Another Paragraph</p><p>@Annotation(\"annotation\") an annotation</p><ul><li>unordered </li></ul><ol><li>ordered </li></ol>", parsed);
	}
	
	@Test
	public void testEmptyParse() {
		String parsed = MarkdownParser.parse("");
		assertEquals("", parsed);
	}
	@Test
	public void testEmptyParseParagraph() {
		String parsed = MarkdownParser.parseParagraph("");
		assertEquals("", parsed);
	}
}
