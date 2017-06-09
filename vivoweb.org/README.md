# Representing ResearchGraph in VIVO

A portion of ResearchGraph will be represented as RDF triples using VIVO and associated ontologies, and using a small additional ResearchGraph ontology to represent elements not normally represented in VIVO.

In what follows, the ResearchGraph ontology is represented by the prefix “researchgraph:”  It will have a URL to be determined during the hosting work.  When the host system is prepared, Conlon will create the required Research Graph ontology, the URL will be determined, and the ontology will be exported from the host system for documentation purposes.

The following entities will be created for the ResearchGraph Ontology:

* researchgraph:rgkey is the key used internally in Research Graph to represent entities. It is a data property containing a URI.
* researchgraph:SourceURL is a sub-class of vcard:URL that indicates a vcard URL is a SourceURL.
* researchgraph:localId is a data property that associates an entity with an identifier string used at the entity’s institution to identify the entity.
* researchgraph:lastUpdated is a data property that associates a datetime value of last update for the entity
* researchgraph:toUri is a data property for an external Uri referred to by a relation.
* researchgraph:LicenseURL is a sub-class of vcard:URL to indicate that a URL points at a license on the web.
* researchgraph:megabyte is a data property used to associate the decimal value of the dataset size in megabytes with the dataset entity.
* researchgraph:participantList is a data property containing a string of grant participant names.
* researchgraph:PurlURL is a sub-class of vcard:URL used to distinguish purl URLs from other URLs.
* researchgraph:FunderURL is a sub-class of vcard:URL used to distinguish funder URLs from other URLs.
* researchgraph:authorsList is a data property containing a string of publication author names.
* researchgraph:scopusEid is a data property to contain the Scopus EID of the article.

## Representing Researchers

To represent ResearchGraph researchers, each researcher will be a foaf:Person with attributes associated to the foaf:Person uri.

### Researcher entity 

Researcher is an entity of rdfs:type foaf:Person.  The researcher has a URI that identifies the researcher on the Semantic Web and provides access to triples regarding the researcher.  All subsequent assertions regarding the researcher use the researcherUri to identify the researcher.

researcherUri rdf:type foaf:Person .

### key

Key is a data property used within the ResearchGraph system to identify the researcher.

researcherUri researchgraph:rgKey xsd:anyUri .

### source

A Uri indicating the system or institution or process that provided the researcher data.  A URL type researchgraph:sourceURL distinguishes the sourceURL from other Uri associated with the researcher.

researcherUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardUrlUri a researchgraph:SourceURL .
vcardUrlUri vcard:url xsd:anyUri .

### local_id

The local_id identifies the researcher at the research’s home institution.  ResearchGraph provides recommended structure for the local_id string.

localId is planned for inclusion in VIVO 1.10 (summer 2017).

researcherUri researchgraph:localId xsd:string .

### last_updated

In VIVO, datetime values are entities with their own URI.  Each has a precision indicating how much of the datetime value is considered accurate (in publishing often only the year or only the year and the month are accurate).

researcherUri researchgraph:lastUpdated datetimeUri .
dateTimeUri a vivo:DateTimeValue .
dateTimeUri vivo:dateTimePrecision vivo:yearMonthDayPrecision .
dateTimeUri vivo:dateTime xsd:datetime .

### url

The researcher Url is stored using the vcard representation.

researcherUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a vcard:URL .
vcardURLUri vcard:url xsd:anyUri

### full_name

Typically “name to be displayed” as the researcher would prefer.  May include any text.  Name parts are separately modeled using vcard, see below.

researcherUri rdfs:label xsd:string .

### first_name

Name part.  Vcard Given name.

researcherUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasName vcardNameUri .
vcardNameUri a vcard:Name .
vcardNameUri vcard:givenName xsd:string .


### last_name

Name part.  Vcard Family name.

researcherUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasName vcardNameUri .
vcardNameUri a vcard:Name .
vcardNameUri vcard:familyName xsd:string .

### orcid

Resolvable Uri format of ORCiD identifier. Example: http://orcid.org/0000-1111-2222-3333.

researcherUri vivo:orcid xsd:anyUri .

### scopus_author_id

Simple string value for Scopus author ID.

researcherUri vivo:scopusId xsd:string .

## Representing Relations

In ResearchGraph, relations can connect any two entities.  In VIVO, a relation is an entity with attributes.  The attributes will contain custom data properties to simplify representation.

### Relation Entity

The relation is a uni-directional connection between entities.  The relation itself is an entity with its own URI.  In VIVO, connections between entities are called Relationships.

