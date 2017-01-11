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
   <xsl:variable name="andsGroupList" select="document('ands_group.xml')"/>
   
   <!-- =========================================== -->
   <!-- RegistryObjects (root) Template             -->
   <!-- =========================================== -->
   
   <xsl:template match="/">
      <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
         https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
         <grants>
            <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="grant"/>
         </grants>
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
         <founder>
            <xsl:value-of select="$groupSource"/>
         </founder>
      </grant>
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
                  <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:key)"/>
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
            or .//rif:identifier/@type='purl'">
            <relation>
               <from_key>
                  <xsl:value-of select="concat('researchgraph.org/ands/',ancestor::rif:registryObject/rif:key)"/>
               </from_key>
               <to_url>
                  <xsl:value-of select="concat('researchgraph.org/ands/',.//rif:identifier)"/>
               </to_url>
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
            <to_url>
               <xsl:value-of select="concat('researchgraph.org/ands/',.)"/>
            </to_url>
         </relation>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>