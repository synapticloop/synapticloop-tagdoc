package synapticloop.ant.generator;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Vector;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import synapticloop.util.TaskHelper;

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

public class HtmlGenerator {
	

	public static void generate(Vector<File> tldFiles, File workingOutputDirectory, File outputDirectory) {
		// generate all of the individual tag specific files
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		transformerFactory.setURIResolver(new ClasspathUriResolver(transformerFactory.getURIResolver()));
		String[] individualtagFiles = TaskHelper.getAllFilesInDirectory(workingOutputDirectory, ".tag-xml");
		for (int i = 0; i < individualtagFiles.length; i++) {
			String individualTagFile = individualtagFiles[i];
			
			File file = new File(workingOutputDirectory.getAbsolutePath() + "/" + individualTagFile);
			TaskHelper.info("Generating " + individualTagFile + ".html");
			try {
				
				Transformer transformer = transformerFactory.newTransformer(new StreamSource(HtmlGenerator.class.getResourceAsStream("/html/individual-tag.xsl")));
				transformer.transform(new StreamSource(file), new StreamResult(new FileOutputStream(outputDirectory.getAbsolutePath() + "/" + individualTagFile + ".html")));
			} catch (TransformerConfigurationException jxttcex) {
				jxttcex.printStackTrace();
			} catch (FileNotFoundException jlfnfex) {
				// TODO Auto-generated catch block
				jlfnfex.printStackTrace();
			} catch (TransformerException jxttex) {
				// TODO Auto-generated catch block
				jxttex.printStackTrace();
			}
			
		}
		
//		// generate the index file
//		TaskHelper.info("Generating index HTML");
//		if(generateFile("index.xml", TagDocConfiguration.getIndexXsl(), TagDocConfiguration.getUserConfig(), workingOutputDirectory, outputDirectory)) {
//			TaskHelper.info("Generated...");
//		}
//
//		Iterator<File> tldFileIterator = tldFiles.iterator();
//		while (tldFileIterator.hasNext()) {
//			File tldFile = (File) tldFileIterator.next();
//			TaskHelper.info("Generating HTML for " + tldFile.getName());
//			generateFile(tldFile.getName() + ".xml", TagDocConfiguration.getIndividualXsl(), TagDocConfiguration.getUserConfig(), workingOutputDirectory, outputDirectory);
//			TaskHelper.info("Generated...");
//		}

	}

	private static boolean generateFile(String inputXml, String indexXsl,
			String userConfig, File workingOutputDirectory,
			File htmlOutputDirectory) {
		// TODO Auto-generated method stub
		return false;
	}

	private static boolean generateIndividualFiles() {
		return false;
	}

}
