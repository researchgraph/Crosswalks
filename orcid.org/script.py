import json
import dicttoxml

filepath = raw_input("Enter the file name : ")
jsonData = json.loads(open(filepath))
xml = dicttoxml.dicttoxml(jsonData)

xml_file = open(filepath.rsplit(".json",1)[0],"w")
xml_file.write(xml)
xml_file.close()