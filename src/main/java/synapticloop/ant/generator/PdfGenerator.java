package synapticloop.ant.generator;

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

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.xml.sax.SAXException;

import synapticloop.ant.TagDocConfiguration;
import synapticloop.util.TaskHelper;

public class PdfGenerator {

	/**
	 * Generate a PDF file
	 * 
	 * @param inputFile The input XML file
	 * @param inputXsl The XSL file to use
	 * @param workingOutputDirectory The working output directory
	 * @param pdfOutputDirectory The pdf output directory
	 */
	private static boolean generateFile(String inputFile, String inputXsl, String userConfig, 
			File workingOutputDirectory, File pdfOutputDirectory) {

		File xmlInputFile = new File(workingOutputDirectory, inputFile);
		InputStream xslInputStream = PdfGenerator.class.getResourceAsStream(inputXsl);
		if(null == xslInputStream) {
			// try and load the input stream from the file system
			try {
				xslInputStream = new FileInputStream(new File(inputXsl));
			} catch (FileNotFoundException jifnfex) {
				TaskHelper.fatal("Could not find the input xsl '" + inputXsl + "'");
				return(false);
			}
		}
		

		File pdfOutputFile = new File(pdfOutputDirectory + "/" + inputFile.substring(0, inputFile.lastIndexOf(".")) + ".pdf");

		FopFactory fopFactory = getConfiguredFopFactory(userConfig);
		FOUserAgent foUserAgent = getConfiguredFOUserAgent(fopFactory);

		OutputStream outputStream = null;

		try {
			outputStream = new BufferedOutputStream(new FileOutputStream(pdfOutputFile));
			Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, outputStream);

			// Setup XSLT
			TransformerFactory factory = TransformerFactory.newInstance();
			
			factory.setURIResolver(new ClasspathUriResolver(factory.getURIResolver()));
			Transformer transformer = factory.newTransformer(new StreamSource(xslInputStream));

			// Set the value of a <param> in the stylesheet
			transformer.setParameter("versionParam", "2.0");

			// Setup input for XSLT transformation
			Source src = new StreamSource(xmlInputFile);

			// Resulting SAX events (the generated FO) must be piped through to FOP
			Result res = new SAXResult(fop.getDefaultHandler());

			// Start XSLT transformation and FOP processing
			transformer.transform(src, res);
		} catch (FOPException oafafopex) {
			oafafopex.printStackTrace();
		} catch (TransformerConfigurationException jxttcex) {
			jxttcex.printStackTrace();
		} catch (TransformerException jxttex) {
			jxttex.printStackTrace();
		} catch (FileNotFoundException jifnfex) {
			jifnfex.printStackTrace();
		} finally {
			try {
				if(null != outputStream) {
					outputStream.close();
				}
			} catch (IOException jiioex) {
				// ignore
			}
		}
		return(true);
	}

	/**
	 * Get the configured FOP factory, including trying to load the user
	 * configuration files. 
	 *  
	 * @param userConfig The location of the user configuration file
	 * @param verbose whether to ouput verbose information
	 * @return the configured FOP factory
	 */
	private static FopFactory getConfiguredFopFactory(String userConfig) {
		FopFactory fopFactory = FopFactory.newInstance();
		
		if(null != userConfig && userConfig.compareTo("") != 0) {
			try {
				fopFactory.setUserConfig(new File(userConfig));
				TaskHelper.info("Using configuration file: '" + userConfig + "'");
			} catch (SAXException oxssaxex) {
				TaskHelper.warn("Could not parse the configuration file: " + oxssaxex.getMessage());
			} catch (IOException jiioex) {
				TaskHelper.warn("Could not locate the configuration file: " + jiioex.getMessage());
			}
		}
		return(fopFactory);
	}

	private static FOUserAgent getConfiguredFOUserAgent(FopFactory fopFactory) {
		FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
		foUserAgent.setAuthor("synapticloop");
		foUserAgent.setCreationDate(new Date(System.currentTimeMillis()));
		foUserAgent.setCreator("synapticloop tag library documentation generation");
		foUserAgent.setProducer("synapticloop tag library documentation generator ant task");
		return(foUserAgent);
		
	}

	/**
	 * Generate 
	 * 
	 * @param tldFiles the list of tld files to be processed
	 * @param workingOutputDirectory the working output directories
	 * @param pdfOutputDirectory the directory to output the PDFs.
	 */
	public static void generate(Vector<File> tldFiles, File workingOutputDirectory, File pdfOutputDirectory) {
		// generate the index file
		TaskHelper.info("Generating index PDF");
		if(generateFile("index.xml", TagDocConfiguration.getIndexXsl(), TagDocConfiguration.getUserConfig(), workingOutputDirectory, pdfOutputDirectory)) {
			TaskHelper.info("Generated...");
		}

		Iterator<File> tldFileIterator = tldFiles.iterator();
		while (tldFileIterator.hasNext()) {
			File tldFile = (File) tldFileIterator.next();
			TaskHelper.info("Generating PDF for " + tldFile.getName());
			generateFile(tldFile.getName() + ".xml", TagDocConfiguration.getIndividualXsl(), TagDocConfiguration.getUserConfig(), workingOutputDirectory, pdfOutputDirectory);
			TaskHelper.info("Generated...");
		}

	}
}
