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
            <xsl:if test=".//oai:header[oai:setSpec='item_type_1' or
                                        oai:setSpec='item_type_2' or
                                        oai:setSpec='item_type_3' or
                                        oai:setSpec='item_type_4' or
                                        oai:setSpec='item_type_9' or
                                        oai:setSpec='item_type_11']">
                <datasets>
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
                </datasets>
            </xsl:if>
            <xsl:if test=".//oai:header[oai:setSpec='item_type_5' or
                                        oai:setSpec='item_type_6' or
                                        oai:setSpec='item_type_7' or
                                        oai:setSpec='item_type_8']">
                <publications>
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
                </publications>
            </xsl:if>
            <researchers>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
            </researchers>
            <relations>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation"/>
            </relations>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                            -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
        <xsl:apply-templates select=".//oai:metadata" mode="dataset"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="dataset">
        <dataset>
            <key>
                <xsl:value-of select="concat('researchgraph.org/figshare/',.//bibo:doi)"/>
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
            <doi>
                <xsl:value-of select=".//bibo:doi"/>
            </doi>
            <publication_year>
                <xsl:value-of select="year-from-date(xs:date(substring-after(.//vivo:datePublished/@rdf:resource,'date')))"/>
            </publication_year>
        </dataset>
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
                <xsl:value-of select="concat('researchgraph.org/figshare/',.//bibo:doi)"/>
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
                <xsl:value-of select=".//vivo:ConferencePaper/@rdf:about"/>
            </url>
            <title>
                <xsl:value-of select=".//rdfs:label"/>
            </title>
            <authors_list>
                <xsl:for-each select=".//vcard:Name">
                    <xsl:value-of select="concat(.//vcard:givenName,' ',.//vcard:familyName)"/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="','"/>
                    </xsl:if>
                </xsl:for-each>
            </authors_list>
            <doi>
                <xsl:value-of select=".//bibo:doi"/>
            </doi>
            <publication_year>
                <xsl:value-of select="year-from-date(xs:date(substring-after(.//vivo:datePublished/@rdf:resource,'date')))"/>
            </publication_year>
        </publication>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                         -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="researcher">
        <xsl:apply-templates select=".//oai:metadata" mode="researcher"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="researcher">
        <xsl:for-each select=".//vcard:Name">
            <xsl:if test="not(contains(preceding-sibling::vivo:Authorship[1]//vcard:Individual/@rdf:about,'authors//'))">
                <xsl:variable name="firstName" select=".//vcard:givenName"/>
                <xsl:variable name="lastName" select=".//vcard:familyName"/>
                <xsl:variable name="fullName" select="concat($firstName,' ',$lastName)"/>
                <researcher>
                    <key>
                        <xsl:value-of select="concat('researchgraph.org/figshare/',substring-after(substring-before(preceding-sibling::vivo:Authorship[1]//vcard:Individual/@rdf:about,'-vcard'),'authors/'))"/>
                    </key>
                    <source>
                        <xsl:value-of select="$source"/>
                    </source>
                    <local_id>
                        <xsl:value-of select="substring-after(substring-before(preceding-sibling::vivo:Authorship[1]//vcard:Individual/@rdf:about,'-vcard'),'authors/')"/>
                    </local_id>
                    <url>
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::vivo:Authorship[1]//vivo:orcidId">
                                <xsl:value-of select="preceding-sibling::vivo:Authorship[1]//vivo:orcidId/@rdf:resource"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(preceding-sibling::vivo:Authorship[1]//vcard:Individual/@rdf:about,'-vcard')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </url>
                    <full_name>
                        <xsl:value-of select="$fullName"/>
                    </full_name>
                    <first_name>
                        <xsl:value-of select="$firstName"/>
                    </first_name>
                    <last_name>
                        <xsl:value-of select="$lastName"/>
                    </last_name>
                </researcher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Relation Template                           -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relation">
        <xsl:apply-templates select=".//oai:metadata" mode="relation"/>
    </xsl:template>
    <xsl:template match="oai:metadata" mode="relation">
        <xsl:for-each select=".//vivo:relates[*]">
            <relation>
                <xsl:choose>
                    <xsl:when test=".//vivo:orcidId">
                        <from_key>
                            <xsl:value-of select="concat('researchgraph.org/figshare/',substring-after(.//vivo:orcidId/@rdf:resource,'orcid.org/'))"/>
                        </from_key>
                    </xsl:when>
                    <xsl:otherwise>
                        <from_key>
                            <xsl:value-of select="concat('researchgraph.org/figshare/',../..//bibo:doi)"/>
                        </from_key>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::vivo:Authorship[1]//vivo:orcidId">
                        <key>
                            <xsl:value-of select="concat('researchgraph.org/figshare/',substring-after(.//vivo:orcidId/@rdf:resource,'orcid.org/'))"/>
                        </key>
                    </xsl:when>
                    <xsl:otherwise>
                        <key>
                            <xsl:value-of select="concat('researchgraph.org/figshare/',substring-after(substring-before(.//vcard:Individual/@rdf:about,'-vcard'),'/figshare.com/'))"/>
                        </key>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:choose>
                    <xsl:when test=".//vivo:orcidId">
                        <label>
                            <xsl:value-of select="'Author_ORCID'"/>
                        </label>
                    </xsl:when>
                    <xsl:otherwise>
                        <label>
                            <xsl:value-of select="'Author'"/>
                        </label>
                    </xsl:otherwise>
                </xsl:choose>
            </relation>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>