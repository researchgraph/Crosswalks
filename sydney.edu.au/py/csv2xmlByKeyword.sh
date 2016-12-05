#!/bin/bash
# Author Keir Vaughan-Taylor
# Runs program to convert each CSV to XML format
# first cleans input of dogy chacrers using program clean.py
# Usage no argument runs all csv files
# usage:     runAllcsv2xml.sh <keywordlist> 

csvDir=/home/dspace/rd_switchboard
xmlDir=/usr/local/rdswitchboard/xml
appdir=/usr/local/rdswitchboard/Crosswalks/sydney.edu.au/py

# Use arguments to determine which CSVs to process
# With no arguments process them all
function csv2xml {
      csvname=$1
      echo csvname $csvname
      #ensure just the keyword
      idkeyword=$(basename $csvname .csv)
      xmlfile=${xmlDir}/${idkeyword}.xml
      echo convert $idkeyword

      ${appdir}/rdswitchcsv2xml.py ${csvDir} $xmlDir $idkeyword

      # Produce test data output reducing the number of CSV lines used to make XML to about ten lines
      ${appdir}/genTestDataRdswitchcsv2xml.py ${csvDir} $xmlDir $idkeyword
      ${appdir}/clean.py $xmlfile > ${xmlDir}/r.$idkeyword.xml
      rm -f $xmlfile
      cp ${xmlDir}/r.$idkeyword.xml /home/ftpuser/xml/
}

if [ $# -eq 0 ]
then
   # Process all the CSV
   for csvfile in `ls $csvDir/*.csv`
   do
      csv2xml $csvfile
   done
else
   for arg
   do
      csv2xml $arg
   done
fi
