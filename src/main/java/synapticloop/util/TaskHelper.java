package synapticloop.util;

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
import java.io.FilenameFilter;

import org.apache.tools.ant.Project;

import synapticloop.ant.TagDocConfiguration;

/**
 * Simple class to log messages and help the task
 *
 */
public class TaskHelper {
	private static final String MESSAGE_WARN = "WARN";
	private static final String MESSAGE_INFO = "INFO";
	private static final String MESSAGE_DEBUG = "DEBUG";
	private static final String MESSAGE_FATAL = "FATAL";

	/**
	 * Print a message to the console in the format of:
	 * 
	 * prefix:message
	 * 
	 * The message will only be printed if the verbose flag is set to 'true'
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param prefix The prefix for the message
	 * @param message the message
	 */
	private static void message(String prefix, String message) {
		if(TagDocConfiguration.getVerbose()) {
			System.out.println(prefix + ": " + message);
		}
	}

	private static void message(boolean verbose, String prefix, String message) {
		if(verbose) {
			System.out.println(prefix + ": " + message);
		}
	}

	/**
	 * Log a fatal message to the console if verbose mode is set to true
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param message The message to log
	 */
	public static void fatal(String message) {
		message(MESSAGE_FATAL, message);
	}

	/**
	 * Log a debug message to the console if verbose mode is set to true
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param message The message to log
	 */
	public static void debug(String message) {
		message(MESSAGE_DEBUG, message);
	}

	/**
	 * Log an info message to the console if verbose mode is set to true
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param message The message to log
	 */
	public static void info(String message) {
		message(MESSAGE_INFO, message);
	}

	public static void forceInfo(boolean verbose, String message) {
		message(verbose, MESSAGE_INFO, message);
	}

	/**
	 * Log a warn message to the console if verbose mode is set to true
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param message The message to log
	 */
	public static void warn(String message) {
		message(MESSAGE_WARN, message);
	}

	/**
	 * Check to see whether the directory exists and create it if not
	 * 
	 * @param verbose Whether verbose mode is turned on
	 * @param project The ant project object
	 * @param directory the directory to create
	 * @return
	 */
	public static File checkAndCreateDirectory(Project project, String directory) {
		String outputDir = null;
		if(directory.startsWith("/")) {
			outputDir = project.getBaseDir() + directory;
		} else {
			outputDir = project.getBaseDir() + "/" + directory;
		}
		
		// now that we have the directory - check to see whether it exists
		File file = new File(outputDir);
		if(file.isFile()) {
			fatal("The 'outputDir' attribute currently points to an existing file.");
			return(null);
		} else {
			// looks good so far - possibly a directory
			if(file.exists()) {
				if(file.canRead() && file.canWrite()) {
					info("Directory " + outputDir + " exists.");
					return(file);
				} else {
					fatal("Directory " + outputDir + " does not have read/write access.");
					return(null);
				}
			} else {
				// doesn't exist - create it
				if(file.mkdirs()) {
					info("Directory " + outputDir + " created successfuly.");
					return(file);
				} else {
					fatal("Directory " + outputDir + " could not be created.");
					return(null);
				}
			}
		}
	}

	/**
	 * Return whether the passed in file reference conforms to the following
	 * criteria:
	 * <ol>
	 * 	<li>is readable,</li>
	 *  <li>is a file (as opposed to a directory), and</li>
	 *  <li>ends with the prefix '.tld' (case insensitive)</li>
	 * <ol>
	 *  
	 * @param file the file to be checked
	 * @return whether the file conforms to the above criteria
	 */
	public static boolean isTldFile(File file) {
		if(file.canRead() && file.isFile() && file.getName().toLowerCase().endsWith(".tld")) {
			return(true);
		}
		return(false);
	}

	public static String[] getAllFilesInDirectory(File directory, final String filenameEndsWith) {
		
		FilenameFilter filenameFilter = new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return(name.endsWith(filenameEndsWith));
			}
		};
		
		return(directory.list(filenameFilter));
	}
}
