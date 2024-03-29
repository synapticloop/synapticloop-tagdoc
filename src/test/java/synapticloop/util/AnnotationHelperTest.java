package synapticloop.util;

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

import synapticloop.ant.TagDocTask;

import static org.mockito.Mockito.*;

public class AnnotationHelperTest {
	AnnotationHelper annotationHelper;

	@Before
	public void setup() {
		annotationHelper = new AnnotationHelper();
	}

	@Test
	public void testHasAnnotations() {
		assertTrue(AnnotationHelper.hasAnnotation("AllowableValue"));
		assertTrue(AnnotationHelper.hasAnnotation("Class"));
		assertTrue(AnnotationHelper.hasAnnotation("Default"));
		assertTrue(AnnotationHelper.hasAnnotation("RequiredParent"));
		assertTrue(AnnotationHelper.hasAnnotation("Section"));
		assertTrue(AnnotationHelper.hasAnnotation("Example"));
		
		assertNotNull(AnnotationHelper.getAnnotator("Example"));
		
		assertNull(AnnotationHelper.getAnnotator("ThisAnnotationShouldNotExist"));
	}
}
