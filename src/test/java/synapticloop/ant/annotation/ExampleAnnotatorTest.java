package synapticloop.ant.annotation;

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

import synapticloop.ant.exception.ParseException;

public class ExampleAnnotatorTest {
	ExampleAnnotator exampleAnnotator;

	@Before
	public void setup() {
		exampleAnnotator = new ExampleAnnotator();
	}

	@Test
	public void testParse() throws ParseException {
		String parsed = exampleAnnotator.parse("marker", " line 1\n line 2");
		assertEquals("<example>marker</example><sub-example><line> line 1</line><line> line 2</line></sub-example>", parsed);
	}

	@Test
	public void testParseEmptyMarker() throws ParseException {
		String parsed = exampleAnnotator.parse("", " line 1\n line 2");
		assertEquals("<example>Example</example><sub-example><line> line 1</line><line> line 2</line></sub-example>", parsed);
	}

	@Test
	public void testParseEmptyLineMarker() throws ParseException {
		String parsed = exampleAnnotator.parse("", "\n line 2\n\n");
		assertEquals("<example>Example</example><sub-example><line> line 2</line></sub-example>", parsed);
	}
	
}
