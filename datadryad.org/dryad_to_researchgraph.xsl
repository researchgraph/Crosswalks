<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
   xmlns:fn="http://www.w3.org/2005/xpath-functions" 
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:mets="http://www.loc.gov/METS/"
   version="1.0" exclude-result-prefixes="xs fn xsl oai mods mets">
	<!-- =========================================== -->
	<!-- Configuration                               -->
	<!-- =========================================== -->
	<xsl:param name="source" select="'hdl.handle.net'"/>
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	<!-- =========================================== -->
	<!-- RegistryObjects (root) Template             -->
	<!-- =========================================== -->
	<xsl:template match="/">
      <xsl:param name="date-stamp">
         <xsl:value-of select=".//oai:header/oai:datestamp" />
      </xsl:param>
      <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://raw.githubusercontent.com/researchgraph/schema/master/xsd/dataset.xsd">
         <datasets>
            <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset">
               <xsl:with-param name="date-stamp" select="$date-stamp" />
            </xsl:apply-templates>
         </datasets>
         <publications>
            <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication">
               <xsl:with-param name="date-stamp" select="$date-stamp" />
            </xsl:apply-templates>
         </publications>
		 <relations>
		 	<xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation">
		 		<xsl:with-param name="date-stamp" select="$date-stamp"/>
		 	</xsl:apply-templates>
		 </relations>
      </registryObjects>
   </xsl:template>
	<!-- =========================================== -->
	<!-- Dataset Template                            -->
	<!-- =========================================== -->
	<xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="record-type">
			<xsl:value-of select=".//mods:genre"/>
		</xsl:variable>
		<xsl:if test="contains(translate($record-type,$uppercase,$smallcase), 'dataset')">
			<xsl:apply-templates select=".//oai:metadata" mode="dataset">
				<xsl:with-param name="date-stamp" select="$date-stamp"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="oai:metadata" mode="dataset">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="forCode" select="substring-after(., ':')"/>
		<dataset>
			<key>
				<xsl:value-of select=".//mods:identifier[@type='uri']"/>
			</key>
			<source>
				<xsl:value-of select="$source"/>
			</source>
			<local_id>
				<xsl:choose>
					<xsl:when test="boolean(contains(.//mods:identifier[@type='uri'],'hdl.handle.net/10255/'))">
						<xsl:value-of select="substring-after(.//mods:identifier[@type='uri'],'10255/')"/>
					</xsl:when>
				</xsl:choose>
			</local_id>
			<title>
				<xsl:value-of select=".//mods:titleInfo"/>
			</title>
			<last_updated>
				<xsl:value-of select="$date-stamp"/>
			</last_updated>
			<url>
				<xsl:value-of select=".//mods:identifier[@type='uri']"/>
			</url>
			<publication_year>
				<xsl:value-of select="substring(.//mods:dateIssued, 1, 4) "/>
			</publication_year>
		</dataset>
	</xsl:template>
	<!-- =========================================== -->
	<!-- Publication Template                        -->
	<!-- =========================================== -->
	<xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="record-type">
			<xsl:value-of select=".//mods:genre"/>
		</xsl:variable>
		<xsl:if test="contains(translate($record-type,$uppercase,$smallcase),
			'article')">
			<xsl:apply-templates select=".//oai:metadata" mode="publication">
				<xsl:with-param name="date-stamp" select="$date-stamp"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="oai:metadata" mode="publication">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="forCode" select="substring-after(., ':')"/>
		<publication>
			<key>
				<xsl:value-of select=".//mods:identifier[@type='uri']"/>
			</key>
			<source>
				<xsl:value-of select="$source"/>
			</source>
			<local_id>
				<xsl:choose>
					<xsl:when test="boolean(contains(.//mods:identifier[@type='uri'], 'hdl.handle.net/10255/'))">
						<xsl:value-of select="substring-after(.//mods:identifier[@type='uri'], '10255/')"/>
					</xsl:when>
				</xsl:choose>
			</local_id>
			<last_updated>
				<xsl:value-of select="$date-stamp"/>
			</last_updated>
			<url>
				<xsl:value-of select=".//mods:identifier[@type='uri']"/>
			</url>
			<title>
				<xsl:value-of select=".//mods:titleInfo"/>
			</title>
			<publication_year>
				<xsl:value-of select="substring(.//mods:dateAccessioned, 1, 4)"/>
			</publication_year>
			<authors_list>
				<xsl:for-each select=".//mods:namePart">
					<xsl:value-of select="concat(.,'; ')"/>
				</xsl:for-each>
			</authors_list>
			<xsl:if test=".//mods:identifier[not(@*)]">
				<doi>
					<xsl:value-of select=".//mods:identifier[not(@*)]"/>
				</doi>
			</xsl:if>
		</publication>
	</xsl:template>
	<!-- =========================================== -->
	<!-- Relation Template                           -->
	<!-- =========================================== -->
	<xsl:template match="oai:OAI-PMH/*/oai:record" mode="relation">
		<xsl:param name="date-stamp"/>
		<xsl:if test=".//mods:relatedItem[*]">
			<xsl:apply-templates select=".//oai:metadata" mode="relation">
				<xsl:with-param name="date-stamp" select="$date-stamp"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="oai:metadata" mode="relation">
		<xsl:param name="data-stamp"/>
		<xsl:for-each select=".//mods:relatedItem">
			<xsl:if test="contains(.,'dryad')">
				<relation>
					<from_key>
						<xsl:value-of select="..//mods:identifier[@type='uri']"/>
					</from_key>
					<to_uri>
						<xsl:value-of select="substring-before(..//mods:identifier[@type='uri'],'dryad')"/>
						<xsl:value-of select="substring(.,string-length(substring-before(.,'dryad'))+1)"/>
					</to_uri>
					<label>
						<xsl:value-of select="@type"/>
					</label>
				</relation>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>

