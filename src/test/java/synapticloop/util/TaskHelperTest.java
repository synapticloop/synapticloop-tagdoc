package synapticloop.util;

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
import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;

import synapticloop.ant.TagDocConfiguration;

import static org.mockito.Mockito.*;

public class TaskHelperTest {
	TaskHelper taskHelper;
	Project project;

	@Before
	public void setup() {
		taskHelper = new TaskHelper();
		project = mock(Project.class);
		when(project.getBaseDir()).thenReturn(new File(System.getProperty("java.io.tmpdir")));
	}

	@Test
	public void testMessages() {
		TaskHelper.fatal("message");
		TaskHelper.debug("message");
		TaskHelper.info("message");
		TaskHelper.warn("message");
	}
	
	@Test
	public void testIsTldFile() {
		File file = mock(File.class);
		when(file.canRead()).thenReturn(false);
		assertFalse(TaskHelper.isTldFile(file));
		
		when(file.isFile()).thenReturn(false);
		assertFalse(TaskHelper.isTldFile(file));
		
		when(file.getName()).thenReturn("something.nottld");
		assertFalse(TaskHelper.isTldFile(file));
		
		when(file.canRead()).thenReturn(true);
		assertFalse(TaskHelper.isTldFile(file));

		when(file.isFile()).thenReturn(true);
		assertFalse(TaskHelper.isTldFile(file));

		when(file.getName()).thenReturn("something.tld");
		assertTrue(TaskHelper.isTldFile(file));
}

	@Test
	public void testDirectoryCreation() {
		TaskHelper.checkAndCreateDirectory(project, "tmp");
		// test that the directory exists
		TaskHelper.checkAndCreateDirectory(project, "tmp");
		TaskHelper.checkAndCreateDirectory(project, "tmp/some/directory");
		
	}
}
