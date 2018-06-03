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

function createAuthorList {
	jq '.author_list |= (if .contributor!=null then
		[.["contributor"][] |
			select (.["credit-name"]!=null) |
				select (.["credit-name"].value!=null) |
					.["credit-name"].value |= sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; " "; "g") |
						.["credit-name"].value+";"] | add 
	else
		""
	end)'
}


function getDOI {
	jq '.doi |= (if .["work-external-identifier"]!=null then 
					if [.["work-external-identifier"][]["work-external-identifier-type"]=="DOI"] | contains([true]) then
	 						[.["work-external-identifier"][] | select (.["work-external-identifier-type"]=="DOI") |
							 	.["work-external-identifier-id"]["value"]][0] | sub("\\n|\\r|\\t|\"|\\|\\\"|\\\\|<CR>"; " "; "g")							
	 				else
	 						""
	 				end
	 			else
	 				""
				end)'
}

function getScopusEID {
	jq '.scopus_eid |= (if .["work-external-identifier"]!=null then 
					if [.["work-external-identifier"][]["work-external-identifier-type"]=="EID"] | contains([true]) then
	 						[.["work-external-identifier"][] | select (.["work-external-identifier-type"]=="EID") | .["work-external-identifier-id"]["value"]][0]							
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
		echo $fileName
	fi

	#Researchers
	cat $f | jq -r --arg fN $fileName '{
			"key": ("researchgraph.org/orcid/"+.["orcid-profile"]["orcid-identifier"]["path"]),
			"local_id": .["orcid-profile"]["orcid-identifier"]["path"],
			"last_updated": [.["orcid-profile"]["orcid-history"]["last-modified-date"]["value"]/1000 | todateiso8601][],
			"url": .["orcid-profile"]["orcid-identifier"]["uri"],
			"full_name": (.["orcid-profile"]["orcid-bio"]["personal-details"]["given-names"]["value"] + " " + .["orcid-profile"]["orcid-bio"]["personal-details"]["family-name"]["value"]),
			"first_name": (.["orcid-profile"]["orcid-bio"]["personal-details"]["given-names"]["value"] // ""),
			"last_name": (.["orcid-profile"]["orcid-bio"]["personal-details"]["family-name"]["value"] // ""),
			"orcid": .["orcid-profile"]["orcid-identifier"]["path"],
			"scopus_author_id": .["orcid-profile"]["orcid-bio"]["external-identifiers"],
			"source_file": $fN
			}' | getScopusAID | fixName | makeResearcherCSV >> $researcherCSV


	#Publications
	cat $f | jq -r --arg fN $fileName 'if .["orcid-profile"]["orcid-activities"]["orcid-works"]["orcid-work"]!=null then
		.["orcid-profile"]["orcid-activities"]["orcid-works"]["orcid-work"][] |
			if .["work-title"]!=null then
				{
					"key": ("researchgraph.org/orcid/"+.["put-code"]),
					"local_id": .["put-code"],
					"title": .["work-title"]["title"]["value"],
					"author_list": .["work-contributors"],		
					"last_updated": [.["last-modified-date"]["value"]/1000 | todateiso8601][],
					"publication_year":(.["publication-date"]["year"]["value"] // ""),
					"url":(.["url"]["value"] // ""),
					"doi":.["work-external-identifiers"],
					"scopus_eid":.["work-external-identifiers"],
					"orcid_work_type":.["work-type"],
					"type": (if .["work-type"]=="DATA_SET" then "dataset" else "publication"	end),
					"source_file": $fN
				}
		else
			empty
		end
	else
		empty
	end' | getDOI | getScopusEID | fixTitle | createAuthorList | makePublicationCSV >> $workCSV

	#Relations
		ORCID=`cat $f | jq -r '.["orcid-profile"]["orcid-identifier"]["path"]'`

		cat $f | jq --arg key $ORCID -r 'if .["orcid-profile"]["orcid-activities"]["orcid-works"]["orcid-work"]!=null then
			.["orcid-profile"]["orcid-activities"]["orcid-works"]["orcid-work"][] | 
			if .["work-title"]!=null then
				{
					"from_key": ("researchgraph.org/orcid/" + $key), 
					"to_uri": ("researchgraph.org/orcid/" + .["put-code"])
				}
			else
				empty
			end
		else
			empty
		end' | makeRelationCSV  >> $relationCSV
done
