<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:kaken="http://kaken.nii.ac.jp/ns#" xmlns:rns="http://rns.nii.ac.jp/ns#"
    exclude-result-prefixes="xs xsl rdf rdfs foaf owl dcterms kaken rns"
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
            <researchers>
                <xsl:apply-templates select="rdf:RDF" mode="researcher"/>
            </researchers>
        </registryObjects>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="researcher">
        <researcher>
            <key>
                <xsl:value-of select="concat('researchergraph.org/nii/',.//rns:researcherNumber)"/>
            </key>
            <source>
                <xsl:value-of select="'rns.nii.ac.jp'"/>
            </source>
            <local_id>
                <xsl:value-of select=".//rns:researcherNumber"/>
            </local_id>
            <url>
                <xsl:value-of select=".//rns:Researcher/@rdf:about"/>
            </url>
            <full_name>
                <xsl:value-of select="concat(.//foaf:firstName[@xml:lang='en'],' ',.//foaf:lastName[@xml:lang='en'])"/>
            </full_name>
            <first_name>
                <xsl:value-of select=".//foaf:firstName[@xml:lang='en']"/>
            </first_name>
            <last_name>
                <xsl:value-of select=".//foaf:lastName[@xml:lang='en']"/>
            </last_name>
        </researcher>
    </xsl:template>
    
</xsl:stylesheet>