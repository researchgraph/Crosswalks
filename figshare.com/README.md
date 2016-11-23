#Crosswalk figshare:RDF to R.XML
This is the crosswalk between figshare RDF files and Research Graph XML schema. 

#Node type
We map the figshare records to four main research graph types using the ```<setSpec>``` in the headers as follows:

* image (```item_type_1```) --> **Dataset** 
* media (```item_type_2```) --> **Dataset** 
* dataset (```item_type_3```) --> **Dataset**  
* fileset (```item_type_4```) --> **Dataset**  
* poster (```item_type_5```) --> **Publication**  
* paper (```item_type_6``) --> **Publication**  
* presentation (```item_type_7``) --> **Publication**  
* thesis (```item_type_8``) --> **Publication**  
* code (```item_type_9``) --> **Dataset**  
* metadata (```item_type_11``) --> **Dataset**  

Note: In this crosswalk, we have types *code* and *metadata* that do not match directly to Research Graph types. For the simplicity at this stage, we are mapping these fields to the type **Dataset**. A further revision in this area is required to accommodate these types.



