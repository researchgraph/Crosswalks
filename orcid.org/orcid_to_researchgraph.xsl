<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs xsl fn xdt fo"
    version="2.0">
    
    <!-- =========================================== -->
    <!-- Configuration                               -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'orcid.org'"/>
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <researcher>
                <xsl:apply-templates select="root/orcid-profile" mode="researcher">
                    <xsl:with-param name="source" select="$source"></xsl:with-param>
                </xsl:apply-templates>
            </researcher>
            <!--<grants>
                <xsl:apply-templates select="orcid-activities"/>
            </grants>
            <publications>
                <xsl:apply-templates select="orcid-work"/>
            </publications>-->
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                         -->
    <!-- =========================================== -->
    <xsl:template match="orcid-profile" mode="researcher">     
        <xsl:variable name="timestamp" select="..//orcid-history/last-modified-date/value"/>
        <key>
            <xsl:value-of select="concat('Researchgraph.org/orcid/',substring-after(.//orcid-identifier/uri,'orcid.org/'))"/>
        </key>
        <source>
            <xsl:value-of select="$source"/>
        </source>
        <local_id>
            <xsl:value-of select="substring-after(.//orcid-identifier/uri,'orcid.org/')"/>
        </local_id>
        <last_updated>
            <xsl:value-of select="$timestamp"/>
        </last_updated>
        <url>
            <xsl:value-of select=".//url[1]/value"/>
        </url>
        <full_name>
            <xsl:value-of select="concat(.//given-names/value,' ',.//family-name/value)"/>
        </full_name>
        <first_name>
            <xsl:value-of select=".//given-names/value"/>
        </first_name>
        <last_name>
            <xsl:value-of select=".//family-name/value"/>
        </last_name>
        <orcid>
            <xsl:value-of select="substring-after(.//orcid-identifier/uri,'orcid.org/')"/>
        </orcid>
        <xsl:if test=".//external-id-common-name[value='Scopus Author ID']">
            <scopus_author_id>
                <xsl:value-of select=".//item[external-id-common-name/value='Scopus Author ID']/external-id-reference/value"/>
            </scopus_author_id>
        </xsl:if>
    </xsl:template></xsl:stylesheet>