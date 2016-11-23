#Crosswalk figshare:RDF to R.XML
This is the crosswalk between figshare RDF files and Research Graph XML schema. 

##Node type
We map the figshare records to four main research graph types using the ```<setSpec>``` in the headers as follows:

* image (```item_type_1```) --> **Dataset** 
* media (```item_type_2```) --> **Dataset** 
* dataset (```item_type_3```) --> **Dataset**  
* fileset (```item_type_4```) --> **Dataset**  
* poster (```item_type_5```) --> **Publication**  
* paper (```item_type_6``) --> **Publication**  
* presentation (```item_type_7``) --> **Publication**  
* thesis (```item_type_8``) --> **Publication**  
* code (```item_type_9``) --> **Dataset**  
* metadata (```item_type_11``) --> **Dataset**  

Note: In this crosswalk, we have types *code* and *metadata* that do not match directly to Research Graph types. For the simplicity at this stage, we are mapping these fields to the type **Dataset**. A further revision in this area is required to accommodate these types.


###Example
For example the following record from figshare is a dataset as the header contains ```   <setSpec>item_type_1</setSpec>```

**Title:** Pal is an essential outer membrane protein, associated with the BAM complex.

**DOI:** 10.1371/journal.pone.0008619.g004

**URL:** <https://api.figshare.com/v2/oai?verb=GetRecord&metadataPrefix=rdf&identifier=oai:figshare.com:article/539255>

```

<?xml version='1.0' encoding='utf-8'?>
<?xml-stylesheet type="text/xsl" href="/v2/static/oai2.xsl"?>
<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
  <responseDate>2016-11-23T05:23:23Z</responseDate>
  <request identifier="oai:figshare.com:article/539255" metadataPrefix="rdf" verb="GetRecord">https://api.figshare.com/v2/oai</request>
  <GetRecord>
    <record>
      <header>
        <identifier>oai:figshare.com:article/539255</identifier>
        <datestamp>2010-01-08T02:34:22Z</datestamp>
        <setSpec>category_12</setSpec>
        <setSpec>category_4</setSpec>
        <setSpec>portal_5</setSpec>
        <setSpec>item_type_1</setSpec>
      </header>
      <metadata>
        <rdf:RDF xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:datacite="http://purl.org/spar/datacite/" xmlns:dc="http://purl.org/dc/terms/" xmlns:fabio="http://purl.org/spar/fabio/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:literal="http://www.essepuntato.it/2010/06/literalreification/" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vcard="http://www.w3.org/2006/vcard/ns#" xmlns:vivo="http://vivoweb.org/ontology/core#">
          <bibo:Image rdf:about="https://figshare.com/articles/Pal_is_an_essential_outer_membrane_protein_associated_with_the_BAM_complex_/539255">
            <bibo:doi>10.1371/journal.pone.0008619.g004</bibo:doi>
            <rdfs:label>Pal is an essential outer membrane protein, associated with the BAM complex.</rdfs:label>
            <vivo:datePublished rdf:resource="http://openvivo.org/a/date2010-01-08"/>
            <vivo:dateModified rdf:resource="http://openvivo.org/a/date2010-01-08"/>
            <vivo:dateCreated rdf:resource="http://openvivo.org/a/date2010-01-08"/>
            <bibo:abstract>&lt;p&gt;(A) BAM complex was immunoprecipitated using BamA antiserum added to outer membrane vesicles that were solubilised with 0.75% (w/v) (Lane 1) and 2.25% (w/v) (Lane 2) dodecyl-maltoside. Immunoprecipitate obtained with preimmune serum was loaded in Lane 3. Asterisks indicate the IgG heavy and light chains, with the migration positions of the molecular markers shown in kDa. (B) Cells with the &lt;i&gt;pal&lt;/i&gt; gene under the control of a xylose-inducible promoter (↓ &lt;i&gt;pal&lt;/i&gt;) were grown in the presence (right montage) and absence (left montage) of xylose (0.3% [w/v]) for 10 hrs. Outer membrane blebs that form predominantly from the division site or cell poles are evident only in the Pal-depleted cells. Scale bars (white) represent 1 micrometer. (C) Membranes were fractionated on sucrose gradient and analysed by SDS-PAGE. Coomassie Brilliant Blue staining (upper panel) reveals separation of the membrane protein profiles and immunoblotting (lower panel) for the inner membrane protein TimA and the outer membrane protein BamA, and the mCherry epitope to determine the location of Pal.&lt;/p&gt;</bibo:abstract>
            <bibo:freetextKeyword>membrane</bibo:freetextKeyword>
            <bibo:freetextKeyword>BAM</bibo:freetextKeyword>
            <dc:rights>CC-BY</dc:rights>
          </bibo:Image>
           ...
       </rdf:RDF>
      </metadata>
    </record>
  </GetRecord>
</OAI-PMH>


```
