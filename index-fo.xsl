<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:en="https://nichar.com"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
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
	
	<xsl:function name="en:getFormation">
		<xsl:param name="players"/>
		<xsl:variable name="def" select="count($players/en:player[@position='defender'])"/>
		<xsl:variable name="mid" select="count($players/en:player[@position='midfielder'])"/>
		<xsl:variable name="for" select="count($players/en:player[@position='forward'])"/>
		<xsl:value-of select="concat($def,'-',$mid,'-',$for)"/>
	</xsl:function>
	
	<xsl:template match="/">	
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master master-name="master" margin-top="5mm" margin-bottom="18mm">
					<fo:region-body margin-left="30px" margin-bottom="2.2cm" margin-right="30px" margin-top="2.2cm"/>
					<fo:region-before extent="1cm"/>
					<fo:region-after extent="1cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
			<fo:page-sequence master-reference="master">
				
				<fo:static-content flow-name="xsl-region-before" 
					color="grey"  
					font-size="3mm">
					<fo:block text-align="right"
						margin-top="1cm" 
						margin-right="1cm">
						<xsl:text>Nikolas Charalambidis, chan01@vse.cz</xsl:text>
					</fo:block>
				</fo:static-content>
				
				<fo:static-content flow-name="xsl-region-after" 
					color="black" 
					font-size="3mm">
					<fo:block text-align="center">
						<fo:page-number/>
					</fo:block>
				</fo:static-content>
				
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block id="odkaz"
						font-size="200%"
						text-align="center">
						<xsl:text>League </xsl:text><xsl:value-of select="en:league/en:detail/en:name"/>
					</fo:block>
					
					<xsl:call-template name="watermark"/>
					
					<fo:block start-indent="1cm" end-indent="1cm">

						<fo:block>
							<xsl:call-template name="league-info">
								<xsl:with-param name="node" select="en:league"/>
							</xsl:call-template>
						</fo:block>
						
						<fo:block text-align="center" 
							font-size="150%" 
							padding-before="1cm" 
							padding-after="1cm"
							text-align-last="justify">
							
							<fo:basic-link internal-destination="bestPlayers">
								<xsl:text>Best players</xsl:text>
							</fo:basic-link>
							<fo:leader leader-pattern="space" />
							<fo:basic-link internal-destination="top11">
								<xsl:text>Top 11</xsl:text>
							</fo:basic-link>
						</fo:block>

						<fo:block text-align="center" 
							font-size="150%" 
							padding-before="1cm" 
							padding-after="1cm">
							<xsl:variable name="teams" select="name(en:league/en:teams)" />
							<xsl:value-of select ="en:firstUpper($teams)"/>
						</fo:block>
						
						<xsl:for-each select="en:league/en:teams/en:team">							
							<fo:block padding-after="3mm" text-align-last="justify">
								<fo:basic-link internal-destination="{generate-id(.)}" 
									color="black">
									<xsl:value-of select="en:description/en:name"/><xsl:text> </xsl:text>
								</fo:basic-link>
								<fo:leader leader-pattern="dots"/>
								<fo:basic-link internal-destination="{generate-id(.)}" color="black">
									<fo:page-number-citation ref-id="{generate-id(.)}"/>
								</fo:basic-link>
							</fo:block>
						</xsl:for-each>
						
					</fo:block>
					
					<xsl:for-each select="en:league/en:teams/en:team">
						<xsl:call-template name="league">
							 <xsl:with-param name="node" select="current()"/>
						</xsl:call-template>
					</xsl:for-each>				
					
					<xsl:call-template name="bestPlayers"/>
					<xsl:call-template name="top11"/>
					
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
	<xsl:template name="league">
		<xsl:param name="node"/>
			<fo:block id="{generate-id(.)}" break-before="page"></fo:block>
		
			<xsl:call-template name="watermark"/>
		
			<fo:block font-size="9mm" text-align="center" padding-top="5mm">
				<xsl:value-of select="$node/en:description/en:name"/><xsl:text> </xsl:text>
			</fo:block>
		
			<fo:block font-size="3mm" height="8mm" text-align="center" padding-top="5mm">
				<xsl:text>ID: </xsl:text><xsl:value-of select="@id"/><xsl:text></xsl:text>
			</fo:block>
		
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:value-of select="en:firstUpper(name($node/en:description))"/></fo:block>
				<fo:table white-space="nowrap" width="75%" font-size="3mm">
						<fo:table-column width="5%"/>
						<fo:table-column width="45%"/>
						<fo:table-column width="5%"/>
						<fo:table-column width="45%"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block padding-after="2mm" text-align="left">
										<xsl:text>TRAINER: </xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm" text-align="right">
										<xsl:value-of select="$node/en:description/en:trainer/en:name"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm" text-align="left">
										<xsl:text>LICENCE:</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="$node/en:description/en:trainer/en:licence"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:text>SHORT:</xsl:text> 
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="$node/en:description/en:short"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:text>PHONE:</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="$node/en:description/en:trainer/en:contact/en:phone"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:text>STADIUM:</xsl:text> 
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="$node/en:description/en:stadium"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:text>EMAIL:</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="$node/en:description/en:trainer/en:contact/en:email"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
			</fo:block>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>Stats</xsl:text></fo:block>		
				<fo:table white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="5%"/>
					<fo:table-column width="45%"/>
					<fo:table-column width="5%"/>
					<fo:table-column width="45%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>TEAM POWER: </xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="en:calculatePower($node/en:players)"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>ATTACK:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="en:calculateAttack($node/en:players)"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>FORMATION:</xsl:text> 
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="en:getFormation($node/en:players)"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>DEFENCE:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="en:calculateDefence($node/en:players)"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>						
					</fo:table-body>
				</fo:table>
			</fo:block>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:value-of select="en:firstUpper(name($node/en:players))"/></fo:block>		
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>POSITION</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block> </fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">		
						<xsl:for-each select="en:players/en:player">
							<fo:table-row>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of>
										<xsl:if test="@status='captain'"><xsl:text> (C)</xsl:text></xsl:if>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="en:name"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="en:age"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="en:nationality"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="en:skill"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block padding-after="2mm">
										<xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</fo:block>	
	</xsl:template>
	
	<xsl:template name="league-info">
		<xsl:param name="node"/>
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="1cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:value-of select="en:firstUpper(name($node/en:description))"/></fo:block>		
				<fo:table white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="5%"/>
					<fo:table-column width="45%"/>
					<fo:table-column width="5%"/>
					<fo:table-column width="45%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-after="2mm" text-align="left">
									<xsl:text>SEASON: </xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm" text-align="right">
									<xsl:value-of select="$node/en:detail/en:season"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm" text-align="left">
									<xsl:text>DIRECTOR:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="$node/en:detail/en:director/en:name"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>START:</xsl:text> 
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="$node/en:detail/en:start"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>PHONE:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="$node/en:detail/en:director/en:contact/en:phone"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>END:</xsl:text> 
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="$node/en:detail/en:end"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:text>EMAIL:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block padding-after="2mm">
									<xsl:value-of select="$node/en:detail/en:director/en:contact/en:email"></xsl:value-of>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template name="bestPlayers">
		<fo:block id="bestPlayers" break-before="page"></fo:block>
		
		<xsl:call-template name="watermark"/>
		
		<fo:block font-size="9mm" text-align="center" padding-top="5mm">
			<xsl:text>Best players</xsl:text>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>Best goalkeepers</xsl:text></fo:block>		
				
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
							<fo:table-cell><fo:block></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">		
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='goalkeeper']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:if test="position() &lt;= 6"> 
								<xsl:call-template name="six-characteristics">
									<xsl:with-param name="node" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>			
			</fo:block>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>Best defenders</xsl:text></fo:block>		
				
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
							<fo:table-cell><fo:block></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">		
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='defender']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:if test="position() &lt;= 10"> 
								<xsl:call-template name="six-characteristics">
									<xsl:with-param name="node" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>			
			</fo:block>
		</fo:block>
		 
		<fo:block padding-before="1cm" width="75%" page-break-inside="avoid">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>Best midfielders</xsl:text></fo:block>		
				
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
							<fo:table-cell><fo:block></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">		
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='midfielder']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:if test="position() &lt;= 10"> 
								<xsl:call-template name="six-characteristics">
									<xsl:with-param name="node" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>			
			</fo:block>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>Best forwards</xsl:text></fo:block>		
				
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
							<fo:table-cell><fo:block></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">		
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='forward']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:if test="position() &lt;= 6"> 
								<xsl:call-template name="six-characteristics">
									<xsl:with-param name="node" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>			
			</fo:block>
		</fo:block>
		
	</xsl:template>
	
	<xsl:template name="top11">
		<xsl:param name="node"/>
		<fo:block id="top11" break-before="page"></fo:block>
		
		<xsl:call-template name="watermark"/>
		
		<fo:block font-size="9mm" text-align="center" padding-top="5mm">
			<xsl:text>Top 11</xsl:text>
		</fo:block>
		
		<fo:block padding-before="1cm" width="75%">
			<fo:block margin-left="2cm">
				<fo:block font-size="6mm" padding-after="5mm"><xsl:text>League </xsl:text><xsl:value-of select="en:league/en:detail/en:name"/><xsl:text> representation</xsl:text></fo:block>		
				
				<fo:table text-align="center" white-space="nowrap" width="75%" font-size="3mm">
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-column width="20%"/>
					<fo:table-header>
						<fo:table-row font-size="3mm" height="8mm">
							<fo:table-cell><fo:block>POSITION</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NAME</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>AGE</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>NATIONALITY</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>SKILL</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>TEAM</fo:block></fo:table-cell>
							<fo:table-cell><fo:block></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body padding-top="5mm">	
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='goalkeeper']
							[en:age = min(//en:teams/en:team/en:players/en:player[@position='goalkeeper']/en:age)]
							[en:skill = max(//en:teams/en:team/en:players/en:player[@position='goalkeeper']/en:skill)]
						">
								<xsl:call-template name="seven-characteristics">
									<xsl:with-param name="node" select="."></xsl:with-param>
								</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='defender']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:sort select="en:age" data-type="number" order="ascending"/>
							<xsl:if test="position() &lt;= 4"> 
								<xsl:call-template name="seven-characteristics">
									<xsl:with-param name="node" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='midfielder']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:sort select="en:age" data-type="number" order="ascending"/>
							<xsl:if test="position() &lt;= 4"> 
								<xsl:call-template name="seven-characteristics">
									<xsl:with-param name="node" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="en:league/en:teams/en:team/en:players/en:player[@position='forward']">
							<xsl:sort select="en:skill" data-type="number" order="descending"/>
							<xsl:sort select="en:age" data-type="number" order="ascending"/>
							<xsl:if test="position() &lt;= 2"> 
								<xsl:call-template name="seven-characteristics">
									<xsl:with-param name="node" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>			
			</fo:block>
		</fo:block>	
	</xsl:template>
	
	<xsl:template name="six-characteristics">
		<xsl:param name="node"/>
		<fo:table-row>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:name"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:age"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:nationality"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:skill"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/../../en:description/en:short"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="seven-characteristics">
		<xsl:param name="node"/>
		<fo:table-row>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="substring(translate(@position, $lowercase, $uppercase),1,1)"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:name"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:age"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:nationality"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/en:skill"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="$node/../../en:description/en:short"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block padding-after="2mm">
					<xsl:value-of select="en:firstUpper(en:skill/@special)"></xsl:value-of>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="watermark">
		<fo:block-container absolute-position="fixed" left="4cm" top="8cm">
			<fo:block>
				<fo:external-graphic src="url(img/ball.png)"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>
		
</xsl:stylesheet>	