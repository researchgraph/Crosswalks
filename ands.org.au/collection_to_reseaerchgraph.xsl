<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:rif="http://ands.org.au/standards/rif-cs/registryObjects"
    exclude-result-prefixes="xs fn xsl oai rif" version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                               -->
    <!-- =========================================== -->
<!--    <xsl:param name="source" select="'researchdata.ands.org'"/>-->
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
            <datasets>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
            </datasets>
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
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <dataset>
            <key>
                <xsl:value-of select="concat('Researchgraph.org/ands/',.//rif:key[1])"/>
            </key>
            <xsl:choose>
                <xsl:when test="$andsGroupList/root/row[group = $groupName]/source">
                    <source>
                        <xsl:value-of select="$groupSource"/>
                    </source>
               </xsl:when>
                <xsl:otherwise>
                    <source>
                        <xsl:value-of select="'unknown'"/>
                    </source>
                </xsl:otherwise>
            </xsl:choose>
            <local_id>
                <xsl:value-of select=".//rif:key[1]"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
            </url>
            <title>
                <xsl:value-of select=".//rif:name[@type='primary']/rif:namePart"/>
            </title>
            <!--<xsl:if test=".//rif:dates[@type='dc.created']/rif:date">
                <publication_year>
                    <xsl:value-of select=".//rif:dates[@type='dc.created']/rif:date"/>
                </publication_year>
            </xsl:if>-->
        </dataset>
    </xsl:template>
</xsl:stylesheet>