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

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class ClasspathUriResolver implements URIResolver {
	public static final String CLASSPATH_URI = "classpath://!";
	private URIResolver originalURIResolver;

	public ClasspathUriResolver(URIResolver originalURIResolver) {
		this.originalURIResolver = originalURIResolver;
	}

	/**
	 * Resolve a URI that starts with 'classpath://' to a file within the
	 * classpath.  If the HREF does not start with 'classpath://' then use
	 * the parent URI resolver to resolve the entry
	 */
	public Source resolve(String href, String base) throws TransformerException {
		if(href.startsWith(CLASSPATH_URI)) {
			String url = href.substring(CLASSPATH_URI.length());
			InputStream is = this.getClass().getResourceAsStream(url);
			return new StreamSource(is);
		} else {
			return(originalURIResolver.resolve(href, base));
		}
	}
}
