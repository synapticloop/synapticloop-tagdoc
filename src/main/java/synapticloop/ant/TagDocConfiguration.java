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

public class TagDocConfiguration {
	// the index xsl file to use
	private static String indexXsl = "/pdf/index.xsl";
	// the individual page xsl
	private static String individualXsl = "/pdf/individual.xsl";
	// whether to turn on verbose logging
	private static boolean verbose = false;
	// the user configuration for the fop processor
	private static String userConfig;

	public static void setIndexXsl(String indexXsl) {
		TagDocConfiguration.indexXsl = indexXsl;
	}

	public static String getIndexXsl() {
		return indexXsl;
	}

	public static void setIndividualXsl(String individualXsl) {
		TagDocConfiguration.individualXsl = individualXsl;
	}

	public static String getIndividualXsl() {
		return individualXsl;
	}

	public static void setVerbose(boolean verbose) {
		TagDocConfiguration.verbose = verbose;
	}

	public static boolean getVerbose() {
		return verbose;
	}

	public static void setUserConfig(String userConfig) {
		TagDocConfiguration.userConfig = userConfig;
	}

	public static String getUserConfig() {
		return userConfig;
	}

}
