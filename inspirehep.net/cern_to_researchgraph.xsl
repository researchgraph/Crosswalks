<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs xsl fn oai marc"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                                                                             -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'inspirehep.net'"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <publications>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
            </publications>
            <researchers>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
            </researchers>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
        <xsl:if test=".//marc:datafield[@tag='035'][marc:subfield='Inspire']">
            <xsl:apply-templates select=".//oai:metadata" mode="publication"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="publication">
        <xsl:variable name="local_id" select=".//marc:datafield[@tag='035'][marc:subfield='Inspire']/marc:subfield[@code='a']"/>
        <publication>
            <key>
                <xsl:value-of select="concat('researchgraph.org/inspirehep/',$local_id)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select="$local_id"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="ancestor::oai:record/oai:header/oai:datestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select="concat('https://inspirehep.net/record/',$local_id)"/>
            </url>
            <title>
                <xsl:value-of select=".//marc:datafield[@tag='245']/marc:subfield[@code='a']"/>
            </title>
            <authors_list>
                <xsl:value-of select="translate(.//marc:datafield[@tag='100']/marc:subfield[@code='a'],',','.')"/>
                <xsl:value-of select=" ' , '"/>
                
                <xsl:for-each select=".//marc:datafield[@tag='700']">
                    <xsl:value-of select="translate(.//marc:subfield[@code='a'],',','.')"/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="' , '"/>
                    </xsl:if>
                </xsl:for-each>
            </authors_list>
            <xsl:if test=".//marc:datafield[@tag='024'][@ind1='7']">
                <doi>
                    <xsl:value-of select=".//marc:datafield[@tag='024'][@ind1='7']/marc:subfield[@code='a']"/>
                </doi>
            </xsl:if>
            <xsl:if test=".//marc:datafield[@tag='260']/marc:subfield[@code='c']">
                <publication_year>
                    <xsl:value-of select=".//marc:datafield[@tag='260']/marc:subfield[@code='c']"/>
                </publication_year>
            </xsl:if>
        </publication>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="researcher">
        <xsl:apply-templates select=".//oai:metadata" mode="researcher"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="researcher">
        <xsl:for-each select=".//marc:datafield[@tag='700']
                                               | .//marc:datafield[@tag='100']">
            <researcher>
                <key>
                    <xsl:value-of select="concat('researchgraph.org/inspirehep/researcher/', .//marc:subfield[@code='i'])"/>
                </key>
                <source>
                    <xsl:value-of select="$source"/>
                </source>
                <local_id>
                    <xsl:value-of select=".//marc:subfield[@code='i']"/>
                </local_id>
                <last_updated>
                    <xsl:value-of select="ancestor::oai:record/oai:header/oai:datestamp"/>
                </last_updated>
                <full_name>
                    <xsl:value-of select=".//marc:subfield[@code='a']"/>
                </full_name>
                <first_name>
                    <xsl:value-of select="substring-before(.//marc:subfield[@code='a'],',')"/>
                </first_name>
                <last_name>
                    <xsl:value-of select="substring-after(.//marc:subfield[@code='a'],', ')"/>
                </last_name>
                <xsl:if test=".//marc:subfield[@code=j]">
                    <orcid>
                        <xsl:value-of select="marc:subfield[@code='j']"/>
                    </orcid>
                </xsl:if>
            </researcher>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>