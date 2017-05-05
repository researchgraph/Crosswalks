import sys
from xmlutils.xml2csv import xml2csv
import os
import 	xml.etree.ElementTree as et

if not os.path.exists('converted_versions'):
	os.makedirs('converted_versions')
if not os.path.exists('converted_versions/dataset'):
	os.makedirs('converted_versions/dataset')
if not os.path.exists('converted_versions/grant'):
	os.makedirs('converted_versions/grant')
if not os.path.exists('converted_versions/publication'):
	os.makedirs('converted_versions/publication')
if not os.path.exists('converted_versions/researcher'):
	os.makedirs('converted_versions/researcher')
if not os.path.exists('converted_versions/relation'):
	os.makedirs('converted_versions/relation')
	
numberOfFiles = 0
numberOfFilesProcessed = 0
for xmlfile in os.listdir('.'):
	if xmlfile.endswith(".xml"):
		numberOfFiles += 1
	
for input_file in os.listdir('.'):
	if input_file.endswith(".xml"):
		numberOfFilesProcessed += 1
		print("Converting " + input_file + " " + str(numberOfFilesProcessed) + " files out of " + str(numberOfFiles) + " completed")
		tree = et.parse(input_file)
		root = tree.getroot()
		if root.findall('{http://researchgraph.org/schema/v2.0/xml/nodes}datasets'): 
			converter = xml2csv(input_file,"./converted_versions/dataset/" + input_file.split('.xml')[0] + ".csv")
			converter.convert(tag="{http://researchgraph.org/schema/v2.0/xml/nodes}dataset")

		if root.findall('{http://researchgraph.org/schema/v2.0/xml/nodes}grants'): 
			converter = xml2csv(input_file,"./converted_versions/grant/" + input_file.split('.xml')[0] + ".csv")
			converter.convert(tag="{http://researchgraph.org/schema/v2.0/xml/nodes}grant")

		if root.findall('{http://researchgraph.org/schema/v2.0/xml/nodes}publications'): 
			converter = xml2csv(input_file,"./converted_versions/publication/" + input_file.split('.xml')[0] + ".csv")
			converter.convert(tag="{http://researchgraph.org/schema/v2.0/xml/nodes}publication")

		if root.findall('{http://researchgraph.org/schema/v2.0/xml/nodes}researchers'): 	
			converter = xml2csv(input_file,"./converted_versions/researcher/" + input_file.split('.xml')[0] + ".csv")
			converter.convert(tag="{http://researchgraph.org/schema/v2.0/xml/nodes}researcher")

		if root.findall('{http://researchgraph.org/schema/v2.0/xml/nodes}relations'): 
			converter = xml2csv(input_file,"./converted_versions/relation/" + input_file.split('.xml')[0] + ".csv")
			converter.convert(tag="{http://researchgraph.org/schema/v2.0/xml/nodes}relation")
