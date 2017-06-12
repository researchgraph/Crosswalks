<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://exslt.org/math"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:ns0="http://vivoweb.org/ontology/core#"
    xmlns:ns1="http://my.domain.edu/ontlogy/researchgraph#"
    xmlns:ns2="http://purl.obolibrary.org/obo/"
    xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:bibo="http://purl.org/ontology/bibo/"
    xmlns:rg="http://researchgraph.org/schema/v2.0/xml/nodes"
    exclude-result-prefixes="rg"
    extension-element-prefixes="math"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration             					 -->
    <!-- =========================================== -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:variable name="uri1" select="'http://vivo.mydomain.edu/individual/n'"/>
    <xsl:variable name="randomNum" select="string(floor(math:random()*9999) mod 9999) + 1"/>
    <!-- =========================================== -->
    <!-- root Template                                                                            -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:ns0="http://vivoweb.org/ontology/core#"
            xmlns:ns1="http://my.domain.edu/ontlogy/researchgraph#"
            xmlns:ns2="http://purl.obolibrary.org/obo/"
            xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:bibo="http://purl.org/ontology/bibo/">
            <rdf:Description rdf:about="{concat($uri1,string(floor(math:random()*9999) mod 9999) + 1)}">
                <xsl:apply-templates select=".//rg:grant" mode="grant"/>
            </rdf:Description>
            <foaf:Person rdf:about="http://vivo.mydomain.edu/individual/n2278">
                <xsl:apply-templates select=".//rg:researcher" mode="researcher"/>
            </foaf:Person>
            <bibo:Article rdf:about="http://vivo.mydomain.edu/individual/n7284">
                <xsl:apply-templates select=".//rg:publication" mode="publication"/>
            </bibo:Article>
            <ns0:Dataset rdf:about="http://vivo.mydomain.edu/individual/n1405">
                <xsl:apply-templates select=".//rg:dataset" mode="dataset"/>
            </ns0:Dataset>
            <xsl:apply-templates select=".//rg:relation" mode="relationship"/>
        </rdf:RDF>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Description (grants) Template                                               -->
    <!-- =========================================== -->
     <xsl:template match="rg:grant" mode="grant">
         <rdfs:label>
             <xsl:value-of select=".//rg:title"/>
         </rdfs:label>
         <rdf:type rdf:resource="http://vivoweb.org/ontology/core#Grant"/>
         <ns0:dateTimeInterval>
             <ns0:DateTimeInterval rdf:about="{concat($uri1,string(floor(math:random()*9999) mod 9999) + 1)}">
                 <ns0:start>
                     <ns0:DateTimeValue rdf:about="{concat($uri1,string(floor(math:random()*9999) mod 9999) + 1)}">
                         <ns0:dateTimePrecision rdf:resource="http://vivoweb.org/ontology/core#yearPrecision"/>
                         <ns0:dateTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                             <xsl:value-of select="concat(.//rg:start_year,'-01-01T00:00:00')"/>
                         </ns0:dateTime>
                     </ns0:DateTimeValue>
                 </ns0:start>
                 
                 <ns0:end>
                     <ns0:DateTimeValue rdf:about="{concat($uri1,string(floor(math:random()*9999) mod 9999) + 1)}">
                         <ns0:dateTimePrecision rdf:resource="http://vivoweb.org/ontology/core#yearPrecision"/>
                         <ns0:dateTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                             <xsl:value-of select="concat(.//rg:end_year,'-01-01T00:00:00')"/>
                         </ns0:dateTime>
                     </ns0:DateTimeValue>
                 </ns0:end>
                 
             </ns0:DateTimeInterval>
         </ns0:dateTimeInterval>
         
         <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
             <xsl:value-of select=".//rg:key"/>
         </ns1:rgKey>
         <ns1:participantList>
             <xsl:value-of select=".//rg:participant_list"/>
         </ns1:participantList>
         <ns1:localId>
            <xsl:value-of select=".//rg:local_id"/>
         </ns1:localId>
         <ns1:lastUpdated rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
            <xsl:value-of select=".//rg:last_updated"/>
         </ns1:lastUpdated>
         <ns2:ARG_2000028>
             <vcard:Kind rdf:about="{concat($uri1,string(floor(math:random()*9999) mod 9999) + 1)}">
                 <vcard:hasURL>
                     <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n3568">
                         <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                            <xsl:value-of select=".//rg:url"/>
                         </vcard:url>
                         <rdfs:label>URL</rdfs:label>
                         <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</ns0:rank>
                     </vcard:URL>
                 </vcard:hasURL>
                 
                 <vcard:hasURL>
                     <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n3569">
                         <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                            <xsl:value-of select="concat('http://',.//rg:source)"/>
                         </vcard:url>
                         <rdfs:label>Source</rdfs:label>
                         <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#SourceUrl"/>
                         <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                     </vcard:URL>
                 </vcard:hasURL>
                 
                 <vcard:hasURL>
                     <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n3570">
                         <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                             <xsl:value-of select="concat('http://',.//rg:purl)"/>
                         </vcard:url>
                         <rdfs:label>PURL</rdfs:label>
                         <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#PurlUrl"/>
                         <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">3</ns0:rank>
                     </vcard:URL>
                 </vcard:hasURL>
                 
                 <vcard:hasURL>
                     <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n3571">
                         <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                             <xsl:value-of select="concat('http://',.//rg:funder)"/>
                         </vcard:url>
                         <rdfs:label>Funder</rdfs:label>
                         <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#FunderUrl"/>
                         <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">4</ns0:rank>
                     </vcard:URL>
                 </vcard:hasURL>
                 
                 <ns2:ARG_2000029 rdf:resource="http://vivo.mydomain.edu/individual/n5891"/>
             </vcard:Kind>
         </ns2:ARG_2000028>
     </xsl:template>
    
    <!-- =========================================== -->
    <!-- Person (researcher) Template                                              -->
    <!-- =========================================== -->
     <xsl:template match="rg:researcher" mode="researcher">
             <rdfs:label>
                 <xsl:value-of select="concat(.//rg:last_name,', ',.//rg:first_name)"/>
             </rdfs:label>
             <ns0:orcidId>
                 <owl:Thing rdf:about="{concat('http://',rg:orcid)}">
                     <ns0:confirmedOrcidId rdf:resource="http://vivo.mydomain.edu/individual/n2278"/>
                 </owl:Thing>
             </ns0:orcidId>
             
             <ns0:scopusId>
                 <xsl:value-of select=".//rg:scopus_author_id"/>
             </ns0:scopusId>
             <ns2:ARG_2000028>
                 <vcard:Kind rdf:about="http://vivo.mydomain.edu/individual/n6229">
                     <vcard:hasURL>
                         <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n4882">
                             <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                 <xsl:value-of select=".//rg:url"/>
                             </vcard:url>
                             <rdfs:label>URL</rdfs:label>
                             <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                         </vcard:URL>
                     </vcard:hasURL>
                     
                     <vcard:hasName>
                         <vcard:Name rdf:about="http://vivo.mydomain.edu/individual/n6714">
                             <vcard:givenName>
                                 <xsl:value-of select=".//rg:first_name"/>
                             </vcard:givenName>
                             <vcard:familyName>
                                 <xsl:value-of select=".//rg:last_name"/>
                             </vcard:familyName>
                         </vcard:Name>
                     </vcard:hasName>
                     
                     <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Individual"/>
                     <ns2:ARG_2000029 rdf:resource="http://vivo.mydomain.edu/individual/n2278"/>
                 </vcard:Kind>
             </ns2:ARG_2000028>
             
             <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                 <xsl:value-of  select="concat('http://',.//rg:key)"/>
             </ns1:rgKey>
             <ns1:localId>
                 <xsl:value-of select=".//rg:local_id"/>
             </ns1:localId>
     </xsl:template>
    
    <!-- =========================================== -->
    <!-- Article (publication) Template                                                 -->
    <!-- =========================================== -->
    <xsl:template match="rg:publication" mode="publication">
        <rdfs:label>
            <xsl:value-of select=".//rg:title"/>
        </rdfs:label>
        <ns0:dateTimeValue>
            <ns0:DateTimeValue rdf:about="http://vivo.mydomain.edu/individual/n7930">
                <ns0:dateTimePrecision rdf:resource="http://vivoweb.org/ontology/core#yearPrecision"/>
                <ns0:dateTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                    <xsl:value-of select="concat(.//rg:publication_year,'-01-01T00:00:00')"/>
                </ns0:dateTime>
            </ns0:DateTimeValue>
        </ns0:dateTimeValue>
        
        <bibo:doi>
            <xsl:value-of select=".//rg:doi"/>
        </bibo:doi>
        <ns2:ARG_2000028>
            <vcard:Kind rdf:about="http://vivo.mydomain.edu/individual/n1275">
                <vcard:hasURL>
                    <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n7833">
                        <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                            <xsl:value-of select=".//rg:url"/>
                        </vcard:url>
                        <rdfs:label>URL</rdfs:label>
                        <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                    </vcard:URL>
                </vcard:hasURL>
                
                <vcard:hasURL>
                    <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n6658">
                        <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                            <xsl:value-of select="concat('http://',.//rg:source)"/>
                        </vcard:url>
                        <rdfs:label>Source</rdfs:label>
                        <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#SourceUrl"/>
                        <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</ns0:rank>
                    </vcard:URL>
                </vcard:hasURL>
                
                <ns2:ARG_2000029 rdf:resource="http://vivo.mydomain.edu/individual/n7284"/>
            </vcard:Kind>
        </ns2:ARG_2000028>
        
        <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
            <xsl:value-of select="concat('http://',.//rg:key)"/>
        </ns1:rgKey>
        <ns1:localId>
            <xsl:value-of select=".//rg:local_id"/>
        </ns1:localId>
        <ns1:lastUpdated rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
            <xsl:value-of select=".//rg:last_updated"/>
        </ns1:lastUpdated>
        <ns1:authorsList>
            <xsl:value-of select=".//rg:authors_list"/>
        </ns1:authorsList>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Dataset Template                                                                     -->
    <!-- =========================================== -->
    <xsl:template match="rg:dataset" mode="dataset">
        <rdfs:label>
            <xsl:value-of select=".//rg:title"/>
        </rdfs:label>
        <ns0:dateTimeValue>
            <ns0:DateTimeValue rdf:about="http://vivo.mydomain.edu/individual/n2705">
                <ns0:dateTimePrecision rdf:resource="http://vivoweb.org/ontology/core#yearPrecision"/>
                <ns0:dateTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                    <xsl:value-of select="concat(.//rg:publication_year,'-01-01T00:00:00')"/>
                </ns0:dateTime>
            </ns0:DateTimeValue>
        </ns0:dateTimeValue>
        
        <bibo:doi>
            <xsl:value-of select=".//rg:doi"/>
            <ns2:ARG_2000028>
                <vcard:Kind rdf:about="http://vivo.mydomain.edu/individual/n3566">
                    <vcard:hasURL>
                        <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n798">
                            <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                <xsl:value-of select="concat('http://',.//rg:source)"/>
                            </vcard:url>
                            <rdfs:label>Source</rdfs:label>
                            <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#SourceUrl"/>
                            <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</ns0:rank>
                        </vcard:URL>
                    </vcard:hasURL>
                    
                    <vcard:hasURL>
                        <vcard:URL rdf:about="http://vivo.mydomain.edu/individual/n4617">
                            <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                <xsl:value-of select=".//rg:url"/>
                            </vcard:url>
                            <rdfs:label>URL</rdfs:label>
                            <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                        </vcard:URL>
                    </vcard:hasURL>
                    
                    <ns2:ARG_2000029 rdf:resource="http://vivo.mydomain.edu/individual/n1405"/>
                </vcard:Kind>
            </ns2:ARG_2000028>
            <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                <xsl:value-of select=".//rg:key"/>
            </ns1:rgKey>
            <ns1:localId>
                <xsl:value-of select=".//rg:local_id"/>
            </ns1:localId>
            <ns1:lastUpdated rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                <xsl:value-of select=".//rg:last_updated"/>
            </ns1:lastUpdated>
        </bibo:doi>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Relationship Template                                                            -->
    <!-- =========================================== -->
    <xsl:template match="rg:relation" mode="relationship">
        <ns0:Relationship rdf:about="http://vivo.mydomain.edu/individual/n4100">
            <rdfs:label>
                <xsl:value-of select=".//rg:label"/>
            </rdfs:label>
        </ns0:Relationship>
    </xsl:template>
</xsl:stylesheet>