relationUri rdf:type vivo:Relationship .

### from_key

from_key is modeled using vivo:relates and vivo:relatedBy, associating the entity to the relationship.

relationUri vivo:relates entityUri .

### to_uri

The two Uri may be either internal or external.  As an internal reference, it is an object property.  As an external reference it is a data property.  Two predicates are needed for VIVO, not to represent internal references and one to represent external references.  VIVO expects to be able to render internal references as web pages.  It expects to visit external references as web links.

For internal references use vivo:relates:

relationUri vivo:relates entityuri .

For external references, use researchgraph:toUri:

relationUri researchgraph:toUri xsd:anyUri .

### label

relationUri rdfs:label xsd:langString .

### Example

A relation will typically have four assertions:

relationUri rdf:type vivo:Relationship .
relationuri rdfs:label “some string goes here”@en .
relationUri researchgraph:fromKey internal_key_value .
relationUri researchgraph:toUri external_uri_value .

## Representing Datasets

To represent datasets using VIVO, each dataset will have a VIVO Uri with attributes associated with that Uri.

### Dataset entity

The dataset entity is represent via a type assertion on the datasetUri:

datasetUri rdf:type bibo:dataset .

### key

Key is a string used within the ResearchGraph system to identify the dataset.

datasetUri researchgraph:rgKey xsd:anyUri .

### source

A Uri indicating the system or institution or process that provided the dataset.  Uri in VIVO are implemented using vcard.  A URL type researchgraph:sourceURL distinguishes the sourceURL from other Uri associated with the researcher.

datasetUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardUrlUri a researchgraph:SourceURL .
vcardUrlUri vcard:url xsd:anyUri .

### local_id

The local_id identifies the dataset at the datasets’s home institution.  ResearchGraph provides recommended structure for the local_id string.

datasetUri researchgraph:localId xsd:string .

### last_updated

In VIVO, datetime values are entities with URI.  Each has a precision indicating how much of the daytime value is considered accurate (in publishing often only the year or only the year and the month are accurate).

last_updated has been discussed for inclusion in the VIVO ontology for future releases.  An alternative is to the use PROV ontology.

datasetUri researchgraph:lastUpdated datetimeUri .
dateTimeUri a vivo:DateTimeValue .
dateTimeUri vivo:dateTimePrecision vivo:yearMonthDayPrecision .
dateTimeUri vivo:dateTime xsd:datetime .

### url

The dataset Url is stored using the vcard representation. Subtyping the URL is often desirable to precisely identify the purpose of the URL and to find URLs of a particular type (Social media types, home pages, Google Scholar, etc)

datasetUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a vcard:URL .
vcardURLUri vcard:url xsd:anyUri .

### title

Dataset title is asserted with rdfs:label

datasetUri rdfs:label xsd:langString .

### doi

Dataset doi is asserted with bibo:doi.

datasetUri bibo:doi xsd:string .

### publication_year

publication year is specified with vivo:dateTimeValue.  Year entities can be created as a collection and referenced by all other entities.

datasetUri vivo:dateTimeValue datetimeUri .
dateTimeValueUri a vivo:DateTimeValue .
dateTimeValueUri vivo:dateTimePrecision vivo:yearPrecision .
dateTimeValueUri vivo:dateTime xsd:datetime .

### license

License is a particular kind of URL.  researchgraph:LicenseURL is introduced as a type to distinguish this kind of URL from other kinds of URL.

datasetUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a researchgraph:LicenseURL .
vcardURLUri vcard:url xsd:anyUri .

### megabyte

The researchgraph:megabyte data property is used to store the megabyte value and associate it with the dataset entity.

datasetUri researchgraph:megabyte xsd:decimal .

## Representing Grants

To represent ResearchGraph grants using VIVO, each grant will have a VIVO Uri with attributes associated with that Uri.


### Grant entity

The grant entity is represent a grant via a type assertion on the grantUri:

grantUri rdf:type vivo:Grant .

### key

Key is a string used within the ResearchGraph system to identify the grant.  See Researcher entity

grantUri researchgraph:rgKey xsd:anyUri .

### source

A Uri indicating the system or institution or process that was awarded the grant.  Uri in VIVO are implemented using vcard.  a URL type researchgraph:sourceURL distinguishes the sourceURL from other Uri associated with the researcher.

grantUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardUrlUri a researchgraph:SourceURL .
vcardUrlUri vcard:url xsd:anyUri .

### local_id

The local_id identifies the grant at the grant’s home institution.  ResearchGraph provides recommended structure for the local_id string.

