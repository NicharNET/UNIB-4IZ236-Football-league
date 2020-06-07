
[![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/LICENSE)

<img align="left" height="113.176" width="126" top="50" src="http://i67.tinypic.com/2ly64qw.png" border="0">

# Football league

The webpage is a result of XSLT transformation to both HTML applied on an XML file with football league data. It has been developed as a semestral work as a part of the course 4IZ238 XML - Theory and Practice of Markup Languages. 

## [https://nikolas-charalambidis.github.io/football-league](https://nikolas-charalambidis.github.io/football-league)

This is also my very first XSLT transformation to both HTML and PDF from 2016 and published now. The webpage is hosted on GitHub Pages.
 
### Glossary

For those who haven't encountered with the following elementary terms yet:
 - `HTML`: [Hypertext Markap Language](https://en.wikipedia.org/wiki/HTML) is a standard markup language for creating web pages and web applications.
 - `XML`: [Extensible Markup Language](https://en.wikipedia.org/wiki/XML) is a markup language that defines a set of rules for encoding.
 - `XSD`: [XML Schema Definition](https://en.wikipedia.org/wiki/XML_Schema_(W3C)) is a specification how to formally describe the elements in an XML document.
 - `XSLT`: [Extensible Stylesheet Language Transformations](https://en.wikipedia.org/wiki/XSLT) is a language for transforming XML documents into other XML documents or other formats.

## How it works?

The entire semestral work could be divided into 4 separated processes.

### Input

The only input is an XML file. All the names and numbers are fictional or randomly generated in the past and exclusively created by myself only.

#### [index.xml](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/index.xml)

It's the input XML file with a root element `league` and two its descendants `detail` describing the league detail and `teams` which lists the detailed description of the team itself and all its players. A brief form appears below:

<details><summary>XML input example</summary>
	
```XML
<league>
    <detail>
        <!--/* League details */ -->
    </detail>
    <teams>
        <team>
            <description>
                <!--/* Team description */ -->
            </description>
            <players>
                <player>
                    <!--/* Player description */ -->
                </player>
                <!--/* Another player */ -->
        </team>
        <!--/* Another team */ -->
    </teams>
</league>
```
</details>

### Validation

The only input XML file validated against both an XSD file and a Schematron file.

#### [index.xsd](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/index.xsd)

This XSD file is a validation file for the input XML which validates its entire structure, the allowed count and order of the particular elements and the data type and format of their values. The following list provides a selection of the most important rules (not ordered by the importance):

 - All the names, shortcuts and contacts have to remain distinct
 - Each team is allowed to recruit at least `11` and up to `20` players and each player is between `15` and `99` years, both inclusive
 - Some of them are talented and their skill has to match the enumeration: `free kicks`, `quick`, `powerful`, `technical` or `head`
 - All the contacts, licenses and ID's must match the format usually defined with a regular expression (Regex)
 - A player can play on one of 4 available positions: `goalkeeper`, `defender`, `midfielder` or `forward`
 - Their overall skill is represented by a double number between `1` and `40`, both inclusive round on the halves using:
     ```XML
     <xsd:assertion test="$value = (for $d in 1 to 40 return 0.5 * $d)"/>
     ````   
     
I have used the Venetian Blind design.

#### [index.sch](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/index.sch)

The Schematron validation is a minor and a supplementary validation file using XPath. Its only job is to assure that each team will have only and exactly one player market as a captain. A part of the overall score was the usage of a Schematron file and the captain validation is a job which suits Schematron a lot:

<details><summary>Schematron (7 lines)</summary>

```XML
<pattern id="check">
    <rule context="//teams/team">
        <assert test="count(players/player[@status='captain']) = 1">
            <!-- Error message -->
        </assert>
    </rule>
</pattern>
```
</details>

### Transformation

The crucial part of the semestral work is the transformation into HTML and PDF output with mutually linked pages and aggregation functions. Each transformation has defined a set of functions applicable to the statistics of the players.

#### [index.xsl](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/index.xsl)

The first transformation produces the website consisted of mutually linked HTML pages deployed on the project's [GitHub Pages](https://nikolas-charalambidis.github.io/4IZ236) with the similar design but variable linked content.

All the transformations are applied to the root element `/` and define immediately self as a template rendered to `index.html` with  to generated partial templates under the `div` containers. The sample code is followed with a brief sample of the `en:teams` template responsible that each team have own page generated into `chunks` folder:

<details><summary>The root element template (31 lines)</summary>

```XML
<xsl:template match="/">
    <xsl:result-document href="index.html" format="html">
        <html>
            <head>
                <!-- /* SKIPPED: The header */ -->
            </head>
            <body>
                <div id="header-bar"/> <xsl:call-template name="header-bar"/>	
                <div id="header">       
                    <xsl:call-template name="header-index"/>         <!-- /* Menu template */-->
                </div>	
                <div id="league">
                    <xsl:apply-templates select="//en:detail"/>	     <!-- /* League summary template */-->
                </div>
                <div id="teams">
                    <xsl:apply-templates select="//en:teams"/>       <!-- /* Teams table template */-->
                </div>
                <div id="footer">
                    <xsl:call-template name="footer"/>               <!-- /* Footer template */-->
                </div>
            </body>
        </html>
    </xsl:result-document>
    
    <xsl:result-document href="best-players.html">                   <!-- /* Best players page render */-->
        <xsl:call-template name="best-players"/>
    </xsl:result-document>
    <xsl:result-document href="top-11.html">	                     <!-- /* Top 11 page render */-->
        <xsl:call-template name="top-11"/>
    </xsl:result-document>
</xsl:template>
```
</details>

<details><summary>The teams template (46 lines)</summary>

```XML
<xsl:template match="en:teams">
    <h2>Teams</h2>
    <table id="teams">
        <tr id="teams-label">
            <!-- /* SKIPPED: Table header labels */-->
        </tr>
        <xsl:for-each select="en:team">
    
            <!-- /* Sorted table of teams with links to the newly generated pages below */-->
            <xsl:sort select="@id"/>
                <tr id="teams">
                    <td><a href="chunks/{translate(en:description/en:name, $uppercase, $lowercase)}.html">
	                <xsl:value-of select="@id"/>
	            </a></td>
                    <td><xsl:value-of select="en:description/en:short"/></td>
                    <td><xsl:value-of select="en:description/en:name"/></td>
                    <td><xsl:value-of select="en:description/en:trainer/en:name"/></td>
                    <td><xsl:value-of select="en:calculatePower(en:players)"/></td>
                </tr>
     
            <!-- /* Generated page for each team */-->
            <xsl:result-document 
		    href="chunks/{translate(en:description/en:name, $uppercase, $lowercase)}.html" 
		    format="html">
                <html>
                    <head>
                        <title><xsl:value-of select="en:description/en:name"/></title>
                        <link rel="stylesheet" type="text/css" href="../index.css"/>
                    </head>
                    <body>
                        <!-- /* SKIPPED: Header and  watermark */-->	
                        <div id="league">
	                    <!-- /* Generated team description using another template */-->
                            <xsl:apply-templates select="en:description"/>    
                        </div>
                        <div id="teams">
	                    <!-- /* Generated list of players using another template */-->
                            <xsl:apply-templates select="en:players"/>        
                        </div>
                        <div id="footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </table>
</xsl:template>
```
</details>

#### [index-fo.xsl](https://github.com/Nikolas-Charalambidis/4IZ236/blob/master/index-fo.xsl)

On the similar principle works the transformation to PDF with a watermark. In the beginning, there is generated a table of contents with links to particular pages. Each team is rendered to the separated page. Last few pages have generated tables with the best players.

This transformation is three times more verbose than the previous one because of the design redefinition since CSS can not be used to this kind of transformation. However, unlike the used elemenets, the principle is pretty identical. A really shortened example of a block summary of the best goalkeepers follows:

<details><summary>The best goalkeepers template (49 lines)</summary>
	
```XML
<xsl:template name="bestPlayers">
    <fo:block id="bestPlayers" break-before="page"></fo:block>
        <xsl:call-template name="watermark"/>
        <fo:block font-size="9mm" text-align="center" padding-top="5mm">
            <xsl:text>Best players</xsl:text>
        </fo:block>
	
	<!-- /* Block for the best goalkeepers */-->
        <fo:block padding-before="1cm" width="75%">
            <fo:block margin-left="2cm">
                <fo:block font-size="6mm" padding-after="5mm">
	            <xsl:text>Best goalkeepers</xsl:text>
	        </fo:block>		
                <fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
                    <fo:table-column width="20%"/>
                    <!-- /* SKIPPED: 4 identical lines */-->
                    <fo:table-column width="20%"/>
	
	            <!-- /* Table header definition */-->
                    <fo:table-header>
                        <fo:table-row font-size="3mm" height="8mm">
                            <fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
                            <!-- /* SKIPPED: Age, Nationality and Skill */-->
                            <fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block></fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
	
	            <!-- /* Table body definition */-->
                    <fo:table-body padding-top="5mm">		
                        <xsl:for-each select=
				 "en:league/en:teams/en:team/en:players/en:player[@position='goalkeeper']">
                            <xsl:sort select="en:skill" data-type="number" order="descending"/>
                            <xsl:if test="position() &lt;= 6"> 
	                        <!-- /* Call of the template rendering the player characteristics */-->
                                <xsl:call-template name="six-characteristics"> 
                                    <xsl:with-param name="node" select="."/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:table-body>
                </fo:table>			
            </fo:block>
        </fo:block>

        <!-- /* SKIPPED: 3 blocks for the defenders, midfielders and forwards */-->
	
    </fo:block>
</xsl:template>
```
</details>

### Ouptut

This section offers an overall view to the generated content structure.

#### HTML

 - [index.html](https://nikolas-charalambidis.github.io/4IZ236/index.html)
   - [chunks/sanha.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/sanha.html)
   - [chunks/xavao.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/xavao.html)
   - [chunks/quernera.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/quernera.html)
   - [chunks/presto%20pallares.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/presto%20pallares.html)
   - [chunks/espartinas.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/espartinas.html)
   - [chunks/sheinis.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/sheinis.html)
   - [chunks/loueiro.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/loueiro.html)
   - [chunks/pazos.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/pazos.html)
   - [chunks/palmeires.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/palmeires.html)
   - [chunks/zingo.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/zingo.html)
   - [chunks/hyuni.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/hyuni.html)
   - [chunks/pulpite.html](https://nikolas-charalambidis.github.io/4IZ236/chunks/pulpite.html)
 - [best-players.html](https://nikolas-charalambidis.github.io/4IZ236/best-players.html)
 - [top-11.html](https://nikolas-charalambidis.github.io/4IZ236/top-11.html)

#### PDF

 - [index.pdf](https://github.com/nikolas-charalambidis/4IZ236/blob/master/index.pdf)
 
    The GitHub PDF viewer doesn't suppor the links to the pages. There is need to download the file for the full functionality.
 
## Quality check
I have integrated [Codebeat](https://codebeat.co) and [Codacy](https://www.codacy.com) cloud static analysis services to check the overall code quality out of curiosity. 

## Licence

MIT License

Copyright (c) 2018 Nikolas Charalambidis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
