#!/bin/bash
#Set data and application locations
rdswitchDir=/usr/local/rdswitchboard
appdir=$rdwitchDir/Crosswalks/sydney.edu.au/py
xmldir=$rdwitchDir/xml

# Run routine to read CSV files from /home/dspace/rdswitchboard
# place resulting XML files into directory xmldir
# also create test files with a small managable  number of tag fields
#$appdir/csv2xmlByKeyword.sh

#Update the neo4j database
#$rdswitchDir/startStopNeo4j.sh stop
sleep 2
cd ${rdswitchDir}/Import-XML/target
java -Xmx8192m -jar neo4j-importer-1.0.0.jar  -c ${rdswitchDir}/r.conf
#$rdswitchDir/startStopNeo4j.sh start
