<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     menu2electron-html.xslt
    # Purpose:	Generate an Electron html menu with JS that mirrors the batch menu.
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016-09-08
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" name="html5"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <!-- <xsl:param name="menufile"/> -->
      <!-- <xsl:variable name="projectpath" select="replace($menufile,'\\setup\\project.menu','')"/> -->
      <!-- <xsl:variable name="projectpathjs" select="replace($projectpath,'\\','\\\\')"/> -->
      <xsl:param name="vimodpath" select="'D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk'"/>
      <xsl:variable name="vimodpathuri" select="f:file2uri($vimodpath)"/>
      <xsl:variable name="vimodpathjs" select="'D:\\All-SIL-Publishing\\github-SILAsiaPub\\vimod-pub\\trunk'"/>
      <xsl:variable name="nolink" select="tokenize('logs xml',' ')"/>
      <!-- <xsl:variable name="part" select="tokenize($menufile,'\\|/')"/> -->
      <!-- <xsl:variable name="varparser" select="'^([^;]+);([^ ]+)[ \t]+([^ \t]+)[ \t]+(.+)'"/> -->
      <xsl:template match="/">
            <data-dummy/>
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="directory">
            <xsl:variable name="menufile" select="concat(@absolutePath,'\setup\project.menu')"/>
            <xsl:variable name="part" select="tokenize($menufile,'\\|/')"/>
            <xsl:variable name="projectpath" select="@absolutePath"/>
            <xsl:variable name="projectpathjs" select="replace($projectpath,'\\','\\\\')"/>
            <xsl:variable name="menufileuri" select="f:file2uri($menufile)"/>
            <xsl:variable name="relpath" select="substring-after(@absolutePath, 'trunk\')"/>
            <xsl:variable name="cookietrail" select="translate($relpath,'\','&#x21D2;')"/>
            <xsl:choose>
                  <xsl:when test="unparsed-text-available($menufileuri)">
                        <xsl:variable name="line" select="f:file2lines($menufile)"/>
                        <xsl:variable name="projectindex" select="f:file2uri(concat($vimodpath,'\tools\electron\',$relpath,'\index.html'))"/>
                        <!-- <xsl:if test="unparsed-text-available(f:file2uri($menufile))"> -->
                        <xsl:result-document href="{$projectindex}" format="html5">
                              <html>
                                    <xsl:call-template name="head"/>
                                    <body>
                                          <h1>
                                                <xsl:value-of select="substring-after($relpath,'data\')"/>
                                                <xsl:text> Project</xsl:text>
                                          </h1>
                                          <h3>
                                                <xsl:value-of select="$part[last()]"/>
                                          </h3>
                                          <ul class="table-view">
                                                <li class="table-view-cell">
                                                      <a href="../index.html">&#x21EA;</a>
                                                </li>
                                                <xsl:for-each select="$line">
                                                      <xsl:call-template name="parseline">
                                                            <xsl:with-param name="line" select="."/>
                                                            <xsl:with-param name="prepend" select="''"/>
                                                            <xsl:with-param name="projectpathjs" select="$projectpathjs"/>
                                                      </xsl:call-template>
                                                </xsl:for-each>
                                          </ul>
                                          <hr></hr>
                                          <button type="button" onclick="resetLog()" style="width:60%">Clear log</button>
                                          <br/>
                                          <ul id="log-container"></ul>
                                          <script>'use strict';
    function resetLog(){
        return document.getElementById("log-container").innerHTML = "";
    }
    function addLog(message,type){
        var el = document.getElementById("log-container");
        var newItem = document.createElement("li");       // Create a li node
        var textnode = document.createTextNode(message);  // Create a text node
        if(type == "error"){
            newItem.style.color = "red";
        }else if(type == "final"){
            newItem.style.color = "blue";
        }
        newItem.appendChild(textnode);                    // Append the text to li
        el.appendChild(newItem);
    }

