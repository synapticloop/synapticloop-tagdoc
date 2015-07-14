<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:include href="classpath://!/pdf/includes/common.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/page-layouts.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/common-text.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/common-blocks.xsl"/>

	<xsl:template match ="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

			<xsl:call-template name="define-master-sets" />

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This page layout is for the front page, including the table of 
	     contents.
	     
	     It uses the 'default' page master defined above
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="front-page-attribution" />

			<fo:flow flow-name="xsl-region-body">
				<!-- 
				  Large blue square with the tag library short name in it 
				  -->
				<xsl:variable name="short-name" select="/tlddoc/taglib/short-name"/>
				<fo:block>
					<fo:inline font-size="178pt"
										font-family="Courier"
										margin-bottom="5pt"
										margin-left="15pt"
										padding="5px"
										padding-top="10pt"
										border="solid"
										border-width="1px"
										border-color="#000"
										background-color="#CDCCFD"
										id="front-page">
						<xsl:value-of select="/tlddoc/taglib/short-name" />
					</fo:inline>
				</fo:block>

				<fo:block font-size="14pt" 
							font-family="Courier" 
							line-height="24pt"
							margin-bottom="15pt" 
							color="black"
							margin-top="10pt"
							vertical-align="top"
							padding-left="5px">
					<xsl:value-of select="/tlddoc/taglib/display-name"/> (v <xsl:value-of select="/tlddoc/taglib/tlib-version" />) Tag Library Documentation
				</fo:block>

				<!-- Here we print out the overview -->
					<fo:block font-size="10pt" line-height="15pt" margin-bottom="3pt" margin-left="20pt" text-align="justify" font-style="italic" border-left-style="solid" border-left-color="#CCCCCC" border-left-width="1px" padding-left="5px">
						<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="tlddoc/taglib/comment/overview/child::node()"/></xsl:call-template>
					</fo:block>

				<!-- Now for the links to the cheat sheets and the quick reference guide -->
				<fo:block margin-top="20pt" />

				<xsl:if test="count(/tlddoc/taglib/tag) != 0">
					<xsl:call-template name="document-sub-heading"><xsl:with-param name="heading">Tags</xsl:with-param></xsl:call-template>

					<xsl:for-each select="/tlddoc/taglib/tag">
						<xsl:if test="name(preceding-sibling::*[1]) = 'comment'">

							<!-- Print a border between each comment sections -->
							<fo:block space-before="15pt" margin-bottom="5pt" padding="0pt" />
							
							<!-- Now go through the comment element and format all of the text -->
							<xsl:for-each select="preceding-sibling::*[1]/*">
								<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
							</xsl:for-each>

							<!-- Print a border between each comment sections -->
							<fo:block margin-top="7pt" margin-left="15pt" border-bottom="solid" >Referenced Tags:</fo:block>
						</xsl:if>

						<xsl:variable name="basic-link"><xsl:value-of select="/tlddoc/taglib/short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:variable>
						<fo:block font-size="12pt"
											font-family="Courier"
											line-height="13pt"
											margin-bottom="0pt"
											margin="0pt"
											margin-left="15pt"
											text-align="justify"
											text-align-last="justify">
							<fo:basic-link internal-destination="{$basic-link}">
								<fo:inline text-decoration="underline">
									<xsl:value-of select="/tlddoc/taglib/short-name" />:<xsl:value-of select="normalize-space(name)" />
								</fo:inline>
								<fo:leader leader-pattern="dots"/>
								<fo:page-number-citation ref-id="{$basic-link}"/>
							</fo:basic-link>
						</fo:block>
		
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(/tlddoc/taglib/function) != 0">
					<xsl:call-template name="document-sub-heading"><xsl:with-param name="heading">Functions</xsl:with-param></xsl:call-template>

					<xsl:for-each select="/tlddoc/taglib/function">
						<xsl:if test="name(preceding-sibling::*[1]) = 'comment'">

							<!-- Print a border between each comment sections -->
							<fo:block space-before="15pt" margin-bottom="5pt" padding="0pt" />

							<!-- Now go through the comment element and format all of the text -->
							<xsl:for-each select="preceding-sibling::*[1]/*">
								<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
							</xsl:for-each>

							<!-- Print a border between each comment sections -->
							<fo:block margin-top="7pt" margin-left="15pt" border-bottom="solid" >Referenced Functions:</fo:block>
						</xsl:if>

						<!-- Create a link to  -->
						<xsl:variable name="basic-link"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:variable>
						<fo:block font-size="12pt"
											font-family="Courier"
											line-height="13pt"
											margin-bottom="0pt"
											margin="0pt"
											margin-left="15pt"
											text-align="justify"
											text-align-last="justify">
							<fo:basic-link internal-destination="{$basic-link}">
								<fo:inline text-decoration="underline">
									<xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" />
								</fo:inline>
								<fo:leader leader-pattern="dots"/>
								<fo:page-number-citation ref-id="{$basic-link}"/>
							</fo:basic-link>
						</fo:block>

					</xsl:for-each>
				</xsl:if>


				<!-- Now for the links to the cheat sheets and the quick reference guide -->
				<fo:block margin-top="20pt" />
				<xsl:call-template name="document-sub-heading"><xsl:with-param name="heading">Cheat Sheet</xsl:with-param></xsl:call-template>

					<xsl:variable name="id-cheat-sheet">Cheat sheet</xsl:variable>
					<fo:block font-size="12pt"
										font-family="Courier"
										line-height="13pt"
										margin-left="15pt"
										padding="0"
										text-align="justify"
										text-align-last="justify">
						<fo:basic-link internal-destination="{$id-cheat-sheet}">
							<fo:inline font-family="sans-serif">Cheat sheet</fo:inline>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="{$id-cheat-sheet}"/>
						</fo:basic-link>
					</fo:block>
			</fo:flow> <!-- closes the flow element-->
		</fo:page-sequence> 
		<!-- End of front page/table of contents -->


	<xsl:for-each select="/tlddoc/taglib/tag">
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="block-table-of-contents-all" />

			<fo:flow flow-name="xsl-region-body">

				<xsl:call-template name="page-heading">
					<xsl:with-param name="heading"><xsl:value-of select="/tlddoc/taglib/short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:with-param>
				</xsl:call-template>

				<xsl:variable name="tag-class"><xsl:value-of select="tag-class"/></xsl:variable>
				<xsl:variable name="id-tag-class"><xsl:value-of select="../short-name" />-<xsl:value-of select="tag-class"/></xsl:variable>

				<fo:table table-layout="fixed" width="100%" border="solid" margin-bottom="13pt">
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt" text-align="justify" id="{$id-tag-class}">
									<fo:inline font-weight="bold" font-family="sans-serif">Tag Class:</fo:inline> <xsl:value-of select="tag-class" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt" font-family="sans-serif" line-height="15pt" margin-bottom="0pt" text-align="justify">
									<fo:inline font-weight="bold">Body Content:</fo:inline> <xsl:value-of select="body-content" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

				<xsl:for-each select="description/*">
					<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
				</xsl:for-each>

				<xsl:if test="count(attribute) != 0">

					<fo:table table-layout="fixed" width="100%" space-before="13pt">
						<fo:table-column column-width="20%" />
						<fo:table-column column-width="20%" />
						<fo:table-column column-width="20%" />
						<fo:table-column column-width="40%" />
						<fo:table-header margin-left="0pt">
							<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" number-columns-spanned="4" padding="3pt"><fo:block font-weight="bold">Attribute Summary</fo:block></fo:table-cell>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-weight="bold">Name</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-weight="bold">Required</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-weight="bold">Expressions</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-weight="bold">Type</fo:block>
								</fo:table-cell>
							</fo:table-row>

							<xsl:for-each select="attribute">
							<fo:table-row>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block><xsl:value-of select="name" /></fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block><xsl:value-of select="required" /></fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block><xsl:value-of select="rtexprvalue" /></fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-family="Courier">
										<xsl:choose>
											<xsl:when test="normalize-space(type) = ''">String</xsl:when>
											<xsl:otherwise><xsl:value-of select="type" /></xsl:otherwise>
										</xsl:choose>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							</xsl:for-each>

						</fo:table-body>
					</fo:table>
				</xsl:if>

				<!--
				  Go through each of the attributes
				  -->

				<xsl:for-each select="attribute">
					<fo:block font-size="14pt"
										font-family="Courier"
										line-height="13pt"
										space-before="13pt"
										margin-bottom="7pt"
										margin="0pt"
										text-align="justify"
										font-weight="bold"
										border-bottom="solid">
						<xsl:value-of select="name" />
					</fo:block>

					<xsl:for-each select="description/*">
						<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
					</xsl:for-each>

				</xsl:for-each>


			</fo:flow>
		</fo:page-sequence>


	</xsl:for-each>


	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This is the start of the overview pages for each of the function 
	     libraries
	     
	     Note: This does not process any of the tag libraries
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<!-- Now for the functions -->
	<xsl:for-each select="/tlddoc/taglib/function">
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="block-table-of-contents-all" />


			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="page-heading">
					<xsl:with-param name="heading"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:with-param>
				</xsl:call-template>

				<xsl:variable name="function-class"><xsl:value-of select="function-class"/></xsl:variable>
				<xsl:variable name="id-function-class"><xsl:value-of select="../short-name" />-<xsl:value-of select="function-class"/>-<xsl:value-of select="name"/></xsl:variable>

				<fo:table table-layout="fixed" width="100%" border="solid" margin-bottom="13pt">
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt"
										font-family="Courier"
										line-height="15pt"
										margin-bottom="0pt"
										text-align="justify"
										id="{$id-function-class}">
									<fo:inline font-weight="bold" font-family="sans-serif">Function Class:</fo:inline> <xsl:value-of select="function-class" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt">
									<fo:inline font-weight="bold" font-family="sans-serif">Function Signature:</fo:inline> <xsl:value-of select="function-signature" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

				<xsl:for-each select="description/*">
					<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
				</xsl:for-each>

				<fo:block font-size="12pt" font-family="Courier" line-height="15pt" space-before="13pt" margin-left="15pt">
					<xsl:value-of select="example" />
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:for-each>

		<fo:page-sequence master-reference="two-columns">

			<xsl:call-template name="block-table-of-contents-all" />

			<fo:flow flow-name="xsl-region-body">

				<!-- Create the cheat sheet -->
				<xsl:call-template name="block-cheat-sheet">
					<xsl:with-param name="heading">Cheat sheet</xsl:with-param>
					<xsl:with-param name="tag-nodes" select="tlddoc/taglib" />
					<xsl:with-param name="function-nodes" select="tlddoc/taglib" />
				</xsl:call-template>

			</fo:flow>
		</fo:page-sequence>	
	</fo:root>
	</xsl:template>
</xsl:stylesheet>
