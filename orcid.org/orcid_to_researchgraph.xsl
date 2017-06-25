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
            <xsl:if  test=".//or:orcid-work[or:work-type='data-set']">
                <datasets>
                    <xsl:apply-templates select=".//or:orcid-work[or:work-type='data-set']" mode="dataset"/>
                </datasets>
            </xsl:if>
            <xsl:if test=".//or:funding-list">
                <grants>
                    <xsl:apply-templates select=".//or:funding-list/or:funding" mode="grant"/>
                </grants>
            </xsl:if>
            <publications>
                <xsl:apply-templates select=".//or:orcid-work[.//or:work-type!='data-set']" mode="publication"/>
            </publications>
            <relations>
                <xsl:apply-templates select=".//or:orcid-work" mode="relation"/>
                <xsl:apply-templates select=".//or:funding" mode="relation"/>
            </relations>
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
    <!-- Dataset Template                                                                     -->    
    <!-- =========================================== -->
    <xsl:template match="or:orcid-work[.//or:work-type='data-set']" mode="dataset">
        <xsl:variable name="timestamp" select=".//or:last-modified-date"/>
        <dataset>
            <key>
                <xsl:choose>
                    <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                        <xsl:value-of select="concat('researchgraph.org/orcid/',.//or:work-external-identifier[or:work-external-identifier-type='doi']/or:work-external-identifier-id)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('researchgraph.org/orcid/',./@put-code)"/>
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
            <xsl:if test=".//or:url">
                <url>
                    <xsl:value-of select=".//or:url"/>
                </url>
            </xsl:if>
            <title>
                <xsl:value-of select=".//or:work-title/or:title"/>
            </title>
            <xsl:if test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                <doi>
                    <xsl:value-of select=".//or:work-external-identifier[or:work-external-identifier-type='doi']/or:work-external-identifier-id"/>
                </doi>
            </xsl:if>
            <xsl:choose>
                <xsl:when test=".//or:publication-date/or:year">
                    <publication_year>
                        <xsl:value-of select=".//or:publication-date/or:year"/>
                    </publication_year>
                </xsl:when>
            </xsl:choose>
        </dataset>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Grant Template                                                                         -->    
    <!-- =========================================== -->
    
    <xsl:template match="or:funding" mode="grant">
        <xsl:variable name="groupName" select=".//or:organization/or:name"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <xsl:variable name="timestamp" select=".//or:last-modified-date"/>
        <xsl:variable name="local_id" select=".//or:funding-external-identifier[1][or:funding-external-identifier-type='grant_number']/or:funding-external-identifier-value"/>
        <grant>
            <key>
                <xsl:value-of select="concat('researchgraph.org/orcid/',$local_id)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select="$local_id"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$timestamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//or:source-orcid/or:uri"/>
            </url>
            <title>
                <xsl:value-of select=".//or:funding-title/or:title"/>
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
                <xsl:value-of select=".//or:organization/or:name"/>
            </funder>
        </grant>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="or:orcid-work[.//or:work-type!='data-set']" mode="publication">
<!--        <xsl:if test=".[//or:work-contributors/or:contributor/or:item[.//or:contributor-role='AUTHOR']] | .[boolean(contains(.//or:citation,'author'))]">-->
            <xsl:variable name="timestamp" select=".//or:last-modified-date"/>
            <publication>
                <key>
                    <xsl:choose>
                        <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                            <xsl:value-of select="concat('researchgraph.org/orcid/',.//or:work-external-identifier[1][or:work-external-identifier-type='doi']/or:work-external-identifier-id)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('researchgraph.org/orcid/',./@put-code)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </key>
                <source>
                    <xsl:value-of select="$source"/>
                </source>
                <local_id>
                    <xsl:choose>
                        <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                            <xsl:value-of select=".//or:work-external-identifier[1][or:work-external-identifier-type='doi']/or:work-external-identifier-id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./@put-code"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </local_id>
                <last_updated>
                    <xsl:value-of select="$timestamp"/>
                </last_updated>
                <xsl:if test=".//or:url">
                    <url>
                        <xsl:value-of select=".//or:url"/>
                    </url>
                </xsl:if>
                <title>
                    <xsl:value-of select=".//or:work-title/or:title"/>
                </title>
                <authors_list>
                    <xsl:choose>
                        <xsl:when test=".//or:work-contributors/or:contributor">
                            <xsl:for-each select=".//or:work-contributors/or:contributor">
                                <xsl:value-of select=".//or:credit-name"/>
                                <xsl:if test="position() != last()">
                                    <xsl:value-of select=" ', ' "/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="boolean(contains(.//or:citation,'author'))">
                            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after(.//or:work-citation/or:citation,'author'),'='),'{'),'}')"/>
                        </xsl:when>                        
                        <xsl:otherwise>
                            <xsl:value-of select=".//or:source/or:source-name"/>
                        </xsl:otherwise>    
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
        <!--</xsl:if>-->
    </xsl:template>
    
    
    <!-- =========================================== -->
    <!-- Relation Template                                                                    -->
    <!-- =========================================== -->
    <xsl:template match="or:orcid-work" mode="relation">
            <relation>
                <from_key>
                    <xsl:value-of select="concat('researchgraph.org/orcid/',ancestor::or:orcid-profile//or:orcid-identifier/or:path)"/>
                </from_key>
                <xsl:choose>
                    <xsl:when test=".//or:work-external-identifier[or:work-external-identifier-type='doi']">
                       <to_uri>
                           <xsl:value-of select="concat('researchgraph.org/orcid/',.//or:work-external-identifier[1][or:work-external-identifier-type='doi']/or:work-external-identifier-id)"/>
                       </to_uri>
                    </xsl:when>
                    <xsl:otherwise>
                        <to_uri>
                            <xsl:value-of select="concat('researchgraph.org/orcid/',./@put-code)"/>
                        </to_uri>
                    </xsl:otherwise>
                </xsl:choose>
                <label>
                    <xsl:value-of select="'relatedTo'"/>
                </label>
            </relation>
    </xsl:template>
    
    <xsl:template match="or:funding" mode="relation">
        <relation>
            <from_key>
                <xsl:value-of select="concat('researchgraph.org/orcid/',ancestor::or:orcid-profile//or:orcid-identifier/or:path)"/>
            </from_key>
            <to_uri>
                <xsl:value-of select="concat('researchgraph.org/orcid/',.//or:funding-external-identifier[1][or:funding-external-identifier-type='grant_number']/or:funding-external-identifier-value)"/>
            </to_uri>
            <label>
                <xsl:value-of select="'relatedTo'"/>
            </label>
        </relation>
    </xsl:template>
</xsl:stylesheet>