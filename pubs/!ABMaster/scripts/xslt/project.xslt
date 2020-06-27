<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:variable name="projectpath" select="'C:\BulletinBuilder\pubs\!ABMaster\issues\2020-07'"/>
   <xsl:variable name="cd" select="''"/>
   <xsl:variable name="true" select="tokenize('true yes on 1','\s+')"/>
   <xsl:variable name="comment1" select="'# project.tasks'"/>
   <xsl:variable name="comment2">define project name                               </xsl:variable>
   <xsl:param name="pcode" select="'AsiaBulletin'"/>
   <xsl:variable name="comment3">define list of headers to include in index/TOC    </xsl:variable>
   <xsl:param name="header_list" select="'h1'"/>
   <xsl:variable name="header" select="tokenize($header_list,'\s+')"/>
   <xsl:variable name="comment4">define list of all headers                        </xsl:variable>
   <xsl:param name="allheader_list" select="'h1 h2 h3 h4 h5 h6'"/>
   <xsl:variable name="allheader" select="tokenize($allheader_list,'\s+')"/>
   <xsl:variable name="comment7"
                 select="'make project.xslt from the above variables        ;projectxslt'"/>
</xsl:stylesheet>