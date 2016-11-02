<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:rif="http://ands.org.au/standards/rif-cs/registryObjects"
    exclude-result-prefixes="xs xsl oai fn rif"
    version="1.0">
    
	<!-- =========================================== -->
	<!-- Configuration                               -->
	<!-- =========================================== -->

	<xsl:param name="source" select="'researchdata.ands.org'"/>
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- =========================================== -->
	<!-- RegistryObjects (root) Template             -->
	<!-- =========================================== -->

	<xsl:template match="/">
		<xsl:param name="date-stamp">
		    <xsl:value-of select=".//oai:header/oai:datestamp"/>
		</xsl:param>
	    <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	        xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
	        https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
	       <grants>
	           <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="grant">
	               <xsl:with-param name="date-stamp" select="$date-stamp"/>
	           </xsl:apply-templates>
	       </grants>
	    </registryObjects>
	</xsl:template>
    
    <!-- =========================================== -->
    <!-- Grant Template                              -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="grant">
        <xsl:param name="date-stamp"/>
        <xsl:apply-templates select=".//oai:metadata" mode="grant">
            <xsl:with-param name="date-stamp" select="$date-stamp"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="grant">
        <xsl:param name="date-stamp"/>
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <grant>
            <!--<xsl:choose>
                <xsl:when test="boolean(contains(.//rif:key[1],'www'))">
                    <key>
                        <xsl:value-of select=".//rif:key[1]"/>
                    </key>
                </xsl:when>
                <xsl:otherwise>
                    <key>
                        <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
                    </key>
                </xsl:otherwise>
            </xsl:choose>-->
            <source>
                <xsl:value-of select=".//rif:originatingSource"/>
            </source>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <title>
                <xsl:value-of select=".//rif:name[@type='primary']/rif:namePart"/>
            </title>
            <xsl:if test=".//rif:startDate">
                <start_year>
                    <xsl:value-of select=".//rif:startDate"/>
                </start_year>
            </xsl:if>
            <xsl:if test=".//rif:endDate">
                <end_year>
                    <xsl:value-of select=".//rif:endDate"/>
                </end_year>
            </xsl:if>
            
        </grant>
    </xsl:template>
</xsl:stylesheet>