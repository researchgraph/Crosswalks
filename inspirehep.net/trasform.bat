@echo off
set /p path="Enter path to xsl processor: "
java -jar %path% sampleWithORCID-1-Input.xml cern_to_researchgraph.xsl > sampleWithORCID-1-Output.xml

pause