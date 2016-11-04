import sys,csv,os
import pdb
import codecs

reload(sys)
sys.setdefaultencoding('utf8')

# Author Keir Vaughan-Taylor     Mon Feb  1 11:37:37 AEDT 2016
# Input Output files
rawDatIn="sampleResearcher.csv"
rifout="./r.researchers.xml"
includeSchema="ResearcherXMLSchemaInclude.py"

if len(sys.argv)>1:
   rawDatIn=str(sys.argv[1])
   print("Output file will be at " + rifout)
   print("Processing ...")
else:
   print("Please specify the input CSV file.")
   print('For example: python createResearcherXML.py sampleResearcher.csv')
   sys.exit()

# Rifs XML data representation of RMA data fields below

# key index data refers to a read data item in the dictionary fldData

# The following dictionary/list structure defines an XML structure 
# Mapping data values from a local database into positions in a RIFs XML file

OrigSource="rqf.library.usyd.edu.au"

with open(includeSchema,"r") as fd:
   rifdefinition=fd.read()

exec(rifdefinition)

# rifplace is a nested set of rif tag entities expressed as nested lists
# In each list the first entry is a key, item zero is a text key every second entry is either a list of data

fieldmap={}

actionList=["type","data","group"]
taglist=["registryObject","collection"]

def emit(txtout,idt):
   # writes string with indent 
   idsize=4
   rifoutfd.write(" "*idt*idsize + txtout)

def keyf(rifplace,idt):
   keystr="<key>"
   if rifplace[0]=="keytxt":
      keystr+=rifplace[1]
   if rifplace[2]=="data":
      keystr+=eval(rifplace[3])
   keystr+="</key>\n"
   emit(keystr,idt)

def typef(rifplace,idt):
   dval=' type="%s"' % rifplace
   rifoutfd.write(dval)

def dataf(rifplace,idt):
   rifoutfd.write(eval(rifplace))

def local_IDf(rifplace,idt):
   emit("<local_id",idt)
   makeCalls(rifplace,idt)
   emit("</local_id>>\n",0)

def first_namef(rifplace,idt):
   emit("<first_name",idt)
   makeCalls(rifplace,idt)
   emit("</first_name>\n",idt)

def last_namef(rifplace,idt):
   emit("<last_name",idt)
   makeCalls(rifplace,idt)
   emit("</last_name>\n",idt)

def full_namef(rifplace,idt):
   emit("<full_name",idt)
   makeCalls(rifplace,idt)
   emit("</full_name>\n",0)

def orcidf(rifplace,idt):
   emit("<orcid",idt)
   makeCalls(rifplace,idt)
   emit("</orcid>\n",0)

def scopus_author_idf(rifplace,idt):
   emit("<scopus_author_id",idt)
   makeCalls(rifplace,idt)
   emit("</scopus_author_id>\n",0)

def researcherf(rifplace,idt):
   emit("<researcher",idt)
   makeCalls(rifplace,idt)
   emit("</researcher>\n",idt)

def rifheader():
   emit('<?xml version="1.0" encoding="UTF-8" ?>\n',0)

def dataNotEmpty(rifplace):
   dp = rifplace.index("data")
   value=eval(rifplace[dp+1])
   return not value.isspace()

def makeCalls(rifplace,idt):
   # Indexes  0,2,4,6,8 etc are keywords 
   # Indexes  1,3,5,....    is either a list or data or another tag
   # Non lists indicate tag meta data items such as type or group

   # Executes calls to routines specified in the rifplace
   # Cycles through list of tags

   bkout=False
   for index in range(0,len(rifplace),2):
      #Decides whether to close off XML tag with closing angle bracket
      if not bkout and idt > 1:
         if rifplace[index]=="data": 
            rifoutfd.write(">")
            bkout=True
         elif type(rifplace[index+1]) is list:
            rifoutfd.write(">\n")
            bkout=True
         
      if isinstance(rifplace[index],basestring):
         calltxt=rifplace[index]+"f(rifplace[index+1],idt+1)"
      else:
         print "Error in sytace of rifs definition"
         print rifplace
         print "index:",index
         print rifplace[index]
         print
         pdb.set_trace()
         sys.exit()
 
      eval(calltxt)


# main Main    -------------------------------------------------------

idt=0    # idt is indent
# Test input file availablility
if not os.path.isfile(rawDatIn):
   print "Error: Input file %s not found" % rawDatIn
   sys.exit()

# Read csv publication input data and write output in appropriate XML format
with codecs.open(rifout,"w",encoding='utf-8',errors='replace') as rifoutfd:
   with open(rawDatIn,"rU") as fieldDatafd:
      datreader=csv.reader(fieldDatafd,delimiter=',')
      headers=datreader.next()

      rifheader()
      idt+=1
      emit('<registryObjects\n',idt)
      emit('xmlns="http://researchgraph.org/schema/v2.0/xml/nodes"',idt+1)
      emit("\n",0)
      emit('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',idt+1)
      emit("\n",0)
      emit('xsi:schemaLocation="https://raw.githubusercontent.com/researchgraph/schema/master/xsd/researcher.xsd">',idt+1)
      emit("\n",0)
      emit('<researchers>\n',idt)
      for row in datreader:
         row = [ x.replace('&apos;',"'").replace('&quot;','"').replace("&amp;","&").replace("&lt;", "<").replace("&gt;", ">").decode('utf-8','ignore').encode("utf-8") for x in row ] # decoding encoded html-unsafe symbols to cover the situation when some of them are already encoded ans some are not
         row = [ x.replace("'",'&apos;').replace('"','&quot;').replace("&","&amp;").replace("<", "&lt;").replace(">", "&gt;").decode('utf-8','ignore').encode("utf-8") for x in row ] # encoding html-unsafe symbols
         for index in range(0,len(rifdef),2):
            fldData=dict(zip(headers,row))   #Header items as keys to values
            makeCalls(rifdef,idt)
      emit('</researchers>\n',idt)
      emit("</registryObjects>\n",idt)

print ("End.")
# Author Keir Vaughan-Taylor     Mon Feb  1 11:37:37 AEDT 2016