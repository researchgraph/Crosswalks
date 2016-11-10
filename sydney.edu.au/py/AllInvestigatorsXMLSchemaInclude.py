rifdef=\
   [ "researcher",
     [ "key",
        [ "keytxt","sydney.edu.au/researcher/",
          "data",'fldData["UserId"]'
        ],
        "local_ID",
        [ 
            "data",'fldData["UserId"]'
        ],
        "first_name",
        [ 
            "data",'fldData["InvestigatorFirstname"]'
        ],
        "last_name",
        [
          "data",'fldData["InvestigatorSurname"]'
        ],
        "full_name",
        [
          "data", 'fldData["InvestigatorFirstname"]+" "+fldData["InvestigatorSurname"]',
        ],
        "orcid",
        [
          "data", 'fldData["InvestigatorORCID"]'
        ],
        "scopus_author_id",
        [
          "data", 'fldData["InvestigatorSCOPUS"]'
        ]
      ]
]
