<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	ab-add-id-to-elements.xslt
    # Purpose:		add id to elements defined by $header array.
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2015-09-14
    # Copyright:    	(c) 2015 SIL International
    # Licence:      	<LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions">
      <xsl:output method="text" encoding="utf-8" name="text"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:variable name="headersimageid" select="concat($projectpath,'/pdf/header-image-ids.txt')"/>
      <xsl:template match="/*">
            <xsl:result-document href="{f:file2uri($headersimageid)}" format="text">
                  <xsl:text>IDs of headers and Images&#13;&#10;--------------------------------------------------&#13;&#10;</xsl:text>
                  <xsl:for-each select="//*[local-name() = $allheader]|//img">
                        <xsl:choose>
                              <xsl:when test="local-name() = 'img'">
                                    <xsl:text>&#9;   </xsl:text>
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
            </xsl:result-document>
            <xsl:copy>
                  <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                  </xsl:attribute>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="*[local-name() = $allheader]">
            <xsl:element name="{local-name()}">
                  <xsl:apply-templates select="@*"/>
                  <xsl:attribute name="id">
                        <xsl:text>lk</xsl:text>
                        <xsl:value-of select="count(preceding::*[local-name() = $allheader]) +1"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="node()"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = 'img']">
            <xsl:element name="{local-name()}">
                  <xsl:apply-templates select="@*"/>
                  <xsl:attribute name="id">
                        <xsl:value-of select="replace(lower-case(@alt),' ','_')"/>
                  </xsl:attribute>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
