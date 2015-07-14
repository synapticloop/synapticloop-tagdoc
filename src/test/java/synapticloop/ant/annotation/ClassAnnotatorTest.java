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

import java.util.StringTokenizer;

import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;

import synapticloop.ant.exception.ParseException;

import static org.mockito.Mockito.*;

public class ClassAnnotatorTest {
	private ClassAnnotator classAnnotator;

	@Before
	public void setup() {
		classAnnotator = new ClassAnnotator();
	}


	@Test
	public void testGetTagName() {
		assertEquals("class", classAnnotator.getTagName());
	}
	
	
	@Test
	public void testSimpleParse() throws ParseException {
		String temp = classAnnotator.parse("java.lang.String", "This is the first line");
		assertEquals(temp, temp);
		//assertEquals("<class>java.lang.String</class><sub-class>This is the first line</sub-class><fields class=\"java.lang.String\"><field><type>Comparator</type><name>CASE_INSENSITIVE_ORDER</name></field></fields><methods class=\"java.lang.String\"><method><return-type>int</return-type><name>hashCode</name></method><method><return-type>String</return-type><name>toString</name></method><method><return-type>int</return-type><name>length</name></method><method><return-type>boolean</return-type><name>empty</name></method><method><return-type>byte[]</return-type><name>bytes</name></method><method><return-type>String</return-type><name>toLowerCase</name></method><method><return-type>String</return-type><name>toUpperCase</name></method><method><return-type>String</return-type><name>trim</name></method><method><return-type>char[]</return-type><name>toCharArray</name></method><method><return-type>String</return-type><name>intern</name></method><method><return-type>Class</return-type><name>class</name></method></methods>", temp);
	}

}
