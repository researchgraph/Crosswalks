import json
import dicttoxml
import os, subprocess
import sys

for file in os.listdir("."):
	if file.endswith('.json'):
		with open(file) as origin_file:
			jsonData = json.load(origin_file)
		xml = dicttoxml.dicttoxml(jsonData)

		xml_file = open(file.rsplit(".json",1)[0] + '.xml',"w")
		xml_file.write(xml.decode())
		xml_file.close()