import sys,csv,os
import pdb

# Author Keir Vaughan-Taylor     Mon Feb  1 11:37:37 AEDT 2016
# Input Output files
rawDatIn="qry_RDS_Sample.csv"
#rawDatIn="Bates_etc_v2.csv"
rifout="./rif-csOut.xml"
ROCode="Needs a column in csv"

# Rifs XML data representation of RMA data fields below

import sys,csv

# Rifs XML data representation of RMA data fields below
#  PublicationCode 
#  OutputType   
#  PublicationYear
#  PublicationTitle
#  Publisher
#  Outlet
#  ISSNISBN
#  Volume
#  Issue
#  StartPage
#  EndPage
#  ScopusId
#  DOI
#  AuthorAssignedForCode1
#  AuthorAssignedForCode2
#  AuthorAssignedForCode3
#  AuthorOrder
#  AuthorType
#  AuthorInternal
#  AuthorNumber
#  AuthorSurname
#  AuthorFirstname
#  AuthorFaculty
#  AuthorSchool

# key index data refers to a read data item in the dictionary fldData

# The following dictionary/list structure defines an XML structure 
# Mapping data values from a local database into positions in a RIFs XML file

OrigSource="rqf.library.usyd.edu.au"

with open("PublicationXMLSchemaInclude.py","r") as fd:
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

def dateFormatf(rifplace,idt):
   rifoutfd.write(" dateFormat=" + rifplace)

def groupf(rifplace,idt):
   rifoutfd.write(' group="'+rifplace+'"')

def typef(rifplace,idt):
   dval=' type="%s"' % rifplace
   rifoutfd.write(dval)

def dataf(rifplace,idt):
   rifoutfd.write(eval(rifplace))

def originatingSourcef(rifplace,idt):
   ostr="<originatingSource>"+rifplace[1]+"</originatingSource>\n"
   emit(ostr,idt)

def partyf(rifplace,idt):
   emit("<party",idt)
   makeCalls(rifplace,idt)
   emit("</party>\n",idt)

def identifierf(rifplace,idt):
   emit("<identifier",idt)
   makeCalls(rifplace,idt)
   emit("</identifier>\n",0)

def collectionf(rifplace,idt):
   emit("<collection",idt)
   makeCalls(rifplace,idt)
   emit('</collection>\n',idt)

def datef(rifplace,idt):
   emit("<date",idt)
   makeCalls(rifplace,idt)
   emit("</date>\n",0)

def datesf(rifplace,idt):
   emit("<dates",idt)
   makeCalls(rifplace,idt)
   emit("</dates>\n",idt)
   
def namePartf(rifplace,idt):
   emit("<namePart",idt)
   makeCalls(rifplace,idt)
   emit("</namePart>\n",0)

def namef(rifplace,idt):
   emit("<name",idt)
   makeCalls(rifplace,idt)
   emit("</name>\n",idt)

def relatedObjectf(rifplace,idt):
   emit("<relatedObject",idt)
   makeCalls(rifplace,idt)
   emit("</relatedObject>\n",idt)

def rifheader():
   emit('<?xml version="1.0" encoding="UTF-8" ?>\n',0)

def subjectf(rifplace,idt):
   if dataNotEmpty(rifplace):
      emit("<subject>",idt)
      makeCalls(rifplace,idt)
      emit("</subject>\n",0)


def locationf(rifplace,idt):
   pass

def registryObjectf(rifplace,idt):
   emit('<registryObject',idt)
   makeCalls(rifplace,idt)
   emit('</registryObject>\n',idt)

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
with open(rifout,"w") as rifoutfd:
   with open(rawDatIn,"r") as fieldDatafd:
      datreader=csv.reader(fieldDatafd,delimiter='\t')
      headers=datreader.next()

      rifheader()
      idt+=1
      emit('<registryObjects>\n',idt)
      for row in datreader:
         for index in range(0,len(rifdef),2):
            fldData=dict(zip(headers,row))   #Header items as keys to values
            makeCalls(rifdef,idt)

      emit("</registryObjects>\n",idt)


# Author Keir Vaughan-Taylor     Mon Feb  1 11:37:37 AEDT 2016