</script>
                                    </body>
                              </html>
                        </xsl:result-document>
                        <!-- </xsl:if> -->
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:variable name="groupindex" select="f:file2uri(concat($vimodpath,'\tools\electron\',$relpath,'\index.html'))"/>
                        <xsl:result-document href="{$groupindex}" format="html5">
                              <html>
                                    <xsl:call-template name="head"/>
                                    <body>
                                          <h1>
                                                <xsl:if test="@name = 'data'">
                                                      <xsl:text>Home</xsl:text>
                                                </xsl:if>
                                                <xsl:value-of select="substring-after($relpath,'data\')"/>
                                                <xsl:text> Group</xsl:text>
                                          </h1>
                                          <ul class="table-view">
                                                <xsl:if test="@name ne 'data'">
                                                      <li class="table-view-cell">
                                                            <a href="../index.html">&#x21EA;</a>
                                                      </li>
                                                </xsl:if>
                                                <xsl:apply-templates select="directory" mode="button"/>
                                          </ul>
                                    </body>
                              </html>
                        </xsl:result-document>
                        <xsl:apply-templates select="directory"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="parseline">
            <xsl:param name="line"/>
            <xsl:param name="prepend"/>
            <xsl:param name="projectpathjs"/>
            <xsl:variable name="linepart" select="tokenize($line,';')"/>
            <xsl:variable name="cmdpart" select="tokenize($linepart[2],' +')"/>
            <xsl:variable name="comment" select="$linepart[1]"/>
            <xsl:variable name="command" select="$cmdpart[1]"/>
            <xsl:variable name="name" select="$cmdpart[2]"/>
            <xsl:variable name="value" select="$cmdpart[3]"/>
            <xsl:variable name="commandstring" select="substring-after($line,';')"/>
            <!-- <xsl:variable name="commonuri" select="f:file2uri(concat($cd,'\tasks\',$name))"/> -->
            <xsl:variable name="onevar">
                  <xsl:if test="matches($value,'^%[\w\d\-_]+%$') or matches($value,'^&#34;%[\w\d\-_]+%&#34;$')">
                        <xsl:text>onevar</xsl:text>
                  </xsl:if>
            </xsl:variable>
            <xsl:variable name="lineno" select="position()"/>
            <xsl:choose>
                  <xsl:when test="matches($line,'^#.*$')">
                        <!-- the above removes comment lines so lines that contain commented out things are not processed -->
                  </xsl:when>
                  <xsl:when test="matches($line,'^\s*$')">
                        <!-- the above removes comment lines so lines that contain commented out things are not processed -->
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:choose>
                              <xsl:when test="matches($command,'tasklist')">
                                    <button type="button" id="executeBat{$prepend}{position()}" style="width:60%">
                                          <xsl:value-of select="$comment"/>
                                    </button>
                                    <br/>
                                    <script>
    document.getElementById("executeBat<xsl:value-of select="$prepend"/><xsl:value-of select="position()"/>").addEventListener("click",function(e){
        var myBatFilePath = "<xsl:value-of select="$vimodpathjs"/>\\pub.cmd tasklist <xsl:value-of select="$projectpathjs"/><xsl:text> </xsl:text><xsl:value-of select="$name"/>";
        const spawn = require('child_process').spawn;
        const bat = spawn('cmd.exe', ['/c', myBatFilePath]);
        bat.stdout.on('data', (data) => {
            var str = String.fromCharCode.apply(null, data);
            addLog(data);
            console.info(str);
        });
        bat.stderr.on('data', (data) => {
            var str = String.fromCharCode.apply(null, data);
            addLog(data,"error");
            console.error(str);
        });
        bat.on('exit', (code) => {
            console.log(`Child exited with code ${code}`);
            var preText = `Child exited with code ${code} : `;
            switch(code){
                case 0:
                    addLog(preText+"All good","final");
                    break;
                case 1:
                    addLog(preText+"An error ocurred while running tasks","final");
                    break;
            }
        });
    },false);
</script>
                              </xsl:when>
                              <xsl:when test="matches($command,'commonmenu')">
                                    <xsl:variable name="commonmenu" select="f:file2lines(concat($vimodpath,'\menus\',$name))"/>
                                    <h4>
                                          <xsl:text>Common menu - </xsl:text>
                                          <xsl:value-of select="$name"/>
                                    </h4>
                                    <xsl:for-each select="$commonmenu">
                                          <xsl:call-template name="parseline">
                                                <xsl:with-param name="line" select="."/>
                                                <xsl:with-param name="prepend" select="concat($lineno,'c')"/>
                                          </xsl:call-template>
                                    </xsl:for-each>
                              </xsl:when>
                              <xsl:when test="matches($command,'menublank')">
                                    <hr></hr>
                              </xsl:when>
                              <xsl:otherwise>
                                    <p>
                                          <xsl:text>unknown item in menu file </xsl:text>
                                          <xsl:value-of select="$commandstring"/>
                                    </p>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="directory" mode="button">
            <xsl:choose>
                  <xsl:when test="@name = $nolink"/>
                  <xsl:otherwise>
                        <xsl:element name="li">
                              <xsl:attribute name="class">
                                    <xsl:text>table-view-cell</xsl:text>
                              </xsl:attribute>
                              <xsl:element name="a">
                                    <xsl:attribute name="href">
                                          <xsl:value-of select="concat(@name,'\index.html')"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                          <xsl:text>table-view-cell</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="@name"/>
                              </xsl:element>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="head">
            <head>
                  <meta charset="UTF-8"/>
                  <title>Vimod-Pub App</title>
                  <!-- <link rel="stylesheet" href="{$vimodpathuri}/tools/electron/css/ratchet.min.css"/> -->
                  <link rel="stylesheet" href="{$vimodpathuri}/tools/electron/css/electron.css"/>
            </head>
      </xsl:template>
</xsl:stylesheet>
