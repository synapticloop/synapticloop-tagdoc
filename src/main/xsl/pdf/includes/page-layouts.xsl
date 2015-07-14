<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     These are the page layouts routines for both the 'individual.xsl' 
	     and the 'index.xsl' which can be included by using
	     
	     <xsl:include href="classpath://!/page-layouts.xsl"/>
	     
	     Which uses a custom resolver to find the file within the classpath
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	<xsl:template name="define-master-sets">
		<fo:layout-master-set>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     Define the page layout for the most of document
	  
	     In this case it is called 'default' with the page width and height 
	     set to auto - which is picked up from the FOP configuration file
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<fo:simple-page-master master-name="default"
					page-height="auto"
					page-width="auto"
					margin-top="1.5cm"
					margin-bottom="0.5cm"
					margin-left="2.0cm"
					margin-right="1.5cm">
				<fo:region-body margin-top="0cm" margin-bottom="1.7cm"/>
				<fo:region-before extent="0cm"/>
				<fo:region-after extent="1.7cm"/>
				<fo:region-start />
			</fo:simple-page-master>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	     
	     Define the page layout for the quick index at the end document
	  
	     In this case it is called 'default' with the page width and height 
	     set to auto - which is picked up from the FOP configuration file
	     
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<fo:simple-page-master master-name="two-columns"
						page-height="auto"
						page-width="auto"
						margin-top="1.5cm"
						margin-bottom="0.5cm"
						margin-left="2.0cm"
						margin-right="1.5cm">
				<fo:region-body margin-top="0cm" margin-bottom="1.7cm" column-count="2"/>
				<fo:region-before extent="0cm"/>
				<fo:region-after extent="1.7cm"/>
				<fo:region-start />
			</fo:simple-page-master>
		</fo:layout-master-set>
		<!-- end: defines page layout -->
	</xsl:template>
</xsl:stylesheet>