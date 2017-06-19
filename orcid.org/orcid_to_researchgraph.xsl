<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:or="http://www.orcid.org/ns/orcid"
    exclude-result-prefixes="xs xsl fn xdt fo or"
    version="2.0">
    
    <!-- =========================================== -->
    <!-- Configuration                               -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'orcid.org'"/>
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:variable name="andsGroupList" select="document('ands_group.xml')"/>
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <researchers>
                <xsl:apply-templates select=".//or:orcid-bio" mode="researcher"/>
            </researchers>
            <xsl:if test=".//or:orcid-activities">
                <grants>
                    <xsl:apply-templates select=".//or:affiliations/or:affiliation" mode="grant"/>
                </grants>
            </xsl:if>
            <xsl:if test=".//or:orcid-works/or:orcid-work">
                <publications>
                    <xsl:apply-templates select=".//or:orcid-work" mode="publication"/>
                </publications>
            </xsl:if>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                                                             -->
    <!-- =========================================== -->
    <xsl:template match="or:orcid-bio" mode="researcher">     
        <xsl:variable name="timestamp" select="..//or:orcid-history/or:last-modified-date"/>
        <researcher>
            <key>
                <xsl:value-of select="concat('researchgraph.org/orcid/',..//or:orcid-identifier/or:path)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select="//or:orcid-identifier/or:path"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$timestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//or:researcher-urls/or:researcher-url[1]/or:url"/>
            </url>
            <full_name>
                <xsl:value-of select="concat(.//or:given-names,' ',.//or:family-name)"/>
            </full_name>
            <first_name>
                <xsl:value-of select=".//or:given-names"/>
            </first_name>
            <last_name>
                <xsl:value-of select=".//or:family-name"/>
            </last_name>
            <xsl:if test="..//or:orcid-identifier/or:uri">
                <orcid>
                    <xsl:value-of select="substring-after(..//or:orcid-identifier/or:uri,'orcid.org/')"/>
                </orcid>
            </xsl:if>
            <xsl:if test=".//or:external-id-common-name[or:value='Scopus Author ID']">
                <scopus_author_id>
                    <xsl:value-of select=".//or:item[or:external-id-common-name/or:value='Scopus Author ID']/or:external-id-reference/or:value"/>
                </scopus_author_id>
            </xsl:if>
        </researcher>
    </xsl:template>
    <!-- =========================================== -->
    <!-- Grant Template                                                                         -->    
    <!-- =========================================== -->
    
    <xsl:template match="or:affiliation" mode="grant">
        <xsl:variable name="groupName" select=".//or:organization/or:name"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <xsl:variable name="timestamp" select=".//or:last-modified-date"/>
        <grant>
            <key>
                <xsl:value-of select="concat('researchgraph.org/orcid/',.//or:source-orcid/or:path)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select=".//or:source-orcid/or:path"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$timestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//or:source-orcid/or:uri"/>
            </url>
            <title>
                <xsl:value-of select=".//or:role-title"/>
            </title>
            <xsl:if test=".//or:start-date/or:year">
                <start_year>
                    <xsl:value-of select=".//or:start-date/or:year"/>
                </start_year>
            </xsl:if>
            <xsl:if test=".//or:end-date/or:year/or:value">
                <end_year>
                    <xsl:value-of select=".//or:end-date/or:year/or:value"/>
                </end_year>
            </xsl:if>
            <funder>
                <xsl:value-of select="$groupSource"/>
            </funder>
        </grant>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="or:orcid-work" mode="publication">
        <xsl:if test=".[//or:work-contributors/or:contributor/or:item[.//or:contributor-role='AUTHOR']] | .[boolean(contains(.//or:citation,'author'))]">
            <xsl:variable name="timestamp" select=".//or:last-modified-date"/>
            <publication>
                <key>
                    <xsl:choose>
                        <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                            <xsl:value-of select="concat('researchgraph.org/',.//or:work-external-identifier[or:work-external-identifier-type='doi']/or:work-external-identifier-id)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('researchgraph.org/',./@put-code)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </key>
                <source>
                    <xsl:value-of select="$source"/>
                </source>
                <local_id>
                    <xsl:choose>
                        <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                            <xsl:value-of select=".//or:work-external-identifier[or:work-external-identifier-type='doi']/or:work-external-identifier-id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./@put-code"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </local_id>
                <last_updated>
                    <xsl:value-of select="$timestamp"/>
                </last_updated>
                <xsl:if test=".//or:url/or:value">
                    <url>
                        <xsl:value-of select=".//or:url/or:value"/>
                    </url>
                </xsl:if>
                <title>
                    <xsl:value-of select=".//or:work-title/or:title"/>
                </title>
                <authors_list>
                    <xsl:choose>
                        <xsl:when test=".//or:work-contributors/or:contributor/or:item[.//or:contributor-role='AUTHOR']">
                            <xsl:for-each select=".//or:work-contributors/or:contributor/or:item[.//or:contributor-role='AUTHOR']">
                                <xsl:value-of select=".//or:credit-name/or:value"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="boolean(contains(.//or:citation,'author'))">
                            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after(.//or:work-citation/or:citation,'author'),'='),'{'),'}')"/>
                        </xsl:when>
                    </xsl:choose>
                </authors_list>
                <xsl:if test="contains(.//or:url,'eid')">
                    <scopus_eid>
                        <xsl:value-of select="substring-after(.//or:url,'eid=')"/>
                    </scopus_eid>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test=".//or:publication-date/or:year">
                        <publication_year>
                            <xsl:value-of select=".//or:publication-date/or:year"/>
                        </publication_year>
                    </xsl:when>
                </xsl:choose>
            </publication>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>