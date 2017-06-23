<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gml="http://graphml.graphdrawing.org/xmlns"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- =========================================== -->
    <!-- Configuration             					 -->
    <!-- =========================================== -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:variable name="source" select="'http://vivo.mydomain.edu/individual/n'"/>
    
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
<!--            <xsl:apply-templates select=".//rg:grants" mode="grant"/>-->
            <xsl:apply-templates select=".//gml:node[gml:data[@key='type']='researcher']" mode="researcher"/>
            <xsl:apply-templates select=".//gml:node[gml:data[@key='type']='publication']" mode="publication"/>
<!--            <xsl:apply-templates select=".//rg:datasets" mode="dataset"/>-->
<!--            <xsl:apply-templates select=".//rg:relations" mode="relationship"/>-->
        </rdf:RDF>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Person (researcher) Template                                              -->
    <!-- =========================================== -->
    <xsl:template match="gml:node[gml:data[@key='type']='researcher']" mode="researcher">
        <foaf:Person rdf:about="{concat($source,.//gml:data[@key='local_id'])}">
            <rdfs:label>
                <xsl:value-of select="concat(.//gml:data[@key='first_name'],', ',.//gml:data[@key='first_name'])"/>
            </rdfs:label>
            <ns0:orcidId>
                <xsl:choose>
                    <xsl:when test="contains(.//gml:data[@key='url'],'orcid.org')">
                        <owl:Thing rdf:about="{concat('http://',.//gml:data[@key='url'])}">
                            <ns0:confirmedOrcidId rdf:resource="{concat($source,.//gml:data[@key='local_id'])}"/>
                        </owl:Thing>
                    </xsl:when>
                    <xsl:otherwise>
                        <owl:Thing rdf:about="{'orcid'}">
                            <ns0:confirmedOrcidId rdf:resource="{'orcid'}"/>
                        </owl:Thing>
                    </xsl:otherwise>
                </xsl:choose>
            </ns0:orcidId>
            
           <!-- <ns0:scopusId>
                <xsl:value-of select=".//rg:scopus_author_id"/>
            </ns0:scopusId>-->
            <ns2:ARG_2000028>
                <vcard:Kind rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                    <vcard:hasURL>
                        <vcard:URL rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                            <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                <xsl:value-of select=".//gml:data[@key='url']"/>
                            </vcard:url>
                            <rdfs:label>URL</rdfs:label>
                            <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                        </vcard:URL>
                    </vcard:hasURL>
                    
                    <vcard:hasName>
                        <vcard:Name rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                            <vcard:givenName>
                                <xsl:value-of select=".//gml:data[@key='first_name']"/>
                            </vcard:givenName>
                            <vcard:familyName>
                                <xsl:value-of select=".//gml:data[@key='last_name']"/>
                            </vcard:familyName>
                        </vcard:Name>
                    </vcard:hasName>
                    
                    <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Individual"/>
                    <ns2:ARG_2000029 rdf:resource="{concat($source,.//gml:data[@key='local_id'])}"/>
                </vcard:Kind>
            </ns2:ARG_2000028>
            
            <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                <xsl:value-of  select="concat('http://',.//gml:data[@key='key'])"/>
            </ns1:rgKey>
            <ns1:localId>
                <xsl:value-of select=".//gml:data[@key='local_id']"/>
            </ns1:localId>
        </foaf:Person>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Article (publication) Template                                                 -->
    <!-- =========================================== -->
    <xsl:template match="gml:node[gml:data[@key='type']='publication']" mode="publication">
        <bibo:Article rdf:about="{concat($source,.//gml:data[@key='local_id'])}">
            <rdfs:label>
                <xsl:value-of select=".//gml:data[@key='title']"/>
            </rdfs:label>
            <ns0:dateTimeValue>
                <ns0:DateTimeValue rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                    <ns0:dateTimePrecision rdf:resource="http://vivoweb.org/ontology/core#yearPrecision"/>
                    <ns0:dateTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                        <xsl:value-of select=".//gml:data[@key='publication_year']"/>
                    </ns0:dateTime>
                </ns0:DateTimeValue>
            </ns0:dateTimeValue>
            
            <bibo:doi>
                <xsl:value-of select=".//.//gml:data[@key='doi']"/>
            </bibo:doi>
            <ns2:ARG_2000028>
                <vcard:Kind rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                    <vcard:hasURL>
                        <vcard:URL rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                            <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                <xsl:value-of select="concat('https://www.doi.org/',.//gml:data[@key='doi'])"/>
                            </vcard:url>
                            <rdfs:label>URL</rdfs:label>
                            <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">2</ns0:rank>
                        </vcard:URL>
                    </vcard:hasURL>
                    
                    <vcard:hasURL>
                        <vcard:URL rdf:about="{concat($source,string(floor(math:random()*9998) mod 8998 + 1001),string(floor(math:random()*9998) mod 8998 + 1001))}">
                            <vcard:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                                <xsl:value-of select="concat('http://',.//gml:data[@key='source'])"/>
                            </vcard:url>
                            <rdfs:label>Source</rdfs:label>
                            <rdf:type rdf:resource="http://my.domain.edu/ontlogy/researchgraph#SourceUrl"/>
                            <ns0:rank rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</ns0:rank>
                        </vcard:URL>
                    </vcard:hasURL>
                    
                    <ns2:ARG_2000029 rdf:resource="{concat($source,.//gml:data[@key='local_id'])}"/>
                </vcard:Kind>
            </ns2:ARG_2000028>
            
            <ns1:rgKey rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
                <xsl:value-of select="concat('http://',.//gml:data[@key='key'])"/>
            </ns1:rgKey>
            <ns1:localId>
                <xsl:value-of select=".//gml:data[@key='local_id']"/>
            </ns1:localId>
            <ns1:lastUpdated rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                <xsl:value-of select=".//gml:data[@key='last_updated']"/>
            </ns1:lastUpdated>
            <ns1:authorsList>
                <xsl:value-of select=".//gml:data[@key='authors_list']"/>
            </ns1:authorsList>
        </bibo:Article>
    </xsl:template>
</xsl:stylesheet>