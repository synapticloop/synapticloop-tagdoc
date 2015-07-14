package synapticloop.ant;

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

import java.io.File;
import java.util.Vector;

import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;

import synapticloop.ant.generator.HtmlGenerator;
import synapticloop.ant.generator.PdfGenerator;
import synapticloop.ant.generator.WorkingGenerator;
import synapticloop.util.AnnotationHelper;
import synapticloop.util.TaskHelper;

public class TagDocTask extends Task {
	// filesets to be checked passed in by the ant sub system 
	protected Vector<FileSet> filesets = new Vector<FileSet>();
	// the actually found tld files from the filesets
	private Vector<File> tldFiles = new Vector<File>();

	// what to generate...
	private boolean generatePdf = true;
	private boolean generateHtml = true;

	// whether to delete the working directory after finishing
	private boolean cleanup = true;

	// the output directory
	private String outputDir = null;
	// the working directory
	private File workingOutputDirectory = null;


	/**
	 * Execute the ant task by getting all of the files in the fileset and
	 * ensuring that they are all tag library descriptor (tld) files
	 */
	public void execute() {
		if(!(generatePdf || generateHtml)) {
			TaskHelper.fatal("Must set attribute 'output' with 'html' and/or 'pdf'.");
			return;
		}

		// run through the fileset and get all of the documents and list them
		if(null == outputDir) {
			TaskHelper.fatal("Must set attribute 'outputDir'.");
			return;
		}

		// so far so good
		checkAndSortFiles();

		// now that we have the files - time to generate
		int numTldFiles = tldFiles.size();

		String s = "s";
		if(numTldFiles == 1) {
			s = "";
		}

		if(numTldFiles != 0) {
			TaskHelper.forceInfo(true, "Generating documentation for " + numTldFiles + " .tld file" + s + ".");
		} else {
			TaskHelper.forceInfo(true, "No .tld files found.  Exiting...");
			return;
		}

		// Generate the working copies
		WorkingGenerator workingGenerator = new WorkingGenerator();
		workingGenerator.generate(tldFiles, workingOutputDirectory);

		if(generatePdf) {
			// now generate the pdf file(s)
			PdfGenerator.generate(tldFiles, workingOutputDirectory, TaskHelper.checkAndCreateDirectory(getProject(), outputDir + "/pdf"));
		}

		if(generateHtml) {
			// now generate the HTML file(s)
			HtmlGenerator.generate(tldFiles, workingOutputDirectory, TaskHelper.checkAndCreateDirectory(getProject(), outputDir + "/html"));
		}

		if(cleanup) {
			workingGenerator.removeWorkingCopies(workingOutputDirectory);
		}
	}



	/**
	 * Check the files within the fileset to ensure that they are valid tag library
	 * descriptor files.
	 */
	private void checkAndSortFiles() {
		for(int i = 0; i < filesets.size(); i++) {
			FileSet fileset = (FileSet) filesets.elementAt(i);
			DirectoryScanner directoryScanner = fileset.getDirectoryScanner(getProject());
			String[] files = directoryScanner.getIncludedFiles();
			File dirBase = fileset.getDir(getProject());

			for(int j = 0; j < files.length; j++){
				File file = new File(dirBase, files[j]);
				if(TaskHelper.isTldFile(file)) {
					tldFiles.add(file);
					TaskHelper.info("Adding file " + file.getName() + " to file list.");
				} else {
					TaskHelper.warn("Ignoring file " + file.getName() + " as it is not a valid tld file.");
				}
			}
		}
	}
	

	/**
	 * Add the pre-configured annotation to the list of known annotations.  The
	 * passed in annotation will be instantiated and already have the property 
	 * setters called by the ant sub-system.
	 * 
	 * @param annotation The instantiated annotation  
	 */
	public void addConfiguredAnnotation(Annotation annotation) {
		AnnotationHelper.addConfiguredAnnotation(annotation);
	}

	/**
	 * The fileset to be used for this task
	 *  
	 * @param fileset the passed in fileset
	 */

	public void addFileset(FileSet fileset) {
		filesets.addElement(fileset);
	}
	
	/**
	 * Set the output directory for the generated information.  The directory (and
	 * associated sub-directories) will be created if they do not exist.
	 * 
	 * @param outputDir the output directory
	 */
	public void setOutputDir(String outputDir) {
		this.outputDir = outputDir;
		this.workingOutputDirectory = TaskHelper.checkAndCreateDirectory(getProject(), outputDir + "/working");
	}

	/**
	 * Set whether to be verbose when running this task
	 * 
	 * @param verbose whether to be verbose
	 */
	public void setVerbose(boolean verbose) {
		TagDocConfiguration.setVerbose(verbose);
	}

	public void setCleanup(boolean cleanup) {
		this.cleanup = cleanup;
	}

	/**
	 * Set the output types which looks through the string for the substring
	 * 'html' and/or 'pdf'
	 * 
	 * @param output the attribute setting
	 */
	public void setOutput(String output) {
		generatePdf = false;
		generateHtml = false;

		String temp = output.toLowerCase();
		if(temp.contains("pdf")) {
			generatePdf = true;
		}

		if(temp.contains("html")) {
			generateHtml = true;
		}
	}

	public void setIndexXsl(String indexXsl) {
		TagDocConfiguration.setIndexXsl(indexXsl);
	}

	public String getIndexXsl() {
		return(TagDocConfiguration.getIndexXsl());
	}

	public void setIndividualXsl(String individualXsl) {
		TagDocConfiguration.setIndividualXsl(individualXsl);
	}

	public String getIndividualXsl() {
		return(TagDocConfiguration.getIndividualXsl());
	}

	public void setUserConfig(String userConfig) {
		TagDocConfiguration.setUserConfig(userConfig);
	}

	public String getUserConfig() {
		return(TagDocConfiguration.getUserConfig());
	}
}
