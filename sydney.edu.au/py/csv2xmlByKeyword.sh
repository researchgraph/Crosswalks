#!/bin/bash
# Author Keir Vaughan-Taylor
# Runs program to convert each CSV to XML format
# first cleans input of dogy chacrers using program clean.py
# Usage no argument runs all csv files
# usage:     runAllcsv2xml.sh <keywordlist> 

csvDir=/home/dspace/rd_switchboard
cmd="ls "
if [ $# -eq 1 ]
then
   cmd="ls $csvDir/*.csv"
else
   for arg
   do
      keyword=$(basename $arg)
      cmd="$cmd ${csvDir}/${keyword}.csv"
   done
fi

echo $arg

for csv in $($cmd)
do
   echo convert $csv
   idkeyword=$(basename $csv .csv)
   local=$(basename $csv)
   ./clean.py $csv > ./$local
   # ./rdswitchcsv2xml.py $idkeyword
   echo removing $local
   rm -f $local
done
