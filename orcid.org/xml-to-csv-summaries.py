import xml.etree.ElementTree as ET
import optparse

namespaces={'common':"http://www.orcid.org/ns/common"}


def xml_to_csv_summaries(xml_file):
	"""Convert an ORCID XML (summaries) file to an Research Graph CSV.
	
	The mappying between XML and XSV follows:
	Col1: 


	The export CSV file has the same name as the input file with the csv extension.
	e.g. 0000-0001-5009-9000.xsl -> 0000-0001-5009-9000.csv
	"""

    tree = ET.parse(arguments[0])
	orcid_id = tree.find("./common:orcid-identifier/common:path",namespaces).text

	

if __name__ == "__main__":
    sys.exit(f0016main(sys.argv[1], sys.argv[2]))