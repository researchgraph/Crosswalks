Please refer to the following link for the Switchboard code for MARCXML crosswalk:
https://github.com/rd-switchboard/Inference/blob/master/Libraries/Marc21/crosswalk_marc21/src/main/java/org/rdswitchboard/libraries/marc21/CrosswalkMarc21.java

InspireHEP HowTo help about MarcXSML:
https://inspirehep.net/help/admin/howto-marc

Basic graph elements:

* local_id is the value of tag="035" and code="a" when code="9" value is "Inspire"

* key is researchgraph.org/inspirehep/{local_id} for articles

* url is https://inspirehep.net/record/{local_id}