<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:variable name="projectpath"
                 select="'C:\git\BulletinBuilder\pubs\!PDMaster\issues\2020-09'"/>
   <xsl:variable name="cd" select="''"/>
   <xsl:variable name="true" select="tokenize('true yes on 1','\s+')"/>
   <xsl:variable name="comment1" select="'# project.tasks'"/>
   <xsl:variable name="comment2">set the URL of the wiki space                     </xsl:variable>
   <xsl:param name="wikiurl" select="'https://gateway.sil.org/display/AB'"/>
   <xsl:variable name="comment3">define list of headers to include in index/TOC    </xsl:variable>
   <xsl:param name="header_list" select="'h1'"/>
   <xsl:variable name="header" select="tokenize($header_list,'\s+')"/>
   <xsl:variable name="comment4">define list of all headers                        </xsl:variable>
   <xsl:param name="allheader_list" select="'h1 h2 h3 h4 h5 h6'"/>
   <xsl:variable name="allheader" select="tokenize($allheader_list,'\s+')"/>
   <xsl:variable name="comment5"
                 select="'make project.xslt from the above variables        ;projectxslt'"/>
</xsl:stylesheet>