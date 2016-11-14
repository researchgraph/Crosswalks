import json
import dicttoxml
import urllib

url = "https://raw.githubusercontent.com/researchgraph/Crosswalks/master/orcid.org/sample-input-json/0000-0002-4259-9774.json"
response = urllib.urlopen(url)
jsonData = json.loads(response.read())
xml = dicttoxml.dicttoxml(jsonData)

xml_file = open("Output.xml","w")
xml_file.write(xml)
xml_file.close()