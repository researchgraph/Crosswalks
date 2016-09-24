<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns="http://researchgraph.org/schema/v2.0/xml/nodes"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="xs fn xsl dc oai_dc oai">
    
    <xsl:param name="source" select="'dspace.cam.ac.uk'"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

        <xsl:template match="/">  
            <xsl:param name="date-stamp">
                <xsl:value-of select=".//oai:header/oai:datestamp"/>
            </xsl:param>
            <registryObjects
            xmlns="http://researchgraph.org/schema/v2.0/xml/nodes"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="https://raw.githubusercontent.com/researchgraph/schema/master/xsd/dataset.xsd">
                <datasets>
                    <xsl:apply-templates select=".//oai:record/*/oai_dc:dc">
                        <xsl:with-param name="date-stamp" select="$date-stamp"/>
                    </xsl:apply-templates>
                </datasets>
            </registryObjects>
        </xsl:template>
        
        <xsl:template match="oai_dc:dc">
            <xsl:param name="date-stamp" />

            <xsl:variable name="forCode" select="substring-after(., ':')"/>
            <dataset>
                 <key>
                    <xsl:value-of select="dc:identifier"/>
                </key>
                <source>
                    <xsl:value-of select="$source"/>
                </source>
               <local_id>
                    <xsl:choose>
                        <xsl:when test="boolean(contains(dc:identifier,'dspace.cam.ac.uk/handle/'))">
                            <xsl:value-of select="substring-after(dc:identifier, 'handle/')"/>    
                        </xsl:when>
                    </xsl:choose>
                </local_id>
                <title>
                    <xsl:value-of select="dc:title"/>
                </title>
                <last_updated>
                    <xsl:value-of select="$date-stamp"/>
                </last_updated>
                <url>
                    <xsl:value-of select="dc:identifier"/>
                </url>
                <publication_year>
                    <xsl:value-of select="substring(dc:date, 1, 4) " />
                </publication_year>
                
            </dataset>

        </xsl:template>
    

</xsl:stylesheet>