<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
    <xsl:variable name="andsGroupList" select="document('ands_group.xml')"/>
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <researcher>
                <xsl:apply-templates select=".//orcid-bio" mode="researcher"/>
            </researcher>
            <grants>
                <xsl:apply-templates select=".//affiliations/affiliation/item" mode="grant"/>
            </grants>
            <publications>
                <xsl:apply-templates select=".//orcid-work/item"/>
            </publications>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                         -->
    <!-- =========================================== -->
    <xsl:template match="orcid-bio" mode="researcher">     
        <xsl:variable name="timestamp" select="..//orcid-history/last-modified-date/value"/>
        <key>
            <xsl:value-of select="concat('Researchgraph.org/orcid/',..//orcid-identifier/path)"/>
        </key>
        <source>
            <xsl:value-of select="$source"/>
        </source>
        <local_id>
            <xsl:value-of select="//orcid-identifier/path"/>
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
        <xsl:if test="..//orcid-identifier/uri">
            <orcid>
                <xsl:value-of select="substring-after(..//orcid-identifier/uri,'orcid.org/')"/>
            </orcid>
        </xsl:if>
        
        <xsl:if test=".//external-id-common-name[value='Scopus Author ID']">
            <scopus_author_id>
                <xsl:value-of select=".//item[external-id-common-name/value='Scopus Author ID']/external-id-reference/value"/>
            </scopus_author_id>
        </xsl:if>
    </xsl:template>
    <!-- =========================================== -->
    <!-- Grant Template                              -->
    <!-- =========================================== -->
    
    <xsl:template match="item" mode="grant">
        <xsl:variable name="groupName" select=".//organization/name"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <grant>
            <key>
                <xsl:value-of select="concat('Researchgraph.org/orcid/',.//source-orcid/path)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select=".//source-orcid/path"/>
            </local_id>
            <last_updated>
                <xsl:value-of select=".//last-modified-date/value"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//source-orcid/uri"/>
            </url>
            <title>
                <xsl:value-of select=".//role-title"/>
            </title>
            <xsl:if test=".//start-date/year/value">
                <start_year>
                    <xsl:value-of select=".//start-date/year/value"/>
                </start_year>
            </xsl:if>
            <xsl:if test=".//end-date/year/value">
                <end_year>
                    <xsl:value-of select=".//end-date/year/value"/>
                </end_year>
            </xsl:if>
            <funder>
                <xsl:value-of select="$groupSource"/>
            </funder>
        </grant>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                        -->
    <!-- =========================================== -->
    <xsl:template match="item">
        <publication>
            <key>
                <xsl:choose>
                    <xsl:when test=".//work-external-identifier/item[work-external-identifier-type='DOI']">
                        <xsl:value-of select=".//work-external-identifier/item[work-external-identifier-type='DOI']/work-external-identifier-id/value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select=".//source-orcid/path"/>
                    </xsl:otherwise>
                </xsl:choose>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:choose>
                    <xsl:when test=".//work-external-identifier/item[work-external-identifier-type='DOI']">
                        <xsl:value-of select="concat('Researchgraph.org/orcid/',.//work-external-identifier-id/value)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('Researchgraph.org/orcid/',.//source-orcid/path)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </local_id>
            <last_modified>
                <xsl:value-of select=".//last-modified-date/value"/>
            </last_modified>
            <xsl:if test=".//url/value">
                <url>
                    <xsl:value-of select=".//url/value"/>
                </url>
            </xsl:if>
            <title>
                <xsl:value-of select=".//work-title/title/value"/>
            </title>
            <xsl:choose>
                    <xsl:when test=".//work-contributors/contributor/item[.//contributor-role='AUTHOR']">
                        <xsl:for-each select=".//work-contributors/contributor/item[.//contributor-role='AUTHOR']">
                            <authors_list>
                                <xsl:value-of select=".//credit-name/value"/>
                            </authors_list>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="boolean(contains(.//work-citation/citation,'author'))">
                        <authors_list>
                            <xsl:value-of select="substring-before(substring-after(substring-after(.//work-citation/citation,'author'),'{'),'}')"/>
                        </authors_list>
                    </xsl:when>
            </xsl:choose>
            <xsl:if test=".//work-external-identifier/item[work-external-identifier-type='DOI']">
                <local_id>
                    <xsl:value-of select="concat('Researchgraph.org/orcid/',.//work-external-identifier-id/value)"/>
                </local_id>
            </xsl:if>
            <xsl:if test=".//publication-date/year/value">
                <publication_year>
                    <xsl:value-of select=".//publication-date/year/value"/>
                </publication_year>
            </xsl:if>
            <xsl:if test="contains(.//url/value,'eid')">
                <scopus_eid>
                    <xsl:value-of select="substring-after(.//url/value,'eid=')"/>
                </scopus_eid>
            </xsl:if>
        </publication>
    </xsl:template>
</xsl:stylesheet>