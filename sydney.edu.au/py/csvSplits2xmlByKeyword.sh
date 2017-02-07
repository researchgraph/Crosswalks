#!/bin/bash
# Author Keir Vaughan-Taylor
# Runs program to convert each CSV to XML format
# first cleans input of dogy chacrers using program clean.py
# Usage no argument runs all csv files
# usage:     runAllcsv2xml.sh <keywordlist> 

# Use arguments to this script to determine which CSVs to process
# With no arguments process them all

csv2xml() {
      idkeyword=$1
      csvname=$2
      echo csvname $csvname
      # Extract the keyword that groups program includes and file outputs
      echo xmlfile=${xmlDir}/$(basename csvname .csv).xml
      xmlfile=${xmlDir}/$(basename $csvname .csv)
      echo convert to XML $idkeyword files

      echo ${appdir}/rdswitchcsv2xml.py $splitDirCSVs/${csvname} $xmlDir $idkeyword
      
      ${appdir}/rdswitchcsv2xml.py $splitDirCSVs $xmlDir $idkeyword $csvname
      echo ${appdir}/clean.py ${xmlfile}.xml  >    ${xmlfile}Cleaned.xml
      ${appdir}/clean.py      ${xmlfile}.xml  >    ${xmlfile}Cleaned.xml
      rm ${xmlfile}.xml

      echo cp ${xmlDir}/${idkeyword}Cleaned.xml /home/ftpuser/xmlSplit/
      # cp ${xmlDir}/${idkeyword}Cleaned.xml /home/ftpuser/xmlSplit/
}

csvDir="/home/dspace/rd_switchboard"
splitDirCSVs="${csvDir}/splitDirCSVs"
xmlDir=/data/rdswitchboard/xmlSplits
# Directory of executable scripts/programs
appdir="/usr/local/rdswitchboard/Crosswalks/sydney.edu.au/py" 

if [ $# -eq 0 ]
then
   # Process all the CSV
   echo for csvfile in `ls $csvDir/*.csv`
   for csvfile in `ls $csvDir/*.csv`
   do
      echo csvfile: $csvfile
      #Split the csv files into smaller units
      echo cp $csvfile $splitDirCSVs/
      cp $csvfile $splitDirCSVs/
      spltcsv=$(basename $csvfile)
      cd $splitDirCSVs
      # Delte the first line (The header)
      hdrText=$(head -n1 $spltcsv)
      sed -i -e "1d" $spltcsv
      keyname=$(basename $csvfile .csv)
      echo key: $keyname
      # Spit the csv file into parts with prefix keyfix, a 4 digit numeric and then extention .csv
      echo split -l1000 -a4 --additional-suffix=".csv" -d $csvfile $keyname
      split -a4 --additional-suffix=".csv" -d $splitDirCSVs/$keyname.csv $keyname
      rm -f $spltcsv
      echo for splitfile in `ls $splitDirCSVs`
      for splitfile in `ls $splitDirCSVs`
      do
         echo $splitfile
         # prepend the  header  from the source file onto each split file
         echo "$hdrText"|cat - $splitfile > tmp1
         mv tmp1 $splitfile
         csv2xml $keyname $splitfile    #Local func call
      done
      rm $splitDirCSVs/*
   done
   ehco grokky flocky
else
   for arg
   do
      cp $arg $splitDirCSVs/
      split -a4 --additional-suffix=".csv" -d $splitDirCSVs/$arg 
      rm -f $splitDirCSVs/$arg
      for splitfile in `ls $splitDirCSVs`
      do
         echo $splitfile
         csv2xml $splitfile
      done
   done
fi
