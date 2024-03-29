<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://researchgraph.org/schema/v2.0/xml/nodes"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    exclude-result-prefixes="xs"
    version="2.0">
     
   <!-- <xsl:message>This is my study xls file.</xsl:message>    
        
    
<! =========================================== -->
<!-- Configuration                               -->
<!-- =========================================== -->
    <xsl:param name="source" select="'nci.org.au'"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
<!-- =========================================== -->
<!-- RegistryObjects (root) Template             -->
<!-- =========================================== -->
    <xsl:template match="/"> 
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <datasets>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="dataset"/>
            </datasets>

            <researchers>
                <xsl:if test=".//gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner'] or
                    .//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='custodian']">
                    
                        <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="researcher"/>
                    
                </xsl:if>
            </researchers>
            <!--<publications>
                <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="publication"/>
            </publications> -->          
           <relations>
               <xsl:if test=".//gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner'] or
                   .//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='custodian']">
                   
                   <xsl:apply-templates select="oai:OAI-PMH/*/oai:record" mode="relation"/>
                   
               </xsl:if>
            </relations>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                            -->
    <!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="dataset">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:apply-templates select=".//oai:metadata" mode="dataset">
            <xsl:with-param name="date-stamp" select="$date-stamp"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="dataset">
        <xsl:param name="date-stamp"/>
        <xsl:param name="local_id">
            <xsl:value-of select=".//*/gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>
        <dataset>
            <key>
                <xsl:value-of select="concat('researchgraph.org/nci/',$local_id)"/>
            </key>
            <source>
                <xsl:value-of select="$source"/>
            </source>
            <local_id>
                <xsl:value-of select="$local_id"/>
            </local_id>
            <last_updated>
                <xsl:value-of select="$date-stamp"/>
            </last_updated>
            <url>
                <xsl:value-of select="concat('pid.nci.org.au/',$local_id)"/>
            </url>
            <title>
                <xsl:value-of select=".//*/gmd:title/gco:CharacterString"/>
            </title>
            <xsl:if test="not(.//*/gmd:dataSetURI/@gco:nilReason='missing')">
            <doi>
                <xsl:value-of select=".//*/gmd:dataSetURI/gco:CharacterString"/>
            </doi>
            </xsl:if>
            <publication_year>
                <xsl:value-of select="year-from-date(.//*/gmd:CI_Date/gmd:date/gco:Date)"/>
            </publication_year>
        </dataset>
    </xsl:template>


<!-- =========================================== -->
<!-- Researcher Template                            -->
<!-- =========================================== -->
    <xsl:template match="oai:OAI-PMH/*/oai:record" mode="researcher">
        <xsl:param name="date-stamp">
            <xsl:value-of select=".//oai:datestamp"/>
        </xsl:param>
        <xsl:apply-templates select=".//oai:metadata" mode="researcher">
            <xsl:with-param name="date-stamp" select="$date-stamp"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="oai:metadata" mode="researcher">
        <xsl:param name="date-stamp"/>
        <xsl:for-each select=".//gmd:MD_Metadata">     
       <xsl:for-each select="gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName">
                <researcher>
                    <key>
                        <xsl:value-of select="concat('researchgraph.org/nci/',../gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString)"/>
                    </key>
                   <source>
                        <xsl:value-of select="$source"/>
                    </source>
                    <local_id>
                        <xsl:value-of select="../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
                    </local_id>
                    <last_updated>
                        <xsl:value-of select="$date-stamp"/>
                    </last_updated>
                    <url>
                        <xsl:value-of select="../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
                    </url>
                    <full_name> 
                        <xsl:value-of select="normalize-space(.)"/>
                    </full_name>
                    <xsl:choose>
                        <xsl:when test="(../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString='ORCID')">
                        <orcid>
                            <xsl:value-of select="../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
                        </orcid>
                        </xsl:when>
                    </xsl:choose>
                </researcher>
            </xsl:for-each>  
        
        
            <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName">
       		<researcher>
       		    <key>
       		        <xsl:value-of select="concat('researchgraph.org/nci/',../gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString)"/>
       		    </key>
       		    <source>
       		        <xsl:value-of select="$source"/>
       		    </source>
       		    <local_id>
       		        <xsl:value-of select="../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
       		    </local_id>
       		    <last_updated>
       		        <xsl:value-of select="$date-stamp"/>
       		    </last_updated>
       		    <url>
       		        <xsl:value-of select="../gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
       		    </url>
        		<full_name> 
                	<xsl:value-of select="normalize-space(.)"/>
        		</full_name>
      		</researcher>
       	    </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
   
<!-- =========================================== -->
<!-- Publication Template                            -->
<!-- =========================================== -->
<!--<xsl:template match="oai:OAI-PMH/*/oai:record" mode="publication">
    <xsl:apply-templates select=".//oai:metadata" mode="publication"/>
</xsl:template>

<xsl:template match="oai:metadata" mode="publication">
    <publication>
        <xsl:if test="(.//*/gmd:online/gmd:CI_OnlineResource/gmd:description/gco:CharacterString='Paper describing data')">
            <key>
                <xsl:value-of select=".//*/gmd:online/gmd:CI_OnlineResource/gmd:linkage/gmd:linkage"/>
        </key>
        </xsl:if>
        <source>
            <xsl:value-of select="$source"/>
        </source>
        <local_id>
            <xsl:value-of select=".//*/gmd:online/gmd:CI_OnlineResource/gmd:linkage/gmd:linkage"/>
        </local_id>
        <last_updated>
            <xsl:value-of select=".//oai:datestamp"/>
        </last_updated>
        <url>
            <xsl:value-of select=".//*/gmd:online/gmd:CI_OnlineResource/gmd:linkage/gmd:linkage"/>
        </url>
        <title>
            <xsl:value-of select="//*/gmd:online/gmd:CI_OnlineResource/gmd:name"/>
        </title>
        <authors_list>
            <xsl:value-of select="//*/gmd:online/gmd:CI_OnlineResource/gmd:name"/>
        </authors_list>
        <doi>
             <xsl:value-of select="//*/gmd:online/gmd:CI_OnlineResource/gmd:linkage"/>
        </doi>   
    </publication>
  
</xsl:template>-->
    
    <!-- =========================================== -->
    <!-- Relation Template                            -->
    <!-- =========================================== -->
         
 <xsl:template match="oai:OAI-PMH/*/oai:record" mode="relation">
     <xsl:param name="date-stamp">
         <xsl:value-of select=".//oai:datestamp"/>
     </xsl:param>
     <xsl:apply-templates select=".//oai:metadata" mode="relation">
         <xsl:with-param name="date-stamp" select="$date-stamp"/>
     </xsl:apply-templates>
         </xsl:template>
    
    <xsl:template match="oai:metadata" mode="relation">
        <xsl:param name="local_id">
                <xsl:value-of select=".//*/gmd:fileIdentifier/gco:CharacterString"/>
            </xsl:param>
        <xsl:for-each select=".//gmd:MD_Metadata">     
            <xsl:for-each select="gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName">
        <relation>       
            <from_key>
                <xsl:value-of select="concat('researchgraph.org/nci/',$local_id)"/>
            </from_key>
            <to_url>
                <xsl:value-of select="concat('researchgraph.org/nci/',../gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString)"/>
            </to_url>
        </relation>   
            </xsl:for-each>  
            
            <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName">
                <relation>       
                    <from_key>
                        <xsl:value-of select="concat('researchgraph.org/nci/',$local_id)"/>
                    </from_key>
                    <to_url>
                        <xsl:value-of select="concat('researchgraph.org/nci/',../gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString)"/>
                    </to_url>
                </relation>  
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
