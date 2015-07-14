<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />

	<xsl:include href="classpath://!/html/includes/common.xsl"/>

	<xsl:template match="/">
	<xsl:variable name="indexfile" select="document('file://index.xml')" />
<html>
<head>
	<xsl:choose>
		<xsl:when test="count(/tag/name) = 1">
			<title>Documentation for '<xsl:value-of select="/tag/name" />' Tag</title>
		</xsl:when>
		<xsl:otherwise>
			<title>Documentation for '<xsl:value-of select="/function/name" />' Function</title>
		</xsl:otherwise>
	</xsl:choose>
<!-- 
	<xsl:call-template name="generate-includes" />
 -->
 </head>
<body>
<!-- 
	<xsl:call-template name="generate-header-links" />
 -->
	<h1></h1>
	<p>
		<xsl:copy-of select="$indexfile" />
	</p>
	<xsl:for-each select="/tag/description/*">
		<xsl:call-template name="parse-description"><xsl:with-param name="description" select="." /></xsl:call-template>
	</xsl:for-each>
</body>
</html>
	</xsl:template>
</xsl:stylesheet>