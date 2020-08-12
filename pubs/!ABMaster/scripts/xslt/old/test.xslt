<?xml version="1.0" encoding="utf-8"?> <!--
    #############################################################
    # Name:         .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2015- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="utf-8" />
     <xsl:include href="project.xslt"/>
 <xsl:template match="/">
                  <xsl:for-each select="//*[local-name() = $allheader]|//img">
                        <xsl:choose>
                              <xsl:when test="local-name() = 'img'">
                                    <xsl:text>  </xsl:text>
                                    <xsl:value-of select="replace(lower-case(@alt),' ','_')"/>
                                    <xsl:text>&#13;&#10;</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>lk</xsl:text>
                                    <xsl:value-of select="count(preceding::*[local-name() = $allheader]) +1"/>
<xsl:text>&#9;</xsl:text>
<xsl:value-of select="."/>
                                    <xsl:text>&#13;&#10;</xsl:text>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:for-each>
 </xsl:template>
</xsl:stylesheet>