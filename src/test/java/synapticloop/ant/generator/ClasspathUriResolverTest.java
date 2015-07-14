package synapticloop.ant.generator;

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

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;

import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;

import static org.mockito.Mockito.*;


public class ClasspathUriResolverTest {
	ClasspathUriResolver classpathUriResolver;

	@Before
	public void setup() {
		classpathUriResolver = new ClasspathUriResolver(new URIResolver() {
			
			@Override
			public Source resolve(String href, String base) throws TransformerException {
				// TODO Auto-generated method stub
				return null;
			}
		});
	}

	@Test
	public void testResolveBadClasspathUri() throws TransformerException {
		classpathUriResolver.resolve("href", "base");
	}

	@Test
	public void testResolveGoodClasspathUri() throws TransformerException {
		classpathUriResolver.resolve(ClasspathUriResolver.CLASSPATH_URI, "base");
	}

}
