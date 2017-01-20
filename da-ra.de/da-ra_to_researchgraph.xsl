<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs oai fn xs xsl"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                                                                              -->
    <!-- =========================================== -->
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template                                           -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://raw.githubusercontent.com/researchgraph/schema/master/xsd/dataset.xsd">
            <datasets>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
            </datasets>
            <!--<publications>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
            </publications>-->
            <researchers>
                <xsl:apply-templates select="."  mode="researcher"/>
            </researchers>
            <relation>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation"/>
            </relation>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                                                                     -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
        <xsl:if test=".//oai:resourceType='1' or
                                .//oai:resourceType='2'">
            <xsl:apply-templates select=".//oai:metadata" mode="dataset"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="dataset">
        <dataset>
            <key>
                <xsl:value-of select="concat('researchgraph.org/da-ra/',.//oai:resourceIdentifier/oai:identifier,.//oai:resourceIdentifier/oai:currentVersion)"/>
            </key>
            <source>
                <xsl:value-of select="substring-before(substring-after(.//oai:dataURLs/oai:dataURL[1],'www.'),'/')"/>
            </source>
            <local_id>
                <xsl:value-of select="concat(.//oai:resourceIdentifier/oai:identifier,.//oai:resourceIdentifier/oai:currentVersion)"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="ancestor::oai:record//oai:datestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//oai:dataURLs/oai:dataURL[1]"/>
            </url>
            <title>
                <xsl:value-of select=".//oai:titleName"/>
            </title>
            <doi>
                <xsl:value-of select=".//oai:doiProposal"/>
            </doi>
            <publication_year>
                <xsl:value-of select=".//oai:publicationDate/oai:date"/>
            </publication_year>
        </dataset>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <!--<xsl:template match="oai:OAI-PMH/*/oai:">
        <xsl:if test=".//oai:resourceType='1' or
            .//oai:resourceType='2'">
            <xsl:apply-templates select=".//oai:metadata" mode="dataset"/>
        </xsl:if>
    </xsl:template>-->
    
    <!-- =========================================== -->
    <!-- Researchers Template                                                           -->
    <!-- =========================================== -->
    <xsl:template match="/" mode="researcher">
        <xsl:for-each select=".//oai:creator">
            <researcher>
                <full_name>
                    <xsl:value-of select="concat(.//oai:firstName,' ',.//oai:lastName)"/>
                </full_name>
                <first_name>
                    <xsl:value-of select=".//oai:firstName"/>
                </first_name>
                <last_name>
                    <xsl:value-of select=".//oai:lastName"/>
                </last_name>
            </researcher>
        </xsl:for-each>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Relation Template                                                                    -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relation">
        <xsl:apply-templates select=".//oai:metadata" mode="relation"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="relation">
        <xsl:if test=".//oai:relation">
            <xsl:for-each select=".//oai:relation">
                <relation>
                    <from_key>
                        <xsl:value-of select="concat('researchgraph.org/da-ra/',ancestor::oai:metadata//oai:resourceIdentifier/oai:identifier)"/>
                    </from_key>
                    <to_uri>
                        <xsl:value-of select=".//oai:identifier"/>
                    </to_uri>
                    <label>
                        <xsl:value-of select=".//oai:relationType"/>
                    </label>
                </relation>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>