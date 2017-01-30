<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns="http://researchgraph.org/schema/v2.0/xml/nodes" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:rif="http://ands.org.au/standards/rif-cs/registryObjects"
    exclude-result-prefixes="xs fn xsl oai rif" 
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                                                                             -->
    <!-- =========================================== -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:variable name="andsGroupList" select="document('ands_group.xml')"/>
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
           <xsl:if test=".//oai:setSpec='class:activity'">
               <grants>
                   <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="grant"/>
               </grants>
           </xsl:if>
            <xsl:if test=".//oai:setSpec='class:collection'">
                <xsl:if test=".//rif:collection/@type != 'publication' or
                    .//rif:collection/@type != 'software' ">
                    <datasets>
                        <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
                    </datasets>
                </xsl:if>
                <xsl:if test=".//rif:collection/@type = 'publication' ">
                    <publications>
                        <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
                    </publications>
                </xsl:if>
            </xsl:if>
            <xsl:if test=".//oai:setSpec='class:party'">
                <researchers>
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
                </researchers>
            </xsl:if>
            <relations>
                <xsl:if test=".//rif:relatedObject">
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relatedObject"/>
                </xsl:if>
                <xsl:if test=".//rif:relatedInfo">
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relatedInfo"/>
                </xsl:if>
                <xsl:if test=".//rif:subject[@type='anzsrc-for']">
                    <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation"/>
                </xsl:if>
            </relations>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Grant Template                              -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="grant">
        <xsl:apply-templates select=".//oai:metadata" mode="grant"/>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="grant">
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <grant>
            <key>
                <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:registryObject/rif:key[1])"/>
            </key>
            <source>
                <xsl:value-of select="$groupSource"/>
            </source>
            <local_id>
                <xsl:value-of select=".//rif:registryObject/rif:key[1]"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="..//oai:datestamp"/>
            </last_updated>
            <xsl:if test=".//rif:electronic[@type='url']">
                <url>
                    <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
                </url>
            </xsl:if>
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
            <xsl:if test=".//rif:identifier[@type='purl'] and contains(.//rif:activity/rif:identifier[@type='purl'],'purl.org')">
                <purl>
                    <xsl:value-of select=".//rif:identifier[@type='purl']"/>
                </purl>
            </xsl:if>
            <xsl:if test=".//rif:description[@type='researchers']">
                <participant_list>
                    <xsl:value-of select=".//rif:description[@type='researchers']"/>
                </participant_list>
            </xsl:if>
            <funder>
                <xsl:value-of select="$groupSource"/>
            </funder>
        </grant>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                            -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:if test=".//rif:collection/@type != 'publication' or
            .//rif:collection/@type != 'software' ">
            <xsl:apply-templates select=".//oai:metadata" mode="dataset">
                <xsl:with-param name="date-stamp" select="$date-stamp"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="dataset">
        <xsl:param name="date-stamp"/>
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <dataset>
            <key>
                <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:registryObject/rif:key[1])"/>
            </key>
            <xsl:choose>
                <xsl:when test="$andsGroupList/root/row[group = $groupName]/source">
                    <source>
                        <xsl:value-of select="$groupSource"/>
                    </source>
                </xsl:when>
                <xsl:otherwise>
                    <source>
                        <xsl:value-of select="'unknown'"/>
                    </source>
                </xsl:otherwise>
            </xsl:choose>
            <local_id>
                <xsl:value-of select=".//rif:registryObject/rif:key[1]"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
            </url>
            <title>
                <xsl:value-of select=".//rif:name[@type='primary']/rif:namePart"/>
            </title>
            <xsl:if test=".//rif:identifier[@type='doi']">
                <doi>
                    <xsl:value-of select=".//rif:identifier[@type='doi']"/>
                </doi>
            </xsl:if>
            <xsl:if test=".//rif:licence">
                <licence>
                    <xsl:value-of select=".//rif:licence/@rightsUri"/>
                </licence>
            </xsl:if>
            <xsl:if test=".//rif:date[@type='publicationDate']">
                <publication_year>
                    <xsl:value-of select=".//rif:date[@type='publicationDate']"/>
                </publication_year>
            </xsl:if>
        </dataset>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:if test=".//rif:collection/@type = 'publication' ">
            <xsl:apply-templates select=".//oai:metadata" mode="publication">
                <xsl:with-param name="date-stamp" select="$date-stamp"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="publication">
        <xsl:param name="date-stamp"/>
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        <publication>
            <key>
                <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:registryObject/rif:key[1])"/>
            </key>
            <xsl:choose>
                <xsl:when test="$andsGroupList/root/row[group = $groupName]/source">
                    <source>
                        <xsl:value-of select="$groupSource"/>
                    </source>
                </xsl:when>
                <xsl:otherwise>
                    <source>
                        <xsl:value-of select="'unknown'"/>
                    </source>
                </xsl:otherwise>
            </xsl:choose>
            <local_id>
                <xsl:value-of select=".//rif:registryObject/rif:key[1]"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
            </url>
            <title>
                <xsl:value-of select=".//rif:name[@type='primary']/rif:namePart"/>
            </title>
            <authors_list>
                <xsl:for-each select=".//rif:citationMetadata/rif:contributor">
                    <xsl:value-of select="translate(.//rif:namePart,',',' ')"/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select=" ' , ' "/>
                    </xsl:if>
                </xsl:for-each>
            </authors_list>
            <xsl:if test=".//rif:identifier[@type='doi']">
                <doi>
                    <xsl:value-of select=".//rif:identifier[@type='doi']"/>
                </doi>
            </xsl:if>
            <xsl:if test=".//rif:licence">
                <licence>
                    <xsl:value-of select=".//rif:licence/@rightsUri"/>
                </licence>
            </xsl:if>
            <xsl:if test=".//rif:date[@type='publicationDate']">
                <publication_year>
                    <xsl:value-of select=".//rif:date[@type='publicationDate']"/>
                </publication_year>
            </xsl:if>
        </publication>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template                         -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="researcher">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:if test=".//rif:party/@type = 'person'">
            <xsl:apply-templates select=".//oai:metadata" mode="researcher">
                <xsl:with-param name="date-stamp" select="$date-stamp"/>
            </xsl:apply-templates>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="researcher">
        <xsl:param name="date-stamp"/>
        <xsl:variable name="forCode" select="substring-after(., ':')"/>
        <xsl:variable name="groupName" select=".//rif:registryObject/@group"/>
        <xsl:variable name="groupSource" select="$andsGroupList/root/row[group = $groupName]/source"/>
        
        <researcher>
            <key>
                <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:registryObject/rif:key)"/>
            </key>
            <source>
                <xsl:value-of select="$groupSource"/>
            </source>
            <local_id>
                <xsl:value-of select=".//rif:key"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <xsl:if test=".//rif:electronic[@type='url']/rif:value">
                <url>
                    <xsl:value-of select=".//rif:electronic[@type='url']/rif:value"/>
                </url>
            </xsl:if>
            <full_name>
                <xsl:choose>
                    <xsl:when test=".//rif:namePart[@type='title']">
                        <xsl:variable name="nameTitle" select=".//rif:namePart[@type='title']"/>
                        <xsl:value-of select="concat($nameTitle,' ',.//rif:namePart[@type='given'],' ',.//rif:namePart[@type='family'])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(.//rif:namePart[@type='given'],' ',.//rif:namePart[@type='family'])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </full_name>
            <first_name>
                <xsl:value-of select=".//rif:namePart[@type='given']"/>
            </first_name>
            <last_name>
                <xsl:value-of select=".//rif:namePart[@type='family']"/>
            </last_name>
            <xsl:if test=".//rif:identifier[@type='orcid']">
                <orcid>
                    <xsl:value-of select=".//rif:identifier[@type='orcid']"/>
                </orcid>
            </xsl:if>
        </researcher>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Related Object Template    `                                                 -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relatedObject">
        <xsl:for-each select=".//rif:relatedObject">
            <relation>
                <from_key>
                    <xsl:value-of select="concat('researchgraph.org/ands/',ancestor::rif:registryObject/rif:key)"/>
                </from_key>
                <to_uri>
                    <xsl:value-of select=".//rif:key"/>
                </to_uri>
                <label>
                    <xsl:value-of select=".//rif:relation/@type"/>
                </label>
            </relation>
        </xsl:for-each>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Related Info                                                                    -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relatedInfo"> 
        <xsl:for-each select=".//rif:relatedInfo">
            <xsl:if test=".//rif:identifier/@type='uri'
                or .//rif:identifier/@type='doi'
                or .//rif:identifier/@type='handle'
                or .//rif:identifier/@type='purl'
                or .//rif:identifier/@type='orcid'">
                <relation>
                    <from_key>
                        <xsl:value-of select="concat('researchgraph.org/ands/',ancestor::rif:registryObject/rif:key)"/>
                    </from_key>
                    <to_uri>
                        <xsl:value-of select=".//rif:identifier"/>
                    </to_uri>
                    <label>
                        <xsl:value-of select="'relatedTo'"/>
                    </label>
                </relation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- =========================================== -->
    <!--  ANZSRC Relation                                                                    -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relation"> 
        <xsl:for-each select=".//rif:subject[@type='anzsrc-for']">
            <relation>
                <from_key>
                    <xsl:value-of select="concat('researchgraph.org/ands/',ancestor::rif:registryObject/rif:key)"/>
                </from_key>
                <to_uri>
                    <xsl:value-of select="concat('http://purl.org/au-research/vocabulary/anzsrc-for/2008/',.)"/>
                </to_uri>
                <label>
                    <xsl:value-of select="'relatedTo'"/>
                </label>
            </relation>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>