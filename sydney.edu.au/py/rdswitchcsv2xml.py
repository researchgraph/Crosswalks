#!/usr/bin/python
# Author Keir Vaughan-Taylor     Mon Feb  1 11:37:37 AEDT 2016
# Oct 12 2016
# Mapping data values from a local database into positions in a RIFs XML file
import sys,csv,os
import codecs
import pdb

reload(sys)
sys.setdefaultencoding('utf8')

# Rifs XML data representation of RMA data fields below
# rifplace is a nested set of rif tag entities expressed as nested lists
# In each list the first entry is a key, item zero is a text key every second entry is either a list of data

if len(sys.argv)>1:
   setname=str(sys.argv[1])
else:
   print("Please specify a set name for  CSV input file and output.")
   print('For example: python createResearcherXML.py sampleResearcher.csv')
   sys.exit()

includeSchema="./"+setname+"XMLSchemaInclude.py"

if not os.path.isfile(includeSchema):
   print("Schema File %s cannot be found." % includeSchema)
   sys.exit()
with open(includeSchema,"r") as fd:
   rifdefinition=fd.read()

exec(rifdefinition)    # rifdefinition is a dictionary of heirachial tags with data

def replaceStrings(row):
   row = [ x.replace('&apos;',"'").\
             replace('&quot;','"').\
             replace("&amp;","&").\
             replace("&lt;", "<").\
             replace("&gt;", ">").\
             decode('utf-8','ignore').\
             encode("utf-8") for x in row ]
   row = [ x.replace("'",'&apos;').\
             replace('"','&quot;').\
             replace("&","&amp;").\
             replace("<", "&lt;").\
             replace(">", "&gt;").\
             decode('utf-8','ignore').\
             encode("utf-8") for x in row ]
   return row

fieldmap={}

# Special action tags
actionList=["type","data","group"]
taglist=["registryObject","collection"]
specialTag=["key","type","data","dataNotEmpty","prefix"]

def emit(txtout,idt):
   # writes string with indent 
   idsize=4
   rifoutfd.write(" "*idt*idsize + txtout)

# key index data refers to a read data item in the dictionary fldData

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

def prefixf(rifplace,idt):
   rifoutfd.write(rifplace)

def rifheader():
   emit('<?xml version="1.0" encoding="UTF-8" ?>\n',0)

def dataNotEmpty(rifplace):
   dp = rifplace.index("data")
   value=eval(rifplace[dp+1])
   return not value.isspace()

def tagFunc(tagname,rifplace,idt):
   emit("<"+tagname,idt)
   makeCalls(rifplace,idt)
   emit("</"+tagname+">\n",idt)

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

      tagname=rifplace[index]
      if isinstance(tagname,basestring):
         if tagname in specialTag:
            calltxt=tagname+"f(rifplace[index+1],idt+1)"
            eval(calltxt)
         else:
            tagFunc(tagname,rifplace[index+1],idt+1)
      else:
         print "Error in sytace of rifs definition"
         print rifplace
         print "index:",index
         print rifplace[index]
         print
         sys.exit()

# main Main    -------------------------------------------------------

csvsrc="/home/dspace/rd_switchboard"

# Input Output files
rawDatIn=csvsrc+"/"+setname+".csv"
xmlOut="/usr/local/rdswitchboard/xml/"
rifout=xmlOut+"r."+setname+".xml"
print "CSV sourced from " + rawDatIn
print("Output file will be at " + rifout)

idt=0    # idt is indent
# Test input file availablility
if not os.path.isfile(rawDatIn):
   print "Error: Input file %s not found" % rawDatIn
   pdb.set_trace()
   sys.exit()

# Read csv publication input data and write output in appropriate XML format
#Nhgube Xrve Inhtuna-Gnlybe Jrq Abi  2 07:40:25 NRQG 2016
with codecs.open(rifout,"w",encoding='utf-8',errors='replace') as rifoutfd:
   with open(rawDatIn,"rU") as fieldDatafd:
      datreader=csv.reader(fieldDatafd,delimiter='	')
      headers=datreader.next()
      headlen=len(headers)

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
      lastrow=[]
      for row in datreader:
         # decoding encoded html-unsafe symbols to cover the situation when some of them are already encoded ans some are not
         # encoding html-unsafe symbols
         row=replaceStrings(row)
         row=lastrow+row           # Mostly lastrow is empty
         if len(row) < headlen:    # If two lines actually one (Maybe DOD ctrl M)
            lastrow=row
         else:
            lastrow=[]
            for index in range(0,len(rifdef),2):
               fldData=dict(zip(headers,row))   #Header items as keys to values
               makeCalls(rifdef,idt)
      emit('</researchers>\n',idt)
      emit("</registryObjects>\n",idt)

print ("End.")
