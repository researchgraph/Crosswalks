<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:rif="http://ands.org.au/standards/rif-cs/registryObjects"
    exclude-result-prefixes="xs xsl fn oai rif"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                               -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'researchdata.ands.org'"/>
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:variable name="andsGroupList" select="document('https://raw.githubusercontent.com/researchgraph/Crosswalks/master/ands.org.au/ands_group.xml')"/>
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <researchers>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
            </researchers>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                         -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="researcher">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:if test=".//rif:name[@type='primary']/rif:namePart[@type='given']">
            <xsl:apply-templates select=".//oai:metadata" mode="researcher">
                <xsl:with-param name="date-stamp" select="$date-stamp"/>
            </xsl:apply-templates>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="researcher">
        <xsl:param name="date-stamp"/>
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        
        <researcher>
            <key>
                <xsl:value-of select="concat('Researchgraph.org/ands/',.//rif:key)"/>
            </key>
            <source>
                <xsl:value-of select="$groupSource"/>
            </source>
            <local_id>
                <xsl:value-of select=".//rif:key"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
            </url>
            <full_name>
                <xsl:value-of select="concat(.//rif:namePart[@type='title'],' ',
                    .//rif:namePart[@type='given'],' ',.//rif:namePart[@type='family'])"/>
            </full_name>
            <first_name>
                <xsl:value-of select=".//rif:namePart[@type='given']"/>
            </first_name>
            <last_name>
                <xsl:value-of select=".//rif:namePart[@type='family']"/>
            </last_name>
            <orcid>
                <xsl:value-of select=".//rif:key"/>
            </orcid>
        </researcher>
    </xsl:template>
</xsl:stylesheet>