<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         ab-toc.xslt
    # Purpose:		create a toc from a partial html
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2015- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    # 
    # Create TOC with links to AB articles on Gateway.
    # In the project folder, adjust header_list value in setup\project.tasks to include h1 and h2, or h1 only.
    #
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="project.xslt"/>
      <xsl:template match="/*">
            <ul>
                  <xsl:for-each select="//*[local-name() = $header]">
                        <!-- uncomment this tag for one-heading-per-line TOC: <div class="toc-{local-name()}">  -->
			<a href="https://gateway.sil.org/display/AB/{text()[1]}"><xsl:value-of select="text()[1]"/></a> • 
		    <!-- uncomment this tag for one-heading per-line TOC: </div>  -->
                  </xsl:for-each>
            </ul>
      </xsl:template>
</xsl:stylesheet>
