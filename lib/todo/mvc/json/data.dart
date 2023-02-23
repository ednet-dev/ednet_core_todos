part of todo_mvc;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// rename ednet_core to yourDomainName
// rename Skeleton to YourModelName

// lib/ednet_core/skeleton/json/data.dart

var todoMvcDataJson = r'''
{
   "domain":"Todo",
   "entries":[
      {
         "concept":"Task",
         "entities":[
            {
               "completed":"false",
               "oid":"1353105264405",
               "title":"design a model",
               "code":null
            },
            {
               "completed":"false",
               "oid":"1353105264407",
               "title":"generate json from the model",
               "code":null
            },
            {
               "completed":"false",
               "oid":"1353105264408",
               "title":"generate code from the json document",
               "code":null
            }
         ]
      }
   ],
   "model":"Mvc"
}
''';