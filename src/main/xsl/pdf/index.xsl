<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<xsl:include href="classpath://!/pdf/includes/common.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/page-layouts.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/common-text.xsl"/>
	<xsl:include href="classpath://!/pdf/includes/common-blocks.xsl"/>

	<xsl:template match ="/">

		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<!-- define the page layouts -->
			<xsl:call-template name="define-master-sets" />
			<!-- end: defines page layout -->


	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This page layout is for the front page, including the table of 
	     contents.
	     
	     It uses the 'default' page master defined above
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="front-page-attribution" />

			<fo:flow flow-name="xsl-region-body">

				<!-- the document heading  -->
				<xsl:call-template name="document-heading"><xsl:with-param name="heading">Tag Library Documentation</xsl:with-param></xsl:call-template>

				<!--
				  Go through each of the tag libraries that are defined in the document and
				  print out the following information:
				  
				  {The Tag name} ({the file name}) ..................................{page number}
				    | {overview of the tag}
				  -->
				<xsl:for-each select="/tlddocs/tlddoc">
					<xsl:variable name="short-name" select="taglib/short-name"/>

					<!-- 
					  Print out each of the short names, followed by a line of dots and
					  a link to the page on which the tag library resides
					  -->
					<fo:block font-size="12pt"
										font-family="serif"
										font-style="italic"
										line-height="13pt"
										margin-bottom="0pt"
										margin-left="15pt"
										text-align="justify"
										text-align-last="justify">
						<fo:basic-link internal-destination="{$short-name}">
							<fo:inline text-decoration="underline">
								<xsl:value-of select="taglib/display-name"/> (<xsl:value-of select="@file" />)
							</fo:inline>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="{$short-name}"/>
						</fo:basic-link>
					</fo:block>

					<!-- Here we print out the overview -->

					<fo:block font-size="12pt" line-height="15pt" margin-bottom="3pt" margin-left="20pt" text-align="justify" font-style="italic" font-family="serif" border-left-style="solid" border-left-color="#CCCCCC" border-left-width="1px" padding-left="5px">
						<xsl:call-template name="parse-markdown"><xsl:with-param name="markdown" select="taglib/comment/overview/child::node()"/></xsl:call-template>
					</fo:block>
				</xsl:for-each>

				<!-- Now for the links to the cheat sheets and the quick reference guide -->
				<fo:block margin-top="20pt" />
				<xsl:call-template name="document-sub-heading"><xsl:with-param name="heading">Reference Guides</xsl:with-param></xsl:call-template>

				<xsl:for-each select="/tlddocs/tlddoc">
					<xsl:variable name="id-cheat-sheet"><xsl:value-of select="taglib/short-name" /> Cheat Sheet</xsl:variable>
					<fo:block font-size="12pt"
										font-family="serif" 
										font-style="italic"
										line-height="13pt"
										margin-left="15pt"
										padding="0"
										text-align="justify"
										text-align-last="justify">
						<fo:basic-link internal-destination="{$id-cheat-sheet}">
							<fo:inline font-family="serif" font-style="italic" text-decoration="underline"><xsl:value-of select="taglib/short-name" /> Cheat Sheet</fo:inline>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="{$id-cheat-sheet}"/>
						</fo:basic-link>
					</fo:block>

					<fo:table table-layout="fixed" 
							margin-left="10pt"
							width="100%" 
							font-size="12pt"
							font-family="serif" 
							font-style="italic">
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-body>
							<xsl:for-each select="./taglib/tag">
									<xsl:if test="(position() mod 4) = 1">
										<fo:table-row>
											<fo:table-cell>
												<fo:block>
													<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(name)" /></xsl:variable>
													<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
														<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="name" /></fo:inline>
													</fo:basic-link>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::tag[1]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::tag[1]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::tag[1]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::tag[2]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::tag[2]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::tag[2]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::tag[3]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::tag[3]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::tag[3]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:if>
							</xsl:for-each>
							<fo:table-row><fo:table-cell><fo:block></fo:block></fo:table-cell></fo:table-row>
						</fo:table-body>
					</fo:table>

					<fo:table table-layout="fixed" 
							margin-left="10pt"
							width="100%"
							font-size="12pt"
							font-family="serif" 
							font-style="italic">
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="25%" />
						<fo:table-body>
							<xsl:for-each select="./taglib/function">
									<xsl:if test="(position() mod 4) = 1">
										<fo:table-row>
											<fo:table-cell>
												<fo:block>
													<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(/name)" /></xsl:variable>
													<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
														<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="name" /></fo:inline>
													</fo:basic-link>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::function[1]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::function[1]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::function[1]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::function[2]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::function[2]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::function[2]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block>
													<xsl:if test="./following-sibling::function[3]/name">
														<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(following-sibling::function[3]/name)" /></xsl:variable>
														<fo:basic-link internal-destination="{$cheat-sheet-basic-link}">
															<fo:inline text-decoration="underline"><xsl:value-of select="../short-name" />:<xsl:value-of select="./following-sibling::function[3]/name" /></fo:inline>
														</fo:basic-link>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:if>
							</xsl:for-each>
							<fo:table-row><fo:table-cell><fo:block></fo:block></fo:table-cell></fo:table-row>
						</fo:table-body>
					</fo:table>
					
					<fo:block margin-top="20pt" />
				</xsl:for-each>


				<fo:block font-size="12pt"
									font-family="serif"
									font-style="italic"
									line-height="13pt"
									margin-left="15pt"
									padding="0"
									text-align="justify"
									text-align-last="justify">
					<fo:basic-link internal-destination="Quick Reference Guide">
						<fo:inline font-family="serif" font-style="italic" text-decoration="underline">Quick Reference Guide</fo:inline>
						<fo:leader leader-pattern="dots"/>
						<fo:page-number-citation ref-id="Quick Reference Guide"/>
					</fo:basic-link>
				</fo:block>

				<fo:block font-size="12pt"
									font-family="serif"
									font-style="italic"
									line-height="13pt"
									margin-left="15pt"
									padding="0"
									text-align="justify"
									text-align-last="justify">
					<fo:basic-link internal-destination="Tag Hierarchy">
						<fo:inline font-family="serif" font-style="italic" text-decoration="underline">Tag Hierarchy</fo:inline>
						<fo:leader leader-pattern="dots"/>
						<fo:page-number-citation ref-id="Tag Hierarchy"/>
					</fo:basic-link>
				</fo:block>


			</fo:flow>
		</fo:page-sequence> 
		<!-- End of front page/table of contents -->

		<!--
		  Now go through each of the referenced tag library documents and generate 
		  the summary pages and the in-depth information
		  -->
		<xsl:for-each select="/tlddocs/tlddoc">

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This is the start of the overview pages for each of the tag 
	     libraries
	     
	     Note: This does not process any of the 'functions' of the tag 
	     libraries
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<fo:page-sequence master-reference="default">

			<!--
			  This is the static content for the footer of every page, which creates 
			  a link to the top of the table of contents for all of the tag 
			  libraries, a link to the table of contents for this tag library and
			  finally the page number that we are on. 
			  -->

			<xsl:call-template name="block-table-of-contents-all" />

		<fo:flow flow-name="xsl-region-body">

			<!-- Page heading with back link -->

			<xsl:call-template name="tag-page-heading"><xsl:with-param name="heading" select="taglib/short-name" /></xsl:call-template>

			<fo:table table-layout="fixed" width="100%" border="solid" margin-bottom="13pt" margin-top="30pt">
				<fo:table-header margin-left="0pt">
					<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" padding="3pt"><fo:block font-weight="bold">Tag Library Summary</fo:block></fo:table-cell>
				</fo:table-header>
				<fo:table-body>

					<xsl:call-template name="table-row-courier">
						<xsl:with-param name="title">Tag Library Version:</xsl:with-param>
						<xsl:with-param name="value" select="taglib/tlib-version" />
					</xsl:call-template>

					<xsl:call-template name="table-row-courier">
						<xsl:with-param name="title">Display Name:</xsl:with-param>
						<xsl:with-param name="value" select="taglib/display-name" />
					</xsl:call-template>

					<xsl:call-template name="table-row-courier">
						<xsl:with-param name="title">URI:</xsl:with-param>
						<xsl:with-param name="value" select="taglib/uri" />
					</xsl:call-template>

					<xsl:call-template name="table-row-courier">
						<xsl:with-param name="title">File Name:</xsl:with-param>
						<xsl:with-param name="value" select="@file" />
					</xsl:call-template>

					<xsl:if test="count(taglib/validator) != 0">
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt"
													font-family="Courier"
													line-height="15pt"
													margin-bottom="0pt"
													text-align="justify">
									<fo:inline font-weight="bold" font-family="sans-serif">Validator class:</fo:inline> 
									<xsl:value-of select="taglib/validator/validator-class" />
									<fo:inline margin-left="3pt" padding-left="3pt" font-family="sans-serif">    
										<xsl:value-of select="taglib/validator/description" />
									</fo:inline>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>

				</fo:table-body>
			</fo:table>
			
			<!-- Print out the description -->

			<xsl:for-each select="taglib/description/*">
				<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
			</xsl:for-each>

			<!-- list all functions -->

			<xsl:for-each select="taglib/function">
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
			
			<!--  list all of the sub sections -->
			<xsl:for-each select="taglib/tag">
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

				<!-- Create a link to each of the tags within the section -->
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

				<fo:block margin-top="20pt" />
				<xsl:call-template name="document-sub-heading"><xsl:with-param name="heading">Cheat Sheet</xsl:with-param></xsl:call-template>

					<xsl:variable name="id-cheat-sheet"><xsl:value-of select="taglib/short-name" /> Cheat Sheet</xsl:variable>
					<fo:block font-size="12pt"
										font-family="serif"
										font-style="italic"
										line-height="13pt"
										margin-left="15pt"
										padding="0"
										text-align="justify"
										text-align-last="justify">
						<fo:basic-link internal-destination="{$id-cheat-sheet}">
							<fo:inline text-decoration="underline">Cheat Sheet</fo:inline>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="{$id-cheat-sheet}"/>
						</fo:basic-link>
					</fo:block>

		</fo:flow>
		<!-- This is the end of the header page for a specific tag library -->
	</fo:page-sequence>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This is the start of the overview pages for each of the function 
	     libraries
	     
	     Note: This does not process any of the tag libraries
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<!-- Now for the functions -->
	<xsl:for-each select="taglib/function">
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="block-table-of-contents-all-current">
				<xsl:with-param name="short-name" select="../short-name" />
			</xsl:call-template>

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
								<fo:block font-size="10pt"
													font-family="Courier"
													line-height="15pt"
													margin-bottom="0pt">
									<fo:inline font-weight="bold" font-family="sans-serif">Function Signature:</fo:inline> <xsl:value-of select="function-signature" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				
				<xsl:for-each select="description/*">
					<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
				</xsl:for-each>
				
				<fo:block font-size="12pt"
									font-family="Courier"
									line-height="15pt"
									space-before="13pt"
									margin-left="15pt">
					<xsl:value-of select="example" />
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:for-each>
	
	<!-- And the actual tags -->
	
	<xsl:for-each select="taglib/tag">
		<fo:page-sequence master-reference="default">

			<xsl:call-template name="block-table-of-contents-all-current">
				<xsl:with-param name="short-name" select="../short-name" />
			</xsl:call-template>

			<fo:flow flow-name="xsl-region-body">

				<xsl:call-template name="page-heading">
					<xsl:with-param name="heading"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:with-param>
				</xsl:call-template>

				<xsl:variable name="tag-class"><xsl:value-of select="tag-class"/></xsl:variable>
				<xsl:variable name="id-tag-class"><xsl:value-of select="../short-name" />-<xsl:value-of select="tag-class"/></xsl:variable>

				<fo:table table-layout="fixed" width="100%" border="solid" margin-bottom="13pt">
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt"
										font-family="Courier"
										line-height="15pt"
										margin-bottom="0pt"
										text-align="justify"
										id="{$id-tag-class}">
									<fo:inline font-weight="bold" font-family="sans-serif">Tag Class:</fo:inline> <xsl:value-of select="tag-class" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell padding="3pt">
								<fo:block font-size="10pt"
													font-family="sans-serif"
													line-height="15pt"
													margin-bottom="0pt"
													text-align="justify">
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
						<fo:table-column column-width="25%" />
						<fo:table-column column-width="20%" />
						<fo:table-column column-width="20%" />
						<fo:table-column column-width="35%" />
						<fo:table-header margin-left="0pt">
							<fo:table-cell margin="0pt" border="solid" background-color="#CCCCFF" number-columns-spanned="4" padding="3pt"><fo:block font-weight="bold">Attribute Summary</fo:block></fo:table-cell>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-weight="bold">Name</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt"  border="solid" padding="3pt">
									<fo:block font-weight="bold">Required</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt"  border="solid" padding="3pt">
									<fo:block font-weight="bold">Expressions</fo:block>
								</fo:table-cell>
								<fo:table-cell margin="0pt"  border="solid" padding="3pt">
									<fo:block font-weight="bold">Type</fo:block>
								</fo:table-cell>
							</fo:table-row>
	
							<xsl:for-each select="attribute">
							<fo:table-row>
								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-family="Courier" font-size="11pt"><xsl:value-of select="name" /></fo:block>
								</fo:table-cell>

								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block><xsl:value-of select="required" /></fo:block>
								</fo:table-cell>

								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block><xsl:value-of select="rtexprvalue" /></fo:block>
								</fo:table-cell>

								<fo:table-cell margin="0pt" border="solid" padding="3pt">
									<fo:block font-family="Courier" font-size="11pt">
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
				  Variables
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

		<fo:page-sequence master-reference="two-columns">

			<xsl:call-template name="block-table-of-contents-all-current">
				<xsl:with-param name="short-name" select="taglib/short-name" />
			</xsl:call-template>

			<fo:flow flow-name="xsl-region-body">

				<!-- Create the cheat sheet -->
				<xsl:call-template name="block-cheat-sheet">
					<xsl:with-param name="heading"><xsl:value-of select="taglib/short-name" /> Cheat Sheet</xsl:with-param>
					<xsl:with-param name="tag-nodes" select="taglib" />
					<xsl:with-param name="function-nodes" select="taglib" />
				</xsl:call-template>
			</fo:flow>
		</fo:page-sequence>

		</xsl:for-each>	
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     This is the quick reference page for all of the tags within this
	     document, containing links to each of the functions.
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<fo:page-sequence master-reference="two-columns">

			<xsl:call-template name="block-table-of-contents-all" />

		<fo:flow flow-name="xsl-region-body">

			<!-- The heading for the quick reference guide -->
			<xsl:call-template name="reference-heading"><xsl:with-param name="heading">Quick Reference Guide</xsl:with-param></xsl:call-template>

			<!--
			  Now generate all of the tag libraries and their page references
			  -->
			<xsl:for-each select="/tlddocs/tlddoc/taglib/tag">

				<!-- sort by the tag name -->
				<xsl:sort select="./name" />

				<xsl:variable name="basic-link"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:variable>
				<fo:block keep-together="always">
				<fo:block text-align="justify"
							text-align-last="justify"
							font-family="serif" font-style="italic" font-weight="bold" >
					<fo:basic-link internal-destination="{$basic-link}">
						<xsl:value-of select="normalize-space(name)" /> (<xsl:value-of select="../short-name" />)
						<fo:leader leader-pattern="dots"/>
						<fo:page-number-citation ref-id="{$basic-link}"/>
					</fo:basic-link>
				</fo:block>
					<!-- now for the variables -->
					<xsl:for-each select="./attribute">
						<fo:block text-align="justify"
							text-align-last="justify"
							font-family="serif" font-style="italic"
							margin-left="12px">
							<fo:inline padding-right="7px"><xsl:value-of select="name" /></fo:inline>
							<xsl:choose>
								<xsl:when test="required = 'true'">
									<fo:inline vertical-align="super" font-size="8pt" padding-right="3px">(req)</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline vertical-align="super" font-size="8pt" padding-right="3px">(opt)</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="rtexprvalue = 'true'"><fo:inline vertical-align="super" font-size="8pt">(exp)</fo:inline></xsl:if>
						</fo:block>
					</xsl:for-each>
					<fo:block margin-bottom="5px" />
					</fo:block>

			</xsl:for-each>
		</fo:flow>
	</fo:page-sequence>

		<!-- This is the generated Hierarchy -->
		<fo:page-sequence master-reference="two-columns">

			<xsl:call-template name="block-table-of-contents-all" />

			<fo:flow flow-name="xsl-region-body">

				<!-- the document heading  -->
				<xsl:call-template name="reference-heading"><xsl:with-param name="heading">Tag Hierarchy</xsl:with-param></xsl:call-template>

				<xsl:for-each select="/tlddocs/tlddoc/taglib">
					<xsl:variable name="tag-hierarchy-link">tag-hierarchy-link-<xsl:value-of select="short-name" /></xsl:variable>

					<fo:block border-top-style="solid" 
								border-top-width="1px" 
								border-bottom-style="solid" 
								border-bottom-width="1px" 
								margin-bottom="12pt">
						<fo:block text-align="left"
									text-align-last="left"
									font-family="serif"
									font-style="italic"
									font-weight="bold"
									border-bottom-style="solid" 
									border-bottom-width="1px" 
									id="{$tag-hierarchy-link}"
									background-color="#CCCCCC"
									margin-bottom="12pt">
									<fo:inline padding-left="5pt"><xsl:value-of select="short-name" /> tag hierarchy</fo:inline>
						</fo:block>

					<xsl:choose>
						<xsl:when test="count(tag/description/requiredparent) = 0">
							<fo:block text-align="left"
										text-align-last="left"
										font-family="serif"
										font-style="italic"
										margin-bottom="12pt">
								<fo:inline padding-right="7px">No tag hierarchy available.</fo:inline>
							</fo:block>
						</xsl:when>
						<xsl:otherwise>
							<fo:block font-family="serif"
									font-style="italic"
									margin-bottom="12pt">
										<fo:inline font-family="serif" font-style="italic">Tags with hierarchy.</fo:inline>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:for-each select="tag">
						<fo:block keep-together="always">
						<xsl:if test="description/requiredparent != ''">
							<xsl:for-each select="description/requiredparent">

								<xsl:variable name="required-parent" select="." />
								<fo:block font-family="Courier"
										margin-left="12pt">
									&lt;<xsl:value-of select="../../../short-name" />:<xsl:value-of select="../../../tag/tag-class[. = $required-parent]/../name" />&gt;
								</fo:block>
	
								<xsl:choose>
									<xsl:when test="body-content = 'empty'">
										<fo:block font-family="Courier"
													margin-left="24pt"
													font-weight="bold">
											<fo:inline font-family="Courier">&lt;<xsl:value-of select="../../../short-name"/>:<xsl:value-of select="../../name"/> /&gt;</fo:inline>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<fo:block font-family="Courier"
													margin-left="24pt"
													font-weight="bold">
											<fo:inline font-family="Courier">&lt;<xsl:value-of select="../../../short-name"/>:<xsl:value-of select="../../name"/>&gt;</fo:inline>
										</fo:block>
										<fo:block font-family="Courier"
													margin-left="24pt"
													font-weight="bold">
												<fo:inline font-family="Courier"> ... </fo:inline>
										</fo:block>
										<fo:block font-family="Courier"
													margin-left="24pt"
													font-weight="bold">
												<fo:inline font-family="Courier">&lt;/<xsl:value-of select="../../../short-name"/>:<xsl:value-of select="../../name"/>&gt;</fo:inline>
										</fo:block>
									</xsl:otherwise>
								</xsl:choose>

								<fo:block font-family="Courier"
										margin-left="12pt"
										margin-bottom="12pt">
									&lt;/<xsl:value-of select="../../../short-name" />:<xsl:value-of select="../../../tag/tag-class[. = $required-parent]/../name" />&gt;
								</fo:block>

							</xsl:for-each>
						</xsl:if>
						</fo:block>
					</xsl:for-each>
						<xsl:if test="count(tag) != 0">
							<fo:block font-family="serif"
									font-style="italic"
									margin-bottom="12pt">
										<fo:inline font-family="serif" font-style="italic">Tags without hierarchy.</fo:inline>
							</fo:block>
						</xsl:if>

						<xsl:for-each select="tag">
						<fo:block keep-together="always">
							<xsl:if test="count(description/requiredparent) = 0">
								<fo:block font-family="Courier"
											margin-left="12pt">
									<fo:inline font-family="Courier">&lt;<xsl:value-of select="../short-name"/>:<xsl:value-of select="name"/> /&gt;</fo:inline>
								</fo:block>
							</xsl:if>
							</fo:block>
						</xsl:for-each>

						<fo:block font-family="serif"
								font-style="italic"
								margin-bottom="12pt">
						</fo:block>

						<fo:block margin-bottom="5px" />
						</fo:block>
				</xsl:for-each>

			</fo:flow>
		</fo:page-sequence> 

	</fo:root>
</xsl:template>

</xsl:stylesheet>
