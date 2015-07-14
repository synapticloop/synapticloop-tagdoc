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

import static org.junit.Assert.*;

import java.io.File;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.FileSet;
import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;

import static org.mockito.Mockito.*;

public class TagDocTaskTest {
	private TagDocTask tagDocTask;
	private Project project;

	@Before
	public void setup() {
		tagDocTask = new TagDocTask();
		
		project = mock(Project.class);
		tagDocTask.setProject(project);
		when(project.getBaseDir()).thenReturn(new File("/tmp"));
	}
	
	@Test
	public void testOutputDirectory() {
		tagDocTask.setVerbose(true);
		tagDocTask.setOutputDir("/tlddoc/tests");
	}

	
	@Test
	public void testAddAnnotation() {
		Annotation annotation = new Annotation();
		annotation.setClassName("synapticloop.ant.annotation.DefaultAnnotator");
		annotation.setName("name");

		tagDocTask.addConfiguredAnnotation(annotation);
		
		annotation.setClassName(null);
		tagDocTask.addConfiguredAnnotation(annotation);

		annotation.setName(null);
		tagDocTask.addConfiguredAnnotation(annotation);

		annotation.setClassName("non.existent.class.name");
		tagDocTask.addConfiguredAnnotation(annotation);

		annotation.setName("name");
		tagDocTask.addConfiguredAnnotation(annotation);
	}
	

	@Test
	public void testAddFileSet() {
		tagDocTask.addFileset(new FileSet());
	}
	@Test
	public void testSetterGetter() {
		tagDocTask.setCleanup(true);
		tagDocTask.setIndexXsl("indexXsl");
		assertEquals("indexXsl", tagDocTask.getIndexXsl());
		tagDocTask.setIndividualXsl("individualXsl");
		assertEquals("individualXsl", tagDocTask.getIndividualXsl());
		tagDocTask.setUserConfig("userConfig");
		assertEquals("userConfig", tagDocTask.getUserConfig());
	}

	@Test
	public void testExecute() {
		tagDocTask.execute();
	}

	@Test
	public void testExecuteWithOutputDir() {
		tagDocTask.setOutputDir(System.getProperty("java.io.tmpdir"));
		tagDocTask.execute();
		
		
	}
}
