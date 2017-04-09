<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
    xmlns:con="http://www.w3.org/2000/10/swap/pim/contact#"
    xmlns:cinii="http://ci.nii.ac.jp/ns/1.0/" xmlns:bibo="http://purl.org/ontology/bibo/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                                                                             -->
    <!-- =========================================== -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <publications>
                <xsl:apply-templates select="rdf:RDF" mode="publication"/>
            </publications>
        </registryObjects>
    </xsl:template>
    
   
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="rdf:RDF" mode="publication">
        <publication>
            <key>
                <xsl:value-of  select="concat('researchgraph.org/nii/',.//cinii:naid)"/>
            </key>
            <source>
                <xsl:value-of select="'ci.nii.ac.jp'"/>
            </source>
            <local_id>
                <xsl:value-of select=".//cinii:naid"/>
            </local_id>
            <!--<last_updated>
                
            </last_updated>-->
            <url>
                <xsl:value-of select=".//rdf:Description/@rdf:about"/>
            </url>
            <title>
                <xsl:value-of select=".//dc:title"/>
            </title>
            <author>
                <xsl:for-each select=".//rdf:Description[1]/dc:creator">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">
                        <xsl:text> , </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </author>
            <publication_year>
                <xsl:value-of select=".//prism:publicationDate"/>
            </publication_year>
        </publication>
    </xsl:template>
</xsl:stylesheet>