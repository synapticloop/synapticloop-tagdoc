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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Vector;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;

import synapticloop.ant.TldSaxParser;
import synapticloop.util.TaskHelper;

public class WorkingGenerator {
	private static final String TLD_TAG_START = "<tag>";
	private static final String TLD_TAG_END = "</tag>";
	private static final String FUNCTION_TAG_START = "<function>";
	private static final String FUNCTION_TAG_END = "</function>";
	private static final String TAG_NAME_START = "<name>";
	private static final String TAG_NAME_END = "</name>";

	private static final String XML_TLDDOCS_END = "</tlddocs>";
	private static final String XML_TLDDOCS_START = "<tlddocs>";
	private static final String XML_TLDDOC_END = "</tlddoc>";
	private static final String XML_TLDDOC_FILE_END = "\">";
	private static final String XML_TLDDOC_FILE_START = "<tlddoc file=\"";

	// The string buffer for all of the files
	private StringBuffer allFiles = new StringBuffer();

	public void generate(Vector<File> tldFiles, File workingOutputDirectory) {

		generateWorkingCopies(tldFiles, workingOutputDirectory);
		writeWorkingCopies(workingOutputDirectory);
	}

	/**
	 * Generate the working copies
	 * 
	 * @param indexStringBuffer
	 */
	private void generateWorkingCopies(Vector<File> tldFiles, File workingOutputDirectory) {
		// the string buffer for the individual files
		StringBuffer indexStringBuffer = new StringBuffer();

		// now create the initial working copies
		
		SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
		try {
			TldSaxParser tldSaxParser = new TldSaxParser();
			SAXParser saxParser = saxParserFactory.newSAXParser();
			saxParser.setProperty("http://xml.org/sax/properties/lexical-handler", tldSaxParser);

			for (File tldFile : tldFiles) {
				try {
					TaskHelper.forceInfo(true, "Parsing " + tldFile);
					saxParser.parse(tldFile, tldSaxParser);

					StringBuffer parsedText = tldSaxParser.getParsedText();

					// split and write out one file for each tag
					writeIndividualTags(workingOutputDirectory, tldFile, parsedText.toString());

					indexStringBuffer.append(parsedText);

					FileWriter fileWriter = new FileWriter(workingOutputDirectory.getAbsolutePath() + "/" + tldFile.getName() + ".xml");
					BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

					allFiles.append(XML_TLDDOC_FILE_START + tldFile.getName() + XML_TLDDOC_FILE_END);
					bufferedWriter.write(XML_TLDDOC_FILE_START + tldFile.getName() + XML_TLDDOC_FILE_END);
					allFiles.append(tldSaxParser.getParsedText().toString());
					bufferedWriter.write(tldSaxParser.getParsedText().toString());
					allFiles.append(XML_TLDDOC_END);
					bufferedWriter.write(XML_TLDDOC_END);
					//Close the output stream
					bufferedWriter.close();

					tldSaxParser.reset();
				} catch (IOException jiioex) {
					// do nothing
				}
			}
		} catch (ParserConfigurationException jxppcex) {
			// do nothing
		} catch (SAXException oxssaxex) {
			// do nothing
		}
	}

	/**
	 * Remove all of the working copies
	 */
	public void removeWorkingCopies(File workingOutputDirectory) {
		File directory = new File(workingOutputDirectory.getAbsolutePath());
		File[] files = directory.listFiles();
		for (int i = 0; i < files.length; i++) {
			File file = files[i];
			boolean deleted = file.delete();
			TaskHelper.info("Cleaning up file " + file.getName() + " (" + (deleted ? "Success" : "Failure") + ")");
		}
		boolean deleted = directory.delete();
		TaskHelper.info("Deleting working directory (" + (deleted ? "Success" : "Failure") + ")");
	}
	
	private void writeIndividualTags(File workingOutputDirectory, File tldFile, String parsedText) {
		String fileName = tldFile.getName();
		
		int index = parsedText.indexOf(TLD_TAG_START);
		while(index != -1) {
			int endIndex = parsedText.indexOf(TLD_TAG_END, index);
			
			// now extract the tag name and 
			String temp = parsedText.substring(index, endIndex + TLD_TAG_END.length());
			String tagName = extractTagName(temp);
			
			writeIndividualTag(workingOutputDirectory, fileName + "." + tagName + ".tag-xml", temp);
			
			
			index = parsedText.indexOf(TLD_TAG_START, endIndex);
		}

		// now go through and grab the functions
		index = parsedText.indexOf(FUNCTION_TAG_START);
		while(index != -1) {
			int endIndex = parsedText.indexOf(FUNCTION_TAG_END, index);
			
			// now extract the tag name and 
			String temp = parsedText.substring(index, endIndex + FUNCTION_TAG_END.length());
			String tagName = extractTagName(temp);
			
			writeIndividualTag(workingOutputDirectory, fileName + "." + tagName + ".tag-xml", temp);
			
			index = parsedText.indexOf(FUNCTION_TAG_START, endIndex);
		}
	}
	
	private void writeIndividualTag(File workingOutputDirectory, String fileName, String fileContents) {
		try {
			FileWriter fileWriter = new FileWriter(workingOutputDirectory.getAbsolutePath() + "/" + fileName);
			BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
			
			bufferedWriter.write(fileContents);
			//Close the output stream
			bufferedWriter.close();
		} catch (IOException jiioex) {
			// do nothing
		}
		
	}

	private String extractTagName(String tagNodeString) {
		int startIndex = tagNodeString.indexOf(TAG_NAME_START);
		int endIndex = tagNodeString.indexOf(TAG_NAME_END);

		return(tagNodeString.substring(startIndex + TAG_NAME_START.length(), endIndex));
	}

	/**
	 * Write out the working copies
	 */
	private void writeWorkingCopies(File workingOutputDirectory) {
		try {
			FileWriter fileWriter = new FileWriter(workingOutputDirectory.getAbsolutePath() + "/index.xml");
			BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
			
			bufferedWriter.write(XML_TLDDOCS_START + allFiles.toString() + XML_TLDDOCS_END);
			//Close the output stream
			bufferedWriter.close();
		} catch (IOException jiioex) {
			// do nothing
		}
	}
}
