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
         <!--<publications>
            <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication">
               <xsl:with-param name="date-stamp" select="$date-stamp" />
            </xsl:apply-templates>
         </publications>-->
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
				<xsl:value-of select="mods:identifier[@type='uri']"/>
			</key>
			<source>
				<xsl:value-of select="$source"/>
			</source>
			<local_id>
				<xsl:choose>
					<xsl:when test="boolean(contains(mods:identifier[@type='uri'],'hdl.handle.net/10255/'))">
						<xsl:value-of select="substring-after(mods:identifier,'10255/')"/>
					</xsl:when>
				</xsl:choose>
			</local_id>
			<title>
				<xsl:value-of select="mods:titleInfo"/>
			</title>
			<last_updated>
				<xsl:value-of select="$date-stamp"/>
			</last_updated>
			<url>
				<xsl:value-of select="mods:identifier[@type='uri']"/>
			</url>
			<publication_year>
				<xsl:value-of select="substring(mods:dateIssued, 1, 4) "/>
			</publication_year>
		</dataset>
	</xsl:template>
	<!-- =========================================== -->
	<!-- Publication Template                        -->
	<!-- =========================================== -->
	<!--<xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="record-type">
			<xsl:value-of select=".//oai:xmlDate/mods:genre"/>
		</xsl:variable>
		<xsl:if test="contains(translate($record-type,$uppercase,$smallcase),
			'article')">
			<xsl:apply-templates select="oai:metadata/oai:mets" mode="publication">
				<xsl:with-param name="date-stamp" select="$date-stamp"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="mets" mode="publication">
		<xsl:param name="date-stamp"/>
		<xsl:variable name="forCode" select="substring-after(., ':')"/>
		<publication>
			<key>
				<xsl:value-of select="mods:identifier"/>
			</key>
			<source>
				<xsl:value-of select="$source"/>
			</source>
			<local_id>
				<xsl:choose>
					<xsl:when test="boolean(contains(mods:identifier[@type='uri'], 'hdl.handle.net/10255/'))">
						<xsl:value-of select="substring-after(mods:identifier[@type='uri'], '10255/')"/>
					</xsl:when>
				</xsl:choose>
			</local_id>
			<last_updated>
				<xsl:value-of select="$date-stamp"/>
			</last_updated>
			<url>
				<xsl:value-of select="mods:identifier"/>
			</url>
			<title>
				<xsl:value-of select="mods:titleInfo"/>
			</title>
			<publication_year>
				<xsl:value-of select="substring(mods:dateAccessioned, 1, 4)"/>
			</publication_year>
			<authors_list>
				<xsl:for-each select="mods:namePart">
					<xsl:value-of select="concat(.,'; ')"/>
				</xsl:for-each>
			</authors_list>-->

			<!-- If there is DOI -->
			<!--<xsl:for-each select="mods:identifier">
				<xsl:if test="boolean(contains(.,'doi.org'))">
					<doi>
						<xsl:value-of select="substring-after(., 'doi.org/')"/>
					</doi>
				</xsl:if>
			</xsl:for-each>
		</publication>
	</xsl:template>-->
</xsl:stylesheet>
