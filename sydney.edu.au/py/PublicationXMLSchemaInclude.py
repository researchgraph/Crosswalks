rifdef=\
   [ "registryObject",
     [ "group","The University of Sydney" ,
        "key",
        [ "keytxt","sydney.edu.au/researcher/",
          "data",'fldData["AuthorNumber"]',
        ],
        "originatingSource",
        ["data", OrigSource ],
        "party",
        [ "type","person",
          "name",
          [ "type","primary" ,
            "namePart",
            [ "type","given",
              "data",'fldData["AuthorFirstname"]'
            ],
            "namePart",
            [ "type","family",
              "data",'fldData["AuthorSurname"]'
            ],
          ],
          "identifier",
          [ "type","orcid",
            "data",'fldData["AuthorNumber"]'
          ],
          "identifier",
          [ "type","scopus_aid",
            "data", 'fldData["ScopusId"]',
          ],
          "identifier",
          [ "type","doi",
            "data", 'fldData["DOI"]'
          ],
          "location",
          [ "address",
            [ "electronic",
              [ "type","email",
                "data",'fldData["PersonContactEmail"]'
              ]
            ]
          ]
        ]
     ],
     "registryObject",
     [
       "key",
       [ "keytxt","sydney.edu.au/researcher/",
         "data",'fldData["AuthorNumber"]',
       ],
       "originatingSource",
       ["data", OrigSource ],
       "collection",
       [ "type","publication",
         "name",
         [ "type","primary",
           "namePart",
           [ "type","title",
             "data",'fldData["PublicationTitle"]'
           ]
         ],
         "dates",
         [ "type","issued",
           "date",
           [ "type","dateFrom",
             "dateFormat","UTC",
             "data",'fldData["PublicationYear"]'
           ]
         ],
         "identifier",
         [ "type","issn",
           "data",'fldData["ISSNISBN"]'
         ],
         "identifier",
         [ "type","local",
           "data",'fldData["ISSNISBN"]'
         ],
         "identifier",
         [ "type","scopus_eid",
           "data",'fldData["ScopusId"]'
         ],
         "identifier",
         [ "type","doi",
           "data",'fldData["DOI"]'
         ],
         "subject",
         [ "type","anzsrc-for",
           "data",'fldData["AuthorAssignedForCode1"]'
         ],
         "subject",
         [ "type","anzsrc-for",
           "data",'fldData["AuthorAssignedForCode2"]'
         ],
         "subject",
         [ "type","anzsrc-for",
           "data",'fldData["AuthorAssignedForCode3"]'
         ],
         "relatedObject",
         [ "type",'isProducedBy',
           "key",
           [ "keytxt","sydney.edu.au/researcher/",
             "data",'fldData["PublicationCode"]'
           ]
         ]
       ]
     ]
   ]

