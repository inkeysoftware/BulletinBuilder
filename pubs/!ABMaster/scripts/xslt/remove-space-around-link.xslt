<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     remove-space-around-link.xslt
    # Purpose:	remove the space betweeen the [ and the link and the following ]
    # Part of:      Asia Bulletin
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017-02-08
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes" />
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="text()[matches(.,'\[ $') or matches(.,'^ \]')]">
            <xsl:choose>
                  <xsl:when test="matches(.,'\[ $')">
                        <xsl:value-of select="replace(.,' $','')"/>
                  </xsl:when>
                  <xsl:when test="matches(.,'^ \]')">
                        <xsl:value-of select="replace(.,'^ ','')"/>
                  </xsl:when>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="em">
            <xsl:choose>
                  <xsl:when test="child::a">
                        <xsl:apply-templates select="*" mode="em"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="."/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="a" mode="em">
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:element name="em">
                        <xsl:apply-templates select="node()"/>
                  </xsl:element>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
