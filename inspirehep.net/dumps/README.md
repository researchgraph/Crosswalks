# Crosswalk
Crosswalk of the main fields from the **HEP-records.xml** file available at
http://inspirehep.net/dumps/inspire-dump.html

Supporting Doc: https://twiki.cern.ch/twiki/bin/view/Inspire/DevelopmentRecordMarkup#Literature_MARC


##Publication

Example:

```
<datafield tag="909" ind1="C" ind2="O">
    <subfield code="o">oai:inspirehep.net:92</subfield>
    <subfield code="p">INSPIRE:HEP</subfield>
</datafield>   
```

### local_id: 
When @tag='909' and subfield='INSPIRE:HEP'

	substring-after( subfield[@code='o'] ,'oai:inspirehep.net:')

### key:

```researchgrapg.org/inspirehep/publication``` + local_id

Example

- local_id=```publication/92```
- key = ```researchgraph.org/inspirehep/publication/92```


###title:

```<xsl:value-of select=".//datafield[@tag='245']/subfield[@code='a']"/>```


###url:
```https://inspirehep.net/record/``` + local_id

Example: 

- url = ```https://inspirehep.net/record/92```


##Researcher

Example:

```
  <datafield tag="700" ind1=" " ind2=" ">
    <subfield code="a">Torzewski, Daniel F.</subfield>
    <subfield code="u">Chicago U., EFI</subfield>
    <subfield code="w">D.F.Torzewski.1</subfield>
    <subfield code="y">0</subfield>
    <subfield code="z">902730</subfield>
  </datafield>
```

###local_id:
```
<xsl:for-each select="./datafield[@tag='700'][subfield[@code='w']]
| ./datafield[@tag='100'][subfield[@code='w']]">
```

###key:
```researchgrapg.org/inspirehep/researcher``` + local_id

Example: 

- local_id=```D.F.Torzewski.1```
- key = ```researchgraph.org/inspirehep/researcher/D.F.Torzewski.1```

###url:
```Http://inspirehep.net/author/profile/``` + local_id

Example: 

- url= ```http://inspirehep.net/author/profile/H.Schlereth.1```


##Relations

###from_key:
- publication.key

###to_uri:
- researcher.key

###label:
- "relatedTo"
