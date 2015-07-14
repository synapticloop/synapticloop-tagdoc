package synapticloop.ant.annotation;

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

import synapticloop.ant.exception.ParseException;

public class RequiredParentAnnotator extends AnnotatorBase {
	public static final String NAME = "RequiredParent";

	@Override
	public String parse(String marker, String lines) throws ParseException {
		StringBuffer stringBuffer = new StringBuffer(super.parse(marker, lines));

		// This should link to the parent tag

		String parentTag = markerParser(marker);
		stringBuffer.append("<link>" + parentTag + "</link>");
		
		return(stringBuffer.toString());
	}

}