grantUri researchgraph:localId xsd:string .

### last_updated

In VIVO, datetime values are entities with URI.  Each has a precision indicating how much of the daytime value is considered accurate (in publishing often only the year or only the year and the month are accurate).

grantUri researchgraph:lastUpdated datetimeUri .
dateTimeUri a vivo:DateTimeValue .
dateTimeUri vivo:dateTimePrecision vivo:yearMonthDayPrecision .
dateTimeUri vivo:dateTime xsd:datetime .

### url

The grant Url is stored using the vcard representation. Subtyping the URL is often desirable to precisely identify the purpose of the URL and to find URLs of a particular type (Social media types, home pages, Google Scholar, etc)

datasetUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a vcard:URL .
vcardURLUri vcard:url xsd:anyUri .

### title

grant title is asserted with rdfs:label

grantUri rdfs:label xsd:langString .

### purl

Research grants from ARC and NHMRC may have purls.  They are represented with a URL that has the purlURL type.

grantUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a researchgraph:purlURL .
vcardURLUri vcard:url xsd:anyUri .

### participant_list

The participant_list is stored in the VIVO data property researchgraph:participantList associated with the grant entity.

grantor researchgraph:participantList xsd:anyString .

### funder

URLs for funders are represented with the FunderURL type.

grantUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a researchgraph:FunderURL .
vcardURLUri vcard:url xsd:anyUri .

### start_year
### end_year

start and end year are presented using a vivo:dateTimeInterval. either end of the interval may be open.

grantUri vivo:dateTimeInterval dtiuri .
dtiuri a vivo:DateTimeInterval .
dtiuri vivo:start starturi .
dtiuri vivo:end enduri .

The start and end uri refer to year precision datetimeValue entities which should be created for use by all Research Graph entities.  See dataset / publication_year for an example of creating VIVO datetimeVlaues.

## Representing Publications

To represent ResearchGraph publications using VIVO, each publication will have a VIVO Uri with attributes associated with that Uri.

### Publication entity

The publication entity represents a publication via a type assertion on the publicationUri.

publicationUri rdf:type bibo:Article .

### key

Key is a string used within the ResearchGraph system to identify the publication.  See Researcher entity

publicationUri researchgraph:rgKey xsd:anyUri .

### source

A Uri indicating the system or institution or process that was awarded the publication.  Uri in VIVO are implemented using vcard.  a URL type researchgraph:sourceURL distinguishes the sourceURL from other Uri associated with the researcher.

publicationUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardUrlUri a researchgraph:SourceURL .
vcardUrlUri vcard:url xsd:anyUri .

### local_id

The local_id identifies the publication at the publications’s home institution.  ResearchGraph provides recommended structure for the local_id string.

publicationUri researchgraph:localId xsd:string .

### last_updated

In VIVO, datetime values are entities with URI.  Each has a precision indicating how much of the daytime value is considered accurate (in publishing often only the year or only the year and the month are accurate).

publicationUri researchgraph:lastUpdated datetimeUri .
dateTimeUri a vivo:DateTimeValue .
dateTimeUri vivo:dateTimePrecision vivo:yearMonthDayPrecision .
dateTimeUri vivo:dateTime xsd:datetime .

### url

The publication Url is stored using the vcard representation. Subtyping the URL is often desirable to precisely identify the purpose of the URL and to find URLs of a particular type (Social media types, home pages, Google Scholar, etc)

datasetUri obo:ARG_2000028 vcardUri .
vcarduri a vcard:Kind .
vcardUri vcard:hasURL vcardUrlUri .
vcardURLUri a vcard:URL .
vcardURLUri vcard:url xsd:anyUri .

### title

publication title is asserted with rdfs:label

publicationUri rdfs:label xsd:langString .

### authors_list

The authors list is a string of author names separated by commas.  It is stored in the authorList data property.

publicationUri researchgraph:authors_list xsd:string .

### doi

publication doi is asserted with bibo:doi

publicationUri bibo:doi xsd:string .

### publication_year

publication year is specified with vivo:dateTimeValue.  Year entities can be created as a collection and referenced by all other entities.

publicationUri vivo:dateTimeValue datetimeUri .
dateTimeValueUri a vivo:DateTimeValue .
dateTimeValueUri vivo:dateTimePrecision vivo:yearPrecision .
dateTimeValueUri vivo:dateTime xsd:datetime .

### scopus_eid

scopus_eid is asserted with researchgraph:scopusEid

publicationUri researchgraph:scopusEid .









