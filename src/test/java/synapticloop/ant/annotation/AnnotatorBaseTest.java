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
public class AnnotatorBaseTest {
	private AnnotatorBase annotatorBase;

	@Before
	public void setup() {
		annotatorBase = new AnnotatorBase();
	}


	@Test
	public void testGetTagName() {
		assertEquals("", annotatorBase.getTagName());
	}
	
	@Test
	public void testMarkerParser() {
		assertEquals("", annotatorBase.markerParser("\"\""));
		assertEquals("this is a test", annotatorBase.markerParser("this is a \"test\""));
	}
	
//	@Test
//	public void testSimpleParse() throws ParseException {
//		StringTokenizer stringTokenizer = new StringTokenizer("");
//		String temp = annotatorBase.parse("marker", "This is the first line", stringTokenizer);
//		assertEquals("<>marker</><sub->This is the first line </sub->", temp);
//		temp = annotatorBase.parse("marker", "This is the first line", null);
//		assertEquals("<>marker</><sub->This is the first line </sub->", temp);
//	}

}
