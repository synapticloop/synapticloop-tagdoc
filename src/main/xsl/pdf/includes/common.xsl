<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     These are the common routines for both the 'individual.xsl' and the
	     'index.xsl' which can be included by using
	     
	     <xsl:include href="classpath://!/common.xsl"/>
	     
	     Which uses a custom resolver to find the file within the classpath
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     Parse the description node - this is where all of the annotations are
	     parsed into the corresponding formatted objects (fo) 
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="parse-description">
		<xsl:param name="description" />

		<!--
		  Parse the section 
		  -->
		<xsl:choose>
			<xsl:when test="name(.) = 'section'">
				<fo:block font-size="14pt" font-family="serif" line-height="15pt" text-align="left" margin-left="5px" padding-top="3pt" margin-bottom="7pt" border-bottom="solid">
					<xsl:value-of select="." />
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-section'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="13pt" text-align="justify"  margin-left="15pt">
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'heading'">
				<fo:block font-size="16pt" font-family="serif" line-height="15pt" text-align="left" padding-top="3pt" margin-bottom="7pt" border-bottom="solid">
					<xsl:value-of select="." />
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-heading'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="13pt" text-align="justify" margin-left="15pt">
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</fo:block>
			</xsl:when>

			<!-- Time for an unordered-list -->
			<xsl:when test="name(.) = 'ul'">
				<fo:list-block margin-left="15pt" margin-bottom="13pt">
					<xsl:for-each select="./li">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()"><fo:block text-align="right">-</fo:block></fo:list-item-label>
							<fo:list-item-body start-indent="body-start()"><fo:block><xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template></fo:block></fo:list-item-body>
						</fo:list-item>
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>

			<!-- Time for an ordered-list -->
			<xsl:when test="name(.) = 'ol'">
				<fo:list-block margin-left="15pt" margin-bottom="13pt">
					<xsl:for-each select="./li">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()"><fo:block text-align="right"><xsl:value-of select="position()" />.</fo:block></fo:list-item-label>
							<fo:list-item-body start-indent="body-start()"><fo:block><xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template></fo:block></fo:list-item-body>
						</fo:list-item>
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>

			<xsl:when test="name(.) = 'requiredparent'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="0pt" margin-left="15pt">
					<xsl:variable name="class-name"><xsl:value-of select="../../../short-name" />-<xsl:value-of  select="." /></xsl:variable>
					<fo:inline font-weight="bold">Required Parent: </fo:inline>
					<xsl:if test="$class-name != ''">
						<fo:basic-link internal-destination="{$class-name}">
							<fo:inline font-family="Courier" text-decoration="underline">
								<xsl:value-of select="normalize-space(.)" />
							</fo:inline>
						</fo:basic-link>
					</xsl:if>
				</fo:block>

				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="0pt" margin-left="15pt">
					<xsl:for-each select="../sub-requiredparent/child::node()">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-requiredparent'"></xsl:when>
			<xsl:when test="name(.) = 'link'"></xsl:when>

			<xsl:when test="name(.) = 'p'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="13pt" text-align="justify" margin-left="15pt">
					<xsl:for-each select="child::node()">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'class'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" space-before="13pt" margin-bottom="13pt" margin-left="15pt">
					<xsl:variable name="class-name" select="." />
					<fo:inline font-weight="bold">Class: </fo:inline> <fo:inline font-family="Courier" ><xsl:value-of select="normalize-space(.)" /></fo:inline> <xsl:value-of select="../sub-class" />
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-class'"></xsl:when>

			<xsl:when test="name(.) = 'example'">
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" space-before="13pt" font-weight="bold" margin-left="15pt">
					<fo:inline font-family="serif"><xsl:value-of select="." /></fo:inline>
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-example'">
				<fo:list-block margin-left="30pt" margin-bottom="13pt">
					<xsl:for-each select="./line">
						<fo:list-item>
							<xsl:choose>
								<xsl:when test="(position() mod 2) = 1">
									<fo:list-item-label end-indent="label-end()"><fo:block text-align="right" font-size="12pt" font-family="Courier" line-height="15pt"><xsl:value-of select="position()" />:</fo:block></fo:list-item-label>
									<fo:list-item-body start-indent="body-start()" text-align="start"><fo:block font-size="12pt" font-family="Courier" line-height="15pt" background-color="#CCCCCC"><xsl:value-of select="." /></fo:block></fo:list-item-body>
								</xsl:when>
								<xsl:otherwise>
									<fo:list-item-label end-indent="label-end()"><fo:block text-align="right" font-size="12pt" font-family="Courier" line-height="15pt"><xsl:value-of select="position()" />:</fo:block></fo:list-item-label>
									<fo:list-item-body start-indent="body-start()"><fo:block font-size="12pt" font-family="Courier" line-height="15pt" background-color="#FFFFFF"><xsl:value-of select="." /></fo:block></fo:list-item-body>
								</xsl:otherwise>
							</xsl:choose>
						</fo:list-item>
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>

			<xsl:when test="name(.) = 'fields'">
				<xsl:if test="count(./field) != 0">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="30%" />
							<fo:table-column column-width="70%" />
							<fo:table-header>
								<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" number-columns-spanned="2" padding="3pt"><fo:block font-weight="bold">Field summary for: <fo:inline font-family="Courier"><xsl:value-of select="@class" /></fo:inline></fo:block></fo:table-cell>
							</fo:table-header>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
										<fo:block font-weight="bold" text-align="right">Type</fo:block>
									</fo:table-cell>
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
										<fo:block font-weight="bold">Field</fo:block>
									</fo:table-cell>
								</fo:table-row>

								<xsl:for-each select="field">
									<fo:table-row>
										<fo:table-cell margin="0pt" border="solid" padding="3pt">
										  <fo:block text-align="right" font-family="Courier" ><xsl:value-of select="type" /></fo:block>
										</fo:table-cell>
										<fo:table-cell margin="0pt" border="solid" padding="3pt">
										  <fo:block font-family="Courier" ><xsl:value-of select="name" /></fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:for-each>

							</fo:table-body>
						</fo:table>
					</xsl:if>
				</xsl:when>

			<xsl:when test="name(.) = 'methods'">
				<xsl:if test="count(./method) != 0">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="33%" />
							<fo:table-column column-width="67%" />

							<fo:table-header>
								<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" number-columns-spanned="2" padding="3pt"><fo:block font-weight="bold">Method summary for: <fo:inline font-family="Courier"><xsl:value-of select="@class" /></fo:inline></fo:block></fo:table-cell>
							</fo:table-header>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
										<fo:block font-weight="bold" text-align="right">Return Type</fo:block>
									</fo:table-cell>
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
										<fo:block font-weight="bold">Method</fo:block>
									</fo:table-cell>
								</fo:table-row>

								<xsl:for-each select="method">
									<fo:table-row>
										<fo:table-cell margin="0pt" border="solid" padding="3pt">
											<fo:block text-align="right" font-family="Courier" ><xsl:value-of select="return-type" /></fo:block>
										</fo:table-cell>
										<fo:table-cell margin="0pt" border="solid" padding="3pt">
											<fo:block font-family="Courier" ><xsl:value-of select="name" /></fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:for-each>

							</fo:table-body>
						</fo:table>
					</xsl:if>
				</xsl:when>

			<xsl:when test="name(.) = 'allowablevalue'">
				<!-- 
				  Generate all of the allowable values - but only if it the first one.
				  This will allow the title header to go across multiple pages, however
				  it means that only one grouping of allowable value elements are
				  allowed within any one description. 
				  -->
					<xsl:if test="name(preceding-sibling::*[1]) != 'allowablevalue'">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="30%" />
					<fo:table-column column-width="70%" />
						<fo:table-header>
							<fo:table-cell border="solid" background-color="#CCCCFF" number-columns-spanned="2" padding="3pt"><fo:block font-weight="bold">Allowable Values</fo:block></fo:table-cell>
						</fo:table-header>
						<fo:table-body>
							<xsl:for-each select="../node()[name(.) = 'allowablevalue']">
								<fo:table-row>

									<!-- print out the allowable value -->
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
										<fo:block font-weight="bold" text-align="right" font-family="Courier"><xsl:value-of select="value" /></fo:block>
									</fo:table-cell>

									<!-- print out the description of the allowable value -->
									<fo:table-cell margin="0pt" border="solid" padding="3pt" font-family="serif">
										<fo:block>
											<xsl:for-each select="sub-allowablevalue/node()">
												<xsl:call-template name="parse-markdown">
													<xsl:with-param name="markdown" select="."/>
												</xsl:call-template>
											</xsl:for-each>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:for-each>

							<!-- Now print out the default value -->
							<xsl:for-each select="../node()[name(.) = 'default']">
								<fo:table-row>
									<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" padding="3pt">
										<fo:block font-weight="bold" text-align="right" >Default</fo:block>
									</fo:table-cell>
									<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" padding="3pt">
										<fo:block font-weight="bold" font-family="Courier"><xsl:value-of select="." /></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:for-each>
						</fo:table-body>
					</fo:table>
				</xsl:if>
			</xsl:when>

			<!-- 
			  The default node is parsed in the allowable value when case above.
			  Do nothing - and alos do nothing for the sub default
			  -->
			<xsl:when test="name(.) = 'default'"></xsl:when>
			<xsl:when test="name(.) = 'sub-default'"></xsl:when>

			<!-- 
			  If we do not have a specific parser for the node name, put parentheses
			  around it and print out the markdown content
			  -->
			<xsl:otherwise>
				<fo:block font-size="12pt" font-family="serif" line-height="15pt" margin-bottom="7pt" text-align="justify" margin-left="15pt">
					{<xsl:value-of select="name(.)" />}
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     The parse-markdown template expects a parameter named 'markdown' which
	     contains the list of nodes to be parsed.  This will parse the content
	     recusively
	     
	     This section should be the same for the 'index.xsl' and the 
	     'individual.xsl' files
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="parse-markdown">
		<xsl:param name="markdown" />

		<!-- 
		  This is where the recursion gets done 
		  -->

		<xsl:for-each select="$markdown">
			<xsl:choose>
				<!-- Parse a normal paragraph tag -->
				<xsl:when test="name(.) = 'p'">
					<xsl:call-template name="parse-markdown">
						<xsl:with-param name="markdown" select="child::node()"/>
					</xsl:call-template>
				</xsl:when>

				<!-- parse the strike-through tag -->
				<xsl:when test="name(.) = 'strike'">
					<fo:inline text-decoration="line-through">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:when>

				<!-- parse the underline tag -->
				<xsl:when test="name(.) = 'u'">
					<fo:inline text-decoration="underline">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:when>

				<!-- parse the emphasis tag -->
				<xsl:when test="name(.) = 'em'">
					<fo:inline font-style="italic">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:when>

				<!-- parse the strong tag -->
				<xsl:when test="name(.) = 'strong'">
					<fo:inline font-weight="bold">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:when>

				<!-- parse the pre-formatted tag -->
				<xsl:when test="name(.) = 'pre'">
					<fo:inline font-family="Courier">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:when>

				<!-- normal text output it as is -->
				<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>