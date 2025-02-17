part of todo_mvc;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/ednet_core/skeleton/json/model.dart

var todoMvcModelJson = r'''
{
    "width":990,
    "relations":[

    ],
    "height":580,
    "concepts":[
        {
            "entry":true,
            "name":"Task",
            "x":162,
            "y":147,
            "width":80,
            "height":80,
            "attributes":[
                {
                    "sequence":20,
                    "category":"required",
                    "name":"title",
                    "type":"String",
                    "essential":true,
                    "sensitive":false,
                    "init":""
                },
                {
                    "sequence":30,
                    "category":"required",
                    "name":"completed",
                    "type":"bool",
                    "essential":false,
                    "sensitive":false,
                    "init":"false"
                }
            ]
        }
    ]
}
''';