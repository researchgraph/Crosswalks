<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bibo="http://purl.org/ontology/bibo/"
    xmlns:vivo="http://vivoweb.org/ontology/core#"
    xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
    exclude-result-prefixes="xs fn oai xsl xs rdfs bibo vivo vcard"
    version="2.0">
    
    <!-- =========================================== -->
    <!-- Configuration                               -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'figshare.com'"/>
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
            <publications>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
            </publications>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                        -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
        <xsl:apply-templates select=".//oai:metadata" mode="publication"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="publication">
        <publication>
            <key>
                <xsl:value-of select="concat('Researchgraph.org/figshare/',.//bibo:doi)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select=".//bibo:doi"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="..//oai:datestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//@rdf:about[1]"/>
            </url>
            <title>
                <xsl:value-of select=".//rdfs:label"/>
            </title>
            <authors_list>
                <xsl:for-each select=".//vcard:Name">
                    <xsl:value-of select="concat(.//vcard:givenName,' ',.//vcard:familyName,',')"/>
                </xsl:for-each>
            </authors_list>
            <doi>
                <xsl:value-of select=".//bibo:doi"/>
            </doi>
            <publication_year>
<!--                <xsl:value-of select="year-from-date(xs:date(substring-after(.//vivo:datePublished/@rdf:resource,'date')))"/>-->
                <xsl:value-of select="substring-before(substring-after(.//vivo:datePublished/@rdf:resource,'date'),'-')"/>
            </publication_year>
        </publication>
    </xsl:template>
</xsl:stylesheet>