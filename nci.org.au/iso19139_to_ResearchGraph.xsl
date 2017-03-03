<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    exclude-result-prefixes="xs"
    version="2.0">
     
   <!-- <xsl:message>This is my study xls file.</xsl:message>    
        
    
<! =========================================== -->
<!-- Configuration                               -->
<!-- =========================================== -->
    <xsl:param name="source" select="'nci.org.au'"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
<!-- =========================================== -->
<!-- RegistryObjects (root) Template             -->
<!-- =========================================== -->
    <xsl:template match="/"> 
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <datasets>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
            </datasets>
 <!--       <publications>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
            </publications>
            <researchers>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
            </researchers>
            <relations>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation"/>
            </relations>-->
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                            -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:apply-templates select=".//oai:metadata" mode="dataset">
            <xsl:with-param name="date-stamp" select="$date-stamp"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="dataset">
        <xsl:param name="date-stamp"/>
        <xsl:param name="local_id">
            <xsl:value-of select=".//*/gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>
        <dataset>
            <key>
                <xsl:value-of select="concat('researchgraph.org/nci/',$local_id)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select="$local_id"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select="concat('pid.nci.org.au/',.//oai.identifier)"/>
            </url>
            <title>
                <xsl:value-of select=".//*/gmd:title/gco:CharacterString"/>
            </title>
            <xsl:if test="not(.//*/gmd:dataSetURI/@gco:nilReason='missing')">
            <doi>
                <xsl:value-of select=".//*/gmd:dataSetURI/gco:CharacterString"/>
            </doi>
            </xsl:if>
            <publication_year>
                <xsl:value-of select="year-from-date(.//*/gmd:CI_Date/gmd:date/gco:Date)"/>
            </publication_year>
        </dataset>
    </xsl:template>
</xsl:stylesheet>
