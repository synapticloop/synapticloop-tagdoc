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

import static org.junit.Assert.*;

import java.io.File;
import java.util.Vector;

import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import org.mockito.Mock;

import static org.mockito.Mockito.*;

public class WorkingGeneratorTest {
	WorkingGenerator workingGenerator;

	@Before
	public void setup() {
		workingGenerator = new WorkingGenerator();
	}

	@Test
	public void testGenerate() {
		WorkingGenerator workingGenerator = new WorkingGenerator();
		workingGenerator.generate(new Vector<File>(), new File(System.getProperty("java.io.tmpdir")));
	}
}
