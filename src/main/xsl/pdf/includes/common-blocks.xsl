<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     These are the common block routines for both the 'individual.xsl' 
	     and the 'index.xsl' which can be included by using
	     
	     <xsl:include href="classpath://!/common-block.xsl"/>
	     
	     Which uses a custom resolver to find the file within the classpath
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="block-cheat-sheet">
		<xsl:param name="heading" />
		<xsl:param name="tag-nodes" />
		<xsl:param name="function-nodes" />

		<!-- The heading for the cheat sheet -->
		<xsl:call-template name="reference-heading"><xsl:with-param name="heading" select="$heading" /></xsl:call-template>

		<!--
		  Now generate all of the tag libraries and their page references
		  -->
		<xsl:for-each select="$tag-nodes/tag">

			<!-- sort by the tag name -->
			<xsl:sort select="./name" />

			<xsl:variable name="basic-link"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:variable>
			<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(name)" /></xsl:variable>
			<fo:block text-align="justify"
						text-align-last="justify"
						font-family="serif" font-style="italic" font-weight="bold" 
						border="solid"
						padding-left="3pt"
						background-color="#CCCCFF"
						keep-with-next="always"
						id="{$cheat-sheet-basic-link}">
				<fo:basic-link internal-destination="{$basic-link}">
					<xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" />
				</fo:basic-link>
			</fo:block>

				<!-- now for the variables -->
			<fo:block border="solid" padding-left="3pt" keep-with-next="always">
				<fo:block font-family="serif" font-style="italic" padding="3px" keep-with-next="always">
					<xsl:value-of select="./description/p" />
				</fo:block>
				<xsl:for-each select="./attribute">
					<fo:block text-align="justify"
						text-align-last="justify"
						font-family="Courier"
						font-size="10pt"
						margin-left="8px"
						keep-with-next="always">
						<fo:inline padding-right="3px" font-weight="bold"><xsl:value-of select="name" /></fo:inline>
						<xsl:choose>
							<xsl:when test="required = 'true'">
								<fo:inline font-size="8pt" padding-right="3px">(required)</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:inline font-size="8pt" padding-right="3px">(optional)</fo:inline>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="rtexprvalue = 'true'"><fo:inline font-size="8pt">(expressions)</fo:inline></xsl:if>
					</fo:block>
				</xsl:for-each>
			</fo:block>
			<fo:block margin-bottom="12px" />

		</xsl:for-each>

		<!--
		  Now generate all of the functions and their page references
		  -->
		<xsl:for-each select="$function-nodes/function">

			<!-- sort by the tag name -->
			<xsl:sort select="./name" />

			<xsl:variable name="basic-link"><xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" /></xsl:variable>
			<xsl:variable name="cheat-sheet-basic-link">cheat-sheet-<xsl:value-of select="../short-name" />-<xsl:value-of select="normalize-space(name)" /></xsl:variable>

			<fo:block text-align="justify"
						text-align-last="justify"
						font-family="serif" 
						font-style="italic" 
						font-weight="bold" 
						border="solid"
						padding-left="3pt"
						background-color="#CCCCFF"
						keep-with-next="always"
						id="{$cheat-sheet-basic-link}">
				<fo:basic-link internal-destination="{$basic-link}">
					<xsl:value-of select="../short-name" />:<xsl:value-of select="normalize-space(name)" />
				</fo:basic-link>
			</fo:block>

				<!-- now for the the function signature -->

			<fo:block border="solid" padding-left="3pt" keep-with-next="always" keep-with-previous="always">
				<fo:block font-family="serif" font-style="italic" padding="3px" keep-with-next="always">
					<xsl:value-of select="./description/p" />
				</fo:block>
				<fo:block font-family="serif" font-weight="bold" padding="3px" keep-with-next="always">
					function signature
				</fo:block>
				<fo:block text-align="left" font-family="Courier" margin-left="8px" font-size="8pt" keep-with-next="always">
						<fo:inline padding-right="3px" keep-with-next="always"><xsl:value-of select="function-signature" /></fo:inline>
				</fo:block>
			</fo:block>
			<fo:block margin-bottom="12px" />

		</xsl:for-each>
	</xsl:template>


	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     Create a table of contents which includes links to:
	       The complete table of contents
	       The current tag library
	     
	     This template requires a parameter named 'short-name' which is used
	     for the display for the second link and also to create the link to
	     the individual table of contents.
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="block-table-of-contents-all-current">
		<xsl:param name="short-name" />

		<fo:static-content flow-name="xsl-region-after">
			<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt" text-align="right" border-top-style="solid" border-top-width="1pt" border-top-color="black">
				Table of Contents for: 
				<fo:basic-link internal-destination="front-page">
					<fo:inline text-decoration="underline">All Tag Libraries</fo:inline>
				</fo:basic-link>
		     |  
		    <xsl:variable name="link-to-page"><xsl:value-of select="$short-name" /></xsl:variable>
				<fo:basic-link internal-destination="{$link-to-page}">
					<fo:inline text-decoration="underline">Current Tag Library (<xsl:value-of select="$short-name" />)</fo:inline>
				</fo:basic-link>
			</fo:block>

			<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt" text-align="right">
		    Page <fo:page-number/> 
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     Create a table of contents which only includes a link to
	       The complete table of contents
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="block-table-of-contents-all">

			<fo:static-content flow-name="xsl-region-after">
				<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt" text-align="right" border-top-style="solid" border-top-width="1pt" border-top-color="black">
						Go to the: 
					<fo:basic-link internal-destination="front-page">
						<fo:inline text-decoration="underline">Table of Contents</fo:inline>
					</fo:basic-link>
				</fo:block>

				<fo:block font-size="10pt" font-family="Courier" line-height="15pt" margin-bottom="0pt" text-align="right">
						Page <fo:page-number/>
				</fo:block>
			</fo:static-content>
	</xsl:template>
</xsl:stylesheet>