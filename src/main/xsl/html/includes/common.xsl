<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     These are the common text routines for both the 'individual.xsl' 
	     and the 'index.xsl' which can be included by using
	     
	     <xsl:include href="classpath://!/html/includes/common.xsl"/>
	     
	     Which uses a custom resolver to find the file within the classpath
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="generate-includes">
		<link />
	</xsl:template>

	<xsl:template name="generate-header-links">
	</xsl:template>

	<xsl:template name="parse-description">
		<xsl:param name="description" />

		<!--
		  Parse the section 
		  -->
		<xsl:choose>
			<xsl:when test="name(.) = 'section'">
				<p class="section">
					<xsl:value-of select="." />
				</p>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-section'">
				<p class="sub-section">
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</p>
			</xsl:when>

			<xsl:when test="name(.) = 'heading'">
				<h2><xsl:value-of select="." /></h2>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-heading'">
				<p class="sub-heading">
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</p>
			</xsl:when>

			<!-- Time for an unordered-list -->
			<xsl:when test="name(.) = 'ul'">
				<ul>
					<xsl:for-each select="./li">
						<li><xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template></li>
					</xsl:for-each>
				</ul>
			</xsl:when>

			<!-- Time for an ordered-list -->
			<xsl:when test="name(.) = 'ol'">
				<ol>
					<li><xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template></li>
				</ol>
			</xsl:when>
<!-- 
			<xsl:when test="name(.) = 'requiredparent'">
				<p><span class="bold">Required Parent: </span></p>
				<fo:block font-size="12pt" font-family="sans-serif" line-height="15pt" margin-bottom="0pt" margin-left="15pt">
					<xsl:variable name="class-name"><xsl:value-of select="../../../short-name" />-<xsl:value-of  select="." /></xsl:variable>
					<fo:inline font-weight="bold"></fo:inline>
					<xsl:if test="$class-name != ''">
						<fo:basic-link internal-destination="{$class-name}">
							<fo:inline font-family="Courier" text-decoration="underline">
								<xsl:value-of select="normalize-space(.)" />
							</fo:inline>
						</fo:basic-link>
					</xsl:if>
				</fo:block>

				<fo:block font-size="12pt" font-family="sans-serif" line-height="15pt" margin-bottom="0pt" margin-left="15pt">
					<xsl:for-each select="../sub-requiredparent/child::node()">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>
 -->
			<xsl:when test="name(.) = 'sub-requiredparent'"></xsl:when>
			<xsl:when test="name(.) = 'link'"></xsl:when>

			<xsl:when test="name(.) = 'p'">
				<p>
					<xsl:for-each select="child::node()">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</p>
			</xsl:when>

			<xsl:when test="name(.) = 'class'">
				<fo:block font-size="12pt" font-family="sans-serif" line-height="15pt" space-before="13pt" margin-bottom="13pt" margin-left="15pt">
					<xsl:variable name="class-name" select="." />
					<fo:inline font-weight="bold">Class: </fo:inline> <fo:inline font-family="Courier" ><xsl:value-of select="normalize-space(.)" /></fo:inline> <xsl:value-of select="../sub-class" />
				</fo:block>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-class'"></xsl:when>

			<xsl:when test="name(.) = 'example'">
				<h3><xsl:value-of select="." /></h3>
			</xsl:when>

			<xsl:when test="name(.) = 'sub-example'">
				<ol class="example">
					<xsl:for-each select="./line">
						<xsl:choose>
							<xsl:when test="(position() mod 2) = 1">
								<li class="alternate"><xsl:value-of select="." /></li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="." /></li>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</ol>
				
			</xsl:when>

			<xsl:when test="name(.) = 'fields'">
				<xsl:if test="count(./field) != 0">
					<table class="fields">
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
						</table>
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
									<fo:table-cell margin="0pt" border="solid" padding="3pt">
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
				<p class="unknown">
					<span class="bold"><xsl:value-of select="name(.)" /></span>
					<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="child::node()"/></xsl:call-template>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="parse-markdown">
		<xsl:param name="markdown" />

		<!-- 
		  This is where the recursion gets done 
		  -->

		<xsl:for-each select="$markdown">
			<xsl:choose>
				<!-- Parse a normal paragraph tag -->
				<xsl:when test="name(.) = 'p'">
					<xsl:element name="p">
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- parse the strike-through tag -->
				<xsl:when test="name(.) = 'strike'">
					<xsl:element name="span">
						<xsl:attribute name="class">strike</xsl:attribute>
							<xsl:call-template name="parse-markdown">
								<xsl:with-param name="markdown" select="child::node()"/>
							</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- parse the underline tag -->
				<xsl:when test="name(.) = 'u'">
					<xsl:element name="span">
						<xsl:attribute name="class">underline</xsl:attribute>
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- parse the emphasis tag -->
				<xsl:when test="name(.) = 'em'">
					<xsl:element name="span">
						<xsl:attribute name="class">emphasis</xsl:attribute>
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- parse the strong tag -->
				<xsl:when test="name(.) = 'strong'">
					<xsl:element name="span">
						<xsl:attribute name="class">bold</xsl:attribute>
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- parse the pre-formatted tag -->
				<xsl:when test="name(.) = 'pre'">
					<xsl:element name="span">
						<xsl:attribute name="class">pre</xsl:attribute>
						<xsl:call-template name="parse-markdown">
							<xsl:with-param name="markdown" select="child::node()"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>

				<!-- normal text output it as is -->
				<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>