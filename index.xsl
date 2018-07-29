<?xml version="1.0" encoding="UTF-8"?>
<!-- http://viximo.com/ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:en="https://nichar.com"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ'" />
	
	<xsl:function name="en:firstUpper">
		<xsl:param name="str"/>
		<xsl:value-of select="concat(upper-case(substring($str,1,1)),substring($str, 2),' '[not(last())])"/>
	</xsl:function>
	
	<xsl:function name="en:calculateAttack">
		<xsl:param name="players"/>
		<xsl:value-of select="format-number((10*sum($players/en:player[@position = 'forward']/en:skill)+5*sum($players/en:player[@position = 'midfielder']/en:skill)) div 50,'#.##')"/>
	</xsl:function>
	
	<xsl:function name="en:calculateDefence">
		<xsl:param name="players"/>
		<xsl:value-of select="format-number((15*sum($players/en:player[@position = 'goalkeeper']/en:skill)+10*sum($players/en:player[@position = 'defender']/en:skill)+5*sum($players/en:player[@position = 'midfielder']/en:skill)) div 50,'#.##')"/>
	</xsl:function>
	
	<xsl:function name="en:calculatePower">
		<xsl:param name="players"/>
		<xsl:value-of select="format-number(avg((en:calculateDefence($players),en:calculateAttack($players))),'#.##')"/>
	</xsl:function>
	
	<xsl:output name="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<xsl:result-document href="index.html" format="html">
			<!--<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>-->
			<html>
				<head>
					<title>League <xsl:value-of select="en:league/en:detail/en:name"/></title>
					<link rel="stylesheet" type="text/css" href="index.css"/>
				</head>
				<body>
					<img src="img/ball.png" alt="Ball"/>
					<div id="header-bar"/>
						<xsl:call-template name="header-bar"/>	
					<div id="header">
						<xsl:call-template name="header-index"/>	
					</div>	
					<div id="league">
						<xsl:apply-templates select="//en:detail"/>	
					</div>
					<div id="teams">
						<xsl:apply-templates select="//en:teams"/>
					</div>
					<div id="footer">
						<xsl:call-template name="footer"/>
					</div>
				</body>
			</html>
		</xsl:result-document>
		<xsl:result-document href="best-players.html">
			<xsl:call-template name="best-players"/>
		</xsl:result-document>
		<xsl:result-document href="top-11.html">		
			<xsl:call-template name="top-11"/>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template name="header-bar">
		<a href="http://www.kosek.cz/vyuka/4iz238/?url=/vyuka/izi238/">
			<div id="circle">
				<p id="circle">4IZ238</p>
			</div>
		</a>
	</xsl:template>
	
	<xsl:template name="header-index">
		<table id="header">
			<tr id="header-menu">
				<td id="header-league" rowspan="2"><h1 id="header">LEAGUE 
					<xsl:value-of select="translate(en:league/en:detail/en:name, $lowercase, $uppercase)"/>
				</h1></td>
				<td id="header-menu">check out</td>
				<td id="header-menu">the best</td>
				<td id="header-menu">take a look at</td>
			</tr>
			<tr id="header-choice">
				<td><a id="_01" href="index.html">TEAMS</a></td>
				<td><a id="_02" href="best-players.html">PLAYERS</a></td>
				<td><a id="_03" href="top-11.html">TOP 11</a></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template name="header-team">
		<table id="header">
			<tr id="header-menu">
				<td id="header-league" rowspan="2"><h1 id="header">
					<xsl:value-of select="translate(en:description/en:name, $lowercase, $uppercase)"/>
				</h1></td>
				<td id="header-menu">check out</td>
				<td id="header-menu">the best</td>
				<td id="header-menu">take a look at</td>
			</tr>
			<tr id="header-choice">
				<td><a id="_01" href="../index.html">TEAMS</a></td>
				<td><a id="_02" href="../best-players.html">PLAYERS</a></td>
				<td><a id="_03" href="../top-11.html">TOP 11</a></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="en:detail">
		<table id="league">
			<tr>
				<td id="league-right">SEASON:</td>
				<td id="league-left"><xsl:value-of select="en:season"/></td>
				<td id="league-right">DIRECTOR:</td> 
				<td id="league-left"><xsl:value-of select="en:director/en:name"/><xsl:text> (</xsl:text><xsl:value-of select="en:director/en:nationality"/>)</td>
			</tr>
			<tr>
				<td id="league-right">START:</td> 
				<td id="league-left"><xsl:value-of select="en:start"/></td>
				<td id="league-right">PHONE:</td> 
				<td id="league-left"><xsl:value-of select="en:director/en:contact/en:phone"/></td>
			</tr>
			<tr>
				<td id="league-right">END:</td> 
				<td id="league-left"><xsl:value-of select="en:end"/></td>
				<td id="league-right">E-MAIL:</td> 
				<td id="league-left"><xsl:value-of select="en:director/en:contact/en:email"/></td>
			</tr>
		</table>	
	</xsl:template>
	
	<xsl:template match="en:description">
		<table id="league">
			<tr>
				<td id="league-right">TRAINER:</td>
				<td id="league-left"><xsl:value-of select="en:trainer/en:name"/><xsl:text> (</xsl:text><xsl:value-of select="en:trainer/en:nationality"/><xsl:text>)</xsl:text></td>
				<td id="league-right">LICENCE:</td> 
				<td id="league-left"><xsl:value-of select="en:trainer/en:licence"/></td>
			</tr>
			<tr>
				<td id="league-right">SHORT:</td> 
				<td id="league-left"><xsl:value-of select="en:short"/></td>
				<td id="league-right">PHONE:</td> 
				<td id="league-left"><xsl:value-of select="en:trainer/en:contact/en:phone"/></td>
			</tr>
			<tr>
				<td id="league-right">STADIUM:</td> 
				<td id="league-left"><xsl:value-of select="en:stadium"/></td>
				<td id="league-right">E-MAIL:</td> 
				<td id="league-left"><xsl:value-of select="en:trainer/en:contact/en:email"/></td>
			</tr>
		</table>	
	</xsl:template>

	<xsl:template match="en:teams">
		<h2>Teams</h2>
		<table id="teams">
			<tr id="teams-label">
				<td>ID</td>
				<td>TEAM</td>
				<td>NAME</td>
				<td>TRAINER</td>
				<td>TEAM POWER</td>
			</tr>
			<xsl:for-each select="en:team">
				<xsl:sort select="@id"/>
				<tr id="teams">
					<td><a href="chunks/{translate(en:description/en:name, $uppercase, $lowercase)}.html"><xsl:value-of select="@id"/></a></td>
					<td><xsl:value-of select="en:description/en:short"/></td>
					<td><xsl:value-of select="en:description/en:name"/></td>
					<td><xsl:value-of select="en:description/en:trainer/en:name"/></td>
					<td><xsl:value-of select="en:calculatePower(en:players)"/></td>
				</tr>
				<xsl:result-document href="chunks/{translate(en:description/en:name, $uppercase, $lowercase)}.html" format="html">
					<html>
						<head>
							<title><xsl:value-of select="en:description/en:name"/></title>
							<link rel="stylesheet" type="text/css" href="../index.css"/>
						</head>
						<body>
							<img src="../img/ball.png" alt="Ball"/>
							<div id="header-bar"/>
								<xsl:call-template name="header-bar"/>	
							<div id="header">
								<xsl:call-template name="header-team"/>	
							</div>	
							<div id="league">
								<xsl:apply-templates select="en:description"/>
							</div>
							<div id="teams">
								<xsl:apply-templates select="en:players"/>
							</div>
							<div id="footer"/>
						</body>
					</html>
				</xsl:result-document>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="en:players">
		<table id="teams">
			<tr id="teams-label">
				<td>POSITION</td>
				<td>NAME</td>
				<td>AGE</td>
				<td>NATIONALITY</td>
				<td>SKILL</td>
				<td>SPECIAL</td>
			</tr>
			<xsl:for-each select="en:player">
				<tr id="teams">
					<td>
						<xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"/>
						<xsl:if test="@status='captain'"><xsl:text> (C)</xsl:text></xsl:if>
					</td>
					<td><xsl:value-of select="en:name"/></td>
					<td><xsl:value-of select="en:age"/></td>
					<td><xsl:value-of select="en:nationality"/></td>
					<td><xsl:value-of select="en:skill"/></td>
					<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template name="best-players-table">
		<h2>Best players</h2>
		<table id="teams">
			<tr id="teams-label">
				<td>POSITION</td>
				<td>NAME</td>
				<td>AGE</td>
				<td>NATIONALITY</td>
				<td>SKILL</td>
				<td>TEAM</td>
				<td>SPECIAL</td>
			</tr>
			<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player">
				<xsl:sort select="en:skill" data-type="number" order="descending"/>
				<xsl:if test="position() &lt;= 11"> 
					<tr id="teams">
						<td><xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of></td>
						<td><xsl:value-of select="en:name"/></td>
						<td><xsl:value-of select="en:age"/></td>
						<td><xsl:value-of select="en:nationality"/></td>
						<td><xsl:value-of select="en:skill"/></td>
						<td><xsl:value-of select="../../en:description/en:short"></xsl:value-of></td>
						<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template name="top-11-table">
		<h2>Top 11</h2>
		<table id="teams">
			<tr id="teams-label">
				<td>POSITION</td>
				<td>NAME</td>
				<td>AGE</td>
				<td>NATIONALITY</td>
				<td>SKILL</td>
				<td>TEAM</td>
				<td>SPECIAL</td>
			</tr>
			<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='goalkeeper']
				[en:age = min(//en:teams/en:team/en:players/en:player[@position='goalkeeper']/en:age)]
				[en:skill = max(//en:teams/en:team/en:players/en:player[@position='goalkeeper']/en:skill)]
				">
				<tr id="teams">
					<td><xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of></td>
					<td><xsl:value-of select="en:name"/></td>
					<td><xsl:value-of select="en:age"/></td>
					<td><xsl:value-of select="en:nationality"/></td>
					<td><xsl:value-of select="en:skill"/></td>
					<td><xsl:value-of select="../../en:description/en:short"></xsl:value-of></td>
					<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='defender']">
				<xsl:sort select="en:skill" data-type="number" order="descending"/>
				<xsl:sort select="en:age" data-type="number" order="ascending"/>
				<xsl:if test="position() &lt;= 4"> 
					<tr id="teams">
						<td><xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of></td>
						<td><xsl:value-of select="en:name"/></td>
						<td><xsl:value-of select="en:age"/></td>
						<td><xsl:value-of select="en:nationality"/></td>
						<td><xsl:value-of select="en:skill"/></td>
						<td><xsl:value-of select="../../en:description/en:short"></xsl:value-of></td>
						<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='midfielder']">
				<xsl:sort select="en:skill" data-type="number" order="descending"/>
				<xsl:sort select="en:age" data-type="number" order="ascending"/>
				<xsl:if test="position() &lt;= 4"> 
					<tr id="teams">
						<td><xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of></td>
						<td><xsl:value-of select="en:name"/></td>
						<td><xsl:value-of select="en:age"/></td>
						<td><xsl:value-of select="en:nationality"/></td>
						<td><xsl:value-of select="en:skill"/></td>
						<td><xsl:value-of select="../../en:description/en:short"></xsl:value-of></td>
						<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='forward']">
				<xsl:sort select="en:skill" data-type="number" order="descending"/>
				<xsl:sort select="en:age" data-type="number" order="ascending"/>
				<xsl:if test="position() &lt;= 2"> 
					<tr id="teams">
						<td><xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of></td>
						<td><xsl:value-of select="en:name"/></td>
						<td><xsl:value-of select="en:age"/></td>
						<td><xsl:value-of select="en:nationality"/></td>
						<td><xsl:value-of select="en:skill"/></td>
						<td><xsl:value-of select="../../en:description/en:short"></xsl:value-of></td>
						<td><xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template name="best-players">
		<html>
			<head>
				<title>League <xsl:value-of select="en:league/en:detail/en:name"/></title>
				<link rel="stylesheet" type="text/css" href="index.css"/>
			</head>
			<body>
				<img src="img/ball.png" alt="Ball"/>
				<div id="header-bar">
					<xsl:call-template name="header-bar"/>
				</div>
				<div id="header">
					<xsl:call-template name="header-index"/>
				</div>			
				<div id="league">
					<xsl:apply-templates select="//en:detail"/>	
				</div>
				<div id="teams">
					<xsl:call-template name="best-players-table"/>
				</div>
				<div id="footer">
					<xsl:call-template name="footer"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="top-11">
		<html>
			<head>
				<title>League <xsl:value-of select="en:league/en:detail/en:name"/></title>
				<link rel="stylesheet" type="text/css" href="index.css"/>
			</head>
			<body>
				<img src="img/ball.png" alt="Ball"/>
				<div id="header-bar"/>
					<xsl:call-template name="header-bar"/>
				<div id="header">
					<xsl:call-template name="header-index"/>
				</div>			
				<div id="league">
					<xsl:apply-templates select="//en:detail"/>	
				</div>
				<div id="teams">
					<xsl:call-template name="top-11-table"/>
				</div>
				<div id="footer"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="footer">
		<h4 id="footer"><xsl:text>Created by Nikolas Charalambidis at 2016</xsl:text></h4>
	</xsl:template>

</xsl:stylesheet>