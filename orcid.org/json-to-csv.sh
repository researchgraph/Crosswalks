DIRECTORY=$1
REGISTRY=$2
PARTITION=$3
DEBUG=$4

#HEADERS**************************************************

#ORCID profiles
headerResearcherCSV="$REGISTRY/header.researcher.nodes.csv" 
echo '"key:ID","source","local_id","last_updated","url","full_name","first_name","last_name","orcid","scopus_author_id","type",":LABEL",":IGNORE",":IGNORE"' > $headerResearcherCSV

#ORCID WORK can be Dataset or Publication. 
headerWorkCSV="$REGISTRY/header.work.nodes.csv" 
echo '"key:ID","source","local_id","title","author_list","last_updated","publication_year","url","doi","scopus_eid","orcid_work_type","type",":LABEL",":IGNORE",":IGNORE"' > $headerWorkCSV

#Relations
headerRelationCSV="$REGISTRY/header.relations.csv"
echo ":START_ID, :END_ID, :TYPE"> $headerRelationCSV


#CSV OOUTPUT ********************************************
workCSV="$REGISTRY/$PARTITION.work.nodes.csv"
researcherCSV="$REGISTRY/$PARTITION.researcher.nodes.csv"
relationCSV="$REGISTRY/$PARTITION.relations.csv"

#Delete the files if they exist
rm -f $workCSV;
rm -f $researcherCSV;
rm -f $researcherCSV;


echo "PARTITION: $PARTITION"
echo "DIRECTORY: $DIRECTORY"
echo "REGISTRY: $REGISTRY"
echo "DEBUG: $DEBUG"
#Functions
function makePublicationCSV {
	jq -r --arg pT $PARTITION '[.key,"orcid.org",.local_id,.title,.author_list,.last_updated,.publication_year,.url,.doi,.scopus_eid,.orcid_work_type,.type,.type+";orcid",.source_file, $pT] |@csv'
}

function makeResearcherCSV {
	jq -r --arg pT $PARTITION '[.key,"orcid.org",.local_id,.last_updated,.url,.full_name,.first_name,.last_name,.orcid,.scopus_author_id,"researcher","researcher;orcid",.source_file, $pT] |@csv'
}

function makeRelationCSV {
	jq -r '[.from_key,.to_uri,"relatedTo"] |@csv'
}

function fixTitle {
	jq  '.title |= sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; " "; "g")'
}

function getDOI {
	jq '.doi |= (if .["external-id"]!=null then 
					if [.["external-id"][]["external-id-type"]=="doi"] | contains([true]) then
	 						[.["external-id"][] | select (.["external-id-type"]=="doi") |
							 	.["external-id-value"]][0] | sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; " "; "g")							
	 				else
	 						""
	 				end
	 			else
	 				""
				end)'
}

function getURL {
	jq '.scopus_eid |= (if .["external-id"]!=null then 
					if [.["external-id"][]["external-id-url"]!=null] | contains([true]) then
	 						[.["external-id"][] | select (.["external-id-url"]!=null) | .["external-id-url"]][0]["value"]							
	 				else
	 						""
	 				end
	 			else
	 				""
				end)'
}

function getScopusEID {
	jq '.url |= (if .["external-id"]!=null then 
					if [.["external-id"][]["external-id-type"]=="eid"] | contains([true]) then
	 						[.["external-id"][] | select (.["external-id-type"]=="eid") | .["external-id-value"]][0]							
	 				else
	 						""
	 				end
	 			else
	 				""
				end)'
}

function getScopusAID {
	jq '.scopus_author_id |= (if .["external-identifier"]!=null then
							if [.["external-identifier"][]["external-id-common-name"]["value"]=="Scopus Author ID"] | contains([true]) then
									[.["external-identifier"][] | select (.["external-id-common-name"]["value"]=="Scopus Author ID") | .["external-id-reference"]["value"]][0]
							else
									""
							end
						else
							""
						end)'
}
function fixName {
	jq '.last_name |= sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; ""; "g")	|
		.first_name |= sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; ""; "g") |
		.full_name |= sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; ""; "g")'  
}


#Process files
FILES="$DIRECTORY/*.json"
FILECOUNTER=0
for f in $FILES
do
	fileName=$(basename $f)
	FILECOUNTER=$((FILECOUNTER+1))
	
	if [ "$DEBUG" == 'true' ]
	then
		echo $FILECOUNTER':'$fileName
	fi

	#Researchers
	cat $f | jq -r --arg fN $fileName 'if .["orcid-identifier"]!=null then {
			"key": ("researchgraph.org/orcid/"+.["orcid-identifier"]["path"]),
			"local_id": .["orcid-identifier"]["path"],
			"last_updated": [.["history"]["last-modified-date"]["value"]/1000 | todateiso8601][],
			"url": .["orcid-identifier"]["uri"],
			"full_name": (.["person"]["given-names"]["value"] + " " + .["person"]["family-names"]["value"]),
			"first_name": (.["person"]["given-names"]["value"] // ""),
			"last_name": (.["person"]["family-names"]["value"] // ""),
			"orcid": .["orcid-identifier"]["path"],
			"scopus_author_id": .["person"]["external-identifiers"],
			"source_file": $fN
			} else
				empty
			end' | getScopusAID | fixName | makeResearcherCSV >> $researcherCSV


	#Publications
	cat $f | jq -r --arg fN $fileName 'if .["activities-summary"]["works"]["group"]!=null then
		.["activities-summary"]["works"]["group"][]["work-summary"][] |
			if .["title"]["title"]!=null then
				{
					"key": ("researchgraph.org/orcid/"+(.["put-code"]|tostring)),
					"local_id": .["put-code"]|tostring,
					"title": .["title"]["title"]["value"],
					"author_list": "",		
					"last_updated": [.["last-modified-date"]["value"]/1000 | todateiso8601][],
					"publication_year":(.["publication-date"]["year"]["value"] // ""),
					"url":.["external-ids"],
					"doi":.["external-ids"],
					"scopus_eid":.["external-ids"],
					"orcid_work_type":(.["type"]| ascii_downcase),
					"type": (if .["work-type"]=="DATA_SET" then "dataset" else "publication" end),
					"source_file": $fN
				}
		else
			empty
		end
	else
		empty
	end' | getDOI | getScopusEID | getURL | fixTitle | makePublicationCSV >> $workCSV

	#Relations
	ORCID=`cat $f | jq -r '.["orcid-identifier"]["path"]'`

	cat $f | jq --arg key $ORCID -r 'if .["activities-summary"]["works"]["group"]!=null then
		.["activities-summary"]["works"]["group"][]["work-summary"][] | 
		if .["title"]["title"]!=null then
			{
				"from_key": ("researchgraph.org/orcid/" + $key), 
				"to_uri": ("researchgraph.org/orcid/" + (.["put-code"]|tostring))
			}
		else
			empty
		end
	else
		empty
	end' | makeRelationCSV  >> $relationCSV
done
