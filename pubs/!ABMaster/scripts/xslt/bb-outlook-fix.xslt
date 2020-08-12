<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     ab-outlook-fix.xslt
    # Purpose:	Ad some mso wrappings around float right and left elements.
    # Part of:      AsiaBulletin build process
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017-02-07
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="*[@class = 'float-right']">
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:comment select="'[if mso]&gt;&lt;table border=&#34;0&#34;cellpadding=&#34;0&#34; cellspacing=&#34;0&#34; align=&#34;right&#34;&gt;&lt;tr&gt;&lt;td style=&#34;padding:0 0px 0px 20px;&#34;&gt;&lt;![endif]'"/>
                  <xsl:apply-templates select="*"/>
                  <xsl:comment select="'[if mso]&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;![endif]'"/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="*[@class = 'float-left']">
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:comment select="'[if mso]&gt;&lt;table border=&#34;0&#34;cellpadding=&#34;0&#34; cellspacing=&#34;0&#34; align=&#34;left&#34;&gt;&lt;tr&gt;&lt;td style=&#34;padding:0 20px 0px 0px;&#34;&gt;&lt;![endif]'"/>
                  <xsl:apply-templates select="*"/>
                  <xsl:comment select="'[if mso]&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;![endif]'"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
